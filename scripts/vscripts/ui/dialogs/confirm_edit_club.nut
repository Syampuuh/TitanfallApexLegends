global function InitConfirmEditClubDialog
global function ConfirmEditClubDialog_Open

struct
{
	var menu
	var contentRui
	float nextAllowCloseTime
	float nextAllowConfirmTime
	string warningString = "#LOBBY_CLUBS_EDIT_SUBMIT"
	bool isCommittingChanges
} file

void function InitConfirmEditClubDialog( var newMenuArg )                                               
{
	var menu = GetMenu( "ClubEditDialog" )
	file.menu = menu

	SetDialog( menu, true )
	SetGamepadCursorEnabled( menu, false )

	file.contentRui = Hud_GetRui( Hud_GetChild( file.menu, "ContentRui" ) )

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, ConfirmEditClubDialog_OnOpen )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, ConfirmEditClubDialog_OnClose )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, ConfirmEditClubDialog_OnNavigateBack )

	AddMenuFooterOption( menu, LEFT, BUTTON_A, true, "#LOBBY_CLUBS_A_BUTTON_LEAVE", "#YES", Confirm )
	AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "#B_BUTTON_CANCEL", "#B_BUTTON_CANCEL" )
}

void function Confirm( var button )
{
	if ( UITime() < file.nextAllowConfirmTime )
		return

	                                     
	  	                 

	OnEditClubDialogResult( eDialogResult.YES )
}

void function ConfirmEditClubDialog_OnOpen()
{
	SetWarningString( file.warningString )
}

void function ConfirmEditClubDialog_OnClose()
{
}


void function SetWarningString( string newStr )
{
	file.warningString = newStr
	RuiSetString( file.contentRui, "headerText", Localize( file.warningString ).toupper() )
}

void function ConfirmEditClubDialog_Open( bool isComittingChanges = true )
{
	EmitUISound( "UI_Menu_Accept" )

	ConfirmDialogData data
	data.headerText = ClubIsValid() ? Localize( "#LOBBY_CLUBS_EDIT_SUBMIT" ) : Localize( "#LOBBY_CLUBS_CREATE_SUBMIT" )

	data.messageText = isComittingChanges ? Localize( "#CLUB_DIALOG_CONFIRM_CHANGES" ) : Localize( "#CLUB_DIALOG_UNSAVED_CHANGES" )

	data.resultCallback = OnEditClubDialogResult

	file.isCommittingChanges = isComittingChanges
	OpenConfirmDialogFromData( data )
}


void function OnEditClubDialogResult( int result )
{
	if ( result != eDialogResult.YES )
	{
		file.nextAllowCloseTime = UITime() + 0.1
		return
	}

	if ( file.isCommittingChanges )
	{
		SubmitClubEdit()
	}
	else
	{
		thread CloseClubCreationMenu()
	}
}


void function ConfirmEditClubDialog_OnNavigateBack()
{
	file.nextAllowCloseTime = UITime() + 0.1
	CloseActiveMenu()
}
