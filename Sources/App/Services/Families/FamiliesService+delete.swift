import Fluent
import Vapor

extension FamiliesService {
    func delete(familyID _: UUID) async throws {
        try await req
            .families
            .scoped(by: .currentUser)
            .nuke()
    }
}
