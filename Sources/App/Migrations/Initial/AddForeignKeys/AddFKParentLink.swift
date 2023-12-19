import Fluent
import SQLKit

struct AddFKParentLink: AddFKAsyncMigration {
    let MIGRATIONS = """
ALTER TABLE parent_links
    ADD CONSTRAINT fk_family_id
        FOREIGN KEY (family_id)
        REFERENCES families (id)
        ON DELETE CASCADE;

ALTER TABLE parent_links
    ADD CONSTRAINT fk_person_id
        FOREIGN KEY (person_id)
        REFERENCES people (id)
        ON DELETE CASCADE;
""".split(separator: "\n\n").map { String($0) }

    let REVERTS = """
ALTER TABLE parent_links
    DROP CONSTRAINT IF EXISTS fk_family_id;

ALTER TABLE parent_links
    DROP CONSTRAINT IF EXISTS fk_person_id;
""".split(separator: "\n\n").map { String($0) }
}
