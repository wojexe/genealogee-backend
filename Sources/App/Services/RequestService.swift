import Vapor
import Fluent

protocol RequestService {
    var req: Request { get }
}

extension RequestService {
    func getPersonRepository(_ db: Database) -> PersonRepository {
        if let people = req.people as? DatabasePersonRepository {
            people.using(db)
        } else {
            req.people
        }
    }

    func getFamilyRepository(_ db: Database) -> FamilyRepository {
        if let families = req.families as? DatabaseFamilyRepository {
            families.using(db)
        } else {
            req.families
        }
    }

    func getTreeRepository(_ db: Database) -> TreeRepository {
        if let trees = req.trees as? DatabaseTreeRepository {
            trees.using(db)
        } else {
            req.trees
        }
    }
}
