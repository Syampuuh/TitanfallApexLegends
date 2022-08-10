global function InitCustomMatchConnectMenu

global const int CUSTOM_MATCH_CODE_ENTRY_LENGTH = 8

const string MATCH_ROLE_TOKEN_CONVAR = "match_roleToken"
const string AUTO_CONNECT_CONVAR = "autoConnect"
const string CUSTOM_MATCH_ENABLED_CONVAR = "customMatch_enabled"

struct
{
	var menu
	var titleRui
	var decorationRui

	var createMatchPanel
	bool isJoinButtonTimedOut = false
	var joinMatchPanel
	var createOrJoinMatchPanel
} file

void function InitCustomMatchConnectMenu( var newMenuArg )
                                              
{
	var menu = newMenuArg
	file.menu = menu

	file.decorationRui = Hud_GetRui( Hud_GetChild( menu, "Decoration" ) )
	file.titleRui = Hud_GetRui( Hud_GetChild( menu, "Title" ) )

	AddUICallback_OnLevelInit( CustomMatchConnect_OnLevelInit )

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, CustomMatchConnectMenu_OnOpen )
	AddMenuEventHandler( menu, eUIEvent.MENU_SHOW, CustomMatchConnectMenu_OnShow )
	AddMenuEventHandler( menu, eUIEvent.MENU_HIDE, CustomMatchConnectMenu_OnHide )

	AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "#B_BUTTON_CLOSE", "#B_BUTTON_CLOSE" )

	RuiSetString( file.titleRui, "titleText", "#TOURNAMENT_CONNECT" )
	RuiSetString( file.titleRui, "subtitleText", "#TOURNAMENT_CONNECT_DESC" )

	file.createMatchPanel = Hud_GetChild( menu, "CreateMatch" )
	file.joinMatchPanel = Hud_GetChild( menu, "JoinMatch" )
	file.createOrJoinMatchPanel = Hud_GetChild( menu, "CreateOrJoinMatch" )

	Init_ConnectBoxPanel( file.createMatchPanel, "#TOURNAMENT_CREATE_MATCH", "", "#TOURNAMENT_BUTTON_CREATE_MATCH", CreateMatchWithEntryCode )
	Init_ConnectBoxPanel( file.joinMatchPanel, "#TOURNAMENT_JOIN_MATCH", "#TOURNAMENT_JOIN_MATCH_DESC", "#TOURNAMENT_BUTTON_JOIN_MATCH", JoinMatchWithEntryCode )
	Init_ConnectBoxPanel( file.createOrJoinMatchPanel, "#TOURNAMENT_CREATE_JOIN_MATCH", "#TOURNAMENT_CREATE_JOIN_MATCH_DESC", "#TOURNAMENT_BUTTON_CREATE_JOIN_MATCH", JoinMatchWithEntryCode )
}

void function CustomMatchConnect_OnLevelInit()
{
	if ( !IsLobby() )
		return

	if ( !GetConVarBool( CUSTOM_MATCH_ENABLED_CONVAR ) )
		return

	if( GetConVarInt( AUTO_CONNECT_CONVAR ) == 2 )
	{
		printf( "Auto connecting to custom match lobby..." )
		string entryCode = GetConVarString( MATCH_ROLE_TOKEN_CONVAR )
		if ( entryCode.len() >= CUSTOM_MATCH_CODE_ENTRY_LENGTH )
			JoinMatchWithEntryCode( entryCode )
		else
			printf( "Unable to auto connect to match lobby. Invalid token: %s", entryCode )

		                                                       
		SetConVarInt( AUTO_CONNECT_CONVAR, 1 )
	}
}

void function CustomMatchConnectMenu_OnOpen()
{
	RuiSetGameTime( file.decorationRui, "initTime", ClientTime() )
	var textEntryJoin = Hud_GetChild( file.joinMatchPanel, "TextEntryCode" )
	var textEntryCreateOrJoin = Hud_GetChild( file.createOrJoinMatchPanel, "TextEntryCode" )
	string entryCode = GetConVarString( MATCH_ROLE_TOKEN_CONVAR )
	if ( entryCode != "" && entryCode.len() == CUSTOM_MATCH_CODE_ENTRY_LENGTH )
	{
		Hud_SetUTF8Text( textEntryJoin, entryCode )
		Hud_SetUTF8Text( textEntryCreateOrJoin, entryCode )
	}
}


