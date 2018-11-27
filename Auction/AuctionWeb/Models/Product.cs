using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace AuctionWeb
{
    public enum BidStatus {OK,LOW,NOT_ACTIVE,PRODUCT_CLOSED,SHILL_BID}

    [MetadataType(typeof(ProductMetaData))]
    public partial class Product
    {
        public const int MinTime = 1;

        public BidStatus MakeBid(Bid bid, AuctionDataModelContainer db)
        {
            if (!active)
                return BidStatus.NOT_ACTIVE;
            if (endtime < DateTime.Now)
                return BidStatus.PRODUCT_CLOSED;
            if (bid.profile.email == profile.email)
                return BidStatus.SHILL_BID;
            if (bid.amount < 1 || (HighestBid() != null && HighestBid().amount >= bid.amount))
                return BidStatus.LOW;
            if (endtime < DateTime.Now.AddMinutes(MinTime))
                endtime = endtime.AddMinutes(MinTime);
            bids.Add(bid);
            bid.product = this;
            db.BidSet.Add(bid);
            buyer = bid.profile;
            db.SaveChanges();
            return BidStatus.OK;
        }

        public bool Publish(AuctionDataModelContainer db)
        {
            if (endtime > DateTime.Now.AddMinutes(MinTime))
            {
                active = true;
                db.SaveChanges();
            }            
            return active;
        }

        public Bid HighestBid()
        {
            return bids.Count == 0 ? null : bids.OrderBy(X => X.amount).Last();
        }
    }

    public class ProductMetaData
    {
        [DataType(DataType.MultilineText)]
        public string description { get; set; }

        [Required]
        [UIHint("Picture")]
        public virtual Picture Picture { get; set; }
    }
}