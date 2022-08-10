
global function InitSocialEventPopup
global function SocialEventUpdate
global function IsSocialPopUpAClubInvite
global function IsSocialPopupActive
global function TryUpdatePartyInvitePresence
global function SocialEvent_RemoveActiveClubInvite

#if DEV
global function SocialEvent_AddDevEvent
global function DevDumpFakeLists
global function DevRemoveFakeData
#endif

global function SocialPopup_GetPartyInviteReasonString

const BAR_COLOR_FRIEND = <29, 162, 255>
const BAR_COLOR_PARTY = <255, 78, 29>
const BAR_COLOR_CLUB = <94, 6, 203>

enum eSocialEventType
{
	PARTY,
	FRIEND,
	CLUB
}

global enum eInviteReason
{
	REASON_00_NONE,
	REASON_01_TRIOS,
	REASON_02_DUOS,
	REASON_03_ARENAS,
	REASON_04_RANKED,
	REASON_06_ANYMODE,
	REASON_07_GRINDING,

	_count
}

const string PARTY_INVITE_SIGNAL = "PartyInviteDisplayed"
const string CLUB_PARTY_INVITE_PRESENCE_UPDATE = "ClubPartyInvitePresenceUpdated"
const float DEFAULT_AUTOREJECT_TIME = 30.0


struct SocialEvent
{
	string name
	string eventID
	int    entryIndex
	int    hardwareID = -1                         
	int    eventType
	bool   completed
	bool   active
	float  timeStamp
	float  autoRejectionTime
	int    inviteReason = -1
	int    maxpartySize = 3
	int    currentPartySize = 1
	EadpPresenceData& eventPresence
}


struct
{
	var eventPanel
	var contentPanel
	array<var> buttonArray

	LobbyPopup         socialEventPopup
	array<SocialEvent> socialEventCache
	SocialEvent&       activeSocialEvent

	bool socialPopupActive
	bool activeEventInvalid
	bool blockInput

	table<int, string> inviteReasonMap
} file


void function InitSocialEventPopup( var panel )
{
	file.eventPanel = panel
	file.contentPanel = Hud_GetChild( panel, "Content" )

	file.buttonArray.append( Hud_GetChild( panel, "AcceptButton" ) )
	file.buttonArray.append( Hud_GetChild( panel, "RejectButton" ) )
	file.buttonArray.append( Hud_GetChild( panel, "BlockButton" ) )

	                                                                
	Hud_AddEventHandler( file.buttonArray[0], UIE_CLICK, void function( var btn ) { EventFriendRequest_HandleInput( KEY_Y ) } )         
	Hud_AddEventHandler( file.buttonArray[1], UIE_CLICK, void function( var btn ) { EventFriendRequest_HandleInput( KEY_N ) } )         
	Hud_AddEventHandler( file.buttonArray[2], UIE_CLICK, void function( var btn ) { EventFriendRequest_HandleInput( KEY_B ) } )        

	file.socialEventPopup.onClose = SocialEventPopup_OnClose
	file.socialEventPopup.checkBlocksInput = EventFriendRequest_CheckBlocksInput
	file.socialEventPopup.handleInput = EventFriendRequest_HandleInput

	AddCallback_OnPartyUpdated( SocialEventUpdate )

	RegisterSignal( "SocialEventPopupClosed" )
	RegisterSignal( PARTY_INVITE_SIGNAL )
	RegisterSignal( CLUB_PARTY_INVITE_PRESENCE_UPDATE )

	file.inviteReasonMap[ eInviteReason.REASON_00_NONE ] <- ""
	file.inviteReasonMap[ eInviteReason.REASON_01_TRIOS ] <- "#PARTY_INVITE_REASON_01_TRIOS"
	file.inviteReasonMap[ eInviteReason.REASON_02_DUOS ] <- "#PARTY_INVITE_REASON_02_DUOS"
	file.inviteReasonMap[ eInviteReason.REASON_03_ARENAS ] <- "#PARTY_INVITE_REASON_03_ARENAS"
	file.inviteReasonMap[ eInviteReason.REASON_04_RANKED ] <- "#PARTY_INVITE_REASON_04_RANKED"
	file.inviteReasonMap[ eInviteReason.REASON_06_ANYMODE ] <- "#PARTY_INVITE_REASON_06_ANYMODE"
	file.inviteReasonMap[ eInviteReason.REASON_07_GRINDING ] <- "#PARTY_INVITE_REASON_07_GRINDING"
}


