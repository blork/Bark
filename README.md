# Bark App

**Developed in Xcode 15.4**

This is a sample application which uses the [Dogs API](https://dog.ceo/dog-api/). The project is intended to show a modern SwiftUI app, with an MVVM architecture with a high degree of modularisation and testability. Many of the choices are overkill for an application of this size, but serve to illustrate a solid foundation upon which a larger app could be sustainably grown.

This project reflects around 6 hours of effort.

The app is composed of 4 modules/packages split over 3 layers:

- Base Layer
	- Base
		- Contains utility methods and classes
	
- Core Layer
	- API
		- Contains networking code, such as creating and performing requests, and decoding responses into structs.
	- Design
		- Contains shared design code, such as styles, design values, and commonly shared stand-alone views.
	
- Feature Layer
	- Dog Browser
		- A list of dog breeds with search functionality and a detail page.
	
The Dog Browser feature is then imported by the main app target ("Bark") and composed into a main window. The idea is that, with additional features, each feature could occupy a tab in a tabview, with each being the "root view" of the feature. The features could be composed in many other ways, though, such as a "Settings" feature being shown modally.

There is also an additional "mini app" target ("StubApp") which sets up the app with a stubbed/mocked data source. With additional features, you could have one "mini app" per feature allowing you to run it independently of the rest of the app and set up some preconditions. This can be very useful in development, when you want to jump directly to the feature you are working on. As there's only one feature here, the onlt difference is the stub networking stack setup. It also has a different accent colour and icon.

The features are composed of multiple SwiftUI Views named as "Screens" for clarity. Each of these has a ViewModel which performs the specific logic needed for thew view. This often take the form of network requests which are performed by specific Repositories. These take the network requests from the API package and transform the decoded API structs into Model objects for consumption by views. In this example multiple requests are required to combine the basic details of a dog breed which are returned in a list, with extra information such as a key photo. The repo batches up these requests using withThrowingTaskGroup, so that the final object is flattened and simplified, and at the point of use is a single async function.

By having the separation of ViewModel and Repository, Unit Testing the VMs becomes simple as they can be provided Stub/Fake/Mock repos which return specific data in test, so simple assertions can be made. In this example, the repository has a protocol which is conformed to by a "real" implementation and also a "stub" version.

Dependency injection is managed manually by having each object take its dependencies as constructor arguments. As an app scales, this could be unwieldy, but it is explicit and clear. I have experience with DI frameworks in Swift, but felt them not needed here.

The project makes use of Unit Tests for logic and Snapshot tests for UI, using the [SnapshotTesting](https://github.com/pointfreeco/swift-snapshot-testing) library.

One "dependency" to call out is the AsyncImage class included in the app. This is slightly adapted from [one shared by a user of the Snapshot testing library](https://github.com/pointfreeco/swift-snapshot-testing/issues/701#issuecomment-1440979736). My reasoning in including this is that it makes Snapshot tests more consistent by preventing AsyncImage hitting the network. Without any wrapping Apple's AsyncImage doesn't allow any customisation like this, or other features such as caching. It is the feature I would be most likely to replace with a library.

Additionally, the app is multi-platform, as this is very easy to enable for a fully SwiftUI app. It runs on iPhone, iPad, and macOS. The UI leaves something to be desired as a Mac app, as I have done very little to make it feel more "native", but it works and is a good starting point.
