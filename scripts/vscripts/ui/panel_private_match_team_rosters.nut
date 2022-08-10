global function InitPrivateMatchTeamRostersPanel
global function InitPrivateMatchSpectatorsPanel
global function InitPrivateMatchUnassignedPlayersPanel

#if CLIENT
                                                    
global function PrivateMatch_TeamRosters_Update
global function SetTeamName_OnOnSave
global function PrivateMatch_KickSelectedPlayer
#endif

#if UI
global function _SetRosterHeaderToolTip
global function ConfirmKickPlayerDialogue
#endif

global const string PRIVATE_MATCH_TEAM_BUTTON_PANEL = "TeamPlayerRoster"
global const string PRIVATE_MATCH_TEAM_HEADER_PANEL = "TeamHeader"

struct RosterButtonData
{
	entity player
	int    encodedEHandle
}

struct
{
	var                        spectatorsPanel
	var                        unassignedPlayersPanel
	var                        teamsPanel
	int                        teamSize
	int                        preloadingPlayers
	table< int, RosterStruct > teamRosters
	var 					   kickDragTarget
	var 					   kickPlayer

	var                            mouseDragIcon
	table< var, int >              mouseDragTargetTeamMap
	table< var, RosterButtonData > rosterButtonToPlayerMap
	RosterButtonData               dragEntData

} file


void function InitPrivateMatchSpectatorsPanel( var panel )
{
	file.spectatorsPanel = panel

	#if UI
		AddUICallback_OnLevelInit( void function() : ( panel )
		{
			Assert( CanRunClientScript() )
			RunClientScript( "InitPrivateMatchSpectatorsPanel", panel )
		} )
	#elseif CLIENT
		                                                                                                     
		file.teamRosters[TEAM_SPECTATOR] <- CreateTeamRoster( TEAM_SPECTATOR, GetPlaylistVarInt( "private_match", "max_observers", TEAM_SPECTATOR_MAX_PLAYERS ), panel )
		file.mouseDragTargetTeamMap[panel] <- TEAM_SPECTATOR
		PrivateMatch_TeamRoster_Configure( file.teamRosters[TEAM_SPECTATOR], "#TEAM_OBSERVER" )
	#endif
}


void function InitPrivateMatchUnassignedPlayersPanel( var panel )
{
	file.unassignedPlayersPanel = panel

	#if UI
		AddUICallback_OnLevelInit( void function() : ( panel )
		{
			Assert( CanRunClientScript() )
			RunClientScript( "InitPrivateMatchUnassignedPlayersPanel", panel )
		} )
	#elseif CLIENT
		                                                                                   
		file.teamRosters[TEAM_UNASSIGNED] <- CreateTeamRoster( TEAM_UNASSIGNED, 0, panel )
		file.mouseDragTargetTeamMap[panel] <- TEAM_UNASSIGNED
		PrivateMatch_TeamRoster_Configure( file.teamRosters[TEAM_UNASSIGNED], "#TEAM_UNASSIGNED" )
	#endif
}


void function InitPrivateMatchTeamRostersPanel( var panel )
{
	                                                            

	file.teamsPanel = panel

	file.mouseDragIcon = Hud_GetChild( Hud_GetParent( panel ), "MouseDragIcon" )

	#if UI
		AddUICallback_OnLevelInit( void function() : ( panel )
		{
			Assert( CanRunClientScript() )
			RunClientScript( "InitPrivateMatchTeamRostersPanel", panel )
		} )
	#elseif CLIENT
		file.preloadingPlayers = -1
		RegisterSignal( "StopMouseDrag" )

		                                                                             
		for ( int index; index < 20; index++ )
		{
			string team          = "Team"
			string indexName     = index < 10 ? "0" + string( index ) : string( index )
			string teamIndexName = team + indexName

			var teamPanel = Hud_GetChild( panel, teamIndexName )
			var teamRosterButtons = Hud_GetChild( teamPanel, PRIVATE_MATCH_TEAM_BUTTON_PANEL )

			file.teamRosters[TEAM_MULTITEAM_FIRST + index] <- CreateTeamRoster( TEAM_MULTITEAM_FIRST + index, 3, teamPanel )
			file.mouseDragTargetTeamMap[teamPanel] <- TEAM_MULTITEAM_FIRST + index
			PrivateMatch_TeamRoster_Configure( file.teamRosters[TEAM_MULTITEAM_FIRST + index], teamIndexName )
		}
		
		file.kickDragTarget = Hud_GetChild( Hud_GetParent( panel ), "KickButton" )
		HudElem_SetRuiArg( file.kickDragTarget, "kickTextString", Localize( "#TOURNAMENT_KICK_PLAYER" ) )	
		
	#endif
}


