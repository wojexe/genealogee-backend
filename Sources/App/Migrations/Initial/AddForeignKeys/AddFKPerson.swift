import Fluent
import FluentSQL

struct AddFKPerson: AddFKAsyncMigration {
    let MIGRATIONS = """
ALTER TABLE people
    ADD CONSTRAINT fk_creator_id
        FOREIGN KEY (creator_id)
        REFERENCES users (id)
        ON DELETE CASCADE;

ALTER TABLE people
    ADD CONSTRAINT fk_tree_id
        FOREIGN KEY (tree_id)
        REFERENCES trees (id)
        ON DELETE CASCADE;
""".split(separator: "\n\n").map { String($0) }

    let REVERTS = """
ALTER TABLE people
    DROP CONSTRAINT IF EXISTS fk_creator_id;

ALTER TABLE people
    DROP CONSTRAINT IF EXISTS fk_tree_id;
""".split(separator: "\n\n").map { String($0) }
}
