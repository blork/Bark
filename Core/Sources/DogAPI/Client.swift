import Foundation
import OSLog

public enum HTTPMethod: String {
    case GET
    case POST
}

/// Represents an Endpoint on the dog.ceo API
public enum Endpoint {
    case breeds
    case images(BreedName, Int)
    
    /// Return the path component of the endpoint URL
    var path: String {
        switch self {
        case .breeds:
            "breeds/list/all"
        case .images(let breed, let count):
            "breed/\(breed)/images/random/\(count)"
        }
    }
    
    /// Return the correct HTTP method for this endpoint.
    /// Note: currently all endpoints use GET
    var method: HTTPMethod {
        .GET
    }
}

public enum ClientError: Error {
    /// Cannot convert the endpoint into a valid URL
    case invalidURL
    
    /// The response status code is not 200
    case unexpected(response: HTTPURLResponse)
    
    /// An unknown error, potentially decoding related.
    case unknown(underlying: Error)
    
    /// The request was cancelled.
    case cancellation
}

/// Represents an API Client for the dog.ceo service.
public protocol Client {
    
    /// Perform a network request on the given endpoint.
    /// Can throw ClientError.
    /// - Parameter endpoint: The endpoint to call.
    /// - Returns: The decodable response.
    func perform<T: Decodable>(_ endpoint: Endpoint) async throws -> T
    
    /// Return a Breeds object containing a list of dog breeds.
    /// Can throw ClientError.
    /// - Returns: A list of dog breeds
    func breeds() async throws -> Breeds
    
    /// Return a list iof URLs pointing to dog images for the given breed..
    /// Can throw ClientError.
    /// - Returns: A list of URLs to images.
    func images(for: BreedName, count: Int) async throws -> [URL]
}

extension Client {
    public func breeds() async throws -> Breeds {
        let response: MessageResponse<Breeds> = try await perform(.breeds)
        return response.message
    }
    
    public func images(for breed: BreedName, count: Int) async throws -> [URL] {
        let response: MessageResponse<[URL]> = try await perform(.images(breed, count))
        return response.message
    }
}

public class DogAPIClient: Client {
    
    private static let baseURL = "https://dog.ceo/api/"
    
    let session: Session
    
    let decoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    public init(session: Session) {
        self.session = session
    }
    
    public func perform<T>(_ endpoint: Endpoint) async throws -> T where T : Decodable {
        return try await perform(request(method: endpoint.method, path: endpoint.path))
    }
    
    /// Construct a URLRequest from the method and path, relative to the baseURL.
    /// - Parameters:
    ///   - method: A HTTPMethod.
    ///   - path: A path component of a URL string.
    /// - Returns: A URLRequest, or throws.
    internal func request(method: HTTPMethod, path: String) throws -> URLRequest {
        var components = URLComponents(string: DogAPIClient.baseURL)!
        components.path += path
        
        if let url = components.url {
            var request = URLRequest(url: url)
            request.httpMethod = method.rawValue
            return request
        } else {
            throw ClientError.invalidURL
        }
    }
    
    /// Perform a URLRequest, handle errors, and decode if successful.
    /// - Parameter request: a URLRequest.
    /// - Returns: A decoded object, or throws.
    internal func perform<T>(_ request: URLRequest) async throws -> T where T: Decodable {
        let data: Data
        let urlResponse: URLResponse
        
        Logger.default.debug("🔼 \(request.httpMethod!) \(request.url!.absoluteString, align: .left(columns: 1))")
        if let body = request.httpBody, let string = String(data: body, encoding: .utf8) {
            Logger.default.debug("\t\(string)")
        }
        
        do {
            let response = try await session.data(for: request)
            data = response.0
            urlResponse = response.1
        } catch {
            let error = error as NSError
            if error.domain == NSURLErrorDomain, error.code == NSURLErrorCancelled {
                Logger.default.error("Request cancelled")
                throw ClientError.cancellation
            } else {
                Logger.default.error("Unexpected error: \(String(describing: error))")
                throw ClientError.unknown(underlying: error)
            }
        }
        
        let httpResponse = (urlResponse as! HTTPURLResponse)
        Logger.default.debug("🔽 \(httpResponse.statusCode) \(request.url!.absoluteString)")
        if let body = String(data: data, encoding: .utf8) {
            Logger.default.debug("\(body)")
        }
        
        if httpResponse.statusCode != 200 {
            Logger.default.error("Unexpected status code: \(httpResponse.statusCode)")
            throw ClientError.unexpected(response: httpResponse)
        }

        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            Logger.default.error("Unexpected error: \(String(describing: error))")
            throw ClientError.unknown(underlying: error)
        }
    }
}

/// A stub Client suitable for use in testing.
/// Because other functions are implemented as protocol extensions, we only need to implement `perform`.`
public class StubClient: Client {
    var responses: [any Decodable]?
    var error: Error?
    
    public init(responses: [any Decodable]? = nil, error: Error? = nil) {
        #if DEBUG
            self.responses = responses
            self.error = error
        #else
            fatalError("StubClient should not be used in RELEASE mode!")
        #endif
    }
    
    public func perform<T>(_ endpoint: Endpoint) async throws -> T where T : Decodable {
        if let error { throw error }
        if responses != nil { return responses!.removeFirst() as! T }
        throw StubClientError.notSetUp
    }
    
    public enum StubClientError: Error {
        case notSetUp
    }
}
