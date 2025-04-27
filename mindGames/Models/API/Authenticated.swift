//struct Authenticated: Codable {
//    var user: User
//    var token: String
//}

import Foundation

struct Token: Decodable {

    let id: UUID
    let value: String
}
