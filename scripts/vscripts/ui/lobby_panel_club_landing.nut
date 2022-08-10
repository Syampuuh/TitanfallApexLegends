global function InitClubLandingPanel
global function IsClubLandingPanelCurrentlyTopLevel
global function ClubLanding_GetLobbyPanel

global function ClubDiscovery_SetCycleDiscoveryButtonEnabled

global function ClubLanding_SearchResultButton_SetActionText

global function UpdateClubLobbyDetails
global function ClubLanding_InitializeClubTabs
global function ClubLanding_ForceUpdateMemberList
global function UpdateClubAdminButtons
global function UpdateJoinRequestsButton
global function ClubLanding_UpdateViewAnnouncementButton

global function ClubLanding_BeginLandingRefresh
global function ClubLanding_RefreshLanding
global function UpdateClubLobbyTabsThread
global function ClubLanding_UpdateUIPresentation
global function ClubLobby_TryUpdatingMemberListForPresence
global function ClubDiscovery_ProcessSearchResults
global function GetStringForClubEvent
global function GetClubEventTimeString
global function GetLastViewedAnnouncementTime
global function SetLastViewedAnnouncementTimeToNow
global function SetLastViewedAnnouncementTimeToNever

global function ClubLobby_GetOnlineMemberCount
global function ClubLobby_MemberReported
global function ClubLobby_IsViewingChat

global function MarkLandingTabNewness

global function ClubDiscovery_ProcessInvitesAndRefreshDisplay
global function ClubDiscovery_ProcessClubInvites

global function ClubLanding_ClearMemberLists

global function ClubLanding_InitHistory
global function UpdateClubChat

#if DEV
	global function ClubLandingDev_JiggleTabs
	global function ClubLandingDev_IsTimelineEnabled
	global function ClubLandingDev_IsTimelineVisible
	global function ClubLandingDev_IsTimelineActive
	global function ClubLandingDev_IsTabActive
	global function ClubLandingDev_AreTabsInitialized
	global function ClubLandingDev_ActivateTimeline
#endif

bool PSNCommRestricted = false;
global function PSNGetCommRestricted
#if UI
global function UICodeCallback_SetCommRestricted
#endif

const int CLUB_LANDING_SEARCH_RESULT_MAX = 9

const string CLUB_NEWNESS_SIGNAL = "ClubCheckNewness"
const string CLUB_TAB_ON_HIDE = "ClubTabOnHide"
const int CLUB_NEW_EVENT_WINDOW = 1
const string TABPANEL_TIMELINE = "ClubEventTimelinePanel"
const string TABPANEL_CHAT = "ClubChatPanel"

const array<string> EVENT_STRINGS_CLUB_CREATED =
[
	"#CLUB_EVENT_CLUB_CREATED_00"
]

const array<string> EVENT_STRINGS_CLUB_CHANGED =
[
	"#CLUB_EVENT_CLUB_CHANGED_00"
]

const array<string> EVENT_STRINGS_USER_JOINED =
[
	"#CLUB_EVENT_USER_JOINED_00"
]

const array<string> EVENT_STRINGS_USER_INVITE =
[
	"#CLUB_EVENT_USER_INVITE_00"
]

const array<string> EVENT_STRINGS_USER_PROMOTED =
[
	"#CLUB_EVENT_USER_PROMOTED_00"
]

const array<string> EVENT_STRINGS_USER_LEFT =
[
	"#CLUB_EVENT_USER_LEFT_00"
]

const array<string> EVENT_STRINGS_LOGO_UPDATES =
[
	"#CLUB_EVENT_LOGO_UPDATE_00"
]

const array<string> EVENT_STRINGS_USER_KICKED =
[
	"#CLUB_EVENT_USER_KICKED_00"
]

const array<string> EVENT_STRINGS_USER_REPORTED =
[
	"#CLUB_EVENT_USER_REPORT_00"
]

const array<string> EVENT_STRINGS_MATCH_COMPLETED =
[
	"#CLUB_EVENT_MATCH_COMPLETED"
]

enum eDiscoveryMenuLockReason
{
	UNDERLEVEL,
	CLUBS_DISABLED,
	ALREADY_IN_CLUB,
	PSN_COMM_RESTRICTED,

	_count
}

const string REFRESH_LANDING_SIGNAL = "ClubRefreshLanding"

struct
{
	var lobbyMenu
	var panel

	bool isWaitingForCurrent
	var spinnerPanel

	var selectedSearchResultButton
	                                          
	var                        discoveryPanel
	var                        discoveryBlurb
	var                        discoveryButtonBlocker
	var                        discoverySearchButton
	var                        discoveryCreateButton
	var                          discoverySearchCycleButton
	var                          competitiveFilterButton
	var                          clubInvitesButton
	bool                         isDisplayingInvites = false
	array<ClubInvite>         clubInvites
	array<ClubHeader>			declinedClubs
	var                          discoverySearchResultsGrid
	array<var>                discoverySearchResultButtons
	table< var, ClubHeader >  resultButtonToClubMap
	int                          searchTagFilterBitmask
	float                        timeSinceLastDiscoverySearch

	                                     
	var lobbyPanel
	var lobbyClubDetails
	var lobbyClubDetailsRankTooltipPanel
	var lobbyClubDetailsPrivacyTooltipPanel
	var lobbyClubDetailsReqsTooltipPanel
	var adminControls
	var editClubButton
	var manageUsersButton
	var viewAnnouncementButton
	var submitAnnouncementButton

	var                      lobbyMemberListHeader
	var                      lobbyMemberListPanel
	array<var>               memberButtons
	table<var, ClubMember >  memberButtonToDataMap
	table< string, var >	 memberIdToButtonMap
	table< string, bool >    memberOnlineStatus
	table< var, bool >		 memberButtonHasInputHandler
	var						 inviteReasonSelector
	var                      inviteAllToPartyButton
	bool					 isInviteCooldownActive
	array<string>			 clubMemberInvitedList
	array<string>			 clubMemberReportedList
	bool					 memberListMapNeedsReset
	float 					 memberInvitedTime

	int                 selectedPartyInviteReason = eInviteReason.REASON_00_NONE
	array< string > selectedClubMembersToInvite

	bool tabsInitialized = false
	bool lobbyIsShown = false

	int        viewedEventTime
	var        timelineTabButton
	var        eventTimelinePanel
	var        eventGrid
	array<var> eventButtons
	int        newEventLineIndex

	int        viewedChatTime
	bool       isChatEnabled
	var        chatTabButton
	var        chatPanel
	var        chatGrid
	array<var> chatButtons
	var        chatTextEntry
	var        chatSubmitButton
	var        newChatLineIndex
	int		   commBlockWarningId = -1

	bool hasNewEvents
	bool hasNewChat

	var joinRequestsPanel
	var joinRequestsButton
	var joinRequestsLabel
	var clubLobbySearchButton

	bool inputsRegistered = false

	bool clubQueryCompleted = false

	                                            
} file
void function InitClubLandingPanel( var panel )

{
	file.panel = panel
	file.lobbyMenu = Hud_GetParent( panel )
	SetPanelTabTitle( panel, "#LOBBY_CLUBS" )
	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, ClubLandingPanel_OnShow )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, ClubLandingPanel_OnHide )

	RegisterSignal( REFRESH_LANDING_SIGNAL )

	                                      
	          
	                                      

	AddCallback_OnClubQuerySuccessful( CLUB_OP_GET_CURRENT, ClubLanding_OnGetCurrentCompleted )

	file.spinnerPanel = Hud_GetChild( panel, "ClubLobbySpinner" )

	                                      
	                 
	                                      

	file.discoveryPanel = Hud_GetChild( panel, "ClubDiscoveryPanel" )
	file.discoveryBlurb = Hud_GetChild( file.discoveryPanel, "BlurbLabel" )

	file.discoveryButtonBlocker = Hud_GetChild( file.discoveryPanel, "LevelReqButtonBlocker" )

	file.discoverySearchButton = Hud_GetChild( file.discoveryPanel, "ClubSearchButton" )
	HudElem_SetRuiArg( file.discoverySearchButton, "buttonText", "#LOBBY_CLUBS_SEARCH" )
	HudElem_SetRuiArg( file.discoverySearchButton, "buttonDescText", "#LOBBY_CLUBS_SEARCH_DESC" )
	                                                                                                   
	Hud_AddEventHandler( file.discoverySearchButton, UIE_CLICK, ClubSearchButton_OnActivate )

	file.discoveryCreateButton = Hud_GetChild( file.discoveryPanel, "ClubCreateButton" )
	HudElem_SetRuiArg( file.discoveryCreateButton, "buttonText", "#LOBBY_CLUBS_CREATE" )
	HudElem_SetRuiArg( file.discoveryCreateButton, "buttonDescText", "#LOBBY_CLUBS_CREATE_DESC" )
	                                                                                                   
	Hud_AddEventHandler( file.discoveryCreateButton, UIE_CLICK, ClubCreationButton_OnActivate )

	file.discoverySearchCycleButton = Hud_GetChild( file.discoveryPanel, "CasualFilterButton" )
	HudElem_SetRuiArg( file.discoverySearchCycleButton, "buttonText", "#CLUB_DISCOVERY_BUTTON" )
	Hud_AddEventHandler( file.discoverySearchCycleButton, UIE_CLICK, RefreshDiscoverySearch )

	                                                                                               
	                                                                                                  
	                                                                                          

	file.clubInvitesButton = Hud_GetChild( file.discoveryPanel, "ClubInvitesButton" )
	HudElem_SetRuiArg( file.clubInvitesButton, "buttonText", "#CLUB_INVITES_BUTTON_NOCOUNT" )
	Hud_AddEventHandler( file.clubInvitesButton, UIE_CLICK, DisplayClubInvites )
	Hud_SetLocked( file.clubInvitesButton, true )
	Hud_SetEnabled( file.clubInvitesButton, false )

	file.discoverySearchResultsGrid = Hud_GetChild( file.discoveryPanel, "DiscoverySearchResultsGrid" )

	                                      
	             
	                                      

	RegisterSignal( CLUB_NEWNESS_SIGNAL )

	file.lobbyPanel = Hud_GetChild( panel, "ClubLobbyPanel" )
	file.lobbyClubDetails = Hud_GetChild( file.lobbyPanel, "ClubDetailsPanel" )
	file.lobbyClubDetailsRankTooltipPanel = Hud_GetChild( file.lobbyPanel, "ClubDetailsRankTooltip" )
	file.lobbyClubDetailsPrivacyTooltipPanel = Hud_GetChild( file.lobbyPanel, "ClubDetailsPrivacyTooltip" )
	file.lobbyClubDetailsReqsTooltipPanel = Hud_GetChild( file.lobbyPanel, "ClubDetailsReqsTooltip" )
	file.adminControls = Hud_GetChild( file.lobbyPanel, "ClubAdminControlsPanel" )

	file.editClubButton = Hud_GetChild( file.adminControls, "EditClubButton" )
	HudElem_SetRuiArg( file.editClubButton, "buttonText", Localize( "#LOBBY_CLUBS_EDIT_SUBMIT" ) )
	Hud_AddEventHandler( file.editClubButton, UIE_CLICK, EditClubButton_OnActivate )

	file.manageUsersButton = Hud_GetChild( file.adminControls, "ManageUsersButton" )
	HudElem_SetRuiArg( file.manageUsersButton, "buttonText", Localize( "#CLUB_MEMBERS_EDIT_NAME" ) )
	Hud_AddEventHandler( file.manageUsersButton, UIE_CLICK, ManageUsersButton_OnActivate )

	file.viewAnnouncementButton = Hud_GetChild( file.lobbyClubDetails, "ViewAnnouncementButton" )
	HudElem_SetRuiArg( file.viewAnnouncementButton, "buttonText", Localize( "#CLUB_ANNOUNCEMENT_VIEW_BUTTON" ) )
	Hud_AddEventHandler( file.viewAnnouncementButton, UIE_CLICK, ViewAnnouncementButton_OnActivate )

	file.submitAnnouncementButton = Hud_GetChild( file.adminControls, "SubmitAnnouncementButton" )
	HudElem_SetRuiArg( file.submitAnnouncementButton, "buttonText", Localize( "#CLUB_ANNOUNCEMENT_SUBMIT_BUTTON" ) )
	Hud_AddEventHandler( file.submitAnnouncementButton, UIE_CLICK, SubmitAnnouncemntButton_OnActivate )

	file.eventTimelinePanel = Hud_GetChild( file.lobbyPanel, "ClubEventTimelinePanel" )

	file.chatPanel = Hud_GetChild( file.lobbyPanel, "ClubChatPanel" )
	file.chatTextEntry = Hud_GetChild( file.chatPanel, "TextEntryChat" )
	file.chatSubmitButton = Hud_GetChild( file.chatPanel, "SubmitChatButton" )
	HudElem_SetRuiArg( file.chatSubmitButton, "buttonText", "#CLUB_CHAT_SEND" )
	Hud_AddEventHandler( file.chatSubmitButton, UIE_CLICK, SubmitChatButton_OnClick )

	file.lobbyMemberListPanel = Hud_GetChild( file.lobbyPanel, "ClubMemberListPanel" )
	file.lobbyMemberListHeader = Hud_GetChild( file.lobbyPanel, "ClubMemberListHeader" )
	file.inviteReasonSelector = Hud_GetChild( file.lobbyPanel, "InviteReasonSwitch" )
	AddButtonEventHandler( file.inviteReasonSelector, UIE_CHANGE, InviteReasonSelector_OnChanged )
	file.inviteAllToPartyButton = Hud_GetChild( file.lobbyPanel, "InviteAllToPartyButton" )
	HudElem_SetRuiArg( file.inviteAllToPartyButton, "buttonText", Localize( "#LOBBY_CLUBS_LOBBY_PARTY_INVITE_ALL" ) )
	Hud_AddEventHandler( file.inviteAllToPartyButton, UIE_CLICK, InviteAllToPartyButton_OnClick )
	file.memberListMapNeedsReset = true

	file.joinRequestsPanel = Hud_GetChild( file.lobbyPanel, "JoinRequestsPanel" )
	file.joinRequestsButton = Hud_GetChild( file.joinRequestsPanel, "JoinRequestsButton" )
	HudElem_SetRuiArg( file.joinRequestsButton, "buttonText", Localize( "#CLUB_JOIN_REQUEST_VIEW" ) )
	Hud_AddEventHandler( file.joinRequestsButton, UIE_CLICK, JoinRequestsButton_OnClick )

	file.clubLobbySearchButton = Hud_GetChild( file.joinRequestsPanel, "ClubSearchButton" )
	HudElem_SetRuiArg( file.clubLobbySearchButton, "buttonText", Localize( "LOBBY_CLUBS_SEARCH_BUTTON" ) )
	Hud_AddEventHandler( file.clubLobbySearchButton, UIE_CLICK, ClubSearchButton_OnClick )

	file.joinRequestsLabel = Hud_GetChild( file.joinRequestsPanel, "JoinRequestsLabel" )

	SetClubFooterOptions( file.panel )
	SetClubFooterOptions( file.eventTimelinePanel )
	SetClubFooterOptions( file.chatPanel )

	AddCallback_OnClubDataUpdated( ClubLanding_BeginLandingRefresh )
}


