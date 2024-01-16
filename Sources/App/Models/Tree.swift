import Fluent
import Vapor

final class Tree: Model, Content {
    static let schema = "trees"

    @ID
    var id: UUID?

    @Parent(key: "creator_id")
    var creator: User

    @Field(key: "name")
    var name: String

    @OptionalField(key: "root_family_id")
    var rootFamilyID: UUID?

    @Children(for: \.$tree)
    var families: [Family]

    @Children(for: \.$tree)
    var people: [Person]

    @Children(for: \.$tree)
    var snapshots: [TreeSnapshot]

    init() {}

    init(id: UUID? = nil,
         creatorID: UUID,
         rootFamilyID: UUID? = nil,
         name: String)
    {
        self.id = id
        $creator.id = creatorID
        self.name = name
        self.rootFamilyID = rootFamilyID
    }

    // Foreign key constraints ensure that all related data is deleted
    func nuke(on db: Database) async throws {
        try await delete(on: db)
    }

    func snapshot(on db: Database) async throws -> Tree.Snapshot {
        try await Tree.Snapshot(from: self, on: db)
    }

    // TODO: implement `restore` here to meet the requirements fro the memento pattern

    struct DTO {}
}

extension Tree: Validatable {
    static func validations(_ val: inout Validations) {
        val.add("name", as: String.self, is: .count(...64))
        val.add("rootFamilyID", as: UUID.self, required: false)
    }
}
