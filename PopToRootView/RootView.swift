//
//  ContentView.swift
//  PopToRootView
//
//  Created by Hitesh Savaliya on 27/02/2023.
//

import SwiftUI
import SwiftUINavigation

typealias RootPresentationMode = Bool
struct RootPresentationModeKey: EnvironmentKey {
    static let defaultValue: Binding<RootPresentationMode> = .constant(RootPresentationMode())
}

extension EnvironmentValues {
    var rootPresentationMode: Binding<RootPresentationMode> {
        get { return self[RootPresentationModeKey.self] }
        set { self[RootPresentationModeKey.self] = newValue }
    }
}

extension RootPresentationMode {
    public mutating func dismiss() {
        self.toggle()
    }
}

//MARK: - SwiftUI view
struct RootView: View {
    @State private var isActive : Bool = false
    var body: some View {
        NavigationView {
            NavigationLink(
                destination: SecondContentView(),
                isActive: self.$isActive
            ) {
                Text("Push Second")
            }.navigationBarTitle("Root")
        }
        .environment(\.rootPresentationMode, self.$isActive)
    }
}

struct SecondContentView: View {
    @State private var isActive: Bool = false
    @Environment(\.presentationMode) private var presentationMode
    var body: some View {
        VStack(spacing: 32) {
            Text("Second")
            NavigationLink(
                destination: ThirdContentView(),
                isActive: self.$isActive
            ) {
                Text("Push Third")
            }
            Button (action: { self.presentationMode.wrappedValue.dismiss() } )
            { Text("Pop") }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitle("Second")
    }
}

struct ThirdContentView: View {
    @Environment(\.rootPresentationMode) private var rootPresentationMode
    var body: some View {
        VStack(spacing: 32) {
            Text("Third")
            Button (action: { self.rootPresentationMode.wrappedValue.dismiss() } )
            { Text("Pop to Root") }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitle("Third")
    }
}


// MARK: - SwiftUI view using SwiftUINavigation Library
struct AnotherRootView: View {
    enum Destination {
        case second
    }
    
    @State private var isActive : Bool = false
    @State var destination: Destination? = nil
    
    var body: some View {
        NavigationView {
            NavigationLink(
                unwrapping: self.$destination,
                case: /Destination.second,
                onNavigate: {
                    self.isActive = $0
                    self.destination = $0 ? .second : nil
                },
                destination: { _ in
                    SecondContentView()
                }
            ){
                Text("Push Second")
            }
            .navigationBarTitle("Another Root")
        }
        .environment(\.rootPresentationMode, self.$isActive)
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            RootView()
                .previewDisplayName("RootView")
            AnotherRootView()
                .previewDisplayName("Another RootView")
        }
    }
}
