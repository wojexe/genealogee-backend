import Vapor

struct TreeService {
    let req: Request
}

extension Request {
    var treeService: TreeService {
        .init(req: self)
    }
}
