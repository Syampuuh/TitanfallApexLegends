                                                                                 
                                                                  
  
                                                                                      
                                                                               

global function printl
global function CodeCallback_Precompile

global struct EchoTestStruct
{
	int test1
	bool test2
	bool test3
	float test4
	vector test5
	int[5] test6
}

global struct TraceResults
{
	entity hitEnt
	vector endPos
	vector surfaceNormal
	string surfaceName
	int surfaceProp
	float fraction
	float fractionLeftSolid
	int hitGroup
	int staticPropID
	bool startSolid
	bool allSolid
	bool hitSky
	bool hitBackFace
	int contents
}

global struct BreachTraceResults
{
	int result
	vector endPos
	vector surfaceNormal
}

global struct GrenadeIndicatorData
{
	vector hitPos
	vector hitNormal
	entity hitEnt
}

global struct VisibleEntityInCone
{
	entity ent
	vector visiblePosition
	int visibleHitbox
	bool solidBodyHit
	vector approxClosestHitboxPos
	int extraMods
}

global struct PlayerDidDamageParams
{
	entity victim
	vector damagePosition
	int hitBox
	int damageType
	float damageAmount
	int damageFlags
	int hitGroup
	entity weapon
	float distanceFromAttackOrigin
}

global struct Attachment
{
	vector position
	vector angle
}

global struct EntityScreenSpaceBounds
{
	float x0
	float y0
	float x1
	float y1
	bool outOfBorder
}

global struct BackendError
{
	int serialNum
	string errorString
}

global struct CommunityFriends
{
	bool isValid
	array<string> ids
	array<string> hardware
	array<string> names
}

global struct CommunityFriendsData
{
	string id
	string hardware
	string name
	string presence
	bool online
	bool ingame
	bool away
}

global struct CommunityFriendsWithPresence
{
	bool isValid
	array<CommunityFriendsData> friends
}

global struct CommunityUserInfo
{
	string hardware
	string uid
	string name
	string kills
	int wins
	int matches
	int banReason
	int banSeconds
	int eliteStreak
	int rankScore
	string rankedPeriodName
	int rankedLadderPos
	int arenaScore
	string arenaPeriodName
	int arenaLadderPos
	int lastCharIdx
	bool isLivestreaming
	bool isOnline
	bool isJoinable
	bool partyFull
	bool partyInMatch
	float lastServerChangeTime
	string privacySetting
	array<int> charData
}

global struct PartyMember
{
	string name
	string uid
	string hardware
	bool ready
	bool present
	string eaid
	string clubTag
	int boostCount
	string unspoofedHardware
}

global struct Party
{
	string playlistName
	string originatorName
	string originatorUID
	int numSlots
	int numClaimedSlots
	int numFreeSlots
	bool amIInThis
	bool amILeader
	bool searching
	array<PartyMember> members
}

global struct RemoteClientInfoFromMatchInfo
{
	string name
	int teamNum
	int score
	int kills
	int deaths
}

global struct RemoteMatchInfo
{
	string datacenter
	string gamemode
	string playlist
	string map
	int maxClients
	int numClients
	int maxRounds
	int roundsWonIMC
	int roundsWonMilitia
	int timeLimitSecs
	int timeLeftSecs
	int teamsLeft
	int maxScore
	array<RemoteClientInfoFromMatchInfo> clients
	array<int> teamScores
}

global struct NetTraceRouteResults
{
	string address
	int sent
	int received
	int bestRttMs
	int worstRttMs
	int lastRttMs
	int averageRttMs
}

#if UI || CLIENT
global struct MatchmakingDatacenterETA
{
	int datacenterIdx
	string datacenterName
	int latency
	int packetLoss
	int etaSeconds
	int idealStartUTC
	int idealEndUTC
}
#endif                

#if SERVER || UI || CLIENT
global struct GRXCraftingOffer
{
	int itemIdx
	int craftingPrice
}

global struct GRXStoreOfferItem
{
	int itemIdx
	int itemQuantity
	int itemType
}

global struct GRXStoreOffer
{
	array< GRXStoreOfferItem > items
	array< array< int > > prices
	table< string, string > attrs
	int offerType
	string offerAlias
}
#endif                          

