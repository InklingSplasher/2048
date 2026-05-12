namespace Game2048.Core;

public sealed record MoveResult(GameBoard Board, int ScoreGained, bool Moved, int HighestMerge);
