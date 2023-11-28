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
    var people: [Person]
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?
    
    @Timestamp(key: "deleted_at", on: .delete)
    var deletedAt: Date?
    
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

extension User: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("email",
                        as: String.self,
                        is: .email)
        
        validations.add("name",
                        as: String.self,
                        is: !.empty && .count(...64))
        
        validations.add("password",
                        as: String.self,
                        is: .count(8...1024))
    }
}
