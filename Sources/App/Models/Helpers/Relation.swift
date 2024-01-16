import Vapor

enum Relation {
    case child(UUID)
    case partner(UUID)
}

enum RelationMultiple {
    case children([UUID])
    case parents([UUID])
}
