// import Fakery
// import Fluent
// import Vapor

// extension App.User: Mockable {
//     public static func mock() -> User {
//         let faker = Faker()

//         let user = User(
//             id: UUID.generateRandom(),
//             email: faker.internet.freeEmail(),
//             name: faker.name.name(),
//             passwordHash: "super_secure_password123"
//         )

//         return user
//     }

//     public static func mockSaved(on db: Database) async throws -> User {
//         let user = User.mock()

//         try await user.save(on: db)

//         return user
//     }
// }
