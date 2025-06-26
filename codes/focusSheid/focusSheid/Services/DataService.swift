import Foundation

protocol DataServiceProtocol {
    func save<T: Codable>(_ object: T, forKey key: String)
    func load<T: Codable>(_ type: T.Type, forKey key: String) -> T?
}

class DataService: DataServiceProtocol {
    private let userDefaults = UserDefaults.standard
    
    func save<T: Codable>(_ object: T, forKey key: String) {
        do {
            let data = try JSONEncoder().encode(object)
            userDefaults.set(data, forKey: key)
        } catch {
            print("Failed to save \(key): \(error)")
        }
    }
    
    func load<T: Codable>(_ type: T.Type, forKey key: String) -> T? {
        guard let data = userDefaults.data(forKey: key) else { return nil }
        do {
            return try JSONDecoder().decode(type, from: data)
        } catch {
            print("Failed to load \(key): \(error)")
            return nil
        }
    }
}