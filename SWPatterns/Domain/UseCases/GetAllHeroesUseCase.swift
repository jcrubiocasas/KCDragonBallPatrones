import Foundation

// MARK: - GetAllHeroesUseCaseContract
// Protocolo que define el contrato para el caso de uso `GetAllHeroesUseCase`.
// Cualquier clase que implemente este protocolo debe proporcionar la función `execute`,
// que se encargará de obtener una lista de héroes y devolver el resultado mediante un bloque de completado.
protocol GetAllHeroesUseCaseContract {
    // Método que ejecuta la solicitud para obtener todos los héroes.
    // - Parameter completion: Bloque de completado que devuelve el resultado de la operación.
    //                         El resultado puede ser un array de héroes en caso de éxito, o un error en caso de fallo.
    func execute(completion: @escaping (Result<[Hero], Error>) -> Void)
}

// MARK: - GetAllHeroesUseCase
// Clase que implementa el caso de uso `GetAllHeroesUseCaseContract`.
// Se encarga de gestionar la lógica para obtener todos los héroes desde la API utilizando una sesión de API proporcionada.
// Esta clase usa la solicitud `GetHeroesAPIRequest` para realizar la llamada al servidor y manejar la respuesta.
final class GetAllHeroesUseCase: GetAllHeroesUseCaseContract {
    
    // Propiedad privada que almacena la sesión de API utilizada para realizar las solicitudes de red.
    private let apiSession: APISessionContract
    
    // Inicializador que permite inyectar una sesión de API personalizada.
    // Si no se proporciona una sesión, se usa la sesión compartida (`APISession.shared`) por defecto.
    // - Parameter apiSession: Una instancia de `APISessionContract` que gestionará las solicitudes de red.
    init(apiSession: APISessionContract = APISession.shared) {
        self.apiSession = apiSession
    }
    
    // MARK: - execute
    // Método que ejecuta la solicitud para obtener todos los héroes.
    // Utiliza `GetHeroesAPIRequest` para realizar la solicitud y gestiona la respuesta o error devuelto por la API.
    // - Parameter completion: Bloque de completado que devuelve el resultado de la operación:
    //                         una lista de héroes o un error.
    func execute(completion: @escaping (Result<[Hero], any Error>) -> Void) {
        // Crea una instancia de la solicitud `GetHeroesAPIRequest` y la ejecuta.
        GetHeroesAPIRequest(name: "")
            .perform { result in
                do {
                    // Intenta obtener el resultado exitoso y llama al bloque de completado con la lista de héroes.
                    try completion(.success(result.get()))
                } catch {
                    // Si ocurre un error, lo pasa al bloque de completado.
                    completion(.failure(error))
                }
            }
    }
}
