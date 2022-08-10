                                                                               
                        

const string CONTROL_MODE_MOVER_SCRIPTNAME = "control_mover"

global function Control_Init
global function Control_RegisterNetworking

#if SERVER
                                      
                                 

                                                 
                                               

                                              
                                        
                                            

                                                
                                           

                                      
                                               

                     
                                          
      

                                                           
                                                               

                                                    

                                     
                                   
                                         
                                                
                                          
                                   
#endif          

#if CLIENT
global function Control_SendRespawnChoiceToServer

global function ServerCallback_Control_ShowSpawnSelection
global function ServerCallback_Control_UpdateSpawnWaveTimerTime
global function ServerCallback_Control_UpdateSpawnWaveTimerVisibility
global function ServerCallback_Control_DeregisterModeButtonPressedCallbacks
global function ServerCallback_Control_SetDeathScreenCallbacks

global function UICallback_Control_UpdatePlayerInfo
global function UICallback_Control_OnMenuPreClosed
global function UICallback_Control_ReportMenu_OnClosed
global function UICallback_Control_ReportMenu_OnOpened
global function UICallback_Control_OnResolutionChanged
global function UICallback_Control_SpawnHeaderUpdated
global function UICallback_Control_SpawnButtonClicked
global function UICallback_Control_LaunchSpawnMenuProcessThread
global function UICallback_ControlMenu_MouseWheelUp
global function UICallback_ControlMenu_MouseWheelDown

global function Control_PingObjectiveFromObjID

global function ServerCallback_Control_ProcessImmediatelyOpenCharacterSelect
global function ServerCallback_Control_OnPlayerChoosingRespawnChoiceChanged
global function ServerCallback_Control_NoVehiclesAvailable
global function ServerCallback_Control_UpdatePlayerExpHUDWeaponEvo
global function ServerCallback_Control_ProcessObjectiveStateChange
global function ServerCallback_Control_DisplayMatchTimeLimitWarning
global function ServerCallback_Control_DisplayIconAtPosition
global function ServerCallback_Control_BountyActiveAlert
global function ServerCallback_Control_BountyClaimedAlert
global function ServerCallback_Control_AirdropNotification
global function ServerCallback_Control_UpdateExtraScoreBoardInfo
global function ServerCallback_Control_TransferCameraData
global function ServerCallback_PlayMatchEndMusic_Control
global function ServerCallback_PlayPodiumMusic
global function ServerCallback_Control_SetControlGeoValidForAirdropsOnClient
global function ServerCallback_Control_DisplayLockoutUnavailableWarning

                    
                                                                  
                          

global function Control_OpenCharacterSelect
global function Control_AnnouncementMessageWarning
global function ServerCallback_Control_DisplaySpawnAlertMessage
global function ServerCallback_Control_DisplayWaveSpawnBarStatusMessage

global function Control_InstanceObjectivePing
global function Control_UpdatePlayerExpHUD
global function	Control_ScoreboardSetup
global function ServerCallback_Control_UpdateObjectivePingText
global function ServerCallback_Control_UpdateObjectivePingCounts
global function ServerCallback_Control_UpdateLastPingedObjective
global function ServerCallback_Control_SetIsPlayerUsingLosingExpTiers
global function UICallback_Control_Loadouts_OnClosed
global function ServerCallback_Control_PlayAllWeaponEvoUpgradeFX
global function ServerCallback_Control_Play3PEXPLevelUpFX
global function ServerCallback_Control_PlayCaptureZoneEnterExitSFX
global function ServerCallback_Control_NewEXPLeader
global function ServerCallback_Control_EXPLeaderKilled

global function Control_ObjectiveScoreTracker_PushAnnouncement
global function Control_PlayEXPGainSFX

global function Control_GetVictoryConditionForFlagset
global function Control_DeathScreenUpdate
global function Control_PopulateSummaryDataStrings
global function Control_ScoreboardUpdateHeader
global function Control_IsPlayerInMapCameraView
global function Control_CloseCharacterSelectOnlyIfOpen
global function Control_GetObjectiveNameFromObjectiveID_Localized
#endif          


#if UI
global function Control_PopulateAboutText
#endif      

#if CLIENT || SERVER
global function Control_GetTeamScore
global function Control_GetScoreLimit
global function Control_GetPlayerExpTotal
global function Control_GetPlayerExpTier
global function Control_DidPlayerPingSameObjective
global function Control_GetPingCountForObjectiveForAlliance
global function Control_GetObjectiveStarterPings
global function Control_GetStarterPingFromTraceBlockerPing
global function Control_IsPlayerAbandoning
global function Control_GetDefaultWeaponTier
global function Control_GetAbandonPenaltyLength

global const float CONTROL_MESSAGE_DURATION = 5.0
const float CONTROL_MATCH_TIME_LIMIT_WARNING_TIME = 300.0                                                                       
const float LEGEND_DIALOGUE_DELAY_POST_ANNOUNCER_DIALOGUE_SHORT = 2.5
const float LEGEND_DIALOGUE_DELAY_POST_ANNOUNCER_DIALOGUE_LONG = 3.5
const float ANNOUNCER_DIALOGUE_DELAY = 1.5

global const string CONTROL_FUNC_BRUSH_GEO_NAME = "func_control_geo"
                                                                                                                                                             
const string CONTROL_EXPEVENT_ELIMINATION = "Control_Exp_Elimination"
const string CONTROL_EXPEVENT_ASSIST = "Control_Exp_Assist"
const string CONTROL_EXPEVENT_ATTACKERKILL = "Control_Exp_AttackerKill"
const string CONTROL_EXPEVENT_DEFENDERKILL = "Control_Exp_DefenderKill"
const string CONTROL_EXPEVENT_HIGHTIERKILL = "Control_Exp_HighTierKill"
const string CONTROL_EXPEVENT_REALLYHIGHTIERKILL = "Control_Exp_ReallyHighTierKill"
const string CONTROL_EXPEVENT_CONTESTING = "Control_Exp_ContestingObjective"
const string CONTROL_EXPEVENT_CAPTURING = "Control_Exp_CapturingObjective"
const string CONTROL_EXPEVENT_DEFENDING_ACTIVEPOINT = "Control_Exp_DefendingActiveObjective"
const string CONTROL_EXPEVENT_CAPTURED = "Control_Exp_CapturedObjective"
const string CONTROL_EXPEVENT_TEAM_CAPTURED = "Control_Exp_TeamCapturedObjective"
const string CONTROL_EXPEVENT_NEUTRALIZED = "Control_Exp_NeutralizedObjective"
const string CONTROL_EXPEVENT_TEAM_NEUTRALIZED = "Control_Exp_TeamNeutralizedObjective"
const string CONTROL_EXPEVENT_WITHSQUADBONUS = "Control_Exp_WithSquadBonus"
const string CONTROL_EXPEVENT_KILLEXPLEADER = "Control_Exp_KillEXPLeader"
const string CONTROL_EXPEVENT_DEFENDING = "Control_Exp_DefendingObjective"
const string CONTROL_EXPEVENT_BOUNTYCLAIMED = "Control_Exp_BountyClaimed"
const string CONTROL_EXPEVENT_LOCKOUTBROKEN = "Control_Exp_TeamCanceledLockout"
const string CONTROL_EXPEVENT_SPAWNONBASE = "Control_Exp_SpawnOnBase"
const string CONTROL_EXPEVENT_RESPAWN = "Control_Exp_Respawn"
                    
                                                                   
                                                                     
                          

const bool CONTROL_ARE_AIRDROPS_ALLOWED_ON_CONTROL_GEO = false                                                                                                                                                                                                 
const int CONTROL_VEHICLE_AIRDROP_BAD_PLACE_RADIUS = 300
const int CONTROL_SKYDIVE_LAUNCHER_AIRDROP_BAD_PLACE_RADIUS = 150
const int CONTROL_DEFAULT_MAX_PLAYERS = 18
#endif                    

#if DEV && SERVER
                           
                                        
                                          
                                             
                                             
                                                 
                                                    
                                                 
                                                     
                                         
                                                 
#endif                     

#if DEV
	const bool CONTROL_DETAILED_DEBUG = false                                                                                     
#endif       

global const CONTROL_DROPPOD_SCRIPTNAME = "control_droppod"
global const CONTROL_OBJECTIVE_SCRIPTNAME = "control_objective"

                     
global const CONTROL_INT_OBJ_TEAM_OWNER = 0
const FLOAT_CAP_PERC = 1
const FLOAT_BOUNTY_AMOUNT = 2
const FLOAT_AVG_BOUNDARY_RADIUS = 3
const INT_TEAM_CAPTURING = 3
global const INT_OBJECTIVE_ID = 4
const INT_TEAM0_PLAYERSONOBJ = 5
const INT_TEAM1_PLAYERSONOBJ = 6
const CONTROL_INT_OBJ_NEUTRAL_TEAM_OWNER = 7

const float CONTROL_INTRO_DELAY = 2.2

const string CONTROL_OBJECTIVE_A_NAME = "A"
const string CONTROL_OBJECTIVE_B_NAME = "B"
const string CONTROL_OBJECTIVE_C_NAME = "C"
const string CONTROL_OBJECTIVE_DEFAULT_NAME = "Default Objective Name"

const int CONTROL_OBJECTIVE_A_INDEX = 0
const int CONTROL_OBJECTIVE_B_INDEX = 1
const int CONTROL_OBJECTIVE_C_INDEX = 2
const int CONTROL_FOB_INDEX_ALLIANCE_A = 0
const int CONTROL_FOB_INDEX_ALLIANCE_B = 2

const INT_TEAM0_SCORE = 4
const INT_TEAM1_SCORE = 5

const asset CONTROL_OBJ_DIAMOND_EMPTY = $"rui/hud/gametype_icons/winter_express/team_diamond_empty"
const asset CONTROL_OBJ_DIAMOND_YOURS = $"rui/hud/gametype_icons/winter_express/team_a_diamond"
const asset CONTROL_OBJ_DIAMOND_ENEMY = $"rui/hud/gametype_icons/winter_express/team_b_diamond"
const asset TEAMMATE_DEATH_ICON = $"rui/rui_screens/icon_skull_postdeath"
const asset TEAMMATE_SPAWN_ICON = $"rui/hud/pve/extraction_dropship"
const asset AIRDROP_LANDED_ICON = $"rui/hud/ping/icon_ping_loot"
const float CONTROL_TEAMMATE_DEATH_ICON_LIFETIME = 12.0                                                                                                                          
const float TEAMMATE_SPAWN_ICON_DURATION = 10.0

const SPAWN_DIST = 1000
const float SPAWN_MIN_RADIUS = 128
const float SPAWN_MIN_RADIUS_NEAR_SQUAD = 712
const float SPAWN_MAX_RADIUS_BASE = 1028
const float SPAWN_MAX_RADIUS_NEAR_SQUAD = 1400
const SPAWN_MAX_TRY_COUNT = 60
const SPAWN_VIEW_DISTANCE_CHECK = 150

                       
const int INT_WAYPOINT_TYPE = 7
global const int CONTROL_WAYPOINT_BASE0_INDEX = 0
global const int CONTROL_WAYPOINT_BASE1_INDEX = 1
global const int CONTROL_WAYPOINT_PLAYER_INDEX = 2
global const int CONTROL_WAYPOINT_POINT_INDEX = 3
                    
                                               
                                                   
                                                
                                                    
                                                                                                                                 
                                                                                                                               
                                                                               
                                                          
                          

                                                                   
string WAYPOINT_CONTROL_PLAYERLOC = "waypoint_control_playerloc"
global const int CONTROL_PLAYERLOC_WAYPOINT_PLAYERENTITY_INDEX = 0

global const asset CONTROL_WAYPOINT_FLARE_ASSET = $"P_control_flare"

global const asset CONTROL_WAYPOINT_BASE_ICON = $"rui/hud/gametype_icons/survival/sur_hovertank_minimap"
global const asset CONTROL_WAYPOINT_PLAYER_ICON = $"rui/hud/gamestate/player_count_icon"

const string WAYPOINT_CONTROL_AIRDROP = "waypoint_control_airdrop"
const int AIRDROP_WAYPOINT_LOOTTIER_INT = 0
const asset HOVER_VEHICLE_SPAWN_BASE = $"mdl/olympus/olympus_vehicle_base.rmdl"
const asset FX_VEHICLE_SPAWN_POINT = $"P_veh_vh1_spawnpoint"
const int	VEHICLE_LIMIT = 6
const vector ANNOUNCEMENT_RED = <235, 65, 65>
const asset DEATH_SCREEN_RUI = $"ui/control_squad_summary_header_data.rpak"

global const vector CONTROL_OBJECTIVE_GREEN = <10, 144, 222>
global const vector CONTROL_OBJECTIVE_RED = <255, 95, 58>
const vector OBJECTIVE_WHITE = <255, 255, 255>

global const string CONTROL_SCORINGEVENT_CAPTURED = "Control_CapturedObjective"
global const string CONTROL_EXPEVENT_GUNRACK_PURCHASE = "Control_Exp_GunRackUse"
global const string CONTROL_EXPEVENT_EXPRESET = "Control_Exp_ExpReset"

const string CONTROL_PIN_VICTORYCONDITION_UNKNOWN = "unknown"
const string CONTROL_PIN_VICTORYCONDITION_SCORE = "score_limit_reached"
const string CONTROL_PIN_VICTORYCONDITION_LOCKOUT = "lockout"

global const int CONTROL_MAX_EXP_TIER = 4
global const int CONTROL_MAX_LOOT_TIER = 3

global const int CONTROL_TEAMSCORE_LOCKOUTBROKEN = 50

#if SERVER
                                     	                                   

                                                                         
                                                                
                                                        
                                                 
                                                      
                                                    
                                                    
                                                                                                                                                                                                                                            

                                  
                                             
                                        
                                         
                                                    
                                                       
                                                                                                                   

                    
                                                                                                                                                   
                          

                                                                     
                                                                         
                                                                           

                                                                     
                                                                                                     
                                                                                                                                       
                                                                                                                                
                                                                                                                                                                                                                                  

                                                       
                                                     
                                                     
                                                                        
                                                  
                                                         
                                                          
                                                                           
                                                         
                                                                   

                    
                                                       
                          

                                                                         
                                                                         
                                                                   

                                                                                    

                             
                                                             

                                                                                        
#endif          

#if SERVER || CLIENT
const int CONTROL_VICTORY_FLAGS_SCORE = ( 1 << 1 )
const int CONTROL_VICTORY_FLAGS_LOCKOUT = ( 1 << 2 )

                    
                                               
                          
#endif                    

#if CLIENT
                     
const FX_WEAPON_EVO_UPGRADE_FP = $"P_wpn_evo_upgrade_FP"
const FX_EXP_LEVELUP_3P = $"P_wpn_evo_upgrade"
const int CONTROL_OBJECTIVE_RUI_SORTING = 301                                           
const int CONTROL_TEAMMATE_ICON_SORTING = 302

      
             
const string CONTROL_SFX_WEAPON_EVO_LVL_1 = "Ctrl_Loadout_Upgrade_lvl1_1P"
const string CONTROL_SFX_WEAPON_EVO_LVL_2 = "Ctrl_Loadout_Upgrade_lvl2_1P"
const string CONTROL_SFX_WEAPON_EVO_LVL_3 = "Ctrl_Loadout_Upgrade_lvl3_1P"
const string CONTROL_SFX_WEAPON_EVO_LVL_4 = "Ctrl_Loadout_Upgrade_lvl4_1P"
           
const string CONTROL_SFX_EXP_GAIN = "Ctrl_XP_Gain_1p"
          
const string CONTROL_SFX_LOCKOUT_START = "Ctrl_LockOut_Begin_1p"
const string CONTROL_SFX_LOCKOUT_ABORT = "Ctrl_LockOut_Abort_1p"
               
const string CONTROL_SFX_CAPTURE_ZONE_ENTER = "Ctrl_Zone_Enter_1p"
const string CONTROL_SFX_CAPTURE_ZONE_EXIT = "Ctrl_Zone_EXIT_1p"
const string CONTROL_SFX_ZONE_CAPTURED_FRIENDLY = "Ctrl_Zone_Capture_1p"
const string CONTROL_SFX_ZONE_CAPTURED_ENEMY = "Ctrl_Zone_Capture_Enemy_1p"
const string CONTROL_SFX_ZONE_NEUTRALIZED = "Ctrl_Zone_Neutralized_1p"
                
const string CONTROL_SFX_CAPTURE_BONUS_ADDED = "Ctrl_CaptureBonus_Added_1p"
const string CONTROL_SFX_CAPTURE_BONUS_CLAIMED_FRIENDLY = "Ctrl_CaptureBonus_Claimed_1p"
const string CONTROL_SFX_CAPTURE_BONUS_CLAIMED_ENEMY = "Ctrl_CaptureBonus_Claimed_Enemy_1p"
            
const string CONTROL_SFX_GAME_END_VICTORY = "Ctrl_Victory_1p"
const string CONTROL_SFX_GAME_END_LOSS = "Ctrl_Loss_1p"
const string CONTROL_SFX_MATCH_TIME_LIMIT = "Ctrl_Match_End_Warning_1p"

                    
                                                                                                   
                                
                                         
                                                         
                          
#endif          

#if DEV
const float SPAWNPOINT_RADIUS = 20
const float SPAWNPOINT_HEIGHT = 128
const float SPAWNPOINT_DISPLAY_TIME = 60
#endif       

global const array<string> CONTROL_DISABLED_BATTLE_CHATTER_EVENTS = [
	"bc_anotherSquadAttackingUs",
	"bc_squadsLeft2 ",
	"bc_squadsLeft3 ",
	"bc_squadsLeftHalf",
	"bc_twoSquaddiesLeft",
	"bc_championEliminated",
	"bc_killLeaderNew",
	"bc_podLeaderLaunch",
	"bc_imJumpmaster",
	"bc_firstBlood",
	"bc_weTookFirstBlood",
]

global const array<int> CONTROL_DISABLED_COMMS_ACTIONS = [
                          
	eCommsAction.INVENTORY_NO_AMMO_BULLET,
	eCommsAction.INVENTORY_NO_AMMO_ARROWS,
	eCommsAction.INVENTORY_NO_AMMO_HIGHCAL,
	eCommsAction.INVENTORY_NO_AMMO_SHOTGUN,
	eCommsAction.INVENTORY_NO_AMMO_SNIPER,
	eCommsAction.INVENTORY_NO_AMMO_SPECIAL,
       
]

global enum eControlPlayerRespawnChoice
{
	SPAWN_AT_BASE,
	SPAWN_ON_SQUAD,
	SPAWN_ON_POINT,

                     
              
                           

	_count
}


global enum eControlPointObjectiveState
{
	CONTESTED,
	CONTROLLED,
}


global enum eControlSpawnFailureCode
{
	INVALID_CHOICE,
	CHOICE_IN_COMBAT,
}

#if CLIENT || UI
                                                                                       
global enum eControlSpawnWaypointUsage
{
	ENEMY_TEAM,
	NOT_USABLE,
	FRIENDLY_TEAM
}
#endif                

enum eControlSpawnAlertCode
{
	SPAWN_FAILED,
	SPAWN_CANCELLED,
	SPAWN_LOST_SPAWNPOINT,
	
                     
                
                           

	_count
}

enum eControlIconIndex
{
	DEATH_ICON,
	SPAWN_ICON,

	_count
}

                                                                                                                                                                    
enum eControlObjectivePingValue
{
	NONE,
	ATTACK_A,
	DEFEND_A,
	ATTACK_B,
	DEFEND_B,
	ATTACK_C,
	DEFEND_C
}

enum eControlVictoryCondition
{
	UNKNOWN,
	SCORE,
	LOCKOUT,

	_count
}

global struct ControlPointData
{
	entity trigger
	entity waypoint
	entity flagProp
	array<entity> spawns

	int id = -1
	string name
	string parentMapVariant
	vector location

	int currentObjectiveState = eControlPointObjectiveState.CONTROLLED
	array< entity > playersInControlPoint
	int lastCapturingTeam = ALLIANCE_NONE
	int controlPointOwner = ALLIANCE_NONE
	int neutralPointOwnership = ALLIANCE_NONE                                                                                 
	float controlPointPercent = 0

	table<int, float> timeOwnedByTeamForMatch
	table<entity, float> timeCapturingByPlayerForMatch
	table<entity, float> timeOnObjectiveByPlayerForMatch
	float fullControlConversionTime = FLT_MAX

	float lastBountyAward = FLT_MAX
	bool hasBountyBeenSet = false
}

struct ControlTeamSpawnData
{
	array<entity> spawnTriggers
	array<entity> playersInSpawnTriggers
	table<entity, array<entity> >	spawnTriggerToSpawns
}


struct ControlMapVariantData
{
	string mapID
	string nameString
	vector mapCenter
	float mapRadius

	array<ControlPointData> controlPoints
	table<entity, ControlPointData> triggerToControlPointMap

	table< int, ControlTeamSpawnData > teamSpawnData
	table<entity, ControlTeamSpawnData> triggerToSpawnDataMap
}


struct ControlOutstandingSpawnData
{
	table< entity, float >	outstandingDropshipSpawns
	array< vector >			outstandingAirdropSpawns
}


struct ControlAnnouncementData
{
	bool isInitialized = false

	entity 		wp
	bool 		shouldTerminateIfWPDies = false
	bool		shouldForcePushAnnouncement = false
	bool		shouldUseTimer

	string 		mainText
	string		subText
	float		displayLength

	float 		displayStartTime
	float		startTime
	float		eventLength

	vector 		overrideColor
}

struct ControlTeamData
{
	int teamScoreFromPoints = 0
	int teamScoreFromBonus = 0
	int teamScorePerSec = 0
}

const ControlTeamData ControlTeamDataDefaults = {
	teamScoreFromPoints =  0
	teamScoreFromBonus = 0
	teamScorePerSec = 0
}

struct {
	array<entity> spawnWaypoints                                                                                                                                                  
	bool isLockout = false
	bool isRampUp = false

	vector cameraLocation
	vector cameraLookDirection

	#if SERVER
		                                        
		                                        

		                           
		   				               

		                                                

		             				                
		             				                               

		                                 
		                                     
		                            
		                          
		                       
		                                    
		                             
		                                  
		                                     
		                                  
		                           
		                            

		                  
		                         
		                         
		                         
		                         

		                            
		                                            
		                                            
		                                                
		                                
		                                        

		                                       
		                                             
		                                        
		                                             
		                                                    
		                                       

		       
		                        
		                          
		                                            
		                                         
		                                  
		                             
		                                
		                                           

		      
                                            
		                                               
		                                                   
		                                              
		                             
		                               
		                

		            
		                       
		                       

		                  
		                                                  
		                                               

		          
		                                                   
		                          
		                                           
		                                                       

		       
		                                    
		                            
		                                  
		                                  

                      
                     
                             
                   
                        
                               
                   
                           
                        
                      
                            

		                                           
	#endif          

	#if CLIENT || SERVER
		array< entity > playersUsingLosingTeamExpTiersArray
		table< entity, float > playerToLastEXPEvoBadWeaponCheckTimeTable

		                 
		array<entity> objectiveStarterPings
		table< entity, int > objectiveToPingCountTableAllianceA
		table< entity, int > objectiveToPingCountTableAllianceB
	#endif                    

	#if CLIENT
		array<entity> waypointList
		array<entity> flagPropList

		table<entity, var> waypointToMinimapRui
		table<entity, var> waypointToFullmapRui
		table<entity, var> waypointToObjectiveFlare

		var onObjectiveRui
		table<int, var> scoreTrackerRui
		table<int, var> fullmapScoreTrackerRui

		float characterSelectClosedTime = 0
		bool shouldImmediatelyOpenCharacterSelectOnRespawn = false

		array<var> spawnButtons
		table< entity, var > waypointToSpawnButton
		table< var, entity > spawnButtonToWaypoint
		var			spawnHeader
		float		uiVMUpdateTime
		var			bountyTracker

		entity	lastLocalObjectivePing

		var announcementRui
		var fullMapAnnouncementRui
		array<ControlAnnouncementData> announcementData
		ControlAnnouncementData& currentAnnouncement

		entity cameraMover
		bool contextPushed
		bool isPlayerInMapCameraView = false
		bool isFirstWaveSpawn = true

		var respawnBlurRui
		var inGameMapRui
		bool tutorialShown = false
		table< entity, var > inGameMapPointsToRuis

		bool firstTimeRespawnShouldWait = true

		array< ControlTeamData > teamData = [ ControlTeamDataDefaults, ControlTeamDataDefaults ]
	#endif          

	#if DEV && SERVER
		                            
	#endif                 
} file


                                                       
                                                                                                                                                     
                                                                                      
global enum eControlStat {
	RATING = 4,
	OBJECTIVES_CAPTURED = 5,
}

                                                      
                                    
                                                                                                            

                                 




  
                                                                                                                                                                 
                                                                                                                                                                  
                                                                                                                                                                  
                                                                                                                                                                  
                                                                                                                                                                  
                                                                                                                                                                  


  



void function Control_Init()
{
	#if CLIENT || SERVER
		AddCallback_EntitiesDidLoad( EntitiesDidLoad )
	#endif                    

	#if DEV && SERVER
		                                                
	#endif                 

	if ( !Control_IsModeEnabled() )
		return

	                                                                                                  
	#if SERVER
		                                                       
		                                                                                                                                  
		                                                                                    
		                                                               
		                                                                 
		                                                                        
		                                                                         
		                                                                

		                                           
		                          
		 
			                                                                       

			                                  
			                                    
			                                                 
			                                      

			                                     
			                                              
			                                           
			                                                    

			                                
			                                    

			                                     
			                                                

			                                                           
			                                        

                     
				                                        
                           
		 

		                     
		                                                                                                                     
		                                                                                                   
		                                                                                                  
		                                                                                                                 
		                                                                                                                         
		                                                                                                                   
		                                                                                                          
		                                                                        

		                                                                                              
		                                                                                                                
		                                                                                                             
	#endif


	#if CLIENT || SERVER
		CausticTT_SetGasFunctionInvertedValue( true )

		PrecacheParticleSystem( $"P_wpn_evo_upgrade_FP" )
		PrecacheParticleSystem( $"P_wpn_evo_upgrade" )

                       
                                             
                                                 
        
	#endif                    

	#if SERVER
		                                             
		                                                        

                       
                                                              
        
		                             
		                                                                                               

		                                                         
		                                                                            
		                                                                              
		                                                                                    

		                                                                     
		                                                    
		                                                                            
		                                                                                                 
		                                                  
		                                                                               
		                                                        

		                                                          
		                                                    
		                                                 
		                                                           
		                                                                               
		                                                       

		                                        

		                                                                            
		                                                                       

		                                                                                 
		                                                       
		                                                                                       
		                                                                                       

		                                      
		 
			                                                                                     
			                                                                         
		 

		                                     
		                                                                                                               
		                                                                             
		                                                                                   
		                                                                                         
		                                                                           
		                                                                                  
		                                                                                 
		                                                                                  
		                                                                                   
		                                                                                   
		                                                                                 
		                                                                                  
		                                                                                  
		                                                                                  
		                                                                             
		                                                                        

		                                                        

		                                            
		                                                       
		                                                  
		                                                      
		                                            
		                                             

		                                                                   
		                                                               
		                                                               

                      
                                             
    
                                                                
                                                                        
                                           
                                            
                                                                                   
                                                                               
                                                                     
                                                       
    
                            

	#endif          

                       
		#if SERVER
			                                                 
			                                                                  
		#endif              
                                 

	#if CLIENT
		SetCustomScreenFadeAsset( $"ui/screen_fade_control.rpak" )
		ClApexScreens_SetCustomApexScreenBGAsset( $"rui/rui_screens/banner_c_control" )
		ClApexScreens_SetCustomLogoImage( $"rui/hud/gametype_icons/control/control_logo" )
		ClApexScreens_SetCustomLogoSize( <400, 400, 0> )

		PakHandle pakHandle = RequestPakFile( "control_mode" )
		PrecacheParticleSystem( CONTROL_WAYPOINT_FLARE_ASSET )
		PrecacheParticleSystem( FX_WEAPON_EVO_UPGRADE_FP )
		PrecacheParticleSystem( FX_EXP_LEVELUP_3P )

		Control_RegisterTimedEvents()

		SetDeathCamSpectateTimeOverride( Control_GetMinDeathScreenTime )

		AddCreateCallback( PLAYER_WAYPOINT_CLASSNAME, Control_WaypointCreated_Spawn )
		SURVIVAL_SetGameStateAssetOverrideCallback( ControlOverrideGameState )
		Waypoints_RegisterCustomType( WAYPOINT_CONTROL_AIRDROP, InstanceWPControlAirdrop )
		Waypoints_RegisterCustomType( WAYPOINT_CONTROL_PLAYERLOC, InstanceWPControlPlayerLoc )

		if ( Control_ShouldShow2DMapIcons() )
		{
			RegisterMinimapPackages()
		}

		AddCallback_GameStateEnter( eGameState.Playing, Control_OnGamestateEnterPlaying_Client )
		AddCallback_GameStateEnter( eGameState.Prematch, Control_OnGamestateEnterPreMatch_Client )
		AddCallback_GameStateEnter( eGameState.WinnerDetermined, Control_OnGamestateEnterWinnerDetermined_Client )
		AddCallback_GameStateEnter( eGameState.Resolution, Control_OnGamestateEnterResolution_Client )
		AddCallback_OnCharacterSelectMenuClosed( Control_OnCharacterSelectMenuClosed )
		AddCallback_OnFindFullMapAimEntity( Control_GetObjectiveUnderAim, Control_PingObjectiveUnderAim )

		                                        
		Fullmap_AddCallback_OnFullmapCreated( Control_OnFullmapCreated )
		AddCallback_OnScoreboardCreated( Control_OnScoreboardCreated )
		AddCreateCallback( "player", Control_OnPlayerCreated )
		AddCallback_OnPlayerChangedTeam( Control_OnPlayerTeamChanged )
		AddCallback_PlayerClassChanged( Control_OnPlayerClassChanged )
		AddOnSpectatorTargetChangedCallback( Control_OnSpectatorTargetChanged )
		AddCallback_OnViewPlayerChanged( Control_OnViewPlayerChanged )
		AddCallback_OnPlayerDisconnected( Control_OnPlayerDisconnected )

		AddCreateCallback( "prop_script", OnVehicleBaseSpawned )
		AddCreateCallback( PLAYER_WAYPOINT_CLASSNAME, Control_OnPlayerWaypointCreated )
		AddDestroyCallback( PLAYER_WAYPOINT_CLASSNAME, Control_OnPlayerWaypointDestroyed )

		CircleAnnouncementsEnable( false )
		CircleBannerAnnouncementsEnable( false )
		RegisterDisabledBattleChatterEvents( CONTROL_DISABLED_BATTLE_CHATTER_EVENTS )
		RunUIScript( "Control_Respawn_SetKillerInfo" )                         
		SetMapFeatureItem( 400, "#CONTROL_EMPTY_OBJ", "#CONTROL_EMPTY_OBJ_DESC", CONTROL_OBJ_DIAMOND_EMPTY )
		SetMapFeatureItem( 500, "#CONTROL_YOUR_OBJ", "#CONTROL_YOUR_OBJ_DESC", CONTROL_OBJ_DIAMOND_YOURS )
		SetMapFeatureItem( 300, "#CONTROL_ENEMY_OBJ", "#CONTROL_ENEMY_OBJ_DESC", CONTROL_OBJ_DIAMOND_ENEMY )

		RegisterSignal( "Control_PlayerHasChosenRespawn" )
		RegisterSignal( "Control_PlayerStartingRespawnSelection" )
		RegisterSignal( "Control_NewCameraDataReceived" )
		RegisterSignal( "Control_PlayerHideScoreboardMap" )
		RegisterSignal( "OnValidSpawnPointThreadStarted" )
		RegisterSignal( "OnSpawnMenuClosed" )
		RegisterSignal( "Control_OnAnnouncementThreadStarted" )

                      
                                             
                                                                             
                            
	#endif          


	#if DEV && SERVER
		                                                 
	#endif                 

	#if DEV
		if ( CONTROL_DETAILED_DEBUG )
		{
			printf( "CONTROL: CONTROL_DETAILED_DEBUG is set to true, debug prints that fire very frequently are enabled" )
		}
		else
		{
			printf( "CONTROL: CONTROL_DETAILED_DEBUG is set to false, to enable debug prints that fire frequently set CONTROL_DETAILED_DEBUG to true" )
		}
	#endif       
}

#if CLIENT || SERVER
void function EntitiesDidLoad()
{
	#if SERVER
		                                                                  
		                      
	#endif         

	#if CLIENT
		if( Control_IsModeEnabled() )
		{
			                                                                     
			array<entity> jumpTowerFlags = GetEntArrayByScriptName( "jump_tower_flag" )
			foreach( flag in jumpTowerFlags )
				flag.Destroy()
		}
	#endif         
}
#endif                    


void function Control_RegisterNetworking()
{
	if ( !Control_IsModeEnabled() )
		return

                      
                      
                                                           
                            
       

	RegisterNetworkedVariable( "Control_WaveStartTime", SNDC_GLOBAL, SNVT_TIME, 0.0 )
	RegisterNetworkedVariable( "Control_WaveSpawnTime", SNDC_GLOBAL, SNVT_TIME, 0.0 )
	RegisterNetworkedVariable( "Control_IsPlayerOnSpawnSelectScreen", SNDC_PLAYER_EXCLUSIVE, SNVT_BOOL, false )
	RegisterNetworkedVariable( "Control_IsPlayerExemptFromWaveSpawn", SNDC_PLAYER_EXCLUSIVE, SNVT_BOOL, false )
	RegisterNetworkedVariable( "Control_ObjectiveIndex", SNDC_PLAYER_EXCLUSIVE, SNVT_INT, -1)
	RegisterNetworkedVariable( "deaths", SNDC_PLAYER_GLOBAL, SNVT_INT, 0 )
	RegisterNetworkedVariable( "control_personal_score", SNDC_PLAYER_GLOBAL, SNVT_BIG_INT, 0 )
	RegisterNetworkedVariable( "control_current_exp_total", SNDC_PLAYER_EXCLUSIVE, SNVT_BIG_INT, 0 )
	RegisterNetworkedVariable( "control_current_exp_tier", SNDC_PLAYER_EXCLUSIVE, SNVT_INT, 0 )
	RegisterNetworkedVariable( "Control_IsMatchFair", SNDC_GLOBAL, SNVT_BOOL, true )

	Remote_RegisterServerFunction( "ClientCallback_Control_ProcessRespawnChoice", "int", 0, eControlPlayerRespawnChoice._count, "entity" )
	Remote_RegisterServerFunction( "ClientCallback_Control_PlayerRespawningFromMenu" )

	Remote_RegisterClientFunction( "ServerCallback_Control_ShowSpawnSelection" )
	Remote_RegisterClientFunction( "ServerCallback_Control_ProcessImmediatelyOpenCharacterSelect" )
	Remote_RegisterClientFunction( "ServerCallback_Control_UpdateSpawnWaveTimerTime" )
	Remote_RegisterClientFunction( "ServerCallback_Control_UpdateSpawnWaveTimerVisibility", "bool" )
	Remote_RegisterClientFunction( "ServerCallback_Control_DeregisterModeButtonPressedCallbacks" )
	Remote_RegisterClientFunction( "ServerCallback_Control_SetDeathScreenCallbacks" )
	Remote_RegisterClientFunction( "ServerCallback_Control_NoVehiclesAvailable" )
	Remote_RegisterClientFunction( "ServerCallback_Control_UpdatePlayerExpHUDWeaponEvo", "bool", "bool" )
	Remote_RegisterClientFunction( "ServerCallback_Control_ProcessObjectiveStateChange", "entity", "int", -1, 2, "int", ALLIANCE_NONE, 2, "int", ALLIANCE_NONE, 2, "int", ALLIANCE_NONE, 2, "int",ALLIANCE_NONE, 2, "bool" )
	Remote_RegisterClientFunction( "ServerCallback_Control_DisplayMatchTimeLimitWarning", "bool" )
	Remote_RegisterClientFunction( "ServerCallback_Control_DisplayIconAtPosition", "vector", -1.0, 1.0, 32, "int", 0, eControlIconIndex._count, "int", INT_MIN, INT_MAX, "float", 0.0, FLT_MAX, 32 )
	Remote_RegisterClientFunction( "ServerCallback_Control_BountyActiveAlert", "entity" )
	Remote_RegisterClientFunction( "ServerCallback_Control_BountyClaimedAlert", "entity", "int", INT_MIN, INT_MAX, "int",ALLIANCE_NONE, 2  )
	Remote_RegisterClientFunction( "ServerCallback_Control_AirdropNotification", "bool" )
	Remote_RegisterClientFunction( "ServerCallback_Control_UpdateExtraScoreBoardInfo", "int", 0, 2, "int", INT_MIN, INT_MAX, "int", INT_MIN, INT_MAX )
	Remote_RegisterClientFunction( "ServerCallback_Control_UpdateObjectivePingText", "entity", "int", INT_MIN, INT_MAX, "int", INT_MIN, INT_MAX, "bool" )
	Remote_RegisterClientFunction( "ServerCallback_Control_UpdateObjectivePingCounts", "entity", "int", ALLIANCE_A, ALLIANCE_B + 1, "int", 0, INT_MAX )
	Remote_RegisterClientFunction( "ServerCallback_Control_UpdateLastPingedObjective", "entity", "entity", "entity", "int", INT_MIN, INT_MAX, "bool" )
	Remote_RegisterClientFunction( "ServerCallback_Control_SetIsPlayerUsingLosingExpTiers", "bool" )
	Remote_RegisterClientFunction( "ServerCallback_Control_DisplaySpawnAlertMessage", "int", 0, eControlSpawnAlertCode._count )
	Remote_RegisterClientFunction( "ServerCallback_Control_DisplayWaveSpawnBarStatusMessage", "bool", "int", 0, eControlPlayerRespawnChoice._count )
	Remote_RegisterClientFunction( "ServerCallback_Control_TransferCameraData", "vector", -FLT_MAX, FLT_MAX, 32, "vector", -FLT_MAX, FLT_MAX, 32 )
	Remote_RegisterClientFunction( "ServerCallback_Control_SetControlGeoValidForAirdropsOnClient", "entity" )
	Remote_RegisterClientFunction( "ServerCallback_Control_PlayAllWeaponEvoUpgradeFX", "entity", "int", 0, CONTROL_MAX_EXP_TIER + 1, "bool" )
	Remote_RegisterClientFunction( "ServerCallback_Control_Play3PEXPLevelUpFX", "entity", "int", 0, CONTROL_MAX_EXP_TIER + 1 )
	Remote_RegisterClientFunction( "ServerCallback_Control_PlayCaptureZoneEnterExitSFX", "bool" )
	Remote_RegisterClientFunction( "ServerCallback_Control_NewEXPLeader", "entity", "int", INT_MIN, INT_MAX )
	Remote_RegisterClientFunction( "ServerCallback_Control_EXPLeaderKilled", "entity", "entity" )
	Remote_RegisterClientFunction( "ServerCallback_PlayMatchEndMusic_Control", "int", 0, eControlVictoryCondition._count )
	Remote_RegisterClientFunction( "ServerCallback_PlayPodiumMusic" )
	Remote_RegisterClientFunction( "ServerCallback_Control_DisplayLockoutUnavailableWarning" )

                     
                                                                                 
                                                                                       
                           

	Remote_RegisterUIFunction( "Control_RemoveAllButtonSpawnIcons" )
	Remote_RegisterUIFunction( "ControlSpawnMenu_SetLoadoutAndLegendSelectMenuIsEnabled", "bool" )

	if ( IsUsingLoadoutSelectionSystem() )
	{
		Remote_RegisterUIFunction( "ControlSpawnMenu_UpdatePlayerLoadout" )
		Remote_RegisterUIFunction( "UI_OpenControlSpawnMenu", "bool" )
	}

	#if CLIENT
		RegisterNetworkedVariableChangeCallback_bool( "Control_IsPlayerOnSpawnSelectScreen", ServerCallback_Control_OnPlayerChoosingRespawnChoiceChanged )
		RegisterNetworkedVariableChangeCallback_int( "control_current_exp_total", Control_UpdatePlayerExpHUD )
	#endif          
}

                                                               
int function Control_GetScoreLimit()
{
	return GetCurrentPlaylistVarInt( "control_score_limit", 250 )
}

