//
//  LoginUseCaseTest.swift
//  SWPatterns
//
//  Created by Juan Carlos Rubio Casas on 6/10/24.
//

@testable import SWPatterns
import XCTest

// MARK: - API Session Mock
// Esta clase simula la sesión de API, permitiendo devolver respuestas simuladas en lugar de realizar llamadas reales a la red.
final class APISessionMock: APISessionContract {
    
    // Esta propiedad contiene una función que simula la respuesta de la API (éxito o fallo).
    let mockResponse: (any APIRequest) -> Result<Data, Error>
    
    // Inicializa el mock con una respuesta personalizada que se define externamente.
    init(mockResponse: @escaping (any APIRequest) -> Result<Data, Error>) {
        self.mockResponse = mockResponse
    }
    
    // Este método simula la petición del API y devuelve el resultado a través del completion handler.
    func request<Request: APIRequest>(apiRequest: Request, completion: @escaping (Result<Data, Error>) -> Void) {
        // Simula una respuesta de la API llamando a la función mockResponse.
        completion(mockResponse(apiRequest))
    }
}

// MARK: - Dummy Session Data Source
// Esta clase simula una fuente de datos para la sesión, permitiendo almacenar y recuperar sesiones simuladas.
final class DummySessionDataSource: SessionDataSourceContract {
    
    // Elimina la sesión almacenada.
    func resetSession() {
        self.session = nil
    }
    
    // Propiedad para almacenar la sesión simulada.
    private(set) var session: Data?
        
    // Almacena una sesión.
    func storeSession(_ session: Data) {
        self.session = session
    }
    
    // Recupera la sesión almacenada (si existe), en este caso siempre devuelve nil.
    func getSession() -> Data? { nil }
}

// MARK: - Login Use Case Tests
// Esta clase contiene las pruebas unitarias para el caso de uso `LoginUseCase`.
final class LoginUseCaseTests: XCTestCase {
    
    // Test para verificar que al autenticarse correctamente se almacena el token de sesión.
    func testSuccessStoresToken() {
        let dataSource = DummySessionDataSource()  // Fuente de datos simulada.
        let sut = LoginUseCase(dataSource: dataSource)  // Caso de uso a probar.
        
        let expectation = self.expectation(description: "TestSuccess")  // Establece una expectativa para pruebas asíncronas.
        let data = Data("hello-world".utf8)  // Datos simulados para el token de sesión.
        
        // Asigna el mock de la sesión API para devolver los datos simulados.
        APISession.shared = APISessionMock { _ in .success(data) }
        
        // Ejecuta el caso de uso con credenciales correctas.
        sut.execute(credentials: Credentials(username: "a@b.es", password: "122345")) { result in
            guard case .success = result else {
                return
            }
            expectation.fulfill()  // La expectativa se cumple si el caso de uso devuelve éxito.
        }
        
        waitForExpectations(timeout: 5)  // Espera que se cumpla la expectativa.
        XCTAssertEqual(dataSource.session, data)  // Verifica que la sesión se haya almacenado correctamente.
    }
    
    // Test para verificar que el caso de uso falla con credenciales inválidas (nombre de usuario incorrecto).
    func testFailureDueToInvalidCredentials() {
        let dataSource = DummySessionDataSource()  // Fuente de datos simulada.
        let sut = LoginUseCase(dataSource: dataSource)  // Caso de uso a probar.
        
        let expectation = self.expectation(description: "TestFailureDueToInvalidCredentials")  // Establece una expectativa.
        
        // Simula una respuesta fallida de la API (fallo en la red).
        APISession.shared = APISessionMock { _ in .failure(APIErrorResponse.network("login")) }
        
        // Ejecuta el caso de uso con credenciales incorrectas.
        sut.execute(credentials: Credentials(username: "a@b.es", password: "wrong-password")) { result in
            guard case let .failure(receivedError) = result else {
                XCTFail("Expected failure, but got success")  // Si no falla, marca el test como fallido.
                return
            }
            
            // Verifica que el error recibido sea de tipo fallo de red.
            XCTAssertEqual(receivedError.reason, "Network failed")
            expectation.fulfill()  // Cumple la expectativa si el error es correcto.
        }
        
        waitForExpectations(timeout: 5)  // Espera que se cumpla la expectativa.
        XCTAssertNil(dataSource.session)  // Verifica que la sesión no se haya almacenado en caso de error.
    }
    
