import Fluent
import Vapor

extension PeopleService {
    @discardableResult
    func addChild(personID: UUID, childID: UUID) async throws -> Family.DTO.Send {
        let person = try await req.people.get(personID)
        var family = try await person.$family.get(on: req.db).first

        if family == nil {
            let treeID = try await person.$tree.get(on: req.db).requireID()

            family = try await req.familiesService.createFamily(treeID: treeID, parents: [personID], children: [childID])
        } else {
            try await req.familiesService.addChild(familyID: try family!.requireID(), childID: childID)
        }

        return try await Family.DTO.Send(family!, on: req.db)
    }
}
