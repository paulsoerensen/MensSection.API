using AutoMapper;
using MensSection.API.Domain;
using MensSection.API.Dtos;
using MensSection.API.Models;
using Microsoft.AspNetCore.Mvc;
using System.Security.Cryptography;

namespace MensSection.API.EndpointDefinitions;

public class UserEndpoint : IEndpointDefinition
{
    private IMapper mapper;

    public UserEndpoint()
    {
        mapper = new MapperConfiguration(cfg =>
        {
            //cfg.CreateMap<Club, ClubDto>()
            //    .ReverseMap();
        }).CreateMapper();
    }
    public void DefineEndpoints(WebApplication app)
    {
        app.MapGet("api/user/{email}", GetUserByEmail);
        app.MapPost("api/user/register", Register);
        app.MapPost("api/user/verify", Verify);
        app.MapPost("api/user/login", Login);
        app.MapPost("api/user/forgotpassword", ForgotPassword);
        app.MapPost("api/user/resetpassword", ResetPassword);
    }

    public void DefineServices(IServiceCollection services)
    {
        services.AddScoped<IRepository, Repository>();
    }

    #region Club
    internal async Task<IResult> GetUserByEmail(IRepository repo, string email)
    {
        var model = await repo.GetUserByEmail(email);
        if (model != null)
        {
            return Results.Ok(mapper.Map<User>(model));
        }
        return Results.NotFound();
    }
    internal async Task<IResult> UserUpsert(IRepository repo, User model)
    {
        //var model = mapper.Map<Models.Player>(dto);
        var res = repo.UserUpsert(model).Result;
        if (res != null)
        {
            return Results.Ok(res);
        }
        return Results.Created($"api/user/{model?.Email}", model);
    }
    internal async Task<IResult> Register(IRepository repo, UserRegisterRequest request) 
    {
        var model = repo.GetUserByEmail(request.Email).Result;
        if (model != null) {
            return Results.BadRequest("User already exists.");
        }
        CreatePasswordHash(request.Password,
            out byte[] passwordHash,
            out byte[] passwordSalt);

        var user = new User
        {
            Email = request.Email,
            PasswordHash = passwordHash,
            PasswordSalt = passwordSalt,
            VerificationToken = CreateRandomToken()
        };
        await repo.UserUpsert(user);
        return Results.Ok("User created");
    }

    internal async Task<IResult> Login(IRepository repo, UserLoginRequest request)
    {

        var user = await repo.GetUserByEmail(request.Email);
        if (user == null)
        {
            return Results.BadRequest("User not found");
        }
        if (!VerifyPasswordHash(request.Password, user.PasswordHash, user.PasswordSalt))
        {
            return Results.BadRequest("Invalid password");
        }        
        if (user.VerificationToken == null)
        {
            return Results.BadRequest("User not verified");
        }

        return Results.Ok("User logged in");
    }

    internal async Task<IResult> Verify(IRepository repo, string token)
    {
        var user = await repo.GetUserByToken(token);
        if (user == null)
        {
            return Results.BadRequest("Invalid token");
        }
        user.VerifiedAt = DateTime.Now;
        await repo.UserUpsert(user);

        return Results.Ok("User verified");
    }

    internal async Task<IResult> ForgotPassword(IRepository repo, string email)
    {
        var user = await repo.GetUserByEmail(email);
        if (user == null)
        {
            return Results.BadRequest("User not found");
        }

        user.PasswordResetToken = CreateRandomToken();
        user.ResetTokenExpires  = DateTime.Now.AddDays(1);
        await repo.UserUpsert(user);

        return Results.Ok("You may now reset password");
    }

    internal async Task<IResult> ResetPassword(IRepository repo, ResetPasswordRequest request)
    {
        var user = await repo.GetUserByResetToken(request.Token);
        if (user == null)
        {
            return Results.BadRequest("Invalid token");
        }

        CreatePasswordHash(request.Password, out byte[] passwordHash, out byte[] passwordSalt);

        user.PasswordHash = passwordHash;
        user.PasswordSalt = passwordSalt;
        user.PasswordResetToken = null;
        user.ResetTokenExpires = null;

        await repo.UserUpsert(user);

        return Results.Ok("Password reset succesfully");
    }

    private void CreatePasswordHash(string password, out byte[] passwordHash, out byte[] passwordSalt)
    {
        using (var hmac = new HMACSHA512())
        {
            passwordSalt = hmac.Key;
            passwordHash = hmac
                .ComputeHash(System.Text.Encoding.UTF8.GetBytes(password));
        }
    }

    private bool VerifyPasswordHash(string password, byte[] passwordHash, byte[] passwordSalt)
    {
        using (var hmac = new HMACSHA512(passwordSalt))
        {
            var computedHash = hmac.ComputeHash(System.Text.Encoding.UTF8.GetBytes(password));
            return computedHash.SequenceEqual(passwordHash);
        }
    }

    private string CreateRandomToken()
    {
        return Convert.ToHexString(RandomNumberGenerator.GetBytes(64));
    }
    #endregion

}

