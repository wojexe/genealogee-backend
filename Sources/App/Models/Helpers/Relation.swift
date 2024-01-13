import Vapor

enum Relation {
    case child(UUID)
    case partner(UUID)
}
