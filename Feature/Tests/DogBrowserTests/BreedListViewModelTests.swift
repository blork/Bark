import Base
@testable import DogBrowser
import XCTest

final class BreedListViewModelTests: XCTestCase {

    func test_breedsInitialValueIsLoading() async throws {
        let repo = StubBreedRepository()
        let vm = BreedListViewModel(breedRepository: repo)
                
        XCTAssertTrue(vm.breeds.isLoading)
    }

    func test_repoThrowsError_load_breedsContainsError() async throws {
        let repo = StubBreedRepository(error: PreviewError.whoops)
        let vm = BreedListViewModel(breedRepository: repo)
        
        await vm.load()
        
        XCTAssertTrue(vm.breeds.isError)
    }
    
    func test_noBreedsReturned_load_breedsIsLoadedAndEmpty() async throws {
        let repo = StubBreedRepository(breeds: [])
        let vm = BreedListViewModel(breedRepository: repo)
        
        await vm.load()
        
        XCTAssertTrue(vm.breeds.isLoaded)
        XCTAssertTrue(vm.breeds.value!.isEmpty)
    }
    
    func test_breedsReturned_load_breedsIsLoadedAndContainsCorrectBreeds() async throws {
        let repo = StubBreedRepository(breeds: [
            .init(name: "Test Breed 1", image: URL(string: "http://example.com")!),
            .init(name: "Test Breed 2", image: URL(string: "http://example.com")!)
        ])
        let vm = BreedListViewModel(breedRepository: repo)
        
        await vm.load()
        
        XCTAssertTrue(vm.breeds.isLoaded)
        let breeds = vm.breeds.value!
        XCTAssertEqual(breeds.count, 2)
        
        XCTAssertTrue(breeds.contains { $0.name == "Test Breed 1" })
        XCTAssertTrue(breeds.contains { $0.name == "Test Breed 2" })
    }
}
