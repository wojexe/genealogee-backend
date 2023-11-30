import Fluent
import Vapor

struct AuthenticationController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.group("auth") { auth in
            auth.post("register", use: register)
            
            auth.grouped([User.credentialsAuthenticator(), // Form
                          User.authenticator(), // Authorization: Basic <login:password>
                          User.guardMiddleware()])
            .post("login", use: login)
            
            auth.get("me", use: getCurrentUser)
        }
    }
    
    func register(req: Request) async throws -> HTTPResponseStatus {
        try User.validate(content: req)
        
        let registerRequest = try req.content.decode(User.Register.self)
        
        let passwordHash = try await req.password.async.hash(registerRequest.password)
        
        let user = User(from: registerRequest, hash: passwordHash)
        
        do {
            try await user.create(on: req.db)
        } catch let dbError as DatabaseError where dbError.isConstraintFailure {
            throw AuthenticationError.emailAlreadyExists
        } catch let err {
            if let dbError = err as? DatabaseError {
                req.logger.warning("\(dbError)")
            } else {
                req.logger.report(error: err)
            }
            
            throw Abort(.internalServerError)
        }
        
        return .created
    }
    
    func login(req: Request) throws -> HTTPResponseStatus {
        try req.auth.require(User.self)
        
        return .ok
    }
    
    func getCurrentUser(_ req: Request) throws -> String {
        let user = try req.auth.require(User.self)
        
        return "You're logged in as: \(user.email)"
    }
}
