global function InitUserManagementMenu
global function OpenClubMemberManagementMenu
global function CloseClubMemberManagementMenu
global function ClubMemberManagement_RefreshMenu
global function ClubMemberManagement_RefreshMemberSettingsFromDialog
global function ClubMemberManagement_RefreshMemberSettingsDisplay
global function ClubMemberManagement_UpdateReportGrid

                                     

struct
{
	var                      menu
	var                      menuHeader

	var                      userButtonGrid
	array<var> memberButtons
	table<var, ClubMember > memberButtonToDataMap

	var userSettingsPanel
	var userNameLabel
	var lastActiveLabel
	                   
	var userReportsLabel
	var userRankSettingButton
	var userRankDescriptionText
	var saveButton
	var resetChangesButton

	var gladCard

	var reportsToggleButton
	var reportGrid

	ClubMember& selectedClubMember
	array<ClubEvent> selectedClubMemberReports
	int selectedRank = -1

	bool changesMade = false

	                                    
	                                       
	                                   
	                                
	                                       
	                                   

	var kickUserButton

	var inspectUserButton

} file


void function InitUserManagementMenu( var menu )
{
	file.menu = menu

	RegisterSignal( "HaltPreviewClubMemberCosmetics" )

	file.menuHeader = Hud_GetChild( menu, "MenuHeader" )
	var menuHeaderRui = Hud_GetRui( file.menuHeader )
	RuiSetString( menuHeaderRui, "menuName", "#CLUB_MEMBERS_EDIT_NAME" )

	                                                   
	                                                                                          
	                                                                       

	file.userButtonGrid = Hud_GetChild( file.menu, "UserGridList" )

	file.userSettingsPanel = Hud_GetChild( file.menu, "UserSettingsPanel" )
	                                                                              
	file.userNameLabel = Hud_GetChild( file.userSettingsPanel, "UserNameHeader" )
	                                                                                  

	                                                                              
	                                                                                  
	                                                                                      

	file.userRankSettingButton = Hud_GetChild( file.userSettingsPanel, "UserRankSetting" )
	                                                                           
	                                                                             
	                                                                                
	                                                                                  
	AddButtonEventHandler( file.userRankSettingButton, UIE_CHANGE, RankSettingButton_OnChanged )

	file.userRankDescriptionText = Hud_GetChild( file.userSettingsPanel, "UserRankDescription" )

	file.saveButton = Hud_GetChild( file.userSettingsPanel, "SaveButton" )
	HudElem_SetRuiArg( file.saveButton, "buttonText", Localize( "#CLUB_MEMBER_MGMT_SAVE_BUTTON_NAME" ) )
	Hud_AddEventHandler( file.saveButton, UIE_CLICK, SaveButton_OnActivate )

	file.resetChangesButton = Hud_GetChild( file.userSettingsPanel, "ResetChangesButton" )
	HudElem_SetRuiArg( file.resetChangesButton, "buttonText", Localize( "#CLUB_MEMBER_MGMT_RESET_BUTTON_NAME" ) )
	Hud_AddEventHandler( file.resetChangesButton, UIE_CLICK, ResetButton_OnActivate )

	                                                                                    

	file.kickUserButton = Hud_GetChild( file.userSettingsPanel, "KickUserButton" )
	Hud_AddEventHandler( file.kickUserButton, UIE_CLICK, KickUserButton_OnActivate )

	file.inspectUserButton = Hud_GetChild( file.userSettingsPanel, "InspectProfileButton" )
	Hud_AddEventHandler( file.inspectUserButton, UIE_CLICK, InspectProfileButton_OnActivate )


	file.gladCard = Hud_GetChild( file.userSettingsPanel, "MemberGladCard" )

	file.reportsToggleButton = Hud_GetChild( file.userSettingsPanel, "ReportsToggleButton" )
	HudElem_SetRuiArg( file.reportsToggleButton, "buttonText", Localize( "CLUB_MEMBER_MGMT_REPORTS_BUTTON" ) )
	Hud_AddEventHandler( file.reportsToggleButton, UIE_CLICK, ReportsToggleButton_OnActivate )
	file.reportGrid = Hud_GetChild( file.userSettingsPanel, "ReportGrid" )

	AddMenuEventHandler( file.menu, eUIEvent.MENU_OPEN, ClubMemberManagement_OnOpen )
	AddMenuEventHandler( file.menu, eUIEvent.MENU_CLOSE, ClubMemberManagement_OnClose )
	AddMenuEventHandler( file.menu, eUIEvent.MENU_GET_TOP_LEVEL, ClubMemberManagement_OnGainTopLevel )

	AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "#B_BUTTON_CLOSE", "#B_BUTTON_CLOSE", null, CanNavigateBack )
}

