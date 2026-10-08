import SwiftUI

struct RisingStarsView: View {
    @State private var playerStats: [PlayerStats] = []
    
    //rising stars list (filtering 23 and under)
    var risingStars: [(title: String, stat: String, player: PlayerStats)] {
        let youngPlayers = playerStats.filter { $0.age <= 23 }

        var result: [(String, String, PlayerStats)] = []

        if let ppgLeader = youngPlayers.max(by: { $0.ppg < $1.ppg }) {
            result.append(("Rising Bucket", "Points", ppgLeader))
        }

        if let apgLeader = youngPlayers.max(by: { $0.apg < $1.apg }) {
            result.append(("Rising Facilitator", "Assists", apgLeader))
        }

        if let rpgLeader = youngPlayers.max(by: { $0.rpg < $1.rpg }) {
            result.append(("Rising Board-Getter", "Rebounds", rpgLeader))
        }

        if let spgLeader = youngPlayers.max(by: { $0.spg < $1.spg }) {
            result.append(("Rising Disruptor", "Steals", spgLeader))
        }

        if let bpgLeader = youngPlayers.max(by: { $0.bpg < $1.bpg }) {
            result.append(("Rising Rim-Protector", "Blocks", bpgLeader))
        }

        return result
    }

    var body: some View {
        NavigationView {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)

                //scrolling for easy visual
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(risingStars, id: \.stat) { item in
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Spacer()
                                    Text(item.title)
                                        .font(.title3)
                                        .fontWeight(.bold)
                                        .foregroundColor(.black)
                                        .padding(.vertical, 6)
                                        .padding(.horizontal, 12)
                                        .background(Color.yellow)
                                        .clipShape(Capsule())
                                    Spacer()
                                }
                                //team logo for each player
                                HStack(spacing: 16) {
                                    if let logo = UIImage(named: item.player.team) {
                                        Image(uiImage: logo)
                                            .resizable()
                                            .frame(width: 50, height: 50)
                                            .clipShape(Circle())
                                    }
                                    //text stuff
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(item.player.playerName)
                                            .font(.headline)
                                            .foregroundColor(.white)

                                        Text("Age: \(item.player.age)")
                                            .font(.subheadline)
                                            .foregroundColor(.white)

                                        Text("\(item.stat): \(statValue(for: item.stat, player: item.player), specifier: "%.1f")")
                                            .font(.subheadline)
                                            .foregroundColor(.white)
                                    }

                                    Spacer()
                                }
                            }
                            .padding()
                            .background(Color.gray.opacity(0.5))
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.yellow, lineWidth: 2)
                            )
                            .padding(.horizontal)
                        }
                    }
                    .padding(.top)
                }
                //title bar
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("Rising Stars")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                }
            }
        }
        .onAppear(perform: loadPlayerStats)
    }
    
    //switch statement for players
    private func statValue(for stat: String, player: PlayerStats) -> Double {
        switch stat {
        case "Points": return player.ppg
        case "Assists": return player.apg
        case "Rebounds": return player.rpg
        case "Steals": return player.spg
        case "Blocks": return player.bpg
        default: return 0.0
        }
    }
    //json decoding
    private func loadPlayerStats() {
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

#Preview {
    RisingStarsView()
}
