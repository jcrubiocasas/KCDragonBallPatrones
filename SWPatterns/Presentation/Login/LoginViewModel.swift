import Foundation

// MARK: - LoginState
// Enum que define los diferentes estados posibles para el `LoginViewModel`.
// Refleja el ciclo de vida del proceso de login y se utiliza para actualizar la interfaz de usuario.
enum LoginState {
    case success          // Estado cuando el login es exitoso.
    case error(reason: String)  // Estado cuando ocurre un error, con una razón proporcionada.
    case loading          // Estado cuando el proceso de login está en curso.
}

// MARK: - LoginViewModel
// ViewModel responsable de manejar la lógica de negocio para la pantalla de login.
// Se comunica con el caso de uso `LoginUseCaseContract` para realizar el proceso de autenticación y notifica
// a la vista sobre los cambios de estado a través de un mecanismo de binding.
final class LoginViewModel {
    
    // MARK: - Propiedades
    // `onStateChanged` es un binding que se utiliza para notificar a la vista cuando el estado del login cambia (loading, success, error).
    let onStateChanged = Binding<LoginState>()
    
    // El caso de uso que maneja la lógica del proceso de autenticación.
    private let useCase: LoginUseCaseContract
    
    // MARK: - Inicialización
    // Inicializa el ViewModel con el caso de uso necesario.
    // - Parameter useCase: El caso de uso que gestiona la lógica de autenticación.
    init(useCase: LoginUseCaseContract) {
        self.useCase = useCase
    }
    
    // MARK: - Función de inicio de sesión
    // Método que inicia el proceso de login. Valida las credenciales y actualiza el estado en consecuencia.
    // - Parameters:
    //   - username: El nombre de usuario ingresado por el usuario.
    //   - password: La contraseña ingresada por el usuario.
    func signIn(_ username: String?, _ password: String?) {
        // Actualiza el estado a `loading` cuando comienza el proceso de autenticación.
        onStateChanged.update(newValue: .loading)
        
        // Crea las credenciales utilizando los valores proporcionados, manejando valores nulos con valores predeterminados.
        let credentials = Credentials(username: username ?? "", password: password ?? "")
        
        // Ejecuta el caso de uso de login con las credenciales proporcionadas.
        useCase.execute(credentials: credentials) { [weak self] result in
            guard let self = self else { return }
            
            // Maneja el resultado de la solicitud de autenticación.
            do {
                // Si el resultado es exitoso, actualiza el estado a `success`.
                try result.get()
                self.onStateChanged.update(newValue: .success)
                
            } catch let error as LoginUseCaseError {
                // Si ocurre un error específico del caso de uso, actualiza el estado a `error` con la razón proporcionada.
                self.onStateChanged.update(newValue: .error(reason: error.reason))
                
            } catch {
                // Si ocurre un error genérico, actualiza el estado a `error` con un mensaje predeterminado.
                self.onStateChanged.update(newValue: .error(reason: "Something has happened"))
            }
        }
    }
}
