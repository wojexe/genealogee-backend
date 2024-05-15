import Fluent
import Vapor

enum Backfill {
    struct TreeCreatedAt {
        let db: Database

        init(_ db: Database) {
            self.db = db
        }

        func select() -> QueryBuilder<Tree> {
            Tree
                .query(on: db)
                .filter(\.$createdAt == nil)
                .join(User.self, on: \Tree.$creator.$id == \User.$id)
                .field(Tree.self, \.$id)
                .field(User.self, \.$createdAt)
        }

        func perform() async throws {
            db.logger.info("START Backfill.TreeCreatedAt#perform")

            let trees = try await select().all()

            for tree in trees {
                let creator = try tree.joined(User.self)
                tree.createdAt = creator.createdAt ?? Date.now
                try await tree.save(on: db)
            }

            db.logger.info("END Backfill.TreeCreatedAt#perform")
        }

        func selectRevert() -> QueryBuilder<Tree> {
            Tree
                .query(on: db)
        }

        func revert() async throws {
            db.logger.info("START Backfill.TreeCreatedAt#revert")

            let trees = try await selectRevert().all()

            for tree in trees {
                tree.createdAt = nil
                try await tree.save(on: db)
            }

            db.logger.info("END Backfill.TreeCreatedAt#revert")
        }
    }
}
