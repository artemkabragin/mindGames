final class AchievementService {
    
    // MARK: - Static Properties
    
    static let shared = AchievementService()
    
    // MARK: - Private Properties
    
    private let client = HTTPClient.shared
    
    // MARK: - Init
    
    private init() {
    }
    
    func loadAchievements() async throws -> [AchievementWithProgress] {
        do {
            let response: AchievementResponse = try await client.sendRequest(requestType: .achievements)
            print(response)
            return response.achievements
        } catch {
            throw error
        }
    }
    
//    func sendOnboardingAttempts(
//        _ attempts: [Double],
//        gameType: GameType
//    ) async throws -> Double {
//        let body = OnboardingRequest(
//            gameType: gameType,
//            attempts: attempts
//        )
//        do {
//            let initialAverage: Double = try await client.sendRequest(requestType: .onboarding(body))
//            print(initialAverage)
//            return initialAverage
//        } catch {
//            throw error
//        }
//    }
//    
//    func getProgress(by type: ProgressType) async throws -> Double {
//        let body = GameProgressRequest(type: type)
//        do {
//            let progress: ProgressResponse = try await client.sendRequest(requestType: .progress(body))
//            print(progress)
//            return progress.progress
//        } catch {
//            throw error
//        }
//    }
}
