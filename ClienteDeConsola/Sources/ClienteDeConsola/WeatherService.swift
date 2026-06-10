//
//  WeatherService.swift
//  ClienteDeConsola
//
//  Created by Lylabrick on 10/06/2026.
//

import Foundation

/// Servicio de clima que consume Open-Meteo con async/await.
/// Interopera con la caché via actor y maneja timeout y cancelación.
struct WeatherService {

    private let cache: WeatherCache
    private let timeoutSegundos: TimeInterval
    private let session: URLSession

    init(cache: WeatherCache, timeoutSegundos: TimeInterval = 8) {
        self.cache = cache
        self.timeoutSegundos = timeoutSegundos

        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = timeoutSegundos
        self.session = URLSession(configuration: config)
    }

    // MARK: - Fetch principal

    /// Obtiene el clima de una ciudad. Usa caché si hay datos válidos.
    func obtenerClima(para ciudad: Ciudad) async throws -> DatosClima {
        // 1. Revisar caché
        if let cached = await cache.obtener(para: ciudad.nombre) {
            print("  [caché] \(ciudad.nombre) — usando datos guardados")
            return cached
        }

        // 2. Chequear cancelación antes de hacer red
        try Task.checkCancellation()

        // 3. Construir URL
        guard let url = construirURL(latitud: ciudad.latitud, longitud: ciudad.longitud) else {
            throw WeatherError.urlInvalida
        }

        print("  [red]   \(ciudad.nombre) — realizando request...")

        // 4. Ejecutar request con manejo de cancelación
        let datos: DatosClima = try await withTaskCancellationHandler {
            try await fetchYDecodear(url: url, ciudad: ciudad)
        } onCancel: {
            print("  [cancel] Task cancelada para \(ciudad.nombre)")
        }

        // 5. Guardar en caché
        await cache.guardar(datos, para: ciudad.nombre)

        return datos
    }

    // MARK: - Fetch con callback legacy (withCheckedContinuation)

    /// Versión que usa withCheckedContinuation para interoperar
    /// con una API basada en completion handler (simula una dependencia legacy).
    func obtenerClimaLegacy(para ciudad: Ciudad) async throws -> DatosClima {
        guard let url = construirURL(latitud: ciudad.latitud, longitud: ciudad.longitud) else {
            throw WeatherError.urlInvalida
        }

        return try await withCheckedThrowingContinuation { continuation in
            // Simulación de API legacy con completion handler
            session.dataTask(with: url) { data, response, error in
                if let error = error {
                    if (error as NSError).code == NSURLErrorCancelled {
                        continuation.resume(throwing: WeatherError.cancelado)
                    } else {
                        continuation.resume(throwing: error)
                    }
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    let code = (response as? HTTPURLResponse)?.statusCode ?? -1
                    continuation.resume(throwing: WeatherError.respuestaInvalida(code))
                    return
                }

                guard let data = data else {
                    continuation.resume(throwing: WeatherError.decodingFallido("Sin datos"))
                    return
                }

                do {
                    let meteoResponse = try JSONDecoder().decode(OpenMeteoResponse.self, from: data)
                    let datos = mapearRespuesta(meteoResponse, ciudad: ciudad.nombre)
                    continuation.resume(returning: datos)
                } catch {
                    continuation.resume(throwing: WeatherError.decodingFallido(error.localizedDescription))
                }
            }.resume()
        }
    }

    // MARK: - Privados

    private func fetchYDecodear(url: URL, ciudad: Ciudad) async throws -> DatosClima {
        let (data, response) = try await session.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw WeatherError.respuestaInvalida(-1)
        }

        guard httpResponse.statusCode == 200 else {
            throw WeatherError.respuestaInvalida(httpResponse.statusCode)
        }

        do {
            let meteoResponse = try JSONDecoder().decode(OpenMeteoResponse.self, from: data)
            return mapearRespuesta(meteoResponse, ciudad: ciudad.nombre)
        } catch {
            throw WeatherError.decodingFallido(error.localizedDescription)
        }
    }

    private func construirURL(latitud: Double, longitud: Double) -> URL? {
        var components = URLComponents(string: "https://api.open-meteo.com/v1/forecast")
        components?.queryItems = [
            URLQueryItem(name: "latitude",               value: String(latitud)),
            URLQueryItem(name: "longitude",              value: String(longitud)),
            URLQueryItem(name: "current",                value: "temperature_2m,relative_humidity_2m,wind_speed_10m,weather_code"),
            URLQueryItem(name: "wind_speed_unit",        value: "kmh"),
            URLQueryItem(name: "timezone",               value: "America/Argentina/Buenos_Aires"),
        ]
        return components?.url
    }
}

// MARK: - Mapping libre de self

private func mapearRespuesta(_ response: OpenMeteoResponse, ciudad: String) -> DatosClima {
    DatosClima(
        ciudad: ciudad,
        temperatura: response.current.temperature2m,
        humedad: response.current.relativeHumidity2m,
        viento: response.current.windSpeed10m,
        descripcion: DatosClima.descripcionDesdeCode(response.current.weatherCode),
        timestamp: Date()
    )
}
