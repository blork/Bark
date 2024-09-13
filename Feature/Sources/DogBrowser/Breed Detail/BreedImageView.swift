import SwiftUI

struct BreedImageView: View {
    let url: URL
    
    var body: some View {
        ZStack(alignment: .center) {
            AsyncImage(
                url: url
            ) { phase in
                switch phase {
                case let .success(image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                default:
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .aspectRatio(1, contentMode: .fill)
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

#Preview {
    BreedImageView(url: Breed.preview().image)
}
