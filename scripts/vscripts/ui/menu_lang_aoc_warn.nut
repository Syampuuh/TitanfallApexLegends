global function InitLangAoCDialog
global function OpenLangAoCDialog

struct
{
	var menu
	var agreement
	var acknowledgement
	var footersPanel
	var parentMenuPanel
} file


void function InitLangAoCDialog( var newMenuArg )                                               
{
	var menu = GetMenu( "LangAoCWarn" )
	file.menu = menu

	SetDialog( menu, true )
	SetGamepadCursorEnabled( menu, false )

	file.footersPanel = Hud_GetChild( menu, "FooterButtons" )

	AddMenuFooterOption( menu, LEFT, BUTTON_A, true, "#A_BUTTON_CONTINUE", "#A_BUTTON_CONTINUE", GotToEShop )
	AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "#B_BUTTON_DECLINE", "#B_BUTTON_DECLINE", null )
	
	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, LangAoCDialog_OnOpen )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, LangAoCDialog_OnClose )
}

void function OpenLangAoCDialog( bool review, var parentMenu = null )
{
	file.parentMenuPanel = parentMenu
	AdvanceMenu( file.menu )
}


void function LangAoCDialog_OnOpen()
{
	var frameElem = Hud_GetChild( file.menu, "DialogFrame" )
	RuiSetImage( Hud_GetRui( frameElem ), "basicImage", $"rui/menu/common/dialog_gradient" )
}


void function LangAoCDialog_OnClose()
{
}


void function GotToEShop( var button )
{
#if NX_PROG
	GoToNXEShop()
#endif
	CloseActiveMenu()
}