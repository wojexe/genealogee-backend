import Fluent
import Vapor

// TODO: Implement FamilyController
struct FamilyController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let family = routes.grouped("family")
        family.delete("delete", use: delete)

        routes.get("families", use: all)
    }

    func addChild(_: Request) async throws -> HTTPStatus {
        throw Abort(.notImplemented)
    }

    func addParent(_: Request) async throws -> HTTPStatus {
        throw Abort(.notImplemented)
    }

    func removeChild(_: Request) async throws -> HTTPStatus {
        throw Abort(.notImplemented)
    }

    func removeParent(_: Request) async throws -> HTTPStatus {
        throw Abort(.notImplemented)
    }

    func delete(_: Request) async throws -> HTTPStatus {
        throw Abort(.notImplemented)
    }

    func all(req: Request) async throws -> [Family] {
        guard req.application.environment == .development else {
            throw Abort(.notFound)
        }

        return try await req
            .families
            .scoped(by: .currentUser)
            .with(\.$parents)
            .with(\.$children)
            .all()
    }
}
