extension PeopleService {
    func createPerson(from data: Person.Create) async throws -> Person.Created {
        let user = try req.auth.require(User.self)
        let userID = try user.requireID()

        guard let person = try? Person(from: data, creatorID: userID) else {
            throw PersonError(.couldNotParse)
        }

        let tree: Tree

        do {
            tree = try await person.$tree.get(on: req.db)
        } catch {
            throw PersonError(.treeNotFound)
        }

        let treeID = try tree.requireID()

        try await req.db.transaction { db in
            try await person.save(on: db)
            let personID = try person.requireID()

            if try await tree.$families.get(on: db).isEmpty {
                let family = Family(treeID: treeID)
                try await family.save(on: db)

                let familyID = try family.requireID()

                tree.rootFamilyID = familyID
                try await tree.update(on: db)

                let parentLink = ParentLink(familyID: familyID, personID: personID)
                try await parentLink.save(on: db)
            }
        }

        // TODO: do i really want this?
        if let parentID = data.childOf {
            try await req.peopleService.addChild(personID: parentID, childID: person.requireID())
        }

        if let partnerID = data.partnerOf {
            try await req.peopleService.addPartner(personID: person.requireID(), partnerID: partnerID)
        }

        return try await Person.Created(person, req.db)
    }
}
