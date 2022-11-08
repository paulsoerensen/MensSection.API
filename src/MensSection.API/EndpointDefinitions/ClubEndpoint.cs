using AutoMapper;
using MensSection.Api.Domain;
using MensSection.Api.Dtos;
using MensSection.Api.Models;

namespace MensSection.Api.EndpointDefinitions;

public class ClubEndpoint : EndpointBase
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
    public override void DefineEndpoints(WebApplication app)
    {
        base.DefineEndpoints(app);

        app.MapGet("api/club", GetClubs);
        app.MapGet("api/club/{clubId:int}", GetClub);
        app.MapPost("api/club", UpsertClub);
        app.MapPut("api/club", UpsertClub);

        app.MapGet("api/club/{clubId:int}/course", GetCourses);
        app.MapPost("api/club/{clubId:int}/course", UpsertCourse);
        app.MapPut("api/club/{clubId:int}/course", UpsertCourse);

        app.MapGet("api/tee", GetTees);
        app.MapGet("api/tee/{teeId:int}", GetTee);
        app.MapPost("api/tee", UpsertTee);
        app.MapPut("api/tee", UpsertTee);
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
            return Results.BadRequest(e.ToString());
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
            return Results.BadRequest(e.ToString());
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
            return Results.BadRequest(e.ToString());
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
            return Results.BadRequest(e.ToString());
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
            return Results.BadRequest(e.ToString());
        }
    }
    internal IResult UpsertCourse(IRepository repo, Club dto)
    {
        try
        {
            var model = mapper.Map<MensSection.Api.Models.Club>(dto);
            model = repo.ClubUpsert(model).Result;
            if (model != null)
            {
                return Results.Ok(mapper.Map<ClubDto>(model));
            }
            return Results.Created($"api/{model?.ClubId}/course/{model?.ClubId}", model);
        }
        catch (Exception e)
        {
            return Results.BadRequest(e.ToString());
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
            return Results.BadRequest(e.ToString());
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
            return Results.BadRequest(e.ToString());
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
            return Results.BadRequest(e.ToString());
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
            return Results.BadRequest(e.ToString());
        }
    }
    #endregion
}

