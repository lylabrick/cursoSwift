//
//  DependencyContainer.swift
//  ExpenseCore
//
//  Created by Lylabrick on 27/06/2026.
//


import SwiftData
import Foundation

public final class DependencyContainer {
    public let modelContainer: ModelContainer
    public let categoryRepository: CategoryRepositoryProtocol
    public let transactionRepository: TransactionRepositoryProtocol

    public init(inMemory: Bool = false) {
        let schema = Schema([CategoryForExpense.self, Transaction.self])
        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: inMemory)

        guard let container = try? ModelContainer(for: schema, configurations: [configuration]) else {
            fatalError("No se pudo crear el ModelContainer")
        }

        self.modelContainer = container
        let context = ModelContext(container)
        self.categoryRepository = CategoryRepository(context: context)
        self.transactionRepository = TransactionRepository(context: context)
        
        if let url = container.configurations.first?.url {
            print("📦 SwiftData store en: \(url.path)")
        }
    }

    public init(modelContainer: ModelContainer,
                categoryRepository: CategoryRepositoryProtocol,
                transactionRepository: TransactionRepositoryProtocol) {
        self.modelContainer = modelContainer
        self.categoryRepository = categoryRepository
        self.transactionRepository = transactionRepository
    }
}
