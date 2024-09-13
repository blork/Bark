import Foundation

public typealias BreedName = String
public typealias SubbreedName = String
public typealias Breeds = [BreedName: [SubbreedName]]

public struct MessageResponse<T: Decodable>: Decodable {
    let message: T
}
