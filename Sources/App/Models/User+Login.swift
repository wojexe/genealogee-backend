import Vapor
import Fluent

extension User {
    struct Login: Content, Validatable {
        var email: String
        var password: String
        
        static func validations(_ validations: inout Validations) {
            validations.add("email",
                            as: String.self,
                            is: .email)
            
            validations.add("password",
                            as: String.self,
                            is: .count(8...1024))
        }
    }
}
