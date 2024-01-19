import Vapor

struct TreesService: RequestService {
    let req: Request
}

extension Request {
    var treesService: TreesService {
        .init(req: self)
    }
}
