import Foundation

enum RequestType {
    case login(UserCredentials)
    case register(UserRegisterRequest)
    case progress
    
    var url: URL {
        switch self {
        case .login:
            URL(string: "http://localhost:8080/auth/login")!
        case .register:
            URL(string: "http://localhost:8080/auth/register")!
        case .progress:
            URL(string: "http://localhost:8080/person/progress")!
        }
//        [ NOTICE ] Server started on http://127.0.0.1:8080

    }
    
    var method: String {
        switch self {
        case .login:
            "POST"
        case .register:
            "POST"
        case .progress:
            "GET"
        }
    }
    
    var body: Encodable? {
        switch self {
        case .login(let credentials):
            credentials
        case .register(let credentials):
            credentials
        default:
            nil
        }
    }
}
