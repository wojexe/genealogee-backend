import Fluent
import Vapor

extension DatabaseTreeRepository {
    func using(_ db: Database) -> Self {
        var copy = self
        copy.db = db
        return copy
    }
}
