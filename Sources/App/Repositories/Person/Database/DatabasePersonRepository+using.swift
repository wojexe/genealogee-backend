import Fluent
import Vapor

extension DatabasePersonRepository {
    func using(_ db: Database) -> Self {
        var copy = self
        copy.db = db
        return copy
    }
}
