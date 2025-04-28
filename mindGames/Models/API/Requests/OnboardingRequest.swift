struct OnboardingRequest: Encodable {
    let gameType: GameType
    let attempts: [Double]
}
