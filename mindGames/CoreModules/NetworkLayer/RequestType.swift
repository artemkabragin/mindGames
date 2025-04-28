import Foundation

enum RequestType {
    case login(UserCredentials)
    case register(UserRegisterRequest)
    
    case onboarding(OnboardingRequest)
    case play(GameAttemptRequest)
    case progress(GameProgressRequest)
    
    case achievements
    
    var url: URL {
        switch self {
        case .login:
            URL(string: "http://localhost:8080/auth/login")!
        case .register:
            URL(string: "http://localhost:8080/auth/register")!
        case .progress(let request):
            URL(string: "http://localhost:8080/users/progress?type=\(request.type.rawValue)")!
        case .onboarding:
            URL(string: "http://localhost:8080/users/onboarding")!
        case .play:
            URL(string: "http://localhost:8080/users/play")!
        case .achievements:
            URL(string: "http://localhost:8080/users/achievements")!
        }
    }
    
    var method: String {
        switch self {
        case .login:
            "POST"
        case .register:
            "POST"
        case .onboarding:
            "POST"
        case .play:
            "POST"
        case .progress:
            "GET"
        case .achievements:
            "GET"
        }
    }
    
    var body: Encodable? {
        switch self {
        case .login(let request):
            request
        case .play(let request):
            request
        case .register(let request):
            request
        case .onboarding(let request):
            request
        default:
            nil
        }
    }
}
