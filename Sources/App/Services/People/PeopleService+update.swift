import Fluent
import Vapor

extension PeopleService {
    func update(_ personID: UUID, _ data: Person.DTO.Update) async throws -> Person {
        let person = try await req.people.get(personID)

        person.givenNames = data.givenNames ?? person.givenNames
        person.familyName = data.familyName ?? person.familyName
        person.birthName = data.birthName
        person.dateOf = data.dateOf ?? person.dateOf

        try await person.save(on: req.db)

        return person
    }
}
