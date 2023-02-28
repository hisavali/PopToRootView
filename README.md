# PopToRootView

Repo is trying to replicate issue described here at [StackOverflow](https://stackoverflow.com/questions/57334455/how-can-i-pop-to-the-root-view-using-swiftui)

- `RootView` is pushing new view using `NavigationLink(destination:isActive:)`
- `RootView` is injecting `.environment(\.rootPresentationMode)` for child views to access!
-  When leaf view `ThirdContentView` taps `Pop to Root`, it works as expected ✅ 

| Working Demo |
| ------------ |
| ![Working](https://user-images.githubusercontent.com/2108707/221866270-59ef08eb-84d1-4242-8336-94398204d7e6.gif) |

# Issue

- `AnotherRootView` is pushing new view using `NavigationLink(unwrapping:case:onNavigate:destination:)` of [SwiftUINavigation](https://github.com/pointfreeco/swiftui-navigation)
- `AnotherRootView` is injecting `.environment(\.rootPresentationMode)` for child views to access!
-  When leaf view `ThirdContentView` taps `Pop to Root`, it doesn't work as expected ❌
- Root cause: `onNavigate` closure is not called to flip the binding. Closure is defined `NavigationLink(unwrapping:case:onNavigate:destination:)`

| Not Working Demo |
| ---------------- |
| ![Broken](https://user-images.githubusercontent.com/2108707/221868901-58de678e-e055-4792-922a-08e41fb9a3b5.gif) |
