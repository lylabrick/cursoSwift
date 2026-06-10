//
//  WeatherCache.swift
//  ClienteDeConsola
//
//  Created by Lylabrick on 10/06/2026.
//

import Foundation

/// Actor que actúa como store en memoria para los datos de clima.
/// Protege el estado compartido ante accesos concurrentes.
actor WeatherCache {

    private var cache: [String: (datos: DatosClima, fechaGuardado: Date)] = [:]
    private let ttlSegundos: TimeInterval

    init(ttlSegundos: TimeInterval = 300) {
        self.ttlSegundos = ttlSegundos
    }

    /// Retorna los datos cacheados si existen y no expiraron.
    func obtener(para ciudad: String) -> DatosClima? {
        guard let entrada = cache[ciudad] else { return nil }
        let ahora = Date()
        guard ahora.timeIntervalSince(entrada.fechaGuardado) < ttlSegundos else {
            cache.removeValue(forKey: ciudad)
            return nil
        }
        return entrada.datos
    }

    /// Guarda los datos en caché con timestamp actual.
    func guardar(_ datos: DatosClima, para ciudad: String) {
        cache[ciudad] = (datos: datos, fechaGuardado: Date())
    }

    /// Cantidad de entradas actualmente en caché.
    func cantidadEntradas() -> Int {
        return cache.count
    }

    /// Limpia todas las entradas vencidas.
    func limpiarVencidas() {
        let ahora = Date()
        cache = cache.filter { _, valor in
            ahora.timeIntervalSince(valor.fechaGuardado) < ttlSegundos
        }
    }

    /// Invalida la caché de una ciudad específica.
    func invalidar(ciudad: String) {
        cache.removeValue(forKey: ciudad)
    }
}
