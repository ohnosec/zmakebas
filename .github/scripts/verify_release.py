#!/usr/bin/env python3
"""Validate zmakebas smoke-test output, architecture, and package layout."""

from __future__ import annotations

import argparse
import hashlib
import struct
import sys
import tarfile
import zipfile
from pathlib import Path


ELF_MACHINES = {
    "x86": (1, 3),
    "x86_64": (2, 62),
    "arm": (1, 40),
    "aarch64": (2, 183),
}

PE_MACHINES = {
    "x86": 0x014C,
    "x86_64": 0x8664,
}


def fail(message: str) -> None:
    raise ValueError(message)


def validate_tap(path: Path, expected_sha256: str | None = None) -> None:
    data = path.read_bytes()
    if len(data) < 25:
        fail(f"{path} is too short to be a TAP file")

    header_size = int.from_bytes(data[0:2], "little")
    if header_size != 19:
        fail(f"{path} has TAP header block length {header_size}, expected 19")

    header_block = data[2:21]
    if len(header_block) != header_size or header_block[0] != 0:
        fail(f"{path} has an invalid TAP header block")
    if _xor(header_block[:-1]) != header_block[-1]:
        fail(f"{path} has an invalid TAP header checksum")

    program_size = int.from_bytes(header_block[12:14], "little")
    data_size = int.from_bytes(data[21:23], "little")
    data_block = data[23:]
    if data_size != program_size + 2 or len(data_block) != data_size:
        fail(f"{path} has inconsistent TAP data lengths")
    if data_block[0] != 0xFF or _xor(data_block[:-1]) != data_block[-1]:
        fail(f"{path} has an invalid TAP data block")
    if expected_sha256 is not None:
        actual_sha256 = hashlib.sha256(data).hexdigest()
        if actual_sha256 != expected_sha256.lower():
            fail(
                f"{path} has SHA-256 {actual_sha256}, "
                f"expected {expected_sha256.lower()}"
            )


def _xor(data: bytes) -> int:
    value = 0
    for byte in data:
        value ^= byte
    return value


def validate_elf(path: Path, machine: str) -> None:
    data = path.read_bytes()
    if len(data) < 20 or data[:4] != b"\x7fELF":
        fail(f"{path} is not an ELF executable")
    if data[5] != 1:
        fail(f"{path} is not a little-endian ELF executable")
    expected_class, expected_machine = ELF_MACHINES[machine]
    actual_machine = int.from_bytes(data[18:20], "little")
    if data[4] != expected_class or actual_machine != expected_machine:
        fail(
            f"{path} has ELF class/machine {data[4]}/{actual_machine}, "
            f"expected {expected_class}/{expected_machine}"
        )


def validate_pe(path: Path, machine: str) -> None:
    data = path.read_bytes()
    if len(data) < 64 or data[:2] != b"MZ":
        fail(f"{path} is not an MZ executable")
    pe_offset = struct.unpack_from("<I", data, 0x3C)[0]
    if pe_offset + 6 > len(data) or data[pe_offset : pe_offset + 4] != b"PE\0\0":
        fail(f"{path} is not a PE executable")
    actual_machine = struct.unpack_from("<H", data, pe_offset + 4)[0]
    if actual_machine != PE_MACHINES[machine]:
        fail(
            f"{path} has PE machine 0x{actual_machine:04x}, "
            f"expected 0x{PE_MACHINES[machine]:04x}"
        )


def validate_dos(path: Path) -> None:
    data = path.read_bytes()
    if len(data) < 64 or data[:2] != b"MZ":
        fail(f"{path} is not an MZ executable")
    pe_offset = struct.unpack_from("<I", data, 0x3C)[0]
    if pe_offset + 2 <= len(data):
        signature = data[pe_offset : pe_offset + 4]
        if signature == b"PE\0\0" or signature[:2] in (b"NE", b"LE", b"LX"):
            fail(f"{path} has an extended executable header, not a real-mode DOS image")


def validate_zip(path: Path, entry: str) -> None:
    with zipfile.ZipFile(path) as archive:
        names = archive.namelist()
        if names != [entry]:
            fail(f"{path} contains {names!r}, expected only {entry!r}")
        if archive.getinfo(entry).file_size == 0:
            fail(f"{path} contains an empty {entry}")
        bad_member = archive.testzip()
        if bad_member is not None:
            fail(f"{path} has a corrupt member: {bad_member}")


def validate_tar_gz(path: Path, entry: str) -> None:
    with tarfile.open(path, mode="r:gz") as archive:
        members = archive.getmembers()
        names = [member.name for member in members]
        if names != [entry]:
            fail(f"{path} contains {names!r}, expected only {entry!r}")

        member = members[0]
        if not member.isfile():
            fail(f"{path} contains a non-regular {entry}")
        if member.size == 0:
            fail(f"{path} contains an empty {entry}")
        if member.mode & 0o111 == 0:
            fail(f"{path} contains a non-executable {entry}")

        stream = archive.extractfile(member)
        if stream is None:
            fail(f"{path} cannot read {entry}")
        bytes_read = 0
        while chunk := stream.read(1024 * 1024):
            bytes_read += len(chunk)
        if bytes_read != member.size:
            fail(
                f"{path} contains {bytes_read} bytes for {entry}, "
                f"expected {member.size}"
            )


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser()
    subparsers = parser.add_subparsers(dest="command", required=True)

    tap = subparsers.add_parser("tap")
    tap.add_argument("path", type=Path)
    tap.add_argument("--sha256")

    binary = subparsers.add_parser("binary")
    binary.add_argument("path", type=Path)
    binary.add_argument("--format", choices=("elf", "pe", "dos"), required=True)
    binary.add_argument("--machine", choices=tuple(ELF_MACHINES), required=False)

    archive = subparsers.add_parser("zip")
    archive.add_argument("path", type=Path)
    archive.add_argument("--entry", required=True)

    tar_archive = subparsers.add_parser("tar")
    tar_archive.add_argument("path", type=Path)
    tar_archive.add_argument("--entry", required=True)
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    try:
        if args.command == "tap":
            validate_tap(args.path, args.sha256)
        elif args.command == "binary":
            if args.format == "elf":
                if args.machine not in ELF_MACHINES:
                    fail("ELF validation requires --machine")
                validate_elf(args.path, args.machine)
            elif args.format == "pe":
                if args.machine not in PE_MACHINES:
                    fail("PE validation requires --machine x86 or x86_64")
                validate_pe(args.path, args.machine)
            else:
                validate_dos(args.path)
        elif args.command == "zip":
            validate_zip(args.path, args.entry)
        else:
            validate_tar_gz(args.path, args.entry)
    except (OSError, ValueError, tarfile.TarError, zipfile.BadZipFile) as error:
        print(f"validation failed: {error}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
