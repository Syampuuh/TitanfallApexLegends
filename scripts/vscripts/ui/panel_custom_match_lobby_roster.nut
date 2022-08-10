global function InitCustomMatchLobbyRosterPanel

struct RosterDisplay
{
	string name
	var button
	var grid
}

struct
{
	var panel
	array<RosterDisplay> rosterDisplays

	int team
} file

const int MIN_ROSTER_SIZE = 6

                                                                    
                           
                                                                    

void function InitCustomMatchLobbyRosterPanel( var panel )
{
	file.panel = panel

	file.rosterDisplays.clear()
	AddRosterPanel( "#TEAM_UNASSIGNED" )
	AddRosterPanel( "#TEAM_SPECTATOR" )
	EnableRosterPanel( TEAM_SPECTATOR )                              

	AddUICallback_InputModeChanged( UICallback_InputModeChanged )
	AddCallback_OnCustomMatchPlayerDataChanged( Callback_OnPlayerDataChanged )
	AddCallback_OnCustomMatchLobbyDataChanged( Callback_OnLobbyDataChanged )
}

void function AddRosterPanel( string name )
{
	int index = file.rosterDisplays.len()
	string buttonName = format( "LobbyRosterButton%02u", index )
	string gridName = format( "LobbyRoster%02u", index )

	RosterDisplay display
	display.name = name
	display.button = Hud_GetChild( file.panel, buttonName )
	display.grid = Hud_GetChild( file.panel, gridName )
	file.rosterDisplays.append( display )

	HudElem_SetRuiArg( display.button, "selected", false )
	HudElem_SetRuiArg( display.button, "buttonText", Localize( display.name ) )
	AddButtonEventHandler( display.button, UIE_CLICK, CustomMatchLobbyRoster_OnLeftClick )
}

                                                                    
                 
                                                                    

void function Callback_OnPlayerDataChanged( CustomMatch_LobbyPlayer player )
{
	if ( file.team != player.team )
	{
		file.team = player.team
		EnabledCurrentRosterPanel()
	}
}

void function Callback_OnLobbyDataChanged( CustomMatch_LobbyState data )
{
	bool controllerModeActive = IsControllerModeActive()

	array< array<CustomMatch_LobbyPlayer> > teams
	teams.resize( TEAM_MULTITEAM_FIRST )
	foreach ( CustomMatch_LobbyPlayer player in data.players )
	{
		if( player.team < TEAM_MULTITEAM_FIRST )
			teams[ player.team ].append( player )
	}

	foreach ( int i, array<CustomMatch_LobbyPlayer> players in teams )
	{
		RosterDisplay display = file.rosterDisplays[ i ]
		HudElem_SetRuiArg( display.button, "buttonText", format( "%s (%i)", Localize( display.name ), players.len() ) )

		int previousCount = Hud_GetButtonCount( display.grid )
		Hud_InitGridButtons( display.grid, int( max( MIN_ROSTER_SIZE, players.len() ) ) )
		Hud_GetChild( display.grid, "ScrollPanel" )                                                    
		foreach ( int buttonIndex, CustomMatch_LobbyPlayer player in players )
		{
			string platformString = PlatformIDToIconString( GetHardwareFromName( player.hardware ) )

			var playerButton = Hud_GetButton( display.grid, buttonIndex )
			HudElem_SetRuiArg( playerButton, "buttonText", player.name )
			HudElem_SetRuiArg( playerButton, "platformString", platformString )
			HudElem_SetRuiArg( playerButton, "isSelf", player.uid == GetPlayerUID() )
			HudElem_SetRuiArg( playerButton, "isAdmin", player.isAdmin )

			AddKeyHandler( playerButton, buttonIndex, buttonIndex >= previousCount )
			Hud_ClearEventHandlers( playerButton, UIE_CLICK )
			if ( CustomMatch_IsLocalAdmin() )
				Hud_AddEventHandler( playerButton, UIE_CLICK, void function( var _ ) : ( player ) { CustomMatchLobby_OnDragPlayer( player ) } )

			Hud_SetChecked( playerButton, ( player.flags & ( CUSTOM_MATCH_PLAYER_BIT_IS_READY | CUSTOM_MATCH_PLAYER_BIT_IS_MATCHMAKING ) ) != 0 )
			Hud_SetNew( playerButton, ( player.flags & CUSTOM_MATCH_PLAYER_BIT_IS_PRELOADING ) != 0 )

			UpdatePlayerToolTip( playerButton, player, IsControllerModeActive() )
		}

		for ( int buttonIndex = MIN_ROSTER_SIZE - 1; buttonIndex >= players.len(); --buttonIndex )
		{
			var playerButton = Hud_GetButton( display.grid, buttonIndex )
			HudElem_SetRuiArg( playerButton, "buttonText", "" )
			HudElem_SetRuiArg( playerButton, "platformString", "" )
			HudElem_SetRuiArg( playerButton, "isSelf", false )
			HudElem_SetRuiArg( playerButton, "isAdmin", false )

			                                                              
			AddKeyHandler( playerButton, buttonIndex, buttonIndex >= previousCount )
			Hud_ClearEventHandlers( playerButton, UIE_CLICK )


			Hud_SetChecked( playerButton, false )
			Hud_SetNew( playerButton, false )

			Hud_ClearToolTipData( playerButton )
		}
	}
}

                                                                    
                  
                                                                    

void function UICallback_InputModeChanged( bool _ )
{
	if ( IsLobby() && CustomMatch_IsInCustomMatch() )
		RefreshPlayerTooltips()
}

void function CustomMatchLobbyRoster_OnLeftClick( var button )
{
	int roster = Hud_GetScriptID( button ).tointeger()
	EnableRosterPanel( roster )
}

