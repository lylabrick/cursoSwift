//
//  EmailNotification.swift
//  TurnosMedicos
//
//  Created by Lylabrick on 01/06/2026.
//

struct EmailNotificacion: Notificable {
    let destinatario: String
    let canal = "Email"
    let asunto: String

    init(email: String, asunto: String = "Información de su turno") {
        self.destinatario = email
        self.asunto = asunto
    }

    func enviarConfirmacion(turno: Turno) {
        print("[\(canal)] Para: \(destinatario)")
        print("Asunto: \(asunto)")
        print("Su turno ha sido confirmado. \(mensajeBase(turno: turno))")
    }

    func enviarRecordatorio(turno: Turno) {
        print("[\(canal)] Para: \(destinatario)")
        print("Asunto: Recordatorio de turno")
        print("Le recordamos su turno mañana. \(mensajeBase(turno: turno))")
    }

    func enviarCancelacion(turno: Turno) {
        print("[\(canal)] Para: \(destinatario)")
        print("Asunto: Cancelación de turno")
        print("Su turno ha sido cancelado. \(mensajeBase(turno: turno))")
    }
}
