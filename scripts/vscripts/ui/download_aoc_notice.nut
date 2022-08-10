global function InitDownloadAoCNoticeDialog
global function OpenDownloadAoCNoticeDialog

struct
{
	var menu
	var agreement
	var acknowledgement
	var footersPanel
	var parentMenuPanel
} file


void function InitDownloadAoCNoticeDialog( var newMenuArg )                                               
{
	var menu = GetMenu( "DownloadAoCNotice" )
	file.menu = menu

	SetDialog( menu, true )
	SetGamepadCursorEnabled( menu, false )

	file.footersPanel = Hud_GetChild( menu, "FooterButtons" )

	AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "#B_BUTTON_DECLINE", "#B_BUTTON_DECLINE", CloseNotice )
	
	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, DownloadAoCNoticeDialog_OnOpen )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, DownloadAoCNoticeDialog_OnClose )
}

void function OpenDownloadAoCNoticeDialog( bool review, var parentMenu = null )
{
	file.parentMenuPanel = parentMenu
	AdvanceMenu( file.menu )
	SetConVarBool( "NewAoCDownloadComplete", false )
}


void function DownloadAoCNoticeDialog_OnOpen()
{
	var frameElem = Hud_GetChild( file.menu, "DialogFrame" )
	RuiSetImage( Hud_GetRui( frameElem ), "basicImage", $"rui/menu/common/dialog_gradient" )
}


void function DownloadAoCNoticeDialog_OnClose()
{
}


void function CloseNotice( var button )
{
	CloseActiveMenu()
}