import SQLKit

/// A PostgreSQL-specific `SQLExpression` which expresses a `SET NOT NULL` or `DROP NOT NULL` clause, intended
/// for use in the `modifyColumns` array of an `SQLAlterTable`.
@usableFromInline
struct PostgreSQLAlterColumnNullability: SQLExpression {
    let column: any SQLExpression
    let makeNullable: Bool // N.B.: To make a column nullable, we want to _DROP_ an existing `NOT NULL` constraint.

    @usableFromInline
    init(column: any SQLExpression, makeNullable: Bool) {
        self.column = column
        self.makeNullable = makeNullable
    }

    @usableFromInline
    func serialize(to serializer: inout SQLSerializer) {
        serializer.statement {
            $0.append(self.column, self.makeNullable ? "DROP" : "SET", "NOT NULL")
        }
    }
}
