//
//  CategoryRepository.swift
//  Expense
//
//  Created by Lylabrick on 26/06/2026.
//

import SwiftData
import Foundation

public final class CategoryRepository: CategoryRepositoryProtocol {
    private let context: ModelContext

    public init(context: ModelContext) {
        self.context = context
    }

    public func fetchAll() throws -> [Category] {
        let descriptor = FetchDescriptor<Category>(sortBy: [SortDescriptor(\.name)])
        return try context.fetch(descriptor)
    }

    public func insert(_ category: Category) throws {
        context.insert(category)
        try context.save()
    }

    public func delete(_ category: Category) throws {
        context.delete(category)
        try context.save()
    }
}
