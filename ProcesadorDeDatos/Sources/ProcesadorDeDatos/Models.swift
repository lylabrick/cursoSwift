//
//  Models.swift
//  ProcesadorDeDatos
//
//  Created by Lylabrick on 05/06/2026.
//
import Foundation

public struct Registro {
    public let campos: [String: String]

    public init(campos: [String: String]) {
        self.campos = campos
    }

    public func valor(para clave: String) -> String? {
        return campos[clave]
    }

    public func valorDouble(para clave: String) -> Double? {
        guard let raw = campos[clave] else { return nil }
        return Double(raw.trimmingCharacters(in: .whitespaces))
    }

    public func valorInt(para clave: String) -> Int? {
        guard let raw = campos[clave] else { return nil }
        return Int(raw.trimmingCharacters(in: .whitespaces))
    }
}

public struct Resumen {
    public let clave: String
    public let cantidad: Int
    public let suma: Double
    public let promedio: Double
    public let maximo: Double
    public let minimo: Double

    public var descripcion: String {
        return """
        Resumen [\(clave)]
        Cantidad : \(cantidad)
        Suma     : \(suma)
        Promedio : \(String(format: "%.2f", promedio))
        Máximo   : \(maximo)
        Mínimo   : \(minimo)
        """
    }
}
