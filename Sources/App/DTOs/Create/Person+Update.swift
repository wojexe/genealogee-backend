import Fluent
import Vapor

extension Person.DTO {
    final class Update: Content, Validatable {
        var treeID: UUID
        var givenNames: String?
        var familyName: String?
        var birthName: String?
        var dateOf: Dates?

        static func validations(_ val: inout Validations) {
            val.add("treeID", as: UUID.self, is: .valid, required: false)
            val.add("givenNames", as: String.self, is: .count(...128), required: false)
            val.add("familyName", as: String.self, is: .count(...128), required: false)
            val.add("birthName", as: String?.self, is: .nil || .count(...128), required: false)

            val.add("dateOf") { val in
                val.add("birth", as: Date?.self, is: .valid, required: false)
                val.add("birthCustom", as: String?.self, is: .nil || .count(...128), required: false)
                val.add("death", as: Date?.self, is: .valid, required: false)
                val.add("deathCustom", as: String?.self, is: .nil || .count(...128), required: false)
            }
        }
    }
}
