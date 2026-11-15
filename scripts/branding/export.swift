import Foundation
import AppKit
import CoreGraphics
import ImageIO
import UniformTypeIdentifiers
let client=URL(fileURLWithPath:FileManager.default.currentDirectoryPath)
let pack=client.appendingPathComponent("branding")
let specs=try! JSONSerialization.jsonObject(with:Data(contentsOf:pack.appendingPathComponent("asset-manifest.json"))) as! [[String:Any]]
func load(_ path:String)->CGImage {
    let ns=NSImage(contentsOfFile:path)!;var rect=CGRect(origin:.zero,size:ns.size)
    return ns.cgImage(forProposedRect:&rect,context:nil,hints:nil)!
}
func content(_ im:CGImage)->CGImage {
    let w=im.width,h=im.height
    let c=CGContext(data:nil,width:w,height:h,bitsPerComponent:8,bytesPerRow:w*4,space:CGColorSpaceCreateDeviceRGB(),bitmapInfo:CGImageAlphaInfo.premultipliedLast.rawValue)!
    c.draw(im,in:CGRect(x:0,y:0,width:w,height:h))
    let p=c.data!.assumingMemoryBound(to:UInt8.self)
    var x0=w,y0=h,x1=0,y1=0
    for y in 0..<h { for x in 0..<w { if p[(y*w+x)*4+3]>=128 {x0=min(x0,x);y0=min(y0,y);x1=max(x1,x);y1=max(y1,y)} } }
    precondition(x1>x0 && y1>y0)
    return im.cropping(to:CGRect(x:x0,y:y0,width:x1-x0+1,height:y1-y0+1))!
}
let diamond=content(load(pack.appendingPathComponent("masters/diamond-original.webp").path))
let logo=content(load(pack.appendingPathComponent("masters/ansible-logo-original.pdf").path))
let variants=["color":diamond,"mono":diamond,"outline":diamond,"settings":diamond,"premium":diamond,"diamond-circle":diamond,"logo-mono":logo]
func template(_ image:CGImage)->CGImage {
    let w=image.width,h=image.height
    let context=CGContext(data:nil,width:w,height:h,bitsPerComponent:8,bytesPerRow:w*4,space:CGColorSpaceCreateDeviceRGB(),bitmapInfo:CGImageAlphaInfo.premultipliedLast.rawValue)!
    context.draw(image,in:CGRect(x:0,y:0,width:w,height:h))
    let p=context.data!.assumingMemoryBound(to:UInt8.self)
    for i in 0..<(w*h) {
        let j=i*4
        let alpha=UInt8((54*UInt32(p[j])+183*UInt32(p[j+1])+19*UInt32(p[j+2])+128)/256)
        p[j]=alpha;p[j+1]=alpha;p[j+2]=alpha;p[j+3]=alpha
    }
    return context.makeImage()!
}
let menuTemplate=template(variants["mono"]!)
var count=0
for s in specs {
    let role=s["role"] as! String
    guard role != "preserved-app" else {continue}
    let raw=variants[role]!
    let source = ["mono","outline","premium"].contains(role) ? menuTemplate : raw
    let relative=s["path"] as! String
    let dest=client.appendingPathComponent(relative)
    precondition(FileManager.default.fileExists(atPath:dest.path))
    let w=s["width"] as! Int,h=s["height"] as! Int
    let c=CGContext(data:nil,width:w,height:h,bitsPerComponent:8,bytesPerRow:w*4,space:CGColorSpaceCreateDeviceRGB(),bitmapInfo:CGImageAlphaInfo.premultipliedLast.rawValue)!
    let tiled=["settings","diamond-circle"].contains(role)
    if tiled {
        c.saveGState()
        let radius=CGFloat(w)*(role=="diamond-circle" ? 0.5 : 0.23)
        c.addPath(CGPath(roundedRect:CGRect(x:0,y:0,width:w,height:h),cornerWidth:radius,cornerHeight:radius,transform:nil));c.clip()
        let colors = role=="premium" ? [NSColor(srgbRed:0.49,green:0.34,blue:0.98,alpha:1).cgColor,NSColor(srgbRed:0.76,green:0.49,blue:0.98,alpha:1).cgColor] : [NSColor(srgbRed:0.08,green:0.35,blue:0.67,alpha:1).cgColor,NSColor(srgbRed:0.17,green:0.64,blue:0.94,alpha:1).cgColor]
        let gradient=CGGradient(colorsSpace:CGColorSpaceCreateDeviceRGB(),colors:colors as CFArray,locations:[0,1])!
        c.drawLinearGradient(gradient,start:CGPoint(x:0,y:0),end:CGPoint(x:w,y:h),options:[]);c.restoreGState()
    }
    let padding:CGFloat=CGFloat(min(w,h))*(tiled ? 0.15 : 0.067)
    let area=CGRect(x:padding,y:padding,width:CGFloat(w)-2*padding,height:CGFloat(h)-2*padding)
    let scale=min(area.width/CGFloat(source.width),area.height/CGFloat(source.height))
    let size=CGSize(width:CGFloat(source.width)*scale,height:CGFloat(source.height)*scale)
    c.interpolationQuality = .high;c.draw(source,in:CGRect(x:area.midX-size.width/2,y:area.midY-size.height/2,width:size.width,height:size.height))
    let output=CGImageDestinationCreateWithURL(dest as CFURL,UTType.png.identifier as CFString,1,nil)!
    CGImageDestinationAddImage(output,c.makeImage()!,nil);precondition(CGImageDestinationFinalize(output));count+=1
}
print("Exported approved diamond variants to \(count) native PNG slots.")
