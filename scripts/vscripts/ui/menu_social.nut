global function InitSocialMenu
global function InitInspectMenu
global function InspectFriend
global function InspectFriendForceEADP

global function InitFriendsPanel
global function InitFriendsOtherPanel
global function InitFriendRequestsPanel

global function InitSeasonSelectPopUp
global function InitModeSelectPopUp

global function ForceSocialMenuUpdate
global function IsMatchPreferenceFlagActive

global function ClientToUI_InviteToPlayByEAID

#if DEV
global function DebugDiscoverability
#endif      

const UPDATE_RATE = 1.0

#if NX_PROG
const MAX_NUMBER_OF_SEASONS_VISIBLE = 10
#else
const MAX_NUMBER_OF_SEASONS_VISIBLE = 15
#endif

enum ePageButtonType
{
	PAGE_INDEX
	PAGE_NEXT
	PAGE_PREV
}


struct PageButtonDef
{
	var button

	int pageButtonType
	int pageIndex
}

enum eSocialMenuState
{
	FRIENDS
	FRIENDS_OTHER
	FRIEND_REQUESTS
}


struct FriendListCallbacks
{
	bool functionref()                                                             isValid
	void functionref ( var panel, var button, int index )                          onClick
	bool functionref ( var panel, var button, int index, int keyId, bool isDown )  onKeyPress
	void functionref ( var panel, var button, int index )                          onClickRight
	void functionref ( var panel, var button, int index )                          onGetFocus
	void functionref ( var panel, var button, int index )                          bindCallback
	int functionref ()                                                             itemVisibleCountCallback
	int functionref ()                                                             itemTotalCountCallback
	void functionref ( var button )                                                buttonInitCallback
}


enum eEADPQueryState
{
	INVALID,
	RUNNING,
	COMPLETE,
}


enum eEADPQuery
{
	FRIENDS,
	FRIEND_REQUESTS,
	MUTE_LIST,
	BLOCK_LIST
}

struct EADPQueryData
{
	int                                queryState
	int functionref()                  doQuery = null
	EadpPeopleList functionref()       getQueryResult = null
	array< EadpPeopleData >            queryResult
	array< Friend >                    friends
}


struct
{
	var                menu
	array<Friend>      friends

	var myGridButton

	var leavePartyButton
	var crossPlayDenyButton
	var partyPrivacyButton
	var lastSquadInvitePrivacyButton
	var steamButton
	var gridSpinner

	FriendsData& friendsData
	Friend&      actionFriend
	var          actionButton
	bool 		 actionFriendForceEADP

	var	discoverabilityWarning

	FriendsData& friendsOtherData
	FriendsData& friendRequestData

	int panePageIndex = 0
	int pagerPageIndex = 0

	int cachedMatchPreferenceFlags = 0

	var friendGrid
	var decorationRui
	var menuHeaderRui

	array<var> pageButtons

	array<PageButtonDef> pageButtonDefs

	float nextFriendsListUpdate

	table<var, float> nextInviteTimes

	bool tabsInitialized = false

	int menuState = eSocialMenuState.FRIENDS
	int lastMenuState = -1

	table<int, FriendListCallbacks>    friendListCallbacksMap

	table<int, EADPQueryData>    eadpQueryDataMap

	float selfPresenceUpdateTime
	bool  canInviteSelf

	int friendDataChecksum
    
	float    SocialMenuUpdateTime = 0
} s_socialFile

const float SOCIALMENUUPDATE_INTERVAL  = 1.0

struct
{
	var menu
	var combinedCard

	var                      statsSummaryRui

	                    
	var                      statsModeButton
	var                      statsModeCloseButton
	var                      statsModePopUpMenu
	var                      statsModePopUp
	var						 statsModeList
	table< var, int >		 buttonToMode
	string					 selectedModeName
	int                      selectedGameMode

	                        
	var                      statsSeasonButton
	var                      statsSeasonCloseButton
	var                      statsSeasonPopUpMenu
	var                      statsSeasonPopUp
	var                      statsSeasonList
	table< var, ItemFlavor > buttonToSeason
	string                   selectedSeasonName
	string                   selectedSeasonGUID

	var  statTabsPanel
	var  statsSummaryPanel
	var  statsPerformancePanel
	var  careerStatsCard
	var  seasonStatsCard
	var  topLegendsStatsCard
	var  topWeaponsStatsCard
	var  graphStatsCard
	bool tabsInitialized = false

	var decorationRui
	var menuHeaderRui
	var altNameListRui

} s_inspectFile


#if NX_PROG
const int FRIEND_GRID_ROWS_NX_HANDHELD = 5
const int FRIEND_GRID_COLUMNS_NX_HANDHELD = 3
const int FRIEND_GRID_ROWS_NX_DOCK = 5
const int FRIEND_GRID_COLUMNS_NX_DOCK = 3
int FRIEND_GRID_ROWS = FRIEND_GRID_ROWS_NX_DOCK
int FRIEND_GRID_COLUMNS = FRIEND_GRID_COLUMNS_NX_DOCK
#else
const int FRIEND_GRID_ROWS = 7
const int FRIEND_GRID_COLUMNS = 3
#endif


void function InitSocialMenu( var newMenuArg )
                                              
{
	RegisterSignal( "HaltPreviewFriendCosmetics" )

	var menu = GetMenu( "SocialMenu" )
	s_socialFile.menu = menu

	s_socialFile.myGridButton = Hud_GetChild( menu, "MyGridButton" )
	Hud_AddKeyPressHandler( s_socialFile.myGridButton, MyFriendButton_OnKeyPress )

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, SocialMenu_OnOpen )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, SocialMenu_OnClose )

	AddMenuEventHandler( menu, eUIEvent.MENU_SHOW, SocialMenu_OnShow )

	AddMenuThinkFunc( menu, SocialMenuThink )

	var tabs = Hud_GetChild( menu, "TabsCommon" )
	Hud_Hide( tabs )

	s_socialFile.gridSpinner = Hud_GetChild( menu, "FriendGridBackground" )

	s_socialFile.discoverabilityWarning = Hud_GetChild( menu, "DiscoverabilityWarning" )

	s_socialFile.leavePartyButton = Hud_GetChild( menu, "LeavePartyButton" )
	HudElem_SetRuiArg( s_socialFile.leavePartyButton, "buttonText", "#LEAVE_PARTY" )
	HudElem_SetRuiArg( s_socialFile.leavePartyButton, "icon", $"rui/menu/common/leave_party" )
	Hud_AddEventHandler( s_socialFile.leavePartyButton, UIE_CLICK, OnLeavePartyButton_Activate )

	s_socialFile.crossPlayDenyButton = Hud_GetChild( menu, "CrossplayDenyButton" )
	HudElem_SetRuiArg( s_socialFile.crossPlayDenyButton, "buttonText", "#DISPLAY_CROSSPLAY" )
	HudElem_SetRuiArg( s_socialFile.crossPlayDenyButton, "icon", $"rui/menu/common/last_squad" )
	Hud_AddEventHandler( s_socialFile.crossPlayDenyButton, UIE_CLICK, OnCrossPlayDenyButton_Activate )

	s_socialFile.partyPrivacyButton = Hud_GetChild( menu, "PartyPrivacyButton" )
	HudElem_SetRuiArg( s_socialFile.partyPrivacyButton, "icon", $"rui/menu/common/party_privacy" )
	Hud_AddEventHandler( s_socialFile.partyPrivacyButton, UIE_CLICK, OnPartyPrivacyButton_Activate )

	s_socialFile.lastSquadInvitePrivacyButton = Hud_GetChild( menu, "LastSquadInvitePrivacyButton" )
	HudElem_SetRuiArg( s_socialFile.lastSquadInvitePrivacyButton, "icon", $"rui/menu/common/last_squad" )
	Hud_AddEventHandler( s_socialFile.lastSquadInvitePrivacyButton, UIE_CLICK, OnLastSquadInvitePrivacyButton_Activate )
	ToolTipData toolTipData
	toolTipData.descText = "#LAST_SQUAD_TOOLTIP"
	Hud_SetToolTipData( s_socialFile.lastSquadInvitePrivacyButton, toolTipData )

	#if PC_PROG
		s_socialFile.steamButton = Hud_GetChild( s_socialFile.menu, "SteamLink" )
		HudElem_SetRuiArg( s_socialFile.steamButton, "icon", $"rui/menu/common/steam_link" )
		Hud_AddEventHandler( s_socialFile.steamButton, UIE_CLICK, OnSteamLinkButton_Activate )
	#endif
	s_socialFile.menuHeaderRui = Hud_GetRui( Hud_GetChild( s_socialFile.menu, "MenuHeader" ) )
	s_socialFile.decorationRui = Hud_GetRui( Hud_GetChild( s_socialFile.menu, "Decoration" ) )
	s_socialFile.friendGrid    = Hud_GetChild( menu, "FriendGrid" )

	#if NX_PROG 
		UpdatePanelRowsAndColumns()
	#endif


	GridPanel_Init( s_socialFile.friendGrid, FRIEND_GRID_ROWS, FRIEND_GRID_COLUMNS, OnBindFriendListGridButton, GetFriendListVisibleCount, FriendListButtonInit )

	var buttonSizer = Hud_GetChild( s_socialFile.friendGrid, "GridButton0x0" )

	int baseWidth = Hud_GetBaseWidth( buttonSizer )

	GridPanel_InitStatic( s_socialFile.friendGrid, baseWidth, int( baseWidth * 0.2 ) )                                                                                 

	GridPanel_SetButtonHandler( s_socialFile.friendGrid, UIE_CLICK, void function( var panel, var button, int index ) : ()
	{
		s_socialFile.friendListCallbacksMap[SocialMenu_GetState()].onClick( panel, button, index )
	} )

	GridPanel_SetButtonHandler( s_socialFile.friendGrid, UIE_CLICKRIGHT, void function( var panel, var button, int index ) : ()
	{
		s_socialFile.friendListCallbacksMap[SocialMenu_GetState()].onClickRight( panel, button, index )
	} )

	GridPanel_SetKeyPressHandler( s_socialFile.friendGrid, bool function( var panel, var button, int index, int keyId, bool isDown ) : ()
	{
		return s_socialFile.friendListCallbacksMap[SocialMenu_GetState()].onKeyPress( panel, button, index, keyId, isDown )
	} )

	GridPanel_SetButtonHandler( s_socialFile.friendGrid, UIE_GET_FOCUS, void function( var panel, var button, int index ) : ()
	{
		s_socialFile.friendListCallbacksMap[SocialMenu_GetState()].onGetFocus( panel, button, index )
	} )

	Hud_SetNavLeft( Hud_GetChild( s_socialFile.friendGrid, "GridButton0x0" ), s_socialFile.myGridButton )
	Hud_SetNavLeft( Hud_GetChild( s_socialFile.friendGrid, "GridButton1x0" ), s_socialFile.partyPrivacyButton )
	Hud_SetNavLeft( Hud_GetChild( s_socialFile.friendGrid, "GridButton2x0" ), s_socialFile.leavePartyButton )
	Hud_SetNavLeft( Hud_GetChild( s_socialFile.friendGrid, "GridButton3x0" ), s_socialFile.lastSquadInvitePrivacyButton )
	Hud_SetNavLeft( Hud_GetChild( s_socialFile.friendGrid, "GridButton4x0" ), s_socialFile.crossPlayDenyButton )


	#if PC_PROG
		Hud_SetNavLeft( Hud_GetChild( s_socialFile.friendGrid, "GridButton6x0" ), s_socialFile.steamButton )
	#endif

	RuiSetString( s_socialFile.menuHeaderRui, "menuName", "#MENU_TITLE_FRIENDS" )

	s_socialFile.pageButtons = GetPanelElementsByClassname( menu, "PaginationButton" )
	s_socialFile.pageButtons.sort( SortByScriptId )
	foreach ( pageButton in s_socialFile.pageButtons )
	{
		Hud_SetVisible( pageButton, false )
		Hud_AddEventHandler( pageButton, UIE_CLICK, OnPageButton_Activate )

		PageButtonDef pageButtonDef
		pageButtonDef.button = pageButton
		s_socialFile.pageButtonDefs.append( pageButtonDef )
	}


	               
	{
		FriendListCallbacks friendsCallbacks
		friendsCallbacks.isValid      = FriendData_IsValid
		friendsCallbacks.onClick      = FriendButton_OnActivate
		friendsCallbacks.onClickRight = FriendButton_OnJoin
		friendsCallbacks.onKeyPress   = FriendButton_OnKeyPress
		friendsCallbacks.onGetFocus   = FriendButton_OnGetFocus

		friendsCallbacks.bindCallback             = FriendsList_OnBindFriend
		friendsCallbacks.itemVisibleCountCallback = FriendsList_GetVisibleFriendCount
		friendsCallbacks.itemTotalCountCallback   = SocialMenu_GetTotalFriendCount

		s_socialFile.friendListCallbacksMap[eSocialMenuState.FRIENDS] <- friendsCallbacks
	}

	                     
	{
		FriendListCallbacks friendsOtherCallbacks
		friendsOtherCallbacks.isValid      = FriendOtherData_IsValid
		friendsOtherCallbacks.onClick      = FriendOtherButton_OnActivate
		friendsOtherCallbacks.onClickRight = FriendOtherButton_OnJoin
		friendsOtherCallbacks.onKeyPress   = FriendOtherButton_OnKeyPress
		friendsOtherCallbacks.onGetFocus   = FriendOtherButton_OnGetFocus

		friendsOtherCallbacks.bindCallback             = FriendsList_OnBindFriendOther
		friendsOtherCallbacks.itemVisibleCountCallback = FriendsList_GetFriendOtherVisibleCount
		friendsOtherCallbacks.itemTotalCountCallback   = FriendsList_GetFriendOtherCount

		s_socialFile.friendListCallbacksMap[eSocialMenuState.FRIENDS_OTHER] <- friendsOtherCallbacks
	}

	                      
	{
		FriendListCallbacks friendRequestCallbacks
		friendRequestCallbacks.isValid      = FriendRequestData_IsValid
		friendRequestCallbacks.onClick      = FriendRequestButton_OnActivate
		friendRequestCallbacks.onClickRight = FriendRequestButton_OnJoin
		friendRequestCallbacks.onKeyPress   = FriendRequestButton_OnKeyPress
		friendRequestCallbacks.onGetFocus   = FriendRequestButton_OnGetFocus

		friendRequestCallbacks.bindCallback             = FriendsList_OnBindFriendRequest
		friendRequestCallbacks.itemVisibleCountCallback = FriendsList_GetFriendRequestVisibleCount
		friendRequestCallbacks.itemTotalCountCallback   = FriendsList_GetFriendRequestCount

		s_socialFile.friendListCallbacksMap[eSocialMenuState.FRIEND_REQUESTS] <- friendRequestCallbacks
	}

	EADPQueryData friendsQueryData
	friendsQueryData.doQuery        = EADP_FriendsDoQuery
	friendsQueryData.getQueryResult = EADP_GetFriendsList
	s_socialFile.eadpQueryDataMap[eEADPQuery.FRIENDS] <- friendsQueryData

	EADPQueryData muteListQueryData
	s_socialFile.eadpQueryDataMap[eEADPQuery.MUTE_LIST] <- muteListQueryData

	EADPQueryData blockListQueryData
	s_socialFile.eadpQueryDataMap[eEADPQuery.BLOCK_LIST] <- blockListQueryData
}


