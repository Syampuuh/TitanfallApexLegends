global function Clubs_Init

                         
#if UI
global function Club_GetErrorStringForCode
global function Club_SetKickedForCrossplayIncompat
global function Clubs_CreateNewClub
global function Clubs_EditClubSettings
global function Clubs_FinalizeNewClub
global function Clubs_CanLeaveClub
global function Clubs_LeaveClub
global function Clubs_FinalizeLeaveClub

global function Clubs_GetDescStringForMinAccountLevel
global function Clubs_GetDescStringForPrivacyLevel
global function Clubs_GetDescStringForMinRank

global function Clubs_GetMinLevelFromSetting

global function Clubs_SetClubMemberRank

global function Clubs_CanKickUsers
global function Clubs_CanKickClubMember
global function Clubs_KickMember
#endif

                             
#if UI
global function Clubs_JoinClub
global function Clubs_SwitchClubsThread
global function Clubs_FinalizeClubSwitchThread
global function Clubs_SetIsSwitchingClubs
global function Clubs_IsSwitchingClubs
global function Clubs_FinalizeJoinClub
global function Clubs_GetJoinRequestsString
global function Clubs_DoesMeetJoinRequirements
#endif

                             
#if UI
global function ClubRequest_AcceptJoinRequest
#endif

                  
#if UI
global function Clubs_Search
global function Clubs_CompletedSearch
global function Clubs_InitSearchResultButton
#endif

                       
#if UI
global function Clubs_CompletedClubInviteQuery
#endif

                
global function GetAllClubLogoElementFlavors
global function GetAllClubLogoElementFlavorsOfType
global function GetRandomClubLogoElementFlavor
global function ClubLogo_GetLogoElementImage
global function ClubLogo_GetLogoSecondaryColorMask
global function ClubLogo_GetLogoFrameMask
global function ClubLogo_GetLogoElementName
global function ClubLogo_GetLogoElementType
global function ClubLogo_GetLogoVerticalOffset
global function ClubLogo_GetLogoColorTable
global function ClubLogo_GetColorSwatchCount

global function GenerateRandomClubLogo
global function ClubLogo_ConvertLogoToString
global function ClubLogo_ConvertLogoStringToLogo

#if UI
global function ClubLogoUI_CreateNestedClubLogo
#endif

                      
global function ClubSearchTag_GetAllEnabledSearchTags
global function ClubSearchTag_CreateSearchTagBitMask
global function ClubSearchTag_GetItemFlavorFromBitMaskAddress
global function ClubSearchTag_GetItemFlavorsFromBitMask
global function ClubSearchTag_GetTagString
global function ClubSearchTag_GetTagType
global function ClubSearchTag_GetSearchTagNamesFromBitmask

#if UI
global function ClubSearchTag_AddSearchTagToSelection
global function ClubSearchTag_RemoveSearchTagFromSelection
global function ClubSearchTag_GetSelectedSearchTags
global function ClubSearchTag_ClearSelectedSearchTags
global function ClubSearchTag_GetNamesOfSearchTagsFromArray
#endif

                    
#if CLIENT || UI
global function Clubs_AreObituaryTagsEnabledByPlaylist
#endif

#if UI
global function Clubs_IsValidClubTag
global function ClubTag_CreateNestedClubTag
#endif

                      
#if SERVER
                                                       
#endif

#if UI
global function ServerToUI_AddPlayerDataForPlacementReport
global function ServerToUI_Clubs_UpdateLastMatchTimes
global function Clubs_ReportMatchPlacementToClub
#endif

#if (UI && DEV)
global function DEV_ReportFakePlacementEvent
#endif

                  
#if UI
global function Clubs_Report
#endif

                           
global function ClubRegulation_GetReasonString

#if UI
global function ClubRegulation_GetComplaintsForMember
#endif

                  
global function Clubs_IsEnabled
global function Clubs_AreDisabledByPlaylist

#if SERVER
                                              
#endif

#if CLIENT
global function Clubs_UpdateCrossplayVar
global function Clubs_UIToClient_SetCrossplayVar
global function Clubs_SetMyStoredClubName
global function Clubs_GetMyStoredClubName
#endif

#if UI
global function ClubDataUpdateThread
global function Clubs_UpdateMyData
global function AddCallback_OnClubDataUpdated
global function RemoveCallback_OnClubDataUpdated
global function Clubs_CheckClubPersistenceThread
global function Clubs_PopulateClubDetails
global function Clubs_ConfigureRankTooltip
global function Clubs_ConfigurePrivacyTooltip
global function Clubs_ConfigureMinLevelAndRankTooltip

global function Clubs_IsUserAClubmate
global function Clubs_GetClubMemberNameFromNucleus
global function Clubs_GetClubMemberRankString
global function Clubs_GetPromotableRanks
global function Clubs_TryCloseAllClubMenus
global function Clubs_SetClubTabUserCount
global function Clubs_DoIMeetMinimumLevelRequirement
global function Clubs_MonitorCrossplayChangeThread

global function Clubs_AttemptRequeryThread
global function Clubs_SetClubQueryState
global function Clubs_GetClubQueryState
global function Clubs_IsClubQueryProcessing
global function AddCallback_OnClubQuerySuccessful
#endif

         
#if UI
global function Clubs_OpenErrorStringDialog
global function Clubs_OpenErrorDialog
global function Clubs_OpenClubJoinedDialog
global function Clubs_ShouldShowClubJoinedDialog
global function Clubs_OpenClubKickedDialog
global function Clubs_ShouldShowClubKickedDialog
global function Clubs_OpenJoinRequestDeniedDialog
global function Clubs_ShouldShowClubJoinRequestDeniedDialog
global function Clubs_OpenJoinReqsConfirmDialog
global function Clubs_OpenReportClubConfirmDialog
global function Clubs_OpenClubCreateBlockedByMatchmakingDialog
global function Clubs_OpenClubEditBlockedByMatchmakingDialog
global function Clubs_OpenClubManagementBlockedByMatchmakingDialog
global function Clubs_ShouldShowClubAnnouncementDialog
global function Clubs_OpenClubAnnouncementCooldownDialog
global function Clubs_OpenMemberManagementResetConfirmationDialog
global function Clubs_OpenCrossplayChangeDialog
global function Clubs_OpenCrossplayChangeConfirmationDialog
global function Clubs_OpenAcceptInviteConfirmationDialog
global function Clubs_OpenKickTargetIsNotAMemberDialog
global function Clubs_OpenJoinReqsChangedDialog
global function Clubs_OpenTooLowRankToInviteDialog
global function Clubs_OpenJoinRegionConfirmationDialog
global function Clubs_OpenSwitchClubsConfirmDialog
#endif

global const int CLUB_QUERY_RETRY_MAX = 5
global const string CLUB_REQUERY_SIGNAL = "ClubAttemptRequery"

global const string CLUB_UPDATE_TAB_SIGNAL = "ClubUpdateTabSignal"

global const int CLUB_LOGO_LAYER_MAX = 3
global const int CLUB_LOGO_LAYER_PROPERTY_COUNT = 3
global const string CLUB_LOGO_LAYER_DELIMITER = ";"
global const string CLUB_LOGO_PROPERTY_DELIMITER = ","
global const string CLUB_LOGO_COLORVEC_DELIMITER = "_"
global const string CLUB_EVENT_DELIMITER = "%"
global const float CLUB_LOGO_ROTATION_STEP = 45.0
global const int CLUB_SEARCH_MAX_RESULTS = 50
global const int CLUB_SEARCH_TAG_SELECTION_MAX = 5
global const int CLUB_TAG_LENGTH_MIN = 3
global const int CLUB_NAME_LENGTH_MIN = 4
global const int CLUB_ANNOUNCE_COOLDOWN_MINUTES = 15
global const int CLUB_JOIN_MIN_ACCOUNT_LEVEL = 9

global const string INVALID_CLUB_ID = ""
global const string PENDING_CLUB_REQUEST = "PendingClubRequest"
global const int INVALID_ANNOUNCE_VIEW_TIME = -1

global const array<string> ILLEGAL_CHAT_CHARS = ["%", "`"]

const int CLUB_MAX_NAME_LENGTH_FOR_CHAT = 16

global enum eClubLogoElementType
{
	CLUBLOGOTYPE_FRAME,
	CLUBLOGOTYPE_EMBLEM,
	CLUBLOGOTYPE_BACKGROUNDS,

	_count
}

global struct ClubLogoLayer
{
	ItemFlavor& elementFlav
	int			elementType
	vector      pos = <0.0,0.0,0.0>
	vector      scale = <1.0,1.0,0>
	float       rotation = 0.0
	vector      primaryColorOverride = <255,255,255>
	float		verticalOffset = 0.0
	vector      secondaryColorOverride = <255,255,255>
	float       secondaryColorAlpha = 1.0
	asset		frameMask
}

global struct ClubLogo
{
	array<ClubLogoLayer> logoLayers
	bool isInvite = false
}

struct ClubHSV
{
	float hue
	float saturation
	float value
}

global enum eClubMinAccountLevel
{
	MINLVL_10,
	MINLVL_50,
	MINLVL_100,
	MINLVL_200,
	MINLVL_300,
	MINLVL_400,
	MINLVL_500,

	_count
}

global enum eClubMinRank
{
	MINRANK_BRONZE,
	MINRANK_SILVER,
	MINRANK_GOLD,
	MINRANK_PLATINUM,
	MINRANK_DIAMOND,
	MINRANK_MASTER,
	MINRANK_APEXPREDATOR,

	_count
}

                              
global enum eClubInviteDisplayLevel
{
	DISABLED,
	ENABLED,

	_count
}

                                                                                         
global enum eClubSearchTagFlags
{
	                     
	MODES_RANKED = (1 << 0)
	MODES_UNRANKED = (1 << 1)
	MODES_DUOS = (1 << 2)
                        
		MODES_ARENAS = (1 << 3)
       
	MODES_ANY = (1 << 4)

	                     
	PLAYSTYLE_COMPETITIVE = (1 << 5)
	PLAYSTYLE_CASUAL = (1 << 6)
	PLAYSTYLE_ALLSTYLES = (1 << 7)
	PLAYSTYLE_LONEWOLVES  = (1 << 8)
	PLAYSTYLE_TEAMPLAYERS = (1 << 9)

	                            
	EXP_BEGINNERS = (1 << 10)
	EXP_WILLHELPBEGINNERS = (1 << 11)
	EXP_EXPERIENCED = (1 << 12)
	EXP_ALLSKILLS = (1 << 13)

	                         
	COMMS_MIC_ONLY = (1 << 14)
	COMMS_MIC_OPTIONAL = (1 << 15)
	COMMS_MIC_NO = (1 << 16)

	                  
	SOC_FAMILY_FRIENDLY = (1 << 17)
	SOC_MATURE = (1 << 18)
	SOC_YOUNG = (1 << 19)                                   
	SOC_LGBT = (1 << 20)
	SOC_DISABLED_GAMERS = (1 << 21)
	SOC_SWEARING_OK = (1 << 22)
	SOC_SWEARING_NO = (1 << 23)
	SOC_TRASHTALK_OK = (1 << 24)
	SOC_TRASHTALK_NO = (1 << 25)
}

global enum eClubSearchTagType
{
	CLUBTAGTYPE_GAMEMODE,
	CLUBTAGTYPE_PLAYSTYLE,
	CLUBTAGTYPE_EXPERIENCE,
	CLUBTAGTYPE_COMMUNICATION,
	CLUBTAGTYPE_SOCIAL,
	CLUBTAGTYPE_PLATFORM,

	_count
}

                                                    
global enum eClubInternalReportReason
{
	REASON_CHAT_OFFENSIVE,
	REASON_CHAT_SPAM,
	REASON_CHAT_HARASSMENT,
	REASON_CHAT_HATESPEECH,
	REASON_CHAT_SUICIDETHREAT,
	_chat_count,

	REASON_GAME_OFFENSIVE,
	REASON_GAME_RUDETOCLUBMATES,
	REASON_GAME_RUDETORANDOMS,
	REASON_GAME_CHEATS,
	_count,
}

global enum eClubQueryState
{
	INACTIVE,
	PROCESSING,
	FAILED,
	SUCCESSFUL,
	_count,
}

global const string CLUBCMD_REPORT_PLACEMENT_ADDPLAYER = "ServerToUI_AddPlayerDataForPlacementReport"
global const string CLUBCMD_UPDATE_LAST_MATCH_TIME = "ServerToUI_Clubs_UpdateLastMatchTimes"

global struct ClubSquadSummaryPlayerData
{
	string nucleusID
	int kills
	int damageDealt
}

struct ClubSquadSummaryData
{
	array<ClubSquadSummaryPlayerData> playerData
	int                               squadplacement = -1
}

struct
{
	table< int, array<vector> > logoColorPalette

	int clubQueryRetryCount = 0

	#if CLIENT
		string myClubName
	#endif

	#if CLIENT || UI
		bool crossplayEnabled
		bool kickedForCrossplay
	#endif

	#if UI
		table<int, int> queryProcessingStateMap
		table< int, array<void functionref()> > clubQuerySuccessCallbacks
		table< int, string > errorCodeMap

		array<void functionref()> myClubUpdatedCallbacks
		array<void functionref()> newClubEventCallbacks

		ClubHeader& newClubSettings
		array<ItemFlavor> selectedSearchTags

		ClubHeader ornull reportClubHeader

		ClubHeader& selectedClubInvite
		ClubHeader& selectedOutOfRegionClub

		ClubHeader& clubToSwitchTo
		bool isSwitchingClubs = false
	#endif
} file

