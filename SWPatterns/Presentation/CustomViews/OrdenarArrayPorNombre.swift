//
//  OrdenarArrayPorNombre.swift
//  SWPatterns
//
//  Created by Juan Carlos Rubio Casas on 6/10/24.
//

import Foundation

// MARK: - extractLeadingNumber
// Función que extrae el número que aparece al principio de una cadena.
// Esta función es útil para ordenar cadenas que empiezan con un número seguido de texto (por ejemplo, "1. Oozaru – Gran Mono").
// Si no hay un número al principio, la función devuelve `Int.max`, lo que permite que las cadenas sin número
// sean ordenadas al final en un contexto de clasificación.
func extractLeadingNumber(from name: String) -> Int {
    // Divide la cadena en componentes separados por espacios.
    // Por ejemplo, "1. Oozaru – Gran Mono" se convierte en ["1.", "Oozaru", "–", "Gran", "Mono"].
    let components = name.split(separator: " ")
    
    // Intenta obtener el primer componente de la cadena (el posible número con un punto).
    if let firstComponent = components.first,
       // Reemplaza el punto final del número (por ejemplo, "1." se convierte en "1").
       let number = Int(firstComponent.replacingOccurrences(of: ".", with: "")) {
        // Si la conversión a número es exitosa, devuelve ese número.
        return number
    }
    
    // Si no se puede encontrar un número válido al principio de la cadena, devuelve `Int.max`.
    // Esto asegura que las cadenas sin número al principio se ordenen al final cuando se comparan en una lista.
    return Int.max
}