int function SocialMenu_GetState()
{
	return GetMenuActiveTabIndex( s_socialFile.menu )
}


void function SocialMenuThink( var menu )
{
	UpdateFriendsList()
	UpdateMyFriendButton()

	SocialMenu_Update()

	#if PC_PROG
		UpdateSteamButton()
	#endif

	if ( GetConVarString( "party_privacy" ) == "open" )
		HudElem_SetRuiArg( s_socialFile.partyPrivacyButton, "buttonText", Localize( "#PARTY_PRIVACY_N", Localize( "#SETTING_OPEN" ) ) )
	else
		HudElem_SetRuiArg( s_socialFile.partyPrivacyButton, "buttonText", Localize( "#PARTY_PRIVACY_N", Localize( "#SETTING_INVITE" ) ) )

	Hud_SetVisible( s_socialFile.leavePartyButton, AmIPartyMember() || (AmIPartyLeader() && GetPartySize() > 1) )

	if ( s_socialFile.cachedMatchPreferenceFlags & eMatchPreferenceFlags.LAST_SQUAD_INVITE_OPT_OUT )
		HudElem_SetRuiArg( s_socialFile.lastSquadInvitePrivacyButton, "buttonText", Localize( "#LAST_SQUAD_N", Localize( "#SETTING_OPT_OUT" ) ) )
	else
		HudElem_SetRuiArg( s_socialFile.lastSquadInvitePrivacyButton, "buttonText", Localize( "#LAST_SQUAD_N", Localize( "#SETTING_ALLOW_INVITES" ) ) )

	if ( s_socialFile.cachedMatchPreferenceFlags & eMatchPreferenceFlags.CROSSPLAY_INVITE_AUTO_DENY )
		HudElem_SetRuiArg( s_socialFile.crossPlayDenyButton, "buttonText", Localize( "#CROSSPLAY_INVITES_N", Localize( "#DENY_CROSSPLAY" ) ) )
	else
		HudElem_SetRuiArg( s_socialFile.crossPlayDenyButton, "buttonText", Localize( "#CROSSPLAY_INVITES_N", Localize( "#DISPLAY_CROSSPLAY" ) ) )
}

#if NX_PROG
void function UpdatePanelRowsAndColumns()
{
	if ( IsNxHandheldMode() )
	{
		FRIEND_GRID_ROWS    = FRIEND_GRID_ROWS_NX_HANDHELD
		FRIEND_GRID_COLUMNS = FRIEND_GRID_COLUMNS_NX_HANDHELD
	}
	else
	{
		FRIEND_GRID_ROWS    = FRIEND_GRID_ROWS_NX_DOCK
		FRIEND_GRID_COLUMNS = FRIEND_GRID_COLUMNS_NX_DOCK
	}
}
#endif

bool function CurrentlyInParty()
{
	return AmIPartyMember() || AmIPartyLeader() && GetPartySize() > 1
}


void function OnBindFriendListGridButton( var panel, var button, int index )
{
	if ( !(SocialMenu_GetState() in s_socialFile.friendListCallbacksMap) )
		return

	s_socialFile.friendListCallbacksMap[SocialMenu_GetState()].bindCallback( panel, button, index )
}


int function GetFriendListVisibleCount( var panel )
{
	if ( !(SocialMenu_GetState() in s_socialFile.friendListCallbacksMap) )
		return 0

	return s_socialFile.friendListCallbacksMap[SocialMenu_GetState()].itemVisibleCountCallback()
}


void function UpdateMyFriendButton()
{
	Friend friend
	friend.status   = eFriendStatus.ONLINE_INGAME
	friend.hardware = GetUnspoofedPlayerHardware()
	friend.ingame   = true
	friend.id       = GetPlayerUID()

	Party party = GetParty()
	friend.presence = Localize( "#PARTY_N_N", party.numClaimedSlots, party.numSlots )
	friend.inparty  = party.numClaimedSlots > 1

	foreach ( PartyMember member in party.members )
	{
		if ( member.uid == friend.id )
		{
			friend.name = member.name
			break
		}
	}

	float timeSinceUpdate = UITime() - s_socialFile.selfPresenceUpdateTime
	if ( timeSinceUpdate > 20 )
	{
		                                                                                            
		                                                          
		UpdateCanInviteSelf()
		s_socialFile.selfPresenceUpdateTime = UITime()
	}

	FriendButton_Init( s_socialFile.myGridButton, friend )
}


void function UpdateCanInviteSelf()
{
	string eaid                               = GetLocalClientPlayer().GetPINNucleusId()
	int hardwareId                            = GetHardwareFromName( GetUnspoofedPlayerHardware() )
	string uid                                = GetPlayerUID()
	array<EadpPresenceData> selfPresenceArray = EADP_GetPresenceForAccount( eaid )

	s_socialFile.canInviteSelf = false
	foreach ( EadpPresenceData data in selfPresenceArray )
	{
		if ( data.firstPartyId == uid && data.hardware == hardwareId )
			continue
		s_socialFile.canInviteSelf = true
	}
}


void function UpdateDpadNav()
{
	if ( CurrentlyInParty() )
	{
		Hud_SetNavDown( s_socialFile.partyPrivacyButton, s_socialFile.leavePartyButton )
		Hud_SetNavUp( s_socialFile.leavePartyButton, s_socialFile.partyPrivacyButton )
		Hud_SetNavDown( s_socialFile.leavePartyButton, s_socialFile.lastSquadInvitePrivacyButton )
	}
	else
	{
		Hud_SetNavDown( s_socialFile.partyPrivacyButton, s_socialFile.lastSquadInvitePrivacyButton )
		Hud_SetNavUp( s_socialFile.lastSquadInvitePrivacyButton, s_socialFile.partyPrivacyButton )
	}

	#if PC_PROG
		Hud_SetNavUp( s_socialFile.steamButton, s_socialFile.crossPlayDenyButton )
		Hud_SetNavDown( s_socialFile.crossPlayDenyButton, s_socialFile.steamButton )
	#endif
}


void function FriendListButtonInit( var button )
{
}


int function SortEADSPresence( EadpPresenceData a, EadpPresenceData b )
{
	if ( a.ingame != b.ingame )
		return a.ingame ? -1 : 1

	if ( a.online != b.online )
		return a.online ? -1 : 1

	if ( a.away != b.away )
		return a.away ? 1 : -1

	return 0
}


void function UpdateEADPQueryData( int queryType )
{
	int queryState = s_socialFile.eadpQueryDataMap[queryType].queryState

	if ( !EADP_SocialEnabled() )
	{
		s_socialFile.eadpQueryDataMap[queryType].queryState = eEADPQueryState.INVALID
		s_socialFile.eadpQueryDataMap[queryType].friends.clear()
	}
	else if ( queryState == eEADPQueryState.INVALID )
	{
		                                                                                                                        
		s_socialFile.eadpQueryDataMap[queryType].queryState = eEADPQueryState.RUNNING
	}
	else if ( queryState == eEADPQueryState.RUNNING )
	{
		InvalidateFriendListChecksum()

		EadpPeopleList queryResult = s_socialFile.eadpQueryDataMap[queryType].getQueryResult()
		if ( queryResult.isValid )
		{
			s_socialFile.eadpQueryDataMap[queryType].queryState  = eEADPQueryState.COMPLETE
			s_socialFile.eadpQueryDataMap[queryType].queryResult = queryResult.people
			s_socialFile.eadpQueryDataMap[queryType].friends.clear()
			foreach ( person in queryResult.people )
			{
				if ( person.presences.len() > 0 )
				{
					foreach ( presence in person.presences )
					{
						#if PC_PROG
							if ( presence.hardware == HARDWARE_PC && GetHardwareFromName( GetUnspoofedPlayerHardware() ) == HARDWARE_PC )
								continue

							                                                                                                                           
							  	        
						#endif

						                              
						Friend friend
						friend.name     = presence.name                                                                                      
						friend.eadpData = person;

						if ( presence.hardware == HARDWARE_PC_STEAM )
							friend.id = person.eaid
						else
							friend.id = presence.firstPartyId

						friend.away     = presence.away
						friend.ingame   = presence.ingame

						if ( presence.presence != null )
						{
							PresenceState pstate = expect PresenceState( presence.presence )
							friend.presence = StringReplace( LocalizePresenceState( pstate ), "%", "%%" )
						}
						else
							friend.presence = ""

						friend.hardware = GetNameFromHardware( presence.hardware )
						friend.inparty  = IsInParty( friend.id )

						if ( presence.away )
							friend.status = eFriendStatus.ONLINE_AWAY
						else if ( presence.ingame  )
							friend.status = eFriendStatus.ONLINE_INGAME
						else if ( presence.online )
							friend.status = eFriendStatus.ONLINE
						else
							friend.status = eFriendStatus.OFFLINE

						s_socialFile.eadpQueryDataMap[queryType].friends.append( friend )
					}
				}
				else
				{
					                                                                                                                                          
					                                                                          
					                                                                                           
					                                                                                          
					                                                                                                     
					Friend friend
					friend.name     = person.name
					friend.id       = person.eaid
					friend.eadpData = person;
					friend.status   = eFriendStatus.OFFLINE
					friend.away     = false
					friend.ingame   = false
					                                                                   
				}
			}
		}
	}
}


void function SocialMenu_OnOpen()
{
	RuiSetGameTime( s_socialFile.decorationRui, "initTime", ClientTime() )
	AddCallback_OnPartyUpdated( UpdateDpadNav )
	UpdateDpadNav()

	thread InitCachedMatchPreferenceFlags()

	if ( EADP_SocialEnabled() )
	{
		s_socialFile.eadpQueryDataMap[eEADPQuery.FRIENDS].queryState = eEADPQueryState.INVALID
		UpdateEADPQueryData( eEADPQuery.FRIENDS )
	}

	InvalidateFriendListChecksum()

	if ( !_IsMenuThinkActive() )
	{
		                                              
		thread UpdateActiveMenuThink()
	}

	if ( !s_socialFile.tabsInitialized )
	{
		array<var> panels = GetMenuTabBodyPanels( s_socialFile.menu )
		foreach ( index, panel in panels )
		{
			AddTab( s_socialFile.menu, panel, GetPanelTabTitle( panel ) )
			AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, Tab_OnShow )

			AddPanelFooterOption( panel, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
			if ( index == eSocialMenuState.FRIENDS )
			{
				AddPanelFooterOption( panel, LEFT, BUTTON_Y, true, "#Y_BUTTON_FIND_FRIEND", "#FOOTER_FIND_FRIEND", void function( var button ) : () {
					AdvanceMenu( GetMenu( "FindFriendDialog" ) )
				}, bool function() : () {
					return EADP_SocialEnabled()
				} )
			}

			break                  
		}

		s_socialFile.tabsInitialized = true
	}

	TabData tabData = GetTabDataForPanel( s_socialFile.menu )
	                           
	if ( GetLastMenuNavDirection() == MENU_NAV_FORWARD )
	{
		ActivateTab( tabData, 0 )
	}
}


