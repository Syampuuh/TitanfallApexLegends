global function InitCustomMatchPlayerRosterPanel

struct RosterLayout
{
	var panel
	int maxTeams
}

enum eRosterAction
{
	RENAME_TEAM,
	SELF_ASSIGN,

	__count
}

const string DEFAULT_LAYOUT = SURVIVAL

struct
{
	var panel

	string playlist
	string gamemode

	int actionBitmask = 0

	table<string, RosterLayout> layouts
} file

                                                                    
                           
                                                                    

void function InitCustomMatchPlayerRosterPanel( var panel )
{
	file.panel = panel
	AddRosterLayouts()

	AddUICallback_InputModeChanged( UICallback_InputModeChanged )
	AddCallback_OnCustomMatchLobbyDataChanged( Callback_OnLobbyDataChanged )
	AddCallback_OnCustomMatchSettingChanged( CUSTOM_MATCH_SETTING_PLAYLIST, Callback_OnPlaylistChanged )
	AddCallback_OnCustomMatchSettingChanged( CUSTOM_MATCH_SETTING_RENAME_TEAM, Callback_OnRenameTeamChanged )
	AddCallback_OnCustomMatchSettingChanged( CUSTOM_MATCH_SETTING_SELF_ASSIGN, Callback_OnSelfAssignChanged )
}

void function AddRosterLayouts()
{
	file.layouts.clear()
	AddRosterLayout( SURVIVAL, "SurvivalRoster", 20 )
	AddRosterLayout( GAMEMODE_ARENAS, "ArenasRoster", 2 )
}

void function AddRosterLayout( string gamemode, string panelName, int maxTeams )
{
	RosterLayout layout

	layout.panel 		= Hud_GetChild( file.panel, panelName )
	layout.maxTeams 	= maxTeams

	BindRosterPanels( layout )

	file.layouts[gamemode] <- layout
}

                                                                    
                 
                                                                    

const string ON = "1"
void function Callback_OnSelfAssignChanged( string _, string value )
{
	bool oldSetting = CanAction( eRosterAction.SELF_ASSIGN )
	bool newSetting = ( value == ON ) || CustomMatch_IsLocalAdmin()

	if ( oldSetting != newSetting )
	{
		UpdateRosterEventHandler( newSetting, UIE_CLICK, CustomMatchTeamRoster_OnLeftClick, "TeamHeader" )
		SetAction( eRosterAction.SELF_ASSIGN, newSetting )
	}
}

void function Callback_OnRenameTeamChanged( string _, string value )
{
	bool oldSetting = CanAction( eRosterAction.RENAME_TEAM )
	bool newSetting = ( value == ON ) || CustomMatch_IsLocalAdmin()

	if ( oldSetting != newSetting )
	{
		UpdateRosterEventHandler( newSetting, UIE_CLICKRIGHT, CustomMatchTeamRoster_OnRightClick, "TeamHeader" )
		SetAction( eRosterAction.RENAME_TEAM, newSetting )
	}
}

void function Callback_OnPlaylistChanged( string _, string value )
{
	file.playlist = value
	string gamemode = GetPlaylistGamemodeByIndex( file.playlist, 0 )
	if ( gamemode != file.gamemode )
	{
		OnGameModeChanged( file.gamemode, gamemode )
		file.gamemode = gamemode
	}
}

