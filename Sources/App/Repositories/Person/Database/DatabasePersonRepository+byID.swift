import Fluent
import Vapor

extension DatabasePersonRepository {
    func byID(_ id: UUID) throws -> QueryBuilder<Person> {
        try scoped(by: .currentUser).filter(\.$id == id)
    }

    func byIDs(_ ids: [UUID]) throws -> QueryBuilder<Person> {
        try scoped(by: .currentUser).filter(\.$id ~~ ids)
    }
}
