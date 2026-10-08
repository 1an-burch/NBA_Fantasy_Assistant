# NBA Fantasy Assistant

An iOS app (SwiftUI) for managing a fantasy basketball squad. Browse real NBA player stats, build a squad, and find breakout candidates with a "Rising Stars" leaderboard.

## Features

- **Login gate** — simple demo login screen in front of the app (see note below)
- **Players tab** — browse, search, sort (points/assists/rebounds/steals/blocks), and filter by position across 740 real NBA players' season stats
- **Squad tab** — add/remove players to build your own fantasy squad, shared across tabs via a single `SquadManager` observable object
- **Rising Stars tab** — surfaces the top under-24 players by category (points, assists, rebounds, steals, blocks) — a simple "who should I be watching" leaderboard

## Screenshots
! [Login View](images/login.png)
! [Squad View](images/squad.png)
! [Search View](images/search.png)
! [Rising Stars View](images/rising.png)
## Requirements

- Xcode 16+
- iOS 17.0+ (simulator or device)

## Running it

1. Open `NBA_FANTASY_ASSISTANT_FINAL_2.xcodeproj` in Xcode
2. Build and run on a simulator or device (⌘R)
3. Log in with the demo credentials below

**Demo login:**
- Username: `FantasyAssistantDemo`
- Password: `FantasyPassword0102`

## Architecture

- `PlayerStats.swift` — `Codable` model for a player's season stats, decoded straight from the bundled `realPlayerData.json`
- `SquadManager.swift` — `ObservableObject` holding the user's squad, injected as an `@EnvironmentObject` so all three tabs share the same state
- `PlayersView.swift` / `SquadView.swift` / `RisingStarsView.swift` — one view per tab
- `MainTabView.swift` — the `TabView` container shown after login
- `LoginView.swift` — the entry screen