void function CustomMatchConnectMenu_OnShow()
{
	print( "CustomMatchConnectMenu_OnShow" )
	UI_SetPresentationType( ePresentationType.WEAPON_CATEGORY )
	bool publicEnabled = GetConVarBool( "customMatch_public_enabled" )
	thread CustomMatchCreateMenu_Update( file.createMatchPanel, publicEnabled )
	thread CustomMatchConnectMenu_Update( file.joinMatchPanel, publicEnabled )
	thread CustomMatchConnectMenu_Update( file.createOrJoinMatchPanel, !publicEnabled )

	RegisterButtonPressedCallback( KEY_ENTER, CustomMatchConnectMenu_OnAttemptEnterCode )
}


void function CustomMatchConnectMenu_OnHide()
{
	print( "CustomMatchConnectMenu_OnHide" )
	Signal( uiGlobal.signalDummy, Hud_GetHudName( file.createMatchPanel ) )
	Signal( uiGlobal.signalDummy, Hud_GetHudName( file.joinMatchPanel ) )
	Signal( uiGlobal.signalDummy, Hud_GetHudName( file.createOrJoinMatchPanel ) )

	DeregisterButtonPressedCallback( KEY_ENTER, CustomMatchConnectMenu_OnAttemptEnterCode )
}


void function CustomMatchCreateMenu_Update( var panel, bool showPanel )
{
	string signalName = Hud_GetHudName( panel )

	Signal( uiGlobal.signalDummy, signalName )
	EndSignal( uiGlobal.signalDummy, signalName )

	if ( showPanel )
		Hud_Show( panel )
	else
		Hud_Hide( panel )

	var textEntry = Hud_GetChild( panel, "TextEntryCode" )
	var textEntryBG = Hud_GetChild( panel, "TextEntryBackground" )
	Hud_Hide( textEntry )
	Hud_Hide( textEntryBG )
	var connectButton = Hud_GetChild( panel, "ConnectButton" )
	Hud_SetEnabled( connectButton, true )

	while ( true )
	{
		WaitFrame()
	}
}


void function CustomMatchConnectMenu_Update( var panel, bool showPanel )
{
	string signalName = Hud_GetHudName( panel )

	Signal( uiGlobal.signalDummy, signalName )
	EndSignal( uiGlobal.signalDummy, signalName )

	if ( showPanel )
		Hud_Show( panel )
	else
		Hud_Hide( panel )

	var textEntry     = Hud_GetChild( panel, "TextEntryCode" )
	var connectButton = Hud_GetChild( panel, "ConnectButton" )

	while ( true )
	{
		string entryCode = Hud_GetUTF8Text( textEntry )
		                                   
		Hud_SetEnabled( connectButton, entryCode.len() >= CUSTOM_MATCH_CODE_ENTRY_LENGTH && !file.isJoinButtonTimedOut )

		WaitFrame()
	}
}


void function CustomMatchConnectMenu_OnAttemptEnterCode( var button )
{
	bool publicEnabled = GetConVarBool( "customMatch_public_enabled" )
	var textEntry = Hud_GetChild( publicEnabled ? file.joinMatchPanel : file.createOrJoinMatchPanel, "TextEntryCode" )

	string entryCode = Hud_GetUTF8Text( textEntry )
	if ( entryCode.len() >= CUSTOM_MATCH_CODE_ENTRY_LENGTH )
	{
		JoinMatchWithEntryCode( entryCode )
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
	CustomMatch_CreateLobby()
	                                      
	                                              
	                   
	                                  
}


void function JoinMatchButtonTimeout_Thread()
{
	var connectButton = Hud_GetChild( file.joinMatchPanel, "ConnectButton" )
	file.isJoinButtonTimedOut = true
	wait 2.0
	file.isJoinButtonTimedOut = false
}


void function JoinMatchWithEntryCode( string entryCode )
{
	printt( "JoinMatchWithEntryCode", entryCode )
	CustomMatch_JoinLobby( entryCode )
	thread JoinMatchButtonTimeout_Thread()
	                                      
	                                              
	                   
	                                  
}
