import Base
import SwiftUI

public struct BreedDetailScreen: View {
    
    var viewModel: BreedDetailViewModel
    
    public init(viewModel: BreedDetailViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        List {
            ForEach(viewModel.breedImages.value ?? [viewModel.breed.image], id: \.self) { url in
                BreedImageView(url: url)
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
                breedImages: .loaded([
                    Breed.preview().image,
                    Breed.preview().image,
                    Breed.preview().image,
                ])
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
