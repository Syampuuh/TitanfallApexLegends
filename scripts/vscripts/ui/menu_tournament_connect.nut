global function InitTournamentConnectMenu

global const int CODE_ENTRY_LENGTH = 6

struct
{
	var menu
	var titleRui
	var decorationRui

	var createMatchPanel
	var joinMatchPanel
} file

void function InitTournamentConnectMenu( var newMenuArg )
                                              
{
	var menu = newMenuArg
	file.menu = menu

	file.decorationRui = Hud_GetRui( Hud_GetChild( menu, "Decoration" ) )
	file.titleRui = Hud_GetRui( Hud_GetChild( menu, "Title" ) )

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, TournamentConnectMenu_OnOpen )
	AddMenuEventHandler( menu, eUIEvent.MENU_SHOW, TournamentConnectMenu_OnShow )
	AddMenuEventHandler( menu, eUIEvent.MENU_HIDE, TournamentConnectMenu_OnHide )

	AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "#B_BUTTON_CLOSE", "#B_BUTTON_CLOSE" )

	RuiSetString( file.titleRui, "titleText", "#TOURNAMENT_CONNECT" )
	RuiSetString( file.titleRui, "subtitleText", "#TOURNAMENT_CONNECT_DESC" )

	                                                             
	file.joinMatchPanel = Hud_GetChild( menu, "JoinMatch" )

	                                                                                                                                                                         
	                                                                                                                                                               
	Init_ConnectBoxPanel( file.joinMatchPanel, "#TOURNAMENT_CREATE_JOIN_MATCH", "#TOURNAMENT_CREATE_JOIN_MATCH_DESC", "#TOURNAMENT_BUTTON_CREATE_JOIN_MATCH", JoinMatchWithEntryCode )
}


void function TournamentConnectMenu_OnOpen()
{
	RuiSetGameTime( file.decorationRui, "initTime", ClientTime() )
}


void function TournamentConnectMenu_OnShow()
{
	print( "TournamentConnectMenu_OnShow" )
	UI_SetPresentationType( ePresentationType.WEAPON_CATEGORY )
	                                                              
	thread TournamentConnectMenu_Update( file.joinMatchPanel )

	RegisterButtonPressedCallback( KEY_ENTER, TournamentConnectMenu_OnAttemptEnterCode )
}


void function TournamentConnectMenu_OnHide()
{
	print( "TournamentConnectMenu_OnHide" )
	                                                                         
	Signal( uiGlobal.signalDummy, Hud_GetHudName( file.joinMatchPanel ) )

	DeregisterButtonPressedCallback( KEY_ENTER, TournamentConnectMenu_OnAttemptEnterCode )
}


void function TournamentConnectMenu_Update( var panel )
{
	string signalName = Hud_GetHudName( panel )

	Signal( uiGlobal.signalDummy, signalName )
	EndSignal( uiGlobal.signalDummy, signalName )

	var textEntry     = Hud_GetChild( panel, "TextEntryCode" )
	var connectButton = Hud_GetChild( panel, "ConnectButton" )

	while ( true )
	{
		string entryCode = Hud_GetUTF8Text( textEntry )
		                                   
		Hud_SetEnabled( connectButton, entryCode.len() >= CODE_ENTRY_LENGTH )

		WaitFrame()
	}
}


void function TournamentConnectMenu_OnAttemptEnterCode( var button )
{
	var textEntry = Hud_GetChild( file.joinMatchPanel, "TextEntryCode" )

	string entryCode = Hud_GetUTF8Text( textEntry )
	if ( entryCode.len() >= CODE_ENTRY_LENGTH )
	{
		CreateMatchWithEntryCode( entryCode )
	}
}


void function Init_ConnectBoxPanel( var panel, string title, string subtitle, string buttonTitle, void functionref( string entryCode ) activateCallback )
{
	RegisterSignal( Hud_GetHudName( panel ) )

	var frame = Hud_GetChild( panel, "ConnectBoxFrame" )

	InitButtonRCP( frame )

	HudElem_SetRuiArg( frame, "titleText", title )
	HudElem_SetRuiArg( frame, "subtitleText", subtitle )

	var textEntry     = Hud_GetChild( panel, "TextEntryCode" )
	var connectButton = Hud_GetChild( panel, "ConnectButton" )

	Hud_SetTextHidden( textEntry, true )
	HudElem_SetRuiArg( connectButton, "buttonText", buttonTitle )

	Hud_AddEventHandler( connectButton, UIE_CLICK, void function( var button ) : (textEntry, activateCallback) {
		string entryCode = Hud_GetUTF8Text( textEntry )
		activateCallback( entryCode )
	} )
}


void function CreateMatchWithEntryCode( string entryCode )
{
	printt( "CreateMatchWithEntryCode", entryCode )
	SetMatchmakingRoleToken( entryCode )
	Lobby_SetSelectedPlaylist( "private_match" )
	CloseActiveMenu()
	ReadyShortcut_OnActivate( null )
}


void function JoinMatchWithEntryCode( string entryCode )
{
	printt( "JoinMatchWithEntryCode", entryCode )
	SetMatchmakingRoleToken( entryCode )
	Lobby_SetSelectedPlaylist( "private_match" )
	CloseActiveMenu()
	ReadyShortcut_OnActivate( null )
}


