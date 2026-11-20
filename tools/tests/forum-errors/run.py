from pathlib import Path
import json
import subprocess
import tempfile

root = Path(__file__).resolve().parents[3]
core = root / "submodules/ansible-ios/submodules/TelegramCore/Sources"
source = (core / "ForumChannels.swift").read_text()
a = source.index("public enum SetChannelForumModeError")
b = source.index("\nstruct LoadMessageHistoryThreadsResult", a)
function = source[a:b].replace("public ", "")
source = (core / "TelegramEngine/Peers/TelegramEnginePeers.swift").read_text()
a = source.index("        public func setChannelForumMode(")
b = source.index("        public func createForumChannelTopic", a)
facade = source[a:b].replace("public ", "")
source = (root / "packages/ForumSettingsUI/Sources/ForumSettingsUI/ForumSettingsController.swift").read_text()
a = source.index("private struct State : Equatable")
b = source.index("private let _id_header", a)
state = source[a:b].replace("private struct", "struct").replace("public ", "")
a = source.index("    let initialState = State()")
b = source.index("    var getController:", a)
setup = source[a:b]
a = source.index("        if let peer {", b)
b = source.index("    }))", a)
receive = source[a:b]
a = source.index("    let update:()->Void =")
b = source.index("    let signal = statePromise.get()", a)
actions = source[a:b]
source = (core / "ApiUtils/TelegramMediaAction.swift").read_text()
a = source.index("func forumTopicEditComponents(")
b = source.index("func telegramMediaActionFromApiAction", a)
topic = source[a:b]
source = (core / "Account/AccountIntermediateState.swift").read_text()
a = source.index("enum MessageWidgetDataChange:")
b = source.index("enum AccountStateMutationOperation", a)
widget_change = source[a:b]
source = (core / "State/MessageWidgetStoreUpdates.swift").read_text()
a = source.index("extension TelegramMediaWidget")
b = source.index("func storeMessageReplacingWidget", a)
widget_update = source[a:source.rfind("}", a, b) + 1]
fixture = Path(__file__).with_name("ForumErrorsTests.swift").read_text()
for key, value in {"CORE":function, "FACADE":facade, "STATE":state, "SETUP":setup, "RECEIVE":receive, "ACTIONS":actions, "TOPIC":topic, "WIDGET_CHANGE":widget_change, "WIDGET_UPDATE":widget_update}.items():
    fixture = fixture.replace("__" + key + "__", value)
with tempfile.TemporaryDirectory(prefix="forum-errors-") as directory:
    directory = Path(directory)
    dependency = json.dumps(str(root / "submodules/ansible-ios/submodules/SSignalKit"))
    manifest = '// swift-tools-version:5.9\nimport PackageDescription\nlet package = Package(name: "ForumErrors", platforms: [.macOS(.v10_13)], dependencies: [.package(path: ' + dependency + ')], targets: [.executableTarget(name: "ForumErrors", dependencies: [.product(name: "SwiftSignalKit", package: "SSignalKit")], path: "Sources")])\n'
    (directory / "Package.swift").write_text(manifest)
    (directory / "Sources").mkdir()
    (directory / "Sources/main.swift").write_text(fixture)
    subprocess.run(["swift", "run", "--package-path", str(directory), "--disable-sandbox", "--jobs", "4"], check=True)
