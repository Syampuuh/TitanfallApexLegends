                 
global function MpAbilityArmoredLeap_Init
global function OnWeaponActivate_ability_armored_leap
global function OnWeaponDeactivate_ability_armored_leap
global function OnWeaponReadyToFire_ability_armored_leap
global function OnWeaponPrimaryAttack_ability_armored_leap
global function OnWeaponPrimaryAttackAnimEvent_ability_armored_leap

global function CodeCallback_ArmoredLeapPhaseChange

global const string ARMORED_LEAP_WEAPON_NAME = "mp_ability_armored_leap"
global const string ARMORED_LEAP_SHIELD_ANCHOR_SCRIPTNAME 		= "al_shield_anchor"
global const string CASTLE_WALL_SNAKEHEAD_SCRIPTNAME 		= "axiom_castle_wall_snakehead"
global const string ARMORED_LEAP_SHIELD_BARRIER_SCRIPTNAME 		= "al_shield_barrier"
global const string CASTLE_WALL_THREAT_TARGETNAME = "axiom_castle_wall_threat"
global const string ARMORED_LEAP_IMPACT_ZONE_THREAT_TARGETNAME = "axiom_impact_zone_threat"

global const string ARMORED_LEAP_SHIELD_ANCHOR_LEFT = "al_shield_anchor_l"
global const string ARMORED_LEAP_SHIELD_ANCHOR_CENTER = "al_shield_anchor_c"
global const string ARMORED_LEAP_SHIELD_ANCHOR_RIGHT = "al_shield_anchor_r"
global const string ARMORED_LEAP_SHIELD_LOW_LEFT = "al_shield_low_l"
global const string ARMORED_LEAP_SHIELD_LOW_RIGHT = "al_shield_low_r"

const string ARMORED_LEAP_MOVER_SCRIPTNAME = "Newcastle_Leap_mover"

global function IsCastleWallEnt
global function CastleWall_EntityShouldBeHighlighted
global function ArmoredLeap_TargetEntityShouldBeHighlighted
global function ArmoredLeap_Handle_StatusEffectInterrupt

#if SERVER
                                                  
#endif

#if CLIENT
global function ServerToClient_ArmoredLeap_AirLaunchComplete
global function ServerToClient_ArmoredLeap_GroundDiveComplete
global function ServerToClient_ArmoredLeapComplete
global function ServerToClient_ArmoredLeapShutdown
global function ServerToClient_ArmoredLeapInterrupted
global function ServerToClient_VisorMode_DeActivate
global function ServerToClient_SetClient_AllyInDanger
global function ServerToClient_RescueTargetRui_Activate
global function ServerToClient_RescueTargetRui_Deactivate
global function ServerToClient_SetClient_BleedoutWaypoint
global function ServerToClient_RemoveClient_BleedoutWaypoint
#endif

                             
const bool VISOR_THREAT_DETECTION							= true

#if DEV
const bool DEBUG_ARMORED_LEAP_TARGETING_DRAW 				= false
const bool DEBUG_SNAKE_DRAW 								= false
const bool DEBUG_DEV_TEST_FLAG								= false		                                                             
const bool DEBUG_THREAT_INDICATORS							= false
const bool DEBUG_DRAW_PUSHER_MOVEMENT						= false
const bool DEBUG_DRAW_DAMAGE_BARRIERS						= false
const bool DEBUG_CAMERA_LERP								= false
const bool DEBUG_PHASE_CHANGES								= false
const bool DEBUG_BETTER_AIR_POS								= false
#endif      


const float ARMORED_LEAP_DISTANCE 							= 1400.0 	       
const float ARMORED_LEAP_DISTANCE_MIN 						= 50.0
const float ARMORED_LEAP_MAX_ALLY_RANGE 					= 2800 		                                                               
const float ARMORED_LEAP_MAX_SLAM_FOLLOW_DISTANCE 			= 1500 		      
const float ARMORED_LEAP_MAX_LEAP_HEIGHT 					= 800 		       
const float ARMORED_LEAP_MAX_LEAP_HEIGHT_ALLY 				= 2000 		       
const float ARMORED_LEAP_MIN_AIR_HEIGHT 					= 100      
const float ARMORED_LEAP_CLOSE_AIR_HEIGHT 					= 200		                                                                 
const float ARMORED_LEAP_FAR_AIR_HEIGHT 					= 500		                                                                                
const float ARMORED_LEAP_MAX_AIR_HEIGHT 					= 800		                                                                 
const float ARMORED_LEAP_FAR_AIR_HEIGHT_DIST 				= 1000 		                                                     
const float ARMORED_LEAP_AIR_POS_OFFSET						= 150		                                                                                   
const float ARMORED_LEAP_HUMAN_HEIGHT_OFFSET				= 90     		                                                                                                                 
const float ARMORED_LEAP_GROUND_DASH_RANGE 					= 600
const float ARMORED_LEAP_GROUND_DASH_HEIGHT_LIMIT 			= 250
const float ARMORED_LEAP_AIR_LAUNCH_SPEED					= 1000		                                                                        
const float ARMORED_LEAP_GROUND_DASH_SPEED 					= 1500		                                                                      
const float ARMORED_LEAP_SLAM_SPEED_NEAR 					= 2000       		                                                                      
const float ARMORED_LEAP_SLAM_SPEED_FAR 					= 2500       		                                                                      
const float ARMORED_LEAP_AIR_LAUNCH_EASE_OUT_TIME			= 0.8 		                                                                                                                                     					                        
const float ARMORED_LEAP_SLAM_EASE_IN_TIME					= 0.9 		                                                                                                                                                	                      
const float ARMORED_LEAP_LAUNCH_CROUCH_TIME 				= 0.4		     
const float ARMORED_LEAP_LAUNCH_DASH_CROUCH_TIME 			= 0.6
const float ARMORED_LEAP_AIRPOS_CHECK_RANGE 				= 20		                                                                                  
const float ARMORED_LEAP_GROUNDPOS_CHECK_RANGE 				= 80		                                                                                    
const float ARMORED_LEAP_AIR_HOVER_TIME 					= 0.55      
const float ARMORED_LEAP_AIR_HOVER_GRAVITY 					= 0.45
const float ARMORED_LEAP_AIR_HOVER_VEL_SCALAR 				= 0.5
const float ARMORED_LEAP_INTERRUPTED_VELOCITY_SCALE			= 0.35                                                                                         

                                 
const float ARMORED_LEAP_SLAM_SPEED_MAX 					= 3500
const float ARMORED_LEAP_GROUND_DASH_SPEED_MIN 				= 800
const float ARMORED_LEAP_GROUND_DASH_SPEED_MAX 				= 1500
const float ARMORED_LEAP_GROUND_DASH_ACCEL 					= 12000

const float ARMORED_LEAP_JUMP_SPEED_MIN 					= 1800
const float ARMORED_LEAP_JUMP_SPEED_MAX 					= 2500
const float ARMORED_LEAP_HOVER_SPEED_MIN					= 320
const float ARMORED_LEAP_HOVER_SPEED_MAX					= 400

const float ARMORED_LEAP_JUMP_ACCEL							= 24000
const float ARMORED_LEAP_HOVER_ACCEL 						= 9000
const float ARMORED_LEAP_DIVE_ACCEL 						= 9000

const float ARMORED_LEAP_AIRPOS_CHECK_RANGE_MIN				= 300
const float ARMORED_LEAP_AIRPOS_CHECK_RANGE_MAX				= 400

const float ARMORED_LEAP_HOVER_DIVE_PREP_SPEED 				= 150
const float ARMORED_LEAP_HOVER_DIVE_PREP_ACCEL				= ARMORED_LEAP_HOVER_DIVE_PREP_SPEED / 0.25


const vector ARMORED_LEAP_COL_MINS 							= <-16,-16, 0  >                                                                    
const vector ARMORED_LEAP_COL_MAXS 							= < 16, 16, 16 >                                                                    
const vector ARMORED_LEAP_ENDPOINT_BUFFER 					= <0,0,8>		                                                    
const float ARMORED_LEAP_AIR_DIVE_LONG_DIST					= 600			                                                                                     
const float ARMORED_LEAP_TIMEOUT_JUMP						= 2.75			                                            
const float ARMORED_LEAP_TIMEOUT_AIR_DIVE					= 2.75			                 
const float ARMORED_LEAP_TIMEOUT_DASH						= 2.5			             
const float ARMORED_LEAP_TIMEOUT_JUMP_ALLY					= 3.25			                 

const float ARMORED_LEAP_DOT_TO_ALLY_TARGET 				= 0.95		                                                                      
const float ARMORED_LEAP_ALLY_DANGER_ALERT_TIME 			= 16.0		                                                                                                 
const float ARMORED_LEAP_ALLY_DANGER_DISTANCE_MAX			= 200

const bool  ARMORED_LEAP_ALLOW_START_ON_MOVERS_DEFAULT 		= true		                                                          
const bool  ARMORED_LEAP_ALLOW_END_ON_MOVERS_DEFAULT 		= true
const float ARMORED_LEAP_MOVERS_MAX_SPEED_FOR_END_DEFAULT 	= 12.0

const float ARMORED_LEAP_WARNING_DURATION 					= 1.5
const float ARMORED_LEAP_RECOVERY_TIME						= 1.0 		                                                         
const float ARMORED_LEAP_CAM_RECOVERY_TIME					= 0.5		                                                                                   
const float ARMORED_LEAP_RECOVERY_MOVESLOW_DURATION 		= 2.0
const float ARMORED_LEAP_ABOVE_LEDGE_DEGREE_CHECK_OFFSET 	= 8 		                                                            
const float ARMORED_LEAP_LEDGE_INSET_AMOUNT			 		= 100     		                                                                   
const float ARMORED_LEAP_LEDGE_INSET_DOWN_TRACE 			= -100 		                                                                                                    
const float ARMORED_LEAP_ABOVE_LEDGE_DOWN_TRACE_OFFSET 		= 200 		                                                                             
const float ARMORED_LEAP_MIN_TARGET_DIST_TO_WALL 			= 75.0		                                                    
const float ARMORED_LEAP_OFFSET_TEST_HEIGHT 				= 48.0 		                                                                                                                           

           
const float ARMORED_LEAP_INITIAL_CAMERA_DIST				= 75.0              
const float ARMORED_LEAP_AIR_CAMERA_DIST					= 115.0
const float ARMORED_LEAP_SLAM_CAMERA_DIST					= 45.0
const float ARMORED_LEAP_END_CAMERA_DIST					= 85.0       

const float ARMORED_LEAP_INITIAL_CAMERA_RIGHT				= -35.0            
const float ARMORED_LEAP_AIR_CAMERA_RIGHT					= -35.0
const float ARMORED_LEAP_SLAM_CAMERA_RIGHT					= -35.0
const float ARMORED_LEAP_END_CAMERA_RIGHT					= -15.0

const float ARMORED_LEAP_INITIAL_CAMERA_HEIGHT				= 10.0             
const float ARMORED_LEAP_AIR_CAMERA_HEIGHT					= 35.0
const float ARMORED_LEAP_SLAM_CAMERA_HEIGHT					= 15.0
const float ARMORED_LEAP_END_CAMERA_HEIGHT					= 4.5      

const float ARMORED_LEAP_IMPACT_RANGE 						= 350.0
const float ARMORED_LEAP_MIN_FORCE 							= 250      
const float ARMORED_LEAP_MAX_FORCE 							= 450
const int ARMORED_LEAP_DAMAGE 								= 0     
const int ARMORED_LEAP_DAMAGE_MIN							= 0    

const float ARMORED_LEAP_VISOR_POST_LANDING_DURATION 		= 0.5      
const int ARMORED_LEAP_REFUND_AMOUNT_FRAC 					= 85		                                                                                                             

                                  
const int CASTLE_WALL_SHIELD_ANCHOR_HEALTH 						= 750	         
const int CASTLE_WALL_MAX_NUM_CASTLES							= 1
const float CASTLE_WALL_SPAWN_OFFSET 							= 50	                                            
const float CASTLE_WALL_SPAWN_GROUND_CHECK_DIST 				= 50
const float CASTLE_WALL_SPAWN_OFFSET_STEP 						= 10
const float CASTLE_WALL_SPAWN_UPTRACE_OFFSET 					= 32
const float CASTLE_WALL_SHIELD_THICKNESS 						= 5
const float CASTLE_WALL_HIGH_WALL_DEPLOY_DELAY 					= 0.15	   
const float CASTLE_WALL_HIGH_WALL_PLANTED_Z_OFFSET 				= 28

const float CASTLE_WALL_OVERLAP_CLEANUP_RADIUS_SEGMENT 			= 40
const float CASTLE_WALL_OVERLAP_CLEANUP_RADIUS_ANCHOR			= 180

const int CASTLE_WALL_BARRIER_DAMAGE 							= 20
const float CASTLE_WALL_BARRIER_DAMAGE_INTERVAL 				= 2.5	                                                                                
const float CASTLE_WALL_BARRIER_DELAY_TIME 						= 3.0	                                                                              
const float CASTLE_WALL_BARRIER_DURATION 						= 30.0
const float CASTLE_WALL_BARRIER_WARNING_DURATION 				= 2.0

const float CASTLE_WALL_WARNING_RADIUS 							= 150

const float CASTLE_WALL_PROTECTION_AREA_RANGE 					= 250

                                
const float CASTLE_SNAKE_WALL_HIGHCOVER_HEIGHT_OFFSET 			= 15	    	    
const float CASTLE_SNAKE_WALL_HIGHCOVER_CORE_OFFSET 			= 115	     
const float CASTLE_SNAKE_MIN_SEGMENT_DISTANCE 					= 27                                                                              
                                     						   
                                     						                                                                          	                                                                                                                
const float CASTLE_SNAKE_GRADUAL_ANGLE_SHIFT 					= 8	                                                 

const float CASTLE_SNAKE_HIGH_COVER_INITIAL_ANGLE_SHIFT 		= 18.0 	                                          
const float CASTLE_SNAKE_HIGH_COVER_FINAL_ANGLE_SHIFT 			= 10.0 	                                                                         
const float CASTLE_SNAKE_MIN_HIGH_COVER_WALL_LENGTH 			= 32.0 	                                                                            
const float CASTLE_SNAKE_MIN_HIGH_COVER_WIDTH 					= 25.0 	                                                                            
const float CASTLE_SNAKE_WALL_HIGH_COVER_EXTENSION_TIME 		= 0.35
const float CASTLE_SNAKE_MAX_TRAVEL_TIME 						= 3.0                                                                             
const float CASTLE_SNAKE_MIN_SNAKE_KICKUP_DIST 					= 10.0	                                                                                          


const float CASTLE_SNAKE_MIN_ALLOWED_SNAKE_DEPLOYMENT_RANGE 	= 65                                                                       
const float CASTLE_SNAKE_FINAL_SPACING_DISTANCE 				= 40                                           

const float CASTLE_ANCHOR_SIDE_OFFSET_DEPLOYED 					= 39.25
const float CASTLE_ANCHOR_SIDE_OFFSET_UNDEPLOYED 				= 15     

const float CASTLE_SNAKE_WALL_DAMAGE_VOLUME_WIDTH_LOW 			= 36	                                                                       
const float CASTLE_SNAKE_WALL_DAMAGE_VOLUME_WIDTH_HIGH			= 58	                                                                      
const float CASTLE_SNAKE_WALL_DAMAGE_VOLUME_THICKNESS 			= 5		                                                  
const float CASTLE_SNAKE_WALL_DAMAGE_VOLUME_HEIGHT 				= 80 	                                    

                                                                     
const float CASTLE_SNAKE_TEST_STEP 								= 64.0
const float CASTLE_SNAKE_CLIMB_HEIGHT 							= 32.0              
const float CASTLE_SNAKE_DROP_TEST_HEIGHT 						= 80                                                                                                                         
const float CASTLE_SNAKE_DROP_TEST_HEIGHT_MAX 					= 100                                                                                                   
                                                                     

                                                   
const float CASTLE_WALL_ALLY_OBJECT_DESTROYED_RADIUS 			= 35
const float CASTLE_WALL_ALLY_OBJECT_DESTROYED_REFUND_TIME 		= 15
const float CASTLE_WALL_ALLY_OBJECT_DESTROYED_REFUND_FRAC 		= 0.75                    

                            
const float ARMORED_LEAP_MAX_TARGETING_DIRECTION_RANGE 			= 2500
const float ARMORED_LEAP_MAX_TARGETING_POSITION_RANGE 			= 2500      
const float ARMORED_LEAP_TARGETING_FX_DIST_FROM_LANDING			= 50            
const float ARMORED_LEAP_TARGETING_MAX_TARGETS					= 10

       
const vector NC_COLOR_FRIENDLY									= < 64, 220, 255 >
const vector NC_COLOR_BEHIND									= < 128, 128, 128 >
const vector CASTLE_WALL_COLOR_ALLY 							= < 10, 100, 120 >
const float  CASTLE_WALL_ALPHA_ALLY								= 180
const vector CASTLE_WALL_COLOR_ENEMY 							= < 250, 85, 25 >
const float  CASTLE_WALL_ALPHA_ENEMY							= 255

const asset ARMORED_LEAP_AR_TARGET_FX 							= $"P_armored_leap_target"
const asset ARMORED_LEAP_AR_TARGET_FX_ALTZ						= $"P_armored_leap_target_altz"
const asset ARMORED_LEAP_AR_AIM_FX 								= $"P_wrp_trl_end"
const asset ARMORED_LEAP_PREVIEW_RING_FX 						= $"P_armored_leap_preview"
const asset ARMORED_LEAP_ALLY_BEAM_FX 							= $"P_armored_leap_ally_beam"	                                                                                 
const asset ARMORED_LEAP_PLACEMENT_ARROW_LEAP_FX				= $"P_armored_leap_path_jump"
const asset ARMORED_LEAP_PLACEMENT_ARROW_LEAP_FX_ALTZ			= $"P_armored_leap_path_jump_altz"
const asset ARMORED_LEAP_PLACEMENT_ARROW_DASH_FX				= $"P_armored_leap_path_dash"
const asset ARMORED_LEAP_PLACEMENT_ARC							= $"P_armored_leap_arc"

const asset ARMORED_LEAP_LAUNCH_JET_BACK_FX						= $"P_NC_launch_jet_back"
const asset ARMORED_LEAP_DOWN_JET_BACK_FX						= $"P_NC_down_jet_back"
const asset ARMORED_LEAP_LAUNCH_JET_LEG_FX						= $"P_NC_launch_jet_leg"
const asset ARMORED_LEAP_AFTERBURNER_FX							= $"P_NC_lanuch_aftburn_trail"
const asset ARMORED_LEAP_ENERGY_RADIUS_FX 						= $"P_armored_leap_radius"                           

const asset ARMORED_LEAP_IMPACT_FX 								= $"P_armored_leap_shockwave"
const string ARMORED_LEAP_IMPACT_FX_TABLE 						= "exp_armored_leap_WallSlam"	                 
const string CASTLE_WALL_SNAKE_IMPACT_FX_TABLE 					= "pilot_bodyslam"   	 		                                    

const asset CASTLE_WALL_SHIELD_ANCHOR_COL_FX 					= $"mdl/fx/newcastle_ar_wall.rmdl"                                       
const asset CASTLE_WALL_SHIELD_WALL_CENTRE_MDL 					= $"mdl/props/newcastle_shield_wall/newcastle_wall_v22_large_w.rmdl"                                           
const asset CASTLE_WALL_SHIELD_WALL_ENDS_L_MDL 					= $"mdl/props/newcastle_shield_wall/newcastle_wall_v22_large_w.rmdl"                                                                            
const asset CASTLE_WALL_SHIELD_WALL_ENDS_R_MDL 					= $"mdl/props/newcastle_shield_wall/newcastle_wall_v22_large_w.rmdl"                                                                            
const asset CASTLE_WALL_SHIELD_WALL_ENDS_LOW_COL_L_MDL			= $"mdl/props/newcastle_shield_wall/newcastle_wall_v22_left_compact_w.rmdl"
const asset CASTLE_WALL_SHIELD_WALL_ENDS_LOW_COL_R_MDL			= $"mdl/props/newcastle_shield_wall/newcastle_wall_v22_right_compact_w.rmdl"
const asset CASTLE_WALL_SHIELD_WALL_SEG_L_MDL 					= $"mdl/props/newcastle_shield_wall/newcastle_wall_v22_left_small_w.rmdl"                                                                                 
const asset CASTLE_WALL_SHIELD_WALL_SEG_R_MDL 					= $"mdl/props/newcastle_shield_wall/newcastle_wall_v22_right_small_w.rmdl"                                                                                  


const CASTLE_WALL_SHIELD_ANCHOR_DESTROYED_FX 					= $"P_armored_leap_wall_destruction"
const CASTLE_WALL_SHIELD_ANCHOR_DESTROYED_LARGE_FX				= $"P_armored_leap_wall_lg_destruction"
const asset CASTLE_WALL_EMP_FX_3P 								= $"P_emp_body_human"
const asset CASTLE_WALL_BARRIER_BEAM_FX 						= $"P_tesla_trap_link_CP"                           
const asset CASTLE_WALL_ELEC_PANEL_LG_FX 						= $"P_armored_leap_elec_panel_lg_01"
const asset CASTLE_WALL_ELEC_PANEL_LG_R_FX 						= $"P_armored_leap_elec_panel_lg_R"
const asset CASTLE_WALL_ELEC_PANEL_LG_L_FX 						= $"P_armored_leap_elec_panel_lg_L"
const asset CASTLE_WALL_ELEC_PANEL_SM_FX_LEFT 					= $"P_armored_leap_elec_panel_sm_l_01"
const asset CASTLE_WALL_ELEC_PANEL_SM_FX_LEFT_02				= $"P_armored_leap_elec_panel_sm_l_02"
const asset CASTLE_WALL_ELEC_PANEL_SM_FX_LEFT_03				= $"P_armored_leap_elec_panel_sm_l_03"
const asset CASTLE_WALL_ELEC_PANEL_SM_FX_RIGHT					= $"P_armored_leap_elec_panel_sm_r_01"
const asset CASTLE_WALL_ELEC_PANEL_SM_FX_RIGHT_02				= $"P_armored_leap_elec_panel_sm_r_02"
const asset CASTLE_WALL_ELEC_PANEL_SM_FX_RIGHT_03				= $"P_armored_leap_elec_panel_sm_r_03"


       
const string ARMORED_LEAP_SOUND_ACTIVATE_3P						= "Newcastle_Ultimate_Prep_3P" 	                                                 
const string ARMORED_LEAP_SOUND_LAUNCH_3P						= "Newcastle_Ultimate_Launch_3p" 	                             
const string ARMORED_LEAP_SOUND_DIVESLAM_3P						= "Newcastle_Ultimate_AirborneBoost_3p" 	                             
const string ARMORED_LEAP_SOUND_AIR_MVMT_3P						= "Newcastle_Ultimate_AirborneMvmt_3p"
const string ARMORED_LEAP_SOUND_ACTIVATE_1P						= "Newcastle_Ultimate_UI_LoopStop"
const string ARMORED_LEAP_SOUND_TO_STOP_1P						= "newcastle_ultimate_ui"                                                                                                                                 
const string ARMORED_LEAP_SOUND_LAUNCH_1P						= "Newcastle_Ultimate_Launch_1p"		                             
const string ARMORED_LEAP_SOUND_DIVESLAM_1P						= "Newcastle_Ultimate_AirborneBoost_1p" 	                             
const string ARMORED_LEAP_SOUND_AIR_MVMT_1P						= "Newcastle_Ultimate_AirborneMvmt_1p"

const string CASTLE_WALL_PLACED_SFX_3P 							= "Newcastle_Ultimate_Wall_Place_3p"
const string CASLTE_WALL_LANDS_ON_GROUND 						= "Newcastle_Ultimate_Wall_Land_Default"

const string CASTLE_WALL_BARRIER_ACTIVE_LOOP_SOUND 				= "Newcastle_Ultimate_Wall_Loop"
const string CASTLE_WALL_BARRIER_END_WARNING_SOUND 				= "Newcastle_Ultimate_Wall_Warn2End"
const string CASTLE_WALL_BARRIER_DISSOLVE_SOUND 				= "Newcastle_Ultimate_Wall_Dissolve"
const string CASTLE_WALL_SHIELD_ANCHOR_DESTROY_SOUND 			= "Newcastle_Ultimate_Wall_Destroy"
const string CASTLE_WALL_BARRIER_DAMAGE_1P_SOUND 				= "Newcastle_Ultimate_Wall_Damage_1p"
const string CASTLE_WALL_BARRIER_DAMAGE_3P_SOUND 				= "Newcastle_Ultimate_Wall_Damage_3p"

const string ARMORED_LEAP_ALLY_TARGETED_SFX_1P 					= "Newcastle_Teamscan_Ping"

const string ARMORED_LEAP_ALLY_TARGETED_CHATTER_1P 				= "diag_mp_newcastle_bc_superSquadTargeted_1p"
const string ARMORED_LEAP_ALLY_TARGETED_CHATTER_3P 				= "diag_mp_newcastle_bc_superSquadTargeted_3p"
const string ARMORED_LEAP_ALLY_BUDDY_TARGETED_CHATTER_3P 		= "diag_mp_newcastle_bc_superSquadObserving_3p"
const string CASTLE_WALL_DESTROYED_CHATTER_VO_1P 				= "diag_mp_newcastle_bc_superDestroyed_1p"
const string CASTLE_WALL_DESTROYED_CHATTER_VO_3P 				= "diag_mp_newcastle_bc_superDestroyed_3p"

