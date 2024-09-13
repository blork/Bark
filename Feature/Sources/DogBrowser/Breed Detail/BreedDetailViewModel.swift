import Base
import DogAPI
import Foundation

@Observable public class BreedDetailViewModel {
    
    let breedRepository: BreedRepository
        
    var breedImages: ResourceState<[URL]> = .loading
    
    let breed: Breed

    public init(breedRepository: BreedRepository, breed: Breed) {
        self.breedRepository = breedRepository
        self.breed = breed
    }
    
    func load() async {
        do {
            breedImages = try await .loaded(breedRepository.images(for: breed.name))
        } catch {
            breedImages = .error(error)
        }
    }
}

extension BreedDetailViewModel {
    class Preview: BreedDetailViewModel {
        init(breed: Breed, breedImages: ResourceState<[URL]>) {
            super.init(breedRepository: StubBreedRepository(), breed: breed)
            self.breedImages = breedImages
        }

        override func load() async {}
    }
}
