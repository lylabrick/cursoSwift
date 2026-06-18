//
//  FormularioLibroView.swift
//  ListaLibrosLectura
//
//  Created by Lylabrick on 17/06/2026.
//

import SwiftUI

/// Formulario único reutilizado tanto para agregar como para editar un libro.
/// Si `libroAEditar` es nil, se trata de un alta; si tiene valor, se trata de una edición.
struct FormularioLibroView: View {
    @ObservedObject var viewModel: ListaLecturaViewModel
    let libroAEditar: Libro?

    @Environment(\.dismiss) private var dismiss

    @State private var titulo: String
    @State private var autor: String
    @State private var genero: String
    @State private var estado: EstadoLectura
    @State private var calificacion: Int
    @State private var notas: String

    init(viewModel: ListaLecturaViewModel, libroAEditar: Libro?) {
        self.viewModel = viewModel
        self.libroAEditar = libroAEditar

        _titulo = State(initialValue: libroAEditar?.titulo ?? "")
        _autor = State(initialValue: libroAEditar?.autor ?? "")
        _genero = State(initialValue: libroAEditar?.genero ?? "")
        _estado = State(initialValue: libroAEditar?.estado ?? .pendiente)
        _calificacion = State(initialValue: libroAEditar?.calificacion ?? 0)
        _notas = State(initialValue: libroAEditar?.notas ?? "")
    }

    private var formularioValido: Bool {
        !titulo.trimmingCharacters(in: .whitespaces).isEmpty &&
        !autor.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Información básica") {
                    TextField("Título", text: $titulo)
                    TextField("Autor", text: $autor)
                    TextField("Género", text: $genero)
                }

                Section("Estado de lectura") {
                    Picker("Estado", selection: $estado) {
                        ForEach(EstadoLectura.allCases) { opcion in
                            Text(opcion.rawValue).tag(opcion)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                Section("Calificación") {
                    Picker("Estrellas", selection: $calificacion) {
                        Text("Sin calificar").tag(0)
                        ForEach(1...5, id: \.self) { numero in
                            Text("\(numero) estrellas").tag(numero)
                        }
                    }
                }

                Section("Notas") {
                    TextEditor(text: $notas)
                        .frame(minHeight: 100)
                }
            }
            .navigationTitle(libroAEditar == nil ? "Nuevo libro" : "Editar libro")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancelar") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Guardar") {
                        guardar()
                    }
                    .disabled(!formularioValido)
                }
            }
        }
    }

    private func guardar() {
        let libro = Libro(
            id: libroAEditar?.id ?? UUID(),
            titulo: titulo,
            autor: autor,
            genero: genero,
            estado: estado,
            calificacion: calificacion,
            notas: notas,
            fechaAgregado: libroAEditar?.fechaAgregado ?? Date()
        )

        if libroAEditar != nil {
            viewModel.actualizar(libro)
        } else {
            viewModel.agregar(libro)
        }
        dismiss()
    }
}

#Preview {
    FormularioLibroView(viewModel: ListaLecturaViewModel(), libroAEditar: nil)
}
