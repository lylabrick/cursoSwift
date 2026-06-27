//
//  DependencyContainer.swift
//  Expense
//
//  Created by Lylabrick on 26/06/2026.
//

import SwiftData
import Foundation

public final class DependencyContainer {
    public let modelContainer: ModelContainer
    public let categoryRepository: CategoryRepositoryProtocol
    public let transactionRepository: TransactionRepositoryProtocol

    public init(inMemory: Bool = false) {
        let schema = Schema([Category.self, Transaction.self])
        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: inMemory)

        guard let container = try? ModelContainer(for: schema, configurations: [configuration]) else {
            fatalError("No se pudo crear el ModelContainer")
        }

        self.modelContainer = container
        let context = ModelContext(container)
        self.categoryRepository = CategoryRepository(context: context)
        self.transactionRepository = TransactionRepository(context: context)
    }

    // Inyección manual para tests: permite pasar repos mock
    public init(modelContainer: ModelContainer,
                categoryRepository: CategoryRepositoryProtocol,
                transactionRepository: TransactionRepositoryProtocol) {
        self.modelContainer = modelContainer
        self.categoryRepository = categoryRepository
        self.transactionRepository = transactionRepository
    }
}