void function SetClubFooterOptions( var panel )
{
	AddPanelFooterOption( panel, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )

	AddPanelFooterOption( panel, LEFT, BUTTON_BACK, true, "#LOBBY_CLUBS_LEAVE", "#LOBBY_CLUBS_LEAVE_PC", LeaveCurrentClub, CanUserLeaveClub )

	AddPanelFooterOption( panel, RIGHT, BUTTON_Y, true, "#FIND_CLUBMEMBERS_CONSOLE", "#FIND_CLUBMEMBERS_PC", OpenFindClubMemberDialog, CanUserInviteClubMembers )
}


bool function IsClubLandingPanelCurrentlyTopLevel()
{
	return GetActiveMenu() == GetMenu( "LobbyMenu" ) && IsPanelActive( file.panel )
}


var function GetClubDiscoveryPanel()
{
	return file.discoveryPanel
}


var function GetClubLobbyPanel()
{
	return file.lobbyPanel
}


void function ClubLandingPanel_OnShow( var panel )
{
	printf( "ClubLandingPanel_OnShow" )
	if ( IsFullyConnected() )
	{
		Clubs_UpdateMyData()
		ClubLanding_InitializeClubTabs()
	}

	ClubLanding_UpdateUIPresentation()

	RegisterInputs()
	UpdateFooterOptions()
}


void function ClubLanding_InitializeClubTabs()
{
	if ( !file.tabsInitialized  && ( ClubIsValid() || !GetConVarBool( "Clubs_oldJoinFlow" )  ) ) 
	{
		                                                               
		UpdateMenuBlur( file.lobbyPanel )

		TabData tabData = GetTabDataForPanel( file.lobbyPanel )
		tabData.centerTabs = true
		TabDef timelineTabDef = AddTab( file.lobbyPanel, Hud_GetChild( file.lobbyPanel, "ClubEventTimelinePanel" ), "#LOBBY_CLUBS_LOBBY_TIMELINE" )
		file.timelineTabButton = timelineTabDef.button
		Hud_AddEventHandler( file.timelineTabButton, UIE_CLICK, EventTabButton_OnClick )
		TabDef chatTabDef = AddTab( file.lobbyPanel, Hud_GetChild( file.lobbyPanel, "ClubChatPanel" ), "#LOBBY_CLUBS_LOBBY_CHAT" )
		file.chatTabButton = chatTabDef.button
		Hud_AddEventHandler( file.chatTabButton, UIE_CLICK, ChatTabButton_OnClick )
		ActivateTab( tabData, Tab_GetTabIndexByBodyName( tabData, TABPANEL_TIMELINE ) )
		file.tabsInitialized = true
	}


}


var function ClubLanding_GetLobbyPanel()
{
	return file.lobbyPanel
}


void function ClubLandingPanel_OnMenuGetTopLevel()
{
	if ( IsClubLandingPanelCurrentlyTopLevel() )
		Clubs_UpdateMyData()
	                              
}


void function ClubLanding_OnGetCurrentCompleted()
{
	if ( file.isWaitingForCurrent )
	{
		printf( "ClubQueryDebug: %s(): CLUB_OP_GET_CURRENT completed. Beginning landing refresh.", FUNC_NAME() )
		file.isWaitingForCurrent = false
		ClubLanding_BeginLandingRefresh()
	}
}


void function ClubLanding_BeginLandingRefresh()
{
	printf( "ClubQueryDebug: %s()", FUNC_NAME() )
	thread ClubLanding_RefreshLandingThread()
}


void function ClubLanding_RefreshLandingThread()
{
	Signal( uiGlobal.signalDummy, REFRESH_LANDING_SIGNAL )
	EndSignal( uiGlobal.signalDummy, REFRESH_LANDING_SIGNAL )

	bool isFullyConnected = false
	bool isItemFlavorRegFinished = false
	int currentOPState = Clubs_GetClubQueryState( CLUB_OP_GET_CURRENT )

	while ( isFullyConnected == false )
	{
		isFullyConnected = IsFullyConnected()
		WaitFrame()
	}

	while ( isItemFlavorRegFinished == false )
	{
		isItemFlavorRegFinished = IsItemFlavorRegistrationFinished()
		WaitFrame()
	}

	while ( currentOPState == eClubQueryState.FAILED || currentOPState == eClubQueryState.PROCESSING )
	{
		currentOPState = Clubs_GetClubQueryState( CLUB_OP_GET_CURRENT )
		WaitFrame()
	}

	OnThreadEnd(
		function() : ( isFullyConnected, isItemFlavorRegFinished, currentOPState )
		{
			if ( isFullyConnected && isItemFlavorRegFinished && currentOPState != eClubQueryState.FAILED && currentOPState != eClubQueryState.PROCESSING )
			{
				ClubLanding_RefreshLanding()
			}
		}
	)
}


void function ClubLanding_RefreshLanding()
{
	int currentOPState = Clubs_GetClubQueryState( CLUB_OP_GET_CURRENT )
	if ( currentOPState == eClubQueryState.FAILED || currentOPState == eClubQueryState.PROCESSING || Clubs_IsSwitchingClubs() )
	{
		file.lobbyIsShown = false
		Hud_Show( file.spinnerPanel )
		Hud_Hide( file.lobbyPanel )
		Hud_Hide( file.discoveryPanel )
		if ( !Clubs_IsSwitchingClubs() )
			file.isWaitingForCurrent = true
		return
	}
	else
	{
		Hud_Hide( file.spinnerPanel )
	}

	if ( Clubs_IsEnabled() && ClubIsValid() )
	{
		file.lobbyIsShown = true
		UpdateClubLobbyDetails()
		thread UpdateClubLobbyMemberList()
		thread UpdateClubLobbyTabsThread()

		thread QueryClubTabsForNewness()

		Hud_Show( file.lobbyPanel )
		Hud_Hide( file.discoveryPanel )
		UpdateFooterOptions()
	}
	else
	{
		file.lobbyIsShown = false
		UpdateBlurbTimeStamp()

		if ( Clubs_IsEnabled() )
		{
			LockDiscoveryMenu( false, -1 )

			bool isBelowMinLevel = Clubs_DoIMeetMinimumLevelRequirement() == false
			if ( isBelowMinLevel )
				LockDiscoveryMenu( isBelowMinLevel, eDiscoveryMenuLockReason.UNDERLEVEL )

			bool allowCrossplay = ClubGetHeader().allowCrossplay || !ClubIsMemberOnDifferentHardware()
			if ( !allowCrossplay )
				LockDiscoveryMenu( !allowCrossplay, eDiscoveryMenuLockReason.ALREADY_IN_CLUB )

			if ( !isBelowMinLevel && allowCrossplay && !Clubs_IsClubQueryProcessing( CLUB_OP_JOIN ) && !Clubs_IsClubQueryProcessing( CLUB_OP_CREATE ) )
				RefreshDiscoverySearch( null )
		}
		else
		{
			if ( PSNGetCommRestricted() )
			{
				array<ClubHeader> emptyResults
				UpdateDiscoveryGrid( emptyResults )
				LockDiscoveryMenu( true, eDiscoveryMenuLockReason.PSN_COMM_RESTRICTED )
			}
			else
			{
				LockDiscoveryMenu( true, eDiscoveryMenuLockReason.CLUBS_DISABLED )
			}
		}

		Hud_Hide( file.lobbyPanel )
		Hud_Show( file.discoveryPanel )
		UpdateFooterOptions()
	}

	ClubLanding_UpdateUIPresentation()
}


void function UpdateClubLobbyTabsThread()
{
	while ( !IsFullyConnected() )
		WaitFrame()

	while ( !file.tabsInitialized )
		WaitFrame()

	UpdateClubEventTimeline()
	UpdateClubChat()

	TabData tabData = GetTabDataForPanel( file.lobbyPanel )
	if ( IsTabActive( tabData ) == false )
	{
		if ( IsViewingTabPanel( TABPANEL_TIMELINE ) )
			ActivateTab( tabData, Tab_GetTabIndexByBodyName( tabData, TABPANEL_TIMELINE ) )
		else
			ActivateTab( tabData, Tab_GetTabIndexByBodyName( tabData, TABPANEL_CHAT ) )
	}
}


