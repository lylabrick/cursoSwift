//
//  Paciente.swift
//  TurnosMedicos
//
//  Created by Lylabrick on 01/06/2026.
//

import Foundation

struct Paciente {
    let dni: String
    let nombre: String
    let apellido: String
    let fechaNacimiento: Date
    var email: String
    var telefono: String

    private(set) var cantidadTurnos: Int = 0

    var nombreCompleto: String {
        return "\(apellido), \(nombre)"
    }

    var edad: Int {
        let calendar = Calendar.current
        let componentes = calendar.dateComponents([.year], from: fechaNacimiento, to: Date())
        return componentes.year ?? 0
    }

    mutating func incrementarTurnos() {
        cantidadTurnos += 1
    }
}

