import Vapor

extension UUID: CodingKeyRepresentable {
    public var codingKey: any CodingKey { BasicCodingKey(uuidString) }
}