#if DEV
void function ClubLandingDev_JiggleTabs()
{
	TabData tabData = GetTabDataForPanel( file.lobbyPanel )

	if ( IsViewingTabPanel( TABPANEL_TIMELINE ) )
	{
		ActivateTab( tabData, Tab_GetTabIndexByBodyName( tabData, TABPANEL_CHAT ) )
		ActivateTab( tabData, Tab_GetTabIndexByBodyName( tabData, TABPANEL_TIMELINE ) )
	}
	else
	{
		ActivateTab( tabData, Tab_GetTabIndexByBodyName( tabData, TABPANEL_TIMELINE ) )
		ActivateTab( tabData, Tab_GetTabIndexByBodyName( tabData, TABPANEL_CHAT ) )
	}
}


bool function ClubLandingDev_IsTimelineEnabled()
{
	TabData tabData = GetTabDataForPanel( file.lobbyPanel )
	return IsTabIndexEnabled( tabData, 0 )
}


bool function ClubLandingDev_IsTimelineVisible()
{
	TabData tabData = GetTabDataForPanel( file.lobbyPanel )
	return IsTabIndexVisible( tabData, 0 )
}


bool function ClubLandingDev_IsTimelineActive()
{
	return IsTabPanelActive( TABPANEL_TIMELINE )
}


bool function ClubLandingDev_IsTabActive()
{
	TabData tabData = GetTabDataForPanel( file.lobbyPanel )
	return IsTabActive( tabData )
}


bool function ClubLandingDev_AreTabsInitialized()
{
	return file.tabsInitialized
}


void function ClubLandingDev_ActivateTimeline()
{
	TabData tabData = GetTabDataForPanel( file.lobbyPanel )
	ActivateTab( tabData, Tab_GetTabIndexByBodyName( tabData, TABPANEL_TIMELINE ) )
}
#endif


void function ClubLanding_InitHistory()
{
	while ( !IsFullyConnected() )
		WaitFrame()

	while ( !file.tabsInitialized )
		WaitFrame()

	UpdateClubEventTimeline()
	UpdateClubChat()
}


void function ClubLanding_UpdateUIPresentation()
{
	if ( !IsClubLandingPanelCurrentlyTopLevel() )
		return

	if ( ClubIsValid() && !PSNGetCommRestricted() )
		UI_SetPresentationType( ePresentationType.CLUB_LANDING )
	else
		UI_SetPresentationType( ePresentationType.CLUB_DISCOVERY )
}



void function ClubLandingPanel_OnHide( var panel )
{
	file.lobbyIsShown = false
	DeregisterInputs()
}


void function RegisterInputs()
{
	if ( file.inputsRegistered )
		return

	RegisterButtonPressedCallback( KEY_ENTER, OnClubLobby_FocusChat )
	RegisterButtonPressedCallback( KEY_PAD_ENTER, OnClubLobby_FocusChat )
	file.inputsRegistered = true
}


void function DeregisterInputs()
{
	if ( !file.inputsRegistered )
		return

	DeregisterButtonPressedCallback( KEY_ENTER, OnClubLobby_FocusChat )
	DeregisterButtonPressedCallback( KEY_PAD_ENTER, OnClubLobby_FocusChat )
	file.inputsRegistered = false
}

                                                                                                               
  
                                                                                                                                                                                                                                                                                  
                                                                                                                                                                                                                                                                                                    
                                                                                                                                                                                                                                                               
                                                                                                                                                                                                                                                              
                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                 
  
                                                                                                               


void function LockDiscoveryMenu( bool isLocked, int reason )
{
	string reasonString = ""
	switch ( reason )
	{
		case eDiscoveryMenuLockReason.ALREADY_IN_CLUB:
			reasonString = "#CLUB_DISCOVERY_BUTTON_BLOCKER_ALREADYINACLUB"
			break
		case eDiscoveryMenuLockReason.CLUBS_DISABLED:
			reasonString = "#CLUB_DISCOVERY_BUTTON_BLOCKER_DISABLED"
			break
		case eDiscoveryMenuLockReason.PSN_COMM_RESTRICTED:
			reasonString = "#CLUB_DISCOVERY_DISABLED_ACCOUNT_RESTRICTED"
			break
		default:
			reasonString = "#CLUB_DISCOVERY_BUTTON_BLOCKER"
			break
	}
	
	Hud_SetVisible( file.discoveryButtonBlocker, isLocked )
	HudElem_SetRuiArg( file.discoveryButtonBlocker, "blockerText", reasonString )

	bool isEnabled = !isLocked
	Hud_SetEnabled( file.discoverySearchButton, isEnabled )
	Hud_SetEnabled( file.discoveryCreateButton, isEnabled )
	Hud_SetEnabled( file.discoverySearchCycleButton, isEnabled )
	Hud_SetEnabled( file.clubInvitesButton, isEnabled )

	Hud_SetLocked( file.discoverySearchButton, isLocked )
	Hud_SetLocked( file.discoveryCreateButton, isLocked )
	Hud_SetLocked( file.discoverySearchCycleButton, isLocked )
	Hud_SetLocked( file.clubInvitesButton, isLocked )
}


void function ClubSearchButton_OnActivate( var button )
{
	if ( !IsConnected() )
		return

	OpenClubSearchMenu()
}


void function ClubCreationButton_OnActivate( var button )
{
	if ( !CanCreateAClub() )
		return

	OpenClubCreationMenu()
}


bool function CanCreateAClub()
{
	if ( !IsConnected() )
		return false

	if ( !Clubs_IsEnabled() )
		return false

	return true
}


const string ORDER_RECEIVED_DATETIME = "2020-08-16 00:00:00 -08:00"
const int BLURB_FAILSAFE_NUM = 1951023600
void function UpdateBlurbTimeStamp()
{
	int originDateUnixTime = expect int(DateTimeStringToUnixTimestamp( ORDER_RECEIVED_DATETIME ))

	int currentUnixTime
	if ( IsFullyConnected() )
		currentUnixTime = GetUnixTimestamp()
	else
		currentUnixTime = BLURB_FAILSAFE_NUM

	int difference = currentUnixTime - originDateUnixTime
	TimeParts timeParts = GetUnixTimeParts( difference )

	HudElem_SetRuiArg( file.discoveryBlurb, "daysCount", timeParts.day )
}


void function RefreshDiscoverySearch( var button )
{
	printf( "DiscoverySearchDebug: %s()", FUNC_NAME() )
	array<ItemFlavor> emptyArray
	Clubs_Search( "", "", CLUB_PRIVACY_SEARCH_ANY, 0, 0, emptyArray, 54, false )
	ClubInviteQueryClubsList( 0, 9 )

	if ( button != null )
	{
		file.timeSinceLastDiscoverySearch = UITime()
		                                           
		ClubDiscovery_SetCycleDiscoveryButtonEnabled( false )
	}
}


void function ClubDiscovery_SetCycleDiscoveryButtonEnabled( bool doEnable )
{
	Hud_SetEnabled( file.discoverySearchCycleButton, doEnable )
	Hud_SetLocked( file.discoverySearchCycleButton, !doEnable )
}


const float DISCOVERY_REFRESH_DEBOUNCE_SECONDS = 1.0
void function RefreshCycleButtonDebounceThread()
{
	Hud_SetEnabled( file.discoverySearchCycleButton, false )
	Hud_SetLocked( file.discoverySearchCycleButton, true )

	while ( UITime() - file.timeSinceLastDiscoverySearch < DISCOVERY_REFRESH_DEBOUNCE_SECONDS )
		wait( 1.0 )

	Hud_SetEnabled( file.discoverySearchCycleButton, true )
	Hud_SetLocked( file.discoverySearchCycleButton, false )
}


void function ClubDiscovery_ProcessSearchResults()
{
	                                                   
	if ( GetActiveMenu() != file.lobbyMenu )
		return

	array<ClubHeader> searchResults = ClubGetSearchResults()
	searchResults.randomize()
	array<ClubHeader> displayResults
	int displayCount = searchResults.len() >= CLUB_LANDING_SEARCH_RESULT_MAX ? CLUB_LANDING_SEARCH_RESULT_MAX : searchResults.len()
	for ( int i = 0; i < displayCount; i++ )
	{
		if ( Clubs_DoesMeetJoinRequirements( searchResults[i] ) )
			displayResults.append( searchResults[i] )
	}

	                                                                                                                         

	file.isDisplayingInvites = false
	file.declinedClubs.clear()
	UpdateDiscoveryGrid( displayResults )

	ClubDiscovery_SetCycleDiscoveryButtonEnabled( true )
}


void function ClubDiscovery_ProcessInvitesAndRefreshDisplay()
{
	if ( GetActiveMenu() != file.lobbyMenu )
		return

	waitthread ClubDiscovery_ProcessClubInvites()

	if ( file.isDisplayingInvites )
		DisplayClubInvites( null )
}


void function ClubDiscovery_ProcessClubInvites()
{
	                                                   
	if ( GetActiveMenu() != file.lobbyMenu )
		return

	file.clubInvites.clear()

	if ( !Clubs_DoIMeetMinimumLevelRequirement() )
		return

	file.clubInvites.extend( ClubGetInvitedClubsList() )

	                                                                                                
	HudElem_SetRuiArg( file.clubInvitesButton, "buttonText", Localize( "#CLUB_INVITES_BUTTON", file.clubInvites.len() ) )
	bool hasInvites = file.clubInvites.len() > 0
	Hud_SetLocked( file.clubInvitesButton, !hasInvites )
	Hud_SetEnabled( file.clubInvitesButton, hasInvites )
}


void function DisplayClubInvites( var button )
{
	                                                   
	if ( file.clubInvites.len() == 0 )
	{
		ClubDiscovery_ProcessSearchResults()
		return
	}

	                                                                                 
	array<ClubHeader> displayResults
	int displayCount = file.clubInvites.len() >= CLUB_LANDING_SEARCH_RESULT_MAX ? CLUB_LANDING_SEARCH_RESULT_MAX : file.clubInvites.len()
	for ( int i = 0; i < displayCount; i++ )
	{
		ClubHeader clubHeader
		clubHeader.clubID = file.clubInvites[i].clubID
		clubHeader.name = file.clubInvites[i].name
		displayResults.append( clubHeader )
	}

	                                                                                                                  
	file.isDisplayingInvites = true
	UpdateDiscoveryGrid( displayResults, true )
	ProcessDeclinedInvites()
}


void function Discovery_UpdateDPadNav()
{
	if ( file.discoverySearchResultButtons.len() > 0 )
	{
		Hud_SetNavDown( file.discoverySearchCycleButton, file.discoverySearchResultButtons[0] )
		                                                                                      
		Hud_SetNavDown( file.clubInvitesButton, file.discoverySearchResultButtons[0] )

		Hud_SetNavUp( file.discoverySearchResultButtons[0], file.discoverySearchCycleButton )

		if ( file.discoverySearchResultButtons.len() >= 2 )
			Hud_SetNavUp( file.discoverySearchResultButtons[1], file.clubInvitesButton )
		if ( file.discoverySearchResultButtons.len() >= 3 )
			Hud_SetNavUp( file.discoverySearchResultButtons[2], file.clubInvitesButton )
	}
	else
	{
		Hud_SetNavDown( file.discoverySearchCycleButton, null )
		                                                      
		Hud_SetNavDown( file.clubInvitesButton, null )
	}
}


