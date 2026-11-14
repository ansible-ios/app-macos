
var checked = 0
for domain in ["asme.su", "www.asme.su"] {
    for prefix in ["", "https://", "http://"] {
        let link = "\(prefix)\(domain)/contact/XXXX:YYYZZZ?free=AbC%2B123%3D"
        precondition(parseContactTokenLink(link) == ContactTokenLink(token: "XXXX:YYYZZZ", freeToken: "AbC+123="))
        checked += 1
    }
}
for link in ["as://contact?token=XXXX%3AYYYZZZ&free=AbC%2B123%3D", "AS://contact?token=XXXX%3AYYYZZZ&free=AbC%2B123%3D", "as://contact?token=XXXX%3AYYYZZZ&free=AbC%2B123%3D", "AS://contact?free=AbC%2B123%3D&token=XXXX:YYYZZZ"] {
    precondition(parseContactTokenLink(link) == ContactTokenLink(token: "XXXX:YYYZZZ", freeToken: "AbC+123="))
    checked += 1
}
for link in ["https://asme.su/contact/XXXX:YYYZZZ", "as://contact?token=XXXX:YYYZZZ", "as://contact?token=XXXX:YYYZZZ&free=", "https://asme.su/contact/XXXX:YYYZZZ?free"] {
    precondition(parseContactTokenLink(link) == ContactTokenLink(token: "XXXX:YYYZZZ", freeToken: nil))
    checked += 1
}
for link in ["https://asme.su.evil.test/contact/token", "https://asme.su@evil.test/contact/token", "https://evil.test@asme.su/contact/token", "https://asme.su:123/contact/token", "https://evil.test/contact/token?free=secret", "https://t.me.evil.test/contact/token", "https://t.me@evil.test/contact/token", "https://evil.test@asme.su/contact/token", "https://asme.su/contact/", "https://asme.su/contact/a/b", "https://asme.su/contact/a%2Fb", "as://contact?token=", "as://contacts?token=a", "as://contact/other?token=a", "https://asme.su/user?free=a"] {
    precondition(parseContactTokenLink(link) == nil, link)
    checked += 1
}
for action in [QrStudioCodeAction.expire, .permanent, .restore, .renew] {
    precondition(action.constrained(toTemporary: false) == action)
    precondition(action.constrained(toTemporary: true) == (action == .permanent ? .expire : action))
    checked += 2
}
var state = QrStudioCodeState()
precondition(QrStudioBurn.menu(for: state, allowsPermanent: false).isEmpty)
state.perform(QrStudioCodeAction.permanent.constrained(toTemporary: true), at: 10)
precondition(state.removeFee && state.expires)
precondition(QrStudioBurn.menu(for: state, allowsPermanent: false) == [[.renew], [.restore]])
precondition(QrStudioBurn.menu(for: state) == [[.renew, .permanent], [.restore]])
state.perform(.restore, at: 20)
precondition(!state.removeFee)
checked += 5
print("Passed \(checked) contact-link and temporary-code checks")

for scheme in ["as", "AS", "As"] {
    precondition(normalizeURLScheme("\(scheme)://resolve?domain=alice&post=42" as NSString) as String == "as://resolve?domain=alice&post=42")
}
precondition(normalizeURLScheme("https://asme.su/alice" as NSString) as String == "https://asme.su/alice")
print("Passed Ansible scheme normalization checks")

for link in ["tg://contact?token=foreign", "ansible://contact?token=foreign", "https://t.me/contact/foreign", "https://telegram.me/contact/foreign"] {
    precondition(parseContactTokenLink(link) == nil, link)
}
print("Foreign application contact links remain external")
