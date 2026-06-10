//
//  Models.swift
//  ClienteDeConsola
//
//  Created by Lylabrick on 10/06/2026.
//

import Foundation

// MARK: - Ciudades disponibles

struct Ciudad {
    let nombre: String
    let latitud: Double
    let longitud: Double
}

let ciudadesDisponibles: [Ciudad] = [
    Ciudad(nombre: "La Plata",      latitud: -34.9215, longitud: -57.9545),
    Ciudad(nombre: "Buenos Aires",  latitud: -34.6037, longitud: -58.3816),
    Ciudad(nombre: "Córdoba",       latitud: -31.4201, longitud: -64.1888),
    Ciudad(nombre: "Rosario",       latitud: -32.9468, longitud: -60.6393),
    Ciudad(nombre: "Mendoza",       latitud: -32.8908, longitud: -68.8272),
]

// MARK: - Respuesta de Open-Meteo

struct OpenMeteoResponse: Codable {
    let latitude: Double
    let longitude: Double
    let current: CurrentWeather

    enum CodingKeys: String, CodingKey {
        case latitude
        case longitude
        case current
    }
}

struct CurrentWeather: Codable {
    let temperature2m: Double
    let relativeHumidity2m: Int
    let windSpeed10m: Double
    let weatherCode: Int

    enum CodingKeys: String, CodingKey {
        case temperature2m       = "temperature_2m"
        case relativeHumidity2m  = "relative_humidity_2m"
        case windSpeed10m        = "wind_speed_10m"
        case weatherCode         = "weather_code"
    }
}

// MARK: - Modelo de dominio

struct DatosClima {
    let ciudad: String
    let temperatura: Double
    let humedad: Int
    let viento: Double
    let descripcion: String
    let timestamp: Date

    /// Convierte el WMO weather code a descripción legible
    static func descripcionDesdeCode(_ code: Int) -> String {
        switch code {
        case 0:           return "Despejado"
        case 1, 2, 3:    return "Parcialmente nublado"
        case 45, 48:     return "Niebla"
        case 51, 53, 55: return "Llovizna"
        case 61, 63, 65: return "Lluvia"
        case 71, 73, 75: return "Nieve"
        case 80, 81, 82: return "Lluvias dispersas"
        case 95:         return "Tormenta"
        default:         return "Condición desconocida (code: \(code))"
        }
    }
}

// MARK: - Errores

enum WeatherError: Error {
    case urlInvalida
    case respuestaInvalida(Int)
    case decodingFallido(String)
    case timeout
    case cancelado
}