const string ARMORED_LEAP_TARGET_FAIL_DEFAULT					= "#HINT_NEWCASTLE_LEAP_TARGET_FAIL_DEFAULT"
const string ARMORED_LEAP_TARGET_FAIL_BLOCKED_LAND				= "#HINT_NEWCASTLE_LEAP_TARGET_FAIL_BLOCKED_LAND"
const string ARMORED_LEAP_TARGET_FAIL_BLOCKED_LEAP				= "#HINT_NEWCASTLE_LEAP_TARGET_FAIL_BLOCKED_LEAP"
const string ARMORED_LEAP_TARGET_FAIL_BLOCKED_ALLY				= "#HINT_NEWCASTLE_LEAP_TARGET_FAIL_BLOCKED_ALLY"
      

           

struct ArmoredLeapTargetInfo
{
	array<vector> posList
	vector        finalPos
	vector        airPos
	vector        eyeHitPos
	vector        eyeHitNorm
	entity		  hitEnt
	bool          success
	bool          isOccluded
	float         pathDistance
	int			  failCase
	bool		  hasAlly
	entity		  allyTarget
}

struct ArmoredLeapSnakeInfo
{
	entity		  mover
	vector        shieldDir
	vector        moverDir
	vector		  nextValidPos
	vector		  dropPos
	vector		  destination
	vector		  surfaceAngle
	float		  wallLength
	bool		  stopped
	bool		  drop
	bool		  isLeft
}

struct FindOffsetPosStruct
{
	bool success
	vector position
}

#if DEV
const table<int,string> armoredLeapPhaseToStringMap = {
	[ PLAYER_ARMORED_LEAP_PHASE_NONE ] = "PLAYER_ARMORED_LEAP_PHASE_NONE",
	[ PLAYER_ARMORED_LEAP_PHASE_PREP ] = "PLAYER_ARMORED_LEAP_PHASE_PREP",
	[ PLAYER_ARMORED_LEAP_PHASE_TRAVEL_AIR ] = "PLAYER_ARMORED_LEAP_PHASE_TRAVEL_AIR",
	[ PLAYER_ARMORED_LEAP_PHASE_TRAVEL_AIR_HOVER ] = "PLAYER_ARMORED_LEAP_PHASE_TRAVEL_AIR_HOVER",
	[ PLAYER_ARMORED_LEAP_PHASE_TRAVEL_GROUND ] = "PLAYER_ARMORED_LEAP_PHASE_TRAVEL_GROUND",
	[ PLAYER_ARMORED_LEAP_PHASE_ARRIVAL ] = "PLAYER_ARMORED_LEAP_PHASE_ARRIVAL",
	[ PLAYER_ARMORED_LEAP_PHASE_INTERRUPTED ] = "PLAYER_ARMORED_LEAP_PHASE_INTERRUPTED"
}
#endif

#if CLIENT
struct CastleWallThreatIndicatorLine
{
	vector startPos
	vector endPos
}

struct CastleWallEntityData
{
	entity        anchorLeft
	entity        anchorCenter
	entity        anchorRight
	array<entity> lowWallsLeft
	array<entity> lowWallsRight
}
#endif         

enum eFailCase
{
	DEFAULT,
	BLOCKED_LANDING,
	BLOCKED_LEAP,
	BLOCKED_ALLY,

	_count
}

enum eSegmentType
{
	CENTER,
	LOW,
	HIGH,
	LOW_LEFT,
	LOW_RIGHT,

	_count
}

enum eAnchorType
{
	NONE,
	LEFT,
	CENTER,
	RIGHT,
	_count
}

struct
{
	                         
	int castleWallHealth		= CASTLE_WALL_SHIELD_ANCHOR_HEALTH
	float maxDist				= ARMORED_LEAP_DISTANCE
	float maxDistAlly			= ARMORED_LEAP_MAX_ALLY_RANGE
	float maxHeight				= ARMORED_LEAP_MAX_LEAP_HEIGHT
	float maxHeightAlly			= ARMORED_LEAP_MAX_LEAP_HEIGHT_ALLY
	float airLaunchSpeed		= ARMORED_LEAP_AIR_LAUNCH_SPEED                                                 
	float airJumpSpeedMin		= ARMORED_LEAP_JUMP_SPEED_MIN
	float airJumpSpeedMax		= ARMORED_LEAP_JUMP_SPEED_MAX
	float airHoverSpeedMin		= ARMORED_LEAP_HOVER_SPEED_MIN
	float airHoverSpeedMax		= ARMORED_LEAP_HOVER_SPEED_MAX
	float groundDashSpeed		= ARMORED_LEAP_GROUND_DASH_SPEED                                                 
	float groundDashSpeedMin	= ARMORED_LEAP_GROUND_DASH_SPEED_MIN
	float groundDashSpeedMax	= ARMORED_LEAP_GROUND_DASH_SPEED_MAX
	float airSlamSpeedNear		= ARMORED_LEAP_SLAM_SPEED_NEAR
	float airSlamSpeedFar		= ARMORED_LEAP_SLAM_SPEED_FAR
	float airSlamSpeedMax		= ARMORED_LEAP_SLAM_SPEED_MAX
	float moveRecoveryTime		= ARMORED_LEAP_RECOVERY_MOVESLOW_DURATION
	float impactRadius			= ARMORED_LEAP_IMPACT_RANGE
	float impactForceMin		= ARMORED_LEAP_MIN_FORCE
	float impactForceMax		= ARMORED_LEAP_MAX_FORCE
	float barrierDuration		= CASTLE_WALL_BARRIER_DURATION
	float barrierDelay			= CASTLE_WALL_BARRIER_DELAY_TIME
	float barrierDMGInterval	= CASTLE_WALL_BARRIER_DAMAGE_INTERVAL
	int barrierDamage			= CASTLE_WALL_BARRIER_DAMAGE
	int impactDamage			= ARMORED_LEAP_DAMAGE

	                  
	table<entity, ArmoredLeapTargetInfo>        armoredLeapTargetTable
	table<entity, vector> allyLKP = {}
	table<entity, entity> allyTarget = {}

	table<entity, bool> playerWeaponsHolstered = {}
	table<entity, vector> shieldSlamPos = {}
	table<entity, int> threatVisionHandle = {}
	table<entity, bool> threatVisionActive = {}
	table<entity, bool> isTargetPlacementActive = {}
	table<entity, bool> allyIsInDanger = {}

	bool allowStartOnMovers 		= ARMORED_LEAP_ALLOW_START_ON_MOVERS_DEFAULT
	bool allowEndOnMovers 			= ARMORED_LEAP_ALLOW_END_ON_MOVERS_DEFAULT
	float maxEndingMoverSpeedSqr 	= ARMORED_LEAP_MOVERS_MAX_SPEED_FOR_END_DEFAULT

	bool hasVisorThreatDetection	= VISOR_THREAT_DETECTION

	#if SERVER
	                                            
	                                           
	                                                          
	                                          

	                                                
	                                                
	                                   

	                                       
	                                          
	#endif

	#if CLIENT
		float cl_timeRemaining = 0.0
		float cl_overshield = 0.0

		array<entity> castleWallClientAGs
		table<int, CastleWallEntityData > castleWallEnts
		table<entity, bool> castleWallHighlightFocus
		array<entity> enemyThreatTargets
		int colorCorrection = -1
		table<entity, entity> bleedoutWP

		var visorRui = null
		int currentArmoredLeapPhase = PLAYER_ARMORED_LEAP_PHASE_NONE
	#endif

} file

void function MpAbilityArmoredLeap_Init()
{
	PrecacheParticleSystem( ARMORED_LEAP_AR_TARGET_FX )
	PrecacheParticleSystem( ARMORED_LEAP_AR_TARGET_FX_ALTZ )
	PrecacheParticleSystem( ARMORED_LEAP_AR_AIM_FX )
	PrecacheParticleSystem( ARMORED_LEAP_ENERGY_RADIUS_FX )
	PrecacheParticleSystem( ARMORED_LEAP_PREVIEW_RING_FX )
	PrecacheParticleSystem( ARMORED_LEAP_AFTERBURNER_FX )
	PrecacheParticleSystem( ARMORED_LEAP_LAUNCH_JET_BACK_FX )
	PrecacheParticleSystem( ARMORED_LEAP_DOWN_JET_BACK_FX )
	PrecacheParticleSystem( ARMORED_LEAP_LAUNCH_JET_LEG_FX )
	PrecacheParticleSystem( ARMORED_LEAP_ALLY_BEAM_FX )

	PrecacheParticleSystem( ARMORED_LEAP_PLACEMENT_ARC )
	PrecacheParticleSystem( ARMORED_LEAP_PLACEMENT_ARROW_LEAP_FX )
	PrecacheParticleSystem( ARMORED_LEAP_PLACEMENT_ARROW_LEAP_FX_ALTZ )
	PrecacheParticleSystem( ARMORED_LEAP_PLACEMENT_ARROW_DASH_FX )

	PrecacheParticleSystem( CASTLE_WALL_SHIELD_ANCHOR_DESTROYED_FX )
	PrecacheParticleSystem( CASTLE_WALL_SHIELD_ANCHOR_DESTROYED_LARGE_FX )
	PrecacheParticleSystem( CASTLE_WALL_BARRIER_BEAM_FX )
	PrecacheParticleSystem( CASTLE_WALL_EMP_FX_3P )

	PrecacheParticleSystem( CASTLE_WALL_ELEC_PANEL_LG_FX )
	PrecacheParticleSystem( CASTLE_WALL_ELEC_PANEL_LG_R_FX )
	PrecacheParticleSystem( CASTLE_WALL_ELEC_PANEL_LG_L_FX )
	PrecacheParticleSystem( CASTLE_WALL_ELEC_PANEL_SM_FX_LEFT )
	PrecacheParticleSystem( CASTLE_WALL_ELEC_PANEL_SM_FX_LEFT_02 )
	PrecacheParticleSystem( CASTLE_WALL_ELEC_PANEL_SM_FX_LEFT_03 )
	PrecacheParticleSystem( CASTLE_WALL_ELEC_PANEL_SM_FX_RIGHT )
	PrecacheParticleSystem( CASTLE_WALL_ELEC_PANEL_SM_FX_RIGHT_02 )
	PrecacheParticleSystem( CASTLE_WALL_ELEC_PANEL_SM_FX_RIGHT_03 )

	PrecacheParticleSystem( ARMORED_LEAP_IMPACT_FX )

	PrecacheImpactEffectTable( ARMORED_LEAP_IMPACT_FX_TABLE )
	PrecacheImpactEffectTable( CASTLE_WALL_SNAKE_IMPACT_FX_TABLE )

	PrecacheModel( CASTLE_WALL_SHIELD_ANCHOR_COL_FX )
	PrecacheModel( CASTLE_WALL_SHIELD_WALL_CENTRE_MDL )
	PrecacheModel( CASTLE_WALL_SHIELD_WALL_ENDS_L_MDL )
	PrecacheModel( CASTLE_WALL_SHIELD_WALL_ENDS_R_MDL )
	PrecacheModel( CASTLE_WALL_SHIELD_WALL_ENDS_LOW_COL_L_MDL )
	PrecacheModel( CASTLE_WALL_SHIELD_WALL_ENDS_LOW_COL_R_MDL )
	PrecacheModel( CASTLE_WALL_SHIELD_WALL_SEG_L_MDL )
	PrecacheModel( CASTLE_WALL_SHIELD_WALL_SEG_R_MDL )


	RegisterSignal( "StopArmoredLeapTargetPlacement" )
	RegisterSignal( "ArmoredLeap_LeapComplete" )
	RegisterSignal( "ArmoredLeap_LeapShutdown" )
	RegisterSignal( "ArmoredLeap_AllyRescueComplete" )
	RegisterSignal( "CastleWall_PickedUp" )
	RegisterSignal( "ArmoredLeap_LaunchEffectsEnd" )
	RegisterSignal( "CastleWall_BarrierDisrupted" )
	RegisterSignal( "CastleWall_CastleDestroyed" )
	RegisterSignal( "ArmoredLeap_AirLaunchComplete" )
	RegisterSignal( "ArmoredLeap_GroundDiveComplete" )
	RegisterSignal( "VisorMode_DeActivate" )

	                                                                                                                                       
	RegisterSignal( "ArmoredLeap_StartPrepPhase" )
	RegisterSignal( "ArmoredLeap_EndPrepPhase" )
	RegisterSignal( "ArmoredLeap_StartTravelAirPhase" )
	RegisterSignal( "ArmoredLeap_EndTravelAirPhase" )
	RegisterSignal( "ArmoredLeap_StartTravelAirHoverPhase" )
	RegisterSignal( "ArmoredLeap_EndTravelAirHoverPhase" )
	RegisterSignal( "ArmoredLeap_StartTravelGroundPhase" )
	RegisterSignal( "ArmoredLeap_EndTravelGroundPhase" )
	RegisterSignal( "ArmoredLeap_StartArrivalPhase" )
	RegisterSignal( "ArmoredLeap_EndArrivalPhase" )
	RegisterSignal( "ArmoredLeap_Interrupted" )

	AddCallback_PlayerCanUseZipline( ArmoredLeap_CanUseZipline )

	#if SERVER
		                                                                                             
		                                                         
		                                                                               
		                                                                             
	#endif

	#if CLIENT
		RegisterConCommandTriggeredCallback( "+scriptCommand5", OnCharacterButtonPressed )
		file.colorCorrection = ColorCorrection_Register( "materials/correction/ability_hunt_mode.raw_hdr" )                                                                           

		AddCallback_UseEntGainFocus( CastleWall_OnGainFocus )
		AddCallback_UseEntLoseFocus( CastleWall_OnLoseFocus )

		AddCreateCallback( "prop_script", CastleWall_OnPropScriptCreated )
		AddDestroyCallback( "prop_script", CastleWall_OnPropScriptDestroyed )
		AddCallback_ModifyDamageFlyoutForScriptName( ARMORED_LEAP_SHIELD_ANCHOR_SCRIPTNAME, CastleWall_OffsetDamageNumbers )
		AddTargetNameCreateCallback( ARMORED_LEAP_IMPACT_ZONE_THREAT_TARGETNAME, AddImpactZoneThreatIndicator )

	#endif

		Remote_RegisterServerFunction( "ClientCallback_TryPickupCastleWall", "entity" )                                                                           
		Remote_RegisterClientFunction( "ServerToClient_ArmoredLeapComplete", "entity" )
		Remote_RegisterClientFunction( "ServerToClient_ArmoredLeapShutdown", "entity" )                                                                                  
		Remote_RegisterClientFunction( "ServerToClient_ArmoredLeapInterrupted", "entity" )                                                                                                                                                                                                                                
		Remote_RegisterClientFunction( "ServerToClient_VisorMode_DeActivate", "entity" )
		Remote_RegisterClientFunction( "ServerToClient_ArmoredLeap_AirLaunchComplete", "entity" )
		Remote_RegisterClientFunction( "ServerToClient_ArmoredLeap_GroundDiveComplete", "entity" )
		Remote_RegisterClientFunction( "ServerToClient_SetClient_AllyInDanger", "entity", "entity", "bool" )
		Remote_RegisterClientFunction( "ServerToClient_RescueTargetRui_Activate", "entity", "entity" )
		Remote_RegisterClientFunction( "ServerToClient_RescueTargetRui_Deactivate", "entity" )
		Remote_RegisterClientFunction( "ServerToClient_SetClient_BleedoutWaypoint", "entity", "entity" )
		Remote_RegisterClientFunction( "ServerToClient_RemoveClient_BleedoutWaypoint", "entity" )

	                 
	file.castleWallHealth			= GetCurrentPlaylistVarInt( "newcastle_armored_leap_castleWallHP", CASTLE_WALL_SHIELD_ANCHOR_HEALTH )
	file.maxDist 					= GetCurrentPlaylistVarFloat( "newcastle_armored_leap_dist", ARMORED_LEAP_DISTANCE )
	file.maxDistAlly				= GetCurrentPlaylistVarFloat( "newcastle_armored_leap_dist_ally", ARMORED_LEAP_MAX_ALLY_RANGE )
	file.maxHeight					= GetCurrentPlaylistVarFloat( "newcastle_armored_leap_height", ARMORED_LEAP_MAX_LEAP_HEIGHT )
	file.maxHeightAlly				= GetCurrentPlaylistVarFloat( "newcastle_armored_leap_height_ally", ARMORED_LEAP_MAX_LEAP_HEIGHT_ALLY )
	file.airLaunchSpeed 			= GetCurrentPlaylistVarFloat( "newcastle_armored_leap_speed_air_launch", ARMORED_LEAP_AIR_LAUNCH_SPEED )                                        
	file.airJumpSpeedMin 			= GetCurrentPlaylistVarFloat( "newcastle_armored_leap_speed_air_jump_min", ARMORED_LEAP_JUMP_SPEED_MIN )
	file.airJumpSpeedMax 			= GetCurrentPlaylistVarFloat( "newcastle_armored_leap_speed_air_jump_max", ARMORED_LEAP_JUMP_SPEED_MAX )
	file.airHoverSpeedMin 			= GetCurrentPlaylistVarFloat( "newcastle_armored_leap_speed_air_hover_min", ARMORED_LEAP_HOVER_SPEED_MIN )
	file.airHoverSpeedMax 			= GetCurrentPlaylistVarFloat( "newcastle_armored_leap_speed_air_hover_max", ARMORED_LEAP_HOVER_SPEED_MAX )
	file.groundDashSpeed			= GetCurrentPlaylistVarFloat( "newcastle_armored_leap_speed_ground_dash", ARMORED_LEAP_GROUND_DASH_SPEED )                                        
	file.groundDashSpeedMin			= GetCurrentPlaylistVarFloat( "newcastle_armored_leap_speed_ground_dash_min", ARMORED_LEAP_GROUND_DASH_SPEED_MIN )
	file.groundDashSpeedMax			= GetCurrentPlaylistVarFloat( "newcastle_armored_leap_speed_ground_dash_max", ARMORED_LEAP_GROUND_DASH_SPEED_MAX )
	file.airSlamSpeedNear			= GetCurrentPlaylistVarFloat( "newcastle_armored_leap_speed_air_slam_near", ARMORED_LEAP_SLAM_SPEED_NEAR )
	file.airSlamSpeedFar			= GetCurrentPlaylistVarFloat( "newcastle_armored_leap_speed_air_slam_far", ARMORED_LEAP_SLAM_SPEED_FAR )
	file.airSlamSpeedMax			= GetCurrentPlaylistVarFloat( "newcastle_armored_leap_speed_air_slam_max", ARMORED_LEAP_SLAM_SPEED_MAX )
	file.moveRecoveryTime			= GetCurrentPlaylistVarFloat( "newcastle_armored_leap_moveslow_recovery_time", ARMORED_LEAP_RECOVERY_MOVESLOW_DURATION )
	file.impactRadius 				= GetCurrentPlaylistVarFloat( "newcastle_armored_leap_impact_radius", ARMORED_LEAP_IMPACT_RANGE )
	file.impactForceMin				= GetCurrentPlaylistVarFloat( "newcastle_armored_leap_impact_force_min", ARMORED_LEAP_MIN_FORCE )
	file.impactForceMax				= GetCurrentPlaylistVarFloat( "newcastle_armored_leap_impact_force_max", ARMORED_LEAP_MAX_FORCE )
	file.barrierDuration			= GetCurrentPlaylistVarFloat( "newcastle_castle_wall_barrier_duration", CASTLE_WALL_BARRIER_DURATION )
	file.barrierDelay 				= GetCurrentPlaylistVarFloat( "newcastle_castle_wall_barrier_delay", CASTLE_WALL_BARRIER_DELAY_TIME )
	file.barrierDMGInterval			= GetCurrentPlaylistVarFloat( "newcastle_castle_wall_barrier_dmg_interval", CASTLE_WALL_BARRIER_DAMAGE_INTERVAL )
	file.barrierDamage				= GetCurrentPlaylistVarInt( "newcastle_castle_wall_barrier_dmg", CASTLE_WALL_BARRIER_DAMAGE )
	file.impactDamage				= GetCurrentPlaylistVarInt( "newcastle_armored_leap_impact_dmg", ARMORED_LEAP_DAMAGE )

	file.maxEndingMoverSpeedSqr 	= pow( GetCurrentPlaylistVarFloat( "axiom_armored_leap_max_mover_speed", ARMORED_LEAP_MOVERS_MAX_SPEED_FOR_END_DEFAULT ), 2.0)
	file.allowStartOnMovers 		= GetCurrentPlaylistVarBool( "axiom_armored_leap_allow_start_on_movers", ARMORED_LEAP_ALLOW_START_ON_MOVERS_DEFAULT )
	file.allowEndOnMovers 			= GetCurrentPlaylistVarBool( "axiom_armored_leap_allow_end_on_movers", ARMORED_LEAP_ALLOW_END_ON_MOVERS_DEFAULT )

	file.hasVisorThreatDetection	= GetCurrentPlaylistVarBool( "newcastle_hasVisorThreat", VISOR_THREAT_DETECTION )
}


void function OnWeaponActivate_ability_armored_leap( entity weapon )
{
	#if SERVER
	                                       
	                         
	 
		                                                                                 
	 
	#endif         
}

void function OnWeaponReadyToFire_ability_armored_leap( entity weapon )
{
	entity player = weapon.GetWeaponOwner()

	if ( weapon.GetWeaponPrimaryClipCount() < weapon.GetAmmoPerShot() )
		return

	                                                                      
	if( weapon.GetWeaponActivity() == ACT_VM_HOLSTER )                                                                                    
		return

	if( player in file.isTargetPlacementActive )
		return

	if( player in file.armoredLeapTargetTable )
		delete file.armoredLeapTargetTable[player]

	thread ArmoredLeap_TargetPlacementTracking_Thread( player )

	#if CLIENT
		if ( !InPrediction() || IsFirstTimePredicted() )
		{
			if ( player == GetLocalViewPlayer() )
			{
				thread ArmoredLeap_AR_Placement_Thread( weapon )
			}
		}
	#endif

}


void function OnWeaponDeactivate_ability_armored_leap( entity weapon )
{
	entity player = weapon.GetWeaponOwner()
	Signal( player, "StopArmoredLeapTargetPlacement" )

	#if SERVER
		                                                           
	#endif

	if ( GetCurrentArmoredLeapPhase( player ) == PLAYER_ARMORED_LEAP_PHASE_NONE )
	{
		Signal( player, "VisorMode_DeActivate" )
	}

	#if CLIENT
		if ( player == GetLocalViewPlayer() )
		{
			weapon.Signal( "StopArmoredLeapTargetPlacement" )
			                                                                                                                                           
			StopSoundOnEntity( player, ARMORED_LEAP_SOUND_TO_STOP_1P )
		}
	#endif
	if( player in file.allyLKP )
		delete file.allyLKP[player]
}


