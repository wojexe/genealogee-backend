import Vapor
import Fluent

struct PersonError: AppError {
    enum Value {
        case couldNotParse
        case couldNotInstantiate
        case couldNotSave
    }
    
    var value: Value
    var source: ErrorSource?
    
    var status: HTTPResponseStatus {
        switch value {
        case .couldNotParse:
            return .badRequest
        case .couldNotInstantiate:
            return .internalServerError
        case .couldNotSave:
            return .internalServerError
        }
    }
    
    var reason: String {
        switch value {
        case .couldNotParse:
            return "Could not parse provided Person"
        case .couldNotInstantiate:
            return "An error occured"
        case .couldNotSave:
            return "An error occured"
        }
    }
    
    var identifier: String {
        switch value {
        case .couldNotParse:
            return "could_not_parse"
        case .couldNotInstantiate:
            return "could_not_instantiate"
        case .couldNotSave:
            return "could_not_save"
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
        self.source = .init(
            file: file,
            function: function,
            line: line,
            column: column
        )
    }
}
