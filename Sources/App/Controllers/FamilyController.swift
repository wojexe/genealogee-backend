import Vapor

struct FamilyController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let family = routes.grouped("family")
        family.delete("delete", use: delete)

        routes.get("families", use: all)
    }

    // TODO: implement
    @Sendable
    func delete(_: Request) async throws -> HTTPStatus {
        throw Abort(.notImplemented)
    }

    @Sendable
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
