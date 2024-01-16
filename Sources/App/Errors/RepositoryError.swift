import Fluent
import Vapor

enum RepositoryError: AppError {
    case notFound(UUID, (any Model.Type)?)
}

extension RepositoryError: AbortError {
    var status: HTTPStatus {
        switch self {
        case .notFound(_, _):
            .notFound
        }
    }

    var reason: String {
        switch self {
            case let .notFound(id, model):
                if let model = model {
                    return "\(model)(\(id)) not found"
                } else {
                    return "Resource#\(id) not found"
                }
        }
    }

    var identifier: String {
        switch self {
        case .notFound(_, _):
            "resource_not_found"
        }
    }
}