void function UpdateDiscoveryGrid( array<ClubHeader> displayResults, bool isShowingInvites = false )
{
	int buttonCount = displayResults.len()

	foreach ( var button in file.discoverySearchResultButtons )
	{
		Hud_RemoveEventHandler( button, UIE_CLICK, SearchResultButton_OnClick )
		Hud_RemoveEventHandler( button, UIE_CLICKRIGHT, SearchResultButton_OnClickRight )
	}
	if ( file.discoverySearchResultButtons.len() > buttonCount )
	{
		file.discoverySearchResultButtons.resize( buttonCount )
	}

	Hud_InitGridButtons( file.discoverySearchResultsGrid, buttonCount )
	var scrollPanel = Hud_GetChild( file.discoverySearchResultsGrid, "ScrollPanel" )
	for ( int btnIdx; btnIdx < buttonCount; btnIdx++ )
	{
		var button              = Hud_GetChild( scrollPanel, format( "GridButton%d", btnIdx ) )
		ClubHeader resultHeader = displayResults[btnIdx]

		if ( !file.discoverySearchResultButtons.contains( button ) )
			file.discoverySearchResultButtons.append( button )

		file.resultButtonToClubMap[ button ] <- resultHeader
		Clubs_InitSearchResultButton( button, resultHeader, isShowingInvites )
	}

	foreach ( var button in file.discoverySearchResultButtons )
	{
		Hud_AddEventHandler( button, UIE_CLICK, SearchResultButton_OnClick )
		Hud_AddEventHandler( button, UIE_CLICKRIGHT, SearchResultButton_OnClickRight )
	}

	Discovery_UpdateDPadNav()
}


void function SearchResultButton_OnClick( var button )
{
	bool isButtonMapped = (button in file.resultButtonToClubMap)
	if ( !isButtonMapped )
		return

	ClubHeader selectedClubHeader = file.resultButtonToClubMap[ button ]

	if ( !Clubs_DoesMeetJoinRequirements( selectedClubHeader ) )
	{
		if ( selectedClubHeader.privacySetting == CLUB_PRIVACY_OPEN_WITH_REQ )
		{
			EmitUISound( "UI_Menu_Deny" )
			Clubs_OpenErrorStringDialog( "#CLUB_OP_FAIL_JOIN_REQS" )
			return
		}
		else
		{
			EmitUISound( "UI_Menu_Accept" )
			Clubs_OpenJoinReqsConfirmDialog( selectedClubHeader )
			return
		}
	}

	file.selectedSearchResultButton = button

	printf( "ClubJoinDialogDebug: Confirming join this club - name: %s, tag: %s, privacy: %i, minLevel: %i, minRank: %i", selectedClubHeader.name, selectedClubHeader.tag, selectedClubHeader.privacySetting, selectedClubHeader.minLevel, selectedClubHeader.minRating )
	if ( file.isDisplayingInvites )
	{
		Clubs_OpenAcceptInviteConfirmationDialog( selectedClubHeader )
	}
	else
	{
		OpenClubJoinDialog( selectedClubHeader )
	}
}

var function ClubLanding_SearchResultButton_SetActionText( string actionString )
{
	printf( "ActionTextDebug: %s()", FUNC_NAME() )
	if ( file.selectedSearchResultButton == null )
		return
	printf( "ActionTextDebug: %s(): setting actionString to %s", FUNC_NAME(), actionString )

	HudElem_SetRuiArg( file.selectedSearchResultButton, "actionSendTime", ClientTime(), eRuiArgType.GAMETIME )
	HudElem_SetRuiArg( file.selectedSearchResultButton, "actionString", actionString )
}

void function SearchResultButton_OnMiddleClick( var button )
{
	bool isButtonMapped = (button in file.resultButtonToClubMap)
	if ( !isButtonMapped )
		return

	ClubHeader selectedClubHeader = file.resultButtonToClubMap[ button ]

	Clubs_OpenReportClubConfirmDialog( selectedClubHeader )
}

void function SearchResultButton_OnClickRight( var button )
{
	bool isButtonMapped = (button in file.resultButtonToClubMap)
	if ( !isButtonMapped )
		return

	ClubHeader selectedClubHeader = file.resultButtonToClubMap[ button ]
	if ( file.isDisplayingInvites )
	{
		file.declinedClubs.append( selectedClubHeader )

		ProcessDeclinedInvites()
		thread RefreshClubInviteDataThread()
		return
	}

	Clubs_OpenReportClubConfirmDialog( selectedClubHeader )
}

void function RefreshClubInviteDataThread()
{
	printf( "ClubDiscoveryDebug: %s()", FUNC_NAME() )
	foreach ( declinedClub in file.declinedClubs )
	{
		foreach ( invite in file.clubInvites )
		{
			if ( invite.clubID == declinedClub.clubID )
			{
				printf( "ClubDiscoveryDebug: %s(): Removing a declined invite from current club results", FUNC_NAME() )
				file.clubInvites.removebyvalue( invite )
			}
		}
	}

	printf( "ClubDiscoveryDebug: %s(): User has %i invites remaining", FUNC_NAME(), file.clubInvites.len() )
	if ( file.clubInvites.len() > 0 )
	{
		                                                                                                                            
		thread ClubDiscovery_ProcessInvitesAndRefreshDisplay()
	}
	else
	{
		                                                                                                                                
		ClubDiscovery_ProcessSearchResults()
	}

	wait( 1.0 )
	ClubInviteQueryClubsList( 0, 9 )
}

void function ProcessDeclinedInvites()
{
	foreach ( declinedClub in file.declinedClubs )
	{
		PIN_Club_DeclineInvite( declinedClub )
		ClubInviteDecline( declinedClub.clubID )
		SocialEvent_RemoveActiveClubInvite( declinedClub )
	}

	file.declinedClubs.clear()
}

                                                                                                               
  
                                                                                                                                                                                            
                                                                                                                                                                                                            
                                                                                                                                                                                         
                                                                                                                                                                                    
                                                                                                                                                                                                                         
                                                                                                                                                                                                         
  
                                                                                                               

void function UpdateClubLobbyDetails()
{
	printf( "ClubCreateDebug: UpdateClubLobbyDetails()" )

	ClubHeader myClubHeader = ClubGetHeader()
	var detailsDisplay      = Hud_GetChild( file.lobbyClubDetails, "ClubDetailsDisplay" )

	printf( "ClubLandingDebug: UpdateClubLobbyDetails(): ClubName: %s, ClubTag: %s, Privacy: %i, MinLvl: %i, MinRank: %i, Members: %i", myClubHeader.name, myClubHeader.tag, myClubHeader.privacySetting, myClubHeader.minLevel, myClubHeader.minRating, myClubHeader.memberCount )
	Clubs_PopulateClubDetails( myClubHeader, file.lobbyClubDetails )
	Clubs_ConfigureRankTooltip( file.lobbyClubDetailsRankTooltipPanel, ClubGetMyMemberRank() )
	Clubs_ConfigurePrivacyTooltip( file.lobbyClubDetailsPrivacyTooltipPanel, myClubHeader.privacySetting )
	Clubs_ConfigureMinLevelAndRankTooltip( file.lobbyClubDetailsReqsTooltipPanel, myClubHeader.privacySetting, myClubHeader.minLevel, myClubHeader.minRating )

	InitPartyInviteReasonSelector()
	ClubLanding_CleanReportAndInviteLists()

	thread Clubs_CheckClubPersistenceThread()
	Hud_SetVisible( file.viewAnnouncementButton, true )
	UpdateClubAdminButtons()
	UpdateJoinRequestsButton()
	ClubLanding_UpdateViewAnnouncementButton()
}


void function UpdateClubAdminButtons()
{
	int myRank = ClubGetMyMemberRank()
	if ( myRank >= CLUB_RANK_ADMIN )
	{
		Hud_SetVisible( file.editClubButton, true )
		Hud_SetVisible( file.manageUsersButton, true )
		Hud_SetVisible( file.submitAnnouncementButton, true )
	}
	else
	{
		Hud_SetVisible( file.editClubButton, false )
		Hud_SetVisible( file.manageUsersButton, false )
		Hud_SetVisible( file.submitAnnouncementButton, false )
	}
}


void function UpdateJoinRequestsButton()
{
	Hud_Show( file.joinRequestsPanel )
	if ( ClubGetMyMemberRank() >= CLUB_RANK_CAPTAIN )
	{
		if( IsValid( file.joinRequestsButton ) )
		{
			Hud_Show( file.joinRequestsButton )
			HudElem_SetRuiArg( file.joinRequestsButton, "buttonText", Localize( "#CLUB_JOIN_REQUEST_VIEW_COUNT", ClubJoinRequestsCount() ) )
		}
	}
	else
	{
		Hud_Hide( file.joinRequestsButton )
	}

	Hud_SetText( file.joinRequestsLabel, "" )
}


void function ClubLanding_UpdateViewAnnouncementButton()
{
	ClubEvent currentAnnouncement = ClubGetStickyNote()
	if ( currentAnnouncement.eventText == "" )
	{
		Hud_SetLocked( file.viewAnnouncementButton, true )
		Hud_SetEnabled( file.viewAnnouncementButton, false )
	}
	else
	{
		Hud_SetLocked( file.viewAnnouncementButton, false )
		Hud_SetEnabled( file.viewAnnouncementButton, true )
	}
}


array<string> function CreateSearchTagDetailsStrings( array<ItemFlavor> searchTags )
{
	array<string> searchTagStrings
	if ( searchTags.len() == 0 )
		return searchTagStrings

	string line00
	string line01
	for ( int i = 0; i < 3; i++ )
	{
		string tagString = Localize( ClubSearchTag_GetTagString( searchTags[i] ) )
		string inbetween = line00.len() > 0 ? ", " : ""
		line00 = line00 + inbetween + tagString
	}
	                                                                           

	if ( searchTags.len() > 3 )
	{
		for ( int i = 3; i < searchTags.len(); i++ )
		{
			string tagString = Localize( ClubSearchTag_GetTagString( searchTags[i] ) )
			string inbetween = line01.len() > 0 ? ", " : ""
			line01 = line01 + inbetween + tagString
		}
		                                                                              
	}

	searchTagStrings.append( line00 )
	searchTagStrings.append( line01 )

	return searchTagStrings
}


                                                                                        
  
                                                                                                                                                                                                                                   
                                                                                                                                                                                                                                               
                                                                                                                                                                                                                            
                                                                                                                                                                                                                            
                                                                                                                                                                                                                                  
                                                                                                                                                                                                                    
  
                                                                                        


enum eClubMemberHardwareType
{
	INVALID,
	DURANGO,
	PC,
	PS4,
	SWITCH,

	_count
}


void function ClubLobby_TryUpdatingMemberListForPresence( EadpPresenceData presence )
{
	if ( !presence.online )
	{
		if ( Clubs_IsEnabled() && ClubIsValid() )
			thread UpdateClubLobbyMemberList()
	}
	else
	{
		var memberButton
		ClubMember member
		foreach ( var playerButton, ClubMember clubMember in file.memberButtonToDataMap )
		{
			if ( clubMember.memberName == presence.name )
			{
				memberButton = playerButton
				member = clubMember
				break
			}
		}

		if ( memberButton == null )
		{
			if ( Clubs_IsEnabled() && ClubIsValid() )
				thread UpdateClubLobbyMemberList()
		}
		else
		{
			file.memberOnlineStatus[ member.memberID ] <- presence.online
			RefreshClubMemberPresence( presence, memberButton )
		}

	}
}


void function ClubLanding_ForceUpdateMemberList()
{
	thread UpdateClubLobbyMemberList()
}


