import Foundation

// MARK: - GetHeroesAPIRequest
// Esta estructura conforma el protocolo `APIRequest` y representa una solicitud para obtener una lista de héroes.
// Define los detalles específicos de la solicitud, como el método HTTP, el path, y el cuerpo de la solicitud.
// El tipo de respuesta (`Response`) asociado a esta solicitud es un array de objetos `Hero`.
struct GetHeroesAPIRequest: APIRequest {
    
    // El tipo de respuesta esperado para esta solicitud es un array de `Hero`.
    typealias Response = [Hero]
    
    // La ruta de la solicitud API (path) que especifica el endpoint de la API.
    // En este caso, apunta a `/api/heros/all`.
    let path: String = "/api/heros/all"
    
    // Método HTTP que se utilizará para esta solicitud. En este caso, es `POST`.
    let method: HTTPMethod = .POST
    
    // El cuerpo de la solicitud que se enviará al servidor.
    // Es opcional y debe conformar al protocolo `Encodable`.
    let body: (any Encodable)?
    
    // Inicializa la solicitud con un nombre opcional.
    // Si se proporciona un nombre, se incluirá en el cuerpo de la solicitud como parte de `RequestEntity`.
    // Si no se proporciona un nombre, se enviará un cuerpo con una cadena vacía.
    // - Parameter name: El nombre que se enviará en la solicitud para filtrar héroes (puede ser nil).
    init(name: String?) {
        body = RequestEntity(name: name ?? "")  // Asigna el cuerpo utilizando la entidad `RequestEntity`.
    }
}

// MARK: - RequestEntity
// Extensión privada que encapsula la estructura interna `RequestEntity` utilizada en el cuerpo de la solicitud.
// Esta estructura conforma `Encodable`, lo que permite que los datos sean codificados a JSON para ser enviados en el cuerpo de la solicitud.
// `RequestEntity` contiene un único campo: el nombre del héroe.
private extension GetHeroesAPIRequest {
    struct RequestEntity: Encodable {
        let name: String  // Nombre que se enviará en el cuerpo de la solicitud para filtrar los héroes.
    }
}
