//
//  main.swift
//  calculadoraEstadisticas
//
//  Created by Lylabrick on 05/05/2026.
//

import Foundation

//Calculador con Var
// ──────────────────────────────────────────────
// Loop principal
// ──────────────────────────────────────────────

var ejecutando = true

while ejecutando {
    mostrarMenu()
    print("  Opción: ", terminator: "")

    // Optional binding sobre readLine()
    guard let opcion = readLine()?.trimmingCharacters(in: .whitespaces) else {
        continue
    }

    switch opcion {
    case "1":
        print("\n  Ingresá los números separados por coma (ej: 1, 2.5, 3):")
        print("  > ", terminator: "")

        if let entrada = readLine() {
            do {
                let numeros = try parsearNumeros(desde: entrada)
                mostrarResultados(numeros: numeros)
            } catch ErrorEstadistica.entradaVacia {
                print("\n  ⚠️  No ingresaste ningún número.")
            } catch ErrorEstadistica.conversionFallida(let valor) {
                print("\n  ⚠️  '\(valor)' no es un número válido.")
            } catch {
                print("\n  ⚠️  Error inesperado: \(error)")
            }
        }

    case "2":
        ejemplos()

    case "3":
        print("\n  Hasta luego.\n")
        ejecutando = false

    default:
        print("\n  Opción no válida.")
    }
}
