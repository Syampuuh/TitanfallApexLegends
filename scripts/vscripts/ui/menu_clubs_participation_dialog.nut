global function InitClubJoinDialog
global function OpenClubJoinDialog

global function InitClubCreateDialog
global function OpenClubCreateDialog

global function Clubs_GetJoinClubHeader
global function Clubs_SetJoinClubHeader

struct
{
	var		   crossplayWarningLabel

	var        joinMenu
	var        joinMenuHeader
	var        joinConfirmButton
	var        joinDenyButton
	var        joinClubDetailsPanel
	ClubHeader& joinClubHeader

	var        createConfirmMenu
	var        createConfirmMenuHeader
	var        createConfirmButton
	var        createDenyButton
	var        createClubDetailsPanel
	ClubHeader& createClubHeader

} file

void function InitClubJoinDialog( var menu )
{
	file.joinMenu = menu
	SetDialog( menu, true )
	SetGamepadCursorEnabled( menu, false )

	file.joinClubDetailsPanel = Hud_GetChild( menu, "ClubDetailsPanel" )

	AddMenuEventHandler( file.joinMenu, eUIEvent.MENU_OPEN, JoinClubDialog_OnOpen )
}

ClubHeader ornull function Clubs_GetJoinClubHeader()
{
	return file.joinClubHeader
}

void function Clubs_SetJoinClubHeader( ClubHeader clubHeader )
{
	file.joinClubHeader = clubHeader
}

void function OpenClubJoinDialog( ClubHeader clubHeader )
{
	file.joinClubHeader = clubHeader
	printf( "ClubJoinDialogDebug: OpenClubJoinDialog - name: %s, tag: %s, privacy: %i, minLevel: %i, minRank: %i", file.joinClubHeader.name, file.joinClubHeader.tag, file.joinClubHeader.privacySetting, file.joinClubHeader.minLevel, file.joinClubHeader.minRating )
	AdvanceMenu( file.joinMenu )
}

void function JoinClubDialog_OnOpen()
{
	ClearMenuFooterOptions( file.joinMenu )

	var frameElem = Hud_GetChild( file.joinMenu, "DialogFrame" )
	var frameRui = Hud_GetRui( frameElem )
	RuiSetImage( frameRui, "basicImage", $"rui/menu/common/dialog_gradient" )
	RuiSetFloat3( frameRui, "basicImageColor", <1, 1, 1> )
	RuiSetFloat( frameRui, "basicImageAlpha", 1.0 )

	Clubs_PopulateClubDetails( file.joinClubHeader, file.joinClubDetailsPanel, false, true )
	                                                                                       

	file.crossplayWarningLabel = Hud_GetChild( file.joinMenu, "CrossplayDisabledWarning" )
	bool shouldShowCrossplayWarning = IsUserOptedInToCrossPlay() == false
	Hud_SetVisible( file.crossplayWarningLabel, shouldShowCrossplayWarning )

	if ( file.joinClubHeader.privacySetting == CLUB_PRIVACY_BY_REQUEST )
		AddMenuFooterOption( file.joinMenu, LEFT, BUTTON_A, true, "#CLUB_JOIN_REQUEST", "#CLUB_JOIN_REQUEST_PC", JoinClubButton_OnActivate )
	else
		AddMenuFooterOption( file.joinMenu, LEFT, BUTTON_A, true, "#CLUB_JOIN_CONFIRM", "#CLUB_JOIN_CONFIRM_PC", JoinClubButton_OnActivate )

	AddMenuFooterOption( file.joinMenu, LEFT, BUTTON_B, true, "#CLUB_JOIN_REQUEST_CANCEL", "#CLUB_JOIN_REQUEST_CANCEL_PC", CancelButton_OnActivate )
	                                                             
	                                                                     
}

