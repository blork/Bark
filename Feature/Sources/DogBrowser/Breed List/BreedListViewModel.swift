import Base
import DogAPI
import Foundation

@Observable public class BreedListViewModel {
    
    let breedRepository: BreedRepository
        
    var breeds: ResourceState<[Breed]> = .loading
    
    private var baseBreeds: [Breed]? {
        if let breedsToShow {
            breeds.value?.filter { breed in
                breedsToShow.contains { $0 == breed.name }
            }
        } else {
            breeds.value
        }
    }
    
    var filteredBreeds: [Breed] {
        if search.isEmpty {
            baseBreeds ?? []
        } else {
            baseBreeds?.filter { $0.name.localizedCaseInsensitiveContains(search) } ?? []
        }
    }

    var search = ""
    var isSearching = false
    
    let breedsToShow: [String]?
    
    public init(breedRepository: BreedRepository, breedsToShow: [String]? = nil) {
        self.breedRepository = breedRepository
        self.breedsToShow = breedsToShow
    }
    
    func load() async {
        do {
            breeds = try await .loaded(breedRepository.breeds())
        } catch ClientError.cancellation {
            // Do nothing
        } catch {
            breeds = .error(error)
        }
    }
}

extension BreedListViewModel {
    class Preview: BreedListViewModel {
        init(_ state: ResourceState<[Breed]>, isSearching: Bool = false) {
            super.init(breedRepository: StubBreedRepository())
            breeds = state
            self.isSearching = isSearching
        }

        override func load() async {}
    }
}
