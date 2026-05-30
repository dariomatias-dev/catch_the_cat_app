<div align="center">

<img src="https://img.shields.io/badge/Flutter-3.44.0-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter">
<img src="https://img.shields.io/badge/Dart-SDK%20^3.12.0-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart">
<img src="https://img.shields.io/badge/Riverpod-2.6.1-08479E?style=for-the-badge" alt="Riverpod">
<img src="https://img.shields.io/badge/Architecture-MVVM%20%2B%20Clean%20%2B%20Feature--First-green?style=for-the-badge" alt="Architecture">

</div>

<br>

<p align="center">
<strong>Language:</strong>
<strong>English</strong> | <a href="README.pt.md">Português</a>
</p>

<h1 align="center">Catch the Cat</h1>

<p align="center">
  A strategy puzzle game on a hexagonal grid — place barriers and trap the cat before it escapes.
  <br><br>
  <a href="https://github.com/dariomatias-dev/catch_the_cat_app/issues">Report Bug</a> ·
  <a href="https://github.com/dariomatias-dev/catch_the_cat_app/issues">Request Feature</a>
</p>

---

## Table of Contents

- [About the Project](#about-the-project)
- [How to Play](#how-to-play)
- [Difficulty Levels](#difficulty-levels)
- [Architecture](#architecture)
- [Folder Structure](#folder-structure)
- [Key Technologies](#key-technologies)
- [Getting Started](#getting-started)
- [Authors](#authors)

---

## About the Project

Catch the Cat is a single-player strategy game played on an 11×11 hexagonal grid. Each turn the player places one barrier; the CPU then moves the cat one step toward the nearest escape route. The player wins by completely surrounding the cat; the CPU wins if the cat reaches the board's edge.

The game tracks wins and losses across sessions and supports three difficulty levels that affect both the initial board setup and the cat's AI behavior.

---

## How to Play

1. Tap any empty cell to place a barrier.
2. The cat responds immediately, moving one step toward its best escape route.
3. Keep placing barriers to narrow the cat's escape paths.
4. **Player wins** — the cat is surrounded with no valid moves.
5. **Cat wins** — the cat reaches the board's edge.

---

## Difficulty Levels

| Level  | Initial Barriers | Cat Start Position | CPU AI Behavior                                                                                   |
| ------ | ---------------- | ------------------ | ------------------------------------------------------------------------------------------------- |
| Easy   | 6 – 10           | Random             | Moves to a random empty cell                                                                      |
| Medium | 9 – 15           | Central region     | Follows the shortest escape path                                                                  |
| Hard   | 12 – 16          | Fixed center (5,5) | Maximizes escape distance — picks the blocking cell that increases the cat's escape path the most |

---

## Architecture

The project applies three complementary patterns:

```
Feature-First  →  folder organization by business domain
Clean Arch     →  explicit dependency rules between layers
MVVM           →  decoupled UI and presentation logic
```

Data flow inside each feature:

```
Screen → Provider → ViewModel → Repository (contract) → RepositoryImpl → DataSource
```

The Domain layer (`entities`, `repositories`, `services`) is pure Dart with zero external dependencies. The UI never touches persistence or AI logic directly.

---

## Folder Structure

```text
lib/src/
├── core/
│   ├── providers/        # Global providers (audio, SharedPreferences)
│   ├── services/         # AudioService
│   └── theme/            # App colors and theme
└── features/
    └── game/
        ├── data/         # Repository implementations
        ├── di/           # Dependency injection (Riverpod providers)
        ├── domain/
        │   ├── entities/ # CellState, Difficulty, GameResult, Position
        │   ├── repositories/
        │   └── services/ # BoardService (BFS pathfinding), CpuAiService
        └── presentation/
            ├── providers/    # GameProvider (Notifier)
            ├── screens/      # GameScreen
            ├── view_models/  # GameStateViewModel
            └── widgets/      # Board, cells, header, score panel, status banner
```

---

## Key Technologies

| Technology         | Version | Role                     |
| ------------------ | ------- | ------------------------ |
| Flutter            | 3.44.0  | UI framework             |
| Dart SDK           | ^3.12.0 | Language                 |
| flutter_riverpod   | 2.6.1   | State management and DI  |
| audioplayers       | 6.7.0   | Background music and SFX |
| shared_preferences | 2.5.5   | Persistent score storage |

---

## Getting Started

### Prerequisites

- [FVM](https://fvm.app) installed
- Flutter `3.44.0` managed via FVM

### Installation

```bash
# Clone the repository
git clone https://github.com/dariomatias-dev/catch_the_cat_app.git

# Enter the project directory
cd catch_the_cat_app

# Install the correct Flutter version
fvm install

# Install dependencies
fvm flutter pub get

# Run the app
fvm flutter run
```

### Supported Platforms

Android · Web · Desktop

---

## Authors

**Alison Andrade**

- GitHub: [https://github.com/AlisonAndrade123](https://github.com/AlisonAndrade123)
- LinkedIn: [https://www.linkedin.com/in/alison-andrade-b23621308/](https://www.linkedin.com/in/alison-andrade-b23621308/)

**Dário Matias**

- GitHub: [https://github.com/dariomatias-dev](https://github.com/dariomatias-dev)
- LinkedIn: [https://linkedin.com/in/dariomatias-dev](https://linkedin.com/in/dariomatias-dev)

**José Arthur Almeida**

- GitHub: [https://github.com/JoseArthurAlmeida](https://github.com/JoseArthurAlmeida)
- LinkedIn: [https://www.linkedin.com/in/jose-arthur-araujo-almeida/](https://www.linkedin.com/in/jose-arthur-araujo-almeida/)
