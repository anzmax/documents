import UIKit

class PasswordVС: UIViewController {
    
    let passwordManager: PasswordManager
    
    init(passwordManager: PasswordManager) {
        self.passwordManager = passwordManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var passwordTextField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.placeholder = ""
        field.borderStyle = .roundedRect
        field.tintColor = .gray
        return field
    }()
    
    lazy var actionButton: UIButton = {
        let button = UIButton()
        button.setTitle("Создать пароль", for: .normal)
        button.backgroundColor = .systemBlue.withAlphaComponent(0.8)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 6
        button.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(passwordTextField)
        view.addSubview(actionButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            passwordTextField.widthAnchor.constraint(equalToConstant: 170),
            
            actionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            actionButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 16),
            actionButton.widthAnchor.constraint(equalToConstant: 170)
        ])
    }
    
    //MARK: - Action
    
    @objc func actionButtonTapped() {
        if passwordManager.getPassword() != nil {
            verifyPassword()
        } else {
            createPassword()
        }
    }
    
    @objc func createPassword() {
        guard let password = passwordTextField.text, password.count >= 4 else {
            showError("Пароль должен содержать минимум 4 символа")
            return
        }
        if password == passwordTextField.text {
            passwordTextField.text = ""
            passwordManager.setPassword(password)
            actionButton.setTitle("Повторите пароль", for: .normal)
            actionButton.removeTarget(self, action: #selector(createPassword), for: .touchUpInside)
            actionButton.addTarget(self, action: #selector(repeatPassword), for: .touchUpInside)
        } else {
            showError("Пароли не совпадают. Попробуйте снова.")
        }
    }
    
    @objc func repeatPassword() {
        guard let repeatedPassword = passwordTextField.text else {
            showError("Повторите пароль")
            return
        }
        
        if repeatedPassword == passwordManager.getPassword() {
            showNextScreen()
        } else {
            showError("Пароли не совпадают. Попробуйте снова.")
            passwordTextField.text = ""
            actionButton.setTitle("Создать пароль", for: .normal)
            actionButton.removeTarget(self, action: #selector(repeatPassword), for: .touchUpInside)
            actionButton.addTarget(self, action: #selector(createPassword), for: .touchUpInside)
        }
    }
    
    @objc func verifyPassword() {
        guard let enteredPassword = passwordTextField.text else {
            showError("Введите пароль")
            return
        }
        if let savedPassword = passwordManager.getPassword(), enteredPassword == savedPassword {
            showNextScreen()
        } else {
            showError("Неверный пароль. Попробуйте снова.")
        }
    }
    
    func showNextScreen() {
        let imagesVC = ImagesVC()
        let settingsVC = SettingsVC()
        let imagesNAV = UINavigationController(rootViewController: imagesVC)
        let settingsNAV = UINavigationController(rootViewController: settingsVC)
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [imagesNAV, settingsNAV]
        imagesNAV.tabBarItem = UITabBarItem(title: "Photos", image: UIImage(systemName: "photo"), tag: 0)
        settingsNAV.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gearshape"), tag: 1)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController = tabBarController
        }
        
        tabBarController.selectedIndex = 0
    }
    
    func showError(_ message: String) {
        let alertController = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}
