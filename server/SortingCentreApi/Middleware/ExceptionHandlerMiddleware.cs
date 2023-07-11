using System.Data.SqlClient;

namespace SortingCentreApi.Middleware;

public class ExceptionHandlerMiddleware : IMiddleware
{
    public async Task InvokeAsync(HttpContext context, RequestDelegate next)
    {
        try
        {
            await next.Invoke(context);
        }
        catch (SqlException exception)
        {
            context.Response.StatusCode = StatusCodes.Status409Conflict;
        }
        catch (Exception exception)
        {
            context.Response.StatusCode = StatusCodes.Status400BadRequest;
        }
    }
}