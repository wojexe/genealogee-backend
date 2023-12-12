import Vapor

enum AuthenticationError: AppError {
    case emailAlreadyExists
    case invalidEmailOrPassword
}

extension AuthenticationError: AbortError {
    var status: HTTPResponseStatus {
        switch self {
        case .emailAlreadyExists:
            .badRequest
        case .invalidEmailOrPassword:
            .badRequest
        }
    }

    var reason: String {
        switch self {
        case .emailAlreadyExists:
            "A user with that email already exists"
        case .invalidEmailOrPassword:
            "The email or password is incorrect"
        }
    }

    var identifier: String {
        switch self {
        case .emailAlreadyExists:
            "email_already_exists"
        case .invalidEmailOrPassword:
            "incorrect_email_or_password"
        }
    }
}