void function SocialEventUpdate()
{
	if ( IsDialog( GetActiveMenu() ) || !IsLobby() )
		return

	file.activeEventInvalid = false

	UpdateFriendRequestCache()
	UpdatePartyInviteCache()
	UpdateClubInviteCache()

	SocialEvent_TryPurgeCrossplayFriendRequests()
	SocialEvent_TryPurgeCrossplayPartyInvites()

	SortSocialEventCache()

	if ( HasActiveLobbyPopup() )
	{
		SocialEvent activeEvent = GetActiveSocialEvent()
		if ( IsValidSocialEvent( activeEvent ) == true )
		{
			UpdateActivePartyInviteEventDetails( activeEvent )
		}
		else if ( file.activeEventInvalid || GetPendingSocialEvent() != file.activeSocialEvent )
		{
			TryShowNextSocialEvent()
		}

		return
	}

	SocialEvent ornull event = GetPendingSocialEvent()
	if ( event == null )
		return
	expect SocialEvent( event )

	SetActiveSocialEvent( event )
	UpdateSocialEventRui( event )
	ShowSocialEventPopup( event )
	SetActiveLobbyPopup( file.socialEventPopup )

	thread BlockInputForDuration( 1.2 )
}

bool function CompareSocialEvents( SocialEvent ornull first, SocialEvent ornull second ){
	if( first == null || second == null ) return false

	SocialEvent firstnonull = expect SocialEvent ( first )
	SocialEvent secondnonull = expect SocialEvent ( second )

	if( firstnonull.eventID != secondnonull.eventID ) return false
	if( firstnonull.inviteReason != secondnonull.inviteReason ) return false
	if( firstnonull.eventType != secondnonull.eventType ) return false

	return true
}

void function SocialEvent_TryPurgeCrossplayFriendRequests()
{
	if ( IsMatchPreferenceFlagActive( eMatchPreferenceFlags.CROSSPLAY_INVITE_AUTO_DENY ) )
	{
		array<SocialEvent> events = clone file.socialEventCache
		foreach ( SocialEvent event in events )
		{
			if ( event.eventType == eSocialEventType.FRIEND )
			{
				EADP_RejectFriendRequestByEAID( event.eventID )
				int pos = file.socialEventCache.find( event )
				file.socialEventCache.remove( pos )
			}
		}
	}
}


void function SocialEvent_TryPurgeCrossplayPartyInvites()
{
	                                                                         
	array<SocialEvent> events = clone file.socialEventCache
	foreach ( SocialEvent event in events )
	{
		if( event.eventType == eSocialEventType.PARTY )
		{
			 if(event.hardwareID  >= 0 && event.hardwareID  <= HARDWARE_XB5 )
			 {
				string hardware = GetNameFromHardware( event.hardwareID )
				                                                                                                                                                    
				if ( event.hardwareID == HARDWARE_PC_STEAM )
					hardware = GetNameFromHardware( HARDWARE_PC )                          

				if (  IsInPartyWithHardware( event.eventID, hardware ) )
				{
					EADP_RejectInviteToPlay( event.eventID )
					int pos = file.socialEventCache.find( event )
					file.socialEventCache.remove( pos )
				}
			}
			else
			{
				                                
				EADP_RejectInviteToPlay( event.eventID )
				int pos = file.socialEventCache.find( event )
				file.socialEventCache.remove( pos )			
			}
		}
	}
}


bool function IsInPartyWithHardware( string id, string hardware )
{
	Party party = GetParty()
	foreach (partyMember in party.members)
	{
		if ( partyMember.eaid == id && partyMember.hardware == hardware )
			return true
	}

	return false
}


void function SortSocialEventCache()
{
	file.socialEventCache.sort( int function( SocialEvent a, SocialEvent b ) {
		if ( a.eventType < b.eventType )
			return -1
		if ( b.eventType < a.eventType )
			return 1

		if ( a.timeStamp < b.timeStamp )
			return -1
		if ( b.timeStamp < a.timeStamp )
			return 1

		if ( a.entryIndex < b.entryIndex )
			return -1
		if ( b.entryIndex < a.entryIndex )
			return 1

		return 0
	} )
}


SocialEvent ornull function GetPendingSocialEvent()
{
	foreach ( SocialEvent event in file.socialEventCache )
	{
		                                            
		if ( IsValidSocialEvent( event ) )
			return event
	}
	return null
}


