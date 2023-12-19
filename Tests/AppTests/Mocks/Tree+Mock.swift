// import Fakery
// import Fluent
// import Vapor

// extension App.Tree {
//     public static func mock(creatorID: UUID,
//                             rootFamilyID: UUID? = nil) -> Tree
//     {
//         let faker = Faker()

//         let tree = Tree(creatorID: creatorID,
//                         rootFamilyID: rootFamilyID,
//                         name: faker.cat.breed())

//         return tree
//     }

//     static func mockSaved(creatorID: UUID,
//                           rootFamilyID: UUID? = nil,
//                           on db: Database) async throws -> Tree
//     {
//         let tree = mock(creatorID: creatorID, rootFamilyID: rootFamilyID)

//         try await tree.save(on: db)

//         return tree
//     }
// }
