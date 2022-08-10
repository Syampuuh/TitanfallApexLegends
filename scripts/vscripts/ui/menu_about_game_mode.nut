global function InitAboutGameModeMenu
global function OpenAboutGameModePage

struct
{
	var menu

	var aboutElem

} file

void function InitAboutGameModeMenu( var newMenuArg )                                               
{
	var menu = newMenuArg
	file.menu = newMenuArg
    
	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnAboutGameModeMenu_Open )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, OnAboutGameModeMenu_Close )

	AddMenuEventHandler( menu, eUIEvent.MENU_SHOW, OnAboutGameModeMenu_Show )
	AddMenuEventHandler( menu, eUIEvent.MENU_HIDE, OnAboutGameModeMenu_Hide )

	AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )

	file.aboutElem = Hud_GetChild( newMenuArg, "AboutText" )
}

void function OpenAboutGameModePage( var button )
{
	if ( GetPlaylistVarBool( Lobby_GetSelectedPlaylist(), "show_ltm_about_button_is_takeover", false ) )
		return

	if ( GetPlaylistVarBool( Lobby_GetSelectedPlaylist(), "ltm_about_button_shows_event_page", false ) )
	{
		ItemFlavor ornull buffetEvent = GetActiveBuffetEventForIndex( GetUnixTimestamp(), 0 )
		if ( buffetEvent != null )
		{
			expect ItemFlavor( buffetEvent )
			BuffetEvent_OnLobbyPlayPanelSpecialChallengeClicked( buffetEvent )
			return
		}
	}

	AdvanceMenu( file.menu )
}

void function FocusAboutForScrolling( ... )
{
	if( !Hud_IsFocused( file.aboutElem ) )
		Hud_SetFocused( file.aboutElem )
}

void function OnAboutGameModeMenu_Open()
{
	var rui = Hud_GetRui( Hud_GetChild( file.menu, "InfoMain" ) )
	UISize screenSize = GetScreenSize()
  	                                                                              
	RuiSetFloat2( rui, "actualRes", < screenSize.width, screenSize.height, 0 > )

	string playlist = Lobby_GetSelectedPlaylist()

	array<int> emblemColor = GetEmblemColor( playlist )
	RuiSetColorAlpha( rui, "emblemColor", SrgbToLinear( <emblemColor[0],emblemColor[1],emblemColor[2]> / 255.0 ), emblemColor[3] / 255.0 )

	asset modeImage = GetModeEmblemImage( playlist )
	RuiSetImage( rui, "modeImage", modeImage )

	string aboutTitle = GetPlaylistVarString( playlist, "survival_takeover_name", GetPlaylistVarString( playlist, "name", "" ) )
	string aboutText = GetPlaylistVarString( playlist, "about_text", "" )
	RuiSetString( rui, "aboutTitle", aboutTitle )
	Hud_SetText( file.aboutElem, aboutText )
}

void function OnAboutGameModeMenu_Close()
{

}

void function OnAboutGameModeMenu_Show()
{
	RegisterStickMovedCallback( ANALOG_RIGHT_Y, FocusAboutForScrolling )
}

void function OnAboutGameModeMenu_Hide()
{
	DeregisterStickMovedCallback( ANALOG_RIGHT_Y, FocusAboutForScrolling )
}