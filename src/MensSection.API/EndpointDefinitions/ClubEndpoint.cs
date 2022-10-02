using AutoMapper;
using MensSection.Api.Domain;
using MensSection.Api.Dtos;
using MensSection.Api.Models;

namespace MensSection.Api.EndpointDefinitions;

public class ClubEndpoint : IEndpointDefinition
{
    private IMapper mapper;

    public ClubEndpoint()
    {
        mapper = new MapperConfiguration(cfg =>
        {
            cfg.CreateMap<Club, ClubDto>()
                .ReverseMap();

            cfg.CreateMap<Course, CourseDto>()
                .ReverseMap();

            cfg.CreateMap<CourseInfo, CourseDto>()
                .ReverseMap();

        }).CreateMapper();
    }
    public void DefineEndpoints(WebApplication app)
    {
        app.MapGet("api/v1/club", GetClubs);
        app.MapGet("api/v1/club/{clubId}", GetClub);
        app.MapPost("api/v1/club", UpsertClub);
        app.MapPut("api/v1/club", UpsertClub);

        app.MapGet("api/v1/club/{clubId}/course", GetCourses);
        app.MapPost("api/v1/club/{clubId}/course", UpsertCourse);
        app.MapPut("api/v1/club/{clubId}/course", UpsertCourse);

        app.MapGet("api/v1/tee", GetTees);
        app.MapGet("api/v1/tee/{teeId}", GetTee);
        app.MapPost("api/v1/tee", UpsertTee);
        app.MapPut("api/v1/tee", UpsertTee);
    }

    public void DefineServices(IServiceCollection services)
    {
        services.AddScoped<IRepository, Repository>();
    }

    #region Club
    internal async Task<IResult> GetClub(IRepository repo, int clubId)
    {
        var model = await repo.GetClub(clubId);
        if (model != null)
        {
            return Results.Ok(mapper.Map<ClubDto>(model));
        }
        return Results.NotFound();
    }
    internal async Task<IResult> GetClubs(IRepository repo)
    {
        var models = await repo.GetClubs();
        if (models != null)
        {
            var dtos = mapper.Map<IEnumerable<ClubDto>>(models);
            return Results.Ok(mapper.Map<IEnumerable<ClubDto>>(models));
        }
        return Results.NotFound();
    }
    internal IResult UpsertClub(IRepository repo, Club dto) 
    {
        var model = mapper.Map<Models.Club>(dto);
        model = repo.ClubUpsert(model).Result;
        if (model != null) {
            return Results.Ok(mapper.Map<ClubDto>(model));
        }
        return Results.Created($"api/v1/club/{model?.ClubId}", model);
    }
    #endregion

    #region Course
    internal async Task<IResult> GetCourse(IRepository repo, int clubId)
    {
        var model = await repo.GetClub(clubId);
        if (model != null)
        {
            return Results.Ok(mapper.Map<ClubDto>(model));
        }
        return Results.NotFound();
    }
    internal async Task<IResult> GetCourses(IRepository repo, int clubId, int? courseId)
    {
        var models = await repo.GetCourses(clubId, courseId);
        if (models != null)
        {
            var dtos = mapper.Map<IEnumerable<CourseDto>>(models);
            return Results.Ok(mapper.Map<IEnumerable<CourseDto>>(models));
        }
        return Results.NotFound();
    }
    internal IResult UpsertCourse(IRepository repo, Club dto)
    {
        var model = mapper.Map<MensSection.Api.Models.Club>(dto);
        model = repo.ClubUpsert(model).Result;
        if (model != null)
        {
            return Results.Ok(mapper.Map<ClubDto>(model));
        }
        return Results.Created($"api/v1/{model?.ClubId}/course/{model?.ClubId}", model);
    }

    #endregion

    #region Tee
    internal async Task<IResult> GetTee(IRepository repo, int teeId)
    {
        var model = await repo.GetTee(teeId);
        if (model != null)
        {
            return Results.Ok(mapper.Map<ClubDto>(model));
        }
        return Results.NotFound();
    }
    internal async Task<IResult> GetTees(IRepository repo)
    {
        var models = await repo.GetTees();
        if (models != null)
        {
            return Results.Ok(models);
        }
        return Results.NotFound();
    }

    internal async Task<IResult> GetCourseTees(IRepository repo, int clubId)
    {
        var models = await repo.GetClubs();
        if (models != null)
        {
            var dtos = mapper.Map<IEnumerable<ClubDto>>(models);
            return Results.Ok(mapper.Map<IEnumerable<ClubDto>>(models));
        }
        return Results.NotFound();
    }
    internal IResult UpsertTee(IRepository repo, ListEntry dto)
    {
        var model = mapper.Map<Models.Club>(dto);
        model = repo.ClubUpsert(model).Result;
        if (model != null)
        {
            return Results.Ok(mapper.Map<ClubDto>(model));
        }
        return Results.Created($"api/v1/{model?.ClubId}/course/{model?.ClubId}", model);
    }
    #endregion
}
