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
    
    func sendRequest<Response: Decodable>(requestType: RequestType) async throws -> Response {
        var request = URLRequest(url: requestType.url)
        request.httpMethod = requestType.method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let token = AuthService.shared.getAccessToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        if let body = requestType.body {
            guard let jsonData = try? encoder.encode(body) else { throw HTTPClientError.badEncode }
            request.httpBody = jsonData
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 401 {
                let refreshed = await AuthService.shared.refreshTokenIfNeeded()
                
                if refreshed {
                    print("LOOOL refreshed success")
                    return try await sendRequest(requestType: requestType)
                } else {
                    print("LOOOL refreshed failure")
                    if let errorResponse = try? decoder.decode(ErrorResponse.self, from: data) {
                        throw errorResponse
                    } else {
                        throw URLError(.userAuthenticationRequired)
                    }
                }
            }
            
            if let errorResponse = try? decoder.decode(ErrorResponse.self, from: data) {
                throw errorResponse
            }
            
            do {
                let responseDTO = try decoder.decode(Response.self, from: data)
                return responseDTO
            } catch {
                throw error
            }
            
        } catch {
            throw error
        }
    }
}