bool function Control_ShouldShow2DMapIcons()
{
	                                                                                                          
	return !( GetCurrentPlaylistVarBool( "disable_minimap", false ) ) && !Control_IsModeEnabled()
}

float function Control_GetDefaultExpPercentToAwardForPointSpawn()
{
	return GetCurrentPlaylistVarFloat( "exp_percent_award_spawn_on_point", -1 )
}

float function Control_GetDefaultExpPercentToAwardForBaseSpawn()
{
	return GetCurrentPlaylistVarFloat( "exp_percent_award_spawn_on_base", 1 )
}

bool function Control_ShouldUseRecoveredExpPercentIfGreaterThanDefaults()
{
	return GetCurrentPlaylistVarBool( "exp_recover_exp_percent_if_greater_than_default", true )
}

                    
                                                 
 
                                                                     
 
                          

#if DEV && SERVER
                                    
 
	                                             

	                                                     
	                                                             
	                                                

	                           
 
#endif                 

#if SERVER
                                                
 
	                                                                       
 
#endif          

#if SERVER
                                         
 
	                                                                  
 
#endif          

#if SERVER
                                     
 
	                                                              
 
#endif          

#if SERVER
                                                                                                          
                                                        
 
	                                                                                  
 
#endif          

#if SERVER
                                              
 
	                                                                   
 
#endif          

#if SERVER
                                             
 
	                                                                          
 
#endif          

#if SERVER
                                                         
 
	                                                                    
 
#endif          

#if SERVER
                                                        
 
	                                                                           
 
#endif          

#if SERVER
                                                   
 
	                                                                      
 
#endif          

#if SERVER
                                                      
 
	                                                                                 
 
#endif          

#if SERVER
                                               
 
	                                                                              
		                                 

	                                                
 
#endif          

#if SERVER
                                                                
 
	                                                                                          
 
#endif          

#if SERVER
                                                                                      
                                          
 
	                                                                                                              

	       
		                                                                                                                             
	             

	                     
 
#endif          

#if SERVER
                                                                                        
                                      
 
	                                                                 
 
#endif          

#if SERVER
                                                  
 
	                                                                         
 
#endif          

#if SERVER
                                                
 
	                                                                                                      
 
#endif          

#if SERVER
                                                    
 
	                                                                                                                
 
#endif          

#if SERVER
                                                   
 
	                                                                                                            
 
#endif          


                                                               
#if CLIENT || SERVER
bool function Control_GetAreAirdropsEnabled()
{
	return GetCurrentPlaylistVarBool( "control_enable_airdrops", true )
}
#endif                    

#if CLIENT || SERVER
bool function Control_GetAreBonusCaptureTimedEventsEnabled()
{
	return GetCurrentPlaylistVarBool( "control_enable_bonus_capture_events", true )
}
#endif                    

#if CLIENT || SERVER
bool function Control_GetIsLockoutEnabled()
{
	return GetCurrentPlaylistVarBool( "control_enable_lockout", true )
}
#endif                    

#if CLIENT || SERVER
bool function Control_GetIsWeaponEvoEnabled()
{
	return GetCurrentPlaylistVarBool( "control_has_evolving_equipment", false )
}
#endif                    

#if CLIENT || SERVER
                                                                                          
bool function Control_GetIsMinHeldObjectivesOnlyForWinningTeam()
{
	return GetCurrentPlaylistVarBool( "control_is_min_objectives_rule_winners_only", false )
}
#endif                    

#if CLIENT || SERVER
int function Control_GetDefaultEquipmentTier()
{
	return GetCurrentPlaylistVarInt( "control_default_equipment_tier", 1 )
}
#endif                    

#if CLIENT || SERVER
int function Control_GetDefaultWeaponTier()
{
	return GetCurrentPlaylistVarInt( "control_default_weapon_tier", 1 )
}
#endif                    

#if CLIENT || SERVER
                                                                                      
                                                                                 
int function Control_GetMinHeldObjectivesToGenerateScore()
{
	int minHeldObjectives = GetCurrentPlaylistVarInt( "control_min_held_zones_to_score", 0 )

	#if SERVER
		                                                              
		                                                                                                                                                 
	#endif          

	return minHeldObjectives
}
#endif                    

#if CLIENT || SERVER
                                                                                                                                                
int function Control_GetPointDiffForCatchupMechanics()
{
	return GetCurrentPlaylistVarInt( "point_difference_to_be_losingteam", 0 )
}
#endif                    

#if CLIENT || SERVER
float function Control_GetMinDeathScreenTime()
{
	return GetCurrentPlaylistVarFloat( "control_min_deathscreen_time", 4.0 )
}
#endif                    

#if CLIENT || SERVER
float function Control_GetMaxDeathScreenTime()
{
	return GetCurrentPlaylistVarFloat( "control_max_deathscreen_time", 20.0 )
}
#endif                    

                    
                    
                                   
                                            
 
                                                                                                                  
                                                                                                                                                                                      
                                                      
                                                                                                                                    

                   
 
                          
                          

                    
                    
                                           
 
                                                                                                         
 
                          
                          

#if UI
                                                                           
array< aboutGamemodeDetailsTab > function Control_PopulateAboutText()
{
	array< aboutGamemodeDetailsTab > tabs
	string playlistUiRules = GetPlaylist_UIRules()

	if ( !GameModeHasRules() || playlistUiRules != GAMEMODE_CONTROL )
		return tabs

	aboutGamemodeDetailsTab tab1
	aboutGamemodeDetailsTab tab2
	aboutGamemodeDetailsTab tab3
	aboutGamemodeDetailsTab tab4

	array< aboutGamemodeDetailsData > tab1Rules
	array< aboutGamemodeDetailsData > tab2Rules
	array< aboutGamemodeDetailsData > tab3Rules
	array< aboutGamemodeDetailsData > tab4Rules

	int withSquadBonusEXPVal = GetCurrentPlaylistVarInt( "exp_value_playing_with_squad", 5 )

	                                              
	tab1.tabName = "#CONTROL_RULES_OVERVIEW_TAB_NAME"
	tab1Rules.append( UI_GameModeRulesDialog_BuildDetailsData( "#CONTROL_RULES_CAPTURING_HEADER", "#CONTROL_RULES_CAPTURING_BODY", $"rui/hud/gametype_icons/control/about_capture" ) )
	tab1Rules.append( UI_GameModeRulesDialog_BuildDetailsData( "#CONTROL_RULES_RATINGS_HEADER", "#CONTROL_RULES_RATINGS_BODY", $"rui/hud/gametype_icons/control/about_ratings" ) )
	tab1Rules.append( UI_GameModeRulesDialog_BuildDetailsData( "#CONTROL_RULES_TIMEDEVENT_HEADER", "#CONTROL_RULES_TIMEDEVENT_BODY", $"rui/hud/gametype_icons/control/about_events" ) )

	                                          
	tab2.tabName = "#CONTROL_RULES_RATINGS_TAB_NAME"
	string killRatingsBody = Localize( "#CONTROL_RULES_KILL_RATINGS_BODY", string( GetCurrentPlaylistVarInt( "exp_value_kill", 20 ) ), string( GetCurrentPlaylistVarInt( "exp_value_kill_assist", 20 ) ), string( withSquadBonusEXPVal ) )
	string specialKillRatingsBody = Localize( "#CONTROL_RULES_SPECIAL_KILL_RATINGS_BODY", string( GetCurrentPlaylistVarInt( "exp_value_kill_attacker", 15 ) ), string( GetCurrentPlaylistVarInt( "exp_value_kill_defender", 15 ) ), string( GetCurrentPlaylistVarInt( "exp_value_kill_high_tier", 15 ) ), string( GetCurrentPlaylistVarInt( "exp_value_kill_reallyhigh_tier", 25 ) ), string( GetCurrentPlaylistVarInt( "exp_value_kill_expleader", 50 ) ) )
	string objectiveRatingsBody = Localize( "#CONTROL_RULES_OBJECTIVE_RATINGS_BODY", string( GetCurrentPlaylistVarInt( "exp_value_capturing", 5 ) ), string( GetCurrentPlaylistVarInt( "exp_value_contesting", 10 ) ), string( GetCurrentPlaylistVarInt( "exp_value_defending_active", 10 ) ), string( GetCurrentPlaylistVarInt( "exp_value_neutralize", 50 ) ), string( GetCurrentPlaylistVarInt( "exp_value_capture", 50 ) ), string( withSquadBonusEXPVal ) )
	string teamRatingsBody = Localize( "#CONTROL_RULES_TEAM_RATINGS_BODY", string( GetCurrentPlaylistVarInt( "exp_value_team_neutralize", 25 ) ), string( GetCurrentPlaylistVarInt( "exp_value_team_capture", 25 ) ), string( CONTROL_TEAMSCORE_LOCKOUTBROKEN ) )
	tab2Rules.append( UI_GameModeRulesDialog_BuildDetailsData( "#CONTROL_RULES_KILL_RATINGS_HEADER", killRatingsBody, $"rui/hud/gametype_icons/control/about_kill_ratings" ) )
	tab2Rules.append( UI_GameModeRulesDialog_BuildDetailsData( "#CONTROL_RULES_SPECIAL_KILL_RATINGS_HEADER", specialKillRatingsBody, $"rui/hud/gametype_icons/control/about_special_kill_ratings" ) )
	tab2Rules.append( UI_GameModeRulesDialog_BuildDetailsData( "#CONTROL_RULES_OBJECTIVE_RATINGS_HEADER", objectiveRatingsBody, $"rui/hud/gametype_icons/control/about_objective_ratings" ) )
	tab2Rules.append( UI_GameModeRulesDialog_BuildDetailsData( "#CONTROL_RULES_TEAM_RATINGS_HEADER", teamRatingsBody, $"rui/hud/gametype_icons/control/about_team_ratings" ) )

	                                   
	tab3.tabName = "#CONTROL_RULES_SPAWNING_TAB_NAME"
	string baseSpawnBody = Localize( "#CONTROL_RULES_BASE_SPAWN_BODY", string( Control_GetDefaultExpPercentToAwardForBaseSpawn() * 100 ) )
	tab3Rules.append( UI_GameModeRulesDialog_BuildDetailsData( "#CONTROL_RULES_BASE_SPAWN_HEADER", baseSpawnBody, $"rui/hud/gametype_icons/control/about_base_spawns" ) )
	tab3Rules.append( UI_GameModeRulesDialog_BuildDetailsData( "#CONTROL_RULES_FORWARDBASE_SPAWN_HEADER", "#CONTROL_RULES_FORWARDBASE_SPAWN_BODY", $"rui/hud/gametype_icons/control/about_forwardbase_spawns" ) )
	tab3Rules.append( UI_GameModeRulesDialog_BuildDetailsData( "#CONTROL_RULES_CENTRAL_SPAWN_HEADER", "#CONTROL_RULES_CENTRAL_SPAWN_BODY", $"rui/hud/gametype_icons/control/about_central_spawns" ) )

	tab1.rules = tab1Rules
	tab2.rules = tab2Rules
	tab3.rules = tab3Rules
	tab4.rules = tab4Rules

	tabs.append( tab1 )
	tabs.append( tab2 )
	tabs.append( tab3 )
	tabs.append( tab4 )

	return tabs
}
#endif      

                                                                                                                          
  
                                                                                                                                                          
                                                                                                                                                           
                                                                                                                                                           
                                                                                                                                                           
                                                                                                                                                           
                                                                                                                                                           

                                                                                                                                                                   
#if SERVER
                                                        
 
	                          
	                                    
	                                     
		                                             
	                                 
		                                      
	                                       
		                                                 

	       
		                                                                                                        
	             

	                               
 
#endif          

#if SERVER
                                                                  
 
	                                 
	                                                   
	                               
	 
		                                                                                                                      
		      
	 

	                                                                     
		                                                                                                                                                    

	                                                                

	                     
	                        
	                                     
	                                            

	                                                      
	                            
	 
		                                                   
			                   
	 

	       
		                                                                                                                    
	             

	                                 
 
#endif          

#if SERVER
                                                                  
 
	                                 
	                                                   
	                               
	 
		                                                                                                                             
		      
	 

	                                                                     
		                                                                                                                                                          

	                                                                

	       
		                                                                                                                        
	             

	                                       
 
#endif          

#if SERVER
                                                         
 
	                                                                        
	                                        
	                        
		      

	                                              
	                                                                 
	 
		                                             
		                         
		                                  
	 
 
#endif          

#if SERVER
                                                                           
 
	                                 
	                                                        
	                               
	 
		                                                                                                                                               
		      
	 

	                                                                     
		                                                                                                                                                               

	                                                                

	       
		                                                                                                                                  
	             

	                                                    
 
#endif          

#if SERVER
                                                                
 
	                                                                       
	                                                              
	 
		       
			                                             
		             

		                                       
	 
 
#endif          

#if SERVER
                                             
 
	                                                                
	                                   
	 
		                                                   
		 
			                                         

			                             
			 
  				                                                   

				                               
				 
					                                                                                                                                           
					                   
					      
				 

				                                                                    
				 
					                                                                                                                                                     

					                                                                

					       
						                                                                                                                        
					             

					                   
				   

				                                     
				                       

				                                                    
				                                                  
				 
					                                   
					                                               
				 
			 
			    
			 
				       
					                                                                      
				             

				                   
			 
		 
	 
 
#endif          

#if SERVER
                                                                                                                                                                           
                                                                                  
 
	                         
		      

	                                                                
	                                    
	 
		                                                     
		 
			                                         

			                              
			 
				                                                                  
				                                                  
				 
					                                               
					                                                                                                                  
				 
			 
		 
	 
 
#endif          

#if SERVER
                                                               
 
	                                 
	                                              
	                               
	 
		                                                                                                                     
		      
	 

	                                                                     
		                                                                                                                                                   

	                                                                

	       
		                                                                                                                      
	             

	                                                                         
	                                        
 
#endif          

#if SERVER
                                                            
 
	                                 
	                                             
	                              
	 
		                                                                                                       
		      
	 

	                                                                        
		                                                                                                                                                   

	                           
	                     

	                             
 
#endif          

#if SERVER
                                                                        
 
	                                         

	                                                                  
		      

	                          
	 
		                                                                
			                                                                                                                                                    

		                                           
	 
	                               
	 
		                                                             
	 

	                                                         
	                      
	 
		                                                                                                       
		                                                                                                                  
	 
 
#endif          

#if SERVER
                                    
                                                           
 
	                              
	 
		              
	 
 
#endif          

#if SERVER
                                                                  
 
	                                 
	                                              
	                               
	 
		                                                                                                                       
		      
	 

	                                                                     
		                                                                                                                                                      

	                                                                  

	       
		                                                                                                                         
	             

	                                   
 
#endif          

#if SERVER
                                                                       
 
	                                                                                                                                                                                                                                        
	 
		                                 
		                                              
		                               
		 
			                                                                                                                                   
			      
		 

		                                                                     
			                                                                                                                                                            

		                                                                  

		       
			                                                                                                                               
		             

		                                        
	 
	    
	 
		              
	 
 
#endif          

#if SERVER
                                          
 
	                         
 
#endif          

#if SERVER
                                
 
	                                                                              
	             
	                                 
	                                                                                       

	                                                    
	                              
	 
		                                                
		 
			                                                     
			 
				         
				                           
				     
			 
		 
	 

	                                                                                           
	                            
	 
		                                                                                                                                         
		                                                
		 
			                                                              
		 

		                                  
		                                                  
	 

	                                                

	       
		                                                                                                                                                                                           
	             

	                                
	                                   
	                           
	                                         
	                                      
	                              
	                                   

	                      
	                        
	                           

	                                                                                 
	                            

	                             

	                                              

	                              

	                          
	                             
	                                                        
		                                       
	                                                            
		                                                 

	                                                         
	                                  
	                                   
	 
		                                                                                      
			                                      
	 

	                                                             
	                                   
	                                                                  

	                                               
	                                                
	                                  
	                                                                                                    
	                                                                          
	                                                    

	                                    
	                                              

	                                          
		                                                                                                                                   
 
#endif          

#if SERVER
                                                 
 
	                                                            
	                                               
	 
		                                              
		                                                             
		 
			                                                    
		 
		    
		 
			                          
			                                                                 
			                                     
			 
				                                       
					                                         
				               
			 

			                       
			                                   
		 
	 
	                             

	                                             
	 
		                                        
		                                                            
		                                                            
		                                                              
		                                                                 
		                                                                                    
	 
 
#endif          

#if SERVER
                                              
 
	                                                  
	                                                  
	 
		                                         
		                                                   
		                                                                

		                                                           
		 
			                                       
		 
	 
	                              
 
#endif          

#if SERVER
                                         
 
	                                                
	                                                
	 
		                                  
		                                              
		                                                                

		                                                           
		 
			                                  
			              
		 
	 
	                            
 
#endif          

#if SERVER
                                          
 
	                                      
	 
		                                           
		                                                      
		                                                                

		                                                           
			                                                 

		                                                                       
		 
			                   
			                                                      
			 
				                                                     
				 
					                        
					     
				 
			 

			                       
			                                                                                                      
			 
				                                                                                                             
			 
			    
			 
				                    
				                      
				                                                                                                       
			 
		 
		                                                                         
		 
			                             
			                                                                                    
		 
	 
 
#endif          

#if SERVER
                                                    
 
	                                                           
	                                                           
	 
		                                             
		                                              
		                                                                

		                                                           
		 
			                                  
			              
		 
	 
	                                       
 
#endif          

#if SERVER
                                                 
 
	                                                        
	                                                        
	 
		                                          
		                                              
		                                                                

		                                                           
		 
			                                  
			              
		 
	 
	                                    
 
#endif          

#if SERVER
                                                              
                                            
 
	                                                       
	                                                   
	 
		                                        
		                                                 
		                                                                  

		                                                           
		 
			                                         
			                 
		 
	 
	                                   
 
#endif          

#if SERVER
                                                                    
                                                 
 
	                                                                 
	                                                        
	 
		                                                  
		                                                      
		                                                                  

		                                                           
		 
			                                                   
			                      
		 
	 
	                                             
 
#endif          

#if SERVER
                                         
 
	                                                                                 
	                                                                    

	                                 
	                                                                  
	 
		                                                                
		                           
		 
			                         
		 
		    
		 
			                                         
			                                                       
			                                    
			                                       
			 
				                                                    
				                                                               
				                                            
				 
					                  
					     
				 
			 
			                                         
		 
	 
	                                                

	                  
	                                                        
	 
		                              

		                                  
		                                      
		                                                    
		                                    
		                                        
		                                       
		                                   
		                                       
		                                     
		                                     

		                                                           
		                                                          
		                                    
		                

		                     
		                                                                  

		                                                                          

		            
		                                                                 
	 
 
#endif          

#if SERVER
                                      
 
	                                  
	                                  

	                                           
	 
		       
			                                                                      
		             

		                     
		          
		          
		                

		                                        
			                                      
		                                        
			                                      
		                                 
			                                     

		                                                                                                
		                                                                
		                                                               
		                                         

		                                 
			                                                  
		                                      
			                                                  
		    
			                                                                                                                                                                                

		                                   
	 

	                                               
	                                          
	                                          

	                                                    

	                                                       
		                                                                              
	                                                       
		                                                                              
 
#endif          

#if SERVER
                                        
 
	                       
 
#endif          

#if SERVER
                                          
 
	                          
		      

	                                                
	                                         
	                                     
	                                 

	                                                        
	 
		                              
		                                                                                         

		                          
		                              
		                                
		 
			                    
			                          
		 

		                                       
		                                                                       
		                                      
		                            
		                         
		                                           

		                   

		                   
		                                     
		 
			                                                                                        
			                                                                                 
			                                      
			                                   
			                                          
			                                          
			                                                      
			                                                
			                               
		 

		                                               

		                                              
			                                                                                         
		    
			                                                      
		                                                                                                                           
		                                                                            
		                                                                                   
		                                                                                                                                                            
		                                                                                                                                                            
		                                          
	 

	                                

	                                                              
	                                  
	                                                 
	                                   

	                                      

	                          

	                                    
	                               
 
#endif          

#if SERVER
                                                                
                                                    
 
	                                               

	       
		                                                                           
	             

	                              

	            
	               
	 
		                                   
		       
			                                                            
		             

		                               
	 
	 
	                        
	
	                                                                                                   
	                                                                 
	                                               

	                                                                                                                                                        
	                                     
	                                                       

	                     
		               
 
#endif          

#if SERVER
                                      
 
	                                          
	                               
 
#endif          

#if SERVER
                                           
 
	                                               
		      

	                                

	                                                   
	                               
		      

	                              
		                                                                                                      

	                                                                                                             
	                                                                               
	                            
		      

	                                     
	                               
	                          
	 
		                                                                                 
		 
			                                                 
			                                                                                            
				        

			                                        
			 
				                                               
				                                            
				 
					                                           
					     
				 
			 
		 
	 

	                                                                    
	                                         
	 
		                                                                                      
		                                                                                                                                                     

		                           
		 
			                                                  
			                                                                                                                                                       
		 
		                                
		 
			                                                  
			                                                                                                                                                       
		 
		                                
		 
			                                                  
			                                                  
			                                                                                                                                                                
		 
	 

	                                                   
	 
		                                            
		                                                 
		                                                                                                     
		                                                          
		                                                                           
	 
	                                                   
	 
		                                            
		                                                                                                                   
		                                                                                                     
		                                                          
		                                                                           
	 

	                                                                    
	                                                                                      
 
#endif          

#if SERVER
                                                                             
 
	                          
	                                                           

	                             
	                                                                                                                         

	                                                            
	                          
	 
		                                                                    

		                                                    
		                                                                        
		                                   

		                                            
		                                                                                                    

		                                     
		                                                    

		                                    

		                                                                                                                                             
	 
 
#endif          

#if SERVER
                            
                                                            
 
	               
	 
		       
			                                                                      
		       
			                                                                         
		       
			                                                                       
		       
			                                                               
		       
			                                                              
		       
			                                                                
		       
			                                                                      
		       
			                                                                    
		       
			                                                          
		       
			                                                         
		        
			              
	 
	           
 
#endif          

#if SERVER
                                                        
 
	       
		                                                                     
	             

	                              
 
#endif          

#if SERVER
                                       
 
	                                         

	                                   
	                             

	                                                             
	 
		               
		                                               
			                                           
		                                                   

		                                                                      

		              
		                                                         

		                                     
		           
	 

	                                                        
	 
		                           
		 
			                                               
		 
	 
 
#endif          

#if SERVER
                                                                     
 
	                                                                                          
	                                                                                       
	                                
	                                     

	                             
	 
		                                                                         
	 
	    
	 
		                                                                         
	 

	              
 
#endif          

#if SERVER
                                                          
 
	                                                                                  
	                           
	                                     
	                                                       

	                                                                          

	              
 
#endif          

#if SERVER
                                                                                    
 
	                                                                                          
	                                   
	                                     
	                                           

	                                                                         

	              
 
#endif          

#if SERVER
                                                    
 
	       
		                                              
	             

	                                                  
		                                        

	                                                  
	                                                                                                                                   
		                                                                                                                             
 
#endif          

#if SERVER
                                                                       
 
	       
		                                             
	             

	                                                 
		                                                   
	                                                         
 
#endif          

#if SERVER
                                                                       
 
	                                               

	                             
	                               

	                       
	                              

	            
		                          
		 
			                                                 
			 
				                                                                                                                                  
				 
					                                                                                                                            
					                                                                                              
				 
				                                                                 
				                                                 
			 
		 
	 

	                                                       
	                                                                               
		           

	                            
 
#endif          

#if SERVER
                                                    
 
	                       
	                                    
	 
		                               
		 
			                                   
			        
		 

		                                                                                                                                  
		 
			                                   
		 
	 

	                       
 
#endif          

#if CLIENT
                                                                                                                                                                                                                        
void function ServerCallback_Control_SetControlGeoValidForAirdropsOnClient( entity geo )
{
	if ( IsValid( geo ) && !GetAllowedAirdropDynamicEntitiesArray().contains( geo ) )
		AddToAllowedAirdropDynamicEntities( geo )
}
#endif          

#if CLIENT
                                                                         
void function ServerCallback_Control_DeregisterModeButtonPressedCallbacks()
{
	Control_DeregisterModeButtonPressedCallbacks()
}
#endif          

#if CLIENT
void function ServerCallback_Control_SetDeathScreenCallbacks()
{
	DeathScreen_SetModeSpecificRuiUpdateFunc( Control_DeathScreenUpdate )
	DeathScreen_SetDataRuiAssetForGamemode( DEATH_SCREEN_RUI )
	SetSummaryDataDisplayStringsCallback( Control_PopulateSummaryDataStrings )
}
#endif          

#if SERVER || CLIENT
                                                                                        
                                                                                   
                                                                                                                                                                             
                                                                                                                                                                                 
                                                                                    
void function Control_RegisterTimedEvents()
{
	                                       
	if (  Control_GetIsLockoutEnabled() )
	{
		TimedEventData lockoutData
		lockoutData.shouldShowPreamble = false

		#if SERVER
			                                   
			                                            
			                                                            
			                                 
			                                
			                              
			                                                                              
			                                               
		#endif          

		#if CLIENT
			lockoutData.eventName = "#EVENT_LOCKOUT_NAME"
			lockoutData.infoOverrideFunctionThread = Control_LockoutInfoOverride
			lockoutData.shouldHideTimer = false
		#endif          

		TimedEvents_RegisterTimedEvent( lockoutData )
	}

	                                       
	if ( Control_GetAreAirdropsEnabled() )
	{
		TimedEventData airdropData

		#if SERVER
			                                   
			                                            
			                                          
			                                                                    
			                                 
			                                  
			                              
			                                                                              
		#endif          

		#if CLIENT
			airdropData.colorOverride = OBJECTIVE_WHITE
			airdropData.eventName = "#EVENT_AIRDROP_NAME"
			airdropData.eventDesc = "#EVENT_AIRDROP_DESC"
			airdropData.shouldHideTimer = true
		#endif          

		TimedEvents_RegisterTimedEvent( airdropData )
	}

                     
                                            
                                            
   
                              

             
                                        
                                                 
                                               
                                                                        
                                       
                                       
                                    
                                                                                         
                   

             
                                                
                                              
                                              
                                       
                   

                                                 
   
                           

	                                       
	if ( Control_GetAreBonusCaptureTimedEventsEnabled() )
	{
		TimedEventData bountyData
		bountyData.shouldHideUntilPrembleDone = true
		#if SERVER
			                                  
			                                            
			                                         
			                                                          
			                                 
			                                 
			                              
			                                                                            
		#endif          

		#if CLIENT
			bountyData.eventName = "#EVENT_STARTS_IN"
			bountyData.eventDesc = "#EVENT_BOUNTY_DESC"
			bountyData.infoOverrideFunctionThread = Control_BountyInfoOverride
			bountyData.shouldHideTimer = false
		#endif          

		TimedEvents_RegisterTimedEvent( bountyData )
	}

	#if SERVER
		                                                              
	#endif          
}
#endif                    

#if CLIENT
                                                                                          
entity function Control_GetObjectiveUnderAim( vector worldPos, float adjustedRange )
{
	float closestDistSqr = FLT_MAX
	entity closestEnt
	array<entity> objectiveArray = file.waypointList
	foreach ( objective in objectiveArray )
	{
		if ( !IsValid( objective ) )
			continue

		vector objectiveOrigin = objective.GetOrigin()
		if ( fabs( objectiveOrigin.x - worldPos.x ) > adjustedRange || fabs( objectiveOrigin.y - worldPos.y ) > adjustedRange )
			continue

		float distSqr = Distance2DSqr( objectiveOrigin, worldPos )
		if ( distSqr < closestDistSqr )
		{
			closestDistSqr = distSqr
			closestEnt     = objective
		}
	}

	return closestEnt
}
#endif          

#if CLIENT
                                                                        
bool function Control_PingObjectiveUnderAim( entity objective )
{
	entity player = GetLocalClientPlayer()

	if ( !IsValid( player ) )
		return false

	Ping_SetControlObjective( player, objective )
	return true
}
#endif          

#if CLIENT
                                                                        
void function Control_PingObjectiveFromObjID( int objID )
{
	entity player = GetLocalClientPlayer()

	if ( !IsValid( player ) )
		return

	foreach ( ping in Control_GetObjectiveStarterPings() )
	{
		if ( !IsValid( ping ) )
			continue

		int objectiveWaypointPingType = Waypoint_GetPingTypeForWaypoint( ping )
		if ( objectiveWaypointPingType == ePingType.CONTROL_OBJECTIVE_DEFEND || objectiveWaypointPingType == ePingType.CONTROL_OBJECTIVE_ATTACK )
		{
			if ( IsValid( ping.GetParent() ) && IsValid( ping.GetParent().GetOwner() ) )
			{
				entity pingedObjective = ping.GetParent().GetOwner()
				int pingedObjectiveObjID = pingedObjective.GetWaypointInt( INT_OBJECTIVE_ID )
				if ( pingedObjectiveObjID == objID )
					Ping_SetControlObjective( player, pingedObjective )
			}
		}
	}
}
#endif          



  
                                                                                                                                                                                      
                                                                                                                                                                                       
                                                                                                                                                                                       
                                                                                                                                                                                       
                                                                                                                                                                                       
                                                                                                                                                                                       

                                                                                                                                                                                         
#if SERVER
                                                                                                                                                                                                                                    
                                           
 
	                                            
	 
		                                      
	 

	                                   
	                                              
	                                              

	                                                                          
	                                     
	 
		                                                                                                                                                                                  
			                                                                   
	 
 
#endif          

#if SERVER
                                                                   
 
	            
 
#endif          

#if SERVER
                                             
 
	            
 
#endif          

#if SERVER
                                                                    
 
	                                                                                                           
	                                                                              
	                                                  
	                                                                                                                                   

	                              
	 
		                               
		              

		                                                                                    

		                                                                                            
		                                      
		 
			        
			                                                    
		 
	   
 
#endif          

#if SERVER
                                                
 
	                                                                                             
	                                                                                                                                   
	                                                             
	                                  

	                                                                                                                                                                                  
		                                                                   

	                                                                                                                                                                                              
	                                                              
	 
		                
		                                                           
		                                                                   
	 
 
#endif          

#if SERVER
                                                 
                                                   
 
	                        
	 
		                                                                                             
	 
 
#endif          

#if SERVER
                                                
 
	                                               

	                             
	                               

	                                                                        
		           

	                                   

	                                    

	                                

	                                              
	 
		                                                                             
		                                               
	 

	                                      
	                                                               

	                                  
		                                                 
	                              
		                                              

	                                                   
	                                                                
		                                                  

	               
	                                         

	                                                                                                               
	                                                                                       
	 
		                              
		                                                                    
	 
	
	                                
	                                                                                                           
	                                      

	                                      
 
#endif          

#if SERVER
                                                                       
 
	                                                                                 
	                         
		      

	                                                      
	                          
	 
		                         
			      

		                                 
		                                     

		                                                 
		 
			                                     
		 
	 
 
#endif          







  
                                                                                 
                                                                                  
                                                                               
                                                                                
                                                                                 
                                                                                  


                                                                                            
                                                                                             
                                                                                          
                                                                                          
                                                                                          
                                                                                          

                                                                                               
#if SERVER || CLIENT
                                                                    
bool function Control_IsPointAnFOB( int pointIndex )
{
	return pointIndex == CONTROL_FOB_INDEX_ALLIANCE_A || pointIndex == CONTROL_FOB_INDEX_ALLIANCE_B
}
#endif                    

#if SERVER
                                                                              
 
	                               
		      

	                                                                                
	                                                     
		                                           

	                                                           
	                                                                                                

	       
		                             
			                                                
	             
 
#endif          

#if SERVER
                                                                             
 
	                               
		      

	                                                                                
	                                                    
		                                                      

	                                                      
	                                                                                                 

	       
		                             
			                                             
	             
 
#endif          

#if SERVER
                                                                                                                  
                                                                                                                                  
                                                                                                                                         
                                                                                                                    
                                                                  
                                                                                        
                                                                 
 
	                                               

	                                                       
	                           
	                            
	                              

	                                     

	            
		                     
		 
			                               
				                       
		 
	 

	                                  
	                                                              
	 
		                                                     
		                                 
		                            
		                                                                                               
	   

	                  
	                                                                                                     
	 
		                          
		                                                    
		                                                      
		                                               

		                                                                  
		 
			                               
			                           
		 

		                                                                                       
		 
			                                                                                   
			                                                           

			                                                
			                                                  
			                  
				           

			                                  
			                                                                          
			                                                         
			                                                         
			                                                                                                                  
		 
		    
		 
			                             
			                             

			                                               
			 
				                        
				 
					                                                       
						                       
					                                                            
						                       

					                                                                 
					                                                     
						                                                                                                                   
					    
						                                                   
				 
			 

			                                                                             
			                                                                             

			                                                                                        
			                                                                                                                                    
			                                                                                                                                                                                              
			                                                                                       
			                                        

			                                         
			                                 
			                                                    
				                          
			                                                         
				                          

			                                            
			                                     
			 
				           
			 
			    
			 
				                                      
			 

			                                                                                   
			                                                                                                                                            
			                                                                                                                                                                                                                                                            
				                      

			                                                  

			                   
			 
				                               
				           
				                                                                                                                           
				                                          
			 
			                                                                   
			 
				                   
				              
				                                                                                                                                                                                      
				                                                                                                                 
				                                                       
				                                                   
			 
			                                                                                                  
			 
				                                                   
				                                                                                                                 
			 
			    
			 
				                                            
				                   
					                                        
				                                                                                                                 
			 

			                                  
			                                                                          

			                                                   
			                                     
			 
				                                                
				 
					                                                                               
					 
						                                                   
							                                                                                                               
						    
							                                                 
					 
				 
			 
		 

		                               
		                                                             
			                                                                                                                                   
		    
			                                                           

		                          
		           
	 
 
#endif          

#if SERVER
                                                                                                    
                                                                                          
 
	                              
	                                                                                       

	                                                    
	 
		                                                                    
		                                                                         
			                                     
	 
	                          
 
#endif          

#if SERVER
                                             
 
	                                               

	                                                            
	                                                

	                                        
	                                                                                    

	                          
	 
		                                            
		                                            
		                                                
	 

	                                      

	                                              
	 
		                                                               
		                                                           
		                                                           

		                                                                                                                 
		                                            
		                                                                                                                                                                         

		                                                         
		                                                                                                                                   

		                                                            
		                                                                                                    
		                                                                                    

		                    

		                    
		                    
		                      
		                                                                                              
		                                                                                              

		                                                        
		 
			                                               
			 
				                                            
					              
				                                                 
					              
			 

			                
		 

		                                         
		 
			                                
			                                               
		 


		                                         
		 
			                                
			                                               
		 

		                          
		                               

		                                                     
			                                          

		                                   
		 
			       
				                                                                              
			             
			                                                                       
			     
		 

		                     
		                          
		 
			                                                           
			                                             
			                                                       
			                                                     

			                                                          
			                                                                                                           
			 
				                                                                     
				                                                                                  
				                                           
			 

			                                                                           
			                                                                                                                                                                 
			 
				                                                                    
				                                                                              
				                                           
			 

			                           
			                                                                                                               
			 
				                                                                     
				                                                                                  
				                                               
			 
		 

		                    
		                                                  
		                                                            
		 
			                      
				                                                   
			                    
			                        
		 
		                                                             
		 
			                      
				                                                   
			                        
		 
		                                                            
		 
			                      
				                                                   
			                        
		 
		                                                             
		 
			                      
				                                                   
			                        
		 

		        
	 
 
#endif          

#if SERVER
                                                                                     
                                             
 
	                                               

	                                         
	                                                          

	       
		                                                           
		                                                               
	                 

	                                                  

	                                                       
	                            
		      
	
	                                                                                                      
	                                                                                                    
	                                                                                                                                                                                            

	       
		                                                                                                                          
	             

	                                                                                                            
	                                          

	                                                                              
	                                      
	 
		                        
			                                                                                                     
	 

	       
		                                                                                                                                                      
	             

	                                                                                 
	                                          

	                                                  
	                                      
	 
		                        
			                                                                                                    
	 

	       
		                                                                           
	             

	                                                                                   
	                             

	                                                   
	       
		                                                                                                                           
	             

	                                         
		                                                                                          
 
#endif          