var function OnWeaponPrimaryAttack_ability_armored_leap( entity weapon, WeaponPrimaryAttackParams params )
{
	entity player = weapon.GetWeaponOwner()

	if ( !IsValid( player ) || player.IsPhaseShifted() )
		return 0

	ArmoredLeapTargetInfo info = GetArmoredLeapTargetInfo( player )

	#if SERVER
	                    
	 
		                                                                                     
		        
	 
	#endif

	#if CLIENT
	if ( !InPrediction() || IsFirstTimePredicted() )
	{
		if ( !info.success )
			return 0
	}
	else
		return 0
	#endif

	if ( DoAdditionalAirPosChecks() )
	{
		info = GetBetterAirPos( player, info )
	}

	if ( IsValid( info.allyTarget) )
	{
		file.allyTarget[player] <- info.allyTarget
	}

	file.armoredLeapTargetTable[player] <- info

	if ( player.IsPhaseShifted() )
	{
		delete file.armoredLeapTargetTable[player]
		return 0
	}

	#if SERVER
                       
			                                       
        
		                                                 
	#endif

	#if SERVER
		                  
		 
			                                                    
			                             
			 
				                      
					        

				                     
					        

				                             
				 
					                                                                                      
					                                                                                               
					        
				 

				                                                                                          
			 

		 
		    
			                                                           
	#endif

	#if SERVER
	                                                                      
	#elseif CLIENT
	file.currentArmoredLeapPhase = PLAYER_ARMORED_LEAP_PHASE_NONE
	#endif

	thread ArmoredLeap_Master_Thread( player, info.finalPos, info.airPos, info.hitEnt )

	Signal( player, "StopArmoredLeapTargetPlacement" )
	#if CLIENT
		if( file.visorRui != null )
			RuiSetGameTime( file.visorRui, "jumpTime", Time() )
	#endif

	PlayerUsedOffhand( player, weapon, true, null, {pos = info.finalPos, hasAlly = info.hasAlly} )


	return weapon.GetAmmoPerShot()
}


                                                                                                   
var function OnWeaponPrimaryAttackAnimEvent_ability_armored_leap( entity weapon, WeaponPrimaryAttackParams params )
{
	int ammoReq = weapon.GetWeaponSettingInt( eWeaponVar.ammo_per_shot )
	entity player = weapon.GetWeaponOwner()

	return 0
}


                                                                                                    
                                                                                                    
                                                                                                    
void function ArmoredLeap_Master_Thread( entity player, vector endPoint, vector airPoint, entity hitEnt )
{
	EndSignal( player, "OnDeath" )
	EndSignal( player, "OnDestroy" )
	EndSignal( player, "BleedOut_OnStartDying" )
	EndSignal( player, "ArmoredLeap_LeapComplete")
	EndSignal( player, "DeathTotem_PreRecallPlayer" )
	EndSignal( player, "Interrupted" )
	#if CLIENT
		EndSignal( player, "ArmoredLeap_LeapShutdown" )
	#endif

	entity mover

	vector startpoint = player.GetOrigin()
	table<entity, bool> didUltDeployOnInterrupted
	didUltDeployOnInterrupted[player] <- false

	#if SERVER


		                                                                                       
		                                             

		                                                                                                                                                                        
		                                                                                                                                                                   

		                               
		 
			                                           
			                                                  
				                                                                                                          
		 


		                                                                               


		                 
		                               
		 
			                                                                                                  
		 

		       
			                                                                            
		      

		                                                                  
		 
			                          
			                         

			                                                     
			                               
			                                                                          
			                                         
			                                             
			                                           
			                                                   
			                                   
			                                  
			                                         
			                                         
			                                              
			                                       
			                                       
			                                            
			                                        
			                                                                
			                                 
		 

		                                                             
		                                                                                      
		                               
			                                       

		                              
			                      
	#endif         



	OnThreadEnd(
		function() : ( player, mover, startpoint, didUltDeployOnInterrupted )
		{
			if ( IsValid( player ) )
			{
				#if SERVER
					                           
					                                     
					                                 

					                               
						                    

					                              
						                     

					                                                           

					                            
						                           

					                               
					 
						                                                                            
							                                                                                                                              
						                              
					 

					                                           
					 
						                                         
						 
							                                
							                                          
						 
					 

					                                                                   
					                                                                                            
					 
						                                                            
					 
				#endif

				#if SERVER
				                                                                                    
				 
					                                          
					 
						                                         
						 
							                                                               
							                                                 
						 
					 
				 
				#endif

				#if SERVER
				                                             
					                                           
				#elseif CLIENT
				file.currentArmoredLeapPhase = PLAYER_ARMORED_LEAP_PHASE_NONE
				#endif

				if ( !GetArmoredLeapUseCode() )
					player.Player_FinishArmoredLeap_Depricated()

				if ( !GetArmoredLeapUseCode() )
				{
					if( player.GetArmoredLeapState_Depricated() != PLAYER_ARMORED_LEAP_STATE_GROUND_END && player.GetArmoredLeapState_Depricated() != PLAYER_ARMORED_LEAP_STATE_AIR_END )
						player.Player_FinishArmoredLeap_Depricated()                                                                                                     
				}

				#if SERVER
					                                                
				#endif
			}

			if ( IsValid( mover ) )
				mover.Destroy()
		}
	)

	                                                                                                       

	#if CLIENT
		if( file.hasVisorThreatDetection )
			thread ArmoredLeap_TrackEnemyAtLandingZone_Thread( player, endPoint )
	#endif

	                                                                                                             

	bool inDashRange = ArmoredLeap_IsInDashRange( player, endPoint, hitEnt )
	bool isHoverSlam = !player.IsOnGround()
	float distToDest2D = Distance2D( player.GetOrigin(), endPoint )
	int armoredLeapType = PLAYER_ARMORED_LEAP_TYPE_NONE

	if ( inDashRange )
	{
		armoredLeapType = PLAYER_ARMORED_LEAP_TYPE_DASH
	}
	else if ( isHoverSlam )
	{
		if ( distToDest2D > ARMORED_LEAP_AIR_DIVE_LONG_DIST )
		{
			armoredLeapType = PLAYER_ARMORED_LEAP_TYPE_AIR_DIVE_LONG
		}
		else
		{
			armoredLeapType = PLAYER_ARMORED_LEAP_TYPE_AIR_DIVE
		}
	}
	else
	{
		armoredLeapType = PLAYER_ARMORED_LEAP_TYPE_JUMP
	}

	#if SERVER
	                                                                                                   

	                    

	                 
		                                               
	                               
		                                          
	    
		                                      

	                                                                                                                                       
	                                                                                                                                       
	                                                                                                                                     

	       
	                        
	 
		                                                                                                                            
		                                                                                                                         
	 
	            
	#endif         

	float dist2D = Distance2D( airPoint, endPoint )
	float dist3D = Distance( airPoint, endPoint )

	float diveSpeed
	if( dist3D < ARMORED_LEAP_FAR_AIR_HEIGHT )
		diveSpeed = GraphCapped( dist3D, ARMORED_LEAP_CLOSE_AIR_HEIGHT, ARMORED_LEAP_FAR_AIR_HEIGHT, ARMORED_LEAP_SLAM_SPEED_NEAR, ARMORED_LEAP_SLAM_SPEED_FAR )
	else
		diveSpeed = GraphCapped( dist3D, ARMORED_LEAP_FAR_AIR_HEIGHT, ARMORED_LEAP_MAX_ALLY_RANGE, ARMORED_LEAP_SLAM_SPEED_FAR, file.airSlamSpeedMax )

	if ( GetArmoredLeapUseCode() )
	{
		thread ArmoredLeap_UpdateLKP_Thread( player, airPoint, endPoint )
	}

	array<entity> ignoreArray = ArmoredLeapIgnoreArray()

	if ( armoredLeapType == PLAYER_ARMORED_LEAP_TYPE_DASH )                      
	{
		if ( GetArmoredLeapUseCode() )
		{
			thread ArmoredLeap_LaunchPrep_Thread( player, endPoint, airPoint, ARMORED_LEAP_LAUNCH_DASH_CROUCH_TIME )
			endPoint = ArmoredLeap_GetUpdatedLKP( player, airPoint, endPoint )                           

			float dashSpeed = GraphCapped( Distance( player.GetOrigin(), endPoint ), 0, ARMORED_LEAP_GROUND_DASH_RANGE, file.groundDashSpeedMin, file.groundDashSpeedMax )
			player.StartArmoredLeapDash( ignoreArray, dashSpeed, ARMORED_LEAP_GROUND_DASH_ACCEL, ARMORED_LEAP_LAUNCH_DASH_CROUCH_TIME, ARMORED_LEAP_RECOVERY_TIME, endPoint, ARMORED_LEAP_TIMEOUT_DASH )

			table signalData = player.WaitSignal( "ArmoredLeap_StartTravelGroundPhase", "ArmoredLeap_Interrupted" )
			bool interrupted = WasArmoredLeapInterrupted( player, signalData )

			if ( interrupted )
			{
				#if SERVER
				                                                                     
				                                               
				#endif

				return
			}
		}
		else
		{
			player.Player_SetArmoredLeapState_Depricated( PLAYER_ARMORED_LEAP_STATE_GROUND_START )                   
			waitthread ArmoredLeap_LaunchPrep_Thread( player, endPoint, airPoint, ARMORED_LEAP_LAUNCH_DASH_CROUCH_TIME )
		}

		if ( !IsValid( player ) )
			return

		if ( !GetArmoredLeapUseCode() )
		{
			                         
			endPoint = ArmoredLeap_GetUpdatedLKP( player, airPoint, endPoint )                           
		}


		                 
		#if SERVER
			                                           
			                                  
		#endif
	}
	else if ( armoredLeapType == PLAYER_ARMORED_LEAP_TYPE_JUMP )	                        
	{

		StopSoundOnEntity( player, ARMORED_LEAP_SOUND_ACTIVATE_1P )
		if ( GetArmoredLeapUseCode() )
		{
			float timeOut
			if( player in file.allyLKP )
				timeOut = ARMORED_LEAP_TIMEOUT_JUMP_ALLY
			else
				timeOut = ARMORED_LEAP_TIMEOUT_JUMP

			float leapDist = Distance( player.GetOrigin(), airPoint )
			float jumpSpeed = GraphCapped( leapDist, ARMORED_LEAP_GROUND_DASH_RANGE, ARMORED_LEAP_DISTANCE, file.airJumpSpeedMin, file.airJumpSpeedMax )
			float hoverSpeed = GraphCapped( leapDist, ARMORED_LEAP_GROUND_DASH_RANGE, ARMORED_LEAP_DISTANCE, file.airHoverSpeedMax, file.airHoverSpeedMin )

			float airPosRange 	= ARMORED_LEAP_AIRPOS_CHECK_RANGE
			float hoverRange	= GraphCapped( leapDist, ARMORED_LEAP_GROUND_DASH_RANGE, ARMORED_LEAP_DISTANCE, ARMORED_LEAP_AIRPOS_CHECK_RANGE_MIN, ARMORED_LEAP_AIRPOS_CHECK_RANGE_MAX )

			player.StartArmoredLeapJump( ignoreArray, jumpSpeed, ARMORED_LEAP_JUMP_ACCEL, hoverSpeed, ARMORED_LEAP_HOVER_ACCEL, diveSpeed, ARMORED_LEAP_DIVE_ACCEL, ARMORED_LEAP_LAUNCH_CROUCH_TIME, ARMORED_LEAP_RECOVERY_TIME, airPosRange, hoverRange, airPoint, endPoint, timeOut )
			thread ArmoredLeap_LaunchToAirPosition( player, null,endPoint, airPoint )

			table signalData = player.WaitSignal( "ArmoredLeap_StartTravelGroundPhase", "ArmoredLeap_Interrupted" )
			bool interrupted = WasArmoredLeapInterrupted( player, signalData )

			if ( interrupted )
			{
				#if SERVER
				                                                                     
				                                               
				#endif

				return
			}
		}
		else
		{
			waitthread ArmoredLeap_LaunchToAirPosition( player, mover, endPoint, airPoint )
		}
	}
	else             
	{
		if ( GetArmoredLeapUseCode() )
		{
			player.StartArmoredLeapAirDive( ignoreArray, ARMORED_LEAP_HOVER_DIVE_PREP_SPEED, ARMORED_LEAP_HOVER_DIVE_PREP_ACCEL, diveSpeed, diveSpeed / ARMORED_LEAP_SLAM_EASE_IN_TIME, ARMORED_LEAP_AIR_HOVER_TIME, ARMORED_LEAP_RECOVERY_TIME, endPoint, ARMORED_LEAP_TIMEOUT_AIR_DIVE, armoredLeapType == PLAYER_ARMORED_LEAP_TYPE_AIR_DIVE_LONG )
			thread ArmoredLeap_LaunchHoverPrep_Thread( player, endPoint, player.EyePosition() )

			table signalData = player.WaitSignal( "ArmoredLeap_StartTravelGroundPhase", "ArmoredLeap_Interrupted" )
			bool interrupted = WasArmoredLeapInterrupted( player, signalData )
			
			if ( interrupted )
			{
				#if SERVER
				                                                                     
				                                               
				#endif

				return
			}
		}
		else
		{
			player.Player_SetArmoredLeapState_Depricated( PLAYER_ARMORED_LEAP_STATE_AIR_HOVER )                  

			#if SERVER
				                                                            
			#endif

			waitthread ArmoredLeap_LaunchHoverPrep_Thread( player, endPoint, player.EyePosition() )
		}

		if( !IsValid( player ) )
			return

		if ( !GetArmoredLeapUseCode() )
		{
			if( IsValid(mover) )
				mover.SetOrigin( player.GetOrigin() )
		}

		#if SERVER
			                 
			                                           
			                                  

			                               
				                                                                          
		#endif
		isHoverSlam = true
	}

	                                                                                              
	if ( !IsValid( player ) )
		return
	if ( player.IsPhaseShifted() )
		return

	                   
	   
	  	                                                                                  
	   
	      

	StopSoundOnEntity( player, ARMORED_LEAP_SOUND_ACTIVATE_1P )

	if ( !GetArmoredLeapUseCode() )
	{
		if( inDashRange )
		{
			player.Player_SetArmoredLeapState_Depricated( PLAYER_ARMORED_LEAP_STATE_GROUND_DASH )             
		}
		else
			player.Player_SetArmoredLeapState_Depricated( PLAYER_ARMORED_LEAP_STATE_AIR_DIVE )             
	}

	Signal( player,"ArmoredLeap_LaunchEffectsEnd" )

	if ( GetArmoredLeapUseCode() )
	{
		thread ArmoredLeap_SlamToGroundPosition( player, null, endPoint, airPoint, inDashRange )

		table signalData = player.WaitSignal( "ArmoredLeap_StartArrivalPhase", "ArmoredLeap_Interrupted" )
		bool interrupted = WasArmoredLeapInterrupted( player, signalData )

		if ( interrupted )
		{
			#if SERVER
			                                                                     
			                                               
			#endif

			return
		}
	}
	else
	{
		endPoint = ArmoredLeap_GetUpdatedLKP( player, airPoint, endPoint )      

		                         
		waitthread ArmoredLeap_SlamToGroundPosition( player, mover, endPoint, airPoint, inDashRange )
	}




	                                                                                             
	if ( !IsValid( player ) )
		return

	if ( player.IsPhaseShifted() )
		return

	#if SERVER
	                               
	 
		                                        
			                                                  
	 
	                                                                                                                                        
	#endif

	if ( !GetArmoredLeapUseCode() )
	{
	                                
		if( inDashRange )                                                                                                                                      
			player.Player_SetArmoredLeapState_Depricated( PLAYER_ARMORED_LEAP_STATE_GROUND_END )                 
		else
			player.Player_SetArmoredLeapState_Depricated( PLAYER_ARMORED_LEAP_STATE_AIR_END )                
	}

	vector finalAngles = VectorToAngles( player.GetViewVector() )
	                                                                                      

	#if SERVER
		                             
		                                                                                
		                               
		 
			                    

			           
		 

		                       
			      

		                                  
		 
			                                                
			      
		 
	#endif

	waitthread ArmoredLeap_ReturnControlToPlayerAfterDelay( player, ARMORED_LEAP_RECOVERY_TIME )

	#if SERVER
	                       
		                                                
	#endif

	if( player in file.allyTarget )
		delete file.allyTarget[player]

	WaitForever()
}

bool function WasArmoredLeapInterrupted( entity player, table signalData )
{
	bool interrupted = expect bool( signalData.interrupted )

	                                                                                                                                                                                                                                                                                                
	if ( !interrupted )
	{
		if ( GetCurrentArmoredLeapPhase( player ) == PLAYER_ARMORED_LEAP_PHASE_INTERRUPTED )
		{
			player.Signal( "ArmoredLeap_Interrupted", { interrupted = true } )
			interrupted = true
		}
	}

	return interrupted
}

#if SERVER
                                               
 
	                                                                                                                                                                                                                              
	                                                                                                                                            
	 
		                                                   
		                                                                                
		 
			                            
			                                 

			           
		 
	 

	            
 


                                                                   
 
	                                           
	             

	                   
	 
		                                                           
		                                                                                                                                                                      
		                              
	 
	    
	 
		                         
	 

	                                                                                                                                                
 
#endif

int function GetCurrentArmoredLeapPhase( entity player )
{
	int leapPhase = PLAYER_ARMORED_LEAP_PHASE_NONE

	#if SERVER
	                                             
		                                                
	#elseif CLIENT
	leapPhase = file.currentArmoredLeapPhase
	#endif

	return leapPhase
}


void function ArmoredLeap_Handle_StatusEffectInterrupt( entity player )
{
	if ( player.IsArmoredLeapActive() )
	{
		player.Signal( "ArmoredLeap_Interrupted", { interrupted = true } )
		player.EndArmoredLeap()

		#if SERVER
		                                                  

		                                                                          
		                           
		 
			                                                                                                                    
		 
		#endif         
	}
}

#if SERVER
                                                                            
 
	                                   

	                                                                                                                                                                                                                                                                              
	                                                                           
	                                                                                                                      
	 
		                          
		           
	 
	                                                                    
	 
		                                                
		            
	 

	            
 
#endif

void function ArmoredLeap_UpdateLKP_Thread( entity player, vector airPoint, vector endPoint )
{
	Assert ( IsNewThread(), "Must be threaded off." )
	player.EndSignal( "OnDestroy" )
	player.EndSignal( "ArmoredLeap_StartTravelGroundPhase" )
	player.EndSignal( "ArmoredLeap_EndTravelAirHoverPhase" )
	player.EndSignal( "ArmoredLeap_Interrupted" )
	player.EndSignal( "ArmoredLeap_LeapComplete" )
	player.EndSignal( "Interrupted" )

	while( true )
	{
		endPoint = ArmoredLeap_GetUpdatedLKP( player, airPoint, endPoint )                         
		player.UpdateArmoredLeapEndPos( endPoint )
		WaitFrame()
	}
}

                                                                                                    
                                                                                                    
                                                                                                    

void function ArmoredLeap_LaunchPrep_Thread( entity player, vector endPoint, vector airPoint, float crouchTime )
{
	EndSignal( player, "OnDeath" )
	EndSignal( player, "OnDestroy" )
	EndSignal( player, "BleedOut_OnStartDying" )
	EndSignal( player, "Interrupted" )

	#if SERVER
		                
		                                                                            
		                               
		 
			                       
			                                                             
		 
	#endif

	#if SERVER
	            
		                                      
		 
			                        
			 
				                               
				 
					                                         
					                        
				 
			 
		 
	 
	#endif

	bool launchSFX = false
	vector targetPos = endPoint
	float endCrouchTime = Time() + crouchTime

	while( Time() < endCrouchTime )
	{
		if (!IsValid(player))
			return

		if ( player.IsPhaseShifted() )
			return

		if ( !GetArmoredLeapUseCode() )
		{
			endPoint = ArmoredLeap_GetUpdatedLKP( player, airPoint, targetPos )                  
		}

		#if SERVER
			                                                                                                                                 
			 
				                
				                                                                             
				                                                                               
			 
		#endif

		WaitFrame()
	}
}

void function ArmoredLeap_LaunchHoverPrep_Thread( entity player, vector endPoint, vector airPoint )
{
	EndSignal( player, "OnDeath" )
	EndSignal( player, "OnDestroy" )
	EndSignal( player, "BleedOut_OnStartDying" )
	EndSignal( player, "Interrupted" )

	if( !IsValid( player ) )
		return

	OnThreadEnd(
		function() : ( player )
		{
			if ( IsValid( player ) )
			{
				#if SERVER
				                               
				 
					                                                   
					       
						                      
							                                   
					      
				 
				#endif
			}
		}
	)

	#if SERVER
	                               
	 
		                                                
		                                        
		                                                                                                                             

		                           
		       
		                                                                
		                            
		      
	 
	#endif

	                             
	float endTime = Time() + ARMORED_LEAP_AIR_HOVER_TIME
	while( Time() < endTime  )
	{
		if( !IsValid( player ) )
			return

		#if SERVER
		                                                 
		 
			                                                                   

			                                                
			      
		 

		                              
		 
			                                                
			      
		 
		#endif

		endPoint = ArmoredLeap_GetUpdatedLKP( player, player.EyePosition(), endPoint )                  
		WaitFrame()
	}
}


void function ArmoredLeap_LaunchToAirPosition( entity player, entity mover, vector endPoint, vector airPoint )
{
	EndSignal( player, "OnDeath" )
	EndSignal( player, "OnDestroy" )
	EndSignal( player, "BleedOut_OnStartDying" )
	EndSignal( player, "ArmoredLeap_AirLaunchComplete" )
	EndSignal( player, "Interrupted" )

	if ( !IsValid( player ) )
		return

	if ( !GetArmoredLeapUseCode() )
		player.Player_SetArmoredLeapState_Depricated( PLAYER_ARMORED_LEAP_STATE_AIR_START )                   

	OnThreadEnd(
		function() : ( player )
		{

			if ( IsValid( player ) )
			{
				#if CLIENT
					if ( player == GetLocalClientPlayer() )
						Signal( player, "ArmoredLeap_AirLaunchComplete" )
				#endif         
				#if SERVER
					                                                                          
					                                                                                                 

					                                                           
					                                                           
				#endif
			}
		}
	)

	                        
	if ( GetArmoredLeapUseCode() )
	{
		thread ArmoredLeap_LaunchPrep_Thread( player, endPoint, airPoint, ARMORED_LEAP_LAUNCH_CROUCH_TIME )
		player.WaitSignal( "ArmoredLeap_EndPrepPhase" )

		if ( !IsValid( player ) )
			return
	}
	else
	{
		waitthread ArmoredLeap_LaunchPrep_Thread( player, endPoint, airPoint, ARMORED_LEAP_LAUNCH_CROUCH_TIME )

		if ( !IsValid( player ) )
			return

		player.Player_SetArmoredLeapState_Depricated( PLAYER_ARMORED_LEAP_STATE_AIR_UP )                    

		                         
		endPoint = ArmoredLeap_GetUpdatedLKP( player, airPoint, endPoint )                           
	}

	float dist = Distance( player.GetOrigin(), airPoint )
	bool isAtHoverDist = false

	#if SERVER
		                 
		                                           
		                                  

		                      
		                                                                               
		                                                                                 

		                                       

		                                                     
		                                      
		                                                                 

		                                                                                                                                                                  
		                                                                                                                                                                    
		                                                                                                                                                                 

		       
			                        
			 
				                                                                                                                                                  
				                                                                                                                                                          
				                                                                                                                                                      
			 
		            

		                               
			                                                         
	#endif

	                                                          
	if ( GetArmoredLeapUseCode() )
	{
		player.WaitSignal( "ArmoredLeap_EndTravelAirHoverPhase" )
	}
	else
	{
		                                                          
		while( dist > ARMORED_LEAP_AIRPOS_CHECK_RANGE )
		{
			if( !IsValid(player) )
				return

			#if SERVER
				                                                 
				 
					                                                
					      
				 
			#endif

			dist = Distance( player.GetOrigin(), airPoint )

			if( dist < ARMORED_LEAP_AIRPOS_CHECK_RANGE * 2 && !isAtHoverDist )
			{
				player.Player_SetArmoredLeapState_Depricated( PLAYER_ARMORED_LEAP_STATE_AIR_HOVER )                  
				isAtHoverDist = true
			}

			endPoint = ArmoredLeap_GetUpdatedLKP( player, airPoint, endPoint )                         
			WaitFrame()
		}
	}
}


void function ArmoredLeap_SlamToGroundPosition( entity player, entity mover, vector endPoint, vector airPoint, bool isDashing )
{
	player.EndSignal( "OnDeath" )
	player.EndSignal( "OnDestroy" )
	EndSignal( player, "BleedOut_OnStartDying" )
	EndSignal( player, "ArmoredLeap_GroundDiveComplete" )
	EndSignal( player, "ArmoredLeap_LeapComplete" )
	player.EndSignal( "ArmoredLeap_StartArrivalPhase" )
	player.EndSignal( "ArmoredLeap_Interrupted" )
	player.EndSignal( "Interrupted" )

	endPoint = endPoint + ARMORED_LEAP_ENDPOINT_BUFFER                                                                 
	float dist = Distance( player.GetOrigin(), endPoint )

	#if SERVER
		                                                           
		                                                         

		                                                                                                                                                              
		               
			                                          

		                                    
		                                                          

		             
		 
			                                                                                                                                                                  
			                                                                                                                                                                    
			                                                                                                                                                                 
			       
				                        
				 
					                                                                                                                                                          
					                                                                                                                                                      
				 
			            
		 
		    
		 
			                                                                                                                                                              
			                                                                                                                                                                
			                                                                                                                                                             
			       
				                        
				 
					                                                                                                                                                      
					                                                                                                                                                  
				 
			            
		 

		                                                                   
		                                                                 
		                                                                



		                                           
		                                          

		                               
			                                                         

		                                 
		                     
		                                                       
		                                                                

		                                                                                                                                                                                                                
		                     
		                                                  

		                  

		                         
		                                                                      
		                     	                                             
		                      	                                              

		                                                                                                                        
		                                                                                                                         
		                       
		                       

		                  
		                                                                               
		                                                                                 
		                                                                               
		                                                                                 

		            
			                                
			 
				                        
				 
					                                                                                                
					                                               

					                                                           
					                                                           

				 
				                       
				 
					                 
					 
						                
						            
					 
				 
			 
		 
	#endif

	if ( GetArmoredLeapUseCode() )
	{
		                                                                                                   
		WaitForever()
	}
	else
	{
		dist = Distance( player.GetOrigin(), endPoint )
		vector endPos = endPoint
		while( dist > ARMORED_LEAP_GROUNDPOS_CHECK_RANGE )
		{
			if( !IsValid( player ) )
				return

			vector pOrigin = player.GetOrigin()
			#if SERVER
				                                               
				 
					                                                                                                                                                                                                                         
					                                                                                                     
					 
						     
					 
					                                                                    
					 
						                                                
						      
					 
				 
			#endif

			                                                                                                                        

			vector lastPos = endPos
			float zHeight = max( player.GetOrigin().z, endPos.z )
			vector upTestPos = <endPos.x, endPos.y, zHeight>

			                                                                                                                 
			                                                                                                                                           
			TraceResults testTrace = TraceLine( endPos, upTestPos, GetPlayerArray_AliveConnected(), TRACE_MASK_PLAYERSOLID, TRACE_COLLISION_GROUP_PLAYER_MOVEMENT )
			TraceResults endTrace = TraceLine( testTrace.endPos , endPoint + < 0.0, 0.0, -500 >,  GetPlayerArray_AliveConnected(), TRACE_MASK_PLAYERSOLID, TRACE_COLLISION_GROUP_PLAYER_MOVEMENT )
			if ( endTrace.fraction < 1.0 && endPos != endTrace.endPos && !endTrace.startSolid )
			{
				endPos = endTrace.endPos + ARMORED_LEAP_ENDPOINT_BUFFER
			}

			dist = Distance( player.GetOrigin(), endPos )
			#if SERVER
				                                                         
				 
					                                               
					 
						                
						                                                                                                                                                             
						                                                                                                                                                      
						               
							                                          

						                           

						                                  
						                                   

						                                                
						                
					 
					    
						                      
				 
			#endif

			WaitFrame()
		}
	}
}