void function SetActiveSocialEvent( SocialEvent event )
{
	file.activeSocialEvent = event
}


SocialEvent function GetActiveSocialEvent()
{
	return file.activeSocialEvent
}


void function UpdateSocialEventRui( SocialEvent event )
{
	HudElem_SetRuiArg( file.contentPanel, "actionTaken", -1 )

	HudElem_SetRuiArg( file.contentPanel, "eventSubText", event.name )
	HudElem_SetRuiArg( file.contentPanel, "eventActionHint1", "#POPUP_BUTTON_ACCEPT" )
	HudElem_SetRuiArg( file.contentPanel, "eventActionHint2", "#POPUP_BUTTON_REJECT" )
	HudElem_SetRuiArg( file.contentPanel, "hardwareIconStr", PlatformIDToIconString( event.hardwareID ) )
	RuiDestroyNestedIfAlive( Hud_GetRui( file.contentPanel ), "clubLogo" )

	switch ( event.eventType )
	{
		case eSocialEventType.FRIEND:
			HudElem_SetRuiArg( file.contentPanel, "eventHeader", "#FRIEND_REQUEST" )
			HudElem_SetRuiArg( file.contentPanel, "eventActionHint3", "#POPUP_BUTTON_BLOCK" )
			RuiSetArgByType( Hud_GetRui( file.contentPanel ), "lineColor", BAR_COLOR_FRIEND / 255.0, eRuiArgType.COLOR )
			break

		case eSocialEventType.PARTY:
			string eventHeader = "#PARTY_INVITE"
			bool isClubPartyInvite = Clubs_IsUserAClubmate( event.eventID )
			if ( isClubPartyInvite )
				eventHeader = "#CLUB_POPUP_PARTY_INVITE"

			HudElem_SetRuiArg( file.contentPanel, "eventHeader", eventHeader )
			HudElem_SetRuiArg( file.contentPanel, "eventActionHint3", "#POPUP_BUTTON_BLOCK" )
			RuiSetArgByType( Hud_GetRui( file.contentPanel ), "lineColor", BAR_COLOR_PARTY / 255.0, eRuiArgType.COLOR )

#if DEV
			if ( GetBugReproNum() == 1970 )
			{
				if ( ClubIsValid() )
					ClubLogoUI_CreateNestedClubLogo( Hud_GetRui( file.contentPanel ), "clubLogo", ClubLogo_ConvertLogoStringToLogo( ClubGetHeader().logoString ) )                             
				else
					ClubLogoUI_CreateNestedClubLogo( Hud_GetRui( file.contentPanel ), "clubLogo", GenerateRandomClubLogo() )

				                                                   
				event.inviteReason = eInviteReason.REASON_02_DUOS                               
				event.maxpartySize = GetPartyInviteMaxPartySize( event.inviteReason )
				event.currentPartySize = GetRandomPartySlotsFilled( event.maxpartySize )
			}
#endif
			if ( isClubPartyInvite )
			{
				                                                                                   
				ClubLogo logo = ClubLogo_ConvertLogoStringToLogo( ClubGetHeader().logoString )
				ClubLogoUI_CreateNestedClubLogo( Hud_GetRui( file.contentPanel ), "clubLogo", logo )
			}

			if ( event.inviteReason > -1 )
			{
				HudElem_SetRuiArg( file.contentPanel, "displayTime", event.autoRejectionTime )
				string inviteReasonString = SocialPopup_GetPartyInviteReasonString( event.inviteReason )
				printf( "PartyInviteDebug: Reason for invite is %s (index %i)", Localize( inviteReasonString ), event.inviteReason )
				HudElem_SetRuiArg( file.contentPanel, "eventReason", inviteReasonString )
				HudElem_SetRuiArg( file.contentPanel, "maxPartySize", event.maxpartySize, eRuiArgType.INT )
				printf( "PartyInviteDebug: Max party invite size set to %i", event.maxpartySize )
				HudElem_SetRuiArg( file.contentPanel, "currentPartySize", event.currentPartySize, eRuiArgType.INT )                                                                            

				                                             
			}
			break

		case eSocialEventType.CLUB:
			HudElem_SetRuiArg( file.contentPanel, "eventHeader", "#CLUB_POPUP_INVITE" )
			HudElem_SetRuiArg( file.contentPanel, "eventActionHint3", "" )
			RuiSetArgByType( Hud_GetRui( file.contentPanel ), "lineColor", BAR_COLOR_CLUB / 255.0, eRuiArgType.COLOR )
			                                                                                                         
			break
	}

	UpdateButtons()
}


