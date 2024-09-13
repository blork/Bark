import DogDesign
import SwiftUI

struct BreedImageView: View {
    
    let url: URL
    
    @ScaledMetric(relativeTo: .title) private var imageSize = 128

    var body: some View {
        Color.clear.overlay(
            DogDesign.AsyncImage(url: url) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .aspectRatio(1, contentMode: .fill)
            .clipped()
        )
        .frame(maxWidth: .infinity)
        .aspectRatio(1, contentMode: .fit)
        .clipShape(.rect(cornerRadius: .cornerRadius(.regular)))
    }
    
    struct Placeholder: View {
        var body: some View {
            Color(.tertiarySystemFill)
                .frame(maxWidth: .infinity)
                .aspectRatio(1, contentMode: .fit)
                .clipShape(.rect(cornerRadius: .cornerRadius(.regular)))
        }
    }
}

#Preview("With Image") {
    BreedImageView(url: Breed.preview().image)
}

#Preview("Placeholder") {
    BreedImageView.Placeholder()
}
