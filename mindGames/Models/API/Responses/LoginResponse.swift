struct AuthResponse: Decodable {
    let token: TokenResponse
    let user: UserResponse
}
