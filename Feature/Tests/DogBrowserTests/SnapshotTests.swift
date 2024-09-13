import Base
@testable import DogBrowser
import SnapshotTesting
import SwiftUI
import XCTest

final class SnapshotTests: XCTestCase {
    
    func testSnapshotBreedListScreen() throws {
        asssertScreenSnapshot(
            of: BreedListScreen(
                viewModel: .Preview(
                    .loading
                )
            )
        )
        asssertScreenSnapshot(
            of: BreedListScreen(
                viewModel: .Preview(
                    .loaded(
                        [.preview()]
                    )
                )
            ).environment(\.imageProvider) { url in
                UIImage(named: "husky", in: Bundle.module, with: nil)
            }
        )
        asssertScreenSnapshot(
            of: BreedListScreen(
                viewModel: .Preview(
                    .error(
                        PreviewError.whoops
                    )
                )
            )
        )
    }
    
    func testSnapshotBreedDetailScreen() throws {
        asssertScreenSnapshot(
            of: BreedDetailScreen(
                viewModel: .Preview(
                    breed: .preview(),
                    breedImages: .loading
                )
            )
        )
        asssertScreenSnapshot(
            of: BreedDetailScreen(
                viewModel: .Preview(
                    breed: .preview(),
                    breedImages: .loaded(
                        (0 ..< 30).map {
                            Breed.preview($0).image
                        }
                    )
                )
            ).environment(\.imageProvider) { url in
                UIImage(named: "husky", in: Bundle.module, with: nil)
            }
        )
        asssertScreenSnapshot(
            of: BreedDetailScreen(
                viewModel: .Preview(
                    breed: .preview(),
                    breedImages: .error(
                        PreviewError.whoops
                    )
                )
            )
        )
    }
        
    private func asssertScreenSnapshot(
        of value: some View,
        layout: SwiftUISnapshotLayout = .device(config: .iPhone13),
        file: StaticString = #file,
        testName: String = #function,
        line: UInt = #line
    ) {
        assertSnapshot(
            of: NavigationStack {
                value
                    .toolbar(.hidden, for: .navigationBar)
            },
            as: .image(precision: 0.99, layout: layout),
            file: file,
            testName: testName,
            line: line
        )
    }
}
