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
    
    init() { }

    init(id: UUID? = nil, email: String, name: String, passwordHash: String) {
        self.id = id
        self.email = email
        self.name = name
        self.passwordHash = passwordHash
    }
}

extension User: ModelAuthenticatable {
    static var usernameKey = \User.$email
    static var passwordHashKey = \User.$passwordHash
    
    func verify(password: String) throws -> Bool {
        return try Bcrypt.verify(password, created: self.passwordHash)
    }
}

extension User: ModelSessionAuthenticatable { }

extension User: ModelCredentialsAuthenticatable { }
