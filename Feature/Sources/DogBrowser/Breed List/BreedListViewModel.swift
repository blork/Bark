import Base
import DogAPI
import Foundation

@Observable public class BreedListViewModel {
    
    var breeds: ResourceState<[Breed]> = .loading
    var getBreeds: () async throws -> [Breed]
    
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
    
    public init(getBreeds: @escaping () async throws -> [Breed], breedsToShow: [String]? = nil) {
        self.getBreeds = getBreeds
        self.breedsToShow = breedsToShow
    }
    
    func load() async {
        do {
            breeds = try await .loaded(getBreeds())
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
            super.init(getBreeds: { [] })
            breeds = state
            self.isSearching = isSearching
        }

        override func load() async {}
    }
}
