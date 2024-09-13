@testable import DogAPI
import XCTest

final class DogAPITests: XCTestCase {
    
    func test_anyRequestIsPerformed_invalidStatusCode_errorIsThrown() async throws {
        let session = StubSession()
        session.response = (Data(), 404)
        
        let client = DogAPIClient(session: session)
        
        do {
            let _: String = try await client.perform(URLRequest(url: URL(string: "http://example.com")!))
        } catch let ClientError.unexpected(response) {
            XCTAssertEqual(response.statusCode, 404)
        } catch {
            XCTFail()
        }
    }
    
    func test_anyRequestIsPerformed_invalidResponseObject_errorIsThrown() async throws {
        let session = StubSession()
        session.response = (Data(), 200)
        
        let client = DogAPIClient(session: session)
        
        do {
            let _: String = try await client.perform(URLRequest(url: URL(string: "http://example.com")!))
        } catch let ClientError.unknown(error) {
            XCTAssertTrue(error is DecodingError)
        } catch {
            XCTFail()
        }
    }
    
    func test_breeds_successful_responseIsReturned() async throws {
        let session = StubSession()
        
        session.response = ("""
        {
            "message": {
                "appenzeller": [],
                "australian": [
                    "shepherd"
                ]
            }
        }
        """.data(using: .utf8)!, 200)
        
        let client = DogAPIClient(session: session)

        let breeds = try await client.breeds()

        XCTAssertEqual(breeds.count, 2)
        XCTAssertTrue(breeds.contains { k, _ in k == "appenzeller" })
        XCTAssertTrue(breeds.contains { k, _ in k == "australian" })
        
        let australian = breeds["australian"]!
        XCTAssertEqual(australian.count, 1)
        XCTAssertTrue(australian.contains { $0 == "shepherd" })
    }
    
    func test_image_successful_responseIsReturned() async throws {
        let session = StubSession()
        
        session.response = ("""
        {
            "message": [
                "http://example.com"
            ]
        }
        """.data(using: .utf8)!, 200)
        
        let client = DogAPIClient(session: session)

        let urls = try await client.images(for: "appenzeller", count: 1)

        XCTAssertEqual(urls.count, 1)
        XCTAssertEqual(urls.first!.absoluteString, "http://example.com")
    }

}
