using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Runtime.Serialization;

namespace MensSection.Api.Models
{
    public class Player
    {
        public Player()
        {
            HcpUpdated = new DateTime(2000, 1, 1);
        }
        public int PlayerId { get; set; }
        public int VgcNo { get; set; }
        public int MemberShipId { get; set; }
        public bool IsMale { get; set; }
        public string Firstname { get; set; }
        public string Lastname { get; set; }
        public string ZipCode { get; set; }
        public string City { get; set; }
        public string Address { get; set; }
        public string Email { get; set; }
        public bool Sponsor { get; set; }
        public decimal HcpIndex { get; set; }
        public DateTime HcpUpdated { get; set; }
        public string Phone { get; set; }
        public int NameGroup { get; set; }
        public bool Fee { get; set; }
        public bool Insurance { get; set; }
        public int Season { get; set; }
        public bool Eclectic { get; set; }
        public DateTime LastUpdate { get; set; }
    }
}
