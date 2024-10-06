import UIKit

// MARK: - LoginViewController
// Controlador de vista responsable de manejar la pantalla de inicio de sesión (login).
// Se conecta a un `LoginViewModel` que gestiona la lógica de autenticación y utiliza bindings
// para reaccionar a los cambios de estado del proceso de login (éxito, error, cargando).
final class LoginViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var usernameField: UITextField!
    @IBOutlet private weak var passwordField: UITextField!
    @IBOutlet private weak var spinner: UIActivityIndicatorView!
    @IBOutlet private weak var signInButton: UIButton!
    @IBOutlet private weak var errorLabel: UILabel!
    
    // MARK: - Propiedades
    // El ViewModel que contiene la lógica de autenticación.
    private let viewModel: LoginViewModel
    
    // MARK: - Inicialización
    // Inicializa el controlador con un ViewModel inyectado.
    // - Parameter viewModel: El ViewModel que contiene la lógica de login.
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "LoginView", bundle: Bundle(for: type(of: self)))
    }
    
    // Este inicializador no debe ser utilizado y genera un error fatal si se invoca.
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Ciclo de vida de la vista
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configura identificadores de accesibilidad para las pruebas.
        usernameField.accessibilityIdentifier = "usernameTextField"
        passwordField.accessibilityIdentifier = "passwordTextField"
        signInButton.accessibilityIdentifier = "loginButton"
        
        // Vincula el estado del ViewModel a la vista.
        bind()
    }
    
    // MARK: - Acciones
    // Método que se ejecuta cuando se pulsa el botón de inicio de sesión.
    // Invoca al método `signIn` del ViewModel con los valores de los campos de texto.
    @IBAction func onLoginButtonTapped(_ sender: Any) {
        viewModel.signIn(usernameField.text, passwordField.text)
    }
    
    // MARK: - Vinculación (binding)
    // Vincula el estado del ViewModel a la vista, actualizando la interfaz de usuario en función del estado actual (loading, success, error).
    private func bind() {
        viewModel.onStateChanged.bind { [weak self] state in
            switch state {
            case .success:
                // Reproduce música al iniciar sesión correctamente.
                AudioPlayerManager.shared.playMusic()
                self?.renderSuccess()
                // Presenta la pantalla de la lista de héroes después de un login exitoso.
                self?.present(HeroesListBuilder().build(), animated: true)
            case .error(let reason):
                self?.renderError(reason)
            case .loading:
                self?.renderLoading()
            }
        }
    }
    
    // MARK: - Funciones de renderizado de estado
    // Muestra la interfaz de éxito al completar el login correctamente.
    private func renderSuccess() {
        signInButton.isHidden = false
        spinner.stopAnimating()
        errorLabel.isHidden = true
    }
    
    // Muestra un mensaje de error si ocurre un problema durante el login.
    private func renderError(_ reason: String) {
        signInButton.isHidden = false
        spinner.stopAnimating()
        errorLabel.isHidden = false
        errorLabel.text = reason
    }
    
    // Muestra la interfaz de carga mientras el login está en progreso.
    private func renderLoading() {
        signInButton.isHidden = true
        spinner.startAnimating()
        errorLabel.isHidden = true
    }
}

#Preview {
    LoginBuilder().build()
}
