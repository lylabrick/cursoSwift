// The Swift Programming Language
// https://docs.swift.org/swift-book

@main
struct ClienteDeConsola {
    static func main() async {
        let cache = WeatherCache(ttlSegundos: 300)
        let servicio = WeatherService(cache: cache, timeoutSegundos: 8)
        let cliente = ConsoleClient(servicio: servicio, cache: cache)

        await cliente.demoPararelo()
        await cliente.demoTaskGroup()
        await cliente.demoCacheHit()
        await cliente.demoCancelacion()
        await cliente.demoLegacy()

        print("\n=== Fin del programa ===\n")
    }
}

