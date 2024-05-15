import SQLKit

extension SQLAlterTableBuilder {
    /// PostgreSQL-specific API for adding or removing nullability to/from a column.
    ///
    /// > Note: This can be implemented for MySQL as well, but as with autoincrement, it requires considerably
    /// > more convolution.
    ///
    /// - Parameters:
    ///   - column: The column whose nullability should change.
    ///   - isNullable: `true` if the column should become `NULL`, `false` if it should become `NOT NULL`
    @inlinable
    @discardableResult
    public func modifyNullability(of column: String, isNullable: Bool) -> Self {
        self.modifyNullability(of: SQLIdentifier(column), isNullable: isNullable)
    }

    @inlinable
    @discardableResult
    public func modifyNullability(of column: any SQLExpression, isNullable: Bool) -> Self {
        self.modifyColumn(PostgreSQLAlterColumnNullability(column: column, makeNullable: isNullable))
    }
}
