//
//  ListaLibrosView.swift
//  ListaLibrosLectura
//
//  Created by Lylabrick on 17/06/2026.
//

import SwiftUI

struct ListaLibrosView: View {
    @StateObject private var viewModel = ListaLecturaViewModel()
    @State private var mostrandoFormularioNuevo = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                filtrosView

                if viewModel.librosFiltrados.isEmpty {
                    Spacer()
                    Text("No hay libros que coincidan")
                        .foregroundColor(.secondary)
                    Spacer()
                } else {
                    List {
                        ForEach(viewModel.librosFiltrados) { libro in
                            NavigationLink(value: libro) {
                                LibroRowView(libro: libro)
                            }
                        }
                        .onDelete { offsets in
                            viewModel.eliminar(at: offsets, en: viewModel.librosFiltrados)
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Mi lista de lectura")
            .searchable(text: $viewModel.textoBusqueda, prompt: "Buscar por título o autor")
            .navigationDestination(for: Libro.self) { libro in
                DetalleLibroView(libro: libro, viewModel: viewModel)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        mostrandoFormularioNuevo = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $mostrandoFormularioNuevo) {
                FormularioLibroView(viewModel: viewModel, libroAEditar: nil)
            }
        }
    }

    private var filtrosView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                FiltroChip(titulo: "Todos", seleccionado: viewModel.filtroEstado == nil) {
                    viewModel.filtroEstado = nil
                }
                ForEach(EstadoLectura.allCases) { estado in
                    FiltroChip(titulo: estado.rawValue, seleccionado: viewModel.filtroEstado == estado) {
                        viewModel.filtroEstado = estado
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
    }
}

/// Chip de filtro, modificador de vista propio aplicado con .buttonStyle/.background encadenados.
private struct FiltroChip: View {
    let titulo: String
    let seleccionado: Bool
    let accion: () -> Void

    var body: some View {
        Button(action: accion) {
            Text(titulo)
                .font(.subheadline)
                .padding(.horizontal, 14)
                .padding(.vertical, 6)
                .background(seleccionado ? Color.accentColor : Color(.systemGray5))
                .foregroundColor(seleccionado ? .white : .primary)
                .clipShape(Capsule())
        }
    }
}

#Preview {
    ListaLibrosView()
}
