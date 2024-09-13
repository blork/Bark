import Base
import DogDesign
import SwiftUI

public struct BreedListScreen: View {
    
    var viewModel: BreedListViewModel
    
    public init(viewModel: BreedListViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        @Bindable var viewModel = viewModel
        
        Group {
            if viewModel.isSearching && viewModel.filteredBreeds.isEmpty {
                ContentUnavailableView.search
            } else {
                ResourceStateView(resource: viewModel.breeds) { _ in
                    List(viewModel.filteredBreeds) { breed in
                        NavigationLink(value: Routes.breed(breed)) {
                            BreedRow(breed: breed)
                        }
                    }
                } placeholder: {
                    List(0 ..< 20) {
                        NavigationLink(value: $0) {
                            BreedRow.Placeholder()
                        }
                    }
                }
            }
        }
        .listStyle(.plain)
        .searchable(text: $viewModel.search, isPresented: $viewModel.isSearching)
        .oneTimeTask {
            await viewModel.load()
        }
    }
}

#Preview("Loaded") {
    NavigationStack {
        BreedListScreen(
            viewModel: .Preview(
                .loaded(
                    (0..<10).map(Breed.preview(_:))
                )
            )
        )
    }
}

#Preview("Loading") {
    NavigationStack {
        BreedListScreen(viewModel: .Preview(.loading))
    }
}

#Preview("Error") {
    NavigationStack {
        BreedListScreen(viewModel: .Preview(.error(PreviewError.whoops)))
    }
}

#Preview("Search") {
    NavigationStack {
        BreedListScreen(viewModel: .Preview(.loaded([]), isSearching: true))
    }
}
