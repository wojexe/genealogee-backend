import Vapor

extension User.DTO {
    struct Send: Content {
        let id: UUID?
        let email: String
        let name: String
        let createdAt: Date?
        let updatedAt: Date?

        init(from user: User) {
            id = user.id
            email = user.email
            name = user.name
            createdAt = user.createdAt
            updatedAt = user.updatedAt
        }
    }
}
