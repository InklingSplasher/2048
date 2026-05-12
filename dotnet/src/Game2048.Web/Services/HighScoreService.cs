namespace Game2048.Web.Services;

public sealed class HighScoreService
{
    private const string StorageKey = "game2048.highscore";

    private readonly LocalStorageService _storage;

    public HighScoreService(LocalStorageService storage)
    {
        _storage = storage;
    }

    public int Current { get; private set; }

    public async Task LoadAsync()
    {
        Current = await _storage.GetIntAsync(StorageKey);
    }

    /// <summary>
    /// If <paramref name="score"/> beats the stored high score, persists it and
    /// returns <c>true</c>. Otherwise returns <c>false</c> without writing.
    /// </summary>
    public async Task<bool> TryUpdateAsync(int score)
    {
        if (score <= Current)
        {
            return false;
        }

        Current = score;
        await _storage.SetAsync(StorageKey, score);
        return true;
    }
}
