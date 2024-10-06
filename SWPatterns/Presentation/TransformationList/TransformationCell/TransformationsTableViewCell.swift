//
//  TransformationsTableViewCell.swift
//  SWPatterns
//
//  Created by Juan Carlos Rubio Casas on 5/10/24.
//

import UIKit

// MARK: - TransformationsTableViewCell
// Clase personalizada que representa una celda en el `UITableView` que muestra las transformaciones de un héroe.
// Esta celda incluye una imagen y el nombre de la transformación.
class TransformationsTableViewCell: UITableViewCell {

    // MARK: - Outlets
    // Imagen que representa la transformación del héroe.
    @IBOutlet weak var transformationImage: AsyncImageView!
    
    // Etiqueta que muestra el nombre de la transformación.
    @IBOutlet weak var transformationName: UILabel!
    
    // MARK: - Ciclo de vida de la celda
    // Método que se llama después de que la celda se ha cargado desde el nib.
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Configura la imagen de la transformación para que tenga un tamaño fijo.
        transformationImage.translatesAutoresizingMaskIntoConstraints = false
        transformationImage.contentMode = .scaleAspectFill
        transformationImage.clipsToBounds = true
        
        // Establece restricciones para que la imagen tenga un tamaño fijo de 100x100 puntos.
        NSLayoutConstraint.activate([
            transformationImage.widthAnchor.constraint(equalToConstant: 100),  // Ancho fijo
            transformationImage.heightAnchor.constraint(equalToConstant: 100)  // Alto fijo
        ])
    }
    
    // MARK: - setSelected
    // Método que se llama cuando una celda es seleccionada o deseleccionada.
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
