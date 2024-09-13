import Base
import SwiftUI

public struct BreedListScreen: View {
    
    var viewModel: BreedListViewModel
    
    public init(viewModel: BreedListViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        @Bindable var viewModel = viewModel
        List {
            if viewModel.isSearching && viewModel.filteredBreeds?.isEmpty == true {
                ContentUnavailableView.search
            } else {
                ForEach(viewModel.filteredBreeds ?? placeholders) { breed in
                    NavigationLink(value: Routes.breed(breed)) {
                        BreedRow(breed: breed)
                    }
                }
            }
        }
        .listStyle(.plain)
        .searchable(text: $viewModel.search, isPresented: $viewModel.isSearching)
        .oneTimeTask {
            await viewModel.load()
        }
        .navigationTitle("Breeds")
    }
    
    private var placeholders: [Breed] {
        (0 ..< 20).map { .preview($0) }
    }
}

#Preview("Loaded") {
    NavigationStack {
        BreedListScreen(viewModel: .Preview(.loaded([.preview()])))
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
