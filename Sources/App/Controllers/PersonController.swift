import Fluent
import Vapor

struct PersonController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let person = routes.grouped("person")
        person.post("create", use: create)
        
        let people = routes.grouped("people")
        people.get("all", use: all)
    }
    
    func create(req: Request) async throws -> HTTPStatus {
        try Person.validate(content: req)
        
        guard let personData = try? await Person.Create.decodeRequest(req) else {
            throw PersonError(.couldNotParse)
        }
        
        let user = try! req.auth.require(User.self) // Already authenticated
        
        guard let person = try? Person(from: personData, creatorID: user.id!) else {
            throw PersonError(.couldNotInstantiate)
        }
        
        do {
            try await person.save(on: req.db)
        } catch let dbError as DatabaseError {
            let logLevel = dbError.isConstraintFailure
                               ? Logger.Level.warning
                               : Logger.Level.error
            
            req.logger.log(level: logLevel, "\(dbError)")
            
            throw PersonError(.couldNotSave)
        } catch let err {
            req.logger.report(error: err)
            
            throw Abort(.internalServerError)
        }
        
        return .ok
    }
    
    func all(req: Request) async throws -> [Person] {
        let user = try! req.auth.require(User.self)
        
        return try await Person.query(on: req.db)
            .filter(\Person.$creator.$id == user.id!)
            .all()
    }
}