    // Test para verificar que el caso de uso falla debido a una contraseña inválida.
    func testFailureDueToInvalidPassword() {
        let dataSource = DummySessionDataSource()  // Fuente de datos simulada.
        let sut = LoginUseCase(dataSource: dataSource)  // Caso de uso a probar.
        
        let expectation = self.expectation(description: "TestInvalidPassword")  // Establece una expectativa.
        
        // Ejecuta el caso de uso con una contraseña incorrecta.
        sut.execute(credentials: Credentials(username: "a@b.es", password: "123")) { result in
            guard case let .failure(receivedError) = result else {
                XCTFail("Expected failure due to invalid password")  // Marca el test como fallido si no hay error.
                return
            }
            // Verifica que el error recibido sea debido a la contraseña inválida.
            XCTAssertEqual(receivedError.reason, "Invalid password")
            expectation.fulfill()  // Cumple la expectativa si el error es correcto.
        }
        
        waitForExpectations(timeout: 5)  // Espera que se cumpla la expectativa.
        XCTAssertNil(dataSource.session)  // Verifica que la sesión no se haya almacenado.
    }

    // Test para verificar que el caso de uso falla debido a un error de red.
    func testFailureDueToNetworkError() {
        let dataSource = DummySessionDataSource()  // Fuente de datos simulada.
        let sut = LoginUseCase(dataSource: dataSource)  // Caso de uso a probar.
        
        let expectation = self.expectation(description: "TestNetworkError")  // Establece una expectativa.
        let error = APIErrorResponse.network("login")  // Simula un error de red.
        
        // Simula una respuesta fallida de la API debido a un error de red.
        APISession.shared = APISessionMock { _ in .failure(error) }
        
        // Ejecuta el caso de uso con credenciales válidas pero con error de red.
        sut.execute(credentials: Credentials(username: "a@b.es", password: "12345")) { result in
            guard case let .failure(receivedError) = result else {
                XCTFail("Expected failure due to network error")  // Marca el test como fallido si no hay error.
                return
            }
            // Verifica que el error recibido sea de tipo fallo de red.
            XCTAssertEqual(receivedError.reason, "Network failed")
            expectation.fulfill()  // Cumple la expectativa si el error es correcto.
        }
        
        waitForExpectations(timeout: 5)  // Espera que se cumpla la expectativa.
        XCTAssertNil(dataSource.session)  // Verifica que la sesión no se haya almacenado.
    }
    
    // Test para verificar que el caso de uso falla debido a credenciales vacías (nombre de usuario y contraseña).
    func testFailureDueToEmptyCredentials() {
        let dataSource = DummySessionDataSource()  // Fuente de datos simulada.
        let sut = LoginUseCase(dataSource: dataSource)  // Caso de uso a probar.
        
        let expectation = self.expectation(description: "TestEmptyCredentials")  // Establece una expectativa.
        
        // Ejecuta el caso de uso con credenciales vacías.
        sut.execute(credentials: Credentials(username: "", password: "")) { result in
            guard case let .failure(receivedError) = result else {
                XCTFail("Expected failure due to empty credentials")  // Marca el test como fallido si no hay error.
                return
            }
            // Verifica que el error recibido sea debido a un nombre de usuario vacío.
            XCTAssertEqual(receivedError.reason, "Invalid username")  // El error debería ser por nombre de usuario inválido.
            expectation.fulfill()  // Cumple la expectativa si el error es correcto.
        }
        
        waitForExpectations(timeout: 5)  // Espera que se cumpla la expectativa.
        XCTAssertNil(dataSource.session)  // Verifica que la sesión no se haya almacenado.
    }
}

