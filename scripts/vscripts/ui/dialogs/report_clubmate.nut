global function InitReportClubmateDialog
global function InitReportClubmateReasonPopup
global function OpenReportClubmateDialog

struct {
	var menu
	var reportReasonButton
	var reportChatButton
	var reportGameButton

	var reportReasonMenu

	var reportReasonPopup
	var reportReasonList

	var closeButton

	array<string> reasons

	table<var, int> buttonToReason

	int selectedReportIndex = -1

	ClubMember& reportClubMember
} file

void function InitReportClubmateDialog( var newMenuArg )                                               
{
	var menu = GetMenu( "ReportClubmateDialog" )
	file.menu = menu

	file.reportReasonButton = Hud_GetChild( menu, "ReportReasonButton" )
	Hud_AddEventHandler( file.reportReasonButton, UIE_CLICK, ReportClubmateReasonButton_OnActivate )

	                                          
	var cheatButton = Hud_GetChild( menu, "ReportCheatButton" )
	Hud_SetVisible( cheatButton, false )

	file.reportChatButton = Hud_GetChild( menu, "ReportGameplayButton" )
	HudElem_SetRuiArg( file.reportChatButton, "buttonText", Localize( "#REPORT_CLUB_INTERNAL_CAT_CHAT" ) )
	Hud_AddEventHandler( file.reportChatButton, UIE_CLICK, ReportChatButton_OnActivate )

	file.reportGameButton = Hud_GetChild( menu, "ReportHarassmentButton" )
	HudElem_SetRuiArg( file.reportGameButton, "buttonText", Localize( "#REPORT_CLUB_INTERNAL_CAT_GAME" ) )
	Hud_AddEventHandler( file.reportGameButton, UIE_CLICK, ReportGameButton_OnActivate )

	                                          
	var contentButton = Hud_GetChild( menu, "ReportContentButton" )
	Hud_SetVisible( contentButton, false )

	var panel = Hud_GetChild( file.menu, "FooterButtons" )

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, ReportClubmateDialog_OnOpen )

	AddMenuFooterOption( menu, LEFT, BUTTON_A, true, "#A_BUTTON_REPORT", "#A_BUTTON_REPORT", ReportClubmateDialog_Yes )
	AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "#B_BUTTON_CANCEL", "#B_BUTTON_CANCEL", ReportClubmateDialog_No )
}


void function OpenReportClubmateDialog( ClubMember clubMember )
{
	file.reportClubMember = clubMember

	AdvanceMenu( GetMenu( "ReportClubmateDialog" ) )
}


void function ReportClubmateDialog_OnOpen()
{
	var contentRui = Hud_GetRui( Hud_GetChild( file.menu, "ContentRui" ) )
	RuiSetString( contentRui, "headerText", "#REPORT_CLUB_INTERNAL_TITLE" )
	string reportDesc = file.reportClubMember.memberName                                                                             
	RuiSetString( contentRui, "messageText", reportDesc )

	Hud_SetVisible( file.reportReasonButton, false )
	Hud_SetVisible( file.reportChatButton, true )
	Hud_SetVisible( file.reportGameButton, true )

	HudElem_SetRuiArg( file.reportReasonButton, "buttonText", Localize( "#SELECT_REPORT_REASON" ) )
	file.selectedReportIndex = -1
}


void function ReportClubmateDialog_Yes( var button )
{
	printf( "ReportClubmateDebug(): %s", FUNC_NAME() )
	if ( file.selectedReportIndex >= 0 )
	{
		if ( IsFullyConnected() )
		{
			printf( "EventReportDebug: ClubReportMember( %s, %i )", file.reportClubMember.memberID, file.selectedReportIndex )
			ClubReportMember( file.reportClubMember.memberID, file.selectedReportIndex )
			ClubLobby_MemberReported( file.reportClubMember )
		}

		CloseAllToTargetMenu( file.menu )
		CloseActiveMenu()
	}
}


void function ReportClubmateDialog_No( var button )
{
	CloseAllToTargetMenu( file.menu )
	CloseActiveMenu()
}


void function ReportClubmateReasonButton_OnActivate( var button )
{
	AdvanceMenu( GetMenu( "ReportClubmateReasonPopup" ) )
	Hud_SetSelected( file.reportReasonButton, true )
}


void function ReportChatButton_OnActivate( var button )
{
	file.reasons = GetChatReportReasons()

	Hud_SetVisible( file.reportReasonButton, file.reasons.len() > 0 )

	Hud_SetVisible( file.reportChatButton, false )
	Hud_SetVisible( file.reportGameButton, false )
}


void function ReportGameButton_OnActivate( var button )
{
	file.reasons = GetGameReportReasons()

	Hud_SetVisible( file.reportReasonButton, file.reasons.len() > 0 )

	Hud_SetVisible( file.reportChatButton, false )
	Hud_SetVisible( file.reportGameButton, false )
}


