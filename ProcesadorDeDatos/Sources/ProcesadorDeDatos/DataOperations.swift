//
//  DataOperations.swift
//  ProcesadorDeDatos
//
//  Created by Lylabrick on 05/06/2026.
//

public struct DataOperations {

    // Filtrar registros por valor exacto de una columna
    public static func filtrar(
        _ registros: [Registro],
        columna: String,
        valor: String
    ) -> [Registro] {
        return registros.filter { $0.valor(para: columna) == valor }
    }

    // Filtrar registros usando un closure personalizado
    public static func filtrar(
        _ registros: [Registro],
        donde condicion: (Registro) -> Bool
    ) -> [Registro] {
        return registros.filter(condicion)
    }

    // Agrupar registros por el valor de una columna
    public static func agrupar(
        _ registros: [Registro],
        por columna: String
    ) -> [String: [Registro]] {
        return Dictionary(grouping: registros) { registro in
            registro.valor(para: columna) ?? "sin_valor"
        }
    }

    // Calcular resumen numérico de una columna agrupando por otra
    public static func resumir(
        _ registros: [Registro],
        columnaValor: String,
        columnaClave: String
    ) -> [Resumen] {
        let grupos = agrupar(registros, por: columnaClave)

        return grupos.compactMap { (clave, filas) -> Resumen? in
            let valores = filas.compactMap { $0.valorDouble(para: columnaValor) }
            guard !valores.isEmpty else { return nil }

            let suma = valores.reduce(0, +)
            let promedio = suma / Double(valores.count)
            let maximo = valores.max() ?? 0
            let minimo = valores.min() ?? 0

            return Resumen(
                clave: clave,
                cantidad: valores.count,
                suma: suma,
                promedio: promedio,
                maximo: maximo,
                minimo: minimo
            )
        }.sorted { $0.clave < $1.clave }
    }

    // Extraer valores únicos de una columna
    public static func valoresUnicos(
        _ registros: [Registro],
        columna: String
    ) -> [String] {
        let valores = registros.compactMap { $0.valor(para: columna) }
        return Array(Set(valores)).sorted()
    }

    // Transformar registros aplicando un closure a cada campo
    public static func transformar(
        _ registros: [Registro],
        columna: String,
        transformacion: (String) -> String
    ) -> [Registro] {
        return registros.map { registro in
            var campos = registro.campos
            if let valor = campos[columna] {
                campos[columna] = transformacion(valor)
            }
            return Registro(campos: campos)
        }
    }
}