#if CLIENT
RosterStruct function CreateTeamRoster( int teamIndex, int teamSize, var panel )
{
	RosterStruct teamRoster
	teamRoster.teamIndex = teamIndex
	teamRoster.teamSize = teamSize
	teamRoster.playerRoster.resize( teamSize, null )
	teamRoster.headerPanel = Hud_GetChild( panel, PRIVATE_MATCH_TEAM_HEADER_PANEL )
	teamRoster.listPanel = Hud_GetChild( panel, PRIVATE_MATCH_TEAM_BUTTON_PANEL )

	Hud_AddEventHandler( teamRoster.headerPanel, UIE_CLICK, OnRosterHeader_ClickJoinTeam )
	Hud_AddEventHandler( teamRoster.headerPanel, UIE_CLICKRIGHT, OnRosterHeader_ClickRenameTeam )
	Hud_AddEventHandler( teamRoster.headerPanel, UIE_GET_FOCUS, OnRosterButton_GetFocus )
	Hud_AddEventHandler( teamRoster.headerPanel, UIE_LOSE_FOCUS, OnRosterButton_LoseFocus )

	return teamRoster
}


void function PrivateMatch_TeamRoster_Configure( RosterStruct teamRoster, string teamName )
{
	var buttonPanel = teamRoster.listPanel
	int teamSize    = teamRoster.teamSize

	                                 
	   
	  	                                                                                              
	   
	HudElem_SetRuiArg( teamRoster.headerPanel, "teamName", teamName )
	HudElem_SetRuiArg( teamRoster.headerPanel, "teamNumber", teamRoster.teamDisplayNumber )

	foreach ( button in teamRoster._listButtons )
	{
		Hud_RemoveEventHandler( button, UIE_CLICK, OnRosterButton_Click )
		Hud_RemoveEventHandler( button, UIE_GET_FOCUS, OnRosterButton_GetFocus )
		Hud_RemoveEventHandler( button, UIE_LOSE_FOCUS, OnRosterButton_LoseFocus )
	}
	teamRoster._listButtons.clear()

	Hud_InitGridButtons( buttonPanel, teamSize )
	var scrollPanel = Hud_GetChild( buttonPanel, "ScrollPanel" )
	for ( int i = 0; i < teamSize; i++ )
	{
		var button = Hud_GetChild( scrollPanel, ("GridButton" + i) )
		if ( i == 0 )
		{
			int rosterHeight = (Hud_GetHeight( button ) * teamSize)
		}
		InitButtonRCP( button )
		HudElem_SetRuiArg( button, "buttonText", "" )
		RosterButton_Init( button, null, true )

		Hud_AddEventHandler( button, UIE_CLICK, OnRosterButton_Click )
		Hud_AddEventHandler( button, UIE_GET_FOCUS, OnRosterButton_GetFocus )
		Hud_AddEventHandler( button, UIE_LOSE_FOCUS, OnRosterButton_LoseFocus )
		teamRoster._listButtons.append( button )
	}
}
#endif


