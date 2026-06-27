//
//  Category.swift
//  Expense
//
//  Created by Lylabrick on 26/06/2026.
//

import SwiftData
import Foundation

@Model
public final class Category {
    public var id: UUID
    public var name: String
    public var colorHex: String
    public var icon: String

    @Relationship(deleteRule: .cascade, inverse: \Transaction.category)
    public var transactions: [Transaction]?

    public init(name: String, colorHex: String = "#3478F6", icon: String = "tag") {
        self.id = UUID()
        self.name = name
        self.colorHex = colorHex
        self.icon = icon
        self.transactions = []
    }
}