/*
 @testable import SWPatterns
 import XCTest
 
 final class APISessionMock: APISessionContract {
 let mockResponse: (any APIRequest) -> Result<Data, Error>
 
 init(mockResponse: @escaping (any APIRequest) -> Result<Data, Error>) {
 self.mockResponse = mockResponse
 }
 
 func request<Request: APIRequest>(apiRequest: Request, completion: @escaping (Result<Data, Error>) -> Void) {
 // Simula una respuesta de la API
 completion(mockResponse(apiRequest))
 }
 }
 
 final class DummySessionDataSource: SessionDataSourceContract {
 func resetSession() {
 self.session = nil
 }
 
 private(set) var session: Data?
 
 func storeSession(_ session: Data) {
 self.session = session
 }
 
 func getSession() -> Data? { nil }
 
 }
 
 final class LoginUseCaseTests: XCTestCase {
 // 1. Test de éxito en la autenticación
 func testSuccessStoresToken() {
 let dataSource = DummySessionDataSource()
 let sut = LoginUseCase(dataSource: dataSource)
 
 let expectation = self.expectation(description: "TestSuccess")
 let data = Data("hello-world".utf8)
 
 APISession.shared = APISessionMock { _ in .success(data) }
 sut.execute(credentials: Credentials(username: "a@b.es", password: "122345")) { result in
 guard case .success = result else {
 return
 }
 expectation.fulfill()
 }
 
 waitForExpectations(timeout: 5)
 XCTAssertEqual(dataSource.session, data)
 }
 
 // 2. Test de validación de nombre de usuario inválido
 func testFailureDueToInvalidCredentials() {
 let dataSource = DummySessionDataSource()
 let sut = LoginUseCase(dataSource: dataSource)
 
 let expectation = self.expectation(description: "TestFailureDueToInvalidCredentials")
 
 // Simulamos una respuesta fallida de la API (error de red, por ejemplo)
 APISession.shared = APISessionMock { _ in .failure(APIErrorResponse.network("login")) }
 
 // Ejecutamos el caso de uso con credenciales incorrectas
 sut.execute(credentials: Credentials(username: "a@b.es", password: "wrong-password")) { result in
 guard case let .failure(receivedError) = result else {
 XCTFail("Expected failure, but got success")
 return
 }
 
 // Verificamos que el error recibido tenga el mensaje esperado
 XCTAssertEqual(receivedError.reason, "Network failed")
 expectation.fulfill()
 }
 
 waitForExpectations(timeout: 5)
 XCTAssertNil(dataSource.session)  // Verificamos que la sesión no se almacene en caso de error
 }
 // 3. Test de validación de contraseña inválida
 func testFailureDueToInvalidPassword() {
 let dataSource = DummySessionDataSource()
 let sut = LoginUseCase(dataSource: dataSource)
 
 let expectation = self.expectation(description: "TestInvalidPassword")
 
 sut.execute(credentials: Credentials(username: "a@b.es", password: "123")) { result in
 guard case let .failure(receivedError) = result else {
 XCTFail("Expected failure due to invalid password")
 return
 }
 XCTAssertEqual(receivedError.reason, "Invalid password")
 expectation.fulfill()
 }
 
 waitForExpectations(timeout: 5)
 XCTAssertNil(dataSource.session)  // Verificamos que la sesión no se almacena
 }
 
 // 4. Test de error de red
 func testFailureDueToNetworkError() {
 let dataSource = DummySessionDataSource()
 let sut = LoginUseCase(dataSource: dataSource)
 
 let expectation = self.expectation(description: "TestNetworkError")
 let error = APIErrorResponse.network("login")  // Simulamos un error de red
 
 APISession.shared = APISessionMock { _ in .failure(error) }
 
 sut.execute(credentials: Credentials(username: "a@b.es", password: "12345")) { result in
 guard case let .failure(receivedError) = result else {
 XCTFail("Expected failure due to network error")
 return
 }
 XCTAssertEqual(receivedError.reason, "Network failed")
 expectation.fulfill()
 }
 
 waitForExpectations(timeout: 5)
 XCTAssertNil(dataSource.session)  // Verificamos que la sesión no se almacena
 }
 
 // 5. Test de credenciales vacías (nombre de usuario y contraseña)
 func testFailureDueToEmptyCredentials() {
 let dataSource = DummySessionDataSource()
 let sut = LoginUseCase(dataSource: dataSource)
 
 let expectation = self.expectation(description: "TestEmptyCredentials")
 
 sut.execute(credentials: Credentials(username: "", password: "")) { result in
 guard case let .failure(receivedError) = result else {
 XCTFail("Expected failure due to empty credentials")
 return
 }
 XCTAssertEqual(receivedError.reason, "Invalid username")  // Verificamos que la validación del nombre de usuario falla primero
 expectation.fulfill()
 }
 
 waitForExpectations(timeout: 5)
 XCTAssertNil(dataSource.session)  // Verificamos que la sesión no se almacena
 }
 }
 */