void function OpenClubMemberManagementMenu()
{
	if ( AreWeMatchmaking() )
	{
		Clubs_OpenClubManagementBlockedByMatchmakingDialog()
		return
	}

	AdvanceMenu( file.menu )
}

void function CloseClubMemberManagementMenu()
{
	if ( GetActiveMenu() == file.menu )
		CloseActiveMenu()
}

void function ClubMemberManagement_OnOpen()
{
	UpdateMemberList()

	AddCallbackAndCallNow_UserInfoUpdated( ClubMemberManagement_OnUserInfoUpdated )
}

void function ClubMemberManagement_OnClose()
{
	Signal( uiGlobal.signalDummy, "HaltPreviewClubMemberCosmetics" )
	RunMenuClientFunction( "ClearAllCharacterPreview" )
	RemoveCallback_UserInfoUpdated( ClubMemberManagement_OnUserInfoUpdated )
}

void function ClubMemberManagement_OnGainTopLevel()
{
	UpdateMemberList()
	ClubMemberManagement_OnUserInfoUpdated( GetNameFromHardware( file.selectedClubMember.memberHardware ), file.selectedClubMember.platformUserID )
	UI_SetPresentationType( ePresentationType.CLUB_LANDING )
}

bool function CanNavigateBack()
{
	if ( GetActiveMenu() != file.menu )
		return false

	return true
}

void function ClubMemberManagement_RefreshMenu()
{
	if ( GetActiveMenu() != file.menu )
		return

	printf( "ClubMgmtDebug: %s()", FUNC_NAME() )

	UpdateMemberList()
}

void function UpdateMemberList()
{
	if ( !ClubIsValid() )
		return

	printf( "ClubMgmtDebug: %s()", FUNC_NAME() )

	array<ClubMember> members = ClubGetMembers()
	members.sort( SortClubMembers )
	
	int buttonCount = members.len()

	foreach ( var button in file.memberButtons )
	{
		Hud_RemoveEventHandler( button, UIE_CLICK, MemberButton_OnClick )
	}

	if ( file.memberButtons.len() > buttonCount )
	{
		file.memberButtons.resize( buttonCount )
	}

	printf( "ClubMgmtDebug: %s(): Initializing member list grid", FUNC_NAME() )

	Hud_InitGridButtons( file.userButtonGrid, buttonCount )
	var scrollPanel = Hud_GetChild( file.userButtonGrid, "ScrollPanel" )

	for ( int memberIdx = 0; memberIdx < buttonCount; memberIdx++ )
	{
		var button = Hud_GetChild( scrollPanel, format( "GridButton%d", memberIdx ) )
		int buttonIdx = file.memberButtons.find( button )
		if ( buttonIdx == -1 )
			file.memberButtons.append( button )

		file.memberButtonToDataMap[ button ] <- members[memberIdx]
	}

	bool selectedMemberIsValid = members.contains( file.selectedClubMember )
	if ( !selectedMemberIsValid )
	{
		file.selectedClubMember = file.memberButtonToDataMap[ file.memberButtons[0] ]
		UpdateMemberSettingsDisplay()
	}

	foreach ( var button in file.memberButtons )
	{
		InitMemberButton( button )
	}
}

void function InitMemberButton( var button )
{
	printf( "ClubMgmtDebug: %s()", FUNC_NAME() )
	ClubMember memberData = file.memberButtonToDataMap[button]
	var rui               = Hud_GetRui( button )

	string buttonText = memberData.memberName + "   " + PlatformIDToIconString( memberData.memberHardware )
	RuiSetString( rui, "buttonText", buttonText )
	ClubManagement_UpdateMemberRank( memberData, memberData.rank )

	printf( "ClubMgmtDebug: %s(): Initialized button for %s (rank %i)", FUNC_NAME(), memberData.memberName, memberData.rank )

	Hud_AddEventHandler( button, UIE_CLICK, MemberButton_OnClick )
}

void function ClubManagement_UpdateMemberRank( ClubMember member, int rank )
{
	var memberButton
	foreach ( var button, ClubMember memberStruct in file.memberButtonToDataMap )
	{
		if ( file.memberButtonToDataMap[button] == member )
		{
			memberButton = button
			break
		}
	}

	if ( memberButton == null )
		return

	ClubMember memberData = file.memberButtonToDataMap[ memberButton ]
	if ( memberData.rank != rank )
		file.memberButtonToDataMap[memberButton].rank = rank

	RuiSetInt( Hud_GetRui( memberButton ), "clubMemberRank", rank )
}

