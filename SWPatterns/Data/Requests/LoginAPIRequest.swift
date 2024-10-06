import Foundation

// MARK: - LoginAPIRequest
// Esta estructura conforma el protocolo `APIRequest` y representa una solicitud para autenticar a un usuario mediante login.
// Define los detalles de la solicitud, como el método HTTP, las cabeceras y el path.
// El tipo de respuesta (`Response`) asociado a esta solicitud es un objeto `Data`, que probablemente contendrá un token de autenticación o algún tipo de confirmación de éxito.
struct LoginAPIRequest: APIRequest {
    
    // El tipo de respuesta esperado para esta solicitud es de tipo `Data`.
    typealias Response = Data
    
    // Las cabeceras HTTP que se enviarán con la solicitud.
    // En este caso, contendrán la cabecera `Authorization` con credenciales codificadas en Base64.
    let headers: [String: String]
    
    // El método HTTP que se utilizará para esta solicitud. En este caso, es `POST`.
    let method: HTTPMethod = .POST
    
    // La ruta de la solicitud API (path) que apunta al endpoint de autenticación.
    // En este caso, apunta a `/api/auth/login`.
    let path: String = "/api/auth/login"
    
    // Inicializa la solicitud con las credenciales del usuario.
    // Las credenciales se codifican en Base64 y se añaden a las cabeceras HTTP bajo el campo `Authorization`.
    // - Parameter credentials: Las credenciales del usuario (nombre de usuario y contraseña) utilizadas para autenticar al usuario.
    init(credentials: Credentials) {
        // Crea una cadena formateada con las credenciales (username:password) y la convierte en `Data`.
        let loginData = Data(String(format: "%@:%@", credentials.username, credentials.password).utf8)
        
        // Codifica las credenciales en Base64 para su uso en la cabecera `Authorization`.
        let base64String = loginData.base64EncodedString()
        
        // Asigna las cabeceras de la solicitud, incluyendo la cabecera `Authorization` con las credenciales en formato Basic.
        headers = ["Authorization": "Basic \(base64String)"]
    }
}
