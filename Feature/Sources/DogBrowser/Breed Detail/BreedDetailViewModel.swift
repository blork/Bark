import Base
import DogAPI
import Foundation

@Observable public class BreedDetailViewModel {
    
    var getImages: (_ breedName: String) async throws -> [URL]
    
    var breedImages: ResourceState<[URL]> = .loading
    
    let breed: Breed

    public init(getImages: @escaping (String) async throws -> [URL], breed: Breed) {
        self.getImages = getImages
        self.breed = breed
    }
    
    func load() async {
        do {
            breedImages = try await .loaded(getImages(breed.name))
        } catch {
            breedImages = .error(error)
        }
    }
}

extension BreedDetailViewModel {
    class Preview: BreedDetailViewModel {
        init(breed: Breed, breedImages: ResourceState<[URL]>) {
            super.init(getImages: { _ in [] }, breed: breed)
            self.breedImages = breedImages
        }

        override func load() async {}
    }
}
