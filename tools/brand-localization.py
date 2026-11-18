from pathlib import Path
import re
import sys


def accessor(name):
    if name.startswith("voiceOverCallsRatingStars"):
        return name
    for old, new in (("TelegramStars", "AnsibleDiamonds"), ("Telegram", "Ansible"),
                     ("Fragment", "CrystalPiece"), ("Stars", "Diamonds")):
        name = re.sub(old + r"(?=[A-Z0-9_]|$)", new, name)
        if re.match((old[0].lower() + old[1:]) + r"(?=[A-Z0-9_]|$)", name):
            name = new[0].lower() + new[1:] + name[len(old):]
    return name.replace("crystalPieceStarWithdraw", "crystalPieceDiamondWithdraw").replace(
        "crystalPieceStarAmount", "crystalPieceDiamondAmount")


def branded_source(source):
    names = set()

    def declaration(match):
        prefix, old = match.groups()
        name = accessor(old)
        if name in names:
            raise ValueError(f"Duplicate localization accessor: {name}")
        names.add(name)
        return prefix + name

    result = re.sub(r"(?m)^(\s*public static (?:var|func) )(\w+)", declaration, source)
    if not names:
        raise ValueError("SwiftGen emitted no public localization accessors")
    return result


if __name__ == "__main__":
    source, output = map(Path, sys.argv[1:])
    output.write_text(branded_source(source.read_text(encoding="utf-8")), encoding="utf-8")
