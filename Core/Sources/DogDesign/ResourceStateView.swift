import Base
import SwiftUI

public struct ResourceStateView<T, Content: View, Placeholder: View>: View {
    
    let resource: ResourceState<T>
    let content: (T) -> Content
    let placeholder: () -> Placeholder
    
    public init(
        resource: ResourceState<T>,
        @ViewBuilder content: @escaping (T) -> Content,
        @ViewBuilder placeholder: @escaping () -> Placeholder
    ) {
        self.resource = resource
        self.content = content
        self.placeholder = placeholder
    }
    
    public var body: some View {
        Group {
            if let value = resource.value {
                content(value)
            } else {
                placeholder()
            }
        }
        .opacity(resource.isLoaded ? 1.0 : 0.3)
        .redacted(reason: resource.isLoaded ? .init() : .placeholder)
        .overlay {
            switch resource {
            case .loading:
                ProgressView()
            case let .error(error):
                ContentUnavailableView(error.localizedDescription, systemImage: "exclamationmark.triangle")
            case .loaded:
                EmptyView()
            }
        }
        .disabled(!resource.isLoaded)
    }
}
