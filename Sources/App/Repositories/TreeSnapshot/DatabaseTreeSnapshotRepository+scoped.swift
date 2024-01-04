import Fluent
import Vapor

extension DatabaseTreeSnapshotRepository {
    func scoped(by scope: TreeSnapshotRepositoryScope) throws -> QueryBuilder<TreeSnapshot> {
        let query = TreeSnapshot.query(on: req.db)

        return switch scope {
        case .currentUser:
            try scopedByCurrentUser(query)
        case let .user(ID):
            query.filter(\.$creator.$id == ID)
        case .none:
            query
        }
    }

    private func scopedByCurrentUser(_ query: QueryBuilder<TreeSnapshot>) throws -> QueryBuilder<TreeSnapshot> {
        let user = try req.auth.require(User.self)
        let userID = try user.requireID()

        return query.filter(\.$creator.$id == userID)
    }
}
