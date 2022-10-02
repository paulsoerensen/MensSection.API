using AutoMapper;
using MensSection.Api.Domain;
using MensSection.Api.Dtos;
using MensSection.Api.Models;

namespace MensSection.Api.EndpointDefinitions;

public class MatchEndpoint : IEndpointDefinition
{
    private IMapper mapper;
    public MatchEndpoint()
    {
        mapper = new MapperConfiguration(cfg =>
        {
            cfg.CreateMap<Player, PlayerDto>()
                //.ForMember(dest => dest.Year,
                //            opts => opts.MapFrom(src => new DateTime(src.Year, 1, 1)))
                //.ForMember(dest => dest.ConsumptionkWh,
                //            opts => opts.MapFrom(src => src.Qnt))
                .ReverseMap();
        }).CreateMapper();
    }

    public void DefineEndpoints(WebApplication app)
    {
        app.MapGet("api/v1/match/{id}", GetMatch);
        app.MapGet("api/v1/match", GetMatches); 
        app.MapGet("api/v1/match/season/{season}", GetSeasonMatches); 
        app.MapPost("api/v1/match", UpsertMatch);      
    }

    public void DefineServices(IServiceCollection services)
    {
        services.AddScoped<IRepository, Repository>();
    }
 
    internal async Task<IResult> GetMatch(IRepository repo, int id)
    {
        var match = await repo.GetMatch(id);
        if (match != null) {
            return Results.Ok(mapper.Map<MatchDto>(match));
        }
        return Results.NotFound();        
    }

    internal async Task<IResult> GetMatches(IRepository repo) 
    {
        var models = await repo.GetMatchList();
        if (models != null) {
            return Results.Ok(mapper.Map<IEnumerable<MatchDto>>(models));
        }
        return Results.NotFound();
    }        

    internal async Task<IResult> GetSeasonMatches(IRepository repo, int season) 
    {
        var models = await repo.GetSeasonMatchList(season);
        if (models != null) {
            return Results.Ok(mapper.Map<IEnumerable<MatchDto>>(models));
        }
        return Results.NotFound();
    }        
    internal async Task<IResult> UpsertMatch(IRepository repo, Models.Match dto) 
    {
        var model = mapper.Map<Models.Match>(dto);
        model = await repo.MatchUpsert(model);
        if (model != null) {
            return Results.Ok(mapper.Map<MatchDto>(model));
        }
        return Results.Created($"api/v1/match/{model?.MatchId}", model);
    }        
}

