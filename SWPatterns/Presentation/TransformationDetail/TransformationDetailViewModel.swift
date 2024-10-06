//
//  TransformationDetailViewModel.swift
//  SWPatterns
//
//  Created by Juan Carlos Rubio Casas on 5/10/24.
//

import Foundation

// MARK: - TransformationDetailState
// Enum que define los diferentes estados posibles para el `TransformationDetailViewModel`.
// Refleja el ciclo de vida de la carga de los detalles de la transformación.
enum TransformationDetailState: Equatable {
    case loading   // Estado cuando los detalles de la transformación están siendo cargados.
    case error(reason: String)   // Estado cuando ocurre un error, con una razón proporcionada.
    case success   // Estado cuando los detalles de la transformación se han cargado correctamente.
}

// MARK: - TransformationDetailViewModel
// ViewModel responsable de manejar la lógica de negocio para la pantalla de detalle de la transformación.
// Utiliza un mecanismo de binding para notificar a la vista sobre los cambios de estado (loading, success, error).
final class TransformationDetailViewModel {
    
    // MARK: - Propiedades
    // `onStateChanged` es un binding que se usa para notificar a la vista cuando el estado cambia.
    let onStateChanged = Binding<TransformationDetailState>()
    
    // Variables que contienen los datos de las transformaciones y la transformación específica.
    private(set) var transformations: [Transformation]?
    var transformation: Transformation?
    
    // Casos de uso necesarios para obtener las transformaciones.
    private let transformationUseCase: GetAllTransformationsUseCaseContract
    
    // Identificadores del héroe y la transformación.
    private let heroId: String
    private let transformationId: String
    
    // MARK: - Inicialización
    // Inicializa el ViewModel con los identificadores del héroe y la transformación, así como el caso de uso necesario.
    // - Parameters:
    //   - heroId: Identificador del héroe cuyas transformaciones se van a cargar.
    //   - transformationId: Identificador de la transformación específica a mostrar.
    //   - transformationUseCase: Caso de uso para obtener las transformaciones.
    init(heroId: String,
         transformationId: String,
         transformationUseCase: GetAllTransformationsUseCaseContract) {
        self.heroId = heroId
        self.transformationId = transformationId
        self.transformationUseCase = transformationUseCase
    }
    
    // MARK: - Carga de datos
    // Método que inicia la carga de las transformaciones para un héroe específico.
    // Actualiza el estado a `loading` al iniciar la carga, y a `success` o `error` dependiendo del resultado.
    func load() {
        // Actualiza el estado a `loading` mientras se están cargando las transformaciones.
        onStateChanged.update(newValue: .loading)
        
        // Ejecuta el caso de uso para obtener las transformaciones del héroe.
        transformationUseCase.execute(identificator: heroId) { [weak self] result in
            guard let self = self else { return }
            
            // Maneja el resultado de la solicitud de transformaciones.
            switch result {
            case .success(let transformations):
                self.transformations = transformations
                
                // Busca la transformación específica usando el `transformationId`.
                if let transformation = transformations.first(where: { $0.identifier == self.transformationId }) {
                    self.transformation = transformation
                    // Si se encuentra la transformación, actualiza el estado a `success`.
                    self.onStateChanged.update(newValue: .success)
                } else {
                    // Si la transformación no se encuentra, actualiza el estado a `error`.
                    self.onStateChanged.update(newValue: .error(reason: "Transformation not found"))
                }
                
            case .failure(let error):
                // Si ocurre un error al obtener las transformaciones, actualiza el estado a `error`.
                self.onStateChanged.update(newValue: .error(reason: error.localizedDescription))
            }
        }
    }
}
