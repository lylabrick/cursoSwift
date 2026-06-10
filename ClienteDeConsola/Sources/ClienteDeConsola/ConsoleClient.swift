//
//  ConsoleClient.swift
//  ClienteDeConsola
//
//  Created by Lylabrick on 10/06/2026.
//

import Foundation

/// Capa de presentación: orquesta los requests y muestra resultados.
struct ConsoleClient {

    private let servicio: WeatherService
    private let cache: WeatherCache

    init(servicio: WeatherService, cache: WeatherCache) {
        self.servicio = servicio
        self.cache = cache
    }

    // MARK: - Demo 1: async let paralelo

    /// Lanza múltiples requests en paralelo con async let.
    /// Todos los fetches corren concurrentemente sin bloquear entre sí.
    func demoPararelo() async {
        print("\n=== DEMO 1: requests paralelos con async let ===\n")

        let ciudades = Array(ciudadesDisponibles.prefix(3))

        async let clima0 = servicio.obtenerClima(para: ciudades[0])
        async let clima1 = servicio.obtenerClima(para: ciudades[1])
        async let clima2 = servicio.obtenerClima(para: ciudades[2])

        do {
            let resultados = try await [clima0, clima1, clima2]
            resultados.forEach { imprimirClima($0) }
        } catch {
            print("Error en requests paralelos: \(error)")
        }
    }

    // MARK: - Demo 2: TaskGroup dinámico

    /// Usa TaskGroup para lanzar N requests según la cantidad de ciudades.
    func demoTaskGroup() async {
        print("\n=== DEMO 2: TaskGroup dinámico ===\n")

        var resultados: [DatosClima] = []

        do {
            resultados = try await withThrowingTaskGroup(of: DatosClima.self) { group in
                for ciudad in ciudadesDisponibles {
                    group.addTask {
                        try await self.servicio.obtenerClima(para: ciudad)
                    }
                }

                var acumulados: [DatosClima] = []
                for try await resultado in group {
                    acumulados.append(resultado)
                }
                return acumulados
            }
        } catch {
            print("Error en TaskGroup: \(error)")
        }

        // Ordenar por nombre para output consistente
        resultados
            .sorted { $0.ciudad < $1.ciudad }
            .forEach { imprimirClima($0) }

        let cantidadCache = await cache.cantidadEntradas()
        print("\n  [info] Entradas en caché: \(cantidadCache)")
    }

    // MARK: - Demo 3: caché hit

    /// Segunda vuelta sobre las mismas ciudades — todas deben venir de caché.
    func demoCacheHit() async {
        print("\n=== DEMO 3: caché hit (no debe haber requests de red) ===\n")

        for ciudad in ciudadesDisponibles {
            do {
                let datos = try await servicio.obtenerClima(para: ciudad)
                print("  ✓ \(datos.ciudad): \(datos.temperatura)°C (desde caché)")
            } catch {
                print("  ✗ \(ciudad.nombre): \(error)")
            }
        }
    }

    // MARK: - Demo 4: cancelación por timeout

    /// Lanza una tarea con deadline corto para demostrar cancelación.
    func demoCancelacion() async {
        print("\n=== DEMO 4: cancelación por timeout ===\n")

        // Invalidamos caché para forzar request real
        await cache.invalidar(ciudad: "La Plata")

        let task = Task {
            try await servicio.obtenerClima(para: ciudadesDisponibles[0])
        }

        // Cancelamos después de 1ms — casi seguro cancela antes de recibir respuesta
        // (en producción sería un tiempo razonable según condiciones de red)
        try? await Task.sleep(nanoseconds: 1_000_000)
        task.cancel()

        do {
            let resultado = try await task.value
            print("  Resultado (llegó antes de cancelar): \(resultado.ciudad) \(resultado.temperatura)°C")
        } catch is CancellationError {
            print("  Task cancelada correctamente ✓")
        } catch {
            print("  Error: \(error)")
        }
    }

    // MARK: - Demo 5: withCheckedContinuation (API legacy)

    /// Demuestra interoperabilidad con completion handlers via continuation.
    func demoLegacy() async {
        print("\n=== DEMO 5: withCheckedContinuation (API legacy) ===\n")

        let ciudad = ciudadesDisponibles[1]
        do {
            let datos = try await servicio.obtenerClimaLegacy(para: ciudad)
            print("  [legacy] \(datos.ciudad): \(datos.temperatura)°C, \(datos.descripcion)")
        } catch {
            print("  Error legacy: \(error)")
        }
    }

    // MARK: - Helpers

    private func imprimirClima(_ datos: DatosClima) {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        let hora = formatter.string(from: datos.timestamp)

        print("""
          📍 \(datos.ciudad)
             Temp:     \(datos.temperatura)°C
             Humedad:  \(datos.humedad)%
             Viento:   \(datos.viento) km/h
             Estado:   \(datos.descripcion)
             Hora:     \(hora)
        """)
    }
}
