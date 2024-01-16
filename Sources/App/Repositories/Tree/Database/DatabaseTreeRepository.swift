import Fluent
import Vapor

struct DatabaseTreeRepository: TreeRepository {
    let req: Request
    var db: Database

    init(req: Request, db: Database? = nil) {
        self.req = req
        self.db = db ?? req.db
    }
}
