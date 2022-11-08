using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Runtime.Serialization;


namespace MensSection.Api.Models
{
	public class Membership
	{
		public int VgcNo { get; set; }
		public string? Firstname { get; set; }
		public string? Lastname { get; set; }
		public string? City { get; set; }
		public string? ZipCode { get; set; }
		public string? Address { get; set; }
		public string? Email { get; set; }
		public string? Phone { get; set; }
		public string? CellPhone { get; set; }
		public bool Fee { get; set; }
		public bool Guest { get; set; }
		public int MembershipId { get; set; }
        public int Season { get; set; }
        public int NameGroup { get; set; }
        public decimal HcpIndex { get; set; }
        public DateTime HcpUpdated { get; set; }
    }
}
