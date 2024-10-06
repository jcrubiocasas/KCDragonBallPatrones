import Foundation

// MARK: - APISessionContract
// Protocolo que define el contrato para una sesión de API.
// Las clases o estructuras que conformen este protocolo deben implementar el método `request`.
// Este método realiza una solicitud de red a partir de un objeto que conforme al protocolo `APIRequest`
// y llama al bloque de completado con el resultado de la solicitud (éxito o fallo).
protocol APISessionContract {
    // Método para realizar una solicitud de red.
    // - Parameters:
    //   - apiRequest: Solicitud API que se va a ejecutar.
    //   - completion: Bloque de completado que maneja el resultado de la solicitud (éxito con datos o fallo con error).
    func request<Request: APIRequest>(apiRequest: Request, completion: @escaping (Result<Data, Error>) -> Void)
}

// MARK: - APISession
// Estructura que implementa `APISessionContract` para gestionar la ejecución de solicitudes HTTP.
// Proporciona una implementación concreta de una sesión de API utilizando `URLSession`.
// También permite aplicar interceptores a las solicitudes antes de que sean enviadas.
struct APISession: APISessionContract {
    
    // Instancia compartida estática que sigue el patrón singleton.
    // Esta instancia puede ser utilizada en toda la aplicación como la sesión API predeterminada.
    static var shared: APISessionContract = APISession()
    
    // Propiedad privada que contiene una instancia de `URLSession` con la configuración predeterminada.
    private let session = URLSession(configuration: .default)
    
    // Array de interceptores de solicitudes que se aplicarán a cada solicitud antes de ser enviada.
    private let requestInterceptors: [APIRequestInterceptor]
    
    // Inicializa la sesión de API con una lista opcional de interceptores de solicitud.
    // Si no se proporcionan interceptores, por defecto incluye un `AuthenticationRequestInterceptor`.
    // - Parameter requestInterceptors: Array de interceptores de solicitud que modificarán las solicitudes antes de ser enviadas.
    init(requestInterceptors: [APIRequestInterceptor] = [AuthenticationRequestInterceptor()]) {
        self.requestInterceptors = requestInterceptors
    }
    
    // Implementación del método `request` definido en el protocolo `APISessionContract`.
    // Este método toma una solicitud API, aplica interceptores, realiza la solicitud HTTP,
    // y maneja la respuesta o los errores de red.
    // - Parameters:
    //   - apiRequest: Objeto que conforma el protocolo `APIRequest` y representa la solicitud que se enviará.
    //   - completion: Bloque de completado que devuelve los datos recibidos o un error en caso de fallo.
    func request<Request: APIRequest>(apiRequest: Request, completion: @escaping (Result<Data, Error>) -> Void) {
        do {
            // Crea un objeto `URLRequest` a partir de las propiedades de `apiRequest`.
            var request = try apiRequest.getRequest()
            
            // Aplica todos los interceptores de solicitud a la solicitud antes de enviarla.
            requestInterceptors.forEach { $0.intercept(request: &request) }
            
            // Ejecuta la solicitud utilizando `URLSession` y gestiona la respuesta.
            session.dataTask(with: request) { data, response, error in
                // Si ocurre un error, lo devuelve a través del bloque de completado.
                if let error = error {
                    return completion(.failure(error))
                }
                
                // Verifica si la respuesta es una respuesta HTTP y si el código de estado es 200 (éxito).
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    // Si el código de estado no es 200, devuelve un error de red.
                    return completion(.failure(APIErrorResponse.network(apiRequest.path)))
                }
                
                // Devuelve los datos recibidos (o un objeto `Data` vacío si no hay datos) a través del bloque de completado.
                return completion(.success(data ?? Data()))
            }.resume()  // Inicia la tarea de red.
            
        } catch {
            // Si ocurre un error al generar la solicitud, lo devuelve a través del bloque de completado.
            completion(.failure(error))
        }
    }
}
