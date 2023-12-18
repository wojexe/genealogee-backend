import Fluent
import Vapor

extension TreeService {
    func create(from data: Tree.Create) async throws -> Tree.Created {
        let user = try req.auth.require(User.self)
        let userID = try user.requireID()

        let tree = try Tree(from: data, creatorID: userID)

        try await tree.save(on: req.db)

        return try Tree.Created(tree)
    }
}