void function Callback_OnLobbyDataChanged( CustomMatch_LobbyState data )
{
	bool controllerModeActive = IsControllerModeActive()

	RosterLayout layout = GetRosterLayout( file.gamemode )
	int teamCount = int( min( data.maxTeams, layout.maxTeams ) )

	array< array<CustomMatch_LobbyPlayer> > teams
	teams.resize( teamCount )
	foreach ( CustomMatch_LobbyPlayer player in data.players )
	{
		int teamIndex = player.team - TEAM_MULTITEAM_FIRST
		if( 0 <= teamIndex && teamIndex < teamCount )
			teams[ teamIndex ].append( player )
	}

	foreach ( int i, array<CustomMatch_LobbyPlayer> team in teams )
	{
		int teamIndex	= i + TEAM_MULTITEAM_FIRST
		var teamPanel 	= GetTeamPanel( layout.panel, i )
		var teamHeader	= Hud_GetChild( teamPanel, "TeamHeader" )
		var teamList 	= Hud_GetChild( teamPanel, "TeamPlayerRoster" )
		int buttonCount = Hud_GetButtonCount( teamList )
		Hud_GetChild( teamList, "ScrollPanel" )                                                    

		string teamName = ( teamIndex in data.teamNames ) ? data.teamNames[ teamIndex ] : Localize( "#TEAM_NUMBERED", i + 1 )
		HudElem_SetRuiArg( teamHeader, "teamName", teamName )

		UpdateTeamToolTip( teamHeader, teamIndex, team.len() == buttonCount, controllerModeActive )

		foreach ( int j, CustomMatch_LobbyPlayer player in team )
		{
			if ( j >= buttonCount )
				continue

			string platformString = PlatformIDToIconString( GetHardwareFromName( player.hardware ) )

			var playerButton = Hud_GetButton( teamList, j )
			HudElem_SetRuiArg( playerButton, "buttonText", player.name )
			HudElem_SetRuiArg( playerButton, "platformString", platformString )
			HudElem_SetRuiArg( playerButton, "isSelf", player.uid == GetPlayerUID() )
			HudElem_SetRuiArg( playerButton, "isAdmin", player.isAdmin )

			Hud_ClearEventHandlers( playerButton, UIE_CLICK )
			if ( CustomMatch_IsLocalAdmin() )
				Hud_AddEventHandler( playerButton, UIE_CLICK, void function( var _ ) : ( player ) { CustomMatchLobby_OnDragPlayer( player ) } )

			Hud_SetChecked( playerButton, ( player.flags & ( CUSTOM_MATCH_PLAYER_BIT_IS_READY | CUSTOM_MATCH_PLAYER_BIT_IS_MATCHMAKING ) ) != 0 )
			Hud_SetNew( playerButton, ( player.flags & CUSTOM_MATCH_PLAYER_BIT_IS_PRELOADING ) != 0 )
		}

		for ( int j = buttonCount - 1; j >= team.len(); --j )
		{
			var playerButton = Hud_GetButton( teamList, j )

			HudElem_SetRuiArg( playerButton, "buttonText", "" )
			HudElem_SetRuiArg( playerButton, "platformString", "" )
			HudElem_SetRuiArg( playerButton, "isSelf", false )
			HudElem_SetRuiArg( playerButton, "isAdmin", false )

			Hud_ClearEventHandlers( playerButton, UIE_CLICK )

			Hud_SetChecked( playerButton, false )
			Hud_SetNew( playerButton, false )
		}
	}
}

                                                                    
                  
                                                                    

void function UICallback_InputModeChanged( bool _ )
{
	if ( IsLobby() && CustomMatch_IsInCustomMatch() )
		RefreshTeamTooltips()
}


void function CustomMatchTeamRoster_OnLeftClick( var button )
{
	if ( ActionsLocked() || !CanAction( eRosterAction.SELF_ASSIGN ) )
		return

	int teamIndex = Hud_GetScriptID( Hud_GetParent( button ) ).tointeger()
	if ( teamIndex != CustomMatch_GetLocalPlayerData().team )
		CustomMatch_SetTeam( teamIndex, GetPlayerHardware(), GetPlayerUID() )
}

void function CustomMatchTeamRoster_OnRightClick( var button )
{
	if ( ActionsLocked() || InputIsButtonDown( MOUSE_LEFT ) || InputIsButtonDown( BUTTON_A ) )
		return

	int teamIndex = Hud_GetScriptID( Hud_GetParent( button ) ).tointeger()
	if ( !CanRenameTeam( teamIndex ) )
		return

	ConfirmDialogData data
	data.headerText = "#CUSTOM_MATCH_CHANGE_TEAM_NAME"
	data.messageText = Localize( "#CUSTOM_MATCH_CHANGE_TEAM_NAME_DESC", teamIndex - 1 )
	data.resultCallback = void function( int result )
	{
		CustomMatchLobby_OnSetTeamNameOpenOrClose( false )
	}
	CustomMatchLobby_OnSetTeamNameOpenOrClose( true )
	OpenTextEntryDialogFromData( data, void function( string name ) : ( teamIndex )
	{
		CustomMatch_SetTeamName( teamIndex, name )
	} )
}

bool function CustomMatchTeamRoster_OnKeyPress( var button, int keyIndex, bool isPressed )
{
	if ( ActionsLocked() )
		return false

	if ( isPressed )
		return CustomMatchTeamRoster_OnKeyDown( button, keyIndex ) || CustomMatchTeamRoster_OnKeyHold( button, keyIndex )
	return false
}

bool function CustomMatchTeamRoster_OnKeyDown( var button, int keyIndex )
{
	int teamIndex = Hud_GetScriptID( Hud_GetParent( button ) ).tointeger()
	switch ( keyIndex )
	{
		case KEY_K:
			TryDisplayKickTeam( teamIndex )
			return true
		default:
			return false
	}
	return false
}

