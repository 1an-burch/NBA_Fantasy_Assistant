import SwiftUI

struct SquadView: View {
    @EnvironmentObject var squadManager: SquadManager
    @State private var showRemovedNotification = false
    let positions = ["PG", "SG", "SF", "PF", "C"]

    //squad stack
    var body: some View {
        NavigationView {
            ZStack {
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(positions, id: \.self) { position in
                        SquadSlotView(position: position, showRemovedNotification: $showRemovedNotification)
                            .padding(.bottom, 8)
                    }

                    Spacer()
                }
                .padding([.top, .horizontal])
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("Your Squad")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                }
                .background(Color.black)
                
                //notifies of removal of squad member (like the add button)
                if showRemovedNotification {
                    VStack {
                        Text("Removed!")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.red)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                            .transition(.move(edge: .top))
                            .zIndex(1)
                    }
                    .padding(.top, 10)
                }
            }
        }
    }
}

//configuring slots for squad
struct SquadSlotView: View {
    @EnvironmentObject var squadManager: SquadManager
    let position: String
    @Binding var showRemovedNotification: Bool

    var body: some View {
        VStack {
            HStack {
                Text(position)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(6)
                    .background(Color.black)
                    .clipShape(Circle())
                    .padding(.leading, 12)

                Spacer()
            }

            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray.opacity(0.5))
                    .shadow(radius: 3)
                    .overlay(RoundedRectangle(cornerRadius: 20) .stroke(.yellow, lineWidth: 2))
                VStack {
                    if let player = squadManager.player(at: position) {
                        HStack {
                            if let logo = UIImage(named: player.team) {
                                Image(uiImage: logo)
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .clipShape(Circle())
                            }

                            VStack(alignment: .leading, spacing: 4) {
                                Text(player.playerName)
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)

                                Text("Team: \(player.team)")
                                    .font(.caption)
                                    .foregroundColor(.white)
                            }

                            Spacer()

                            //removal button
                            Button(action: {
                                squadManager.removePlayer(at: position)
                                showRemovedNotification = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    showRemovedNotification = false
                                }
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                                    .font(.title2)
                            }
                        }
                        .padding([.top, .bottom], 6)
                    } else {
                        Text("Insert Selected Player")
                            .font(.subheadline)
                            .foregroundColor(.white)
                            .padding([.top, .bottom], 6)
                    }
                }
                .padding([.leading, .trailing], 10)
            }
        }
    }
}

#Preview {
    SquadView()
        .environmentObject(SquadManager())
}
