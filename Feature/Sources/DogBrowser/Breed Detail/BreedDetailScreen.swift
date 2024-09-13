import Base
import DogDesign
import SwiftUI

public struct BreedDetailScreen: View {
    
    var viewModel: BreedDetailViewModel
    
    public init(viewModel: BreedDetailViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        let columns = [
            GridItem(.adaptive(minimum: 128), spacing: .spacing(.small))
        ]
        
        ResourceStateView(resource: viewModel.breedImages) { images in
            ScrollView {
                LazyVGrid(columns: columns, spacing: .spacing(.small)) {
                    ForEach(images, id: \.self) { url in
                        BreedImageView(url: url)
                    }
                }
                .padding()
            }
        } placeholder: {
            ScrollView {
                LazyVGrid(columns: columns, spacing: .spacing(.small)) {
                    ForEach(0 ..< 30) { _ in
                        BreedImageView.Placeholder()
                    }
                }
                .padding()
            }
        }
        .oneTimeTask {
            await viewModel.load()
        }
        .navigationTitle(viewModel.breed.name.capitalized)
        .listStyle(.plain)
        #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
        #endif
    }
}

#Preview("Loaded") {
    NavigationStack {
        BreedDetailScreen(
            viewModel: .Preview(
                breed: .preview(),
                breedImages: .loaded(
                    (0 ..< 30).map {
                        Breed.preview($0).image
                    }
                )
            )
        )
    }
}

#Preview("Loading") {
    NavigationStack {
        BreedDetailScreen(
            viewModel: .Preview(
                breed: .preview(),
                breedImages: .loading
            )
        )
    }
}

#Preview("Error") {
    NavigationStack {
        BreedDetailScreen(
            viewModel: .Preview(
                breed: .preview(),
                breedImages: .error(PreviewError.whoops)
            )
        )
    }
}
