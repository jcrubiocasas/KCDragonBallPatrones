//
//  Transformation.swift
//  SWPatterns
//
//  Created by Juan Carlos Rubio Casas on 2/10/24.
//

// MARK: - Transformation
// Esta estructura representa una transformación de un héroe en la aplicación.
// Conforma los protocolos `Equatable`, `Encodable` y `Decodable`, lo que permite comparar, codificar y decodificar
// instancias de `Transformation` a y desde JSON.
// Define las propiedades clave que describen una transformación, como su identificador, foto, nombre y descripción.
struct Transformation: Equatable, Encodable, Decodable {
    
    // Identificador único de la transformación.
    let identifier: String
    
    // URL o nombre de archivo de la imagen o foto de la transformación.
    let photo: String
    
    // Nombre de la transformación.
    let name: String
    
    // Descripción que proporciona detalles adicionales sobre la transformación.
    let description: String
    
    // MARK: - CodingKeys
    // Enumeración que define las claves utilizadas para codificar y decodificar las propiedades en JSON.
    // Permite personalizar cómo las propiedades del objeto se mapean a las claves del JSON.
    enum CodingKeys: String, CodingKey {
        case identifier = "id"  // Mapea `identifier` a la clave `id` en el JSON.
        case photo               // `photo` se mapea directamente.
        case name                // `name` se mapea directamente.
        case description         // `description` se mapea directamente.
    }
}
