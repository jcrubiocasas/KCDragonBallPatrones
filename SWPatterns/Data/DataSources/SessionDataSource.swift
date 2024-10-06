import Foundation

// MARK: - SessionDataSourceContract
// Este protocolo define los métodos necesarios para manejar la persistencia de la sesión.
// Las clases que implementen este protocolo deben proporcionar la funcionalidad para:
// - Almacenar una sesión.
// - Recuperar la sesión almacenada.
// - Reiniciar (eliminar) la sesión almacenada.
protocol SessionDataSourceContract {
    
    // Almacena la sesión proporcionada.
    // - Parameter session: Datos de la sesión que se desean almacenar (por ejemplo, un token de autenticación).
    func storeSession(_ session: Data)
    
    // Recupera la sesión almacenada.
    // - Returns: Los datos de la sesión almacenada, si existen; de lo contrario, devuelve nil.
    func getSession() -> Data?
    
    // Reinicia la sesión almacenada, eliminando cualquier valor existente.
    func resetSession()
}

// MARK: - SessionDataSource
// Esta clase concreta implementa el protocolo `SessionDataSourceContract` y se encarga de manejar la sesión
// utilizando una propiedad estática para almacenar el token de sesión de forma persistente durante el ciclo de vida
// de la aplicación.
//
// Los métodos permiten almacenar, recuperar y eliminar el token de sesión de manera centralizada.
final class SessionDataSource: SessionDataSourceContract {
    
    // Propiedad estática para almacenar el token de sesión.
    // Esta propiedad es compartida entre todas las instancias de `SessionDataSource`.
    // El valor almacenado es de tipo `Data?`, lo que permite guardar cualquier tipo de dato binario como un token.
    private static var token: Data?
    
    // Almacena la sesión proporcionada en la propiedad estática `token`.
    // Este método guarda el token de sesión recibido como un dato de tipo `Data`.
    // - Parameter session: Datos de la sesión que se desean almacenar.
    func storeSession(_ session: Data) {
        SessionDataSource.token = session  // Almacena el token en la propiedad estática.
    }
    
    // Recupera la sesión almacenada en la propiedad estática `token`.
    // Este método devuelve los datos almacenados, si existen, o nil en caso de que no haya una sesión guardada.
    // - Returns: El token de sesión almacenado, si existe; de lo contrario, devuelve nil.
    func getSession() -> Data? {
        SessionDataSource.token  // Retorna el token almacenado.
    }
    
    // Reinicia (elimina) la sesión almacenada, estableciendo el valor de la propiedad estática `token` a nil.
    // Este método efectivamente elimina cualquier sesión previamente almacenada.
    func resetSession() {
        SessionDataSource.token = nil  // Elimina el token almacenado.
    }
}
