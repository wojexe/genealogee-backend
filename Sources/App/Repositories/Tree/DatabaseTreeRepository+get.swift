import Fluent
import Vapor

extension DatabaseTreeRepository {
    func get(id: UUID, entire recursive: Bool = false) async throws -> Tree {
        let query = try scoped(by: .currentUser)
            .filter(\.$id == id)
            .with(\.$creator)
            .with(\.$families)

        if recursive {
            query.with(\.$people) { loadPerson($0) }
        } else {
            query.with(\.$people)
        }

        guard let result = try await query.first() else {
            throw Abort(.notFound, reason: "No such tree exists")
        }

        return result
    }

    private func loadPerson(_ person: NestedEagerLoadBuilder<QueryBuilder<Tree>, ChildrenProperty<Tree, Person>>) {
        person
            .with(\.$family)
            .with(\.$parentFamily)
    }
}
