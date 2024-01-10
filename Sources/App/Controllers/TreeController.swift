import Fluent
import Vapor

struct TreeController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let tree = routes.grouped("tree")

        tree.post("create", use: create)

        tree.get(":id", use: byID)

        routes.get("trees", use: all)
    }

    func create(req: Request) async throws -> Tree.Created {
        try Tree.validate(content: req)

        let treeData = try await Tree.Create.decodeRequest(req)

        return try await req.treeService.create(from: treeData)
    }

    func all(req: Request) async throws -> [Tree.DTO.Send] {
        let trees = try await req
            .trees
            .scoped(by: .currentUser)
            .with(\.$creator)
            .with(\.$people)
            .with(\.$families)
            .all()

        var DTOs: [Tree.DTO.Send] = []

        for tree in trees {
            try await DTOs.append(Tree.DTO.Send(tree, on: req.db))
        }

        return DTOs
    }

    func byID(req: Request) async throws -> Tree.DTO.Send {
        let treeID = try req.parameters.require("id", as: UUID.self)

        return try await .init(
            req.trees.get(id: treeID, entire: false),
            on: req.db
        )
    }
}
