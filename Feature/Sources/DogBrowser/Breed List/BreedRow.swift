import SwiftUI

struct BreedRow: View {
    
    let breed: Breed
    
    @ScaledMetric(relativeTo: .title) private var imageSize = 64

    var body: some View {
        HStack {
            AsyncImage(url: breed.image) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Color(.tertiarySystemFill)
            }
            .background(Color(.tertiarySystemFill))
            .frame(width: imageSize, height: imageSize)

            VStack(alignment: .leading) {
                Text(breed.name.capitalized)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.headline)
            }
        }
    }
}

#Preview {
    BreedRow(breed: .preview())
        .padding()
}
