import Fluent
import Vapor

extension DatabasePersonRepository {
    func scoped(by scope: PersonRepositoryScope) throws -> QueryBuilder<Person> {
        let query = Person.query(on: req.db)

        return switch scope {
        case .currentUser:
            try scopedByCurrentUser(query)
        case let .user(ID):
            query.filter(\.$creator.$id == ID)
        case .none:
            query
        }
    }

    private func scopedByCurrentUser(_ query: QueryBuilder<Person>) throws -> QueryBuilder<Person> {
        let user = try req.auth.require(User.self)
        let userID = try user.requireID()

        return query.filter(\.$creator.$id == userID)
    }
}
