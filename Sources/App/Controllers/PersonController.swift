import Fluent
import Vapor

struct PersonController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let person = routes.grouped("person")
        person.post("create", use: create)

        let certainPerson = person.grouped(":personID")
        certainPerson.delete(use: delete)

        certainPerson.group("add") { add in
            add.post("partner", ":partnerID", use: partner)
            add.post("child", ":childID", use: child)
        }

        routes.get("people", use: all) // Mostly for debugging, might be hidden behind a flag later on
    }

    func create(req: Request) async throws -> Person.Created {
        try Person.validate(content: req)

        let personData = try await Person.Create.decodeRequest(req)

        return try await req.peopleService.createPerson(from: personData)
    }

    func partner(req: Request) async throws -> Family.Created {
        let personID = try req.parameters.require("personID", as: UUID.self)
        let partnerID = try req.parameters.require("partnerID", as: UUID.self)

        return try await req.peopleService.addPartner(personID: personID, partnerID: partnerID)
    }

    func child(req: Request) async throws -> Family.Created {
        let personID = try req.parameters.require("personID", as: UUID.self)
        let childID = try req.parameters.require("childID", as: UUID.self)

        return try await req.peopleService.addChild(personID: personID, childID: childID)
    }

    func delete(req: Request) async throws -> HTTPStatus {
        let personID = try req.parameters.require("personID", as: UUID.self)

        try await req.peopleService.deletePerson(personID)

        return .ok
    }

    func all(req: Request) async throws -> [Person] {
        let user = req.auth.get(User.self)!

        return try await Person.query(on: req.db)
            .filter(\.$creator.$id == user.id!)
            .all()
    }
}
