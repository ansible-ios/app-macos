from pathlib import Path
import argparse
import subprocess
import tempfile

root = Path(__file__).resolve().parents[3]
parser = argparse.ArgumentParser()
parser.add_argument("--row-source", type=Path)
args = parser.parse_args()
source = (args.row_source or root / "packages/ChatListUI/Sources/ChatListUI/ChatListRowItem.swift").read_text()
a = source.index("    public var owningCommunityId:")
b = source.index("    private func takeStoryControl()", a)
production = source[a:b].replace("public ", "")
fixture = Path(__file__).with_name("CommunityDropdownTests.swift").read_text()
fixture = fixture.replace("__PRODUCTION__", production)
assert "__PRODUCTION__" not in fixture
with tempfile.TemporaryDirectory(prefix="community-dropdown-") as directory:
    directory = Path(directory)
    path = directory / "main.swift"
    path.write_text(fixture)
    executable = directory / "community-dropdown"
    subprocess.run(["swiftc", str(path), "-o", str(executable)], check=True)
    subprocess.run([str(executable)], check=True)
