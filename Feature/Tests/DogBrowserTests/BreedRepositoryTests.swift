import Base
@testable import DogAPI
@testable import DogBrowser
import XCTest

final class BreedRepositoryTests: XCTestCase {

    func test_breeds_clientThrowsError_repoThrowsError() async throws {
        let client = StubClient(error: PreviewError.whoops)
        let repo = RemoteBreedRepository(client: client)
        
        do {
            _ = try await repo.breeds()
            XCTFail("Method should throw")
        } catch PreviewError.whoops {
            XCTAssert(true)
        } catch {
            XCTFail("Wrong error type")
        }
    }
    
    func test_breeds_clientReturnsBreeds_repoParsesAndReturns() async throws {
        let client = StubClient(responses: [
            DogAPI.MessageResponse(message: [
                "example breed 1": ["subbreed 1"],
                "example breed 2": ["subbreed 2"],
            ]),
            DogAPI.MessageResponse(message: [
                URL(string: "https://example.com/image")!
            ]),
            DogAPI.MessageResponse(message: [
                URL(string: "https://example.com/image")!
            ])
        ])
        let repo = RemoteBreedRepository(client: client)
        
        let breeds = try await repo.breeds()
        
        XCTAssertEqual(breeds.count, 2)
            
        let breed1 = breeds[0]
        XCTAssertEqual(breed1.name, "example breed 1")
        XCTAssertEqual(breed1.image.absoluteString, "https://example.com/image")
        
        let breed2 = breeds[1]
        XCTAssertEqual(breed2.name, "example breed 2")
        XCTAssertEqual(breed2.image.absoluteString, "https://example.com/image")
        
        XCTAssertEqual(client.responses!.count, 0)
    }
    
    func test_images_clientThrowsError_repoThrowsError() async throws {
        let client = StubClient(error: PreviewError.whoops)
        let repo = RemoteBreedRepository(client: client)
        
        do {
            _ = try await repo.images(for: "example")
            XCTFail("Method should throw")
        } catch PreviewError.whoops {
            XCTAssert(true)
        } catch {
            XCTFail("Wrong error type")
        }
    }

    func test_images_clientReturnsBreeds_repoParsesAndReturns() async throws {
        let client = StubClient(responses: [
            DogAPI.MessageResponse(message: [
                URL(string: "https://example.com/image1")!,
                URL(string: "https://example.com/image2")!,
                URL(string: "https://example.com/image3")!
            ])
        ])
        let repo = RemoteBreedRepository(client: client)
        
        let images = try await repo.images(for: "example")
        
        XCTAssertEqual(images.count, 3)
        XCTAssertEqual(images[0].absoluteString, "https://example.com/image1")
        XCTAssertEqual(images[1].absoluteString, "https://example.com/image2")
        XCTAssertEqual(images[2].absoluteString, "https://example.com/image3")
    }
}
