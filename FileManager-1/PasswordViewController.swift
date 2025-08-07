import UIKit

final class PasswordViewController: UIViewController {
    var forceCreateMode: Bool = false

    private let textField = UITextField()
    private let button = UIButton(type: .system)
    private var firstInputPassword: String?

    private var isCreatingPassword: Bool {
        return forceCreateMode || !PasswordManager.shared.passwordExists()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        updateButtonTitle()
    }

    private func setupUI() {
        textField.placeholder = "Введите пароль"
        textField.isSecureTextEntry = true
        textField.borderStyle = .roundedRect

        button.addTarget(self, action: #selector(handleButton), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [textField, button])
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
    }

    private func updateButtonTitle() {
        if forceCreateMode {
            if firstInputPassword != nil {
                button.setTitle("Повторите пароль", for: .normal)
            } else if PasswordManager.shared.passwordExists() {
                button.setTitle("Поменять пароль", for: .normal)
            } else {
                button.setTitle("Создать пароль", for: .normal)
            }
        } else {
            if isCreatingPassword {
                button.setTitle(firstInputPassword == nil ? "Создать пароль" : "Повторите пароль", for: .normal)
            } else {
                button.setTitle("Введите пароль", for: .normal)
            }
        }
    }

    @objc private func handleButton() {
        guard let input = textField.text, input.count >= 4 else {
            showError("Пароль должен быть минимум 4 символа")
            return
        }

        if isCreatingPassword {
            if firstInputPassword == nil {
                firstInputPassword = input
                textField.text = ""
                updateButtonTitle()
            } else {
                if input == firstInputPassword {
                    PasswordManager.shared.savePassword(input)
                    showMainApp()
                } else {
                    showError("Пароли не совпадают")
                    firstInputPassword = nil
                    textField.text = ""
                    updateButtonTitle()
                }
            }
        } else {
            if PasswordManager.shared.validate(password: input) {
                showMainApp()
            } else {
                showError("Неверный пароль")
            }
        }
    }

    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .default))
        present(alert, animated: true)
    }

    private func showMainApp() {
        let tabBar = UITabBarController()
        let filesVC = ViewController()
        filesVC.tabBarItem = UITabBarItem(title: "Файлы", image: UIImage(systemName: "folder"), tag: 0)

        let settingsVC = SettingsViewController()
        settingsVC.tabBarItem = UITabBarItem(title: "Настройки", image: UIImage(systemName: "gear"), tag: 1)

        tabBar.viewControllers = [UINavigationController(rootViewController: filesVC),
                                  UINavigationController(rootViewController: settingsVC)]
        tabBar.modalPresentationStyle = .fullScreen
        present(tabBar, animated: true)
    }
}

