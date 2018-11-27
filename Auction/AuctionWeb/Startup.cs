using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(AuctionWeb.Startup))]
namespace AuctionWeb
{
    public partial class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            app.MapSignalR();
            ConfigureAuth(app);
        }
    }
}
