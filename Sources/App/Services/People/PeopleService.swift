import Vapor

struct PeopleService: RequestService {
    let req: Request
}

extension Request {
    var peopleService: PeopleService {
        .init(req: self)
    }
}
