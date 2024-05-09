import Vapor

struct TreeController: RouteCollection {
    /// POST    /tree/create
    ///
    /// GET     /tree/:id
    /// DELETE  /tree/:id
    ///
    /// POST    /tree/:id/snapshot/create
    ///
    /// GET     /tree/:id/snapshot - get latest snapshot
    /// POST    /tree/:id/restore - restore latest snapshot
    ///
    /// GET     /tree/:id/snapshot/:snapshotID
    /// POST    /tree/:id/snapshot/:snapshotID/restore
    ///
    /// GET     /trees
    ///
    /// - Development -
    ///
    /// DELETE  /trees
    func boot(routes: RoutesBuilder) throws {
        let tree = routes.grouped("tree")
        let certainTree = tree.grouped(":treeID")
        let snapshotTree = certainTree.grouped("snapshot")
        let certainSnapshot = snapshotTree.grouped(":snapshotID")

        tree.post("create", use: create)

        certainTree.get(use: byID)
        certainTree.delete(use: delete)

        certainTree.post("restore", use: restoreLatestSnapshot)

        snapshotTree.get(use: getLatestSnapshot)
        snapshotTree.post("create", use: createSnapshot)

        certainSnapshot.get(use: getSnapshot)
        certainSnapshot.post("restore", use: restoreSnapshot)

        routes.get("trees", use: all)

        routes.delete("trees", use: nukeAllTrees)
    }

    @Sendable
    func create(req: Request) async throws -> Tree.DTO.Send {
        try Tree.DTO.Create.validate(content: req)

        let treeData = try await Tree.DTO.Create.decodeRequest(req)

        return try await .init(
            req.treesService.create(from: treeData),
            on: req.db
        )
    }

    @Sendable
    func delete(req: Request) async throws -> HTTPStatus {
        let treeID = try req.parameters.require("treeID", as: UUID.self)

        try await req.treesService.delete(treeID)

        return .ok
    }

    @Sendable
    func createSnapshot(req: Request) async throws -> TreeSnapshot.DTO.Send {
        let treeID = try req.parameters.require("treeID", as: UUID.self)

        return try await .init(
            req.treesService.snapshot(treeID),
            on: req.db
        )
    }

    @Sendable
    func getLatestSnapshot(req: Request) async throws -> TreeSnapshot.DTO.Send {
        let treeID = try req.parameters.require("treeID", as: UUID.self)

        let snapshot = try await req.treeSnapshots.get(by: .treeID(treeID))

        return try .init(snapshot, on: req.db)
    }

    @Sendable
    func restoreLatestSnapshot(req: Request) async throws -> Tree.DTO.Send {
        let treeID = try req.parameters.require("treeID", as: UUID.self)

        let latestSnapshot = try await req.treeSnapshots.get(by: .treeID(treeID))

        let tree = try await req.treesService.restore(treeID: treeID, snapshotID: latestSnapshot.requireID())

        return try await .init(tree, on: req.db)
    }

    @Sendable
    func getSnapshot(req: Request) async throws -> TreeSnapshot.DTO.Send {
        let treeID = try req.parameters.require("treeID", as: UUID.self)
        let snapshotID = try req.parameters.require("snapshotID", as: UUID.self)

        let snapshot = try await req.treeSnapshots.get(by: .snapshotID(snapshotID))

        guard snapshot.$tree.id == treeID else {
            throw Abort(.notFound, reason: "Snapshot does not belong to tree")
        }

        return try .init(snapshot, on: req.db)
    }

    @Sendable
    func restoreSnapshot(req: Request) async throws -> Tree.DTO.Send {
        let treeID = try req.parameters.require("treeID", as: UUID.self)
        let snapshotID = try req.parameters.require("snapshotID", as: UUID.self)

        let tree = try await req.treesService.restore(treeID: treeID, snapshotID: snapshotID)

        return try await .init(tree, on: req.db)
    }

    @Sendable
    func byID(req: Request) async throws -> Tree.DTO.Send {
        let treeID = try req.parameters.require("treeID", as: UUID.self)

        return try await .init(
            req.trees.get(id: treeID),
            on: req.db
        )
    }

    @Sendable
    func all(req: Request) async throws -> Tree.DTO.SendAll {
        let trees = try await req
            .trees
            .scoped(by: .currentUser)
            .with(\.$creator)
            .with(\.$people)
            .with(\.$families)
            .all()

        let DTOs = try await Tree.DTO.SendAll(trees, on: req.db)

        return DTOs
    }

    // MARK: - Development

    @Sendable
    func nukeAllTrees(req: Request) async throws -> HTTPStatus {
        guard req.application.environment == .development else {
            throw Abort(.notFound)
        }

        try await Tree.query(on: req.db).all().delete(force: true, on: req.db)

        return .ok
    }
}