void function Tab_OnShow( var panel )
{
	printt( "Tab_OnShow", GetMenuActiveTabIndex( s_socialFile.menu ) )
	s_socialFile.nextFriendsListUpdate = UITime()

	BindPageButtons( GetNumPanePages(), s_socialFile.pagerPageIndex )
	#if NX_PROG
		UpdatePanelRowsAndColumns()
		GridPanel_UpdateRowsAndColumns( s_socialFile.friendGrid, FRIEND_GRID_ROWS, FRIEND_GRID_COLUMNS )
		var buttonSizer = Hud_GetChild( s_socialFile.friendGrid, "GridButton0x0" )
		int baseWidth   = Hud_GetBaseWidth( buttonSizer )
		GridPanel_Refresh( s_socialFile.friendGrid, true, baseWidth, int( baseWidth * 0.2 ) )
	#else
		GridPanel_Refresh( s_socialFile.friendGrid )
	#endif
}


void function InitCachedMatchPreferenceFlags()
{
	while ( !IsPersistenceAvailable() )
	{
		WaitFrame()
	}

	s_socialFile.cachedMatchPreferenceFlags = GetPersistentVarAsInt( "matchPreferences" )
}


void function SocialMenu_OnShow()
{
	UI_SetPresentationType( ePresentationType.WEAPON_CATEGORY )
	s_socialFile.selfPresenceUpdateTime = 0                                
}


void function ForceSocialMenuUpdate()
{
	                                                                                                                 
	                                                              
	printt( "ForceSocialMenuUpdate" )
	s_socialFile.eadpQueryDataMap[eEADPQuery.FRIENDS].queryState = eEADPQueryState.INVALID
	InvalidateFriendListChecksum()
}


void function SocialMenu_Update()
{
	if ( !(SocialMenu_GetState() in s_socialFile.friendListCallbacksMap) )
		return

	if(  s_socialFile.SocialMenuUpdateTime  >= UITime() )                                
		return
	s_socialFile.SocialMenuUpdateTime  = UITime() + SOCIALMENUUPDATE_INTERVAL


	UpdateEADPQueryData( eEADPQuery.FRIENDS )

	Hud_SetVisible( s_socialFile.gridSpinner, !s_socialFile.friendListCallbacksMap[SocialMenu_GetState()].isValid() )
	s_socialFile.friendsData = GetFriendsData()

	int checksum = CalculateFriendListChecksum( s_socialFile.friendsData.friends )
	if ( checksum != s_socialFile.friendDataChecksum )
	{
		s_socialFile.friendDataChecksum = checksum
		RemoveDuplicateFriends( s_socialFile.eadpQueryDataMap[eEADPQuery.FRIENDS].friends, s_socialFile.friendsData.friends )
	}

	SocialMenu_ClearFriends()
	SocialMenu_AddFriends( s_socialFile.friendsData.friends )
	SocialMenu_AddFriends( s_socialFile.eadpQueryDataMap[eEADPQuery.FRIENDS].friends )

	SocialMenu_SortFriends()

	RuiSetArg( s_socialFile.menuHeaderRui, "ingameCount", SocialMenu_GetInGameFriendCount() )
	RuiSetArg( s_socialFile.menuHeaderRui, "onlineCount", SocialMenu_GetOnlineFriendCount() )
	RuiSetArg( s_socialFile.menuHeaderRui, "totalCount", SocialMenu_GetTotalFriendCount() )

	BindPageButtons( GetNumPanePages(), s_socialFile.pagerPageIndex )
	#if NX_PROG
		UpdatePanelRowsAndColumns()
		GridPanel_UpdateRowsAndColumns( s_socialFile.friendGrid, FRIEND_GRID_ROWS, FRIEND_GRID_COLUMNS )
		var buttonSizer = Hud_GetChild( s_socialFile.friendGrid, "GridButton0x0" )
		int baseWidth   = Hud_GetBaseWidth( buttonSizer )
		GridPanel_Refresh( s_socialFile.friendGrid, true, baseWidth, int( baseWidth * 0.2 ) )
	#else
		GridPanel_Refresh( s_socialFile.friendGrid )
	#endif

	UpdateDiscoverabilityWarning()
}

void function UpdateDiscoverabilityWarning()
{
	EadpPrivacySetting myPrivacySettings = Eadp_GetPrivacyData()

	bool doShowDiscoverabilityWarning

	if ( myPrivacySettings.isValid == false )
		doShowDiscoverabilityWarning = false

	#if DEV
		if( GetBugReproNum() == 7896188 )
		{
			printf( "-------- %s() --------", FUNC_NAME() )
			printf( "%s() Display Name Discoverable to: %s", FUNC_NAME(), myPrivacySettings.displayNameDiscoverable )
			printf( "%s() Steam Name Discoverable to: %s", FUNC_NAME(), myPrivacySettings.steamNameDiscoverable )
			printf( "%s() Nintendo Name Discoverable to: %s", FUNC_NAME(), myPrivacySettings.nintendoNameDiscoverable )
			printf( "%s() PSN Name Discoverable to: %s", FUNC_NAME(), myPrivacySettings.psnIdDiscoverable )
			printf( "%s() XBL Name Discoverable to: %s", FUNC_NAME(), myPrivacySettings.xboxTagDiscoverable )
		}
	#endif

	if ( myPrivacySettings.displayNameDiscoverable == DISCOVERABLE_NOONE )
		doShowDiscoverabilityWarning = true

	if ( myPrivacySettings.steamNameDiscoverable == DISCOVERABLE_NOONE )
		doShowDiscoverabilityWarning = true

	if ( myPrivacySettings.nintendoNameDiscoverable == DISCOVERABLE_NOONE )
		doShowDiscoverabilityWarning = true

	if ( myPrivacySettings.psnIdDiscoverable == DISCOVERABLE_NOONE )
		doShowDiscoverabilityWarning = true

	if ( myPrivacySettings.xboxTagDiscoverable == DISCOVERABLE_NOONE )
		doShowDiscoverabilityWarning = true

	#if DEV
		if( GetBugReproNum() == 7896188 )
		{
			if ( doShowDiscoverabilityWarning )
				printf( "%s() Displaying Warning", FUNC_NAME() )
			else
				printf( "%s() Hiding Warning", FUNC_NAME() )
		}
	#endif

	doShowDiscoverabilityWarning = doShowDiscoverabilityWarning && CrossplayUserOptIn()

	var rui = Hud_GetRui( s_socialFile.discoverabilityWarning )
	RuiSetBool( rui, "isVisible", doShowDiscoverabilityWarning )
}

#if DEV
void function DebugDiscoverability()
{
	EadpPrivacySetting myPrivacySettings = Eadp_GetPrivacyData()

	printf( "-------- %s() --------", FUNC_NAME() )
	printf( "%s() Display Name Discoverable to: %s", FUNC_NAME(), myPrivacySettings.displayNameDiscoverable )
	printf( "%s() Steam Name Discoverable to: %s", FUNC_NAME(), myPrivacySettings.steamNameDiscoverable )
	printf( "%s() Nintendo Name Discoverable to: %s", FUNC_NAME(), myPrivacySettings.nintendoNameDiscoverable )
	printf( "%s() PSN Name Discoverable to: %s", FUNC_NAME(), myPrivacySettings.psnIdDiscoverable )
	printf( "%s() XBL Name Discoverable to: %s", FUNC_NAME(), myPrivacySettings.xboxTagDiscoverable )
}
#endif      

void function RemoveDuplicateFriends( array<Friend> eadpFriends, array<Friend> nativFriends )
{
	foreach ( eadpFriend in clone eadpFriends )
	{
		foreach ( nativFriend in nativFriends )
		{
			if ( IsSameFriend( eadpFriend, nativFriend ) )
			{
				printt( "remove dubplicate friend" )
				eadpFriends.fastremovebyvalue( eadpFriend )
			}
		}
	}
}


bool function IsSameFriend( Friend eadpFriend, Friend nativFriend )
{
	string firstPartyId
	bool sameHardware = eadpFriend.hardware == nativFriend.hardware

	if ( sameHardware && FriendHasEAPDData( eadpFriend ) )
	{
		firstPartyId  = GetFirstPartyIdFromPresence( eadpFriend )
	}

	                                                                                                                                          
	bool sameID = eadpFriend.id == nativFriend.id || firstPartyId == nativFriend.id

	return sameID && sameHardware
}


string function GetFirstPartyIdFromPresence( Friend eadpFriend )
{
	Assert( eadpFriend.eadpData != null )

	int hardwareID = GetHardwareFromName( eadpFriend.hardware )
	EadpPeopleData eadpData = expect EadpPeopleData( eadpFriend.eadpData )
	foreach( EadpPresenceData presence in eadpData.presences )
	{
		if ( presence.hardware != hardwareID )
			continue

		return presence.firstPartyId
	}

	return ""
}

int function CalculateFriendListChecksum( array<Friend> friends )
{
	                                                                                  
	int checksum

	foreach ( Friend friend in friends )
	{
		checksum += int( (friend.id).slice( maxint( 0, friend.id.len() - 5 ) ) )
		checksum = (checksum << 3) ^ (checksum >> 15)
	}

	return checksum
}


void function InvalidateFriendListChecksum()
{
	s_socialFile.friendDataChecksum += 123456
}


Friend function SocialMenu_GetFriendByIndex( int index )
{
	Assert( index < s_socialFile.friends.len() )
	return s_socialFile.friends[index]
}


Friend function FriendsList_GetFriendByIndex( int index )
{
	int friendOffset = FriendsList_GetCurrentFriendOffset()
	return s_socialFile.friends[friendOffset + index]

}


void function SocialMenu_ClearFriends()
{
	s_socialFile.friends.clear()
}


void function SocialMenu_AddFriends( array<Friend> newFriends )
{
	s_socialFile.friends.extend( newFriends )
}


void function SocialMenu_SortFriends()
{
	s_socialFile.friends.sort( SortFriendGroupStatus )
}


int function SocialMenu_GetOnlineFriendCount()
{
	int count = 0
	foreach ( friend in s_socialFile.friends )
	{
		if ( friend.status >= eFriendStatus.OFFLINE )
			continue

		count++
	}

	return count
}


int function SocialMenu_GetInGameFriendCount()
{
	int count = 0
	foreach ( friend in s_socialFile.friends )
	{
		if ( !friend.ingame )
			continue

		count++
	}

	return count
}


int function SocialMenu_GetTotalFriendCount()
{
	return s_socialFile.friends.len()
}


array<Friend> function SocialMenu_GetFriends()
{
	return s_socialFile.friends
}


int function FriendsList_GetCurrentFriendOffset()
{
	#if NX_PROG
		UpdatePanelRowsAndColumns()
	#endif
	int friendOffset = s_socialFile.panePageIndex * FRIEND_GRID_ROWS * FRIEND_GRID_COLUMNS
	return friendOffset
}


int function GetNumPanePages()
{
	if ( !(SocialMenu_GetState() in s_socialFile.friendListCallbacksMap) )
		return 0
	#if NX_PROG
		UpdatePanelRowsAndColumns()
	#endif
	int numFriends = s_socialFile.friendListCallbacksMap[SocialMenu_GetState()].itemTotalCountCallback()
	int numPages   = int( ceil( numFriends / float(FRIEND_GRID_ROWS * FRIEND_GRID_COLUMNS) ) )

	return numPages
}


