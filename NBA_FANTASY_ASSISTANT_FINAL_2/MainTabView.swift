import SwiftUI

struct MainTabView: View {
    @StateObject private var squadManager = SquadManager()

    var body: some View {
        //Bottom Taskbar
        TabView {
            //Squad Screen Icon/button
            SquadView()
                .environmentObject(squadManager)
                .tabItem {
                    Label("Squad", systemImage: "basketball.fill")
                }
                .toolbarBackground(.black, for: .tabBar)
                .toolbarBackground(.visible, for: .tabBar)
                .toolbarColorScheme(.dark, for: .tabBar)
            //Players Screen Icon/Button
            PlayersView()
                .environmentObject(squadManager)
                .tabItem {
                    Label("Players", systemImage: "figure.basketball.circle")
                }
                .toolbarBackground(.black, for: .tabBar)
                .toolbarBackground(.visible, for: .tabBar)
                .toolbarColorScheme(.dark, for: .tabBar)
            //Rising Stars Screen Icon/Button
            RisingStarsView()
                .tabItem {
                    Label("Rising Stars", systemImage: "star.fill")
                }
                .toolbarBackground(.black, for: .tabBar)
                .toolbarBackground(.visible, for: .tabBar)
                .toolbarColorScheme(.dark, for: .tabBar)
        }
    }
}


#Preview {
    MainTabView()
}
