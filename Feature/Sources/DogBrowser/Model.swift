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
            image: URL(string: "https://picsum.photos/id/\(id)/200/300")!
        )
    }
}
