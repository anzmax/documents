import UIKit
import KeychainAccess

class NewPasswordVC: UIViewController {
    
    let passwordManager: PasswordManager
    
    init(passwordManager: PasswordManager) {
        self.passwordManager = passwordManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var currentPasswordTextField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.placeholder = "Current password"
        field.borderStyle = .roundedRect
        field.textAlignment = .center
        field.tintColor = .gray
        return field
    }()
    
    lazy var newPasswordTextField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.placeholder = "New password"
        field.borderStyle = .roundedRect
        field.textAlignment = .center
        field.tintColor = .gray
        return field
    }()
    
    var firstStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 24
        return stack
    }()
    
    lazy var changeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Change", for: .normal)
        button.backgroundColor = .systemBlue.withAlphaComponent(0.8)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 6
        button.addTarget(self, action: #selector(changeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("Delete", for: .normal)
        button.backgroundColor = .systemBlue.withAlphaComponent(0.8)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 6
        button.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        return button
    }()
    
    var secondStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 24
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(firstStackView)
        view.addSubview(secondStackView)
        firstStackView.addArrangedSubview(currentPasswordTextField)
        firstStackView.addArrangedSubview(newPasswordTextField)
        secondStackView.addArrangedSubview(changeButton)
        secondStackView.addArrangedSubview(deleteButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            firstStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            firstStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
            firstStackView.widthAnchor.constraint(equalToConstant: 200),
            
            secondStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            secondStackView.topAnchor.constraint(equalTo: firstStackView.bottomAnchor, constant: 40),
            secondStackView.widthAnchor.constraint(equalToConstant: 200),
        ])
    }
    
    @objc func changeButtonTapped() {
        guard let newPassword = newPasswordTextField.text, !newPassword.isEmpty else {
            showError("Введите новый пароль")
            return
        }
        
        let userDefaults = UserDefaults.standard
        userDefaults.set(newPassword, forKey: "savedPassword")
        
        passwordManager.setPassword(newPassword)
        let vc = PasswordVС(passwordManager: passwordManager)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func deleteButtonTapped() {
        passwordManager.deletePassword()
        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: "deletedPassword")
        self.dismiss(animated: true, completion: nil)
    }
    
    func showError(_ message: String) {
        let alertController = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}
