import Fluent
import Vapor

final class User: Model, Content {
    static let schema = "users"

    @ID
    var id: UUID?

    @Field(key: "email")
    var email: String

    @Field(key: "name")
    var name: String

    @Field(key: "password_hash")
    var passwordHash: String

    @Children(for: \.$creator)
    var trees: [Tree]

    @Children(for: \.$creator)
    var people: [Person]

    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?

    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?

    init() {}

    init(id: UUID? = nil, email: String, name: String, passwordHash: String) {
        self.id = id
        self.email = email
        self.name = name
        self.passwordHash = passwordHash
    }

    struct DTO {}
}

extension User: ModelAuthenticatable {
    static var usernameKey = \User.$email
    static var passwordHashKey = \User.$passwordHash

    func verify(password: String) throws -> Bool {
        try Bcrypt.verify(password, created: passwordHash)
    }
}

extension User: ModelSessionAuthenticatable {}

extension User: ModelCredentialsAuthenticatable {}
