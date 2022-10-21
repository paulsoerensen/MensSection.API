using AutoMapper;
using MensSection.API.Domain;
using MensSection.API.Dtos;
using MensSection.API.Models;

namespace MensSection.API.EndpointDefinitions;

public class ClubEndpoint : IEndpointDefinition
{
    private IMapper mapper;
    private readonly ILogger<ClubEndpoint> _logger;

    public ClubEndpoint()
    {
        ;
    }
    public ClubEndpoint(ILogger<ClubEndpoint> logger)
    {
        _logger = logger;
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
        app.MapGet("api/club", GetClubs);
        app.MapGet("api/club/{clubId}", GetClub);
        app.MapPost("api/club", UpsertClub);
        app.MapPut("api/club", UpsertClub);

        app.MapGet("api/club/{clubId}/course", GetCourses);
        app.MapPost("api/club/{clubId}/course", UpsertCourse);
        app.MapPut("api/club/{clubId}/course", UpsertCourse);

        app.MapGet("api/tee", GetTees);
        app.MapGet("api/tee/{teeId}", GetTee);
        app.MapPost("api/tee", UpsertTee);
        app.MapPut("api/tee", UpsertTee);
    }

    public void DefineServices(IServiceCollection services)
    {
        services.AddScoped<IRepository, Repository>();
    }

    #region Club
    internal async Task<IResult> GetClub(IRepository repo, int clubId)
    {
        try
        {
            var model = await repo.GetClub(clubId);
            if (model != null)
            {
                return Results.Ok(mapper.Map<ClubDto>(model));
            }
            return Results.NotFound();
        }
        catch (Exception e)
        {
            _logger.LogError(e.ToString());
            return Results.BadRequest(e);
        }
    }
    internal async Task<IResult> GetClubs(IRepository repo)
    {
        try
        {
            var models = await repo.GetClubs();
            if (models != null)
            {
                var dtos = mapper.Map<IEnumerable<ClubDto>>(models);
                return Results.Ok(mapper.Map<IEnumerable<ClubDto>>(models));
            }
            return Results.NotFound();
        }
        catch (Exception e)
        {
            _logger.LogError(e.ToString());
            return Results.BadRequest(e);
        }
    }
    internal IResult UpsertClub(IRepository repo, Club dto)
    {
        try
        {
            var model = mapper.Map<Models.Club>(dto);
            model = repo.ClubUpsert(model).Result;
            if (model != null)
            {
                return Results.Ok(mapper.Map<ClubDto>(model));
            }
            return Results.Created($"api/club/{model?.ClubId}", model);
        }
        catch (Exception e)
        {
            _logger.LogError(e.ToString());
            return Results.BadRequest(e);
        }
    }
    #endregion

    #region Course
    internal async Task<IResult> GetCourse(IRepository repo, int clubId)
    {
        try
        {
            var model = await repo.GetClub(clubId);
            if (model != null)
            {
                return Results.Ok(mapper.Map<ClubDto>(model));
            }
            return Results.NotFound();
        }
        catch (Exception e)
        {
            _logger.LogError(e.ToString());
            return Results.BadRequest(e);
        }
    }
    internal async Task<IResult> GetCourses(IRepository repo, int clubId, int? courseId)
    {
        try
        {
            var models = await repo.GetCourses(clubId, courseId);
            if (models != null)
            {
                var dtos = mapper.Map<IEnumerable<CourseDto>>(models);
                return Results.Ok(mapper.Map<IEnumerable<CourseDto>>(models));
            }
            return Results.NotFound();
        }
        catch (Exception e)
        {
            _logger.LogError(e.ToString());
            return Results.BadRequest(e);
        }
    }
    internal IResult UpsertCourse(IRepository repo, Club dto)
    {
        try
        {
            var model = mapper.Map<MensSection.API.Models.Club>(dto);
            model = repo.ClubUpsert(model).Result;
            if (model != null)
            {
                return Results.Ok(mapper.Map<ClubDto>(model));
            }
            return Results.Created($"api/{model?.ClubId}/course/{model?.ClubId}", model);
        }
        catch (Exception e)
        {
            _logger.LogError(e.ToString());
            return Results.BadRequest(e);
        }
    }

    #endregion

    #region Tee
    internal async Task<IResult> GetTee(IRepository repo, int teeId)
    {
        try
        {
            var model = await repo.GetTee(teeId);
            if (model != null)
            {
                return Results.Ok(mapper.Map<ClubDto>(model));
            }
            return Results.NotFound();
        }
        catch (Exception e)
        {
            _logger.LogError(e.ToString());
            return Results.BadRequest(e);
        }
    }
    internal async Task<IResult> GetTees(IRepository repo)
    {
        try
        {
            var models = await repo.GetTees();
            if (models != null)
            {
                return Results.Ok(models);
            }
            return Results.NotFound();
        }
        catch (Exception e)
        {
            _logger.LogError(e.ToString());
            return Results.BadRequest(e);
        }
    }

    internal async Task<IResult> GetCourseTees(IRepository repo, int clubId)
    {
        try
        {
            var models = await repo.GetClubs();
            if (models != null)
            {
                var dtos = mapper.Map<IEnumerable<ClubDto>>(models);
                return Results.Ok(mapper.Map<IEnumerable<ClubDto>>(models));
            }
            return Results.NotFound();
        }
        catch (Exception e)
        {
            _logger.LogError(e.ToString());
            return Results.BadRequest(e);
        }
    }
    internal IResult UpsertTee(IRepository repo, ListEntry dto)
    {
        try
        {
            var model = mapper.Map<Models.Club>(dto);
            model = repo.ClubUpsert(model).Result;
            if (model != null)
            {
                return Results.Ok(mapper.Map<ClubDto>(model));
            }
            return Results.Created($"api/{model?.ClubId}/course/{model?.ClubId}", model);
        }
        catch (Exception e)
        {
            _logger.LogError(e.ToString());
            return Results.BadRequest(e);
        }
    }
    #endregion
}

