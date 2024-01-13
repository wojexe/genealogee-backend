import Vapor

struct TreeController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let tree = routes.grouped("tree")

        tree.post("create", use: create)

        let certainTree = tree.grouped(":id")

        certainTree.get(use: byID)
        certainTree.delete(use: delete)

        routes.get("trees", use: all)

        routes.delete("trees", use: nukeAllTrees)
    }

    func create(req: Request) async throws -> Tree.Created {
        try Tree.validate(content: req)

        let treeData = try await Tree.Create.decodeRequest(req)

        return try await req.treeService.create(from: treeData)
    }

    func delete(req: Request) async throws -> HTTPStatus {
        let treeID = try req.parameters.require("id", as: UUID.self)

        try await req.treeService.deleteTree(treeID)

        return .ok
    }

    func byID(req: Request) async throws -> Tree.DTO.Send {
        let treeID = try req.parameters.require("id", as: UUID.self)

        return try await .init(
            req.trees.get(id: treeID),
            on: req.db
        )
    }

    func all(req: Request) async throws -> [Tree.DTO.Send] {
        guard req.application.environment == .development else {
            throw Abort(.notFound)
        }

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

    // MARK: - Development

    func nukeAllTrees(req: Request) async throws -> HTTPStatus {
        guard req.application.environment == .development else {
            throw Abort(.notFound)
        }

        try await Tree.query(on: req.db).all().delete(force: true, on: req.db)

        return .ok
    }
}
