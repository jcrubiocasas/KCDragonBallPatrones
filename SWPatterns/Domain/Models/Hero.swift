// MARK: - Hero
// Esta estructura representa un héroe y conforma los protocolos `Equatable`, `Encodable` y `Decodable`.
// Define las propiedades básicas de un héroe, como su identificador, nombre, descripción, foto y si es un favorito.
// También personaliza el mapeo entre los nombres de las propiedades y las claves del JSON mediante la enumeración `CodingKeys`.
struct Hero: Equatable, Encodable, Decodable {
    
    // Identificador único del héroe.
    let identifier: String
    
    // Nombre del héroe.
    let name: String
    
    // Descripción del héroe.
    let description: String
    
    // URL o nombre de archivo de la imagen o foto del héroe.
    let photo: String
    
    // Indica si el héroe es marcado como favorito por el usuario.
    let favorite: Bool
    
    // MARK: - CodingKeys
    // Enumeración que define las claves utilizadas para codificar y decodificar las propiedades en JSON.
    // Esto permite personalizar cómo las propiedades del objeto se mapearán a las claves del JSON.
    enum CodingKeys: String, CodingKey {
        case identifier = "id"  // Mapea `identifier` a la clave `id` en el JSON.
        case name                // `name` se mapea directamente.
        case description         // `description` se mapea directamente.
        case photo               // `photo` se mapea directamente.
        case favorite            // `favorite` se mapea directamente.
    }
}
