//
//  TransformationsListViewModel.swift
//  SWPatterns
//
//  Created by Juan Carlos Rubio Casas on 5/10/24.
//

import Foundation

// MARK: - TransformationsListState
// Enum que define los diferentes estados posibles del `TransformationsListViewModel`.
// Refleja el ciclo de vida de la carga de las transformaciones.
enum TransformationsListState: Equatable {
    case loading   // Estado cuando las transformaciones están siendo cargadas.
    case error(reason: String)   // Estado cuando ocurre un error, con una razón proporcionada.
    case success   // Estado cuando las transformaciones se han cargado correctamente.
}

// MARK: - TransformationsListViewModel
// ViewModel responsable de manejar la lógica de negocio para la pantalla de lista de transformaciones.
// Utiliza un mecanismo de binding para notificar a la vista sobre los cambios de estado (loading, success, error).
final class TransformationsListViewModel {
    
    // MARK: - Propiedades
    // `onStateChanged` es un binding que se usa para notificar a la vista cuando el estado cambia.
    let onStateChanged = Binding<TransformationsListState>()
    
    // Lista de transformaciones cargadas.
    private(set) var transformations: [Transformation] = []
    
    // Caso de uso para obtener las transformaciones.
    private let useCase: GetAllTransformationsUseCaseContract
    
    // Identificador del héroe cuyas transformaciones se van a cargar.
    let heroId: String
    
    // MARK: - Inicialización
    // Inicializa el ViewModel con el caso de uso y el identificador del héroe.
    // - Parameters:
    //   - useCase: El caso de uso que maneja la lógica de obtener las transformaciones.
    //   - heroId: El identificador del héroe cuyas transformaciones se van a cargar.
    init(useCase: GetAllTransformationsUseCaseContract, heroId: String) {
        self.useCase = useCase
        self.heroId = heroId
    }
    
    // MARK: - Carga de datos
    // Método que inicia la carga de las transformaciones para un héroe específico.
    // Actualiza el estado a `loading` al iniciar la carga, y a `success` o `error` dependiendo del resultado.
    func load() {
        // Actualiza el estado a `loading` mientras se están cargando las transformaciones.
        onStateChanged.update(newValue: .loading)
        
        // Ejecuta el caso de uso para obtener las transformaciones del héroe.
        useCase.execute(identificator: heroId) { [weak self] result in
            guard let self = self else { return }
            
            do {
                // Si el resultado es exitoso, asigna las transformaciones.
                self.transformations = try result.get()
                
                // Ordena las transformaciones según el número al inicio del nombre.
                self.transformations.sort { extractLeadingNumber(from: $0.name) < extractLeadingNumber(from: $1.name) }
                
                // Actualiza el estado a `success` después de cargar y ordenar las transformaciones.
                self.onStateChanged.update(newValue: .success)
            } catch {
                // Si ocurre un error, actualiza el estado a `error` con la descripción del error.
                self.onStateChanged.update(newValue: .error(reason: error.localizedDescription))
            }
        }
    }
}
