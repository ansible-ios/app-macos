import Foundation
import TelegramApi

struct Fixture: Decodable {
    let name: String
    let hex: String
}

let fixtures = try JSONDecoder().decode([Fixture].self, from: Data(contentsOf: URL(fileURLWithPath: CommandLine.arguments[1])))
for fixture in fixtures {
    let chars = Array(fixture.hex)
    let bytes = Data(stride(from: 0, to: chars.count, by: 2).map { UInt8(String(chars[$0...$0+1]), radix: 16)! })
    let sentinel = Data([0x37, 0x97, 0x79, 0xbc])
    let reader = BufferReader(Buffer(data: bytes + sentinel))
    guard let signature = reader.readInt32(), let parsed = Api.parse(reader, signature: signature) else {
        fatalError("Cannot parse " + fixture.name)
    }
    precondition(reader.offset == bytes.count, "Incorrect vector boundary: " + fixture.name)
    precondition(reader.readInt32() == Int32(bitPattern: 0xbc799737), "Following Bool was lost: " + fixture.name)
    let serialized = Buffer()
    Api.serializeObject(parsed, buffer: serialized, boxed: true)
    precondition(serialized.makeData() == bytes, "Roundtrip changed fields: " + fixture.name)
    precondition(Api.parse(Buffer(data: bytes.dropLast())) == nil, "Truncated frame accepted: " + fixture.name)
}
print("Layer 233: \(fixtures.count) independent wire vectors PASS")
