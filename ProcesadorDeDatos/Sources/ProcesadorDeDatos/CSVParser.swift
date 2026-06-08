//
//  CSVParser.swift
//  ProcesadorDeDatos
//
//  Created by Lylabrick on 05/06/2026.
//

public enum CSVError: Error, CustomStringConvertible {
    case archivoVacio
    case encabezadoInvalido
    case filaInconsistente(linea: Int, esperadas: Int, encontradas: Int)
    case valorInvalido(linea: Int, columna: String, valor: String)
    case formatoNoSoportado(detalle: String)

    public var description: String {
        switch self {
        case .archivoVacio:
            return "El contenido CSV está vacío."
        case .encabezadoInvalido:
            return "El encabezado CSV es inválido o está ausente."
        case .filaInconsistente(let linea, let esperadas, let encontradas):
            return "Línea \(linea): se esperaban \(esperadas) columnas pero se encontraron \(encontradas)."
        case .valorInvalido(let linea, let columna, let valor):
            return "Línea \(linea): valor '\(valor)' inválido en columna '\(columna)'."
        case .formatoNoSoportado(let detalle):
            return "Formato no soportado: \(detalle)."
        }
    }
}

public struct CSVParser {
    public let separador: Character
    public let tolerarFilasInconsistentes: Bool

    public init(separador: Character = ",", tolerarFilasInconsistentes: Bool = false) {
        self.separador = separador
        self.tolerarFilasInconsistentes = tolerarFilasInconsistentes
    }

    // Versión con Result — no lanza, devuelve éxito o fallo
    public func parsear(_ contenido: String) -> Result<[Registro], CSVError> {
        do {
            let registros = try parsearOLanzar(contenido)
            return .success(registros)
        } catch let error as CSVError {
            return .failure(error)
        } catch {
            return .failure(.formatoNoSoportado(detalle: error.localizedDescription))
        }
    }

    // Versión con throws — para usar en contextos do-catch
    public func parsearOLanzar(_ contenido: String) throws -> [Registro] {
        let lineas = contenido
            .components(separatedBy: "\n")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }

        guard !lineas.isEmpty else {
            throw CSVError.archivoVacio
        }

        let encabezados = lineas[0]
            .split(separator: separador, omittingEmptySubsequences: false)
            .map { $0.trimmingCharacters(in: .whitespaces) }

        guard !encabezados.isEmpty && encabezados.allSatisfy({ !$0.isEmpty }) else {
            throw CSVError.encabezadoInvalido
        }

        var registros: [Registro] = []

        for (indice, linea) in lineas.dropFirst().enumerated() {
            let numeroLinea = indice + 2
            let valores = linea
                .split(separator: separador, omittingEmptySubsequences: false)
                .map { $0.trimmingCharacters(in: .whitespaces) }

            if valores.count != encabezados.count {
                if tolerarFilasInconsistentes {
                    continue
                } else {
                    throw CSVError.filaInconsistente(
                        linea: numeroLinea,
                        esperadas: encabezados.count,
                        encontradas: valores.count
                    )
                }
            }

            var campos: [String: String] = [:]
            for (columna, valor) in zip(encabezados, valores) {
                campos[columna] = valor
            }

            registros.append(Registro(campos: campos))
        }

        return registros
    }
}
