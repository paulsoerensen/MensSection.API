using AutoMapper;
using MensSection.Api.Dtos;
using MensSection.Api.Models;

namespace MensSection.Api.Profiles
{
    public class MatchProfile: Profile
    {
        public MatchProfile()
        {
            CreateMap<MatchDto, Match>().ReverseMap();
        } 
    }
}