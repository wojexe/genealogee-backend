import Vapor

struct TreeService: RequestService {
    let req: Request
}

extension Request {
    var treeService: TreeService {
        .init(req: self)
    }
}
