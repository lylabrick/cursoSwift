//
//  CategoryRepository.swift
//  ExpenseCore
//
//  Created by Lylabrick on 27/06/2026.
//

import SwiftData
import Foundation

public final class CategoryRepository: CategoryRepositoryProtocol {
    private let context: ModelContext

    public init(context: ModelContext) {
        self.context = context
    }

    public func fetchAll() throws -> [CategoryForExpense] {
        let descriptor = FetchDescriptor<CategoryForExpense>(sortBy: [SortDescriptor(\.name)])
        return try context.fetch(descriptor)
    }

    public func insert(_ category: CategoryForExpense) throws {
        context.insert(category)
        try context.save()
    }

    public func delete(_ category: CategoryForExpense) throws {
        context.delete(category)
        try context.save()
    }
}
