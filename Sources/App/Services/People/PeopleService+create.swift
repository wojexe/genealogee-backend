import Fluent
import Vapor

extension PeopleService {
    func create(from data: Person.DTO.Create, on db: Database? = nil) async throws -> Person {
        let user = try req.auth.require(User.self)
        let db = db ?? req.db

        guard let tree = try? await req.trees.get(id: data.treeID) else {
            throw PersonError(.treeNotFound)
        }

        guard tree.rootFamilyID != nil else {
            return try await db.transaction { db in
                let firstFamily = try await req.familiesService.create(treeID: data.treeID, on: db)
                let person = try Person(from: data, creatorID: user.requireID(), familyID: firstFamily.requireID())
                tree.rootFamilyID = try firstFamily.requireID()

                try await person.save(on: db)
                try await tree.save(on: db)

                return person
            }
        }

        guard (data.childOf != nil && data.partnerOf == nil)
            || (data.childOf == nil && data.partnerOf != nil)
        else {
            throw Abort(.badRequest, reason: "Both partnerOf and childOf specified")
        }

        return try await db.transaction { db in
            let personRepository = getPersonRepository(db)

            if data.childOf != nil {
                guard let parent = try await personRepository.byID(data.childOf!)
                    .filter(\.$tree.$id == data.treeID)
                    .with(\.$family)
                    .first()
                else {
                    throw Abort(.badRequest, reason: "Parent not found in the specified tree")
                }

                let childFamily = try await req.familiesService.create(treeID: data.treeID, on: db)

                let person = try Person(from: data,
                                        creatorID: user.requireID(),
                                        familyID: childFamily.requireID(),
                                        parentFamilyID: parent.family.requireID())
                try await person.save(on: db)

                return person
            }
            // data.partnerOf != nil
            else {
                guard let partner = try await personRepository.byID(data.partnerOf!)
                    .filter(\.$tree.$id == data.treeID)
                    .with(\.$family)
                    .first()
                else {
                    throw Abort(.badRequest, reason: "Partner not found in the specified tree")
                }

                let person = try Person(from: data,
                                        creatorID: user.requireID(),
                                        familyID: partner.family.requireID())
                try await person.save(on: db)

                return person
            }
        }
    }
}