void function Clubs_Init()
{
	printf( "ClubsDebug: Init Clubs" )

	AddCallback_RegisterRootItemFlavors( void function() {
		foreach ( asset logoElementAsset in GetBaseItemFlavorsFromArray( "clubLogoElements" ) )
			RegisterItemFlavorFromSettingsAsset( logoElementAsset )
	} )

	AddCallback_RegisterRootItemFlavors( void function() {
		foreach ( asset searchTag in GetBaseItemFlavorsFromArray( "clubSearchTags" ) )
			RegisterItemFlavorFromSettingsAsset( searchTag )
	} )

	file.logoColorPalette = BuildColorSwatchTable()

	                      
	  	                                                 
	        

	#if CLIENT
		AddCallback_OnSettingsUpdated( OnSettingsUpdated )
	#endif

	#if CLIENT || UI
		file.crossplayEnabled = GetConVarBool( "CrossPlay_user_optin" )
	#endif         

	#if UI
		RegisterSignal( CLUB_REQUERY_SIGNAL )
		RegisterSignal( CLUB_UPDATE_TAB_SIGNAL )

		                                                                        
		                                                                                  
		                                                                          
		                                                                               
		                                                                                        
		                                                                           
		                                                                                      
		                                                                                        
		                                                                        
		                                                                                  
		                                                                          
		                                                                         
		                                                                                   
		                                                                                    
		                                                                                 
		                                                                                 
		                                                                          
		                                                                                         
		                                                                                  
		                                                                                       
		                                                                                  
		                                                                               


		file.errorCodeMap[CLUB_ERROR_CODE_CROSSPLAY_INCOMPAT] <- "#CLUB_OP_FAIL_CROSSPLAY_INCOMPAT"
		file.errorCodeMap[CLUB_ERROR_CODE_INSUFFICENT_PERMISSIONS] <- "#CLUB_OP_FAIL_INSUFFICIENT_PERMISSIONS"
		file.errorCodeMap[CLUB_ERROR_CODE_VALIDATION] <- "#CLUB_OP_FAIL_VALIDATION"
		file.errorCodeMap[CLUB_ERROR_CODE_NO_SUCH_GROUP] <- "#CLUB_OP_FAIL_NO_SUCH_CLUB"
		file.errorCodeMap[CLUB_ERROR_CODE_INAPPROPRIATE] <- "#CLUB_OP_FAIL_CREATE_INAPPROPRIATE"
		file.errorCodeMap[CLUB_ERROR_CODE_MEMBERSHIP_LIMIT] <- "#CLUB_OP_FAIL_MEMBERSHIP_LIMIT"
		file.errorCodeMap[CLUB_ERROR_CODE_FULL] <- "#CLUB_OP_FAIL_JOIN_FULL"
		file.errorCodeMap[CLUB_ERROR_CODE_KICK_COOL_OFF] <- "#CLUB_OP_FAIL_JOIN_KICK_COOL_OFF"
		file.errorCodeMap[CLUB_ERROR_CODE_JOIN_COOL_OFF] <- "#CLUB_OP_FAIL_JOIN_COOL_OFF"
		file.errorCodeMap[CLUB_ERROR_CODE_HOP_COOL_OFF] <- "#CLUB_OP_FAIL_JOIN_HOP_COOL_OFF"
		file.errorCodeMap[CLUB_ERROR_CODE_DUPLICATE_NAME] <- "#CLUB_OP_FAIL_CREATE_NAME_EXISTS"
		file.errorCodeMap[CLUB_ERROR_CODE_AUTH] <- "#CLUB_OP_FAIL_AUTHENTICATION"

		thread Clubs_CheckClubPersistenceThread()
	#endif     
}

                                                                                       
  
                                                                                                                                                                                             
                                                                                                                                                                                                             
                                                                                                                                                                                          
                                                                                                                                                                                     
                                                                                                                                                                                                                          
                                                                                                                                                                                                          
  
                                                                                       


#if UI
string function Club_GetErrorStringForCode( int errorCode )
{
	if ( errorCode in file.errorCodeMap )
	{
		return file.errorCodeMap[ errorCode ]
	}

	return "#CLUB_OP_FAIL_UNDEFINED"
}

void function Club_SetKickedForCrossplayIncompat()
{
	file.kickedForCrossplay = true
}

void function Clubs_CreateNewClub( ClubHeader clubHeader )
{
	if ( ClubIsValid() )
		return

	Clubs_SetClubQueryState( CLUB_OP_CREATE, eClubQueryState.PROCESSING )

	file.newClubSettings = clubHeader
	ClubCreate( clubHeader.name, clubHeader.tag, clubHeader.privacySetting )
}

                                                                              
void function Clubs_FinalizeNewClub()
{
	if ( file.newClubSettings.privacySetting == CLUB_PRIVACY_OPEN_WITH_REQ )
	{
		if ( file.newClubSettings.minLevel == 0 && file.newClubSettings.minRating == 0 )
			file.newClubSettings.privacySetting = CLUB_PRIVACY_OPEN
		ClubSetJoinRequirements( file.newClubSettings.minLevel, file.newClubSettings.minRating )
	}
	else
	{
		ClubSetJoinRequirements( 0, 0 )
		file.newClubSettings.minLevel = 0
		file.newClubSettings.minRating = 0
	}
	ClubSetPrivacySetting( file.newClubSettings.privacySetting )

	ClubSetSearchTags( file.newClubSettings.searchTags )
	ClubSetLogoString( file.newClubSettings.logoString )

	PIN_Club_Create( file.newClubSettings )
	Clubs_UpdateMyData()
	thread CloseClubCreationMenu()
	thread Clubs_MonitorCrossplayChangeThread()
}

void function Clubs_EditClubSettings( ClubHeader clubHeader )
{
	if ( !ClubIsValid() )
		return

	             
	Clubs_SetClubQueryState( CLUB_OP_SET_JOIN_REQUIREMENTS, eClubQueryState.PROCESSING )
	Clubs_SetClubQueryState( CLUB_OP_SET_PRIVACY_SETTING, eClubQueryState.PROCESSING )
	Clubs_SetClubQueryState( CLUB_OP_SET_SEARCHTAGS, eClubQueryState.PROCESSING )
	Clubs_SetClubQueryState( CLUB_OP_SET_LOGO, eClubQueryState.PROCESSING )
	
	
	ClubSetPrivacySetting( clubHeader.privacySetting )
	if ( clubHeader.privacySetting == CLUB_PRIVACY_OPEN_WITH_REQ )
		ClubSetJoinRequirements( clubHeader.minLevel, clubHeader.minRating )
	else
		ClubSetJoinRequirements( 0, 0 )

	ClubSetSearchTags( clubHeader.searchTags )
	ClubSetLogoString( clubHeader.logoString )

	                                                                                                                                                                        
	                                                  
	                                                                             
	                                                                                        
	                                       
	                                                                           
	                                     

	                      
	                                            

	PIN_Club_Setting( clubHeader )
	thread ClubDataUpdateThread()
	thread CloseClubCreationMenu()
}

bool function Clubs_CanLeaveClub()
{
	if ( !IsClubLandingPanelCurrentlyTopLevel() )
		return false

	if ( !ClubIsValid() )
		return false

	return true
}

void function Clubs_LeaveClub()
{
	if ( !ClubIsValid() )
		return

	PIN_Club_Leave( ClubGetHeader() )                                                                       
	ClubLeave()

	var clubPanel = GetPanel( "ClubLandingPanel" )
	SetPanelTabNew( clubPanel, false )
}

void function Clubs_FinalizeLeaveClub( bool wasKicked = false )
{
	if ( !IsConnected() )
		WaitFrame()

	int lastQueryError = ClubGetLastQueryError()
	if ( lastQueryError > 0 )
	{
		ClubLeave()
		return
	}

	var clubPanel = GetPanel( "ClubLandingPanel" )
	SetPanelTabNew( clubPanel, false )
	Clubs_TryCloseAllClubMenus()
	Remote_ServerCallFunction( "ClientCallback_SetClubID", INVALID_CLUB_ID )
	Remote_ServerCallFunction( "ClientCallback_SetClubChatViewedTime", -1 )
	Remote_ServerCallFunction( "ClientCallback_SetClubTimelineViewedTime", -1 )
	SetLastViewedAnnouncementTimeToNever()
	ClubSearchTag_ClearSelectedSearchTags()
	Clubs_UpdateMyData()
	ClubLanding_ClearMemberLists()
	ClubLanding_UpdateUIPresentation()

	if ( wasKicked )
		Clubs_OpenClubKickedDialog()

	if ( Clubs_IsSwitchingClubs() )
		thread Clubs_FinalizeClubSwitchThread()
}

string function Clubs_GetDescStringForPrivacyLevel( int privacyLevel )
{
	                                                                                
	switch ( privacyLevel )
	{
		case CLUB_PRIVACY_OPEN:
			return "#CLUB_CREATION_PRIVACY_OPEN"
		case CLUB_PRIVACY_OPEN_WITH_REQ:
			return "#CLUB_CREATION_PRIVACY_OPEN_RESTRICTIONS"
		case CLUB_PRIVACY_BY_REQUEST:
			return "#CLUB_CREATION_PRIVACY_BYREQUEST"
		case CLUB_PRIVACY_INVITE_ONLY:
			return "#CLUB_CREATION_PRIVACY_INVITEONLY"
		case null:
			return "null"
		default:
			return ""
	}

	unreachable
}

string function Clubs_GetDescStringForMinAccountLevel( int accountLevel )
{
	                                                                                
	switch ( accountLevel )
	{
		case eClubMinAccountLevel.MINLVL_10:
			return "#CLUB_CREATION_LVLREQ_10"
		case eClubMinAccountLevel.MINLVL_50:
			return "#CLUB_CREATION_LVLREQ_50"
		case eClubMinAccountLevel.MINLVL_100:
			return "#CLUB_CREATION_LVLREQ_100"
		case eClubMinAccountLevel.MINLVL_200:
			return "#CLUB_CREATION_LVLREQ_200"
		case eClubMinAccountLevel.MINLVL_300:
			return "#CLUB_CREATION_LVLREQ_300"
		case eClubMinAccountLevel.MINLVL_400:
			return "#CLUB_CREATION_LVLREQ_400"
		case eClubMinAccountLevel.MINLVL_500:
			return "#CLUB_CREATION_LVLREQ_500"
		case null:
			return "null"
		default:
			return ""
	}

	unreachable
}

string function Clubs_GetDescStringForMinRank( int minRank )
{
	                                                                      
	switch ( minRank )
	{
		case eClubMinRank.MINRANK_BRONZE:
			return "#CLUB_CREATION_RANKREQ_BRONZE"
		case eClubMinRank.MINRANK_SILVER:
			return "#CLUB_CREATION_RANKREQ_SILVER"
		case eClubMinRank.MINRANK_GOLD:
			return "#CLUB_CREATION_RANKREQ_GOLD"
		case eClubMinRank.MINRANK_PLATINUM:
			return "#CLUB_CREATION_RANKREQ_PLATINUM"
		case eClubMinRank.MINRANK_DIAMOND:
			return "#CLUB_CREATION_RANKREQ_DIAMOND"
		case eClubMinRank.MINRANK_MASTER:
			return "#CLUB_CREATION_RANKREQ_MASTER"
		case eClubMinRank.MINRANK_APEXPREDATOR:
			return "#CLUB_CREATION_RANKREQ_APEXPRED"
		case null:
			return "null"
		default:
			return ""
	}

	unreachable
}

int function Clubs_GetMinLevelFromSetting( int accountLevel )
{
	switch ( accountLevel )
	{
		case eClubMinAccountLevel.MINLVL_10:
			return 9
		case eClubMinAccountLevel.MINLVL_50:
			return 49
		case eClubMinAccountLevel.MINLVL_100:
			return 99
		case eClubMinAccountLevel.MINLVL_200:
			return 199
		case eClubMinAccountLevel.MINLVL_300:
			return 299
		case eClubMinAccountLevel.MINLVL_400:
			return 399
		case eClubMinAccountLevel.MINLVL_500:
			return 499
		default:
			return CLUB_JOIN_MIN_ACCOUNT_LEVEL
	}

	unreachable
}

int function Clubs_GetMinHighestRankScoreFromSetting( int minRank )
{
	switch ( minRank )
	{
		case eClubMinRank.MINRANK_BRONZE:
			return 0
		case eClubMinRank.MINRANK_SILVER:
			return 2
		case eClubMinRank.MINRANK_GOLD:
			return 3
		case eClubMinRank.MINRANK_PLATINUM:
			return 4
		case eClubMinRank.MINRANK_DIAMOND:
			return 5
		case eClubMinRank.MINRANK_MASTER:
		case eClubMinRank.MINRANK_APEXPREDATOR:
			return 6
		default:
			return 0
	}

	unreachable
}

void function Clubs_SetClubMemberRank( ClubMember clubMember, int rank )
{
	ClubSetMemberRank( clubMember.memberID, rank )
}

bool function Clubs_CanKickUsers()
{
	if ( !ClubIsValid() )
		return false

	return ClubGetMyMemberRank() >= CLUB_RANK_ADMIN
}

bool function Clubs_CanKickClubMember( ClubMember clubMember )
{
	if ( !Clubs_CanKickUsers() )
		return false

	int myRank = ClubGetMyMemberRank()
	return myRank > clubMember.rank
}

void function Clubs_KickMember( ClubMember clubMember )
{
	int myRank = ClubGetMyMemberRank()
	if ( myRank < CLUB_RANK_ADMIN )
		return

	if ( myRank <= clubMember.rank )
		return

	PIN_Club_Remove( ClubGetHeader(), clubMember.memberID )
	ClubKick( clubMember.memberID )
}
#endif     

                                                                                       
  
                                                                          
                                                                                
                                                                            
                                                                                  
                                                                                            
                                                                                  
  
                                                                                       

#if UI
void function Clubs_JoinClub( string clubID )
{
	if ( clubID == "" )
		return

	Clubs_SetClubQueryState( CLUB_OP_JOIN, eClubQueryState.PROCESSING )
	ClubJoin( clubID )
}


void function Clubs_FinalizeJoinClub()
{
	if ( !ClubIsValid() )
		return

	SetDialogFlowPersistenceTables( "clubIsPendingApproval", false  )                                                                                     
	Remote_ServerCallFunction( "ClientCallback_SetClubIsPendingApproval", false )

	ClubHeader clubHeader = ClubGetHeader()
	ClubInvite_ProcessAcceptedClubInvite( clubHeader )
	Clubs_SetIsSwitchingClubs( false )
	Clubs_UpdateMyData()
	ClubLanding_InitializeClubTabs()
	Clubs_OpenClubJoinedDialog( clubHeader.name )
	thread Clubs_MonitorCrossplayChangeThread()
}


void function Clubs_SwitchClubsThread( ClubHeader clubHeader )
{
	printf( "ClubSwitchDebug: %s()", FUNC_NAME() )

	if ( clubHeader.clubID == "" )
		return

	printf( "ClubSwitchDebug: %s(): Leaving current club.", FUNC_NAME() )
	file.clubToSwitchTo = clubHeader
	Clubs_SetIsSwitchingClubs( true )
	ClubLeave()
}


void function Clubs_FinalizeClubSwitchThread()
{
	if ( !Clubs_IsSwitchingClubs() )
		return

	if ( file.clubToSwitchTo.clubID == "" )
		return

	printf( "ClubSwitchDebug: %s(): Waiting one second before joining %s", FUNC_NAME(), file.clubToSwitchTo.name )
	Wait( 1.0 )

	Clubs_JoinClub( file.clubToSwitchTo.clubID )
}


void function Clubs_SetIsSwitchingClubs( bool isSwitching )
{
	file.isSwitchingClubs = isSwitching
}


bool function Clubs_IsSwitchingClubs()
{
	return file.isSwitchingClubs
}


string function Clubs_GetJoinRequestsString()
{
	int pendingRequests = ClubJoinRequestsCount()
	if ( pendingRequests == 0 )
		return ""

	if ( ClubGetMyMemberRank() < CLUB_RANK_CAPTAIN )
		return ""

	switch ( pendingRequests )
	{
		case 1:
			return Localize( "#CLUB_JOIN_REQUEST_VIEW_DESC_SOLO" )
		default:
			return Localize( "#CLUB_JOIN_REQUEST_VIEW_DESC", pendingRequests )
	}

	unreachable
}


