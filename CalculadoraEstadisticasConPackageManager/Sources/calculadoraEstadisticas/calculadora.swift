// Sources/main.swift

import Foundation

// ──────────────────────────────────────────────
// Tipos y constantes del dominio
// ──────────────────────────────────────────────

let nombreApp: String = "QuickStats"
let version      = "1.0"                     // inferencia de tipo
let separador    = String(repeating: "─", count: 40)

enum ErrorEstadistica: Error {
    case entradaVacia
    case conversionFallida(String)
}

// ──────────────────────────────────────────────
// Funciones de cálculo
// ──────────────────────────────────────────────

func calcularMedia(numeros: [Double]) -> Double? {
    guard !numeros.isEmpty else { return nil }
    let suma = numeros.reduce(0.0, +)
    return suma / Double(numeros.count)
}

func calcularMediana(numeros: [Double]) -> Double? {
    guard !numeros.isEmpty else { return nil }
    let ordenados = numeros.sorted()
    let medio     = ordenados.count / 2
    if ordenados.count % 2 == 0 {
        return (ordenados[medio - 1] + ordenados[medio]) / 2
    }
    return ordenados[medio]
}

func calcularModa(numeros: [Double]) -> [Double]? {
    guard !numeros.isEmpty else { return nil }

    // Dictionary para contar frecuencias
    var frecuencias: [Double: Int] = [:]
    for n in numeros {
        frecuencias[n, default: 0] += 1
    }

    let maxFrecuencia = frecuencias.values.max() ?? 0
    guard maxFrecuencia > 1 else { return [] }   // sin moda si todos aparecen una vez

    // Set para eliminar duplicados, luego Array ordenado
    let modas = Set(frecuencias.filter { $0.value == maxFrecuencia }.keys)
    return modas.sorted()
}

func calcularDesvio(numeros: [Double], media: Double) -> Double? {
    guard !numeros.isEmpty else { return nil }
    let varianza = numeros.map { pow($0 - media, 2) }.reduce(0, +) / Double(numeros.count)
    return sqrt(varianza)
}

// Múltiples valores de retorno con tupla
func calcularEstadisticas(
    numeros: [Double],
    incluirDesvio: Bool = true          // parámetro con valor por defecto
) -> (media: Double?, mediana: Double?, moda: [Double]?, desvio: Double?) {

    let media   = calcularMedia(numeros: numeros)
    let mediana = calcularMediana(numeros: numeros)
    let moda    = calcularModa(numeros: numeros)
    let desvio  = incluirDesvio ? media.flatMap { calcularDesvio(numeros: numeros, media: $0) } : nil

    return (media, mediana, moda, desvio)
}

// ──────────────────────────────────────────────
// Parsing de entrada
// ──────────────────────────────────────────────

func parsearNumeros(desde texto: String) throws -> [Double] {
    guard !texto.trimmingCharacters(in: .whitespaces).isEmpty else {
        throw ErrorEstadistica.entradaVacia
    }

    var numeros: [Double] = []
    let partes = texto.split(separator: ",")

    for parte in partes {
        let limpio = parte.trimmingCharacters(in: .whitespaces)
        // Optional binding: Double(String) devuelve Double?
        if let numero = Double(limpio) {
            numeros.append(numero)
        } else {
            throw ErrorEstadistica.conversionFallida(limpio)
        }
    }

    guard !numeros.isEmpty else { throw ErrorEstadistica.entradaVacia }
    return numeros
}

// ──────────────────────────────────────────────
// Presentación de resultados
// ──────────────────────────────────────────────

func formatear(_ valor: Double?, decimales: Int = 2) -> String {
    // nil-coalescing: si valor es nil mostramos "—"
    guard let v = valor else { return "—" }
    return String(format: "%.\(decimales)f", v)
}

func mostrarResultados(numeros: [Double]) {
    let stats = calcularEstadisticas(numeros: numeros)

    print(separador)
    print("  Cantidad de números : \(numeros.count)")
    print("  Media               : \(formatear(stats.media))")
    print("  Mediana             : \(formatear(stats.mediana))")

    // switch con pattern matching sobre Optional<[Double]>
    switch stats.moda {
    case nil:
        print("  Moda                : —")
    case let modas? where modas.isEmpty:
        print("  Moda                : sin moda (todos únicos)")
    case let modas?:
        let lista = modas.map { formatear($0) }.joined(separator: ", ")
        print("  Moda                : \(lista)")
    }

    print("  Desvío estándar     : \(formatear(stats.desvio))")
    print(separador)
}

// ──────────────────────────────────────────────
// Menú interactivo
// ──────────────────────────────────────────────

func mostrarMenu() {
    print("""

    \(separador)
      \(nombreApp) v\(version)
    \(separador)
      1. Ingresar números
      2. Ver ejemplos
      3. Salir
    \(separador)
    """)
}

func ejemplos() {
    let casos: [(String, [Double])] = [
        ("Lista normal",    [4, 8, 6, 5, 3, 2, 8, 9, 2, 5]),
        ("Con moda clara",  [1, 2, 2, 3, 4]),
        ("Un solo elemento",[42]),
    ]

    for (nombre, nums) in casos {
        print("\n  Ejemplo: \(nombre)")
        print("  Datos  : \(nums.map { String($0) }.joined(separator: ", "))")
        mostrarResultados(numeros: nums)
    }
}


//
//  calculadora.swift
//  calculadoraEstadisticas
//
//  Created by Lylabrick on 01/06/2026.
//