bool function CustomMatchTeamRoster_OnKeyHold( var button, int keyIndex )
{
	int teamIndex = Hud_GetScriptID( Hud_GetParent( button ) ).tointeger()
	switch ( keyIndex )
	{
		case BUTTON_STICK_RIGHT:
			thread OnHold_internal( keyIndex, teamIndex, TryDisplayKickTeam )
			return true
		default:
			return false
	}
	return false
}

const float BUTTON_HOLD_DELAY = 0.3
void function OnHold_internal( int button, int teamIndex, void functionref( int teamIndex ) func )
{
	float endTIme = UITime() + BUTTON_HOLD_DELAY

	while ( InputIsButtonDown( button ) && UITime() < endTIme )
	{
		WaitFrame()
	}

	if ( InputIsButtonDown( button ) )
		func( teamIndex )
}

                                                                    
                           
                                                                    

void function BindRosterPanels( RosterLayout layout )
{
	for ( int i = 0; i < layout.maxTeams; ++i )
	{
		var panel = GetTeamPanel( layout.panel, i )
		var headerPanel = Hud_GetChild( panel, "TeamHeader" )
		Hud_AddKeyPressHandler( headerPanel, CustomMatchTeamRoster_OnKeyPress )
	}
}

                                                                        
                                                                     
                                                         
                                                  
                                                                              
void function UpdateRosterEventHandler( bool enabled, int uiEvent, void functionref(var) callback, ... )
{
	foreach ( RosterLayout layout in file.layouts )
	{
		for ( int i = 0; i < layout.maxTeams; ++i )
		{
			var panel = GetTeamPanel( layout.panel, i )
			for ( int j = 0; j < vargc; ++j )
				panel = Hud_GetChild( panel, string( vargv[ j ] ) )

			if ( enabled )
				Hud_AddEventHandler( panel, uiEvent, callback )
			else
				Hud_RemoveEventHandler( panel, uiEvent, callback )
		}
	}
}

void function OnGameModeChanged( string oldGamemode, string newGamemode )
{
	if ( oldGamemode != "" )
		Hud_Hide( GetRosterLayout( oldGamemode ).panel )

	DisplayRoster( newGamemode, GetRosterLayout( newGamemode ) )
}

void function DisplayRoster( string gamemode, RosterLayout layout )
{
	Hud_Show( layout.panel )

	int teamCount = GetPlaylistVarInt( file.playlist, "max_teams", 0 )
	int playerCount = GetPlaylistVarInt( file.playlist, "max_players", 0 )
	int teamSize = teamCount == 0 ? 0 : ( playerCount / teamCount )

	if ( teamCount > layout.maxTeams )
	{
		Warning( "Layout \"%s\" does not support %i teams.", gamemode, teamCount )
		teamCount = layout.maxTeams
	}

	for ( int i = 0; i < teamCount; ++i )
	{
		var teamPanel 		= GetTeamPanel( layout.panel, i )
		var teamPanelRoster = Hud_GetChild( teamPanel, "TeamPlayerRoster" )

		Hud_Show( teamPanel )
		Hud_InitGridButtons( teamPanelRoster, teamSize )
	}

	for ( int i = teamCount; i < layout.maxTeams; ++i )
		Hud_Hide( GetTeamPanel( layout.panel, i ) )
}

RosterLayout function GetRosterLayout( string gamemode )
{
	if ( file.layouts.len() == 0 )
	{
		Warning( "Custom match roster layouts missing: Restoring layouts." )
		AddRosterLayouts()
	}

	if ( gamemode == "" )
		return file.layouts[ DEFAULT_LAYOUT ]

	if ( gamemode in file.layouts )
		return file.layouts[ gamemode ]

	Warning( "No layout found for game mode \"" + gamemode + "\"" )
	return file.layouts[ DEFAULT_LAYOUT ]
}

var function GetTeamPanel( var panel, int index )
{
	return Hud_GetChild( panel, format( "Team%02u", index ) )
}

bool function CanAction( int action )
{
	return ( ( file.actionBitmask & ( 1 << action ) ) != 0 )
}

void function SetAction( int action, bool enable )
{
	if( enable )
		file.actionBitmask = file.actionBitmask | ( 1 << action )
	else
		file.actionBitmask = file.actionBitmask & ~( 1 << action )
}

bool function ActionsLocked()
{
	return CustomMatch_GetSetting( CUSTOM_MATCH_SETTING_MATCH_STATUS ) != CUSTOM_MATCH_STATUS_PREPARING
}

bool function CanRenameTeam( int teamIndex )
{
	if ( CustomMatch_IsLocalAdmin() )
		return true

	return ( CustomMatch_GetLocalPlayerData().team == teamIndex )
		&& CanAction( eRosterAction.RENAME_TEAM )
}