bool function Clubs_DoesMeetJoinRequirements( ClubHeader clubHeader )
{
	entity player = GetLocalClientPlayer()
	int currentXP    = GetPlayerAccountXPProgress( ToEHI( player ) )
	int currentLevel = GetAccountLevelForXP( currentXP )

	if ( currentLevel < CLUB_JOIN_MIN_ACCOUNT_LEVEL )
		return false

	int levelReq = Clubs_GetMinLevelFromSetting( clubHeader.minLevel )
	if ( currentLevel < levelReq )
	{
		                                                                                                                                           
		return false
	}
	
	int rankReq                            = Clubs_GetMinHighestRankScoreFromSetting( clubHeader.minRating )

	                                                                     

	              
	                                          		                                                
	                                         		                                                        
	                                       			                                                      
	                                           		                                                          
	                                          		                                                         
	                                         		                                              
	                                               	                                                     

	SharedRankedTierData highestRankedTier = Ranked_GetHighestHistoricalRankedTierData( GetLocalClientPlayer() )

	if ( highestRankedTier.index < rankReq )
	{		
	                                                                                                                                                              
		return false
	}

	                                                                                                                                                                                             
	return true
}

#endif

                                                                                       
  
                                                                                                                                        
                                                                                                                                                
                                                                                                                                      
                                                                                                                                      
                                                                                                                                        
                                                                                                                                      
  
                                                                                       

#if UI
void function Clubs_Search( string clubName, string clubTag, int privacySetting, int minAccountLevel, int minRank, array<ItemFlavor> searchTags, int maxResults, bool anyDataCenter )
{
	                                            
	if ( !Clubs_IsEnabled() )
		return

	if ( Clubs_IsClubQueryProcessing( CLUB_OP_SEARCH ) )
		return

	Clubs_SetClubQueryState( CLUB_OP_SEARCH, eClubQueryState.PROCESSING )

	int searchTagBitmask = ClubSearchTag_CreateSearchTagBitMask( searchTags )

	                                                                                                                                                                                       
	ClubSearch( clubName, clubTag, 0, maxResults, true, anyDataCenter, searchTagBitmask, privacySetting, minAccountLevel, minRank )
}

void function Clubs_CompletedSearch()
{
	                                        
	ClubDiscovery_ProcessSearchResults()
	ClubSearch_ProcessSearchResults()
}

void function Clubs_InitSearchResultButton( var button, ClubHeader clubHeader, bool isInvite = false )
{
	bool isLocked = !Clubs_DoIMeetMinimumLevelRequirement()
	bool isEnabled = !isLocked
	Hud_SetLocked( button, isLocked )
	Hud_SetEnabled( button, isEnabled )

	var buttonRui = Hud_GetRui( button )

	ClubLogo clubLogo
	if ( clubHeader.logoString.len() == 0 )
		clubLogo = GenerateRandomClubLogo( clubHeader.clubID )
	else
		clubLogo = ClubLogo_ConvertLogoStringToLogo( clubHeader.logoString )

	clubLogo.isInvite = isInvite
	var logo = ClubLogoUI_CreateNestedClubLogo( buttonRui, "clubLogo", clubLogo )
	RuiSetBool( buttonRui, "isInvite", isInvite )
	RuiSetString( buttonRui, "clubName", clubHeader.name )
	RuiSetInt( buttonRui, "memberCount", clubHeader.memberCount )

	array<string> searchTagStrings = ClubSearchTag_GetSearchTagNamesFromBitmask( clubHeader.searchTags )
	string searchTags
	foreach( string tagString in searchTagStrings )
	{
		string seperator = searchTags.len() == 0 ? "" : ", "
		searchTags = searchTags + seperator + Localize( tagString )
	}
	RuiSetString( buttonRui, "searchTags", searchTags )
	Hud_Show( button )

	if ( !isLocked )
	{
		CreateSearchResultButtonToolTip( button, clubHeader, isInvite )
	}

	                                                                                                                                        
}

void function CreateSearchResultButtonToolTip( var button, ClubHeader clubHeader, bool isInvite = false )
{
	ToolTipData toolTipData

	string privacyLevel = Localize( Clubs_GetDescStringForPrivacyLevel( clubHeader.privacySetting ) )
	string minLevel = Localize( Clubs_GetDescStringForMinAccountLevel( clubHeader.minLevel ) )
	string minRank = Localize( Clubs_GetDescStringForMinRank( clubHeader.minRating ) )
	string memberCount = clubHeader.memberCount > 1 ? Localize( "#CLUB_JOIN_TOOLTIP_USERCOUNT", clubHeader.memberCount ) : Localize( "#CLUB_JOIN_TOOLTIP_USERCOUNT_SINGLE" )
	string summary = Localize( "#CLUB_JOIN_TOOLTIP_SUMMARY", privacyLevel, minLevel, minRank, memberCount )

	                                                   
	if ( isInvite )
		toolTipData.descText = clubHeader.name.toupper()
	else
		toolTipData.descText = summary

	string joinHint = "#CLUB_JOIN_TOOLTIP_CLICK_JOIN"
	if ( isInvite )
		joinHint = "#CLUB_JOIN_TOOLTIP_CLICK_ACCEPT"
	else if ( clubHeader.privacySetting == CLUB_PRIVACY_BY_REQUEST )
		joinHint = "#CLUB_JOIN_TOOLTIP_CLICK_REQUEST"
	toolTipData.actionHint2 = joinHint

	toolTipData.actionHint1 = isInvite ? "#CLUB_JOIN_TOOLTIP_CLICKRIGHT_INVITE" : "#CLUB_JOIN_TOOLTIP_CLICKRIGHT"

	Hud_SetToolTipData( button, toolTipData )
}
#endif

                                                                                       
  
                                                                                                                                                                                                
                                                                                                                                                                                                      
                                                                                                                                                                            
                                                                                                                                                                                
                                                                                                                                                                                            
                                                                                                                                                                                    

                                                                                       

#if UI
void function ClubRequest_AcceptJoinRequest( ClubJoinRequest joinRequest, bool isAccepted )
{
	printf( "ClubRequestDebug: %s(): Attempting to accept or deny %s (%s)", FUNC_NAME(), joinRequest.userName, joinRequest.userID )
	ClubJoinRequests_RefreshJoinRequests()

	array<ClubJoinRequest> joinRequests = ClubGetJoinRequests()
	bool validRequest
	for ( int i = 0; i < joinRequests.len(); i++ )
	{
		printf( "ClubRequestDebug: %s(): Request %i: %s (%s)", FUNC_NAME(), i, joinRequests[i].userName, joinRequests[i].userID )
		if ( joinRequests[i].userID == joinRequest.userID )
		{
			printf( "ClubRequestDebug: %s(): Request found!", FUNC_NAME() )
			validRequest = true
			break
		}
	}

	if ( !validRequest )
	{
		printf( "ClubRequestDebug: %s(): User Join Request no longer valid (ID = %s)", FUNC_NAME(), joinRequest.userID )
		Clubs_OpenUserAlreadyDeniedDialog( joinRequest )
		return
	}

	if( Clubs_IsUserAClubmate( joinRequest.userID ) )
	{
		printf( "ClubRequestDebug: %s(): User is already a club member (ID = %s)", FUNC_NAME(), joinRequest.userID )
		Clubs_OpenUserAlreadyAcceptedDialog( joinRequest )
		return
	}

	if ( isAccepted )
	{
		printf( "ClubRequestDebug: %s(): Accepting User Request to Join", FUNC_NAME() )
		ClubPetitionApprove( joinRequest.userID )
	}
	else
	{
		printf( "ClubRequestDebug: %s(): Rejecting User Request to Join", FUNC_NAME() )
		ClubPetitionDeny( joinRequest.userID )
	}
}
#endif

                                                                                       
  
                                                                                                                                              
                                                                                                                                                
                                                                                                                                  
                                                                                                                                        
                                                                                                                                        
                                                                                                                                  
  
                                                                                       

#if UI
void function Clubs_CompletedClubInviteQuery()
{
	thread ClubDiscovery_ProcessInvitesAndRefreshDisplay()
}

void function ClubInvite_ProcessAcceptedClubInvite( ClubHeader clubHeader )
{
	PIN_Club_AcceptInvite( clubHeader )
}
#endif

                                                                                       
  
  	                                                                                                                                                                     
  	                                                                                                                                                                                    
  	                                                                                                                                                            
  	                                                                                                                                                          
  	                                                                                                                                                                                                                
  	                                                                                                                                                                                           
  
                                                                                       

array<ItemFlavor> function GetAllClubLogoElementFlavors()
{
	return  GetAllItemFlavorsOfType( eItemType.club_logo_element )
}

array<ItemFlavor> function GetAllClubLogoElementFlavorsOfType( int elementType )
{
	array<ItemFlavor> logoElements = GetAllClubLogoElementFlavors()
	array<ItemFlavor> logoElementsOfType

	foreach ( ItemFlavor logoElement in logoElements )
	{
		if ( ClubLogo_GetLogoElementType( logoElement ) == elementType && IsClubLogoElementEnabled( logoElement ) )
			logoElementsOfType.append( logoElement )
	}

	return logoElementsOfType
}

ItemFlavor function GetRandomClubLogoElementFlavor()
{
	array<ItemFlavor> elementFlavors = GetAllClubLogoElementFlavors()
	return elementFlavors[ RandomIntRange( 0, (elementFlavors.len() - 1) ) ]
}

ItemFlavor function GetRandomClubLogoElementFlavorByType( int elementType, var seed = null )
{
	array<ItemFlavor> elementFlavors = GetAllClubLogoElementFlavorsOfType( elementType )
	printf( "GetRandomClubLogoElementFlavorByType: type: %i, elementFlavors.len() = %i", elementType, elementFlavors.len() )
	if ( seed )
		return elementFlavors.getrandomseeded( seed )
	return elementFlavors.getrandom()
}

bool function IsClubLogoElementEnabled( ItemFlavor element )
{
	Assert( ItemFlavor_GetType( element ) == eItemType.club_logo_element )
	return GetGlobalSettingsBool( ItemFlavor_GetAsset( element ), "clubLogoElementEnabled" )
}

asset function ClubLogo_GetLogoElementImage( ItemFlavor element )
{
	Assert( ItemFlavor_GetType( element ) == eItemType.club_logo_element )
	return GetGlobalSettingsAsset( ItemFlavor_GetAsset( element ), "clubLogoElementImage" )
}

asset ornull function ClubLogo_GetLogoSecondaryColorMask( ItemFlavor element )
{
	Assert( ItemFlavor_GetType( element ) == eItemType.club_logo_element )
	return GetGlobalSettingsAsset( ItemFlavor_GetAsset( element ), "clubLogoElementSecondaryColorMask" )
}

asset ornull function ClubLogo_GetLogoFrameMask( ItemFlavor element )
{
	Assert( ItemFlavor_GetType( element ) == eItemType.club_logo_element )
	return GetGlobalSettingsAsset( ItemFlavor_GetAsset( element ), "clubLogoElementFrameMask" )
}

float function ClubLogo_GetLogoVerticalOffset( ItemFlavor element )
{
	Assert( ItemFlavor_GetType( element ) == eItemType.club_logo_element )
	return GetGlobalSettingsFloat( ItemFlavor_GetAsset( element ), "elementCenterPointAdjustment" )
}

string function ClubLogo_GetLogoElementName( ItemFlavor element )
{
	Assert( ItemFlavor_GetType( element ) == eItemType.club_logo_element )
	return GetGlobalSettingsString( ItemFlavor_GetAsset( element ), "localizationKey_NAME_SHORT" )
}

int function ClubLogo_GetLogoElementType( ItemFlavor element )
{
	Assert( ItemFlavor_GetType( element ) == eItemType.club_logo_element )
	return eClubLogoElementType[ GetGlobalSettingsString( ItemFlavor_GetAsset( element ), "elementCategory" ) ]
}

ClubLogo function GenerateRandomClubLogo( string clubID = "" )
{
	ClubLogo newLogo

	var seed = null
	if ( clubID != "" )
		seed = CreateRandomSeed( clubID.tointeger() )

	array<vector> colorSet = ClubLogo_GetRandomDoubleSplitComplementaryColorSet( seed )

	Assert( colorSet.len() == 5, "ClubLogo_GetRandomDoubleSplitComplementaryColorSet() acquired incorect number of colors" )

	for ( int i = 0; i < CLUB_LOGO_LAYER_MAX; i++ )
	{
		ClubLogoLayer newLayer

		newLayer.elementFlav = GetRandomClubLogoElementFlavorByType( i, seed )

		                                                               
		                                                                                          

		switch( i )
		{
			case eClubLogoElementType.CLUBLOGOTYPE_FRAME:
				newLayer.primaryColorOverride = colorSet[0]
				break
			case eClubLogoElementType.CLUBLOGOTYPE_EMBLEM:
				newLayer.primaryColorOverride = colorSet[1]
				newLayer.secondaryColorOverride = colorSet[2]
				break
			case eClubLogoElementType.CLUBLOGOTYPE_BACKGROUNDS:
				newLayer.primaryColorOverride = colorSet[3]
				newLayer.secondaryColorOverride = colorSet[4]
		}

		newLayer.verticalOffset = ClubLogo_GetLogoVerticalOffset( newLayer.elementFlav )

		newLogo.logoLayers.append( newLayer )
	}

	asset frameMask
	float verticalOffset
	array<ClubLogoLayer> nonFrameLayers
	foreach ( ClubLogoLayer layer in newLogo.logoLayers )
	{
		if ( ClubLogo_GetLogoElementType( layer.elementFlav ) == eClubLogoElementType.CLUBLOGOTYPE_FRAME )
		{
			frameMask = expect asset( ClubLogo_GetLogoFrameMask( layer.elementFlav ) )
			verticalOffset = ClubLogo_GetLogoVerticalOffset( layer.elementFlav )
		}
		else
		{
			nonFrameLayers.append( layer )
		}
	}

	foreach ( ClubLogoLayer layer in newLogo.logoLayers )
	{
		if ( nonFrameLayers.contains( layer ) )
			layer.frameMask = frameMask

		int layerType = ClubLogo_GetLogoElementType( layer.elementFlav )

		if ( layerType == eClubLogoElementType.CLUBLOGOTYPE_EMBLEM )
			layer.verticalOffset = verticalOffset
	}

	return newLogo
}

