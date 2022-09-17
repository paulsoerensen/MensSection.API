namespace MensSection.Api.Models
{
    public class MatchRead
    {
        public int Id { get; set; }

        public DateTime MatchDate { get; set; }

        public int MatchformId { get; set; }

        public string? Matchform { get; set; }

        public string? MatchText { get; set; }

        public bool IsHallington { get; set; }

        public bool IsStrokePlay { get; set; }

        public string? Sponsor { get; set; }

        public int SponsorLogoId { get; set; }

        public int CourseDetailId { get; set; }

        public string? CourseName { get; set; }

        public int Par { get; set; }

        public string? Tee { get; set; }

        public decimal CourseRating { get; set; }

        public int Slope { get; set; }

        public string? Remarks { get; set; }

        public bool Official { get; set; }

        public bool Shootout { get; set; }

        public string? ClubName { get; set; }
    }
}