namespace Game2048.Web.Services;

public sealed class ThemeService
{
    private const string StorageKey = "game2048.darkmode";

    private readonly LocalStorageService _storage;

    public ThemeService(LocalStorageService storage)
    {
        _storage = storage;
    }

    public bool IsDarkMode { get; private set; }

    public event Action? Changed;

    public async Task LoadAsync()
    {
        IsDarkMode = await _storage.GetBoolAsync(StorageKey);
        Changed?.Invoke();
    }

    public async Task ToggleAsync()
    {
        IsDarkMode = !IsDarkMode;
        await _storage.SetAsync(StorageKey, IsDarkMode);
        Changed?.Invoke();
    }
}
