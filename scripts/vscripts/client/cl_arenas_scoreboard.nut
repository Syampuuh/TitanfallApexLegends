global function ClArenasScoreboard_Init

global function Arenas_ScoreboardSetup

struct {
	var scoreboardRui
} file

void function ClArenasScoreboard_Init()
{

}

void function Arenas_ScoreboardSetup()
{
	clGlobal.showScoreboardFunc = ShowScoreboardOrMap_Arenas
	clGlobal.hideScoreboardFunc = HideScoreboardOrMap_Arenas
	Teams_AddCallback_ScoreboardData( Arenas_GetScoreboardData )
	Teams_AddCallback_PlayerScores( Arenas_GetPlayerScores )
	Teams_AddCallback_Header( Arenas_ScoreboardUpdateHeader )
	Teams_AddCallback_SortScoreboardPlayers( Arenas_ScoreboardSortPlayers )
}

void function ShowScoreboardOrMap_Arenas()
{
	ShowFullmap()
	Fullmap_ClearInputContext()

	UpdateMainHudVisibility( GetLocalViewPlayer() )

	HudInputContext inputContext
	inputContext.keyInputCallback = Arenas_HandleKeyInput
	inputContext.moveInputCallback = Arenas_HandleMoveInput
	inputContext.viewInputCallback = Arenas_HandleViewInput
	HudInput_PushContext( inputContext )

	if ( IsLocalPlayerOnTeamSpectator() )
	{
		string playlistName = GetCurrentPlaylistName()

		float customZoomFactor = GetPlaylistVarFloat( playlistName, "fullmapCustomZoomFactor", 0.0 )

		float customZoomX = GetPlaylistVarFloat( playlistName, "fullmapCustomZoomAnchorX", 0.0 )
		float customZoomY = GetPlaylistVarFloat( playlistName, "fullmapCustomZoomAnchorY", 0.0 )

		if(customZoomFactor > 0.0)
		{
			if(customZoomX > 0.0 && customZoomY > 0.0)
			{
				vector customZoomPos = <customZoomX,customZoomY,0.0>
				SetCurrentZoom( customZoomFactor, customZoomPos, false )
			}
			else
				SetCurrentZoom( customZoomFactor, Cl_SURVIVAL_GetDeathFieldCenter() )
		}
		else printf( "NO PLAYLISY VAR in playlist %s, map %s, name %s", playlistName, GetMapName(), GetPlaylistVarString( playlistName, "name", "" ) )
	}
}

void function HideScoreboardOrMap_Arenas()
{
	HudInput_PopContext()
	HideFullmap()
}

bool function Arenas_HandleKeyInput( int key )
{
	bool swallowInput = false

	switch ( key )
	{
		default:
			return Fullmap_HandleKeyInput( key )
	}

	return swallowInput
}

bool function Arenas_HandleMoveInput( float x, float y )
{
	return Fullmap_HandleMoveInput( x, y )
}

bool function Arenas_HandleViewInput( float x, float y )
{
	return Fullmap_HandleViewInput( x, y )
}

ScoreboardData function Arenas_GetScoreboardData()
{
	ScoreboardData data

	data.columnNumDigits.append( 2 )
	data.columnDisplayIcons.append( $"rui/hud/gamestate/player_kills_icon" )
	data.columnDisplayIconsScale.append( 1.0 )

	data.columnNumDigits.append( 2 )
	data.columnDisplayIcons.append( $"rui/hud/gamestate/assist_count_icon2" )
	data.columnDisplayIconsScale.append( 1.0 )

	data.columnNumDigits.append( 4 )
	data.columnDisplayIcons.append( $"rui/hud/gamestate/player_damage_dealt_icon" )
	data.columnDisplayIconsScale.append( 1.0 )

	data.columnNumDigits.append( 4 )
	data.columnDisplayIcons.append( $"rui/hud/gametype_icons/survival/crafting_currency_white" )
	data.columnDisplayIconsScale.append( 0.7 )

	data.numScoreColumns       = data.columnDisplayIcons.len()

	return data
}

array< int > function Arenas_GetPlayerScores( entity player )
{
	array< int > scores

	int kills = player.GetPlayerNetInt( "kills" )
	scores.append( kills )

	int assists = player.GetPlayerNetInt( "assists" )
	scores.append( assists )

	int damage = player.GetPlayerNetInt( "damageDealt" )
	scores.append( damage )

	int cash = player.GetPlayerNetInt( "arenas_current_cash" )
	scores.append( cash )

	return scores
}

void function Arenas_ScoreboardUpdateHeader( var headerRui, var frameRui, int team )
{
	if ( !IsValid( GetLocalViewPlayer() ) )
		return

	if( headerRui != null )
	{
		bool isFriendly = team == GetLocalViewPlayer().GetTeam()
		RuiSetString( headerRui, "headerText", Localize( isFriendly ? "#ALLIES" : "#ENEMIES" ) )
		RuiSetInt( headerRui, "roundsWon", Arenas_GetTeamWins( team ) )

		vector color  = SrgbToLinear( GetKeyColor( COLORID_FRIENDLY ) / 255 )
		if( !isFriendly )
			color  = SrgbToLinear( GetKeyColor( COLORID_ENEMY ) / 255 )

		RuiSetColorAlpha( headerRui, "teamColor", color, 1.0 )

		int myTeamWins = Arenas_GetTeamWins( team )
		int enemyTeamWins = Arenas_GetTeamWins (Arenas_GetOpposingTeam(team ) )
		RuiSetBool( headerRui, "isWinning", ( myTeamWins > enemyTeamWins ) )

		if( frameRui != null )
			RuiSetColorAlpha( frameRui, "teamColor", color, 1.0 )
	}
}

array< entity > function Arenas_ScoreboardSortPlayers( array< entity > teamPlayers, ScoreboardData gameData )
{
	teamPlayers.sort( int function( entity a, entity b )
		{
			int aScore = a.GetPlayerNetInt( "kills" )
			int bScore = b.GetPlayerNetInt( "kills" )

			if ( aScore > bScore ) return -1
			else if ( aScore < bScore ) return 1
			return 0
		}
	)

	return teamPlayers
}