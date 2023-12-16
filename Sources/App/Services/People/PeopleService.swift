import Vapor

struct PeopleService {
    let req: Request
}

extension Request {
    var peopleService: PeopleService {
        .init(req: self)
    }
}
