import Fluent
import Vapor

struct DatabaseFamilyRepository: FamilyRepository {
    let req: Request

    init(req: Request) {
        self.req = req
    }
}