void function ArmoredLeap_ReturnControlToPlayerAfterDelay( entity player, float delay )
{
	EndSignal( player, "OnDeath" )
	EndSignal( player, "OnDestroy" )
	EndSignal( player, "BleedOut_OnStartDying" )
	EndSignal( player, "Interrupted" )

	OnThreadEnd(
		function() : ( player )
		{
			if( IsValid( player ) )
			{
				#if SERVER
					                       
				#endif
				if ( GetArmoredLeapUseCode() )
				{
					player.SetArmoredLeapState( PLAYER_ARMORED_LEAP_STATE_NONE )
				}
				else
				{
					player.Player_FinishArmoredLeap_Depricated()
				}
			}
		}
	)
	#if SERVER
		                                                                                                                                                                                                                                
		                            
		 
			                                                                                 
		 
		                             
		                        
		                                                                                         
	#endif        

	wait delay

}

void function ArmoredLeap_CameraRecoveryDelay( entity player, float delay )
{
	EndSignal( player, "OnDeath" )
	EndSignal( player, "OnDestroy" )
	EndSignal( player, "BleedOut_OnStartDying" )
	EndSignal( player, "Interrupted" )

	OnThreadEnd(
		function() : ( player )
		{
			if( IsValid( player ) )
			{
				#if SERVER
				                           
				                                     
				                                 
				#endif
			}
		}
	)
	wait delay

}


void function CodeCallback_ArmoredLeapPhaseChange( entity player, int newArmoredLeapPhase, int oldArmoredLeapPhase )
{
	if ( !IsValid( player ) )
		return

	#if DEV
	if ( DEBUG_PHASE_CHANGES )
		printt( FUNC_NAME() + " got code callback for player: " + player.GetPlayerName() + " phase is: " + armoredLeapPhaseToStringMap[newArmoredLeapPhase] + " old phase is: " + armoredLeapPhaseToStringMap[oldArmoredLeapPhase] )
	#endif

	switch( oldArmoredLeapPhase )
	{
		case PLAYER_ARMORED_LEAP_PHASE_PREP:
			player.Signal( "ArmoredLeap_EndPrepPhase" )
			break
		case PLAYER_ARMORED_LEAP_PHASE_TRAVEL_AIR:
			player.Signal( "ArmoredLeap_EndTravelAirPhase" )
			break
		case PLAYER_ARMORED_LEAP_PHASE_TRAVEL_AIR_HOVER:
			player.Signal( "ArmoredLeap_EndTravelAirHoverPhase" )
			break
		case PLAYER_ARMORED_LEAP_PHASE_TRAVEL_GROUND:
			player.Signal("ArmoredLeap_EndTravelGroundPhase")
			break
		case PLAYER_ARMORED_LEAP_PHASE_ARRIVAL:
			player.Signal( "ArmoredLeap_EndArrivalPhase" )
			break
	}

	switch( newArmoredLeapPhase )
	{
		case PLAYER_ARMORED_LEAP_PHASE_PREP:
			break
		case PLAYER_ARMORED_LEAP_PHASE_TRAVEL_AIR:
			player.Signal( "ArmoredLeap_StartTravelAirPhase", { interrupted = false } )
			break
		case PLAYER_ARMORED_LEAP_PHASE_TRAVEL_AIR_HOVER:
			player.Signal( "ArmoredLeap_StartTravelAirHoverPhase", { interrupted = false } )
			break
		case PLAYER_ARMORED_LEAP_PHASE_TRAVEL_GROUND:
			player.Signal( "ArmoredLeap_StartTravelGroundPhase", { interrupted = false } )
			break
		case PLAYER_ARMORED_LEAP_PHASE_ARRIVAL:
			player.Signal( "ArmoredLeap_StartArrivalPhase", { interrupted = false } )
			break
		case PLAYER_ARMORED_LEAP_PHASE_NONE:
			player.Signal( "ArmoredLeap_LeapComplete", { interrupted = false } )
			break
		case PLAYER_ARMORED_LEAP_PHASE_INTERRUPTED:
			player.Signal( "ArmoredLeap_Interrupted", { interrupted = true } )
			#if SERVER
			                                                                                                                                         
			                                                                                                                  
			                                                                                        
			#endif         
			break
	}

	#if SERVER
	                                                           
	#elseif CLIENT
	file.currentArmoredLeapPhase = newArmoredLeapPhase
	#endif
}

                                                                                                    
                                                                                                   
                                                                                                    
#if SERVER
                                                              
 
	                      
		      

	                                            
	                                                                                     

	                                             

	                      
		      

	                                       
		                                      

	                                        
	                                                                                      
 
#endif

#if CLIENT
void function ServerToClient_ArmoredLeapComplete( entity player )
{
	if ( player != GetLocalClientPlayer() )
		return
	Signal( player, "ArmoredLeap_LeapComplete" )
}

void function ServerToClient_ArmoredLeapShutdown( entity player )
{
	if ( player != GetLocalClientPlayer() )
		return
	Signal( player, "ArmoredLeap_LeapShutdown" )

	if( player in file.armoredLeapTargetTable )                                                                                                                                          
		delete file.armoredLeapTargetTable[player]
}

void function ServerToClient_ArmoredLeapInterrupted( entity player )
{
	if ( player != GetLocalClientPlayer() )
		return

	player.Signal( "ArmoredLeap_Interrupted", { interrupted = true } )
}
#endif


#if CLIENT
void function ServerToClient_ArmoredLeap_AirLaunchComplete( entity player )
{
	if ( player != GetLocalClientPlayer() )
		return
	Signal( player, "ArmoredLeap_AirLaunchComplete" )
}
#endif

#if CLIENT
void function ServerToClient_ArmoredLeap_GroundDiveComplete( entity player )
{
	if ( player != GetLocalClientPlayer() )
		return
	Signal( player, "ArmoredLeap_GroundDiveComplete" )
}
#endif


void function ArmoredLeap_OnAttemptFailed( entity player, vector startpoint )
{
	if( !IsValid( player ) )
		return

	entity weapon = player.GetOffhandWeapon( OFFHAND_ULTIMATE )
	#if SERVER
		                              
		 
			                                                                                 
		 

		                               
		 
			                                                                                              
			                                         
			                     			      
			                              	     
			                                           
			                               
				                                                              
		 

	#endif

	if( !IsValid( weapon ) )
		return

	int currentAmmo = weapon.GetWeaponPrimaryClipCount()
	int ammo = minint( currentAmmo + ARMORED_LEAP_REFUND_AMOUNT_FRAC, weapon.GetWeaponPrimaryClipCountMax() )
	weapon.SetWeaponPrimaryClipCount( ammo )

}

bool function ArmoredLeap_IsInterrupted( entity player, vector destination )
{
	if( !IsValid(player) )
		return false

	if(	player.IsPhaseShifted() )
		return true

	vector mins   		= ARMORED_LEAP_COL_MINS
	vector maxs   		= ARMORED_LEAP_COL_MAXS
	vector pPos	  		= player.GetOrigin() + <0,0,35>
	vector fwd 	  		= Normalize( player.GetForwardVector() )

	                                                                  

	array<entity> ignoreArray = ArmoredLeapIgnoreArray()
	TraceResults results = TraceHull( pPos, destination , mins, maxs, ignoreArray, TRACE_MASK_PLAYERSOLID, TRACE_COLLISION_GROUP_PLAYER_MOVEMENT )
	if ( results.startSolid )
	{
		return true
	}

	float distToEnd = Distance(pPos, results.endPos)

	if( distToEnd <= 200 )
	{
		bool isValidEnd = ArmoredLeap_HasValidHullRoom( player, destination )
		entity pusher = GetPusherEnt( results.hitEnt )
		if ( pusher )
		{
			vector position = pusher.GetOrigin()
			if ( LengthSqr(pusher.GetAbsVelocityAtPoint(position)) > file.maxEndingMoverSpeedSqr )	                                                                                    
				return true
		}

		if( !isValidEnd )
			return true
	}


	return false
}


#if DEV
#if SERVER
                                                                                                             
 
	                              
	                                
	                                            
	                                              

	                        
	 
		                                                              
		                                                                                      
		                                                                                     
		                                                                                  
		        
		             
	 

 
#endif
#endif

                              
                              
#if SERVER
                                                           
 
	                              
	                                
	                                            
	                                                  
	                                                         
	                                              
	                                  

	                         
		      

	                         
	                                                                        
	                                                                      

	                     	                                             
	                      	                                              
	                    	                                            
	                     	                                            

	                     
	                                                                                                                     
	                                                                                                                      
	                      
	                      

	                                                                                                                        
	                                                                                                                         
	                       
	                       

	            
		                                
		 
			                        
			 
			 

			                        
			 
				                 
				 
					              
					            
				 
			 
		 
	 

	             
 

#endif

#if SERVER
                                                                                              
 
	                              
	                                
	                                            
	                                  

	                                                                  
	                                  
	                           

	                     

	                                                                                   
	                       
	                       
	                                                      
	                                                      
	                                                                               
	                            
	                                        

	                                                                                    
	                        
	                                                    
	                                                       
	                                                         
	                             
	                                         

	                      
	                       

	                             
	                                            
	                       
	                        

	              
	 
		                                                                                        
		                                                                                                            
		                             
		                                                       
		                                                                 
	 

	                     
	                                                                              
	                                                                       
	                             
	                           
	                                
	                                            

	            
		                                                        
		 
			                        
			 
			 
			                        
			 
				                  
					        

				                
				                
				            
			 
			                         
			 
				                        
				                                                  
			 
			                         
			 
				                    
			 
		 
	 

	                                 
	                       
	                             

	                                       
	                                                                      
	                          
	 
		                                                                                                         
		                                                                                                                                                   
		                                                                                                                                                            
		                                              
		 
			                            
			 
				                                                       
			 

			                            
				                                

			                                       
			                       
			 
				                                                                                                                                       
				                                                          
				 
					                       

					                                                                                                                        
					 
						                       
						 
							                  
								        

							                                  
							                      
						 

						                           
						 
							                                          
							                              
						 

						                 
					 
				 
				                                                
					                        

			 
			    
				                        

			                       
			 
				                        
				 
					                            
						                                

					                       
					 
						                
							        

						                
						                            
					 

					                           
					 
						                        
						                                    
					 

					                  
				 
			 

		 

		           
	 
 

                                                                
 
	                                                            
	            
		                           
		 
			                         
			 
				                        
				                    
			 
		 
	 
	        
 
#endif

#if SERVER
                                                                                                 
 
	                            
	                                                
	 
		                        
			        

		                                                        
			        

		                             
	 

	                                                  

	                   
	 
		                                       
		 
			                         
			                                                                                                   
		 
	 
 
                                                               
 
	                            
	                                                
	 
		                        
			        

		                                                        
			        

		                             
	 
	                          
	                                       
	 
		                                                                                                  
	 
 
#endif

#if CLIENT
void function ServerToClient_SetClient_BleedoutWaypoint( entity victim, entity wp )
{
	if( IsValid( wp ) )
		file.bleedoutWP[victim] <- wp
}
void function ServerToClient_RemoveClient_BleedoutWaypoint( entity victim )
{
	if( victim in file.bleedoutWP )
		delete file.bleedoutWP[ victim ]
}
#endif

#if CLIENT
void function ServerToClient_RescueTargetRui_Activate( entity allyTarget, entity player )
{
	if ( allyTarget != GetLocalClientPlayer() )
		return

	thread ArmoredLeap_CreateAllyRescueHud( allyTarget, player )
}

void function ServerToClient_RescueTargetRui_Deactivate( entity allyTarget )
{
	if ( allyTarget != GetLocalClientPlayer() )
		return

	Signal( allyTarget, "ArmoredLeap_AllyRescueComplete" )
}

void function ArmoredLeap_CreateAllyRescueHud( entity allyTarget, entity player )
{
	if ( allyTarget != GetLocalClientPlayer() )
		return

	if( !IsValid( player ) )
		return

	player.EndSignal( "OnDeath" )
	player.EndSignal( "OnDestroy" )
	EndSignal( player, "BleedOut_OnStartDying" )

	allyTarget.EndSignal( "OnDeath" )
	allyTarget.EndSignal( "OnDestroy" )
	EndSignal( allyTarget, "ArmoredLeap_AllyRescueComplete" )

	          
	var rui = CreateCockpitRui( $"ui/newcastle_rescue_icon.rpak", HUD_Z_BASE )

	RuiSetBool( rui, "isVisible", true )
	RuiSetBool( rui, "showClampArrow", true )

	OnThreadEnd(
		function() : ( rui )
		{
			RuiDestroyIfAlive( rui )
		}
	)

	while ( true )
	{
		if ( !IsValid( player ) )
			return
		if ( !IsValid( allyTarget ) )
			return

		                                                       
		int attachment = player.LookupAttachment( "CHESTFOCUS" )
		RuiTrackFloat3( rui, "pos", player, RUI_TRACK_POINT_FOLLOW, attachment )

		WaitFrame()
	}

}
#endif         



void function ArmoredLeap_TargetPlacementTracking_Thread( entity ent )
{
	EndSignal( ent, "OnDeath" )
	EndSignal( ent, "OnDestroy" )
	EndSignal( ent, "BleedOut_OnStartDying" )
	EndSignal( ent, "StopArmoredLeapTargetPlacement" )                                                           
	EndSignal( ent, "ArmoredLeap_LeapComplete" )
	EndSignal( ent, "ArmoredLeap_Interrupted" )

	                                                                                                   
	file.isTargetPlacementActive[ent] <- true

	bool inDanger = false
	entity lastAttacker
	bool attackerNearby

	array<entity> allyArray = GetAllyPlayerArray(ent)
	foreach ( ally in allyArray )
	{
		if ( ally == ent )
			continue

		if( !IsValid( ally ) )
			continue

		file.allyIsInDanger[ally] <- false
	}

	OnThreadEnd(
		function() : ( ent, allyArray )
		{
			if ( IsValid( ent ) )
			{
				if( ent in file.isTargetPlacementActive )
					delete file.isTargetPlacementActive[ent]

			}

			foreach ( ally in allyArray )
			{
				if( !IsValid( ally ) )
					continue

				if( ally in file.allyIsInDanger )
					delete file.allyIsInDanger[ally]
			}
		}
	)


	while( IsValid(ent) )
	{
		                                   
		ArmoredLeapTargetInfo info                                                                                                                   
		ArmoredLeap_SetAllyTargetAndLKP( ent, info )

		                                                                                 
		                                                                                                                          
		                                                                                                                                    
		                                                                                                                                                                           



		                                                                             
		allyArray = GetAllyPlayerArray( ent )

		foreach ( ally in allyArray )
		{
			if ( ally == ent )
				continue

			if( !IsValid( ally ) )
				continue

			if ( ally.e.recentDamageHistory.len() > 0 )
			{
				lastAttacker = ally.e.recentDamageHistory[ 0 ].attacker                                       
			}

			if( IsValid( lastAttacker ) )
			{
				float distToAttacker = 	Distance2D( ally.GetOrigin(), lastAttacker.GetOrigin() )
				if( distToAttacker < ARMORED_LEAP_ALLY_DANGER_DISTANCE_MAX )
					attackerNearby = true
				else
					attackerNearby = false
			}

			#if SERVER
				                                                                                                                           
				 
					               
				 
				    
				 
					                      
					                
				 

				                                 
				 
					                                         
					 
						                                     
						                                                                                                  
					 
				 

			#endif
		}


		WaitFrame()
	}

}

void function ArmoredLeap_SetAllyTargetAndLKP( entity ent, ArmoredLeapTargetInfo info )
{
	entity targetAlly = GetAllyTargetInRange( ent )
	array<entity> ignoreArray = ArmoredLeapIgnoreArray()

	bool foundValidEnd = false

	if( IsValid( targetAlly ) )
	{
		file.allyTarget[ent] <- targetAlly
		vector allyEndPos = targetAlly.GetOrigin() + < 0,0,5 >                           

		TraceResults groundTrace = TraceLine( allyEndPos, allyEndPos + <0,0,-1000>, ignoreArray, TRACE_MASK_ABILITY, TRACE_COLLISION_GROUP_PLAYER_MOVEMENT )
		if( groundTrace.fraction < 1 )                                           
		{
			entity hitEnt = groundTrace.hitEnt
			                                                                                                                                               
			allyEndPos = ArmoredLeap_GetBestAllyLandingPos( ent, groundTrace.endPos, Normalize(ent.GetViewVector()), info )                                  
			                                                              

			foundValidEnd  = ArmoredLeap_HasValidLeapPos( ent, targetAlly, allyEndPos, hitEnt, info )
			                                                                  

			if( foundValidEnd )
			{
				info.hasAlly = true
				info.allyTarget = targetAlly

				file.allyLKP[ent] <- allyEndPos
			}
			else
			{
				if ( ent in file.allyLKP )
				{
					if ( IsValid( file.allyLKP[ent] ) )
					{
						allyEndPos = file.allyLKP[ent]
						foundValidEnd = ArmoredLeap_HasValidLeapPos( ent, targetAlly, allyEndPos, hitEnt, info )
						if ( foundValidEnd )
						{
							info.hasAlly = false
							info.allyTarget = targetAlly
						}
						else
						{
							if ( ent in file.allyLKP )
								delete file.allyLKP[ent]
						}
					}
				}
			}
		}
		else
		{
			if( ent in file.allyTarget )
				delete file.allyTarget[ent]

			if( ent in file.allyLKP )
				delete file.allyLKP[ent]
		}
	}
	else
	{
		if( ent in file.allyTarget )
			delete file.allyTarget[ent]

		if( ent in file.allyLKP )
			delete file.allyLKP[ent]
	}
}

vector function ArmoredLeap_GetUpdatedLKP( entity player, vector airPoint, vector targetPos )
{
	if( player in file.allyTarget )
	{
		if( IsValid( file.allyTarget[player] ) )
		{
			array<entity> ignoreArray = ArmoredLeapIgnoreArray()
			vector adjustedEndPos = file.allyTarget[player].GetOrigin() + < 0,0,5 >                           

			TraceResults groundTrace = TraceLine( adjustedEndPos, adjustedEndPos + <0,0,-1000>, ignoreArray, TRACE_MASK_ABILITY, TRACE_COLLISION_GROUP_PLAYER_MOVEMENT )                                   
			if( groundTrace.fraction < 1 )                                           
			{
				adjustedEndPos = groundTrace.endPos + < 0,0,5 >
				float dist2D = Distance2D( airPoint, adjustedEndPos )
				if( dist2D <= ARMORED_LEAP_MAX_SLAM_FOLLOW_DISTANCE )
				{
					                                                                                          
					adjustedEndPos = groundTrace.endPos + < 0,0,5 >
					TraceResults slamTrace = TraceHull( airPoint, adjustedEndPos, player.GetPlayerMins(), player.GetPlayerMaxs(), ignoreArray, TRACE_MASK_PLAYERSOLID, TRACE_COLLISION_GROUP_PLAYER_MOVEMENT )

					if ( slamTrace.fraction == 1.0 )
					{
						file.allyLKP[player] <- slamTrace.endPos
					}
				}
			}

		}
		else
			delete file.allyTarget[player]
	}

	if( player in file.allyLKP )
	{
		targetPos = file.allyLKP[player]

	}

	                                                                       
	                                                              
	return targetPos
}


                                                                                                    
                                                                                                    
                                                                                                    

