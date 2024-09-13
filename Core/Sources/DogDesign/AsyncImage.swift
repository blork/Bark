import SwiftUI

/// https://github.com/pointfreeco/swift-snapshot-testing/issues/701#issuecomment-1440979736
public struct AsyncImage<Content>: View where Content: View {
    private var content: (ImageProvider) -> _ConditionalContent<SwiftUI.AsyncImage<Content>, Content>

    @Environment(\.imageProvider) var imageProvider

    public init(
        url: URL?,
        scale: CGFloat = 1
    ) where Content == Image {
        content = { imageProvider in
            if let uiImage = url.flatMap(imageProvider) {
                return ViewBuilder.buildEither(
                    second: Image(uiImage: uiImage)
                )
            } else {
                return ViewBuilder.buildEither(
                    first: SwiftUI.AsyncImage(
                        url: url,
                        scale: scale
                    )
                )
            }
        }
    }

    public init<I, P>(
        url: URL?,
        scale: CGFloat = 1,
        @ViewBuilder content: @escaping (Image) -> I,
        @ViewBuilder placeholder: @escaping () -> P
    ) where Content == _ConditionalContent<I, P>, I: View, P: View {
        self.content = { imageProvider in
            if let uiImage = url.flatMap(imageProvider) {
                return ViewBuilder.buildEither(
                    second: ViewBuilder.buildEither(
                        first: content(Image(uiImage: uiImage))
                    )
                )
            } else {
                return ViewBuilder.buildEither(
                    first: SwiftUI.AsyncImage(
                        url: url,
                        scale: scale,
                        content: content,
                        placeholder: placeholder
                    )
                )
            }
        }
    }

    public init(
        url: URL?,
        scale: CGFloat = 1,
        transaction: Transaction = Transaction(),
        @ViewBuilder content: @escaping (AsyncImagePhase) -> Content
    ) {
        self.content = { imageProvider in
            if let uiImage = url.flatMap(imageProvider) {
                return ViewBuilder.buildEither(
                    second: content(.success(Image(uiImage: uiImage)))
                )
            } else {
                return ViewBuilder.buildEither(
                    first: SwiftUI.AsyncImage(
                        url: url,
                        scale: scale,
                        transaction: transaction,
                        content: content
                    )
                )
            }
        }
    }

    public var body: some View {
        self.content(self.imageProvider)
    }
}

public typealias ImageProvider = (URL) -> UIImage?

private struct Key: EnvironmentKey {
    static var defaultValue: ImageProvider = { _ in nil }
}

public extension EnvironmentValues {
    var imageProvider: ImageProvider {
        get { self[Key.self] }
        set { self[Key.self] = newValue }
    }
}
