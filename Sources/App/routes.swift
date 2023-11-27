import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get("ping") { req async in
        "pong"
    }
    
    try app.register(collection: AuthenticationController())
    
    let authenticated = app.grouped(User.guardMiddleware())
    
    try authenticated.register(collection: TreeController())
    try authenticated.register(collection: PersonController())
}