void function OnPageButton_Activate( var button )
{
	int buttonIndex             = int( Hud_GetScriptID( button ) )
	PageButtonDef pageButtonDef = s_socialFile.pageButtonDefs[buttonIndex]

	switch ( pageButtonDef.pageButtonType )
	{
		case ePageButtonType.PAGE_INDEX:
			s_socialFile.panePageIndex = pageButtonDef.pageIndex
			break

		case ePageButtonType.PAGE_PREV:
			s_socialFile.pagerPageIndex = maxint( 0, s_socialFile.pagerPageIndex - 1 )
			break

		case ePageButtonType.PAGE_NEXT:
			s_socialFile.pagerPageIndex = minint( GetNumPanePages() - 1, s_socialFile.pagerPageIndex + 1 )
			break
	}

	BindPageButtons( GetNumPanePages(), s_socialFile.pagerPageIndex )

	#if NX_PROG
		UpdatePanelRowsAndColumns()
		GridPanel_UpdateRowsAndColumns( s_socialFile.friendGrid, FRIEND_GRID_ROWS, FRIEND_GRID_COLUMNS )
		var buttonSizer = Hud_GetChild( s_socialFile.friendGrid, "GridButton0x0" )
		int baseWidth   = Hud_GetBaseWidth( buttonSizer )
		GridPanel_Refresh( s_socialFile.friendGrid, true, baseWidth, int( baseWidth * 0.2 ) )
	#else
		GridPanel_Refresh( s_socialFile.friendGrid )
	#endif
}


void function BindPageButtons( int numItems, int currentPageIdx )
{
	int numButtons = s_socialFile.pageButtons.len()

	int numItemsForRegularPage = numButtons - 2
	                                                                               

	                                           

	int pageCount = int(ceil( float(numItems - 1 - 1) / float(numItemsForRegularPage) ))
	                                                     
	                                                    

	int firstNonArrowButtonIdx
	int firstItemIdx
	int lastItemIdx
	int lastIdxShift = 1
	if ( currentPageIdx == 0 )
	{
		firstNonArrowButtonIdx = 0
		firstItemIdx           = currentPageIdx * numItemsForRegularPage
		lastItemIdx            = firstItemIdx + numItemsForRegularPage + 1                                       
		if ( pageCount == 1 )
			lastIdxShift = 0
	}
	else if ( currentPageIdx == pageCount - 1 )
	{
		firstNonArrowButtonIdx = 1
		lastItemIdx            = (numItems - 1)
		firstItemIdx           = lastItemIdx - (numItemsForRegularPage)
		lastIdxShift           = 0
	}
	else
	{
		firstNonArrowButtonIdx = 1
		firstItemIdx           = currentPageIdx * numItemsForRegularPage + 1                                                   
		lastItemIdx            = firstItemIdx + numItemsForRegularPage
	}

	int lastNonArrowButtonIdx = firstNonArrowButtonIdx + (lastItemIdx - firstItemIdx - 1)
	if ( currentPageIdx == pageCount - 1 )
		lastNonArrowButtonIdx += 1

	int buttonOffset = maxint( 0, lastItemIdx - (numItems - 1) )

	firstNonArrowButtonIdx += buttonOffset
	lastNonArrowButtonIdx += buttonOffset

	if ( s_socialFile.panePageIndex < firstItemIdx )
		s_socialFile.panePageIndex = firstItemIdx
	else if ( s_socialFile.panePageIndex > lastItemIdx - lastIdxShift )
		s_socialFile.panePageIndex = lastItemIdx - lastIdxShift

	for ( int buttonIdx = 0; buttonIdx < numButtons; buttonIdx++ )
	{
		PageButtonDef pageButtonDef = s_socialFile.pageButtonDefs[buttonIdx]
		var pageButton              = pageButtonDef.button
		Assert( pageButton == s_socialFile.pageButtons[buttonIdx] )

		Hud_SetSelected( pageButton, false )
		if ( buttonIdx < firstNonArrowButtonIdx - (currentPageIdx == 0 ? 0 : 1) )
		{
			Hud_SetVisible( pageButton, false )
		}
		else if ( buttonIdx < firstNonArrowButtonIdx )
		{
			pageButtonDef.pageButtonType = ePageButtonType.PAGE_PREV
			Hud_SetVisible( pageButton, true )
			HudElem_SetRuiArg( pageButton, "buttonText", "<" )
		}
		else if ( buttonIdx > lastNonArrowButtonIdx )
		{
			pageButtonDef.pageButtonType = ePageButtonType.PAGE_NEXT
			Hud_SetVisible( pageButton, true )
			HudElem_SetRuiArg( pageButton, "buttonText", ">" )
		}
		else
		{
			int buttonItemIdx = firstItemIdx + buttonIdx - firstNonArrowButtonIdx

			if ( buttonItemIdx < numItems )
			{
				pageButtonDef.pageButtonType = ePageButtonType.PAGE_INDEX
				pageButtonDef.pageIndex      = buttonItemIdx

				if ( buttonItemIdx == s_socialFile.panePageIndex )
					Hud_SetSelected( pageButton, true )

				Hud_SetVisible( pageButton, GetNumPanePages() > 1 )
				HudElem_SetRuiArg( pageButton, "buttonText", "" + (buttonItemIdx + 1) )
			}
			else
			{
				Hud_SetVisible( pageButton, false )
			}
		}
	}
}


void function SocialMenu_OnClose()
{
	RunMenuClientFunction( "ClearAllCharacterPreview" )
	RemoveCallback_OnPartyUpdated( UpdateDpadNav )
}


bool function FriendHasEAPDData( Friend friend )
{
	return friend.eadpData != null
}

EadpPresenceData ornull function GetEadpPresence( Friend eadpFriend )
{
	if( eadpFriend.eadpData != null )
	{
		int hardwareID = GetHardwareFromName( eadpFriend.hardware )
		EadpPeopleData eadpData = expect EadpPeopleData( eadpFriend.eadpData )
		foreach( EadpPresenceData presence in eadpData.presences )
		{
			if ( presence.hardware != hardwareID )
				continue
			return presence
		}
	}
	return null
}

void function FriendButton_Init( var button, Friend friend )
{
	var rui = Hud_GetRui( button )

	string friendName = friend.name
	#if DEV
		if ( FriendHasEAPDData( friend ) )
			friendName = "*" + friendName
	#endif
	RuiSetString( rui, "buttonText", friendName )

	switch ( friend.status )
	{
		case eFriendStatus.ONLINE_INGAME:
			RuiSetString( rui, "statusText", "#PRESENSE_PLAYING" )
			break

		case eFriendStatus.ONLINE:
			RuiSetString( rui, "statusText", "#PRESENSE_ONLINE" )
			break

		case eFriendStatus.ONLINE_AWAY:
			RuiSetString( rui, "statusText", "#PRESENSE_AWAY" )
			break

		case eFriendStatus.OFFLINE:
			RuiSetString( rui, "statusText", "#PRESENSE_OFFLINE" )
			break
	}

	RuiSetString( rui, "presenseText", friend.presence )
	RuiSetBool( rui, "isInGame", friend.ingame )
	RuiSetBool( rui, "isPartyMember", friend.inparty )
	RuiSetInt( rui, "status", friend.status )

	if ( FriendHasEAPDData( friend ) )
	{
		EadpPeopleData ornull peopleData = friend.eadpData
		expect EadpPeopleData( peopleData )
		if ( peopleData.presences.len() == 0 )
		{
			RuiSetString( rui, "platformString", "" )
		}
		else
		{
			string platformString = CrossplayUserOptIn() ? PlatformStringForHardwareList( [friend.hardware] ) : ""
			RuiSetString( rui, "platformString", platformString )
		}
	}
	else if ( friend.hardware != "" )
	{
		string platformString = CrossplayUserOptIn() ? PlatformStringForHardwareList( [friend.hardware] ) : ""
		RuiSetString( rui, "platformString", platformString )
	}

	bool isOffline = friend.status == eFriendStatus.OFFLINE
	Hud_SetLocked( button, !isOffline )

	ToolTipData toolTipData
	toolTipData.tooltipStyle = eTooltipStyle.BUTTON_PROMPT
	toolTipData.actionHint1  = "#Y_BUTTON_INSPECT"


	                                                  
	                                                                                     
	string friendNucleusID = GetFriendNucleusID( friend )
	if ( ClubIsValid() && friendNucleusID != "" && !Clubs_IsUserAClubmate( friendNucleusID ) )
	{
		string clubInviteTooltip = (ClubGetMyMemberRank() >= CLUB_RANK_CAPTAIN) ? Localize( "#FRIEND_BUTTON_CLUB_INVITE" ) : Localize( "#FRIEND_BUTTON_CLUB_INVITE_UNDERRANK" )
		                                                                                                                                                             
		toolTipData.actionHint1 = Localize( "#Y_BUTTON_INSPECT" ) + "   " + clubInviteTooltip
	}

	bool gotUserInfo = false
	if ( !isOffline )
	{
		string uid = GetPlayerUID()

		                                                                                                      
		bool hideInvite = (friend.id == uid && !s_socialFile.canInviteSelf)

		                                         
		bool hideJoin = friend.id == uid

		bool canInvite = !hideInvite && !friend.inparty && GetParty().numFreeSlots > 0 && !(friend.id == "0" || friend.id == "")
		toolTipData.actionHint2 = canInvite ? "#A_BUTTON_INVITE" : ""

		if ( friend.ingame && friend.hardware != "" && !friend.inparty && !hideJoin )
		{
			CommunityUserInfo ornull userInfo = GetUserInfo( friend.hardware, friend.id )
			if ( userInfo != null )
			{
				int timeInMatch = 0;
				EadpPresenceData ornull userPresenceOrNull = GetEadpPresence( friend )
				expect CommunityUserInfo( userInfo )
			    if( userPresenceOrNull != null &&  GetConVarBool("friends_joinUsePresence") )
				{
					expect EadpPresenceData( userPresenceOrNull )
					toolTipData.actionHint3 = userPresenceOrNull.isJoinable ? "X_BUTTON_JOIN" : ""
					gotUserInfo = true
					RuiSetBool( rui, "partyInMatch", userPresenceOrNull.partyInMatch )
					RuiSetBool( rui, "partyIsFull", userPresenceOrNull.partyIsFull )
					RuiSetString( rui, "privacy", userPresenceOrNull.privacySetting )

					if ( userPresenceOrNull.presence != null)
					{
						PresenceState pstate = expect PresenceState( userPresenceOrNull.presence )
						if ( pstate.matchStartTime > 0 )
							timeInMatch = GetUnixTimestamp() - pstate.matchStartTime
					}
				}
				else
				{
					toolTipData.actionHint3 = userInfo.isJoinable ? "X_BUTTON_JOIN" : ""
					gotUserInfo = true
					RuiSetBool( rui, "partyInMatch", userInfo.partyInMatch )
					RuiSetBool( rui, "partyIsFull", userInfo.partyFull )
					RuiSetString( rui, "privacy", userInfo.privacySetting )
				}

				RuiSetInt( rui, "timeInMatch", timeInMatch )
			}
		}
	}

	if ( !gotUserInfo )
	{
		RuiSetBool( rui, "partyInMatch", false )
		RuiSetBool( rui, "partyIsFull", false )
		RuiSetString( rui, "privacy", "invite" )
		RuiSetInt( rui, "timeInMatch", 0 )
	}

	Hud_SetToolTipData( button, toolTipData )
}


bool function CanPlayerInviteDebounce( var button )
{
	if ( !(button in s_socialFile.nextInviteTimes) )
		s_socialFile.nextInviteTimes[button] <- 0.0

	float lastInviteTime = s_socialFile.nextInviteTimes[button]

	if ( UITime() - lastInviteTime < 2.0 )
	{
		s_socialFile.nextInviteTimes[button] = UITime() - 1.0;
		return false
	}

	s_socialFile.nextInviteTimes[button] = UITime();
	return true
}


bool function MyFriendButton_OnKeyPress( var button, int keyId, bool isDown )
{
	if ( !isDown )
		return false

	if ( keyId == KEY_F || keyId == BUTTON_Y )
	{
		Friend friend
		friend.status   = eFriendStatus.ONLINE_INGAME
		friend.hardware = GetPlayerHardware()
		friend.ingame   = true
		friend.id       = GetPlayerUID()

		Party party = GetParty()
		friend.presence = Localize( "#PARTY_N_N", party.numClaimedSlots, party.numSlots )
		friend.inparty  = party.numClaimedSlots > 1

		foreach ( PartyMember member in party.members )
		{
			if ( member.uid == friend.id )
			{
				friend.name = member.name
				break
			}
		}

		InspectFriend( friend )

		return true
	}
	else if ( keyId == MOUSE_LEFT || keyId == BUTTON_A )
	{
		UpdateCanInviteSelf()

		if ( s_socialFile.canInviteSelf )
		{
			HudElem_SetRuiArg( s_socialFile.myGridButton, "actionSendTime", ClientTime(), eRuiArgType.GAMETIME )
			HudElem_SetRuiArg( s_socialFile.myGridButton, "actionString", "#INVITE_SENT" )

			string eaid = GetLocalClientPlayer().GetPINNucleusId()
			EADP_InviteToPlayByEAID( eaid , 0 )
		}
		return true
	}

	return false

}


bool function FriendData_IsValid()
{
	return s_socialFile.friendsData.isValid
}


