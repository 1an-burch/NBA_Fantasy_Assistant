import SwiftUI

class SquadManager: ObservableObject {
    @Published var squad: [PlayerStats] = []

    //addition of playe rto squad, duplicates not allowed
    func addPlayerToSquad(_ player: PlayerStats) {
        if !squad.contains(where: { $0.id == player.id }) {
            squad.append(player)
        }
    }

    //delete button for squad view
    func removePlayer(at position: String) {
        if let index = squad.firstIndex(where: { $0.position == position }) {
            squad.remove(at: index)
        }
    }

    //player positions
    func player(at position: String) -> PlayerStats? {
        return squad.first { $0.position == position }
    }
}