array<string> function GetChatReportReasons()
{
	array<string> reportReasons = []

	for( int reasonIdx = 0; reasonIdx < eClubInternalReportReason._chat_count; reasonIdx++ )
	{
		reportReasons.append( ClubRegulation_GetReasonString( reasonIdx ) )
	}

	return reportReasons
}

array<string> function GetGameReportReasons()
{
	array<string> reportReasons = []

	for( int reasonIdx = eClubInternalReportReason.REASON_GAME_OFFENSIVE; reasonIdx < eClubInternalReportReason._count; reasonIdx++ )
	{
		reportReasons.append( ClubRegulation_GetReasonString( reasonIdx ) )
	}

	return reportReasons
}


void function InitReportClubmateReasonPopup( var newMenuArg )                                               
{
	var reportReasonMenu = GetMenu( "ReportClubmateReasonPopup" )
	file.reportReasonMenu = reportReasonMenu

	SetPopup( reportReasonMenu, true )

	file.reportReasonPopup = Hud_GetChild( reportReasonMenu, "ReportReasonPopup" )
	AddMenuEventHandler( reportReasonMenu, eUIEvent.MENU_OPEN, OnOpenReportClubmateDialog )
	AddMenuEventHandler( reportReasonMenu, eUIEvent.MENU_CLOSE, OnCloseReportClubmateDialog )

	file.reportReasonList = Hud_GetChild( file.reportReasonPopup, "ReportReasonList" )

	file.closeButton = Hud_GetChild( reportReasonMenu, "CloseButton" )
	Hud_AddEventHandler( file.closeButton, UIE_CLICK, OnCloseButton_Activate )
}


void function OnCloseButton_Activate( var button )
{
	CloseAllToTargetMenu( file.menu )
	Hud_SetSelected( file.reportReasonButton, false )
}


void function OnOpenReportClubmateDialog()
{
	foreach ( button, playlistName in file.buttonToReason )
	{
		Hud_RemoveEventHandler( button, UIE_CLICK, OnReasonButton_Activate )
	}
	file.buttonToReason.clear()

	var ownerButton = file.reportReasonButton

	UIPos ownerPos   = REPLACEHud_GetAbsPos( ownerButton )
	UISize ownerSize = REPLACEHud_GetSize( ownerButton )

	array<string> reasons = file.reasons

	if ( reasons.len() == 0 )
		return

	Hud_Show( file.reportReasonButton )

	Hud_InitGridButtons( file.reportReasonList, reasons.len() )
	var scrollPanel = Hud_GetChild( file.reportReasonList, "ScrollPanel" )
	for ( int i = 0; i < reasons.len(); i++ )
	{
		var button = Hud_GetChild( scrollPanel, ("GridButton" + i) )
		if ( i == 0 )
		{
			int popupHeight = (Hud_GetHeight( button ) * reasons.len())
			Hud_SetPos( file.reportReasonPopup, ownerPos.x, ownerPos.y                   )
			Hud_SetSize( file.reportReasonPopup, ownerSize.width, popupHeight )
			Hud_SetSize( file.reportReasonList, ownerSize.width, popupHeight )

			if ( GetDpadNavigationActive() )
			{
				Hud_SetFocused( button )
				Hud_SetSelected( button, true )
			}
		}

		ReasonButton_Init( button, i )
	}
}


void function OnCloseReportClubmateDialog()
{
	Hud_SetSelected( file.reportReasonButton, false )

	if ( GetDpadNavigationActive() )
		Hud_SetFocused( file.reportReasonButton )
}


void function ReasonButton_Init( var button, int reasonIndex )
{
	Assert( Hud_GetWidth( file.reportReasonButton ) == Hud_GetWidth( button ), "" + Hud_GetWidth( file.reportReasonButton ) + " != " + Hud_GetWidth( button ) )

	InitButtonRCP( button )
	var rui = Hud_GetRui( button )

	RuiSetString( rui, "buttonText", Localize( file.reasons[reasonIndex] ) )

	Hud_AddEventHandler( button, UIE_CLICK, OnReasonButton_Activate )
	file.buttonToReason[button] <- reasonIndex
}


void function OnReasonButton_Activate( var button )
{
	int reportIndex = file.buttonToReason[button]

	if ( file.reasons[reportIndex] == ClubRegulation_GetReasonString( reportIndex ) )
		file.selectedReportIndex = reportIndex
	else
		file.selectedReportIndex = reportIndex + eClubInternalReportReason._chat_count + 1
	HudElem_SetRuiArg( file.reportReasonButton, "buttonText", Localize( file.reasons[reportIndex] ) )
	Hud_SetSelected( file.reportReasonButton, false )

	CloseAllToTargetMenu( file.menu )
}
