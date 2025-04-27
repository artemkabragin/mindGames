import Foundation

public struct ErrorResponse: Decodable, Equatable, Error {
    public var reason: String
}