#if SERVER
                                                                                                                  
 
	                               
	                                     
	                                                                         
	                                                  

	                                  
	                                                                                  
	                                                                 
	                                                                                              

	                                     

	                                          
	                                            
	            
	 
		                                           
		                                                                                                                                                                       
		                                                                

		                                                                                                                                     
		                                                                                                  
		 
			                                      
			 
				                                                                                                                                              
				 
					                                                                                                                 
				 
			 
		 
	 
	    
	 
		                                                                                      
		                                                                                                      
		                                                                                     
		                                                                                           
		                                                                   

		                                                                                                                                     
		                                                                                                     
		 
			                                      
			 
				                                                                                                                                              
				 
					                                                                                                                 
				 
			 
		 
	 

	                                                       
	                                       
			                                    
			                                                    
		      

	                                                           
	                                                                                                                      
	 
		                  
		                                                     
	 

	                                                       
	                                                                           
		      

	                                       

	                           
	                                                        
	 
		                                               
			                     
	 

	                                                                                             

	                                                                                                                                                                              

	                                                                                                            
	                                                                                                                                                                 
	 
		                                          
		 
			                                                                                                  
		 
	 
 
#endif          

#if SERVER
                                                
                                                                                                               
 
	                                        
		      

	                         

	                                                                                                                          
	                                                                                                                                                                                     
	 
		                                                                    
	 
	                                                                                                                                                            
	 
		                    
		 
			                                                       
			                 
			 
				                               
					                                                               
					     
				                               
					                                                               
					     
				                               
					                                                               
					     
			 
			     
			                                                             
			                 
			 
				                               
					                                                                  
					     
				                               
					                                                                  
					     
				                               
					                                                                  
					     
			 
			     
		 
	 

	                             
		                                                                                                                          
 
#endif          

#if SERVER
                                                                                                                                                                                                   
 
	                     
		      

	                                          
		                                                                                                                                                                                                                
 
#endif          

#if SERVER
                                                           
 
	                                
		      

	                             
	                                                                                                          

	                                                                
	 
		                                                   
		                                                                                                                                      
	 

	              
	                                                        
	                             

	                                                                                         
	                                                                                                                                                       
 
#endif          

#if SERVER
                                                                                               
 
	                     
		      

	                                          
		                                                                                                                     
 
#endif          

#if SERVER
                                                                         
 
	                     
		      

	                                        
		      

	                                          
		                                                                                       

	                           

	                                        
	                            
		               

	                           
	                    
	 
		                               
			                                                                                                        
			     
		                               
			                                                                                                        
			     
		                               
			                                                                                                        
			     
		        
			                                                                                                              
			     
	 

	                                                             
	                                                                               
	                                                                        
 
#endif          

#if SERVER
                                                                                          
                                                                        
 
	       
		                           
			      
	             

	                                                                                                        
	                                                

	                              
 
#endif          

#if SERVER
                                                                                 
 
	                                                       
		      

	                                     
	 
		                                                                               
		                                                                                   

		                                                               
		                                                                                                                
	 

	                                      
	 
		                                                                                                                                
		                                                       
		                                             
		                                                     
		                                               
		                                              
	 
 
#endif          

#if SERVER
                                                                   
 
	                                                       
		      

	                                      
	 
		                                                                                                                                  
		                                                       
		                                             
		                                                     
		                                               
		                                              
	 
 
#endif          

#if SERVER
                                                                                
 
	                                                                                                    

	                                                                                                                              
	                                                                        
	 
		                                                                                    
		                                                                                                                                                   
	 

	                                      
	 
		                                                            
		                                                    
		 
			                                                                                   
			 
				                                                                                                                                
			 
		 
	 

	                                               
	 
		                                                                                                        
		 
			                                                                                                                                                                                                                                               
			                                      
			 
				                                                                                                                      
				                                             
			 
			                                                                                                    
			                                               

			                                                                    
			                                                                              
				                                                               

			                                                               
		 
	 
 
#endif          

#if SERVER
                                                          
                                                                               
 
	                                                                               
	                                                             
	                                                    
	 
		                                                                                   
		 
			                                                                                          
			                                                                                                                                                                                                                                                                              
			                                                       
			                                                   

			                                      
			 
				                                                                                    
			 
		 
	 

	                                    
	 
		                                        
	 
	    
	 
		                                        
	 
 
#endif          

#if SERVER
                                     
                                                                                   
 
	                                                            
	                                       
		      

	                                                                                                       
	                                                                                       
	                                                                                                                                                      

	                                      
	 
		                                                               
		                                                     
		 
			                                                                                   
			 
				                                                                                                                                      
			 
		 
	 

	                                                    
	                                               
	 
		                                                                                                        
		 
			                                                                                                                                                                                                                                                  
			                                      
			 
				                                                                                                                            
				                                             
			 
		 
	 
 
#endif          

#if SERVER
                                   
                                                              
 
	                            
	                            

	                                                             
	                                               
	 
		                 
		 
			                                                                              
			 
				                      
			 
			    
			 
				                      
			 
		 
	 

	                                                                                              
	                                               
	 
		                         
			        

		                                                                                                                                                  
		                                                                                                                                              

		                                            
		                                                                                          
		 
			                                                   
			                                                  
			 
				                                                                                                                                                                                                                                                
				                                                                          
				                                                             
				 
					                                                                                   
					                                             
				 
			 
			                                                                                                           
			 
				                                                                                                                                                                                                                                                 
				                                                                             
				                                                              
				 
					                                                                                     
					                                             
				 
			 
		 

		                                               
		                                                                                          
		 
			                                                                                      
			 
				                                                                                                                                                                                                                                                
				                                                                          
				                                                              
				 
					                                                                                   
					                                             
				 
			 
			                                                                                          
			 
				                                                                                                                                                                                                                                                            
				                                                                                        
				                                                                   
				 
					                                                                                                     
					                                             
				 
			 
		 
	 
 
#endif          

#if SERVER
                                                                                            
                                                               
 
	                                             
	                                                                     

	                                                              
	                                                    
	 
		                                                                                   
		 
			                                                                                                             

			                                                                             
				                                                                                                       
		 
	 

	                                    
	 
		                                                           
	 
	    
	 
		                                                           
	 
 
#endif          

#if SERVER
                                                               
                                                                                                                                                                
 
	                         
		      

	                                                              
	                                                  
	                              
	                               
		                                                             

	                 
	 
		                                                                                                       
		                                                                                    

		                         
		 
			                                                                                                                   
			                                            
			                                                                               
			                                                                      
			                                                               

			                                                                    
			                                                                 
				                                                  

			                                                           
		 

		                                                                      
		                                  
	 

	                          
	                                                                                                                                                           
 
#endif          

#if SERVER
                                                                       
                                                                                  
 
	                         
		      

	                    
	                              
	                                                            
	                                                                                  

	                             
	 
		                                                    
		                                                                                        
		                                                        
	 

	                                       
	                                                                                                                                  
	 
		                                                                     
		                                                                                                      
	 

	                                                              
	                                              
	                              

	                          
	                                                                                                                                                       
 
#endif          

#if SERVER
                                                                                   
                                                                  
 
	                                                                                        
	                                                                                                                               
		      

	                              
	                                                                                                                      
	                                                                               
	 
		                                                                                                                                                    
		 
			                        
			     
		 
	 

	                        
		                                                                                             
 
#endif          

#if SERVER
                                                                         
                                                                
 
	                         
		      

	                             
	                                                                                                     
	                                                        
	 
		                                                                                                                                                                                         
		 
			                       
			     
		 
	 

	                       
	 
		                                                        
		                                                                                  
		                                                                                                     
			                                                                                         
	 
 
#endif          

#if SERVER
                                                                          
                                                                               
 
	                                               
		      

	                             
	                                                                                                     
	                                                        
	 
		                                                                                                                                                                                         
		 
			                       
			     
		 
	 

	                       
	 
		                                                         
		                                                                                  
		                                                                                                     
			                                                                                         
	 
 
#endif          

#if SERVER
                                                             
                                                                                 
 
	                                               
		      

	                                                                                            
	                                                                   

	                                                                           
	 
		                          
		 
			                                                                                                                                             
		 
		                              
		 
			                                                                                                                                 
		 
	 
 
#endif          

#if SERVER
                                                        
                                                                        
 
	                                               
		      

	                                                                                                                               
		                                                                                                                                          
 
#endif          

#if SERVER
                                                       
                                                                   
                                                        
                                                                
                                                                                                                                                    
                                                          
 
	                                               

	                                                   
	                                                          

	                                                                                                    
	            
		               
		 
			                                                                                                                            
				                                                                        
		 
	 

	                                                  

	                                                         
	                                                                                        
	 
		                                                                                                                                       
		                                             
		                                           
	 

	                                                                      
 
#endif          

#if SERVER
                                                    
                        
                                                                      
 
	                                               

	                         
		      

	                         
		      

	                                        
		      

	                                 
	                                                                                         

	                                                                                                                
	                                                  
	 
		                                                          
		                    
                                            

		      
	 
	                                                                                                                                                                                             
	 
		              

		                        
		                           
		                                                  
		 
			                                                                                         
			 
				                                                      
				                                   
			 
		 

		                                                                                                                       
		                                      
		 
			                             
			                
		 
		    
		 
			      
		 
	 
	    
	 
		                                                                                                                                                                                  
		                                                                                                                                  
		           

		                                            

		                                                                                           
		                                                   
                                                                            

		                    
			      
	 

	                                                                                                                                                                              
	                                                                                                          
		      

	                                        
		      

	                                       
	                                                                                         
	                                                                                  
		                                                     

	                         
		      

	                                       
	                       
                                    
	                                                
	                                    
	                                             

	                                                                   
	                                                             
		                                       

	                                                                                                           
	                                                                                                                                                                      

	                                                           

                                                                                                                                                                                                 
                                                                                                                                                                                                                              
                                                                                                                         
                                                                                                                     
	                                  
	 
		                             
			                                                                                                         
	 

	                                                       
 
#endif          

#if SERVER
                                                                                                                                                                                            
                                                                                     
 
	                                     
	                                                     
 
#endif          

#if SERVER
                                                                        
 
	                                               

	                                      
	                                    
	                                       
	                                        
		      

	                                   

	                                                                                                                                                        
	                             

	                                      
	                                        
	                                       
	                                             
		                                        

	                                        
	                                                      
	                                       

	                               
	                               
	                                 
	 
		                                                                           
			                  
		                                                                           
			                  

		                                                                                     

		                                                                                                               
		 
			                                                  
			 
				                         
					        

				                               
				                                          

				                                 
				                                                                  
				                                     
				                                                                                   
			 
		 
	 

	                                         

	                                   
	                                    
	                                   
	                                                                            
	                                        

	                                                                           
	                                          

	                                                                                                            
	                                                                                 
	                                                         
	 
		                                                                      
		                                                                                                                                                 
		                               
		                                
			                                                             
		    
			                                                             

		                                                     
	 
	                                                                
	 
		                                          
		                                               
		               
		                                         
	 
	                                                                                                
	 
		                              
	 

	                                                                                                        
	                                                      
	                                           

	                                               
 
#endif          

#if SERVER
                                                                          
 
	                          
	 
		                                       
			                                  

		                                         
			                                    
	 

	        
 
#endif          

#if SERVER
                                               
 
	                                   
 
#endif          

                     
          
                                          
 
                                                                         
                                      
  
                           
           

                                                                                                    
                                             
           

                                                                               
   
              
   

                                                                                                                         
   
              
   
  

                                                                           
             
 
                
                           

#if SERVER
                                                    
 
	                               
		        

	                                          
		        

	                                                                              
	                                                             
 
#endif          

#if SERVER
                                                 
                                                                 
 
	                                      
	 
		                        
		 
			                        
			                               
		 
	 

	                                                                  
	                                  

	                                                    
	                                                         
	 
		                                      
		 
			                        
			 
				                                                    
					                                                                                                  

				                                                      
					                                                                                                     
			 
		 
	 

	                                 
	                                                                                  
		                                                     

	                                                
	                                                               
	 
		                                                                                   
		                           
		  	        

		                                                                 

		                                        
		                        
		 
			                                                                                                   
			                                                                                                                                                    
			                              
			                                                            
			                                                                                                          
			                                                                                                                                   
		 

		                                                                                                            
		                                         
			        

                        
			                                                                                          
				                                          
                              

		                                                                                    
			                                                                                                            
	 

	                              

	                                                                                                                                                                                
	                                   

	                                            
	 
		                         
			        

		                                                                         
	 

	                                   
 
#endif          

#if SERVER
                                             
 
	                                             
	                                         

	                                            
	 
		                         
			        

		                        
		 
			                                                                                                   
			                                                                                                                                                    
			                              
			                                                                           
			                                                                                                                                   
		 
	   
 
#endif          

#if SERVER
                                                                                                                  
 
	                                
		      

	                                        
		      

	                         

	                                
	 
		                                         
		 
			                                                 
				                            
		 
	 

	                                                                                                                        
 
#endif          

#if SERVER
                                                                                                                                                       
 
	                                
		      

	                                        
		      

	                         
	                                
	 
		                                         
		 
			                                                    
			                      
				                                                                                  
		 
	 

 
#endif          

#if SERVER
                                                                                                                                                                                                                           
                                                         
                                                           
	                                        
	                                        
	                                        
	                                        
	                                        
	                                        
	                                     
	                                     
	                                     
	                                     
                                                                                                                                                
                                                                          
                                                                                         
 
	                                        
		      

	                                                                           
	                                                                                                    
		      

	                                
	 
		                                              
		                                                                               
		                   
		 
			                                                                                                                                      
			                                                                                      
			 
				                                                                                                                                  

				                                 
				 
					                                                                           
					                                                                                                                                  
				 
			 
		 
	 
 
#endif          

  
                                                                                                                                                                                                                        
                                                                                                                                                                                                                         
                                                                                                                                                                                                                      
                                                                                                                                                                                                                      
                                                                                                                                                                                                                      
                                                                                                                                                                                                                      

                                  
  

#if CLIENT
void function Control_OnGamestateEnterPlaying_Client()
{
	entity player = GetLocalViewPlayer()
	if ( IsValid( player) )
	{
		                                                                                                          
		Minimap_UpdateMinimapVisibility( player )
	}
}
#endif          

#if CLIENT
void function Control_OnGamestateEnterPreMatch_Client()
{
	file.isFirstWaveSpawn = true
}
#endif          

#if CLIENT
void function Control_OnGamestateEnterWinnerDetermined_Client()
{
	Control_DeregisterModeButtonPressedCallbacks()
	RunUIScript( "UpdateSystemMenu" )
}
#endif          

#if CLIENT
void function Control_OnGamestateEnterResolution_Client()
{
	Control_DeregisterModeButtonPressedCallbacks()
}
#endif          

#if CLIENT
void function Control_DeregisterModeButtonPressedCallbacks( bool shouldCloseCharacterSelect = true )
{
	RunUIScript( "UI_CloseGameModeRulesDialog" )
	RunUIScript( "Control_SetAllButtonsDisabled" )

	if ( shouldCloseCharacterSelect )
		Control_CloseCharacterSelectOnlyIfOpen()

	if ( IsUsingLoadoutSelectionSystem() )
		RunUIScript( "LoadoutSelectionMenu_CloseLoadoutMenu" )

	RunUIScript( "UI_CloseControlSpawnMenu" )
	DestroyRespawnBlur()
}
#endif          

#if CLIENT
void function Control_CloseCharacterSelectOnlyIfOpen()
{
	if ( CharacterSelect_MenuIsOpen() )
		CloseCharacterSelectNewMenu()
}
#endif          

#if CLIENT
void function ControlOverrideGameState()
{
	ClGameState_RegisterGameStateAsset( $"ui/gamestate_control_mode.rpak" )
	ClGameState_RegisterGameStateFullmapAsset( $"ui/gamestate_info_fullmap_control.rpak" )
}
#endif          

#if CLIENT
void function Control_OnFullmapCreated( var fullmap )
{
	ObjectiveScoreTrackerSetup( fullmap )
}
#endif          

#if CLIENT
void function Control_OnScoreboardCreated()
{
	ObjectiveScoreTrackerSetup( ClGameState_GetRui() )
	ObjectiveScoreTracker_AnnouncementSetup( ClGameState_GetRui() )
}
#endif          

#if CLIENT
void function Control_OnPlayerCreated( entity player )
{
	ObjectiveScoreTracker_PopulatePlayerData( GetFullmapGamestateRui() )
	ObjectiveScoreTracker_PopulatePlayerData( ClGameState_GetRui() )
}
#endif          

#if CLIENT
void function Control_OnPlayerTeamChanged( entity player, int oldTeam, int newTeam )
{
	ObjectiveScoreTracker_PopulatePlayerData( GetFullmapGamestateRui() )
	ObjectiveScoreTracker_PopulatePlayerData( ClGameState_GetRui() )
}
#endif          

#if CLIENT
void function Control_OnPlayerClassChanged( entity player )
{
	ObjectiveScoreTracker_PopulatePlayerData( GetFullmapGamestateRui() )
	ObjectiveScoreTracker_PopulatePlayerData( ClGameState_GetRui() )
}
#endif          

#if CLIENT
void function Control_OnSpectatorTargetChanged( entity spectatingPlayer, entity prevSpectatorTarget, entity newSpectatorTarget )
{
	ObjectiveScoreTracker_PopulatePlayerData( GetFullmapGamestateRui() )
	ObjectiveScoreTracker_PopulatePlayerData( ClGameState_GetRui() )
}
#endif          

#if CLIENT
void function Control_OnViewPlayerChanged( entity player )
{
	ObjectiveScoreTracker_PopulatePlayerData( GetFullmapGamestateRui() )
	ObjectiveScoreTracker_PopulatePlayerData( ClGameState_GetRui() )
}
#endif          

#if CLIENT
void function Control_OnPlayerDisconnected( entity player )
{
	entity localPlayer = GetLocalClientPlayer()
	if ( !IsValid( player ) || !IsValid( localPlayer ) )
		return

	if ( player != GetLocalClientPlayer() )
		return

	                                                                                                                                    
	Control_DeregisterModeButtonPressedCallbacks( false )
}
#endif          

#if CLIENT
void function Control_InstanceObjectivePing( entity wp )
{
	int wpType = wp.GetWaypointType()
	Assert( wpType == eWaypoint.CONTROL_OBJECTIVE )

	entity viewPlayer = GetLocalViewPlayer()
	if ( !IsValid( viewPlayer ) )
	{
		Warning( "%s(): no view-player.", FUNC_NAME() )
		return
	}

	if ( viewPlayer.GetTeamMemberIndex() < 0 )
	{
		Warning( "%s(): team member index was invalid.", FUNC_NAME() )
		return
	}

	var rui = CreateWaypointRui( $"ui/waypoint_control_objective.rpak", CONTROL_OBJECTIVE_RUI_SORTING )
	RuiKeepSortKeyUpdated( rui, true, "targetPos" )

	RuiTrackInt( rui, "viewPlayerTeamMemberIndex", viewPlayer, RUI_TRACK_PLAYER_TEAM_MEMBER_INDEX )
	RuiTrackFloat3( rui, "targetPos", wp, RUI_TRACK_ABSORIGIN_FOLLOW )
	RuiTrackFloat3( rui, "playerAngles", viewPlayer, RUI_TRACK_CAMANGLES_FOLLOW )                             

	PlayerMatchState_RuiTrackInt( rui, "matchStateCurrent", viewPlayer )

	bool visible = ShouldWaypointRuiBeVisible()
	RuiSetVisible( rui, visible )

	SetWaypointRui_HUD( wp, rui )
	UpdateResponseIcons( wp )

	SetupObjectiveWaypoint( wp, rui )
}
#endif          

#if CLIENT
void function SetupObjectiveWaypoint( entity wp, var rui )
{
	if ( wp.GetWaypointType() == eWaypoint.CONTROL_OBJECTIVE )
	{
		thread ManageObjectiveWaypoint( wp, rui )
		int objectiveID = wp.GetWaypointInt( INT_OBJECTIVE_ID )

		RuiSetString( rui, "objectiveName", Control_GetObjectiveNameFromObjectiveID_Localized( objectiveID ) )
		RuiTrackFloat( rui, "capturePercentage", wp, RUI_TRACK_WAYPOINT_FLOAT, FLOAT_CAP_PERC )
		RuiTrackInt( rui, "currentControllingTeam", wp, RUI_TRACK_WAYPOINT_INT, INT_TEAM_CAPTURING )
		RuiTrackInt( rui, "currentOwner", wp, RUI_TRACK_WAYPOINT_INT, CONTROL_INT_OBJ_TEAM_OWNER )
		RuiTrackInt( rui, "neutralPointOwnership", wp, RUI_TRACK_WAYPOINT_INT, CONTROL_INT_OBJ_NEUTRAL_TEAM_OWNER )
		RuiSetInt( wp.wp.ruiHud, "yourTeamIndex", AllianceProximity_GetAllianceFromTeam( GetLocalViewPlayer().GetTeam() ) )
		RuiTrackInt( rui, "team0PlayersOnObj", wp, RUI_TRACK_WAYPOINT_INT, INT_TEAM0_PLAYERSONOBJ )
		RuiTrackInt( rui, "team1PlayersOnObj", wp, RUI_TRACK_WAYPOINT_INT, INT_TEAM1_PLAYERSONOBJ )

		thread ObjectiveWaypointThink( wp, rui )
		thread ObjectiveGameStateTrackerThink( wp, ClGameState_GetRui(), true, true )
		thread ObjectiveGameStateTrackerThink( wp, GetFullmapGamestateRui(), true, false )

		thread ObjectiveFlareFXThink( wp )
	}
}
#endif          

#if CLIENT
void function ManageObjectiveWaypoint( entity wp, var rui )
{
	Assert( IsNewThread(), "Must be threaded off" )

	file.waypointList.append( wp )

	OnThreadEnd( void function() : ( wp ) {
		#if DEV
			printf( "CONTROL: Objective waypoint destroyed" )
		#endif       

		file.waypointList.fastremovebyvalue( wp )
	} )

	WaitSignal( wp, "OnDestroy" )
}
#endif          

#if CLIENT
void function ObjectiveFlareFXThink( entity wp )
{
	Assert( IsNewThread(), "Must be threaded off" )

	if ( !IsValid( wp ) )
		return

	wp.EndSignal( "OnDestroy" )
	wp.EndSignal( SIGNAL_WAYPOINT_RUI_SET )

	entity scriptParent = wp.GetParent()
	entity objectiveFlag = scriptParent

	if ( GetEditorClass( scriptParent ) != "control_flag_prop" )
	{
		array<entity> linkedEnts = scriptParent.GetLinkEntArray()
		foreach( ent in linkedEnts )
		{
			if ( GetEditorClass( ent ) == "control_flag_prop" )
				objectiveFlag = ent
		}
	}

	if ( !IsValid( objectiveFlag ) )
		return

	#if DEV
		printf( "CONTROL: setting up flare on objective " + scriptParent + " with flag ent " + objectiveFlag )
	#endif       

	int flareFX = StartParticleEffectOnEntity( objectiveFlag, GetParticleSystemIndex( CONTROL_WAYPOINT_FLARE_ASSET ), FX_PATTACH_POINT_FOLLOW_NOROTATE, objectiveFlag.LookupAttachment( "fx_end" ) )
	entity player = GetLocalViewPlayer()

	OnThreadEnd(
		function() : ( objectiveFlag, flareFX )
		{
			if ( EffectDoesExist( flareFX ) )
				EffectStop( flareFX, false, false )
		}
	)

	                                                                                                                                                
	while ( GetGameState() == eGameState.Playing )
	{
		player = GetLocalViewPlayer()

		if ( EffectDoesExist( flareFX ) && IsValid( player ) )                                                                                                
		{
			EffectWake( flareFX )

			if ( IsValid( wp ) )
			{
				if ( wp.GetWaypointInt( CONTROL_INT_OBJ_TEAM_OWNER ) == ALLIANCE_NONE )
					EffectSetControlPointVector( flareFX, 1, <150,150,150> )
				else if ( wp.GetWaypointInt( CONTROL_INT_OBJ_TEAM_OWNER ) == AllianceProximity_GetAllianceFromTeam( player.GetTeam() ) )
					EffectSetControlPointVector( flareFX, 1, CONTROL_OBJECTIVE_GREEN )
				else
					EffectSetControlPointVector( flareFX, 1, CONTROL_OBJECTIVE_RED )
			}
		}
		else if ( !EffectDoesExist( flareFX ) && IsValid( objectiveFlag ) && IsValid( player ) )                                                                                            
		{
			flareFX = StartParticleEffectOnEntity( objectiveFlag, GetParticleSystemIndex( CONTROL_WAYPOINT_FLARE_ASSET ), FX_PATTACH_POINT_FOLLOW_NOROTATE, objectiveFlag.LookupAttachment( "fx_end" ) )
		}
		else                                                                                       
		{
			break
		}

		WaitFrame()
	}
}
#endif          

#if CLIENT
void function ObjectiveWaypointThink( entity wp, var rui )
{
	wp.EndSignal( "OnDestroy" )
	wp.EndSignal( SIGNAL_WAYPOINT_RUI_SET )

	while ( GetGameState() == eGameState.Playing )
	{
		entity player = GetLocalViewPlayer()

		if ( !IsValid( player ) )
			return

		int playerTeam = player.GetTeam()
		int playerAlliance = AllianceProximity_GetAllianceFromTeam( playerTeam )

		if ( Control_ShouldShow2DMapIcons() )
		{
			var minimapRui
			var fullmapRui
			if ( wp in file.waypointToMinimapRui )
				minimapRui = file.waypointToMinimapRui[wp]
			if ( wp in file.waypointToFullmapRui )
				fullmapRui = file.waypointToFullmapRui[wp]

			asset iconToSet
			if ( wp.GetWaypointInt( CONTROL_INT_OBJ_TEAM_OWNER ) == ALLIANCE_NONE )
				iconToSet = CONTROL_OBJ_DIAMOND_EMPTY
			else if ( wp.GetWaypointInt( CONTROL_INT_OBJ_TEAM_OWNER ) == playerAlliance )
				iconToSet = CONTROL_OBJ_DIAMOND_YOURS
			else
				iconToSet = CONTROL_OBJ_DIAMOND_ENEMY

			if ( minimapRui != null )
				RuiSetImage( minimapRui, "defaultIcon", iconToSet )
			if ( fullmapRui != null )
				RuiSetImage( fullmapRui, "defaultIcon", iconToSet )
		}

		if ( wp.GetWaypointFloat( FLOAT_BOUNTY_AMOUNT ) > 0 )
			RuiSetBool( rui,"hasEmphasis", true )
		else
			RuiSetBool( rui,"hasEmphasis", false )

		RuiSetInt( rui, "numTeamPings", Control_GetPingCountForObjectiveForAlliance( wp, playerAlliance ) )

		RuiSetBool( rui, "localPlayerOnObjective",  Control_Client_IsOnObjective( wp, player ) )

		RuiSetBool( rui, "isHidden", file.inGameMapRui != null || IsScoreboardShown() )                                                         
		                                                   
			                                        
		    
			                                           

		WaitFrame()
	}
}
#endif          

#if CLIENT
void function ObjectiveGameStateTrackerThink( entity wp, var gameStateRui, bool shouldTrackOnObjective = true, bool shouldTrackOwner = false )
{
	Assert( IsNewThread(), "Must be threaded off" )

	wp.EndSignal( "OnDestroy" )
	wp.EndSignal( SIGNAL_WAYPOINT_RUI_SET )

	int waypointIndex = wp.GetWaypointInt( INT_OBJECTIVE_ID )
	var mainTrackerRui = RuiCreateNested( gameStateRui, "objective" + waypointIndex, $"ui/control_mode_progress_tracker.rpak" )

	              
	RuiSetInt( mainTrackerRui, "yourTeamIndex", AllianceProximity_GetAllianceFromTeam( GetLocalViewPlayer().GetTeam() ) )
	RuiSetString( mainTrackerRui, "name", Control_GetObjectiveNameFromObjectiveID_Localized( waypointIndex ) )

	RuiTrackFloat( mainTrackerRui, "capturePercentage", wp, RUI_TRACK_WAYPOINT_FLOAT, FLOAT_CAP_PERC )
	RuiTrackInt( mainTrackerRui, "currentControllingTeam", wp, RUI_TRACK_WAYPOINT_INT, INT_TEAM_CAPTURING )
	RuiTrackInt( mainTrackerRui, "currentOwner", wp, RUI_TRACK_WAYPOINT_INT, CONTROL_INT_OBJ_TEAM_OWNER )
	RuiTrackInt( mainTrackerRui, "neutralPointOwnership", wp, RUI_TRACK_WAYPOINT_INT, CONTROL_INT_OBJ_NEUTRAL_TEAM_OWNER )
	RuiTrackInt( mainTrackerRui, "team0PlayersOnObj", wp, RUI_TRACK_WAYPOINT_INT, INT_TEAM0_PLAYERSONOBJ )
	RuiTrackInt( mainTrackerRui, "team1PlayersOnObj", wp, RUI_TRACK_WAYPOINT_INT, INT_TEAM1_PLAYERSONOBJ )

	OnThreadEnd(
		function() : ( gameStateRui, waypointIndex )
		{
			RuiDestroyNestedIfAlive( gameStateRui, "objective" + waypointIndex )
		}
	)

	while ( GetGameState() == eGameState.Playing )
	{
		                     
		entity player = GetLocalViewPlayer()

		RuiSetFloat( mainTrackerRui, "iconScale", 0.7 )

		int slot = OFFHAND_INVENTORY
		entity weapon = player.GetOffhandWeapon( slot )
		if( weapon != null )
		{
			switch ( weapon.GetWeaponSettingEnum( eWeaponVar.cooldown_type, eWeaponCooldownType ) )
			{
				case eWeaponCooldownType.ammo:
					int maxAmmoReady = weapon.UsesClipsForAmmo() ? weapon.GetWeaponSettingInt( eWeaponVar.ammo_clip_size ) : weapon.GetWeaponPrimaryAmmoCountMax( weapon.GetActiveAmmoSource() )
					int ammoPerShot = weapon.GetWeaponSettingInt( eWeaponVar.ammo_per_shot )

					RuiSetInt( gameStateRui, "ultimateSegments", maxAmmoReady / ammoPerShot )
					break
				default:
					RuiSetInt( gameStateRui, "ultimateSegments", 1 )
					break
			}
		}
		else
			RuiSetInt( gameStateRui, "ultimateSegments", 1 )

		if ( shouldTrackOnObjective )
		{
			if ( Control_Client_IsOnObjective( wp, player ) )
			{
				RuiSetBool( gameStateRui, "isOnObjective" + waypointIndex, true )
				RuiSetBool( mainTrackerRui, "isOnObjective", true )
				RuiSetFloat( mainTrackerRui, "iconScale", 1.35 )
			}
			else
			{
				RuiSetBool( gameStateRui, "isOnObjective" + waypointIndex, false )
				RuiSetBool( mainTrackerRui, "isOnObjective", false )
				RuiSetFloat( mainTrackerRui, "iconScale", 0.7 )
			}
		}
		if ( wp.GetWaypointFloat( FLOAT_BOUNTY_AMOUNT ) > 0 )
			RuiSetBool( mainTrackerRui, "shouldPlayEmphasis", true )
		else
			RuiSetBool( mainTrackerRui, "shouldPlayEmphasis", false )

		WaitFrame()
	}
}
#endif          

#if CLIENT
void function ObjectiveScoreTrackerSetup( var rui )
{
	table<int, var> nestedRuiTable

	for( int i = 0; i<2; i++ )
	{
		var childRui = RuiCreateNested( rui, "team" + i + "Tracker", $"ui/control_score_tracker.rpak" )
		RuiSetFloat( childRui, "scoreLimit", float( Control_GetScoreLimit() ) )
		RuiSetInt( childRui, "trackerIndex", i )

		if ( i == 1 )
			RuiSetBool( childRui, "reverseOrientation", true )

		nestedRuiTable[i] <- childRui
	}

	if ( rui == ClGameState_GetRui() )
		file.scoreTrackerRui = nestedRuiTable
	else if ( rui == GetFullmapGamestateRui() )
		file.fullmapScoreTrackerRui = nestedRuiTable
	else
		return

	                                                                                                                                                                                                           
	if ( rui != null )
		ObjectiveScoreTracker_PopulatePlayerData( rui )
}
#endif          

#if CLIENT
void function ObjectiveScoreTracker_PopulatePlayerData( var parentRui )
{
	                                                      
	if ( parentRui == null )
		ObjectiveScoreTrackerSetup( ClGameState_GetRui() )

	if ( GetLocalClientPlayer() == null || GetGameState() < eGameState.Prematch)
		return                                                                                                                                                                

	entity localPlayer = GetLocalClientPlayer()
	int friendlyAlliance = AllianceProximity_GetAllianceFromTeam( localPlayer.GetTeam() )
	int enemyAlliance = AllianceProximity_GetOtherAlliance( friendlyAlliance )
	table<int, var> nestedRuiTable

	if ( parentRui == ClGameState_GetRui() )
		nestedRuiTable = file.scoreTrackerRui
	else if ( parentRui == GetFullmapGamestateRui() )
		nestedRuiTable = file.fullmapScoreTrackerRui

	RuiSetInt( nestedRuiTable[1], "yourTeamIndex", friendlyAlliance )
	RuiSetInt( nestedRuiTable[0], "yourTeamIndex", enemyAlliance )
	RuiTrackFloat( nestedRuiTable[1], "teamScore", localPlayer, RUI_TRACK_FRIENDLY_TEAM_SCORE )
	RuiTrackFloat( nestedRuiTable[1], "opponentScore", localPlayer, RUI_TRACK_ENEMY_TEAM_SCORE )
	RuiTrackFloat( nestedRuiTable[0], "teamScore", localPlayer, RUI_TRACK_ENEMY_TEAM_SCORE )
	RuiTrackFloat( nestedRuiTable[0], "opponentScore", localPlayer, RUI_TRACK_FRIENDLY_TEAM_SCORE )
}
#endif          

#if CLIENT
void function ObjectiveScoreTracker_AnnouncementSetup( var parentRui )
{
	if ( parentRui == null )
		return

	file.announcementRui = RuiCreateNested( parentRui, "announcementTracker", $"ui/control_announcement_tracker.rpak" )
	thread ObjectiveScoreTracker_AnnouncementManagement()
}
#endif          

#if CLIENT
void function ObjectiveScoreTracker_AnnouncementManagement()
{
	Assert( IsNewThread(), "Must be threaded off" )

	                                                                    
	                                                                       
	bool shouldUpdateCatchupMechanicsUI = Control_GetMinHeldObjectivesToGenerateScore() > 0 && Control_GetIsMinHeldObjectivesOnlyForWinningTeam() ? true : false
	bool isUsingCatchupMechanic = false

	while ( true )
	{
		float currentTime = Time()

		if ( file.currentAnnouncement.isInitialized )
		{
			array<ControlAnnouncementData> announcementCopy = clone file.announcementData
			foreach( announcement in announcementCopy )
			{
				if ( announcement.shouldForcePushAnnouncement )
				{
					Control_DisplayAnnouncement( announcement )
				}
			}

			                                                                              
			if ( file.currentAnnouncement.shouldTerminateIfWPDies && !IsValid(file.currentAnnouncement.wp ) )
				Control_CancelAnnouncementDisplay()

			float announcementDisplayEndTime = file.currentAnnouncement.displayStartTime + file.currentAnnouncement.displayLength
			float eventEndTime = file.currentAnnouncement.startTime + file.currentAnnouncement.eventLength
			float trueEndTime = min( announcementDisplayEndTime, eventEndTime )
			if ( currentTime > trueEndTime )
				Control_CancelAnnouncementDisplay()
		}
		else
		{
			array<ControlAnnouncementData> announcementCopy = clone file.announcementData

			                                                     
			foreach( announcement in announcementCopy )
			{
				float announcementEndTime = announcement.startTime + announcement.eventLength
				if ( currentTime > announcementEndTime )
				{
					                                              
					file.announcementData.removebyvalue( announcement )
				}
				else
				{
					Control_DisplayAnnouncement( announcement )
				}
			}
		}
		entity player = GetLocalClientPlayer()
		bool isPlayerOnSpawnSelectScreen = false
		if ( IsValid( player ) )
			isPlayerOnSpawnSelectScreen = player.GetPlayerNetBool( "Control_IsPlayerOnSpawnSelectScreen" )

		if(file.announcementRui != null)
			RuiSetBool( file.announcementRui, "isRespawnMap", isPlayerOnSpawnSelectScreen )


		                                                                                                               
		                                                                                                             
		                                                                                                   
		if ( shouldUpdateCatchupMechanicsUI && isUsingCatchupMechanic != Control_ShouldUseCatchupMechanics() )
		{
			isUsingCatchupMechanic = Control_ShouldUseCatchupMechanics()
			Control_UpdateScoreGenerationOnClient()
		}

		WaitFrame()
	}
}
#endif          

#if CLIENT
void function Control_ObjectiveScoreTracker_PushAnnouncement( 	entity wp,
														bool shouldTerminateIfWPDies,
														string mainText,
														string subText,
														float eventLength,
														float displayLength,
														bool shouldForcePushAnnouncement,
														bool shouldUseTimer,
														vector overrideColor)
{
	ControlAnnouncementData announcementData

	announcementData.isInitialized = true
	announcementData.wp = wp
	announcementData.shouldTerminateIfWPDies = shouldTerminateIfWPDies
	announcementData.shouldForcePushAnnouncement = shouldForcePushAnnouncement
	announcementData.shouldUseTimer = shouldUseTimer

	announcementData.mainText = mainText
	announcementData.subText = subText

	announcementData.startTime = Time()
	announcementData.eventLength = eventLength
	announcementData.displayLength = displayLength
	announcementData.overrideColor = overrideColor

	file.announcementData.append( announcementData )
}
#endif          

