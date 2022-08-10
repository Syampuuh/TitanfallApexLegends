global function InitErrorDialog
global function OpenErrorDialogThread

struct
{
	var menu
	var contentRui
	asset contextImage
	string headerText
	string messageText
	string SIDText
} file

void function InitErrorDialog( var newMenuArg )                                               
{
	var menu = GetMenu( "ErrorDialog" )
	file.menu = menu

	SetDialog( menu, true )
	SetGamepadCursorEnabled( menu, false )

	file.contentRui = Hud_GetRui( Hud_GetChild( file.menu, "ContentRui" ) )

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, ErrorDialog_OnOpen )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, ErrorDialog_OnClose )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, ErrorDialog_OnNavigateBack )

	AddMenuFooterOption( menu, LEFT, BUTTON_A, true, "#A_BUTTON_CONTINUE", "#CONTINUE", Continue )

#if DEV
	AddMenuThinkFunc( menu, ErrorDialogAutomationThink )
#endif       
}

#if DEV
void function ErrorDialogAutomationThink( var menu )
{
	if (AutomateUi())
	{
		printt("ErrorDialogAutomationThink Continue()")
		Continue(null)
	}
}
#endif       

void function Continue( var button )
{
	if ( GetActiveMenu() == file.menu )
		CloseActiveMenu()
}

void function ErrorDialog_OnOpen()
{
	RuiSetAsset( file.contentRui, "contextImage", file.contextImage )
	RuiSetString( file.contentRui, "headerText", file.headerText )

	string messageText = file.messageText
	if( !IsValid( messageText ) )
	{
		messageText = "ERROR MESSAGE TEXT WAS INVALID"
	}
	RuiSetString( file.contentRui, "messageText", messageText )

	var label = Hud_GetChild( file.menu, "ServerID" )
	Hud_SetText( label, file.SIDText )
}

void function ErrorDialog_OnClose()
{
}

void function ErrorDialog_OnNavigateBack()
{
	CloseActiveMenu()
}

void function OpenErrorDialogThread( string errorMessage )
{
	bool isIdleDisconnect = errorMessage.find( Localize( "#DISCONNECT_IDLE" ) ) == 0

	file.contextImage = isIdleDisconnect ? $"ui/menu/common/dialog_notice" : $"ui/menu/common/dialog_error"
	file.headerText = ( isIdleDisconnect ? Localize( "#DISCONNECTED_HEADER" ) : Localize( "#ERROR" ) ).toupper()
	file.messageText = errorMessage
	file.SIDText = "SID: " + GetServerDebugId()                                          

	while ( GetActiveMenu() != GetMenu( "MainMenu" ) )
		WaitSignal( uiGlobal.signalDummy, "OpenErrorDialog", "ActiveMenuChanged" )

	AdvanceMenu( file.menu )
}