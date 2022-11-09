using AutoMapper;
using MensSection.Api.Domain;
using MensSection.Api.Dtos;
using MensSection.Api.Models;
using System.Configuration;

namespace MensSection.Api.EndpointDefinitions;

public class AdminEndpoint : EndpointBase
{
    public override void DefineEndpoints(WebApplication app)
    {
        base.DefineEndpoints(app);
        try
        {
            app.MapGet("api/admin/info", GetInfo);
            app.MapGet("api/admin/test", GetTest);
        }
        catch (Exception e)
        {
            _logger?.LogError(e.ToString());
        }
    }

    #region Info
    internal IResult GetInfo(IRepository repo)
    {
        var s = //string.Join(Environment.NewLine, repo.Info());
        string.Join
        (
            Environment.NewLine,
            repo.Info().Select(pair => $"{pair.Key}={pair.Value}").ToArray()
        );
        try
        {
            s = (_config as IConfigurationRoot)?.GetDebugView();
            //return ctx.Response.WriteAsync(config);
            //_logger.LogInformation(_config.GetConnectionString("SqlDbConnectionString"));
            _logger?.LogInformation(s);
            //s = System.Configuration.ConfigurationManager.ConnectionStrings["SqlDbConnectionString"]?.ConnectionString;
            //_logger.LogInformation($"From ConfigurationManager:{s}");
            s = _config?["ConnectionStrings:SqlDbConnectionString"];
            _logger?.LogInformation($"From Config:{s}");

            return Results.Ok(s);
        }
        catch (Exception e)
        {
            _logger?.LogError(e.ToString());
            return Results.BadRequest(e.ToString());
        }
    }
    internal IResult GetTest(IRepository repo)
    {
        return Results.Ok("Some string");
    }
    //static void ReadAllSettings()
    //{
    //    try
    //    {
    //        var appSettings = System.Configuration.ConfigurationManager.AppSettings;

    //        if (appSettings.Count == 0)
    //        {
    //            Console.WriteLine("AppSettings is empty.");
    //        }
    //        else
    //        {
    //            foreach (var key in appSettings.AllKeys)
    //            {
    //                Console.WriteLine("Key: {0} Value: {1}", key, appSettings[key]);
    //            }
    //        }
    //    }
    //    catch (ConfigurationErrorsException)
    //    {
    //        Console.WriteLine("Error reading app settings");
    //    }
    //}
    #endregion
}

