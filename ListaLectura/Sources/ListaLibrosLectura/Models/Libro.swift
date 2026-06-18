//
//  Libro.swift
//  ListaLibrosLectura
//
//  Created by Lylabrick on 17/06/2026.
//

import Foundation

enum EstadoLectura: String, Codable, CaseIterable, Identifiable {
    case pendiente = "Pendiente"
    case leyendo = "Leyendo"
    case terminado = "Terminado"

    var id: String { rawValue }

    var colorNombre: String {
        switch self {
        case .pendiente: return "gray"
        case .leyendo: return "blue"
        case .terminado: return "green"
        }
    }
}

struct Libro: Identifiable, Codable, Equatable, Hashable {
    var id: UUID = UUID()
    var titulo: String
    var autor: String
    var genero: String
    var estado: EstadoLectura
    var calificacion: Int // 0 a 5
    var notas: String
    var fechaAgregado: Date = Date()
}