void function FriendButton_OnActivate( var panel, var button, int index )
{
	Friend friend = FriendsList_GetFriendByIndex( index )
	s_socialFile.actionFriend = friend
	s_socialFile.actionButton = button

	if ( friend.inparty || friend.status == eFriendStatus.OFFLINE )
	{
		printt( "Not inviting Friend is inparty or offline " + friend.id + " inparty=" + friend.inparty + " status=" + friend.status )
		return
	}

	if ( !CanInvite() )
		return

	if ( !CanPlayerInviteDebounce( button ) )
		return

	if ( FriendHasEAPDData( friend ) && !EADP_InvitationAllowed() )
		return

	HudElem_SetRuiArg( button, "actionSendTime", ClientTime(), eRuiArgType.GAMETIME )
	HudElem_SetRuiArg( button, "actionString", "#INVITE_SENT" )
	InviteFriend( friend )
}


bool function FriendButton_OnKeyPress( var panel, var button, int index, int keyId, bool isDown )
{
	if ( !isDown )
		return false

	switch ( keyId )
	{
		case KEY_F:                  

		case BUTTON_Y:             

		case KEY_R:                      

		case BUTTON_SHOULDER_RIGHT:                           
		break

		default:
			return false
	}

	bool isInspectInput    = (keyId == KEY_F || keyId == BUTTON_Y)
	bool isClubInviteInput = (keyId == KEY_R || keyId == BUTTON_SHOULDER_RIGHT)

	Friend friend = FriendsList_GetFriendByIndex( index )

	if ( isInspectInput )
	{
		s_socialFile.actionButton = button
		InspectFriend( friend )
	}

	string friendNucleusID = GetFriendNucleusID( friend )

	if ( friendNucleusID != "" )
	{
		if ( isClubInviteInput && Clubs_IsEnabled() && ClubIsValid() && !Clubs_IsUserAClubmate( friendNucleusID ) )
		{
			if ( ClubGetMyMemberRank() >= CLUB_RANK_CAPTAIN )
			{
				HudElem_SetRuiArg( button, "actionSendTime", ClientTime(), eRuiArgType.GAMETIME )
				HudElem_SetRuiArg( button, "actionString", "#CLUB_INVITE_INVITED" )

				ClubInviteUser( friendNucleusID )
			}
			else
			{
				Clubs_OpenTooLowRankToInviteDialog()
			}
		}
	}

	return true
}


void function FriendButton_OnJoin( var panel, var button, int index )
{
	Friend friend = FriendsList_GetFriendByIndex( index )
	s_socialFile.actionFriend = friend
	s_socialFile.actionButton = button

	if ( !friend.ingame || friend.inparty || friend.status == eFriendStatus.OFFLINE || friend.id == "0" || friend.id == "" )
		return

	CommunityUserInfo ornull userInfo = GetUserInfo( friend.hardware, friend.id )
	if ( userInfo != null )
	{
		expect CommunityUserInfo( userInfo )
		EadpPresenceData ornull userPresenceOrNull = GetEadpPresence( friend )
	    if( userPresenceOrNull != null && GetConVarBool("friends_joinUsePresence") )
		{
			expect EadpPresenceData( userPresenceOrNull )
			if ( !userPresenceOrNull.isJoinable )
				return
		}
		else
		{
			if ( !userInfo.isJoinable )
				return
		}
	}

	if ( CurrentlyInParty() )
	{
		if ( GetParty().numFreeSlots == 0 )
		{
			ConfirmDialogData data
			data.headerText     = "#LEAVE_PARTY"
			data.messageText    = "#LEAVE_PARTY_DESC"
			data.resultCallback = OnLeavePartyDialogResult

			OpenConfirmDialogFromData( data )
			AdvanceMenu( GetMenu( "ConfirmDialog" ) )
		}
		else
		{
			ConfirmDialogData data
			data.headerText     = Localize( "#BRING_PARTY", friend.name )
			data.messageText    = Localize( "#BRING_PARTY_DESC", friend.name )
			data.resultCallback = OnBringPartyDialogResult
			data.contextImage   = $"ui/menu/common/dialog_notice"
			data.noText         = ["#B_BUTTON_NO", "#NO"]

			OpenConfirmDialogFromData( data )
			AdvanceMenu( GetMenu( "ConfirmDialog" ) )
		}
	}
	else
	{
		ConfirmDialogData data
		data.headerText     = "#JOIN_USER"
		data.messageText    = Localize( "#JOIN_USER_DESC", friend.name )
		data.resultCallback = OnJoinUserDialogResult

		OpenConfirmDialogFromData( data )
		AdvanceMenu( GetMenu( "ConfirmDialog" ) )
	}

	EmitUISound( "menu_accept" )
}


void function FriendsList_OnBindFriend( var panel, var button, int index )
{
	Friend friend = FriendsList_GetFriendByIndex( index )
	FriendButton_Init( button, friend )
}


int function FriendsList_GetVisibleFriendCount()
{
	if ( !s_socialFile.friendsData.isValid )
		return 0

	#if NX_PROG
		UpdatePanelRowsAndColumns()
	#endif

	int totalFriends = SocialMenu_GetTotalFriendCount()
	if ( totalFriends <= FRIEND_GRID_ROWS * FRIEND_GRID_COLUMNS )
		return totalFriends

	if ( (s_socialFile.panePageIndex + 1) * (FRIEND_GRID_ROWS * FRIEND_GRID_COLUMNS) > totalFriends )
		return minint( SocialMenu_GetTotalFriendCount() % (FRIEND_GRID_ROWS * FRIEND_GRID_COLUMNS), FRIEND_GRID_ROWS * FRIEND_GRID_COLUMNS )
	else
		return (FRIEND_GRID_ROWS * FRIEND_GRID_COLUMNS)

	unreachable
}


void function FriendButton_OnGetFocus( var panel, var button, int index )
{
	Friend friend = FriendsList_GetFriendByIndex( index )
	if ( friend.hardware != "" && friend.id != "" )
		CommunityUserInfo ornull userInfo = GetUserInfo( friend.hardware, friend.id )
}


bool function FriendOtherData_IsValid()
{
	return false
}


void function FriendOtherButton_OnActivate( var panel, var button, int index )
{
}


bool function FriendOtherButton_OnKeyPress( var panel, var button, int index, int keyId, bool isDown )
{
	return false
}


void function FriendOtherButton_OnJoin( var panel, var button, int index )
{
}


void function FriendsList_OnBindFriendOther( var panel, var button, int index )
{
}


int function FriendsList_GetFriendOtherVisibleCount()
{
	return 0
}


int function FriendsList_GetFriendOtherCount()
{
	return 0
}


void function FriendOtherButton_OnGetFocus( var panel, var button, int index )
{
}


bool function FriendRequestData_IsValid()
{
	return EADP_GetFriendRequestList().isValid
}


void function FriendRequestButton_OnActivate( var panel, var button, int index )
{
}


bool function FriendRequestButton_OnKeyPress( var panel, var button, int index, int keyId, bool isDown )
{
	return false
}


void function FriendRequestButton_OnJoin( var panel, var button, int index )
{
}


void function FriendsList_OnBindFriendRequest( var panel, var button, int index )
{
	#if NX_PROG
		UpdatePanelRowsAndColumns()
	#endif

	int friendOffset = s_socialFile.panePageIndex * FRIEND_GRID_ROWS * FRIEND_GRID_COLUMNS
	                                                                         

	EadpPeopleData friend = EADP_GetFriendRequestList().people[friendOffset + index]

	var rui = Hud_GetRui( button )
	RuiSetString( rui, "buttonText", friend.name )
	RuiSetString( rui, "statusText", "Friend Request" )
	RuiSetString( rui, "presenseText", Localize( "#A_BUTTON_ACCEPT" ) + " " + Localize( "#Y_BUTTON_REJECT" ) )
	RuiSetBool( rui, "isInGame", false )
	RuiSetBool( rui, "isPartyMember", false )
	RuiSetBool( rui, "partyInMatch", false )
	RuiSetBool( rui, "partyIsFull", false )
	RuiSetString( rui, "privacy", "" )
	RuiSetString( rui, "platformString", "" )
	RuiSetInt( rui, "status", eFriendStatus.REQUEST )

	  
		                      
		                      
		                        
		                                             
		                     
		                          
		                         
		                        
		                   
		                   

		              

		                                     
		                        

		                          
	  
	  
		                        
		 
			                                 
				                                                      
				     

			                          
				                                                     
				     

			                               
				                                                   
				     

			                           
				                                                      
				     
		 

		                                                    
		                                            
		                                                  
		                                         
		                                                                                           

		                                                       
		                                   

		                       
		                                                      
		                                             

		                        
		                 
		 
			                                                               

			                                                             

			                                                                
			 
				                                                                             
				                       
				 
					                                    
					                                                                      
					                                                                             
					 
						                                             
						                                                                              
						                  
						                                                                  
						                                                                
						                                                                 

					 
					    
					 
						                                                                    
						                  
						                                                        
						                                                    
						                                                       
						                                                                                                                                       
					 
				 
			 
		 

		                   
		 
			                                        
			                                       
			                                        
			                                  
		 

		                                           
}


int function FriendsList_GetFriendRequestVisibleCount()
{
	#if NX_PROG
		UpdatePanelRowsAndColumns()
	#endif
	int totalFriends = EADP_GetFriendRequestList().people.len()
	if ( totalFriends <= FRIEND_GRID_ROWS * FRIEND_GRID_COLUMNS )
		return totalFriends

	if ( (s_socialFile.panePageIndex + 1) * (FRIEND_GRID_ROWS * FRIEND_GRID_COLUMNS) > totalFriends )
		return minint( EADP_GetFriendRequestList().people.len() % (FRIEND_GRID_ROWS * FRIEND_GRID_COLUMNS), FRIEND_GRID_ROWS * FRIEND_GRID_COLUMNS )

	return (FRIEND_GRID_ROWS * FRIEND_GRID_COLUMNS)
}


int function FriendsList_GetFriendRequestCount()
{
	return EADP_GetFriendRequestList().people.len()
}


void function FriendRequestButton_OnGetFocus( var panel, var button, int index )
{
}


void function InspectFriend( Friend friend )
{
	s_socialFile.actionFriend = friend
	s_socialFile.actionFriendForceEADP = false

	printt( "Inspect", friend.name, friend.id, friend.hardware )
	EmitUISound( "UI_Menu_FriendInspect" )
	AdvanceMenu( GetMenu( "InspectMenu" ) )
}

void function InspectFriendForceEADP( Friend friend, bool forceEADP )
{
	InspectFriend( friend )
	s_socialFile.actionFriendForceEADP = forceEADP;
}

void function OnJoinUserDialogResult( int result )
{
	Friend friend = s_socialFile.actionFriend
	if ( !friend.ingame || friend.inparty || friend.status == eFriendStatus.OFFLINE || friend.id == "0" || friend.id == "" )
		return

	switch ( result )
	{
		case eDialogResult.YES:
			if ( JoinUserParty( friend.hardware, friend.id, false ) )
			{
				HudElem_SetRuiArg( s_socialFile.actionButton, "actionSendTime", ClientTime(), eRuiArgType.GAMETIME )
				HudElem_SetRuiArg( s_socialFile.actionButton, "actionString", "#JOIN_SUCCESS" )
				CloseActiveMenuNoParms()
			}
			else
			{
				HudElem_SetRuiArg( s_socialFile.actionButton, "actionSendTime", ClientTime(), eRuiArgType.GAMETIME )
				HudElem_SetRuiArg( s_socialFile.actionButton, "actionString", "#JOIN_FAIL" )
			}
	}
}


void function OnLeavePartyDialogResult( int result )
{
	switch ( result )
	{
		case eDialogResult.YES:
		{
			if ( IsInParty( s_socialFile.actionFriend.id ) )
				return

			HudElem_SetRuiArg( s_socialFile.actionButton, "actionSendTime", ClientTime(), eRuiArgType.GAMETIME )
			if ( JoinUserParty( s_socialFile.actionFriend.hardware, s_socialFile.actionFriend.id, false ) )
			{
				HudElem_SetRuiArg( s_socialFile.actionButton, "actionSendTime", ClientTime(), eRuiArgType.GAMETIME )
				HudElem_SetRuiArg( s_socialFile.actionButton, "actionString", "#JOIN_SUCCESS" )
				CloseActiveMenuNoParms()
			}
			else
			{
				HudElem_SetRuiArg( s_socialFile.actionButton, "actionSendTime", ClientTime(), eRuiArgType.GAMETIME )
				HudElem_SetRuiArg( s_socialFile.actionButton, "actionString", "#JOIN_FAIL" )
			}

			break
		}
	}
}


