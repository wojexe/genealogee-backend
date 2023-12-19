import Fluent
import Vapor

struct DatabaseTreeRepository: TreeRepository {
    let req: Request

    init(req: Request) {
        self.req = req
    }
}
