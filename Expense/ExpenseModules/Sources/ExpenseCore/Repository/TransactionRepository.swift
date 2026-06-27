//
//  TransactionRepository.swift
//  Expense
//
//  Created by Lylabrick on 26/06/2026.
//

import SwiftData
import Foundation

public final class TransactionRepository: TransactionRepositoryProtocol {
    private let context: ModelContext

    public init(context: ModelContext) {
        self.context = context
    }

    public func fetchAll() throws -> [Transaction] {
        let descriptor = FetchDescriptor<Transaction>(sortBy: [SortDescriptor(\.date, order: .reverse)])
        return try context.fetch(descriptor)
    }

    public func fetch(from startDate: Date, to endDate: Date) throws -> [Transaction] {
        let predicate = #Predicate<Transaction> { transaction in
            transaction.date >= startDate && transaction.date <= endDate
        }
        let descriptor = FetchDescriptor<Transaction>(
            predicate: predicate,
            sortBy: [SortDescriptor(\.date, order: .reverse)]
        )
        return try context.fetch(descriptor)
    }

    public func insert(_ transaction: Transaction) throws {
        context.insert(transaction)
        try context.save()
    }

    public func update(_ transaction: Transaction) throws {
        try context.save()
    }

    public func delete(_ transaction: Transaction) throws {
        context.delete(transaction)
        try context.save()
    }
}