void function UpdateActivePartyInviteEventDetails( SocialEvent event )
{
	SocialEvent currentEvent = GetActiveSocialEvent()
	if ( event.eventID != currentEvent.eventID )
		return

	UpdateSocialEventRui( event )
}


string function SocialPopup_GetPartyInviteReasonString( int eventReasonIdx )
{
	if ( eventReasonIdx in file.inviteReasonMap )
		return file.inviteReasonMap[ eventReasonIdx ]

	return ""
}


int function GetPartyInviteMaxPartySize( int eventReasonIdx )
{
	int maxPartySize = 3
	switch( eventReasonIdx )
	{
		case eInviteReason.REASON_02_DUOS:
			maxPartySize = 2
			break
		default:
			maxPartySize = 3
			break
	}

	return maxPartySize
}


void function AutoRejectPartyInviteThread( SocialEvent event )
{
	Assert( IsNewThread(), "Must be threaded off" )

	if ( event.eventType != eSocialEventType.PARTY )
		return

	Signal( uiGlobal.signalDummy, PARTY_INVITE_SIGNAL )
	EndSignal( uiGlobal.signalDummy, PARTY_INVITE_SIGNAL )
	EndSignal( uiGlobal.signalDummy, "SocialEventPopupClosed" )

	float startTime = UITime()
	float rejectionTime = startTime + event.autoRejectionTime

	OnThreadEnd(
		function(): ( event, rejectionTime )
		{
			if ( UITime() >= rejectionTime )
			{
				AutoRejectPartyInvite( event )
			}
		}
	)

	while ( UITime() < rejectionTime )
	{
		WaitFrame()
	}
}


void function AutoRejectPartyInvite( SocialEvent event )
{
	if ( event.eventType != eSocialEventType.PARTY )
		return

	EADP_RejectInviteToPlay( event.eventID )

	#if DEV
		DevRemoveFakeData( event.eventID, event.eventType )
	#endif
	SocialEventMarkCompleted( event, 1 )
	TryShowNextSocialEvent()
}


#if DEV
int function GetRandomPartyInviteReason()
{
	return RandomIntRange(1, eInviteReason._count)
}

int function GetRandomPartySlotsFilled( int maxSlots )
{
	return RandomIntRange( 1, maxSlots )
}
#endif


void function ShowSocialEventPopup( SocialEvent event )
{
	file.socialPopupActive = true
	Hud_Show( file.eventPanel )

	HudElem_SetRuiArg( file.contentPanel, "shouldShow", true )
}


bool function IsValidSocialEvent( SocialEvent event )
{
	if ( event.completed )
		return false

	if ( event.eventType == eSocialEventType.CLUB )
	{
		if ( ClubIsValid() )                                                        
			return false
	}

	if ( event.eventType == eSocialEventType.PARTY )
	{
		                                                    
		if ( Clubs_IsUserAClubmate( event.eventID ) && GetPartySize() > 1 )
			return false
	}

	return true
}


void function UpdateFriendRequestCache()
{
	EadpPeopleList requestData = EADP_GetFriendRequestList()
	if ( !requestData.isValid )
		return

	#if DEV
		if ( GetBugReproNum() == 1970 )
		{
			requestData.people.extend( DevGetFakeFriendList() )
		}
	#endif

	for ( int cacheIndex = 0; cacheIndex < file.socialEventCache.len(); cacheIndex++ )
	{
		SocialEvent event = file.socialEventCache[ cacheIndex ]

		if ( event.completed || event.eventType != eSocialEventType.FRIEND )
			continue                                                        

		bool eventValid = false
		foreach ( int index, EadpPeopleData request in requestData.people )
		{
			if ( event.eventID == request.eaid )
			{
				requestData.people.remove( index )
				eventValid = true
				break                          
			}
		}

		if ( !eventValid )
		{
			                        
			file.socialEventCache.remove( cacheIndex )
			cacheIndex--                                                            

			SocialEvent activeEvent = GetActiveSocialEvent()
			if ( activeEvent == event )
				file.activeEventInvalid = true
			continue
		}
	}

	foreach ( EadpPeopleData request in requestData.people )
	{
		if ( IsInEventCashe( request.eaid, eSocialEventType.FRIEND ) )
			continue

		SocialEvent newEvent
		newEvent.eventType = eSocialEventType.FRIEND
		newEvent.name = request.platformName
		newEvent.eventID = request.eaid
		newEvent.hardwareID = GetHardwareFromName( request.platformHardware )
		newEvent.timeStamp = UITime()
		newEvent.entryIndex = file.socialEventCache.len()

		file.socialEventCache.append( newEvent )
	}
}


