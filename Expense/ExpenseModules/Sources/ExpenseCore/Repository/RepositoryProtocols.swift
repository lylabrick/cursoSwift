//
//  RepositoryProtocols.swift
//  ExpenseCore
//
//  Created by Lylabrick on 27/06/2026.
//

import Foundation

public protocol CategoryRepositoryProtocol {
    func fetchAll() throws -> [CategoryForExpense]
    func insert(_ category: CategoryForExpense) throws
    func delete(_ category: CategoryForExpense) throws
}

public protocol TransactionRepositoryProtocol {
    func fetchAll() throws -> [Transaction]
    func fetch(from startDate: Date, to endDate: Date) throws -> [Transaction]
    func insert(_ transaction: Transaction) throws
    func update(_ transaction: Transaction) throws
    func delete(_ transaction: Transaction) throws
}