bool function CustomMatchLobbyRoster_OnKeyPress( var button, int buttonIndex, int keyIndex, bool isPressed )
{
	var menu = Hud_GetParent( Hud_GetParent( button ) )                            
	int menuIndex = Hud_GetScriptID( menu ).tointeger()
	if ( isPressed )
		return CustomMatchLobbyRoster_OnKeyDown( button, buttonIndex, menuIndex, keyIndex ) || CustomMatchLobbyRoster_OnKeyHold( button, buttonIndex, menuIndex, keyIndex )
	return false
}

bool function CustomMatchLobbyRoster_OnKeyDown( var button, int buttonIndex, int menuIndex, int keyIndex )
{
	switch ( keyIndex )
	{
		case KEY_K:
			TryDisplayKickPlayer( buttonIndex, menuIndex )
			return true
		default:
			return false
	}
	return false
}

bool function CustomMatchLobbyRoster_OnKeyHold( var button, int buttonIndex, int menuIndex, int keyIndex )
{
	switch ( keyIndex )
	{
		case BUTTON_STICK_RIGHT:
			thread OnHold_internal( keyIndex, buttonIndex, menuIndex, TryDisplayKickPlayer )
			return true
		default:
			return false
	}
	return false
}

const float BUTTON_HOLD_DELAY = 0.3
void function OnHold_internal( int button, int buttonIndex, int menuIndex, void functionref( int buttonIndex, int menuIndex ) func )
{
	float endTIme = UITime() + BUTTON_HOLD_DELAY

	while ( InputIsButtonDown( button ) && UITime() < endTIme )
	{
		WaitFrame()
	}

	if ( InputIsButtonDown( button ) )
		func( buttonIndex, menuIndex )
}

                                                                    
                           
                                                                    

var function EnabledCurrentRosterPanel()
{
	int team = CustomMatch_GetLocalPlayerData().team
	switch ( team )
	{
		case TEAM_UNASSIGNED:
		case TEAM_SPECTATOR:
			EnableRosterPanel( team )
			break
		default:
			break
	}
}

var function EnableRosterPanel( int index )
{
	Assert( index < file.rosterDisplays.len() )
	foreach ( int i, RosterDisplay display in file.rosterDisplays )
	{
		Hud_SetVisible( display.grid, i == index )
		HudElem_SetRuiArg( display.button, "selected", i == index )
	}
}

void function AddKeyHandler( var button, int buttonIndex, bool isNewButton )
{
	if ( isNewButton )
		Hud_AddKeyPressHandler( button, bool function ( var button, int keyIndex, bool isPressed ) : ( buttonIndex ) { return CustomMatchLobbyRoster_OnKeyPress( button, buttonIndex, keyIndex, isPressed ) } )
}

bool function CanKickPlayer( CustomMatch_LobbyPlayer player )
{
	return CustomMatch_IsLocalAdmin()
		&& player.uid != GetPlayerUID()
}

void function TryDisplayKickPlayer( int buttonIndex, int menuIndex )
{
	if ( ActionsLocked() || InputIsButtonDown( MOUSE_LEFT ) || InputIsButtonDown( BUTTON_A ) )
		return

	array<CustomMatch_LobbyPlayer> players = CustomMatch_GetTeam( menuIndex )
	if ( buttonIndex < players.len() )
		if ( CanKickPlayer( players[ buttonIndex ] ) )
			CustomMatch_ShowKickDialog( [ players[ buttonIndex ] ], true )
}

bool function ActionsLocked()
{
	return CustomMatch_GetSetting( CUSTOM_MATCH_SETTING_MATCH_STATUS ) != CUSTOM_MATCH_STATUS_PREPARING
}

void function RefreshPlayerTooltips()
{
	foreach ( int teamIndex, RosterDisplay display in file.rosterDisplays )
	{
		int buttonCount = Hud_GetButtonCount( display.grid )
		array<CustomMatch_LobbyPlayer> players = CustomMatch_GetTeam( teamIndex )
		foreach ( int i, CustomMatch_LobbyPlayer player in players )
		{
			Assert( i < buttonCount )
			if ( i >= buttonCount )
				break

			var button	= Hud_GetButton( display.grid, i )
			UpdatePlayerToolTip( button, player, IsControllerModeActive() )
		}
	}
}

void function UpdatePlayerToolTip( var button, CustomMatch_LobbyPlayer player, bool controllerModeActive )
{
	ToolTipData toolTipData
	toolTipData.tooltipStyle = eTooltipStyle.CUSTOM_MATCHES

	                                                                                       
	if ( CanKickPlayer( player ) )
	{
		Assert( CustomMatch_IsLocalAdmin() )
		toolTipData.titleText = Localize( "#CUSTOM_MATCH_TOOLTIP_ADMIN" )
		toolTipData.actionHint1 = Localize( controllerModeActive ? "#CUSTOM_MATCH_HOLD_KICK_PLAYERS" : "#CUSTOM_MATCH_KICK_PLAYERS" )
		toolTipData.customMatchData.isAdmin = true
		toolTipData.customMatchData.adminActions = 1
		toolTipData.customMatchData.actionEnabledMask = ActionsLocked() ? 0 : ( 1 << 1 )

		toolTipData.tooltipFlags = toolTipData.tooltipFlags & ~eToolTipFlag.HIDDEN
		Hud_SetToolTipData( button, toolTipData )
	}
	else
	{
		toolTipData.tooltipFlags = toolTipData.tooltipFlags | eToolTipFlag.HIDDEN
		Hud_SetToolTipData( button, toolTipData )
	}
}