table< int, array<vector> > function BuildColorSwatchTable()
{
	table< int, array<vector> > swatchTable

	var dt       = GetDataTable( $"datatable/color_swatch_table.rpak" )
	int rowCount = GetDataTableRowCount( dt )

	array<vector> whiteToBlack
	int whiteCol = GetDataTableColumnByName( dt, "whiteToBlack" )
	for ( int i = 0; i < rowCount; i++ )
	{
		whiteToBlack.append( GetDataTableVector( dt, i, whiteCol ) )
	}

	array< array<vector> > allColors
	allColors.append( whiteToBlack )

	for ( int valueIdx = 0; valueIdx < rowCount; valueIdx++ )
	{
		array<vector> colorRow
		for( int hueIdx = 0; hueIdx < rowCount; hueIdx++ )
		{
			int hueRow = GetDataTableColumnByName( dt, format( "color%02d", hueIdx ) )
			vector newColor = GetDataTableVector( dt, valueIdx, hueRow )

			if ( newColor == <999,999,999> )
				continue
			else
				colorRow.append( newColor )
		}
		allColors.append( colorRow )
	}

	for ( int i = 0; i < allColors.len(); i++ )
	{
		swatchTable[ i ] <- allColors[i]
	}

	printf( "ClubsDebug: BuildColorSwatchTable: Built table of %i colors", ClubLogo_GetColorSwatchCount( swatchTable ) )
	return swatchTable
}

int function ClubLogo_GetColorSwatchCount( table< int, array<vector> > swatchTable )
{
	int colorCount
	foreach ( int colorIndex, array<vector> colorShades in swatchTable )
	{
		array<vector> shades = swatchTable[ colorIndex ]
		for ( int i = 0; i < shades.len(); i++ )
			colorCount++
	}

	return colorCount
}

table< int, array<vector> > function ClubLogo_GetLogoColorTable()
{
	return file.logoColorPalette
}

vector function ClubLogo_GetRandomLogoColor( var seed = null )
{
	vector color = <255.0,255.0,255.0>

	printf( "RandomLogoDebug: Picking a random color from %i options", ClubLogo_GetColorSwatchCount( file.logoColorPalette ) )

	int rowCount

	foreach( int colorRow, array<vector> colorArray in file.logoColorPalette )
	{
		if ( colorRow > rowCount )
			rowCount = colorRow
	}

	int randomRow
	if ( seed )
		randomRow = RandomIntRangeSeeded( seed, 0, rowCount )
	else
		randomRow = RandomIntRange( 0, rowCount )

	if ( file.logoColorPalette[ randomRow ].len() > 0 )
	{
		if ( seed )
			color = file.logoColorPalette[ randomRow ].getrandomseeded( seed )
		else
			color = file.logoColorPalette[ randomRow ].getrandom()
	}
	else
	{
		printf( "RandomLogoDebug: Returning white because row %i is empty", randomRow )
	}

	printf( "RandomLogoDebug: Returning <%f, %f, %f>", color.x, color.y, color.z )
	return color
}

const float RANDOMLOGO_HUE_SHIFT_DEGREES = 30.0
const float RANDOMLOGO_VALUE_SHIFT_PERCENT = 0.25
array<vector> function ClubLogo_GetRandomDoubleSplitComplementaryColorSet( var seed = null )
{
	vector startingColor = ClubLogo_GetRandomLogoColor( seed )
	bool isShadeOfGray = ( startingColor.x == startingColor.y && startingColor.x == startingColor.z )

	ClubHSV startingHSV       = RGBToHSV( startingColor )

	ClubHSV splitComplement01 = clone( startingHSV )
	splitComplement01.hue = HSVHueShift( splitComplement01.hue, 180.0 - RANDOMLOGO_HUE_SHIFT_DEGREES )
	splitComplement01.value = isShadeOfGray ? HSVSaturationOrValueShift( 1-splitComplement01.value, RANDOMLOGO_VALUE_SHIFT_PERCENT ) : splitComplement01.value

	ClubHSV splitComplement02 = clone( startingHSV )
	splitComplement02.hue = HSVHueShift( splitComplement02.hue, 180.0 + RANDOMLOGO_HUE_SHIFT_DEGREES )
	splitComplement02.value = isShadeOfGray ? HSVSaturationOrValueShift( 1-splitComplement02.value, -RANDOMLOGO_VALUE_SHIFT_PERCENT ) : splitComplement02.value

	ClubHSV dblComplement01 = clone( splitComplement01 )
	dblComplement01.hue = HSVHueShift( dblComplement01.hue, 180.0 )
	dblComplement01.value = isShadeOfGray ? HSVSaturationOrValueShift( dblComplement01.value, RANDOMLOGO_VALUE_SHIFT_PERCENT/2 ) : dblComplement01.value
	ClubHSV dblComplement02 = clone( splitComplement02 )
	dblComplement02.hue = HSVHueShift( dblComplement02.hue, 180.0 )
	dblComplement02.value = isShadeOfGray ? HSVSaturationOrValueShift( dblComplement02.value, -RANDOMLOGO_VALUE_SHIFT_PERCENT/2 ) : dblComplement02.value

	array<vector> colorSet = [
		startingColor,
		FindNearestColorOnColorTable( HSVToRGB( splitComplement01 ) ),
		FindNearestColorOnColorTable( HSVToRGB( splitComplement02 ) ),
		FindNearestColorOnColorTable( HSVToRGB( dblComplement01 ) ),
		FindNearestColorOnColorTable( HSVToRGB( dblComplement02 ) ),
	]

	return colorSet
}

vector function FindNearestColorOnColorTable( vector color )
{
	vector closestColor
	float closestDistToColor = -1

	foreach ( int rowIdx, array<vector> colorEntries in file.logoColorPalette )
	{
		foreach ( vector colorEntry in colorEntries )
		{
			float distToColor = sqrt( pow( (color.x - colorEntry.x), 2.0 ) + pow( (color.y - colorEntry.y), 2.0 ) + pow( (color.z - colorEntry.z), 2.0 ) )

			if ( distToColor < closestDistToColor || closestDistToColor < 0.0 )
			{
				closestColor = colorEntry
				closestDistToColor = distToColor
			}
		}
	}

	return closestColor
}

ClubHSV function RGBToHSV( vector rgb )
{
	ClubHSV hsv
	float maxChannel = max( rgb.x, rgb.y )
	maxChannel = max( maxChannel, rgb.z )
	float minChannel = min( rgb.x, rgb.y )
	minChannel = min( minChannel, rgb.z )
	float difference = maxChannel - minChannel

	hsv.saturation = (maxChannel == 0.0) ? 0.0 : (difference/maxChannel)

	if ( hsv.saturation == 0 )
		hsv.hue = 0
	else if ( maxChannel == rgb.x )
		hsv.hue = 60.0 * ( rgb.y - rgb.z ) / difference
	else if ( maxChannel == rgb.y )
		hsv.hue = 120.0 + 60.0 * ( rgb.z - rgb.x ) / difference
	else if ( maxChannel == rgb.z )
		hsv.hue = 240.0 + 60.0 * ( rgb.x - rgb.y ) / difference

	if ( hsv.hue < 0.0 )
		hsv.hue += 360.0

	hsv.hue = RoundFloat( hsv.hue )
	hsv.value = maxChannel/255.0

	return hsv
}

float function HSVHueShift( float hue, float shiftDegrees )
{
	float newHue = hue + shiftDegrees

	while ( newHue >= 360.0 )
		newHue -= 360.0

	while ( newHue < 0.0 )
		newHue += 360.0

	return newHue
}

float function HSVSaturationOrValueShift( float value, float shiftPercent )
{
	float newValue = value + shiftPercent

	while ( newValue >= 1.0 )
		newValue -= 1.0

	while ( newValue < 0.0 )
		newValue += 1.0

	return newValue
}

vector function HSVToRGB( ClubHSV hsv )
{
	vector rgb
	ClubHSV adjustedHSV = hsv

	if ( hsv.saturation == 0.0 )
	{
		rgb.x = RoundFloat( hsv.value * 255.0 )
		rgb.y = RoundFloat( hsv.value * 255.0 )
		rgb.z = RoundFloat( hsv.value * 255.0 )
		return rgb
	}

	adjustedHSV.hue /= 60.0
	float i = floor( adjustedHSV.hue )
	float f = adjustedHSV.hue - i
	float p = adjustedHSV.value * ( 1 - adjustedHSV.saturation )
	float q = adjustedHSV.value * ( 1 - adjustedHSV.saturation * f )
	float t = adjustedHSV.value * ( 1 - adjustedHSV.saturation * (1-f) )
	switch ( i )
	{
		case 0:
			rgb.x = adjustedHSV.value
			rgb.y = t
			rgb.z = p
			break
		case 1:
			rgb.x = q
			rgb.y = adjustedHSV.value
			rgb.z = p
			break
		case 2:
			rgb.x = p
			rgb.y = adjustedHSV.value
			rgb.z = t
			break
		case 3:
			rgb.x = p
			rgb.y = q
			rgb.z = adjustedHSV.value
			break
		case 4:
			rgb.x = t
			rgb.y = p
			rgb.z = adjustedHSV.value
			break
		default:
			rgb.x = adjustedHSV.value
			rgb.y = p
			rgb.z = q
	}

	rgb.x = RoundFloat( rgb.x * 255.0 )
	rgb.y = RoundFloat( rgb.y * 255.0 )
	rgb.z = RoundFloat( rgb.z * 255.0 )

	return rgb
}

float function RoundFloat( float number )
{
	float integral = floor( number )
	float decimal  = fabs( number % 1.0 )

	if ( decimal >= 0.5 )
		integral += signum( integral )

	return integral
}

string function ClubLogo_ConvertLogoToString( ClubLogo logo )
{
	string clubLogoString

	for ( int layerIndex = 0; layerIndex < logo.logoLayers.len(); layerIndex++ )
	{
		ClubLogoLayer layer = logo.logoLayers[layerIndex]

		string nameString    = ItemFlavor_GetGUIDString( layer.elementFlav ) + CLUB_LOGO_PROPERTY_DELIMITER
		string primaryColorX = string( layer.primaryColorOverride.x ) + CLUB_LOGO_COLORVEC_DELIMITER
		string primaryColorY = string( layer.primaryColorOverride.y ) + CLUB_LOGO_COLORVEC_DELIMITER
		string primaryColorZ = string( layer.primaryColorOverride.z ) + CLUB_LOGO_PROPERTY_DELIMITER
		string secondaryColorX = string( layer.secondaryColorOverride.x ) + CLUB_LOGO_COLORVEC_DELIMITER
		string secondaryColorY = string( layer.secondaryColorOverride.y ) + CLUB_LOGO_COLORVEC_DELIMITER
		string secondaryColorZ = string( layer.secondaryColorOverride.z ) + CLUB_LOGO_LAYER_DELIMITER
		string secondaryColorAlpha = string( layer.secondaryColorAlpha ) + CLUB_LOGO_LAYER_DELIMITER

		clubLogoString = clubLogoString + nameString + primaryColorX + primaryColorY + primaryColorZ + secondaryColorX + secondaryColorY + secondaryColorZ            
	}

	printf( "ClubLogoDebug: %s(): Converted logo to string: %s", FUNC_NAME(), clubLogoString )
	return clubLogoString
}

ClubLogo function ClubLogo_ConvertLogoStringToLogo( string logoString )
{
	array<string> logoStringArray = split( logoString, CLUB_LOGO_LAYER_DELIMITER )
	ClubLogo clubLogo

	if ( logoStringArray.len() == 0 )
	{
		return clubLogo
	}
	else if ( logoStringArray.len() < CLUB_LOGO_LAYER_MAX )
	{
		return clubLogo
	}
	else
	{
		if ( logoStringArray.len() > CLUB_LOGO_LAYER_MAX )
			logoStringArray.resize( CLUB_LOGO_LAYER_MAX )
	}

	foreach ( string layerString in logoStringArray )
	{
		int layerIndex = logoStringArray.find( layerString )

		ClubLogoLayer layer

		array<string> layerPropArray = split( layerString, CLUB_LOGO_PROPERTY_DELIMITER )

		string layerFlavGuidString = layerPropArray[0]

		                                                                                                                                   
		SettingsAssetGUID layerFlavGUID = ConvertItemFlavorGUIDStringToGUID( layerFlavGuidString )
		if ( !IsValidItemFlavorGUID( layerFlavGUID ) )
		{
			Warning( "Club Logo Warning: Had to bypass adding ItemFlavor GUID " + layerFlavGuidString + " (layer index: " + layerIndex + ") to the logo as it is invalid." )
			continue
		}

		ItemFlavor ornull layerFlav = GetItemFlavorByGUID( layerFlavGUID )
		Assert( layerFlav != null, format( "Club Logo String returned null Item Flavor: %s", layerFlavGuidString ) )
		expect ItemFlavor( layerFlav )

		layer.elementFlav = layerFlav

		string layerPrimaryColorOverrideString = layerPropArray[1]
		array<string> primaryColorStringArray  = split( layerPrimaryColorOverrideString, CLUB_LOGO_COLORVEC_DELIMITER )
		Assert( primaryColorStringArray.len() == 3, "Club Logo String returned incorrect number of parameters for color vector" )
		vector colorOverride
		colorOverride.x = float( primaryColorStringArray[0] )
		colorOverride.y = float( primaryColorStringArray[1] )
		colorOverride.z = float( primaryColorStringArray[2] )
		layer.primaryColorOverride = colorOverride

		string layerSecondaryColorOverrideString = layerPropArray[2]
		array<string> secondaryColorStringArray = split( layerSecondaryColorOverrideString, CLUB_LOGO_COLORVEC_DELIMITER )
		if ( secondaryColorStringArray.len() == 3 )
		{
			vector secondaryColorOverride
			secondaryColorOverride.x = float( secondaryColorStringArray[0] )
			secondaryColorOverride.y = float( secondaryColorStringArray[1] )
			secondaryColorOverride.z = float( secondaryColorStringArray[2] )
			layer.secondaryColorOverride = secondaryColorOverride
		}
		else
		{
			layer.secondaryColorAlpha = 0.0
		}

		clubLogo.logoLayers.append( layer )
	}

	return clubLogo
}

