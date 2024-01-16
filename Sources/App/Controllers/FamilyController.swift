import Fluent
import Vapor

struct FamilyController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let family = routes.grouped("family")
        family.delete("delete", use: delete)

        routes.get("families", use: all)
    }

    /// These methods are not implemented currently, because it is easier
    /// to maintain correct relationships this way. The architecture to implement
    /// there functions is there, but adding this feature expands the scope too far.

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
