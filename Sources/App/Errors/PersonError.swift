import Fluent
import Vapor

struct PersonError: AppError {
    enum Value {
        case couldNotParse
        case treeNotFound
        case couldNotInstantiate
        case couldNotSave
    }

    var value: Value
    var source: ErrorSource?

    var status: HTTPResponseStatus {
        switch value {
        case .couldNotParse:
            .badRequest
        case .treeNotFound:
            .badRequest
        case .couldNotInstantiate:
            .internalServerError
        case .couldNotSave:
            .internalServerError
        }
    }

    var reason: String {
        switch value {
        case .couldNotParse:
            "Could not parse provided Person"
        case .treeNotFound:
            "Provided treeID was not found"
        case .couldNotInstantiate:
            "An error occured"
        case .couldNotSave:
            "An error occured"
        }
    }

    var identifier: String {
        switch value {
        case .couldNotParse:
            "could_not_parse"
        case .treeNotFound:
            "tree_not_found"
        case .couldNotInstantiate:
            "could_not_instantiate"
        case .couldNotSave:
            "could_not_save"
        }
    }

    init(
        _ value: Value,
        file: String = #file,
        function: String = #function,
        line: UInt = #line,
        column: UInt = #column
    ) {
        self.value = value
        source = .init(
            file: file,
            function: function,
            line: line,
            column: column
        )
    }
}
