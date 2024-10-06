//
//  HeroDetailViewController.swift
//  SWPatterns
//
//  Created by Juan Carlos Rubio Casas on 3/10/24.
//

import UIKit

// MARK: - HeroDetailViewController
// Controlador de vista responsable de mostrar los detalles de un héroe, incluyendo su imagen, nombre y descripción.
// También permite la navegación a una lista de transformaciones asociadas al héroe.
final class HeroDetailViewController: UIViewController {
    
    // Outlets conectados a los elementos de la interfaz de usuario definidos en el XIB.
    @IBOutlet weak var heroImage: AsyncImageView!
    @IBOutlet weak var heroName: UILabel!
    @IBOutlet weak var heroDetail: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var transformationButton: UIButton!
    
    // MARK: - Propiedades
    // ViewModel que gestiona la lógica y los datos para esta vista.
    private let viewModel: HeroDetailViewModel
    
    // MARK: - Inicialización
    // Inicializador personalizado que recibe el ViewModel.
    // - Parameter viewModel: El ViewModel que contiene la lógica para cargar y gestionar los datos del héroe.
    init(viewModel: HeroDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "HeroDetailViewController", bundle: nil)
    }
    
    // Este inicializador no se debe usar y lanzará un error si se invoca.
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Ciclo de vida de la vista
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configuración del layout para la imagen del héroe.
        heroImage.translatesAutoresizingMaskIntoConstraints = false
        heroImage.contentMode = .scaleAspectFill
        heroImage.clipsToBounds = true
        NSLayoutConstraint.activate([
            heroImage.widthAnchor.constraint(equalToConstant: 361),  // Ancho fijo de la imagen
            heroImage.heightAnchor.constraint(equalToConstant: 220), // Alto fijo de la imagen
            heroImage.centerXAnchor.constraint(equalTo: view.centerXAnchor)  // Centrar horizontalmente en la vista
        ])
        
        // Enlaza el ViewModel con la vista.
        bind()
        
        // Carga los datos del héroe desde el ViewModel.
        viewModel.load()
    }
    
    // MARK: - Vinculación (binding)
    // Método que conecta el estado del ViewModel con la vista.
    // Dependiendo del estado del ViewModel (éxito, error, o cargando), la vista se actualiza en consecuencia.
    private func bind() {
        viewModel.onStateChanged.bind { [weak self] state in
            switch state {
            case .success:
                self?.renderSuccess()
            case .error(let reason):
                self?.renderError(reason)
            case .loading:
                self?.renderLoading()
            }
        }
    }
    
    // MARK: - Métodos de renderizado
    // Muestra la vista de carga mientras los datos se están cargando.
    private func renderLoading() {
        spinner.startAnimating()
        heroName.isHidden = true
        heroDetail.isHidden = true
        heroImage.isHidden = true
        transformationButton.isHidden = true
    }
    
    // Muestra los detalles del héroe y habilita el botón de transformaciones si están disponibles.
    private func renderSuccess() {
        spinner.stopAnimating()
        
        // Actualiza la vista con los datos del héroe.
        if let hero = viewModel.hero {
            heroName.text = hero.name
            heroDetail.text = hero.description
            heroImage.setImage(hero.photo)  // Carga la imagen del héroe de forma asíncrona.
        }
        
        // Verifica si hay transformaciones disponibles y muestra el botón si es necesario.
        if let transformations = viewModel.transformations, transformations.count > 0 {
            transformationButton.isHidden = false
        } else {
            transformationButton.isHidden = true
        }
        
        heroName.isHidden = false
        heroDetail.isHidden = false
        heroImage.isHidden = false
    }
    
    // Muestra un mensaje de error si ocurre un problema al cargar los datos.
    private func renderError(_ reason: String) {
        spinner.stopAnimating()
        let alert = UIAlertController(title: "Error", message: reason, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Acciones
    // Método que se ejecuta cuando se pulsa el botón de transformaciones.
    // Navega a una nueva pantalla que muestra las transformaciones del héroe.
    @IBAction func transformationButtonTapped(_ sender: Any) {
        guard let heroId = viewModel.hero?.identifier else { return }
        
        // Construye y navega hacia la pantalla de transformaciones.
        let transformationsVC = TransformationsListBuilder().build(with: heroId)
        navigationController?.pushViewController(transformationsVC, animated: true)
    }
}
