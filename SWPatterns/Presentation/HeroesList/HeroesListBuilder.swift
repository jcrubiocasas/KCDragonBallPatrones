import UIKit

// MARK: - HeroesListBuilder
// Clase responsable de construir e inicializar la pantalla que muestra la lista de héroes.
// Utiliza el patrón Builder para crear las dependencias necesarias y retornar un controlador de navegación que contiene
// la vista con la lista de héroes.
final class HeroesListBuilder {
    
    // MARK: - build
    // Método que construye y configura la pantalla de lista de héroes.
    // Este método crea los casos de uso, el ViewModel y el ViewController necesarios,
    // luego envuelve el controlador de la lista de héroes dentro de un `UINavigationController`.
    // - Returns: Un `UINavigationController` que contiene la vista de la lista de héroes como su controlador raíz.
    func build() -> UIViewController {
        // Crea el caso de uso responsable de obtener la lista de héroes.
        let useCase = GetAllHeroesUseCase()
        
        // Inicializa el ViewModel de la lista de héroes, inyectando el caso de uso.
        let viewModel = HeroesListViewModel(useCase: useCase)
        
        // Crea el ViewController de la lista de héroes, inyectando el ViewModel.
        let viewController = HeroesListViewController(viewModel: viewModel)
        
        // Envuelve el ViewController dentro de un UINavigationController para gestionar la navegación.
        let navigationController = UINavigationController(rootViewController: viewController)
        
        // Configura el estilo de presentación a pantalla completa.
        navigationController.modalPresentationStyle = .fullScreen
        
        // Retorna el UINavigationController configurado.
        return navigationController
    }
}
