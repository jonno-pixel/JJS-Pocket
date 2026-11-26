import SwiftUI

@main
struct JJSPocketApp: App {
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .preferredColorScheme(.dark)
        }
    }
}

struct MainTabView: View {
    @State private var selectedTab = 1

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(selectedTab: $selectedTab)
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)

            ModelDownloaderView()
                .tabItem {
                    Label("Models", systemImage: "shippingbox.fill")
                }
                .tag(1)

            AIDeveloperChatView(selectedTab: $selectedTab)
                .tabItem {
                    Label("Chat", systemImage: "bubble.left.and.bubble.right.fill")
                }
                .tag(2)

            ProjectGeneratorView()
                .tabItem {
                    Label("Projects", systemImage: "folder.fill")
                }
                .tag(3)
        }
        .tint(Color(red: 0.15, green: 0.55, blue: 1.0))
    }
}
