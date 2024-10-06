import Foundation

// MARK: - HTTPMethod
// Enum que define los métodos HTTP estándar utilizados en las solicitudes HTTP.
// Cada caso representa un método de solicitud HTTP (por ejemplo, GET, POST, PUT, DELETE).
enum HTTPMethod: String {
    case GET, POST, PUT, UPDATE, HEAD, PATCH, DELETE, OPTIONS
}

// MARK: - APIRequest
// Protocolo que define la estructura básica de una solicitud API.
// Cualquier tipo que conforme este protocolo debe proporcionar la información necesaria para realizar una solicitud HTTP,
// como el host, método HTTP, cuerpo, path, headers y parámetros de consulta.
// También define los tipos asociados para las respuestas de la solicitud y los manejadores de completado.
protocol APIRequest {
    
    // La propiedad `host` define el dominio del servidor donde se realizará la solicitud.
    var host: String { get }
    
    // El método HTTP que se utilizará para la solicitud (por ejemplo, GET, POST, etc.).
    var method: HTTPMethod { get }
    
    // Cuerpo opcional de la solicitud, que debe conformar al protocolo `Encodable`.
    var body: Encodable? { get }
    
    // Ruta de la URL específica para la solicitud (por ejemplo, "/heroes").
    var path: String { get }
    
    // Diccionario de cabeceras HTTP adicionales que se deben incluir en la solicitud.
    var headers: [String: String] { get }
    
    // Diccionario de parámetros de consulta que se deben añadir a la URL de la solicitud.
    var queryParameters: [String: String] { get }
    
    // Tipo asociado para la respuesta de la solicitud, que debe conformar al protocolo `Decodable`.
    associatedtype Response: Decodable
    
    // Tipos alias para el resultado de la solicitud API y el manejador de completado.
    typealias APIRequestResponse = Result<Response, APIErrorResponse>
    typealias APIRequestCompletion = (APIRequestResponse) -> Void
}

// MARK: - APIRequest Default Implementations
// Proporciona implementaciones por defecto para algunas de las propiedades y métodos de `APIRequest`.
// Estas implementaciones permiten definir valores predeterminados que pueden ser sobrescritos por cada tipo conforme.
extension APIRequest {
    
    // Host predeterminado para todas las solicitudes de la API.
    var host: String { "dragonball.keepcoding.education" }
    
    // Parámetros de consulta predeterminados (vacíos).
    var queryParameters: [String: String] { [:] }
    
    // Cabeceras HTTP predeterminadas (vacías).
    var headers: [String: String] { [:] }
    
    // Cuerpo de la solicitud predeterminado (nil si no hay datos que enviar).
    var body: Encodable? { nil }
    
    // Método que genera una solicitud `URLRequest` a partir de las propiedades del protocolo.
    // Ensambla la URL utilizando los parámetros de consulta y añade las cabeceras HTTP.
    // Si hay un cuerpo de la solicitud, se codifica en JSON y se asigna al `httpBody`.
    // - Throws: `APIErrorResponse` si no se puede construir una URL válida o si hay un error al codificar el cuerpo.
    func getRequest() throws -> URLRequest {
        var components = URLComponents()  // Crea los componentes de la URL.
        components.scheme = "https"  // Especifica el esquema (https).
        components.host = host  // Asigna el host (predeterminado o sobrescrito).
        components.path = path  // Asigna el path de la solicitud.
        
        // Si hay parámetros de consulta, los añade a la URL.
        if !queryParameters.isEmpty {
            components.queryItems = queryParameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        
        // Intenta crear la URL final a partir de los componentes.
        guard let finalURL = components.url else {
            throw APIErrorResponse.malformedURL(path)  // Lanza un error si la URL no es válida.
        }
        
        var request = URLRequest(url: finalURL)  // Crea el objeto `URLRequest` con la URL final.
        request.httpMethod = method.rawValue  // Asigna el método HTTP a la solicitud.
        
        // Si el método no es GET y hay un cuerpo de la solicitud, lo codifica en JSON.
        if method != .GET, let body {
            request.httpBody = try JSONEncoder().encode(body)
        }
        
        // Asigna las cabeceras HTTP estándar y cualquier cabecera adicional proporcionada.
        request.allHTTPHeaderFields = ["Accept": "application/json", "Content-Type": "application/json"]
            .merging(headers) { $1 }
        
        request.timeoutInterval = 10  // Asigna un tiempo de espera para la solicitud.
        return request  // Retorna el objeto `URLRequest` listo para ser ejecutado.
    }
}

// MARK: - Execution
// Extensión que añade un método para ejecutar la solicitud de la API.
// Realiza la solicitud utilizando una sesión de API y maneja la respuesta o el error de la solicitud.
extension APIRequest {
    
    // Método que ejecuta la solicitud de la API utilizando una sesión de API proporcionada.
    // Decodifica la respuesta recibida según el tipo `Response` asociado a la solicitud.
    // Maneja los errores de red, decodificación y otros problemas relacionados con la solicitud.
    // - Parameters:
    //   - session: La sesión de API utilizada para realizar la solicitud (por defecto, la sesión compartida).
    //   - completion: Bloque de completado que maneja el resultado de la solicitud (éxito o error).
    func perform(session: APISessionContract = APISession.shared, completion: @escaping APIRequestCompletion) {
        session.request(apiRequest: self) { result in
            do {
                // Intenta obtener los datos de la respuesta.
                let data = try result.get()
                
                // Imprime los datos crudos recibidos para fines de depuración.
                print("Data received: \(String(data: data, encoding: .utf8) ?? "Invalid data")")
                
                // Si el tipo de respuesta es `Void`, retorna éxito sin datos.
                if Response.self == Void.self {
                    return completion(.success(() as! Response))
                }
                // Si el tipo de respuesta es `Data`, retorna los datos crudos.
                else if Response.self == Data.self {
                    return completion(.success(data as! Response))
                }
                
                // Intenta decodificar los datos de la respuesta al tipo `Response` especificado.
                let decodedResponse = try JSONDecoder().decode(Response.self, from: data)
                print("Decoded response: \(decodedResponse)")  // Imprime la respuesta decodificada para depuración.
                
                completion(.success(decodedResponse))  // Retorna éxito con la respuesta decodificada.
                
            } catch let error as APIErrorResponse {
                completion(.failure(error))  // Maneja errores específicos de la API.
            } catch {
                completion(.failure(APIErrorResponse.unknown(path)))  // Maneja otros tipos de errores.
            }
        }
    }
}