void function OnBringPartyDialogResult( int result )
{
	switch ( result )
	{
		case eDialogResult.YES:
			if ( IsInParty( s_socialFile.actionFriend.id ) )
				return

			HudElem_SetRuiArg( s_socialFile.actionButton, "actionSendTime", ClientTime(), eRuiArgType.GAMETIME )
			if ( JoinUserParty( s_socialFile.actionFriend.hardware, s_socialFile.actionFriend.id, true ) )
			{
				HudElem_SetRuiArg( s_socialFile.actionButton, "actionSendTime", ClientTime(), eRuiArgType.GAMETIME )
				HudElem_SetRuiArg( s_socialFile.actionButton, "actionString", "#JOIN_SUCCESS" )
				CloseActiveMenuNoParms()
			}
			else
			{
				HudElem_SetRuiArg( s_socialFile.actionButton, "actionSendTime", ClientTime(), eRuiArgType.GAMETIME )
				HudElem_SetRuiArg( s_socialFile.actionButton, "actionString", "#JOIN_FAIL" )
			}
			break

		case eDialogResult.NO:
			ConfirmDialogData data
			data.headerText = "#LEAVE_PARTY"
			data.messageText = "#LEAVE_PARTY_TO_JOIN"
			data.resultCallback = OnLeavePartyDialogResult

			OpenConfirmDialogFromData( data )
			AdvanceMenu( GetMenu( "ConfirmDialog" ) )
			break
	}
}


void function OnLeavePartyButton_Activate( var button )
{
	LeavePartyDialog()
}


void function OnPartyPrivacyButton_Activate( var button )
{
	if ( Hud_IsLocked( button ) )
		return

	if ( GetConVarString( "party_privacy" ) == "open" )
	{
		                                                                                                                                  
		SetConVarString( "party_privacy", "invite" )
	}
	else
	{
		                                                                                                                                
		SetConVarString( "party_privacy", "open" )
	}
}


void function OnCrossPlayDenyButton_Activate( var button )
{
	if ( Hud_IsLocked( button ) )
		return

	if ( !IsPersistenceAvailable() )
		return

	_ToggleMatchPreference( eMatchPreferenceFlags.CROSSPLAY_INVITE_AUTO_DENY )
}


void function OnLastSquadInvitePrivacyButton_Activate( var button )
{
	if ( Hud_IsLocked( button ) )
		return

	_ToggleMatchPreference( eMatchPreferenceFlags.LAST_SQUAD_INVITE_OPT_OUT )
}


void function _ToggleMatchPreference( int matchPrefFlag )
{
	if ( IsMatchPreferenceFlagActive( matchPrefFlag ) )
	{
		Remote_ServerCallFunction( "ClientCallback_ClearMatchPreferenceFlag", matchPrefFlag )
		s_socialFile.cachedMatchPreferenceFlags = s_socialFile.cachedMatchPreferenceFlags & ~matchPrefFlag
	}
	else
	{
		Remote_ServerCallFunction( "ClientCallback_SetMatchPreferenceFlag", matchPrefFlag )
		s_socialFile.cachedMatchPreferenceFlags = s_socialFile.cachedMatchPreferenceFlags | matchPrefFlag
	}
}


bool function IsMatchPreferenceFlagActive( int matchPrefFlag )
{
	return (s_socialFile.cachedMatchPreferenceFlags & matchPrefFlag) > 0
}

#if PC_PROG
void function UpdateSteamButton()
{
	var button = s_socialFile.steamButton

	if ( PCPlat_IsSteam() )
	{
		Hud_Hide( button )
		return
	}

	Hud_Show( button )

	int linkStatus = GetSteamAccountStatus();
	if ( linkStatus == -1 )
	{
		Hud_SetLocked( button, true )
		Hud_Hide( button )
		HudElem_SetRuiArg( s_socialFile.steamButton, "buttonText", "" )
	}
	else if ( linkStatus == 0 )
	{
		                                                      
		Hud_SetLocked( button, false )
		Hud_Show( button )
		HudElem_SetRuiArg( s_socialFile.steamButton, "buttonText", "LINK_STEAM_BUTTON" )
	}
	else if ( linkStatus == 1 )
	{
		                                                                                                               
		Hud_SetLocked( button, false )
		Hud_Show( button )
		HudElem_SetRuiArg( s_socialFile.steamButton, "buttonText", Localize( "#STEAM_ACCOUNT_LINKED", GetConVarString( "steam_name" ) ) )
	}
}
#endif

#if PC_PROG
void function OnSteamLinkButton_Activate( var button )
{
	int linkStatus = GetSteamAccountStatus();
	if ( linkStatus == -1 )
	{
	}
	else if ( linkStatus == 0 )
	{
		LinkSteamAccount()
	}
	else if ( linkStatus == 1 )
	{
		ConfirmDialogData data
		data.headerText     = "#UNLINK_STEAM_HEADER"
		data.messageText    = "#UNLINK_STEAM_MESSAGE"
		data.contextImage   = $"ui/menu/common/dialog_notice"
		data.resultCallback = OnUnlinkSteamAccountResult
		data.noText         = ["#B_BUTTON_NO", "#NO"]

		OpenConfirmDialogFromData( data )
		AdvanceMenu( GetMenu( "ConfirmDialog" ) )
	}
}

void function OnUnlinkSteamAccountResult( int result )
{
	if ( result != eDialogResult.YES )
		return

	UnlinkSteamAccount()
}

#endif

void function PreviewFriendCosmetics( bool isForLocalPlayer, CommunityUserInfo ornull userInfoOrNull )
{
	Signal( uiGlobal.signalDummy, "HaltPreviewFriendCosmetics" )
	EndSignal( uiGlobal.signalDummy, "HaltPreviewFriendCosmetics" )

	SetupMenuGladCard( s_inspectFile.combinedCard, "card", isForLocalPlayer )

	string introQuipSoundEventName = ""

	if ( isForLocalPlayer )
	{
		if ( LoadoutSlot_IsReady( LocalClientEHI(), Loadout_Character() ) )
		{
			ItemFlavor character = LoadoutSlot_GetItemFlavor( LocalClientEHI(), Loadout_Character() )
			if ( LoadoutSlot_IsReady( LocalClientEHI(), Loadout_CharacterIntroQuip( character ) ) )
			{
				ItemFlavor introQuip = LoadoutSlot_GetItemFlavor( LocalClientEHI(), Loadout_CharacterIntroQuip( character ) )
				introQuipSoundEventName = CharacterIntroQuip_GetVoiceSoundEvent( introQuip )
			}
		}

		                                                                                              
		Ranked_SetupMenuGladCardForUIPlayer()
                        
		ArenasRanked_SetupMenuGladCardForUIPlayer()
       
	}
	else
	{
		CommunityUserInfo userInfo = expect CommunityUserInfo(userInfoOrNull)
		#if DEV
			DEV_PrintUserInfo( userInfo )
		#endif

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
		introQuipSoundEventName = CharacterIntroQuip_GetVoiceSoundEvent( introQuip )

		Ranked_SetupMenuGladCardFromCommunityUserInfo( userInfo )

                        
		ArenasRanked_SetupMenuGladCardFromCommunityUserInfo( userInfo )
       
	}

	OnThreadEnd( void function() : ( introQuipSoundEventName ) {
		SetupMenuGladCard( null, "", false )

		if ( introQuipSoundEventName != "" )
			StopUISoundByName( introQuipSoundEventName )
	} )


	if ( introQuipSoundEventName != "" )
	{
		wait 0.7
		EmitUISound( introQuipSoundEventName )
	}

	WaitForever()
}


void function InviteFriend( Friend friend )
{
	if ( FriendHasEAPDData( friend ) )
	{
		EadpPeopleData eadpData = expect EadpPeopleData( friend.eadpData )
		printt( " InviteEADPFriend id:", eadpData.eaid )
		EADP_InviteToPlayByEAID( eadpData.eaid , 0 )
	}
	else
	{
		printt( " InviteFriend id:", friend.id )
		DoInviteToParty( [friend.id] )
	}
}


void function InitInspectMenu( var newMenuArg )
                                              
{
	var menu = GetMenu( "InspectMenu" )

	s_inspectFile.menu         = menu
	s_inspectFile.combinedCard = Hud_GetChild( menu, "CombinedCard" )

	var statTabs           = Hud_GetChild( menu, "TabsCommon" )
	var summaryPanel       = Hud_GetChild( menu, "StatsSummaryPanel" )
	                                                                      
	var seasonSelectButton = Hud_GetChild( menu, "SelectSeasonButton" )

	ShPlayerStatCards_Init()

	s_inspectFile.statTabsPanel = statTabs

	s_inspectFile.statsSummaryPanel = summaryPanel


	s_inspectFile.statsSummaryRui   = Hud_GetChild( summaryPanel, "LifetimeAndSeasonalStats" )
	s_inspectFile.statsModeButton = Hud_GetChild( menu, "SelectModeButton" )
	Hud_AddEventHandler( s_inspectFile.statsModeButton, UIE_CLICK, SelectModeButton_OnActivate )
	s_inspectFile.statsSeasonButton = seasonSelectButton
	Hud_AddEventHandler( s_inspectFile.statsSeasonButton, UIE_CLICK, SelectSeasonButton_OnActivate )

	ToolTipData modeButtonToolTipData
	modeButtonToolTipData.descText = "#STATS_TOOLTIP_SELECT_MODE"
	Hud_SetToolTipData( s_inspectFile.statsModeButton, modeButtonToolTipData )

	ToolTipData seasonButtonToolTipData
	seasonButtonToolTipData.descText = "#STATS_TOOLTIP_SELECT_SEASON"
	Hud_SetToolTipData( s_inspectFile.statsSeasonButton, seasonButtonToolTipData )

	s_inspectFile.menuHeaderRui  = Hud_GetRui( Hud_GetChild( menu, "MenuHeader" ) )
	s_inspectFile.decorationRui  = Hud_GetRui( Hud_GetChild( menu, "Decoration" ) )
	s_inspectFile.altNameListRui = Hud_GetRui( Hud_GetChild( menu, "AltNameList" ) )

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, InspectMenu_OnOpen )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, InspectMenu_OnClose )

	AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
	#if NX_PROG
		AddMenuFooterOption( menu, LEFT, BUTTON_Y, true, "#Y_BUTTON_USER_PAGE", "#USER_PAGE", OnViewProfile, ViewProfileAllowed )
	#else
		AddMenuFooterOption( menu, LEFT, BUTTON_Y, true, "#Y_BUTTON_VIEW_PROFILE", "#VIEW_PROFILE", OnViewProfile, ViewProfileAllowed )
	#endif
	AddMenuFooterOption( menu, LEFT, BUTTON_X, true, "#X_BUTTON_UNFRIEND_EA_FRIEND", "#UNFRIEND_EA_FRIEND", OnPlayerUnfriend, IsPlayerEADPFriend )
	AddMenuFooterOption( menu, LEFT, BUTTON_X, true, "#X_BUTTON_SEND_FRIEND_REQUEST", "#SEND_FRIEND_REQUEST", OnPlayerSendFriendRequest, CanSendEADPFriendRequest )

	AddMenuFooterOption( menu, RIGHT, BUTTON_STICK_RIGHT, true, "#BUTTON_REPORT_PLAYER", "#REPORT_PLAYER_SHORT", OnUserReport, CanReportUser )
	AddMenuFooterOption( menu, RIGHT, BUTTON_STICK_LEFT, true, "#LAST_SQUAD_BUTTON_CLUB_INVITE", "#CLUB_INVITE_NO_KEY", OnClubSendInvite, CanSendClubInvite )
}


void function InspectMenu_OnOpen()
{
	UI_SetPresentationType( ePresentationType.WEAPON_CATEGORY )

	string platformString   = CrossplayUserOptIn() ? PlatformIDToIconString( GetHardwareFromName( s_socialFile.actionFriend.hardware ) ) : ""
	string menuHeaderString = Localize( "#INSPECT_MENU_HEADER_NAME_PLAT", s_socialFile.actionFriend.name, platformString )

	RuiSetString( s_inspectFile.menuHeaderRui, "menuName", menuHeaderString )
	RuiSetGameTime( s_inspectFile.decorationRui, "initTime", ClientTime() )

	AddCallbackAndCallNow_UserInfoUpdated( OnUserInfoUpdated )

	EmitUISound( "ui_menu_friendinspect" )
}


