namespace Game2048.Core;

/// <summary>
/// Mutable session that ties a <see cref="GameBoard"/>, a tile generator and the
/// player's score together. Designed to be driven by a UI layer.
/// </summary>
public sealed class GameSession
{
    public const int DefaultWinTarget = 2048;

    private readonly ITileGenerator _generator;

    public GameSession() : this(new RandomTileGenerator(), DefaultWinTarget) { }

    public GameSession(ITileGenerator generator) : this(generator, DefaultWinTarget) { }

    public GameSession(ITileGenerator generator, int winTarget)
    {
        ArgumentNullException.ThrowIfNull(generator);
        if (winTarget < 4 || (winTarget & (winTarget - 1)) != 0)
        {
            throw new ArgumentException("Win target must be a power of two and at least 4.", nameof(winTarget));
        }

        _generator = generator;
        WinTarget = winTarget;
        Board = GameBoard.Empty();
        Status = GameStatus.Playing;
    }

    public GameBoard Board { get; private set; }

    public int Score { get; private set; }

    public int WinTarget { get; }

    public GameStatus Status { get; private set; }

    public bool IsGameOver => Status == GameStatus.Lost;

    public bool CanMove => Status == GameStatus.Playing || Status == GameStatus.WonContinuing;

    /// <summary>
    /// Resets the session: clears the board and score and spawns the two
    /// initial tiles, returning the session to <see cref="GameStatus.Playing"/>.
    /// </summary>
    public void Start()
    {
        Board = GameBoard.Empty();
        Score = 0;
        Status = GameStatus.Playing;
        SpawnTile();
        SpawnTile();
    }

    /// <summary>
    /// Performs a move in the given direction. A new tile is only spawned if
    /// the move actually changed the board. The session status is updated to
    /// <see cref="GameStatus.Won"/> on first reaching the win target or to
    /// <see cref="GameStatus.Lost"/> when no further moves are possible.
    /// </summary>
    /// <returns><c>true</c> if the move changed the board, otherwise <c>false</c>.</returns>
    public bool Move(Direction direction)
    {
        if (!CanMove)
        {
            return false;
        }

        var result = Board.Move(direction);
        if (!result.Moved)
        {
            return false;
        }

        Board = result.Board;
        Score += result.ScoreGained;

        if (Status == GameStatus.Playing && result.HighestMerge >= WinTarget)
        {
            Status = GameStatus.Won;
        }

        SpawnTile();

        if (!Board.HasAnyMove())
        {
            Status = GameStatus.Lost;
        }

        return true;
    }

    /// <summary>
    /// Acknowledges a win and switches to endless play. No-op outside of the
    /// <see cref="GameStatus.Won"/> state.
    /// </summary>
    public void ContinueAfterWin()
    {
        if (Status == GameStatus.Won)
        {
            Status = GameStatus.WonContinuing;
        }
    }

    private void SpawnTile()
    {
        int empties = Board.EmptyCellCount;
        if (empties == 0)
        {
            return;
        }

        int index = _generator.NextEmptyCellIndex(empties);
        int value = _generator.NextValue();
        Board = Board.WithSpawnedTile(index, value);
    }
}