#if CLIENT
void function PrivateMatch_TeamRosters_Update( table< int, array< entity > > teamPlayersMap )
{
	if ( file.teamsPanel == null )
		return

	if ( file.teamRosters.len() == 0 )
		return

	int playlistMaxTeams = GetCurrentPlaylistVarInt( "max_teams", 20 )
	int preloadinglayerCount = 0
	foreach ( teamIndex, teamRoster in file.teamRosters )
	{
		if ( teamIndex >= playlistMaxTeams )
			continue

		array<entity> players
		if ( teamIndex in teamPlayersMap )
			players = teamPlayersMap[teamIndex]

		bool isTeamFull = players.len() >= teamRoster.teamSize
		if ( teamIndex == TEAM_UNASSIGNED )
		{
			isTeamFull = false
			teamRoster.teamSize = players.len()
			teamRoster.playerRoster.resize( teamRoster.teamSize, null )
			PrivateMatch_TeamRoster_Configure( teamRoster, Localize( "#TEAM_UNASSIGNED" ) )
		}

		string teamName
		if ( teamRoster.teamIndex == TEAM_SPECTATOR )
			teamName = Localize( "#TEAM_OBSERVER" )
		else if ( teamRoster.teamIndex == TEAM_UNASSIGNED )
			teamName = Localize( "#TEAM_UNASSIGNED" )
		else
			teamName = PrivateMatch_GetTeamName( teamRoster.teamIndex )
		HudElem_SetRuiArg( teamRoster.headerPanel, "teamName", teamName )

		if ( teamIndex != TEAM_UNASSIGNED && teamIndex != TEAM_SPECTATOR )
		{
			int teamDisplayNumber = teamIndex - 1
			                                                                                                    
			teamRoster.teamDisplayNumber = teamDisplayNumber
			HudElem_SetRuiArg( teamRoster.headerPanel, "teamNumber", teamRoster.teamDisplayNumber )
		}

		var scrollPanel = Hud_GetChild( teamRoster.listPanel, "ScrollPanel" )
		Assert( players.len() <= teamRoster.teamSize )
		for ( int playerIndex = 0; playerIndex < teamRoster.teamSize; playerIndex++ )
		{
			var button = Hud_GetChild( scrollPanel, ("GridButton" + playerIndex) )
			if ( playerIndex < players.len() )
			{
				if ( players[playerIndex].GetPlayerNetInt( "readiness" ) & PRIVATEMATCH_ISPRELOADING_BIT )
					preloadinglayerCount++

				RosterButton_Init( button, players[playerIndex] )
				teamRoster.playerRoster[playerIndex] = players[playerIndex]
			}
			else
			{
				RosterButton_Init( button )
				teamRoster.playerRoster[playerIndex] = null
			}
		}

		CreateRosterHeaderToolTipDesc( teamRoster, teamName )
	}

	if ( file.preloadingPlayers != preloadinglayerCount )
	{
		RunUIScript( "PrivateMatch_SetPreloadingPlayers", preloadinglayerCount )
		file.preloadingPlayers = preloadinglayerCount
	}
}

void function CreateRosterHeaderToolTipDesc( RosterStruct teamRoster, string teamName )
{
	int playerTeam = GetLocalClientPlayer().GetTeam()
	int rosterTeam = teamRoster.teamIndex
	bool isTeamFull = GetPlayerArrayOfTeam( rosterTeam ).len() >= teamRoster.teamSize

	string actionText1 = ""
	string actionText2 = ""
	string actionText3 = ""
	if ( GetLocalClientPlayer().HasMatchAdminRole() )
	{
		if ( playerTeam != rosterTeam && !isTeamFull && rosterTeam > TEAM_SPECTATOR )
		{
			actionText1 = Localize( "#TOURNAMENT_HINT_JOIN_TEAM" )
			actionText2 = Localize( "#TOURNAMENT_HINT_RENAME_TEAM" )
		}
		else if ( playerTeam != rosterTeam && rosterTeam == TEAM_SPECTATOR )
		{
			actionText1 = Localize( "#TOURNAMENT_HINT_JOIN_TEAM" )
		}
		else if ( rosterTeam > TEAM_SPECTATOR )
		{
			actionText1 = Localize( "#TOURNAMENT_HINT_RENAME_TEAM" )
		}
	}
	else
	{
		if ( playerTeam != rosterTeam && !isTeamFull && PrivateMatch_CanAssignSelf( GetLocalClientPlayer() ) )
		{
			actionText1 = Localize( "#TOURNAMENT_HINT_JOIN_TEAM" )
		}
		else if ( PrivateMatch_CanRenameTeam( GetLocalClientPlayer(), rosterTeam ) )
		{
			actionText1 = Localize( "#TOURNAMENT_HINT_RENAME_TEAM" )
		}
	}

	RunUIScript( "_SetRosterHeaderToolTip", teamRoster.headerPanel, teamName, actionText1, actionText2, actionText3 )
}
#endif

#if UI
void function _SetRosterHeaderToolTip( var panel, string toolTipText, string actionText1, string actionText2 = "", string actionText3 = "" )
{
	Hud_SetToolTipData( panel, CreateSimpleToolTip( "", toolTipText, actionText1, actionText2, actionText3 ) )
}

void function ConfirmKickPlayerDialogue( string playerName )
{
	if ( IsDialog( GetActiveMenu() ) )
		return
	
	ConfirmDialogData data
	data.headerText = "#TOURNAMENT_KICK_PLAYER"
	data.messageText = Localize( "#TOURNAMENT_KICK_PLAYER_CONFIRM", playerName )  
	data.resultCallback = void function( int dialogResult ) {
		if( dialogResult == eDialogResult.YES )
		{
			RunClientScript( "PrivateMatch_KickSelectedPlayer" ) 
		}
	}

	OpenConfirmDialogFromData( data )
}

