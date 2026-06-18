//
//  DetalleLibroView.swift
//  ListaLibrosLectura
//
//  Created by Lylabrick on 17/06/2026.
//

import SwiftUI

struct DetalleLibroView: View {
    let libro: Libro
    @ObservedObject var viewModel: ListaLecturaViewModel

    @State private var mostrandoFormularioEdicion = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(libro.titulo)
                        .font(.title)
                        .fontWeight(.bold)
                    Text(libro.autor)
                        .font(.title3)
                        .foregroundColor(.secondary)
                }

                HStack {
                    EstadoBadgeView(estado: libro.estado)
                    Spacer()
                    if libro.calificacion > 0 {
                        HStack(spacing: 2) {
                            ForEach(1...5, id: \.self) { numero in
                                Image(systemName: numero <= libro.calificacion ? "star.fill" : "star")
                                    .foregroundColor(.yellow)
                            }
                        }
                    }
                }

                Divider()

                infoFila(titulo: "Género", valor: libro.genero)

                if !libro.notas.isEmpty {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Notas")
                            .font(.headline)
                        Text(libro.notas)
                            .foregroundColor(.secondary)
                    }
                }

                Spacer(minLength: 20)
            }
            .padding()
        }
        .navigationTitle("Detalle")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Editar") {
                    mostrandoFormularioEdicion = true
                }
            }
        }
        .sheet(isPresented: $mostrandoFormularioEdicion) {
            FormularioLibroView(viewModel: viewModel, libroAEditar: libro)
        }
    }

    private func infoFila(titulo: String, valor: String) -> some View {
        HStack {
            Text(titulo)
                .font(.subheadline)
                .foregroundColor(.secondary)
            Spacer()
            Text(valor)
                .font(.subheadline)
        }
    }
}

#Preview {
    NavigationStack {
        DetalleLibroView(
            libro: Libro(
                titulo: "1984",
                autor: "George Orwell",
                genero: "Distopía",
                estado: .terminado,
                calificacion: 5,
                notas: "Releer el final."
            ),
            viewModel: ListaLecturaViewModel()
        )
    }
}
