//
//  HeroDetailBuilder.swift
//  SWPatterns
//
//  Created by Juan Carlos Rubio Casas on 2/10/24.
//

import UIKit

// MARK: - HeroDetailBuilder
// Clase responsable de construir e inicializar la pantalla de detalle del héroe.
// Este patrón de construcción permite la creación de la vista y el viewModel con sus respectivas dependencias,
// y la configuración de la navegación dentro de la aplicación.
class HeroDetailBuilder {
    
    // MARK: - build
    // Método estático que se encarga de construir y configurar la pantalla de detalle de un héroe.
    // Este método inicializa los casos de uso necesarios, el ViewModel, y la vista correspondiente,
    // luego empuja la vista al stack de navegación.
    // - Parameters:
    //   - heroName: El nombre del héroe que se desea mostrar en el detalle.
    //   - navigationController: El controlador de navegación donde se empujará la vista de detalle.
    static func build(with heroName: String, in navigationController: UINavigationController?) {
        
        // Inicializa el caso de uso para obtener todos los héroes.
        let heroUseCase = GetAllHeroesUseCase()
        
        // Inicializa el caso de uso para obtener todas las transformaciones del héroe.
        let transformationUseCase = GetAllTransformationsUseCase()
        
        // Crea el ViewModel de la pantalla de detalle, inyectando los casos de uso necesarios.
        let viewModel = HeroDetailViewModel(heroName: heroName,
                                            heroUseCase: heroUseCase,
                                            transformationUseCase: transformationUseCase)
        
        // Crea el ViewController de detalle del héroe, inyectando el ViewModel correspondiente.
        let viewController = HeroDetailViewController(viewModel: viewModel)
        
        // Empuja la vista del detalle del héroe al stack de navegación, animando la transición.
        navigationController?.pushViewController(viewController, animated: true)
    }
}
