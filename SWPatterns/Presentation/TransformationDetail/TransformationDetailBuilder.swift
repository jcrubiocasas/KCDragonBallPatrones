//
//  TransformationDetailBuilder.swift
//  SWPatterns
//
//  Created by Juan Carlos Rubio Casas on 5/10/24.
//

import UIKit

// MARK: - TransformationDetailBuilder
// Clase responsable de construir e inicializar la pantalla de detalle de la transformación de un héroe.
// Utiliza el patrón Builder para crear las dependencias necesarias (caso de uso, ViewModel y ViewController)
// y retornar el controlador de vista listo para ser presentado en el stack de navegación.
class TransformationDetailBuilder {
    
    // MARK: - build
    // Método estático que construye y configura la pantalla de detalle de la transformación de un héroe.
    // Crea las dependencias necesarias (caso de uso, ViewModel y ViewController) e inserta el ViewController
    // resultante en el stack de navegación proporcionado.
    // - Parameters:
    //   - heroId: El identificador del héroe cuyo detalle de transformación se va a mostrar.
    //   - transformationId: El identificador de la transformación que se va a mostrar.
    //   - navigationController: El `UINavigationController` donde se empujará la vista de detalle.
    static func build(with heroId: String,
                      transformationId: String,
                      in navigationController: UINavigationController?) {
        
        // Creación del caso de uso para obtener las transformaciones.
        let transformationsUseCase = GetAllTransformationsUseCase()
        
        // Inicialización del ViewModel con el `heroId`, `transformationId`, y el caso de uso.
        let viewModel = TransformationDetailViewModel(heroId: heroId,
                                                      transformationId: transformationId,
                                                      transformationUseCase: transformationsUseCase)
        
        // Creación del ViewController para mostrar el detalle de la transformación.
        let viewController = TransformationDetailViewController(viewModel: viewModel)
        
        // Empuja el ViewController al stack de navegación proporcionado.
        navigationController?.pushViewController(viewController, animated: true)
    }
}
