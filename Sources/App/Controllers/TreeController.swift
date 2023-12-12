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

    func create(req: Request) async throws -> Tree.Created {
        try Tree.validate(content: req)

        guard let treeData = try? await Tree.Create.decodeRequest(req) else {
            throw Abort(.internalServerError)
        }

        let user = try req.auth.require(User.self)
        let userID = try user.requireID()

        guard let tree = try? Tree(from: treeData, creatorID: userID) else {
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

        return try Tree.Created(tree)
    }

    func all(req: Request) async throws -> [Tree] {
        let user = req.auth.get(User.self)!

        return try await Tree.query(on: req.db)
            .filter(\Tree.$creator.$id == user.id!)
            .with(\.$people)
            .with(\.$families) { family in
                family
                    .with(\.$children)
                    .with(\.$parents)
            }
            .all()
    }

    func byID(req: Request) async throws -> Tree {
        let user = try req.auth.require(User.self)

        guard let treeID = req.parameters.get("id", as: UUID.self) else {
            throw Abort(.imATeapot)
        }

        guard let tree = try await Tree.query(on: req.db)
            .filter(\Tree.$creator.$id == user.id!)
            .filter(\Tree.$id == treeID)
            .first()
        else {
            throw Abort(.notFound)
        }

        return tree
    }
}
