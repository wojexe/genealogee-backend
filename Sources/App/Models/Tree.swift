import Fluent
import Vapor

final class Tree: Model, Content {
    static let schema = "trees"
    
    @ID
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    
    @OptionalChild(for: \.$tree)
    var rootFamily: Family?
}
