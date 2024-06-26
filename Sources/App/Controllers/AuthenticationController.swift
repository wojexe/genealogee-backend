import Fluent
import Vapor

struct AuthenticationController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let auth = routes.grouped("auth")

        auth
            .grouped([User.authenticator(), User.credentialsAuthenticator()])
            .post("login", use: login)

        auth.post("logout", use: logout)
        auth.post("register", use: register)

        auth.get("me", use: getCurrentUser)
    }

    @Sendable
    func login(req: Request) throws -> HTTPStatus {
        try req.auth.require(User.self)

        return .ok
    }

    @Sendable
    func logout(req: Request) throws -> HTTPStatus {
        try req.auth.require(User.self)
        req.auth.logout(User.self)

        return .ok
    }

    @Sendable
    func register(req: Request) async throws -> HTTPStatus {
        try User.DTO.Create.validate(content: req)

        let registerRequest = try req.content.decode(User.DTO.Create.self)

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

    @Sendable
    func getCurrentUser(req: Request) throws -> User.DTO.Send {
        let user = try req.auth.require(User.self)

        return try .init(from: user)
    }
}
