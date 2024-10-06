//
//  GetHeroUseCase.swift
//  SWPatterns
//
//  Created by Juan Carlos Rubio Casas on 3/10/24.
//

import Foundation

// MARK: - GetHeroUseCaseContract
// Protocolo que define el contrato para el caso de uso `GetHeroUseCase`.
// Este protocolo requiere que cualquier clase que lo implemente proporcione una función para obtener un héroe específico basado en su nombre.
protocol GetHeroUseCaseContract {
    // Método que ejecuta la solicitud para obtener un héroe por su nombre.
    // - Parameters:
    //   - heroName: El nombre del héroe que se desea buscar.
    //   - completion: Bloque de completado que devuelve el héroe encontrado o un error si no se encuentra o si ocurre un fallo.
    func execute(heroName: String, completion: @escaping (Result<Hero, Error>) -> Void)
}

// MARK: - GetHeroUseCase
// Clase que implementa el caso de uso `GetHeroUseCaseContract`.
// Se encarga de buscar un héroe específico por su nombre realizando una solicitud a la API y filtrando los resultados.
final class GetHeroUseCase: GetHeroUseCaseContract {
    
    // Propiedad privada que almacena una referencia a `GetAllHeroesUseCaseContract`,
    // lo que permite obtener una lista de todos los héroes para filtrar por nombre.
    private let getAllHeroesUseCase: GetAllHeroesUseCaseContract
    
    // Inicializador que permite inyectar una implementación personalizada de `GetAllHeroesUseCaseContract`.
    // Si no se proporciona, se usa la implementación por defecto (`GetAllHeroesUseCase`).
    // - Parameter getAllHeroUseCase: Caso de uso que permite obtener la lista de héroes.
    init(getAllHeroUseCase: GetAllHeroesUseCaseContract = GetAllHeroesUseCase()) {
        self.getAllHeroesUseCase = getAllHeroUseCase
    }
    
    // MARK: - execute
    // Método que ejecuta la búsqueda de un héroe específico por su nombre.
    // Realiza la solicitud para obtener los héroes y luego filtra el resultado para encontrar el héroe buscado.
    // - Parameters:
    //   - heroName: El nombre del héroe que se desea buscar.
    //   - completion: Bloque de completado que devuelve el héroe encontrado o un error si no se encuentra.
    func execute(heroName: String, completion: @escaping (Result<Hero, Error>) -> Void) {
        // Realiza la solicitud a la API para obtener la lista de héroes.
        GetHeroesAPIRequest(name: heroName).perform { result in
            do {
                // Intenta obtener la lista de héroes de la respuesta.
                let heroes = try result.get()
                
                // Filtra el héroe específico basado en el nombre proporcionado.
                if let hero = heroes.first(where: { $0.name == heroName }) {
                    // Si se encuentra el héroe, se devuelve como éxito en el bloque de completado.
                    completion(.success(hero))
                } else {
                    // Si no se encuentra el héroe, se devuelve un error personalizado.
                    let error = NSError(domain: "HeroNotFound", code: 404, userInfo: [NSLocalizedDescriptionKey: "Hero not found"])
                    completion(.failure(error))
                }
            } catch {
                // Si ocurre un error en la solicitud o la decodificación, se devuelve el error al bloque de completado.
                completion(.failure(error))
            }
        }
    }
}
