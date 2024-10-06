import Foundation

// MARK: - SplashState
// Enum que define los diferentes estados posibles para el `SplashViewModel`.
// Refleja el ciclo de vida de la pantalla de splash y se utiliza para actualizar la interfaz de usuario.
enum SplashState {
    case loading  // Estado cuando los datos o la pantalla de splash están cargando.
    case error    // Estado cuando ocurre un error al cargar.
    case ready    // Estado cuando la pantalla de splash ha terminado su trabajo y está lista.
}

// MARK: - SplashViewModel
// ViewModel responsable de manejar la lógica de la pantalla de splash.
// Utiliza un mecanismo de binding para notificar a la vista sobre los cambios de estado (loading, ready, error).
class SplashViewModel {
    
    // MARK: - Propiedades
    // `onStateChanged` es un binding que se usa para notificar a la vista cuando el estado cambia.
    var onStateChanged = Binding<SplashState>()
    
    // MARK: - Funciones
    // Método que inicia la carga o el proceso de la pantalla de splash.
    // Simula una carga asincrónica de 3 segundos antes de actualizar el estado a `ready`.
    func load() {
        // Actualiza el estado a `loading` para indicar que la carga ha comenzado.
        onStateChanged.update(newValue: .loading)
        
        // Simula un retraso asincrónico de 3 segundos para realizar la transición a `ready`.
        DispatchQueue.global().asyncAfter(deadline: .now() + 3) { [weak self] in
            // Al completar el retraso, actualiza el estado a `ready` para indicar que la pantalla está lista.
            self?.onStateChanged.update(newValue: .ready)
        }
    }
}
