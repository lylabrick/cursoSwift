//
//  LibroRowView.swift
//  ListaLibrosLectura
//
//  Created by Lylabrick on 17/06/2026.
//

import SwiftUI

/// Componente reutilizable que representa una fila de la lista de libros.
/// Extraído como View independiente para poder reusarse y simplificar ListaLibrosView.
struct LibroRowView: View {
    let libro: Libro

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(libro.titulo)
                    .font(.headline)
                Text(libro.autor)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                if libro.calificacion > 0 {
                    EstrellasView(calificacion: libro.calificacion)
                }
            }
            Spacer()
            EstadoBadgeView(estado: libro.estado)
        }
        .padding(.vertical, 6)
    }
}

/// Sub-componente simple para mostrar la calificación en estrellas.
private struct EstrellasView: View {
    let calificacion: Int

    var body: some View {
        HStack(spacing: 2) {
            ForEach(1...5, id: \.self) { numero in
                Image(systemName: numero <= calificacion ? "star.fill" : "star")
                    .font(.caption2)
                    .foregroundColor(.yellow)
            }
        }
    }
}

#Preview {
    LibroRowView(libro: Libro(
        titulo: "Cien años de soledad",
        autor: "Gabriel García Márquez",
        genero: "Novela",
        estado: .leyendo,
        calificacion: 4,
        notas: ""
    ))
    .padding()
}