#if CLIENT
void function ArmoredLeap_AR_Placement_Thread( entity weapon )
{
	entity player = weapon.GetWeaponOwner()

	if( !IsValid( player ) )
		return

	player.EndSignal( "OnDeath" )
	player.EndSignal( "OnDestroy" )
	EndSignal( player, "BleedOut_OnStartDying" )
	EndSignal( player, "VisorMode_DeActivate" )
	EndSignal( player, "ArmoredLeap_LeapComplete" )
	EndSignal( player, "ArmoredLeap_Interrupted" )

	int team = player.GetTeam()

	thread ArmoredLeap_VisionMode_Thread( player )

	                                          
	array<var> ruis

	table< entity, var > allyRui
	array<entity> allyArray = GetAllyPlayerArray( player )


	                     
	array<entity> arEnts

	entity endPointMover = CreateClientsideScriptMover( $"mdl/dev/empty_model.rmdl", <0, 0, 0>, <0, 0, 0> )			                                                                    
	entity allyMover	 = CreateClientsideScriptMover( $"mdl/dev/empty_model.rmdl", <0, 0, 0>, <0, 0, 0> )			                                             
	entity shieldMover = CreateClientsideScriptMover( CASTLE_WALL_SHIELD_ANCHOR_COL_FX, <0, 0, 0>, <0, 180, 0> ) 	                          
	shieldMover.EnableRenderAlways()
	shieldMover.kv.rendermode = 3
	shieldMover.kv.renderamt = 1
	DeployableModelHighlightNewcastle( shieldMover )

	arEnts.append(endPointMover)
	arEnts.append(allyMover)
	arEnts.append(shieldMover)

	                        
	entity arrowLeap = CreateClientsideScriptMover( $"mdl/dev/empty_model.rmdl", ZERO_VECTOR, ZERO_VECTOR )
	entity arrowDash = CreateClientsideScriptMover( $"mdl/dev/empty_model.rmdl", ZERO_VECTOR, ZERO_VECTOR )
	arrowLeap.SetOrigin( endPointMover.GetOrigin() )                                         
	arrowDash.SetOrigin( endPointMover.GetOrigin() )

	arrowLeap.SetParent( endPointMover, "", true, 0.0 )
	arrowDash.SetParent( endPointMover, "", true, 0.0 )

	arEnts.append(arrowLeap)
	arEnts.append(arrowDash)

	                       

	OnThreadEnd(
		function() : ( ruis, arEnts )
		{
			foreach( ar in arEnts )
			{
				if( IsValid(ar) )
					ar.Destroy()
			}

			foreach ( rui in ruis )
			{
				RuiDestroyIfAlive( rui )
			}

			HidePlayerHint( ARMORED_LEAP_TARGET_FAIL_DEFAULT )
			HidePlayerHint( ARMORED_LEAP_TARGET_FAIL_BLOCKED_LAND )
			HidePlayerHint( ARMORED_LEAP_TARGET_FAIL_BLOCKED_LEAP )
			HidePlayerHint( ARMORED_LEAP_TARGET_FAIL_BLOCKED_ALLY )
		}
	)


	                                                  
	int fxID           = GetParticleSystemIndex( ARMORED_LEAP_AR_TARGET_FX_ALTZ )
	int screenFxHandle = StartParticleEffectOnEntity( endPointMover, fxID, FX_PATTACH_ABSORIGIN_FOLLOW, ATTACHMENTID_INVALID )          
	EffectSetControlPointVector( screenFxHandle, 1, NC_COLOR_FRIENDLY )
	EffectSetControlPointVector( screenFxHandle, 3, NC_COLOR_BEHIND )

	int allyBeamFxID =  GetParticleSystemIndex( ARMORED_LEAP_ALLY_BEAM_FX )
	int allyBeamHandle = StartParticleEffectOnEntityWithPos( allyMover, allyBeamFxID, FX_PATTACH_ABSORIGIN_FOLLOW, ATTACHMENTID_INVALID, endPointMover.GetOrigin() +<0,0,250>, <0,0,1> )
	EffectSetControlPointVector( allyBeamHandle, 1, TEAM_COLOR_FRIENDLY )

	int arcFxID =  GetParticleSystemIndex( ARMORED_LEAP_PLACEMENT_ARC )
	int arcFxHandle = StartParticleEffectOnEntity( shieldMover, arcFxID, FX_PATTACH_ABSORIGIN_FOLLOW, ATTACHMENTID_INVALID )
	                                                                                  
	EffectSetControlPointVector( arcFxHandle, 2, NC_COLOR_FRIENDLY )


	                                                    
	int leapFxID           = GetParticleSystemIndex( ARMORED_LEAP_PLACEMENT_ARROW_LEAP_FX_ALTZ )
	int leapFxHandle = StartParticleEffectOnEntity( arrowLeap, leapFxID, FX_PATTACH_ABSORIGIN_FOLLOW, ATTACHMENTID_INVALID )          
	EffectSetControlPointVector( leapFxHandle, 1, NC_COLOR_FRIENDLY )
	EffectSetControlPointVector( leapFxHandle, 3, NC_COLOR_BEHIND )

	int dashFxID           = GetParticleSystemIndex( ARMORED_LEAP_PLACEMENT_ARROW_DASH_FX )
	int dashFxHandle = StartParticleEffectOnEntity( arrowDash, dashFxID, FX_PATTACH_ABSORIGIN_FOLLOW, ATTACHMENTID_INVALID )          
	EffectSetControlPointVector( leapFxHandle, 1, NC_COLOR_FRIENDLY )
	EffectSetControlPointVector( leapFxHandle, 3, NC_COLOR_BEHIND )


	                      
	bool inDashRange 	= false
	bool isLeaping 		= false
	string failReason 	= ""
	entity prevTarget

	                                                                              


	                                          
	ArmoredLeapTargetInfo info

	while ( !isLeaping )
	{
		if ( !IsValid( player ) )
			return

		if ( player in file.armoredLeapTargetTable )
			info = file.armoredLeapTargetTable[ player ]
		else
			info = GetArmoredLeapTargetInfo( player )

		#if DEV
		if ( DoAdditionalAirPosChecks() )
		{
			if ( DEBUG_BETTER_AIR_POS )
			{
				                                                                                   
				GetBetterAirPos( player, info )
			}
		}
		#endif      

		int leapPhase = GetCurrentArmoredLeapPhase( player )

		if ( leapPhase != PLAYER_ARMORED_LEAP_PHASE_NONE && leapPhase != PLAYER_ARMORED_LEAP_PHASE_PREP )
		{
			isLeaping = true
			break
		}

		#if DEV
			if( DEBUG_ARMORED_LEAP_TARGETING_DRAW )
			{
				DebugDrawLine( player.GetOrigin(), info.airPos , <0, 200, 200>, true, 0.1 )
				DebugDrawLine( info.airPos, info.finalPos , <200, 200, 0>, true, 0.1 )
			}
		#endif

		switch( info.failCase )
		{
			case eFailCase.DEFAULT:
				failReason = ARMORED_LEAP_TARGET_FAIL_DEFAULT
				break

			case eFailCase.BLOCKED_LANDING:
				failReason = ARMORED_LEAP_TARGET_FAIL_BLOCKED_LAND
				break

			case eFailCase.BLOCKED_LEAP:
				failReason = ARMORED_LEAP_TARGET_FAIL_BLOCKED_LEAP
				break

			case eFailCase.BLOCKED_ALLY:
				failReason = ARMORED_LEAP_TARGET_FAIL_BLOCKED_ALLY
				break
		}

		                                               
		                                               
		vector adjPos = info.finalPos + <0,0,CASTLE_WALL_HIGH_WALL_PLANTED_Z_OFFSET>
		vector fwdPos = adjPos + FlattenVec(AnglesToForward(player.CameraAngles())) * CASTLE_WALL_SPAWN_OFFSET

		TraceResults fwdTrace = TraceLine( adjPos, fwdPos, GetPlayerArray_Alive(), TRACE_MASK_SOLID_BRUSHONLY, TRACE_COLLISION_GROUP_PLAYER_MOVEMENT )
		if ( fwdTrace.fraction < 1.0 )
			adjPos = fwdTrace.endPos
		else
			adjPos = (info.finalPos + <0,0,CASTLE_WALL_HIGH_WALL_PLANTED_Z_OFFSET> ) + FlattenVec(AnglesToForward(player.CameraAngles())) * CASTLE_WALL_SPAWN_OFFSET

		endPointMover.SetOrigin( info.finalPos )                                                                                                  
		endPointMover.SetAngles( VectorToAngles( FlattenVec( Normalize( info.finalPos - player.EyePosition() ) ) ) )
		allyMover.SetOrigin( info.finalPos + <0,0,100> )
		shieldMover.SetOrigin( adjPos )
		shieldMover.SetAngles( AnglesCompose( VectorToAngles( FlattenVec(info.finalPos - player.EyePosition()) ), <0,0,0> ) )

		endPointMover.Hide()
		allyMover.Hide()
		shieldMover.Hide()
		arrowLeap.Hide()
		arrowDash.Hide()
		                                                  

		entity allyTarget = info.allyTarget

		                                
		if ( info.success )
		{
			endPointMover.Show()
			shieldMover.Show()
			arrowLeap.Show()
			HidePlayerHint( ARMORED_LEAP_TARGET_FAIL_DEFAULT )
			HidePlayerHint( ARMORED_LEAP_TARGET_FAIL_BLOCKED_LAND )
			HidePlayerHint( ARMORED_LEAP_TARGET_FAIL_BLOCKED_LEAP )
			HidePlayerHint( ARMORED_LEAP_TARGET_FAIL_BLOCKED_ALLY )

			if( info.failCase == eFailCase.BLOCKED_ALLY )
				AddPlayerHint( 60.0, 0, $"", failReason )

			if ( !info.isOccluded )                                                                          
			{
				EffectSetControlPointVector( screenFxHandle, 1, NC_COLOR_FRIENDLY )                     
				EffectSetControlPointVector( screenFxHandle, 3, NC_COLOR_BEHIND )                   
				                                                                  
			}
			else
			{
				EffectSetControlPointVector( screenFxHandle, 1, NC_COLOR_FRIENDLY )                     
				EffectSetControlPointVector( screenFxHandle, 3, NC_COLOR_BEHIND )                   
				                                                                 
			}


			inDashRange = ArmoredLeap_IsInDashRange( player, info.finalPos, info.hitEnt )

			                  
			if( info.hasAlly )
			{
				if( allyTarget != prevTarget )
				{
					EmitSoundOnEntity( player, ARMORED_LEAP_ALLY_TARGETED_SFX_1P )
					prevTarget = allyTarget
				}
				allyMover.Show()
			}
			else                
			{
				bool isVisible 		= false
				bool allyIsValid	= IsValid( allyTarget )
				if( allyIsValid )                                                                                                                    
				{
					array<entity> ignoreArray = ArmoredLeapIgnoreArray()
					TraceResults losTrace = TraceLine( player.EyePosition(), allyTarget.EyePosition(), ignoreArray, TRACE_MASK_SOLID_BRUSHONLY, TRACE_COLLISION_GROUP_PLAYER_MOVEMENT )
					isVisible = losTrace.fraction == 1
				}

				if( allyIsValid && !ArmoredLeap_HasValidLandingRoom( player, allyTarget.GetOrigin(), info ) && ( player in file.allyLKP ) && isVisible )       
				{
					                                                                                                       
					allyMover.Show()
				}

				if( IsValid( prevTarget ) )
					prevTarget = null
			}

			                
			if ( !info.isOccluded && inDashRange )
			{
				shieldMover.Show()
				arrowLeap.Hide()
				arrowDash.Show()
			}

		}
		else             
		{
			                 
			inDashRange = false
			endPointMover.Show()
			endPointMover.SetOrigin( info.eyeHitPos )
			EffectSetControlPointVector( screenFxHandle, 1, <255, 0, 0> )
			EffectSetControlPointVector( screenFxHandle, 3, <255, 0, 0> )
			AddPlayerHint( 60.0, 0, $"", failReason )
		}

		                                                                                      
		foreach( ally in allyArray )
		{
			if( ally == player )
				continue

			if( IsValid(ally)  )                       
			{
				                                                             
				                                                                                                               
				int allyTeam = ally.GetTeam()
				if( team != allyTeam && ally != allyTarget )
				{
					if( ally in allyRui )
					{
						var oldRui = allyRui[ally]
						ruis.fastremovebyvalue( oldRui )                                                                                              
						RuiDestroyIfAlive( oldRui )
					}
					continue
				}

				if( !(ally in allyRui) )
				{
					allyRui[ally] <- CreateCockpitRui( $"ui/ally_hint_target.rpak", HUD_Z_BASE )
					ruis.append( allyRui[ally] )
				}

				entity wp
				if ( ally in file.bleedoutWP )
				{
					wp = file.bleedoutWP[ally]
				}

				if( allyRui[ally] != null )
					continue

				ItemFlavor character = LoadoutSlot_GetItemFlavor( ToEHI( ally ), Loadout_Character() )

				RuiSetBool( allyRui[ally], "isVisible", true )   
				RuiSetBool( allyRui[ally], "isTarget", ally == allyTarget)
				RuiSetBool( allyRui[ally], "isVisible", IsAlive( ally ) )
				RuiSetImage( allyRui[ally], "legendIcon", CharacterClass_GetGalleryPortrait( character ) )
				RuiSetFloat( allyRui[ally], "bleedoutEndTime", ally.GetPlayerNetTime( "bleedoutEndTime" ) )

				if( IsValid( wp ) )
					RuiTrackFloat3( allyRui[ally], "pos", wp, RUI_TRACK_ABSORIGIN_FOLLOW )
				else
				{
					int attachment = ally.LookupAttachment( "CHESTFOCUS" )
					RuiTrackFloat3( allyRui[ally], "pos", ally, RUI_TRACK_POINT_FOLLOW, attachment )
				}

				if( ally in file.allyIsInDanger )
				{
					if( file.allyIsInDanger[ally] )
						RuiSetBool( allyRui[ally], "isInDanger", true )
					else
						RuiSetBool( allyRui[ally], "isInDanger", false )
				}

				vector allyOrigin 		= ally.GetOrigin()
				float allyDistance 		= Distance( allyOrigin, player.GetOrigin() )
				bool isAllyOutOfRange 	= !( ArmoredLeap_HasValidLeapPos( player, ally, allyOrigin, null,  info ) && ( allyDistance < ARMORED_LEAP_MAX_ALLY_RANGE ) )

				RuiSetBool( allyRui[ally], "outOfRange", isAllyOutOfRange )
				                                                                              

			}
			else                                                           
			{
				              
				if( ally in allyRui )
				{
					RuiDestroyIfAlive( allyRui[ally] )

					if( ruis.contains( allyRui[ally] ) )
					{
						ruis.fastremovebyvalue( allyRui[ally] )
					}
					delete allyRui[ally]
				}
			}
		}
		allyArray = GetAllyPlayerArray( player )                                                

		WaitFrame()
	}

	                                                  
	foreach ( hudRui in ruis )
	{
		RuiDestroyIfAlive( hudRui )
	}

	HidePlayerHint( ARMORED_LEAP_TARGET_FAIL_DEFAULT)
	HidePlayerHint( ARMORED_LEAP_TARGET_FAIL_BLOCKED_LAND )
	HidePlayerHint( ARMORED_LEAP_TARGET_FAIL_BLOCKED_LEAP )
	HidePlayerHint( ARMORED_LEAP_TARGET_FAIL_BLOCKED_ALLY )

	arrowLeap.Hide()
	arrowDash.Hide()
	allyMover.Hide()
	shieldMover.Show()
	endPointMover.Show()

	if ( player in file.armoredLeapTargetTable )
		info = file.armoredLeapTargetTable[ player ]
	else
		info = GetArmoredLeapTargetInfo( player )

	                                                                                          
	EffectSetControlPointVector( screenFxHandle, 1, NC_COLOR_FRIENDLY )                     
	EffectSetControlPointVector( screenFxHandle, 3, NC_COLOR_BEHIND )                   

	vector endPoint = info.finalPos


	                                           
	while ( isLeaping )                                                              
	{
		if ( !IsValid( player ) )
			return

		int leapPhase = GetCurrentArmoredLeapPhase( player )

		if ( leapPhase == PLAYER_ARMORED_LEAP_PHASE_ARRIVAL || leapPhase == PLAYER_ARMORED_LEAP_PHASE_INTERRUPTED )
			return

		if( player in file.allyLKP )
			endPoint = file.allyLKP[player]

		vector flatCamDir = FlattenVec( AnglesToForward(player.CameraAngles() ) )
		vector shieldPosAR = (endPoint+ <0,0,28> ) + flatCamDir * CASTLE_WALL_SPAWN_OFFSET

		shieldMover.SetOrigin( shieldPosAR )
		shieldMover.SetAngles( AnglesCompose( VectorToAngles(flatCamDir), <0,0,0> ) )
		endPointMover.SetOrigin( endPoint )
		endPointMover.SetAngles( shieldMover.GetAngles() )

		WaitFrame()
	}
}
#endif         


#if CLIENT
void function UpdateAllyTargetRUI( var rui, entity allyTarget, entity allyMover )
{
	entity player = GetLocalClientPlayer()

	if( !IsValid( player ) )
		return

	if( !( IsValid( allyTarget ) ) )
		return

	if( !( IsValid( allyMover ) ) )
		return

	if( rui != null )
		return

	if( !allyTarget.IsPlayer() )
	{
		RuiTrackFloat3( rui, "pos", allyTarget, RUI_TRACK_ABSORIGIN_FOLLOW )
		RuiTrackFloat3( rui, "chestPos", allyTarget, RUI_TRACK_ABSORIGIN_FOLLOW )
		RuiTrackFloat3( rui, "targetPos", allyMover, RUI_TRACK_ABSORIGIN_FOLLOW )
		return
	}

	int armorTier = EquipmentSlot_GetEquipmentTier( allyTarget, "armor" )
	RuiSetInt( rui, "armorTier", armorTier )

	float shieldFrac = GetShieldHealthFrac( allyTarget )
	float healthFrac = GetHealthFrac( allyTarget )
	RuiSetFloat( rui, "shieldFrac", shieldFrac )
	RuiSetFloat( rui, "healthFrac", healthFrac )

	RuiTrackFloat( rui, "shieldFrac", allyTarget, RUI_TRACK_SHIELD_FRACTION )
	RuiTrackFloat( rui, "healthFrac", allyTarget, RUI_TRACK_HEALTH )
	RuiTrackFloat3( rui, "pos", allyTarget, RUI_TRACK_OVERHEAD_FOLLOW )

	int attachment = allyTarget.LookupAttachment( "CHESTFOCUS" )
	RuiTrackFloat3( rui, "chestPos", allyTarget, RUI_TRACK_POINT_FOLLOW, attachment )

	RuiTrackFloat3( rui, "targetPos", allyMover, RUI_TRACK_ABSORIGIN_FOLLOW )

	if( allyTarget in file.allyIsInDanger )
	{
		if( file.allyIsInDanger[allyTarget] )
			RuiSetBool( rui, "isInDanger", true )
		else
			RuiSetBool( rui, "isInDanger", false )
	}

}
#endif

#if CLIENT
void function ArmoredLeap_VisionMode_Thread( entity player )
{
	if( player != GetLocalClientPlayer() )
		return

	                                                                                                                 
	if ( file.visorRui != null )
	{
		Warning( FUNC_NAME() + " multiple inits on visor rui?")
		return
	}

	EndSignal( player, "VisorMode_DeActivate" )
	EndSignal( player, "OnDeath" )
	EndSignal( player, "OnDestroy" )
	EndSignal( player, "BleedOut_OnStartDying" )
	EndSignal( player, "ArmoredLeap_LeapComplete" )
	EndSignal( player, "StopArmoredLeapTargetPlacement" )


	                       
	Chroma_StartHuntMode()
	ColorCorrection_SetExclusive( file.colorCorrection, true )

	file.visorRui = CreateCockpitRui( $"ui/armored_leap_visor.rpak" )
	RuiSetBool( file.visorRui, "isVisible", true )


	OnThreadEnd(
		function() : ( player )
		{
			if( IsValid( player ) )
			{
				ColorCorrection_SetWeight( file.colorCorrection, 0.0 )                                         
				ColorCorrection_SetExclusive( file.colorCorrection, false )
				                        
				Chroma_EndHuntMode()

			}

			if( file.visorRui != null )
			{
				if( file.visorRui != null )
					RuiSetGameTime( file.visorRui, "endTime", Time() )

				RuiDestroyIfAlive ( file.visorRui )
				file.visorRui = null
			}
		}
	)

	const LERP_IN_TIME = 0.0125
	float startTime = Time()

	while ( true )
	{
		float weight = 5.0
		weight = GraphCapped( Time() - startTime, 0, LERP_IN_TIME, 0, weight )

		ColorCorrection_SetWeight( file.colorCorrection, weight )

		if( file.visorRui != null )
			RuiSetFloat3( file.visorRui, "cameraAngle", player.CameraAngles() )

		WaitFrame()
	}

	WaitForever()
}
#endif


                              
#if SERVER
                                                       
 
	                                                                     
 
#endif

bool function ArmoredLeap_TargetEntityShouldBeHighlighted( entity ent )
{
	#if CLIENT
		if( !IsValid(ent) )
			return false

		if ( (file.enemyThreatTargets.contains(ent) ) )
				return true

	#endif
	return false
}

#if CLIENT
void function ArmoredLeap_TrackEnemyAtLandingZone_Thread( entity player, vector endPoint )
{
	Assert ( IsNewThread(), "Must be threaded off." )

	if( player != GetLocalClientPlayer() )
		return

	EndSignal( player, "OnDeath" )
	EndSignal( player, "OnDestroy" )
	EndSignal( player, "BleedOut_OnStartDying" )
	EndSignal( player, "VisorMode_DeActivate" )
	EndSignal( player, "ArmoredLeap_LeapShutdown" )

	int team = player.GetTeam()
	array<int> arcFXArray

	array<entity> enemyThreatTargets = ArmoredLeap_GetEnemyThreatsArray( player, endPoint )

	                                                                 
	foreach( enemy in enemyThreatTargets )                                                    
	{
		if( !(IsValid(enemy)) )
			continue

		file.enemyThreatTargets.append(enemy)

		float dist = Distance2D( enemy.GetOrigin(), endPoint )
		if( dist < ARMORED_LEAP_MAX_TARGETING_POSITION_RANGE )
		{
			ManageHighlightEntity( enemy )
		}

	}

	OnThreadEnd(
		function() : ( player, enemyThreatTargets, arcFXArray )
		{
			foreach( arcFX in arcFXArray)
			{
				if( EffectDoesExist( arcFX ) )
				{
					EffectStop( arcFX, false, true )
				}
			}

			foreach( enemy in enemyThreatTargets )
			{
				if ( IsValid( enemy ) )
				{
					foreach ( threatEnemy in file.enemyThreatTargets )
					{
						if( threatEnemy != enemy )
							continue

						file.enemyThreatTargets.removebyvalue(threatEnemy)
						ManageHighlightEntity( threatEnemy )
					}
				}
			}

		}
	)

	while ( true )
	{
		if( !IsValid( player ) )
			return

		                                    
		foreach( enemy in enemyThreatTargets )
		{
			                               
			if ( !IsValid( enemy ) )
			{
				enemyThreatTargets.removebyvalue( enemy )

				if( file.enemyThreatTargets.contains( enemy ) )
					file.enemyThreatTargets.fastremovebyvalue( enemy )
				continue
			}

			if( !( file.enemyThreatTargets.contains( enemy ) ) )
				file.enemyThreatTargets.append( enemy )

			                               
			ManageHighlightEntity( enemy )

		}


		                      
		array<entity> newTargets = ArmoredLeap_GetEnemyThreatsArray( player, endPoint )

		foreach( target in newTargets )
		{
			if( !(enemyThreatTargets.contains(target)) )
				enemyThreatTargets.append(target)
		}

		WaitFrame()
	}

	WaitForever()
}
#endif          

#if CLIENT
array<entity> function ArmoredLeap_GetEnemyThreatsArray( entity player, vector endPoint )
{
	array<entity> enemyThreatsArray

	if( !IsValid(player) )
		return enemyThreatsArray

	const bool DO_THREAT_VISIBILITY_TRACE		= true
	const float THREAT_TRACE_OFFSET_Z 			= 80.0

	int team = player.GetTeam()
	array<entity> ignoreArray = ArmoredLeapIgnoreArray( null, true )

	array<entity> enemyPlayersArray = GetPlayerArrayOfEnemies_Alive( team )

	array<entity> holoEnts = GetPlayerDecoyArray()
	foreach ( ent in holoEnts )
	{
		if( !IsValid(ent) )
			continue
		if( team == ent.GetTeam() )
			continue
		enemyPlayersArray.append(ent)
	}

	foreach ( enemy in enemyPlayersArray)
	{
		if( !IsValid( enemy ) )
			continue

		if( enemy == player )                                  
			continue

		bool phaseShifted = enemy.IsPlayer() ? enemy.IsPhaseShiftedOrPending() : false
		if ( phaseShifted )
			continue

		float dist = Distance2D( enemy.GetOrigin(), endPoint )
		if( dist > ARMORED_LEAP_MAX_TARGETING_DIRECTION_RANGE )
			continue

		                 
		                       
		if( DO_THREAT_VISIBILITY_TRACE )
		{
			TraceResults playerTrace = TraceLine( enemy.GetOrigin() + < 0.0, 0.0, THREAT_TRACE_OFFSET_Z >, player.EyePosition(), ignoreArray, TRACE_MASK_SOLID_BRUSHONLY, TRACE_COLLISION_GROUP_PLAYER_MOVEMENT )
			TraceResults shieldTrace = TraceLine( enemy.GetOrigin() + < 0.0, 0.0, THREAT_TRACE_OFFSET_Z >, endPoint + < 0.0, 0.0, THREAT_TRACE_OFFSET_Z >, ignoreArray, TRACE_MASK_SOLID_BRUSHONLY, TRACE_COLLISION_GROUP_PLAYER_MOVEMENT )

			if( playerTrace.fraction < 1 && shieldTrace.fraction < 1 )
				continue
		}

		                                       
		if( enemyThreatsArray.len() >= ARMORED_LEAP_TARGETING_MAX_TARGETS )
		{
			entity farthestTarget = enemy
			float farthestDist = dist
			foreach( target in enemyThreatsArray )
			{
				float targetDist = Distance2D( target.GetOrigin(), endPoint )
				if( farthestDist < targetDist )
				{
					farthestTarget = target
					farthestDist = targetDist
				}
			}

			if( farthestTarget != enemy )
			{
				enemyThreatsArray.fastremovebyvalue(farthestTarget)
				enemyThreatsArray.append(enemy)
			}
		}
		else
			enemyThreatsArray.append(enemy)
	}

	return enemyThreatsArray
}
#endif         

#if CLIENT
void function ServerToClient_VisorMode_DeActivate( entity player )
{
	if ( player != GetLocalClientPlayer() )
		return
	Signal( player, "VisorMode_DeActivate" )
}
#endif

#if CLIENT
void function ServerToClient_SetClient_AllyInDanger( entity player, entity ally, bool inDanger )
{
	if( player != GetLocalClientPlayer() )
		return

	file.allyIsInDanger[ally] <- inDanger
}
#endif         








                                                                                                    
                                                                                                    
                                                                                                    

#if SERVER
                                                 
 
	                           
	                                  

	                     
	                                 

	                           
	                                                                                                                         

 
#endif         


#if SERVER
                                                                                                                                  
 
	                          

	                                              
	                                    
	 
		                                         
			        

		                     
		 
			                                    
			        
		 

		                                                       
		                                                         
		                                              
			        

		                                                                              

		                                                                                                            

		                                 
		                                        
		                                                                      
		                                     


		                                               
		 
			                                      
			        
		 
		    
		 
			                            
			                                      
		 

		                                                   

		                                                                                                               
		                                         
		                                                                                                            

		                                         
			                            

		                                         
		 
			                                       
		 

		                                  
		                                             
		 
			                                     
			                                     
		 

	 

	              
	                                                                

	                 
	                                                           
	                                                                   

 
#endif         

                                                 
                                                
                                                

array<entity> function ArmoredLeapIgnoreArray( entity castle = null, bool ignoreAllCastles = false, bool ignorePropDoors = false )
{
	array<entity> ignoreArray = GetPlayerArray_Alive()

	                               
	if( ignoreAllCastles )
	{
		array<entity> shieldAnchor = GetEntArrayByScriptName( ARMORED_LEAP_SHIELD_ANCHOR_SCRIPTNAME )                
		foreach ( shieldWall in shieldAnchor )
		{
			if( !IsValid( shieldWall ) )
				continue

			ignoreArray.append( shieldWall )
		}
	}
	else
	{
		#if SERVER
			                                   
			                                   
			 
				                                                  
				 
					                       
						        

					                             
				 
			 
		#endif
	}

	                                
	array<entity> mobileShields = GetEntArrayByScriptName( MOBILE_SHIELD_SCRIPTNAME )                      
	foreach ( shieldWall in mobileShields )
	{
		if( !IsValid(shieldWall) )
			continue
		ignoreArray.append( shieldWall )
	}

	array<entity> thrownShields = GetEntArrayByScriptName( SHIELD_THROW_SCRIPTNAME )                            
	foreach ( shield in thrownShields )
	{
		if( !IsValid(shield) )
			continue
		ignoreArray.append( shield )
	}

	array<entity> bubbleShields = GetEntArrayByScriptName( BUBBLE_SHIELD_SCRIPTNAME )                
	foreach ( bubble in bubbleShields )
	{
		if( !IsValid(bubble) )
			continue
		ignoreArray.append( bubble )
	}

	array<entity> holoEnts = GetPlayerDecoyArray()
	ignoreArray.extend( holoEnts )

	if( ignorePropDoors )
		ignoreArray.extend( GetAllPropDoors() )

	return ignoreArray
}








                                           
const bool DO_LEDGE_TRACE = true
const bool DO_LOWER_ANGLE_TRACE = true
const float DOWN_TRACE_DISTANCE = 1500.0
const float TUNNEL_STEP_DIST = 16.0
const float MINIMUM_TUNNEL_STEP_DIST = 4.0

