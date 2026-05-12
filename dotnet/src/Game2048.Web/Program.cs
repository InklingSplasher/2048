using Microsoft.AspNetCore.Components.Web;
using Microsoft.AspNetCore.Components.WebAssembly.Hosting;
using Game2048.Core;
using Game2048.Web;
using Game2048.Web.Services;

var builder = WebAssemblyHostBuilder.CreateDefault(args);
builder.RootComponents.Add<App>("#app");
builder.RootComponents.Add<HeadOutlet>("head::after");

builder.Services.AddScoped<LocalStorageService>();
builder.Services.AddScoped<HighScoreService>();
builder.Services.AddScoped<ThemeService>();
builder.Services.AddScoped<ITileGenerator>(_ => new RandomTileGenerator());

await builder.Build().RunAsync();
