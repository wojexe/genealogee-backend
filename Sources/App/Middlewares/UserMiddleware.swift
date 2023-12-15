import Fluent

struct UserMiddleware: AsyncModelMiddleware {
    func create(model: User, on db: Database, next: AnyAsyncModelResponder) async throws {
        model.email = model.email.lowercased()

        try await next.create(model, on: db)
    }
}
