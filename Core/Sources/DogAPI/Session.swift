import Foundation

/// Protocol representing a generic network Session.
/// This allows us to easily stub it, while continuing to allow easy use of URLSession.
public protocol Session {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: Session {}
