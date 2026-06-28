//
//  PreviewMocks.swift
//  ExpenseCore
//
//  Created by Lylabrick on 28/06/2026.
//

import Foundation
import ExpenseCore

#if DEBUG
final class PreviewMockTransactionRepository: TransactionRepositoryProtocol {
    func fetchAll() throws -> [Transaction] {
        [
            Transaction(amount: 1500, note: "Supermercado", date: .now, type: .expense),
            Transaction(amount: 50000, note: "Sueldo", date: .now, type: .income),
            Transaction(amount: 800, note: "Café", date: .now, type: .expense)
        ]
    }

    func fetch(from startDate: Date, to endDate: Date) throws -> [Transaction] {
        try fetchAll()
    }

    func insert(_ transaction: Transaction) throws {}
    func update(_ transaction: Transaction) throws {}
    func delete(_ transaction: Transaction) throws {}
}

final class PreviewMockCategoryRepository: CategoryRepositoryProtocol {
    func fetchAll() throws -> [CategoryForExpense] {
        [
            CategoryForExpense(name: "Comida", colorHex: "#FF6B6B"),
            CategoryForExpense(name: "Transporte", colorHex: "#4ECDC4")
        ]
    }

    func insert(_ category: CategoryForExpense) throws {}
    func delete(_ category: CategoryForExpense) throws {}
}
#endif
