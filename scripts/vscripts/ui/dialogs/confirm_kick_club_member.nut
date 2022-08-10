global function InitConfirmKickUserDialog
global function ConfirmKickClubMemberDialog_Open

struct
{
	var menu
	var contentRui
	float nextAllowCloseTime
	float nextAllowConfirmTime
	string warningString = "#CLUB_KICK_USER_NAME"

	ClubMember& selectedClubMember
} file

void function InitConfirmKickUserDialog( var newMenuArg )                                               
{
	var menu = GetMenu( "ClubKickDialog" )
	file.menu = menu

	SetDialog( menu, true )
	SetGamepadCursorEnabled( menu, false )

	file.contentRui = Hud_GetRui( Hud_GetChild( file.menu, "ContentRui" ) )

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, ConfirmKickClubMemberDialog_OnOpen )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, ConfirmKickClubMemberDialog_OnClose )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, ConfirmKickClubMemberDialog_OnNavigateBack )

	AddMenuFooterOption( menu, LEFT, BUTTON_A, true, "#LOBBY_CLUBS_A_BUTTON_LEAVE", "#YES", Confirm )
	AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "#B_BUTTON_CANCEL", "#B_BUTTON_CANCEL" )
}

void function Confirm( var button )
{
	if ( UITime() < file.nextAllowConfirmTime )
		return

	                                     
	  	                 

	Clubs_LeaveClub()
}

void function ConfirmKickClubMemberDialog_OnOpen()
{
	SetWarningString( file.warningString )
}

void function ConfirmKickClubMemberDialog_OnClose()
{
}


void function SetWarningString( string newStr )
{
	file.warningString = newStr
	RuiSetString( file.contentRui, "headerText", Localize( file.warningString ).toupper() )
}

void function ConfirmKickClubMemberDialog_Open( ClubMember clubMember )
{
	file.selectedClubMember = clubMember
	ConfirmDialogData data
	data.headerText = Localize( "#CLUB_KICK_USER_NAME" )
	data.messageText = Localize( "#CLUB_KICK_USER_DESC", clubMember.memberName )

	data.resultCallback = OnKickClubMemberDialogResult

	OpenConfirmDialogFromData( data )
}


void function OnKickClubMemberDialogResult( int result )
{
	if ( result != eDialogResult.YES )
	{
		file.nextAllowCloseTime = UITime() + 0.1
		return
	}

	if ( !Clubs_IsUserAClubmate( file.selectedClubMember.memberID ) )
	{
		Clubs_OpenKickTargetIsNotAMemberDialog( file.selectedClubMember )
		return
	}

	Clubs_KickMember( file.selectedClubMember )
}


void function ConfirmKickClubMemberDialog_OnNavigateBack()
{
	file.nextAllowCloseTime = UITime() + 0.1
	CloseActiveMenu()
}
