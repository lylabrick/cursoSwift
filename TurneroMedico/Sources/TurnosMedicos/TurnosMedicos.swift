// The Swift Programming Language
// https://docs.swift.org/swift-book
import Foundation

@main
struct TurnosMedicos {
    static func main() {

        // Crear paciente
        let fechaNac = Calendar.current.date(from: DateComponents(year: 1990, month: 3, day: 15))!
        var paciente = Paciente(
            dni: "32456789",
            nombre: "Laura",
            apellido: "González",
            fechaNacimiento: fechaNac,
            email: "laura@email.com",
            telefono: "+54 221 555-1234"
        )

        // Crear turno
        let fechaTurno = Calendar.current.date(byAdding: .day, value: 2, to: Date())!
        var turno = Turno(
            paciente: paciente,
            especialidad: .cardiologia,
            medico: "Dr. Martínez",
            fecha: fechaTurno,
            duracionMinutos: 45
        )

        // Mostrar información
        print(paciente.descripcionCompleta())
        print("---")
        print(turno.descripcionCompleta())
        print("---")

        // Cambiar estado — dispara willSet y didSet
        turno.estado = .confirmado
        print("---")

        // Notificaciones
        let emailNotif = EmailNotificacion(email: paciente.email)
        let smsNotif = SMSNotificacion(telefono: paciente.telefono)

        emailNotif.enviarConfirmacion(turno: turno)
        print("---")
        smsNotif.enviarRecordatorio(turno: turno)
        print("---")

        // Cancelar y notificar
        turno.estado = .cancelado
        emailNotif.enviarCancelacion(turno: turno)
        smsNotif.enviarCancelacion(turno: turno)

        // Incrementar turnos del paciente
        paciente.incrementarTurnos()
        print("---")
        print("Turnos del paciente: \(paciente.cantidadTurnos)")
    }
}