int function SortClubMembers( ClubMember a, ClubMember b )
{
	if ( a.rank > b.rank )
		return -1
	else if ( b.rank > a.rank )
		return 1

	return 0
}

void function MemberButton_OnClick( var button )
{
	printf( "ClubMemberManagementDebug: MemberButton_OnClick" )

	file.selectedClubMember = file.memberButtonToDataMap[ button ]
	ClubMemberManagement_OnUserInfoUpdated( GetNameFromHardware(file.selectedClubMember.memberHardware), file.selectedClubMember.platformUserID )
	UpdateMemberSettingsDisplay()
	                                            
}

void function ClubMemberManagement_RefreshMemberSettingsFromDialog( int result )
{
	if ( result == eDialogResult.YES )
		ClubMemberManagement_RefreshMemberSettingsDisplay()
}

void function ClubMemberManagement_RefreshMemberSettingsDisplay()
{
	if ( GetActiveMenu() != file.menu )
		return

	printf( "ClubMgmtDebug: %s()", FUNC_NAME() )

	                       
	                                              
	  	      

	UpdateMemberSettingsDisplay()
}

void function UpdateMemberSettingsDisplay()
{
	var userNameHeaderRui = Hud_GetRui( file.userNameLabel )
	string userName = file.selectedClubMember.memberName
	string userPlatform = PlatformIDToIconString( file.selectedClubMember.memberHardware )
	string userNameDisplay = userName + " `1" + userPlatform + "`0"
	RuiSetString( userNameHeaderRui, "userName", userNameDisplay )
	                                                                                                                  
	                                                                                      

	file.selectedClubMemberReports = ClubRegulation_GetComplaintsForMember( file.selectedClubMember )
	HudElem_SetRuiArg( file.reportsToggleButton, "buttonText", Localize( "#CLUB_MEMBER_MGMT_REPORTS_BUTTON", file.selectedClubMemberReports.len() ) )
	bool hasNoReports = file.selectedClubMemberReports.len() == 0
	Hud_SetLocked( file.reportsToggleButton, hasNoReports )
	Hud_SetEnabled( file.reportsToggleButton, !hasNoReports )
	                                                                                                                     

	                                                                         
	                                                                                                                         

	file.selectedRank = file.selectedClubMember.rank
	Hud_SetDialogListSelectionIndex( file.userRankSettingButton, file.selectedClubMember.rank )
	UpdateUserRankDescription()

	                                                                                                                                                                                             
	                                                                                                          
	if ( IsDisplayingReports() )
		UpdateMemberReportGrid()
	      
	  	                                                                                                                                                            

	Hud_SetVisible( file.userSettingsPanel, true )

	HudElem_SetRuiArg( file.kickUserButton, "buttonText", Localize( "#CLUB_MEMBER_MGMT_KICK_USER", file.selectedClubMember.memberName.toupper() ) )
	                                                                   
	Hud_SetVisible( file.kickUserButton, true )            

	HudElem_SetRuiArg( file.inspectUserButton, "buttonText", "#CLUB_MEMBER_MGMT_INSPECT_BUTTON" )
}

void function HideMemberSettingsDisplay()
{
	Hud_SetVisible( file.userSettingsPanel, false )
}


void function ClubMemberManagement_OnUserInfoUpdated( string hardware, string id )
{
	printf( "ClubMgmtCardDebug: %s()", FUNC_NAME() )
	ClubMember member = file.selectedClubMember
	string memberHardware = GetNameFromHardware( member.memberHardware )
	string memberUid = member.platformUserID
	string introQuipSoundEventName = ""
	CommunityUserInfo ornull userInfoOrNull = GetUserInfo( memberHardware, memberUid )

	if ( userInfoOrNull == null )
		return

	if ( !IsDisplayingReports() )
		thread UpdateMemberGladCardThread( file.gladCard, userInfoOrNull )
}


