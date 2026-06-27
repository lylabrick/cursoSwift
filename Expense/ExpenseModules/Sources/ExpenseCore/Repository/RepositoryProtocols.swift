//
//  RepositoryProtocols.swift
//  Expense
//
//  Created by Lylabrick on 26/06/2026.
//

import Foundation

public protocol CategoryRepositoryProtocol {
    func fetchAll() throws -> [Category]
    func insert(_ category: Category) throws
    func delete(_ category: Category) throws
}

public protocol TransactionRepositoryProtocol {
    func fetchAll() throws -> [Transaction]
    func fetch(from startDate: Date, to endDate: Date) throws -> [Transaction]
    func insert(_ transaction: Transaction) throws
    func update(_ transaction: Transaction) throws
    func delete(_ transaction: Transaction) throws
}
