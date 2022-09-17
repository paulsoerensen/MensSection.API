namespace MensSection.Api.Domain;
public interface IEndpointDefinition
{
    void DefineServices(IServiceCollection
        services);

    //void DefineEndpoints(IHost app)
    //void DefineEndpoints(IEndpointRouteBuilder app)
    void DefineEndpoints(WebApplication app);
}