#if CLIENT
void function Control_ObjectiveScoreTracker_UpdateAnnouncement( entity wp,
		bool shouldTerminateIfWPDies,
		string mainText,
		string subText,
		float eventLength,
		float displayLength,
		bool shouldForcePushAnnouncement,
		bool shouldUseTimer )
{
	if ( !file.currentAnnouncement.isInitialized || !IsValid(file.currentAnnouncement.wp ) )
	{
		if( file.announcementData.len() > 0 )
		{
			Control_DisplayAnnouncement( file.announcementData.top() )
		}
		else
		{
			Warning( "Control_ObjectiveScoreTracker_UpdateAnnouncement - No current announcement!" )
			return
		}

	}

	file.currentAnnouncement.displayLength = file.currentAnnouncement.displayLength + displayLength

	table<int, var> nestedRuiTable
	nestedRuiTable = file.scoreTrackerRui

	RuiSetFloat( nestedRuiTable[0], "announcementLength", file.currentAnnouncement.displayLength )
	RuiSetFloat( nestedRuiTable[1], "announcementLength", file.currentAnnouncement.displayLength )

	nestedRuiTable = file.fullmapScoreTrackerRui

	RuiSetFloat( nestedRuiTable[0], "announcementLength", file.currentAnnouncement.displayLength )
	RuiSetFloat( nestedRuiTable[1], "announcementLength", file.currentAnnouncement.displayLength )

	RuiSetFloat( ClGameState_GetRui(), "announcementLength",  file.currentAnnouncement.displayLength )
	RuiSetFloat( GetFullmapGamestateRui(), "announcementLength", file.currentAnnouncement.displayLength )

	entity linkedEnt = file.currentAnnouncement.wp.GetParent()
	int yourTeamIndex = AllianceProximity_GetAllianceFromTeam( GetLocalViewPlayer().GetTeam() )
	vector colorOverride

	if ( IsValid( linkedEnt ) )
	{
		int currentOwner = linkedEnt.GetWaypointInt( CONTROL_INT_OBJ_TEAM_OWNER )
		if ( currentOwner == ALLIANCE_NONE )
			colorOverride = OBJECTIVE_WHITE
		else
		{
			if ( yourTeamIndex == currentOwner )
				colorOverride = CONTROL_OBJECTIVE_GREEN
			else
				colorOverride = CONTROL_OBJECTIVE_RED
		}
	}
	else
	{
		colorOverride = OBJECTIVE_WHITE
	}

	RuiSetString( file.announcementRui, "mainText", mainText )
	RuiSetString( file.announcementRui, "subText", subText )
	RuiSetBool( file.announcementRui, "shouldUseTimer", shouldUseTimer )
	RuiSetFloat( file.announcementRui, "announcementLength", file.currentAnnouncement.displayLength )
	RuiSetFloat3( file.announcementRui, "colorOverride", SrgbToLinear( colorOverride / 255.0 ) )

	RuiSetString( file.fullMapAnnouncementRui, "mainText", mainText )
	RuiSetString( file.fullMapAnnouncementRui, "subText", subText )
	RuiSetBool( file.fullMapAnnouncementRui, "shouldUseTimer", shouldUseTimer )
	RuiSetFloat( file.fullMapAnnouncementRui, "announcementLength", file.currentAnnouncement.displayLength )
	RuiSetFloat3( file.fullMapAnnouncementRui, "colorOverride", SrgbToLinear( colorOverride / 255.0 ) )
}
#endif          

#if CLIENT
void function Control_DisplayAnnouncement( ControlAnnouncementData data )
{
	float announcementEndTime = data.startTime + data.eventLength
	float currentTime = Time()
	float timeUntilEnd = announcementEndTime - currentTime
	float displayTime = min( timeUntilEnd, data.displayLength )
  
	data.displayStartTime = currentTime

	RuiSetGameTime( ClGameState_GetRui(), "announcementStartTime", currentTime )
	RuiSetFloat( ClGameState_GetRui(), "announcementLength", displayTime )

	RuiSetGameTime( GetFullmapGamestateRui(), "announcementStartTime", currentTime )
	RuiSetFloat( GetFullmapGamestateRui(), "announcementLength", displayTime )

	table<int, var> nestedRuiTable
	nestedRuiTable = file.scoreTrackerRui

	RuiSetGameTime( nestedRuiTable[0], "announcementStartTime", currentTime )
	RuiSetFloat( nestedRuiTable[0], "announcementLength", displayTime )
	RuiSetGameTime( nestedRuiTable[1], "announcementStartTime", currentTime )
	RuiSetFloat( nestedRuiTable[1], "announcementLength", displayTime )

	nestedRuiTable = file.fullmapScoreTrackerRui

	RuiSetGameTime( nestedRuiTable[0], "announcementStartTime", currentTime )
	RuiSetFloat( nestedRuiTable[0], "announcementLength", displayTime )
	RuiSetGameTime( nestedRuiTable[1], "announcementStartTime", currentTime )
	RuiSetFloat( nestedRuiTable[1], "announcementLength", displayTime )

	RuiSetGameTime( file.announcementRui, "announcementStartTime", currentTime )
	RuiSetFloat( file.announcementRui, "announcementLength", displayTime )
	RuiSetString( file.announcementRui, "mainText", data.mainText )
	RuiSetString( file.announcementRui, "subText", data.subText )
	RuiSetBool( file.announcementRui, "shouldUseTimer", data.shouldUseTimer )
	RuiSetFloat3( file.announcementRui, "colorOverride",  SrgbToLinear( data.overrideColor / 255.0 ) )

	if(file.fullMapAnnouncementRui == null)
		file.fullMapAnnouncementRui = RuiCreateNested( GetFullmapGamestateRui(), "announcementTracker", $"ui/control_announcement_tracker.rpak" )

	RuiSetGameTime( file.fullMapAnnouncementRui, "announcementStartTime", currentTime )
	RuiSetFloat( file.fullMapAnnouncementRui, "announcementLength", displayTime )
	RuiSetString( file.fullMapAnnouncementRui, "mainText", data.mainText )
	RuiSetString( file.fullMapAnnouncementRui, "subText", data.subText )
	RuiSetBool( file.fullMapAnnouncementRui, "shouldUseTimer", data.shouldUseTimer )
	RuiSetFloat3( file.fullMapAnnouncementRui, "colorOverride",  SrgbToLinear( data.overrideColor / 255.0 ) )
	RuiSetBool( file.fullMapAnnouncementRui, "isWorldMap", true )

	file.currentAnnouncement = data
	file.announcementData.removebyvalue( data )
}
#endif          

#if CLIENT
void function Control_CancelAnnouncementDisplay()
{
	ControlAnnouncementData rawData
	file.currentAnnouncement = rawData
}
#endif          

#if CLIENT
void function Control_BountyInfoOverride( entity wp, TimedEventLocalClientData data )
{
	EndSignal( wp, "OnDestroy" )

	int yourTeamIndex = AllianceProximity_GetAllianceFromTeam( GetLocalViewPlayer().GetTeam() )
	string originalName = data.eventName

	Control_ObjectiveScoreTracker_PushAnnouncement( wp,
		true,
		"",
		Localize( data.eventName ),
		wp.GetWaypointGametime( 1 ) - wp.GetWaypointGametime( 0 ),
		11,
		false,
		true,
		OBJECTIVE_WHITE)

	while ( !IsValid( wp ) || !IsValid( wp.GetParent() ) )
	{
		WaitFrame()
	}

	                                        
	entity linkedEnt = wp.GetParent()
	int currentOwner = linkedEnt.GetWaypointInt( CONTROL_INT_OBJ_TEAM_OWNER )
	int objectiveID = linkedEnt.GetWaypointInt( INT_OBJECTIVE_ID )
	string objectiveName = Control_GetObjectiveNameFromObjectiveID_Localized( objectiveID )
	string eventName

	if ( currentOwner == ALLIANCE_NONE )
		eventName = Localize( "#CONTROL_POINT_BOUNTY_ATTACK", objectiveName )
	else
	{
		if ( yourTeamIndex == currentOwner )
			eventName = Localize( "#CONTROL_POINT_BOUNTY_DEFEND", objectiveName )
		else
			eventName = Localize( "#CONTROL_POINT_BOUNTY_ATTACK", objectiveName )
	}

	Control_ObjectiveScoreTracker_UpdateAnnouncement( wp,
											true,
											eventName.toupper(),
											Localize( data.eventName ),
											wp.GetWaypointGametime( 1 ) - wp.GetWaypointGametime( 0 ),
											4,
											false,
											true )

	                                             
	while ( true )
	{
		linkedEnt = wp.GetParent()
		if ( IsValid( linkedEnt ) )
		{
			currentOwner = linkedEnt.GetWaypointInt( CONTROL_INT_OBJ_TEAM_OWNER )
			if ( currentOwner == ALLIANCE_NONE )
			{
				data.colorOverride = OBJECTIVE_WHITE
				data.eventName = Localize( "#CONTROL_POINT_BOUNTY_ATTACK", objectiveName )
			}
			else
			{
				if ( yourTeamIndex == currentOwner )
				{
					data.colorOverride = CONTROL_OBJECTIVE_GREEN
					data.eventName = Localize( "#CONTROL_POINT_BOUNTY_DEFEND", objectiveName )
				}
				else
				{
					data.colorOverride = CONTROL_OBJECTIVE_RED
					data.eventName = Localize( "#CONTROL_POINT_BOUNTY_ATTACK", objectiveName )
				}
			}
		}
		else
		{
			data.colorOverride = OBJECTIVE_WHITE
			data.eventName = originalName
		}

		WaitFrame()
	}
}
#endif          

#if CLIENT
void function Control_LockoutInfoOverride( entity wp, TimedEventLocalClientData data )
{
	Assert( IsNewThread(), "Must be threaded off" )

	EndSignal( wp, "OnDestroy" )

	file.isLockout = true

	int yourTeamIndex = AllianceProximity_GetAllianceFromTeam( GetLocalViewPlayer().GetTeam() )
	string originalName = data.eventName

	while ( !IsValid( wp ) )
	{
		WaitFrame()
	}

	float eventEnd = wp.GetWaypointGametime( 1 )
	int majorityTeam = wp.GetWaypointInt( 5 )

	if ( IsValid( GetLocalClientPlayer() ) )
		EmitUISound( CONTROL_SFX_LOCKOUT_START )


	OnThreadEnd(
		function() : ( wp, eventEnd, majorityTeam, yourTeamIndex )
		{
			file.isLockout = false

			foreach( scoreRui in file.scoreTrackerRui )
			{
				RuiSetBool( scoreRui, "isLockout", false )
			}

			foreach( scoreRui in file.fullmapScoreTrackerRui )
			{
				RuiSetBool( scoreRui, "isLockout", false )
			}

			if ( Time() < eventEnd )
			{
				Control_ObjectiveScoreTracker_PushAnnouncement( null,
					false,
					Localize( "#CONTROL_LOCKOUT_ABORTED" ),
					yourTeamIndex == majorityTeam ? Localize( "#CONTROL_LOCKOUT_ENEMY_CAPTURED_OBJ" ) : Localize( "#CONTROL_LOCKOUT_FRIENDLY_CAPTURED_OBJ" ),
					7,
					7,
					false,
					false,
					OBJECTIVE_WHITE)

				if ( IsValid( GetLocalClientPlayer() ) )
					EmitUISound( CONTROL_SFX_LOCKOUT_ABORT )
			}
		}
	)

	string eventDesc = Localize( "#CONTROL_LOCKOUT_EVENT_DESC" )
	if ( yourTeamIndex ==  majorityTeam )
	{
		eventDesc = eventDesc + Localize( "#CONTROL_LOCKOUT_INSTRUCTIONS_WINNINGTEAM" )
		data.eventDesc = eventDesc
		data.colorOverride = CONTROL_OBJECTIVE_GREEN
	}
	else
	{
		eventDesc = eventDesc + Localize( "#CONTROL_LOCKOUT_INSTRUCTIONS_LOSINGTEAM" )
		data.eventDesc = eventDesc
		data.colorOverride = CONTROL_OBJECTIVE_RED
	}

	Control_ObjectiveScoreTracker_PushAnnouncement( wp,
											true,
											"",
											Localize( data.eventName ),
											wp.GetWaypointGametime( 1 ) - wp.GetWaypointGametime( 0 ),
											wp.GetWaypointGametime( 1 ) - wp.GetWaypointGametime( 0 ),
											true,
											true,
											data.colorOverride)

	foreach( scoreRui in file.scoreTrackerRui )
	{
		RuiSetBool( scoreRui, "isLockout", true )
	}

	foreach( scoreRui in file.fullmapScoreTrackerRui )
	{
		RuiSetBool( scoreRui, "isLockout", true )
	}

	WaitForever()
}
#endif          

#if CLIENT
void function RegisterMinimapPackages()
{
	RegisterMinimapPackage( "prop_script", eMinimapObject_prop_script.CONTROL_OBJECTIVE, MINIMAP_OBJECT_DYNAMIC_RUI, MinimapPackage_Objective, FULLMAP_OBJECT_RUI, FullmapPackage_Objective )
}
#endif          

#if CLIENT
void function MinimapPackage_Objective( entity ent, var rui )
{
	RuiSetImage( rui, "defaultIcon", CONTROL_OBJ_DIAMOND_EMPTY )
	RuiSetImage( rui, "clampedDefaultIcon", $"" )
	RuiSetFloat2( rui, "iconScale", <0.5, 0.5, 0> )

	entity waypoint
	foreach( child in ent.GetParent().GetChildren() )
	{
		if ( child != ent )
		{
			waypoint = child
			break
		}
	}

	if ( IsValid(waypoint ) )
		file.waypointToMinimapRui[waypoint] <- rui
}
#endif          

#if CLIENT
void function FullmapPackage_Objective( entity ent, var rui )
{
	RuiSetImage( rui, "defaultIcon", CONTROL_OBJ_DIAMOND_EMPTY )
	RuiSetImage( rui, "clampedDefaultIcon", $"" )

	entity waypoint
	foreach( child in ent.GetParent().GetChildren() )
	{
		if ( child != ent )
		{
			waypoint = child
			break
		}
	}

	if ( IsValid(waypoint ) )
		file.waypointToFullmapRui[waypoint] <- rui
}
#endif          

#if CLIENT
void function ServerCallback_Control_ProcessObjectiveStateChange( entity objective, int newState, int owner, int lastOwner, int capturer, int lastCapturer, bool didCapturingTeamBreakLockout )
{
	if ( !IsValid( objective ) )
		return

	entity localViewPlayer = GetLocalViewPlayer()
	if ( !IsValid( localViewPlayer ) )
		return

	int localPlayerAlliance = AllianceProximity_GetAllianceFromTeam( localViewPlayer.GetTeam() )
	int objectiveID = objective.GetWaypointInt( INT_OBJECTIVE_ID )
	string objectiveName = Control_GetObjectiveNameFromObjectiveID_Localized( objectiveID )

	if ( newState == eControlPointObjectiveState.CONTROLLED )
	{
		if ( owner == ALLIANCE_NONE )
		{
			                       
			Obituary_Print_Localized( Localize( "#CONTROL_UNCONTROLLED_POINT", objectiveName ), OBJECTIVE_WHITE )
		}
		else
		{
			                             
			string teamName = localPlayerAlliance == owner ? "#PL_YOUR_TEAM" : "#PL_ENEMY_TEAM"
			vector announcementColor = localPlayerAlliance == owner ? CONTROL_OBJECTIVE_GREEN : CONTROL_OBJECTIVE_RED
			string soundAlias = localPlayerAlliance == owner ? CONTROL_SFX_ZONE_CAPTURED_FRIENDLY : CONTROL_SFX_ZONE_CAPTURED_ENEMY
			Obituary_Print_Localized( Localize( "#CONTROL_CAPTURED_POINT", Localize( teamName ), objectiveName ), announcementColor )

			if ( !file.isLockout && !didCapturingTeamBreakLockout )
				EmitSoundOnEntity( objective, soundAlias )
		}
	}
	else if ( newState == eControlPointObjectiveState.CONTESTED )
	{
		if ( owner == ALLIANCE_NONE )
		{
			                       
			string teamName = localPlayerAlliance != capturer ? "#PL_YOUR_TEAM" : "#PL_ENEMY_TEAM"
			vector announcementColor = localPlayerAlliance != capturer ? CONTROL_OBJECTIVE_GREEN : CONTROL_OBJECTIVE_RED
			string warningAnnouncement = "#CONTROL_OBJ_FLIPPED"
			vector warningColor = localPlayerAlliance == capturer ? CONTROL_OBJECTIVE_GREEN : CONTROL_OBJECTIVE_RED
			Obituary_Print_Localized( Localize( "#CONTROL_LOST_POINT", Localize( teamName ), objectiveName ), announcementColor )

			EmitSoundOnEntity( objective, CONTROL_SFX_ZONE_NEUTRALIZED )
		}
	}

	Control_UpdateScoreGenerationOnClient()
}
#endif          

#if CLIENT
                                                                         
void function Control_UpdateScoreGenerationOnClient()
{
	entity localViewPlayer = GetLocalViewPlayer()

	if ( !IsValid( localViewPlayer ) )
		return

	int localPlayerAlliance = AllianceProximity_GetAllianceFromTeam( localViewPlayer.GetTeam() )
	int enemyAlliance = AllianceProximity_GetOtherAlliance( localPlayerAlliance )

	                                                                                                                         
	                                                        
	int minNumOwnedObjectivesToGainScore = Control_GetMinHeldObjectivesToGenerateScore()
	int numObjectivesOwnedByLocalPlayerAlliance = 0
	int numObjectivesOwnedByEnemyAlliance = 0

	foreach ( wp in file.waypointList )
	{
		if ( IsValid( wp ) && wp.GetWaypointType() == eWaypoint.CONTROL_OBJECTIVE )
		{
			int objectiveOwner = wp.GetWaypointInt( CONTROL_INT_OBJ_TEAM_OWNER )
			if ( objectiveOwner == localPlayerAlliance )
			{
				numObjectivesOwnedByLocalPlayerAlliance++
			}
			else if ( objectiveOwner != ALLIANCE_NONE )
			{
				numObjectivesOwnedByEnemyAlliance++
			}
		}
	}

	int minNumOwnedPointsFriendly = Control_GetMinHeldObjectivesToGenerateScore_ForAlliance( localPlayerAlliance )
	int minNumOwnedPointsEnemy = Control_GetMinHeldObjectivesToGenerateScore_ForAlliance( enemyAlliance )


	                                                                                                                                      
	int numObjectivesNeeded = maxint( minNumOwnedPointsFriendly - numObjectivesOwnedByLocalPlayerAlliance, 0 )
	int teamScorePerSec = numObjectivesOwnedByLocalPlayerAlliance >= minNumOwnedPointsFriendly ? numObjectivesOwnedByLocalPlayerAlliance : 0
	file.teamData[0].teamScorePerSec = teamScorePerSec

	int numObjectivesNeededEnemy = maxint( minNumOwnedPointsEnemy - numObjectivesOwnedByEnemyAlliance, 0 )
	int teamScorePerSecEnemy = numObjectivesOwnedByEnemyAlliance >= minNumOwnedPointsEnemy ? numObjectivesOwnedByEnemyAlliance : 0
	file.teamData[1].teamScorePerSec = teamScorePerSecEnemy

	                                                                                                                             
	                                                                                                      
	if ( minNumOwnedObjectivesToGainScore > 1 )
	{
		var scoreTrackerRui = file.scoreTrackerRui[1]
		var mapScoreTrackerRui = file.fullmapScoreTrackerRui[1]

		if ( IsValid( scoreTrackerRui ) )
		{
			RuiSetBool( scoreTrackerRui, "shouldDisplayMinOwnedObjectiveMessage", true )
			RuiSetInt( scoreTrackerRui, "yourTeamObjectivesNeededToScore", numObjectivesNeeded )
			RuiSetInt( scoreTrackerRui, "teamScorePerSec", teamScorePerSec )
			RuiSetBool( scoreTrackerRui, "shouldDisplayCatchupMechanicMessage", Control_ShouldUseCatchupMechanics() )
			RuiSetInt( scoreTrackerRui, "catchupMechanicScoreDifference", Control_GetPointDiffForCatchupMechanics() )
		}

		if ( IsValid( mapScoreTrackerRui ) )
		{
			RuiSetBool( mapScoreTrackerRui, "shouldDisplayMinOwnedObjectiveMessage", true )
			RuiSetInt( mapScoreTrackerRui, "yourTeamObjectivesNeededToScore", numObjectivesNeeded )
			RuiSetInt( mapScoreTrackerRui, "teamScorePerSec", teamScorePerSec )
			RuiSetBool( mapScoreTrackerRui, "shouldDisplayCatchupMechanicMessage", Control_ShouldUseCatchupMechanics() )
			RuiSetInt( mapScoreTrackerRui, "catchupMechanicScoreDifference", Control_GetPointDiffForCatchupMechanics() )
		}

		                                                                          
		var scoreTrackerRuiEnemy = file.scoreTrackerRui[0]
		var mapScoreTrackerRuiEnemy = file.fullmapScoreTrackerRui[0]

		if ( IsValid( scoreTrackerRuiEnemy ) )
		{
			RuiSetBool( scoreTrackerRuiEnemy, "shouldDisplayMinOwnedObjectiveMessage", true )
			RuiSetInt( scoreTrackerRuiEnemy, "teamScorePerSec", teamScorePerSecEnemy )
		}

		if ( IsValid( mapScoreTrackerRuiEnemy ) )
		{
			RuiSetBool( mapScoreTrackerRuiEnemy, "shouldDisplayMinOwnedObjectiveMessage", true )
			RuiSetInt( mapScoreTrackerRuiEnemy, "teamScorePerSec", teamScorePerSecEnemy )
		}
	}
}
#endif          

#if CLIENT
void function ServerCallback_Control_BountyClaimedAlert( entity wp, int bountyAmount, int capturingTeam )
{
	if ( !IsValid( wp ) )
		return

	entity localViewPlayer = GetLocalViewPlayer()
	entity localClientPlayer = GetLocalClientPlayer()

	if ( !IsValid( localViewPlayer ) )
		return

	if ( !IsValid( localClientPlayer ) )
		return

	int localPlayerAlliance = AllianceProximity_GetAllianceFromTeam( localViewPlayer.GetTeam() )

	string teamName = localPlayerAlliance == capturingTeam ? "#PL_YOUR_TEAM" : "#PL_ENEMY_TEAM"
	teamName = Localize( teamName )
	string announcementSFX = localPlayerAlliance == capturingTeam ? CONTROL_SFX_CAPTURE_BONUS_CLAIMED_FRIENDLY : CONTROL_SFX_CAPTURE_BONUS_CLAIMED_ENEMY
	vector announcementColor = localPlayerAlliance == capturingTeam ? CONTROL_OBJECTIVE_GREEN : CONTROL_OBJECTIVE_RED
	int objectiveID = wp.GetWaypointInt( INT_OBJECTIVE_ID )
	string objectiveName = Control_GetObjectiveNameFromObjectiveID_Localized( objectiveID )
	Obituary_Print_Localized( Localize( "#CONTROL_POINT_BOUNTY_CLAIMED_SPECIFIC_OBIT", objectiveName, Localize( teamName ) ), announcementColor )
	AnnouncementMessageRight( GetLocalClientPlayer(), Localize( "#CONTROL_POINT_BOUNTY_CLAIMED_SPECIFIC", objectiveName, teamName ), "", SrgbToLinear( announcementColor / 255 ), $"rui/hud/gametype_icons/control/capture_bonus", CONTROL_MESSAGE_DURATION, announcementSFX, SrgbToLinear( announcementColor / 255 ) )
}
#endif          

#if CLIENT
void function ServerCallback_Control_BountyActiveAlert( entity wp )
{
	if ( !IsValid( wp ) )
		return

	entity localViewPlayer = GetLocalViewPlayer()
	entity localClientPlayer = GetLocalClientPlayer()
	if ( !IsValid( localViewPlayer ) )
		return

	if ( !IsValid( localClientPlayer ) )
		return

	int localPlayerAlliance = AllianceProximity_GetAllianceFromTeam( localViewPlayer.GetTeam() )
	int ownerTeam = wp.GetWaypointInt( CONTROL_INT_OBJ_TEAM_OWNER )
	vector announcementColor = localPlayerAlliance == ownerTeam ? CONTROL_OBJECTIVE_GREEN : CONTROL_OBJECTIVE_RED
	int objectiveID = wp.GetWaypointInt( INT_OBJECTIVE_ID )
	string objectiveName = Control_GetObjectiveNameFromObjectiveID_Localized( objectiveID )

	Obituary_Print_Localized( Localize( "#CONTROL_POINT_BOUNTY_PLACED_SPECIFIC_OBIT", objectiveName ), announcementColor )
	AnnouncementMessageRight( GetLocalClientPlayer(), Localize( "#CONTROL_POINT_BOUNTY_PLACED_SPECIFIC", objectiveName ), "", SrgbToLinear( announcementColor / 255), $"rui/hud/gametype_icons/control/capture_bonus", CONTROL_MESSAGE_DURATION, CONTROL_SFX_CAPTURE_BONUS_ADDED, SrgbToLinear( announcementColor / 255 ) )
}
#endif          

#if CLIENT
bool function Control_Client_IsOnObjective( entity wp, entity player )
{
	return player.GetPlayerNetInt( "Control_ObjectiveIndex" ) == wp.GetWaypointInt( INT_OBJECTIVE_ID )
}
#endif          

#if CLIENT
                                                                                                                    
string function Control_GetObjectiveNameFromObjectiveID_Localized( int objectiveID )
{
	string objectiveName = CONTROL_OBJECTIVE_DEFAULT_NAME
	bool didGetValidObjectiveName = false
	switch ( objectiveID )
	{
		case CONTROL_OBJECTIVE_A_INDEX:
			objectiveName = "#CONTROL_OBJECTIVE_A"
			didGetValidObjectiveName = true
			break
		case CONTROL_OBJECTIVE_B_INDEX:
			objectiveName = "#CONTROL_OBJECTIVE_B"
			didGetValidObjectiveName = true
			break
		case CONTROL_OBJECTIVE_C_INDEX:
			objectiveName = "#CONTROL_OBJECTIVE_C"
			didGetValidObjectiveName = true
			break
	}

	if ( !didGetValidObjectiveName )
		return objectiveName

	return Localize( objectiveName )
}
#endif

  
                                                                                                  
                                                                                                   
                                                                                                 
                                                                                                  
                                                                                                   
                                                                                                  


	               
  


                                                                                                          
                                                                                                                                              
                                                      
string function Control_GetObjectiveNameFromObjectiveID( int objectiveID )
{
	string objectiveName = CONTROL_OBJECTIVE_DEFAULT_NAME
	switch ( objectiveID )
	{
		case CONTROL_OBJECTIVE_A_INDEX:
			objectiveName = CONTROL_OBJECTIVE_A_NAME
			break
		case CONTROL_OBJECTIVE_B_INDEX:
			objectiveName = CONTROL_OBJECTIVE_B_NAME
			break
		case CONTROL_OBJECTIVE_C_INDEX:
			objectiveName = CONTROL_OBJECTIVE_C_NAME
			break
	}

	return objectiveName
}

#if SERVER
                                                                                                                                 
                                                                             
 
	                          
	                    
	 
		                                                       
		 
			                                                              
			 
				                               
					                      
			 
		 

		                           
		 
			                                                            
			                                                             
		 
	 

	                   
 
#endif          

#if SERVER
                                                                                                    
                                                                    
 
	                          
	                    
	 
		                                                                                                                           
		                                                                                                                                                                                            
		                                                     
		                           
	 

	                   
 
#endif          

#if SERVER
                                                                      
                                                                                                 
 
	                                                                   
		      

	                                             
	                                    
		      

	                                                                    
		      

	                        
		      

	                 

	                                                                                                         
	 
		                                                
		 
			                                                          
			                         
			 
				                    
				 
					                                                                                                                                
					                                                
					                                                                                                                            
					                                                                
					                                           
					      
				 
				                                                
				                                                                                                                            
				                                                                
				                                           
			 
		 

		                                                                                                       
			      

		                                                                  

		                                                                                                                                 
		                                               
		
		                                                                                                                            
		                                                                      
		                                                     
		 
			                                               
			 
				                                                                    
			 
			                                                    
			 
				                                                                    
			 
			                                                    
			 
				                                                                    
			 
		 
		                                                          
		 
			                                               
			 
				                                                                    
			 
			                                                    
			 
				                                                                    
			 
			                                                    
			 
				                                                                    
			 
		 

		                                                                          
		 
			                                                                   
			 
				                                                                        
				           
				                                                                        
			 
			    
			 
				                                                                         
			 

			                                             
			 
				                                                                                                                   
					                                                                                                                                             
			 
		 
		                                                                              
		 
			                                                                   
			 
				                                                                        
				           
				                                                                        
			 
			    
			 
				                                                                         
			 

			                                             
			 
				                                                                                                                   
					                                                                                                                                             
			 
		 
		                                                                                                                             
	 
 
#endif          

#if SERVER
                                                                        
                                                           
 
	                                                                        
	 
		                                                    
		                                                                    
			      

		                                                                    
		                 
		                                                                         
		 
			                             
			 
				                                                                   
				 
					                                                                        
					           
					                                                                                     
				 
				    
				 
					                                                                         
				 

				                                       
				                                             
				 
					                                                                                                                   
						                                                                                                                                                          
				 
			 
			                                  
			 
				                                                                   
				 
					                                                                        
					           
					                                                                                     
				 
				    
				 
					                                                                         
				 

				                                       
				                                             
				 
					                                                                                                                   
						                                                                                                                                                          
				 
			 
			                                                                            
		 
	 
 
#endif          

#if SERVER
                                                                       
                                                                                                     
 
	                                                                                                          
		      

	                                                 

	                                                                                     
		                                             

	                                                                                          
	                             
	                                     
	 
		                                                                                                 
			                                
	 

	                                                                                                                                                                                                         
	                   

	                                              
	 
		                       
			        

		                                                                          
			        

		                                                                       
		                                                                                                                                         
		 
			                                                                            
			 
				                                                    
				                                           
					                   
			 
		 
	 

	                              
	 
		                                                    
		 
			                                
			 
				                                              
				                                                        
				 
					                                                                        
					                                                                                                                          
					 
						                                                                
							                                        
					 
				 
				                                                                                                                                                                       
			 
		 
	 
 
#endif          

#if SERVER
                                                                                                                                               
                                                                                          
 
	                                        
	                                                                                                          
		      

	                                      
	                           

	                                              
	 
		                       
			        

		                                                                  
		                                                                                               
		 
			                                                    
			                                           
			 
				                                                                       
				                             
				                                                                       

				                                                                                                      
				 
					                                                                                                  
					                            
				 
				                                                                                                          
				 
					                                                                                                 
					                            
				 
			 
		 

	 
	                                                                                                                           
	                                                                                           

	                                        
	 
		                      
		 
			                                                                                                        
			                                     
			 
				                                                
				 
					                                                          
					                         
					 
						                      
						 
							                                                
							                                                                                                                            
							                                                                
						 
					 
				 
			 
			
			                                                                              
			                             
			              

			                                                                       
			 
				                                                                      
				 
					                                                                                                                                                                           
				 
				    
				 
					                                                                                                                                                                           
				 
			 
			                                                                            
			 
				                                                                      
				 
					                                                                                                                                                                           
				 
				    
				 
					                                                                                                                                                                           
				 
			 
			    
			 
				                                                                      
				 
					                                                                                                                                                                           
				 
				                                                                           
				 
					                                                                                                                                                                           
				 
			 
		 
	 
 
#endif          

                      
#if SERVER
                                                                                       
 
	                               
		      

	                                                                                        
	                                                                                                                           
	                                                                                                                     
	                                                                                         

	                                                                                                                           
	                                                                                                                                                          
	 
		                                                                                         
		                                                                                         
		                                 
		 
			                                                                           
				                  
			                                                                           
				                  
		 

		                              
		                                                                                        
		                                                                                                                  
		 
			                                          
			                                 
			                                                                  
			                                     
			                                                                                   
		 
	 

	                               
		      

	                                                                                    
	 
		                                                                                                                                       
		                                                                                           

		                                                                                          

		                                                
		                                                         
		                                                                                            
		                                                                  
	 
	    
	 
		                                                                       
		                                                          

		                                                                              
		                                                                                                                                
		                                                                                                         

		                                                                                                                                   
		 
			                                                  
		 
	 
 
#endif          
                            


                      
#if CLIENT || SERVER
bool function Control_IsPlayerAbandoning( entity player )
{
	if ( !Control_IsModeEnabled() )
		return false

	if ( !GetCurrentPlaylistVarBool( "control_match_abandon_penalty", true ) )
		return false

	if ( GetGameState() >= eGameState.WinnerDetermined )
		return false

	if ( Control_IsLeavingReasonableForPlayer( player ) )
		return false

	if ( GetGameState() >= eGameState.Prematch && !player.GetPlayerNetBool( "rankedDidPlayerEverHaveAFullTeam" ) )
		return false

	return true
}
#endif                    
                            

                      
#if CLIENT || SERVER
bool function Control_IsLeavingReasonableForPlayer( entity player )
{
	if ( !GetGlobalNetBool( "Control_IsMatchFair" ) )
		return true

	return false
}
#endif                    
                            

#if CLIENT || SERVER
int function Control_GetAbandonPenaltyLength( entity player )
{
	if( !IsValid( player ) )
		return 0

	int numGamesAbandoned = expect int ( player.GetPersistentVar( "numControlAbandons" ) ) + 1

	int banLength
	switch( numGamesAbandoned )
	{
		case 0:
			banLength = 0                         
			break
		case 1:
			banLength = GetCurrentPlaylistVarInt( "control_abandon_penalty_1", 60 * 2 )            
			break
		case 2:
			banLength = GetCurrentPlaylistVarInt( "control_abandon_penalty_2", 60 * 5 )            
			break
		case 3:
			banLength = GetCurrentPlaylistVarInt( "control_abandon_penalty_3", 60 * 10 )              
			break
		case 4:
			banLength = GetCurrentPlaylistVarInt( "control_abandon_penalty_4", 60 * 20 )              
			break
		default:
			banLength = GetCurrentPlaylistVarInt( "control_abandon_penalty_4", 60 * 20 )                                                            
			break
	}

	return banLength
}
#endif                    

#if CLIENT || SERVER
                                                               
array<entity> function Control_GetObjectiveStarterPings()
{
	return file.objectiveStarterPings
}
#endif                    

#if CLIENT || SERVER
                                                                     
int function Control_GetPingCountForObjectiveForAlliance( entity wp, int alliance )
{
	int pingCount = 0

	if ( IsValid( wp ) && wp.GetWaypointType() == eWaypoint.CONTROL_OBJECTIVE )
	{
		if ( alliance == ALLIANCE_A && wp in file.objectiveToPingCountTableAllianceA )
		{
			pingCount = file.objectiveToPingCountTableAllianceA[ wp ]
		}
		else if ( alliance == ALLIANCE_B && wp in file.objectiveToPingCountTableAllianceB )
		{
			pingCount = file.objectiveToPingCountTableAllianceB[ wp ]
		}
	}
	return pingCount
}
#endif                    

#if CLIENT || SERVER
                                                                                                                                                                                 
                                                                                                                                                                                       
entity function Control_GetStarterPingFromTraceBlockerPing( entity pingedEnt, int playerTeam )
{
	entity starterPing = null

	if ( IsValid( pingedEnt ) && pingedEnt.GetScriptName() == CONTROL_OBJECTIVE_SCRIPTNAME && IsValid( pingedEnt.GetOwner() ) )
	{
		array<entity> objectiveStartPings = Control_GetObjectiveStarterPings()

		if ( objectiveStartPings.len() > 0 )
		{
			entity objective = pingedEnt.GetOwner()
			int pingType

			foreach ( ping in objectiveStartPings )
			{
				if ( !IsValid( ping ) )
					continue

				                                                               
				if ( IsValid( ping ) && IsValid( ping.GetParent() ) && IsValid( ping.GetParent().GetOwner() ) )
				{
					entity pingedObjective = ping.GetParent().GetOwner()
					if ( pingedObjective == objective )
					{
						int objectiveWaypointPingType = Waypoint_GetPingTypeForWaypoint( ping )
						bool isPingTeamPlayerTeam = AllianceProximity_GetAllianceFromTeam( playerTeam ) == ping.GetTeam() ? true : false

						if ( isPingTeamPlayerTeam )
						{
							starterPing = ping
							pingType = objectiveWaypointPingType
						}
					}
				}
			}
		}
	}

	return starterPing
}
#endif                    

#if CLIENT
                                                                                            
void function Control_OnPlayerWaypointCreated( entity wp )
{
	if ( IsValid( wp ) && wp.GetWaypointType() == eWaypoint.PING_LOCATION && IsValid( wp.GetOwner() ) )
	{
		entity objectiveWaypoint = wp.GetOwner()

		if ( objectiveWaypoint.GetNetworkedClassName() != PLAYER_WAYPOINT_CLASSNAME )
			return

		if ( IsValid( objectiveWaypoint ) && objectiveWaypoint.GetWaypointType() == eWaypoint.CONTROL_OBJECTIVE && !file.objectiveStarterPings.contains( wp ) )
				file.objectiveStarterPings.append( wp )
	}
}
#endif          

#if CLIENT
                                                                                              
void function Control_OnPlayerWaypointDestroyed( entity wp )
{
	if ( IsValid( wp ) && wp.GetWaypointType() == eWaypoint.PING_LOCATION && IsValid( wp.GetOwner() ) && file.objectiveStarterPings.contains( wp ) )
		file.objectiveStarterPings.fastremovebyvalue( wp )
}
#endif          

#if CLIENT
                                        
