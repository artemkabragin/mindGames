final class AchievementService {
    
    // MARK: - Static Properties
    
    static let shared = AchievementService()
    
    // MARK: - Private Properties
    
    private let client = HTTPClient.shared
    
    // MARK: - Init
    
    private init() {}
    
    // MARK: - Public Methods
    
    func loadAchievements() async throws -> [AchievementWithProgress] {
        do {
            let response: AchievementResponse = try await client.sendRequest(requestType: .achievements)
            print(response)
            return response.achievements
        } catch {
            throw error
        }
    }
}
