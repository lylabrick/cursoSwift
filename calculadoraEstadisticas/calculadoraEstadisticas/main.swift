//
//  main.swift
//  calculadoraEstadisticas
//
//  Created by Lylabrick on 05/05/2026.
//

import Foundation

print("--- Calculadora de Estadísticas ---")
print("Ingresa los números separados por espacios (ej: 10 20 30.5):")

//Leemos la Línea de la consola

if let entrada = readLine(){
    // Convertimos el string en un array de números Double
    let numeros = entrada.split(separator: " ").compactMap(Double($0))
    
    if numeros.isEmpty {
        print("No ingresaste números válidos")
    } else {
        let suma = numeros.reduce(0, +)
        let promedio = 
        
    }
    
    
}


