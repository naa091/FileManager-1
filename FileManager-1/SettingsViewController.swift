import UIKit

final class SettingsViewController: UITableViewController {
    enum Section: Int, CaseIterable {
        case sortOrder
        case changePassword
    }
    
    private let sortKey = "sort_ascending"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Настройки"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        Section.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch Section(rawValue: section)! {
        case .sortOrder: return "Сортировка"
        case .changePassword: return "Безопасность"
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = Section(rawValue: indexPath.section)!
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        switch section {
        case .sortOrder:
            let isAscending = UserDefaults.standard.bool(forKey: sortKey)
            cell.textLabel?.text = isAscending ? "А → Я" : "Я → А"
            cell.accessoryType = .disclosureIndicator
        case .changePassword:
            cell.textLabel?.text = "Поменять пароль"
            cell.accessoryType = .disclosureIndicator
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch Section(rawValue: indexPath.section)! {
        case .sortOrder:
            let current = UserDefaults.standard.bool(forKey: sortKey)
            UserDefaults.standard.set(!current, forKey: sortKey)
            tableView.reloadRows(at: [indexPath], with: .automatic)
            NotificationCenter.default.post(name: .sortOrderChanged, object: nil)
        case .changePassword:
            let vc = PasswordViewController()
            vc.forceCreateMode = true // 🔥 Важно
            vc.modalPresentationStyle = .formSheet
            present(vc, animated: true)
        }
    }
}

extension Notification.Name {
    static let sortOrderChanged = Notification.Name("sortOrderChanged")
}

