global function InitJoinRequestsMenu
global function OpenJoinRequestsMenu
global function CloseJoinRequestsMenu

global function ClubJoinRequests_RefreshJoinRequests

struct
{
	var                                  menu
	var                                  menuHeader
	var                                  menuHeaderRui
	var                                  requestsGrid
	array<var> 					       buttons
	table< var, ClubJoinRequest >      buttonToRequestMap
	ClubJoinRequest&                     selectedJoinRequest
	int                                  selectedRequestIndex = -1

	var userDetailsPanel
	                   
	                      
	                    

	var gladCard
} file

void function InitJoinRequestsMenu( var menu )
{
	file.menu = menu

	file.menuHeader = Hud_GetChild( menu, "MenuHeader" )
	file.menuHeaderRui = Hud_GetRui( file.menuHeader )
	RuiSetString( file.menuHeaderRui, "menuName", "#CLUB_JOIN_REQUEST_NAME" )

	file.requestsGrid = Hud_GetChild( menu, "PetitionGrid" )

	file.userDetailsPanel = Hud_GetChild( menu, "UserDetailsPanel" )

	file.gladCard = Hud_GetChild( file.userDetailsPanel, "UserGladCard" )

	AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "#B_BUTTON_CLOSE", "#B_BUTTON_CLOSE", null, CanNavigateBack )
	AddMenuFooterOption( menu, LEFT, BUTTON_X, true, "#CLUB_REQUEST_ACTION_ACCEPT", "#CLUB_REQUEST_ACTION_ACCEPT_PC", AcceptButton_OnClick )
	AddMenuFooterOption( menu, LEFT, BUTTON_Y, true, "#CLUB_REQUEST_ACTION_DENY", "#CLUB_REQUEST_ACTION_DENY_PC", DenyButton_OnClick )

	AddMenuEventHandler( file.menu, eUIEvent.MENU_OPEN, PetitionsMenu_OnOpen )
	AddMenuEventHandler( file.menu, eUIEvent.MENU_CLOSE, PetitionsMenu_OnClose )
}

void function OpenJoinRequestsMenu()
{
	AdvanceMenu( file.menu )
}

void function PetitionsMenu_OnOpen()
{
	                 

	RefreshPetitionsListGrid()
}

void function PetitionsMenu_OnClose()
{
	Signal( uiGlobal.signalDummy, "HaltPreviewClubMemberCosmetics" )
	RunMenuClientFunction( "ClearAllCharacterPreview" )
}

bool function CanNavigateBack()
{
	if ( GetActiveMenu() != file.menu )
		return false

	return true
}

void function ClubJoinRequests_RefreshJoinRequests()
{
	int requestsRemaining = ClubJoinRequestsCount()
	if ( requestsRemaining > 0 )
	{
		printf( "ClubRequestDebug: %s(): %i requests remaining", FUNC_NAME(), requestsRemaining )
		RefreshPetitionsListGrid()
	}
	else
	{
		CloseJoinRequestsMenu()
		return
	}

	ClubLanding_BeginLandingRefresh()
}

                               
   
  	                                                                                         
   

void function RefreshPetitionsListGrid()
{
	printf( "ClubJoinPetitionDebug: RefreshPetitionsListGrid()" )

	if ( GetActiveMenu() != file.menu )
		return

	foreach ( var button in file.buttons )
	{
		Hud_RemoveEventHandler( button, UIE_CLICK, JoinRequestButton_OnClick )
		printf( "ClubJoinPetitionDebug: Removing Right Click Event for Join Request Button" )
		                                                                                  
	}

	int buttonCount = ClubJoinRequestsCount()

	if ( file.buttons.len() > buttonCount )
	{
		file.buttons.resize( buttonCount )
	}

	if ( buttonCount == 0 )
	{
		CloseActiveMenu()
		return
	}

	Hud_InitGridButtons( file.requestsGrid, buttonCount )

	var gridScrollPanel = Hud_GetChild( file.requestsGrid, "ScrollPanel" )
	array<ClubJoinRequest> joinRequestsArray = ClubGetJoinRequests();
	for ( int btnIndex; btnIndex < buttonCount; btnIndex++ )
	{
		ClubJoinRequest joinRequest = joinRequestsArray[ btnIndex ]
		var button = Hud_GetChild( gridScrollPanel, format( "GridButton%d", btnIndex ) )
		file.buttonToRequestMap[ button ] <- joinRequest

		var buttonRui = Hud_GetRui( button )
		RuiSetString( buttonRui, "playerName", joinRequest.userName )

		int buttonIdx = file.buttons.find( button )
		if ( buttonIdx == -1 )
			file.buttons.append( button )
	}

	foreach ( var button in file.buttons )
	{
		Hud_AddEventHandler( button, UIE_CLICK, JoinRequestButton_OnClick )
		printf( "ClubJoinPetitionDebug: Adding Right Click Event for Join Request Button" )
		                                                                               
	}

	bool selectedRequestIsValid = false
	for ( int i = 0; i < file.buttons.len(); i++ )
	{
		if ( file.buttonToRequestMap[ file.buttons[i] ] == file.selectedJoinRequest )
		{
			selectedRequestIsValid = true
		}
	}
	if ( selectedRequestIsValid )
	{
		UpdateApplicantDisplay()
	}
	else
	{
		FindBestRequestAndSelect()
	}
}

