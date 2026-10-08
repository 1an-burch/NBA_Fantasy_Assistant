import SwiftUI

struct PlayersView: View {
    //variables
    struct SortOption: Identifiable {
        var id: String { key }
        let key: String
        let label: String
        let comparator: (PlayerStats, PlayerStats) -> Bool
    }

    @EnvironmentObject var squadManager: SquadManager
    @State private var playerStats: [PlayerStats] = []
    @State private var searchText: String = ""
    @State private var selectedSort = "Points"
    @State private var selectedPosition = "All"
    @State private var showNotification = false
    
    //sorting options
    var sortOptions: [SortOption] = [
        SortOption(key: "Points", label: "Points") { $0.ppg > $1.ppg },
        SortOption(key: "Assists", label: "Assists") { $0.apg > $1.apg },
        SortOption(key: "Rebounds", label: "Rebounds") { $0.rpg > $1.rpg },
        SortOption(key: "Steals", label: "Steals") { $0.spg > $1.spg },
        SortOption(key: "Blocks", label: "Blocks") { $0.bpg > $1.bpg },
        SortOption(key: "FG%", label: "FG%") {
            ($0.fieldPercent ?? 0) > ($1.fieldPercent ?? 0)
        },
        SortOption(key: "3P%", label: "3P%") {
            ($0.threePercent ?? 0) > ($1.threePercent ?? 0)
        }
    ]

    let positions: [String] = ["All", "PG", "SG", "SF", "PF", "C"]

    var filteredAndSortedStats: [PlayerStats] {
        let filtered = playerStats.filter { player in
            let matchesSearch = searchText.isEmpty || player.playerName.lowercased().contains(searchText.lowercased())
            let matchesPosition = selectedPosition == "All" || player.position == selectedPosition
            return matchesSearch && matchesPosition
        }

        let sortMethod = sortOptions.first { $0.key == selectedSort }?.comparator ?? { _, _ in false }
        return filtered.sorted(by: sortMethod)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)

                VStack(spacing: 12) {
                    //search bar
                    TextField("Search players...", text: $searchText)
                        .textFieldStyle(YellowBorder())
                        .padding(.horizontal)
                        .foregroundColor(.white)
                        .background(Color.black)

                    //sorting dropdowns
                    HStack {
                        Picker("Sort by", selection: $selectedSort) {
                            ForEach(sortOptions) { option in
                                Text(option.label).tag(option.key)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .foregroundColor(.white)
                        .background(Color.black)

                        Spacer()

                        Picker("Position", selection: $selectedPosition) {
                            ForEach(positions, id: \.self) { position in
                                Text(position).tag(position)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .foregroundColor(.white)
                        .background(Color.black)
                    }
                    .padding(.horizontal)

                    //player list
                    List(filteredAndSortedStats) { player in
                        VStack(alignment: .leading, spacing: 6) {
                            HStack(alignment: .center, spacing: 12) {
                                if let logo = UIImage(named: player.team) {
                                    Image(uiImage: logo)
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                        .clipShape(Circle())
                                }

                                VStack(alignment: .leading) {
                                    Text(player.playerName)
                                        .font(.headline)
                                        .foregroundColor(.white)

                                    Text("Position: \(player.position)")
                                        .font(.subheadline)
                                        .foregroundColor(.white)

                                    Text("Team: \(player.team)")
                                        .font(.subheadline)
                                        .foregroundColor(.white)
                                }

                                Spacer()
                                //add to squad button (interacts with squad manager)
                                Button("Add to Squad") {
                                    squadManager.addPlayerToSquad(player)
                                    showNotification = true
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                        showNotification = false
                                    }
                                }
                                .buttonStyle(BorderlessButtonStyle())
                                .foregroundColor(.black)
                                .padding(6)
                                .background(Color.yellow)
                                .cornerRadius(8)
                            }

                            HStack {
                                VStack(alignment: .leading) {
                                    Text("PTS: \(player.ppg, specifier: "%.1f")")
                                    Text("AST: \(player.apg, specifier: "%.1f")")
                                    Text("REB: \(player.rpg, specifier: "%.1f")")
                                }
                                .foregroundColor(.white)

                                Spacer()

                                VStack(alignment: .leading) {
                                    Text("STL: \(player.spg, specifier: "%.1f")")
                                    Text("BLK: \(player.bpg, specifier: "%.1f")")
                                }
                                .foregroundColor(.white)
                            }
                            .font(.subheadline)
                        }
                        .padding(.vertical, 4)
                        .background(Color.gray.opacity(0.5))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.yellow, lineWidth: 2)
                        )
                        .listRowBackground(Color.black)
                    }
                    .listStyle(PlainListStyle())
                    .scrollContentBackground(.hidden)
                }

                // notification to let user know that player is added to squad
                if showNotification {
                    VStack {
                        Text("Added!")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                            .transition(.move(edge: .top))
                            .zIndex(1)
                    }
                    .padding(.top, 10)
                }
            }
            .background(Color.black)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("All Players")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
            }
        }
        .onAppear(perform: loadPlayerStats)
    }
    //using the json data
    func loadPlayerStats() {
        guard let url = Bundle.main.url(forResource: "realPlayerData", withExtension: "json") else {
            print("Could not locate realPlayerData.json in the app bundle.")
            return
        }

        do {
            let data = try Data(contentsOf: url)
            let decoded = try JSONDecoder().decode([PlayerStats].self, from: data)
            playerStats = decoded
        } catch {
            print("Failed to decode player data: \(error)")
        }
    }
}
//custom yellow border for search bar, makin it match with my theme
struct YellowBorder: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 30)
                    .stroke(Color.yellow, lineWidth:2)
            )
    }
}
#Preview {
    PlayersView()
        .environmentObject(SquadManager())
}
