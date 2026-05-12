using System.Text;

namespace Game2048.Core;

/// <summary>
/// Immutable 4x4 grid of tile values. A value of <c>0</c> represents an empty cell.
/// Indexing uses <c>[row, column]</c> with the origin at the top-left corner.
/// </summary>
public sealed class GameBoard : IEquatable<GameBoard>
{
    public const int Size = 4;

    private readonly int[,] _cells;

    private GameBoard(int[,] cells)
    {
        _cells = cells;
    }

    public static GameBoard Empty() => new(new int[Size, Size]);

    public static GameBoard FromCells(int[,] cells)
    {
        ArgumentNullException.ThrowIfNull(cells);
        if (cells.GetLength(0) != Size || cells.GetLength(1) != Size)
        {
            throw new ArgumentException($"Expected a {Size}x{Size} grid.", nameof(cells));
        }

        var copy = new int[Size, Size];
        Array.Copy(cells, copy, cells.Length);
        return new GameBoard(copy);
    }

    public int this[int row, int column] => _cells[row, column];

    public int HighestTile
    {
        get
        {
            int max = 0;
            for (int r = 0; r < Size; r++)
            {
                for (int c = 0; c < Size; c++)
                {
                    if (_cells[r, c] > max)
                    {
                        max = _cells[r, c];
                    }
                }
            }
            return max;
        }
    }

    public int EmptyCellCount
    {
        get
        {
            int count = 0;
            for (int r = 0; r < Size; r++)
            {
                for (int c = 0; c < Size; c++)
                {
                    if (_cells[r, c] == 0)
                    {
                        count++;
                    }
                }
            }
            return count;
        }
    }

    public bool HasAnyMove()
    {
        if (EmptyCellCount > 0)
        {
            return true;
        }

        for (int r = 0; r < Size; r++)
        {
            for (int c = 0; c < Size; c++)
            {
                int v = _cells[r, c];
                if (c + 1 < Size && _cells[r, c + 1] == v) return true;
                if (r + 1 < Size && _cells[r + 1, c] == v) return true;
            }
        }

        return false;
    }

    /// <summary>
    /// Returns a new board with the tile at <paramref name="emptyCellIndex"/>
    /// (counted across empty cells in row-major order) set to <paramref name="value"/>.
    /// </summary>
    public GameBoard WithSpawnedTile(int emptyCellIndex, int value)
    {
        if (value <= 0)
        {
            throw new ArgumentOutOfRangeException(nameof(value), "Spawned tile value must be positive.");
        }

        var next = (int[,])_cells.Clone();
        int seen = 0;
        for (int r = 0; r < Size; r++)
        {
            for (int c = 0; c < Size; c++)
            {
                if (next[r, c] == 0)
                {
                    if (seen == emptyCellIndex)
                    {
                        next[r, c] = value;
                        return new GameBoard(next);
                    }
                    seen++;
                }
            }
        }

        throw new InvalidOperationException("No empty cell at the requested index.");
    }

    /// <summary>
    /// Slides and merges tiles in the given direction. Each tile may only be
    /// merged once per move. The returned <see cref="MoveResult"/> contains the
    /// new board, the score gained from merges, whether anything moved and the
    /// highest value produced by a merge during this move (0 if none).
    /// </summary>
    public MoveResult Move(Direction direction)
    {
        var next = (int[,])_cells.Clone();
        int score = 0;
        int highestMerge = 0;
        bool moved = false;

        Span<int> values = stackalloc int[Size];
        Span<int> result = stackalloc int[Size];

        for (int lane = 0; lane < Size; lane++)
        {
            var positions = LanePositions(direction, lane);
            for (int i = 0; i < Size; i++)
            {
                values[i] = next[positions[i].Row, positions[i].Column];
            }

            var (laneScore, laneHighest, laneMoved) = SlideAndMerge(values, result);
            score += laneScore;
            if (laneHighest > highestMerge) highestMerge = laneHighest;
            if (laneMoved) moved = true;

            for (int i = 0; i < Size; i++)
            {
                next[positions[i].Row, positions[i].Column] = result[i];
            }
        }

        return new MoveResult(new GameBoard(next), score, moved, highestMerge);
    }

    private static (int Score, int HighestMerge, bool Moved) SlideAndMerge(ReadOnlySpan<int> input, Span<int> output)
    {
        Span<int> compact = stackalloc int[Size];
        int count = 0;
        for (int i = 0; i < input.Length; i++)
        {
            if (input[i] != 0)
            {
                compact[count++] = input[i];
            }
        }

        int score = 0;
        int highest = 0;
        int outIndex = 0;
        int read = 0;
        while (read < count)
        {
            if (read + 1 < count && compact[read] == compact[read + 1])
            {
                int merged = compact[read] * 2;
                output[outIndex++] = merged;
                score += merged;
                if (merged > highest) highest = merged;
                read += 2;
            }
            else
            {
                output[outIndex++] = compact[read++];
            }
        }
        while (outIndex < output.Length)
        {
            output[outIndex++] = 0;
        }

        bool moved = false;
        for (int i = 0; i < input.Length; i++)
        {
            if (input[i] != output[i])
            {
                moved = true;
                break;
            }
        }

        return (score, highest, moved);
    }

    private static (int Row, int Column)[] LanePositions(Direction direction, int lane)
    {
        var positions = new (int Row, int Column)[Size];
        for (int i = 0; i < Size; i++)
        {
            positions[i] = direction switch
            {
                Direction.Up => (i, lane),
                Direction.Down => (Size - 1 - i, lane),
                Direction.Left => (lane, i),
                Direction.Right => (lane, Size - 1 - i),
                _ => throw new ArgumentOutOfRangeException(nameof(direction))
            };
        }
        return positions;
    }

    public bool Equals(GameBoard? other)
    {
        if (other is null) return false;
        if (ReferenceEquals(this, other)) return true;
        for (int r = 0; r < Size; r++)
        {
            for (int c = 0; c < Size; c++)
            {
                if (_cells[r, c] != other._cells[r, c]) return false;
            }
        }
        return true;
    }

    public override bool Equals(object? obj) => obj is GameBoard other && Equals(other);

    public override int GetHashCode()
    {
        var hash = new HashCode();
        for (int r = 0; r < Size; r++)
        {
            for (int c = 0; c < Size; c++)
            {
                hash.Add(_cells[r, c]);
            }
        }
        return hash.ToHashCode();
    }

    public override string ToString()
    {
        var sb = new StringBuilder();
        for (int r = 0; r < Size; r++)
        {
            for (int c = 0; c < Size; c++)
            {
                if (c > 0) sb.Append(' ');
                sb.Append(_cells[r, c].ToString().PadLeft(4));
            }
            sb.AppendLine();
        }
        return sb.ToString();
    }
}
