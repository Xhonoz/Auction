using Microsoft.AspNet.SignalR;
using SignalRSales;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Net;
using System.Threading;
using System.Threading.Tasks;
using System.Web;
using System.Web.Mvc;
using System.Timers;

namespace AuctionWeb
{
    [RequireHttps]
    public class ProductsController : Controller
    {
        private AuctionDataModelContainer db = new AuctionDataModelContainer();

        // GET: Products
        public ActionResult Index()
        {
            return View(db.ProductSet.Where(X => X.active && X.endtime > DateTime.Now).ToList());
        }

        public ActionResult Search(string searchString)
        {
            TempData["search"] = searchString;
            return View("Index",db.ProductSet.Where(X => X.active && X.endtime > DateTime.Now && X.name.Contains(searchString)).ToList());
        }

        // GET: Products/Details/5
        public ActionResult Details(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Product product = db.ProductSet.Find(id);
            if (product == null)
            {
                return HttpNotFound();
            }
            if (!product.active && (!User.Identity.IsAuthenticated || User.Identity.Name != product.profile.email))
                return RedirectToAction("Index");

            return View(product);
        }

        [HttpPost]
        [System.Web.Mvc.Authorize]
        [ValidateAntiForgeryToken]
        public ActionResult Bid([Bind(Include = "Id,amount")] int amount, int Id)
        {
            Product product = db.ProductSet.Find(Id);
            if (product == null)
                return View();

            Profile profile = db.ProfileSet.Where(X => X.email == User.Identity.Name).First();
            Bid bid = new Bid { amount = amount, profile = profile };
            BidStatus statusCode = product.MakeBid(bid, db);
            TempData[statusCode == BidStatus.OK ? "message" : "error"] = statusCode;

            if (statusCode == BidStatus.OK)
            {
                System.Timers.Timer timeEvent = (System.Timers.Timer)System.Web.HttpContext.Current.Application[product.Id.ToString()];
                timeEvent.Stop();
                timeEvent.Interval = (product.endtime - DateTime.Now).TotalMilliseconds;
                timeEvent.Start();
            }

            return RedirectToAction("Details", new { id = Id });
        }

        // GET: Products/Create
        [System.Web.Mvc.Authorize]
        public ActionResult Create()
        {
            Product product = new Product();
            product.Picture = new Picture();
            return View(product);
        }

        // POST: Products/Create
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [System.Web.Mvc.Authorize]
        [ValidateAntiForgeryToken]
        public ActionResult Create([Bind(Include = "Id,name,description,endtime,active,Picture")] Product product)
        {
            if (ModelState.IsValid)
            {
                product.active = false;
                product.profile = db.ProfileSet.Where(X => X.email == User.Identity.Name).First();
                db.ProductSet.Add(product);
                db.SaveChanges();
                TempData["message"] = "New product saved";
                return RedirectToAction("Index","Manage");
            }

            return View(product);
        }

        // GET: Products/Edit/5
        [System.Web.Mvc.Authorize]
        public ActionResult Edit(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Product product = db.ProductSet.Find(id);
            if (product == null || product.profile.email != User.Identity.Name)
            {
                return HttpNotFound();
            }
            return View(product);
        }

        // POST: Products/Edit/5
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [System.Web.Mvc.Authorize]
        [ValidateAntiForgeryToken]
        public ActionResult Edit([Bind(Include = "Id,name,description,endtime,Picture")] Product product)
        {
            if (ModelState.IsValid)
            {
                db.Entry(product).State = EntityState.Modified;
                db.Entry(product.Picture).State = EntityState.Modified;
                db.SaveChanges();
                TempData["message"] = "Changes saved";
                return RedirectToAction("Index");
            }
            return View(product);
        }

        // GET: Products/Delete/5
        [System.Web.Mvc.Authorize]
        public ActionResult Delete(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Product product = db.ProductSet.Find(id);
            if (product == null || product.active)
            {
                return HttpNotFound();
            }
            return View(product);
        }

        // POST: Products/Delete/5
        [System.Web.Mvc.Authorize]
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(int id)
        {
            Product product = db.ProductSet.Find(id);
            if (!product.active && product.profile.email == User.Identity.Name)
            {
                db.PictureSet.Remove(product.Picture);
                db.ProductSet.Remove(product);
                db.SaveChanges();
                TempData["message"] = "Product deleted";
            }
            return RedirectToAction("Index");
        }

        [System.Web.Mvc.Authorize]
        public ActionResult Publish(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Product product = db.ProductSet.Find(id);
            if (product == null || product.active || product.profile.email != User.Identity.Name)
            {
                return HttpNotFound();
            }
            if (product.Publish(db))
            {
                System.Timers.Timer timeEvent = new System.Timers.Timer((product.endtime - DateTime.Now).TotalMilliseconds);
                timeEvent.Elapsed += (sender, e) => MyElapsedMethod(sender, e, product.Id);
                timeEvent.Enabled = true;
                System.Web.HttpContext.Current.Application[product.Id.ToString()] = timeEvent;
                TempData["message"] = "Product published";
            }
            else
                TempData["error"] = "Invalid end time";
            return RedirectToAction("Index", "Manage");
        }

        static void MyElapsedMethod(object sender, ElapsedEventArgs e, int productId)
        {
            AuctionDataModelContainer db = new AuctionDataModelContainer();
            Product product = db.ProductSet.Find(productId);
            var context = GlobalHost.ConnectionManager.GetHubContext<SalesHub>();
            context.Clients.All.addNewMessageToPage(product.name, product.buyer == null ? "No buyer" : product.buyer.email);
            ((System.Timers.Timer)sender).Stop();
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }
    }
}
