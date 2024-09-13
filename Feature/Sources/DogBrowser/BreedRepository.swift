import DogAPI
import Foundation

public protocol BreedRepository {
    func breeds() async throws -> [Breed]
    func images(for breedName: String) async throws -> [URL]
}

/// Fetch, parse, and return data from DogAPI
public class RemoteBreedRepository: BreedRepository {
    let client: Client
    
    public init(client: Client) {
        self.client = client
    }
    
    /// Fetch the list of breeds
    /// - Returns: A list of breeds,
    public func breeds() async throws -> [Breed] {
        let breeds = try await client.breeds()
        
        /*
         * The breeds list returned by the API is very simple and only includes names (and subbreeds, but we don't care
         * about those yet). We really want image urls at the same point as we get the breed names. This performs
         * an additional request for each breed name and then combines them all up into the data we want, so it's
         * simpler at the point of use.
         * NOTE: while this is quite neat, it's also a lot of requests. IRL you'd hopefully be able to change the
         * response on the server-side.
         */
        return try await withThrowingTaskGroup(of: (BreedName, URL?).self, returning: [Breed].self) { taskGroup in
            breeds.forEach { breedName, subbreedName in
                taskGroup.addTask {
                    try (breedName, await self.client.images(for: breedName, count: 1).first)
                }
            }
            
            return try await taskGroup.reduce(into: [Breed]()) { partialResult, element in
                if let image = element.1 {
                    partialResult.append(
                        Breed(name: element.0, image: image)
                    )
                }
            }
            .sorted { lhs, rhs in
                lhs.name < rhs.name
            }
        }
    }
    
    public func images(for breedName: Breed.Name) async throws -> [URL] {
        try await client.images(for: breedName, count: 30)
    }
}

public class StubBreedRepository: BreedRepository {
    
    var error: Error?
    var breeds: [Breed]?
    var images: [URL]?

    public init(error: Error? = nil, breeds: [Breed]? = nil, images: [URL]? = nil) {
        #if DEBUG
            self.error = error
            self.breeds = breeds
            self.images = images
        #else
            fatalError("StubBreedRepository should not be used in RELEASE mode!")
        #endif
    }
    
    public func breeds() async throws -> [Breed] {
        if let error { throw error }
        if let breeds { return breeds }
        throw StubBreedRepositoryError.notSetUp
    }

    public func images(for _: String) async throws -> [URL] {
        if let error { throw error }
        if let images { return images }
        throw StubBreedRepositoryError.notSetUp
    }
    
    public enum StubBreedRepositoryError: Error {
        case notSetUp
    }
}
