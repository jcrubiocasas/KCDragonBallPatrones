//
//  HeroDetailViewModel.swift
//  SWPatterns
//
//  Created by Juan Carlos Rubio Casas on 2/10/24.
//

import Foundation

// MARK: - HeroDetailState
// Enum que define los diferentes estados posibles del `HeroDetailViewModel`.
// Estos estados reflejan el ciclo de vida de la carga de los datos y se utilizan para actualizar la interfaz de usuario.
enum HeroDetailState: Equatable {
    case loading   // El estado cuando los datos están siendo cargados.
    case error(reason: String)  // El estado cuando ocurre un error, con una razón proporcionada.
    case success   // El estado cuando los datos se han cargado correctamente.
}

// MARK: - HeroDetailViewModel
// ViewModel responsable de manejar la lógica de negocio para la pantalla de detalles del héroe.
// Este ViewModel se comunica con los casos de uso para obtener los datos del héroe y sus transformaciones,
// y actualiza la interfaz de usuario a través de un mecanismo de binding.
final class HeroDetailViewModel {
    
    // MARK: - Propiedades
    // `onStateChanged` es un binding que se usa para notificar a la vista cuando el estado cambia (loading, success, error).
    let onStateChanged = Binding<HeroDetailState>()
    
    // Lista de héroes obtenida del caso de uso.
    private(set) var heroes: [Hero]?
    
    // Héroe seleccionado que se mostrará en la vista.
    var hero: Hero?
    
    // Caso de uso para obtener todos los héroes.
    private let heroUseCase: GetAllHeroesUseCaseContract
    
    // Nombre del héroe a buscar.
    private let heroName: String
    
    // Lista de transformaciones del héroe seleccionado.
    private(set) var transformations: [Transformation]?
    
    // Caso de uso para obtener las transformaciones del héroe.
    private let transformationUseCase: GetAllTransformationsUseCaseContract
    
    // MARK: - Inicialización
    // Inicializa el ViewModel con los casos de uso necesarios y el nombre del héroe.
    // - Parameters:
    //   - heroName: El nombre del héroe cuyos detalles se van a cargar.
    //   - heroUseCase: Caso de uso para obtener los datos del héroe.
    //   - transformationUseCase: Caso de uso para obtener las transformaciones del héroe.
    init(heroName: String,
         heroUseCase: GetAllHeroesUseCaseContract,
         transformationUseCase: GetAllTransformationsUseCaseContract) {
        self.heroName = heroName
        self.heroUseCase = heroUseCase
        self.transformationUseCase = transformationUseCase
    }
    
    // MARK: - Carga de datos
    // Método que inicia la carga de los datos del héroe y sus transformaciones.
    // Primero carga la lista de héroes, luego busca el héroe por nombre y finalmente carga sus transformaciones.
    func load() {
        onStateChanged.update(newValue: .loading)  // Actualiza el estado a `loading`.
        
        // Ejecuta el caso de uso para obtener la lista de héroes.
        heroUseCase.execute() { [weak self] result in
            guard let self = self else { return }
            
            // Maneja el resultado de la solicitud de héroes.
            switch result {
            case .success(let heroes):
                self.heroes = heroes
                
                // Busca el héroe por su nombre.
                if let hero = heroes.first(where: { $0.name == self.heroName }) {
                    self.hero = hero
                    // Una vez encontrado el héroe, carga las transformaciones.
                    self.loadTransformations()
                    self.onStateChanged.update(newValue: .success)
                } else {
                    // Si el héroe no se encuentra, actualiza el estado con un error.
                    self.onStateChanged.update(newValue: .error(reason: "Hero not found"))
                }
                
            case .failure(let error):
                // Si ocurre un error en la solicitud, actualiza el estado con el mensaje de error.
                self.onStateChanged.update(newValue: .error(reason: error.localizedDescription))
            }
        }
    }
    
    // MARK: - Carga de transformaciones
    // Método que carga las transformaciones del héroe seleccionado.
    private func loadTransformations() {
        guard let heroId = self.hero?.identifier else {
            // Si no se encuentra el identificador del héroe, actualiza el estado con un error.
            self.onStateChanged.update(newValue: .error(reason: "Hero ID not found"))
            return
        }
        
        // Ejecuta el caso de uso para obtener las transformaciones del héroe.
        transformationUseCase.execute(identificator: heroId) { [weak self] transformationResult in
            guard let self = self else { return }
            
            // Maneja el resultado de la solicitud de transformaciones.
            do {
                // Si la solicitud es exitosa, guarda las transformaciones y actualiza el estado a `success`.
                self.transformations = try transformationResult.get()
                print("Hero = \(String(describing: self.hero?.name)) - Transformations = \(self.transformations?.count ?? 0)")
                
                // Actualiza el estado a `success` después de obtener las transformaciones.
                self.onStateChanged.update(newValue: .success)
            } catch {
                // Si ocurre un error al obtener las transformaciones, actualiza el estado con un mensaje de error.
                self.onStateChanged.update(newValue: .error(reason: error.localizedDescription))
            }
        }
    }
}
