import Vapor
import Fluent

struct FamiliesService: RequestService {
    let req: Request
}

extension Request {
    var familiesService: FamiliesService {
        .init(req: self)
    }
}
