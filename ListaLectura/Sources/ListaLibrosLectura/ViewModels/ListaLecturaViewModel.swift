//
//  ListaLecturaViewModel.swift
//  ListaLibrosLectura
//
//  Created by Lylabrick on 17/06/2026.
//

import Foundation
import Combine

final class ListaLecturaViewModel: ObservableObject {
    @Published var libros: [Libro] = []
    @Published var textoBusqueda: String = ""
    @Published var filtroEstado: EstadoLectura? = nil // nil = "todos"

    private let storage: LibroStorage
    private var cancellables = Set<AnyCancellable>()

    init(storage: LibroStorage = LibroStorage()) {
        self.storage = storage
        self.libros = storage.cargar()

        // Persiste automáticamente cada vez que cambia la lista de libros
        $libros
            .dropFirst()
            .sink { [weak self] nuevosLibros in
                self?.storage.guardar(nuevosLibros)
            }
            .store(in: &cancellables)
    }

    var librosFiltrados: [Libro] {
        libros
            .filter { libro in
                filtroEstado == nil || libro.estado == filtroEstado
            }
            .filter { libro in
                textoBusqueda.isEmpty ||
                libro.titulo.localizedCaseInsensitiveContains(textoBusqueda) ||
                libro.autor.localizedCaseInsensitiveContains(textoBusqueda)
            }
            .sorted { $0.fechaAgregado > $1.fechaAgregado }
    }

    func agregar(_ libro: Libro) {
        libros.append(libro)
    }

    func actualizar(_ libro: Libro) {
        guard let index = libros.firstIndex(where: { $0.id == libro.id }) else { return }
        libros[index] = libro
    }

    func eliminar(_ libro: Libro) {
        libros.removeAll { $0.id == libro.id }
    }

    func eliminar(at offsets: IndexSet, en lista: [Libro]) {
        let idsAEliminar = offsets.map { lista[$0].id }
        libros.removeAll { idsAEliminar.contains($0.id) }
    }
}
