global function InitArenasPostRoundSummary

global function ClientToUI_Arenas_OpenPostRoundSummary
global function ClientToUI_Arenas_ClosePostRoundSummary
global function ClientToUI_Arenas_PopulatePostRoundSummary

struct
{
	var menu

	var triangleFrame = null
	array<var> leftScorePips
	array<var> rightScorePips
	array<var> tieScorePips

} file

void function InitArenasPostRoundSummary( var newMenuArg )                                               
{
	var menu = newMenuArg
	file.menu = menu

	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, OnPostRoundSummary_NavBack )

	file.triangleFrame = Hud_GetChild( file.menu, "TriangleFrame" )

	file.leftScorePips.append( Hud_GetChild( file.menu, "LeftScorePip_0" ) )
	file.leftScorePips.append( Hud_GetChild( file.menu, "LeftScorePip_1" ) )
	file.leftScorePips.append( Hud_GetChild( file.menu, "LeftScorePip_2" ) )

	file.rightScorePips.append( Hud_GetChild( file.menu, "RightScorePip_0" ) )
	file.rightScorePips.append( Hud_GetChild( file.menu, "RightScorePip_1" ) )
	file.rightScorePips.append( Hud_GetChild( file.menu, "RightScorePip_2" ) )

	file.tieScorePips.append( Hud_GetChild( file.menu, "TieScorePip_0" ) )
	file.tieScorePips.append( Hud_GetChild( file.menu, "TieScorePip_1" ) )
	file.tieScorePips.append( Hud_GetChild( file.menu, "TieScorePip_2" ) )
}

void function ClientToUI_Arenas_OpenPostRoundSummary()
{
	CloseAllMenus()
	AdvanceMenu( file.menu )
}

void function ClientToUI_Arenas_ClosePostRoundSummary()
{
	if ( MenuStack_Contains( file.menu ) )
	{
		CloseAllMenus()
	}
}

void function ClientToUI_Arenas_PopulatePostRoundSummary( int roundNum, int leftTeamScore, int rightTeamScore, bool won, int numTies )
{
	int minWinScore = GameMode_GetWinBy2MinScore( GAMEMODE_ARENAS )
	bool isSuddenDeath = numTies == GameMode_GetWinBy2MaxTies( GAMEMODE_ARENAS )
	bool leftTeamMatchpoint	 = leftTeamScore  >= (minWinScore - 1) && leftTeamScore  - rightTeamScore >= 1
	bool rightTeamMatchpoint = rightTeamScore >= (minWinScore - 1) && rightTeamScore - leftTeamScore  >= 1
	bool isTieBreaker = leftTeamScore == rightTeamScore && roundNum > minWinScore
	float startTime = ClientTime()

	thread _PlayIntroTransition()

	string nextRoundStatusText = ""
	if( isSuddenDeath )
		nextRoundStatusText = Localize( "#ARENAS_SUDDEN_DEATH" )
	else if( leftTeamMatchpoint || rightTeamMatchpoint )
		nextRoundStatusText = Localize( "#ARENAS_MATCH_POINT" )
	else if( isTieBreaker )
		nextRoundStatusText = Localize( "#ARENAS_TIEBREAKER" )

	string roundNumString = nextRoundStatusText == "" ? string( roundNum + 1 ) : ""

	var triangleFrameRui = Hud_GetRui( file.triangleFrame )
	RuiSetBool( triangleFrameRui, "isSuddenDeath", isSuddenDeath )
	RuiSetBool( triangleFrameRui, "leftTeamMatchpoint", leftTeamMatchpoint )
	RuiSetBool( triangleFrameRui, "rightTeamMatchpoint", rightTeamMatchpoint )
	RuiSetBool( triangleFrameRui, "isTieBreaker", isTieBreaker )
	RuiSetString( triangleFrameRui, "roundNum", roundNumString )
	RuiSetString( triangleFrameRui, "titleText", nextRoundStatusText )
	RuiSetBool( triangleFrameRui, "roundWon", won )
	RuiSetGameTime( triangleFrameRui, "startTime", startTime )

	for( int i = 0; i < file.leftScorePips.len(); ++i )
	{
		var pipRui = Hud_GetRui( file.leftScorePips[i] )
		RuiSetBool( pipRui, "scored", (i + 1) <= leftTeamScore )
		RuiSetBool( pipRui, "roundWon", won )
		RuiSetBool( pipRui, "playScoreAnim", won && (i + 1) == minint( leftTeamScore, file.leftScorePips.len() ) )
		RuiSetGameTime( pipRui, "startTime", startTime )
	}

	for( int i = 0; i < file.rightScorePips.len(); ++i )
	{
		var pipRui = Hud_GetRui( file.rightScorePips[i] )
		RuiSetBool( pipRui, "scored", (i + 1) <= rightTeamScore )
		RuiSetBool( pipRui, "roundWon", won )
		RuiSetBool( pipRui, "playScoreAnim", !won && (i + 1) == minint( rightTeamScore, file.rightScorePips.len() ) )
		RuiSetGameTime( pipRui, "startTime", startTime )
	}

	for( int i = 0; i < file.tieScorePips.len(); ++i )
	{
		var pipRui = Hud_GetRui( file.tieScorePips[i] )

		if( numTies == 0 )
		{
			RuiSetBool( pipRui, "show", false )
			continue
		}

		RuiSetBool( pipRui, "show", true )
		RuiSetBool( pipRui, "scored", (i + 1) <= numTies )
		RuiSetBool( pipRui, "roundWon", won )
		RuiSetBool( pipRui, "playScoreAnim", isTieBreaker && (i + 1) == numTies )
		RuiSetGameTime( pipRui, "startTime", startTime )
	}

}

void function _PlayIntroTransition( )
{
	                                    
	wait 0.35

	const float scoreTransitionTime = 0.35
	const float leftScoreXOffset  = -700
	const float rightScoreXOffset = 700

	var leftScoreAnchor  = Hud_GetChild( file.menu, "LeftScorePip_Anchor" )
	var rightScoreAnchor = Hud_GetChild( file.menu, "RightScorePip_Anchor" )

	Hud_SetX( leftScoreAnchor, leftScoreXOffset )
	Hud_SetX( rightScoreAnchor, rightScoreXOffset )
	Hud_ReturnToBasePosOverTime( leftScoreAnchor, scoreTransitionTime, INTERPOLATOR_DEACCEL )
	Hud_ReturnToBasePosOverTime( rightScoreAnchor, scoreTransitionTime, INTERPOLATOR_DEACCEL )
}

void function OnPostRoundSummary_NavBack()
{
	                                                                 
}