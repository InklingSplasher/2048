using Game2048.Core;

namespace Game2048.Tests;

/// <summary>
/// Deterministic <see cref="ITileGenerator"/> for tests. Consumers configure
/// the exact sequence of spawned values and the index (across the empty cells
/// in row-major order) where each one lands.
/// </summary>
internal sealed class ScriptedTileGenerator : ITileGenerator
{
    private readonly Queue<int> _values;
    private readonly Queue<int> _indices;

    public ScriptedTileGenerator(IEnumerable<int> values, IEnumerable<int> indices)
    {
        _values = new Queue<int>(values);
        _indices = new Queue<int>(indices);
    }

    public int NextValue() =>
        _values.Count > 0 ? _values.Dequeue() : 2;

    public int NextEmptyCellIndex(int emptyCellCount) =>
        _indices.Count > 0 ? _indices.Dequeue() : 0;
}