#if UI || CLIENT
global struct GRXBundleOffer
{
	array< array<int> >bundlePrices
	int purchaseCount
	string ineligibleReason
}
#endif                

global struct GRXUserInfo
{
	int inventoryState

	int queryGoal
	int queryOwner
	int queryState
	int querySeqNum

	array< int > balances
	int nextCurrencyExpirationAmt
	int nextCurrencyExpirationTime

	int sparkleLimitCounter
	int sparkleLimitResetDate

	int marketplaceEdition

	bool isOfferRestricted
	bool hasUpToDateBundleOffers
}

#if UI || CLIENT
global struct ClubHeader
{
	string clubID
	string name
	string tag
	string logoString
	string creatorID
	string dataCenter
	int memberCount
	int privacySetting	                 
	int minLevel
	int minRating
	int searchTags
	int hardware
	bool allowCrossplay
	int lastActive
}

global struct ClubMember
{
	string memberID
	string memberName
	string platformUserID
	int memberHardware
	int rank
}

global struct ClubJoinRequest
{
	string userID
	string userName
	int userHardware
	string platformUid
	int expireTime
}

global struct ClubEvent
{
	int eventTime
	int eventType	               
	int eventParam
	string eventText
	string memberName
	string memberID
}

global struct ClubData
{
	array< ClubMember > members
	array< ClubJoinRequest > joinRequests
	array< ClubEvent > eventLog
	array< ClubEvent > chatLog
}

global struct ClubInvite
{
	string clubID
	string name
}

global struct ClubDisplay{
	string clubID
	string name
	string tag
	string logoString
	string dataCenter
	int lastActive
	int numMembers
	int maxMembers
	float activityMetric
}
#endif                


global struct VortexBulletHit
{
	entity vortex
	vector hitPos
}

global struct AnimRefPoint
{
	vector origin
	vector angles
}

global struct LevelTransitionStruct
{
	                                                                                                          
	                             

	int startPointIndex

	int[3] ints

	int[2] pilot_mainWeapons = [-1,-1]
	int[2] pilot_offhandWeapons = [-1,-1]
	int ornull[2] pilot_weaponMods = [null,null]
	int pilot_ordnanceAmmo = -1

	int titan_mainWeapon = -1
	int titan_unlocksBitfield = 0

	int difficulty = 0
}

global struct WeaponOwnerChangedParams
{
	entity oldOwner
	entity newOwner
}

global struct WeaponTossPrepParams
{
	bool isPullout
}

global struct WeaponPrimaryAttackParams
{
	vector pos
	vector dir
	bool firstTimePredicted
	int burstIndex
	int barrelIndex
}

global struct WeaponRedirectParams
{
	entity projectile
	vector projectilePos
}

global struct WeaponBulletHitParams
{
	entity hitEnt
	vector startPos
	vector hitPos
	vector hitNormal
	vector dir
}

global struct WeaponFireBulletSpecialParams
{
	vector pos
	vector dir
	int bulletCount
	int scriptDamageType
	bool skipAntiLag
	bool dontApplySpread
	bool doDryFire
	bool noImpact
	bool noTracer
	bool activeShot
	bool doTraceBrushOnly
}

global struct WeaponFireBoltParams
{
	vector pos
	vector dir
	float speed
	int scriptTouchDamageType
	int scriptExplosionDamageType
	bool clientPredicted
	int additionalRandomSeed
	bool dontApplySpread
	int projectileIndex
	bool deferred                                                      
}

global struct WeaponFireGrenadeParams
{
	vector pos
	vector vel
	vector angVel
	float fuseTime
	int scriptTouchDamageType
	int scriptExplosionDamageType
	bool clientPredicted
	bool lagCompensated
	bool useScriptOnDamage
	bool isZiplineGrenade = false
	int projectileIndex
}

global struct WeaponFireMissileParams
{
	vector pos
	vector dir
	float speed
	int scriptTouchDamageType
	int scriptExplosionDamageType
	bool doRandomVelocAndThinkVars
	bool clientPredicted
	int projectileIndex
}

