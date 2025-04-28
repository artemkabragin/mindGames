final class GameService {
    
    // MARK: - Static Properties
    
    static let shared = GameService()
    
    // MARK: - Private Properties
    
    private let client = HTTPClient.shared
    
    // MARK: - Init
    
    private init() {
    }
    
    func sendAttempt(
        _ attempt: Double,
        gameType: GameType
    ) async throws {
        let body = GameAttemptRequest(attempt: attempt)
        do {
            let status: String = try await client.sendRequest(requestType: .play(body))
            print(status)
        } catch {
            throw error
        }
    }
    
    func sendOnboardingAttempts(
        _ attempts: [Double],
        gameType: GameType
    ) async throws -> Double {
        let body = OnboardingRequest(attempts: attempts)
        do {
            let initialAverage: Double = try await client.sendRequest(requestType: .onboarding(body))
            print(initialAverage)
            return initialAverage
        } catch {
            throw error
        }
    }
    
    func getProgress(by gameType: GameType) async throws -> Double {
        let body = GameProgressRequest(gameType: gameType)
        do {
            let progress: ProgressResponse = try await client.sendRequest(requestType: .progress(body))
            print(progress)
            return progress.progress
        } catch {
            throw error
        }
    }
}
