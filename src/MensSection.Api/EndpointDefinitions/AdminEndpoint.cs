using AutoMapper;
using MensSection.API.Domain;
using MensSection.API.Dtos;
using MensSection.API.Models;

namespace MensSection.API.EndpointDefinitions;

public class AdminEndpoint : IEndpointDefinition
{
    private IMapper mapper;
    private readonly ILogger<AdminEndpoint> _logger;

    public AdminEndpoint()
    {; }
    public AdminEndpoint(ILogger<AdminEndpoint> logger)
    {
        _logger = logger;
    }

    public void DefineEndpoints(WebApplication app)
    {
        try
        { 
            app.MapGet("api/admin/info", GetInfo);
        }
        catch (Exception e)
        {
            _logger.LogError(e.ToString());
        }
    }

    public void DefineServices(IServiceCollection services)
    {
        services.AddScoped<IRepository, Repository>();
    }

    #region Club
    internal async Task<IResult> GetInfo(IRepository repo)
    {
        var s = //string.Join(Environment.NewLine, repo.Info());
        string.Join
        (
            Environment.NewLine,
            repo.Info().Select(pair => $"{pair.Key}={pair.Value}").ToArray()
        );
        return Results.Ok(s);
    }
    #endregion
}