void function OnUserInfoUpdated( string hardware, string id )
{
	bool isForLocalPlayer = (s_socialFile.actionFriend.id == GetPlayerUID())

	if ( (s_socialFile.actionFriend.hardware == "" && !isForLocalPlayer) || s_socialFile.actionFriend.id == "" )
		return

	CommunityUserInfo ornull userInfoOrNull
	if ( !isForLocalPlayer )
	{
		userInfoOrNull = GetUserInfo( s_socialFile.actionFriend.hardware, s_socialFile.actionFriend.id )
		if ( userInfoOrNull == null )
			return                             
	}

	thread PreviewFriendCosmetics( isForLocalPlayer, userInfoOrNull )

	Hud_SetVisible( s_inspectFile.statsSummaryPanel, isForLocalPlayer )

	Hud_SetVisible( s_inspectFile.statsModeButton, isForLocalPlayer )
	Hud_SetVisible( s_inspectFile.statsSeasonButton, isForLocalPlayer )

	UpdatePlayerAltNames( isForLocalPlayer )

	if ( !isForLocalPlayer )
		return

	array<ItemFlavor> revealedSeasons = StatCard_GetAvailableSeasons( s_inspectFile.selectedGameMode )

	if ( s_inspectFile.selectedModeName == "" )
		s_inspectFile.selectedModeName = StatsCard_GetNameOfGameMode( s_inspectFile.selectedGameMode )
	HudElem_SetRuiArg( s_inspectFile.statsModeButton, "buttonText", s_inspectFile.selectedModeName )

	if ( revealedSeasons.len() > 0 )
	{
		s_inspectFile.selectedSeasonGUID = ItemFlavor_GetGUIDString( revealedSeasons[ revealedSeasons.len() - 1 ] )
		s_inspectFile.selectedSeasonName = ItemFlavor_GetLongName( revealedSeasons[ revealedSeasons.len() - 1 ] )
		HudElem_SetRuiArg( s_inspectFile.statsSeasonButton, "buttonText", s_inspectFile.selectedSeasonName )
	}

	UpdatePlayerStatsDisplay()
}


void function InspectMenu_OnClose()
{
	Signal( uiGlobal.signalDummy, "HaltPreviewFriendCosmetics" )

	RunMenuClientFunction( "ClearAllCharacterPreview" )

	RemoveCallback_UserInfoUpdated( OnUserInfoUpdated )
}


void function UpdatePlayerAltNames( bool isForLocalPlayer )
{
	const MAX_ALT_NAMES = 8                                                                                                                               

	array<string> altNameList = GetAltNamesForEADPAccount()

	for ( int index = 0; index < MAX_ALT_NAMES; index++ )
	{
		if ( altNameList.len() > index )
		{
			RuiSetString( s_inspectFile.altNameListRui, "name" + (index + 1), altNameList[ index ] )
		}
		else
		{
			RuiSetString( s_inspectFile.altNameListRui, "name" + (index + 1), "" )
		}
	}

	bool shouldShow = !isForLocalPlayer && altNameList.len() > 0

	RuiSetBool( s_inspectFile.altNameListRui, "shouldShow", shouldShow )
}


array<string> function GetAltNamesForEADPAccount()
{
	Friend friend = s_socialFile.actionFriend
	int hardwareID = GetHardwareFromName( friend.hardware )

	array<string> altNameList
	array<EadpPresenceData> presenceList = GetFrindPresenceWithOffline( friend )

	foreach ( EadpPresenceData presence in presenceList )
	{
		if ( presence.hardware == hardwareID )
			continue

		string accountNameWithPlatform = PlatformIDToIconString( presence.hardware ) + "  " + presence.name
		altNameList.append( accountNameWithPlatform )
	}

	return altNameList
}

array<EadpPresenceData> function GetFrindPresenceWithOffline( Friend friend )
{
	int hardwareId = GetHardwareFromName( friend.hardware )

	                                                                               

	array<EadpPresenceData> emptyPresence

	EadpPeopleList peopleList = EADP_GetFriendsListWithOffline()
	foreach ( EadpPeopleData person in peopleList.people )
	{
		                                                                     

		if ( friend.id == person.eaid )
			return person.presences

		foreach ( EadpPresenceData presence in person.presences )
		{
			                                                                                   
			                                                                                                        
			if ( hardwareId == presence.hardware && friend.id == presence.firstPartyId )
				return person.presences

			                                                                                                             
			if ( hardwareId == presence.hardware && friend.name == presence.name )
				return person.presences
		}
	}

	return emptyPresence
}


bool function IsPlayerEADPFriend()
{
	if ( !FriendHasEAPDData( s_socialFile.actionFriend ) )
		return false

	int hardwareID = GetHardwareFromName( GetUnspoofedPlayerHardware() )
	if ( hardwareID == HARDWARE_PC && GetHardwareFromName( s_socialFile.actionFriend.hardware ) == HARDWARE_PC )
	{
		                                                                                                                               
		return false
	}

	EadpPeopleData eadpData = expect EadpPeopleData( s_socialFile.actionFriend.eadpData )
	printt( "#EADP IsPlayerEADPFriend", eadpData.eaid )
	return EADP_IsFriendByEAID( eadpData.eaid ) != 0                                  
}

bool function CanReportUser(){
	                             
	if( s_socialFile.actionFriend.id == GetPlayerUID() )
		return false
	return true
}

void function OnUserReport(var button){
	string friendNucleusID = GetFriendNucleusID( s_socialFile.actionFriend )
	if( friendNucleusID != "" )
	{
		ClientToUI_ShowReportPlayerDialog( s_socialFile.actionFriend.name, GetHardwareFromName( s_socialFile.actionFriend.hardware ),
			s_socialFile.actionFriend.id, friendNucleusID, "friendly" )                                                                                         
	}
}

void function OnClubSendInvite(var button){
	string friendNucleusID = GetFriendNucleusID( s_socialFile.actionFriend )

	if ( friendNucleusID != "" )
	{
		if ( Clubs_IsEnabled() && ClubIsValid() && !Clubs_IsUserAClubmate( friendNucleusID ) )
		{
			if ( ClubGetMyMemberRank() >= CLUB_RANK_CAPTAIN )
			{
				                                                                                   
				                                                                     
				ClubInviteUser( friendNucleusID )
			}
			else
			{
				Clubs_OpenTooLowRankToInviteDialog()
			}
		}
	}
}

bool function CanSendClubInvite(){
	if(!ClubIsValid()) return false
	if(s_socialFile.actionFriend.id == GetPlayerUID()) return false
	return true
}

void function OnPlayerUnfriend( var button )
{
	ConfirmDialogData dialogData
	dialogData.headerText     = "#UNFRIEND_DIALOG_HEADER"
	dialogData.messageText    = Localize( "#UNFRIEND_DIALOG_MSG", s_socialFile.actionFriend.name )
	dialogData.contextImage   = $"ui/menu/common/dialog_notice"
	dialogData.resultCallback = void function( int dialogResult ) {
		if ( dialogResult == eDialogResult.YES )
		{
			Assert( s_socialFile.actionFriend.eadpData != null )
			EadpPeopleData eadpData = expect EadpPeopleData( s_socialFile.actionFriend.eadpData )
			EADP_UnFriendByEAID( eadpData.eaid )

			if ( GetActiveMenu() == s_inspectFile.menu )
				CloseActiveMenuNoParms()
		}
	}

	OpenConfirmDialogFromData( dialogData )
}


void function OnPlayerSendFriendRequest( var button )
{
	Friend friend = s_socialFile.actionFriend

	if ( IsUserOnSamePlatform( friend.hardware ) && !s_socialFile.actionFriendForceEADP )
	{
		                                       
		printt( "#EADP - OnPlayerSendFriendRequest - NATIVE" )
		DoInviteToBeFriend( friend.id )
	}
	else if ( FriendHasEAPDData( friend ) )
	{
		                               
		printt( "#EADP - OnPlayerSendFriendRequest - EADP" )
		EadpPeopleData ornull peopleData = friend.eadpData
		expect EadpPeopleData( peopleData )
		EADP_InviteFriendByEAID( peopleData.eaid )
	}

	ConfirmDialogData data
	data.headerText     = "#FRIEND_INVITE_DIALOG_HEADER"
	data.messageText    = Localize( "#FRIEND_INVITE_DIALOG_MSG_INVITE_SENT", friend.name )
	data.resultCallback = void function( int dialogResult ) {
		if ( GetActiveMenu() == s_inspectFile.menu )
			CloseActiveMenuNoParms()
	}

	OpenOKDialogFromData( data )
}


bool function CanSendEADPFriendRequest()
{
	if ( !IsFullyConnected() )
		return false

	if ( IsPlayerEADPFriend() )
		return false

	if ( s_socialFile.actionFriend.id == "" )
		return false

	if ( s_socialFile.actionFriend.id == GetPlayerUID() )
		return false

	CommunityFriends friends = GetFriendInfo()
	foreach ( id in friends.ids )
	{
		if ( s_socialFile.actionFriend.id == id )
		{
			return false
		}
	}

	if ( GetLocalClientPlayer() == null )
		return false

	string eaid = GetLocalClientPlayer().GetPINNucleusId()
	if ( s_socialFile.actionFriend.eadpData != null )
	{
		EadpPeopleData eadpData = expect EadpPeopleData( s_socialFile.actionFriend.eadpData )
		if ( eadpData.eaid == eaid )
			return false
	}


	return true                      
}


bool function ViewProfileAllowed()
{
	string hardware       = GetUnspoofedPlayerHardware()
	string friendHardware = s_socialFile.actionFriend.hardware

	string friendID = s_socialFile.actionFriend.id

	if ( friendID == "" )
		return false

	if ( hardware != friendHardware )
	{
		if( hardware == "PS4" || hardware == "PS5" )
		{
			                             
			if( friendHardware != "PS4" && friendHardware != "PS5" )
			{
				return false
			}
		}
		else if( hardware == "X1" || hardware == "XB5" )
		{
			                               
			if( friendHardware != "X1" && friendHardware != "XB5" )
			{
				return false
			}
		}
		else
		{
			return false
		}
	}

	return true
}


void function OnViewProfile( var button )
{
	#if PC_PROG

		if ( !PCPlat_IsOverlayAvailable() )
		{
			string platname = PCPlat_IsOrigin() ? "ORIGIN" : "STEAM"
			ConfirmDialogData dialogData
			dialogData.headerText   = ""
			dialogData.messageText  = "#" + platname + "_INGAME_REQUIRED"
			dialogData.contextImage = $"ui/menu/common/dialog_notice"


			OpenOKDialogFromData( dialogData )
			return
		}
	#endif

	if ( !ViewProfileAllowed() )
		return

	ShowPlayerProfileCardForUID( s_socialFile.actionFriend.id )
}


void function InitModeSelectPopUp( var newMenuArg )
{
	var selectModePopUpMenu = GetMenu( "StatsModeSelectPopUp" )
	s_inspectFile.statsModePopUpMenu = selectModePopUpMenu

	SetPopup( selectModePopUpMenu, true )

	s_inspectFile.statsModePopUp = Hud_GetChild( selectModePopUpMenu, "SelectModePopUp" )
	AddMenuEventHandler( selectModePopUpMenu, eUIEvent.MENU_OPEN, OnOpenModeSelectDialog )
	AddMenuEventHandler( selectModePopUpMenu, eUIEvent.MENU_CLOSE, OnCloseModeSelectDialog )

	s_inspectFile.statsModeList = Hud_GetChild( s_inspectFile.statsModePopUp, "SelectModeList" )

	s_inspectFile.statsModeCloseButton = Hud_GetChild( selectModePopUpMenu, "CloseButton" )
	Hud_AddEventHandler( s_inspectFile.statsModeCloseButton, UIE_CLICK, OnModeCloseButton_Activate )
}


void function InitSeasonSelectPopUp( var newMenuArg )
                                              
{
	var selectSeasonPopUpMenu = GetMenu( "StatsSeasonSelectPopUp" )
	s_inspectFile.statsSeasonPopUpMenu = selectSeasonPopUpMenu

	SetPopup( selectSeasonPopUpMenu, true )

	s_inspectFile.statsSeasonPopUp = Hud_GetChild( selectSeasonPopUpMenu, "SelectSeasonPopup" )
	AddMenuEventHandler( selectSeasonPopUpMenu, eUIEvent.MENU_OPEN, OnOpenSeasonSelectDialog )
	AddMenuEventHandler( selectSeasonPopUpMenu, eUIEvent.MENU_CLOSE, OnCloseSeasonSelectDialog )

	s_inspectFile.statsSeasonList = Hud_GetChild( s_inspectFile.statsSeasonPopUp, "SelectSeasonList" )

	s_inspectFile.statsSeasonCloseButton = Hud_GetChild( selectSeasonPopUpMenu, "CloseButton" )
	Hud_AddEventHandler( s_inspectFile.statsSeasonCloseButton, UIE_CLICK, OnSeasonCloseButton_Activate )
}


void function SelectModeButton_OnActivate( var button )
{
	AdvanceMenu( s_inspectFile.statsModePopUpMenu )
	Hud_SetSelected( s_inspectFile.statsModeButton, true )
}

void function OnModeCloseButton_Activate( var button )
{
	CloseAllToTargetMenu( s_inspectFile.menu )
	Hud_SetSelected( s_inspectFile.statsModeButton, false )
}


void function SelectSeasonButton_OnActivate( var button )
{
	AdvanceMenu( s_inspectFile.statsSeasonPopUpMenu )
	Hud_SetSelected( s_inspectFile.statsSeasonButton, true )
}


