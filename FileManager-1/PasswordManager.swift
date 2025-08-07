import Foundation
import KeychainAccess

class PasswordManager {
    static let shared = PasswordManager()
    private let keychain = Keychain(service: "com.yourcompany.documentsviewer")

    private let passwordKey = "user_password"

    func savePassword(_ password: String) {
        keychain[passwordKey] = password
    }

    func getPassword() -> String? {
        return keychain[passwordKey]
    }

    func clearPassword() {
        try? keychain.remove(passwordKey)
    }

    func passwordExists() -> Bool {
        return getPassword() != nil
    }

    func validate(password: String) -> Bool {
        return password == getPassword()
    }
}


