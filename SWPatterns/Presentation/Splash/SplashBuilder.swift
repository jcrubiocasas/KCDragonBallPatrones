import UIKit

// MARK: - SplashBuilder
// Clase responsable de construir e inicializar la pantalla de splash.
// Utiliza el patrón Builder para crear las dependencias necesarias (ViewModel y ViewController) y retornar el controlador de vista.
final class SplashBuilder {
    
    // MARK: - build
    // Método que construye y configura la pantalla de splash.
    // Crea el ViewModel necesario para la pantalla de splash y lo inyecta en el ViewController.
    // - Returns: Un `UIViewController` configurado para mostrar la pantalla de splash.
    func build() -> UIViewController {
        // Crea el ViewModel de la pantalla de splash.
        let viewModel = SplashViewModel()
        
        // Retorna el SplashViewController inyectando el ViewModel creado.
        return SplashViewController(viewModel: viewModel)
    }
}
