global function InitConfirmClubMemberRankDialog
global function ConfirmClubMemberRankDialog_Open

struct
{
	var menu
	var contentRui
	float nextAllowCloseTime
	float nextAllowConfirmTime
	string warningString = "#CLUB_DIALOG_MEMBER_RANK_HEADER"

	ClubMember& selectedClubMember
	int newRank = 0
} file

void function InitConfirmClubMemberRankDialog( var newMenuArg )                                               
{
	var menu = GetMenu( "ClubMemberRankDialog" )
	file.menu = menu

	SetDialog( menu, true )
	SetGamepadCursorEnabled( menu, false )

	file.contentRui = Hud_GetRui( Hud_GetChild( file.menu, "ContentRui" ) )

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, ConfirmClubMemberRankDialog_OnOpen )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, ConfirmClubMemberRankDialog_OnClose )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, ConfirmClubMemberRankDialog_OnNavigateBack )

	AddMenuFooterOption( menu, LEFT, BUTTON_A, true, "#LOBBY_CLUBS_A_BUTTON_LEAVE", "#YES", Confirm )
	AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "#B_BUTTON_CANCEL", "#B_BUTTON_CANCEL" )
}

void function Confirm( var button )
{
	if ( UITime() < file.nextAllowConfirmTime )
		return

	                                     
	  	                 

	OnClubMemberRankDialogResult( eDialogResult.YES )
}

void function ConfirmClubMemberRankDialog_OnOpen()
{
	SetWarningString( file.warningString )
}

void function ConfirmClubMemberRankDialog_OnClose()
{
}


void function SetWarningString( string newStr )
{
	file.warningString = newStr
	RuiSetString( file.contentRui, "headerText", Localize( file.warningString ).toupper() )
}

void function ConfirmClubMemberRankDialog_Open( ClubMember clubMember, int newRank )
{
	int oldRank = clubMember.rank
	if ( newRank == oldRank )
		return

	file.selectedClubMember = clubMember
	file.newRank = newRank

	ConfirmDialogData data
	data.headerText = Localize( "#CLUB_DIALOG_MEMBER_RANK_HEADER" )

	string memberName = clubMember.memberName
	bool isPromotion = newRank > oldRank
	bool isCrowningNewCreator = newRank == CLUB_RANK_CREATOR
	string newRankString = Clubs_GetClubMemberRankString( newRank )

	string messageText
	if ( isPromotion )
	{
		if ( isCrowningNewCreator )
			messageText = Localize( "#CLUB_DIALOG_DEMOTE_SELF_CREATOR", memberName )
		else
			messageText = Localize( "#CLUB_DIALOG_MEMBER_RANK_PROMOTE", memberName, newRankString )
	}
	else
	{
		messageText = Localize( "#CLUB_DIALOG_MEMBER_RANK_DEMOTE", memberName, newRankString )
	}
	data.messageText = messageText

	data.resultCallback = OnClubMemberRankDialogResult

	OpenConfirmDialogFromData( data )
}


void function OnClubMemberRankDialogResult( int result )
{
	if ( result != eDialogResult.YES )
	{
		file.nextAllowCloseTime = UITime() + 0.1
		return
	}

	bool isPromotion = file.selectedClubMember.rank < file.newRank
	if ( isPromotion )
	{
		PIN_Club_Promote( ClubGetHeader(), file.selectedClubMember.memberID, Clubs_GetClubMemberRankString( file.newRank ) )
	}
	else
	{
		PIN_Club_Demote( ClubGetHeader(), file.selectedClubMember.memberID, Clubs_GetClubMemberRankString( file.newRank ) )
	}

	Clubs_SetClubMemberRank( file.selectedClubMember, file.newRank )
}


void function ConfirmClubMemberRankDialog_OnNavigateBack()
{
	file.nextAllowCloseTime = UITime() + 0.1
	CloseActiveMenu()
}
