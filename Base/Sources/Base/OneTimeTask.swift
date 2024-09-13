import SwiftUI

struct OneTimeTask: ViewModifier {

    @State private var hasAppeared = false
    private let action: () async -> Void
    
    init(perform action: @escaping (() async -> Void)) {
        self.action = action
    }
    
    func body(content: Content) -> some View {
        content.task {
            if !hasAppeared {
                hasAppeared = true
                await action()
            }
        }
    }
}

public extension View {
    
    /// Adds an asynchronous task to perform before this view appears.
    /// This task will only be performed on the first appearance of the view. It is ignored on subsequent appearances.
    /// - Parameter action: A closure that SwiftUI calls as an asynchronous task before the view appears. SwiftUI will automatically cancel the task at some point after the view disappears before the action completes.
    /// - Returns: A view that runs the specified action asynchronously before the view appears.
    func oneTimeTask(perform action: @escaping (() async -> Void)) -> some View {
        modifier(OneTimeTask(perform: action))
    }
}
