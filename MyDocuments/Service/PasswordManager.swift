import Foundation
import KeychainAccess

class PasswordManager {
    private let keychain = Keychain(service: "com.anzmax.MyDocuments")
    
    func setPassword(_ password: String) {
        keychain["password"] = password
    }
    
    func getPassword() -> String? {
        return keychain["password"]
    }
    
    func deletePassword() {
        keychain["password"] = nil
    }
}
