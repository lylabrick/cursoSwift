//
//  CSVExporter.swift
//  ExpenseCore
//
//  Created by Lylabrick on 27/06/2026.
//


import Foundation

public struct CSVExporter {
    public init() {}

    public func export(transactions: [Transaction]) -> String {
        var lines = ["fecha,categoria,tipo,monto,nota"]

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"

        for transaction in transactions {
            let date = formatter.string(from: transaction.date)
            let category = transaction.category?.name ?? "Sin categoría"
            let type = transaction.type.rawValue
            let amount = "\(transaction.amount)"
            let note = transaction.note.replacingOccurrences(of: ",", with: ";")
            lines.append("\(date),\(category),\(type),\(amount),\(note)")
        }

        return lines.joined(separator: "\n")
    }

    public func writeToTempFile(csv: String, fileName: String = "transactions.csv") throws -> URL {
        let url = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
        try csv.write(to: url, atomically: true, encoding: .utf8)
        return url
    }
}