#endif


#if CLIENT

void function RosterButton_Init( var button, entity player = null, bool force = false )
{
	RosterButtonData rosterButtonData
	if ( !(button in file.rosterButtonToPlayerMap) )
		file.rosterButtonToPlayerMap[button] <- rosterButtonData
	else
		rosterButtonData = file.rosterButtonToPlayerMap[button]

	if ( force || rosterButtonData.player != player )
	{
		rosterButtonData.player = player
		rosterButtonData.encodedEHandle = player != null ? player.GetEncodedEHandle() : -1

		string playerName = ""
		if ( player != null )
		{
			playerName = player.GetPlayerNameWithClanTag()
		}

		HudElem_SetRuiArg( button, "buttonText", playerName )

		string platformString = ""
		if (player != null)
		{
			platformString = PlatformIDToIconString( GetHardwareFromName( player.GetHardwareName() ) )
		}

		HudElem_SetRuiArg( button, "platformString", platformString )
	}


	int bits = player == null ? 0 : player.GetPlayerNetInt( "readiness" )
	Hud_SetChecked( button, ( bits & PRIVATEMATCH_ISREADY_BIT ) == PRIVATEMATCH_ISREADY_BIT )
	Hud_SetNew( button, ( bits & PRIVATEMATCH_ISPRELOADING_BIT ) == PRIVATEMATCH_ISPRELOADING_BIT )
}


void function OnRosterButton_Click( var button )
{
	if ( InputIsButtonDown( MOUSE_LEFT ) || InputIsButtonDown( BUTTON_A ) && PrivateMatch_CanAssignPlayers( GetLocalClientPlayer() ) )
		thread TrackMouseDrag( button )
}


void function OnRosterHeader_ClickJoinTeam( var button )
{
	if( !InputIsButtonDown( MOUSE_LEFT ) && !InputIsButtonDown( BUTTON_A ) )
		return

	int teamIndex = -1
	foreach ( teamRoster in file.teamRosters )
	{
		if ( teamRoster.headerPanel != button )
			continue

		teamIndex = teamRoster.teamIndex
		break
	}

	Remote_ServerCallFunction( "ClientCallback_PrivateMatchSetPlayerTeam", GetLocalClientPlayer(), teamIndex ) 
}


void function OnRosterHeader_ClickRenameTeam( var button )
{
	if( !InputIsButtonDown( MOUSE_RIGHT ) && !InputIsButtonDown( BUTTON_X ) )
		return

	foreach ( teamRoster in file.teamRosters )
	{
		if ( teamRoster.headerPanel != button )
			continue

		int teamIndex = teamRoster.teamIndex
		if ( teamIndex < TEAM_MULTITEAM_FIRST )
			return

		entity player = GetLocalClientPlayer()
		if ( !PrivateMatch_CanRenameTeam( player, teamIndex ) )
			return

		RunUIScript( "DisplaySetTeamNameDialog", teamIndex, GameRules_GetTeamName( teamIndex ) )
	}
}


const float MOUSE_DRAG_BUFFER = 16.0
const float MOUSE_DRAG_BUFFER_TIME = 0.5

void function TrackMouseDrag( var button )
{
	float startTime   = Time()
	vector mouseStart = GetCursorPosition()

	float dist
	float elapsedTime
	bool dragStarted = false

	OnThreadEnd(
		function() : ()
		{
			Signal( clGlobal.signalDummy, "StopMouseDrag" )
		}
	)

	RosterButtonData rosterButtonData = file.rosterButtonToPlayerMap[button]
	if ( !IsValid( rosterButtonData.player ) )
		return

	if ( rosterButtonData.player.HasMatchAdminRole() )
		return

	if ( !PrivateMatch_CanAssignPlayers( GetLocalClientPlayer() ) )
		return

	while( InputIsButtonDown( MOUSE_LEFT ) || InputIsButtonDown( BUTTON_A ) )
	{
		vector mouseEnd = GetCursorPosition()
		dist = Length( mouseEnd - mouseStart )
		elapsedTime = Time() - startTime

		if ( !dragStarted && (elapsedTime > MOUSE_DRAG_BUFFER_TIME || dist > MOUSE_DRAG_BUFFER) )
		{
			dragStarted = true
			thread StartMouseDrag( button, file.rosterButtonToPlayerMap[button] )
		}

		WaitFrame()
	}

	if ( !dragStarted )
	{
		                                   
	}
	else
	{
		var focusElement = GetMouseFocus()

		var parentElem = focusElement
		while ( parentElem != null )
		{
			if ( parentElem in file.mouseDragTargetTeamMap )
			{
				Remote_ServerCallFunction( "ClientCallback_PrivateMatchSetPlayerTeam", rosterButtonData.player, file.mouseDragTargetTeamMap[parentElem] ) 
				break
			}
			
			if ( parentElem == file.kickDragTarget )
			{
				file.kickPlayer = rosterButtonData.player
				string playerName = rosterButtonData.player.GetPlayerName()
				RunUIScript( "ConfirmKickPlayerDialogue", playerName );
				break
			}

			parentElem = Hud_GetParent( parentElem )
		}
	}
}

