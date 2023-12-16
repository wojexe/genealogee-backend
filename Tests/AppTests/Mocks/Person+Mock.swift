import Fakery
import Fluent
import Vapor

extension App.Person {
    public static func mock(creatorID: UUID,
                            treeID: UUID,
                            withDates: Bool = false) async throws -> Person
    {
        let faker = Faker()

        let person = Person(
            id: UUID.generateRandom(),
            creatorID: creatorID,
            treeID: treeID,
            givenNames: faker.name.firstName() + faker.name.firstName(),
            familyName: faker.name.lastName(),
            birthName: Bool.random() ? faker.name.lastName() : nil,
            dateOf: withDates ? Dates.mock() : Dates()
        )

        return person
    }

    public static func mockSaved(creatorID: UUID,
                                 treeID: UUID,
                                 withDates: Bool? = false,
                                 on db: Database) async throws -> Person
    {
        let person = try await mock(creatorID: creatorID,
                                    treeID: treeID,
                                    withDates: withDates ?? false)

        try await person.save(on: db)

        return person
    }
}

extension App.Dates: Mockable {
    public static func mock() -> Dates {
        let faker = Faker()

        let birthCustom = Bool.random()
        let deathCustom = Bool.random()

        let birthDate = faker.date.birthday(0, 50)
        let deathDate = faker.date.birthday(50, 100)

        return Dates(birth: birthCustom ? nil : birthDate,
                     birthCustom: birthCustom ? birthDate.ISO8601Format() : nil,
                     death: deathCustom ? nil : deathDate,
                     deathCustom: deathCustom ? deathDate.ISO8601Format() : nil)
    }
}