#if UI
var function ClubLogoUI_CreateNestedClubLogo( var parentRui, string arg, ClubLogo logo )
{
	RuiDestroyNestedIfAlive( parentRui, arg )

	var nestedClubLogoRui = RuiCreateNested( parentRui, arg, $"ui/club_logo.rpak" )
	asset ornull frameMask
	float verticalOffset

	int layerCount = minint( logo.logoLayers.len(), CLUB_LOGO_LAYER_MAX )
	if ( layerCount > 0 )
	{
		frameMask = ClubLogo_GetLogoFrameMask( logo.logoLayers[0].elementFlav )
		verticalOffset = ClubLogo_GetLogoVerticalOffset( logo.logoLayers[0].elementFlav )
	}

	RuiSetBool( nestedClubLogoRui, "isInvite", logo.isInvite )

	for( int i = 0; i < layerCount; i++ )
	{
		string logoLayerString = format( "layer0%d", i )
		RuiSetImage( nestedClubLogoRui, logoLayerString + "Image", ClubLogo_GetLogoElementImage( logo.logoLayers[i].elementFlav ) )
		                                                                                             
		RuiSetFloat3( nestedClubLogoRui, logoLayerString + "Color01", logo.logoLayers[i].primaryColorOverride )

		                 
		asset ornull secondaryColorMask = ClubLogo_GetLogoSecondaryColorMask( logo.logoLayers[i].elementFlav )
		if ( secondaryColorMask != null )
		{
			expect asset( secondaryColorMask )
			RuiSetImage( nestedClubLogoRui, logoLayerString + "ColorMask", secondaryColorMask )
			RuiSetFloat3( nestedClubLogoRui, logoLayerString + "Color02", logo.logoLayers[i].secondaryColorOverride )
			                                                                                                            
		}

		int elementType = ClubLogo_GetLogoElementType( logo.logoLayers[i].elementFlav )
		if ( elementType != eClubLogoElementType.CLUBLOGOTYPE_FRAME )
		{
			if ( frameMask != null )
				RuiSetImage( nestedClubLogoRui, "frameMask", expect asset( frameMask ) )                                

			if ( elementType == eClubLogoElementType.CLUBLOGOTYPE_EMBLEM )
				RuiSetFloat( nestedClubLogoRui, "verticalOffset", verticalOffset )
		}
	}

	return nestedClubLogoRui
}
#endif

                                                                                       
  
                                                                                                                                                                                                                                        
                                                                                                                                                                                                                                                      
                                                                                                                                                                                                                              
                                                                                                                                                                                                                            
                                                                                                                                                                                                                                
                                                                                                                                                                                                                          
  
                                                                                       

array<ItemFlavor> function GetAllClubSearchTags()
{
	return GetAllItemFlavorsOfType( eItemType.club_search_tag )
}

array<ItemFlavor> function ClubSearchTag_GetAllEnabledSearchTags()
{
	array<ItemFlavor> tagFlavors = GetAllClubSearchTags()
	foreach ( ItemFlavor tagFlavor in tagFlavors )
	{
		if ( !ClubSearchTag_IsTagEnabled( tagFlavor ) )
			tagFlavors.removebyvalue( tagFlavor )
	}

	return tagFlavors
}

ItemFlavor ornull function ClubSearchTag_GetItemFlavorFromBitMaskAddress( int address )
{
	array<ItemFlavor> allTags = ClubSearchTag_GetAllEnabledSearchTags()

	foreach ( ItemFlavor searchTag in allTags )
	{
		int tagAddress = ClubSearchTag_GetBitFlag( searchTag )
		if ( tagAddress == address )
			return searchTag
	}

	return null
}

array<ItemFlavor> function ClubSearchTag_GetItemFlavorsFromBitMask( int flagMask )
{
	array<ItemFlavor> searchTags

	for ( int i = 0; i <= 31; i++ )
	{
		int mask = ( 1 << i )

		bool isFlagged = (flagMask & mask) == mask
		if ( isFlagged )
		{
			ItemFlavor ornull tagFlavor = ClubSearchTag_GetItemFlavorFromBitMaskAddress( i )
			if ( tagFlavor != null )
			{
				expect ItemFlavor( tagFlavor )
				printf( "ClubCreateDebug: Adding %s to detail array", ClubSearchTag_GetTagString( tagFlavor ) )
				searchTags.append( tagFlavor )
			}
		}
	}

	return searchTags
}

array<string> function ClubSearchTag_GetSearchTagNamesFromBitmask( int flagMask )
{
	array<string> searchTagNames

	array<ItemFlavor> searchTagFlavs = ClubSearchTag_GetItemFlavorsFromBitMask( flagMask )
	foreach ( ItemFlavor tagFlav in searchTagFlavs )
	{
		string tagName = ClubSearchTag_GetTagString( tagFlav )
		searchTagNames.append( tagName )
	}

	return searchTagNames
}

int function ClubSearchTag_CreateSearchTagBitMask( array<ItemFlavor> searchTags )
{
	                                                                                                     

	int searchTagBitMask
	array<int> searchTagFlags
	foreach ( ItemFlavor searchTag in searchTags )
	{
		int flag = ClubSearchTag_GetBitFlag( searchTag )
		                                                                              
		searchTagFlags.append( flag )
	}

	foreach ( int flag in searchTagFlags )
	{
		int address = ( 1 << flag )
		searchTagBitMask = searchTagBitMask | address
	}

	                                                                                        
	return searchTagBitMask
}

int function ClubSearchTag_GetBitFlag( ItemFlavor searchTag )
{
	Assert( ItemFlavor_GetType( searchTag ) == eItemType.club_search_tag )
	return GetGlobalSettingsInt( ItemFlavor_GetAsset( searchTag ), "tagBitAddress" )
}

int function ClubSearchTag_GetTagType( ItemFlavor searchTag )
{
	Assert( ItemFlavor_GetType( searchTag ) == eItemType.club_search_tag )
	return eClubSearchTagType[ GetGlobalSettingsString( ItemFlavor_GetAsset( searchTag ), "tagCategory" ) ]
}

string function ClubSearchTag_GetTagString( ItemFlavor searchTag )
{
	Assert( ItemFlavor_GetType( searchTag ) == eItemType.club_search_tag )
	return GetGlobalSettingsString( ItemFlavor_GetAsset( searchTag ), "localizationKey_NAME_SHORT" )
}

bool function ClubSearchTag_IsTagEnabled( ItemFlavor searchTag )
{
	Assert( ItemFlavor_GetType( searchTag ) == eItemType.club_search_tag )
	return GetGlobalSettingsBool( ItemFlavor_GetAsset( searchTag ), "isSearchTagEnabled" )
}

array<ItemFlavor> function ClubSearchTag_GetTagsByType( int tagType )
{
	array<ItemFlavor> flavors = ClubSearchTag_GetAllEnabledSearchTags()

	foreach( flavor in flavors )
	{
		if ( ClubSearchTag_GetTagType( flavor ) != tagType )
			flavors.removebyvalue( flavor )
	}

	return flavors
}

#if UI
void function ClubSearchTag_AddSearchTagToSelection( ItemFlavor searchTag )
{
	                                                                        
	Assert( ItemFlavor_GetType( searchTag ) == eItemType.club_search_tag )
	Assert( !file.selectedSearchTags.contains( searchTag ), "Search Tag Selection: Tried to add duplicate item flavor selection" )

	file.selectedSearchTags.append( searchTag )
}

void function ClubSearchTag_RemoveSearchTagFromSelection( ItemFlavor searchTag )
{
	                                                                          
	Assert( ItemFlavor_GetType( searchTag ) == eItemType.club_search_tag )
	Assert( file.selectedSearchTags.contains( searchTag ), "Search Tag Selection: Tried to remove search tag from selection that was not present" )

	file.selectedSearchTags.removebyvalue( searchTag )
}

array<ItemFlavor> function ClubSearchTag_GetSelectedSearchTags()
{
	                                                                                                            
	return file.selectedSearchTags
}

void function ClubSearchTag_ClearSelectedSearchTags()
{
	                                                   
	file.selectedSearchTags.clear()
}

const int CLUB_DETAILS_SEARCH_TAG_LINE_LENGTH = 100
array<string> function CreateSearchTagDetailsStrings( array<ItemFlavor> searchTags )
{
	array<string> searchTagStrings
	if ( searchTags.len() == 0 )
		return searchTagStrings

	string line00
	string line01
	int maxTags = minint( searchTags.len(), 3 )
	bool isPopulatingLine01 = false
	for ( int i = 0; i < searchTags.len(); i++ )
	{
		string tagString = Localize( ClubSearchTag_GetTagString( searchTags[i] ) )
		string inbetween = line00.len() > 0 ? ", " : ""

		string testString = line00 + inbetween + tagString
		if ( testString.len() < CLUB_DETAILS_SEARCH_TAG_LINE_LENGTH && !isPopulatingLine01 )
		{
			line00 = line00 + inbetween + tagString
		}
		else
		{
			inbetween = line01.len() > 0 ? ", " : ""
			line01 = line01 + inbetween + tagString
			isPopulatingLine01 = true
		}
	}

	                                                                           
	                                                                              
	searchTagStrings.append( line00 )
	searchTagStrings.append( line01 )

	return searchTagStrings
}

string function ClubSearchTag_GetNamesOfSearchTagsFromArray( array<string> searchTags )
{
	string tagListString
	foreach ( name in searchTags )
	{
		string delimiter = searchTags.find( name ) == searchTags.len() - 1 ? "" : ", "
		tagListString = tagListString + Localize( name ) + delimiter
	}

	return tagListString
}
#endif

                                                                                       
  
                                                                                                                                                           
                                                                                                                                                                     
                                                                                                                                              
                                                                                                                                            
                                                                                                                                                                        
                                                                                                                                                           
  
                                                                                       

#if CLIENT || UI
bool function Clubs_AreObituaryTagsEnabledByPlaylist()
{
	return GetCurrentPlaylistVarBool( "ClubTagsInObituaryEnabled", true )
}
#endif

#if UI
var function ClubTag_CreateNestedClubTag( var parentRui, string arg, string clubTag )
{
	RuiDestroyNestedIfAlive( parentRui, arg )

	var nestedClubTagRui = RuiCreateNested( parentRui, arg, $"ui/club_tag.rpak" )
	RuiSetString( nestedClubTagRui, "clubTagString", clubTag )

	return nestedClubTagRui
}
#endif

#if UI
bool function Clubs_IsValidClubTag( string clubTag )
{
	if ( clubTag.len() < 3 )
		return false

	if ( clubTag.find( " " ) > -1 )
		return false

	return true
}
#endif


                                                                                       
  
                                                                                                                                                   
                                                                                                                                                     
                                                                                                                                   
                                                                                                                                         
                                                                                                                                             
                                                                                                                                       
  
                                                                                       

const int MAX_PLACEMENT_FOR_CLUB_EVENT = 5
const int MAX_PLACEMENT_FOR_ARENAS_CLUB_EVENT = 1
const int MAX_PLACEMENT_FOR_WINTER_EXPRESS_CLUB_EVENT = 1

#if SERVER
                                                                                     
 
	                                                                

	                                               
		      

                        
		                                                                      
			      
       

                       
                                                                                                 
         
       

	                                                                               
	                                                                    
	                                                            
 
#endif

#if UI
void function ServerToUI_AddPlayerDataForPlacementReport( int placement )
{
	                                               
	array< ClubSquadSummaryPlayerData > squadSummaryData
	int maxTrackedSquadMembers = PersistenceGetArrayCount( "lastGameSquadStats" )

	                                                                                                
	                                                    
	   
	  	                                                                                                   
	  	                                                                                                 
	  	                                                                                
	  	                                                                                    
	  
	  	                                                                                                                                                                 
	   
	                                                                                              

	for ( int i = 0; i < maxTrackedSquadMembers; i++ )
	{
		ClubSquadSummaryPlayerData playerData
		playerData.nucleusID = expect string( GetPersistentVar( "lastGameSquadStats[" + i + "].nucleusId" ) )
		if ( !Clubs_IsUserAClubmate( playerData.nucleusID ) )
		{
			                                                                                                                                                          
			continue
		}

		playerData.kills = GetPersistentVarAsInt( "lastGameSquadStats[" + i + "].kills" )
		playerData.damageDealt = GetPersistentVarAsInt( "lastGameSquadStats[" + i + "].damageDealt" )

		if ( squadSummaryData.contains( playerData ) == false )
		{
			squadSummaryData.append( playerData )
		}
	}

	                                                                                        
	                                                                       
	   
	  	                                       
	  	                                  
	  	                                      
	  
	  	                                                                                                                                            
	   
	                                                                                      

	Clubs_ReportMatchPlacementToClub( squadSummaryData, placement )
}
#endif

#if UI
void function ServerToUI_Clubs_UpdateLastMatchTimes()
{
	int maxTrackedSquadMembers = PersistenceGetArrayCount( "lastGameSquadStats" )
	bool playedWithClubMembers = false
	string eaid = GetLocalClientPlayer().GetPINNucleusId()

	for ( int i = 0; i < maxTrackedSquadMembers; i++ )
	{
		ClubSquadSummaryPlayerData playerData
		playerData.nucleusID = expect string( GetPersistentVar( "lastGameSquadStats[" + i + "].nucleusId" ) )
		if ( Clubs_IsUserAClubmate( playerData.nucleusID ) && playerData.nucleusID != eaid )
			playedWithClubMembers = true
	}

	ClubUpdateLastMatchTime( playedWithClubMembers )
}
#endif

#if UI
void function Clubs_ReportMatchPlacementToClub( array<ClubSquadSummaryPlayerData> squadSummaryData, int placement )
{
	printf( "ClubEventDebug: %s()", FUNC_NAME() )
	if ( placement > MAX_PLACEMENT_FOR_CLUB_EVENT )
		return

	if ( !Clubs_IsEnabled() )
		return

	if ( !ClubIsValid() )
		return

	foreach ( ClubSquadSummaryPlayerData summaryData in squadSummaryData )
	{
		if ( !Clubs_IsUserAClubmate( summaryData.nucleusID ) )
		{
			squadSummaryData.removebyvalue( summaryData )
		}
	}
	if ( squadSummaryData.len() == 0 )
		return

	squadSummaryData.sort( SortClubMembersByPerformance )


	if (squadSummaryData[0].nucleusID != GetLocalClientPlayer().GetPINNucleusId() )
	{
		return
	}

	int playlistIndex = GetPlaylistIndexForName( GetCurrentPlaylistName() )
	if ( playlistIndex == -1 )
		return

	array<string> playerIDs
	for ( int i = 0; i < squadSummaryData.len(); i++ )
	{
		playerIDs.append( squadSummaryData[i].nucleusID )
	}
	string compiledPlayerNames = CompilePlacementNamesIntoOneString( playerIDs )
	string playlistName = GetCurrentPlaylistVarInt( "maskPlaylistNameForClubReport", 0 ) == 0 ? GetCurrentPlaylistVarString( "name", "#PL_TRIO" ) : "#PL_TRIO"

	#if DEV
		int maxTeams = GetCurrentPlaylistVarInt( "max_teams", 20 )
		int maxPlayers = GetCurrentPlaylistVarInt( "max_players", 60 )
		int maxSquadSize = maxPlayers / maxTeams

		if ( squadSummaryData.len() > maxSquadSize )
		{
			printf( "ClubEventDebug: %s(): DEBUG: Playlist Data: Name: %s, Display Name: %s", FUNC_NAME(), GetCurrentPlaylistName(), GetCurrentPlaylistVarString( "name", "#PL_TRIO" ) )

			printf( "ClubEventDebug: %s(): PLACEMENT EVENT ERRROR - Begin Squad Data Dump", FUNC_NAME() )
			foreach ( ClubSquadSummaryPlayerData playerData in squadSummaryData )
			{
				string nucleusID = playerData.nucleusID
				int playerKills = playerData.kills
				int playerDmg = playerData.damageDealt

				printf( "ClubEventDebug: %s(): PLACEMENT EVENT ERRROR - nucleus ID: %s, kills: %i, playerDmg: %i", FUNC_NAME(), nucleusID, playerKills, playerDmg )
			}
			printf( "ClubEventDebug: %s(): PLACEMENT EVENT ERRROR - End Squad Data Dump", FUNC_NAME() )

			Assert( false, "CLUB ERROR: Attempted to report too many player names to Event Timeline. EXPECTED " + maxSquadSize + ", GOT " + squadSummaryData.len() )
		}
	#endif

	compiledPlayerNames = RegexpReplace( compiledPlayerNames, "%", "□" )

	string eventText = compiledPlayerNames + CLUB_EVENT_DELIMITER + playlistName

	ClubPublishEvent( CLUB_EVENT_PROGRESS, placement, eventText )
}
#endif