void function ServerCallback_Control_UpdateObjectivePingText( entity wp, int pingType, int pingCount, bool doesPlayerHavePingOnObjective )
{
	if ( IsValid( wp ) && IsValid( wp.wp.ruiHud ) && pingCount >= 0 )
	{
		if ( pingType == ePingType.CONTROL_OBJECTIVE_DEFEND || pingType == ePingType.CONTROL_OBJECTIVE_ATTACK )
		{
			                                                                                                   
			string promptText = ""

			if ( pingCount <= 0 )                                                        
			{
				promptText = Localize( "#PROMPT_PING_CONTROL_OBJECTIVE" )
			}
			else                                     
			{
				if ( doesPlayerHavePingOnObjective )
				{
					if ( pingCount == 1 )                                                                                             
					{
						promptText = Localize( "#PROMPT_CANCELED_PING" )
					}
					else                                                                                                          
					{
						promptText = Localize( "#PROMPT_PING_CONTROL_OBJECTIVE_CANCEL", pingCount )
					}
				}
				else                                                                                                                                   
				{
					promptText = Localize( "#PROMPT_PING_CONTROL_OBJECTIVE_JOIN", pingCount )
				}
			}

			promptText = promptText + " `1%ping%`0"
			RuiSetString( wp.wp.ruiHud, "pingPrompt", promptText )
		}
	}
}
#endif          

#if CLIENT
                                                      
void function ServerCallback_Control_UpdateLastPingedObjective( entity pingingPlayer, entity wp, entity pingedEnt, int pingType, bool isDestroying )
{
	entity localPlayer = GetLocalViewPlayer()

	if ( !IsValid( wp ) || !IsValid( pingedEnt ) ||!IsValid( pingingPlayer ) || !IsValid( localPlayer ) )
		return

	if ( pingingPlayer != localPlayer )
		return

	if ( pingType != ePingType.CONTROL_OBJECTIVE_DEFEND &&  pingType != ePingType.CONTROL_OBJECTIVE_ATTACK )
		return

	entity objectiveWaypoint = pingedEnt.GetOwner()
	if ( IsValid( objectiveWaypoint ) && objectiveWaypoint.GetWaypointType() == eWaypoint.CONTROL_OBJECTIVE )
	{
		if ( isDestroying )
		{
			file.lastLocalObjectivePing = null
		}
		else
		{
			file.lastLocalObjectivePing = wp
		}
	}
}
#endif          

#if CLIENT
                                                      
void function ServerCallback_Control_UpdateObjectivePingCounts( entity objectiveWaypoint, int alliance, int count )
{
	if ( IsValid( objectiveWaypoint ) && objectiveWaypoint.GetWaypointType() == eWaypoint.CONTROL_OBJECTIVE )
	{
		if ( alliance == ALLIANCE_A )
		{
			file.objectiveToPingCountTableAllianceA[ objectiveWaypoint ] <- count
		}
		else if ( alliance == ALLIANCE_B )
		{
			file.objectiveToPingCountTableAllianceB[ objectiveWaypoint ] <- count
		}
	}
}
#endif          

#if CLIENT || SERVER
                                                                             
bool function Control_DidPlayerPingSameObjective( entity player, entity wp, entity pingEnt )
{
	if ( !IsValid( pingEnt ) || !IsValid( player ) || !IsValid( wp ) )
		return false

	entity objectiveWaypoint = pingEnt.GetOwner()
	if ( IsValid( objectiveWaypoint ) && objectiveWaypoint.GetWaypointType() == eWaypoint.CONTROL_OBJECTIVE )
	{
		#if CLIENT
			entity oldPing = file.lastLocalObjectivePing
			if ( IsValid( oldPing ) && oldPing == wp )
				return true
		#endif          

		#if SERVER
		                                                
		 
			                                                          
			                                          
				           
		 
		#endif          
	}
	return false
}
#endif                    

#if CLIENT || SERVER
int function Control_GetTeamScore( int team )
{
	int allianceIndex = AllianceProximity_GetAllianceFromTeam( team )
	return GetAllianceTeamsScore( allianceIndex )
}
#endif                    

#if CLIENT || SERVER
                                                                           
int function Control_GetHighestCurrentScore()
{
	int scoreTeam1 = 0
	int scoreTeam2 = 0

	scoreTeam1 = GetAllianceTeamsScore( ALLIANCE_A )
	scoreTeam2 = GetAllianceTeamsScore( ALLIANCE_B )

	return maxint( scoreTeam1, scoreTeam2 )
}
#endif                    

#if CLIENT || SERVER
                                  
                                                                                               
int function Control_GetLeadingAlliance()
{
	int allianceAScore = GetAllianceTeamsScore( ALLIANCE_A )
	int allianceBScore = GetAllianceTeamsScore( ALLIANCE_B )
	return allianceAScore >= allianceBScore ? ALLIANCE_A : ALLIANCE_B
}
#endif                    

#if CLIENT || SERVER
                                                                                                                                        
bool function Control_ShouldUseCatchupMechanics()
{
	bool shouldUseCatchupMechanics = false

	int allianceAScore = GetAllianceTeamsScore( ALLIANCE_A )
	int allianceBScore = GetAllianceTeamsScore( ALLIANCE_B )
	int scoreDifference = maxint( allianceAScore, allianceBScore ) - minint( allianceAScore, allianceBScore )

	if ( scoreDifference >= Control_GetPointDiffForCatchupMechanics() )
		shouldUseCatchupMechanics = true

	return shouldUseCatchupMechanics
}
#endif                    

#if CLIENT || SERVER
                                                                                                     
                                                                                                  
                                                                                                                                   
int function Control_GetMinHeldObjectivesToGenerateScore_ForAlliance( int alliance )
{
	int minNumOwnedObjectivesToGainScore = Control_GetMinHeldObjectivesToGenerateScore()
	return ( minNumOwnedObjectivesToGainScore > 0 && ( !Control_GetIsMinHeldObjectivesOnlyForWinningTeam() || Control_ShouldUseCatchupMechanics() && Control_GetLeadingAlliance() == alliance ) ) ? minNumOwnedObjectivesToGainScore : 0
}
#endif                    


#if SERVER
                                       
                                                             
 
	                                                                                                                                                                                 
	                                                    
		      

	                               
		      

	                           
	                                     
	 
		                                                                         
		 
			                     
		 
	 
	                                                                
 
#endif          

#if SERVER
                                                                                                                                                                          
                                                            
 
	                           
	                                                
		                                                               

	                          
 
#endif          

#if SERVER
                                                                                                                                               
                                             
 
	                                                              

	                               
	 
		                                       
			                                                     
			     

		                                         
			                                                       
			     
	 


	                       
 
#endif          

  
                                                   
                                                    
                                                    
                                                    
                                                    
                                                    


                                                                                            
                                                                                             
                                                                                          
                                                                                          
                                                                                          
                                                                                          

                                                                                               
#if SERVER
                                                                                      
 
	                                        
		      

	                        
	 
		                                        
		                                                       
		                                 
		 
			                                                                                         
			 
				                 
				                                                
			 
		   

		                                                                          
		                                                                             

		                       
		                                                 
			                                               

		                         
		                                         
			                              

		                                                                                                                 
		                                                                                                      
			                                               

		                                                
		                                                                        
	 

	                         
		      

	                                                                  
	 
		                              
		                                            

		                             
		                                                          
		 
			                                                                
				                                     
		 

		                                                                                                                                                     
	 

	                             
	                                                                                                                        
 
#endif          

#if SERVER
                                                               
 
	                                                  
		            

	                                                                   
	                                 
		       	     

	                                                                 
	                                                                
	                                       
		           

	            
 
#endif          

#if SERVER
                                                                                    
                                                                                           
 
	                                               

	           

	                                               
		      

	                               
	 
		                     
		                                                                            
			                                                  

		                                         
			                                                                                                                                    

		                                                           
		                                  
			                                                                                                      

		                                                   
	 
 
#endif          

#if SERVER
                                 
                                                                                         
                                                               
 
	                         
		      

	                                

	                                   
	 
		                                           
		                                                                                             
		                           
		                                 
		 
			                                                                
			                                                                                       
			 
				                                                                         
			 
		 

		                            
		 
			                                                                                                                                                                        
		 
		    
		 
			                                                                                   
		 
		                                      
		                                                                                  
	 

	                                                                                               
	                                                                                      
	                                                              
	                   
	                                      
	 
		                          
			        

		                                                                
		                             
		 
			     
		 
		                                               
		 
			                                                            
			                                                                                                                                    
			                                    
		 
	 

	                           
	                                                                  

	                            
	 
		                        
			                                                                                                                                   
	 


	                                                                   
	                                                                    
	                                                                      
	                                                                                
	                                                                          
	                                                            

	                                                                   
	 
		                                                             
		                                       
		 
			                                                                                                                      
		 
	 

	                                                                     
	 
		                                                              
		                                       
		 
			                                                                                                                      
		 
	 

	                                                                               
	 
		                                                                   
		                                       
		 
			                                                                                                                      
		 
	 

	                                                                         
	 
		                                                                
		                                       
		 
			                                                                                                                      
		 
	 

                     
                                              
   
                                                                      

                          
    
                             
                                                                                                       
     
                                                                          
                                                                                                                           
     
    
   
                           

	                                                                                         
	                                         
	 
		                                        
	 

 
#endif          

#if SERVER
                                                                
                                                                     
 
	                                 
	 
		                                                                                            
		                                                                                                                                  

		                                                                                         
		                                         
		 
			                                        
		 
	 
 
#endif          

#if SERVER
                                                                              
 
	                               
		      

	                                                                                               
 
#endif          

#if SERVER
                                                                             
 
	                               
		      

	                                                                                                          
 
#endif          

#if SERVER
                                             
 
	                                            
		                          

	                          
	                                                        

	                                    
 
#endif          

#if SERVER
                                                   
                                          
 
	                                              
	 
		                          
		                                                     
		                                                        
		                                                                       

		                                      
		 
			                        
			 
				                                                                                                                    
				                                                                   
				 
					                                              
				 

				                                      
				                                                                                          
			 
		 

		                 

		                            
		 
			                             

			                                                                                                  
			                                      
			 
				                                                                                                                  
				 
					                                              
				 
			 
		 
	 
 
#endif          

#if SERVER
                                                                                                                                                                                                                  
                                                                   
 
	                         
		      

	                                                                      
	                                                                   
		                                                                     
	                                                
	                                                                                                       
 
#endif          

#if SERVER
                                                                                                                                                               
                                               
 
	                  
	                             
	 
		                                                                                
	 
	    
	 
		                                                                                      
	 

	                   
 
#endif          

#if SERVER
                                                              
 
	                         
		      

	                               

	                                                        
	                                                                  
	                                                  
	           

	                         
		      

	                                       
	 
		                                               
		                            
		                                                                   
	 

	                                                                                            
 
#endif          

#if SERVER
                                                        
                                               
 
	                          
	                                                                         
	                          
 
#endif          

#if SERVER
                                                             
 
	                         
		      
	                                           
		      

	                                        
		                                               

	                                    
	                                

	                                               
 
#endif          

#if SERVER
                                                         
 
	                                                    
	                                                           
	                                                                                
	                                                 

	                                                                       
	                                                                                                       
	                                                                      

	                                                                                                                                   

	                                                             
		                                                   

	                                                                                            
	                                      
		                                                    
 
#endif          

#if SERVER
                                                     
 
	                      
	 
		                                                                      
		                                                                                         
	 
	    
	 
		                                                                                               

		                                                                                
		                                                                                                                                                       
                      
                         
                            
		                    
		                       
		                       

		                                      
		                                       
		 
			                       
			 
				                                                            
				                      
				 
					                                  
						                                                       
							                 
						     
					                                  
						                                                       
							                 
						     
                         
                                     
                                                                                       
                                              
                       
           
                               
				 
			 
		 

		                                  
		                                       
		 
			                          

			                    
			 
				                          
				                                           
				                                        
				 
					                     
					 
						                               
							              
							     
						                               
							           
							     
						                               
							              
							     
					 
				 
			 
		 

		                                              
		                           
                      
                          
    
                         
                                                                                         
    
                            
		
		                      
		 
			                                          
			 
				                                                                                     
			 
			                             
			 
				                                                                                        
			 
			                             
			 
				                                                                                       
			 
			    
			 
				                                                         
			 
		 
	 
 
#endif          

#if SERVER
                                                                                                                          
                                                                                                                     
 
	                         
		      

	                                                                               
		      

	                                                                    
	                                                                              
		                                                               
	                                                                 
		                                                  

	                                                            
	 
		                                                                                               
		 
			                                                                     
			                                                                                  
		 
		                                                                                                                                                                                                                
		 
			                                                                             
			                                                                              
		 
		    
		 
			                                                                                   
			                                                                        
		 
	 
 
#endif          

#if SERVER
                                                                                                              
                                                                                                                      
 
	                         
		      

	                                                                               
		      

	                                                            
	 
		                                                                                                                                                                                                           
		 
			                                                                                    
			                                                                                              
			                                                                                                                                                                                                
			                                                          

			                                                                    
			                     
				                                
		 
	 
 
#endif          

#if SERVER
                                    
                                                                                      
 
	                                           
		      

	                                                                                                      
	                               
		      

	                                                                          
	                                                                        
		      

	                                                
	                                                                                     
	 
		                                           
		                                             
		                                                                                                            
		                                                                                                                 
		                                                                     
		                                                                                                 
		                                                                                                       
	 
 
#endif          

#if SERVER
                                                                              
 
	                         
		      

	                                                           
	                                                                                                       

	                                        
	                                                                                             
		      

	                            
	                         
		      

	             
	                                                       
 
#endif          

#if SERVER
                                                                                        
 
	                                               

	                                 

	                                                                    
		                                                                                
	   
 
#endif          

#if SERVER
                                    
                                                                                                        
 
	                                                                                                                                                                                           

                     
                                                                  
                              
                           

	                           
	 
		                                                     
		                                                         
		                                                                                                                       
	 
 
#endif          

#if SERVER
                                                                                                                        
                                                                                                                                                                                                                         
                                                                                                           
 
	                               
	                                                         

	                                                                      
	                                                                                                                                                                   
	                                        
		      

	       
		                                                                                                       
	             

	                                                                        
	                                                                          
	                                                                                                      
	                                                                 

	                                                                                                                   
	                                                                        
	 
		                                                                       
		                                         

		                                                                                                                                                             
		                                                         
		 
			                                                   
		 
		    
		 
			                                                                                                  
			                                   
		 

		               

		                                                            
		                   
		 
			                                        
			                      
				                                    

			                                          
		 

		                                                                                                   
		                                                                                                                      
		 
			                                                                                                  
			                                   

			                                          
		 

	 

	                                                                                               
		      

	                                                                      
	                                                                                                                                                                   
	                                        
		      

	                                                    
	                                                        
	                                                                                                                                                     

                     
                                                                  
                              
                           

	                                                                                                       
	                           
	 
		                    
		                                                                 
		 
			                                                                  
		 
		                                                                       
		 
			                                                                                                                                                               
			 
				               
			 
			    
			 
				                                                                                
			 
		 

                      
                                                                   
    
                                                                   
    
                            

		                                                                                                                              
		              
		 
			                                                 

			                                                            
				                                                              

			                                                                                                                                                                                          
			                                           
				                                           
			                                             
				                                             
			                                                                                                            

		 
		    
		 
			                                                              

			                                                             
				                                                   

			                                                                                                                                                          
			                            
			                                 
				                                      

			                                                                                                                   
			                                                                           

			                                                                      
			                                                                                                       
			      
		 
	 
	                                                                       
	                                                     
 
#endif          

#if SERVER
                                                         
 
	            
 
#endif          

#if SERVER
                                                        
 
	                                                        
 
#endif          

#if SERVER
                                         
                                                                                                                                         
 
	                           
		                                   

	                                  
	                                                                
	                                                              
	                                                        

	                                                                           
	                                                    
	 
		                                        
		                      
			                                    

		                                          
	 

	                             
	                                               

	                                         
	 
		                                                                            
		                                                    
		                                                                                                                           
	 

	                                           

	                                                                                                                 
	                          
	 
		                                    
		                                   
		                                                  
		                                
		   
		  	                                                                                              
		  	                                                
		  	                                                                                 
		  	                             
		  
		  	       
		  	                                                                                                                           
		  	                                                                                                       
		  	                                                                                                                 
		   

		              
		                              
			                                                
		                                              
		                       

		                                      

		                              
		 
			                                                          
		 

		                         
			                                                  
	 

	                                                                                                                                                  
	                                                                            
		                                                  
 
#endif          

#if SERVER
                                                                      
 
	                                               

	           

	                         
		      

	                                                            
	                                                              
	                     

	                                                                                                                
	                                              
 
#endif          

#if SERVER
                                                                                                                                                             
                                                                                                                                                                                                                                                    
                                                         
 
	                                               

	                         
		      

	                                           
		      

	                                                               
	                               
	                                                                             

	                               
	                             
	                                         

	            
	                           
	 
		            
	 
	 

	                                                          
	                     
	                                                
	 
		                                   
		                                                           

		                                                                                                                                            
                               
         
                                                                
             
                                                          
                                                                           
             
         
            
         
                                                               
             
                                                                     
                                                                           
             
         

		           
	 
 
#endif          

#if SERVER
                                                                   
                                                                   
 
	                                                                                         
		      

	                                                                                                                          
	                                                 
	 
		                                                                  
		 
			                                  
			                                                                        
			                                                             
			                                                          
		 
	 
	    
	 
		                                                           
	 
 
#endif          

#if SERVER
                                                                                 
 
	                         
		      

	                                  
	                                            

	                                                                                              
	                          

	               
	                                         

	                                                                                                               
	                                                                  
	 
		                              
		                                                                    
	 
 
#endif          

#if SERVER
                                                             
 
	                                        
 
#endif          

#if SERVER
                                                      
 
	           

	                         
		      

	                                           
	                                     
		      

	                                                                       
	 
		                                  
		                   
		                 
		                      
	 
 
#endif          

#if SERVER
                                                        
 
	                                                                                     
	                    
	                    
	                                                    
	                                   
	 
		                                                                                                                                                              
		 
			                          
			                                                    
		 
	 

	                              
	 
		                                                                        
			                                                                     
			                                                                     

			                    
				         
			                         
				        

			        
		   
	 
 
#endif          

#if SERVER
                                                                                                                                      
 
	                         
		            

	                                                                      
	                                                                                                                                                                   
	                                        
		            

	                          
	                                                                                        

	                                  
		                                                                                                                                

	                                                                                                                                         

	                                    
	 
		                          
	 
	    
	 
		                     
	 

	                                                                        

	                         
	 
		                                                 
		                                                 

		                                                
		                                              
		                       
		                                                                                                                                                          
		                                                                                                                                             
	 
	    
	 
		            
	 

	           
 
#endif          

#if SERVER
                                                                                                                            
 
	                                            
		            

	                                                                      
	                                                                                                                                                                   
	                                        
		            

	                                                                                             
	                                                                                              

	                                                                                                    

	                                       
	                                                                              
	                               
	                             
	 
		                                           
		 
			                                               
			                                                        
			 
				                          
				                                 
				                                                                                            
				                                                                                                                       
				        
			 

			                                                         
			 
				                                    
				                                 
				                                                                                            
				                                                                                                                        
				        
			 

			                                                                   
			                                                                                          
			                                                                                                                     
		 
		    
		 
			                                                                     
			                                 
			                                                                                          
			                                                                                                
		 
	 

	                                               

	                         
	                                                                                       

	                                    
	 
		                            
	 
	    
	 
		                       
	 

	                             
	 
		                                    
		                                           
		                                           

		                                                                          
		 
			                                                                                                   
			                                     
		 

		                                                                                                                                              
	 
	    
	 
		            
	 

	           
 
#endif          

                    
          
                                                                               
 
                                 
              

                                                                       
                                                                                                                                                                    
                                         
              

                                              
                                          
                      
                      
                             
                                

                                                                                      
  
                                               

                                  
                                                                                            
                                                
                                                                                                                                           
                                
                                                                                  
                                                 
   
                                                     
                       

                          
    
           
                                                    
          
           
                                                    
          
           
                                                    
          
           
                                                    
          
    

                                                 
    
                                                                                            
                                                                                
                                                                                                                                                                                      
                
    

                               
                                                            

                                            
                                                       

                                                                                                                
          
                                                                                                       
                

                           
            

                                                                                         
              
   
  

                                                                                                                          

                                    
              

                                                     
                                                                                        

                      
                         

                                                                                             
                                                                                                       

            
 
                
                          

#if SERVER
                                                                
 
	                                               

	                                           
		      

	                             
	                               

	                                     

	            
		                       
		 
			                              
				                                      
		 
	 

	                                
	                                         

	                                                      
	        

	                                                                                               
	                                                   
	 
		                                                                                                                      
		        
	 
 
#endif          

#if SERVER
                                                                               
 
	                                               

	           

	                                                       
		                         
			      

		       
			                         
			 
				                      
				                                                                                                    
				                                                                                     
			 
		             
	   

	                             
	                               

	                                             

	       

	                       
	                                                                                                      
 
#endif          

#if SERVER
                                                                                                        
                                                                                           
 
	       
		                                                          
	             
	                                
	 
		                                                  
		 
			                                                                                                                              
  			                                                            
  			 
	  			       
	  				                    
	  					                                                                                                                                          
	  			      
  				            
  			 
			       
				                    
					                                                                                                                                         
			             

			        
		 
		       
			                    
				                                                                                                                                           
		             
		            
	 
	           
 
#endif          

#if SERVER
                                                                                                          
 
	       
		                                                          
	             

	                         
	                                
	 
		                                  
			     

		                                                  
		 
			                                                                                                                              
  			                                                            
  			 
	  			       
	  				                    
	  					                                                                                                                                          
	  			      
  				                           
  			 
			       
				                    
					                                                                                                                                         
			             

			        
		 
		       
			                    
				                                                                                                                                           
		             

		                           
	 
	                  
 
#endif          

#if SERVER
                                                                                                        
                                                                           
 
	                             
	 
		                              
		  	                                                       
		            
	 

	                                                                      
	                                           
	 
		            
	 

	                                                        
	 
		                              
		  	                                                              
		            
	 

	                                                                                        
	                              
	 
		                              
		  	                                                    
		            
	 

	                                                      
	 
		            
	 

	                                                              
	 
		                              
		  	                                                        
		            
	 

	           
 
#endif          

#if SERVER
                                                                                      
 
	                             
	 
		                              
		  	                                                       
		            
	 

	                                                        
	 
		                              
		  	                                                              
		            
	 

	                                                      
	 
		            
	 

	                                                              
	 
		                              
		  	                                                        
		            
	 

	                                                                      
 
#endif          


                                                              
  
          
                                                                                                              
 
	                            
		            

	                                                

	                                             
	                                     
	                     
	                      

	                                                                            

	                 
	 
		                     
		 
			                
			                
		 
		    
		 
			               
		 
	 
	    
	 
		                     
			                
	 

	                            
	                               
	                                                                        
		                                

	                                                     
	                                                           
		            

	       
		                                                                     
	             

	                 

	                 
	 
		                                                                                                 
		                                              
			          
			              
			          
			               
			      
			   
			          
		                                   
			            

		                                                               
	 
	    
	 
		                                              
			          
			       
			          
			               
			      
			   
			          
		                                   
			            

		                              
	 

	                                                                   
	                                          

	                                 
	                 
		                                  
	    
		                                 

	                                                                    
	           
 
                

          
                                                                                              
 
	                
	                                
	                                                                                        
	                                                                 
	                          
	                                                   
	                                

	                             
	                                                 
	                                      
	                                                                     

	             
	                             
	                                                                                             

	                                                                               
	                                                                                           
	                                                                            
	                              
	                                           

	                                                                                                                            
	                                     
	                                                  

	                                     

	                                   
	                                         
	                                                 
	                                                                             

	                                                              
	                                                                                              

	                                        

	                           
	                                                        
	                                                                                                                            
	                                                                            
	                                                                    
	                                   
	                          
	                          
	                                           
	                                  

	                             
	                                                  
	                                  
	                                             
	                                    

	                     
	                        
	                                           
	                                             

	            
		                                                                        
		 
			                     
			                                                                 
			                      

			                                 
				                         

			                        
			 
				                                                    
				                                            

				                                       
					                                
				                                                  
					                                     

				                                                              
				                                                          
				                          
				                    
				                                   
				                          

				                                                                                                 
			 
		 
	 

	                                                            

	        
	                               

	                        
		                                     

	                                       
	                                        
	                                  
	                                          
	                                            
	                

	                        
		                                                                          
 
                

          
                                                                                                                    
 
	                     
	                                   

                                                                               
	                         
	                     

	                     
	                           
	                                                        
	                                                          
	                                                          
	                                                                       

	                                     
	                            
	                            
	                                            
	                                    

	            
		                                                                    
		 
			                                                    
				                        

			                                                                                         
			                                       

			                                                                                
			                  
		 
	 

	                            

	                                          
	        

	                                  
	                       
	                       
	                                              
	                                            
	                       

	                                       

	                                  

	                              
	                  
	                                                                  
	                                                 
	                                                 
 
                

          
                                                                                                         
 
	                             
	                          

	                                 
	                                                                        
	                                                                        

	                                 
	 
		                                         
			                                                            
		    
			                                                         
	 

	                                 
		                                                                                               
	                              
		                                                                                           

	                                                                    
	                                                              

	                                                            
	                                                                      

	                                                                                             

	                         
 
                

          
                                                                                           
 
	                         
		            

	                                                                      
	                                                                                                                                                                   
	                                        
		            

	                          
	                                                                                        

	                                  
		                                                                                                                                

	                    
	                                                         
	                                                          
	                 

	                                 
	                                 
	                                          

	              	               

	                                                                  

	       
		                                                                                               
	             

	                   
	 
		                                                  
		                                                                                                                                 
		                           

		                                                                                                                

		                                                                                     
		                                                                                            

		                                    
		 
			                                                     
			                                   
			 
				       
					                                                         
				             

				        
			 
			                                                                   
			 
				       
					                                                             
				             

				        
			 
			                                                                                       
			 
				       
					                                                                                         
				             

				        
			 

			                                
		 
	 

	                 
	                                                            

	                                 
	 
		                 
		                           
		                           
		                                    
		 
			                                                 
			 
				                  
				                     
				     
			 
		 

		                     
			                       
		    
			                              
	      
	 
		                                                                                             
		            
	 

	                                                           

	                               

	                                    
	                                 
	                       

	           
 
                

          
                                                                               
 
	                               
	                              

	                                          
	                                                          
	                                                                                                                                                                                          
	                                  
	 
		           
	 

	            
 
                

          
                                                                                                                
 
	                                                                                                                 
	                                           
	                                                 
	                   
	                                                                                                     

	                  
	                        
		              

	             
 
                

          
                                                                                                                                 
 
	                       

	                                                                                              
	                                
	 
		       
			                 
				                               
		             
		            
	 

	                                                                                                    
	                                                                                                   
	                                                    
	 
		       
			                 
			 
				                                                                  
				                                                               
				                                        
			 
		             
		            
	 

	       
		                 
		 
			                   
			 
				                                                              
				                                                                  
			 
			    
			 
				                               
			 
		 
	             
	           
 
                

  

                    
          
                                                               
 
                                                      
 
                
                          

                    
          
                                                                   
 
                                                                                         

                                                                       
                                                                             
                                                     
                                  

             
                           
   
                                                                         
   
  

              
 
                
                          

                    
          
                                                            
 
                                                   
 
                
                          

#if SERVER
                                                          
 
	                                                                       
	                                                                   
	 
		                                                                
		                                                                                                   
			                    
	 

	                            
 
#endif          

#if SERVER
                                                                                                  
 
	                                                                         
	                                                                 
 
#endif          

#if SERVER
                                                                                       
 
	                
	                                                                                    
	                               
		                                                   
	    
		                                                           

	                
 
#endif          

#if SERVER
                                                                        
 
	                           
		      

	                                                     

	                                 
	 
		                                                                                                                 
		 
			       
				                                                                                        
			             

			                                                          
			                                                         
		 
	 
 
#endif          

#if SERVER
                                                                                  
 
	                                               

	                               
	                                 

	            
		                                       
		 
			                                  
		 
	 

	                                                  
 
#endif          

#if SERVER
                                                                   
 
	                                               

	                                                                                                

	                               
	                                 

	            
		                                       
		 
			                                           
		 
	 

	                                                  
 
#endif          

#if SERVER
                                           
 
	                         
		      

	                                                 
	                                                                                                      
 
#endif          

#if SERVER
                                                                
                                                                                                        
 
	                         
		      

	                                     
	 
		                                 
		                                                             
		 
			                                                                                                                                                            
			 
				                                                                                                                                                           
			 
		 
	 
 
#endif          

  
                                                                                                                                                         
                                                                                                                                                          
                                                                                                                                                       
                                                                                                                                                       
                                                                                                                                                       
                                                                                                                                                       


                       
  


#if CLIENT
void function Control_OnPlayerSentSpawnRequest( entity player, entity wp )
{
	int respawnChoice = -1

	if ( wp.GetWaypointInt( INT_WAYPOINT_TYPE ) == CONTROL_WAYPOINT_BASE0_INDEX || wp.GetWaypointInt( INT_WAYPOINT_TYPE ) == CONTROL_WAYPOINT_BASE1_INDEX )
	{
		respawnChoice = eControlPlayerRespawnChoice.SPAWN_AT_BASE
	}
	else if ( wp.GetWaypointInt( INT_WAYPOINT_TYPE ) == CONTROL_WAYPOINT_POINT_INDEX )
	{
		respawnChoice = eControlPlayerRespawnChoice.SPAWN_ON_POINT
	}
	else if ( wp.GetWaypointInt( INT_WAYPOINT_TYPE ) == CONTROL_WAYPOINT_PLAYER_INDEX )
	{
		respawnChoice = eControlPlayerRespawnChoice.SPAWN_ON_SQUAD
	}

                     
                                                                             
                                                           
                           

	#if DEV
		printf( "CONTROL: Sending spawn request from " + wp.GetTargetName() + " of type " + respawnChoice )
	#endif       

	entity entityToSpawnOn = null
	if ( respawnChoice == eControlPlayerRespawnChoice.SPAWN_ON_SQUAD )
		entityToSpawnOn = wp.GetParent()              

	if ( respawnChoice == eControlPlayerRespawnChoice.SPAWN_ON_POINT )
		entityToSpawnOn = wp.GetParent()                 

                     
                                                                  
                                                     
                           

	Control_SendRespawnChoiceToServer( respawnChoice, entityToSpawnOn )
}
#endif          

#if CLIENT
void function Control_WaypointCreated_Spawn( entity wp )
{
	thread Control_ManageRespawnWaypoint_Thread( wp )
}
#endif          

#if CLIENT
void function Control_ManageRespawnWaypoint_Thread( entity wp )
{
	Assert( IsNewThread(), "Must be threaded off" )

	if ( !IsValid( wp ) )
		return

	if ( Waypoint_GetPingTypeForWaypoint( wp ) != ePingType.SPAWN_REGION )
		return

	while ( IsValid( wp ) && wp.wp.ruiHud == null )
		WaitFrame()

	if ( !IsValid( wp ) )
		return

	int waypointType
	if ( Waypoint_GetPingTypeForWaypoint( wp ) == ePingType.SPAWN_REGION )
	{
		RuiSetFloat( wp.wp.ruiHud, "maxDrawDistance", 50000 )
		RuiSetBool( wp.wp.ruiHud, "displayDistance", false )
		RuiSetBool( wp.wp.ruiHud, "alwaysShowLargeIcon", true )

		waypointType = wp.GetWaypointInt( INT_WAYPOINT_TYPE )
		if ( waypointType == CONTROL_WAYPOINT_BASE0_INDEX || waypointType == CONTROL_WAYPOINT_BASE1_INDEX )
		{
			RuiSetImage( wp.wp.ruiHud, "outerIcon", CONTROL_WAYPOINT_BASE_ICON )
		}
		else if ( waypointType == CONTROL_WAYPOINT_POINT_INDEX )
		{
			RuiSetImage( wp.wp.ruiHud, "outerIcon", CONTROL_OBJ_DIAMOND_YOURS )
		}
		else if ( waypointType == CONTROL_WAYPOINT_PLAYER_INDEX )
		{
			RuiSetImage( wp.wp.ruiHud, "outerIcon", CONTROL_WAYPOINT_PLAYER_ICON )
		}

                      
                                                    
                                                                 
                            

		file.spawnWaypoints.append( wp )
	}

	int waypointEHI = wp.GetEncodedEHandle()
	wp.EndSignal( "OnDestroy" )

	OnThreadEnd( function() : ( wp, waypointEHI )
	{
		RunUIScript( "ClearWaypointDataForUI", waypointEHI )
		file.spawnWaypoints.fastremovebyvalue( wp )
	} )

	entity parentObjective
	if ( waypointType == CONTROL_WAYPOINT_POINT_INDEX )
		parentObjective = wp.GetParent()

	while ( true )
	{
		WaitFrame()

		if ( !GetLocalClientPlayer().GetPlayerNetBool( "Control_IsPlayerOnSpawnSelectScreen" ) )
		{
			RuiSetBool( wp.wp.ruiHud, "isHidden", true )
			continue
		}

		if ( waypointType == CONTROL_WAYPOINT_POINT_INDEX )
		{
			int owner = parentObjective.GetWaypointInt( CONTROL_INT_OBJ_TEAM_OWNER )
			if ( AllianceProximity_GetAllianceFromTeam( GetLocalClientPlayer().GetTeam() ) == owner )
				RuiSetBool( wp.wp.ruiHud, "isHidden", false )
			else
				RuiSetBool( wp.wp.ruiHud, "isHidden", true )
		}

		if ( waypointType == CONTROL_WAYPOINT_PLAYER_INDEX )
		{
			entity playerOwner = wp.GetParent()
			if ( IsValid( playerOwner ) && IsAlive( playerOwner ) && BleedoutState_GetPlayerBleedoutState( playerOwner ) == BS_NOT_BLEEDING_OUT  )
				RuiSetBool( wp.wp.ruiHud, "isHidden", false )
			else
				RuiSetBool( wp.wp.ruiHud, "isHidden", true )
		}

                      
                                                    
                                                 
                            
	}
}
#endif          

#if CLIENT
                                                            
void function Control_SendRespawnChoiceToServer( int respawnChoice, entity entityToSpawnOn )
{
	if ( GetLocalClientPlayer() != GetLocalViewPlayer() )
		return

	if ( !GetLocalClientPlayer().GetPlayerNetBool( "Control_IsPlayerOnSpawnSelectScreen" ) )
		return

	Remote_ServerCallFunction( "ClientCallback_Control_ProcessRespawnChoice", respawnChoice, entityToSpawnOn )
}
#endif          

#if CLIENT
void function ServerCallback_Control_ShowSpawnSelection()
{
	entity player = GetLocalClientPlayer()
	if ( IsValid( player ) && player.GetPlayerNetBool( "Control_IsPlayerOnSpawnSelectScreen" ) )
	{
		Control_UpdatePlayerExpPercentAmountsForSpawns( player )

		#if DEV
			printf( "CONTROL: opening spawn menu from connection callback" )
		#endif       

		RunUIScript( "UI_OpenControlSpawnMenu", false )
		RunUIScript( "ControlSpawnMenu_SetLoadoutAndLegendSelectMenuIsEnabled", true )

		Control_SetWaveSpawnTimerTime()

		thread Control_CameraInputManager_Thread( player )
	}
}
#endif          

#if CLIENT
                                                              
void function ServerCallback_Control_UpdateSpawnWaveTimerTime()
{
	Control_SetWaveSpawnTimerTime()
}
#endif          

#if CLIENT
void function UICallback_Control_OnResolutionChanged()
{
	entity player = GetLocalClientPlayer()
	if ( !IsValid( player ) )                                        
		return

	if ( !Control_IsModeEnabled() )
		return

	if ( !player.GetPlayerNetBool( "Control_IsPlayerOnSpawnSelectScreen" ) )
		return

	if ( IsUsingLoadoutSelectionSystem() )
		LoadoutSelection_RefreshAllUILoadoutInfo()

	#if DEV
		printf( "CONTROL: opening spawn menu from resolution changed callback" )
	#endif       

	RunUIScript( "UI_OpenControlSpawnMenu", false )

	thread Control_CameraInputManager_Thread( player )
	Control_SetWaveSpawnTimerTime()
}
#endif          

#if CLIENT
void function ServerCallback_Control_ProcessImmediatelyOpenCharacterSelect()
{
	file.shouldImmediatelyOpenCharacterSelectOnRespawn = true
}
#endif          

#if CLIENT
void function ServerCallback_Control_OnPlayerChoosingRespawnChoiceChanged( entity player, bool new )
{
	if ( !IsValid( player ) )
		return

	if ( player != GetLocalClientPlayer() )
		return

	if ( GetGameState() >= eGameState.WinnerDetermined )                                              
		return

	var gameStateRui = ClGameState_GetRui()

	if ( !new )                                       
	{
		RunUIScript( "UICodeCallback_CloseAllMenus" )
		Control_DeregisterModeButtonPressedCallbacks()
		Obituary_SetEnabled( true )                      
		RuiSetBool( gameStateRui, "isRespawning", false )
		player.Signal( "Control_PlayerHasChosenRespawn" )
	}

	if ( new )                                      
	{
		if ( !player.IsBot() )
		{
			player.Signal( "Control_PlayerStartingRespawnSelection" )
			player.Signal( "Bleedout_StopBleedoutEffects" )

			thread Control_CameraInputManager_Thread( player )
			thread Control_UIManager_Thread( player )
		}

		thread function()
		{
			if ( file.shouldImmediatelyOpenCharacterSelectOnRespawn )
			{
				wait 0.1

				Control_OpenCharacterSelect()
				file.shouldImmediatelyOpenCharacterSelectOnRespawn = false
			}
		}()
	}
}
#endif          

#if CLIENT
void function CreateRespawnBlur(){
	if(file.respawnBlurRui == null)
		file.respawnBlurRui = CreateFullscreenRui( $"ui/control_respawn_screen_blur.rpak" )
}
#endif          

#if CLIENT
void function DestroyRespawnBlur(){
	if ( IsValid( file.respawnBlurRui  ) )
		RuiDestroyIfAlive( file.respawnBlurRui )

	file.respawnBlurRui = null
}
#endif          

#if CLIENT
void function UICallback_Control_UpdatePlayerInfo( var elem )
{
	thread Control_UpdatePlayerInfo_thread( elem )
}
#endif          

