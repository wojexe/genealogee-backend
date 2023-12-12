import Fluent
import Vapor

struct PersonController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let person = routes.grouped("person")
        person.post("create", use: create)

        routes.get("people", use: all)

        // add child
        // add partner
        // add to new family
    }

    func create(req: Request) async throws -> HTTPStatus {
        try Person.validate(content: req)

        guard let personData = try? await Person.Create.decodeRequest(req) else {
            throw PersonError(.couldNotParse)
        }

        let user = req.auth.get(User.self)!

        guard let person = try? Person(from: personData, creatorID: user.id!) else {
            throw PersonError(.couldNotInstantiate)
        }

        do {
            try await person.save(on: req.db)
        } catch let dbError as DatabaseError {
            req.logger.log(level: .warning, "\(dbError)")

            throw PersonError(.couldNotSave)
        } catch let err {
            req.logger.report(error: err)

            throw Abort(.internalServerError)
        }

        return .created
    }

    func all(req: Request) async throws -> [Person] {
        let user = req.auth.get(User.self)!

        return try await Person.query(on: req.db)
            .filter(\Person.$creator.$id == user.id!)
            .all()
    }
}
