//
//  TransformationsViewController.swift
//  SWPatterns
//
//  Created by Juan Carlos Rubio Casas on 5/10/24.
//

import UIKit

// MARK: - TransformationsViewController
// Controlador de vista que muestra la lista de transformaciones de un héroe en un `UITableView`.
// Se conecta a un `TransformationsListViewModel` que maneja la lógica de negocio y el estado de la vista.
class TransformationsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Outlets
    // Conexiones con los componentes de la interfaz de usuario para la lista de transformaciones.
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var errorPannel: UIStackView!
    @IBOutlet weak var errorLabel: UILabel!
    
    // MARK: - Propiedades
    // El ViewModel que contiene la lógica de negocio para la lista de transformaciones.
    private let viewModel: TransformationsListViewModel
    
    // MARK: - Inicialización
    // Inicializador personalizado que recibe el ViewModel como parámetro.
    // - Parameter viewModel: El ViewModel que maneja la lógica de la lista de transformaciones.
    init(viewModel: TransformationsListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "TransformationsViewController", bundle: Bundle(for: type(of: self)))
    }
    
    // Este inicializador no debe ser utilizado y genera un error fatal si se invoca.
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Ciclo de vida de la vista
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configuración del título de la pantalla.
        title = "Transformations list"
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.red,
            .font: UIFont.boldSystemFont(ofSize: 25)
        ]
        
        // Configuración de la tabla.
        tableView.dataSource = self
        tableView.delegate = self
        
        // Registro de la celda personalizada.
        tableView.register(UINib(nibName: "TransformationsTableViewCell", bundle: nil), forCellReuseIdentifier: "TransformationsTableViewCell")
        
        // Vincula el estado del ViewModel a la vista y carga los datos.
        bind()
        viewModel.load()
    }
    
    // MARK: - Binding
    // Vincula el estado del ViewModel a la vista, actualizando la interfaz en función del estado actual (loading, success, error).
    private func bind() {
        viewModel.onStateChanged.bind { [weak self] state in
            DispatchQueue.main.async {
                switch state {
                case .loading:
                    self?.renderLoading()
                case .success:
                    self?.renderSuccess()
                case .error(let reason):
                    self?.renderError(reason)
                }
            }
        }
    }
    
    // MARK: - Manejo de estados
    // Muestra la interfaz de carga mientras los datos se están cargando.
    private func renderLoading() {
        spinner.startAnimating()
        errorPannel.isHidden = true
        tableView.isHidden = true
    }
    
    // Muestra la lista de transformaciones cuando los datos se han cargado correctamente.
    private func renderSuccess() {
        spinner.stopAnimating()
        errorPannel.isHidden = true
        tableView.isHidden = false
        tableView.reloadData()
    }
    
    // Muestra un mensaje de error si ocurre un problema durante la carga de datos.
    private func renderError(_ reason: String) {
        spinner.stopAnimating()
        errorLabel.text = reason
        errorPannel.isHidden = false
        tableView.isHidden = true
    }
    
    // MARK: - UITableViewDataSource
    // Devuelve el número de filas en la tabla, que es el número de transformaciones cargadas.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.transformations.count
    }
    
    // Configura cada celda de la tabla con el nombre y la imagen de la transformación.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TransformationsTableViewCell", for: indexPath) as? TransformationsTableViewCell else {
            return UITableViewCell()
        }
        
        let transformation = viewModel.transformations[indexPath.row]
        cell.transformationName.text = transformation.name
        cell.transformationImage.setImage(transformation.photo)
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    // Maneja la selección de una fila en la tabla. Navega a la pantalla de detalle de la transformación seleccionada.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedTransformation = viewModel.transformations[indexPath.row]
        
        // Llama al TransformationDetailBuilder para mostrar los detalles de la transformación seleccionada.
        TransformationDetailBuilder.build(
            with: viewModel.heroId,  // heroId es gestionado por el ViewModel
            transformationId: selectedTransformation.identifier,  // Identificador de la transformación seleccionada
            in: navigationController  // Usa el navigationController para hacer el push
        )
    }
}
