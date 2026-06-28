//
//  ExpenseApp.swift
//  Expense
//
//  Created by Lylabrick on 27/06/2026.
//

import SwiftUI
import ExpenseCore
import ExpenseUI

@main
struct ExpenseApp: App {
    let container = DependencyContainer()

    var body: some Scene {
        WindowGroup {
            TabView {
                SummaryView(viewModel: SummaryViewModel(transactionRepository: container.transactionRepository))
                    .tabItem { Label("Resumen", systemImage: "chart.pie") }

                TransactionListView(viewModel: TransactionsViewModel(
                    transactionRepository: container.transactionRepository,
                    categoryRepository: container.categoryRepository
                ))
                .tabItem { Label("Transacciones", systemImage: "list.bullet") }
            }
        }
    }
}
