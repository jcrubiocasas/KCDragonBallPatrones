//
//  GetTransformationsAPIRequest.swift
//  SWPatterns
//
//  Created by Juan Carlos Rubio Casas on 2/10/24.
//

import Foundation

// MARK: - GetTransformationsAPIRequest
// Esta estructura conforma el protocolo `APIRequest` y representa una solicitud para obtener las transformaciones
// asociadas a un héroe específico.
// Define los detalles de la solicitud, como el método HTTP, el path, y el cuerpo de la solicitud.
// El tipo de respuesta (`Response`) asociado a esta solicitud es un array de objetos `Transformation`.
struct GetTransformationsAPIRequest: APIRequest {
    
    // El tipo de respuesta esperado para esta solicitud es un array de `Transformation`.
    typealias Response = [Transformation]
    
    // La ruta de la solicitud API (path) que apunta al endpoint para obtener las transformaciones de un héroe.
    let path: String = "/api/heros/tranformations"
    
    // Método HTTP que se utilizará para esta solicitud. En este caso, es `POST`.
    let method: HTTPMethod = .POST
    
    // El cuerpo de la solicitud que se enviará al servidor.
    // Es opcional y debe conformar al protocolo `Encodable`.
    let body: (any Encodable)?
    
    // Inicializa la solicitud con un identificador opcional.
    // Si se proporciona un `id`, este se incluirá en el cuerpo de la solicitud como parte de `RequestTransformationEntity`.
    // Si no se proporciona un `id`, se enviará un cuerpo con una cadena vacía.
    // - Parameter id: El identificador del héroe cuyas transformaciones se desean obtener (puede ser nil).
    init(id: String?) {
        body = RequestTransformationEntity(id: id ?? "")  // Asigna el cuerpo utilizando la entidad `RequestTransformationEntity`.
    }
}

// MARK: - RequestTransformationEntity
// Extensión privada que encapsula la estructura interna `RequestTransformationEntity` utilizada en el cuerpo de la solicitud.
// Esta estructura conforma `Encodable`, lo que permite que los datos sean codificados a JSON para ser enviados en el cuerpo de la solicitud.
// `RequestTransformationEntity` contiene un único campo: el identificador del héroe.
private extension GetTransformationsAPIRequest {
    struct RequestTransformationEntity: Encodable {
        let id: String  // Identificador del héroe para obtener sus transformaciones.
    }
}
