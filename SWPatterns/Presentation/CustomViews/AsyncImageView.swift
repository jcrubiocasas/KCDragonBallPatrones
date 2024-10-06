import UIKit

// MARK: - AsyncImageView
// Subclase de `UIImageView` que proporciona la funcionalidad para cargar imágenes de manera asíncrona desde una URL.
// Esta clase utiliza `DispatchWorkItem` para gestionar la carga de imágenes y permite cancelar la operación si es necesario.
final class AsyncImageView: UIImageView {
    
    // Propiedad privada que almacena la referencia al `DispatchWorkItem` actual que gestiona la carga de la imagen.
    private var workItem: DispatchWorkItem?
    
    // MARK: - setImage (String)
    // Método que inicia la carga de una imagen desde una URL representada como cadena de texto.
    // Convierte la cadena de texto en una URL y llama al método sobrecargado `setImage(_ url:)`.
    // - Parameter string: La cadena de texto que contiene la URL de la imagen a cargar.
    func setImage(_ string: String) {
        if let url = URL(string: string) {
            setImage(url)  // Convierte la cadena a URL y llama al método sobrecargado.
        }
    }
    
    // MARK: - setImage (URL)
    // Método que inicia la carga asíncrona de una imagen desde una URL.
    // Utiliza un `DispatchWorkItem` para gestionar la operación de carga y se asegura de que la actualización de la interfaz
    // gráfica se realice en el hilo principal.
    // - Parameter url: La URL de la imagen que se va a cargar.
    func setImage(_ url: URL) {
        // Crea un nuevo `DispatchWorkItem` para cargar la imagen desde la URL.
        let workItem = DispatchWorkItem {
            // Intenta descargar los datos desde la URL y convertirlos en una imagen.
            let image = (try? Data(contentsOf: url)).flatMap { UIImage(data: $0) }
            
            // Regresa al hilo principal para actualizar la interfaz de usuario.
            DispatchQueue.main.async { [weak self] in
                self?.image = image  // Asigna la imagen cargada a la vista de imagen.
                self?.workItem = nil  // Limpia el `workItem` después de completar la carga.
            }
        }
        
        // Ejecuta el `DispatchWorkItem` en una cola global de fondo para evitar bloquear el hilo principal.
        DispatchQueue.global().async(execute: workItem)
        
        // Almacena la referencia al `DispatchWorkItem` actual para permitir su cancelación si es necesario.
        self.workItem = workItem
    }
    
    // MARK: - cancel
    // Método que cancela cualquier operación de carga de imagen en curso.
    // Llama al método `cancel()` en el `DispatchWorkItem` almacenado y limpia la referencia.
    func cancel() {
        workItem?.cancel()  // Cancela el `DispatchWorkItem` en curso si existe.
        workItem = nil  // Limpia la referencia al `workItem`.
    }
}
