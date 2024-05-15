import SQLKit

public extension SQLExpression {
    @inlinable
    static func identifier(_ identifier: String) -> Self where Self == SQLIdentifier {
        .init(identifier)
    }

    @inlinable
    static func column(_ name: String, table: String? = nil) -> Self where Self == SQLColumn {
        .init(name, table: table)
    }

    @inlinable
    static func function(_ name: String, _ args: any SQLExpression...) -> Self where Self == SQLFunction {
        function(name, args)
    }

    @inlinable
    static func function(_ name: String, _ args: [any SQLExpression]) -> Self where Self == SQLFunction {
        SQLFunction(name, args: args)
    }

    @inlinable
    static func count(_ column: String, table: String? = nil) -> Self where Self == SQLFunction {
        count(.column(column, table: table))
    }

    @inlinable
    static func count(_ expr: any SQLExpression) -> Self where Self == SQLFunction {
        function("count", expr)
    }

    @inlinable
    static func sum(_ column: String, table: String? = nil) -> Self where Self == SQLFunction {
        sum(.column(column, table: table))
    }

    @inlinable
    static func sum(_ expr: any SQLExpression) -> Self where Self == SQLFunction {
        function("sum", expr)
    }

    @inlinable
    static func coalesce(_ exprs: any SQLExpression...) -> Self where Self == SQLFunction {
        function("coalesce", exprs)
    }
}
