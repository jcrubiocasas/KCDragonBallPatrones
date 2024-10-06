import Foundation

// MARK: - APIInterceptor
// Protocolo base que representa un interceptor de la API.
// No tiene requisitos específicos, pero sirve como base para especializar diferentes tipos de interceptores.
protocol APIInterceptor { }

// MARK: - APIRequestInterceptor
// Este protocolo hereda de `APIInterceptor` y se especializa en interceptores que manipulan solicitudes de la API.
// Requiere la implementación de un método `intercept(request:)` que permitirá modificar las solicitudes de `URLRequest`.
protocol APIRequestInterceptor: APIInterceptor {
    // Método para interceptar y modificar una solicitud `URLRequest`.
    // - Parameter request: Solicitud que será modificada antes de ser enviada.
    func intercept(request: inout URLRequest)
}

// MARK: - AuthenticationRequestInterceptor
// Esta clase implementa `APIRequestInterceptor` y se utiliza para interceptar solicitudes y agregar un token de autenticación.
// El interceptor toma un token de sesión de una fuente de datos (por ejemplo, almacenamiento local) y lo añade a las cabeceras HTTP de la solicitud.
final class AuthenticationRequestInterceptor: APIRequestInterceptor {
    
    // Fuente de datos para obtener la sesión actual (por ejemplo, un token de autenticación).
    private let dataSource: SessionDataSourceContract
    
    // Inicializa el interceptor con una fuente de datos, por defecto se usa `SessionDataSource` como implementación.
    // - Parameter dataSource: Proveedor de datos de la sesión, que debe implementar `SessionDataSourceContract`.
    init(dataSource: SessionDataSourceContract = SessionDataSource()) {
        self.dataSource = dataSource
    }
    
    // Intercepta y modifica la solicitud añadiendo un token de autenticación a las cabeceras.
    // - Parameter request: Solicitud que será modificada para incluir el token en las cabeceras HTTP.
    func intercept(request: inout URLRequest) {
        // Obtiene el token de sesión de la fuente de datos.
        guard let session = dataSource.getSession() else {
            return  // Si no hay sesión, no se modifica la solicitud.
        }
        
        // Convierte el token de sesión a una cadena UTF-8 y lo agrega como valor del campo "Authorization" en las cabeceras HTTP.
        request.setValue("Bearer \(String(decoding: session, as: UTF8.self))", forHTTPHeaderField: "Authorization")
    }
}