void function UpdatePartyInviteCache()
{
	EadpInviteToPlayList inviteToPlayList = EADP_GetInviteToPlayList()
	if ( !inviteToPlayList.isValid )
		return

	if ( !IsFullyConnected() )
		return

	if ( !IsValid( GetLocalClientPlayer() ) )
		return

	if ( !IsLobby() )
		return

	#if DEV
		if ( GetBugReproNum() == 1970 )
		{
			inviteToPlayList.invitations.extend( DevGetFakePartyList() )
		}
	#endif

	for ( int cacheIndex = 0; cacheIndex < file.socialEventCache.len(); cacheIndex++ )
	{
		SocialEvent event = file.socialEventCache[ cacheIndex ]

		if ( event.completed || event.eventType != eSocialEventType.PARTY )
			continue                                                        

		bool eventValid = false
		foreach ( int index, EadpInviteToPlayData invite in inviteToPlayList.invitations )
		{
			if ( event.eventID == invite.eaid )
			{
				inviteToPlayList.invitations.remove( index )
				eventValid = true
				break                          
			}
		}

		if ( !eventValid )
		{
			                        
			file.socialEventCache.remove( cacheIndex )
			cacheIndex--                                                               

			SocialEvent activeEvent = GetActiveSocialEvent()
			if ( activeEvent == event )
				file.activeEventInvalid = true
			continue
		}
	}

	foreach ( EadpInviteToPlayData invite in inviteToPlayList.invitations )
	{
		if ( IsInEventCashe( invite.eaid, eSocialEventType.PARTY ) )
			continue

		string eaid = GetLocalClientPlayer().GetPINNucleusId()
		int hardwareId = GetHardwareFromName( GetUnspoofedPlayerHardware() )

		if ( invite.eaid == eaid && invite.hardware == hardwareId )
			continue                                                         

		SocialEvent newEvent
		newEvent.eventType = eSocialEventType.PARTY
		newEvent.name = invite.name
		newEvent.eventID = invite.eaid
		newEvent.hardwareID = invite.hardware
		newEvent.timeStamp = UITime()
		newEvent.entryIndex = file.socialEventCache.len()
		newEvent.inviteReason = invite.reason
		newEvent.maxpartySize = GetPartyInviteMaxPartySize( invite.reason )

		if ( invite.eadpPresence != null )
		{
			EadpPresenceData presenceData = expect EadpPresenceData( invite.eadpPresence )
			newEvent.eventPresence = clone( presenceData )

			PresenceState presence = expect PresenceState( presenceData.presence )
			newEvent.currentPartySize = presence.party_slotsUsed
		}

		file.socialEventCache.append( newEvent )
	}
}


void function UpdateClubInviteCache()
{
	if ( !IsPersistenceAvailable() )
	{
		return
	}

	array<ClubInvite> clubInviteList = ClubGetInvitedClubsList()
	if ( !Clubs_DoIMeetMinimumLevelRequirement() )
	{
		                                                                                                                             
		return
	}

		                                                                                          
	if ( !AreClubInvitesEnabled() )
	{
		                                                                                      
		return
	}

	if ( Clubs_IsSwitchingClubs() )
	{
		                                                                                                                                
		return
	}

	                                                                                                                                            

	#if DEV
		if ( GetBugReproNum() == 1970 )
		{
			clubInviteList.extend( DevGetFakeClubList() )
		}
	#endif

	for ( int cacheIndex = 0; cacheIndex < file.socialEventCache.len(); cacheIndex++ )
	{
		SocialEvent event = file.socialEventCache[ cacheIndex ]

		if ( event.completed || event.eventType != eSocialEventType.CLUB )
			continue                                                        

		bool eventValid = false
		foreach ( int index, ClubInvite invite in clubInviteList )
		{
			if ( event.eventID == invite.clubID )
			{
				clubInviteList.remove( index )
				eventValid = true
				break                          
			}
		}

		if ( !eventValid )
		{
			                                                   
			file.socialEventCache.remove( cacheIndex )
			cacheIndex--                                                               

			SocialEvent activeEvent = GetActiveSocialEvent()
			if ( activeEvent == event )
				file.activeEventInvalid = true
			continue
		}
	}

	foreach ( ClubInvite invite in clubInviteList )
	{
		if ( IsInEventCashe( invite.clubID, eSocialEventType.CLUB ) )
			continue

		SocialEvent newEvent
		newEvent.eventType = eSocialEventType.CLUB
		newEvent.name = invite.name
		newEvent.eventID = invite.clubID
		newEvent.hardwareID = -1
		newEvent.timeStamp = UITime()
		newEvent.entryIndex = file.socialEventCache.len()

		file.socialEventCache.append( newEvent )
	}
}


