//
//  EstadoBadgetView.swift
//  ListaLibrosLectura
//
//  Created by Lylabrick on 17/06/2026.
//

import SwiftUI

/// Componente reutilizable: muestra el estado de lectura como una etiqueta de color.
/// Se usa tanto en LibroRowView como en DetalleLibroView.
struct EstadoBadgeView: View {
    let estado: EstadoLectura

    private var color: Color {
        switch estado {
        case .pendiente: return .gray
        case .leyendo: return .blue
        case .terminado: return .green
        }
    }

    var body: some View {
        Text(estado.rawValue)
            .font(.caption)
            .fontWeight(.semibold)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(color.opacity(0.15))
            .foregroundColor(color)
            .clipShape(Capsule())
    }
}

#Preview {
    HStack {
        EstadoBadgeView(estado: .pendiente)
        EstadoBadgeView(estado: .leyendo)
        EstadoBadgeView(estado: .terminado)
    }
}