void function UpdateMemberGladCardThread( var gladCard, CommunityUserInfo ornull userInfoOrNull )
{
	printf( "ClubMgmtCardDebug: %s()", FUNC_NAME() )
	Signal( uiGlobal.signalDummy, "HaltPreviewClubMemberCosmetics" )
	EndSignal( uiGlobal.signalDummy, "HaltPreviewClubMemberCosmetics" )

	SetupMenuGladCard( gladCard, "card", false )

	                                                                      
	                                          
	                                                                                    

	if ( userInfoOrNull == null )
		return

	CommunityUserInfo userInfo = expect CommunityUserInfo( userInfoOrNull )
	         
	  	                                                   
	        

	SendMenuGladCardPreviewString( eGladCardPreviewCommandType.NAME, 0, userInfo.name )

	ItemFlavor character = GetItemFlavorForCommunityUserInfo( userInfo, ePlayerStryderCharDataArraySlots.CHARACTER, eItemType.character )
	SendMenuGladCardPreviewCommand( eGladCardPreviewCommandType.CHARACTER, 0, character )

	ItemFlavor skin = GetItemFlavorForCommunityUserInfo( userInfo, ePlayerStryderCharDataArraySlots.CHARACTER_SKIN, eItemType.character_skin )
	SendMenuGladCardPreviewCommand( eGladCardPreviewCommandType.SKIN, 0, skin )

	RunClientScript( "UIToClient_PreviewCharacterSkin", ItemFlavor_GetNetworkIndex( skin ), ItemFlavor_GetNetworkIndex( character ) )

	ItemFlavor frame = GetItemFlavorForCommunityUserInfo( userInfo, ePlayerStryderCharDataArraySlots.BANNER_FRAME, eItemType.gladiator_card_frame )
	SendMenuGladCardPreviewCommand( eGladCardPreviewCommandType.FRAME, 0, frame )

	ItemFlavor stance = GetItemFlavorForCommunityUserInfo( userInfo, ePlayerStryderCharDataArraySlots.BANNER_STANCE, eItemType.gladiator_card_stance )
	SendMenuGladCardPreviewCommand( eGladCardPreviewCommandType.STANCE, 0, stance )

	for ( int badgeIndex = 0; badgeIndex < GLADIATOR_CARDS_NUM_BADGES; badgeIndex++ )
	{
		ItemFlavor badge = GetBadgeItemFlavorForCommunityUserInfo( userInfo, character, badgeIndex )
		int dataInteger  = GetBadgeDataIntegerFromCommunityUserInfo( userInfo, badgeIndex )
		SendMenuGladCardPreviewCommand( eGladCardPreviewCommandType.BADGE, badgeIndex, badge, dataInteger )
	}

	for ( int trackerIndex = 0; trackerIndex < GLADIATOR_CARDS_NUM_TRACKERS; trackerIndex++ )
	{
		ItemFlavor tracker = GetTrackerItemFlavorForCommunityUserInfo( userInfo, character, trackerIndex )
		int dataInteger    = GetTrackerDataIntegerFromCommunityUserInfo( userInfo, trackerIndex )
		SendMenuGladCardPreviewCommand( eGladCardPreviewCommandType.TRACKER, trackerIndex, tracker, dataInteger )
	}

	ItemFlavor introQuip = GetItemFlavorForCommunityUserInfo( userInfo, ePlayerStryderCharDataArraySlots.CHARACTER_INTRO_QUIP, eItemType.gladiator_card_intro_quip )
	string introQuipSoundEventName = CharacterIntroQuip_GetVoiceSoundEvent( introQuip )

	Ranked_SetupMenuGladCardFromCommunityUserInfo( userInfo )

	OnThreadEnd( void function() : ( introQuipSoundEventName ) {
		SetupMenuGladCard( null, "", false )

		if ( introQuipSoundEventName != "" )
			StopUISoundByName( introQuipSoundEventName )
	} )

	WaitForever()
}

void function RankSettingButton_OnChanged( var button )
{
	file.selectedRank = Hud_GetDialogListSelectionIndex( file.userRankSettingButton )

	UpdateUserRankDescription()
	file.changesMade = true
}

void function UpdateUserRankDescription()
{
	var rui = Hud_GetRui( file.userRankDescriptionText )
	RuiSetInt( rui, "rank", file.selectedRank )
}

void function SelectRankButton_OnActivate( var button )
{
	                                         
	                                                
}

void function ReportsToggleButton_OnActivate( var button )
{
	if ( IsDisplayingReports() )
	{
		Hud_Hide( file.reportGrid )
		Hud_Show( file.gladCard )
		                                                                             
		HudElem_SetRuiArg( file.reportsToggleButton, "buttonText", Localize( "#CLUB_MEMBER_MGMT_REPORTS_BUTTON", file.selectedClubMemberReports.len() ) )
	}
	else
	{
		Hud_Hide( file.gladCard )
		Hud_Show( file.reportGrid )
		UpdateMemberReportGrid()
		HudElem_SetRuiArg( file.reportsToggleButton, "buttonText", Localize( "#CLUB_MEMBER_MGMT_BANNER_BUTTON" ) )
	}
}

