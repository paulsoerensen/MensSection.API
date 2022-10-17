
using MensSection.API.Domain;

namespace  MensSection.Api.EndpointDefinitions;

public class SwaggerEndpoint : IEndpointDefinition
{
    public void DefineEndpoints(WebApplication app)
    {
        app.UseSwagger();
        app.UseSwaggerUI(c => c.SwaggerEndpoint("/swagger/v1/swagger.json", "MensSection.Api"));

    }
    private static bool alreadyAdded;
    public void DefineServices(IServiceCollection services)
    {
        if (alreadyAdded) return;
        services.AddEndpointsApiExplorer();
        services.AddSwaggerGen(c =>
        {
            c.SwaggerDoc("v1", new Microsoft.OpenApi.Models.OpenApiInfo
            { 
                Title = "Mens Section Api",
                Version = "v1"
            });
        });
        alreadyAdded = true;
    }
}
