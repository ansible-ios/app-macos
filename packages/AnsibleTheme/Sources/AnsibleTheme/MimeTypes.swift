import Cocoa
import SwiftSignalKit
import AnsibleUIKit
import GZIP

public enum AnsibleStickerFormat {
    public static let mimeType = "application/x-ansible-sticker"

    public static func matches(_ mime: String) -> Bool {
        return mime == mimeType || mime == "application/x-tgsticker"
    }

    public static func fileName(_ name: String?, fallback: String = "sticker") -> String {
        let leaf = ((name ?? "") as NSString).lastPathComponent
        let stem = (leaf as NSString).deletingPathExtension
        if stem.isEmpty || stem == "." || stem == ".." || [".ass", ".tgs"].contains(leaf.lowercased()) {
            return fallback + ".ass"
        }
        return stem + ".ass"
    }

    private static let byteLimit = 8 * 1024 * 1024

    public static func dimensions(at path: String) -> (width: Int32, height: Int32)? {
        // SubStation Alpha subtitles also use .ass. Only classify a gzip Lottie as a sticker.
        guard let handle = FileHandle(forReadingAtPath: path) else { return nil }
        defer { handle.closeFile() }
        guard handle.readData(ofLength: 2) == Data([0x1f, 0x8b]) else { return nil }
        handle.seek(toFileOffset: 0)
        return dimensions(in: handle.readData(ofLength: byteLimit + 1))
    }

    public static func dimensions(in data: Data) -> (width: Int32, height: Int32)? {
        guard data.count <= byteLimit, let json = AnsibleGUnzipData(data, UInt32(byteLimit)), json.count <= byteLimit,
              let object = (try? JSONSerialization.jsonObject(with: json)) as? [String: Any],
              object["layers"] is [Any], let width = object["w"] as? Int32, let height = object["h"] as? Int32,
              width > 0, height > 0 else { return nil }
        return (width, height)
    }
}

fileprivate var mimestore:[String:String] = [:]
fileprivate var extensionstore:[String:String] = [:]


public func initializeMimeStore() {
    assertOnMainThread()
    if mimestore.isEmpty && extensionstore.isEmpty {
        let path = Bundle.main.path(forResource: "mime-types", ofType: "txt")
        let content = try? String(contentsOfFile: path ?? "")
        let mimes = content?.components(separatedBy: CharacterSet.newlines)
        
        if let mimes = mimes {
            for mime in mimes {
                let single = mime.components(separatedBy: ":")
                if single.count == 2 {
                    extensionstore[single[0]] = single[1]
                    mimestore[single[1]] = single[0]
                }
            }
        }
    }
}

public func resourceType(mimeType:String? = nil, orExt:String? = nil) -> Signal<String?, NoError> {
    
    
    assert(mimeType != nil || orExt != nil)
    assert((mimeType != nil && orExt == nil) || (mimeType == nil && orExt != nil))
    
    return Signal<String?, NoError> { (subscriber) -> Disposable in
        
        initializeMimeStore()
        
        var result:String?
        
        if let mimeType = mimeType {
            result = fileExt(mimeType)
        } else if let orExt = orExt {
            result = extensionstore[orExt.lowercased()]
        }
        
        subscriber.putNext(result)
        subscriber.putCompletion()
        
        return EmptyDisposable
        
    } |> runOn(Queue.mainQueue())
}

public func MIMEType(_ path: String, isExt: Bool = false) -> String {
    let fileExtension = isExt ? path.lowercased() : path.nsstring.pathExtension.lowercased()
    if fileExtension == "ass" || fileExtension == "tgs" {
        if isExt { return AnsibleStickerFormat.mimeType }
        if path.isDirectory { return "application/zip" }
        return AnsibleStickerFormat.dimensions(at: path) == nil ? "application/octet-stream" : AnsibleStickerFormat.mimeType
    }
    if !fileExtension.isEmpty {
        if let ext = extensionstore[fileExtension] {
            return ext
        } else {
            if !fileExtension.isEmpty {
                let UTIRef = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, fileExtension as CFString, nil)
                let UTI = UTIRef?.takeRetainedValue()
                if let UTI = UTI {
                    let MIMETypeRef = UTTypeCopyPreferredTagWithClass(UTI, kUTTagClassMIMEType)
                    if MIMETypeRef != nil
                    {
                        let MIMEType = MIMETypeRef?.takeRetainedValue()
                        return MIMEType as String? ?? "application/octet-stream"
                    }
                }
                
            }
            return "application/octet-stream"
        }
    } else {
        return !isExt && path.isDirectory ? "application/zip" : "application/octet-stream"
    }
    
}

public func fileExt(_ mimeType: String) -> String? {
    if AnsibleStickerFormat.matches(mimeType) { return "ass" }
    if let ext = mimestore[mimeType] {
        return ext
    }
    return nil
}

public let voiceMime = "audio/ogg"