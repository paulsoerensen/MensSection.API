using AutoMapper;
using MensSection.API.Domain;
using MensSection.API.Dtos;
using MensSection.API.Models;
using System.Configuration;

namespace MensSection.API.EndpointDefinitions;

public class AdminEndpoint : IEndpointDefinition
{
    public void DefineEndpoints(WebApplication app)
    {
        try
        {
            app.MapGet("api/admin/info", GetInfo);
            app.MapGet("api/admin/test", GetTest);
        }
        catch (Exception e)
        {
            ;// _logger.LogError(e.ToString());
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
    internal IResult GetTest(IRepository repo)
    {
        return Results.Ok("Some string");
    }
    static void ReadAllSettings()
    {
        try
        {
            var appSettings = System.Configuration.ConfigurationManager.AppSettings;

            if (appSettings.Count == 0)
            {
                Console.WriteLine("AppSettings is empty.");
            }
            else
            {
                foreach (var key in appSettings.AllKeys)
                {
                    Console.WriteLine("Key: {0} Value: {1}", key, appSettings[key]);
                }
            }
        }
        catch (ConfigurationErrorsException)
        {
            Console.WriteLine("Error reading app settings");
        }
    }
    #endregion
}

