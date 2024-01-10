import Fluent
import Vapor

extension FamiliesService {
    func addParents(familyID: UUID, parentIDs: [UUID]) async throws {
        let family = try await req.families.get(familyID)
        let parents = try await req.people.get(parentIDs)

        try await family.$parents.attach(parents, on: req.db)
    }
}
