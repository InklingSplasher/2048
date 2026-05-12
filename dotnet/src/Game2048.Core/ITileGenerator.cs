namespace Game2048.Core;

public interface ITileGenerator
{
    int NextValue();

    int NextEmptyCellIndex(int emptyCellCount);
}
