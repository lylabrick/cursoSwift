//
//  SMSNotification.swift
//  TurnosMedicos
//
//  Created by Lylabrick on 01/06/2026.
//

struct SMSNotificacion: Notificable {
    let destinatario: String
    let canal = "SMS"

    init(telefono: String) {
        self.destinatario = telefono
    }

    func enviarConfirmacion(turno: Turno) {
        print("[\(canal)] Para: \(destinatario)")
        print("Turno confirmado: \(mensajeBase(turno: turno))")
    }

    func enviarRecordatorio(turno: Turno) {
        print("[\(canal)] Para: \(destinatario)")
        print("Recordatorio: \(mensajeBase(turno: turno))")
    }

    func enviarCancelacion(turno: Turno) {
        print("[\(canal)] Para: \(destinatario)")
        print("Turno cancelado: \(mensajeBase(turno: turno))")
    }
}
