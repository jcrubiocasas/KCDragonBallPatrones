import UIKit

// MARK: - HeroTableViewCell
// Clase que representa una celda personalizada para mostrar un héroe en una tabla (`UITableView`).
// Esta celda muestra el nombre del héroe y una imagen (avatar) que se carga de forma asíncrona.
final class HeroTableViewCell: UITableViewCell {
    
    // MARK: - Propiedades estáticas
    // Identificador de reutilización de la celda para su registro y reutilización en la tabla.
    static let reuseIdentifier = "HeroTableViewCell"
    
    // Devuelve el nib asociado a esta celda para poder registrar y cargar la celda desde un archivo XIB.
    static var nib: UINib {
        UINib(nibName: "HeroTableViewCell", bundle: Bundle(for: HeroTableViewCell.self))
    }
    
    // MARK: - Outlets
    // Elementos de la interfaz que representan el nombre del héroe y el avatar.
    @IBOutlet private weak var heroName: UILabel!
    @IBOutlet private weak var avatar: AsyncImageView!
    
    // MARK: - Ciclo de vida de la celda
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Configuración inicial del avatar
        avatar.translatesAutoresizingMaskIntoConstraints = false
        avatar.contentMode = .scaleAspectFill
        avatar.clipsToBounds = true
        
        // Configuración de restricciones para que el avatar tenga un tamaño fijo.
        NSLayoutConstraint.activate([
            avatar.widthAnchor.constraint(equalToConstant: 100),  // Ancho fijo del avatar.
            avatar.heightAnchor.constraint(equalToConstant: 100)  // Alto fijo del avatar.
        ])
    }
    
    // MARK: - Preparación para reutilización
    // Método que se llama antes de que una celda sea reutilizada en la tabla.
    // Se cancela cualquier carga de imagen en progreso para evitar comportamientos inesperados.
    override func prepareForReuse() {
        super.prepareForReuse()
        avatar.cancel()  // Cancela la carga de la imagen del avatar si está en progreso.
    }
    
    // MARK: - Configuración de la celda
    // Método que asigna la imagen del avatar a la celda utilizando un enlace a una URL o cadena.
    // - Parameter avatar: URL o cadena de texto que representa la imagen del avatar del héroe.
    func setAvatar(_ avatar: String) {
        self.avatar.setImage(avatar)
    }
    
    // Método que asigna el nombre del héroe a la etiqueta de la celda.
    // - Parameter heroName: El nombre del héroe a mostrar.
    func setHeroName(_ heroName: String) {
        self.heroName.text = heroName
    }
}
