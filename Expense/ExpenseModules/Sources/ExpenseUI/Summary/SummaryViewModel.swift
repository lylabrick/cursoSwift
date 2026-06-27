//
//  SummaryViewModel.swift
//  Expense
//
//  Created by Lylabrick on 26/06/2026.
//

import Foundation
import ExpenseCore

public enum PeriodFilter: String, CaseIterable, Identifiable {
    case week = "Semana"
    case month = "Mes"
    case year = "Año"
    case all = "Todo"

    public var id: String { rawValue }

    public func dateRange(from now: Date = .now) -> ClosedRange<Date>? {
        let calendar = Calendar.current
        switch self {
        case .week:
            guard let start = calendar.date(byAdding: .day, value: -7, to: now) else { return nil }
            return start...now
        case .month:
            guard let start = calendar.date(byAdding: .month, value: -1, to: now) else { return nil }
            return start...now
        case .year:
            guard let start = calendar.date(byAdding: .year, value: -1, to: now) else { return nil }
            return start...now
        case .all:
            return nil
        }
    }
}

public struct CategoryTotal: Identifiable {
    public var id: String { categoryName }
    public let categoryName: String
    public let total: Decimal
    public let colorHex: String
}

@MainActor
public final class SummaryViewModel: ObservableObject {
    @Published public var selectedPeriod: PeriodFilter = .month
    @Published public var totalIncome: Decimal = 0
    @Published public var totalExpense: Decimal = 0
    @Published public var categoryTotals: [CategoryTotal] = []

    private let transactionRepository: TransactionRepositoryProtocol

    public init(transactionRepository: TransactionRepositoryProtocol) {
        self.transactionRepository = transactionRepository
    }

    public func reload() {
        do {
            let transactions: [Transaction]
            if let range = selectedPeriod.dateRange() {
                transactions = try transactionRepository.fetch(from: range.lowerBound, to: range.upperBound)
            } else {
                transactions = try transactionRepository.fetchAll()
            }

            totalIncome = transactions
                .filter { $0.type == .income }
                .reduce(0) { $0 + $1.amount }

            totalExpense = transactions
                .filter { $0.type == .expense }
                .reduce(0) { $0 + $1.amount }

            var grouped: [String: (total: Decimal, color: String)] = [:]
            for transaction in transactions where transaction.type == .expense {
                let name = transaction.category?.name ?? "Sin categoría"
                let color = transaction.category?.colorHex ?? "#999999"
                let current = grouped[name]?.total ?? 0
                grouped[name] = (current + transaction.amount, color)
            }

            categoryTotals = grouped.map { CategoryTotal(categoryName: $0.key, total: $0.value.total, colorHex: $0.value.color) }
                .sorted { $0.total > $1.total }
        } catch {
            print("Error cargando resumen: \(error)")
        }
    }
}