void function SocialEvent_RemoveActiveClubInvite( ClubHeader club )
{
	printf( "SocialEventDebug: %s()", FUNC_NAME() )
	foreach ( cachedEvent in file.socialEventCache )
	{
		if ( cachedEvent.eventID == club.clubID )
		{
			printf( "SocialEventDebug: %s(): Found club invite in cache. Removing.", FUNC_NAME() )
			file.socialEventCache.removebyvalue( cachedEvent )
		}
	}

	SocialEvent activeEvent = GetActiveSocialEvent()
	if ( activeEvent.eventID == club.clubID )
	{
		printf( "SocialEventDebug: %s(): Club invite is active display. Forcing update.", FUNC_NAME() )
		TryShowNextSocialEvent()
	}
}


bool function IsInEventCashe( string eventID, int eventType )
{
	foreach ( SocialEvent event in file.socialEventCache )
	{
		if ( event.eventID == eventID && event.eventType == eventType )
			return true
	}
	return false
}


void function BlockInputForDuration( float duration )
{
	Assert( IsNewThread(), "Must be threaded off." )
	EndSignal( uiGlobal.signalDummy, "SocialEventPopupClosed" )

	OnThreadEnd( function() {
		file.blockInput = false
		UpdateButtons()
	} )

	file.blockInput = true
	UpdateButtons()

	wait duration
}


void function UpdateButtons()
{
	foreach ( button in file.buttonArray )
	{
		if ( file.blockInput )
			Hud_Hide( button )
		else
			Hud_Show( button )
	}

	if ( file.activeEventInvalid || file.activeSocialEvent.eventType == eSocialEventType.CLUB )
		Hud_Hide( file.buttonArray[2] )                                                            
}


void function SocialEventPopup_OnClose()
{
	                                                                                
	Signal( uiGlobal.signalDummy, "SocialEventPopupClosed" )

	HudElem_SetRuiArg( file.contentPanel, "shouldShow", false )

	file.blockInput = false
	file.socialEventCache.clear()
	file.socialPopupActive = false
	Hud_Hide( file.eventPanel )
}


bool function EventFriendRequest_CheckBlocksInput( int inputID )
{
	if ( inputID == BUTTON_X || inputID == KEY_N || inputID == KEY_Y || inputID == BUTTON_Y || inputID == BUTTON_STICK_LEFT || inputID == KEY_B )
		return true

	if ( inputID == KEY_ESCAPE || inputID == BUTTON_B )
		return true

	return false
}


bool function EventFriendRequest_HandleInput( int inputID )
{
	if ( file.blockInput )
		return false                                         

	SocialEvent event = GetActiveSocialEvent()

	if ( inputID == BUTTON_X || inputID == KEY_Y )
	{
		switch( event.eventType )
		{
			case eSocialEventType.FRIEND:
				EADP_AcceptFriendRequestByEAID( event.eventID )
				break

			case eSocialEventType.PARTY:
				EADP_AcceptInvitToPlay( event.eventID )
				break

			case eSocialEventType.CLUB:
				Clubs_JoinClub( event.eventID )
				                           
				break
		}

		#if DEV
			DevRemoveFakeData( event.eventID, event.eventType )
		#endif
		SocialEventMarkCompleted( event, 0 )
		TryShowNextSocialEvent()
		return true
	}
	else if ( inputID == BUTTON_Y || inputID == KEY_N )
	{
		switch( event.eventType )
		{
			case eSocialEventType.FRIEND:
				EADP_RejectFriendRequestByEAID( event.eventID )
				break

			case eSocialEventType.PARTY:
				EADP_RejectInviteToPlay( event.eventID )
				break

			case eSocialEventType.CLUB:
				SendClubInviteRejectionToPIN( event )
				ClubInviteDecline( event.eventID )
				thread ClubDiscovery_ProcessInvitesAndRefreshDisplay()
				break
		}

		#if DEV
			DevRemoveFakeData( event.eventID, event.eventType )
		#endif
		SocialEventMarkCompleted( event, 1 )
		TryShowNextSocialEvent()

		return true
	}
	else if ( inputID == BUTTON_STICK_RIGHT || inputID == KEY_B )
	{
		if ( event.eventType == eSocialEventType.FRIEND || event.eventType == eSocialEventType.PARTY )
			SocialEventBlockPlayerDialog( event )

		return true
	}

	return false
}


