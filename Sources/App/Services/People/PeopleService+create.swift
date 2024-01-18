import Fluent
import Vapor

extension PeopleService {
    func create(from data: Person.DTO.Create, on db: Database? = nil) async throws -> Person {
        let user = try req.auth.require(User.self)

        guard let person = try? Person(from: data, creatorID: user.requireID()) else {
            throw PersonError(.couldNotParse)
        }

        guard let tree = try? await person.$tree.get(on: req.db) else {
            throw PersonError(.treeNotFound)
        }

        try await req.db.transaction { db in
            try await person.save(on: db)

            if try await tree.$families.get(on: db).isEmpty {
                if data.childOf != nil {
                    req.logger.warning("Ommiting childOf parameter when creating a person - first person in a tree ")
                }

                if data.partnerOf != nil {
                    req.logger.warning("Ommiting partnerOf parameter when creating a person - first person in a tree ")
                }

                let family = try await req
                    .familiesService
                    .create(treeID: tree.requireID(), parents: [person.requireID()], on: db)

                tree.rootFamilyID = try family.requireID()

                try await tree.update(on: db)
            } else {
                if data.childOf == nil, data.partnerOf == nil {
                    throw Abort(.badRequest, reason: "Person has either to be a child or a partner of someone")
                }

                if data.childOf != nil, data.partnerOf != nil {
                    throw Abort(.badRequest, reason: "Cannot set a person to be both a child and a partner at a one time")
                }

                if let parentID = data.childOf {
                    try await req
                        .peopleService
                        .addChild(personID: parentID, childID: person.requireID(), on: db)
                }

                if let partnerID = data.partnerOf {
                    try await req
                        .peopleService
                        .addPartner(personID: partnerID, partnerID: person.requireID(), on: db)
                }
            }
        }

        return person
    }
}
