global function InitConfirmLeaveClubDialog
global function ConfirmLeaveClubDialog_Open

struct
{
	var menu
	var contentRui
	float nextAllowCloseTime
	float nextAllowConfirmTime
	string warningString = "#LOBBY_CLUBS_LEAVE_NAME"
} file

void function InitConfirmLeaveClubDialog( var newMenuArg )                                               
{
	var menu = GetMenu( "ClubLeaveDialog" )
	file.menu = menu

	SetDialog( menu, true )
	SetGamepadCursorEnabled( menu, false )

	file.contentRui = Hud_GetRui( Hud_GetChild( file.menu, "ContentRui" ) )

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, ConfirmLeaveClubDialog_OnOpen )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, ConfirmLeaveClubDialog_OnClose )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, ConfirmLeaveClubDialog_OnNavigateBack )

	AddMenuFooterOption( menu, LEFT, BUTTON_A, true, "#LOBBY_CLUBS_A_BUTTON_LEAVE", "#YES", Confirm )
	AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "#B_BUTTON_CANCEL", "#B_BUTTON_CANCEL" )
}

void function Confirm( var button )
{
	if ( UITime() < file.nextAllowConfirmTime )
		return

	                                     
	  	                 

	Clubs_LeaveClub()
}

void function ConfirmLeaveClubDialog_OnOpen()
{
	SetWarningString( file.warningString )
}

void function ConfirmLeaveClubDialog_OnClose()
{
}


void function SetWarningString( string newStr )
{
	file.warningString = newStr
	RuiSetString( file.contentRui, "headerText", Localize( file.warningString ).toupper() )
}


void function ConfirmLeaveClubDialog_Open()
{
	if( IsDialog( GetActiveMenu() ) )
		return

	bool isCreator = ClubGetMyMemberRank() == CLUB_RANK_CREATOR
	int userCount = ClubGetMembers().len()

	ConfirmDialogData data
	data.headerText = Localize( "#LOBBY_CLUBS_LEAVE_NAME" )

	string messageString = "#LOBBY_CLUBS_LEAVE_DESC"
	if ( isCreator )
		messageString = "#LOBBY_CLUBS_LEAVE_DESC_CREATOR"
	if ( userCount == 1 )
		messageString = "#LOBBY_CLUBS_LEAVE_DESC_LASTMEMBER"
	data.messageText = Localize( messageString, ClubGetHeader().name )

	data.resultCallback = OnLeaveClubDialogResult

	OpenConfirmDialogFromData( data )
}


void function OnLeaveClubDialogResult( int result )
{
	if ( result != eDialogResult.YES )
	{
		file.nextAllowCloseTime = UITime() + 0.1
		return
	}

	EmitUISound( "UI_Menu_LeaveClub" )
	Clubs_LeaveClub()
}


void function ConfirmLeaveClubDialog_OnNavigateBack()
{
	file.nextAllowCloseTime = UITime() + 0.1
	CloseActiveMenu()
}
