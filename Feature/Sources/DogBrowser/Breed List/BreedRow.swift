import SwiftUI
import DogDesign

struct BreedRow: View {
    let breed: Breed
    
    var body: some View {
        InternalBreedRow(breed: breed)
    }
    
    struct Placeholder: View {
        var body: some View {
            InternalBreedRow(breed: nil)
        }
    }
}

private struct InternalBreedRow: View {
    
    let breed: Breed?
    
    @ScaledMetric(relativeTo: .title) private var imageSize = 64

    var body: some View {
        HStack {
            Group {
                if let image = breed?.image {
                    DogDesign.AsyncImage(url: image) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Color(.tertiarySystemFill)
                    }
                } else {
                    Color.clear
                }
            }
            .background(Color(.tertiarySystemFill))
            .frame(width: imageSize, height: imageSize)
            .clipShape(.rect(cornerRadius: .cornerRadius(.regular)))
            .overlay(
                RoundedRectangle(cornerRadius: .cornerRadius(.regular))
                    .stroke(Color(.systemFill), lineWidth: 1)
            )

            VStack(alignment: .leading) {
                Text(breed?.name.capitalized ?? String(repeating: "A", count: 20))
                .lineLimit(2)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.headline)
            }
        }
    }
}

#Preview("With Data") {
    BreedRow(breed: .preview())
        .padding()
}

#Preview("Placeholder") {
    BreedRow.Placeholder()
        .redacted(reason: .placeholder)
        .padding()
}
