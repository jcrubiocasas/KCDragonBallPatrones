//
//  GetAllHeroesUseCaseTests.swift
//  SWPatterns
//
//  Created by Juan Carlos Rubio Casas on 6/10/24.
//

@testable import SWPatterns
import XCTest

// MARK: - API Session Mock
// Esta clase simula la sesión de API para devolver respuestas simuladas sin llamar a la red real.
final class APISessionGetAllHeroesMock: APISessionContract {
    
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

// MARK: - GetAllHeroesUseCase Tests
// Esta clase contiene las pruebas unitarias para el caso de uso `GetAllHeroesUseCase`.
final class GetAllHeroesUseCaseTests: XCTestCase {
    
    // Test para verificar que el caso de uso devuelve héroes con éxito cuando la respuesta es válida.
    func testSuccessReturnsHeroes() {
        let sut = GetAllHeroesUseCase() // Se inicializa el caso de uso a probar.
        
        // Se establece una expectativa para sincronizar la prueba asíncrona.
        let expectation = self.expectation(description: "TestSuccess")
        
        // Se crea un héroe simulado para usar como resultado esperado.
        let hero = Hero(identifier: "1", name: "Goku", description: "Saiyan", photo: "goku.jpg", favorite: false)
        
        // Se codifica el héroe en formato JSON para simular la respuesta del servidor.
        let heroesData: Data
        do {
            heroesData = try JSONEncoder().encode([hero])
        } catch {
            // Si hay un error al codificar el héroe, se falla el test.
            XCTFail("Error al codificar el héroe: \(error)")
            return
        }
        
        // Se asigna el mock de la sesión de API para devolver el héroe codificado.
        APISession.shared = APISessionGetAllHeroesMock { _ in .success(heroesData) }
        
        // Se ejecuta el caso de uso y se verifica el resultado.
        sut.execute { result in
            switch result {
            case .success(let heroes):
                // Se verifica que se devuelve un héroe y que el nombre es correcto.
                XCTAssertEqual(heroes.count, 1)
                XCTAssertEqual(heroes.first?.name, "Goku")
                expectation.fulfill() // Se cumple la expectativa si el test pasa.
            case .failure:
                XCTFail("Expected success but got failure") // Si falla, se marca como error.
            }
        }
        
        // Se espera a que la expectativa se cumpla dentro de 5 segundos.
        waitForExpectations(timeout: 5)
    }
    
    // Test para verificar que el caso de uso devuelve un error cuando la respuesta falla.
    func testFailureReturnsError() {
        let sut = GetAllHeroesUseCase() // Se inicializa el caso de uso a probar.
        
        // Se establece una expectativa para sincronizar la prueba asíncrona.
        let expectation = self.expectation(description: "TestFailure")
        
        // Se asigna el mock de la sesión de API para devolver un fallo simulado.
        APISession.shared = APISessionGetAllHeroesMock { _ in .failure(APIErrorResponse.network("heroes-fail")) }
        
        // Se ejecuta el caso de uso y se verifica el resultado.
        sut.execute { result in
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

// MARK: - API Session Mock
final class APISessionGetAllHeroesMock: APISessionContract {
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

// MARK: - GetAllHeroesUseCase Tests
final class GetAllHeroesUseCaseTests: XCTestCase {
    
    // Test para verificar que el caso de uso devuelve héroes con éxito
    func testSuccessReturnsHeroes() {
        let sut = GetAllHeroesUseCase()
        let expectation = self.expectation(description: "TestSuccess")
        let hero = Hero(identifier: "1", name: "Goku", description: "Saiyan", photo: "goku.jpg", favorite: false)
        
        let heroesData: Data
        do {
            heroesData = try JSONEncoder().encode([hero])
        } catch {
            XCTFail("Error al codificar el héroe: \(error)")
            return
        }
        
        APISession.shared = APISessionGetAllHeroesMock { _ in .success(heroesData) }
        sut.execute { result in
            switch result {
            case .success(let heroes):
                XCTAssertEqual(heroes.count, 1)
                XCTAssertEqual(heroes.first?.name, "Goku")
                expectation.fulfill()
            case .failure:
                XCTFail("Expected success but got failure")
            }
        }
        
        waitForExpectations(timeout: 5)
    }
    
    // Test para verificar que el caso de uso devuelve un error en caso de fallo
    func testFailureReturnsError() {
        let sut = GetAllHeroesUseCase()
        let expectation = self.expectation(description: "TestFailure")
        
        APISession.shared = APISessionGetAllHeroesMock { _ in .failure(APIErrorResponse.network("heroes-fail")) }
        sut.execute { result in
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
