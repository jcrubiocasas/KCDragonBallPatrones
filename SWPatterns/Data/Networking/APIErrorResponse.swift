import Foundation

// MARK: - APIErrorResponse
// Esta estructura representa un error de respuesta de la API. Conforma el protocolo `Error` para que pueda
// ser utilizada como un error y también implementa `Equatable` para permitir la comparación entre instancias.
// Se utiliza para capturar información detallada sobre los errores que pueden ocurrir durante las llamadas a la API.
struct APIErrorResponse: Error, Equatable {
    
    // Propiedad que contiene la URL donde ocurrió el error.
    let url: String
    
    // Código de estado HTTP asociado con la respuesta de error (puede ser un código de éxito o error).
    let statusCode: Int
    
    // Datos opcionales recibidos de la respuesta del servidor que acompañan al error.
    let data: Data?
    
    // Mensaje de error asociado que describe la naturaleza del problema.
    let message: String
    
    // Inicializa una instancia de `APIErrorResponse` con la URL, código de estado, datos opcionales y un mensaje.
    // - Parameters:
    //   - url: La URL donde ocurrió el error.
    //   - statusCode: El código de estado HTTP asociado con el error.
    //   - data: Datos opcionales asociados a la respuesta del servidor.
    //   - message: Un mensaje descriptivo del error.
    init(url: String, statusCode: Int, data: Data? = nil, message: String) {
        self.url = url
        self.statusCode = statusCode
        self.data = data
        self.message = message
    }
}

// MARK: - APIErrorResponse Extensions
// Esta extensión agrega métodos de conveniencia estáticos para generar errores comunes en las llamadas a la API,
// cada uno con un mensaje específico y un código de estado que representa diferentes tipos de fallos.

extension APIErrorResponse {
    
    // Método de conveniencia para generar un error relacionado con problemas de conexión de red.
    // - Parameter url: La URL donde ocurrió el fallo de red.
    // - Returns: Una instancia de `APIErrorResponse` con un código de estado `-1` y un mensaje indicando
    //            un error de conexión de red.
    static func network(_ url: String) -> APIErrorResponse {
        APIErrorResponse(url: url, statusCode: -1, message: "Network connection error")
    }
    
    // Método de conveniencia para generar un error relacionado con problemas de análisis de datos recibidos.
    // - Parameter url: La URL donde ocurrió el fallo de análisis de datos.
    // - Returns: Una instancia de `APIErrorResponse` con un código de estado `-2` y un mensaje indicando
    //            que los datos no se pueden analizar.
    static func parseData(_ url: String) -> APIErrorResponse {
        APIErrorResponse(url: url, statusCode: -2, message: "Cannot Parse data")
    }
    
    // Método de conveniencia para generar un error desconocido.
    // - Parameter url: La URL donde ocurrió el error desconocido.
    // - Returns: Una instancia de `APIErrorResponse` con un código de estado `-3` y un mensaje indicando
    //            que ocurrió un error desconocido.
    static func unknown(_ url: String) -> APIErrorResponse {
        APIErrorResponse(url: url, statusCode: -3, message: "Unknown error")
    }
    
    // Método de conveniencia para generar un error relacionado con una respuesta vacía del servidor.
    // - Parameter url: La URL donde ocurrió el fallo debido a una respuesta vacía.
    // - Returns: Una instancia de `APIErrorResponse` con un código de estado `-4` y un mensaje indicando
    //            que la respuesta está vacía.
    static func empty(_ url: String) -> APIErrorResponse {
        APIErrorResponse(url: url, statusCode: -4, message: "Empty response")
    }
    
    // Método de conveniencia para generar un error relacionado con una URL malformada.
    // - Parameter url: La URL malformada que causó el error.
    // - Returns: Una instancia de `APIErrorResponse` con un código de estado `-5` y un mensaje indicando
    //            que no se pudo generar la URL.
    static func malformedURL(_ url: String) -> APIErrorResponse {
        APIErrorResponse(url: url, statusCode: -5, message: "Can't generate the Url")
    }
}
