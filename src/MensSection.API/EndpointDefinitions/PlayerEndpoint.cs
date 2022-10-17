using AutoMapper;
using MensSection.API.Domain;
using MensSection.API.Dtos;
using MensSection.API.Models;
using Microsoft.AspNetCore.Mvc;

namespace MensSection.API.EndpointDefinitions;

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
        app.MapGet("api/player", GetSeasonPlayers);
        app.MapGet("api/player/{vgcNo}", GetPlayer);
        app.MapPost("api/player", UpsertPlayer);
        app.MapPut("api/player", UpsertPlayer);
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
    internal async Task<IResult> GetPlayer(IRepository repo, [FromQuery(Name = "vgcNo")] int vgcNo)
    {
        var model = await repo.GetPlayer(vgcNo);
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
        return Results.Created($"api/player/{model?.VgcNo}", model);
    }
    #endregion
}

