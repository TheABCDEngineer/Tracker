import Foundation

extension UserDefaults {
    func setJSON <T: Codable> (codable: T, forKey key: String) {
        let data = try! JSONEncoder().encode(codable)
        UserDefaults.standard.set(data, forKey: key)
    }
    
    func getJSON <T: Codable> (forKey key: String) -> T? {
        guard let data = UserDefaults.standard.data(forKey: key) else { return nil }
        let encodingData = try! JSONDecoder().decode(T.self, from: data)
        return encodingData
    }
}
