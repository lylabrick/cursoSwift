//
//  Transaction.swift
//  ExpenseCore
//
//  Created by Lylabrick on 27/06/2026.
//

import SwiftData
import Foundation

public enum TransactionType: String, Codable, CaseIterable {
    case expense
    case income
}

@Model
public final class Transaction {
    public var id: UUID
    public var amount: Decimal
    public var note: String
    public var date: Date
    public var type: TransactionType

    public var category: CategoryForExpense?

    public init(amount: Decimal, note: String, date: Date = .now, type: TransactionType = .expense, category: CategoryForExpense? = nil) {
        self.id = UUID()
        self.amount = amount
        self.note = note
        self.date = date
        self.type = type
        self.category = category
    }
}
