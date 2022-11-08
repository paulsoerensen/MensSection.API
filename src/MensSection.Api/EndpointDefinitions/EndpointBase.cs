using AutoMapper;
using MensSection.Api.Domain;
using MensSection.Api.Dtos;
using MensSection.Api.Models;
using System.Configuration;

namespace MensSection.Api.EndpointDefinitions;

public class EndpointBase : IEndpointDefinition
{
    protected ILogger? _logger;
    protected IConfiguration? _config;
    public virtual void DefineEndpoints(WebApplication app)
    {
        _logger = app.Logger;
        _config = app.Configuration;
    }

    public virtual void DefineServices(IServiceCollection services)
    {
        services.AddScoped<IRepository, Repository>();
    }
}

