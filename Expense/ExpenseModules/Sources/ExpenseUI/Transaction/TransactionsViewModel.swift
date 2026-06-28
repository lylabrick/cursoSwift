//
//  TransactionsViewModel.swift
//  ExpenseCore
//
//  Created by Lylabrick on 27/06/2026.
//

import Foundation
import ExpenseCore

@MainActor
public final class TransactionsViewModel: ObservableObject {
    @Published public var transactions: [Transaction] = []
    @Published public var categories: [CategoryForExpense] = []

    private let transactionRepository: TransactionRepositoryProtocol
    private let categoryRepository: CategoryRepositoryProtocol
    private let exporter = CSVExporter()

    public init(transactionRepository: TransactionRepositoryProtocol, categoryRepository: CategoryRepositoryProtocol) {
        self.transactionRepository = transactionRepository
        self.categoryRepository = categoryRepository
    }

    public func loadAll() {
        do {
            transactions = try transactionRepository.fetchAll()
            categories = try categoryRepository.fetchAll()
        } catch {
            print("Error cargando datos: \(error)")
        }
    }

    public func addTransaction(amount: Decimal, note: String, date: Date, type: TransactionType, category: CategoryForExpense?) {
        let transaction = Transaction(amount: amount, note: note, date: date, type: type, category: category)
        do {
            try transactionRepository.insert(transaction)
            loadAll()
        } catch {
            print("Error guardando transacción: \(error)")
        }
    }

    public func delete(_ transaction: Transaction) {
        do {
            try transactionRepository.delete(transaction)
            loadAll()
        } catch {
            print("Error eliminando: \(error)")
        }
    }

    public func addCategory(name: String, colorHex: String, icon: String) {
        let category = CategoryForExpense(name: name, colorHex: colorHex, icon: icon)
        do {
            try categoryRepository.insert(category)
            loadAll()
        } catch {
            print("Error guardando categoría: \(error)")
        }
    }

    public func exportCSV() -> URL? {
        let csv = exporter.export(transactions: transactions)
        return try? exporter.writeToTempFile(csv: csv)
    }
}
