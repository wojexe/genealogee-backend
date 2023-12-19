import Fluent
import SQLKit

struct AddFKTree: AddFKAsyncMigration {
    let MIGRATIONS = """
ALTER TABLE ONLY trees
    ADD CONSTRAINT fk_creator_id
        FOREIGN KEY (creator_id)
        REFERENCES users (id)
        ON DELETE CASCADE;

ALTER TABLE trees
    ADD CONSTRAINT fk_root_family_id
        FOREIGN KEY (root_family_id)
        REFERENCES families (id)
        ON DELETE SET NULL;
""".split(separator: "\n\n").map { String($0) }

    let REVERTS = """
ALTER TABLE trees
    DROP CONSTRAINT IF EXISTS fk_creator_id;

ALTER TABLE trees
    DROP CONSTRAINT IF EXISTS fk_root_family_id;
""".split(separator: "\n\n").map { String($0) }
}
