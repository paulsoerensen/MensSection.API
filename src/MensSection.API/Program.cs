using MensSection.API.Domain;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Authorization;
using MensSection.API.EndpointDefinitions;
using Serilog;

var builder = WebApplication.CreateBuilder(args);

// Apply logging 
builder.Logging.ClearProviders();
var path = builder.Configuration.GetValue<string>("LogPath");
var logger = new LoggerConfiguration()
    .WriteTo.File(path)
    .CreateLogger();
builder.Logging.AddSerilog(logger);

builder.Services.AddEndpointDefinitions(typeof(MatchEndpoint));
builder.Services.AddEndpointDefinitions(typeof(ClubEndpoint));

builder.Services.AddAutoMapper(AppDomain.CurrentDomain.GetAssemblies());

builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme).AddJwtBearer();
builder.Services.AddAuthorization(options => 
{
    options.FallbackPolicy = new AuthorizationPolicyBuilder()
    .AddAuthenticationSchemes(JwtBearerDefaults.AuthenticationScheme)
    .RequireAuthenticatedUser()
    .Build();
});

var app = builder.Build();
app.Logger.LogInformation("Starting the app");

app.UseEndpointDefinitions();

app.UseHttpsRedirection();

app.Run();

 