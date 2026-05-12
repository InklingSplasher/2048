# 2048 - C# / .NET Port

Re-implementation of the original Processing 2048 game in C# on .NET 8. The
solution is split so that the game rules sit in a pure, UI-free library and
the browser front-end consumes them through Blazor WebAssembly.

## Projects

| Project              | Type                      | Purpose                                                                 |
| -------------------- | ------------------------- | ----------------------------------------------------------------------- |
| `Game2048.Core`      | Class library (`net8.0`)  | Immutable `GameBoard`, move/merge rules, `GameSession`, tile generator. |
| `Game2048.Web`       | Blazor WebAssembly app    | UI, keyboard input, dark mode, local-storage high score.                |
| `Game2048.Tests`     | xUnit test project        | Unit tests for the game logic.                                          |

The Web project depends on Core; the Tests project depends on Core. Core has
no dependencies on UI or storage and is fully deterministic when wired with a
custom `ITileGenerator`.

## Running

```bash
cd dotnet
dotnet run --project src/Game2048.Web
```

The Blazor dev server prints a URL (`http://localhost:5xxx`); open it in a
browser. Keyboard: arrow keys or WASD to move, `R` for a new game.

## Tests

```bash
dotnet test
```

## Features

- 4x4 grid, canonical 2048 rules (each tile merges at most once per move).
- Random spawns: 90% `2`, 10% `4` (the original Processing port used 50/50).
- Endless mode after reaching 2048 ("Weiterspielen" / "Neu starten").
- Dark Mode toggle, persisted in `localStorage`.
- High score persisted in `localStorage`.
