import Vapor

struct PersonController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let person = routes.grouped("person")
        person.post("create", use: create)

        let certainPerson = person.grouped(":personID")
        certainPerson.get(use: byID)
        certainPerson.patch(use: update)
        certainPerson.delete(use: delete)

        routes.get("people", use: all)
    }

    @Sendable
    func create(req: Request) async throws -> Person.DTO.Send {
        try Person.DTO.Create.validate(content: req)

        let data = try await Person.DTO.Create.decodeRequest(req)

        return try await .init(
            req.peopleService.create(from: data),
            on: req.db
        )
    }

    @Sendable
    func update(req: Request) async throws -> Person.DTO.Send {
        let personID = try req.parameters.require("personID", as: UUID.self)

        try Person.DTO.Update.validate(content: req)

        let data = try await Person.DTO.Update.decodeRequest(req)

        return try await .init(
            req.peopleService.update(personID, data),
            on: req.db
        )
    }

    @Sendable
    func delete(req: Request) async throws -> HTTPStatus {
        let personID = try req.parameters.require("personID", as: UUID.self)

        try await req.peopleService.delete(personID)

        return .ok
    }

    @Sendable
    func byID(req: Request) async throws -> Person.DTO.Send {
        let personID = try req.parameters.require("personID", as: UUID.self)

        return try await .init(
            req.people.get(personID),
            on: req.db
        )
    }

    // MARK: - Connections (currently unavailable)

    @Sendable
    func partner(req: Request) async throws -> Family.DTO.Send {
        let personID = try req.parameters.require("personID", as: UUID.self)
        let partnerID = try req.parameters.require("partnerID", as: UUID.self)

        return try await .init(
            req.peopleService.addRelative(personID: personID, .partner(partnerID)),
            on: req.db
        )
    }

    @Sendable
    func child(req: Request) async throws -> Family.DTO.Send {
        let personID = try req.parameters.require("personID", as: UUID.self)
        let childID = try req.parameters.require("childID", as: UUID.self)

        return try await .init(
            req.peopleService.addRelative(personID: personID, .child(childID)),
            on: req.db
        )
    }

    // MARK: - Development

    @Sendable
    func all(req: Request) async throws -> [Person] {
        guard req.application.environment == .development else {
            throw Abort(.notFound)
        }

        return try await req
            .people
            .scoped(by: .currentUser)
            .with(\.$family)
            .with(\.$parentFamily)
            .all()
    }
}
