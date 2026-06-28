//
//  TransactionFormView.swift
//  ExpenseCore
//
//  Created by Lylabrick on 27/06/2026.
//

import SwiftUI
import ExpenseCore

public struct TransactionFormView: View {
    @ObservedObject var viewModel: TransactionsViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var amountText = ""
    @State private var note = ""
    @State private var date = Date.now
    @State private var type: TransactionType = .expense
    @State private var selectedCategory: CategoryForExpense?

    public init(viewModel: TransactionsViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        NavigationStack {
            Form {
                Section("Datos") {
                    TextField("Monto", text: $amountText)
                        .keyboardType(.decimalPad)
                    TextField("Nota", text: $note)
                    DatePicker("Fecha", selection: $date, displayedComponents: .date)
                    Picker("Tipo", selection: $type) {
                        ForEach(TransactionType.allCases, id: \.self) { t in
                            Text(t == .expense ? "Gasto" : "Ingreso").tag(t)
                        }
                    }
                    Picker("Categoría", selection: $selectedCategory) {
                        Text("Sin categoría").tag(CategoryForExpense?.none)
                        ForEach(viewModel.categories) { category in
                            Text(category.name).tag(CategoryForExpense?.some(category))
                        }
                    }
                }
            }
            .navigationTitle("Nueva transacción")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Guardar") {
                        guard let amount = Decimal(string: amountText) else { return }
                        viewModel.addTransaction(amount: amount, note: note, date: date, type: type, category: selectedCategory)
                        dismiss()
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
            }
        }
    }
}
