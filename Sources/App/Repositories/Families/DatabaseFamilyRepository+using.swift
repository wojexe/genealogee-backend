import Fluent
import Vapor

extension DatabaseFamilyRepository {
    func using(_ db: Database) -> Self {
        var copy = self
        copy.db = db
        return copy
    }
}
