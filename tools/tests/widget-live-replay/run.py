from pathlib import Path
import subprocess
import tempfile

root = Path(__file__).resolve().parents[3]
source = (root / "packages/HTMLBubbles/Sources/HTMLBubbles/HTMLBubbleState.swift").read_text(encoding="utf-8")
start = source.index("    private var currentWidgetData =")
end = source.index("    public var widgetActionHandler", start)
fixture = Path(__file__).with_name("WidgetDelivery.swift").read_text(encoding="utf-8")
fixture = fixture.replace("__PRODUCTION__", source[start:end])
with tempfile.TemporaryDirectory(prefix="widget-replay-") as directory:
    main = Path(directory) / "main.swift"
    main.write_text(fixture, encoding="utf-8")
    binary = main.with_suffix("")
    subprocess.run(["swiftc", str(main), "-o", str(binary)], check=True)
    subprocess.run([str(binary)], check=True)
