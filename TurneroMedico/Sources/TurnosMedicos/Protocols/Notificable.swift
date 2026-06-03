//
//  Notificable.swift
//  TurnosMedicos
//
//  Created by Lylabrick on 01/06/2026.
//

protocol Notificable {
    var destinatario: String { get }
    var canal: String { get }
    func enviarConfirmacion(turno: Turno)
    func enviarRecordatorio(turno: Turno)
    func enviarCancelacion(turno: Turno)
}

extension Notificable {
    func mensajeBase(turno: Turno) -> String {
        return "Turno con \(turno.medico) - \(turno.especialidad.rawValue) - \(turno.descripcionFecha)"
    }
}