void function SetSelectedRequest( var button, ClubJoinRequest request )
{
	file.selectedJoinRequest = request
	file.selectedRequestIndex = file.buttons.find( button )
	Hud_SetSelected( button, true )
	UpdateApplicantDisplay()
	UpdateFooterOptions()
}

void function FindBestRequestAndSelect()
{
	if ( ClubJoinRequestsCount() == 0 )
		return

	if ( file.selectedRequestIndex < 0 )
	{
		file.selectedRequestIndex = 0
	}
	else if ( file.selectedRequestIndex >= file.buttons.len() )
	{
		file.selectedRequestIndex = file.buttons.len() - 1
	}

	var selectedButton = file.buttons[ file.selectedRequestIndex ]
	SetSelectedRequest( selectedButton, file.buttonToRequestMap[ selectedButton ] )
}

void function JoinRequestButton_OnClick( var button )
{
	                                                              
	SetSelectedRequest( button, file.buttonToRequestMap[ button ] )
	printf( "ClubRequestDebug: %s(): Displaying details for %s", FUNC_NAME(), file.selectedJoinRequest.userName )
	UpdateApplicantDisplay()
	UpdateFooterOptions()
}

                                                            
   
  	                                                                 
  	                                                               
  	                                                                                         
  	                                      
  	                          
   

void function UpdateApplicantDisplay()
{
	                                                          
	                                                                                  

	ShowDetailsPanel( true )
	thread UpdateApplicantGladCardThread( file.gladCard, file.selectedJoinRequest )
}

void function UpdateApplicantGladCardThread( var gladCard, ClubJoinRequest joinRequest )
{
	Signal( uiGlobal.signalDummy, "HaltPreviewClubMemberCosmetics" )
	EndSignal( uiGlobal.signalDummy, "HaltPreviewClubMemberCosmetics" )

	WaitFrame()
	WaitFrame()
	WaitFrame()

	string memberHardware = GetNameFromHardware( joinRequest.userHardware )
	string memberUid = joinRequest.platformUid
	string introQuipSoundEventName = ""
	CommunityUserInfo ornull userInfo = GetUserInfo( memberHardware, memberUid )

	if ( userInfo == null )
		return

	expect CommunityUserInfo( userInfo )

	SetupMenuGladCard( gladCard, "card", false )

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

	OnThreadEnd( void function() : ( introQuipSoundEventName ) {
		SetupMenuGladCard( null, "", false )

		if ( introQuipSoundEventName != "" )
			StopUISoundByName( introQuipSoundEventName )
	} )

	WaitForever()
}

void function ShowDetailsPanel( bool doShow )
{
	Hud_SetVisible( file.userDetailsPanel, doShow )
}


void function AcceptButton_OnClick( var button )
{
	ClubRequest_AcceptJoinRequest( file.selectedJoinRequest, true )
}

void function DenyButton_OnClick( var button )
{
	ClubRequest_AcceptJoinRequest( file.selectedJoinRequest, false )
}


bool function CanCloseDialog()
{
	return GetActiveMenu() == file.menu
}

bool function CanAcceptOrDeny()
{
	return ClubGetJoinRequests().contains( file.selectedJoinRequest )
}

void function CloseJoinRequestsMenu()
{
	if ( GetActiveMenu() != file.menu )
		return

	CloseActiveMenu()
}

void function CancelButton_OnActivate( var button )
{
	if ( !CanCloseDialog() )
		return

	CloseActiveMenu()
}