void function JoinClubButton_OnActivate( var button )
{
	printf( "ClubJoinRequestDebug: JoinClubButton_OnActivate()" )
	CloseActiveMenu()
	CloseAllDialogs()
	CloseClubsSearchMenu()

	if ( ClubIsValid() )
	{
		if ( file.joinClubHeader.privacySetting == CLUB_PRIVACY_BY_REQUEST )
			Clubs_OpenErrorStringDialog( "#CLUB_DIALOG_CLUB_SWITCH_BYREQUEST" )
		else
			Clubs_OpenSwitchClubsConfirmDialog( file.joinClubHeader )
		return
	}

	if ( !Clubs_DoesMeetJoinRequirements( file.joinClubHeader ) )
	{
		Clubs_OpenJoinReqsChangedDialog( file.joinClubHeader )
		return
	}

	if ( file.joinClubHeader.privacySetting == CLUB_PRIVACY_BY_REQUEST )
	{
		PIN_Club_RequestToJoin( file.joinClubHeader )
		ClubLanding_SearchResultButton_SetActionText( "#CLUB_JOIN_REQUEST_SENT" )
		EmitUISound( "UI_Menu_Clubs_SendJoinRequest" )
	}

	if ( HasActiveLobbyPopup() && IsSocialPopUpAClubInvite() )
	{
		thread ClearActiveLobbyPopup()
	}

	string playerDataCenter = GetDatacenterRealName()
	printf( "ClubDatacenterDebug: Player Datacenter: %s (region: %s), Club Datacenter: %s", playerDataCenter, MyRegion(), file.joinClubHeader.dataCenter )
	if ( file.joinClubHeader.dataCenter != playerDataCenter )
	{
		Clubs_OpenJoinRegionConfirmationDialog( file.joinClubHeader )
		return
	}
	                                                                                       

	Clubs_JoinClub( file.joinClubHeader.clubID )
	                                        
}

void function InitClubCreateDialog( var menu )
{
	file.createConfirmMenu = menu
	SetDialog( menu, true )
	SetGamepadCursorEnabled( menu, false )

	file.createClubDetailsPanel = Hud_GetChild( menu, "ClubDetailsPanel" )

	AddMenuEventHandler( file.createConfirmMenu, eUIEvent.MENU_OPEN, CreateClubDialog_OnOpen )
}

void function OpenClubCreateDialog( ClubHeader clubHeader )
{
	file.createClubHeader = clubHeader
	AdvanceMenu( file.createConfirmMenu )
}

void function CreateClubDialog_OnOpen()
{
	ClearMenuFooterOptions( file.createConfirmMenu )

	var frameElem = Hud_GetChild( file.createConfirmMenu, "DialogFrame" )
	RuiSetImage( Hud_GetRui( frameElem ), "basicImage", $"rui/menu/common/dialog_gradient" )
	RuiSetFloat3( Hud_GetRui( frameElem ), "basicImageColor", <1, 1, 1> )

	Clubs_PopulateClubDetails( file.createClubHeader, file.createClubDetailsPanel, true )

	file.crossplayWarningLabel = Hud_GetChild( file.createConfirmMenu, "CrossplayDisabledWarning" )
	bool shouldShowCrossplayWarning = IsUserOptedInToCrossPlay() == false
	Hud_SetVisible( file.crossplayWarningLabel, shouldShowCrossplayWarning )

	AddMenuFooterOption( file.createConfirmMenu, LEFT, BUTTON_A, true, "#LOBBY_CLUBS_CREATE_CONFIRM", "#LOBBY_CLUBS_CREATE_CONFIRM_PC", CreateClubButton_OnActivate )
	AddMenuFooterOption( file.createConfirmMenu, LEFT, BUTTON_B, true, "#CLUB_JOIN_REQUEST_CANCEL", "#CLUB_JOIN_REQUEST_CANCEL_PC", CancelButton_OnActivate )
}

void function CreateClubButton_OnActivate( var button )
{
	CloseActiveMenu()
	CloseAllDialogs()

	SubmitClubEdit()
}

bool function CanCloseDialog()
{
	var activeMenu = GetActiveMenu()
	if ( activeMenu == file.joinMenu || activeMenu == file.createConfirmMenu )
		return true

	return false
}

void function CancelButton_OnActivate( var button )
{
	                          
	  	      

	CloseActiveMenu()
}