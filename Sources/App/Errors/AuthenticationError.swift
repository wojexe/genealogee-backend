import Vapor

enum AuthenticationError: AppError {
    case emailAlreadyExists
    case invalidEmailOrPassword
}

extension AuthenticationError: AbortError {
    var status: HTTPResponseStatus {
        switch self {
        case .emailAlreadyExists:
            return .badRequest
        case .invalidEmailOrPassword:
            return .badRequest
        }
    }
    
    var reason: String {
        switch self {
        case .emailAlreadyExists:
            return "A user with that email already exists"
        case .invalidEmailOrPassword:
            return "The email or password is incorrect"
        }
    }
    
    var identifier: String {
        switch self {
        case .emailAlreadyExists:
            return "email_already_exists"
        case .invalidEmailOrPassword:
            return "incorrect_email_or_password"
        }
    }
}