#if CLIENT
void function Control_UpdatePlayerInfo_thread( var elem )
{
	Assert( IsNewThread(), "Must be threaded off" )

	entity localPlayer = GetLocalClientPlayer()
	localPlayer.EndSignal( "Control_PlayerHasChosenRespawn" )

	while( IsValid( elem ) )
	{
		entity player = GetLocalClientPlayer()

		ItemFlavor character = LoadoutSlot_WaitForItemFlavor( ToEHI( player ), Loadout_Character() )

		var rui = Hud_GetRui( elem )

		if ( !IsValid( rui ) )
			break

		RuiSetImage( rui, "playerPortrait", CharacterClass_GetCharacterLockedPortrait( character ) )
		RuiSetString( rui, "playerName", player.GetPlayerName() )
		RuiSetInt( rui, "micStatus", GetPlayerMicStatus( player ) )

		WaitFrame()
	}
}
#endif          

#if CLIENT
void function ServerCallback_Control_TransferCameraData( vector cameraPosition, vector cameraLookDirection )
{
	entity player = GetLocalClientPlayer()

	file.cameraLocation = cameraPosition
	file.cameraLookDirection = cameraLookDirection

	if ( IsValid( player ) )
	{
		player.Signal( "Control_NewCameraDataReceived" )

		if ( player.GetPlayerNetBool( "Control_IsPlayerOnSpawnSelectScreen" ) )
			thread Control_CameraInputManager_Thread( player )
	}
}
#endif          

#if CLIENT
void function ServerCallback_PlayMatchEndMusic_Control( int victoryCondition )
{
	                                                                                                                              
	                                                                                  

	entity clientPlayer = GetLocalClientPlayer()
	if ( !IsValid( clientPlayer ) )
		return

	if ( clientPlayer.GetTeam() == GetWinningTeam() )
	{
		EmitSoundOnEntity( clientPlayer, CONTROL_SFX_GAME_END_VICTORY )

		if ( victoryCondition == eControlVictoryCondition.LOCKOUT )
		{
			EmitSoundOnEntity( clientPlayer, "Music_Ctrl_LockOut_Victory" )
		}
		else if ( victoryCondition == eControlVictoryCondition.SCORE )
		{
			EmitSoundOnEntity( clientPlayer, "Music_Ctrl_RampUp_Victory" )
		}
	}
	else
	{
		EmitSoundOnEntity( clientPlayer, CONTROL_SFX_GAME_END_LOSS )

		if ( victoryCondition == eControlVictoryCondition.LOCKOUT )
		{
			EmitSoundOnEntity( clientPlayer, "Music_Ctrl_LockOut_Loss" )
		}
		else
		{
			EmitSoundOnEntity( clientPlayer, "Music_Ctrl_RampUp_Loss" )
		}
	}
}
#endif          

#if CLIENT
void function ServerCallback_PlayPodiumMusic()
{
	entity clientPlayer = GetLocalClientPlayer()
	if ( IsValid( clientPlayer ) )
		EmitSoundOnEntity( clientPlayer, "Music_Ctrl_Podium" )
}
#endif          

#if CLIENT
void function ControlMenu_HandleInput( float x, float y, float zoom, bool shouldEase = true )
{
	float processedX = x
	float processedY = y
	float processedZoom = zoom

	                    
	                                         
	                                         

	if ( fabs( processedX ) < 0.15 )
		processedX = 0.0
	if ( fabs( processedY ) < 0.15 )
		processedY = 0.0
	if ( fabs( processedZoom ) < 0.15 )
		processedZoom = 0.0

	if ( shouldEase )
	{
		processedX    = Control_CubicEase( processedX )
		processedY    = Control_CubicEase( processedY )
		processedZoom = Control_CubicEase( processedZoom )
	}

	ControlMenu_ReceiveInputContext( processedX, processedY, processedZoom, shouldEase )
}
#endif          

#if CLIENT
float function Control_CubicEase( float val )
{
	return val * val * val
}
#endif          

#if CLIENT
void function ControlMenu_ReceiveInputContext( float xInput, float yInput, float zoomInput, bool shouldEase = true )
{
	if ( !IsValid( file.cameraMover ) )
		return

	float lateralBoundaryDelta = 4000
	float zoomBoundaryDelta
	if ( zoomInput > 0 )
		zoomBoundaryDelta = 14000
	else
		zoomBoundaryDelta = 4000

	vector defaultCameraPosition = file.cameraLocation
	vector currentCameraPosition = file.cameraMover.GetOrigin()

	vector cameraAngles = file.cameraMover.GetAngles()
	vector cameraForward = Normalize( file.cameraMover.GetForwardVector() )
	vector cameraRight = Normalize( file.cameraMover.GetRightVector() )
	vector cameraUp = Normalize( file.cameraMover.GetUpVector() )

	float rightScalar = 1.0
	float upScalar = 1.0
	float zoomScalar = 1.0

	float processedX = xInput
	float processedY = yInput

	if ( fabs( zoomInput ) > 0.0 )
	{
		                             
		vector cursorPosition = ConvertCursorToScreenPos()
		UISize screenSize     = GetScreenSize()
		vector cursorDelta    = <screenSize.width / 2.0, screenSize.height / 2.0, 0.0> - cursorPosition

		processedX += -9 * ( cursorDelta.x / screenSize.width ) * ( IsControllerModeActive() || zoomInput >= 0 ? 1.0 : -1.0 )
		processedY += -5 * ( cursorDelta.y / screenSize.height ) * ( IsControllerModeActive() || zoomInput >= 0 ? 1.0 : -1.0 )

		if ( IsControllerModeActive() )
		{
			processedX *= 0.6
			processedY *= 0.6
		}
	}

	                               
	vector deltaVector = currentCameraPosition - defaultCameraPosition

	float deltaOnRight = cameraRight.Dot( deltaVector )
	if ( fabs( deltaOnRight ) >= lateralBoundaryDelta && deltaOnRight * processedX > 0 )
		rightScalar = 0.0

	float deltaOnUp = cameraUp.Dot( deltaVector )
	if ( fabs( deltaOnUp ) >= lateralBoundaryDelta && -1 * deltaOnUp * processedY > 0)
		upScalar = 0.0

	float deltaOnForward = cameraForward.Dot( deltaVector )
	if ( fabs( deltaOnForward ) >= zoomBoundaryDelta && deltaOnForward * zoomInput > 0)
		zoomScalar = 0.0

	vector pos = currentCameraPosition
	pos += processedX * cameraRight * 500 * rightScalar
	pos += processedY * cameraUp * -500 * upScalar
	pos += zoomInput * cameraForward * 500 * zoomScalar

	file.cameraMover.NonPhysicsMoveTo( pos, 0.2, 0.0, 0.075 )
}
#endif          

#if CLIENT
void function UICallback_ControlMenu_MouseWheelUp()
{
	                                             
}
#endif          

#if CLIENT
void function UICallback_ControlMenu_MouseWheelDown()
{
	                                              
}
#endif          

#if CLIENT
void function Control_UIManager_Thread( entity player )
{
	Assert( IsNewThread(), "Must be threaded off" )

	var gameStateRui = ClGameState_GetRui()

	CreateRespawnBlur()
	Control_UpdatePlayerExpPercentAmountsForSpawns( player )

	if(file.firstTimeRespawnShouldWait)
	{
		                                
		wait CONTROL_INTRO_DELAY
	}

	RunUIScript( "UI_OpenControlSpawnMenu", false )
	RunUIScript( "ControlSpawnMenu_SetLoadoutAndLegendSelectMenuIsEnabled", true )
	RuiSetBool( gameStateRui, "isRespawning", true )
	Control_SetWaveSpawnTimerTime()

	                                                           
	Obituary_ClearObituary()
	Obituary_SetEnabled( false )

	if(file.firstTimeRespawnShouldWait)
	{
		file.firstTimeRespawnShouldWait = false

		                                                                                            
		if ( IsUsingLoadoutSelectionSystem() )
		{
			                                                                     
			RunUIScript( "LoadoutSelectionMenu_OpenLoadoutMenu", false )
		}
	}

}
#endif          

#if CLIENT
void function Control_CameraInputManager_Thread( entity player )
{
	Assert( IsNewThread(), "Must be threaded off" )

	player.EndSignal( "Control_NewCameraDataReceived" )
	player.EndSignal( "Control_PlayerStartingRespawnSelection" )
	player.EndSignal( "Control_PlayerHasChosenRespawn" )
	player.EndSignal( "Control_PlayerHideScoreboardMap" )

	file.isPlayerInMapCameraView = true

	vector cameraPosition = file.cameraLocation
	vector cameraAngles = VectorToAngles( file.cameraLookDirection )

	entity cameraMover = CreateClientsideScriptMover( $"mdl/dev/empty_model.rmdl", cameraPosition, cameraAngles )
	entity camera      = CreateClientSidePointCamera( cameraPosition, cameraAngles, 70.0 )
	player.SetMenuCameraEntity( camera )
	camera.SetTargetFOV( 70.0, true, EASING_CUBIC_INOUT, 0.0 )
	camera.SetParent( cameraMover, "", false )

	file.cameraMover = cameraMover

	OnThreadEnd(
		function() : ( player, camera, cameraMover )
		{
			                                                  

			if ( IsValid( player ) )
				player.ClearMenuCameraEntity()
			file.cameraMover = null
			if ( IsValid( camera ) )
				camera.Destroy()
			                                       
			                               
			  	                     

			file.isPlayerInMapCameraView = false
		}
	)

	                                                                                      
	                                                        
	                            

	              
	 
		                                                        
		                          
		                                              

		                               
		 
			                    
			                                            
			                                            
			                        
			                                                                                              
			                                                  
		 
		    
		 
			            
			            

			                                       
			 
				                                                                            
				                                                                            

				                                                     
			 
		 

		                           
		                                         

		           
	   

	WaitForever()
}
#endif          

#if CLIENT
vector function ConvertCursorToScreenPos()
{
	vector mousePos   = GetCursorPosition()
	UISize screenSize = GetScreenSize()
	mousePos = < mousePos.x * screenSize.width / 1920.0, mousePos.y * screenSize.height / 1080.0, 0.0 >
	return mousePos
}
#endif          

#if CLIENT
void function UICallback_Control_LaunchSpawnMenuProcessThread()
{
	thread ProcessSpawnMenu( GetLocalClientPlayer() )
}
#endif          

#if CLIENT
void function ProcessSpawnMenu( entity player )
{
	Assert( IsNewThread(), "Must be threaded off" )

	#if DEV
		printf( "CONTROL: kicking off process spawn menu thread" )
	#endif       

	player.Signal( "OnValidSpawnPointThreadStarted" )

	player.EndSignal( "OnSpawnMenuClosed" )
	player.EndSignal( "OnValidSpawnPointThreadStarted" )
	player.EndSignal( "OnDestroy" )

	OnThreadEnd(
		function() : ()
		{
			if ( ClGameState_GetRui() != null )
				RuiSetBool( ClGameState_GetRui(), "isInSpawnMenu", false )
		}
	)

	if ( ClGameState_GetRui() != null )
	{
		RuiSetBool( ClGameState_GetRui(), "isInSpawnMenu", true )
	}

	while ( !IsAlive( player ) )
	{
		bool shouldShowWaypoints = player.GetPlayerNetBool( "Control_IsPlayerOnSpawnSelectScreen" )
		int localPlayerAlliance = AllianceProximity_GetAllianceFromTeam( player.GetTeam() )

		foreach( wp in file.spawnWaypoints )
		{
			bool shouldShowThisWaypoint = true
			int spawnWaypointTeamUsability = eControlSpawnWaypointUsage.FRIENDLY_TEAM

			if ( shouldShowWaypoints )
			{
				if ( IsValid( wp.GetParent() ) )
				{
					if ( wp.GetParent() == player )
					{
						shouldShowThisWaypoint = false                                        
						spawnWaypointTeamUsability = eControlSpawnWaypointUsage.NOT_USABLE
					}
					else if ( wp.GetParent().IsPlayer() && !wp.GetParent().GetPlayerNetBool( "Control_IsPlayerOnSpawnSelectScreen" ) )
					{
						shouldShowThisWaypoint = true                                                         
						spawnWaypointTeamUsability = eControlSpawnWaypointUsage.FRIENDLY_TEAM
					}
					else if ( !wp.GetParent().IsPlayer() )
					{
						if ( wp.GetWaypointInt( INT_WAYPOINT_TYPE ) == CONTROL_WAYPOINT_POINT_INDEX )
						{
							shouldShowThisWaypoint = true

							int waypointOwner = wp.GetParent().GetWaypointInt( CONTROL_INT_OBJ_TEAM_OWNER )
							bool isYourWaypoint = waypointOwner == localPlayerAlliance
							bool isSpawnUsable = bool( wp.GetParent().GetWaypointBitfield() ) && waypointOwner != ALLIANCE_NONE

							spawnWaypointTeamUsability = isSpawnUsable ? ( isYourWaypoint ? eControlSpawnWaypointUsage.FRIENDLY_TEAM : eControlSpawnWaypointUsage.ENEMY_TEAM ) : eControlSpawnWaypointUsage.NOT_USABLE
						}
                          
                                                                                      
       
                                                                                     
                                                                 
                                                                                                                                     
                                              
       
                                
						else
						{
							shouldShowThisWaypoint = true                    
							spawnWaypointTeamUsability = wp.GetWaypointInt( INT_WAYPOINT_TYPE ) == localPlayerAlliance ? eControlSpawnWaypointUsage.FRIENDLY_TEAM : eControlSpawnWaypointUsage.NOT_USABLE                               
						}
					}
					else
					{
						shouldShowThisWaypoint = false                           
						spawnWaypointTeamUsability = eControlSpawnWaypointUsage.NOT_USABLE
					}
				}
				else
				{
					shouldShowThisWaypoint = false
					spawnWaypointTeamUsability = eControlSpawnWaypointUsage.NOT_USABLE
				}
			}
			else
			{
				shouldShowThisWaypoint = false
				spawnWaypointTeamUsability = eControlSpawnWaypointUsage.NOT_USABLE
			}

			SpawnMenu_ButtonUpdate(  wp, shouldShowThisWaypoint, spawnWaypointTeamUsability )
		}

		int lastLocalPingObjID = (file.lastLocalObjectivePing != null)? file.lastLocalObjectivePing.GetOwner().GetWaypointInt( INT_OBJECTIVE_ID ): -1
		RunUIScript( "SetLastLocalPingObjIDForUI", lastLocalPingObjID )
		WaitFrame()
	}
}
#endif          

#if CLIENT
void function SpawnMenu_ButtonUpdate( entity wp, bool shouldShowWaypoint, int spawnWaypointTeamUsability )
{
	if ( shouldShowWaypoint )
	{
		int waypointEHI = wp.GetEncodedEHandle()
		int waypointType = wp.GetWaypointInt( INT_WAYPOINT_TYPE )

		float[2] screenPos = GetScreenSpace( wp.GetOrigin() )

		string nameInformation = ""
		switch( waypointType )
		{
			case CONTROL_WAYPOINT_BASE0_INDEX:
			case CONTROL_WAYPOINT_BASE1_INDEX:
				nameInformation = Localize( "#CONTROL_BASE" )
				break
			case CONTROL_WAYPOINT_PLAYER_INDEX:
				if ( IsValid( wp.GetParent() ) && wp.GetParent().IsPlayer() )
					nameInformation = wp.GetParent().GetPlayerName()
				break
			case CONTROL_WAYPOINT_POINT_INDEX:
				if ( IsValid( wp.GetParent() ) )
				{
					int objectiveID = wp.GetParent().GetWaypointInt( INT_OBJECTIVE_ID )
					nameInformation = Control_GetObjectiveNameFromObjectiveID_Localized( objectiveID )
				}
				break
                       
                                   
                                    
     
                                                            
     
         
                             
		}

		if ( !IsValid( GetLocalViewPlayer() ) )
			return

		int yourTeamIndex = ( AllianceProximity_GetAllianceFromTeam( GetLocalViewPlayer().GetTeam() ) == 0 ) ? 0 : 1
		if ( waypointType == CONTROL_WAYPOINT_BASE0_INDEX || waypointType == CONTROL_WAYPOINT_BASE1_INDEX  )
		{
			RunUIScript( "SetWaypointDataForUI",
									waypointEHI,
									true,
									spawnWaypointTeamUsability,
									false,
									-1,
									waypointType,
									screenPos[0],
									screenPos[1],
									nameInformation,
									0,
									ALLIANCE_NONE,
									ALLIANCE_NONE,
									ALLIANCE_NONE,
									yourTeamIndex,
									false,
									0
			)
		}
		else if ( waypointType == CONTROL_WAYPOINT_POINT_INDEX )
		{

			entity objective = wp.GetParent()

			int objID = objective.GetWaypointInt( INT_OBJECTIVE_ID )
			int currentControllingTeam = objective.GetWaypointInt( INT_TEAM_CAPTURING )
			int currentOwner = objective.GetWaypointInt( CONTROL_INT_OBJ_TEAM_OWNER )
			int neutralPointOwnership = objective.GetWaypointInt( CONTROL_INT_OBJ_NEUTRAL_TEAM_OWNER )
			float capturePercentage = objective.GetWaypointFloat( FLOAT_CAP_PERC )
			bool hasEmphasis = objective.GetWaypointFloat( FLOAT_BOUNTY_AMOUNT ) > 0
			bool isFOB = Control_IsPointAnFOB( objID )
			int numTeamPings = Control_GetPingCountForObjectiveForAlliance( objective, AllianceProximity_GetAllianceFromTeam( GetLocalViewPlayer().GetTeam() ) )


			RunUIScript( "SetWaypointDataForUI",
				waypointEHI,
				true,
				spawnWaypointTeamUsability,
				isFOB,
				objID,
				waypointType,
				screenPos[0],
				screenPos[1],
				nameInformation,
				capturePercentage,
				currentControllingTeam,
				currentOwner,
				neutralPointOwnership,
				yourTeamIndex,
				hasEmphasis,
				objective.GetWaypointInt( INT_TEAM0_PLAYERSONOBJ ),
				objective.GetWaypointInt( INT_TEAM1_PLAYERSONOBJ ),
				numTeamPings
			)
		}

                      
                                                    
    

                                                                                           
                                             

                                        
                 
          
                                
           
        
                  
                  
                  
                     
       
                            
                  
                   
                   
          
     
    
                            
	}
	else
	{
		int waypointEHI = wp.GetEncodedEHandle()
		RunUIScript( "SetWaypointDataForUI", waypointEHI, false, spawnWaypointTeamUsability, false, -1, 0, ALLIANCE_NONE, ALLIANCE_NONE, "" )
	}
}
#endif          

#if CLIENT
void function UICallback_Control_ReportMenu_OnOpened()
{

}
#endif          

#if CLIENT
void function UICallback_Control_ReportMenu_OnClosed()
{
	entity player = GetLocalClientPlayer()
	if ( !IsValid( player ) )                                        
		return

	if ( !Control_IsModeEnabled() )
		return

	if ( !player.GetPlayerNetBool( "Control_IsPlayerOnSpawnSelectScreen" ) )
		return

	RunUIScript( "UI_OpenControlSpawnMenu", true )

	Control_SetWaveSpawnTimerTime()
}
#endif          

#if CLIENT
void function UICallback_Control_OnMenuPreClosed()
{
	if ( IsValid( GetLocalClientPlayer() ) )
		GetLocalClientPlayer().Signal( "OnSpawnMenuClosed" )

	                          
	if ( IsValid( file.spawnHeader ) )
	{
		var rui = Hud_GetRui( file.spawnHeader )
		if ( IsValid( rui ) )
		{
			RuiSetBool( rui, "spawnSelected", false )
		}
	}

	file.spawnHeader = null
	file.uiVMUpdateTime = 0
}
#endif          

#if CLIENT
void function UICallback_Control_SpawnHeaderUpdated( var spawnHeader, float time )
{
	file.spawnHeader = spawnHeader
	file.uiVMUpdateTime = time
}
#endif          

#if CLIENT
void function UICallback_Control_SpawnButtonClicked( int waypointEHI )
{
	entity waypoint = GetEntityFromEncodedEHandle( waypointEHI )

	#if DEV
		if ( waypoint == null )
			printf( "CONTROL: tried to spawn on button with a waypoint that no longer exists" )
	#endif       

	int type = waypoint.GetWaypointInt( INT_WAYPOINT_TYPE )
	Control_OnPlayerSentSpawnRequest( GetLocalClientPlayer(), waypoint )
}
#endif          

#if CLIENT
void function Control_OpenCharacterSelectMenu( var button )
{
	if ( GetGameState() != eGameState.Playing )
		return

	Control_OpenCharacterSelect()
}
#endif          

#if CLIENT
void function Control_OpenCharacterSelect()
{
	entity clientPlayer = GetLocalClientPlayer()
	entity viewPlayer = GetLocalViewPlayer()
	DestroyRespawnBlur()
	                                                                                                     
	if ( !Control_IsModeEnabled() )
		return

	                                                                                                                                                                            
	if ( file.characterSelectClosedTime + 0.5 > Time() )
		return

	                                                                
	if ( !clientPlayer.GetPlayerNetBool( "Control_IsPlayerOnSpawnSelectScreen" ) )
		return

	                                                                                  
	if ( ClGameState_GetRui() != null )
		RuiSetBool( ClGameState_GetRui(), "isInSpawnMenu", false )

	const bool browseMode = true
	const bool showLockedCharacters = true
	HideScoreboard()

	OpenCharacterSelectNewMenu( browseMode, showLockedCharacters )
}
#endif          

#if CLIENT
void function Control_OnCharacterSelectMenuClosed()
{
	file.characterSelectClosedTime = Time()

	if ( !GetLocalClientPlayer().GetPlayerNetBool( "Control_IsPlayerOnSpawnSelectScreen" ) )
		return

	CreateRespawnBlur()
	if( !file.firstTimeRespawnShouldWait )
	{
		                                                    
		RunUIScript( "UI_OpenControlSpawnMenu", false )
	}

	thread Control_CameraInputManager_Thread( GetLocalClientPlayer() )

	                                                                                  
	if ( ClGameState_GetRui() != null )
		RuiSetBool( ClGameState_GetRui(), "isInSpawnMenu", true )
}
#endif          

#if CLIENT
                                                                                                                                                                                              
void function Control_SetWaveSpawnTimerTime()
{
	entity player = GetLocalClientPlayer()

	if ( !IsValid( player ) )
		return

	if ( !player.GetPlayerNetBool( "Control_IsPlayerOnSpawnSelectScreen" ) )
		return

	if ( player.GetPlayerNetBool( "Control_IsPlayerExemptFromWaveSpawn" ) )
		return

	if ( IsValid( file.spawnHeader ) )
	{
		var rui = Hud_GetRui( file.spawnHeader )

		if ( IsValid( rui ) )
		{
			float startTime = GetGlobalNetTime( "Control_WaveStartTime" )
			float endTime =  GetGlobalNetTime( "Control_WaveSpawnTime" )
			RuiSetGameTime( rui, "respawnStartTime", startTime )
			RuiSetGameTime( rui, "respawnEndTime", endTime )
		}
	}
}
#endif          

#if CLIENT
                                                                                                                                                                                          
void function ServerCallback_Control_UpdateSpawnWaveTimerVisibility( bool isVisible )
{
	entity player = GetLocalClientPlayer()

	if ( !IsValid( player ) )
		return

	if ( !player.GetPlayerNetBool( "Control_IsPlayerOnSpawnSelectScreen" ) )
		return

	                                                                                              
	if ( file.spawnHeader == null && ( !isVisible || player.GetPlayerNetBool( "Control_IsPlayerExemptFromWaveSpawn" ) ) )
		return

	Control_SetWaveSpawnTimerTime()
}
#endif          

#if CLIENT
                                                                                                                      
void function ServerCallback_Control_DisplaySpawnAlertMessage( int spawnAlertMessageCode )
{
	var rui
	if ( !IsValid( file.spawnHeader ) )
		return

	rui = Hud_GetRui( file.spawnHeader )
	if ( !IsValid( rui) )
		return

	RunUIScript( "Control_SetAllButtonsEnabled" )

	string message
	bool isMessageCodeValid = false
	switch ( spawnAlertMessageCode )
	{
		case eControlSpawnAlertCode.SPAWN_FAILED:
			message = "#CONTROL_FAILED_SPAWN"
			isMessageCodeValid = true
			break
		case eControlSpawnAlertCode.SPAWN_CANCELLED:
			message = "#CONTROL_CANCELLED_SPAWN"
			isMessageCodeValid = true
			break
		case eControlSpawnAlertCode.SPAWN_LOST_SPAWNPOINT:
			message = "#CONTROL_LOST_SELECTED_SPAWN"
			isMessageCodeValid = true
			break
                      
                                             
                                           
                            
        
                            
		default:
			break
	}

	if ( isMessageCodeValid )
	{
		RuiSetString( rui, "spawnAlertMessage", message )
		RuiSetGameTime( rui, "alertTime", ClientTime() )
	}
}
#endif          

#if CLIENT
                                                                                                                                     
void function ServerCallback_Control_DisplayWaveSpawnBarStatusMessage( bool isShowingMessage, int spawnType )
{
	if ( !IsValid( file.spawnHeader ) )
		return

	var rui = Hud_GetRui( file.spawnHeader )
	if ( IsValid( rui ) )
	{
		if ( isShowingMessage )
		{
			RuiSetBool( rui, "spawnSelected", true )

			float startTime = GetGlobalNetTime( "Control_WaveStartTime" )
			float endTime =  GetGlobalNetTime( "Control_WaveSpawnTime" )
			RunUIScript("SetRespawnOverlayTime", startTime, endTime)

			string spawnChoice
			switch( spawnType )
			{
				case eControlPlayerRespawnChoice.SPAWN_AT_BASE:
					spawnChoice = "#CONTROL_BASE"
					break
				case eControlPlayerRespawnChoice.SPAWN_ON_POINT:
					spawnChoice = "#CONTROL_POINT"
					break
				case eControlPlayerRespawnChoice.SPAWN_ON_SQUAD:
					spawnChoice = "#CONTROL_SQUAD"
					break
                        
                                                  
                                 
          
                              
				default:
					spawnChoice = ""
					break
			}

			RuiSetString( rui, "spawnOptionSelected", spawnChoice )
		}
		else
		{
			RunUIScript("SetRespawnOverlayTime", RUI_BADGAMETIME, RUI_BADGAMETIME)
			RuiSetBool( rui, "spawnSelected", false )
		}
	}
}
#endif          

#if CLIENT
                                             
void function Control_ShowTeammateDeathIcon_3DMap_Thread( entity victimWP )
{
	Assert( IsNewThread(), "Must be threaded off" )

	entity localPlayer = GetLocalViewPlayer()
	if ( !IsValid( localPlayer ) )
		return

	if ( !IsFriendlyTeam( localPlayer.GetTeam(), victimWP.GetTeam() ) )
		return

	if ( !Control_ShouldDisplayFriendlyMapIcons( localPlayer ) )
		return

	var rui = CreateFullscreenRui(  $"ui/control_teammate_death_icon.rpak", CONTROL_TEAMMATE_ICON_SORTING )

	localPlayer.EndSignal( "Control_NewCameraDataReceived" )
	localPlayer.EndSignal( "Control_PlayerStartingRespawnSelection" )
	localPlayer.EndSignal( "Control_PlayerHasChosenRespawn" )
	localPlayer.EndSignal( "Control_PlayerHideScoreboardMap" )

	OnThreadEnd(
		function() : ( rui )
	{
		RuiDestroy( rui )
	}
	)

	entity victim = victimWP.GetWaypointEntity( CONTROL_PLAYERLOC_WAYPOINT_PLAYERENTITY_INDEX )
	if ( IsValid( victim ) )
	{
		vector deathLoc = victim.GetOrigin()
		bool isVictimSquadmate = localPlayer.GetTeam() ==  victim.GetTeam() ? true : false
		if ( isVictimSquadmate )
			RuiSetColorAlpha( rui, "deathIconColor", SrgbToLinear( GetTeammateIconColor( victim ) / 255.0 ), 1.0 )
		RuiSetGameTime( rui, "deathStartTime", Time() )
		RuiSetFloat3( rui, "deathLocation", deathLoc )

		wait CONTROL_TEAMMATE_DEATH_ICON_LIFETIME
	}

}
#endif          

#if CLIENT
                                                                                                                         
void function InstanceWPControlPlayerLoc( entity wp )
{
	entity player = GetLocalViewPlayer()

	if ( !IsValid( player ) || !IsValid( wp ) )
		return

	                                               
	if ( !IsFriendlyTeam( player.GetTeam(), wp.GetTeam() ) )
		return

	thread Control_TeamLocationWaypointThink_Thread( wp )
}
#endif          

#if CLIENT
vector function GetTeammateIconColor( entity player )
{
	return GetKeyColor( COLORID_MEMBER_COLOR0, player.GetTeamMemberIndex() )
}
#endif          

#if CLIENT
                                                 
void function Control_TeamLocationWaypointThink_Thread( entity wp )
{
	Assert( IsNewThread(), "Must be threaded off" )

	entity localPlayer = GetLocalViewPlayer()
	if ( !IsValid( localPlayer ) )
		return

	if ( !IsFriendlyTeam( localPlayer.GetTeam(), wp.GetTeam() ) )
		return

	var rui = CreateWaypointRui( $"ui/control_teammate_loc_icon.rpak", CONTROL_TEAMMATE_ICON_SORTING )

	wp.EndSignal( "OnDestroy" )
	localPlayer.EndSignal( "OnDestroy" )

	OnThreadEnd(
		function() : ( rui, wp, localPlayer )
		{
			if ( IsValid( localPlayer ) )
				thread Control_ShowTeammateDeathIcon_3DMap_Thread( wp )
			RuiDestroy( rui )
		}
	)

	entity teammate = wp.GetWaypointEntity( CONTROL_PLAYERLOC_WAYPOINT_PLAYERENTITY_INDEX )

	if ( IsValid( teammate ) )
	{
		bool isTeammateSquadmate = localPlayer.GetTeam() == teammate.GetTeam() ? true : false
		if ( isTeammateSquadmate )
			RuiSetColorAlpha( rui, "teammateIconColor", SrgbToLinear( GetTeammateIconColor( teammate ) / 255.0 ), 1.0 )
		RuiTrackFloat3( rui, "teammateLocation", teammate, RUI_TRACK_ABSORIGIN_FOLLOW )
		RuiTrackFloat3( rui, "teammateRotation", teammate, RUI_TRACK_CAMANGLES_FOLLOW )
		RuiSetFloat3( rui, "cameraLookDirection", VectorToAngles( file.cameraLookDirection ) )
		RuiSetGameTime( rui, "spawnStartTime", Time() )
		bool isDisplayingTeammateIcon = Control_ShouldDisplayFriendlyMapIcons( localPlayer ) ? true : false
		RuiSetBool( rui, "display", isDisplayingTeammateIcon )

		                                                                                                                                     
		while ( GetGameState() == eGameState.Playing )
		{
			if ( Control_ShouldDisplayFriendlyMapIcons( localPlayer ) && !isDisplayingTeammateIcon )
			{
				isDisplayingTeammateIcon = true
				RuiSetBool( rui, "display", isDisplayingTeammateIcon )
			}

			if ( !Control_ShouldDisplayFriendlyMapIcons( localPlayer ) && isDisplayingTeammateIcon )
			{
				isDisplayingTeammateIcon = false
				RuiSetBool( rui, "display", isDisplayingTeammateIcon )
			}

			WaitFrame()
		}
	}
}
#endif          

#if CLIENT
                                                                                                                                         
bool function Control_ShouldDisplayFriendlyMapIcons( entity player )
{
	if ( IsValid( player ) && file.isPlayerInMapCameraView)
		return true

	return false
}
#endif          

#if CLIENT
void function ServerCallback_Control_DisplayIconAtPosition( vector position, int iconIndex, int colorID, float duration )
{
	asset icon = $""
	switch ( iconIndex )
	{
		case eControlIconIndex.DEATH_ICON:
			icon = TEAMMATE_DEATH_ICON
			break
		case eControlIconIndex.SPAWN_ICON:
			icon = TEAMMATE_SPAWN_ICON
			break
		default:
			break
	}

	thread DisplayIconAtPosition_Thread( position, icon, colorID, duration )
}
#endif          

#if CLIENT
void function DisplayIconAtPosition_Thread( vector position, asset icon, int colorID, float duration )
{
	Assert( IsNewThread(), "Must be threaded off" )

	entity player = GetLocalViewPlayer()
	if ( !IsValid( player ) )
		return

	vector iconColor = GetKeyColor( colorID ) * ( 1.0 / 255.0 )
	var minimapRui = Minimap_AddIconAtPosition( position, <0,90,0>, icon, 0.9, iconColor )
	var fullmapRui = FullMap_AddIconAtPos( position, <0,0,0>, icon, 6.0, iconColor )

	OnThreadEnd(
		function() : ( minimapRui, fullmapRui )
		{
			Minimap_CommonCleanup( minimapRui )
			Fullmap_RemoveRui( fullmapRui )
			RuiDestroy( fullmapRui )
		}
	)

	wait duration
}
#endif          

  
                                                                                                                                                                      
                                                                                                                                                                       
                                                                                                                                                                     
                                                                                                                                                                      
                                                                                                                                                                       
                                                                                                                                                                      

	                        
  


#if SERVER || CLIENT
bool function Control_PlayerIsInCombat( entity player, bool shouldDoWeaponTests )
{
	const float TEAMMATE_NEAR_SPOTTED_ENEMY = 512.0
	const float LAST_DAMAGED_BY_PLAYER_OR_NPC = 2.5
	const float LAST_DID_DAMAGE_TO_PLAYER_OR_NPC = 2.5
	const float LAST_BAD_WEAPON_CHECK = 2.5

	if ( Bleedout_IsBleedingOut( player ) )
		return true

	                                                               
	if ( GetEffectiveDeltaSince( player.GetLastTimeDamagedByOtherPlayer() ) < LAST_DAMAGED_BY_PLAYER_OR_NPC )
	{
		#if DEV
			if ( CONTROL_DETAILED_DEBUG )
				printf( "CONTROL: Control_PlayerIsInCombat() - player damaged by other player" )
		#endif       

		return true
	}

	if ( GetEffectiveDeltaSince( player.GetLastTimeDamagedByNPC() ) < LAST_DAMAGED_BY_PLAYER_OR_NPC )
	{
		#if DEV
			if ( CONTROL_DETAILED_DEBUG )
				printf( "CONTROL: Control_PlayerIsInCombat() - player damaged by NPC" )
		#endif       

		return true
	}

	  
	if ( GetEffectiveDeltaSince( player.GetLastTimeDidDamageToOtherPlayer() ) < LAST_DID_DAMAGE_TO_PLAYER_OR_NPC )
	{
		#if DEV
			if ( CONTROL_DETAILED_DEBUG )
				printf( "CONTROL: Control_PlayerIsInCombat() - Last did damage to other player" )
		#endif       

		return true
	}

	if ( GetEffectiveDeltaSince( player.GetLastTimeDidDamageToNPC() ) < LAST_DID_DAMAGE_TO_PLAYER_OR_NPC )
	{
		#if DEV
			if ( CONTROL_DETAILED_DEBUG )
				printf( "CONTROL: Control_PlayerIsInCombat() - Last did damage to NPC" )
		#endif       

		return true
	}

	  
#if SERVER
	                                                                                                              
#elseif CLIENT
	if ( Waypoint_AnyEnemySpottedNearPoint( player.EyePosition(), TEAMMATE_NEAR_SPOTTED_ENEMY ) )
#endif
	{
		#if DEV
			if ( CONTROL_DETAILED_DEBUG )
				printf( "CONTROL: Control_PlayerIsInCombat() - Any teammate near spotted enemy" )
		#endif       

		return true
	}

	if ( shouldDoWeaponTests && GetEffectiveDeltaSince( Control_GetTimeOfEXPEvoBadWeaponCheck( player ) ) < LAST_BAD_WEAPON_CHECK )
	{
		#if DEV
			if ( CONTROL_DETAILED_DEBUG )
				printf( "CONTROL: Control_PlayerIsInCombat() - failed weapon check" )
		#endif       

		return true
	}

	return false
}
#endif                    

#if SERVER || CLIENT
                                                                                                                                                         
