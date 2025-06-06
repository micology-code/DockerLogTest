using Serilog;

namespace DockerLogTest
{
    public class Program
    {
        public static void Main(string[] args)
        {
            var builder = WebApplication.CreateBuilder(args);

            Log.Logger = new LoggerConfiguration()
             .ReadFrom.Configuration(builder.Configuration)
             .CreateLogger();


            // Add services to the container.
            builder.Services.AddAuthorization();
            builder.Host.UseSerilog();

            var app = builder.Build();

            // Configure the HTTP request pipeline.

            app.UseAuthorization();

            var summaries = new[]
            {
                "Freezing", "Bracing", "Chilly", "Cool", "Mild", "Warm", "Balmy", "Hot", "Sweltering", "Scorching"
            };

            app.MapGet("/weatherforecast", (HttpContext httpContext) =>
            {
                var forecast = Enumerable.Range(1, 5).Select(index =>
                    new WeatherForecast
                    {
                        Date = DateOnly.FromDateTime(DateTime.Now.AddDays(index)),
                        TemperatureC = Random.Shared.Next(-20, 55),
                        Summary = summaries[Random.Shared.Next(summaries.Length)]
                    })
                    .ToArray();
                return forecast;
            });

            Log.Logger.Information("MySettings:Setting1=>{value}", builder.Configuration["MySettings:Setting1"]);

            app.Run();
            Log.CloseAndFlush();
        }
    }
}