void function OnSeasonCloseButton_Activate( var button )
{
	CloseAllToTargetMenu( s_inspectFile.menu )
	Hud_SetSelected( s_inspectFile.statsSeasonButton, false )
}


void function OnOpenModeSelectDialog()
{
	foreach ( button, mode in s_inspectFile.buttonToMode )
	{
		Hud_RemoveEventHandler( button, UIE_CLICK, OnModeButton_Activate )
	}
	s_inspectFile.buttonToMode.clear()

	var owner = s_inspectFile.statsModeButton
	UIPos ownerPos = REPLACEHud_GetAbsPos( owner )
	UISize ownerSize = REPLACEHud_GetSize( owner )

	Hud_Show( s_inspectFile.statsModeButton )

	int gameModeCount = eStatCardGameMode._count
	Hud_InitGridButtons( s_inspectFile.statsModeList, gameModeCount )
	var scrollPanel = Hud_GetChild( s_inspectFile.statsModeList, "ScrollPanel" )
	for ( int i = 0; i < gameModeCount; i++ )
	{
		var button = Hud_GetChild( scrollPanel, ("GridButton" + i) )
		if ( i == 0 )
		{
			int popupHeight = (Hud_GetHeight( button ) * gameModeCount)
			Hud_SetPos( s_inspectFile.statsModePopUp, ownerPos.x, ownerPos.y )
			Hud_SetSize( s_inspectFile.statsModePopUp, ownerSize.width, popupHeight )
			Hud_SetSize( s_inspectFile.statsModeList, ownerSize.width, popupHeight )

			if ( GetDpadNavigationActive() )
			{
				Hud_SetFocused( button )
				Hud_SetSelected( button, true )
			}
		}

		ModeButton_Init( button, i )
	}
}


void function OnCloseModeSelectDialog()
{
	Hud_SetSelected( s_inspectFile.statsModeButton, false )

	if ( GetDpadNavigationActive() )
		Hud_SetFocused( s_inspectFile.statsModeButton )
}


void function OnOpenSeasonSelectDialog()
{
	foreach ( button, season in s_inspectFile.buttonToSeason )
	{
		Hud_RemoveEventHandler( button, UIE_CLICK, OnSeasonButton_Activate )
	}
	s_inspectFile.buttonToSeason.clear()

	var ownerButton = s_inspectFile.statsSeasonButton

	UIPos ownerPos   = REPLACEHud_GetAbsPos( ownerButton )
	UISize ownerSize = REPLACEHud_GetSize( ownerButton )

	array<ItemFlavor> seasonsAndRankedPeriods = []
	seasonsAndRankedPeriods.extend( StatCard_GetAvailableSeasonsAndRankedPeriods( s_inspectFile.selectedGameMode ) )

	if ( seasonsAndRankedPeriods.len() == 0 )
		return

	Hud_Show( s_inspectFile.statsSeasonButton )

	Hud_InitGridButtons( s_inspectFile.statsSeasonList, seasonsAndRankedPeriods.len() )
	var scrollPanel = Hud_GetChild( s_inspectFile.statsSeasonList, "ScrollPanel" )
	for ( int i = 0; i < seasonsAndRankedPeriods.len(); i++ )
	{
		var button = Hud_GetChild( scrollPanel, ("GridButton" + i) )
		if ( i == 0 )
		{
			int popupHeight = ( Hud_GetHeight( button ) * int( min( seasonsAndRankedPeriods.len(), MAX_NUMBER_OF_SEASONS_VISIBLE ) ) )
			Hud_SetPos( s_inspectFile.statsSeasonPopUp, ownerPos.x, ownerPos.y                    )
			Hud_SetSize( s_inspectFile.statsSeasonPopUp, ownerSize.width, popupHeight )
			Hud_SetSize( s_inspectFile.statsSeasonList, ownerSize.width, popupHeight )

			if ( GetDpadNavigationActive() )
			{
				Hud_SetFocused( button )
				Hud_SetSelected( button, true )
			}
		}

		SeasonButton_Init( button, seasonsAndRankedPeriods[i] )
	}
}


void function OnCloseSeasonSelectDialog()
{
	Hud_SetSelected( s_inspectFile.statsSeasonButton, false )

	if ( GetDpadNavigationActive() )
		Hud_SetFocused( s_inspectFile.statsSeasonButton )
}


void function ModeButton_Init( var button, int gameMode )
{
	Assert( Hud_GetWidth( s_inspectFile.statsModeButton ) == Hud_GetWidth( button ), "Stats UI Assertion: " + Hud_GetWidth( s_inspectFile.statsModeButton ) + " != " + Hud_GetWidth( button ) )

	InitButtonRCP( button )
	var rui = Hud_GetRui( button )
	RuiSetString( rui, "buttonText", Localize( StatsCard_GetNameOfGameMode( gameMode ) ) )

	Hud_AddEventHandler( button, UIE_CLICK, OnModeButton_Activate )
	s_inspectFile.buttonToMode[ button ] <- gameMode
}


void function OnModeButton_Activate( var button )
{
	int selectedMode = s_inspectFile.buttonToMode[button]

	s_inspectFile.selectedGameMode = selectedMode
	s_inspectFile.selectedModeName = StatsCard_GetNameOfGameMode( selectedMode )
	HudElem_SetRuiArg( s_inspectFile.statsModeButton, "buttonText", Localize( s_inspectFile.selectedModeName ) )
	Hud_SetSelected( s_inspectFile.statsModeButton, false )

	UpdatePlayerStatsDisplay()

	CloseAllToTargetMenu( s_inspectFile.menu )
}


void function SeasonButton_Init( var button, ItemFlavor season )
{
	Assert( Hud_GetWidth( s_inspectFile.statsSeasonButton ) == Hud_GetWidth( button ), "Stats UI Assertion: " + Hud_GetWidth( s_inspectFile.statsSeasonButton ) + " != " + Hud_GetWidth( button ) )

	InitButtonRCP( button )
	var rui = Hud_GetRui( button )

	RuiSetString( rui, "buttonText", Localize( ItemFlavor_GetLongName( season ) ) )

	Hud_AddEventHandler( button, UIE_CLICK, OnSeasonButton_Activate )
	s_inspectFile.buttonToSeason[ button ] <- season
}


void function OnSeasonButton_Activate( var button )
{
	ItemFlavor selectedSeason = s_inspectFile.buttonToSeason[ button ]

	s_inspectFile.selectedSeasonName = ItemFlavor_GetLongName( selectedSeason )
	s_inspectFile.selectedSeasonGUID = ItemFlavor_GetGUIDString( selectedSeason )
	HudElem_SetRuiArg( s_inspectFile.statsSeasonButton, "buttonText", Localize( s_inspectFile.selectedSeasonName ) )
	Hud_SetSelected( s_inspectFile.statsSeasonButton, false )

	UpdatePlayerStatsDisplay()

	CloseAllToTargetMenu( s_inspectFile.menu )
}


void function UpdatePlayerStatsDisplay()
{
	printf( "StatCardV2Debug: %s()", FUNC_NAME() )
	entity player = GetLocalClientPlayer()

	UpdatePlayerAccountProgressBar( player )

	if ( s_inspectFile.selectedSeasonGUID == "" || StatsCard_IsSeasonOrRankedRefValidForMode( s_inspectFile.selectedGameMode, s_inspectFile.selectedSeasonGUID ) == false )
	{
		ItemFlavor ornull currentSeason = GetActiveSeason( GetUnixTimestamp() )
		string ornull currentSeasonRefOrNull = GetCurrentStatSeasonRefOrNull()

		ItemFlavor mostRecentSeason = GetLatestSeason( GetUnixTimestamp() )
		string mostRecentSeasonRef  = ItemFlavor_GetGUIDString( mostRecentSeason )

		if ( currentSeasonRefOrNull != null )
			s_inspectFile.selectedSeasonGUID = expect string( currentSeasonRefOrNull )
		else if ( mostRecentSeasonRef != "" )
			s_inspectFile.selectedSeasonGUID = mostRecentSeasonRef

		s_inspectFile.selectedSeasonName = (currentSeasonRefOrNull != null) ? ItemFlavor_GetLongName( expect ItemFlavor( currentSeason ) ) : ItemFlavor_GetLongName( mostRecentSeason )
		HudElem_SetRuiArg( s_inspectFile.statsSeasonButton, "buttonText", Localize( s_inspectFile.selectedSeasonName ) )
	}

	int refGUID                = ConvertItemFlavorGUIDStringToGUID( s_inspectFile.selectedSeasonGUID )
	ItemFlavor refFlavor       = GetItemFlavorByGUID( refGUID )
	bool isSelectedGUIDASeason = IsSeasonFlavor( refFlavor )

	if ( isSelectedGUIDASeason )
		UpdatePlayerSeasonBattlePassBadge( player, s_inspectFile.selectedSeasonGUID )
	else
		UpdatePlayerRankedBadge( player, s_inspectFile.selectedSeasonGUID )

	if ( s_inspectFile.selectedSeasonGUID == "" )
		StatCard_UpdateAndDisplayStats( s_inspectFile.statsSummaryRui, player, s_inspectFile.selectedGameMode )
	else
		StatCard_UpdateAndDisplayStats( s_inspectFile.statsSummaryRui, player, s_inspectFile.selectedGameMode, s_inspectFile.selectedSeasonGUID )
}


void function UpdatePlayerAccountProgressBar( entity player )
{
	int xpProgress            = GetPlayerAccountXPProgress( ToEHI( player ) )
	int accountLevel          = GetAccountLevelForXP( xpProgress )
	int xpForAccountLevel     = GetTotalXPToCompleteAccountLevel( accountLevel - 1 )
	int xpForNextAccountLevel = GetTotalXPToCompleteAccountLevel( accountLevel )
	float accountFrac         = GraphCapped( xpProgress, xpForAccountLevel, xpForNextAccountLevel, 0.0, 1.0 )

	StatCard_ConstructAccountProgressBar( s_inspectFile.statsSummaryRui, accountLevel, accountFrac )
}


void function UpdatePlayerSeasonBattlePassBadge( entity player, string seasonRef = "" )
{
	Assert( seasonRef != "", "Stat Card UI: Cannot update season battle pass badge without a season ref" )

	SettingsAssetGUID seasonGUID = ConvertItemFlavorGUIDStringToGUID( seasonRef )
	ItemFlavor season            = GetItemFlavorByGUID( seasonGUID )
	ItemFlavor battlePass        = Season_GetBattlePass( season )

	                                      
	                                        
	                                                                  
	                                                                          
	                                                                                   

	bool getPreviousProgress = false
	int battlePassXP = GetPlayerBattlePassXPProgress( ToEHI( player ), battlePass, getPreviousProgress )

	int battlePassLevel = GetBattlePassLevelForXP( battlePass, battlePassXP )

	StatCard_ConstructBattlePassLevelBadge( s_inspectFile.statsSummaryRui, player, battlePassLevel, seasonRef )
}


void function UpdatePlayerRankedBadge( entity player, string rankedPeriodRef = "" )
{
	Assert( rankedPeriodRef != "", "Stat Card UI: Cannot update ranked badge without a ranked period GUID" )

	StatCard_ConstructRankedBadges( s_inspectFile.statsSummaryRui, player, rankedPeriodRef )
}


string function PlatformStringForHardwareList( array<string> hardwareList )
{
	string platformString = ""
	foreach ( hardwareName in hardwareList )
	{
		if ( platformString == "" )
			platformString = PlatformIDToIconString( GetHardwareFromName( hardwareName ) )
		else
			platformString = platformString + " " + PlatformIDToIconString( GetHardwareFromName( hardwareName ) )
	}

	return platformString
}


string function PlatformStringForHardwareIDList( array<int> hardwareIDList )
{
	string platformString = ""
	foreach ( hardwareID in hardwareIDList )
	{
		if ( platformString == "" )
			platformString = PlatformIDToIconString( hardwareID )
		else
			platformString = platformString + " " + PlatformIDToIconString( hardwareID )
	}

	return platformString
}


void function InitFriendsPanel( var panel )
{

}


void function InitFriendsOtherPanel( var panel )
{

}


void function InitFriendRequestsPanel( var panel )
{

}


void function ClientToUI_InviteToPlayByEAID( string eaid )
{
	EADP_InviteToPlayByEAID( eaid , 0 )
}

string function GetFriendNucleusID( Friend friend )
{
	string friendNucleusID = ""
	string friendEadpHardwareName =""
	if( FriendHasEAPDData( friend ) )
	{
		EadpPeopleData friendEadpData = expect EadpPeopleData( friend.eadpData )
		friendNucleusID = friendEadpData.eaid
	}
	else
	{
		friendNucleusID = EADP_GetEadpIdFromFirstPartyID( friend.id, GetHardwareFromName( friend.hardware ) )
	}

	return friendNucleusID
}