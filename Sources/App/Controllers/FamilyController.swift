import Fluent
import Vapor

struct FamilyController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let family = routes.grouped("family")
        family.post("create", use: create)

        routes.get("families", use: all)
    }

    func create(req _: Request) async throws -> HTTPStatus {
        throw Abort(.internalServerError)
    }

    func addChild(req _: Request) async throws -> HTTPStatus {
        throw Abort(.internalServerError)
    }

    func addParent(req _: Request) async throws -> HTTPStatus {
        throw Abort(.internalServerError)
    }

    func all(req _: Request) async throws -> HTTPStatus {
        throw Abort(.internalServerError)
    }
}
