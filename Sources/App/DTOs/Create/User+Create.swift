import Fluent
import Vapor

extension User {
    convenience init(from registerRequest: DTO.Create, hash: String) {
        self.init(email: registerRequest.email,
                  name: registerRequest.name,
                  passwordHash: hash)
    }
}

extension User.DTO {
    struct Create: Content, Validatable {
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
