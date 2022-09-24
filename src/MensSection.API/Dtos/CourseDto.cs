namespace MensSection.Api.Dtos
{
    public class CourseDto
    {
        public int ClubId { get; set; }
        public string ClubName { get; set; }
        public int CourseId { get; set; }
        public string CourseName { get; set; }
        public int Slope { get; set; }
        public decimal CourseRating { get; set; }
        public int Par { get; set; }
        public string Tee { get; set; }
        public int CourseTeeId { get; set; }
        public int CourseDetailId { get; set; }
        public bool IsMale { get; set; }
    }
}
