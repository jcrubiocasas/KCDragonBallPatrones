//
//  GetTransformationsUseCaseTest.swift
//  SWPatterns
//
//  Created by Juan Carlos Rubio Casas on 6/10/24.
//

@testable import SWPatterns
import XCTest

// MARK: - API Session Mock for GetTransformations
// Esta clase simula la sesión de API para devolver respuestas simuladas relacionadas con transformaciones sin hacer llamadas reales a la red.
final class APISessionGetTransformationsMock: APISessionContract {
    
    // Esta propiedad contiene una función que se usará para devolver un resultado simulado (éxito o fallo).
    let mockResponse: ((any APIRequest) -> Result<Data, any Error>)
    
    // Inicializa el mock con una respuesta personalizada que se define externamente.
    init(mockResponse: @escaping (any APIRequest) -> Result<Data, any Error>) {
        self.mockResponse = mockResponse
    }
    
    // Este método simula la petición del API, llamando a la función `mockResponse` con el request y devolviendo un resultado simulado.
    func request<Request: APIRequest>(apiRequest: Request, completion: @escaping (Result<Data, any Error>) -> Void) {
        completion(mockResponse(apiRequest)) // Devuelve el resultado simulado a través del completion handler.
    }
}

// MARK: - GetTransformationUseCase Tests
// Esta clase contiene las pruebas unitarias para el caso de uso `GetAllTransformationsUseCase`.
final class GetTransformationUseCaseTests: XCTestCase {
    
    // Test para verificar que las transformaciones se devuelven correctamente cuando la respuesta es válida.
    func testSuccessReturnsTransformations() {
        let sut = GetAllTransformationsUseCase() // Se inicializa el caso de uso a probar.
        
        // Se establece una expectativa para sincronizar la prueba asíncrona.
        let expectation = self.expectation(description: "TestSuccess")
        
        // Se crea una transformación simulada para usar como resultado esperado.
        let transformation = Transformation(identifier: "D13A40E5-4418-4223-9CE6-D2F9A28EBE94",
                                            photo: "https://areajugones.sport.es/wp-content/uploads/2021/05/ozarru.jpg.webp",
                                            name: "1. Oozaru – Gran Mono",
                                            description: "Cómo todos los Saiyans con cola, Goku es capaz de convertirse en un mono gigante si mira fijamente a la luna llena. Así es como Goku cuando era un infante liberaba todo su potencial a cambio de perder todo el raciocinio y transformarse en una auténtica bestia. Es por ello que sus amigos optan por cortarle la cola para que no ocurran desgracias, ya que Goku mató a su propio abuelo adoptivo Son Gohan estando en este estado. Después de beber el Agua Ultra Divina, Goku liberó todo su potencial sin necesidad de volver a convertirse en Oozaru.")
        
        // Se codifica la transformación en formato JSON para simular la respuesta del servidor.
        let transformationsData: Data
        do {
            transformationsData = try JSONEncoder().encode([transformation])
        } catch {
            // Si hay un error al codificar la transformación, se falla el test.
            XCTFail("Error al codificar la transformación: \(error)")
            return
        }
        
        // Se asigna el mock de la sesión de API para devolver la transformación codificada.
        APISession.shared = APISessionGetTransformationsMock { _ in .success(transformationsData) }
        
        // Se ejecuta el caso de uso y se verifica el resultado.
        sut.execute(identificator: "D13A40E5-4418-4223-9CE6-D2F9A28EBE94") { result in
            switch result {
            case .success(let transformations):
                // Se verifica que se devuelve una transformación y que el nombre es correcto.
                XCTAssertEqual(transformations.count, 1)
                XCTAssertEqual(transformations.first?.name, "1. Oozaru – Gran Mono")
                expectation.fulfill() // Se cumple la expectativa si el test pasa.
            case .failure:
                XCTFail("Expected success but got failure") // Si falla, se marca como error.
            }
        }
        
        // Se espera a que la expectativa se cumpla dentro de 5 segundos.
        waitForExpectations(timeout: 5)
    }
    
