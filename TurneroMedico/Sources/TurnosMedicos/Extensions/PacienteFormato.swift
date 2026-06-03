//
//  PacienteFormato.swift
//  TurnosMedicos
//
//  Created by Lylabrick on 01/06/2026.
//

import Foundation

extension Paciente {
    func descripcionCompleta() -> String {
        return """
        Paciente: \(nombreCompleto)
        DNI: \(dni)
        Edad: \(edad) años
        Email: \(email)
        Teléfono: \(telefono)
        Turnos tomados: \(cantidadTurnos)
        """
    }

    func requiereAyuno(para especialidad: Especialidad) -> String {
        let requiere = especialidad.requiereAyuno()
        return requiere ? "Recuerde concurrir en ayunas." : "No requiere ayuno."
    }
}
