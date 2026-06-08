//import Testing
//@testable import ProcesadorDeDatos

//@Test func example() async throws {
    // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    // Swift Testing Documentation
    // https://developer.apple.com/documentation/testing
//}

import XCTest
@testable import ProcesadorDeDatos

final class DataProcessorTests: XCTestCase {

    let csvValido = """
    nombre,categoria,precio,stock
    Notebook,electronica,1200.50,10
    Auriculares,electronica,85.00,50
    Mesa,muebles,350.00,5
    Silla,muebles,120.00,20
    Monitor,electronica,450.00,8
    """

    let csvFilaInconsistente = """
    nombre,categoria,precio
    Notebook,electronica
    Auriculares,electronica,85.00
    """

    let csvVacio = ""

    // MARK: - CSVParser

    func testParseoExitoso() {
        let parser = CSVParser()
        let resultado = parser.parsear(csvValido)

        switch resultado {
        case .success(let registros):
            XCTAssertEqual(registros.count, 5)
            XCTAssertEqual(registros[0].valor(para: "nombre"), "Notebook")
            XCTAssertEqual(registros[0].valorDouble(para: "precio"), 1200.50)
        case .failure(let error):
            XCTFail("No debería fallar: \(error)")
        }
    }

    func testParseoCSVVacio() {
        let parser = CSVParser()
        let resultado = parser.parsear(csvVacio)

        switch resultado {
        case .success:
            XCTFail("Debería fallar con archivo vacío")
        case .failure(let error):
            if case .archivoVacio = error { } else {
                XCTFail("Error incorrecto: \(error)")
            }
        }
    }

    func testParseoFilaInconsistente() {
        let parser = CSVParser(tolerarFilasInconsistentes: false)
        let resultado = parser.parsear(csvFilaInconsistente)

        switch resultado {
        case .success:
            XCTFail("Debería fallar con fila inconsistente")
        case .failure(let error):
            if case .filaInconsistente = error { } else {
                XCTFail("Error incorrecto: \(error)")
            }
        }
    }

    func testParseoToleranteFilasInconsistentes() {
        let parser = CSVParser(tolerarFilasInconsistentes: true)
        let resultado = parser.parsear(csvFilaInconsistente)

        switch resultado {
        case .success(let registros):
            XCTAssertEqual(registros.count, 1)
        case .failure(let error):
            XCTFail("No debería fallar en modo tolerante: \(error)")
        }
    }

    // MARK: - Pipeline

    func testPipelineMapFilter() {
        let numeros = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

        let resultado = Pipeline(numeros)
            .filter { $0 % 2 == 0 }
            .map { $0 * $0 }
            .resultado()

        XCTAssertEqual(resultado, [4, 16, 36, 64, 100])
    }

    func testPipelineCompactMap() {
        let valores = ["1", "dos", "3", "cuatro", "5"]

        let resultado = Pipeline(valores)
            .compactMap { Int($0) }
            .resultado()

        XCTAssertEqual(resultado, [1, 3, 5])
    }

    // MARK: - DataOperations

    func testFiltrarPorColumna() throws {
        let parser = CSVParser()
        let registros = try parser.parsearOLanzar(csvValido)
        let filtrados = DataOperations.filtrar(registros, columna: "categoria", valor: "electronica")
        XCTAssertEqual(filtrados.count, 3)
    }

    func testAgrupar() throws {
        let parser = CSVParser()
        let registros = try parser.parsearOLanzar(csvValido)
        let grupos = DataOperations.agrupar(registros, por: "categoria")
        XCTAssertEqual(grupos["electronica"]?.count, 3)
        XCTAssertEqual(grupos["muebles"]?.count, 2)
    }

    func testResumir() throws {
        let parser = CSVParser()
        let registros = try parser.parsearOLanzar(csvValido)
        let resumenes = DataOperations.resumir(registros, columnaValor: "precio", columnaClave: "categoria")
        let electronica = resumenes.first { $0.clave == "electronica" }
        XCTAssertNotNil(electronica)
        XCTAssertEqual(electronica?.cantidad, 3)
        XCTAssertEqual(electronica?.maximo, 1200.50)
    }
}
