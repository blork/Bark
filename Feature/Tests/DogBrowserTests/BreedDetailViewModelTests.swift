import Base
@testable import DogBrowser
import XCTest

final class BreedDetailViewModelTests: XCTestCase {

    func test_imagesInitialValueIsLoading() async throws {
        let repo = StubBreedRepository()
        let vm = BreedDetailViewModel(breedRepository: repo, breed: .preview())
        
        XCTAssertTrue(vm.breedImages.isLoading)
    }

    func test_repoThrowsError_load_imagesContainsError() async throws {
        let repo = StubBreedRepository(error: PreviewError.whoops)
        let vm = BreedDetailViewModel(breedRepository: repo, breed: .preview())
        
        await vm.load()
        
        XCTAssertTrue(vm.breedImages.isError)
    }
    
    func test_noImagesReturned_load_breedsIsLoadedAndEmpty() async throws {
        let repo = StubBreedRepository(images: [])
        let vm = BreedDetailViewModel(breedRepository: repo, breed: .preview())
        
        await vm.load()
        
        XCTAssertTrue(vm.breedImages.isLoaded)
        XCTAssertTrue(vm.breedImages.value!.isEmpty)
    }
    
    func test_imagesReturned_load_imagesIsLoadedAndContainsCorrectImages() async throws {
        let repo = StubBreedRepository(images: [
            URL(string: "http://example1.com")!,
            URL(string: "http://example2.com")!,
        ])
        let vm = BreedDetailViewModel(breedRepository: repo, breed: .preview())
        
        await vm.load()
        
        XCTAssertTrue(vm.breedImages.isLoaded)
        let images = vm.breedImages.value!
        XCTAssertEqual(images.count, 2)
        
        XCTAssertTrue(images.contains { $0.absoluteString == "http://example1.com" })
        XCTAssertTrue(images.contains { $0.absoluteString == "http://example2.com" })
    }
}
