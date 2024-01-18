import Fluent
import Vapor

extension TreeService {
    func create(from data: Tree.DTO.Create) async throws -> Tree {
        let user = try req.auth.require(User.self)
        let userID = try user.requireID()

        let tree = try Tree(from: data, creatorID: userID)

        try await tree.save(on: req.db)

        return tree
    }
}
