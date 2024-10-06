import UIKit

// MARK: - HeroesListViewController
// Controlador de vista responsable de mostrar una lista de héroes en una tabla.
// Utiliza un ViewModel (HeroesListViewModel) para manejar la lógica de negocio, y la tabla para mostrar los héroes.
// El controlador también maneja la reproducción de música de fondo y la navegación hacia la pantalla de detalle de un héroe.
final class HeroesListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - Outlets
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var spinner: UIActivityIndicatorView!
    @IBOutlet private weak var errorContainer: UIStackView!
    @IBOutlet private weak var errorLabel: UILabel!
    
    // MARK: - Propiedades
    // El ViewModel que maneja la lógica para obtener la lista de héroes y notificar sobre cambios de estado.
    private let viewModel: HeroesListViewModel
    
    // MARK: - Inicialización
    // Inicializa el controlador con un ViewModel inyectado.
    // - Parameter viewModel: El ViewModel que contiene la lógica para cargar y manejar la lista de héroes.
    init(viewModel: HeroesListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "HeroesListView", bundle: Bundle(for: type(of: self)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Ciclo de vida de la vista
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configura la accesibilidad de la tabla para pruebas.
        tableView.accessibilityIdentifier = "heroesTableView"
        
        // Configuración del título de la barra de navegación.
        title = "Hero list"
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.red,
            .font: UIFont.boldSystemFont(ofSize: 25)
        ]
        
        // Configuración de la tabla.
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        
        // Registra la celda personalizada para la tabla.
        tableView.register(HeroTableViewCell.nib, forCellReuseIdentifier: HeroTableViewCell.reuseIdentifier)
        
        // Configura el botón de música en la barra de navegación.
        configureMusicButton()
        
        // Vincula el estado del ViewModel a la vista y carga los datos iniciales.
        bind()
        viewModel.load()
    }
    
    // MARK: - Configuración del botón de música
    // Configura el botón de música en la barra de navegación para controlar la reproducción de música.
    private func configureMusicButton() {
        let musicButton = UIBarButtonItem(title: "Music OFF", style: .plain, target: self, action: #selector(musicButtonTapped))
        musicButton.tintColor = .black
        navigationItem.rightBarButtonItem = musicButton
    }

    // Acción del botón de música. Inicia o detiene la música según el estado actual.
    @objc private func musicButtonTapped() {
        if let musicButton = navigationItem.rightBarButtonItem {
            if musicButton.title == "Music ON" {
                print("Musica iniciada")
                AudioPlayerManager.shared.playMusic()
                musicButton.title = "Music OFF"
            } else {
                print("Musica detenida")
                AudioPlayerManager.shared.stopMusic()
                musicButton.title = "Music ON"
            }
        }
    }
    
    // Acción para reintentar cargar los datos en caso de error.
    @IBAction func onRetryTapped(_ sender: Any) {
        viewModel.load()
    }
    
    // MARK: - Vinculación (binding)
    // Vincula el estado del ViewModel a la vista, actualizando la interfaz según el estado (loading, success, error).
    private func bind() {
        viewModel.onStateChanged.bind { [weak self] state in
            switch state {
            case .loading:
                self?.renderLoading()
            case .success:
                self?.renderSuccess()
            case .error(let error):
                self?.renderError(error)
            }
        }
    }
    
    // Muestra la vista de error cuando ocurre un problema al cargar los datos.
    private func renderError(_ reason: String) {
        spinner.stopAnimating()
        errorContainer.isHidden = false
        tableView.isHidden = true
        errorLabel.text = reason
    }
    
    // Muestra la vista de carga mientras se están obteniendo los datos.
    private func renderLoading() {
        spinner.startAnimating()
        errorContainer.isHidden = true
        tableView.isHidden = true
    }
    
    // Muestra la tabla con los héroes cuando los datos se han cargado correctamente.
    private func renderSuccess() {
        spinner.stopAnimating()
        errorContainer.isHidden = true
        tableView.isHidden = false
        tableView.reloadData()
    }
    
    // MARK: - UITableViewDataSource
    // Devuelve el número de filas en la tabla, que es el número de héroes en el ViewModel.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.heroes.count
    }
    
    // Configura la celda para cada héroe, asignando el nombre y la imagen del héroe.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HeroTableViewCell.reuseIdentifier, for: indexPath)
        if let cell = cell as? HeroTableViewCell {
            let hero = viewModel.heroes[indexPath.row]
            cell.setAvatar(hero.photo)
            cell.setHeroName(hero.name)
        }
        return cell
    }
    
    // MARK: - UITableViewDelegate
    // Maneja la selección de una fila en la tabla. Navega a la pantalla de detalle del héroe seleccionado.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let hero = viewModel.heroes[indexPath.row]
        HeroDetailBuilder.build(with: hero.name, in: navigationController)
    }
}
#Preview {
    HeroesListBuilder().build()
}
