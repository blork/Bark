import Foundation

public enum Dimensions {
    public enum CornerRadius: CGFloat {
        case regular = 8
    }
    
    public enum Spacing: CGFloat {
        case small = 4
        case medium = 8
        case large = 32
    }

}

public extension CGFloat {
    static func cornerRadius(_ cornerRadius: Dimensions.CornerRadius) -> CGFloat {
        cornerRadius.rawValue
    }
    
    static func spacing(_ spacing: Dimensions.Spacing) -> CGFloat {
        spacing.rawValue
    }
}
