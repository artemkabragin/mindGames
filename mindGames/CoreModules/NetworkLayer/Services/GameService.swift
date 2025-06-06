final class GameService {
    
    // MARK: - Static Properties
    
    static let shared = GameService()
    
    // MARK: - Private Properties
    
    private let client = HTTPClient.shared
    
    // MARK: - Init
    
    private init() {}
    
    func sendAttempt(
        _ attempt: Double,
        gameType: GameType
    ) async throws -> [AchievementWithProgress] {
        let body = GameAttemptRequest(
            gameType: gameType,
            attempt: attempt
        )
        do {
            let achivements: [AchievementWithProgress] = try await client.sendRequest(requestType: .play(body))
            print(achivements)
            return achivements
        } catch {
            throw error
        }
    }
    
    func sendOnboardingAttempts(
        _ attempts: [Double],
        gameType: GameType
    ) async throws -> OnboardingResponse {
        let body = OnboardingRequest(
            gameType: gameType,
            attempts: attempts
        )
        do {
            let response: OnboardingResponse = try await client.sendRequest(requestType: .onboarding(body))
            print(response.average)
            return response
        } catch {
            throw error
        }
    }
    
    func getProgress(by type: ProgressType) async throws -> Double {
        let body = GameProgressRequest(type: type)
        do {
            let progress: ProgressResponse = try await client.sendRequest(requestType: .progress(body))
            print(progress)
            return progress.progress
        } catch {
            throw error
        }
    }
}
