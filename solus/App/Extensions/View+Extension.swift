//
//  View+Extension.swift
//  solus
//
//  Created by Victoria Ono on 8/13/23.
//  Source for 1: https://www.avanderlee.com/swiftui/conditional-view-modifier/
//  Source for 2: https://www.swiftjectivec.com/swiftui-run-code-only-once-versus-onappear-or-task/

import SwiftUI

extension View {
    /// Applies the given transform if the given condition evaluates to `true`.
    /// - Parameters:
    ///   - condition: The condition to evaluate.
    ///   - transform: The transform to apply to the source `View`.
    /// - Returns: Either the original `View` or the modified `View` if the condition is `true`.
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
    
    func onFirstAppear(_ action: @escaping () -> ()) -> some View {
        modifier(FirstAppear(action: action))
    }
    
    func animate(using animation: Animation = .easeInOut(duration: 0.5), _ action: @escaping () -> Void) -> some View {
        onAppear {
            withAnimation(animation) {
                action()
            }
        }
    }
}

private struct FirstAppear: ViewModifier {
    let action: () -> ()
    
    // Use this to only fire your block one time
    @State private var hasAppeared = false
    
    func body(content: Content) -> some View {
        // And then, track it here
        content.task {
            guard !hasAppeared else { return }
            hasAppeared = true
            action()
        }
    }
}
