using System;
using System.Web;
using Microsoft.AspNet.SignalR;
using Microsoft.AspNet.SignalR.Hubs;

namespace SignalRSales
{
    [HubName("SalesHub")]
    public class SalesHub : Hub
    {
    }
}