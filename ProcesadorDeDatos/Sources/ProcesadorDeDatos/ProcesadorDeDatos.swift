// The Swift Programming Language
// https://docs.swift.org/swift-book

@main
struct ProcesadorDeDatos {
    static func main() {
        let csv = """
        nombre,categoria,precio,stock
        Notebook,electronica,1200.50,10
        Auriculares,electronica,85.00,50
        Mesa,muebles,350.00,5
        Silla,muebles,120.00,20
        Monitor,electronica,450.00,8
        """

        let parser = CSVParser()

        switch parser.parsear(csv) {
        case .success(let registros):
            print("Registros parseados: \(registros.count)")

            let caros = Pipeline(registros)
                .filter { $0.valorDouble(para: "precio") ?? 0 > 100 }
                .sorted { ($0.valorDouble(para: "precio") ?? 0) > ($1.valorDouble(para: "precio") ?? 0) }
                .resultado()

            print("\nProductos con precio > 100, ordenados:")
            caros.forEach { print("  \($0.valor(para: "nombre") ?? "") - $\($0.valor(para: "precio") ?? "")") }

            let resumenes = DataOperations.resumir(registros, columnaValor: "precio", columnaClave: "categoria")
            print("\nResúmenes por categoría:")
            resumenes.forEach { print($0.descripcion) }

        case .failure(let error):
            print("Error al parsear: \(error)")
        }
    }
}
