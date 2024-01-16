import Fluent
import Vapor

extension DatabaseFamilyRepository {
    func byID(_ id: UUID) throws -> QueryBuilder<Family> {
        try scoped(by: .currentUser).filter(\.$id == id)
    }
}