void function SocialEventMarkCompleted( SocialEvent event, int actionTaken )
{
	Assert( event.completed == false )
	event.completed = true

	HudElem_SetRuiArg( file.contentPanel, "actionTaken", actionTaken )
}


void function TryShowNextSocialEvent()
{
	SocialEvent ornull event = GetPendingSocialEvent()
	if ( event == null )
	{
		                        
		thread function()
		{
			EndSignal( uiGlobal.signalDummy, "SocialEventPopupClosed" )
			OnThreadEnd( function() {
				SocialEventUpdate()
			} )

			HudElem_SetRuiArg( file.contentPanel, "shouldShow", false )
			thread BlockInputForDuration( 1.2 )

			wait(1.2)                               
			thread ClearActiveLobbyPopup()                                                         
		}()
	}
	else
	{
		                                   
		expect SocialEvent( event )

		thread function() : (event )
		{
			EndSignal( uiGlobal.signalDummy, "SocialEventPopupClosed" )
			OnThreadEnd( function() {
				SocialEventUpdate()
			} )

			                       
			if( !CompareSocialEvents( event, file.activeSocialEvent ) )                                
			{
				RuiSetArgByType( Hud_GetRui( file.contentPanel ), "transitionStartTime", ClientTime(), eRuiArgType.GAMETIME )
				thread BlockInputForDuration( 1.0 )
			}

			SetActiveSocialEvent( event )                                                                         
			wait(0.4)                                                   

			UpdateSocialEventRui( event )
		}()
	}
}


void function SocialEventBlockPlayerDialog( SocialEvent event )
{
	ShowBlockPlayerDialog( event.name, event.eventID, void function( int dialogResult, string eaid ) : ( event ) {
		if ( dialogResult == eDialogResult.YES )
		{
			if ( event.eventType == eSocialEventType.FRIEND )
				EADP_RejectFriendRequestByEAID( eaid )
			else if ( event.eventType == eSocialEventType.PARTY )
				EADP_RejectInviteToPlay( eaid )

			#if DEV
				DevRemoveFakeData( event.eventID, event.eventType )
			#endif

			EADP_BlockByEAID( eaid )

			SocialEventMarkCompleted( event, 2 )
			TryShowNextSocialEvent()
		}
		else
		{
			                                            
		}
	} )
}


void function SendClubInviteRejectionToPIN( SocialEvent event )
{
	ClubHeader clubHeader
	clubHeader.clubID = event.eventID
	clubHeader.name = event.name
	PIN_Club_DeclineInvite( clubHeader )
}

bool function IsSocialPopUpAClubInvite()
{
	if ( file.activeEventInvalid == true )
		return false

	return file.activeSocialEvent.eventType == eSocialEventType.CLUB
}


bool function IsSocialPopupActive()
{
	return file.socialPopupActive
}


void function TryUpdatePartyInvitePresence( EadpPresenceData presence )
{
	if ( !IsSocialPopupActive() )
		return

	SocialEvent activeEvent = GetActiveSocialEvent()
	if ( activeEvent.eventPresence.presence != presence.presence )
		return

	bool shouldTestPresence = PartyInviteShouldCycle( presence )

	Signal( uiGlobal.signalDummy, CLUB_PARTY_INVITE_PRESENCE_UPDATE )
	EndSignal( uiGlobal.signalDummy, CLUB_PARTY_INVITE_PRESENCE_UPDATE )
	EndSignal( uiGlobal.signalDummy, "SocialEventPopupClosed" )

	OnThreadEnd( function() : (presence, shouldTestPresence)
	{
		                                                                                         
		if ( shouldTestPresence && PartyInviteShouldCycle( presence ) )
			TryShowNextSocialEvent()
	} )

	activeEvent.eventPresence = clone( presence )
	UpdateSocialEventRui( activeEvent )

	wait( 1.0 )
	shouldTestPresence = true
}


