import Cocoa

public final class ApiEnvironment {
    public static var apiId:Int32 {
        guard let value = Bundle.main.object(forInfoDictionaryKey: "AnsibleApiId") as? String,
              let id = Int32(value), id > 0 else {
            preconditionFailure("Configure ANSIBLE_API_ID before building Ansible")
        }
        return id
    }
    public static var apiHash:String {
        guard let value = Bundle.main.object(forInfoDictionaryKey: "AnsibleApiHash") as? String,
              value.count == 32, value.allSatisfy({ $0.isHexDigit }) else {
            preconditionFailure("Configure ANSIBLE_API_HASH before building Ansible")
        }
        return value
    }
    
    public static var bundleId: String {
        return "com.ansible.macos"
    }
    public static var teamId: String {
        return Bundle.main.object(forInfoDictionaryKey: "AnsibleTeamId") as? String ?? ""
    }
    
    
    
    public static var containerURL: URL? {
        if !usesAppGroup {
            guard let support = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first else {
                return nil
            }
            let url = support.appendingPathComponent(bundleId).appendingPathComponent(prefix)
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: [.posixPermissions: 0o700])
                return url
            } catch {
                return nil
            }
        }
        let appGroupName = ApiEnvironment.group
        let containerUrl = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupName)?.appendingPathComponent(prefix)
        if let containerUrl = containerUrl {
            try? FileManager.default.createDirectory(at: containerUrl, withIntermediateDirectories: true, attributes: nil)
            return containerUrl
        }
        return nil
    }
    
    public static func migrate() {
        if let containerURL = containerURL, let legacy = legacyContainerURL, let sequence = FileManager.default.enumerator(atPath: legacy.path) {
            let contents = try? FileManager.default.contentsOfDirectory(at: containerURL, includingPropertiesForKeys: nil, options: [])
            if let contents = contents, !contents.isEmpty {
                return
            }
            for value in sequence {
                if let value = value as? String {
                    if !prefixList.contains(value) {
                        try? FileManager.default.moveItem(at: legacy.appendingPathComponent(value), to: containerURL.appendingPathComponent(value))
                    }
                }
            }
        }
    }
    
    public static var legacyContainerURL: URL? {
        guard usesAppGroup else {
            return nil
        }
        let appGroupName = ApiEnvironment.group
        let containerUrl = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupName)
        return containerUrl
    }
    
    public static var group: String {
        return "group.com.ansible.macos"
    }

    public static var usesAppGroup: Bool {
        return Bundle.main.object(forInfoDictionaryKey: "AnsibleUseAppGroup") as? String == "YES"
    }

    public static var keychainScope: String {
        return bundleId + "." + prefix
    }
    
    public static var appData: Data {
        let apiData = evaluateApiData() ?? ""
        let dict:[String: String] = ["bundleId": bundleId, "data": apiData]
        return try! JSONSerialization.data(withJSONObject: dict, options: [])
    }
    public static var language: String {
        return "macos"
    }
    
    public static var prefixList:[String] {
        return ["debug", "stable", "appstore", "beta"]
    }
    
    public static var prefix: String {
        var prefix: String = ""
        switch Configuration.value(for: .source) {
        case "DEBUG":
            prefix = "debug"
        case "STABLE":
            prefix = "stable"
        case "APP_STORE":
            prefix = "appstore"
        default:
            prefix = "beta"
        }
        return prefix
    }
    
    public static var version: String {
        var suffix: String = ""
        
        suffix = Configuration.value(for: .source) ?? "DEBUG"
        let shortVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] ?? ""
        return "\(shortVersion) \(suffix)"
    }
    
}



