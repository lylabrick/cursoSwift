//
//  Especialidad.swift
//  TurnosMedicos
//
//  Created by Lylabrick on 01/06/2026.
//

enum Especialidad: String {
    case clinica = "Clínica Médica"
    case cardiologia = "Cardiología"
    case pediatria = "Pediatría"
    case dermatologia = "Dermatología"
    case neurologia = "Neurología"

    func requiereAyuno() -> Bool {
        switch self {
        case .clinica, .cardiologia: return true
        default: return false
        }
    }
}

enum EstadoTurno: String {
    case pendiente = "Pendiente"
    case confirmado = "Confirmado"
    case cancelado = "Cancelado"
    case realizado = "Realizado"

    var esActivo: Bool {
        switch self {
        case .pendiente, .confirmado: return true
        default: return false
        }
    }
}
