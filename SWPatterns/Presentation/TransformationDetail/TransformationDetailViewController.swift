//
//  TransformationDetailViewController.swift
//  SWPatterns
//
//  Created by Juan Carlos Rubio Casas on 5/10/24.
//

import UIKit

// MARK: - TransformationDetailViewController
// Controlador de vista responsable de mostrar el detalle de una transformación específica de un héroe.
// Se conecta a un `TransformationDetailViewModel` que maneja la lógica de negocio y el estado de la vista.
class TransformationDetailViewController: UIViewController {
    
    // MARK: - Outlets
    // Conectores a los elementos de la interfaz de usuario que muestran los detalles de la transformación.
    @IBOutlet weak var transformationImage: AsyncImageView!
    @IBOutlet weak var transformationName: UILabel!
    @IBOutlet weak var transformationDescription: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    // MARK: - Propiedades
    // El ViewModel que contiene la lógica de negocio para la pantalla de detalle de la transformación.
    private let viewModel: TransformationDetailViewModel
    
    // MARK: - Inicialización
    // Inicializador personalizado que recibe el ViewModel como parámetro.
    // - Parameter viewModel: El ViewModel que contiene la lógica de la transformación.
    init(viewModel: TransformationDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    // Este inicializador no debe ser utilizado y genera un error fatal si se invoca.
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Ciclo de vida de la vista
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configuración inicial de la imagen de la transformación con tamaño fijo.
        transformationImage.translatesAutoresizingMaskIntoConstraints = false
        transformationImage.contentMode = .scaleAspectFill
        transformationImage.clipsToBounds = true
        
        // Definición de las restricciones para el tamaño y la posición de la imagen.
        NSLayoutConstraint.activate([
            transformationImage.widthAnchor.constraint(equalToConstant: 361),  // Ancho fijo
            transformationImage.heightAnchor.constraint(equalToConstant: 220), // Alto fijo
            transformationImage.centerXAnchor.constraint(equalTo: view.centerXAnchor)  // Centrar horizontalmente en la vista
        ])
        
        // Enlaza el ViewModel al ViewController para manejar los cambios de estado.
        bindViewModel()
        
        // Inicia la carga de datos llamando al método `load` del ViewModel.
        viewModel.load()
    }
    
    // MARK: - Binding
    // Vincula el estado del ViewModel a la vista, actualizando la interfaz en función del estado actual (loading, success, error).
    private func bindViewModel() {
        viewModel.onStateChanged.bind { [weak self] state in
            DispatchQueue.main.async {
                switch state {
                case .loading:
                    // Muestra el spinner mientras los datos se están cargando.
                    self?.spinner.startAnimating()
                case .success:
                    // Detiene el spinner y actualiza la interfaz cuando los datos se han cargado correctamente.
                    self?.spinner.stopAnimating()
                    self?.updateUI()
                case .error(let reason):
                    // Muestra el mensaje de error si ocurre un problema al cargar los datos.
                    self?.showError(message: reason)
                }
            }
        }
    }
    
    // MARK: - Actualización de la UI
    // Actualiza la interfaz de usuario con los detalles de la transformación cargada.
    private func updateUI() {
        // Asegura que la transformación esté disponible antes de actualizar la interfaz.
        guard let transformation = viewModel.transformation else { return }
        
        // Asigna los valores de la transformación a los elementos de la interfaz de usuario.
        transformationName.text = transformation.name
        transformationDescription.text = transformation.description
        transformationImage.setImage(transformation.photo)  // Carga la imagen de manera asíncrona.
    }
    
    // MARK: - Manejo de errores
    // Muestra un mensaje de error si ocurre un problema durante la carga de datos.
    private func showError(message: String) {
        // Muestra el error en la consola o en la interfaz de usuario según sea necesario.
        print("Error: \(message)")
    }
}
