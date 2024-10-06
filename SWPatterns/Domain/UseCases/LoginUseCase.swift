import Foundation

// MARK: - LoginUseCaseContract
// Protocolo que define el contrato para el caso de uso `LoginUseCase`.
// Cualquier clase que implemente este protocolo debe proporcionar una función para ejecutar el proceso de login,
// validando las credenciales del usuario y manejando la sesión.
protocol LoginUseCaseContract {
    // Método que ejecuta la solicitud de login.
    // - Parameters:
    //   - credentials: Credenciales del usuario (nombre de usuario y contraseña).
    //   - completion: Bloque de completado que devuelve `Void` en caso de éxito o un error específico de login en caso de fallo.
    func execute(credentials: Credentials, completion: @escaping (Result<Void, LoginUseCaseError>) -> Void)
}

// MARK: - LoginUseCase
// Clase que implementa el caso de uso `LoginUseCaseContract`.
// Se encarga de gestionar la lógica del proceso de login, que incluye la validación de las credenciales del usuario
// y la solicitud de autenticación a través de una API. Además, gestiona el almacenamiento del token de sesión
// utilizando un `SessionDataSourceContract`.
final class LoginUseCase: LoginUseCaseContract {
    
    // Propiedad privada que almacena una referencia a `SessionDataSourceContract`,
    // lo que permite gestionar la sesión del usuario (por ejemplo, almacenando el token tras un login exitoso).
    private let dataSource: SessionDataSourceContract
    
    // Inicializador que permite inyectar una implementación personalizada de `SessionDataSourceContract`.
    // Si no se proporciona, se usa la implementación por defecto (`SessionDataSource`).
    // - Parameter dataSource: Fuente de datos que manejará la sesión del usuario.
    init(dataSource: SessionDataSourceContract = SessionDataSource()) {
        self.dataSource = dataSource
    }
    
    // MARK: - execute
    // Método que ejecuta el proceso de login.
    // Primero valida las credenciales del usuario, y si son válidas, realiza una solicitud de login a la API.
    // Si la solicitud tiene éxito, almacena el token de sesión; de lo contrario, maneja el error correspondiente.
    // - Parameters:
    //   - credentials: Credenciales del usuario (nombre de usuario y contraseña).
    //   - completion: Bloque de completado que devuelve `Void` en caso de éxito o un error específico de login en caso de fallo.
    func execute(credentials: Credentials, completion: @escaping (Result<Void, LoginUseCaseError>) -> Void) {
        // Valida el nombre de usuario.
        guard validateUsername(credentials.username) else {
            return completion(.failure(LoginUseCaseError(reason: "Invalid username")))
        }
        // Valida la contraseña.
        guard validatePassword(credentials.password) else {
            return completion(.failure(LoginUseCaseError(reason: "Invalid password")))
        }
        
        // Ejecuta la solicitud de login con las credenciales del usuario.
        LoginAPIRequest(credentials: credentials)
            .perform { [weak self] result in
                switch result {
                case .success(let token):
                    // Si el login tiene éxito, almacena el token de sesión.
                    self?.dataSource.storeSession(token)
                    completion(.success(()))
                case .failure:
                    // Si ocurre un fallo de red, devuelve un error específico de red.
                    completion(.failure(LoginUseCaseError(reason: "Network failed")))
                }
            }
    }
    
    // MARK: - Validación de credenciales
    // Valida que el nombre de usuario contenga un "@" y no esté vacío.
    // - Parameter username: El nombre de usuario que se desea validar.
    // - Returns: `true` si el nombre de usuario es válido, de lo contrario `false`.
    private func validateUsername(_ username: String) -> Bool {
        username.contains("@") && !username.isEmpty
    }
    
    // Valida que la contraseña tenga al menos 4 caracteres.
    // - Parameter password: La contraseña que se desea validar.
    // - Returns: `true` si la contraseña es válida, de lo contrario `false`.
    private func validatePassword(_ password: String) -> Bool {
        password.count >= 4
    }
}

// MARK: - LoginUseCaseError
// Estructura que representa un error específico del caso de uso de login.
// Esta estructura conforma el protocolo `Error` y contiene un mensaje que describe la razón del error.
struct LoginUseCaseError: Error {
    let reason: String  // Razón del fallo (por ejemplo, "Invalid username" o "Network failed").
}
