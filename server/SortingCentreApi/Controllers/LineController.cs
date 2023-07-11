using Microsoft.AspNetCore.Mvc;
using SortingCentre;

namespace SortingCentreApi.Controllers;

[ApiController]
[Route("line")]
public class LineController : Controller
{
    [HttpGet]
    public int LineByCityId([FromQuery] int delivery, [FromQuery] int sortingCentre)
    {
        SQL.addDataTime(delivery, DateTime.Today, DateTime.Now);
        SQL.statusUpdate(delivery);
        SQL.updateSortingCentre(delivery, sortingCentre);
        return SQL.getLineByID(delivery);
    }
}