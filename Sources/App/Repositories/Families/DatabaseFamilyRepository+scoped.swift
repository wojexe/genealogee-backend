import Fluent
import Vapor

extension DatabaseFamilyRepository {
    func scoped(by scope: FamilyRepositoryScope) throws -> QueryBuilder<Family> {
        let query = Family.query(on: req.db)

        switch scope {
        case .currentUser:
            return try scopedByCurrentUser(query)
        case let .user(ID):
            return query.filter(\.$creator.$id == ID)
        case .none:
            return query
        }
    }

    private func scopedByCurrentUser(_ query: QueryBuilder<Family>) throws -> QueryBuilder<Family> {
        let user = try req.auth.require(User.self)
        let userID = try user.requireID()

        return query.filter(\.$creator.$id == userID)
    }
}
