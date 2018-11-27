using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace AuctionWeb
{
    [MetadataType(typeof(PictureMetaData))]
    public partial class Picture
    {
    }

    public class PictureMetaData
    {
        [Required]
        public string path { get; set; }
        [Required]
        public string title { get; set; }
    }
}