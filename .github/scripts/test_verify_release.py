#!/usr/bin/env python3
"""Regression tests for the release artifact validator."""

from __future__ import annotations

import hashlib
import io
import struct
import tarfile
import tempfile
import unittest
import zipfile
from pathlib import Path

import verify_release


class VerifyReleaseTests(unittest.TestCase):
    def setUp(self) -> None:
        self.temporary_directory = tempfile.TemporaryDirectory()
        self.addCleanup(self.temporary_directory.cleanup)
        self.directory = Path(self.temporary_directory.name)

    def write(self, name: str, data: bytes) -> Path:
        path = self.directory / name
        path.write_bytes(data)
        return path

    @staticmethod
    def tap_bytes() -> bytes:
        program = b"\x00\x0a\x03\x00\xf5\x0d"
        header = bytearray(18)
        header[0] = 0
        header[1] = 0
        header[2:12] = b"SMOKE     "
        header[12:14] = len(program).to_bytes(2, "little")
        header.append(verify_release._xor(header))
        data_block = bytearray(b"\xff" + program)
        data_block.append(verify_release._xor(data_block))
        return (
            len(header).to_bytes(2, "little")
            + header
            + len(data_block).to_bytes(2, "little")
            + data_block
        )

    def test_tap_accepts_expected_content(self) -> None:
        data = self.tap_bytes()
        path = self.write("smoke.tap", data)
        verify_release.validate_tap(path, hashlib.sha256(data).hexdigest())

    def test_tap_rejects_bad_checksum_and_wrong_content_hash(self) -> None:
        data = self.tap_bytes()
        path = self.write("smoke.tap", data)
        with self.assertRaises(ValueError):
            verify_release.validate_tap(path, "0" * 64)
        corrupted = bytearray(data)
        corrupted[-1] ^= 1
        with self.assertRaises(ValueError):
            verify_release.validate_tap(self.write("corrupt.tap", corrupted))

    def test_elf_checks_class_and_machine(self) -> None:
        elf = bytearray(20)
        elf[:6] = b"\x7fELF\x02\x01"
        elf[18:20] = (62).to_bytes(2, "little")
        path = self.write("zmakebas", elf)
        verify_release.validate_elf(path, "x86_64")
        with self.assertRaises(ValueError):
            verify_release.validate_elf(path, "x86")
        elf[5] = 2
        with self.assertRaises(ValueError):
            verify_release.validate_elf(self.write("big-endian", elf), "x86_64")

    def test_pe_checks_machine(self) -> None:
        pe = bytearray(128)
        pe[:2] = b"MZ"
        struct.pack_into("<I", pe, 0x3C, 64)
        pe[64:68] = b"PE\0\0"
        struct.pack_into("<H", pe, 68, verify_release.PE_MACHINES["x86"])
        path = self.write("zmakebas.exe", pe)
        verify_release.validate_pe(path, "x86")
        with self.assertRaises(ValueError):
            verify_release.validate_pe(path, "x86_64")

    def test_dos_rejects_extended_executable_headers(self) -> None:
        dos = bytearray(128)
        dos[:2] = b"MZ"
        struct.pack_into("<I", dos, 0x3C, 64)
        verify_release.validate_dos(self.write("dos.exe", dos))
        for signature in (b"PE\0\0", b"NE", b"LE", b"LX"):
            extended = bytearray(dos)
            extended[64 : 64 + len(signature)] = signature
            with self.subTest(signature=signature):
                with self.assertRaises(ValueError):
                    verify_release.validate_dos(
                        self.write(f"extended-{signature[:2].decode()}.exe", extended)
                    )

    def test_zip_requires_one_named_nonempty_entry(self) -> None:
        archive_path = self.directory / "package.zip"
        with zipfile.ZipFile(archive_path, "w") as archive:
            archive.writestr("zmakebas", b"binary")
        verify_release.validate_zip(archive_path, "zmakebas")

        with zipfile.ZipFile(archive_path, "a") as archive:
            archive.writestr("unexpected", b"file")
        with self.assertRaises(ValueError):
            verify_release.validate_zip(archive_path, "zmakebas")

    def test_tar_gz_requires_one_named_nonempty_executable(self) -> None:
        archive_path = self.directory / "package.tar.gz"
        member = tarfile.TarInfo("zmakebas")
        member.size = len(b"binary")
        member.mode = 0o755
        with tarfile.open(archive_path, "w:gz") as archive:
            archive.addfile(member, io.BytesIO(b"binary"))
        verify_release.validate_tar_gz(archive_path, "zmakebas")

        member.mode = 0o644
        with tarfile.open(archive_path, "w:gz") as archive:
            archive.addfile(member, io.BytesIO(b"binary"))
        with self.assertRaises(ValueError):
            verify_release.validate_tar_gz(archive_path, "zmakebas")

    def test_tar_gz_rejects_links_empty_files_and_extra_members(self) -> None:
        archive_path = self.directory / "package.tar.gz"

        link = tarfile.TarInfo("zmakebas")
        link.type = tarfile.SYMTYPE
        link.linkname = "elsewhere"
        link.mode = 0o755
        with tarfile.open(archive_path, "w:gz") as archive:
            archive.addfile(link)
        with self.assertRaises(ValueError):
            verify_release.validate_tar_gz(archive_path, "zmakebas")

        empty = tarfile.TarInfo("zmakebas")
        empty.mode = 0o755
        with tarfile.open(archive_path, "w:gz") as archive:
            archive.addfile(empty, io.BytesIO())
        with self.assertRaises(ValueError):
            verify_release.validate_tar_gz(archive_path, "zmakebas")

        executable = tarfile.TarInfo("zmakebas")
        executable.size = 1
        executable.mode = 0o755
        extra = tarfile.TarInfo("unexpected")
        extra.size = 1
        with tarfile.open(archive_path, "w:gz") as archive:
            archive.addfile(executable, io.BytesIO(b"x"))
            archive.addfile(extra, io.BytesIO(b"y"))
        with self.assertRaises(ValueError):
            verify_release.validate_tar_gz(archive_path, "zmakebas")


if __name__ == "__main__":
    unittest.main()
