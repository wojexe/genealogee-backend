import Fluent
import Vapor

struct AuthenticationController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let auth = routes.grouped("auth")

        auth
            .grouped([User.authenticator(), User.credentialsAuthenticator()])
            .post("login", use: login)

        auth.post("register", use: register)

        auth.get("me", use: getCurrentUser)
    }

    func login(req: Request) throws -> HTTPStatus {
        try req.auth.require(User.self)

        return .ok
    }

    func register(req: Request) async throws -> HTTPStatus {
        try User.Register.validate(content: req)

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

        req.auth.login(user)

        return .created
    }

    func getCurrentUser(req: Request) throws -> User.DTO.Send {
        let user = try req.auth.require(User.self)

        return .init(from: user)
    }
}
