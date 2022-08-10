global function InitCustomMatchDashboardMenu
global function CustomMatch_CloseLobbyMenu

struct
{
	var menu
	var lobbyDetails
	var matchSettings
	var matchCountdown
} file

enum eDashboardTab
{
	MATCH_LOBBY,
	MATCH_SUMMARY,

	__count
}

void function InitCustomMatchDashboardMenu( var menu )
{
	file.menu = menu
	file.lobbyDetails = Hud_GetChild( menu, "LobbyDetails" )
	file.matchSettings = Hud_GetChild( menu, "MatchSettings" )
	file.matchCountdown = Hud_GetChild( menu, "MatchCountdown" )

	Hud_SetEnabled( file.matchSettings, false )

	SetTabNavigationEnabled( file.menu, true )
	AddTab( file.menu, Hud_GetChild( menu, "LobbyPanel" ), "#MATCH_LOBBY" )		                            
	AddTab( file.menu, Hud_GetChild( menu, "SummaryPanel" ), "#MATCH_SUMMARY" )	                              

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, CustomMatchDashboard_OnOpen )
	AddMenuEventHandler( menu, eUIEvent.MENU_SHOW, CustomMatchDashboard_OnShow )
	AddMenuEventHandler( menu, eUIEvent.MENU_HIDE, CustomMatchDashboard_OnHide )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, CustomMatchDashboard_OnNavigateBack )

	AddButtonEventHandler( file.matchSettings, UIE_CLICK, MatchSettings_OnClick )

	AddCallback_OnCustomMatchSettingChanged( CUSTOM_MATCH_SETTING_PLAYLIST, Callback_OnLobbyPlaylistChanged )
	AddCallback_OnCustomMatchSettingChanged( CUSTOM_MATCH_SETTING_LOBBY_NAME, Callback_OnLobbyNameChanged )
	AddCallback_OnCustomMatchSettingChanged( CUSTOM_MATCH_SETTING_MATCH_STATUS, Callback_OnMatchStatusChanged )
	AddCallback_OnCustomMatchPlayerDataChanged( Callback_OnPlayerDataChanged )
}

void function CustomMatch_CloseLobbyMenu( string leaveHeader = "", string leaveDesc = "" )
{
	if ( MenuStack_Contains( GetMenu( "CustomMatchLobbyMenu" ) ) )
	{
		CloseAllMenus()
		AdvanceMenu( GetMenu( "LobbyMenu" ) )

		if ( leaveHeader != "" )
		{
			ConfirmDialogData data
			data.headerText = leaveHeader
			data.messageText = leaveDesc
			OpenOKDialogFromData( data )
		}
	}
}

void function CustomMatchDashboard_OnOpen()
{
	CustomMatch_RefreshPlaylists()
	TabData tabData = GetTabDataForPanel( file.menu )
	ActivateTab( tabData, eDashboardTab.MATCH_LOBBY )

	                                                    
	if ( CustomMatch_HasSetting( CUSTOM_MATCH_SETTING_MATCH_STATUS ) )
		Callback_OnMatchStatusChanged( CUSTOM_MATCH_SETTING_MATCH_STATUS, CustomMatch_GetSetting( CUSTOM_MATCH_SETTING_MATCH_STATUS ) )
}

void function CustomMatchDashboard_OnShow()
{
	UI_SetPresentationType( ePresentationType.WEAPON_CATEGORY )
	RegisterButtonPressedCallback( KEY_TAB, MatchSettings_OnClick )
	RegisterButtonPressedCallback( BUTTON_BACK, MatchSettings_OnClick )
}

void function CustomMatchDashboard_OnHide()
{
	DeregisterButtonPressedCallback( KEY_TAB, MatchSettings_OnClick )
	DeregisterButtonPressedCallback( BUTTON_BACK, MatchSettings_OnClick )
}

void function CustomMatchDashboard_OnNavigateBack()
{
	bool isMatchmaking = ( CustomMatch_GetSetting( CUSTOM_MATCH_SETTING_MATCH_STATUS ) == CUSTOM_MATCH_STATUS_MATCHMAKING )
	bool isReady = ( CustomMatch_GetLocalPlayerData().flags & CUSTOM_MATCH_PLAYER_BIT_IS_READY ) != 0
	TabData tabData = GetTabDataForPanel( file.menu )

	if ( tabData.activeTabIdx != eDashboardTab.MATCH_LOBBY )
		ActivateTab( tabData, eDashboardTab.MATCH_LOBBY )
	else if ( CustomMatch_IsLocalAdmin() && isMatchmaking )
		CustomMatch_SetMatchmaking( false )
	else if ( isReady )
		CustomMatch_SetReady( false )
	else
		AdvanceMenu( GetMenu( "SystemMenu" ) )
}

void function Callback_OnLobbyPlaylistChanged( string _, string value )
{
	CustomMatchPlaylist playlist = expect CustomMatchPlaylist( CustomMatch_GetPlaylist( value ) )
	CustomMatchMap map = expect CustomMatchMap( CustomMatch_GetMap( playlist.mapIndex ) )
	CustomMatchCategory category = expect CustomMatchCategory( CustomMatch_GetCategory( playlist.categoryIndex ) )

	HudElem_SetRuiArg( file.matchSettings, "map", map.displayName )
	HudElem_SetRuiArg( file.matchSettings, "gamemode", category.displayName )
	HudElem_SetRuiArg( file.matchSettings, "logo", category.displayLogo )

	HudElem_SetRuiArg( file.matchCountdown, "map", map.displayName )
	HudElem_SetRuiArg( file.matchCountdown, "gamemode", category.displayName )
	HudElem_SetRuiArg( file.matchCountdown, "logo", category.displayLogo )
}

void function Callback_OnLobbyNameChanged( string _, string value )
{
	HudElem_SetRuiArg( file.lobbyDetails, "lobbyName", value )
}

void function Callback_OnMatchStatusChanged( string _, string value )
{
	switch ( value )
	{
		case CUSTOM_MATCH_STATUS_PREPARING:
			Hud_SetVisible( file.matchSettings, true )
			Hud_SetVisible( file.matchCountdown, false )
			break
		case CUSTOM_MATCH_STATUS_MATCHMAKING:
			Hud_SetVisible( file.matchSettings, false )
			Hud_SetVisible( file.matchCountdown, true )

			float startDelay = GetConVarFloat( "customMatch_startMatchmakingDelay" )
			HudElem_SetRuiArg( file.matchCountdown, "startTime", ClientTime() + startDelay, eRuiArgType.GAMETIME )
			HudElem_SetRuiArg( file.matchCountdown, "inProgress", false )
			break
		default:
			Hud_SetVisible( file.matchSettings, false )
			Hud_SetVisible( file.matchCountdown, true )

			if ( IsFullyConnected() )
				HudElem_SetRuiArg( file.matchCountdown, "inProgress", !AreWeMatchmaking() )
			break
	}
}

void function Callback_OnPlayerDataChanged( CustomMatch_LobbyPlayer player )
{
	Hud_SetEnabled( file.matchSettings, player.isAdmin )
}

void function MatchSettings_OnClick( var button )
{
	if ( Hud_IsVisible( file.matchSettings ) && Hud_IsEnabled( file.matchSettings ) )
		AdvanceMenu( GetMenu( "CustomMatchSettingsDialog" ) )
}