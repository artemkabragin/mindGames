import Foundation

enum RequestType {
    case login(UserCredentials)
    case progress
    
    var url: URL {
        switch self {
        case .login:
            URL(string: "http://localhost:8080/auth/login")!
        case .progress:
            URL(string: "http://localhost:8080/person/progress")!
        }
    }
    
    var method: String {
        switch self {
        case .login:
            "POST"
        case .progress:
            "GET"
        }
    }
    
    var body: Encodable? {
        switch self {
        case .login(let credentials):
            credentials
        default:
            nil
        }
    }
}
