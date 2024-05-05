import Fluent
import Vapor

extension Tree.DTO {
    struct SendAll: Content {
        let trees: [Tree.DTO.Send]

        init(_ treeModels: [Tree], on db: Database) async throws {
            var DTOs: Array<Tree.DTO.Send> = []
            DTOs.reserveCapacity(treeModels.count)

            for tree in treeModels {
                try await DTOs.append(Tree.DTO.Send(tree, on: db))
            }

            trees = DTOs
        }
    }
}