bool function PartyInviteShouldCycle( EadpPresenceData presence )
{
	if ( presence.online == false )
		return true

	if ( presence.partyInMatch == true )
		return true

	if ( presence.partyIsFull == true )
		return true

	if ( presence.isJoinable == false )
		return true

	SocialEvent activeEvent = GetActiveSocialEvent()

	PresenceState ornull pstate = presence.presence
	expect PresenceState( pstate )
	if ( activeEvent.inviteReason == eInviteReason.REASON_02_DUOS && pstate.party_slotsUsed >= 2 )
		return true

	return false
}





#if DEV
array< EadpPeopleData > devFriendList
array< EadpInviteToPlayData > devPartyList
array< ClubInvite > devClubList
int friendIndex

array< EadpPeopleData > function DevGetFakeFriendList()
{
	return devFriendList
}


array< EadpInviteToPlayData > function DevGetFakePartyList()
{
	return devPartyList
}


array<ClubInvite> function DevGetFakeClubList()
{
	return devClubList
}


void function DevRemoveFakeData( string eventID, int eventType )
{
	if ( GetBugReproNum() != 1970 )
		return

	switch( eventType )
	{
		case eSocialEventType.FRIEND:
			foreach ( index, data in devFriendList )
			{
				if ( data.eaid == eventID )
					devFriendList.remove( index )
			}
			break

		case eSocialEventType.PARTY:
			foreach ( index, data in devPartyList )
			{
				if ( data.eaid == eventID )
					devPartyList.remove( index )
			}            break

		case eSocialEventType.CLUB:
			foreach ( index, data in devClubList )
			{
				if ( data.clubID == eventID )
					devClubList.remove( index )
			}
			break
	}

	                           
	delaythread( 0.2 ) SocialEventUpdate()
}


void function DevDumpFakeLists()
{
	printt( "## devPartyList type:", eSocialEventType.PARTY, "count", devPartyList.len() )
	foreach ( data in devPartyList )
		printt( data.name, " - ", data.eaid )

	printt( "----" )
	printt( "## devFriendList type:", eSocialEventType.FRIEND, "count", devFriendList.len() )
	foreach ( data in devFriendList )
		printt( data.platformName, " - ", data.eaid )

	printt( "----" )
	printt( "## devClubList type:", eSocialEventType.CLUB, "count", devClubList.len() )
	foreach ( data in devClubList )
		printt( data.name, " - ", data.clubID )

	printt( "----" )
	printt( "## Event Cashe, count", file.socialEventCache.len() )
	foreach ( data in file.socialEventCache )
		printt( data.name, " - ", data.eventID, " - ", data.eventType )
}


void function SocialEvent_AddDevEvent( int eventType = eSocialEventType.FRIEND )
{
	                         

	printf( "SocialEventDebug: %s( %i )", FUNC_NAME(), eventType )

	switch( eventType )
	{
		case eSocialEventType.FRIEND:
			EadpPeopleData person
			person.eaid = "10000" + string( RandomIntRange( 10000000, 30000000 ) )
			person.name = "Friend Name #" + (devFriendList.len() + 1)                 
			person.platformName = "Friend Plfm Name #" + (++friendIndex)
			person.platformHardware = ["PC", "X1", "PS4"].getrandom()

			devFriendList.append( person )
			break

		case eSocialEventType.PARTY:
			printf( "SocialEventDebug: %s(): Adding party invite", FUNC_NAME() )
			EadpInviteToPlayData invite
			invite.name = "Party Friend Name #" + (++friendIndex)
			invite.eaid = "10000" + string( RandomIntRange( 10000000, 30000000 ) )                  		  	             	             	             
			invite.hardware = [HARDWARE_PC, HARDWARE_PS4, HARDWARE_XBOXONE].getrandom()               

			devPartyList.append( invite )
			break

		case eSocialEventType.CLUB:
			ClubInvite invite
			invite.name = "CoolClubName #" + (++friendIndex)
			invite.clubID = "10000" + string( RandomIntRange( 10000000, 30000000 ) )             

			devClubList.append( invite )
			break
	}

	                           
	delaythread( 0.2 ) SocialEventUpdate()
}
#endif       
