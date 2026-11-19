import Foundation
import AppKit
import Postbox
import TelegramCore
import MtProtoKit
import Colors
import Strings

public func escape(with link:String, addPercent: Bool = true) -> String {
    var escaped = addPercent ? link.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? link : link

    escaped = escaped.removingPercentEncoding ?? escaped
    return escaped
}

public func urlVars(with url: String) -> ([String: String], Set<String>) {
    var vars: [String: String] = [:]
    let range = url.nsstring.range(of: "?")
    let ns: NSString = range.location != NSNotFound ? url.nsstring.substring(from: range.location + 1).nsstring : url.nsstring

    let hashes = ns.components(separatedBy: "&")
    var emptyVars: Set<String> = Set()
    for hash in hashes {
        let param = hash.components(separatedBy: "=")
        if param.count > 1 {
            let key = param[0].lowercased()
            let rawValue = param[1...].joined(separator: "=")
            vars[key] = rawValue.removingPercentEncoding ?? rawValue
        } else if param.count == 1 {
            emptyVars.insert(param[0])
        }
    }
    return (vars, emptyVars)
}

/// Telegram links reach us with the query introduced by "&" as often as by "?",
/// and a strict URL parser reads the whole tail as the host. Give the query the
/// separator it needs so such a link can be understood.
public func normalizedAnsibleLinkQuery(_ url: String) -> String {
    guard !url.contains("?"), let separator = url.range(of: "&") else {
        return url
    }
    let scheme = url.prefix(while: { $0 != ":" }).lowercased()
    guard scheme == "as" else {
        return url
    }
    return url.replacingCharacters(in: separator, with: "?")
}

public func addUrlParameter(value: String, to url: String) -> String {
    if let _ = url.range(of: "?") {
        return url + "&" + value
    } else {
        if url.hasSuffix("/") {
            return url + value
        } else {
            return url + "/" + value
        }
    }
}

public func proxySettings(from url:String) -> (ProxyServerSettings?, Bool) {
    if let settings = webProxySettings(from: url) {
        return (settings, true)
    }
    let url = url.nsstring
    if url.hasPrefix(ansible_scheme), let _ = URL(string: url as String) {
        let action = url.substring(from: ansible_scheme.length)

        let (vars, _) = urlVars(with: url as String)
        if action.hasPrefix("socks") {
            if let server = vars[keyURLHost], let maybePort = vars[keyURLPort], let port = Int32(maybePort) {
                let server = escape(with: server)
                return (ProxyServerSettings(host: server, port: port, connection: .socks5(username: vars[keyURLUser], password: vars[keyURLPass])), true)
            }
            return (nil , true)
        } else if action.hasPrefix("proxy") {
            if let server = vars[keyURLHost], let maybePort = vars[keyURLPort], let port = Int32(maybePort), let rawSecret = vars[keyURLSecret] {
                let server = escape(with: server)
                if let secret = MTProxySecret.parse(rawSecret)?.serialize() {
                    return (ProxyServerSettings(host: server, port: port, connection: .mtp(secret: secret)), true)
                }
            }
        }

    } else if let _ = URL(string: url as String) {
        let link = parseInAppLink(url, options: InAppLinkParsingOptions(hasApplyProxy: true))
        switch link {
        case let .socks(_, settings):
            return (settings, true)
        default:
            break
        }
    }
    return (nil, false)
}

func webProxySettings(from value: String) -> ProxyServerSettings? {
    return parseWebProxySettingsLink(value)
}

public func isRetiredPaymentLink(_ value: String) -> Bool {
    let source = normalizedAnsibleLinkQuery(value)
    guard var url = URLComponents(string: source) else { return false }
    if url.scheme == nil && url.host == nil {
        guard let absolute = URLComponents(string: "https://" + source) else { return false }
        url = absolute
    }
    let scheme = url.scheme?.lowercased() ?? ""
    if ["ton", "gram", "tonsite", "tc", "tonconnect"].contains(scheme) { return true }
    let host = url.host?.lowercased().trimmingCharacters(in: CharacterSet(charactersIn: ".")) ?? ""
    if host.hasSuffix(".ton") { return true }
    var path = url.path.lowercased().split(separator: "/").map(String.init)
    if ["as", "tg", "telegram"].contains(scheme) {
        if host.isEmpty && url.queryItems?.contains(where: { $0.name == "v" && $0.value == "2" }) == true { return true }
        path.insert(host, at: 0)
    } else if host != "asme.su" {
        return false
    }
    let retired = ["ton", "gram", "grams", "sendgrams"]
    return path.first.map(retired.contains) == true || (path.count == 2 && path[0] == "settings" && retired.contains(path[1]))
}

public func explicitUrl(_ url: String) -> String {
    var url = url
    if !url.hasPrefix("http") && !url.hasPrefix("https") && url.range(of: "://") == nil {
        url = "https://\(url)"
    }
    return url
}

public func urlWithoutScheme(from url: URL) -> (url: String, host: String)? {
    guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
        return nil
    }

    guard let host = components.host else {
        return nil
    }

    var urlString = host

    if !components.path.isEmpty {
        urlString += components.path
    }

    if let query = components.query, !query.isEmpty {
        urlString += "?" + query
    }

    if let fragment = components.fragment, !fragment.isEmpty {
        urlString += "#" + fragment
    }

    if urlString.hasSuffix("/") {
        _ = urlString.removeLast()
    }

    return (url: urlString, host: host)
}