#if UI
int function SortClubMembersByPerformance( ClubSquadSummaryPlayerData a, ClubSquadSummaryPlayerData b )
{
	if ( a.kills > b.kills )
		return -1
	if ( a.kills < b.kills )
		return 1
	if ( a.damageDealt > b.damageDealt )
		return -1
	if ( a.damageDealt < b.damageDealt )
		return 1

	return 0
}
#endif

#if UI
string function CompilePlacementNamesIntoOneString( array<string> playerIDs )
{
	                                                                                                        
	                                    
	if ( playerIDs.len() > 1 )
	{
		for ( int i = 0; i < playerIDs.len(); i++ )
		{
			if ( i >= playerIDs.len() )
				break

			for( int y = 0; y < playerIDs.len(); y++ )
			{
				if ( i != y && playerIDs[i] == playerIDs[y] )
					playerIDs.fastremove( y )
			}
		}
	}

	array<string> uncompiledNames
	foreach( playerID in playerIDs )
	{
		string memberName = Clubs_GetClubMemberNameFromNucleus( playerID )

		if ( memberName != "" )
			uncompiledNames.append( Clubs_GetClubMemberNameFromNucleus( playerID ) )
	}
	                                                                                                      

	string compiledNames
	for ( int i = 0; i < uncompiledNames.len(); i++ )
	{
		string delimiter
		int namesLeft = (uncompiledNames.len() - 1) - i
		if ( namesLeft > 1 )
			delimiter = Localize( "#CLUB_EVENT_PROGRESS_NAME_BREAK" )
		if ( namesLeft == 1 )
			delimiter = Localize( "#CLUB_EVENT_PROGRESS_NAME_LAST" )

		compiledNames = compiledNames + uncompiledNames[i] + delimiter
		                                                                                                                                         
	}

	                                                                                                    
	return compiledNames
}
#endif

#if (UI && DEV)
void function DEV_ReportFakePlacementEvent( int forceSquadSize = -1, bool testDupes = false )
{
	if ( !ClubIsValid() )
		return

	array<ClubMember> clubMembers = ClubGetMembers()
	int squadSize = minint( clubMembers.len(), RandomIntRange( 1, 3 ) )
	if ( forceSquadSize > 0 )
		squadSize = minint( clubMembers.len(), forceSquadSize )

	clubMembers.randomize()
	clubMembers.resize( squadSize )

	if ( testDupes )
	{
		for ( int i = 0; i < squadSize * 2; i++ )
		{
			                                                                                                                                                     
			clubMembers.append( clubMembers[i] )
		}
		clubMembers.randomize()
	}

	array<string> playerIDs
	foreach ( ClubMember member in clubMembers )
	{
		playerIDs.append( member.memberID )
	}
	string squadNames = CompilePlacementNamesIntoOneString( playerIDs )

	squadNames = RegexpReplace( squadNames, "%", "□" )

	                                                                                                                  
	ClubPublishEvent( CLUB_EVENT_PROGRESS, RandomIntRange( 1, 5 ), (squadNames+CLUB_EVENT_DELIMITER+"Pretend Playlist") )
}
#endif

                                                                                       
  
                                                                                                                                                                                                      
                                                                                                                                                                                                                    
                                                                                                                                                                                               
                                                                                                                                                                                             
                                                                                                                                                                                           
                                                                                                                                                                                
  
                                                                                       


#if UI
void function Clubs_Report( ClubHeader clubHeader )
{
	Remote_ServerCallFunction( "ClientCallback_ReportClub", clubHeader.clubID, clubHeader.creatorID, clubHeader.tag, clubHeader.name , GetNameFromHardware(clubHeader.hardware))
}
#endif


                                                                                       
  
                                                                                                                                                                                                                                                                                                            
                                                                                                                                                                                                                                                                                                                          
                                                                                                                                                                                                                                                                                            
                                                                                                                                                                                                                                                                                            
                                                                                                                                                                                                                                                                                                                          
                                                                                                                                                                                                                                                                                                            
  
                                                                                       


string function ClubRegulation_GetReasonString( int reasonInt )
{
	string reasonString
	switch ( reasonInt )
	{
		case eClubInternalReportReason.REASON_CHAT_OFFENSIVE:
			reasonString = "#REPORT_CLUB_INTERNAL_CAT_CHAT_OFFENSIVE"
			break
		case eClubInternalReportReason.REASON_CHAT_SPAM:
			reasonString = "#REPORT_CLUB_INTERNAL_CAT_CHAT_SPAM"
			break
		case eClubInternalReportReason.REASON_CHAT_HARASSMENT:
			reasonString = "#REPORT_CLUB_INTERNAL_CAT_CHAT_HARASSMENT"
			break
		case eClubInternalReportReason.REASON_CHAT_HATESPEECH:
			reasonString = "#REPORT_CLUB_INTERNAL_CAT_CHAT_HATESPEECH"
			break
		case eClubInternalReportReason.REASON_CHAT_SUICIDETHREAT:
			reasonString = "#REPORT_CLUB_INTERNAL_CAT_CHAT_SUICIDETHREAT"
			break
		case eClubInternalReportReason.REASON_GAME_CHEATS:
			reasonString = "#REPORT_CLUB_INTERNAL_CAT_GAME_CHEATS"
			break
		case eClubInternalReportReason.REASON_GAME_OFFENSIVE:
			reasonString = "#REPORT_CLUB_INTERNAL_CAT_GAME_OFFENSIVE"
			break
		case eClubInternalReportReason.REASON_GAME_RUDETOCLUBMATES:
			reasonString = "#REPORT_CLUB_INTERNAL_CAT_GAME_RUDECLUBMATES"
			break
		case eClubInternalReportReason.REASON_GAME_RUDETORANDOMS:
			reasonString = "#REPORT_CLUB_INTERNAL_CAT_GAME_RUDERANDOMS"
			break
		default:
			reasonString = "INVALID REPORT REASON"
			break
	}

	                                                                                                          
	return reasonString
}

#if UI
array<ClubEvent> function ClubRegulation_GetComplaintsForMember( ClubMember member )
{
	array<ClubEvent> memberReports
	array<ClubEvent> allReports = ClubGetEventLogReports()

	foreach( ClubEvent report in allReports )
	{
		if ( report.eventText == member.memberID )
			memberReports.append( report )
	}

	return memberReports
}
#endif


                                                                                       
  
                                                                                                                                                     
                                                                                                                                                                         
                                                                                                                                                         
                                                                                                                                                           
                                                                                                                                                                       
                                                                                                                                               
  
                                                                                       

bool function Clubs_IsEnabled()
{
#if UI
	if ( IsConnected() && Clubs_AreDisabledByPlaylist() )
		return false

	return ( ClubEnabled() && !PSNGetCommRestricted() )
#else
	return false
#endif
}


bool function Clubs_AreDisabledByPlaylist()
{
	return GetCurrentPlaylistVarBool( "Clubs_ForceDisable", false )
}


#if SERVER
                                                             
 
	                                            
	                                                     
	                                                                                                                               

	       
		                               
		 
			                                                                                                                                                
			                
			                                                                   
			                                          
			 
				                        
					          
			 

			                                                                                                                 

			                                                                           
			 
				                                                                                                                 
				                      
			 
			    
			 
				                                                                                                                                                     
			 
		 
	      

	                      
 
#endif


#if CLIENT
void function OnSettingsUpdated()
{
	bool crossplayEnabled = GetConVarBool( "CrossPlay_user_optin" )
	if ( crossplayEnabled != file.crossplayEnabled )
	{
		RunUIScript( "Clubs_OpenCrossplayChangeDialog" )
	}

	int localBool = crossplayEnabled ? 1 : 0
	int fileBool = file.crossplayEnabled ? 1 : 0
	int convarBool = GetConVarBool( "CrossPlay_user_optin" ) ? 1 : 0
	printf( "ClubsCrossplayDebug: crossplayEnabled: %i, file.crossplayEnabled: %i, convar: %i", localBool, fileBool, convarBool )
}

void function Clubs_UpdateCrossplayVar()
{
	file.crossplayEnabled = GetConVarBool( "CrossPlay_user_optin" )
}

void function Clubs_UIToClient_SetCrossplayVar( bool isEnabled )
{
	SetConVarBool( "CrossPlay_user_optin", isEnabled )
	Clubs_UpdateCrossplayVar()
}


void function Clubs_SetMyStoredClubName( string clubName )
{
	file.myClubName = clubName
}


string function Clubs_GetMyStoredClubName()
{
	return file.myClubName
}
#endif         

#if UI
void function ClubDataUpdateThread()
{
	printf( "ClubDataUpdateThread()" )
	wait 0.1
	                                                              
	bool finishedEditing = false
	while( !finishedEditing )
	{
		wait 0.1
		
		if ( Clubs_GetClubQueryState( CLUB_OP_SET_JOIN_REQUIREMENTS ) == eClubQueryState.PROCESSING )
			continue
		
		if ( Clubs_GetClubQueryState( CLUB_OP_SET_PRIVACY_SETTING ) == eClubQueryState.PROCESSING )
			continue
		
		if ( Clubs_GetClubQueryState( CLUB_OP_SET_SEARCHTAGS ) == eClubQueryState.PROCESSING )
			continue
		
		if ( Clubs_GetClubQueryState( CLUB_OP_SET_LOGO ) == eClubQueryState.PROCESSING )
			continue
		
		finishedEditing = true
	}
	
	UpdateClubLobbyDetails()
	ClubPublishEvent( CLUB_EVENT_EDIT, 0, "" )
	Clubs_UpdateMyData()
}

void function Clubs_UpdateMyData()
{
	printf( "Clubs_UpdateMyData()" )

	int lastQueryError = ClubGetLastQueryError()
	if ( lastQueryError <= 0 )
	{
		thread Clubs_SetClubTabUserCount()

		foreach ( callbackFunc in file.myClubUpdatedCallbacks )
			callbackFunc()
	}
	else
	{
		Warning( "ClubsError: UpdateMyData called when previous query failed. Attempting requery." )
		printf( "ClubQueryDebug: %s(): Forced to attempt requery due to error %i", FUNC_NAME(), lastQueryError )
		thread Clubs_AttemptRequeryThread()
	}
}

void function AddCallback_OnClubDataUpdated( void functionref() callbackFunc )
{
	Assert( !file.myClubUpdatedCallbacks.contains( callbackFunc ), "Already added " + string( callbackFunc ) + " with AddCallback_OnClubDataUpdated" )
	file.myClubUpdatedCallbacks.append( callbackFunc )
}


void function RemoveCallback_OnClubDataUpdated( void functionref() callbackFunc )
{
	Assert( file.myClubUpdatedCallbacks.contains( callbackFunc ), "Callback " + string( callbackFunc ) + " doesn't exist" )
	file.myClubUpdatedCallbacks.fastremovebyvalue( callbackFunc )
}


void function Clubs_CheckClubPersistenceThread()
{
	while ( !IsFullyConnected() )
	{
		WaitFrame()
	}

	if ( ClubEnabled() && IsLobby() && Remote_ServerCallFunctionAllowed() )
	{
		ClubHeader myClubHeader = ClubGetHeader()
		string persistentClubID = string(GetPersistentVar( "clubID" ))
		if ( persistentClubID != myClubHeader.clubID )
		{
			string  toSetId = myClubHeader.clubID;
			Remote_ServerCallFunction( "ClientCallback_SetClubID", toSetId )
		}
	}
}

                              
void function Clubs_PopulateClubDetails( ClubHeader clubHeader, var detailsPanel, bool isMyClub = true, bool hideFrame = false )
{
	                                                
	var logoAnchor    = Hud_GetChild( detailsPanel, "ClubLogoDisplay" )
	var logoAnchorRui = Hud_GetRui( logoAnchor )
	ClubLogo clubLogo
	if ( clubHeader.logoString.len() == 0 )
		clubLogo = GenerateRandomClubLogo( clubHeader.clubID )
	else
		clubLogo = ClubLogo_ConvertLogoStringToLogo( clubHeader.logoString )

	var logo = ClubLogoUI_CreateNestedClubLogo( logoAnchorRui, "clubLogo", clubLogo )
	var detailsDisplay      = Hud_GetChild( detailsPanel, "ClubDetailsDisplay" )
	var detailsRui          = Hud_GetRui( detailsDisplay )

	var nestedClubTag = ClubTag_CreateNestedClubTag( detailsRui, "clubTag", clubHeader.tag )

	printf( "ClubJoinDialogDebug: Clubs_PopulateClubDetails() - name: %s, tag: %s, privacy: %i, minLevel: %i, minRank: %i", clubHeader.name, clubHeader.tag, clubHeader.privacySetting, clubHeader.minLevel, clubHeader.minRating )

	int rank
	if ( isMyClub )
	{
		if ( ClubIsValid() )
			rank = ClubGetMyMemberRank()
		else
			rank = CLUB_RANK_CREATOR
	}
	else
	{
		rank = -1
	}
	RuiSetInt( detailsRui, "myRank", rank )
	                 
	   
	  	                                            
	   

	RuiSetBool( detailsRui, "hideFrame", hideFrame )
	RuiSetString( detailsRui, "clubName", clubHeader.name )
	RuiSetInt( detailsRui, "privacySetting", clubHeader.privacySetting )
	RuiSetString( detailsRui, "minLvlSettingString", Clubs_GetDescStringForMinAccountLevel( clubHeader.minLevel ) )
	RuiSetString( detailsRui, "minRankSettingString", Clubs_GetDescStringForMinRank( clubHeader.minRating ) )
	RuiSetInt( detailsRui, "memberCount", clubHeader.memberCount )

	int searchTagBitFlags = clubHeader.searchTags
	array<ItemFlavor> searchTags = ClubSearchTag_GetItemFlavorsFromBitMask( searchTagBitFlags )
	array<string> tagStrings = CreateSearchTagDetailsStrings( searchTags )
	if (tagStrings.len() == 0 )
	{
		RuiSetString( detailsRui, "searchTagsRow00", "" )
		RuiSetString( detailsRui, "searchTagsRow01", "" )
		return
	}

	for( int i = 0; i < tagStrings.len(); i++ )
	{
		string searchTagRow = format( "searchTagsRow0%d", i )
		RuiSetString( detailsRui, searchTagRow, tagStrings[i] )
	}
}


