import Foundation

// MARK: - HeroesListState
// Enum que define los diferentes estados posibles del `HeroesListViewModel`.
// Estos estados reflejan el ciclo de vida de la carga de los datos y son utilizados para actualizar la interfaz de usuario.
enum HeroesListState: Equatable {
    case loading  // El estado cuando los datos están siendo cargados.
    case error(reason: String)  // El estado cuando ocurre un error, con una razón proporcionada.
    case success  // El estado cuando los datos se han cargado correctamente.
}

// MARK: - HeroesListViewModel
// ViewModel responsable de manejar la lógica de negocio para la pantalla de la lista de héroes.
// Este ViewModel se comunica con el caso de uso para obtener los héroes y actualiza la interfaz de usuario
// a través de un mecanismo de binding.
final class HeroesListViewModel {
    
    // MARK: - Propiedades
    // `onStateChanged` es un binding que se usa para notificar a la vista cuando el estado cambia (loading, success, error).
    let onStateChanged = Binding<HeroesListState>()
    
    // Arreglo de héroes cargados.
    private(set) var heroes: [Hero] = []
    
    // Caso de uso que maneja la lógica para obtener todos los héroes.
    private let useCase: GetAllHeroesUseCaseContract
    
    // MARK: - Inicialización
    // Inicializa el ViewModel con el caso de uso necesario.
    // - Parameter useCase: Caso de uso que maneja la lógica de obtener la lista de héroes.
    init(useCase: GetAllHeroesUseCaseContract) {
        self.useCase = useCase
    }
    
    // MARK: - Carga de datos
    // Método que inicia la carga de los héroes desde el caso de uso.
    // Actualiza el estado a `loading` al iniciar la carga, y a `success` o `error` dependiendo del resultado.
    func load() {
        // Actualiza el estado a `loading` mientras los héroes están siendo cargados.
        onStateChanged.update(newValue: .loading)
        
        // Ejecuta el caso de uso para obtener la lista de héroes.
        useCase.execute { [weak self] result in
            do {
                // Intenta obtener la lista de héroes del resultado exitoso.
                self?.heroes = try result.get()
                // Actualiza el estado a `success` cuando los héroes se han cargado exitosamente.
                self?.onStateChanged.update(newValue: .success)
            } catch {
                // Si ocurre un error, actualiza el estado a `error` con una descripción del error.
                self?.onStateChanged.update(newValue: .error(reason: error.localizedDescription))
            }
        }
    }
}