void function UpdateClubLobbyMemberList()
{
	while( !file.tabsInitialized )
		WaitFrame()

	if ( CrossplayUserOptIn() )
	{
		while ( !EADP_SocialCanRun() )
			WaitFrame()
	}

	printf( "ClubLobbyDebug: UpdateClubLobbymemberList()" )

	if( !ClubIsValid() )
		return;
	  
	array<ClubMember> members = ClubGetMembers()
	members.sort( SortClubMembersByOnlinePresenceAndRank )

	var memberListGrid = Hud_GetChild( file.lobbyMemberListPanel, "MemberListGrid" )

	file.memberOnlineStatus.clear()

	int buttonCount = members.len()

	foreach ( var button in file.memberButtons )
	{
		Hud_RemoveEventHandler( button, UIE_CLICK, MemberButton_OnClick )
		                                                                             
	}

	if ( file.memberButtons.len() > buttonCount )
	{
		file.memberButtons.resize( buttonCount )
	}

	if ( file.memberListMapNeedsReset == true )
	{
		file.memberButtonToDataMap.clear()
		file.memberIdToButtonMap.clear()
		file.memberListMapNeedsReset = false
	}

	Hud_InitGridButtons( memberListGrid, buttonCount )
	var scrollPanel = Hud_GetChild( memberListGrid, "ScrollPanel" )
	
	for ( int memberIdx = 0; memberIdx < buttonCount; memberIdx++ )
	{
		var button    = Hud_GetChild( scrollPanel, format( "GridButton%d", memberIdx ) )
		int buttonIdx = file.memberButtons.find( button )
		if ( buttonIdx == -1 )
			file.memberButtons.append( button )

		file.memberButtonToDataMap[ button ] <- members[memberIdx]
		file.memberIdToButtonMap[ members[memberIdx].memberID ] <- button
	}

	foreach ( var button in file.memberButtons )
	{
		InitMemberButton( button )
	}

	UpdateMemberButtonSelectionIcons()
	RefreshOnlineMemberCount()
}


void function InitMemberButton( var button )
{
	ClubMember memberData = file.memberButtonToDataMap[button]
	var rui               = Hud_GetRui( button )


	string namePrefix
	if ( memberData.memberID == GetLocalClientPlayer().GetPINNucleusId() )
		namePrefix = Localize( "#CLUB_MEMBER_YOU" )
	RuiSetString( rui, "buttonText", (namePrefix + memberData.memberName) )
	RuiSetInt( rui, "buttonTextLength", memberData.memberName.len() )
	RuiSetInt( rui, "clubMemberRank", ClubGetMemberRankByID( memberData.memberID ) )

	if ( CrossplayUserOptIn() )
	{
		RuiSetString( rui, "platformString", PlatformIDToIconString( memberData.memberHardware ) )
	}

	bool buttonHandlerInitialized = (button in file.memberButtonHasInputHandler)
	if ( !buttonHandlerInitialized )
		file.memberButtonHasInputHandler[ button ] <- false

	Hud_AddEventHandler( button, UIE_CLICK, MemberButton_OnClick )
	                                                                          

	if ( file.memberButtonHasInputHandler[button] == false )
	{
		Hud_AddKeyPressHandler( button, MemberButton_OnKeyPress )
		file.memberButtonHasInputHandler[button] <- true
	}

	EadpPresenceData presence = EADP_GetPresenceForUser( memberData.memberID, memberData.memberHardware )
	file.memberOnlineStatus[ memberData.memberID ] <- presence.online

	RefreshClubMemberPresence( presence, button )

	HudElem_SetRuiArg( button, "startInviteIconFadeTime", file.memberInvitedTime, eRuiArgType.GAMETIME)
	RuiSetBool( rui, "isInvited", file.clubMemberInvitedList.contains( memberData.memberID ) )
	RuiSetBool( rui, "isReported", file.clubMemberReportedList.contains( memberData.memberID ) )

	ConfigureMemberButtonToolTip( button, memberData, presence )
}


void function ConfigureMemberButtonToolTip( var button, ClubMember memberData, EadpPresenceData presence )
{
	ToolTipData toolTipData
	toolTipData.tooltipStyle = eTooltipStyle.CLUB_MEMBER
	toolTipData.titleText = memberData.memberName
	                                                                         

	bool isMyToolTip = memberData.memberID == GetLocalClientPlayer().GetPINNucleusId()
	int memberRank = memberData.rank
	bool isOnline = presence.online
	bool isInGame = presence.ingame
	bool isInMatch = presence.partyInMatch

	toolTipData.clubMemberData.memberRank = memberRank
	toolTipData.clubMemberData.isOnline = isOnline
	toolTipData.clubMemberData.isInGame = isInGame
	toolTipData.clubMemberData.isInMatch = isInMatch

	if ( !isMyToolTip )
	{
		if ( isOnline )
		{
			if ( file.selectedClubMembersToInvite.contains( memberData.memberID )  )
				toolTipData.actionHint3 = Localize( "#CLUB_MEMBER_BUTTON_TOOLTIP_DESELECT" )
			else
				toolTipData.actionHint3 = Localize( "#CLUB_MEMBER_BUTTON_TOOLTIP_SELECT" )
		}

		toolTipData.actionHint2 = Localize( "#REPORT_CLUB_INTERNAL_BUTTON" )

		toolTipData.actionHint1 = Localize( "#Y_BUTTON_INSPECT" )
	}

	Hud_SetToolTipData( button, toolTipData )
}


void function RefreshOnlineMemberCount()
{
	if ( !ClubIsValid() )
		return

	int currentOnlineUsers = ClubLobby_GetOnlineMemberCount( true )
	int allUsers = ClubGetMembers().len()

	HudElem_SetRuiArg( file.lobbyMemberListHeader, "currentUsers", currentOnlineUsers )
	HudElem_SetRuiArg( file.lobbyMemberListHeader, "allUsers", allUsers )
}


int function SortClubMembersByOnlinePresenceAndRank( ClubMember a, ClubMember b )
{
	bool isALocalPlayer = a.memberID == GetLocalClientPlayer().GetPINNucleusId()
	bool isBLocalPlayer = b.memberID == GetLocalClientPlayer().GetPINNucleusId()

	EadpPresenceData aPresence = EADP_GetPresenceForUser( a.memberID, a.memberHardware )
	EadpPresenceData bPresence = EADP_GetPresenceForUser( b.memberID, b.memberHardware )

	bool isAOnline = isALocalPlayer ? true : aPresence.online
	bool isBOnline = isBLocalPlayer ? true : bPresence.online

	if ( isAOnline && !isBOnline )
		return -1
	if ( !isAOnline && isBOnline )
		return 1

	if ( a.rank > b.rank )
		return -1
	else if ( b.rank > a.rank )
		return 1

	return 0
}


void function RefreshClubMemberPresence( EadpPresenceData presence, var button )
{
	                                                                                                                                                                                                                                            

	if ( file.memberButtons.find( button ) == -1 )
	{
		Warning( "Clubs: Attempted to refresh club member presence for %s without a valid member list button to refresh", presence.name )
		return
	}

	var memberButton = null
	if ( button == null )
	{
		foreach ( var playerButton, ClubMember clubMember in file.memberButtonToDataMap )
		{
			if ( clubMember.memberName == presence.name )
			{
				memberButton = playerButton
				break
			}
		}
	}
	else
	{
		memberButton = button
	}

	Assert( memberButton )

	var rui               = Hud_GetRui( memberButton )
	ClubMember clubMember = file.memberButtonToDataMap[ memberButton ]
	bool isMe             = clubMember.memberID == GetLocalClientPlayer().GetPINNucleusId()
	if ( isMe )
	{
		                                                       
		RuiSetBool( rui, "isOnline", true )
		RuiSetBool( rui, "isInGame", true )
		RuiSetBool( rui, "partyInMatch", false )
		return
	}

	if ( presence.online )
	{
		RuiSetBool( rui, "isOnline", true )
		RuiSetBool( rui, "isInGame", presence.ingame )
		RuiSetBool( rui, "partyInMatch", presence.partyInMatch )
	}
	else
	{
		if ( file.clubMemberInvitedList.contains( clubMember.memberID ) )
		{
			file.clubMemberInvitedList.removebyvalue( clubMember.memberID )
			ConfigureMemberButtonToolTip( memberButton, clubMember, presence )
		}

		RuiSetBool( rui, "isOnline", false )
		RuiSetBool( rui, "isInGame", false )
		RuiSetBool( rui, "partyInMatch", false )
	}

	RuiSetBool( rui, "isInvited", file.clubMemberInvitedList.contains( clubMember.memberID ) )
	RuiSetBool( rui, "isReported", file.clubMemberReportedList.contains( clubMember.memberID ) )


	if ( file.selectedClubMembersToInvite.contains( clubMember.memberID ) )
	{
		bool shouldRemoveFromToInviteList
		Party myParty = GetParty()
		array<string> partyMemberUIDs
		foreach( PartyMember partyMember in myParty.members )
		{
			partyMemberUIDs.append( partyMember.eaid )
		}

		if ( partyMemberUIDs.contains( clubMember.memberID ) )
		{
			shouldRemoveFromToInviteList = true
		}

		if ( !presence.online || presence.partyInMatch )
		{
			shouldRemoveFromToInviteList = true
		}

		if ( shouldRemoveFromToInviteList )
		{
			file.selectedClubMembersToInvite.removebyvalue( clubMember.memberID )

			UpdateMemberButtonSelectionIcons()
			ConfigureMemberButtonToolTip( memberButton, clubMember, presence )
			UpdateInviteAllToPartyButton()
		}
	}
}


void function MemberButton_OnClick( var button )
{
	printf( "ClubMemberDebug: MemberButton_OnClick" )

	if ( Hud_IsLocked( button ) )
		return

	ClubMember clubMember = file.memberButtonToDataMap[ button ]

	if ( file.isInviteCooldownActive == false )
		MemberButton_ToggleInviteSelection( button )
}


void function MemberButton_OnMiddleClick( var button )
{
	printf( "ClubMemberListDebug: MemberButton_OnClick" )

	if ( Hud_IsLocked( button ) )
		return

	ClubMember clubMember = file.memberButtonToDataMap[ button ]

	if ( clubMember.memberID != GetLocalClientPlayer().GetPINNucleusId() )
	{
		PIN_Club_Invite( ClubGetHeader(), "party", clubMember.memberID )
		InviteClubMemberToParty( clubMember.memberID )
	}
}

const array<int> GENERIC_PARTY_INVITE_REASONS = [ eInviteReason.REASON_06_ANYMODE, eInviteReason.REASON_07_GRINDING ]
void function InitPartyInviteReasonSelector()
{
	if ( GENERIC_PARTY_INVITE_REASONS.contains( file.selectedPartyInviteReason ) )
		return

	int startingReason = GetPartyInviteReasonFromSelectedPlaylist()
	Hud_SetDialogListSelectionIndex( file.inviteReasonSelector, (startingReason - 1) )
}

void function InviteReasonSelector_OnChanged( var button )
{
	SetPartyInviteReason( Hud_GetDialogListSelectionIndex( file.inviteReasonSelector ) + 1 )
}

void function SetPartyInviteReason( int reasonIdx )
{
	printf( "PartyInviteDebug: %s(): Setting Selected Party Invite Reason to %s (Index %i)", FUNC_NAME(), SocialPopup_GetPartyInviteReasonString(reasonIdx), reasonIdx )
	file.selectedPartyInviteReason = reasonIdx
}

int function GetPartyInviteReasonFromSelectedPlaylist()
{
	string playlistName = Lobby_GetSelectedPlaylist()

	if ( playlistName.find( "duos" ) > -1 )
		return eInviteReason.REASON_02_DUOS

	if ( playlistName.find( "arenas" ) > -1 )
	{
		if ( GetPlaylistVarInt( playlistName, "is_ranked_game", 0 ) == 1 )
			return eInviteReason.REASON_04_RANKED
		else
			return eInviteReason.REASON_03_ARENAS
	}

	return eInviteReason.REASON_01_TRIOS
}

