import UIKit

class SettingsVC: UIViewController {
    
    lazy var changePasswordButton: UIButton = {
        let button = UIButton()
        button.setTitle("Change Password", for: .normal)
        button.backgroundColor = .systemBlue.withAlphaComponent(0.8)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 6
        button.addTarget(self, action: #selector(changePasswordButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        view.backgroundColor = .white
        view.addSubview(changePasswordButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            changePasswordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            changePasswordButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            changePasswordButton.widthAnchor.constraint(equalToConstant: 170)
        ])
    }
    
    @objc func changePasswordButtonTapped() {
        let passwordManager = PasswordManager()
        let vc = NewPasswordVC(passwordManager: passwordManager)
        present(vc, animated: true)
    }
}
