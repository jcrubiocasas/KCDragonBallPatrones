import UIKit

// MARK: - LoginBuilder
// Clase responsable de construir e inicializar la pantalla de login.
// Utiliza el patrón Builder para crear las dependencias necesarias (caso de uso, ViewModel, y ViewController)
// y retornar el controlador de vista listo para ser presentado.
final class LoginBuilder {
    
    // MARK: - build
    // Método que construye y configura la pantalla de login.
    // Este método crea el caso de uso, el ViewModel, y el ViewController necesarios para la funcionalidad de login.
    // - Returns: Un `UIViewController` configurado para manejar el proceso de login.
    func build() -> UIViewController {
        // Crea el caso de uso responsable de la lógica del login.
        let loginUseCase = LoginUseCase()
        
        // Inicializa el ViewModel del login, inyectando el caso de uso.
        let viewModel = LoginViewModel(useCase: loginUseCase)
        
        // Crea el ViewController del login, inyectando el ViewModel.
        let viewController = LoginViewController(viewModel: viewModel)
        
        // Configura la presentación del ViewController para que sea en pantalla completa.
        viewController.modalPresentationStyle = .fullScreen
        
        // Retorna el ViewController de login listo para ser presentado.
        return viewController
    }
}
