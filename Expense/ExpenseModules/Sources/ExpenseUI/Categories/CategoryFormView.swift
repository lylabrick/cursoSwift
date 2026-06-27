//
//  CategoryFormView.swift
//  Expense
//
//  Created by Lylabrick on 26/06/2026.
//


import SwiftUI
import ExpenseCore

public struct CategoryFormView: View {
    @ObservedObject var viewModel: TransactionsViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var colorHex = "#3478F6"
    @State private var icon = "tag"

    public init(viewModel: TransactionsViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        NavigationStack {
            Form {
                TextField("Nombre", text: $name)
                TextField("Color (hex)", text: $colorHex)
                TextField("Icono (SF Symbol)", text: $icon)
            }
            .navigationTitle("Nueva categoría")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Guardar") {
                        viewModel.addCategory(name: name, colorHex: colorHex, icon: icon)
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