    // Test para verificar que un fallo en la petición devuelve un error.
    func testFailureReturnsError() {
        let sut = GetAllTransformationsUseCase() // Se inicializa el caso de uso a probar.
        
        // Se establece una expectativa para sincronizar la prueba asíncrona.
        let expectation = self.expectation(description: "TestFailure")
        
        // Se asigna el mock de la sesión de API para devolver un fallo simulado.
        APISession.shared = APISessionGetTransformationsMock { _ in .failure(APIErrorResponse.network("transformations-fail")) }
        
        // Se ejecuta el caso de uso y se verifica el resultado.
        sut.execute(identificator: "2") { result in
            switch result {
            case .success:
                XCTFail("Expected failure but got success") // Si no falla, se marca como error.
            case .failure(let error):
                XCTAssertNotNil(error) // Se verifica que el error no sea nulo.
                expectation.fulfill() // Se cumple la expectativa si el test pasa.
            }
        }
        
        // Se espera a que la expectativa se cumpla dentro de 5 segundos.
        waitForExpectations(timeout: 5)
    }
}

/*
@testable import SWPatterns
import XCTest

// MARK: - API Session Mock for GetTransformations
final class APISessionGetTransformationsMock: APISessionContract {
    let mockResponse: ((any APIRequest) -> Result<Data, any Error>)
    
    // Inicializa el mock con una respuesta simulada
    init(mockResponse: @escaping (any APIRequest) -> Result<Data, any Error>) {
        self.mockResponse = mockResponse
    }
    
    // Simula la petición del API, devolviendo la respuesta simulada
    func request<Request: APIRequest>(apiRequest: Request, completion: @escaping (Result<Data, any Error>) -> Void) {
        completion(mockResponse(apiRequest))
    }
}

// MARK: - GetTransformationUseCase Tests
final class GetTransformationUseCaseTests: XCTestCase {
    
    // Test para verificar que las transformaciones se devuelven correctamente
    func testSuccessReturnsTransformations() {
        let sut = GetAllTransformationsUseCase()
        
        let expectation = self.expectation(description: "TestSuccess")
        let transformation = Transformation(identifier: "D13A40E5-4418-4223-9CE6-D2F9A28EBE94",
                                            photo: "https://areajugones.sport.es/wp-content/uploads/2021/05/ozarru.jpg.webp",
                                            name: "1. Oozaru – Gran Mono",
                                            description: "Cómo todos los Saiyans con cola, Goku es capaz de convertirse en un mono gigante si mira fijamente a la luna llena. Así es como Goku cuando era un infante liberaba todo su potencial a cambio de perder todo el raciocinio y transformarse en una auténtica bestia. Es por ello que sus amigos optan por cortarle la cola para que no ocurran desgracias, ya que Goku mató a su propio abuelo adoptivo Son Gohan estando en este estado. Después de beber el Agua Ultra Divina, Goku liberó todo su potencial sin necesidad de volver a convertirse en Oozaru")
        
        let transformationsData: Data
        do {
            transformationsData = try JSONEncoder().encode([transformation])
        } catch {
            XCTFail("Error al codificar la transformación: \(error)")
            return
        }
        
        APISession.shared = APISessionGetTransformationsMock { _ in .success(transformationsData) }
        sut.execute(identificator: "D13A40E5-4418-4223-9CE6-D2F9A28EBE94") { result in
            switch result {
            case .success(let transformations):
                XCTAssertEqual(transformations.count, 1)
                XCTAssertEqual(transformations.first?.name, "1. Oozaru – Gran Mono")
                expectation.fulfill()
            case .failure:
                XCTFail("Expected success but got failure")
            }
        }
        
        waitForExpectations(timeout: 5)
    }
    
    // Test para verificar que un fallo en la petición devuelve un error
    func testFailureReturnsError() {
        let sut = GetAllTransformationsUseCase()
        
        let expectation = self.expectation(description: "TestFailure")
        
        APISession.shared = APISessionGetTransformationsMock { _ in .failure(APIErrorResponse.network("transformations-fail")) }
        sut.execute(identificator: "2") { result in
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                XCTAssertNotNil(error)
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 5)
    }
}
*/