ArmoredLeapTargetInfo function GetArmoredLeapTargetInfo( entity ent )
{
	ArmoredLeapTargetInfo info
	info.finalPos   = ent.GetOrigin()
	info.success    = false
	info.isOccluded = false
	info.hasAlly 	= false
	info.failCase	= eFailCase.DEFAULT

	vector eyePos = ent.EyePosition()
	vector eyeDir = ent.GetViewVector()
	eyeDir          = Normalize( eyeDir )
	info.eyeHitNorm = -eyeDir

	float rangeNormal = file.maxDist
	float rangeSqr    = rangeNormal * rangeNormal

	                                                                          
	float pitchClamped   = clamp( ent.EyeAngles().x, -70.0, 70.0 )
	float rangeEffective = rangeNormal / deg_cos( pitchClamped )

	bool foundValidEnd = false






	array<entity> ignoreArray = ArmoredLeapIgnoreArray()

	                                                                                
	TraceResults initialTrace = TraceLine( eyePos, eyePos + (eyeDir * rangeEffective), ignoreArray, TRACE_MASK_PLAYERSOLID, TRACE_COLLISION_GROUP_PLAYER_MOVEMENT )
	info.eyeHitPos = initialTrace.endPos

	                                                                          
	vector lowHitPos
	vector lowDir = AnglesToForward(AnglesCompose( VectorToAngles( eyeDir ), <ARMORED_LEAP_ABOVE_LEDGE_DEGREE_CHECK_OFFSET,0,0> ) )
	lowDir = Normalize( lowDir )

	entity hitEnt = initialTrace.hitEnt
	if( IsValid( hitEnt ) )
	{
		info.hitEnt = hitEnt
		string scriptName = hitEnt.GetScriptName()
		if( scriptName == "octane_jump_pad" )                                        
			return info

		if( EntIsHoverVehicle(hitEnt) )
			return info
	}

	if( !ent.IsOnGround() )
	{
		                          
		const float ARMORED_LEAP_MIN_HOVER_AIR_HEIGHT = 100                                                                                    
		TraceResults minAirTrace = TraceLine( ent.GetOrigin(), ent.GetOrigin() + <0,0,-ARMORED_LEAP_MIN_HOVER_AIR_HEIGHT>, ignoreArray, TRACE_MASK_PLAYERSOLID, TRACE_COLLISION_GROUP_PLAYER_MOVEMENT )
		if( minAirTrace.fraction < 1 )
			return info
	}

	if( !ArmoredLeap_HasValidHullRoom( ent, ent.GetOrigin() ) )
	{
		info.failCase = eFailCase.BLOCKED_LEAP
		return info
	}

	#if DEV
		if( DEBUG_ARMORED_LEAP_TARGETING_DRAW )
		{
			                	      
			              		       
			            		                                                       
			            		                                                        
			DebugDrawSphere( initialTrace.endPos, 5.0, <0, 150, 150>, false, 0.1 )                       
		}
	#endif

	vector adjustedEndPos = initialTrace.endPos


	                
	                                                                                                                                               
	entity targetAlly = GetAllyTargetInRange( ent )
	ArmoredLeap_SetAllyTargetAndLKP( ent, info )

	if( ent in file.allyTarget )
	{
		if( IsValid(file.allyTarget[ent]) )
		{
			targetAlly = file.allyTarget[ent]
		}
	}
	if( ent in file.allyLKP )
	{
		adjustedEndPos = file.allyLKP[ent]
		foundValidEnd = true
	}

	if( !foundValidEnd )
	{

		bool didLowerTraceHit = false
		if ( initialTrace.fraction < 1.0 )
		{
			if ( DotProduct( initialTrace.surfaceNormal, <0, 0, 1> ) > 0.85 )
			{
				hitEnt = initialTrace.hitEnt
				                      
				foundValidEnd = ArmoredLeap_HasValidLandingRoom( ent, adjustedEndPos, info )
				if( !foundValidEnd )
				{
					                                                                                          
					                                                                                                                                

					const float ARMORED_LEAP_LIP_TEST_STEP = 16
					float backStep = ARMORED_LEAP_LIP_TEST_STEP               


					for( int i=0; i < 4; i++ )                                                                                                                  
					{
						vector lipTestPos = adjustedEndPos - eyeDir * backStep
						TraceResults lipTrace = TraceLine( lipTestPos, lipTestPos + <0, 0, -100>, ignoreArray, TRACE_MASK_PLAYERSOLID, TRACE_COLLISION_GROUP_PLAYER_MOVEMENT )

						if ( lipTrace.fraction < 1.0 )
						{
							foundValidEnd = ArmoredLeap_HasValidLandingRoom( ent, lipTrace.endPos, info )
							if( foundValidEnd )
							{
								hitEnt = lipTrace.hitEnt
								adjustedEndPos = lipTrace.endPos
								break
							}
							else info.failCase = eFailCase.BLOCKED_LANDING

						}
						backStep += ARMORED_LEAP_LIP_TEST_STEP
					}

				}

				                                                                        
				vector flatEyeDir 	= FlattenVec(eyeDir)
				vector raisedEndPos	= adjustedEndPos + <0,0,ARMORED_LEAP_OFFSET_TEST_HEIGHT>
				vector wallTestPos 	= raisedEndPos + flatEyeDir * ARMORED_LEAP_MIN_TARGET_DIST_TO_WALL
				TraceResults wallAheadTrace = TraceLine( raisedEndPos, wallTestPos, ignoreArray, TRACE_MASK_PLAYERSOLID, TRACE_COLLISION_GROUP_PLAYER_MOVEMENT )

				if ( wallAheadTrace.fraction < 1.0 )                        
				{
					if( DotProduct( wallAheadTrace.surfaceNormal, <0, 0, 1> ) < 0.85 )                        
					{
						float distDiff = Distance(wallTestPos, wallAheadTrace.endPos)
						raisedEndPos = raisedEndPos - flatEyeDir *distDiff
						TraceResults pushbackTrace = TraceLine( raisedEndPos, raisedEndPos + <0,0,-100>, ignoreArray, TRACE_MASK_PLAYERSOLID, TRACE_COLLISION_GROUP_PLAYER_MOVEMENT )
						if ( pushbackTrace.fraction < 1.0 )
						{
							foundValidEnd = ArmoredLeap_HasValidLandingRoom( ent, pushbackTrace.endPos, info )
							if( foundValidEnd )
							{
								adjustedEndPos = pushbackTrace.endPos
								hitEnt = pushbackTrace.hitEnt
							}
							else info.failCase = eFailCase.BLOCKED_LANDING
						}
					}
				}
			}
			else
			{
				adjustedEndPos -= eyeDir * ARMORED_LEAP_MIN_TARGET_DIST_TO_WALL
			}
		}
		else
		{
			                                                                                                                                       
			TraceResults lowTrace = TraceLine( eyePos, eyePos + (lowDir * rangeEffective), ignoreArray, TRACE_MASK_PLAYERSOLID, TRACE_COLLISION_GROUP_PLAYER_MOVEMENT )
			if( lowTrace.fraction < 1.0 )
			{
				if ( DotProduct( Normalize(lowTrace.surfaceNormal), <0, 0, 1> ) < 0.75 )                                                                                                  
				{
					lowHitPos = lowTrace.endPos
					didLowerTraceHit = true
				}
			}
		}


		if ( DO_LEDGE_TRACE && !foundValidEnd && (initialTrace.fraction < 1.0 || didLowerTraceHit) )
		{
			vector lookPos          = didLowerTraceHit ? lowHitPos : initialTrace.endPos
			vector lookDir			= didLowerTraceHit ? lowDir : eyeDir
			vector ledgeTraceStart  = lookPos + <0, 0, 200.0> + Normalize( <lookDir.x, lookDir.y, 0> ) * ARMORED_LEAP_LEDGE_INSET_AMOUNT
			TraceResults ledgeTrace = TraceHull( ledgeTraceStart, ledgeTraceStart + <0, 0, -200>, ent.GetPlayerMins(), ent.GetPlayerMaxs(), ignoreArray, TRACE_MASK_PLAYERSOLID, TRACE_COLLISION_GROUP_PLAYER_MOVEMENT )


			#if DEV
				if( DEBUG_ARMORED_LEAP_TARGETING_DRAW )
				{
					DebugDrawSphere( ledgeTraceStart, 8.0, COLOR_YELLOW, true, 0.1 )                      
					DebugDrawSphere( ledgeTrace.endPos, 15.0, <255, 175, 0>, true, 0.1 )                    
					DebugDrawCircle( ledgeTrace.endPos, VectorToAngles(ledgeTrace.surfaceNormal), 64, <255, 175, 175>, true, 0.1, 3 )
				}
			#endif

			bool isHigher = ( ledgeTrace.endPos.z + 64.0 ) > lookPos.z
			float frac = ledgeTrace.fraction
			bool solid = ledgeTrace.startSolid
			if ( ledgeTrace.fraction < 1.0 && isHigher && !ledgeTrace.startSolid )
			{
				hitEnt = ledgeTrace.hitEnt
				bool ledgeRoomAirCheck = ArmoredLeap_HasValidLeapPos( ent, null, ledgeTrace.endPos, hitEnt, info )                                                                                              
				if ( ledgeRoomAirCheck == true )
				{
					adjustedEndPos = ledgeTrace.endPos
					foundValidEnd  = true
				}
			}
		}

		vector airPos = adjustedEndPos

		if ( !foundValidEnd )
		{
			TraceResults downTrace = TraceLine( airPos, airPos - <0.0, 0.0, DOWN_TRACE_DISTANCE>, ignoreArray, TRACE_MASK_PLAYERSOLID, TRACE_COLLISION_GROUP_PLAYER_MOVEMENT )

			if ( downTrace.fraction < 1.0 )
			{
				hitEnt = downTrace.hitEnt
				if (DotProduct( eyeDir, Normalize( downTrace.endPos - eyePos ) ) > 0.88 )
				{
					adjustedEndPos = downTrace.endPos
					foundValidEnd  = true
				}
			}

			#if DEV
				if( DEBUG_ARMORED_LEAP_TARGETING_DRAW )
				{
					DebugDrawSphere( downTrace.endPos, 5.0, COLOR_GREEN, false, 0.1 )                       
				}
			#endif
		}

		if ( !foundValidEnd )
		{
			                                                                     
			airPos = adjustedEndPos

			lowDir = AnglesToForward(AnglesCompose( VectorToAngles( eyeDir ), <ARMORED_LEAP_ABOVE_LEDGE_DEGREE_CHECK_OFFSET,0,0> ) )
			lowDir = Normalize( lowDir )

			vector adjustedAirPos = eyePos + lowDir * rangeEffective
			TraceResults lowAirTrace = TraceLine( eyePos, adjustedAirPos, ignoreArray, TRACE_MASK_PLAYERSOLID, TRACE_COLLISION_GROUP_PLAYER_MOVEMENT )
			if ( lowAirTrace.fraction < 1.0 )
			{
				                                                                         
				vector lowAirDir = Normalize( lowAirTrace.endPos - eyePos )
				vector ledgeInset = lowAirTrace.endPos + lowAirDir * ARMORED_LEAP_LEDGE_INSET_AMOUNT
				ledgeInset = < ledgeInset.x, ledgeInset.y, lowAirTrace.endPos.z >                 

				vector intersect = ledgeInset + <0,0,ARMORED_LEAP_ABOVE_LEDGE_DOWN_TRACE_OFFSET>

				TraceResults dropAirTrace = TraceLine( intersect, ledgeInset + <0,0,ARMORED_LEAP_LEDGE_INSET_DOWN_TRACE> , ignoreArray, TRACE_MASK_PLAYERSOLID, TRACE_COLLISION_GROUP_PLAYER_MOVEMENT )
				hitEnt = dropAirTrace.hitEnt
				if( dropAirTrace.fraction < 1 && ArmoredLeap_HasValidLeapPos( ent, null, dropAirTrace.endPos, hitEnt, info ))
				{
					                                                                           
					TraceResults sightTrace = TraceLine( eyePos, dropAirTrace.endPos + <0,0,8> , ignoreArray, TRACE_MASK_PLAYERSOLID, TRACE_COLLISION_GROUP_PLAYER_MOVEMENT )
					if( sightTrace.fraction < 1.0 )
					{
						adjustedEndPos = dropAirTrace.endPos
						foundValidEnd = true
					}
				}
				#if DEV
					if( DEBUG_ARMORED_LEAP_TARGETING_DRAW )
					{
						DebugDrawSphere( intersect, 8.0, <255, 0, 250>, false, 0.1 )                    
						DebugDrawSphere( dropAirTrace.endPos, 15.0, <255, 0, 100>, true, 0.1 )                     
					}
				#endif
			}

			#if DEV
				if( DEBUG_ARMORED_LEAP_TARGETING_DRAW )
				{
					DebugDrawSphere( lowAirTrace.endPos, 5.0, <100, 0, 50>, true, 0.1 )                  
				}
			#endif

			if ( !foundValidEnd )
				return info

		}

		foundValidEnd  = ArmoredLeap_HasValidLeapPos( ent, null, adjustedEndPos, hitEnt, info )                                                       

		if ( !foundValidEnd )
			return info

		if( IsValid( targetAlly ) )
			info.failCase = eFailCase.BLOCKED_ALLY
	}


	vector portalPos = ent.GetOrigin()
	vector portalDir = Normalize( adjustedEndPos - portalPos )
	float distCheck  = Distance( portalPos, adjustedEndPos )

	while ( info.pathDistance < distCheck )
	{
		float step = min( TUNNEL_STEP_DIST, distCheck - info.pathDistance )

		if ( step < MINIMUM_TUNNEL_STEP_DIST )
			break

		vector newPos = portalPos + (portalDir * step)


		info.pathDistance += step
		info.posList.append( newPos )
		info.finalPos = (newPos)
		info.hitEnt = hitEnt
		portalPos     = newPos
	}

	info.success    = info.pathDistance > ARMORED_LEAP_DISTANCE_MIN && foundValidEnd
	info.isOccluded = !PlayerCanSeePos( ent, info.finalPos, true, 70 )

	return info
}

                                                                                                 
ArmoredLeapTargetInfo function GetBetterAirPos( entity player, ArmoredLeapTargetInfo info )
{
	if ( IsValid( player ) && info.success )
	{
		TraceResults groundTraceResult = TraceHull( info.finalPos + <0, 0, 10>, info.finalPos - <0, 0, 2000>, player.GetPlayerMins(), player.GetPlayerMaxs(), player, TRACE_MASK_PLAYERSOLID, TRACE_COLLISION_GROUP_PLAYER_MOVEMENT )
		info.finalPos = groundTraceResult.endPos
		array<entity> ignoreArray = ArmoredLeapIgnoreArray()
		vector playerPos          = player.GetOrigin()
		vector groundOffset	  = player.IsOnGround() ? <0, 0, 48> : <0, 0, 0>                                                                                                                    
		playerPos += groundOffset
		float distCheck           = Distance( player.GetOrigin(), info.finalPos )
		                                               
		                                                                                                                                                                                                                                                           
		float airHeight           = info.airPos == ZERO_VECTOR ? ARMORED_LEAP_MAX_AIR_HEIGHT : info.airPos.z - info.finalPos.z
		TraceResults traceUp      = TraceHull( info.finalPos, info.finalPos + <0, 0, airHeight>, player.GetPlayerMins(), player.GetPlayerMaxs(), ignoreArray, TRACE_MASK_PLAYERSOLID, TRACE_COLLISION_GROUP_PLAYER_MOVEMENT )

		#if DEV
		if ( DEBUG_BETTER_AIR_POS )
		{
			DebugDrawText( info.eyeHitPos, "info.eyeHitPos", true, 0.1 )
			DebugDrawText( info.finalPos, "info.finalPos", true, 0.1 )
			DebugDrawText( traceUp.endPos, "traceUp.endPos", true, 0.1 )
		}
		#endif      

		                                                                                
		const int findPosIterations = 5
		float airDis = Distance( info.finalPos, traceUp.endPos )
		float interationDist = airDis / findPosIterations
		bool foundGoodAirPos = false
		vector goodAirPos = ZERO_VECTOR

		for ( int i = 0; i < findPosIterations; i++ )
		{
			                                                           
			if ( foundGoodAirPos )
				break

			float zOffSet = i * interationDist

			vector leapDir = Normalize( ( traceUp.endPos - <0, 0, zOffSet> ) - playerPos )
			vector traceTarget = traceUp.endPos - <0, 0, zOffSet>

			TraceResults iterationTrace = TraceHull( playerPos, traceTarget, player.GetPlayerMins(), player.GetPlayerMaxs(), ignoreArray, TRACE_MASK_PLAYERSOLID, TRACE_COLLISION_GROUP_PLAYER_MOVEMENT )

			                                                                                                    
			if ( iterationTrace.fraction >= 0.99 )
			{
				#if DEV
				if ( DEBUG_BETTER_AIR_POS )
				{
					DebugDrawMark( iterationTrace.endPos, 10, COLOR_GREEN, true, 0.1 )
					DebugDrawLine( playerPos, traceTarget, COLOR_CYAN, true, 0.1 )
					DebugDrawText( iterationTrace.endPos, "fraction: " + iterationTrace.fraction, true, 0.1 )
				}
				#endif      

				if ( !foundGoodAirPos )
				{
					                                                                                                              
					FindOffsetPosStruct offsetData = GetBetterAirPos_FindOffsetPos( player, ignoreArray, leapDir, traceTarget, info.finalPos )

					if ( offsetData.success )
					{
						foundGoodAirPos = true
						goodAirPos      = offsetData.position
					}
				}
			}
			else
			{
				#if DEV
				if ( DEBUG_BETTER_AIR_POS )
				{
					DebugDrawLine( playerPos, traceTarget, COLOR_RED, true, 0.1 )
					DebugDrawMark( iterationTrace.endPos, 10, COLOR_RED, true, 0.1 )
					DebugDrawText( iterationTrace.endPos, "fraction: " + iterationTrace.fraction, true, 0.1 )
				}
				#endif
			}
		}

		                                                                                       
		if ( !foundGoodAirPos )
		{
			TraceResults traceUpPlayer = TraceHull( player.GetOrigin(), player.GetOrigin() + <0, 0, airHeight>, player.GetPlayerMins(), player.GetPlayerMaxs(), ignoreArray, TRACE_MASK_PLAYERSOLID, TRACE_COLLISION_GROUP_PLAYER_MOVEMENT )
			traceUp = TraceLine( info.finalPos, info.finalPos + <0, 0, airHeight>, ignoreArray, TRACE_MASK_PLAYERSOLID, TRACE_COLLISION_GROUP_PLAYER_MOVEMENT )
			vector abovePlayer = traceUpPlayer.endPos
			vector aboveDest = traceUp.endPos
			vector walkBackDir = Normalize( aboveDest - abovePlayer )
			float walkBackDistTotal = Distance( aboveDest, abovePlayer )

			#if DEV
			if ( DEBUG_BETTER_AIR_POS )
			{
				DebugDrawMark( abovePlayer, 10, COLOR_YELLOW, true, 0.1 )
				DebugDrawMark( aboveDest, 10, COLOR_MAGENTA, true, 0.1 )
			}
			#endif

			const int walkBackIterations = 8
			float walkBackIterationDist = walkBackDistTotal / walkBackIterations
			bool validDirectlyOverEnd = false
			bool validDirectlyOverPlayer = false
			vector validDirectlyOverEndPos = ZERO_VECTOR
			vector validDirectlyOverPlayerPos = ZERO_VECTOR

			for ( int i = walkBackIterations; i >= 0; i-- )
			{
				float iterationDist = i * walkBackIterationDist
				vector walkBackIterationPos = abovePlayer + ( walkBackDir * iterationDist )

				TraceResults traceToWalkbackPos

				                                                                                  
				if ( i == walkBackIterations )
				{
					traceToWalkbackPos = TraceLine( player.GetOrigin(), walkBackIterationPos, ignoreArray, TRACE_MASK_PLAYERSOLID, TRACE_COLLISION_GROUP_PLAYER_MOVEMENT )
				}
				else
				{
					traceToWalkbackPos = TraceHull( player.GetOrigin(), walkBackIterationPos, player.GetPlayerMins(), player.GetPlayerMaxs(), ignoreArray, TRACE_MASK_PLAYERSOLID, TRACE_COLLISION_GROUP_PLAYER_MOVEMENT )
				}

				if ( traceToWalkbackPos.fraction >= 0.99 )
				{
					#if DEV
						if ( DEBUG_BETTER_AIR_POS )
						{
							DebugDrawLine( player.GetOrigin(), traceToWalkbackPos.endPos, COLOR_GREEN, true, 0.1 )
							DebugDrawText( traceToWalkbackPos.endPos, "fraction: " + traceToWalkbackPos.fraction, true, 0.1 )
						}
					#endif

					                   
					TraceResults traceFinalPos = TraceHull( walkBackIterationPos, info.finalPos, player.GetPlayerMins(), player.GetPlayerMaxs(), ignoreArray, TRACE_MASK_PLAYERSOLID, TRACE_COLLISION_GROUP_PLAYER_MOVEMENT )

					if ( traceFinalPos.fraction >= 0.99 )
					{
						#if DEV
							if ( DEBUG_BETTER_AIR_POS )
							{
								DebugDrawLine( walkBackIterationPos, traceFinalPos.endPos, COLOR_GREEN, true, 0.1 )
								                                                                                           
							}
						#endif

						                                                                                                    
						if ( i == walkBackIterations )
						{
							FindOffsetPosStruct offsetData = GetBetterAirPos_FindOffsetPos( player, ignoreArray, walkBackDir, walkBackIterationPos, info.finalPos )

							if ( offsetData.success )
							{
								foundGoodAirPos = true
								goodAirPos      = offsetData.position
								break
							}
							else
							{
								foundGoodAirPos = true
								goodAirPos      = walkBackIterationPos
								break
							}
						}
						else
						{
							foundGoodAirPos = true
							goodAirPos      = walkBackIterationPos
							break
						}
					}
					else
					{
						#if DEV
							if ( DEBUG_BETTER_AIR_POS )
							{
								DebugDrawLine( walkBackIterationPos, info.finalPos, COLOR_RED, true, 0.1 )
								DebugDrawMark( traceFinalPos.endPos, 25, COLOR_RED, true, 0.1 )
								DebugDrawText( traceFinalPos.endPos, "fraction: " + traceFinalPos.fraction, true, 0.1 )
							}
						#endif
					}
				}
				else
				{
					#if DEV
						if ( DEBUG_BETTER_AIR_POS )
						{
							DebugDrawLine( player.GetOrigin(), walkBackIterationPos, COLOR_RED, true, 0.1 )
							DebugDrawMark( traceToWalkbackPos.endPos, 25, COLOR_RED, true, 0.1 )
							DebugDrawText( traceToWalkbackPos.endPos, "fraction: " + traceToWalkbackPos.fraction, true, 0.1 )
						}
					#endif
				}
			}
		}

		if ( foundGoodAirPos )
		{
			info.airPos = goodAirPos

			#if DEV
			if ( DEBUG_BETTER_AIR_POS )
			{
				float drawTime = 0.1
				#if SERVER
				              
				#endif

				DebugDrawMark( info.finalPos, 25, COLOR_YELLOW, true, drawTime )
				DebugDrawMark( goodAirPos, 25, COLOR_CYAN, true, drawTime )
				DebugDrawText( player.GetWorldSpaceCenter(), "foundGoodAirPos found!", true, 0.1 )
			}
			#endif      
		}
		else
		{
			#if DEV
			if ( DEBUG_BETTER_AIR_POS )
			{
				DebugDrawText( player.GetWorldSpaceCenter(), "foundGoodAirPos NOT found!", true, 0.1 )
			}
			#endif      
		}
	}

	return info
}

FindOffsetPosStruct function GetBetterAirPos_FindOffsetPos( entity player, array< entity > ignoreArray, vector leapDir, vector airPos, vector endPos )
{
	FindOffsetPosStruct results
	results.success = false
	results.position = ZERO_VECTOR
	                                                                           
	                                                                                                                                                                         
	const int endPosInterations = 3
	float iterationToEndDist = ARMORED_LEAP_AIR_POS_OFFSET / endPosInterations

	for ( int x = endPosInterations; x >= 0; x-- )
	{
		float offset = x * iterationToEndDist
		vector offsetTraceTarget = airPos - ( leapDir * offset )

		TraceResults destinationTrace = TraceHull( offsetTraceTarget, endPos, player.GetPlayerMins(), player.GetPlayerMaxs(), ignoreArray, TRACE_MASK_PLAYERSOLID, TRACE_COLLISION_GROUP_PLAYER_MOVEMENT )

		if ( destinationTrace.fraction >= 0.99 )
		{
			#if DEV
			if ( DEBUG_BETTER_AIR_POS )
			{
				DebugDrawMark( destinationTrace.endPos, 10, COLOR_GREEN, true, 0.1 )
				DebugDrawLine( offsetTraceTarget, destinationTrace.endPos, COLOR_GREEN, true, 0.1 )
				DebugDrawText( offsetTraceTarget, "goodAirPos! fraction: " + destinationTrace.fraction, true, 0.1 )
			}
			#endif      

			results.success = true
			results.position = offsetTraceTarget
			return results
		}
		else
		{
			#if DEV
			if ( DEBUG_BETTER_AIR_POS )
			{
				DebugDrawMark( destinationTrace.endPos, 10, COLOR_RED, true, 0.1 )
				DebugDrawLine( offsetTraceTarget, destinationTrace.endPos, COLOR_RED, true, 0.1 )
				DebugDrawText( offsetTraceTarget, "fraction: " + destinationTrace.fraction, true, 0.1 )
			}
			#endif      
		}
	}

	return results
}

