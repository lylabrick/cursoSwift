//
//  TurnoFormato.swift
//  TurnosMedicos
//
//  Created by Lylabrick on 01/06/2026.
//

import Foundation

extension Turno {
    var descripcionFecha: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        formatter.locale = Locale(identifier: "es_AR")
        return formatter.string(from: fecha)
    }

    func descripcionCompleta() -> String {
        return """
        Turno ID: \(id)
        Paciente: \(paciente.nombreCompleto)
        Especialidad: \(especialidad.rawValue)
        Médico: \(medico)
        Fecha: \(descripcionFecha)
        Duración: \(duracionMinutos) minutos
        Estado: \(estado.rawValue)
        \(paciente.requiereAyuno(para: especialidad))
        """
    }
}