void function MemberButton_ToggleInviteSelection( var button )
{
	printf( "ClubMemberDebug: %s()", FUNC_NAME() )

	if ( Hud_IsLocked( button ) )
		return

	ClubMember clubMember = file.memberButtonToDataMap[ button ]

	if ( clubMember.memberID == GetLocalClientPlayer().GetPINNucleusId() )
		return

	EadpPresenceData presence = EADP_GetPresenceForUser( clubMember.memberID, clubMember.memberHardware )
	if ( presence.online == false )
		return

	if ( file.selectedClubMembersToInvite.contains( clubMember.memberID ) )
		file.selectedClubMembersToInvite.removebyvalue( clubMember.memberID  )
	else
		file.selectedClubMembersToInvite.append( clubMember.memberID )

	UpdateMemberButtonSelectionIcons()
	UpdateInviteAllToPartyButton()

	ConfigureMemberButtonToolTip( button, clubMember, presence )
}


void function ClearMembersSelectedForInvite()
{
	file.selectedClubMembersToInvite.clear()

	foreach ( button in file.memberButtons )
	{
		MemberButton_SetSelectedCheckmark( button, false )
		ClubMember member = file.memberButtonToDataMap[ button ]
		EadpPresenceData presence = EADP_GetPresenceForUser( member.memberID, member.memberHardware )
		ConfigureMemberButtonToolTip( button, member, presence )
	}

	UpdateInviteAllToPartyButton()
}


void function UpdateMemberButtonSelectionIcons()
{
	printf( "ClubMemberDebug: %s(): Updating icons for %i invited members", FUNC_NAME(), file.selectedClubMembersToInvite.len() )

	array< string > updatedSelectedMembersList

	foreach ( ID in file.selectedClubMembersToInvite )
	{
		foreach ( button in file.memberButtons )
		{
			ClubMember member = file.memberButtonToDataMap[ button ]
			if ( member.memberID == ID )
			{
				updatedSelectedMembersList.push( ID )
				break
			}
		}
	}

	file.selectedClubMembersToInvite = updatedSelectedMembersList

	foreach ( button in file.memberButtons )
	{
		ClubMember member = file.memberButtonToDataMap[ button ]

		bool isSelected = file.selectedClubMembersToInvite.contains( member.memberID )
		MemberButton_SetSelectedCheckmark( button, isSelected )
	}

	UpdateInviteAllToPartyButton()
}


void function MemberButton_SetSelectedCheckmark( var button, bool isSelected )
{
	HudElem_SetRuiArg( button, "isSelectedForInvite", isSelected )
}


void function InviteSelectedMembersToParty()
{
	if ( file.selectedPartyInviteReason == eInviteReason.REASON_00_NONE )
		file.selectedPartyInviteReason = Hud_GetDialogListSelectionIndex( file.inviteReasonSelector ) + 1

	if ( file.selectedClubMembersToInvite.len() == 0 )
	{
		InviteAllClubMembersToParty()
	}
	else
	{
		foreach( string memberID in file.selectedClubMembersToInvite )
		{
			InviteClubMemberToParty( memberID )
		}
	}
}


void function InviteClubMemberToParty( string memberID )
{
	printf( "ClubPartyInviteDebug: %s(): Inviting %s for reason index %i", FUNC_NAME(), memberID, file.selectedPartyInviteReason )
	EADP_InviteToPlayByEAID( memberID , file.selectedPartyInviteReason )

	var button = file.memberIdToButtonMap[ memberID ]
	MarkMemberAsInvited( button )

	                                                                                                       
	                                                                           

	                                                           
	  
	                                                                         
	                                                                         
	   
	             
	  	                                                                                                                                            
	  	                                                             
	  	 
	  		                                                  
	  	 
	  	    
	  	 
	  		      
	  	 
	       
	  	                                                      
	  	                                              
	        
	   
	                                
	   
	  	                                                                          
	   
}


void function InviteAllClubMembersToParty()
{
	if ( !ClubIsValid() )
		return

	array<ClubMember> clubMembers = ClubGetMembers()

	foreach ( member in clubMembers )
	{
		if ( file.memberOnlineStatus[ member.memberID ] == false )
			continue

		InviteClubMemberToParty( member.memberID )
	}
}


void function MemberButton_OnRightClick( var button )
{
	printf( "ClubMemberListDebug: MemberButton_OnRightClick()" )

	ClubMember clubMember = file.memberButtonToDataMap[ button ]

	if ( clubMember.memberID != GetLocalClientPlayer().GetPINNucleusId() )
	{
		OpenReportClubmateDialog( clubMember )
	}
}


void function UpdateInviteAllToPartyButton()
{
	if ( Hud_IsEnabled( file.inviteAllToPartyButton ) == false )
		return

	int selectedMemberCount = file.selectedClubMembersToInvite.len()
	printf( "ClubInviteDebug: %s(): updating button text for %i members to invite", FUNC_NAME(), selectedMemberCount )

	if ( selectedMemberCount > 1 )
		HudElem_SetRuiArg( file.inviteAllToPartyButton, "buttonText", Localize( "#LOBBY_CLUBS_PARTY_INVITE", selectedMemberCount ) )
	else if ( selectedMemberCount == 1 )
		HudElem_SetRuiArg( file.inviteAllToPartyButton, "buttonText", Localize( "#LOBBY_CLUBS_PARTY_INVITE_SINGLE" ) )
	else
		HudElem_SetRuiArg( file.inviteAllToPartyButton, "buttonText", Localize( "#LOBBY_CLUBS_LOBBY_PARTY_INVITE_ALL" ) )
}


void function InviteAllToPartyButton_OnClick( var button )
{
	file.memberInvitedTime = ClientTime()
	printf( "ClubInviteDebug: %s()", FUNC_NAME() )

	InviteSelectedMembersToParty()

	ClearMembersSelectedForInvite()
	UpdateInviteAllToPartyButton()

	thread InviteAllButtonDebounceThread()
}

const float INVITE_ALL_BUTTON_DEBOUNCE_TIME = 10.0
void function InviteAllButtonDebounceThread()
{
	Assert( IsNewThread(), "Must be threaded off" )

	file.isInviteCooldownActive = true
	Hud_SetEnabled( file.inviteAllToPartyButton, false )
	HudElem_SetRuiArg( file.inviteAllToPartyButton, "buttonText", Localize( "#LOBBY_CLUBS_INVITE_SENT" ) )

	float startTime = UITime()
	while ( UITime() < (startTime + INVITE_ALL_BUTTON_DEBOUNCE_TIME) )
	{
		wait( 0.5 )
	}

	file.selectedClubMembersToInvite.clear()
	file.clubMemberInvitedList.clear()
	file.isInviteCooldownActive = false
	Hud_SetEnabled( file.inviteAllToPartyButton, true )
	ClearMemberButtonInvitedBools()
	UpdateInviteAllToPartyButton()
}


void function MarkMemberAsInvited( var button )
{
	printf( "ClubInviteDebug: %s()", FUNC_NAME() )
	ClubMember member = file.memberButtonToDataMap[ button ]

	if ( member.memberID == GetLocalClientPlayer().GetPINNucleusId() )
		return

	if ( file.memberOnlineStatus[ member.memberID ] == false )
		return

	if ( file.clubMemberInvitedList.contains( member.memberID ) )
		return

	HudElem_SetRuiArg( button, "startInviteIconFadeTime", file.memberInvitedTime, eRuiArgType.GAMETIME)
	HudElem_SetRuiArg( button, "isInvited", true )
	file.clubMemberInvitedList.append( member.memberID )
}


void function ClearMemberButtonInvitedBools()
{
	foreach ( button in file.memberButtons )
	{
		HudElem_SetRuiArg( button, "isInvited", false )
	}
}


void function ClubLobby_MemberReported( ClubMember member )
{
	var memberButton
	foreach ( var button in file.memberButtons )
	{
		if ( file.memberButtonToDataMap[ button ] == member )
		{
			memberButton = button
			break
		}
	}
	if ( memberButton == null )
	{
		return
	}

	MarkMemberAsReported( memberButton )
}


void function MarkMemberAsReported( var button )
{
	ClubMember member = file.memberButtonToDataMap[ button ]

	if ( member.memberID == GetLocalClientPlayer().GetPINNucleusId() )
		return

	if ( file.clubMemberReportedList.contains( member.memberID ) )
		return

	HudElem_SetRuiArg( button, "isReported", true )
	file.clubMemberReportedList.append( member.memberID )
}


void function ClubLanding_CleanReportAndInviteLists()
{
	if ( !ClubIsValid() )
		return

	array<ClubMember> clubMembers = ClubGetMembers()
	array<string> memberIDs
	foreach ( member in clubMembers )
	{
		memberIDs.append( member.memberID )
	}

	foreach ( string invitedMemberID in file.clubMemberInvitedList )
	{
		if ( !memberIDs.contains( invitedMemberID ) )
			file.clubMemberInvitedList.removebyvalue( invitedMemberID )
	}

	foreach ( string reportedMemberID in file.clubMemberReportedList )
	{
		if ( !memberIDs.contains( reportedMemberID ) )
			file.clubMemberReportedList.removebyvalue( reportedMemberID )
	}
}


void function ClubLanding_ClearMemberLists()
{
	file.memberButtonToDataMap.clear()
	file.memberOnlineStatus.clear()
	file.clubMemberInvitedList.clear()
	file.clubMemberReportedList.clear()
	file.selectedClubMembersToInvite.clear()
}

bool function MemberButton_OnKeyPress( var button, int keyId, bool isDown )
{
	if ( !Clubs_IsEnabled() )
		return false

	if ( !ClubIsValid() )
		return false

	if ( !IsLobby() )
		return false

	if ( !isDown )
		return false

	switch ( keyId )
	{
		case KEY_F:
		case BUTTON_Y:
		case MOUSE_RIGHT:
		case BUTTON_STICK_RIGHT:
			break
		default:
			return false
	}

	bool isInspectInput = ( keyId == KEY_F || keyId == BUTTON_Y )
	bool isReportInput = ( keyId == MOUSE_RIGHT || keyId == BUTTON_STICK_RIGHT )

	if ( isInspectInput )
	{
		bool isButtonMapped = (button in file.memberButtonToDataMap)
		if ( !isButtonMapped )
			return false

		ClubMember clubMember = file.memberButtonToDataMap[ button ]

		if ( clubMember.memberID == GetLocalClientPlayer().GetPINNucleusId() )
			return false

		if ( clubMember.platformUserID == "" )
			return false

		Friend clubMemberToFriend
		clubMemberToFriend.name = clubMember.memberName
		clubMemberToFriend.id = clubMember.platformUserID
		clubMemberToFriend.hardware = GetNameFromHardware( clubMember.memberHardware )
		clubMemberToFriend.eadpData = CreateEADPDataFromEAID( clubMember.memberID )

		InspectFriendForceEADP( clubMemberToFriend, PCPlat_IsSteam() )
	}

	if ( isReportInput )
	{
		ClubMember clubMember = file.memberButtonToDataMap[ button ]

		if ( clubMember.memberID != GetLocalClientPlayer().GetPINNucleusId() )
		{
			OpenReportClubmateDialog( clubMember )
		}
	}

	return true
}

                                                                                        
  
                                                                                                                                                                 
                                                                                                                                                                       
                                                                                                                                                     
                                                                                                                                                       
                                                                                                                                                                     
                                                                                                                                                             
  
                                                                                        


void function EventTabButton_OnClick( var button )
{
	SetLastViewedChatTimeToNow()

	MarkLandingTabNewness( TABPANEL_TIMELINE, false )
	UpdateClubEventTimeline()
}


