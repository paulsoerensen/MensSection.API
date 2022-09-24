

CREATE PROCEDURE [ms].[CompetitionResultUpsert]
	@MembershipId int, 
	@MatchId int, 
	@CompetitionId int, 
	@CompetitionResultId int output  
AS BEGIN
	IF @CompetitionResultId is null BEGIN
		select @CompetitionResultId = 0
	END;
	MERGE ms.CompetitionResult as T
	USING (
	select @MemberShipId as MemberShipId, 
			@MatchId as MatchId, 
			@CompetitionId as CompetitionId,
			@CompetitionResultId as CompetitionResultId
		) as S
	ON S.CompetitionResultId = T.CompetitionResultId
	WHEN NOT MATCHED then 
		INSERT (MemberShipId, MatchId, CompetitionId)
		VALUES (S.MemberShipId, S.MatchId, S.CompetitionId)
	WHEN MATCHED then 
		UPDATE set MemberShipId=S.MemberShipId, 
			T.CompetitionId = S.CompetitionId,
			T.MatchId = S.MatchId;
	
	IF @CompetitionResultId < 1 BEGIN
		SELECT @CompetitionResultId = CAST(SCOPE_IDENTITY() as [int]);
	END;
END