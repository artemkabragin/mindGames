import Foundation

final class HTTPClient {
    
    // MARK: - Static Properties
    
    static let shared = HTTPClient()
    
    // MARK: - Private Properties
    
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    // MARK: - Init
    
    private init() {}
    
    // MARK: - Public Methods
    
    func sendRequest<ResponseDTO: Decodable>(
        requestType: RequestType
    ) async throws -> ResponseDTO {
        var request = URLRequest(url: requestType.url)
        request.httpMethod = requestType.method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let body = requestType.body {
            guard let jsonData = try? encoder.encode(body) else { throw HTTPClientError.badEncode }
            request.httpBody = jsonData
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            do {
                let responseDTO = try decoder.decode(ResponseDTO.self, from: data)
                return responseDTO
            } catch {
                throw error
            }
        } catch {
            throw error
        }
    }
}
