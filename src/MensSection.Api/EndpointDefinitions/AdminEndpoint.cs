using AutoMapper;
using MensSection.API.Domain;
using MensSection.API.Dtos;
using MensSection.API.Models;

namespace MensSection.API.EndpointDefinitions;

public class AdminEndpoint : IEndpointDefinition
{
    private IMapper mapper;

    public AdminEndpoint()
    {; }

    public void DefineEndpoints(WebApplication app)
    {
        try
        {
            app.MapGet("api/admin/info", GetInfo);
            app.MapGet("api/admin/test", GetTest);
        }
        catch (Exception e)
        {
            ;
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
    internal async Task<IResult> GetTest(IRepository repo)
    {
        return Results.Ok("Some string");
    }

    #endregion
}