void function UpdateClubEventTimeline()
{
	array<ClubEvent> eventLog = FilterOldProgressEvents( ClubGetEventLog() )
	int newEventLineIndex = AttemptToInsertNewEventLine( eventLog, false )

	file.eventGrid = Hud_GetChild( file.eventTimelinePanel, "TimelineGrid" )

	int buttonCount = eventLog.len()

	if ( file.eventButtons.len() > buttonCount )
	{
		file.eventButtons.resize( buttonCount )
	}

	Hud_InitGridButtons( file.eventGrid, buttonCount )
	var scrollPanel = Hud_GetChild( file.eventGrid, "ScrollPanel" )

	for ( int eventIndex = 0; eventIndex < buttonCount; eventIndex++ )
	{
		var button = Hud_GetChild( scrollPanel, format( "GridButton%d", eventIndex ) )

		int buttonIdx = file.eventButtons.find( button )
		if ( buttonIdx == -1 )
		{
			file.eventButtons.append( button )
			buttonIdx = file.eventButtons.find( button )
		}

		bool isNewEventLine = (buttonIdx == newEventLineIndex) && (newEventLineIndex != -1)

		                                                                                                                                                                 
		ConfigureClubEventButton( eventLog[eventIndex], button, isNewEventLine )
	}

	for( int i = 0; i < file.eventButtons.len(); i++ )
	{
		var eventRui = Hud_GetRui( file.eventButtons[i] )

		bool isFirstEvent = (i-1 == newEventLineIndex)
		bool isLastEvent = (i == file.eventButtons.len() - 1) || (i+1 == newEventLineIndex)

		RuiSetBool( eventRui, "isFirstEvent", isFirstEvent )
		RuiSetBool( eventRui, "isLastEvent", isLastEvent )
	}
}

array<ClubEvent> function FilterOldProgressEvents( array<ClubEvent> eventLog )
{
	array<ClubEvent> newLog
	
	foreach ( event in eventLog )
	{
		if ( event.eventType == CLUB_EVENT_PROGRESS )
		{
			string text = event.eventText
			if ( text.find( ";%!;" ) > 0 )
				continue
		}
		newLog.push( event )
	}

	return newLog
}

void function ConfigureClubEventButton( ClubEvent clubEvent, var eventButton, bool isNewEventRule = false )
{
	var buttonRui = Hud_GetRui( eventButton )
	RuiSetBool( buttonRui, "isNewEventLine", isNewEventRule )

	if ( !isNewEventRule )
	{
		string description
		switch( clubEvent.eventType )
		{
			case CLUB_EVENT_KICK:
				description = Localize( GetStringForClubEvent( clubEvent ), clubEvent.memberName, clubEvent.eventText )
				break;

			case CLUB_EVENT_MATCH_COMPLETED:
				description = Localize( GetStringForClubEvent( clubEvent ), clubEvent.memberName, clubEvent.eventParam, Localize( clubEvent.eventText ) )
				break;

			case CLUB_EVENT_RANK_CHANGE:
				description = Localize( GetStringForClubEvent( clubEvent ), clubEvent.eventText, Clubs_GetClubMemberRankString( clubEvent.eventParam ), clubEvent.memberName )
				                                                                                                                                                                                                                               
				break;

			case CLUB_EVENT_REPORT:
				description = Localize( GetStringForClubEvent( clubEvent ), clubEvent.eventText, clubEvent.memberName, Localize( ClubRegulation_GetReasonString( clubEvent.eventParam ) ) )
				break;

			case CLUB_EVENT_PROGRESS:
				description = ProcessProgressEventString( clubEvent )
				break;

			default:
				description = Localize( GetStringForClubEvent( clubEvent ), clubEvent.memberName )
		}

		RuiSetString( buttonRui, "eventString", description )
		RuiSetInt( buttonRui, "eventType", clubEvent.eventType )

		int rank = clubEvent.eventParam
		RuiSetInt( buttonRui, "userRank", rank )

		string timeString = RLocalDateTime( clubEvent.eventTime )
		RuiSetString( buttonRui, "eventTimeString", timeString )
	}
}

string function ProcessProgressEventString( ClubEvent clubEvent )
{
	string eventString = StripNewLinesFromPlacementEvent( clubEvent.eventText )
	
	array<string> eventStrings = split( eventString, CLUB_EVENT_DELIMITER )
	if ( eventStrings.len() < 2 )
	{
		for( int i = 0; i < 2 - eventStrings.len(); i++ )
		{
			eventStrings.append( Localize( "#CLUB_EVENT_PROGRESS_UNKNOWN" ) )
		}
	}


	string placementString
	switch ( clubEvent.eventParam )
	{
		case 1:
			placementString = Localize( "#CLUB_EVENT_PROGRESS_FIRST" )
			break
		case 2:
			placementString = Localize( "#CLUB_EVENT_PROGRESS_SECOND" )
			break
		case 3:
			placementString = Localize( "#CLUB_EVENT_PROGRESS_THIRD" )
			break
		case 4:
			placementString = Localize( "#CLUB_EVENT_PROGRESS_FOURTH" )
			break
		case 5:
			placementString = Localize( "#CLUB_EVENT_PROGRESS_FIFTH" )
			break
	}

	string description = Localize( GetStringForClubEvent( clubEvent ), eventStrings[0], placementString, Localize( eventStrings[1] ) )
	                                                                              

	return description
}

string function StripNewLinesFromPlacementEvent( string eventString )
{
	int newLineIndex = eventString.find( "\n" )
	if ( newLineIndex == -1 )
		return eventString

	string sanitizedName = eventString.slice( 0, newLineIndex ) + " " + eventString.slice( newLineIndex + 1, eventString.len() )
	return sanitizedName
}

string function GetStringForClubEvent( ClubEvent clubEvent )
{
	array< string > eventStrings
	switch ( clubEvent.eventType )
	{
		case CLUB_EVENT_LEAVE:
			eventStrings.extend( EVENT_STRINGS_USER_LEFT )
			break

		case CLUB_EVENT_JOIN:
			eventStrings.extend( EVENT_STRINGS_USER_JOINED )
			break

		case CLUB_EVENT_KICK:
			eventStrings.extend( EVENT_STRINGS_USER_KICKED )
			break

		case CLUB_EVENT_MATCH_COMPLETED:
			eventStrings.push( "#CLUB_EVENT_MATCH_COMPLETED" )
			break

		case CLUB_EVENT_RANK_CHANGE:
			eventStrings.extend( EVENT_STRINGS_USER_PROMOTED )
			break

		case CLUB_EVENT_REPORT:
			eventStrings.push( "#CLUB_EVENT_REPORT" )
			break

		case CLUB_EVENT_PROGRESS:
			eventStrings.extend( EVENT_STRINGS_MATCH_COMPLETED )
			break

		case CLUB_EVENT_EDIT:
			eventStrings.extend( EVENT_STRINGS_CLUB_CHANGED )
			break
			
		case CLUB_EVENT_USER_AUTOBLOCKED:
			return clubEvent.eventText                          
	}

	if ( eventStrings.len() == 0 )
		return "#CLUB_EVENT_ERROR_MISSING"

	return eventStrings.getrandom()
}


string function GetClubEventTimeString( int eventTime )
{
	                                
	if ( !IsFullyConnected() )
		return Localize( "#CLUB_EVENT_TIMESTAMP_HOURS", 0 )

	int fakeTimeDays   = GetFakeTimeInSeconds()
	int timeSinceEvent = GetUnixTimestamp() - fakeTimeDays - eventTime

	DisplayTime displayTime = SecondsToDHMS( timeSinceEvent )
	int months = int( floor( displayTime.days/30 ) )
	int weeks = int( floor( displayTime.days/7 ) )
	string timeString
	if ( months > 1 )
		timeString = Localize( "#CLUB_EVENT_TIMESTAMP_MONTHS", months )
	else if ( months == 1 )
		timeString = Localize( "#CLUB_EVENT_TIMESTAMP_MONTH" )
	else if ( weeks > 1 )
		timeString = Localize( "#CLUB_EVENT_TIMESTAMP_WEEKS", weeks )
	else if ( weeks == 1 )
		timeString = Localize( "#CLUB_EVENT_TIMESTAMP_WEEK" )
	else if ( displayTime.days > 1 )
		timeString = Localize( "#CLUB_EVENT_TIMESTAMP_DAYS", displayTime.days )
	else if ( displayTime.days == 1 )
		timeString = Localize( "#CLUB_EVENT_TIMESTAMP_DAY" )
	else if ( displayTime.hours > 1 )
		timeString = Localize( "#CLUB_EVENT_TIMESTAMP_HOURS", displayTime.hours )
	else if ( displayTime.hours == 1 )
		timeString = Localize( "#CLUB_EVENT_TIMESTAMP_HOUR" )
	else if ( displayTime.minutes >= 5  )
		timeString = Localize( "#CLUB_EVENT_TIMESTAMP_MINUTES", displayTime.minutes )
	else
		timeString = Localize( "#CLUB_EVENT_TIMESTAMP_JUSTNOW" )

	return timeString
}


                                                                                        
  
                                                                                            
                                                                                                  
                                                                             
                                                                             
                                                                               
                                                                             
  
                                                                                        


void function ChatTabButton_OnClick( var button )
{
	SetLastViewedTimelineTimeToNow()

	MarkLandingTabNewness( TABPANEL_CHAT, false )
	UpdateClubChat()
}


void function UpdateClubChat()
{
	array<ClubEvent> chatLog = ClubGetChatLog()
	int newEventLineIndex    = AttemptToInsertNewEventLine( chatLog, true )
	printf( "ClubChatDebug: %s(): Inserting a new line at %i", FUNC_NAME(), newEventLineIndex )

	var commBlockWarning = Hud_GetChild( file.chatPanel, "CommBlockWarning" )
	if( file.commBlockWarningId != -1 )
	{
		int fullHeight = Hud_GetBaseHeight( file.chatPanel )
#if NX_PROG
		Hud_SetHeight( commBlockWarning , fullHeight * 0.3 )
#else
		Hud_SetHeight( commBlockWarning , fullHeight * 0.15 )
#endif
		var commBlockRui = Hud_GetRui( commBlockWarning )
		RuiSetInt( commBlockRui, "ruiStyle", file.commBlockWarningId )
		string warningString = GetCommunicationBlockWarningText( file.commBlockWarningId )
		RuiSetString( commBlockRui, "message", warningString.slice(3) )
		printf( "ClubChatDebug: Set communication block state id %d", file.commBlockWarningId )
	} else
		Hud_SetHeight( commBlockWarning , 0)

	file.chatGrid = Hud_GetChild( file.chatPanel, "ChatGrid" )
	int buttonCount = chatLog.len()

	if ( file.chatButtons.len() > buttonCount )
	{
		file.chatButtons.resize( buttonCount )
	}

	Hud_InitGridButtons( file.chatGrid, buttonCount )
	var scrollPanel = Hud_GetChild( file.chatGrid, "ScrollPanel" )

	for ( int chatIndex = 0; chatIndex < buttonCount; chatIndex++ )
	{
		var button = Hud_GetChild( scrollPanel, format( "GridButton%d", chatIndex ) )

		int buttonIdx = file.chatButtons.find( button )
		if ( buttonIdx == -1 )
		{
			file.chatButtons.append( button )
			buttonIdx = file.chatButtons.find( button )
		}

		bool isNewEventLine = (buttonIdx == newEventLineIndex) && (newEventLineIndex != -1)

		ConfigureClubChatButton( chatLog[chatIndex], button, isNewEventLine )
	}

	if ( !IsPersistenceAvailable() )
		return
}


