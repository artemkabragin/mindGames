import Foundation

final class UserDefaultsManager {
    
    // MARK: - Static Properties
    
    static let shared = UserDefaultsManager()
    
    // MARK: - Private Properties
    
    private let defaults = UserDefaults.standard
    private let encoder = JSONEncoder()
    let decoder = JSONDecoder()

    // Сохранение значения
    func save<T: Codable>(
        _ value: T,
        forKey key: StorageKeys
    ) {
        if let encoded = try? encoder.encode(value) {
            defaults.set(encoded, forKey: key.rawValue)
        }
    }

    // Загрузка значения
    func load<T: Codable>(
        _ type: T.Type,
        forKey key: StorageKeys
    ) -> T? {
        guard let data = defaults.data(forKey: key.rawValue) else { return nil }
        
        return try? decoder.decode(T.self, from: data)
    }

    // Удаление
    func remove(forKey key: StorageKeys) {
        defaults.removeObject(forKey: key.rawValue)
    }
}

struct UserSettings: Codable {
    var username: String
    var isPremium: Bool
}

// Сохранение
//Task {
//    let settings = UserSettings(username: "mindgamer", isPremium: true)
//    await UserDefaultsManager.shared.save(settings, forKey: "user_settings")
//}
//
//// Загрузка
//Task {
//    if let settings = await UserDefaultsManager.shared.load(UserSettings.self, forKey: "user_settings") {
//        print(settings.username)  // mindgamer
//    }
//}
