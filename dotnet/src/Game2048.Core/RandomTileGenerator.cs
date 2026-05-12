namespace Game2048.Core;

public sealed class RandomTileGenerator : ITileGenerator
{
    private const double FourProbability = 0.1;

    private readonly Random _random;

    public RandomTileGenerator() : this(new Random()) { }

    public RandomTileGenerator(int seed) : this(new Random(seed)) { }

    public RandomTileGenerator(Random random)
    {
        _random = random ?? throw new ArgumentNullException(nameof(random));
    }

    public int NextValue() => _random.NextDouble() < FourProbability ? 4 : 2;

    public int NextEmptyCellIndex(int emptyCellCount)
    {
        if (emptyCellCount <= 0)
        {
            throw new ArgumentOutOfRangeException(nameof(emptyCellCount));
        }

        return _random.Next(emptyCellCount);
    }
}