void function PrivateMatch_KickSelectedPlayer( )
{
	Remote_ServerCallFunction( "ClientCallback_PrivateMatchKickPlayer", file.kickPlayer )
}

var function GetMouseDragTarget()
{
	var focusElement = GetMouseFocus()

	var parentElem = focusElement
	while ( parentElem != null )
	{
		if ( parentElem in file.mouseDragTargetTeamMap )
			return parentElem

		parentElem = Hud_GetParent( parentElem )
	}

	return null
}


void function StartMouseDrag( var button, RosterButtonData rosterButtonData )
{
	EndSignal( clGlobal.signalDummy, "StopMouseDrag" )

	var elem = file.mouseDragIcon
	var rui  = Hud_GetRui( elem )

	if ( !IsValid( rosterButtonData.player ) )
		return

	HudElem_SetRuiArg( elem, "buttonText", rosterButtonData.player.GetPlayerNameWithClanTag() )
	Hud_Show( elem )

	OnThreadEnd(
		function () : ( elem, button )
		{
			Hud_Hide( elem )

			foreach ( teamRoster in file.teamRosters )
			{
				HudElem_SetRuiArg( teamRoster.headerPanel, "isDragTarget", false )
			}
			
			HudElem_SetRuiArg( file.kickDragTarget, "isDragTarget", false )
		}
	)

	while ( 1 )
	{
		if ( !IsValid( rosterButtonData.player ) )
			Signal( clGlobal.signalDummy, "StopMouseDrag" )

		vector screenPos = ConvertCursorToScreenPos()
		Hud_SetPos( elem, screenPos.x - Hud_GetWidth( elem ) * 0.5, screenPos.y - Hud_GetHeight( elem ) * 0.5 )

		var mouseTarget = GetMouseDragTarget()
		int targetIndex = mouseTarget != null ? file.mouseDragTargetTeamMap[mouseTarget] : -1
		foreach ( teamRoster in file.teamRosters )
		{
			if ( teamRoster.teamIndex == targetIndex )
			{
				HudElem_SetRuiArg( teamRoster.headerPanel, "isDragTarget", targetIndex == TEAM_UNASSIGNED )
				foreach ( player in teamRoster.playerRoster )
				{
					if ( player != null )
						continue

					HudElem_SetRuiArg( teamRoster.headerPanel, "isDragTarget", true )
					break
				}
			}
			else
			{
				HudElem_SetRuiArg( teamRoster.headerPanel, "isDragTarget", false )
			}
		}
		
		var focusElem = GetMouseFocus()
		
		if( focusElem == file.kickDragTarget )
		{
			HudElem_SetRuiArg( file.kickDragTarget, "isDragTarget", true )
		}
		else
		{
			HudElem_SetRuiArg( file.kickDragTarget, "isDragTarget", false )
		}
				
		WaitFrame()
	}
}


vector function ConvertCursorToScreenPos()
{
	vector mousePos   = GetCursorPosition()
	UISize screenSize = GetScreenSize()
	mousePos = < mousePos.x * screenSize.width / 1920.0, mousePos.y * screenSize.height / 1080.0, 0.0 >
	return mousePos
}



void function OnRosterButton_GetFocus( var button )
{
	var rui = Hud_GetRui(button)
	RuiSetBool( rui, "isFocused", true )
}


void function OnRosterButton_LoseFocus( var button )
{
	var rui = Hud_GetRui(button)
	RuiSetBool( rui, "isFocused", false )
}

void function SetTeamName_OnOnSave( int teamIndex, string newTeamName )
{
	Remote_ServerCallFunction( "ClientCallback_PrivateMatchSetTeamName", teamIndex, newTeamName )
}
#endif
