using Game2048.Core;
using Game2048.Web.Services;
using Microsoft.AspNetCore.Components;
using Microsoft.AspNetCore.Components.Web;

namespace Game2048.Web.Pages;

public class HomeBase : ComponentBase, IDisposable
{
    [Inject] protected ITileGenerator TileGenerator { get; set; } = default!;
    [Inject] protected HighScoreService HighScore { get; set; } = default!;
    [Inject] protected ThemeService Theme { get; set; } = default!;

    protected GameSession Session { get; private set; } = default!;
    protected ElementReference _boardElement;

    private bool _initialFocusPending;

    protected override async Task OnInitializedAsync()
    {
        Session = new GameSession(TileGenerator);
        Session.Start();
        Theme.Changed += OnThemeChanged;
        await HighScore.LoadAsync();
        await Theme.LoadAsync();
        _initialFocusPending = true;
    }

    protected override async Task OnAfterRenderAsync(bool firstRender)
    {
        if (_initialFocusPending)
        {
            _initialFocusPending = false;
            try
            {
                await _boardElement.FocusAsync();
            }
            catch
            {
                // Focus is a quality-of-life touch; if it fails on a given
                // browser, swallow rather than break the page.
            }
        }
    }

    protected async Task OnKeyDown(KeyboardEventArgs e)
    {
        if (TryMapDirection(e.Key, out var direction))
        {
            await HandleMove(direction);
        }
        else if (string.Equals(e.Key, "r", StringComparison.OrdinalIgnoreCase))
        {
            NewGame();
        }
    }

    private async Task HandleMove(Direction direction)
    {
        if (!Session.CanMove)
        {
            return;
        }

        if (Session.Move(direction))
        {
            await HighScore.TryUpdateAsync(Session.Score);
            StateHasChanged();
        }
    }

    protected void NewGame()
    {
        Session.Start();
        StateHasChanged();
    }

    protected void ContinuePlaying()
    {
        Session.ContinueAfterWin();
        StateHasChanged();
    }

    protected async Task ToggleTheme()
    {
        await Theme.ToggleAsync();
    }

    private void OnThemeChanged() => InvokeAsync(StateHasChanged);

    private static bool TryMapDirection(string key, out Direction direction)
    {
        switch (key)
        {
            case "ArrowUp":
            case "w":
            case "W":
                direction = Direction.Up;
                return true;
            case "ArrowDown":
            case "s":
            case "S":
                direction = Direction.Down;
                return true;
            case "ArrowLeft":
            case "a":
            case "A":
                direction = Direction.Left;
                return true;
            case "ArrowRight":
            case "d":
            case "D":
                direction = Direction.Right;
                return true;
            default:
                direction = default;
                return false;
        }
    }

    public void Dispose()
    {
        Theme.Changed -= OnThemeChanged;
    }
}
