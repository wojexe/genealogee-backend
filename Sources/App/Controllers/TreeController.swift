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

        let treeData = try await Tree.Create.decodeRequest(req)

        return try await req.treeService.create(from: treeData)
    }

    func all(req: Request) async throws -> [Tree] {
        try await req
            .trees
            .scoped(by: .currentUser)
            .with(\.$creator)
            .with(\.$people)
            .with(\.$families) { family in
                family
                    .with(\.$children)
                    .with(\.$parents)
            }
            .all()
    }

    // TODO: Error handling (maybe even in the repo itself)
    func byID(req: Request) async throws -> Tree {
        guard let treeID = req.parameters.get("id", as: UUID.self) else {
            throw Abort(.badRequest)
        }

        struct Params: Content {
            let entire: Bool?
        }

        guard let entire = try req.query.get(Params.self).entire else {
            throw Abort(.badRequest)
        }

        return try await req
            .trees
            .get(id: treeID, entire: entire)
    }
}
