import Vapor

struct FamiliesService {
    let req: Request
}

extension Request {
    var familiesService: FamiliesService {
        .init(req: self)
    }
}