void function Clubs_ConfigureRankTooltip( var element, int memberRank )
{
	printf( "DetailsTooltip: %s()", FUNC_NAME() )
	string rankName = Clubs_GetClubMemberRankString( memberRank )
	string desc = Clubs_GetClubMemberRankDescriptionStringForTooltip( memberRank )

	printf( "DetailsTooltip: %s(): title: %s, desc: %s", FUNC_NAME(), rankName, desc )
	ToolTipData toolTipData
	toolTipData.titleText = rankName
	toolTipData.descText = desc

	Hud_SetToolTipData( element, toolTipData )
}


string function Clubs_GetClubMemberRankString( int memberRank )
{
	switch( memberRank )
	{
		case CLUB_RANK_GRUNT:
			return Localize( "#LOBBY_CLUBS_RANK_GRUNT" )
		case CLUB_RANK_CAPTAIN:
			return Localize( "#LOBBY_CLUBS_RANK_CAPTAIN" )
		case CLUB_RANK_ADMIN:
			return Localize( "#LOBBY_CLUBS_RANK_ADMIN" )
		case CLUB_RANK_CREATOR:
			return Localize( "#LOBBY_CLUBS_RANK_CREATOR" )
		default:
			return "null"
	}

	unreachable
}


string function Clubs_GetClubMemberRankDescriptionStringForTooltip( int memberRank )
{
	switch( memberRank )
	{
		case CLUB_RANK_GRUNT:
			return Localize( "#CLUB_DETAILS_TOOLTIP_RANK_GRUNT" )
		case CLUB_RANK_CAPTAIN:
			return Localize( "#CLUB_DETAILS_TOOLTIP_RANK_CAPTAIN" )
		case CLUB_RANK_ADMIN:
			return Localize( "#CLUB_DETAILS_TOOLTIP_RANK_ADMIN" )
		case CLUB_RANK_CREATOR:
			return Localize( "#CLUB_DETAILS_TOOLTIP_RANK_CREATOR" )
		default:
			return "null"
	}

	unreachable
}


void function Clubs_ConfigurePrivacyTooltip ( var element, int privacyLevel )
{
	string privacyName = Clubs_GetDescStringForPrivacyLevel( privacyLevel )
	string desc = Clubs_GetPrivacyDescriptionStringForTooltip( privacyLevel )

	ToolTipData toolTipData
	toolTipData.titleText = privacyName
	toolTipData.descText = desc

	Hud_SetToolTipData( element, toolTipData )
}


string function Clubs_GetPrivacyDescriptionStringForTooltip( int privacyLevel )
{
	switch ( privacyLevel )
	{
		case CLUB_PRIVACY_OPEN:
			return Localize( "#CLUB_DETAILS_TOOLTIP_PRIVACY_OPEN" )
		case CLUB_PRIVACY_OPEN_WITH_REQ:
			return Localize( "#CLUB_DETAILS_TOOLTIP_PRIVACY_RESTRICTED" )
		case CLUB_PRIVACY_BY_REQUEST:
			return Localize( "#CLUB_DETAILS_TOOLTIP_PRIVACY_REQUEST" )
		case CLUB_PRIVACY_INVITE_ONLY:
			return Localize( "#CLUB_DETAILS_TOOLTIP_PRIVACY_INVITEONLY" )
		default:
			return ""
	}

	unreachable
}


void function Clubs_ConfigureMinLevelAndRankTooltip( var element, int privacyLevel, int minLvl, int minRank )
{
	string desc
	if ( privacyLevel != CLUB_PRIVACY_OPEN_WITH_REQ )
		desc = Localize( "#CLUB_DETAILS_TOOLTIP_REQUIREMENTS_ANY" )
	else
		desc = Localize( "#CLUB_DETAILS_TOOLTIP_REQUIREMENTS_SET", Localize(Clubs_GetDescStringForMinAccountLevel( minLvl )), Localize(Clubs_GetDescStringForMinRank( minRank )) )

	ToolTipData toolTipData
	toolTipData.descText = desc

	Hud_SetToolTipData( element, toolTipData )
}


array<int> function Clubs_GetPromotableRanks()
{
	array<int> promotableRanks

	for( int i=0; i <= CLUB_RANK_CREATOR; i++ )
	{
		promotableRanks.append(i)
	}

	return promotableRanks
}


string function Clubs_GetClubMemberNameFromNucleus( string memberID )
{
	if ( !ClubIsValid() )
		return ""

	array<ClubMember> clubMembers = ClubGetMembers()

	string memberName
	foreach ( ClubMember clubMember in clubMembers )
	{
		if ( clubMember.memberID == memberID )
		{
			memberName = clubMember.memberName
			break
		}
	}

	return memberName
}


bool function Clubs_IsUserAClubmate( string nucleusID )
{
	if ( !ClubIsValid() )
		return false

	array<ClubMember> clubMembers = ClubGetMembers()

	bool isClubmate
	foreach ( clubMember in clubMembers )
	{
		if ( clubMember.memberID == nucleusID )
		{
			isClubmate = true
			break
		}
	}

	return isClubmate
}

void function Clubs_TryCloseAllClubMenus()
{
	CloseClubsSearchMenu()
	ClubsLogoEditor_CloseLogoEditor()
	thread CloseClubCreationMenu()
	CloseFindClubMemberDialog()
	CloseClubMemberManagementMenu()
}

void function Clubs_SetClubTabUserCount()
{
	while ( !IsConnected() )
		WaitFrame()

	if ( !Clubs_IsEnabled() )
		return

	if ( !IsLobby() )
		return

	var lobbyMenu = GetMenu( "LobbyMenu" )
	TabData lobbyTabData = GetTabDataForPanel( lobbyMenu )

	array<var> panels = GetAllMenuPanels( lobbyMenu )
	int clubPanelIndex
	foreach ( panel in panels )
	{
		if ( GetPanelTabTitle( panel ) == "#LOBBY_CLUBS" )
		{
			clubPanelIndex = panels.find( panel )
		}
	}
	if ( clubPanelIndex == -1 )
		return

	var clubTabButton = lobbyTabData.tabButtons[ clubPanelIndex ]
	var clubTabRui = Hud_GetRui( clubTabButton )

	string popString = GetUserCountStringForClubTab()
	if ( !ClubIsValid() )
		popString = ""

	RuiSetString( clubTabRui, "subtitleText", popString )
}

string function GetUserCountStringForClubTab()
{
	if ( !Clubs_IsEnabled() )
		return ""

	if ( !ClubIsValid() )
		return ""

	return Localize( "#LOBBY_CLUBS_USERCOUNT", ClubLobby_GetOnlineMemberCount() )
}

bool function Clubs_DoIMeetMinimumLevelRequirement()
{
	if ( !IsConnected() )
		return false

	if ( !IsLocalClientEHIValid() )
		return false

	int currentXP    = GetPersistentVarAsInt( "xp" )
	int currentLevel = GetAccountLevelForXP( currentXP )

	if ( currentLevel < CLUB_JOIN_MIN_ACCOUNT_LEVEL )
		return false

	return true
}

void function Clubs_MonitorCrossplayChangeThread()
{
	while ( !IsConnected() )
	{
		WaitFrame()
	}

	if ( !Clubs_IsEnabled() )
	{
		return
	}

	if ( !ClubIsValid() )
	{
		return
	}

	bool userCrossplayEnabled = GetConVarBool( "CrossPlay_user_optin" )
	bool clubCrossplayEnabled = ClubGetHeader().allowCrossplay

	while ( Clubs_IsEnabled() && ClubIsValid() && userCrossplayEnabled == clubCrossplayEnabled )
	{
		if ( IsUserHudOptionsDisplayed() )
		{
			WaitFrame()
			continue
		}

		if ( IsDialog( GetActiveMenu() ) )
		{
			WaitFrame()
			continue
		}

		WaitFrame()

		userCrossplayEnabled = GetConVarBool( "CrossPlay_user_optin" )
		clubCrossplayEnabled =  ClubGetHeader().allowCrossplay

	}

	if( Clubs_IsEnabled() && ClubIsValid() )
	{

		if ( userCrossplayEnabled != clubCrossplayEnabled )
		{
			ClubLeave()
			Clubs_OpenErrorStringDialog( "#CLUB_DIALOG_CROSSPLAY_SYSTEMCHANGE" )
	    }
	}
}

                                                                         
void function Clubs_SetClubQueryState( int operation, int queryState )
{
	printf( "ClubQueryDebug: %s(): Setting query state for operation %i to %i", FUNC_NAME(), operation, queryState )

	file.queryProcessingStateMap[operation] <- queryState

	bool doesOpHaveSuccessCallbacks = operation in file.clubQuerySuccessCallbacks
	if ( !doesOpHaveSuccessCallbacks )
	{
		printf( "ClubQueryDebug: %s(): Initializing Op success callback array for operation %i", FUNC_NAME(), operation )
		array<void functionref()> funcArray = []
		file.clubQuerySuccessCallbacks[operation] <- funcArray
	}

	if ( doesOpHaveSuccessCallbacks && queryState == eClubQueryState.SUCCESSFUL )
	{
		foreach ( callbackFunc in file.clubQuerySuccessCallbacks[operation] )
			callbackFunc()
	}
}


int function Clubs_GetClubQueryState( int operation )
{
	if ( !Clubs_IsClubQueryOperationStateInitialized( operation ) )
	{
		printf( "ClubQueryDebug: Operation %i not yet found in Query State table. Adding.", operation )
		file.queryProcessingStateMap[ operation ] <- eClubQueryState.INACTIVE
	}

	int queryState = file.queryProcessingStateMap[operation]
	printf( "ClubQueryDebug: %s(): Query State for operation %i is %i", FUNC_NAME(), operation, queryState )

	return file.queryProcessingStateMap[operation]
}


bool function Clubs_IsClubQueryProcessing( int operation )
{
	if ( !Clubs_IsClubQueryOperationStateInitialized( operation ) )
		return false

	return file.queryProcessingStateMap[operation] == eClubQueryState.PROCESSING
}


bool function Clubs_IsClubQueryOperationStateInitialized( int operation )
{
	return operation in file.queryProcessingStateMap
}


void function AddCallback_OnClubQuerySuccessful( int operation, void functionref() callbackFunc )
{
	bool operationIsInTable = operation in file.clubQuerySuccessCallbacks
	if ( !operationIsInTable )
	{
		printf( "ClubQueryDebug: %s(): Initializing Op Completed callback array for operation %i", FUNC_NAME(), operation )
		array<void functionref()> funcArray = []
		file.clubQuerySuccessCallbacks[operation] <- funcArray
	}

	Assert( !file.clubQuerySuccessCallbacks[operation].contains( callbackFunc ), "Already added " + string( callbackFunc ) + " with AddCallback_OnClubQueryCompleted" )
	file.clubQuerySuccessCallbacks[operation].append( callbackFunc )
}


void function RemoveCallback_OnClubQuerySuccessful( int operation, void functionref() callbackFunc )
{
	bool operationIsInTable = operation in file.clubQuerySuccessCallbacks
	Assert( !operationIsInTable, "Attempted to remove callback " + string( callbackFunc ) + " for operation + " + string( operation ) + " which has no callbacks" )

	Assert( file.clubQuerySuccessCallbacks[operation].contains( callbackFunc ), "Callback " + string( callbackFunc ) + " doesn't exist" )
	file.clubQuerySuccessCallbacks[operation].fastremovebyvalue( callbackFunc )
}


void function Clubs_AttemptRequeryThread()
{
	printf( "ClubQueryDebug: %s()", FUNC_NAME() )

	while( !IsFullyConnected() )
		WaitFrame()

	Signal( uiGlobal.signalDummy, CLUB_REQUERY_SIGNAL )
	EndSignal( uiGlobal.signalDummy, CLUB_REQUERY_SIGNAL )

	printf( "ClubQueryDebug: %s(): User connected. Checking Clubs_IsEnabled()", FUNC_NAME() )

	if ( !Clubs_IsEnabled() )
		return

	printf( "ClubQueryDebug: %s(): User connected. Checking CLUB_OP_GET_CURRENT query state", FUNC_NAME() )

	if ( Clubs_GetClubQueryState( CLUB_OP_GET_CURRENT ) == eClubQueryState.SUCCESSFUL )
		return

	printf( "ClubQueryDebug: %s(): User connected. CLUB_OP_GET_CURRENT query state is SUCCESSFUL, counting requery attempts (%i/%i)", FUNC_NAME(), file.clubQueryRetryCount, CLUB_QUERY_RETRY_MAX )

	if ( file.clubQueryRetryCount >= CLUB_QUERY_RETRY_MAX )
		return

	ClubGetCurrent()
	file.clubQueryRetryCount++
}


void function Clubs_AttemptLeaveRequestThread()
{

}
#endif     

                                                                                       
  
                                                                                                                                           
                                                                                                                                                       
                                                                                                                                           
                                                                                                                                         
                                                                                                                                                               
                                                                                                                                                     

                                                                                       

#if UI
void function Clubs_OpenErrorDialog( int operation, int errorCode, string errorMsg, string errorCodeString )
{
	if ( IsDialog( GetActiveMenu() ) )
		return

	string errorString = Localize( errorCodeString, operation, errorCode, errorMsg )
	printf( "ClubErrorDebug: Error Dialog String = %s", errorString )

	ConfirmDialogData dialogData
	dialogData.headerText = "#ERROR"
	dialogData.messageText = errorString
	OpenOKDialogFromData( dialogData )
}

void function Clubs_OpenErrorStringDialog( string errorCodeString )
{
	if ( !Clubs_IsEnabled() )
		return

	if ( !IsLobby() || IsPrivateMatchLobby() )
		return

	EmitUISound( "UI_Menu_Deny" )
	Clubs_OpenErrorDialog( -1, CLUB_ERROR_CODE_UNDEFINED, "", errorCodeString )
}

void function Clubs_OpenClubJoinedDialog( string clubName, bool dialogFlow = false )
{
	if ( IsDialog( GetActiveMenu() ) )
		CloseActiveMenu()

	EmitUISound( "UI_Menu_Clubs_JoinedClub" )

	ConfirmDialogData dialogData
	dialogData.headerText = "CLUB_DIALOG_JOINED_NAME"
	dialogData.messageText = Localize( "#CLUB_DIALOG_JOINED_DESC", clubName )
	if ( dialogFlow )
	{
		dialogData.resultCallback = void function ( int result )
		{
			DialogFlow()
		}
	}

	string clubID = ClubGetHeader().clubID
	SetDialogFlowPersistenceTables( "clubID", clubID )                                                                                      
	Remote_ServerCallFunction( "ClientCallback_SetClubID", clubID )

	OpenOKDialogFromData( dialogData )
}

