import Foundation

public struct Breed: Identifiable, Hashable {
    public typealias Name = String
    
    public let name: Name
    public let image: URL
    public var id: String { name }
}

public extension Breed {
    static func preview(_ id: Int = 1) -> Breed {
        .init(
            name: "Dog Breed #\(id)",
            image: URL(string: "https://images.dog.ceo/breeds/hound-basset/n02088238_12160.jpg")!
        )
    }
}