float function Control_GetTimeOfEXPEvoBadWeaponCheck( entity player )
{
	const float LAST_FIRED_TIME_ALLOWANCE = 0.5
	float lastBadWeaponCheckTime = 0.0

	if ( !IsValid( player ) )
		return lastBadWeaponCheckTime

	bool isWeaponCheckBad = false

	                                                     
	#if SERVER
		                              
	#elseif CLIENT
		if ( player.GetAdsFraction() > 0 )
	#endif
		{
			#if DEV
				if ( CONTROL_DETAILED_DEBUG )
					printf( "CONTROL: Control_GetTimeOfEXPEvoBadWeaponCheck - Bad weapon check ( player in ADS )" )
			#endif       

			isWeaponCheckBad = true
		}

	                                                           
	if ( player.IsUsingOffhandWeapon( eActiveInventorySlot.altHand ) )
	{
		#if DEV
			if ( CONTROL_DETAILED_DEBUG )
				printf( "CONTROL: Control_GetTimeOfEXPEvoBadWeaponCheck - Bad weapon check ( using tac )" )
		#endif       

		isWeaponCheckBad = true
	}

	                                                         
	if ( player.IsUsingOffhandWeapon( eActiveInventorySlot.mainHand ) )
	{
		#if DEV
			if ( CONTROL_DETAILED_DEBUG )
				printf( "CONTROL: Control_GetTimeOfEXPEvoBadWeaponCheck - Bad weapon check ( using main  )" )
		#endif       

		isWeaponCheckBad = true
	}

	entity weapon = player.GetActiveWeapon( eActiveInventorySlot.mainHand )

                                                    
	if ( IsValid( weapon ) && weapon.IsReloading() )
	{
		#if DEV
			if ( CONTROL_DETAILED_DEBUG )
				printf( "CONTROL: Control_GetTimeOfEXPEvoBadWeaponCheck - Bad weapon check ( reloading )" )
		#endif       

		isWeaponCheckBad = true
	}

	                                                             
	if ( IsValid( weapon ) )
	{
		LootData data = SURVIVAL_GetLootDataFromWeapon( weapon )
		if ( data.lootType == eLootType.ORDNANCE )
		{
			#if DEV
				if ( CONTROL_DETAILED_DEBUG )
					printf( "CONTROL: Control_GetTimeOfEXPEvoBadWeaponCheck - Bad weapon check ( using ordnance )" )
			#endif       

			isWeaponCheckBad = true
		}
	}

	if ( IsValid( weapon ) && weapon.GetEnergizeState() == ENERGIZE_ENERGIZING )
	{
		#if DEV
			printf( "CONTROL: Control_GetTimeOfEXPEvoBadWeaponCheck - Bad weapon check ( charging )" )
		#endif       

		isWeaponCheckBad = true
	}

	                                                      
	if ( GetEffectiveDeltaSince( player.GetLastFiredTime() ) < LAST_FIRED_TIME_ALLOWANCE )
	{
		#if DEV
			if ( CONTROL_DETAILED_DEBUG )
				printf( "CONTROL: Control_GetTimeOfEXPEvoBadWeaponCheck - Bad weapon check ( firing weapon )" )
		#endif       

		isWeaponCheckBad = true
	}

	                                                    
	if ( player.IsSwitching( WEAPON_INVENTORY_SLOT_PRIMARY_0 ) || player.IsSwitching( WEAPON_INVENTORY_SLOT_PRIMARY_1 ) )
	{
		#if DEV
			if ( CONTROL_DETAILED_DEBUG )
				printf( "CONTROL: Control_GetTimeOfEXPEvoBadWeaponCheck - Bad weapon check ( switching weapons )" )
		#endif       

		isWeaponCheckBad = true
	}

	                                          
	if ( player.Anim_IsActive() )
	{
		#if DEV
			if ( CONTROL_DETAILED_DEBUG )
				printf( "CONTROL: Control_GetTimeOfEXPEvoBadWeaponCheck - Bad weapon check ( Anim_IsActive )" )
		#endif       

		isWeaponCheckBad = true
	}

	                                                                              
	if ( player.IsInputCommandHeld( IN_USE ) || player.IsInputCommandHeld( IN_USE_LONG ) )
	{
		#if DEV
			if ( CONTROL_DETAILED_DEBUG )
				printf( "CONTROL: Control_GetTimeOfEXPEvoBadWeaponCheck - Bad weapon check ( using interaction )" )
		#endif       

		isWeaponCheckBad = true
	}

	                                                
	if ( player.IsPhaseShifted() )
	{
		#if DEV
			if ( CONTROL_DETAILED_DEBUG )
				printf( "CONTROL: Control_GetTimeOfEXPEvoBadWeaponCheck - Bad weapon check ( phasing )" )
		#endif       

		isWeaponCheckBad = true
	}

	                                                   
	if ( StatusEffect_GetSeverity( player, eStatusEffect.placing_phase_tunnel ) )
	{
		#if DEV
			if ( CONTROL_DETAILED_DEBUG )
				printf( "CONTROL: Control_GetTimeOfEXPEvoBadWeaponCheck - Bad weapon check ( placing phase tunnel )" )
		#endif       

		isWeaponCheckBad = true
	}

	                                                 
	if ( player.GetPlayerNetBool( "isHealing" ) )
	{
		#if DEV
			if ( CONTROL_DETAILED_DEBUG )
				printf( "CONTROL: Control_GetTimeOfEXPEvoBadWeaponCheck - Bad weapon check ( healing )" )
		#endif       

		isWeaponCheckBad = true
	}

	                                              
	if ( player.PlayerMelee_GetState() != PLAYER_MELEE_STATE_NONE )
	{
		#if DEV
			if ( CONTROL_DETAILED_DEBUG )
				printf( "CONTROL: Control_GetTimeOfEXPEvoBadWeaponCheck - Bad weapon check ( melee )" )
		#endif       

		isWeaponCheckBad = true
	}

	#if SERVER
		                                           
		 
			       
				                             
					                                                                                                
			             

			                       
		 
	#elseif CLIENT
		if ( IsValid( player.GetPlayerNetEnt( "Translocation_ActiveProjectile" ) ) )
		{
			#if DEV
				if ( CONTROL_DETAILED_DEBUG )
					printf( "CONTROL: Control_GetTimeOfEXPEvoBadWeaponCheck - Bad weapon check ( translocating )" )
			#endif       

			isWeaponCheckBad = true
		}
	#endif

	                                       
	if ( !IsValid( weapon ) )
	{
		#if DEV
			if ( CONTROL_DETAILED_DEBUG )
				printf( "CONTROL: Control_GetTimeOfEXPEvoBadWeaponCheck - Bad weapon check ( weapon is null )" )
		#endif       

		#if SERVER
			                                                                                                                                                      
			                                                                                             
			                                                                                        
			 
				                                                       
				                                                              
				                                  
					                                                                         
			 
		#endif
		isWeaponCheckBad = true
	}

	                                                                       
	if ( isWeaponCheckBad )
		file.playerToLastEXPEvoBadWeaponCheckTimeTable[ player ] <- Time()

	                                                         
	if ( player in file.playerToLastEXPEvoBadWeaponCheckTimeTable )
		lastBadWeaponCheckTime = file.playerToLastEXPEvoBadWeaponCheckTimeTable[ player ]

	return lastBadWeaponCheckTime
}
#endif                    

#if SERVER || CLIENT
float function GetEffectiveDeltaSince( float timeThen )
{
	if ( timeThen <= 0.0001 )
		return 999999.0

	return (Time() - timeThen)
}
#endif                    


  
                                                               
                                                                
                                                             
                                                              
                                                               
                                                                


                                                                                            
                                                                                             
                                                                                          
                                                                                          
                                                                                          
                                                                                          

                   
  


#if SERVER || CLIENT
void function OnVehicleBaseSpawned( entity vehicleBase )
{
	if ( vehicleBase.GetScriptName() != "Control_SetUsableVehicleBase" )
		return

	            
		                                                                                
	      

	                                                                      
	                                                                      
	  
}
#endif                    

  
                    
                                                                              
 
	                                       
		            

	                                      
		            

	                                                
		            

	                                                  
		            

	                   
		            

	           
 
                          

                    
                                                      
 
	                                   
 
                          

                    
                                                                                    
 
	                                     
		      

	          
	                                           
	                            
	                                
	                                        
	 
		                                             
			                                    
	 

	                                                                   

	                                                                   
	 
		                                                               
		                                   
		 
			                                         
		 
		                                        
		 
			                                                                
			                                       
			                                                    
		 

	 
	    
	 
		                                                   
		                                                                                     
		      
	 
	      
 
                          
  


#if SERVER
                                                       
 
	                                                              
	                                                          
	 
		                                                      
		                                                        
		                                                                

		                                                           
		 
			                                                
			                        
		 
	 
	                                          

	                                                  
	 
		                                              
	 
 
#endif          

#if SERVER
                                                                         
 
	                                 
		      

	                                   
	                                                                   
	                            
	                            
	                                            
	                                                                      
	                                                                                            
	                                                              
	                                                                
	                                                                                                                    
	                                                                                                                              

	                                                    
 
#endif          

#if SERVER
                                                                       
 
	                                                          
	                           
	                                                        
		                                        
	                                                                    
	                                                                           

	                             
	                          
	 
		                                                             
	 
	    
	 
		                                 
		                                          
	 

	                                        

	                                                   
	 
		                                         
		                                                      
	 

	                                 
	                       
	 
		                                                            
		                         
			                                                                                          
	   

	                                                           
 
#endif          

#if SERVER
                                                                      
 
	                                               

	                          
		      

	                                

	            
		                                     
		 
			                                             
				                                               
		 
	 

	             
 
#endif          

#if SERVER
                                                               
 
	                                               

	                              
		      

	                        
	             

	                                                        

	                              
	                             
	                                
	                                

	              
	 
		                            
		                            
		                                        
		 
			                          
				        

			                                                                                                    
			 
				                      
				     
			 
		 

		                       
		 
			                        
			                        
			 
				                
				             
			 

			                                    
			                                                               
			                                                             
			                                                                                                
			 
				                                                                              
				                      
					                                                                                 
				    
					                                                                                                    
			 
		 
		                           
		 
			                        
			                     
				                                                                                                                                                                                                      
			                                                                     
		 

		           
	 
 
#endif          

#if SERVER
                                                                            
 
	                                                                       
	                                   
	 
		                                
		           
	 
	    
	 
		                                                               
		 
			                                                                                                                                           
			 
				                                                                      
				                                            
				           
			 
		 
	 

	            
 
#endif          

#if SERVER
                                                          
 
	                                             
	 
		                                                            
			                                                          

		                                                      
	 
 
#endif          


#if CLIENT
void function ServerCallback_Control_NoVehiclesAvailable()
{
	AnnouncementMessageRight( GetLocalClientPlayer(), Localize( "#CONTROL_NO_VEHICLES_AVAILABLE" ), "", ANNOUNCEMENT_RED, $"", CONTROL_MESSAGE_DURATION, "WXpress_Train_Update_Small" )
}
#endif          


  
                                                                                                                   
                                                                                                                    
                                                                                                                  
                                                                                                                   
                                                                                                                    
                                                                                                                   

                    
   

#if CLIENT
                                                                                                 
void function ServerCallback_Control_DisplayMatchTimeLimitWarning( bool isFinalWarning )
{
	entity player = GetLocalViewPlayer()
	if ( !IsValid( player ) )
		return

	                                                                                                 
	if ( CONTROL_MATCH_TIME_LIMIT_WARNING_TIME < 60 )
		return

	string message = Localize( "#CONTROL_MATCH_TIMELIMIT_WARNING", CONTROL_MATCH_TIME_LIMIT_WARNING_TIME/ 60 )
	if ( isFinalWarning )
		message = Localize( "#CONTROL_MATCH_TIMELIMIT_GAMEEND" )

	Control_AnnouncementMessageWarning( player, message, CONTROL_OBJECTIVE_RED, CONTROL_SFX_MATCH_TIME_LIMIT, CONTROL_MESSAGE_DURATION )
}
#endif          

#if CLIENT
void function Control_AnnouncementMessageWarning( entity player, string messageText, vector titleColor, string soundAlias, float duration )
{
	AnnouncementData announcement = Announcement_Create( messageText )
	Announcement_SetHeaderText( announcement, " " )
	Announcement_SetSubText( announcement, " " )
	Announcement_SetStyle( announcement, ANNOUNCEMENT_STYLE_GENERIC_WARNING )
	Announcement_SetSoundAlias( announcement, soundAlias )
	Announcement_SetPurge( announcement, true )
	Announcement_SetPriority( announcement, 200 )                                                        
	Announcement_SetDuration( announcement, duration )

	Announcement_SetTitleColor( announcement, titleColor )
	Announcement_SetVerticalOffset( announcement, 140 )
	AnnouncementFromClass( player, announcement )
}
#endif          

#if CLIENT
                                                                               
void function ServerCallback_Control_AirdropNotification( bool areMultipleAirdropsIncoming )
{
	entity player = GetLocalClientPlayer()
	if ( !IsValid( player ) )
		return

	string announcementText

	if ( areMultipleAirdropsIncoming )
	{
		announcementText = Localize( "#CONTROL_INCOMING_AIRDROPS" )
	}
	else
	{
		announcementText = Localize( "#CONTROL_INCOMING_AIRDROP" )
	}

	vector announcementColor = <0, 0, 0>
	Obituary_Print_Localized( announcementText, announcementColor )
	AnnouncementMessageRight( player, announcementText, "", SrgbToLinear( announcementColor / 255 ), $"", CONTROL_MESSAGE_DURATION, SFX_HUD_ANNOUNCE_QUICK, SrgbToLinear( announcementColor / 255 ) )
}
#endif          

#if CLIENT
                                                 
void function Control_UpdatePlayerExpHUD( entity player, int newExpTotal )
{
	if ( !IsValid( player ) )
		return

	if ( player != GetLocalClientPlayer() )
		return

	                            
	int expTier = Control_GetPlayerExpTier( player, false )
	float currentTierExp = float( Control_GetPlayerExpTotal( player, true, expTier ) )
	float expTierThreshold = float( Control_GetExpDifferenceBetweenLastTierAndTier( expTier + 1, player ) )
	bool isMaxTier = expTier >= CONTROL_MAX_EXP_TIER ? true : false
	var rui = ClGameState_GetRui()
	int tierOffset = 1 - Control_GetDefaultWeaponTier()

	if ( GetGameState() == eGameState.Playing && IsValid( rui ) )
	{
		RuiSetBool( rui, "shouldDisplayExpUI", Control_GetIsWeaponEvoEnabled() )
		RuiSetBool( rui, "isMaxTier", isMaxTier )
		RuiSetBool( rui, "isUltimateFull", Control_IsPlayerUltReady( player ) )
		RuiSetInt( rui, "expTierColor", Control_GetPlayerExpTier( player ) )
		RuiSetFloat( rui, "expTotal", currentTierExp )
		RuiSetFloat( rui, "expTierThreshold", expTierThreshold )

		if ( currentTierExp > 0 )
			RuiSetGameTime( rui, "expGainedTime", Time() )
	}

	                                                  
	Control_UpdatePlayerExpPercentAmountsForSpawns( player )
}
#endif          

#if CLIENT
                                                                                                                                                       
void function Control_UpdatePlayerExpPercentAmountsForSpawns( entity player )
{
	if ( !IsValid( player ) )
		return

	if ( player != GetLocalClientPlayer() )
		return

	                                                  
	float playerExpPercentFromLastLife = Control_GetEXPPercentToNextTier( player )
	int recoveredExpPercentToAward = int( playerExpPercentFromLastLife * 100 )

	                                                         
	int expPercentToAwardForPointSpawn = 0
	int expPercentToAwardForBaseSpawn = 0

	                                                                                               
	if ( Control_GetDefaultExpPercentToAwardForPointSpawn() < 0 )
		expPercentToAwardForPointSpawn = recoveredExpPercentToAward

	                                                                                            
	if ( Control_GetDefaultExpPercentToAwardForBaseSpawn() < 0 )
		expPercentToAwardForBaseSpawn = recoveredExpPercentToAward

	                                                                                                                                                                                                  
	if ( playerExpPercentFromLastLife > Control_GetDefaultExpPercentToAwardForPointSpawn() && Control_GetDefaultExpPercentToAwardForPointSpawn() > 0 && Control_ShouldUseRecoveredExpPercentIfGreaterThanDefaults() )
	{
		expPercentToAwardForPointSpawn = recoveredExpPercentToAward
	}
	else if ( Control_GetDefaultExpPercentToAwardForPointSpawn() > 0 )
	{
		expPercentToAwardForPointSpawn = int( Control_GetDefaultExpPercentToAwardForPointSpawn() * 100 )
	}

	                                                                                                                                                                                               
	if ( playerExpPercentFromLastLife > Control_GetDefaultExpPercentToAwardForBaseSpawn() && Control_GetDefaultExpPercentToAwardForBaseSpawn() > 0 && Control_ShouldUseRecoveredExpPercentIfGreaterThanDefaults() )
	{
		expPercentToAwardForBaseSpawn = recoveredExpPercentToAward
	}
	else if ( Control_GetDefaultExpPercentToAwardForBaseSpawn() > 0 )
	{
		expPercentToAwardForBaseSpawn = int( Control_GetDefaultExpPercentToAwardForBaseSpawn() * 100 )
	}

	RunUIScript( "Control_UI_SpawnMenu_SetExpPercentAmountsForSpawns", expPercentToAwardForPointSpawn, expPercentToAwardForBaseSpawn )
}
#endif          

#if CLIENT
                                        
void function Control_PlayEXPGainSFX()
{
	entity player = GetLocalClientPlayer()
	if ( !IsValid( player ) )
		return

	EmitUISound( CONTROL_SFX_EXP_GAIN )
}
#endif          

#if CLIENT
string function Control_GetVictoryConditionForFlagset( int gameResultFlags )
{
	switch( gameResultFlags )
	{
		case( CONTROL_VICTORY_FLAGS_SCORE ):
			return CONTROL_PIN_VICTORYCONDITION_SCORE

		case( CONTROL_VICTORY_FLAGS_LOCKOUT ):
			return CONTROL_PIN_VICTORYCONDITION_LOCKOUT
	}

	return CONTROL_PIN_VICTORYCONDITION_UNKNOWN
}
#endif          

#if CLIENT
void function Control_DeathScreenUpdate( var rui )
{
	SquadSummaryData squadData = GetSquadSummaryData()

	string titleString = squadData.squadPlacement == 1 ? "#SQUAD_PLACEMENT_GCARDS_TITLE" : "#SQUAD_HEADER_DEFEAT"
	string killsText   = "#CONTROL_DEATH_SCREEN_SUMMARY_KILLS_ALLIANCE"

	string victoryCondition = Control_GetVictoryConditionForFlagset( squadData.gameResultFlags )
	RuiSetString( rui, "victoryCondition", victoryCondition )
	RuiSetString( rui, "headerText", titleString )                                                                                                                
	RuiSetString( rui, "killsText", killsText )

	if ( victoryCondition == CONTROL_PIN_VICTORYCONDITION_SCORE )
	{
		RuiSetInt( rui, "losingScore", squadData.gameScoreFlags )
		RuiSetInt( rui, "winningScore", Control_GetScoreLimit() )
	}
}
#endif          

#if CLIENT
void function Control_PopulateSummaryDataStrings( SquadSummaryPlayerData data )
{
	data.modeSpecificSummaryData[0].displayString = "#DEATH_SCREEN_SUMMARY_KILLS"
	data.modeSpecificSummaryData[1].displayString = "#DEATH_SCREEN_SUMMARY_ASSISTS"
	data.modeSpecificSummaryData[2].displayString = ""
	data.modeSpecificSummaryData[3].displayString = "#DEATH_SCREEN_SUMMARY_DAMAGE_DEALT"
	data.modeSpecificSummaryData[4].displayString = "#DEATH_SCREEN_SUMMARY_CONTROL_RATING"
	data.modeSpecificSummaryData[5].displayString = "#DEATH_SCREEN_SUMMARY_CONTROL_OBJECTIVES_CAPTURED"
	data.modeSpecificSummaryData[6].displayString = ""
}
#endif          

#if CLIENT
                                                                                                          
void function ServerCallback_Control_UpdatePlayerExpHUDWeaponEvo( bool isWeaponEvoPending, bool didGainNewExpTier )
{
	entity player = GetLocalClientPlayer()
	if ( !IsValid( player ) )
		return

	var rui = ClGameState_GetRui()
	if ( GetGameState() == eGameState.Playing && IsValid( rui ) )
	{
		RuiSetBool( rui, "isEXPEvoPending", isWeaponEvoPending )

		if ( didGainNewExpTier )
			RuiSetGameTime( rui, "expTierGainedTime", Time() )
	}
}
#endif          

#if CLIENT
                                                         
void function ServerCallback_Control_NewEXPLeader( entity expLeader, int exp )
{
	EHI playerEHI = ToEHI( expLeader )

	                                                      
	if ( playerEHI == EHI_null )
		return

	if ( !IsValid( expLeader ) )
		return

	entity localPlayer = GetLocalViewPlayer()

	if ( !IsValid( localPlayer ) )
		return

	string playerName = GetPlayerNameFromEHI( playerEHI )
	vector playerNameColor = expLeader.GetTeam() == localPlayer.GetTeam() ? GetPlayerInfoColor( expLeader ) : GetKeyColor( COLORID_ENEMY )

	Obituary_Print_Localized( Localize( "#CONTROL_NEW_EXPLEADER_OBIT", playerName, exp ), playerNameColor )

	if ( localPlayer == expLeader )
	{
		AnnouncementData announcement = Announcement_Create( "" )
		Announcement_SetStyle( announcement, ANNOUNCEMENT_STYLE_RATING_LEADER )
		Announcement_SetPurge( announcement, true )
		Announcement_SetOptionalTextArgsArray( announcement, [Localize("#CONTROL_YOU_ARE_EXPLEADER"), Localize( "#CONTROL_EXPLEADER_EXP", exp, GetPlayerInfoColor( expLeader ) ), string( exp ) ] )
		Announcement_SetPriority( announcement, 200 )
		Announcement_SetSoundAlias( announcement, SOUND_NEW_KILL_LEADER )
		announcement.duration = CONTROL_MESSAGE_DURATION
		AnnouncementFromClass( localPlayer, announcement )
	}
}
#endif          

#if CLIENT
                                                                      
void function ServerCallback_Control_EXPLeaderKilled( entity attacker, entity expLeader )
{
	if ( !IsValid( attacker ) || !IsValid( expLeader ) )
		return

	entity localClientPlayer = GetLocalClientPlayer()

	if ( !IsValid( localClientPlayer ) )
		return

	EHI expLeaderEHI = ToEHI( expLeader )
	string expLeaderName = GetPlayerNameFromEHI( expLeaderEHI )
	vector expLeaderNameColor = expLeader.GetTeam() == GetLocalViewPlayer().GetTeam() ? GetPlayerInfoColor( expLeader ) : <255, 255, 255>


	Obituary_Print_Localized( Localize( "#CONTROL_EXPLEADER_OBIT", expLeaderName ), expLeaderNameColor )
	if ( localClientPlayer == attacker && attacker != expLeader )
		AnnouncementMessageSweep( localClientPlayer, "#CONTROL_YOUKILLED_EXPLEADER", expLeaderName, expLeaderNameColor )
}
#endif          

#if CLIENT
                                                        
void function ServerCallback_Control_PlayCaptureZoneEnterExitSFX( bool isEnteringZone )
{
	entity localClientPlayer = GetLocalClientPlayer()

	if ( !IsValid( localClientPlayer ) )
		return

	if ( isEnteringZone )
	{
		EmitUISound( CONTROL_SFX_CAPTURE_ZONE_ENTER )
	}
	else
	{
		EmitUISound( CONTROL_SFX_CAPTURE_ZONE_EXIT )
	}
}
#endif          

  
                                                                     
                                                                      
                                                                       
                                                                       
                                                                       
                                                                      

	          
  

#if CLIENT
void function Control_ScoreboardSetup()
{
	clGlobal.showScoreboardFunc = Control_ShowScoreboardOrMap_Teams
	clGlobal.hideScoreboardFunc = Control_HideScoreboardOrMap_Teams

	Teams_AddCallback_ScoreboardData( Control_GetScoreboardData )
	Teams_AddCallback_PlayerScores( Control_GetPlayerScores )
	Teams_AddCallback_SortScoreboardPlayers( Control_SortPlayersByScore )
	Teams_AddCallback_Header( Control_ScoreboardUpdateHeader )
}
#endif          

#if CLIENT
void function Control_ShowScoreboardOrMap_Teams()
{
	entity player = GetLocalClientPlayer()

	if ( IsValid( player ) )
	{
		thread Control_CameraInputManager_Thread( player )
	}

	Scoreboard_SetVisible( true )
	UpdateFullmapRuiTracks()
	Fullmap_ClearInputContext()
	UpdateMainHudVisibility( GetLocalViewPlayer() )

	HudInputContext inputContext
	inputContext.keyInputCallback = Control_HandleKeyInput
	inputContext.moveInputCallback = Control_ShowScoreboardOrMapHandleMoveInput
	inputContext.viewInputCallback = Control_ShowScoreboardOrMapHandleViewInput
	HudInput_PushContext( inputContext )

	Control_OnInGameMapShow()
}
#endif          

#if CLIENT
bool function Control_HandleKeyInput( int key )
{
	bool swallowInput = false

	switch ( key )
	{
		case BUTTON_B:
			HideScoreboard()
			return true
		case BUTTON_DPAD_UP:
		case KEY_F2:
			RunUIScript( "UI_OpenGameModeRulesDialog" )
			return true
	}

	return Fullmap_HandleKeyInput( key )
}
#endif          

#if CLIENT
bool function Control_ShowScoreboardOrMapHandleMoveInput( float x, float y )
{
	return Fullmap_HandleMoveInput( x, y )

	unreachable
}
#endif          

#if CLIENT
bool function Control_ShowScoreboardOrMapHandleViewInput( float x, float y )
{
	return Fullmap_HandleViewInput( x, y )

	unreachable
}
#endif          

#if CLIENT
void function Control_HideScoreboardOrMap_Teams()
{
	entity player = GetLocalClientPlayer()

	HudInput_PopContext()
	Scoreboard_SetVisible( false )

	HideFullmap()
	Control_OnInGameMapHide()

	if ( IsValid( player ) )
	{
		player.Signal( "Control_PlayerHideScoreboardMap" )
	}
}
#endif          

#if CLIENT
void function Control_OnInGameMapShow()
{
	if ( IsValid( file.inGameMapRui ) )
		return

	entity localPlayer = GetLocalViewPlayer()
	if ( !IsValid( localPlayer ) )
		return

	var rui = CreateTransientFullscreenRui( $"ui/control_teams_map.rpak", 0)
	RuiSetBool( rui, "showBottomBar", true )

	string playlist = GetCurrentPlaylistName()
	string playlistUiRules = GetPlaylistVarString( playlist, "ui_rules", "" )
	RuiSetBool( rui, "rulesEnabled", playlistUiRules != "" )

	foreach( int idx, wp in file.spawnWaypoints )
	{
		int waypointType = wp.GetWaypointInt( INT_WAYPOINT_TYPE )
		bool isSpawnWaypoint = waypointType == CONTROL_WAYPOINT_BASE0_INDEX || waypointType == CONTROL_WAYPOINT_BASE1_INDEX || waypointType == CONTROL_WAYPOINT_POINT_INDEX

                      
                                                    
                          
                            

		if ( isSpawnWaypoint )
		{
			var nestedRui = RuiCreateNested( rui, "spawn" + idx, $"ui/control_spawn_button.rpak"  )

			file.inGameMapPointsToRuis[ wp ] <- nestedRui

			if ( waypointType == CONTROL_WAYPOINT_POINT_INDEX )
			{
				entity objective = wp.GetParent()
				RuiTrackFloat( nestedRui, "capturePercentage", objective, RUI_TRACK_WAYPOINT_FLOAT, FLOAT_CAP_PERC )
				RuiTrackInt( nestedRui, "currentControllingTeam", objective, RUI_TRACK_WAYPOINT_INT, INT_TEAM_CAPTURING )
				RuiTrackInt( nestedRui, "currentOwner", objective, RUI_TRACK_WAYPOINT_INT, CONTROL_INT_OBJ_TEAM_OWNER )
				RuiTrackInt( nestedRui, "neutralPointOwnership", objective, RUI_TRACK_WAYPOINT_INT, CONTROL_INT_OBJ_NEUTRAL_TEAM_OWNER )
				RuiTrackInt( nestedRui, "team0PlayersOnObj", objective, RUI_TRACK_WAYPOINT_INT, INT_TEAM0_PLAYERSONOBJ )
				RuiTrackInt( nestedRui, "team1PlayersOnObj", objective, RUI_TRACK_WAYPOINT_INT, INT_TEAM1_PLAYERSONOBJ )
			}

                       
                                                                               
     
                                                                                                                                        
      
                                                                  
      
         
      
                                                 
      
     
                             
		}
	}

	file.inGameMapRui = rui

	thread Thread_Control_InGameMapData()
}
#endif          

#if CLIENT
void function Thread_Control_InGameMapData()
{
	while( file.inGameMapRui != null )
	{
		foreach( int idx, wp in file.spawnWaypoints )
		{
			if( wp in file.inGameMapPointsToRuis )
			{
				var nestedRui = file.inGameMapPointsToRuis[ wp ]
				int waypointType = wp.GetWaypointInt( INT_WAYPOINT_TYPE )

				float[2] screenPos = GetScreenSpace( wp.GetOrigin() )

				UISize screenSize = GetScreenSize()

				screenPos[0] =  screenPos[0] / screenSize.width
				screenPos[1] =  screenPos[1] / screenSize.height

				int playerAlliance = AllianceProximity_GetAllianceFromTeam( GetLocalViewPlayer().GetTeam() )
				int yourTeamIndex = ( playerAlliance == 0 ) ? 0 : 1

				string nameInformation = ""
				asset waypointImage = $""
				bool shouldShowObjective = true

				switch( waypointType )
				{
					case CONTROL_WAYPOINT_BASE0_INDEX:
					case CONTROL_WAYPOINT_BASE1_INDEX:
						nameInformation = ""
						waypointImage = CONTROL_WAYPOINT_BASE_ICON
						shouldShowObjective = false
						break
					case CONTROL_WAYPOINT_PLAYER_INDEX:
						if ( IsValid( wp.GetParent() ) && wp.GetParent().IsPlayer() )
							nameInformation = wp.GetParent().GetPlayerName()
						break
					case CONTROL_WAYPOINT_POINT_INDEX:
						if ( IsValid( wp.GetParent() ) )
						{
							int objectiveID = wp.GetParent().GetWaypointInt( INT_OBJECTIVE_ID )
							nameInformation = Control_GetObjectiveNameFromObjectiveID_Localized( objectiveID )
						}
						shouldShowObjective = true
						break
                         
                                     
                                                             
                                         
                                 
           
                               
				}

				bool isSpawnWaypoint = waypointType == CONTROL_WAYPOINT_BASE0_INDEX || waypointType == CONTROL_WAYPOINT_BASE1_INDEX || waypointType == CONTROL_WAYPOINT_POINT_INDEX
				bool isValidNonHomeBaseSpawn = true

                        
                                                      
      
                            
                                     
      
                              

				if( isSpawnWaypoint )
				{
					RuiSetString( nestedRui, "objectiveName", nameInformation )
					RuiSetImage( nestedRui, "centerImage", waypointImage )
					RuiSetFloat2( file.inGameMapRui, "posSpawn" + idx, < screenPos[0], screenPos[1], 0.0 > )
					RuiSetInt( nestedRui, "yourTeamIndex", yourTeamIndex )
					RuiSetBool( nestedRui, "isDisabled", true )
					RuiSetBool( nestedRui, "shouldShowObjective", shouldShowObjective )
				}

				if ( waypointType == CONTROL_WAYPOINT_BASE0_INDEX || waypointType == CONTROL_WAYPOINT_BASE1_INDEX )
				{
					if ( waypointType == yourTeamIndex )
						RuiSetFloat2( file.inGameMapRui, "baseSpawnScreenspace", < screenPos[0], screenPos[1], 0.0 >  )
				}
				else if ( isValidNonHomeBaseSpawn )
				{
					int objID = wp.GetParent().GetWaypointInt( INT_OBJECTIVE_ID )
					int waypointOwner = wp.GetParent().GetWaypointInt( CONTROL_INT_OBJ_TEAM_OWNER )
					bool isFOB = Control_IsPointAnFOB( objID )
					bool isFOBForLocalPlayer = isFOB && ( ( objID == 0 && yourTeamIndex == 0) || (objID != 0 && yourTeamIndex !=  0) )
					bool isYourWaypoint = waypointOwner == AllianceProximity_GetAllianceFromTeam( GetLocalViewPlayer().GetTeam() )
					if ( isFOBForLocalPlayer )
					{
						RuiSetFloat2( file.inGameMapRui, "fobSpawnScreenspace", < screenPos[0], screenPos[1], 0.0 > )
						RuiSetBool( file.inGameMapRui, "canSpawnOnFOB", isYourWaypoint )
					}
					else if ( !isFOB )
					{
						RuiSetFloat2( file.inGameMapRui, "centralSpawnScreenspace", < screenPos[0], screenPos[1], 0.0 > )
						RuiSetBool( file.inGameMapRui, "canSpawnOnCentral", isYourWaypoint )
					}
					if(objID >= 0 && objID <= 2)
						RuiSetBool( GetFullmapGamestateRui(), "isOnObjective" + objID,  Control_Client_IsOnObjective( wp.GetParent(), GetLocalViewPlayer() ) )
				}

				if( waypointType == CONTROL_WAYPOINT_POINT_INDEX )
				{
					if ( wp.GetParent().GetWaypointFloat( FLOAT_BOUNTY_AMOUNT ) > 0 )
						RuiSetBool( nestedRui,"hasEmphasis", true )
					else
						RuiSetBool( nestedRui,"hasEmphasis", false )
				}
			}
		}
		WaitFrame()
	}
}
#endif          

#if CLIENT
void function Control_OnInGameMapHide()
{
	Fullmap_SetVisible_MapOnly( false )

	if ( IsValid( file.inGameMapRui ) )
	{
		file.inGameMapPointsToRuis.clear()
		RuiDestroy( file.inGameMapRui )
		file.inGameMapRui = null
	}
}
#endif          

#if CLIENT
ScoreboardData function Control_GetScoreboardData()
{
	ScoreboardData data

	if ( Control_GetIsWeaponEvoEnabled() )
	{
		data.columnDisplayIcons.append( $"rui/hud/gametype_icons/control/control_ratings" )
		data.columnNumDigits.append( 5 )
		data.columnDisplayIconsScale.append( 1.0 )
	}

	data.columnDisplayIcons.append( $"rui/hud/gamestate/player_kills_icon" )
	data.columnNumDigits.append( 3 )
	data.columnDisplayIconsScale.append( 1.0 )

	data.numScoreColumns = data.columnDisplayIcons.len()

	return data
}
#endif          

#if CLIENT
bool function BindTeamButtonCommon( var button, bool friendly )
{
	array<entity> teamPlayers = GetTeamPlayers( friendly )

	int row = int( Hud_GetScriptID( button ) )

	if ( row >= teamPlayers.len() )
	{
		Hud_Hide( button )
		return false
	}

	Hud_Show( button )

	return true
}
#endif          

#if CLIENT
array<entity> function GetTeamPlayers( bool friendly )
{
	if ( IsLocalPlayerOnTeamSpectator() )
		return []

	array<entity> friendlies = GetPlayerArrayOfTeam( GetLocalClientPlayer().GetTeam() )

	int enemyTeam = GetOtherTeam( GetLocalClientPlayer().GetTeam() )
	array<entity> enemies = GetPlayerArrayOfTeam( enemyTeam )

	if ( Control_IsModeEnabled() )
	{
		friendlies.clear()
		enemies.clear()
		foreach( matchPlayer in GetPlayerArray() )
		{
			if ( IsValid( matchPlayer ) && AllianceProximity_GetAllianceFromTeam( matchPlayer.GetTeam() ) == AllianceProximity_GetAllianceFromTeam( GetLocalClientPlayer().GetTeam() ) )
			{
				friendlies.append( matchPlayer )
			}
			else if ( IsValid( matchPlayer ) )
			{
				enemies.append( matchPlayer )
			}
		}
	}

	array<entity> teamPlayers = friendly ?friendlies : enemies
	return teamPlayers
}
#endif          

#if CLIENT
array< int > function Control_GetPlayerScores( entity player )
{
	array< int > scores

	if ( Control_GetIsWeaponEvoEnabled() )
	{
		int points = player.GetPlayerNetInt( "control_personal_score" )
		scores.append( points )
	}

	int kills = player.GetPlayerNetInt( "kills" )
	scores.append( kills )

	return scores
}
#endif          

#if CLIENT
array< entity > function Control_SortPlayersByScore( array< entity > teamPlayers, ScoreboardData gameData )
{
	teamPlayers.sort( int function( entity a, entity b )
		{
			array< int > aScores = Control_GetPlayerScores( a )
			array< int > bScores = Control_GetPlayerScores( b )

			if ( aScores[0] > bScores[0] ) return -1
			else if ( aScores[0] < bScores[0] ) return 1
			return 0
		}
	)

	return teamPlayers
}
#endif          

#if CLIENT
void function Control_ScoreboardUpdateHeader( var headerRui, var frameRui,  int team )
{
	bool isFriendly = team == AllianceProximity_GetAllianceFromTeam( GetLocalClientPlayer().GetTeam() )

	if( headerRui != null )
	{
		RuiSetString( headerRui, "headerText", Localize( isFriendly ? "#ALLIES" : "#ENEMIES" ) )

		vector color  = SrgbToLinear( GetKeyColor( COLORID_CONTROL_FRIENDLY ) / 255 )
		if( !isFriendly )
			color  = SrgbToLinear( GetKeyColor( COLORID_CONTROL_ENEMY ) / 255 )

		RuiSetColorAlpha( headerRui, "teamColor", color, 1.0 )

		if( frameRui != null )
			RuiSetColorAlpha( frameRui, "teamColor", color, 1.0 )
	}

	int winningTeam = -1
	if( ( GetAllianceTeamsScore( ALLIANCE_A ) + GetAllianceTeamsScore( ALLIANCE_B ) ) > 0 )
		winningTeam = Control_GetLeadingAlliance()

	RuiSetBool( headerRui, "isWinning", ( winningTeam == team ) )

	if( team >= 0 )
	{
		ControlTeamData data = file.teamData[ team ]
		if( headerRui != null )
		{
			RuiSetInt( headerRui, "teamScoreFromPoints", data.teamScoreFromPoints )
			RuiSetInt( headerRui, "teamScoreFromBonus", data.teamScoreFromBonus )
			RuiSetInt( headerRui, "teamScorePerSec", data.teamScorePerSec )
		}
	}
}
#endif          

#if CLIENT
                                                                                         
void function ServerCallback_Control_UpdateExtraScoreBoardInfo( int teamIndex, int scoreFromPoints, int scoreFromBonuses )
{
	if ( !IsValid( GetLocalViewPlayer() ) )
		return

	int index = ( AllianceProximity_GetAllianceFromTeam( GetLocalViewPlayer().GetTeam() ) == teamIndex )? 0: 1

	ControlTeamData data
	data.teamScoreFromBonus = scoreFromPoints
	data.teamScoreFromBonus = scoreFromBonuses
	data.teamScorePerSec = file.teamData[index].teamScorePerSec

	file.teamData[index] = data
}
#endif          

#if CLIENT
bool function Control_IsPlayerInMapCameraView ( entity player )
{
	return file.isPlayerInMapCameraView
}

#endif          

#if SERVER
                                                                                                  
                                            
 
	                                            
	 
		                                                                                                                                                                                                 
		                                                                                                                                                                                                 
	 
 
#endif          

  
		                                                         
		                                                          
		                                                        
		                                                         
		                                                          
		                                                         

		         
  


#if SERVER
                                                                                                    
                                                       
 
	                                                                        
 
#endif          

#if SERVER
                                          
                                                                
 
	                         
		      

	                                                                        
		      

	                                                                                                                                                                
	                                                                                     
		                                                                                                                                              
 
#endif          

