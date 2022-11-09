using AutoMapper;
using MensSection.Api.Domain;
using MensSection.Api.Dtos;
using MensSection.Api.Models;

namespace MensSection.Api.EndpointDefinitions;

public class MatchEndpoint : EndpointBase
{
    private IMapper mapper;
    public MatchEndpoint()
    {
        mapper = new MapperConfiguration(cfg =>
        {
            cfg.CreateMap<Match, MatchDto>()
                //.ForMember(dest => dest.Year,
                //            opts => opts.MapFrom(src => new DateTime(src.Year, 1, 1)))
                //.ForMember(dest => dest.ConsumptionkWh,
                //            opts => opts.MapFrom(src => src.Qnt))
                .ReverseMap();
        }).CreateMapper();
    }

    public override void DefineEndpoints(WebApplication app)
    {
        base.DefineEndpoints(app);

        app.MapGet("api/match/{id:int}", GetMatch);
        app.MapGet("api/match", GetMatches);
        app.MapGet("api/match/season/{season:int}", GetSeasonMatches);
        app.MapPost("api/match", UpsertMatch);
    }

    internal async Task<IResult> GetMatch(IRepository repo, int id)
    {
        try
        {
            var match = await repo.GetMatch(id);
            if (match != null)
            {
                return Results.Ok(mapper.Map<MatchDto>(match));
            }
            return Results.NotFound();
        }
        catch (Exception e)
        {
            return Results.BadRequest(e);
        }
    }

    internal async Task<IResult> GetMatches(IRepository repo)
    {
        _logger?.LogInformation("Getmatches");
        try
        {
            var models = await repo.GetMatchList();
            if (models != null)
            {
                return Results.Ok(mapper.Map<IEnumerable<MatchDto>>(models));
            }
            return Results.NotFound();
        }
        catch (Exception e)
        {
            return Results.BadRequest(e);
        }
    }

    internal async Task<IResult> GetSeasonMatches(int season, IRepository repo)
    {
        try
        {
            var models = await repo.GetSeasonMatchList(season);
            if (models != null)
            {
                return Results.Ok(mapper.Map<IEnumerable<MatchDto>>(models));
            }
            return Results.NotFound();
        }
        catch (Exception e)
        {
            return Results.BadRequest(e);
        }
    }
    internal async Task<IResult> UpsertMatch(IRepository repo, Models.Match dto)
    {
        try
        {
            var model = mapper.Map<Models.Match>(dto);
            model = await repo.MatchUpsert(model);
            if (model != null)
            {
                return Results.Ok(mapper.Map<MatchDto>(model));
            }
            return Results.Created($"api/match/{model?.MatchId}", model);
        }
        catch (Exception e)
        {
            return Results.BadRequest(e);
        }
    }
}

