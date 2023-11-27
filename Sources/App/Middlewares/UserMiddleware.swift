import Fluent

struct UserMiddleware: ModelMiddleware {
    func create(model: User, on db: Database, next: AnyModelResponder) -> EventLoopFuture<Void> {
        model.email = model.email.lowercased()
        
        return next.create(model, on: db)
    }
}
