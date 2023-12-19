import Fluent
import SQLKit

struct AddFKFamily: AddFKAsyncMigration {
    let MIGRATIONS = ["""
ALTER TABLE families
    ADD CONSTRAINT fk_tree_id
        FOREIGN KEY (tree_id)
        REFERENCES trees (id)
        ON DELETE CASCADE;
"""]

    let REVERTS = ["""
ALTER TABLE people
    DROP CONSTRAINT IF EXISTS fk_tree_id;
"""]
}
