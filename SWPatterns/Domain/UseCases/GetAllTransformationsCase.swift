//
//  GetAllTransformationsUseCase.swift
//  SWPatterns
//
//  Created by Juan Carlos Rubio Casas on 2/10/24.
//

import Foundation

// MARK: - GetAllTransformationsUseCaseContract
// Protocolo que define el contrato para el caso de uso `GetAllTransformationsUseCase`.
// Cualquier clase que implemente este protocolo debe proporcionar la función `execute`,
// que se encargará de obtener todas las transformaciones asociadas a un héroe y devolver el resultado mediante un bloque de completado.
protocol GetAllTransformationsUseCaseContract {
    // Método que ejecuta la solicitud para obtener todas las transformaciones de un héroe.
    // - Parameters:
    //   - identificator: El identificador del héroe cuyas transformaciones se desean obtener.
    //   - completion: Bloque de completado que devuelve el resultado de la operación.
    //                 El resultado puede ser un array de transformaciones en caso de éxito, o un error en caso de fallo.
    func execute(identificator: String, completion: @escaping (Result<[Transformation], Error>) -> Void)
}

// MARK: - GetAllTransformationsUseCase
// Clase que implementa el caso de uso `GetAllTransformationsUseCaseContract`.
// Se encarga de gestionar la lógica para obtener todas las transformaciones de un héroe desde la API.
// Utiliza la solicitud `GetTransformationsAPIRequest` para realizar la llamada al servidor y manejar la respuesta.
final class GetAllTransformationsUseCase: GetAllTransformationsUseCaseContract {
    
    // MARK: - execute
    // Método que ejecuta la solicitud para obtener todas las transformaciones asociadas a un héroe.
    // Utiliza `GetTransformationsAPIRequest` para realizar la solicitud y gestionar la respuesta o error devuelto por la API.
    // - Parameters:
    //   - identificator: El identificador del héroe cuyas transformaciones se desean obtener.
    //   - completion: Bloque de completado que devuelve el resultado de la operación:
    //                 una lista de transformaciones o un error.
    func execute(identificator: String,
                 completion: @escaping (Result<[Transformation], any Error>) -> Void) {
        // Crea una instancia de la solicitud `GetTransformationsAPIRequest` con el identificador del héroe.
        GetTransformationsAPIRequest(id: identificator)
           .perform { result in
                do {
                    // Intenta obtener el resultado exitoso y llama al bloque de completado con la lista de transformaciones.
                    try completion(.success(result.get()))
                } catch {
                    // Si ocurre un error, lo pasa al bloque de completado.
                    completion(.failure(error))
                }
            }
    }
}
