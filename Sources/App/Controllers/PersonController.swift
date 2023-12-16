import Fluent
import Vapor

struct PersonController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let person = routes.grouped("person")
        person.post("create", use: create)

        let certainPerson = person.grouped(":personID")
        certainPerson.delete(use: delete)

        certainPerson.group("add") { add in
            add.post("partner", ":partnerID", use: partner) // /person/:personID/add/partner/:partnerID
            add.post("child", ":childID", use: child) // /person/:personID/add/child/:childID
        }

        routes.get("people", use: all) // Mostly for debugging, might be hidden behind a flag later on
    }

    func create(req: Request) async throws -> Person.Created {
        try Person.validate(content: req)

        guard let personData = try? await Person.Create.decodeRequest(req) else {
            throw PersonError(.couldNotParse)
        }

        return try await req.peopleService.createPerson(from: personData)
    }

    func partner(req: Request) async throws -> Family.Created {
        guard let personID = req.parameters.get("personID", as: UUID.self) else {
            throw Abort(.badRequest, reason: "Provided Person ID is not a valid UUID.")
        }

        guard let partnerID = req.parameters.get("partnerID", as: UUID.self) else {
            throw Abort(.badRequest, reason: "Provided Partner ID is not a valid UUID.")
        }

        return try await req.peopleService.addPartner(personID: personID, partnerID: partnerID)
    }

    func child(req: Request) async throws -> Family.Created {
        guard let personID = req.parameters.get("personID", as: UUID.self) else {
            throw Abort(.badRequest, reason: "Provided Person ID is not a valid UUID.")
        }

        guard let childID = req.parameters.get("childID", as: UUID.self) else {
            throw Abort(.badRequest, reason: "Provided Child ID is not a valid UUID.")
        }

        return try await req.peopleService.addChild(personID: personID, childID: childID)
    }

    func delete(req: Request) async throws -> HTTPStatus {
        guard let personID = req.parameters.get("id", as: UUID.self) else {
            throw Abort(.badRequest, reason: "Provided ID is not a valid UUID.")
        }

        try await req.peopleService.deletePerson(personID)

        return .ok
    }

    func all(req: Request) async throws -> [Person] {
        let user = req.auth.get(User.self)!

        return try await Person.query(on: req.db)
            .filter(\Person.$creator.$id == user.id!)
            .all()
    }
}