void function UpdateMemberReportGrid()
{
	int buttonCount = file.selectedClubMemberReports.len()
	Hud_InitGridButtons( file.reportGrid, buttonCount )
	var scrollPanel = Hud_GetChild( file.reportGrid, "ScrollPanel" )

	for ( int eventIndex = 0; eventIndex < buttonCount; eventIndex++ )
	{
		var button = Hud_GetChild( scrollPanel, format( "GridButton%d", eventIndex ) )

		var buttonRui = Hud_GetRui( button )
		ClubEvent clubEvent = file.selectedClubMemberReports[ eventIndex ]
		string description = Localize( GetStringForClubEvent( clubEvent ), ClubGetMemberNameByID( clubEvent.eventText ), clubEvent.memberName, Localize( ClubRegulation_GetReasonString( clubEvent.eventParam ) ) )
		RuiSetString( buttonRui, "eventString", description )

		string timeString = GetClubEventTimeString( clubEvent.eventTime )
		RuiSetString( buttonRui, "eventTimeString", timeString )

		RuiSetInt( buttonRui, "eventType", CLUB_EVENT_REPORT )
		RuiSetBool( buttonRui, "isFirstEvent", true )
		RuiSetBool( buttonRui, "isLastEvent", true )
	}
}

void function KickUserButton_OnActivate( var button )
{
	int myRank = ClubGetMyMemberRank()

	if ( file.selectedClubMember.memberID == GetLocalClientPlayer().GetPINNucleusId() )
	{
		OpenClubLeaveDialog()
		return
	}

	if ( myRank == CLUB_RANK_ADMIN && file.selectedClubMember.rank == CLUB_RANK_ADMIN )
	{
		Clubs_OpenErrorStringDialog( "#CLUB_DIALOG_KICK_FAIL_ADMIN" )
		return
	}

	if ( file.selectedClubMember.rank == CLUB_RANK_CREATOR )
	{
		Clubs_OpenErrorStringDialog( "#CLUB_DIALOG_KICK_FAIL_CREATOR" )
		return
	}
	if ( !Clubs_IsUserAClubmate( file.selectedClubMember.memberID ) )
	{
		Clubs_OpenKickTargetIsNotAMemberDialog( file.selectedClubMember )
		return
	}

	ConfirmKickClubMemberDialog_Open( file.selectedClubMember )
}


void function InspectProfileButton_OnActivate( var button )
{
	Friend friendData
	friendData.name = file.selectedClubMember.memberName
	friendData.id = file.selectedClubMember.platformUserID
	friendData.hardware = GetNameFromHardware( file.selectedClubMember.memberHardware )

	InspectFriend( friendData )
}


void function SaveButton_OnActivate( var button )
{
	int myRank = ClubGetMyMemberRank()

	if ( file.selectedClubMember.rank != file.selectedRank )
	{
		if ( file.selectedRank == CLUB_RANK_CREATOR && myRank < CLUB_RANK_CREATOR )
		{
			Clubs_OpenErrorStringDialog( "#CLUB_DIALOG_PROMOTE_FAIL_CREATOR" )
			return
		}

		if ( file.selectedClubMember.rank == CLUB_RANK_CREATOR )
		{
			Clubs_OpenErrorStringDialog( "#CLUB_DIALOG_DEMOTE_FAIL_CREATOR" )
			return
		}

		if ( myRank < CLUB_RANK_CREATOR && file.selectedClubMember.rank == CLUB_RANK_ADMIN )
		{
			Clubs_OpenErrorStringDialog( "#CLUB_DIALOG_DEMOTE_FAIL_ADMIN" )
			return
		}

		ConfirmClubMemberRankDialog_Open( file.selectedClubMember, file.selectedRank )
	}
}

void function ResetButton_OnActivate( var button )
{
	if ( file.changesMade == true )
		Clubs_OpenMemberManagementResetConfirmationDialog()
}

void function ClubMemberManagement_UpdateReportGrid()
{
	if ( GetActiveMenu() != file.menu )
		return

	if ( IsDisplayingReports() )
		UpdateMemberReportGrid()
}

bool function IsDisplayingReports()
{
	return Hud_IsVisible( file.reportGrid )
}