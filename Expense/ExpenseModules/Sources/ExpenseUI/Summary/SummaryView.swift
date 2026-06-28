//
//  SummaryView.swift
//  ExpenseCore
//
//  Created by Lylabrick on 27/06/2026.
//


import SwiftUI
import Charts
import ExpenseCore

public struct SummaryView: View {
    @ObservedObject var viewModel: SummaryViewModel

    public init(viewModel: SummaryViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    Picker("Período", selection: $viewModel.selectedPeriod) {
                        ForEach(PeriodFilter.allCases) { period in
                            Text(period.rawValue).tag(period)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)

                    HStack(spacing: 16) {
                        totalCard(title: "Ingresos", amount: viewModel.totalIncome, color: .green)
                        totalCard(title: "Gastos", amount: viewModel.totalExpense, color: .red)
                    }
                    .padding(.horizontal)

                    if !viewModel.categoryTotals.isEmpty {
                        Chart(viewModel.categoryTotals) { item in
                            SectorMark(
                                angle: .value("Total", NSDecimalNumber(decimal: item.total).doubleValue),
                                innerRadius: .ratio(0.5)
                            )
                            .foregroundStyle(Color(hex: item.colorHex))
                            .annotation(position: .overlay) {
                                Text(item.categoryName)
                                    .font(.caption2)
                            }
                        }
                        .frame(height: 260)
                        .padding(.horizontal)

                        Chart(viewModel.categoryTotals) { item in
                            BarMark(
                                x: .value("Categoría", item.categoryName),
                                y: .value("Total", NSDecimalNumber(decimal: item.total).doubleValue)
                            )
                            .foregroundStyle(Color(hex: item.colorHex))
                        }
                        .frame(height: 200)
                        .padding(.horizontal)
                    } else {
                        Text("Sin gastos en este período")
                            .foregroundStyle(.secondary)
                            .padding()
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Resumen")
            .onAppear { viewModel.reload() }
            .onChange(of: viewModel.selectedPeriod) { _, _ in viewModel.reload() }
        }
    }

    private func totalCard(title: String, amount: Decimal, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(amount, format: .currency(code: "ARS"))
                .font(.title3.bold())
                .foregroundStyle(color)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex.trimmingCharacters(in: CharacterSet(charactersIn: "#")))
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        let r = Double((rgb >> 16) & 0xFF) / 255
        let g = Double((rgb >> 8) & 0xFF) / 255
        let b = Double(rgb & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}


