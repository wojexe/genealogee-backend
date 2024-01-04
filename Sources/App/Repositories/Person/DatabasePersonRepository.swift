import Fluent
import Vapor

struct DatabasePersonRepository: PersonRepository {
    let req: Request

    init(req: Request) {
        self.req = req
    }
}