vector function ArmoredLeap_GetBestAllyLandingPos( entity ent, vector endPos, vector eyeDir, ArmoredLeapTargetInfo info )
{
	vector bestPos = endPos
	array<entity> ignoreArray = ArmoredLeapIgnoreArray()
	if( !ArmoredLeap_HasValidLandingRoom( ent, endPos, info ) )
	{
		vector traceOrigin                  = ent.EyePosition()               
		array<vector> ridgeTraceVectorArray                                                                                                  
		                                                                          
		int maxNumChecks = 6
		float angleOffset = 360 / maxNumChecks.tofloat()
		float angle = 0

		eyeDir = FlattenVec(Normalize( endPos - ent.EyePosition() ))
		ridgeTraceVectorArray.append( eyeDir )

		for ( int i=1;i<maxNumChecks;i++ )
		{
			eyeDir = -(eyeDir)                                                                

			vector offsetVec = RotateVector( eyeDir, <0,angle,0> )
			ridgeTraceVectorArray.append( offsetVec )
			if( i == 1 )
				angle = angle + angleOffset
			if( i == 5 )
				angle = angle + angleOffset
			if( IsOdd( i ) )
				angle = angle * -1
		}

		foreach ( traceVector in ridgeTraceVectorArray )
		{
			vector ridgeOrigin      = endPos + <0, 0, ARMORED_LEAP_OFFSET_TEST_HEIGHT> + traceVector * 64
			vector ridgeTraceOrigin = endPos + <0, 0, -ARMORED_LEAP_OFFSET_TEST_HEIGHT> + traceVector * 64

			TraceResults ridgeTrace = TraceLine( ridgeOrigin, ridgeTraceOrigin, ignoreArray, (TRACE_MASK_PLAYERSOLID | TRACE_MASK_TITANSOLID | CONTENTS_NOAIRDROP), TRACE_COLLISION_GROUP_PLAYER_MOVEMENT, ent )
			float fraction          = ridgeTrace.fraction
			if ( fraction == 1 )
			{
				                                                               
				continue
			}

			bestPos = ridgeTrace.endPos
			if( ArmoredLeap_HasValidLandingRoom( ent, bestPos, info )  )
			{
				                                                                 
				return bestPos
			}

			                                                                  
		}
	}

	return endPos
}

bool function ArmoredLeap_HasValidLandingRoom( entity ent, vector endPos, ArmoredLeapTargetInfo info )
{
	bool isTriangle = true

	array<entity> ignoreArray = ArmoredLeapIgnoreArray()

	if( !ArmoredLeap_HasValidHullRoom(ent, endPos+ ARMORED_LEAP_ENDPOINT_BUFFER, true) )
	{
		info.failCase = eFailCase.BLOCKED_LANDING
		return false
	}
	if( isTriangle )
	{
		                                                                                                                                 
		                                                                                                     
		vector traceOrigin                  = endPos               
		array<vector> ridgeTraceVectorArray = [ <1, 0, 0>, <-0.5, 0.86, 0>, <-0.5, -0.86, 0> ]                                                   
		foreach ( traceVector in ridgeTraceVectorArray )
		{
			vector ridgeOrigin      = endPos + <0, 0, ARMORED_LEAP_OFFSET_TEST_HEIGHT> + traceVector * 64                                
			vector ridgeTraceOrigin = endPos + <0, 0, -ARMORED_LEAP_OFFSET_TEST_HEIGHT> + traceVector * 64                   

			TraceResults ridgeTrace = TraceLine( ridgeOrigin, ridgeTraceOrigin, ignoreArray, (TRACE_MASK_PLAYERSOLID | TRACE_MASK_TITANSOLID | CONTENTS_NOAIRDROP), TRACE_COLLISION_GROUP_PLAYER_MOVEMENT, ent )
			float fraction          = ridgeTrace.fraction
			if ( fraction == 1 )
			{
				                                                                               

				info.failCase = eFailCase.BLOCKED_LANDING
				return false
			}
		}
	}


	return true
}

bool function ArmoredLeap_HasValidHullRoom( entity ent, vector pos, bool useLandingHulls = false )
{
	vector up = <0,0,1>
	array<entity> ignoreArray = ArmoredLeapIgnoreArray()

	vector mins = ent.GetPlayerMins()
	vector maxs = ent.GetPlayerMaxs()
	maxs = < maxs.x, maxs.y, 80 >                                                                      

	if( useLandingHulls )
		maxs = maxs + <0,0,50>

	TraceResults results = TraceHull( pos, pos, mins, maxs, ignoreArray, TRACE_MASK_PLAYERSOLID, TRACE_COLLISION_GROUP_PLAYER_MOVEMENT, up, ent )
	if ( results.startSolid )
	{
		return false
	}

	return true
}

bool function ArmoredLeap_HasValidLeapPos( entity ent, entity targetAlly, vector endPos, entity traceHitEnt,  ArmoredLeapTargetInfo info )
{
	bool hasValidAirPosition = true

	vector eyePos = ent.EyePosition()
	vector eyeDir = ent.GetViewVector()
	eyeDir          = Normalize( eyeDir )

	array<entity> ignoreArray = ArmoredLeapIgnoreArray()

	vector leapPos = ent.GetOrigin()
	vector leapDir = Normalize( endPos - leapPos )
	float distCheck  = Distance( leapPos, endPos )

	float maxHeight	  = ARMORED_LEAP_MAX_LEAP_HEIGHT
	float vertDist	= endPos.z - leapPos.z

	vector adjustedEndPos = endPos + < 0, 0, 5 >                                                          

	info.hitEnt = traceHitEnt

	if( !ArmoredLeap_IsValidPosition( ent, endPos, traceHitEnt ) )
	{
		info.failCase = eFailCase.DEFAULT
		return false
	}

	if( !ArmoredLeap_HasValidLandingRoom( ent, endPos, info ) )
	{
		info.failCase = eFailCase.BLOCKED_LANDING
		return false
	}

	if( !ent.IsOnGround() )                         
	{
		                                                                                                                               
		TraceResults airLOSTrace = TraceLine( leapPos, endPos, ignoreArray, TRACE_MASK_VISIBLE, TRACE_COLLISION_GROUP_PLAYER_MOVEMENT )
		                                                                                                                                                                               
		if ( airLOSTrace.fraction < 0.98 )                                                                                   
			return false
	}

	                                           
	                                                                                    
	                                                                                 
	                                                             

	if( IsValid(targetAlly) )
		maxHeight = ARMORED_LEAP_MAX_LEAP_HEIGHT_ALLY

	if( vertDist > maxHeight )
	{
		info.failCase = eFailCase.DEFAULT
		return false
	}

	                                    
	float airHeight = GraphCapped( distCheck, 0, ARMORED_LEAP_FAR_AIR_HEIGHT_DIST, ARMORED_LEAP_CLOSE_AIR_HEIGHT, ARMORED_LEAP_FAR_AIR_HEIGHT )
	vector airLeapPos = ( endPos + < 0, 0, airHeight > ) - ( leapDir * ARMORED_LEAP_AIR_POS_OFFSET )

	                                            
	bool isDash = ArmoredLeap_IsInDashRange(ent, adjustedEndPos, traceHitEnt)

	vector up = <0,0,1>
	vector mins = ARMORED_LEAP_COL_MINS
	vector maxs = ARMORED_LEAP_COL_MAXS

	if( !isDash )                                                           
	{
		bool hasAirSpace = ArmoredLeap_HasValidHullRoom( ent, airLeapPos )
		TraceResults upAirTrace = TraceLine( adjustedEndPos, airLeapPos, ignoreArray, TRACE_MASK_PLAYERSOLID, TRACE_COLLISION_GROUP_PLAYER_MOVEMENT )                     
		if ( upAirTrace.fraction < 1.0 || !hasAirSpace )
		{
			                                                                                 
			vector newAirLeapPos = upAirTrace.endPos - < 0, 0, ARMORED_LEAP_HUMAN_HEIGHT_OFFSET >
			hasAirSpace = ArmoredLeap_HasValidHullRoom( ent, newAirLeapPos )

			TraceResults newAirLeapTrace = TraceLine( newAirLeapPos, adjustedEndPos, ignoreArray, TRACE_MASK_PLAYERSOLID, TRACE_COLLISION_GROUP_PLAYER_MOVEMENT )
			float zDist = Distance( < 0, 0, newAirLeapPos.z>, < 0, 0, endPos.z >  )
			if( zDist < ARMORED_LEAP_MIN_AIR_HEIGHT || newAirLeapTrace.fraction < 1 || !hasAirSpace)
			{
				                                           
				                                                                                                      
				                                                                                              
				                                                                        

				                                                            
				                                                                                                                                              
				vector overheadAirPos = endPos + < 0, 0, airHeight >
				hasAirSpace = ArmoredLeap_HasValidHullRoom( ent, overheadAirPos )

				TraceResults overheadAirLeapTrace = TraceLine( adjustedEndPos, overheadAirPos, ignoreArray, TRACE_MASK_PLAYERSOLID, TRACE_COLLISION_GROUP_PLAYER_MOVEMENT )
				if ( overheadAirLeapTrace.fraction < 1.0 || !hasAirSpace)
				{
					                        
					newAirLeapPos = overheadAirLeapTrace.endPos - < 0, 0, ARMORED_LEAP_HUMAN_HEIGHT_OFFSET >
					hasAirSpace = ArmoredLeap_HasValidHullRoom( ent, overheadAirPos )
					TraceResults newOverheadAirLeapTrace = TraceLine( newAirLeapPos, adjustedEndPos, ignoreArray, TRACE_MASK_PLAYERSOLID, TRACE_COLLISION_GROUP_PLAYER_MOVEMENT )
					zDist = Distance( < 0, 0, newAirLeapPos.z>, < 0, 0, endPos.z >  )
					if( zDist < ARMORED_LEAP_MIN_AIR_HEIGHT || newOverheadAirLeapTrace.fraction < 1 || !hasAirSpace )
					{
						                                                              
						info.failCase = eFailCase.BLOCKED_LANDING
						return false
					}

				}
				else
				{
					newAirLeapPos = overheadAirPos
				}

			}

			airLeapPos = newAirLeapPos
		}


		                                                                                                                      
		                                                
		hasAirSpace = ArmoredLeap_HasValidHullRoom( ent, airLeapPos )
		TraceResults dashTrace = TraceHull( eyePos, airLeapPos, mins, maxs, ignoreArray, TRACE_MASK_PLAYERSOLID, TRACE_COLLISION_GROUP_PLAYER_MOVEMENT, up, ent )                         
		if( dashTrace.fraction < 1.0 || !hasAirSpace)
		{
			                               
			                                                                        
			vector dropLeapPos = airLeapPos + < 0, 0, ARMORED_LEAP_HUMAN_HEIGHT_OFFSET >
			hasAirSpace = ArmoredLeap_HasValidHullRoom( ent, dropLeapPos )
			TraceResults dashDropTrace = TraceHull( eyePos, dropLeapPos,  mins, maxs, ignoreArray, TRACE_MASK_PLAYERSOLID, TRACE_COLLISION_GROUP_PLAYER_MOVEMENT, up, ent )
			TraceResults dashDropToEnd = TraceLine( dropLeapPos, adjustedEndPos, ignoreArray, TRACE_MASK_PLAYERSOLID, TRACE_COLLISION_GROUP_PLAYER_MOVEMENT )

			if( dashDropTrace.fraction < 1.0 || dashDropToEnd.fraction < 1 || !hasAirSpace )
			{
				                                    
				dropLeapPos = <dropLeapPos.x, dropLeapPos.y, endPos.z> + < 0, 0, ARMORED_LEAP_MIN_AIR_HEIGHT >
				hasAirSpace = ArmoredLeap_HasValidHullRoom( ent, dropLeapPos )

				TraceResults dashMinHeightTrace = TraceHull( eyePos, dropLeapPos,  mins, maxs, ignoreArray, TRACE_MASK_PLAYERSOLID, TRACE_COLLISION_GROUP_PLAYER_MOVEMENT, up, ent )
				TraceResults dashMinToEnd 		= TraceLine( dropLeapPos, adjustedEndPos, ignoreArray, TRACE_MASK_PLAYERSOLID, TRACE_COLLISION_GROUP_PLAYER_MOVEMENT )

				if( dashMinHeightTrace.fraction < 1.0 || dashMinToEnd.fraction < 1.0 || !hasAirSpace)
				{
					                               

					                                                                    
					if( IsValid(targetAlly) )
					{
						airHeight = ARMORED_LEAP_MAX_AIR_HEIGHT

						vector airLeapTestPos = ( endPos + < 0, 0, airHeight > ) - ( leapDir * ARMORED_LEAP_AIR_POS_OFFSET)
						hasAirSpace = ArmoredLeap_HasValidHullRoom( ent, airLeapTestPos )

						TraceResults dashHighTrace = TraceHull( eyePos, airLeapTestPos,  mins, maxs, ignoreArray, TRACE_MASK_PLAYERSOLID, TRACE_COLLISION_GROUP_PLAYER_MOVEMENT, up, ent )

						if( dashHighTrace.fraction < 1.0 || !hasAirSpace)
						{
							float minLeapAirDist = Distance2D( ent.GetOrigin(), endPos ) / 3                                                                                                          

							airLeapTestPos = ( ent.GetOrigin() + < 0, 0, airHeight > ) + leapDir * minLeapAirDist
							hasAirSpace = ArmoredLeap_HasValidHullRoom( ent, airLeapTestPos )

							TraceResults superDashTrace = TraceHull( eyePos, airLeapTestPos,  mins, maxs, ignoreArray, TRACE_MASK_PLAYERSOLID, TRACE_COLLISION_GROUP_PLAYER_MOVEMENT, up, ent )

							if( superDashTrace.fraction < 1 || !hasAirSpace)
							{
								airLeapTestPos = ent.GetOrigin() + < 0, 0, airHeight >
								hasAirSpace = ArmoredLeap_HasValidHullRoom( ent, airLeapTestPos )

								TraceResults diveKickTrace = TraceHull( eyePos, airLeapTestPos,  mins, maxs, ignoreArray, TRACE_MASK_PLAYERSOLID, TRACE_COLLISION_GROUP_PLAYER_MOVEMENT, up, ent )

								if( diveKickTrace.fraction < 1 || !hasAirSpace)
								{
									                                                                           
									info.failCase = eFailCase.BLOCKED_LEAP
									return false
								}
							}
							                                                                         
						}

						                                                                                                                                                                                   
						                                                                                                                                                                                               
						TraceResults dashHighToGroundTrace = TraceHull( adjustedEndPos, airLeapTestPos, ent.GetPlayerMins(), ent.GetPlayerMaxs(), ignoreArray, TRACE_MASK_PLAYERSOLID, TRACE_COLLISION_GROUP_PLAYER_MOVEMENT )
						if ( dashHighToGroundTrace.fraction < 0.98 )        
						{
							info.failCase = eFailCase.BLOCKED_LANDING
							return false
						}
						else
						{
							info.airPos = ( airLeapTestPos )
							return hasValidAirPosition
						}
					}

					info.failCase = eFailCase.BLOCKED_LEAP
					return false
				}

			}

			airLeapPos = dropLeapPos
		}

	}
	info.airPos = ( airLeapPos )


	return hasValidAirPosition
}

bool function ArmoredLeap_IsValidPosition( entity player, vector position, entity traceHitEnt )                                  
{
	if ( IsValid( traceHitEnt ) )
	{
		if ( traceHitEnt.IsPlayer() || traceHitEnt.IsNPC() || IsDeathboxFlyer( traceHitEnt ) )
			return false

		if ( traceHitEnt.GetScriptName() == CRYPTO_DRONE_SCRIPTNAME  )
			return false

		if ( traceHitEnt.IsProjectile() )
			return false

		entity pusher = GetPusherEnt( traceHitEnt )
		if ( pusher )
		{
			if ( ! file.allowEndOnMovers )
				return false

			#if DEV
				if ( DEBUG_DRAW_PUSHER_MOVEMENT )
				{
					vector pusherVelAtPoint = pusher.GetAbsVelocityAtPoint(position)
					DebugScreenText( 0.1,0.6, "Pusher " + pusher + ", speed is " + Length(pusherVelAtPoint) + " , vel is " + pusherVelAtPoint )
				}
			#endif

			if ( LengthSqr(pusher.GetAbsVelocityAtPoint(position)) > file.maxEndingMoverSpeedSqr )	                                                                                    
				return false
		}
	}

	array<string> triggersToCheck = ["trigger_slip"]
	triggersToCheck.append( "trigger_out_of_bounds" )
	triggersToCheck.append( "trigger_no_object_placement" )
	triggersToCheck.append( "trigger_no_zipline" )
	triggersToCheck.append( "trigger_no_grapple" )

	foreach ( entity trigger in GetTriggersByClassesInRealms_HullSize(
		triggersToCheck,
		position, position,
		player.GetRealms(), TRACE_MASK_PLAYERSOLID,
		player.GetPlayerMins(), player.GetPlayerMaxs() ) )
	{
		return false
	}

	return true
}

bool function ArmoredLeap_IsInDashRange( entity player, vector endPoint, entity hitEnt )
{
	if( !IsValid(player) )
		return false

	entity pusher = GetPusherEnt( hitEnt )
	if ( pusher )
	{
		if ( LengthSqr(pusher.GetAbsVelocityAtPoint(endPoint)) > file.maxEndingMoverSpeedSqr )	                                                                                    
			return false
	}

	float dist = Distance2D( player.EyePosition(), endPoint )
	float distZ = fabs( player.GetOrigin().z - endPoint.z )
	array<entity> ignoreArray = ArmoredLeapIgnoreArray()
	TraceResults visionTrace = TraceLine( player.EyePosition(), endPoint + <0,0,5>, ignoreArray, TRACE_MASK_PLAYERSOLID, TRACE_COLLISION_GROUP_PLAYER_MOVEMENT )

	if( dist <= ARMORED_LEAP_GROUND_DASH_RANGE && visionTrace.fraction == 1 && distZ < ARMORED_LEAP_GROUND_DASH_HEIGHT_LIMIT && player.IsOnGround() )
	{
		TraceResults dashBackTrace = TraceHull( endPoint + <0,0,16>, player.EyePosition(), ARMORED_LEAP_COL_MINS, ARMORED_LEAP_COL_MAXS, ignoreArray, TRACE_MASK_PLAYERSOLID, TRACE_COLLISION_GROUP_PLAYER_MOVEMENT )
		if ( dashBackTrace.fraction < 0.98 )        
		{
			return false
		}
		return true
	}

	return false
}

bool function ArmoredLeap_CanUseZipline( entity player, entity zipline, vector ziplineClosestPoint )
{
	if( !(player in file.isTargetPlacementActive) )
		return true

	if ( file.isTargetPlacementActive[player] )
		return false

	return true
}



                                       
                                       
                                      

entity function GetAllyTargetInRange( entity owner )
{
	entity hitEnt = null
	entity allyEnt = null
	float distToTarget = 0.0
	float lastBestDotRange = 0.0
	bool canTargetAllyDeathbox = true

	array<entity> allyArray = GetAllyPlayerArray(owner)                         
	array<entity> allyInRangeArray

	                                                  
	foreach ( entity player in allyArray )
	{
		float distToAlly = Distance2D( owner.GetOrigin(), player.GetOrigin() )
		if ( distToAlly > ARMORED_LEAP_MAX_ALLY_RANGE )
			continue

		allyInRangeArray.append( player )

	}

	if( canTargetAllyDeathbox )
	{
		array<entity> deathboxArray = GetAllDeathBoxes()
		foreach( deathbox in deathboxArray)
		{
			if( !IsValid( deathbox ) )
				continue
			if( !ShouldPickupDNAFromDeathBox( deathbox, owner  ) )
				continue
			float distToBox = Distance2D( owner.GetOrigin(), deathbox.GetOrigin() )
			if ( distToBox > ARMORED_LEAP_MAX_ALLY_RANGE )
				continue

			allyInRangeArray.append(deathbox)
		}
	}

	                       
	foreach ( entity ally in allyInRangeArray )
	{
		if ( !IsValid( ally ) )
		{
			continue
		}
		                     
		vector allyEyePos = ally.GetOrigin() + <0,0,ARMORED_LEAP_HUMAN_HEIGHT_OFFSET>                                                                       
		vector playerEyePos = owner.EyePosition()
		vector playerEyeDir = AnglesToForward( owner.EyeAngles() )

		vector dir = Normalize(playerEyeDir)
		vector dirToTarget = Normalize( allyEyePos - playerEyePos )

		                                                                                                                                  
		                                  

		float dotRangeToTarget = DotProduct( dir, dirToTarget )

		if( dotRangeToTarget > ARMORED_LEAP_DOT_TO_ALLY_TARGET )
		{
			if( dotRangeToTarget > lastBestDotRange )
			{
				allyEnt = ally
				lastBestDotRange = dotRangeToTarget
			}
		}

	}

	return allyEnt
}

