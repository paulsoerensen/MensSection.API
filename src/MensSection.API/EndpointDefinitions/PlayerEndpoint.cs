using AutoMapper;
using MensSection.Api.Domain;
using MensSection.Api.Dtos;
using MensSection.Api.Models;
using Microsoft.AspNetCore.Mvc;

namespace MensSection.Api.EndpointDefinitions;

public class PlayerEndpoint : IEndpointDefinition
{
    private IMapper mapper;

    public PlayerEndpoint()
    {
        mapper = new MapperConfiguration(cfg =>
        {
            cfg.CreateMap<Player, PlayerDto>()
                .ReverseMap();
        }).CreateMapper();
    }
    public void DefineEndpoints(WebApplication app)
    {
        app.MapGet("api/v1/player", GetSeasonPlayers);
        app.MapGet("api/v1/player/{playerId}", GetPlayer);
        app.MapPost("api/v1/player", UpsertPlayer);
        app.MapPut("api/v1/player", UpsertPlayer);
    }

    public void DefineServices(IServiceCollection services)
    {
        services.AddScoped<IRepository, Repository>();
    }

    #region Club
    internal async Task<IResult> GetSeasonPlayers(IRepository repo, int season)
    {
        var model = await repo.GetPlayers(season);
        if (model != null)
        {
            return Results.Ok(mapper.Map<IEnumerable<PlayerDto>>(model));
        }
        return Results.NotFound();
    }
    internal async Task<IResult> GetPlayer(IRepository repo, [FromQuery(Name = "playerId")] int playerId)
    {
        var model = await repo.GetPlayer(playerId);
        if (model != null)
        {
            return Results.Ok(mapper.Map<PlayerDto>(model));
        }
        return Results.NotFound();
    }
    internal IResult UpsertPlayer(IRepository repo, PlayerDto dto) 
    {
        var model = mapper.Map<Models.Player>(dto);
        model = repo.PlayerUpsert(model).Result;
        if (model != null) {
            return Results.Ok(mapper.Map<PlayerDto>(model));
        }
        return Results.Created($"api/v1/player/{model?.PlayerId}", model);
    }
    #endregion
}

