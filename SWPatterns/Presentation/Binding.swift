import Foundation

// MARK: - Binding
// Clase genérica que permite establecer una relación reactiva entre el estado de un ViewModel y una vista.
// El patrón Binding facilita la comunicación entre la lógica de negocio (ViewModel) y la vista, actualizando la vista cada vez que el estado cambia.
final class Binding<State> {
    
    // MARK: - Typealias
    // Alias para una closure que recibe un valor del estado y no retorna nada.
    typealias Completion = (State) -> Void
    
    // MARK: - Propiedades
    // La closure que se ejecutará cada vez que el estado cambie.
    var completion: Completion?
    
    // MARK: - Métodos
    // Método que establece la binding (vinculación) con una closure de actualización.
    // - Parameter completion: Closure que se ejecutará cada vez que el estado se actualice.
    func bind(completion: @escaping Completion) {
        self.completion = completion
    }
    
    // Método que actualiza el estado y notifica a la vista vinculada.
    // - Parameter newValue: El nuevo valor del estado.
    func update(newValue: State) {
        // Ejecuta la actualización en el hilo principal para garantizar que los cambios afecten directamente a la interfaz de usuario.
        DispatchQueue.main.async { [weak self] in
            // Llama a la closure almacenada con el nuevo valor del estado, si existe.
            self?.completion?(newValue)
        }
    }
}
