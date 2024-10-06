//
//  TransformationsListBuilder.swift
//  SWPatterns
//
//  Created by Juan Carlos Rubio Casas on 5/10/24.
//

import UIKit

// MARK: - TransformationsListBuilder
// Clase responsable de construir e inicializar la pantalla que muestra la lista de transformaciones de un héroe.
// Utiliza el patrón Builder para crear las dependencias necesarias (caso de uso, ViewModel y ViewController)
// y retornar el controlador de vista listo para ser presentado.
final class TransformationsListBuilder {
    
    // MARK: - build
    // Método que construye y configura la pantalla de lista de transformaciones de un héroe.
    // Crea las dependencias necesarias (caso de uso, ViewModel y ViewController) para manejar la lógica de negocio y la vista.
    // - Parameter heroId: El identificador del héroe cuyas transformaciones se van a mostrar.
    // - Returns: Un `UIViewController` configurado para manejar la lista de transformaciones.
    func build(with heroId: String) -> UIViewController {
        
        // Crea el caso de uso responsable de obtener las transformaciones del héroe.
        let useCase = GetAllTransformationsUseCase()
        
        // Inicializa el ViewModel de la lista de transformaciones, inyectando el caso de uso y el heroId.
        let viewModel = TransformationsListViewModel(useCase: useCase, heroId: heroId)
        
        // Crea el ViewController para mostrar la lista de transformaciones, inyectando el ViewModel.
        let viewController = TransformationsViewController(viewModel: viewModel)
        
        // Retorna el ViewController configurado.
        return viewController
    }
}