bool function Clubs_ShouldShowClubJoinedDialog()
{
	if ( !IsPersistenceAvailable()  )
		return false

	if ( Clubs_GetClubQueryState( CLUB_OP_GET_CURRENT ) != eClubQueryState.SUCCESSFUL )
		return false

	if ( !Clubs_IsEnabled() )
		return false

	string myClubID = ClubGetHeader().clubID

	if ( GetDialogFlowTablesValueOrPersistence( "clubID"  ) == myClubID  )                                                                                       
		return false

	if ( !ClubIsValid() )
		return false

	return true
}

void function Clubs_OpenClubKickedDialog( bool dialogFlow = false )
{
	if ( IsDialog( GetActiveMenu() ) )
	{
		return
	}

	if ( !IsLobby() )
	{
		return
	}

	ConfirmDialogData dialogData
	dialogData.headerText = "CLUB_DIALOG_KICKED_NAME"
	if ( file.kickedForCrossplay )
	{
		dialogData.messageText = "#CLUB_OP_FAIL_CROSSPLAY_INCOMPAT"
		file.kickedForCrossplay = false
	}
	else
	{
		dialogData.messageText = "#CLUB_DIALOG_KICKED_DESC"
	}

	if ( dialogFlow )
	{
		dialogData.resultCallback = void function ( int result )
		{
			DialogFlow()
		}
	}

	SetDialogFlowPersistenceTables( "clubID", INVALID_CLUB_ID  )
	Remote_ServerCallFunction( "ClientCallback_SetClubID", INVALID_CLUB_ID )                                                                                      

	OpenOKDialogFromData( dialogData )
}

bool function Clubs_ShouldShowClubKickedDialog()
{
	if ( !IsPersistenceAvailable()  )
		return false

	if ( Clubs_GetClubQueryState( CLUB_OP_GET_CURRENT ) != eClubQueryState.SUCCESSFUL )
		return false

	if ( !IsConnected() )
		return false

	if ( !Clubs_IsEnabled() )
		return false

	if ( ClubIsValid() )
		return false

	string persistentClubID = string(GetPersistentVar( "clubID" ))
	string myClubID = ClubGetHeader().clubID

	if ( myClubID != "" )
		return false

	if ( persistentClubID == "" )
		return false

	if ( GetDialogFlowTablesValueOrPersistence( "clubID" ) == myClubID )                                                                                     
		return false

	                                                                                                                  
	return ( persistentClubID != myClubID )
}

void function Clubs_OpenJoinRequestDeniedDialog( bool dialogFlow = false )
{
	ConfirmDialogData dialogData
	dialogData.headerText = "#CLUB_DIALOG_PETITION_DECLINED_NAME"
	dialogData.messageText = "#CLUB_DIALOG_PETITION_DECLINED_DESC"
	if ( dialogFlow )
	{
		dialogData.resultCallback = void function ( int result )
		{
			DialogFlow()
		}
	}

	SetDialogFlowPersistenceTables( "clubIsPendingApproval", false  )                                                                                     
	Remote_ServerCallFunction( "ClientCallback_SetClubIsPendingApproval", false )

	OpenOKDialogFromData( dialogData )
}

bool function Clubs_ShouldShowClubJoinRequestDeniedDialog()
{
	if ( !IsPersistenceAvailable()  )
		return false

	if ( Clubs_GetClubQueryState( CLUB_OP_GET_CURRENT ) != eClubQueryState.SUCCESSFUL )
		return false

	if ( !Clubs_IsEnabled() )
		return false

	if ( ClubIsValid() )
		return false

	                                                                                                                                                       
	bool isPendingApproval = bool(GetPersistentVar( "clubIsPendingApproval" )) || ( GetDialogFlowTablesValueOrPersistence( "clubIsPendingApproval" ) == true )
	return ( isPendingApproval == true && isPendingApproval != ClubIsPendingApproval() )
}

void function Clubs_OpenJoinReqsConfirmDialog( ClubHeader clubHeader )
{
	Clubs_SetJoinClubHeader( clubHeader );

	ConfirmDialogData dialogData
	dialogData.headerText = "#CLUB_DIALOG_PETITION_DECLINED_NAME"
	dialogData.messageText = "#CLUB_DIALOG_WARNING_JOIN_REQS"
	dialogData.resultCallback = OnJoinClubDespiteReqsDialogResult

	OpenConfirmDialogFromData( dialogData )
}

void function OnJoinClubDespiteReqsDialogResult( int result )
{
	if ( result == eDialogResult.YES )
	{
		ClubHeader clubHeader = expect ClubHeader( Clubs_GetJoinClubHeader() )

		Assert( clubHeader.clubID != "" )
		if ( clubHeader.clubID != "" )
		{
			Clubs_JoinClub( clubHeader.clubID )
			                               
			if ( clubHeader.privacySetting == CLUB_PRIVACY_BY_REQUEST )
				Remote_ServerCallFunction( "ClientCallback_SetClubID", PENDING_CLUB_REQUEST )
		}
	}
}

void function Clubs_OpenSwitchClubsConfirmDialog( ClubHeader clubHeader )
{
	Clubs_SetJoinClubHeader( clubHeader )

	ConfirmDialogData dialogData
	dialogData.headerText = "#CLUB_DIALOG_JOIN_NAME"
	dialogData.messageText = "#CLUB_DIALOG_CONFIRM_CLUB_CHANGE"
	dialogData.resultCallback = OnSwitchClubsResult

	OpenConfirmDialogFromData( dialogData )
}

void function OnSwitchClubsResult( int result )
{
	if ( result == eDialogResult.YES )
	{
		ClubHeader clubHeader = expect ClubHeader( Clubs_GetJoinClubHeader() )
		Assert( clubHeader.clubID != "" )
		if ( clubHeader.clubID != "" )
		{
			thread Clubs_SwitchClubsThread( clubHeader )
		}
	}
}

void function Clubs_OpenReportClubConfirmDialog( ClubHeader clubHeader )
{
	if ( HasActiveLobbyPopup() )
		return

	file.reportClubHeader = clubHeader
	ConfirmDialogData dialogData
	dialogData.headerText = "#REPORT_CLUB_HEADER"
	dialogData.messageText = Localize( "#REPORT_CLUB_DESC", clubHeader.name )
	dialogData.resultCallback = OnReportClubDialogResult

	OpenConfirmDialogFromData( dialogData )
}

void function OnReportClubDialogResult( int result )
{
	if ( result == eDialogResult.YES )
	{
		Clubs_Report( expect ClubHeader( file.reportClubHeader ) )

		file.reportClubHeader = null
		Clubs_OpenClubReportedDialog()
	}
}

void function Clubs_OpenClubReportedDialog()
{
	ConfirmDialogData dialogData
	dialogData.headerText = "#REPORT_CLUB_HEADER"
	dialogData.messageText = "#REPORT_CLUB_SENT"

	OpenOKDialogFromData( dialogData )
}

void function Clubs_OpenClubCreateBlockedByMatchmakingDialog()
{
	ConfirmDialogData dialogData
	dialogData.headerText = "#LOBBY_CLUBS_CREATE"
	dialogData.messageText = "#CLUB_DIALOG_CREATE_MATCHMAKING"

	OpenOKDialogFromData( dialogData )
}

void function Clubs_OpenClubEditBlockedByMatchmakingDialog()
{
	ConfirmDialogData dialogData
	dialogData.headerText = "#LOBBY_CLUBS_EDIT_SUBMIT"
	dialogData.messageText = "#CLUB_DIALOG_EDIT_MATCHMAKING"

	OpenOKDialogFromData( dialogData )
}

void function Clubs_OpenClubManagementBlockedByMatchmakingDialog()
{
	ConfirmDialogData dialogData
	dialogData.headerText = "#CLUB_MEMBERS_EDIT_NAME"
	dialogData.messageText = "#CLUB_DIALOG_MANAGE_MATCHMAKING"

	OpenOKDialogFromData( dialogData )
}

bool function Clubs_ShouldShowClubAnnouncementDialog()
{
	if ( !IsConnected() )
		return false

	if ( !IsPersistenceAvailable() )
		return false

	if ( Clubs_GetClubQueryState( CLUB_OP_GET_CURRENT ) != eClubQueryState.SUCCESSFUL )
		return false

	if ( !IsLobby() )
		return false

	if ( !Clubs_IsEnabled() )
		return false

	if ( !ClubIsValid() )
		return false

	ClubEvent announcement = ClubGetStickyNote()
	if ( announcement.eventText == "" )
		return false

	int announceTime = announcement.eventTime
	if ( announceTime == 0 )
		return false

	int savedTime = GetLastViewedAnnouncementTime()

	return announceTime >= savedTime
}

void function Clubs_OpenClubAnnouncementCooldownDialog()
{
	CloseClubAnnouncementDialog()

	ConfirmDialogData dialogData
	dialogData.headerText = "#CLUB_DIALOG_ANNOUNCE_COOLDOWN_NAME"
	dialogData.messageText = Localize( "#CLUB_DIALOG_ANNOUNCE_COOLDOWN_DESC", CLUB_ANNOUNCE_COOLDOWN_MINUTES )

	OpenOKDialogFromData( dialogData )
}

void function Clubs_OpenMemberManagementResetConfirmationDialog()
{
	ConfirmDialogData dialogData
	dialogData.headerText = "#CLUB_MEMBERS_EDIT_NAME"
	dialogData.messageText = "#CLUB_DIALOG_MEMBER_RANK_RESET"
	dialogData.resultCallback = ClubMemberManagement_RefreshMemberSettingsFromDialog

	OpenConfirmDialogFromData( dialogData )
}

void function Clubs_OpenCrossplayChangeDialog()
{
	if ( !ClubIsValid() )
		return
	
	thread OpenCrossplayChangeDialogThread()
}

void function OpenCrossplayChangeDialogThread()
{
	CloseAllDialogs()

	WaitFrame()

	Clubs_OpenCrossplayChangeConfirmationDialog()
}

void function Clubs_OpenCrossplayChangeConfirmationDialog()
{
	ConfirmDialogData dialogData
	dialogData.headerText = "#CLUB_DIALOG_CROSSPLAY_CHANGE_NAME"
	dialogData.messageText = "#CLUB_DIALOG_CROSSPLAY_CHANGE_DESC"
	dialogData.resultCallback = CrossplayLeaveClubOrResultConvar

	OpenConfirmDialogFromData( dialogData )
}

void function CrossplayLeaveClubOrResultConvar( int result )
{
	bool isCrossplayEnabled = GetConVarBool( "CrossPlay_user_optin" )
	if ( result == eDialogResult.YES )
	{
		Clubs_LeaveClub()
	}
	else
	{
		thread ToggleCrossplaySettingThread()
	}
}

void function Clubs_OpenAcceptInviteConfirmationDialog( ClubHeader inviteHeader )
{
	ConfirmDialogData dialogData
	file.selectedClubInvite = inviteHeader

	dialogData.headerText = inviteHeader.name.toupper()                                  
	dialogData.messageText = IsUserOptedInToCrossPlay() ? "#CLUB_DIALOG_INVITE_ACCEPT_DESC" : "#CLUB_DIALOG_INVITE_ACCEPT_DESC_CROSSPLAY"                                                                    
	dialogData.resultCallback = AcceptClubInviteResult

	OpenConfirmDialogFromData( dialogData )
}

void function AcceptClubInviteResult( int result )
{
	if ( result == eDialogResult.YES )
	{
		CloseAllDialogs()

		if ( ClubIsValid() )
		{
			Clubs_OpenErrorStringDialog( "#CLUB_DIALOG_NUCLEUS_ALREADY_IN_CLUB" )
			return
		}

		SocialEventUpdate()
		Clubs_JoinClub( file.selectedClubInvite.clubID )
		                                            
	}
}

void function Clubs_OpenKickTargetIsNotAMemberDialog( ClubMember targetMember )
{
	ConfirmDialogData dialogData
	dialogData.headerText = "#CLUB_KICK_USER_NAME"
	dialogData.messageText = Localize( "#CLUB_KICK_USER_INVALID", targetMember.memberName )

	OpenOKDialogFromData( dialogData )
}

void function Clubs_OpenUserAlreadyAcceptedDialog( ClubJoinRequest joinRequest )
{
	ConfirmDialogData dialogData
	dialogData.headerText = "#CLUB_JOIN_REQUEST_NAME"
	dialogData.messageText = Localize( "#CLUB_DIALOG_PETITION_ACCEPT_INVALID", joinRequest.userName)

	OpenOKDialogFromData( dialogData )
}

void function Clubs_OpenUserAlreadyDeniedDialog( ClubJoinRequest joinRequest )
{
	ConfirmDialogData dialogData
	dialogData.headerText = "#CLUB_JOIN_REQUEST_NAME"
	dialogData.messageText = Localize( "#CLUB_DIALOG_PETITION_REJECT_INVALID", joinRequest.userName)

	OpenOKDialogFromData( dialogData )
}

void function Clubs_OpenJoinReqsChangedDialog( ClubHeader clubHeader )
{
	if ( IsDialog( GetActiveMenu() ) )
		CloseActiveMenu()

	ConfirmDialogData dialogData
	dialogData.headerText = "#CLUB_DIALOG_JOIN_NAME"
	dialogData.messageText = Localize( "#CLUB_DIALOG_JOIN_REQS_CHANGED", clubHeader.name )

	OpenOKDialogFromData( dialogData )
}

void function Clubs_OpenTooLowRankToInviteDialog()
{
	if ( IsDialog( GetActiveMenu() ) )
		CloseActiveMenu()

	ConfirmDialogData dialogData
	dialogData.headerText = Localize( "#CLUB_POPUP_INVITE" ).toupper()
	dialogData.messageText = "#CLUB_DIALOG_INVITE_UNDERRANK"

	OpenOKDialogFromData( dialogData )
}

void function Clubs_OpenJoinRegionConfirmationDialog( ClubHeader clubHeader )
{
	ConfirmDialogData dialogData
	file.selectedOutOfRegionClub = clubHeader

	dialogData.headerText = "#CLUB_DIALOG_JOIN_NAME"
	dialogData.messageText = "#CLUB_DIALOG_JOIN_DIFFERENT_DATACENTER"
	dialogData.resultCallback = AcceptClubDifferentDataCenterResult

	OpenConfirmDialogFromData( dialogData )
}

void function AcceptClubDifferentDataCenterResult( int result )
{
	if ( result == eDialogResult.YES )
	{
		Clubs_JoinClub( file.selectedOutOfRegionClub.clubID )
		                                                 
	}
}
#endif
