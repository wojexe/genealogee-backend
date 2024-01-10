import Fluent
import Vapor

extension FamiliesService {
    func addChildren(familyID: UUID, childIDs: [UUID]) async throws {
        let family = try await req.families.get(familyID)
        let children = try await req.people.get(childIDs)

        try await family.$children.attach(children, on: req.db)
    }
}
