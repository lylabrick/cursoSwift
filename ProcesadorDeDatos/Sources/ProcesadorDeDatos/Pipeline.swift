//
//  Pipeline.swift
//  ProcesadorDeDatos
//
//  Created by Lylabrick on 05/06/2026.
//

// Tipo que representa una transformación de [T] a [U]
public typealias Transformacion<T, U> = ([T]) -> [U]

// Pipeline que encadena transformaciones homogéneas sobre una colección
public func pipeline<T>(_ datos: [T], _ transformaciones: ((T) -> T)...) -> [T] {
    return transformaciones.reduce(datos) { acumulado, transformacion in
        acumulado.map(transformacion)
    }
}

// Pipeline que acepta transformaciones heterogéneas usando closures encadenados
public struct Pipeline<T> {
    private let datos: [T]

    public init(_ datos: [T]) {
        self.datos = datos
    }

    public func map<U>(_ transformacion: (T) -> U) -> Pipeline<U> {
        return Pipeline<U>(datos.map(transformacion))
    }

    public func filter(_ condicion: (T) -> Bool) -> Pipeline<T> {
        return Pipeline<T>(datos.filter(condicion))
    }

    public func compactMap<U>(_ transformacion: (T) -> U?) -> Pipeline<U> {
        return Pipeline<U>(datos.compactMap(transformacion))
    }

    public func reduce<U>(_ inicial: U, _ combinar: (U, T) -> U) -> U {
        return datos.reduce(inicial, combinar)
    }

    public func forEach(_ accion: (T) -> Void) -> Pipeline<T> {
        datos.forEach(accion)
        return self
    }

    public func resultado() -> [T] {
        return datos
    }

    public func sorted(by criterio: (T, T) -> Bool) -> Pipeline<T> {
        return Pipeline<T>(datos.sorted(by: criterio))
    }
}
