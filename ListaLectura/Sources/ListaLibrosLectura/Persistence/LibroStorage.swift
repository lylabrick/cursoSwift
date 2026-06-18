//
//  LibroStorage.swift
//  ListaLibrosLectura
//
//  Created by Lylabrick on 17/06/2026.
//

import Foundation

/// Encapsula la persistencia de libros en UserDefaults.
/// Se mantiene separada del ViewModel para respetar responsabilidades únicas.
final class LibroStorage {
    private let key = "libros_guardados"
    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func cargar() -> [Libro] {
        guard let data = defaults.data(forKey: key) else { return [] }
        do {
            return try JSONDecoder().decode([Libro].self, from: data)
        } catch {
            print("Error al decodificar libros: \(error)")
            return []
        }
    }

    func guardar(_ libros: [Libro]) {
        do {
            let data = try JSONEncoder().encode(libros)
            defaults.set(data, forKey: key)
        } catch {
            print("Error al codificar libros: \(error)")
        }
    }
}
