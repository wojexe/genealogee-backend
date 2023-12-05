import Fluent
import Vapor

// TODO: Better error handling
struct TreeController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.get("trees", use: all)

        let tree = routes.grouped("tree")

        tree.post("create", use: create)
        tree.get(":id", use: byID)
    }

    func all(req: Request) async throws -> [Tree] {
        let user = req.auth.get(User.self)!

        return try await Tree.query(on: req.db)
            .filter(\Tree.$creator.$id == user.id!)
            .with(\.$families)
            .all()
    }

    func create(req: Request) async throws -> HTTPStatus {
        try Tree.validate(content: req)

        guard let treeData = try? await Tree.Create.decodeRequest(req) else {
            throw Abort(.internalServerError)
        }

        let user = req.auth.get(User.self)!

        guard let tree = try? Tree(from: treeData, creatorID: user.id!) else {
            throw Abort(.internalServerError)
        }

        do {
            try await tree.save(on: req.db)
        } catch let dbError as DatabaseError {
            req.logger.log(level: .warning, "\(dbError)")

            throw PersonError(.couldNotSave)
        } catch let err {
            req.logger.report(error: err)

            throw Abort(.internalServerError)
        }

        return .created
    }

    func byID(req: Request) async throws -> Tree {
        let user = req.auth.get(User.self)!
        let treeID = req.parameters.get("id", as: UUID.self)

        guard let tree = try await Tree.query(on: req.db)
            .filter(\Tree.$creator.$id == user.id!)
            .filter(\Tree.$id == treeID!)
            .first() else {
            throw Abort(.notFound)
        }

        return tree
    }
}
