import Fluent
import Vapor

struct DatabaseTreeSnapshotRepository: TreeSnapshotRepository {
    let req: Request

    init(req: Request) {
        self.req = req
    }
}
