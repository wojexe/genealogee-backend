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
    
    func register(req: Request) throws -> EventLoopFuture<HTTPResponseStatus> {
        try User.Register.validate(content: req)
        
        let registerRequest = try req.content.decode(User.Register.self)
        
        return req
            .password
            .async
            .hash(registerRequest.password)
            .flatMapThrowing { User(from: registerRequest, hash: $0) }
            .flatMap { user in
                user.create(on: req.db)
                    .flatMapErrorThrowing { err in
                        if let dbError = err as? DatabaseError, dbError.isConstraintFailure {
                            throw AuthenticationError.emailAlreadyExists
                        }
                        
                        req.logger.error("Error while registering user: \(err)")
                        
                        throw Abort(.internalServerError)
                    }
                    .transform(to: .created)
            }
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
