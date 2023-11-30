import Vapor
import Fluent

extension Person {
    convenience init(from createRequest: Create, creatorID: UUID) throws {
        self.init(creatorID: creatorID,
                  givenNames: createRequest.givenNames,
                  familyName: createRequest.familyName,
                  birthName: createRequest.birthName,
                  date_of: createRequest.date_of)
    }
    
    struct Create: Content {
        var givenNames: String
        var familyName: String
        var birthName: String?
        var date_of: Dates
    }
}