global struct WeaponMissileMultipleTargetData
{
	vector pos
	vector normal
	float delay
}

global struct ModInventoryItem
{
	int slot
	string mod
	string weapon
	int count
}

global struct OpticAppearanceOverride
{
	array<string>	bodygroupNames
	array<int>		bodygroupValues
	array<string>	uiDataNames
}

global struct ConsumableInventoryItem
{
	int slot
	int type
	int count
}

global struct OutsourceViewer_SkinDetails
{
	string skinName
	int skinTier
}

global struct PingCollection
{
	entity latestPing
	array<entity> locations
	array<entity> loots
}

global struct HudInputContext
{
	bool functionref(int) keyInputCallback
	bool functionref(float, float) viewInputCallback
	bool functionref(float, float) moveInputCallback
	int hudInputFlags
}

global struct SmartAmmoTarget
{
	entity ent
	float fraction
	float prevFraction
	bool visible
	float lastVisibleTime
	bool activeShot
	float trackTime
}

global struct StaticPropRui
{
	                                
	                                                                                                                                 
	  
	                                                                                                                 

	string scriptName                                       
	string mockupName                                                  
	string modelName                                 
	vector spawnOrigin			                                                                                                       
	vector spawnMins			                                                                                                                                         
	vector spawnMaxs			                                                                                                                                         

	vector spawnForward
	vector spawnRight
	vector spawnUp

	                                
	                                                                                   
	                                                                                    
	                                             
	  
	                                                                                                                                                   

	asset ruiName                                                 
	table<string, string> args                   

	                                
	                                                                                                                                                 
	                                                                                                                                             
	  
	                                                                                                                                                
	                                          

	int magicId
}

global struct ScriptAnimWindow
{
	entity ent
	asset settingsAsset
	string stringID
	string windowName
	float startCycle
	float endCycle
}

global struct ZiplineStationSpots
{
	asset beginStationModel
	vector beginStationOrigin
	vector beginStationAngles
	entity beginStationMoveParent
	string beginStationAnimation
	vector beginZiplineOrigin

	asset endStationModel
	vector endStationOrigin
	vector endStationAngles
	entity endStationMoveParent
	string endStationAnimation
	vector endZiplineOrigin
}

global struct WaypointClusterInfo
{
	vector clusterPos
	int numPointsNear
}

global struct PlayersInViewInfo
{
	entity player
	bool hasLOS
	float distanceSqr
	float dot
}

global struct NavMesh_FindMeshPath_Result
{
	bool navMeshOK
	bool startPolyOK
	bool goalPolyOK
	bool pathFound
	bool pathIsPartialPath
	array<vector> points
	float pathLength
}

global struct PrivateMatchStatsStruct
{
	string playerName
	string teamName
	string characterName
	string platformUid
	string hardware
	int survivalTime
	int kills
	int assists
	int knockdowns
	int damageDealt
	int shots
	int hits
	int headshots
	int revivesGiven
	int respawnsGiven
	int teamNum
	int teamPlacement
	bool alive
}

global struct PrivateMatchAdminChatConfigStruct
{
	int		chatMode
	int		targetIndex
	bool	spectatorChat
}

global struct PrivateMatchChatConfigStruct
{
	bool	adminOnly
}

global typedef SettingsAssetGUID int

#if CLIENT || UI

global enum eRichPresenceSubstitutionMode
{												    				  				  
	NONE,										  
	MODE_MAP,									          			       
	MODE_MAP_SQUADSLEFT,						          			       			                                                                                   
	MODE_MAP_FRIENDLYSCORE_ENEMYSCORE,			          			       			                                                                       
	MODE_MAP_FRIENDLYSCORE_ENEMYSCORE_PERCENTAGE,          			       			                                                                       
	PARTYSLOTSUSED_PARTYSLOTSMAX,				                 	              	                         
}

global struct PresenceState
{
	string 			layout
	int				substitutionMode

	string 			mapName
	string 			gamemode
	int				matchStartTime
	int 			party_slotsUsed
	int 			party_slotsMax
	int 			survival_squadsRemaining
	int				teams_friendlyScore
	int				teams_enemyScore
}

