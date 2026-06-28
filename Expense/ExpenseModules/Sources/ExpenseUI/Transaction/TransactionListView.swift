//
//  TransactionListView.swift
//  ExpenseCore
//
//  Created by Lylabrick on 27/06/2026.
//


import SwiftUI
import ExpenseCore

public struct TransactionListView: View {
    @ObservedObject var viewModel: TransactionsViewModel
    @State private var showingForm = false
    @State private var showingShareSheet = false
    @State private var exportURL: URL?
    @State private var showingCategoryForm = false

    public init(viewModel: TransactionsViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.transactions) { transaction in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(transaction.note.isEmpty ? (transaction.category?.name ?? "Sin nota") : transaction.note)
                                .font(.body)
                            Text(transaction.date, style: .date)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Text(transaction.amount, format: .currency(code: "ARS"))
                            .foregroundStyle(transaction.type == .income ? .green : .red)
                    }
                }
                .onDelete { indexSet in
                    indexSet.forEach { viewModel.delete(viewModel.transactions[$0]) }
                }
            }
            .navigationTitle("Transacciones")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingForm = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        exportURL = viewModel.exportCSV()
                        showingShareSheet = exportURL != nil
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingCategoryForm = true
                    } label: {
                        Image(systemName: "tag")
                    }
                }
            }
            .sheet(isPresented: $showingForm) {
                TransactionFormView(viewModel: viewModel)
            }
            .sheet(isPresented: $showingShareSheet) {
                if let exportURL {
                    ShareSheet(url: exportURL)
                }
            }
            .sheet(isPresented: $showingCategoryForm) {
                CategoryFormView(viewModel: viewModel)
            }
            .onAppear { viewModel.loadAll() }
        }
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: [url], applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

