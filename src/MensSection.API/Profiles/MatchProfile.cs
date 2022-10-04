using AutoMapper;
using MensSection.API.Dtos;
using MensSection.API.Models;

namespace MensSection.API.Profiles
{
    public class MatchProfile: Profile
    {
        public MatchProfile()
        {
            CreateMap<MatchDto, Match>().ReverseMap();
        } 
    }
}