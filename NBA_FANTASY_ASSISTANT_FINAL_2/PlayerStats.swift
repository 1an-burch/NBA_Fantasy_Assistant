import Foundation

//Json variables
struct PlayerStats: Identifiable, Codable, Equatable {
    let id: Int
    let playerName: String
    let games: Int
    let points: Int
    let assists: Int
    let totalRb: Int
    let steals: Int
    let blocks: Int
    let fieldPercent: Double?
    let threePercent: Double?
    let position: String
    let team: String
    let age: Int
    
//Per game stat calculations
    var ppg: Double { games > 0 ? Double(points) / Double(games) : 0 }
    var apg: Double { games > 0 ? Double(assists) / Double(games) : 0 }
    var rpg: Double { games > 0 ? Double(totalRb) / Double(games) : 0 }
    var spg: Double { games > 0 ? Double(steals) / Double(games) : 0 }
    var bpg: Double { games > 0 ? Double(blocks) / Double(games) : 0 }
}
