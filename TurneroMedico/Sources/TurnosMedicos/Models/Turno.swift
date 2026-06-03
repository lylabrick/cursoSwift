//
//  Turno.swift
//  TurnosMedicos
//
//  Created by Lylabrick on 01/06/2026.
//

import Foundation

struct Turno {
    let id: UUID
    let paciente: Paciente
    let especialidad: Especialidad
    let medico: String
    let fecha: Date

    var estado: EstadoTurno = .pendiente {
        willSet {
            print("[\(id)] Estado cambiará de \(estado.rawValue) a \(newValue.rawValue)")
        }
        didSet {
            print("[\(id)] Estado actualizado a \(estado.rawValue)")
        }
    }

    var duracionMinutos: Int

    init(paciente: Paciente, especialidad: Especialidad, medico: String, fecha: Date, duracionMinutos: Int = 30) {
        self.id = UUID()
        self.paciente = paciente
        self.especialidad = especialidad
        self.medico = medico
        self.fecha = fecha
        self.duracionMinutos = duracionMinutos
    }

    var estaVigente: Bool {
        return estado.esActivo && fecha > Date()
    }
}