void function ConfigureClubChatButton( ClubEvent chatEvent, var button, bool isNewEventRule = false )
{
	var buttonRui = Hud_GetRui( button )
	RuiSetBool( buttonRui, "isNewEventLine", isNewEventRule )
	string chatstring = chatEvent.eventText

	if ( !isNewEventRule )
	{
		string timeString = RLocalTime( chatEvent.eventTime )
		RuiSetString( buttonRui, "chatTimeString", timeString )

		RuiSetString( buttonRui, "memberName", chatEvent.memberName )

		int rank = ClubGetMemberRankByID( chatEvent.memberID )
		RuiSetInt( buttonRui, "userRank", rank )

		RuiSetString( buttonRui, "chatString", chatstring )
	}
}


void function SubmitChatButton_OnClick( var button )
{
	ClubLobby_SendChat()
}


int function AttemptToInsertNewEventLine( array<ClubEvent> eventLog, bool isForChat = false )
{
	int lastViewedTime    = isForChat ? GetLastViewedChatTime() : GetLastViewedTimelineTime()

	ClubEvent ruleEvent
	int ruleIndex           = -1
	foreach ( event in eventLog )
	{
		if ( event.eventTime > lastViewedTime )
		{
			int eventIndex = eventLog.find( event )
			ruleIndex = eventIndex
			                                                                                                                                                           
			break
		}
	}
	if ( ruleIndex > 0 )
	{
		eventLog.insert( ruleIndex, ruleEvent )
	}
	else
	{
		return -1
	}

	return ruleIndex
}


void function MarkLandingTabNewness( string bodyName, bool isNew )
{
	while ( !file.tabsInitialized )
		WaitFrame()

	TabData tabData = GetTabDataForPanel( file.lobbyPanel )

	int tabIndex = Tab_GetTabIndexByBodyName( tabData, bodyName )

	if ( tabIndex == -1 )
		return

	bool canFlagAsNew = isNew && !IsViewingTabPanel( bodyName )

	if ( bodyName == TABPANEL_TIMELINE )
		file.hasNewEvents = canFlagAsNew
	if( bodyName == TABPANEL_CHAT )
		file.hasNewChat = canFlagAsNew

	UpdateClubTabNewness()

	var tabButton = tabData.tabButtons[tabIndex]
	var buttonRui = Hud_GetRui( tabButton )
	RuiSetBool( buttonRui, "isNew", canFlagAsNew )
}


bool function IsViewingTabPanel( string bodyName )
{
	if ( !file.tabsInitialized )
		return false

	TabData tabData = GetTabDataForPanel( file.lobbyPanel )
	int tabIndex    = Tab_GetTabIndexByBodyName( tabData, bodyName )
	if ( tabIndex == -1 )
		return false

	return (tabIndex == tabData.activeTabIdx)
}

bool function ClubLobby_IsViewingChat()
{
	return IsViewingTabPanel( TABPANEL_CHAT )
}

void function ClubLobby_SendChat()
{
	string chatMessage = Hud_GetUTF8Text( file.chatTextEntry )
	if ( chatMessage.len() > 0 )
	{
		string sanitizedString = chatMessage
		foreach( string illegalChar in ILLEGAL_CHAT_CHARS )
		{
			sanitizedString = RegexpReplace( sanitizedString, illegalChar, "" )
		}

		if ( sanitizedString.len() == 0 )
			return

		if ( !ClubChatSend( sanitizedString ) )
		{
			Hud_SetUTF8Text( file.chatTextEntry, "" )
			return
		}

		                                                                                             
		Hud_SetUTF8Text( file.chatTextEntry, "" )
	}

	Hud_SetFocused( file.chatTextEntry )
}


void function OnClubLobby_FocusChat( var panel )
{
	if ( IsDialog( GetActiveMenu() ) )
		return

	if ( !IsTabPanelActive( GetPanel( "ClubLandingPanel" ) ) )
		return

	if ( Hud_IsFocused( file.chatTextEntry ) )
		ClubLobby_SendChat()
	else
		Hud_SetFocused( file.chatTextEntry )
}


                                              
   
  	                                               
  
  	                                               
  	                     
  		      
  
  	            
  		               
  		 
  			                         
  			                         
  		 
  	 
  
  	                           
  	 
  		                                             
  		 
  			                                
  				                        
  
  			                                         
  
  			                                                                 
  		 
  
  		                                         
  		 
  			                                 
  				                         
  
  			                                        
  
  			                                                             
  		 
  
  		           
  	 
   

                                                                                        
  
                                                                                                                                                                                                                
                                                                                                                                                                                                                                    
                                                                                                                                                                                                                                  
                                                                                                                                                                                                                                    
                                                                                                                                                                                                                                   
                                                                                                                                                                                                                       
  
                                                                                        


void function EditClubButton_OnActivate( var button )
{
	OpenClubCreationMenu()
}


void function ManageUsersButton_OnActivate( var button )
{
	OpenClubMemberManagementMenu()
}

void function SubmitAnnouncemntButton_OnActivate( var button )
{
	OpenSubmitAnnouncementDialog()
}

void function ViewAnnouncementButton_OnActivate( var button )
{
	OpenViewAnnouncementDialog()
}


void function LeaveCurrentClub( var button )
{
	OpenClubLeaveDialog()
	                              
}


bool function CanUserLeaveClub()
{
	if ( !IsClubLandingPanelCurrentlyTopLevel() )
		return false

	if ( !ClubIsValid() )
		return false

	return true
}


bool function CanUserInviteClubMembers()
{
	if ( !EADP_SocialEnabled() )
		return false

	if ( !ClubIsValid() )
		return false

	if ( ClubGetMyMemberRank() < CLUB_RANK_CAPTAIN )
		return false

	if ( !IsClubLandingPanelCurrentlyTopLevel() )
		return false

	if ( IsSocialPopupActive() )
		return false

	return true
}


void function JoinRequestsButton_OnClick( var button )
{
	OpenJoinRequestsMenu()
}


void function ClubSearchButton_OnClick( var button )
{
	OpenClubSearchMenu()
}


                                                                                        
  
                                                                                                                                                                                                                                                         
                                                                                                                                                                                                                                                                 
                                                                                                                                                                                                                               
                                                                                                                                                                                                                               
                                                                                                                                                                                                                                         
                                                                                                                                                                                                                                     
  
                                                                                        


void function QueryClubTabsForNewness()
{
	Signal( uiGlobal.signalDummy, CLUB_NEWNESS_SIGNAL )
	EndSignal( uiGlobal.signalDummy, CLUB_NEWNESS_SIGNAL )

	bool threadComplete
	while ( !IsPersistenceAvailable() )
	{
		WaitFrame()
	}

	OnThreadEnd(
		function() : ( threadComplete )
		{
			if ( threadComplete == true )
				printf( "ClubNewness: Newness check completed" )
			else
				printf( "ClubNewness: Newness check terminated before completion" )
		}
	)

	int fakeTimeDays   = GetFakeTimeInSeconds()
	int currentTime = GetUnixTimestamp() - fakeTimeDays
	int lastViewedTimelineTime = GetLastViewedTimelineTime()
	int lastViewedChatTime = GetLastViewedChatTime()
	int mostRecentEventTime
	int mostRecentChatTime

	bool haveUnreadEvents
	bool haveUnreadChat

	array<ClubEvent> clubChat = ClubGetChatLog()
	foreach( ClubEvent event in clubChat )
	{
		if ( event.eventTime > lastViewedChatTime )
			haveUnreadChat = true

		if ( event.eventTime > mostRecentChatTime )
			mostRecentChatTime = event.eventTime
	}

	array<ClubEvent> clubEvents = ClubGetEventLog()
	foreach( ClubEvent event in clubEvents )
	{
		if ( event.eventTime > lastViewedTimelineTime )
		{
			                                                                                                                                
			haveUnreadEvents = true
		}

		if ( event.eventTime > mostRecentEventTime )
			mostRecentEventTime = event.eventTime
	}

	int isChatNew = haveUnreadChat ? 1 : 0
	int isTimelineNew = haveUnreadEvents ? 1 : 0
	                                                                                                          
	                                                                                                                                                                                                                                               

	thread MarkLandingTabNewness( TABPANEL_CHAT, haveUnreadChat )
	thread MarkLandingTabNewness( TABPANEL_TIMELINE, haveUnreadEvents )

	int prevStateID = file.commBlockWarningId
	file.commBlockWarningId = GetCommunicationBlockStateID()

	if( prevStateID != file.commBlockWarningId ){
		UpdateClubChat()
	}

	threadComplete = true
}


void function UpdateClubTabNewness()
{
	var clubPanel = GetPanel( "ClubLandingPanel" )

	bool hasNewContent = file.hasNewEvents == true || file.hasNewChat == true

	       
	                                                      
	                                                  
	                                                                                                                                     

	SetPanelTabNew( clubPanel, hasNewContent )
}


int function GetLastViewedChatTime()
{
	if ( !IsPersistenceAvailable() )
		return -1

	return GetPersistentVarAsInt( "clubLastViewedChatTime" )
}


void function SetLastViewedChatTimeToNow()
{
	if ( !IsPersistenceAvailable() || !Remote_ServerCallFunctionAllowed())
		return

	                                                     
	int fakeTimeDays   = GetFakeTimeInSeconds()
	int currentTime = GetUnixTimestamp() - fakeTimeDays

	printf( "ClubChatDebug: %s(): Setting last viewed chat time to %i", FUNC_NAME(), currentTime )
	                                                                                       
	Remote_ServerCallFunction( "ClientCallback_SetClubChatViewedTime", currentTime )
}


int function GetLastViewedTimelineTime()
{
	if ( !IsPersistenceAvailable() )
		return -1

	return GetPersistentVarAsInt( "clubLastViewedTimelineTime" )
}


void function SetLastViewedTimelineTimeToNow()
{
	if ( !IsPersistenceAvailable() || !Remote_ServerCallFunctionAllowed())
		return

	                                                     
	int fakeTimeDays = GetFakeTimeInSeconds()
	int currentTime = GetUnixTimestamp() - fakeTimeDays

	Remote_ServerCallFunction( "ClientCallback_SetClubTimelineViewedTime", currentTime )
}


int function GetLastViewedAnnouncementTime()
{
	if ( !IsPersistenceAvailable() || !Remote_ServerCallFunctionAllowed() )
		return -1

	return GetPersistentVarAsInt( "clubLastViewedAnnouncementTime" )
}


void function SetLastViewedAnnouncementTimeToNow()
{
	if ( !IsPersistenceAvailable()  || !Remote_ServerCallFunctionAllowed() )
		return

	int fakeTimeDays = GetFakeTimeInSeconds()
	int currentTime = GetUnixTimestamp() - fakeTimeDays

	Remote_ServerCallFunction( "ClientCallback_SetClubAnnouncementViewedTime", currentTime )
}

void function SetLastViewedAnnouncementTimeToNever()
{
	if ( !IsPersistenceAvailable() || !Remote_ServerCallFunctionAllowed() )
		return

	Remote_ServerCallFunction( "ClientCallback_SetClubAnnouncementViewedTime", -1 )
}

int function ClubLobby_GetOnlineMemberCount( bool includeLocalUser = false )
{
	if ( !IsConnected() )
		return 0

	if ( !GetLocalClientPlayer() )
		return 0

	if ( !ClubIsValid() )
		return 0

	int onlineCount
	array<ClubMember> clubMembers = ClubGetMembers()
	foreach ( member in clubMembers )
	{
		EadpPresenceData presence = EADP_GetPresenceForUser( member.memberID, member.memberHardware )
		if ( presence.online )
		{
			if ( includeLocalUser || (!includeLocalUser && member.memberID != GetLocalClientPlayer().GetPINNucleusId()) )
				onlineCount++
		}
	}

	return onlineCount
}

bool function PSNGetCommRestricted()
{
	return PSNCommRestricted
}

#if UI
void function UICodeCallback_SetCommRestricted( bool bRestricted )
{
	PSNCommRestricted = bRestricted
}
#endif