import DogAPI
import DogBrowser
import SwiftUI

@main
struct BarkApp: App {
    let client: Client
    
    let breedRepository: BreedRepository

    init() {
        client = DogAPIClient(session: URLSession.shared)
        breedRepository = RemoteBreedRepository(client: client)
    }

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                DogBrowser.BreedListScreen(viewModel: .init(
                    breedRepository: breedRepository
                ))
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
