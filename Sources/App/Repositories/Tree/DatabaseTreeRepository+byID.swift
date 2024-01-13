import Fluent
import Vapor

extension DatabaseTreeRepository {
    func byID(_ id: UUID) throws -> QueryBuilder<Tree> {
        try scoped(by: .currentUser).filter(\.$id == id)
    }
}
