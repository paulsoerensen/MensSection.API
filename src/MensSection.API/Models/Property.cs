using System;

namespace MensSection.Api.Models
{
    public class Property
    {
        public int Id { get; set; }
        public string? Value { get; set; }
        public string? SystemType { get; set; }
        public DateTime ValidFrom { get; set; }
        public DateTime ValidTo { get; set; }
        public string? Description { get; set; }
    }
}
