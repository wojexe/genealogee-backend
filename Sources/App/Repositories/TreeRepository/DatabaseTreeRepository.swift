import Fluent
import Vapor

struct DatabaseTreeRepository: TreeRepository {
    let req: Request

    init(req: Request) {
        self.req = req
    }

    func scoped(by scope: TreeRepositoryScope = .currentUser) throws -> QueryBuilder<Tree> {
        let query = Tree.query(on: req.db)

        return switch scope {
        case .currentUser:
            try scopedByCurrentUser(query)
        case let .user(ID):
            query.filter(\.$creator.$id == ID)
        case .none:
            query
        }
    }

    private func scopedByCurrentUser(_ query: QueryBuilder<Tree>) throws -> QueryBuilder<Tree> {
        let user = try req.auth.require(User.self)
        let userID = try user.requireID()

        return query.filter(\.$creator.$id == userID)
    }
}
