import json
from pathlib import Path
import struct
import sys
import tempfile
import unittest
from unittest.mock import patch
import zlib

sys.path.insert(0, str(Path(__file__).resolve().parents[2] / "scripts"))
import macos_package_guard as guard


class WalletGuardTests(unittest.TestCase):
    def setUp(self):
        scratch = tempfile.TemporaryDirectory()
        self.addCleanup(scratch.cleanup)
        self.root = Path(scratch.name)
        self.project = Path("Ansible.xcodeproj/project.pbxproj")
        self.write(self.project, "productName = WidgetEngineServer;")
        for folder in ("packages/ChatUI", guard.CORE, guard.CORE.parent / "PasscodeCore",
                       guard.WIDGET, "third-party/twidget", "submodules/tgcalls"):
            self.write(Path(folder) / "Package.swift", "")
        target = {"name": "TelegramCore", "type": "library", "sources": ["Account.swift"]}
        self.describe = patch.object(guard.subprocess, "check_output",
                                     return_value=json.dumps({"targets": [target]})).start()
        self.addCleanup(patch.stopall)

    def write(self, path, data):
        path = self.root / path
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(data, encoding="utf-8")

    def test_extension_link(self):
        self.write(self.project, "productName = TONConnect;")
        with self.assertRaisesRegex(RuntimeError, "TONConnect"):
            guard.check_packages(self.root)

    def test_transitive_widget_dependency(self):
        self.write(guard.WIDGET / "Package.swift", '.package(path: "../Support")')
        self.write("third-party/Support/Package.swift", '.product(name: "GramCore")')
        with self.assertRaisesRegex(RuntimeError, "GramCore"):
            guard.check_packages(self.root)

    def test_compiled_core_source(self):
        target = {"name": "TelegramCore", "type": "library", "sources": ["TelegramEngine/Wallet/Send.swift"]}
        self.describe.return_value = json.dumps({"targets": [target]})
        with self.assertRaisesRegex(RuntimeError, "Wallet/Send"):
            guard.check_packages(self.root)

    def test_missing_transitive_manifest(self):
        self.write(guard.WIDGET / "Package.swift", '.package(path: "../Uninitialized")')
        with self.assertRaisesRegex(RuntimeError, "Uninitialized"):
            guard.check_packages(self.root)

    def test_tl_constructors_and_outbound_methods(self):
        schema = "wallet.card#1 = wallet.Card;\n---functions---\npayments.getStarsStatus#2 = Bool;\n"
        self.write("swift_scheme.tl", schema)
        guard.check_schema(self.root)
        for rpc in ("wallet.getState", "payments.withdrawStarGift", "payments.transferGrams"):
            with self.subTest(rpc=rpc):
                self.write("swift_scheme.tl", schema + rpc + "#3 = Bool;\n")
                with self.assertRaisesRegex(RuntimeError, rpc):
                    guard.check_schema(self.root)

    def generated(self, swift_method, binary_method):
        body = "public extension Api.functions.payments {\n    static func %s() {}\n}\n"
        self.write("Sources/SwiftPMGenerated/Api1.swift", body % "getStarsStatus" + body % swift_method)
        pool = b"payments.getStarsStatus\0"
        records = bytes(28) + struct.pack("<I", len(pool)) + bytes(24)
        pool += binary_method.encode("ascii") + b"\0"
        pool_offset = 72 + len(records)
        header = struct.pack("<4sIQ14I", b"TLS1", 3, 0, pool_offset + len(pool), 0, 0, 2, 0, 0,
                             pool_offset, len(pool), 72, 72, 72, 72, 72, 0)
        array = ", ".join(f"0x{v:02x}" for v in zlib.compress(header + records + pool))
        self.write("ObjC/SwiftPMGenerated/TLApiSchemaData.m", f"const uint8_t TLApiSchemaCompressed[] = {{{array}}};")

    def test_generated_swift_and_objc_independently(self):
        self.generated("transferStarGift", "payments.transferStarGift")
        guard.check_generated(self.root)
        for swift, binary, expected in [("depositStarGift", "payments.transferStarGift", "depositStarGift"),
                                        ("transferStarGift", "gram.send", "gram.send")]:
            with self.subTest(swift=swift, binary=binary):
                self.generated(swift, binary)
                with self.assertRaisesRegex(RuntimeError, expected):
                    guard.check_generated(self.root)


if __name__ == "__main__":
    unittest.main()
