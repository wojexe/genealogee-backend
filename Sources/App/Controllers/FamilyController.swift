import Fluent
import Vapor

struct FamilyController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let family = routes.grouped("family")
        family.post("create", use: create)
        family.delete("delete", use: delete)

        routes.get("families", use: all)
    }

    func create(_: Request) async throws -> HTTPStatus {
        throw Abort(.internalServerError)
    }

    func addChild(_: Request) async throws -> HTTPStatus {
        throw Abort(.internalServerError)
    }

    func addParent(_: Request) async throws -> HTTPStatus {
        throw Abort(.internalServerError)
    }

    func delete(_: Request) async throws -> HTTPStatus {
        throw Abort(.internalServerError)
    }

    func all(req _: Request) async throws -> HTTPStatus {
        throw Abort(.internalServerError)
    }
}
