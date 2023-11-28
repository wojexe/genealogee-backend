import Fluent
import Vapor

struct PersonController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let person = routes.grouped("person")
        person.post("create", use: create)
        
        let people = routes.grouped("people")
        people.get("all", use: all)
    }
    
    // TODO: better error handling :)
    func create(req: Request) async throws -> HTTPStatus {
        try Person.validate(content: req)
        
        guard let personData = try? await Person.Create.decodeRequest(req) else {
            throw Abort(.badRequest)
        }
        
        guard let person = try? Person(from: personData) else {
            throw Abort(.internalServerError)
        }
        
        guard let _ = try? await person.save(on: req.db) else {
            throw Abort(.internalServerError)
        }
        
        return .ok
    }
    
    func all(req: Request) async throws -> [Person] {
        return try await Person.query(on: req.db).all()
    }
}