array<entity> function GetAllyPlayerArray( entity owner )
{
	int team = owner.GetTeam()
	int alliance

                         
		if ( Control_IsModeEnabled()  )
		{
			alliance = AllianceProximity_GetAllianceFromTeam( team )
		}
       

	array<entity> playerArray = GetPlayerArray_Alive()
	array<entity> validAllyArray

	                                                  
	foreach ( entity player in playerArray )
	{
		if ( player == owner )
			continue

		if ( player.IsPhaseShifted() )
			continue

		if( player.Player_IsSkywardFollowing() )                                                                                                             
			continue

		int playerTeam = player.GetTeam()
		if( !IsFriendlyTeam( team, playerTeam ) )
			continue

                          
			if ( Control_IsModeEnabled()  )
			{
				if ( !IsTeamInAlliance( playerTeam, alliance ) )
					continue
			}
        

		validAllyArray.append( player )
	}

	return validAllyArray
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


#if SERVER
                                                                                                                               
 
	                         
	                               
	                            	                          

	                               
	                                    

	                                                                                                              
	                                                  

	                       
	                                                          
	                                                                                    

	                                                                                                                                                                                
	                                                                                      
	 
		                                  
		                                                                                                                               
	 
	                                       
	 
		                                   
		                                                         

		                                                                                                                                      
		                                                                                                                                       
		 
			                          
			                        
		 
		                                                     
		 
			                                    
			                                                                                                                              
		 
	 

	                     
		                                     

	                                              
	                                         
		                        

	                   
 
#endif

bool function SnakeWall_IsValidMountHitEnt( entity hitEnt )
{
	                                                                                                             
	if( !IsValid( hitEnt ) )
		return false

	array<entity> lootBins = GetEntArrayByScriptName( LOOT_BIN_SCRIPTNAME )                                   
	if( lootBins.contains(hitEnt) )
		return false

	if( hitEnt.GetNetworkedClassName() == "phys_bone_follower" )
		return false

	return true
}

vector function SnakeWall_GetBestDownTracePosition( vector nextValidPos, vector traceStart, vector tracePos, vector dir, array<entity> ignoreArray, ArmoredLeapSnakeInfo snakeInfo )
{
                                                                                                                                         
	                                                                    
	                                                    


	TraceResults downTrace = TraceLine( tracePos, tracePos + <0.0, 0.0, -CASTLE_SNAKE_DROP_TEST_HEIGHT>, ignoreArray, TRACE_MASK_SOLID, TRACE_COLLISION_GROUP_PLAYER_MOVEMENT )
	if ( downTrace.fraction == 1.0 )                
	{
		TraceResults downCliffTrace = TraceLine( tracePos, tracePos + < 0.0, 0.0, -CASTLE_SNAKE_DROP_TEST_HEIGHT_MAX >, ignoreArray, TRACE_MASK_SOLID, TRACE_COLLISION_GROUP_PLAYER_MOVEMENT )

		#if DEV
			if( DEBUG_SNAKE_DRAW )
			{
				DebugDrawSphere( downCliffTrace.endPos, 6.0, COLOR_RED, true, 15.0, 8 )
			}
		#endif

		entity hitEnt = downCliffTrace.hitEnt
		bool canMountEnt = SnakeWall_IsValidMountHitEnt( hitEnt )

		if( downCliffTrace.fraction != 1 && canMountEnt )                                                                                                                
		{
			vector downCliffTraceEnd = downCliffTrace.endPos + <0,0,5>
			TraceResults dropRoomAheadTrace = TraceLine( downCliffTraceEnd , downCliffTraceEnd + dir * CASTLE_SNAKE_TEST_STEP , ignoreArray, TRACE_MASK_SOLID_BRUSHONLY, TRACE_COLLISION_GROUP_PLAYER_MOVEMENT )
			if( dropRoomAheadTrace.fraction == 1 )
			{
				nextValidPos = tracePos                        
				snakeInfo.drop = true                              
				snakeInfo.dropPos = downCliffTrace.endPos                                        
				return nextValidPos
			}

		}
		else                                                                          
		{
			const float CASTLE_SNAKE_NUM_ANGLE_CHECKS = 5
			const float CASTLE_SNAKE_MAX_EDGE_ANGLE = 45.0

			float anglePerCheck = CASTLE_SNAKE_MAX_EDGE_ANGLE/CASTLE_SNAKE_NUM_ANGLE_CHECKS

			if( !snakeInfo.isLeft )                             
				anglePerCheck = -(anglePerCheck)

			for( int i = 0; i < CASTLE_SNAKE_NUM_ANGLE_CHECKS; i++ )
			{
				float adjustedAngle = anglePerCheck*i
				vector bendTestPos = traceStart + ( RotateVector(dir, <0, adjustedAngle, 0> ) * CASTLE_SNAKE_TEST_STEP )                                                                                                                              
				TraceResults ledgeBendTrace = TraceLine( traceStart, bendTestPos, ignoreArray, TRACE_MASK_SOLID_BRUSHONLY, TRACE_COLLISION_GROUP_PLAYER_MOVEMENT )

				if( ledgeBendTrace.fraction == 1 )                               
				{
					TraceResults ledgeBendDownTrace = TraceLine( ledgeBendTrace.endPos, ledgeBendTrace.endPos + < 0.0, 0.0, -CASTLE_SNAKE_DROP_TEST_HEIGHT >, ignoreArray, TRACE_MASK_SOLID_BRUSHONLY, TRACE_COLLISION_GROUP_PLAYER_MOVEMENT )
					hitEnt = ledgeBendDownTrace.hitEnt
					canMountEnt = SnakeWall_IsValidMountHitEnt( hitEnt )
					if ( ledgeBendDownTrace.fraction != 1.0 && canMountEnt )                                 
					{
						snakeInfo.moverDir = RotateVector(dir, <0, adjustedAngle, 0> )
						nextValidPos = ledgeBendDownTrace.endPos
						return nextValidPos
					}

					#if DEV
					if( DEBUG_SNAKE_DRAW )
					{
						DebugDrawSphere( ledgeBendTrace.endPos, 6.0, COLOR_RED, true, 15.0 )                                             
					}
					#endif

				}
			}
			                                                                                                         
			snakeInfo.stopped = true

		}

	}
	else                                      
	{
		if( !downTrace.startSolid )
			nextValidPos = downTrace.endPos
	}

	return nextValidPos

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

#if SERVER
                                                         
 
	                         
		      

	                                                  
 
#endif

#if CLIENT
vector function CastleWall_OffsetDamageNumbers( entity shieldEnt, vector damageFlyoutPosition )
{
	vector flyoutPosition = ZERO_VECTOR

	entity player = GetLocalClientPlayer()

	if( !IsValid(player) )
		return damageFlyoutPosition

	float distToShield = Distance( player.GetOrigin(),shieldEnt.GetOrigin() )
	const float CASTLE_WALL_DAMAGE_POS_FWD_OFFSET = 20.0
	const float CASTLE_WALL_DAMAGE_POS_VERT_OFFSET_NEAR 	= 25.0
	const float CASTLE_WALL_DAMAGE_POS_VERT_OFFSET_FAR 		= -180.0
	vector origin = shieldEnt.GetOrigin() - shieldEnt.GetForwardVector() * CASTLE_WALL_DAMAGE_POS_FWD_OFFSET

	float vertOffset = GraphCapped( distToShield, 200, 2000, CASTLE_WALL_DAMAGE_POS_VERT_OFFSET_NEAR, CASTLE_WALL_DAMAGE_POS_VERT_OFFSET_FAR )
	flyoutPosition = origin + <0,0,vertOffset>             

	return flyoutPosition
}
#endif

#if SERVER
                                                                        
 
	            
	                 

	                       
	 
		                                          
		                                          

		                                                                                                                                                        
		 
			                                                                                 
			           	                                         
		 
		                                                              
		 
			                                                                           
			           	                                         
		 

		                                                                                               
		                                                                      

		                                 
		                       
		 
			                                      
			                          
			 
				                                                      
				                                                 
				 
					                                                                                                                           
					                                                                                              
				 
			 

			                                   
			 
				                                                  
					                                                     

				                                      
				 
					                                                                                          
				 
				                                      
				 
					                                                                                          
				 
				                     
				                                            
					                                              
			 
		 
	 
 

                                                                                                               
 
		                                  
		 
			                             
			 
				                       
					        

				                     
				 
					                                                 
						                                                    

					               
				 

			 
		 
 

#endif

bool function IsCastleWallEnt( entity ent )
{
	return ent.GetScriptName() == ARMORED_LEAP_SHIELD_ANCHOR_SCRIPTNAME
}




                                                                                                    
                                                                                                    
                                                                                                    

                  
#if SERVER
                                                                
 
	                                

	                                   
	 
		               		                   
		           			                           

		                                           
		                   	         
		                             
		              
		                 

		                                              
		 
			                   	      
			                      
				        

			                                        

			                    
			 
				                                  
					                                   
					                       
					 
						                                       
						                                                                             
						                                     
						                               
						                              
					 

					     
				                                   
					                                   
					                        
					 
						                                        
						                                                                               
						                                      
						                                
						                               
					 
					     
				                                       
					                               
					     
				                                     
					                               
					     
				                                      
					                               
					     
				        
					     
			 

			                                  
			 
				                                           
			 

			                             

			                    
			 
				                                                           
				                                                                                                                                             

				                                                            
				                                                                              
			 
		 
	 

 
#endif


                                      
#if SERVER
                                                                                                                 
 
	                                   
	                            
	                                                      

	                                    
	                                              
	                                 

	                                                   
	                              
	                                    	                                                                                   
	                                   		                                                                  
	                                   
	                                        
	                                          
	                             
	                                             
	                        

	               	   
	                                       
		                                                                 

	                                                                                                              
	                              

	                                                                             

	                                              


	            
		                                    
		 
			                         
			 
				                 
			 
			                            
			 
			 
		 
	 

	                                                                 
	                         
	 
		                                                     
		                                                    
		                                    
	 

	       
		                                
		 
			                                      
			 
				                                                                 
				                                                                                                                       
				                                                                                                                       
				                                                                                                         
				                                                                                                         

			 

			                                     
			 
				                                                               
				                                                                                                                        
				                                                                                                                        
				                                                                                                         
				                                                                                                            
			 
		 
	      

	                                                                   
	                                                                              

	                 
	                          
		      

	                                                                      

	                                         
	               

 

                                                                        
 
	                        
		      

	                                                                                                                                                               
	                              
	 
		                         
		 
			      
		 
	 

	                                                    
 

                                                                       
 
	                        
		      

 

                                                                         
 
	                                

	                                      

	                             
		      

	                                                                         
		      

	                       
		                             

	                               

	         			                   
	         			                  
	              		                       
	            		       
	              		                                            

	            
		                       
		 
			                        
			 
			 
		 
	 

	                                    
		      

	                                      
	 
		                        
			      

		                                                                                                                
		 

			                                   
			 
				                                                      
				 
					                                              

					                    
					 
						                                  
							                                                    
							     
						                                   
							                                                    
							     
						        
							                                                     
							     
					 
				 

				                                                                    
				                                                                  
				                                       
					               
				    
					              
			 


			                                           
			 
				                                      
				                   	                                                            
				           			                                                          

				                        
				 
					                                             

					                                                                                                             
					                                                                                                 
					                                                                                                      
					                                                                                                      
				 

				                                                                                                                                                                                                                        

				                      
				 
					                                                                                                                    
					                                                                                                                      
				 
				    
				 
					                                                                                                
				 
			 
		 

		           
	 
 

                                                                       
 
	                      
		      

	                                                        
	 
		                                       
		      
	 

	                                                                                         
 

                                                           
 
	                              
	                                

	                                                              
	                  

	                                                                           
	 
		                                                                                                                                            
		                              
		                                                                                       
	 

	            
		                            
		 
			                             
			 
				                         
				                     
			 
		 
	 

	                                        
 
#endif         


                                                               
#if SERVER
                                                                                                                 
 
	                             
	                                       
	                                                 
	                            
	                                               

	                        
	                             

	                     
	             		   
	           			                 
	              		                                   
	                  	                     

	        

	                             
	 
		                                     
			                                                               
			     
		                                       
			                                                             
			     
		                                      
			                                                               
			     
		                                  
			                   
			 
				       
					                                                                  
					                                            
					     
				       
					                                                                     
					                                            
					     
				       
					                                                                     
					                                            
					     
				        
					     
			 
			     
		                                   
			                   
			 
				       
					                                                                   
					                                             
					     
				       
					                                                                      
					                                             
					     
				       
					                                                                      
					                                             
					     
				        
					     
			 
			             
			     
		        
			     
	 

	       
		                                
		 
			                                                                                    
		 
	      

	           
	                                                                                                                                                      
	                                                                
	                                                                        

	                       
	                                                      
	                        

	            
	                                                                                                                                                       
	                                                                  
	                                                                          

	                        
	                                                    
	                         

	                      
	                       
	            

	                                  

	            
		                              
		 
			                         
			 
				                    
				 
					              
					            
				 
			 

			                    
			 
				                                   
			 
		 
	 

	                                                                   
	                                                                        

	                 
	                   
		      
	                                                               

	                                         

 
#endif          



                                  
                                 
                                 
bool function CastleWall_CanUse( entity player, entity ent, int useFlags )
{
	if ( ! IsValid( player ) )
		return false

	TraceResults viewTrace = GetViewTrace( player )

	int playerTeam = player.GetTeam()

	return IsFriendlyTeam( ent.GetTeam(), playerTeam ) &&
	viewTrace.hitEnt == ent &&
	SURVIVAL_PlayerAllowedToPickup( player ) &&
	! GradeFlagsHas( ent, eGradeFlags.IS_BUSY )
}

#if SERVER
                                                                                    
 
	                                                
		      

	                                                                                                    
		      

	                                          
		      

	                                                       
		      

	                                 
	                                                         
		      

	                                                

	                                              
	 
		                                                              

	 
 

                                                                   
 

	                                 
	                                                              
	                                                         
		            

	                                       
		            

	                                                                             
	                                                            
		            

	           
 

                                                                            
 
	                                                          

	                            
	 
		                                            
		                        
		                           
		 
			                                                                           
			 
				                                             
				                                            
			 

		 

		                                                                                                  
		                     
		                                           
	 
	                                          
	      

 
#endif


#if CLIENT
                        
void function OnCharacterButtonPressed( entity player )
{
	entity useEnt = player.GetUsePromptEntity()
	if ( !IsValid( useEnt ) || useEnt.GetScriptName() != ARMORED_LEAP_SHIELD_ANCHOR_SCRIPTNAME )
		return

	int playerTeam = player.GetTeam()
	int entTeam = useEnt.GetTeam()

	if ( !IsFriendlyTeam( entTeam, playerTeam ) )
		return

	                                          
	CustomUsePrompt_SetLastUsedTime( Time() )

	Remote_ServerCallFunction( "ClientCallback_TryPickupCastleWall", useEnt )
}

void function CastleWall_OnPropScriptCreated( entity ent )
{
	if ( ent.GetScriptName() == ARMORED_LEAP_SHIELD_ANCHOR_SCRIPTNAME )
	{
		AddEntityCallback_GetUseEntOverrideText( ent, CastleWall_UseTextOverride )
		AddCallback_OnUseEntity_ClientServer( ent, CastleWall_OnUseWall )

		int shieldTeam = ent.GetTeam()

		bool startThreatIndicatorThread = false

		if ( !( shieldTeam in file.castleWallEnts ) )
		{
			startThreatIndicatorThread = true
			CastleWallEntityData data

			file.castleWallEnts[shieldTeam] <- data
		}

		switch( ent.GetTargetName() )
		{
			case ARMORED_LEAP_SHIELD_ANCHOR_LEFT:
				file.castleWallEnts[shieldTeam].anchorLeft = ent
				break
			case ARMORED_LEAP_SHIELD_ANCHOR_CENTER:
				file.castleWallEnts[shieldTeam].anchorCenter = ent
				break
			case ARMORED_LEAP_SHIELD_ANCHOR_RIGHT:
				file.castleWallEnts[shieldTeam].anchorRight = ent
				break
			case ARMORED_LEAP_SHIELD_LOW_LEFT:
				file.castleWallEnts[shieldTeam].lowWallsLeft.append( ent )
				break
			case ARMORED_LEAP_SHIELD_LOW_RIGHT:
				file.castleWallEnts[shieldTeam].lowWallsRight.append( ent )
				break
			default:
				break
		}

		ent.e.castleWallIsEnergized = true
		thread TrackCastleWallEnergizedState_Thread( ent )

		if ( IsEnemyTeam( GetLocalViewPlayer().GetTeam(), shieldTeam ) )
		{
			if ( startThreatIndicatorThread )
			{
				thread DoCastleWallThreatIndicatorAndSound_Thread( GetLocalViewPlayer(), shieldTeam, CASTLE_WALL_WARNING_RADIUS )
				startThreatIndicatorThread = false
			}
		}
	}
}

void function CastleWall_OnUseWall( entity wallProxy, entity player, int useFlags )
{
	if ( IsControllerModeActive() )
	{
		if ( ! ( useFlags & USE_INPUT_LONG ) )
		{
			thread IssueReloadCommand( player )
		}
	}
}

void function IssueReloadCommand( entity player )
{
	EndSignal( player, "OnDestroy" )

	player.ClientCommand( "+reload" )
	WaitFrame()
	player.ClientCommand( "-reload" )
}

void function TrackCastleWallEnergizedState_Thread( entity ent )
{
	EndSignal( ent, "OnDestroy" )

	OnThreadEnd(
		function() : ( ent )
		{
			if ( IsValid( ent ) )
				ent.e.castleWallIsEnergized = false
		}
	)

	float endTime                    = Time() + CASTLE_WALL_BARRIER_DURATION
	while ( Time() < endTime )
	{
		WaitFrame()
	}
}

void function CastleWall_OnPropScriptDestroyed( entity ent )
{
	if ( !IsValid( ent ) )
		return

	if ( ent.GetScriptName() == ARMORED_LEAP_SHIELD_ANCHOR_SCRIPTNAME )
	{
		CustomUsePrompt_ClearForEntity( ent )
	}
}

string function CastleWall_UseTextOverride( entity ent )
{
	entity player = GetLocalViewPlayer()
	int playerTeam = player.GetTeam()

	if ( !CastleWall_CanUse( player, ent, USE_FLAG_NONE ) )
	{
		CustomUsePrompt_Hide()

		if( ent in file.castleWallHighlightFocus )
			delete file.castleWallHighlightFocus[ent]
	}
	else if ( IsFriendlyTeam( ent.GetTeam(), playerTeam ) )
	{
		CustomUsePrompt_Show( ent )
		CustomUsePrompt_SetSourcePos( ent.GetOrigin() + < 0, 0, -5 > )

		CustomUsePrompt_SetText( Localize("#NEWCASTLE_CASTLE_WALL_DYNAMIC_DESTROY") )
		                                                                                      
		CustomUsePrompt_SetHintImage( $"" )
		CustomUsePrompt_SetLineColor( <1.0, 0.5, 0.0> )

		file.castleWallHighlightFocus[ ent ] <- true

		if ( PlayerIsInADS( player ) )
			CustomUsePrompt_ShowSourcePos( false )
		else
			CustomUsePrompt_ShowSourcePos( true )
	}

	ManageHighlightEntity( ent )
	return ""
}
#endif         

bool function CastleWall_EntityShouldBeHighlighted( entity target )
{
	#if CLIENT
		if( !IsValid(target) )
			return false

		if ( (target in file.castleWallHighlightFocus) )
		{
			if ( file.castleWallHighlightFocus[ target ] )
				return true
		}
	#endif

	return false
}

#if CLIENT
void function CastleWall_OnGainFocus( entity ent )
{
	if ( !IsValid( ent ) )
		return

	if ( ent.GetScriptName() == ARMORED_LEAP_SHIELD_ANCHOR_SCRIPTNAME )
	{
		CustomUsePrompt_Show( ent )
	}
}

void function CastleWall_OnLoseFocus( entity ent )
{
	if ( IsValid( ent ) )
	{
		if ( ent.GetScriptName() == ARMORED_LEAP_SHIELD_ANCHOR_SCRIPTNAME )
		{
			if( ent in file.castleWallHighlightFocus )
				delete file.castleWallHighlightFocus[ent]

			ManageHighlightEntity( ent )
		}
	}

	CustomUsePrompt_ClearForAny()
}
#endif         

#if CLIENT
void function AddImpactZoneThreatIndicator( entity impactMarker )
{
	entity player = GetLocalViewPlayer()
	int team = player.GetTeam()
	int markerTeam = impactMarker.GetTeam()

	if( IsEnemyTeam( team, markerTeam ) )
		ShowGrenadeArrow( player, impactMarker, ARMORED_LEAP_IMPACT_RANGE, 0.0, true, eThreatIndicatorVisibility.INDICATOR_SHOW_TO_ALL, <0, 0, 0>, true )
}
#endif

#if CLIENT
                                                                                                                           
                                                                                                                                                                                                              
                                                                                                                                                                                    
                                                                                                                                                                                                                                                                                                        
void function DoCastleWallThreatIndicatorAndSound_Thread( entity player, int shieldTeam, float warningRadius )
{
	Assert ( IsNewThread(), "Must be threaded off." )
	player.EndSignal( "OnDestroy" )

	float endTime                    = Time() + CASTLE_WALL_BARRIER_DURATION
	vector ornull closestProjection  = GetProjectionForCastleThreat( player, shieldTeam, true )
	vector ornull farthestProjection = GetProjectionForCastleThreat( player, shieldTeam, false )
	vector startingPosClose          = ZERO_VECTOR
	vector startingPosFar			 = ZERO_VECTOR
	bool doClosestPositionActions
	bool doFarthestPositionActions

	if ( closestProjection != null )
	{
		startingPosClose         = expect vector( closestProjection )
		doClosestPositionActions = true
	}
	else
	{
		doClosestPositionActions = false
	}

	if ( farthestProjection != null )
	{
		startingPosFar         = expect vector( closestProjection )
		doFarthestPositionActions = true
	}
	else
	{
		doFarthestPositionActions = false
	}

	entity closestPositionEnt  = CreateClientSidePropDynamic( startingPosClose, <0,0,0>, $"mdl/dev/empty_model.rmdl" )
	closestPositionEnt.SetScriptName( CASTLE_WALL_THREAT_TARGETNAME )
	entity farthestPositionEnt = CreateClientSidePropDynamic( startingPosFar, <0,0,0>, $"mdl/dev/empty_model.rmdl" )
	EmitSoundOnEntity( closestPositionEnt, CASTLE_WALL_BARRIER_ACTIVE_LOOP_SOUND )
	EmitSoundOnEntity( farthestPositionEnt, CASTLE_WALL_BARRIER_ACTIVE_LOOP_SOUND )

	if ( !doClosestPositionActions )
	{
		StopSoundOnEntityByName( closestPositionEnt, CASTLE_WALL_BARRIER_ACTIVE_LOOP_SOUND )
		closestPositionEnt.Hide()
	}

	if ( !doFarthestPositionActions )
	{
		StopSoundOnEntityByName( closestPositionEnt, CASTLE_WALL_BARRIER_ACTIVE_LOOP_SOUND )
		farthestPositionEnt.Hide()
	}

	OnThreadEnd(
		function() : ( closestPositionEnt, farthestPositionEnt, shieldTeam )
		{
			if ( IsValid( closestPositionEnt ) )
			{
				StopSoundOnEntityByName( closestPositionEnt, CASTLE_WALL_BARRIER_ACTIVE_LOOP_SOUND )
				closestPositionEnt.Destroy()
			}

			if ( IsValid( farthestPositionEnt ) )
			{
				StopSoundOnEntityByName( farthestPositionEnt, CASTLE_WALL_BARRIER_ACTIVE_LOOP_SOUND )
				farthestPositionEnt.Destroy()
			}

			if ( shieldTeam in file.castleWallEnts )
			{
				delete file.castleWallEnts[shieldTeam]
			}
		}
	)

	ShowGrenadeArrow( player, closestPositionEnt, warningRadius, 0.0, true, eThreatIndicatorVisibility.INDICATOR_SHOW_TO_ALL, <0, 0, 0>, true )

	while ( Time() < endTime )
	{
		vector ornull newClosestProjection = GetProjectionForCastleThreat( player, shieldTeam, true )
		vector ornull newFarthestProjection = GetProjectionForCastleThreat( player, shieldTeam, false )

		if ( newClosestProjection != null )
		{
			if ( !doClosestPositionActions )
			{
				closestPositionEnt.Show()
				doClosestPositionActions = true
				EmitSoundOnEntity( closestPositionEnt, CASTLE_WALL_BARRIER_ACTIVE_LOOP_SOUND )
			}

			closestPositionEnt.SetOrigin( expect vector ( newClosestProjection ) )
		}
		else
		{
			if ( doClosestPositionActions )
			{
				closestPositionEnt.Hide()
				StopSoundOnEntityByName( closestPositionEnt, CASTLE_WALL_BARRIER_ACTIVE_LOOP_SOUND )
				doClosestPositionActions = false
			}
		}

		if ( newFarthestProjection != null )
		{
			if ( !doFarthestPositionActions )
			{
				farthestPositionEnt.Show()
				doFarthestPositionActions = true
				EmitSoundOnEntity( farthestPositionEnt, CASTLE_WALL_BARRIER_ACTIVE_LOOP_SOUND )
			}

			farthestPositionEnt.SetOrigin( expect vector ( newFarthestProjection ) )
		}
		else
		{
			if ( doFarthestPositionActions )
			{
				farthestPositionEnt.Hide()
				StopSoundOnEntityByName( farthestPositionEnt, CASTLE_WALL_BARRIER_ACTIVE_LOOP_SOUND )
				doFarthestPositionActions = false
			}
		}

		#if DEV
		if ( DEBUG_THREAT_INDICATORS )
		{
			DebugDrawMark( closestPositionEnt.GetOrigin(), 20, COLOR_RED, true, 0.1 )
			DebugDrawMark( farthestPositionEnt.GetOrigin(), 10, COLOR_BLUE, true, 0.1 )
		}
		#endif      

		WaitFrame()
	}
}

vector ornull function GetProjectionForCastleThreat( entity player, int shieldTeam, bool findClosest )
{
	vector ornull bestPos   = null
	float bestDistanceFound = findClosest ? FLT_MAX : 0.0

	if ( ( shieldTeam in file.castleWallEnts ) )
	{
		                
		array<CastleWallThreatIndicatorLine> leftToCenterLines = BuildThreatLines( file.castleWallEnts[shieldTeam].anchorCenter, file.castleWallEnts[shieldTeam].lowWallsLeft, file.castleWallEnts[shieldTeam].anchorLeft )
		                
		array<CastleWallThreatIndicatorLine> centerToRightLines = BuildThreatLines( file.castleWallEnts[shieldTeam].anchorCenter, file.castleWallEnts[shieldTeam].lowWallsRight, file.castleWallEnts[shieldTeam].anchorRight )

		                                                  
		leftToCenterLines.extend( centerToRightLines )

		foreach ( CastleWallThreatIndicatorLine line in leftToCenterLines )
		{
			vector projection = GetClosestPointOnLineSegment( line.startPos, line.endPos, player.EyePosition() )
			float distance = Distance( player.EyePosition(), projection )

			if ( findClosest )
			{
				if ( distance < bestDistanceFound )
				{
					bestPos           = projection
					bestDistanceFound = distance
				}
			}
			else
			{
				if ( distance > bestDistanceFound )
				{
					bestPos           = projection
					bestDistanceFound = distance
				}
			}
		}
	}

	return bestPos
}

array<CastleWallThreatIndicatorLine> function BuildThreatLines( entity startingAnchor, array<entity> middleWalls, entity endingAnchor )
{
	array<CastleWallThreatIndicatorLine> results
	array<entity> allWalls
	const float indicatorForwardOffset = 10.0

	allWalls.append( startingAnchor )
	allWalls.extend( middleWalls )
	allWalls.append( endingAnchor )

	for ( int i = 1; i < allWalls.len(); i++ )
	{
		CastleWallThreatIndicatorLine line
		vector startPos
		vector endPos

		bool validCurrent   = IsValid( allWalls[i] )
		bool validPrevious  = IsValid( allWalls[i - 1] )
		bool validLineFound = false

		if ( validCurrent && validPrevious )
		{
			startPos       = allWalls[i - 1].GetWorldSpaceCenter() + ( allWalls[i - 1].GetForwardVector() * indicatorForwardOffset )
			endPos         = allWalls[i].GetWorldSpaceCenter() + ( allWalls[i].GetForwardVector() * indicatorForwardOffset )
			validLineFound = true
		}
		else if ( validCurrent && !validPrevious )
		{
			startPos       = allWalls[i].GetWorldSpaceCenter() + ( allWalls[i].GetForwardVector() * indicatorForwardOffset )
			endPos         = allWalls[i].GetWorldSpaceCenter() + ( allWalls[i].GetForwardVector() * indicatorForwardOffset )
			validLineFound = true
		}
		else if ( validPrevious && !validCurrent )
		{
			startPos       = allWalls[i - 1].GetWorldSpaceCenter() + ( allWalls[i - 1].GetForwardVector() * indicatorForwardOffset )
			endPos         = allWalls[i - 1].GetWorldSpaceCenter() + ( allWalls[i - 1].GetForwardVector() * indicatorForwardOffset )
			validLineFound = true
		}

		if ( validLineFound )
		{
			line.startPos = startPos
			line.endPos = endPos
			results.append( line )

			#if DEV
			if ( DEBUG_THREAT_INDICATORS )
			{
				 DebugDrawArrow( line.startPos, line.endPos, 10, COLOR_GREEN, true, 0.1 )
			}
			#endif      
		}
	}

	return results
}
#endif         

                                                               
bool function GetArmoredLeapUseReducedEntCount()
{
	return GetCurrentPlaylistVarBool( "newcastle_ult_reduce_ents", true )
}

                                                     
bool function GetArmoredLeapUseCode()
{
	return GetCurrentPlaylistVarBool( "newcastle_ult_code", true )
}

                                                                                                                                                                                                                             
bool function DoAdditionalAirPosChecks()
{
	return GetCurrentPlaylistVarBool( "newcastle_ult_additional_air_pos_checks", true )
}


              