import Fluent
import Vapor

extension User {
    convenience init(from registerRequest: Register, hash: String) {
        self.init(email: registerRequest.email,
                  name: registerRequest.name,
                  passwordHash: hash)
    }

    struct Register: Content, Validatable {
        var email: String
        var name: String
        var password: String

        static func validations(_ validations: inout Validations) {
            validations.add("email",
                            as: String.self,
                            is: .email)

            validations.add("name",
                            as: String.self,
                            is: !.empty && .count(...64))

            validations.add("password",
                            as: String.self,
                            is: .count(8 ... 1024))
        }
    }
}
