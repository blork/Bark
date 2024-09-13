import DogAPI
import DogBrowser
import SwiftUI

@main
struct BarkApp: App {
    
    let breedRepository: BreedRepository

    init() {
        breedRepository = StubBreedRepository(breeds: (0..<30).map(Breed.preview(_:)))
    }

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                DogBrowser.BreedListScreen(viewModel: .init(
                    breedRepository: breedRepository
                ))
                .navigationTitle("Stub App")
                .navigationDestination(for: DogBrowser.Routes.self) { route in
                    switch route {
                    case let .breed(breed):
                        DogBrowser.BreedDetailScreen(viewModel: .init(breedRepository: breedRepository, breed: breed))
                    }
                }
            }
        }
    }
}
