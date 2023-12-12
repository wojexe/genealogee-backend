import Fluent
import Vapor

extension Person {
    convenience init(from createRequest: Create, creatorID: UUID) throws {
        self.init(creatorID: creatorID,
                  givenNames: createRequest.givenNames,
                  familyName: createRequest.familyName,
                  birthName: createRequest.birthName,
                  dateOf: createRequest.dateOf)
    }

    struct Create: Content {
        var givenNames: String
        var familyName: String
        var birthName: String?
        var dateOf: Dates
    }
}
