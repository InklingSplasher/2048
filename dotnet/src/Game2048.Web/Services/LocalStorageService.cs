using Microsoft.JSInterop;

namespace Game2048.Web.Services;

/// <summary>
/// Minimal typed wrapper around <c>window.localStorage</c>. Treats parse and
/// JS errors as "no value present" — the call site only needs a default-or-value
/// outcome.
/// </summary>
public sealed class LocalStorageService
{
    private readonly IJSRuntime _js;

    public LocalStorageService(IJSRuntime js)
    {
        _js = js;
    }

    public async ValueTask<int> GetIntAsync(string key, int defaultValue = 0)
    {
        try
        {
            var raw = await _js.InvokeAsync<string?>("localStorage.getItem", key);
            return int.TryParse(raw, out var value) ? value : defaultValue;
        }
        catch (JSException)
        {
            return defaultValue;
        }
    }

    public async ValueTask<bool> GetBoolAsync(string key, bool defaultValue = false)
    {
        try
        {
            var raw = await _js.InvokeAsync<string?>("localStorage.getItem", key);
            return bool.TryParse(raw, out var value) ? value : defaultValue;
        }
        catch (JSException)
        {
            return defaultValue;
        }
    }

    public ValueTask SetAsync(string key, int value) =>
        _js.InvokeVoidAsync("localStorage.setItem", key, value.ToString());

    public ValueTask SetAsync(string key, bool value) =>
        _js.InvokeVoidAsync("localStorage.setItem", key, value ? "true" : "false");
}
