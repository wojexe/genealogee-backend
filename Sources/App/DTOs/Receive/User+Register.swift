import Vapor
import Fluent

extension User {
    convenience init(from registerRequest: Register, hash: String) {
        self.init(email: registerRequest.email,
                  name: registerRequest.name,
                  passwordHash: hash)
    }

    struct Register: Content {
        var email: String
        var name: String
        var password: String
    }
}