bool function CanKickTeam( int index )
{
	if ( !CustomMatch_IsLocalAdmin() )
		return false

	array<CustomMatch_LobbyPlayer> team = CustomMatch_GetTeam( index )
	switch( team.len() )
	{
		                                 
		case 0:
			return false

		                   
		case 1:
			return team[0].uid != GetPlayerUID()

		default:
			return true
	}
	unreachable
}

void function TryDisplayKickTeam( int index )
{
	if ( InputIsButtonDown( MOUSE_LEFT ) || InputIsButtonDown( BUTTON_A ) )
		return

	if ( CanKickTeam( index ) )
		CustomMatch_ShowKickDialog( CustomMatch_GetTeam( index ) )
}

void function RefreshTeamTooltips()
{
	RosterLayout layout = GetRosterLayout( file.gamemode )
	for ( int i = 0; i < layout.maxTeams; i++)
	{
		int teamIndex = i + TEAM_MULTITEAM_FIRST
		var teamPanel 	= GetTeamPanel( layout.panel, i )
		var teamHeader	= Hud_GetChild( teamPanel, "TeamHeader" )
		RefreshTeamToolTip( teamHeader, teamIndex )
	}
}

void function RefreshTeamToolTip( var button, int teamIndex )
{
	if ( Hud_HasToolTipData( button ) )
	{
		ToolTipData toolTipData = Hud_GetToolTipData( button )
		UpdateTeamToolTip( button, teamIndex, toolTipData.customMatchData.isTeamFull, IsControllerModeActive() )
	}
}

void function UpdateTeamToolTip( var button, int teamIndex, bool teamFull, bool controllerModeActive )
{
	ToolTipData toolTipData
	toolTipData.tooltipStyle = eTooltipStyle.CUSTOM_MATCHES

	toolTipData.customMatchData.isAdmin = CustomMatch_IsLocalAdmin()
	toolTipData.customMatchData.isTeamFull = teamFull
	toolTipData.customMatchData.adminActions = 0
	toolTipData.customMatchData.actionEnabledMask = 0

	toolTipData.titleText = CustomMatch_IsLocalAdmin() ? Localize( "#CUSTOM_MATCH_TOOLTIP_ADMIN" ) : ""

	                                                                                                                   
	                                                                                                                            
	int actionCount = 0;

	bool canAction = !ActionsLocked()
	bool isOwnTeam = CustomMatch_GetLocalPlayerData().team == teamIndex
	if ( isOwnTeam || CustomMatch_IsLocalAdmin() )
	{
		toolTipData.customMatchData.adminActions++
		SetTooltipAction( toolTipData, ++actionCount, "#CUSTOM_MATCH_CHANGE_TEAM_NAME_PROMPT", canAction && CanAction( eRosterAction.RENAME_TEAM ) )
	}

	if ( CanKickTeam( teamIndex ) )
	{
		toolTipData.customMatchData.adminActions++
		string text = controllerModeActive ? "#CUSTOM_MATCH_HOLD_KICK_PLAYERS" : "#CUSTOM_MATCH_KICK_PLAYERS"
		SetTooltipAction( toolTipData, ++actionCount, text, canAction )
	}

	if ( isOwnTeam )
	{
		string text = controllerModeActive ? "#CUSTOM_MATCH_HOLD_LEAVE_TEAM" : "#CUSTOM_MATCH_LEAVE_TEAM"
		SetTooltipAction( toolTipData, ++actionCount, text, canAction && CanAction( eRosterAction.SELF_ASSIGN ) )
	}
	else if ( teamFull )
	{
		SetTooltipAction( toolTipData, ++actionCount, "#CUSTOM_MATCH_TEAM_FULL", true )                             
	}
	else
	{
		SetTooltipAction( toolTipData, ++actionCount, "#CUSTOM_MATCH_JOIN_TEAM", canAction && CanAction( eRosterAction.SELF_ASSIGN ) )
	}

	Hud_SetToolTipData( button, toolTipData )
}

void function SetTooltipAction( ToolTipData toolTipData, int actionIndex, string text, bool enabled )
{
	switch( actionIndex )
	{
		case 1:
			toolTipData.actionHint1 = Localize( text )
			break
		case 2:
			toolTipData.actionHint2 = Localize( text )
			break
		case 3:
			toolTipData.actionHint3 = Localize( text )
			break
		default:
			Assert( actionIndex < 3 )
			break
	}

	if ( enabled )
		toolTipData.customMatchData.actionEnabledMask = toolTipData.customMatchData.actionEnabledMask | ( 1 << actionIndex )
}