#if SERVER
                                                                            
 
	                                               

	                         
		      

	                             
	                               

	                              

	                                  
		                                                 
	                              
		                                              

	                                                   
	                                                                
		                                                  

	           

	                                                                                                                                                                                                 
	                                                                                           
	                                                              
	                                                                                                                  
	                                                                 

	                                                                                                                                                                                               
	                                      
	                                                                            
	                            

	                                                                                                                                                                      
	 
		                                                              
		                                                            
			                                                       

		                                                                                                                                                                                               
		                                                                                                                                                                                                             
		 
			                                                       
		 
		                                                                 
		 
			                                                                              
		 

		                                               
	 
	                                      
	 
		                        
		                                                              
		                                                             
			                                                       

		                                                                                                                                                                                                 
		                                                                                                                                                                                                               
		 
			                                                       
		 
		                                                                  
		 
			                                                                               
		 
	 

	                                                                                      
	                                         
	                                                              
	                                                                                                         

	                                              
	                                 

	                                  
	 
		                                                                        
		                                                  
		                                        
			                                                                       
	 

	                                                                                                        
	 
		                                                         
	 
	                                                                                                             
	 
		                                                                    
	 

	                                                                                                                                   

	                        
	                                                                                                           

	                                                                             
	                                      
	 
		                                                        
	 
	    
	 
		                 
		                                                                                                            
		                                                                          

		               
		                                                                                                
		                                                                                

		                   
		                                                                                                            
		                                                                             
	 

	                                                                     
	         
	                                                                                                                                             
	                                                                                                                                                                                                                                        

	                     
	 
		                       
		 
			                                                                                 
		 
		    
		 
			                                                                             
		 
	 

	                                                                              
	                                           
 
#endif          

#if CLIENT
                                                                                                                                                      
void function ServerCallback_Control_SetIsPlayerUsingLosingExpTiers( bool shouldUseLosingTeamTiers )
{
	entity player = GetLocalClientPlayer()
	if ( !IsValid( player ) )
		return

	if ( shouldUseLosingTeamTiers && !file.playersUsingLosingTeamExpTiersArray.contains( player ) )
	{
		file.playersUsingLosingTeamExpTiersArray.append( player )
	}
	else if ( !shouldUseLosingTeamTiers && file.playersUsingLosingTeamExpTiersArray.contains( player ) )
	{
		file.playersUsingLosingTeamExpTiersArray.fastremovebyvalue( player )
	}
}
#endif          

#if CLIENT
void function UICallback_Control_Loadouts_OnClosed()
{
	if ( !GetLocalClientPlayer().GetPlayerNetBool( "Control_IsPlayerOnSpawnSelectScreen" ) )
		return

	CreateRespawnBlur()
	RunUIScript( "UI_OpenControlSpawnMenu", true )

	entity player = GetLocalClientPlayer()
	                                                                                             
	if( IsValid( player ) && !file.tutorialShown && GetStat_Int( player, ResolveStatEntry( CAREER_STATS.modes_games_played, GAMEMODE_CONTROL ), eStatGetWhen.CURRENT ) == 0 )
		RunUIScript( "UI_OpenGameModeRulesDialog" )

	file.tutorialShown = true

	if ( ClGameState_GetRui() != null )
		RuiSetBool( ClGameState_GetRui(), "isInSpawnMenu", true )
}
#endif          


  
		                            
		                             
		                          
		                          
		                          
		                          

		     
  

#if SERVER
                                                          
                                                     
 
	                          
		      

                     
                                                                    
                                              
   
                                                                               
                                                                                 
    
                                                             
                              
                                                     
                                        

                                            
     
                                                
                                                               
     

                                                           
    
   
                           

	                                             
		                                   
 
#endif          

#if SERVER
                                                                                                                
                                               
                                                
                                                  
                                                  
                                         
 
	                                               

	                                             
	 
		                           
		                                     
	 
 
#endif          

#if SERVER
                                                                   
                                         
 
	                                            

	                        
	 
		                      
		 
			                                                  
			                                                                         

			                                                                      
			                                           
			 
				                                                                                                                                                  
				 
					                                              
				 
				                                                                                        
				 
					                                                                                                                   
					 
						                                            
					 
					                                                                                                                           
					 
						                                              
					 
				 
				                                                                                                                                                                                                            
				 
					                                              
				 
			 

			                                                                         
			                                               
			 
				                                           
				              
			 
		 
	 
 
#endif          

  
	                                                       
	                                                        
	                                                   
	                                                   
	                                                       
	                                                        

	                      
  


#if CLIENT || SERVER
                                                     
int function Control_GetPlayerExpTotal( entity player, bool shouldRemoveInitialTierBoostEXP = false, int boostTier = -1 )
{
	int expTotal = 0
	if ( IsValid( player ) )
		expTotal = player.GetPlayerNetInt( "control_current_exp_total" )

	                                                                                                                            
	                                                                                                  
	if ( shouldRemoveInitialTierBoostEXP )
	{
		if ( boostTier == -1 )
			boostTier = Control_GetDefaultWeaponTier()

		int boostEXP = Control_GetExpThresholdForTier( boostTier, player )
		expTotal = maxint( ( expTotal - boostEXP ), 0 )
	}

	return expTotal
}
#endif                    

#if CLIENT || SERVER
                                   
int function Control_GetPlayerExpTier( entity player, bool useClampedValue = true )
{
	int expTier = Control_GetDefaultWeaponTier()

	if ( IsValid( player ) && player.GetPlayerNetInt( "control_current_exp_tier" ) >= expTier )
		expTier = player.GetPlayerNetInt( "control_current_exp_tier" )

	                                                                                                                         
	if ( useClampedValue )
		expTier = minint( expTier, CONTROL_MAX_EXP_TIER )

	return expTier
}
#endif                    

#if CLIENT || SERVER
                                                                    
int function Control_GetExpTierFromExpTotal( int expTotal, entity player, bool useClampedValue = true )
{
	int expTier = 1

	if ( !IsValid( player ) )
		return expTier

	int nextExpTier = 2
	int expThreshold = Control_GetExpThresholdForTier( nextExpTier, player )

	while ( expTotal >= expThreshold )
	{
		expTier++
		nextExpTier++
		expThreshold = Control_GetExpThresholdForTier( nextExpTier, player )
	}

	if ( useClampedValue )
		expTier = minint( expTier, CONTROL_MAX_EXP_TIER )

	return expTier
}
#endif                    

#if CLIENT || SERVER
                                                                        
int function Control_GetExpToNextExpTier( entity player )
{
	int currentExp = Control_GetPlayerExpTotal( player )
	int nextExpTier = Control_GetExpTierFromExpTotal( currentExp, player, false ) + 1
	int nextExpThreshold = Control_GetExpThresholdForTier( nextExpTier, player )
	int expNeeded = 0

	if ( nextExpThreshold > 0 )
		expNeeded = nextExpThreshold - currentExp

	return expNeeded
}
#endif                    

#if CLIENT || SERVER
                                                     
int function Control_GetExpThresholdForTier( int tier, entity player )
{
	int expThreshold = 999
	if ( !IsValid( player ) )
		return expThreshold

	string playlistVarModifier = ""
	bool shouldAdjustToLosingTeam = file.playersUsingLosingTeamExpTiersArray.contains( player ) ? true : false

	if ( shouldAdjustToLosingTeam )
		playlistVarModifier = "losingteam_"

	if ( tier <= CONTROL_MAX_EXP_TIER )
	{
		expThreshold = GetCurrentPlaylistVarInt( "exp_requirement_" + playlistVarModifier + "tier" + tier, 0 )
	}
	else
	{
		                                            
		int tiersPastMax = tier - CONTROL_MAX_EXP_TIER

		                                                        
		int expDifferenceToMaxTier = ( GetCurrentPlaylistVarInt( "exp_requirement_" + playlistVarModifier + "tier" + ( CONTROL_MAX_EXP_TIER + 1 ), 0 ) ) - ( GetCurrentPlaylistVarInt( "exp_requirement_" + playlistVarModifier + "tier" + CONTROL_MAX_EXP_TIER, 0 ) )

		expThreshold = GetCurrentPlaylistVarInt( "exp_requirement_" + playlistVarModifier + "tier" + CONTROL_MAX_EXP_TIER, 0 ) + ( tiersPastMax * expDifferenceToMaxTier )
	}
	return expThreshold
}
#endif                    

#if CLIENT || SERVER
                                                                        
int function Control_GetExpDifferenceBetweenLastTierAndTier( int tier, entity player )
{
	int expDifference = -1

	if ( !IsValid( player ) )
		return expDifference

	                                                                                                                                
	if ( tier > CONTROL_MAX_EXP_TIER )
	{
		expDifference = Control_GetExpThresholdForTier( CONTROL_MAX_EXP_TIER + 1, player ) - Control_GetExpThresholdForTier( CONTROL_MAX_EXP_TIER, player )
	}
	else if ( tier >= 2 )                                                                          
	{
		expDifference = Control_GetExpThresholdForTier( tier, player ) - Control_GetExpThresholdForTier( tier - 1, player )
	}

	Assert( expDifference >= 0, "Control_GetExpDifferenceBetweenLastTierAndTier getting a negative difference value which should never happen" )
	return expDifference
}
#endif                    

#if CLIENT || SERVER
                                                                           
float function Control_GetEXPPercentToNextTier( entity player )
{
	float expPercentToNextTier = 0.0

	if ( IsValid( player ) )
	{
		int expTier = Control_GetPlayerExpTier( player, false )
		float currentExp = float( Control_GetPlayerExpTotal( player, true, expTier ) )
		float nextExpThreshold = float( Control_GetExpDifferenceBetweenLastTierAndTier( expTier + 1, player ) )
		if ( nextExpThreshold > 0.0 )
			expPercentToNextTier = ( currentExp / nextExpThreshold )
	}

	return expPercentToNextTier
}
#endif                    

#if CLIENT || SERVER
                                          
bool function Control_IsPlayerUltReady( entity player )
{
	if ( !IsValid( player ) )
		return 	false

	entity ultimateWeapon = player.GetOffhandWeapon( OFFHAND_ULTIMATE )
	if ( !IsValid( ultimateWeapon ) )
		return 	false

	int currentUltCharge = ultimateWeapon.GetWeaponPrimaryClipCount()
	int maxUltCharge = ultimateWeapon.GetWeaponPrimaryClipCountMax()

	if ( currentUltCharge >= maxUltCharge )
		return true

	if ( ultimateWeapon.HasMod( MOBILE_HMG_ACTIVE_MOD ) || ultimateWeapon.HasMod( ULTIMATE_ACTIVE_MOD_STRING ) )
		return true

	return false
}
#endif                    

#if SERVER
                                                                    
                                                       
 
	                                                             
		      

	                                                            
	                                                                                 
	                                                             
	                                                                                        
	                                                 

	                     
	 
		                                                                                 
		                                                             

		                                          
		                                                            
		                                                             
		                                                                 
		                                                                       
		                                                                            
		                                                                                                                                                                          

		                                                                                                        
		                                                                      
		 
			                           
		 
		                                                                                                                                                                           	        
		 
			                                                               
				                                                     
			                                                                                                          
		 

		                                                              
		                                                                    
	 
	    
	 
		                                                                                            
		                                                                              
	 
 
#endif          

#if SERVER
                                                                                                                                    
                                                
 
	                                               
		      

	                                                                                                                                                  
	                                                                      

	                                                                  
	                                                                                                          

	                              
	                                                            
	                                                

	               
	                                                             
	                                                                 
	                                                                       
	                                                                            

	                                                                                     
	                                                                                         
	                                                                           

	                              
	                                        
		                                                                                            
 
#endif          

#if SERVER
                                                    
                                                                                                                                                                                                               
                                                                                                                 
                                                                                    
 
	                                               

	                         
		      

	                                                         
	                             
	                               

	                                                                   
	 
		                               
		                                                         
	 


	            
		                       
		 
			                                                                                       
			 
				                              
				                                                                    
			 
		 
	 

	                                       
 
#endif          

#if SERVER
                                                                                                                                                                 
                                                                                     
 
	                         
		      

	                                                           
	                       
		      

	                                                                    
	                                                                   
		      

	                                                                  
	                                                                
	                           
 
#endif          

#if SERVER
                                                                                                                                 
                                                                                                                                  
                                                                                                   
 
	                         
		      

	                                                                   
	                                 
		      

	                                         
		      

	                                                                

	                                                                                                       
	                            
	                           
		                                                

	                                                                                        
	                                                                        
 
#endif          

#if SERVER
                                                
                                                              
 
	                         
		      

	                                        
	                                                                   
	                                
	 
		                                                          
		                                                                
		                                
			                                                        
	 

	                                                                                                                  
	                                                                                                      
	 
		                                                                   
		                                
		 
			                                                          
			                                                                
			                                
				                                                        

			                                                          
		 
	 
 
#endif          

#if SERVER
                                              
                                                                               
 
	                            

	                                                                                                                                  
		                      

	                                        
		                      

	                                                                 

	                                      
		                                                                 

	                                                             

	                                                                     
	                     
	 
		                                                                                                                                                 
		                              

		                                
			                                                                                     

		                                                                    
		                                              
		                                           

		                                                                                                                                  
		 
			                                                                                                                                          
			                                     
			                      
			                                     
			 
				                                          
					        

				                                                               
				                                                      
				 
					                         
					     
				 
			 

			                                                                                                                             
			                      

			                                      
			 
				                                                                                        
			 
			    
			 
				                                                                                            
				                                      
				                    
			 

			                           
			                                         
			 
				                                              
					        

				                                                                   
				                                                     
				 
					                            
						                    
					    
						                             
					                    
					     
				 
			 

			                                             
			 
				                                  
			 

			                                     
			 
				                                      
				 
					                          
				 
			 

			                                                                                             
			                           
			                
			 
				                                               
			 

			                                                        
			                                                           
			                
			                                                                                              
			                                         

			                                                                    
			                                            

			                                                                                                         
			                                                                     
			                         
			                                                   

			                
			 
				                                               
				                                                
				                                         

				                                                                       
				                                                           
					                                     
			 


			                                                                                                                                                                                
			                                                     
			 
				                        
				 
					                                                                         
				 
				    
				 
					                                                                                              
				 
			 
			                      
		 
	 
	                      
 
#endif          

#if SERVER
                                  
                                                                     
 
	                              
	                                                              
	                                        
	                                                              
	                                                                                                                              

	                                                               
		                        

	                        
 
#endif          

#if SERVER
                                  
                                                                                                 
 
	                                
		      

	                                                     
		      

	                                                                                                      
	                                                                                                                                     

	                                                                                                                    
	                                            
	                                                                  
	                                             
	 
		                         
			        

		                              
			        

		                                     
		                                                                     
			                                                                                                         
	 

 
#endif          

#if CLIENT
const float CONTROL_DEFAULT_WEAPON_EVO_VFX_DELAY = 0.5
                                                                  
void function ServerCallback_Control_PlayAllWeaponEvoUpgradeFX( entity player, int expTier, bool didWeaponEvo )
{
	if ( !IsValid( player ) )
		return

	if ( expTier <= 0 || expTier > CONTROL_MAX_EXP_TIER )
		return

	thread Control_PlayAllWeaponEvoUpgradeFX_Thread( player, expTier, didWeaponEvo )
}
#endif          

#if CLIENT
                                                                                
void function Control_PlayAllWeaponEvoUpgradeFX_Thread( entity player, int expTier, bool didWeaponEvo )
{
	Assert( IsNewThread(), "Must be threaded off" )

	int activeWeaponSlot = SURVIVAL_GetActiveWeaponSlot( player )
	entity activePrimaryWeapon = player.GetNormalWeapon( activeWeaponSlot )
	float timeToWait = CONTROL_DEFAULT_WEAPON_EVO_VFX_DELAY

	                                                                                                                                                                                                           
	if ( IsValid( activePrimaryWeapon ) )
		timeToWait += activePrimaryWeapon.GetWeaponSettingFloat( eWeaponVar.deploy_time )

	wait timeToWait

	if ( !IsValid( player ) )
		return

	                                                               
	switch ( expTier )
	{
		case 1:
			EmitUISound( CONTROL_SFX_WEAPON_EVO_LVL_1 )
			break

		case 2:
			EmitUISound( CONTROL_SFX_WEAPON_EVO_LVL_2 )
			break

		case 3:
			EmitUISound( CONTROL_SFX_WEAPON_EVO_LVL_3 )
			break

		case 4:
			EmitUISound( CONTROL_SFX_WEAPON_EVO_LVL_4 )
			break
	}

	                                                                        
	activeWeaponSlot = SURVIVAL_GetActiveWeaponSlot( player )
	activePrimaryWeapon = player.GetNormalWeapon( activeWeaponSlot )

	if ( !IsValid( activePrimaryWeapon ) )
		return

	                                   
	vector tierColor = GetFXRarityColorForTier( expTier )
	int fxHandle = activePrimaryWeapon.PlayWeaponEffectReturnViewEffectHandle( FX_WEAPON_EVO_UPGRADE_FP, FX_EXP_LEVELUP_3P, "hcog", true )                 
	EffectSetControlPointVector( fxHandle, 1, tierColor )

}
#endif          

#if CLIENT
                                                                  
void function ServerCallback_Control_Play3PEXPLevelUpFX( entity player, int expTier )
{
	if ( !IsValid( player ) )
		return

	if ( player == GetLocalClientPlayer() )
		return

	if ( !player.DoesShareRealms( GetLocalClientPlayer() ) )
		return

	if ( expTier <= 0 || expTier > CONTROL_MAX_EXP_TIER )
		return

	thread Control_Play3PEXPLevelUpFX_Thread( player, expTier )
}
#endif          

#if CLIENT
                                                                
void function Control_Play3PEXPLevelUpFX_Thread( entity player, int expTier )
{
	Assert( IsNewThread(), "Must be threaded off" )

	int activeWeaponSlot = SURVIVAL_GetActiveWeaponSlot( player )
	entity activePrimaryWeapon = player.GetNormalWeapon( activeWeaponSlot )
	float timeToWait = CONTROL_DEFAULT_WEAPON_EVO_VFX_DELAY

	                                                                                                                                                                                                           
	if ( IsValid( activePrimaryWeapon ) )
		timeToWait += activePrimaryWeapon.GetWeaponSettingFloat( eWeaponVar.deploy_time )

	wait timeToWait

	if ( !IsValid( player ) )
		return

	                                                                        
	activeWeaponSlot = SURVIVAL_GetActiveWeaponSlot( player )
	activePrimaryWeapon = player.GetNormalWeapon( activeWeaponSlot )

	if ( !IsValid( activePrimaryWeapon ) )
		return

	                            
	vector tierColor = GetFXRarityColorForTier( expTier )
	int fxHandle = activePrimaryWeapon.PlayWeaponEffectReturnViewEffectHandle( $"", FX_EXP_LEVELUP_3P, "hcog", true )
	EffectSetControlPointVector( fxHandle, 1, tierColor )

}
#endif          


  
                                                                                 
                                                                                  
                                                                                
                                                                                 
                                                                                  
                                                                                 

               
  

#if SERVER
                                                                         
                                                                
                                                                                                
 
	                                        
	                                                                                           
	                                                                               

	                                                                      
 
#endif          

#if SERVER
                                                                                                  
                                                                 
 
	                                                                           
	                                                                                                                                               
	                                                                
	                                                                                            

	                                                                                     
	                                                                        
	 
		                                          
		 
			                                                                                                  
		 
		                                       
	 

	                                                                                                   
	                                                                                       
 
#endif          

#if SERVER
                                                      
                                     
                                                                                                                                                             
                                                                                                       
 
	                                        
	                                                                       
	                                                                                                              
	                                                                            

	                                                                                                            
 
#endif          

#if CLIENT
                                                                   
void function ServerCallback_Control_DisplayLockoutUnavailableWarning()
{
	var scoreTrackerRui = file.scoreTrackerRui[1]
	var mapScoreTrackerRui = file.fullmapScoreTrackerRui[1]
	float currentTime = Time()

	if ( IsValid( scoreTrackerRui ) )
	{
		RuiSetGameTime( scoreTrackerRui, "lastLockoutBlockedMessageDisplayTime", currentTime )
	}

	if ( IsValid( mapScoreTrackerRui ) )
	{
		RuiSetGameTime( mapScoreTrackerRui, "lastLockoutBlockedMessageDisplayTime", currentTime )
	}
}
#endif          

#if SERVER
                                        
                                                                
 
	                                        
	                                                                               
	                                                                                                                                                       
	                                                                                          

	                                                                                        
	                                   
	                                                         
	 
		                              
		 
			                             
			     
		 
	 

	                                                                                                          
 
#endif          

#if SERVER
                                                                 
 
	                                                                                       
	                                                                  
	                                                                              
 
#endif          

                    
          
                                                                       
 
                                                                                                  
 
                
                          

  
	                                                                                       
	                                                                                        
	                                                                                     
	                                                                                      
	                                                                                       
	                                                                                        

	                               
  

#if SERVER
                                                                         
 
	                                               

	                                                                     

	                                         
	                                                               

	                                                  
	                                                
	                                                                                               
	                                                                                                                

	       
		                                                                                                                                              
	             

	                                                     

	                                     
	                                                                                                  

	                                      
	                                    
	                                               
	 
		                                                                      
		 
			                           
			        
		 
		                                        
		 
			                                                                                             
				                           
		 
	 

	                                        
	                                              
	 
		                                                                       
		            
			                                    
			 
				              
				                                              
					                                                                       

				                                            
			 
		 

		       
			                                                                                                          
		             

		                                                                                
		                                                                                  
		                                           
		                                            

		                                                 

		                                                                                      
		                      
		                                               
	 
	    
	 
		       
			                                                                              
		             

		                             
	 

	                                 
	                                                         

	                                     
	                                         
		                                                                                                                               

	                                      

	                                            
	                                                             
	 
		                                           

		                             
	 
	    
	 
		                                                                         
		                                           
		                                                                
			           

		                                           

		                             
	 
 
#endif          

#if SERVER
                                                         
                                               
 
	                                           
	                                            
	                                        

	                                               
	                                                                                                              
 
#endif          

  
		                                             
		                                               
		                                            
		                                            
		                                            
		                                            

          
  

#if SERVER
                                                                          
 
	                                               

	                                         
	                                                               

	                  
	                                 

	            
		                  
		 
			       
				                                                                   
			             

			                      

			                                 
			 
				                              
				                                                 
				                   
				      
			 
			    
			 
				                                                       
				                                                                 
			 

			                                            
			                    
			 
				                        
					                                                   
				                             
					                                                   
				                             
					                                                   
				                             
					                                                  
			 
			    
			 
				                              
				                                                 
			 
		 
	 

	                     
	                                                  

	                                                  
	                                                

	       
		                                                                                                                                                
	             

	                              
	                                                                                                                                             
	                                                                       
	                                         

	                                         
	 
		                                                                                                                        
		                                                                                  
		                                                                                     
	 

	                                                       
	 
		                       
		 
			                                
			                        
			     
		 

		           
	 

	                        
	 
		       
			                                                
		             

		                                                                          
	 
	    
	 
		                                          
	 

	                             
 
#endif          

#if SERVER
                                                   
 
	                                  
	                                                                   
	 
		                                                                

		                                               
			            

		             
		 
			                                        
		 
		    
		 
			                                                
				            
		 
	 

	           
 
#endif          

#if SERVER
                                                              
 
	                                                                       
	                                                        
	 
		                                              
			           
	 

	            
 
#endif          


  
			                                                  
		                                                       
		                                                     
	                                                          
	                                                           
	                                                          

	        
  

#if SERVER
                                       
                                                                                  
 
	                                               

	                                                                                       
	                                
	 
		       
			                                                                                       
		             

		                             
	 
	                                                                                         
	                        

	       
		                                                                                                                                                                                  
	             

	            
		                        
		 
			                             
		 
	 

	                                                                                                                       

	                                                          
	                         
	                                                         
	 
		                                                     

		                                             
		 
			                                                  
			                                                                

			                                  
				                                                     
		 
		                                                           
		 
			                                               
			                                                                              

			                                  
				                                                    
		 

		                    
		                                                                                           
		                     
		                                                                                            
	 

	                                         
	 
		                                                                                                                     
		                                                             

		                                                                                  
		                                                                        
	 

	                                        
	                            
		                                  

	                                            
	 
		                                                                                                                  
	 

	                                              

	                                           
 
#endif          

#if SERVER
                                                                                                     
                                                              
                                                                                                     
 
	                                               
	                                                                                                    

	                                       
	                                                           
	                                                
	 
		                                                   
		                                              
		 
			                                            
		 
		    
		 
			             
			                                                                                                
			                                                       
			 
				                                                           
				                               
				 
					                                                   
					     
				 
				       
			 

			                                                                 
			                                                      
				                                            
		 
	 

	                                                                                    
	                                             
	 
		                                                                                                                                                                                                 
		                                                         
		                                                
		                                                     

		                                             
		 
			                                                                               
			                                                                                     

			                                             
				                                            
		 

		                                             
		 
			                                                                                     
			                                                                                    

			                                                  
				                                                 
		 

		                          
		                                                                                                 
		                                           
		 
			                                                              
			                                                                                                                          
			                                                       

			                             
			 
				                                              
				 
					                                                   
				 
			 
		 

		                                                                                                                   
		                                                
		 
			                                                 
			                                                                
			 
				                                                                                       
				                                                                 

				                                                    
				 
					                                                                            
				 
			 
		 
		                                                                                                                                                                                                      
		 
			                                                 
			                                                  
			                                                               
			 
				                                                                                       
				                                                                                     
				                                                                                     

				                                                    
				 
					                
					 
						                                                                            
					 
					    
					 
						                                                                           
					 
				 
			 
		 

		                                                                                                        
		                                                                                          
			                                    
	 

	                                                                                                           
	                                             
		                                      

	                                   
 
#endif          

#if SERVER
                                                                                                                                      
                                                                                                       
                                                                                                             
 
	                                       
	                                     

	                                                  

	                                                                                    
	                                       
	 
		                                                                            
		                                                                                                        

		                                                                                                        
		                                                                  
			                               
	 

	                                        
	                                                      
	                                                         
	 
		             

		                                                                                                                          
		                               
		 
			                             
			 
				                                           
				                                                            
			 

			                                                 
			                                         
				                              
		 

		                                                                                               
		 
			                                            
				                                  
		 
		                                                                                                                             
		 
			                                               
				                                  
		 
		                                                                                                                             
		 
			                                               
				                                  
		 

		                                           
	 

	                                
 
#endif          

#if SERVER
                        
                                                                    
 
	                             
	                            

	                                                                             
	                                      

	                                                                                                                                           
	                                                
	 
		                             
		                                     
		                                                                               
	 

	                                      
	                      
 
#endif          

#if SERVER
                     
                                                                                                                                                                   
                                                                                                                                                
 
	                                               

	                                                         

	                                             
	                                                                                                                   
	                                    

	                                                                                                                                                   
	                                                                               
		                                                     

	                                                                                         
	                                       
	                                              

	                                                        
	                 
	                      
	                   

	            
		                                                    
		 
			                     
			 
				                    
					                
			 

			                                 
				                         

			                              
				                      
		 
	 

	                                                                                                
	                                   
	                                                    
	                                            

                     
                                                                                                                                 
                                                                                               
                     
   
                                        
                                                     
                                                                                                                                  
                                                                                  
                                                                                                       
                         
                                                                    
                                                                                                                          

                                                                               
                                                                     
                                                                                                         
                       
                                                                                                 
                                                                  

                                                                            
                                                                            

                          
                                        
    
                                  
                                 
                               
                                   

                                                
     
                                                                                                                                                                                                                  
     
    

                                                                                                                   
                                                          

                                                                                                                                   
                                                            

                       
                                    

                                                                                           
                        
    
                        
                     
    
              

                                    
                             

                                 
                          
   
                           

	                     
	                                                                                                       
	                                                                                               

                     
                                                                                                                                        
                     
                                                            
                           
 
#endif          

#if SERVER
                                                                                                                              
                                                                            
 
	                                                                                         
	 
		                                                                                        
	 
	                                                 
	 
		                                                              
	 
 
#endif          

#if SERVER
                                                                                                                          
                                                                          
 
                     
                                                                                                                                    
                                                                                                     
                                                                                                                        
                                                                                                         
   
                                      
                                                               

         
   
                           

	                
	                                                                                                                        

	                                             
		                                                 

	                                                             
	                                                            
	                          

	                                            
	                           
 
#endif          

#if SERVER
                                                   
                                                                      
 
	                                                                                                                        

	                                             
	 
		                                                  
		                    
		 
                       
                                                                        
     
                             

                                                 
      
                                                                  
                                    
                                                                    
                                                                                   
      
     
                             

			            
			                                             
			                                             
		 
	 
	                           
 
#endif          

#if CLIENT
                                                                                      
void function InstanceWPControlAirdrop( entity wp )
{
	if ( Control_ShouldShow2DMapIcons() )
	{
		int lootTier = wp.GetWaypointInt( AIRDROP_WAYPOINT_LOOTTIER_INT )
		thread Control_CreateAirdropIcon_Thread( wp, lootTier )
	}

                     
                                                     
                                                                                                             
   
                                                                 
   
                           
}
#endif          

#if CLIENT
                               
void function Control_CreateAirdropIcon_Thread( entity wp, int lootTier )
{
	Assert( IsNewThread(), "Must be threaded off" )

	FlagWait( "EntitiesDidLoad" )
	entity player = GetLocalViewPlayer()
	if ( !IsValid( player ) || !IsValid( wp ) )
		return

	player.EndSignal( "OnDestroy" )
	wp.EndSignal( "OnDestroy" )

	int airdropIconColorID
	switch( lootTier )
	{
		case -1:
			airdropIconColorID = COLORID_HUD_LOOT_TIER5
			break
		case 1:
			airdropIconColorID = COLORID_HUD_LOOT_TIER2
			break
		case 2:
			airdropIconColorID = COLORID_HUD_LOOT_TIER3
			break
		case 3:
			airdropIconColorID = COLORID_HUD_LOOT_TIER4
			break
		default:
			airdropIconColorID = COLORID_HUD_LOOT_TIER0
			break
	}

	vector iconColor = GetKeyColor( airdropIconColorID ) * ( 1.0 / 255.0 )
	var minimapRui = Minimap_AddIconAtPosition( wp.GetOrigin(), <0,90,0>, AIRDROP_LANDED_ICON, 1.0, iconColor )
	var fullmapRui = FullMap_AddIconAtPos( wp.GetOrigin(), <0,0,0>, AIRDROP_LANDED_ICON, 7.0, iconColor )

	OnThreadEnd(
		function() : ( minimapRui, fullmapRui )
		{
			Minimap_CommonCleanup( minimapRui )
			Fullmap_RemoveRui( fullmapRui )
			RuiDestroy( fullmapRui )
		}
	)

	WaitForever()
}
#endif          

  
	                                                                                                 
	                                                                                                  
	                                                                                               
	                                                                                               
	                                                                                               
	                                                                                               

	               
  

                    
          
                                                                                                                                                                     
                                                              
                                                   
 
                                                 
 
                
                          

                    
          
                                   
                                                    
                                                    
                                                                                    
                                                                                                                
                                                                                                            
                                                                                 
 
                                                

        
                                                          
              

                             

             
                          
   
          
                                                         
                

                                
                                
   
  

                                                          
   
                                          
  
                                                                                                                               
  
   

                                                                                                        

                                                                                       
                          
                                              
  
                                                    
                                                                  

                                    
                                                       
  
                                                            
  
                                           
                                                                                

                                    
                                                       
  

        
                                                            
              

                     
                                                                                              
                      
                                                                                                   

                                                 
                                                        

        
                                                                                                         
              

                                   

                                                        
   
                                          
  
                                                                                                                             
  
   
 
                
                          

                    
          
                                           
                                                                
 
                                                
                                          
                                                           

             
                 
   
          
                                                                                                            
                

                           
                       
   
  

                        

        
                                                                 
              

                                                        

        
                                                                                                         
              

                                   

        
                                                                                      
              
 

                
                          

                    
          
                                                                                                                             
                                                                      
                                                                              
 
                                                              

                           
                                                            
                       
 
                
                          

                    
          
                                                              
                                                    
                                                                            
 
                                                

                              
                                     
                                            
        

                                
                            

                                                                                                        
                                                    
                                                                    
                                                       
                                                                             

             
                          
   
                            
                         
   
  

              
 
                
                          

                    
          
                                                                                                                                                             
                                                           
 
                       
        

                               

               
        

                                                        

                                       
                                  
 
                
                          

                    
          
                                                                                                      
                                               
 
                                                             
 
                
                          

                    
          
                                                 
                                                                          
 
                                                

                      
        

                            

                                          

                               
        

                                     

                                                               

             
                              
   
                                 
    
                              
    
   
  

                                            
                                                                                   
                                                                             
                              

                                                
  
                                                              

                                                                                      
   
                                                 
    
                                                 
                                                                                      
                                                           
    
   
                                                                  
   
                                   

                                                                                     
    
                                                  
    
                                                                                                                                          
    
                                                 
                                                                         
                                                                   
    
                                                                
    
                                                 
                                                                      
                                                                   
    
   

                                      
  
 
                
                          

                    
          
                                                                  
 
           
                                     

                          
        

                                                                                                   
                                                                        
                                                                            
                                                  
                                                      

              
 
                
                          

                    
          
                                                                                                   
                                                                      
 
                             
  
                                                                                                   

                                                                   
                                                                       

                                                                       
  
 
                
                          

                    
          
                                                                                                                        
                                                                                   
 
                                                

                              
        

                                                                                         

                                  
                                    
                                              
                                                      

             
                                           
   
                               
                                                 
   
  

              
 
                
                          

                    
                    
                                                                 
 
           
                            
                 

           
                                                    
                 
 
                          
                          

                    
          
                                                                                       
                                                                  
 
                                             
 
                
                          

                    
          
                                                                                                                 
                                               
                                                  
                                                   
 
                                                

                                          

                               
        

                                     
                                   

                       

                                      

                                                                                              
                                
  
                                                                  
                                                       

                                                 
         

                                
         

                           
                                 
   
                                                                                             

                                                                             
                                                                                                             
   
      
   
                                                                                                       
   

                                                            
                                   
  
 
                
                          

                    
          
                                                       
                                                     
                                                                                  
 
                                                

                                                                                       
                                        
        

                                  
                                    
                                              
                                                      

                                                                              

              
  
                                            
                                                                                           
                                                   
  
 
                
                          

                    
          
                                                    
                                                                     
 
        
                                             
              

                                            
 
                
                          

                    
          
                                                                                 
                                                                                                                                                           
 
                          
        

                                              
        

                                                      

                        
        

                                 
  
                              
                                          
   
                                                          
                                                                         
   
                                   

                                                     
                                               
  
 
                
                          

                    
          
                                                                         
                                                                                              
                                                                                                                                           
 
                                                                                                       
  
                                                                                         
                                              
                            
                                                   
                                  
                                   
                                                     

                                                   
                                        
   
                                                                                                                                 
                                                
   
  
 
                
                          

                    
          
                                                                                                                                
                                                     
 
                                    
                                                               
        

                         
                  
                                                                                   

                     
                                                                                    
                                            

                                                                                                   
                           
                                                                  
                                                                        
 
                
                          

                    
          
                                                                 
                                                             
 
                               
                                                                                   
                            
                                      

                                                                        
                                                                          

               
 
                
                          

                    
          
                                                        
                                  
 
                               

                          
        

                                                                            

                                                                               
                                       
  
                                                                                                                                                                                                            
   
                                                                                                                                                                                                                                 
                                                                                 
   
  

                      
                           
                                                  
                                            
                 

                                         
  
                                  
                               
  

                                             
                                   
 
                
                          

  
	                                   
	                                    
	                                   
	                                    
	                                    
	                                    

	                  
  

#if DEV && SERVER
                                              
                                                                                           
 
	                       
	 
		                                                 
		 
			                                                       
				                                                                                 
		 
	 
	    
	 
		                                   
		                                             
			                                                                            
	 
 
#endif                 

#if DEV && SERVER
                                                                         
                                                                          
 
	                     

	                        
	 
		                                                 
		 
			                                                       
			 
				                                                          
				                                                                                     
			 
		 
	 
	    
	 
		                                   
		                                             
		 
			                                                     
			                                                                                
		 
	 
 
#endif                 

#if DEV && SERVER
                  
                                                                           
 
	                                                                
	                                                       
	 
		                                   
		                         
		 
			                                                                                                                                                      
			      
		 
		                                                                    
	 

	                                                        
	 
		                                  
		                             
		                                                                    
		                                  
	 
 
#endif                 

#if DEV && SERVER
                        
                                             
 
	                                                      
	 
		                                                                                                            
	 

	                                                             
 
#endif                 

#if DEV && SERVER
                             
                                                                                                 
 
	                                                      
	 
		                                                                                         
	 

	                               
	                                                        
	 
		                                                  
		 
			                      
			     
		 
	 

	                                         
	 
		                                                                                                                           
		                                                       
		 
			                                                        
			 
				                                                                                   
			 
			    
			 
				                                   
				                         
				 
					                                                                                                                                                          
					      
				 
				                                                                    
			 
		 

		                                           
		                                      
		                                                                             
		                                           
	 
	    
	 
		                                                                                                       
	 
 
#endif                 

#if DEV && SERVER
                                
                                                                      
 
	                                                      
	 
		                                                                                               
	 

	                               
	                                                        
	 
		                                                  
		 
			                      
			     
		 
	 

	                                         
	 
		                                                
		                                      
		                                                                             
		                                                
	 
	    
	 
		                                                                                                          
	 
 
#endif                 

#if DEV && SERVER
                                     
                                                                                              
 
	                
	 
		                                                                                    
		      
	 

	                                                       
	 
		                                   
		                         
		 
			                                                                                                                                                            
			      
		 
		                                                                    
	 

	                                                       
	                                           
 
#endif                 

#if DEV && SERVER
                                       
                                                     
 
	                                                          
 
#endif                 

#if DEV && SERVER
                        
                                                                                                                                     
 
	                                                                                  
	 
		                                                                                                                                                                                                                                                                                      
		      
	 

	                                                                
	                                                                     
	 
		                                   
		                         
		 
			                                                                                                                                                    
			      
		 
		                                                                           
	 

	                                                          
	                                                             
 
#endif                 

#if DEV && SERVER
                           
                                                 
 
	                                                                     
	                                                           
 
#endif                 
                             
