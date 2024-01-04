import Fluent
import Vapor

extension FamiliesService {
    func delete(familyID: UUID) async throws {
        try await req
            .families
            .get(familyID)
            .nuke(on: req.db)
    }
}
