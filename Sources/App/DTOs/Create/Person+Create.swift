import Fluent
import Vapor

extension Person {
    convenience init(from createRequest: DTO.Create, creatorID: UUID) throws {
        self.init(creatorID: creatorID,
                  treeID: createRequest.treeID,
                  givenNames: createRequest.givenNames,
                  familyName: createRequest.familyName,
                  birthName: createRequest.birthName,
                  dateOf: createRequest.dateOf)
    }
}

extension Person.DTO {

    final class Create: Content, Validatable {
        var treeID: UUID
        var givenNames: String
        var familyName: String
        var birthName: String?
        var dateOf: Dates

        var childOf: UUID?
        var partnerOf: UUID?

        static func validations(_ val: inout Validations) {
            val.add("treeID", as: UUID.self, is: .valid)
            val.add("givenNames", as: String.self, is: .count(...128))
            val.add("familyName", as: String.self, is: .count(...128))
            val.add("birthName", as: String?.self, is: .nil || .count(...128), required: false)

            val.add("dateOf") { val in
                val.add("birth", as: Date?.self, is: .valid, required: false)
                val.add("birthCustom", as: String?.self, is: .nil || .count(...128), required: false)
                val.add("death", as: Date?.self, is: .valid, required: false)
                val.add("deathCustom", as: String?.self, is: .nil || .count(...128), required: false)
            }

            val.add("childOf", as: UUID?.self, required: false)
            val.add("partnerOf", as: UUID?.self, required: false)
        }
    }
}