global struct CustomMatch_LobbyPlayer
{
	string uid
	string hardware
	string name
	string clubTag
	bool isAdmin = false
	int team = 1
	int flags = 0
}

global struct CustomMatch_MatchHistory
{
	int matchNumber
	int endTime
}

global struct CustomMatch_LobbyState
{
	                
	int maxTeams = 20
	int minPlayers = 24
	int maxPlayers = 60
	int maxSpectators = 20
	int matchState = 0
	int tokenVer = 1
	int selfIdx = -1
	string playlist
	bool adminChat = false
	bool teamRename = false
	bool selfAssign = true
	bool aimAssist = true
	bool anonMode = false
	array<CustomMatch_LobbyPlayer> players
	array<CustomMatch_MatchHistory> matches
	table<int, string> teamNames
}

global struct CustomMatch_MatchPlayer
{
	string uid
	string hardware
	string name
	string clubTag
	string character
	int status
}

global struct CustomMatch_MatchTeam
{
	int index
	string name
	int placement
	int killCount
	array<CustomMatch_MatchPlayer> players
}

global struct CustomMatch_MatchSummary
{
	string gamemode
	bool inProgress
	array<CustomMatch_MatchTeam> teams
}

global struct CustomMatch_LobbyHistory
{
	array<CustomMatch_MatchHistory> matches
}

#endif                

#if UI || CLIENT
global struct CustomMatch_SettingsForUpdate
{
	string playlist
	bool adminChat
	bool teamRename
	bool selfAssign
	bool aimAssist
	bool anonMode
}

global struct  EadpPresenceData
{
	int			hardware
	PresenceState ornull 	presence
	bool		partyInMatch
	bool		partyIsFull
	string		privacySetting
	string		name
	bool		online
	bool		ingame
	bool		away
	string      firstPartyId
	bool        isJoinable
}

global struct EadpPeopleData
{
	string eaid
	string name
	string platformName
	string platformHardware
	array< EadpPresenceData > presences
}

global struct EadpPeopleList
{
	bool   isValid
	array< EadpPeopleData > people
}

global struct EadpQuerryPlayerData
{
	string	eaid
	string	name
	int		hardware
}

global struct EadpQuerryPlayerDataList
{
	bool   isValid
	array< EadpQuerryPlayerData > players
}


global struct EadpInviteToPlayData
{
	string	eaid
	string	name
	int		hardware
	int		reason
	EadpPresenceData ornull eadpPresence
}

global struct EadpInviteToPlayList
{
	bool   isValid
	array< EadpInviteToPlayData > invitations
}

global const string DISCOVERABLE_EVERYONE = "EVERYONE"
global const string DISCOVERABLE_NOONE = "NO_ONE"

global struct EadpPrivacySetting
{
	bool	isValid
	string	psnIdDiscoverable
	string	xboxTagDiscoverable
	string	displayNameDiscoverable
	string	steamNameDiscoverable
	string	nintendoNameDiscoverable
}

global enum eFriendStatus
{
	ONLINE_INGAME,
	ONLINE,
	ONLINE_AWAY,
	OFFLINE,
	REQUEST,
	COUNT
}

global struct Friend
{
	string id
	string hardware
	string name = "Unknown"
	string presence = ""
	int    status = eFriendStatus.OFFLINE
	bool   ingame = false
	bool   inparty = false
	bool   away = false

	EadpPeopleData ornull eadpData
}

global struct FriendsData
{
	array<Friend> friends
	bool          isValid
}

global struct CodeRedemptionGrant
{
	string alias
	int qty
	int type
}

global struct UMAttribute
{
	string key
	string value
}

global struct UMItem
{
	string type
	string name
	string value
	array<UMAttribute> attributes
}

global struct UMAction
{
	string name
	string trackingId
	array<UMItem> items
}

global struct UMData
{
	string triggerId
	string triggerName
	array<UMAction> actions
}

#endif                
                                                                               
          
                                                                               

void function printl( var text )
{
	return print( text + "\n" )
}

void function CodeCallback_Precompile()
{
#if DEV
	                                                                       
	if ( hasscriptdocs() )
	{
		getroottable().originalConstTable <- clone getconsttable()
	}
#endif
}

