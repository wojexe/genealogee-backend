import Fluent
import Vapor

extension Tree.DTO {
    struct SendAll: Content {
        let trees: [Tree.DTO.Send]

        init(_ treeModels: [Tree], on db: Database) async throws {
            var DTOs: [Tree.DTO.Send] = []
            DTOs.reserveCapacity(treeModels.count)

            for tree in treeModels {
                try await DTOs.append(Tree.DTO.Send(tree, on: db))
            }

            DTOs.sort(by: { a, b in
                // created_at == nil should land at the end
                if a.created_at == nil { return true }
                if b.created_at == nil { return true }

                return a.created_at!.compare(b.created_at!) == .orderedAscending
            })

            trees = DTOs
        }
    }
}
