global function VantageCompanion_Init


global function VantageCompanion_GetEnt
global function VantageCompanion_FindAndDisplayOrderPos
global function VantageCompanion_OrderCompanion
global function VantageCompanion_SetPlayerLaunchState
global function VantageCompanion_GetPlayerLaunchState


        
                                           
global function Launch_CalcLaunchToPos
                                       
                                      

#if CLIENT
global function GetVantageTacticalRui
global function CreateVantageTacticalRui_Internal
global function DestroyVantageTacticalRui
#endif

#if SERVER
                                       
                                        


                                                      
                                         
#endif

                                                

        
const asset VANTAGE_COMPANION_MODEL = $"mdl/creatures/echo/echo_base_w.rmdl"
const float VANTAGE_COMPANION_MODEL_SCALE = 1.5

global const string VANTAGE_COMPANION_SCRIPTNAME = "vantage_companion"

        
const string SOUND_COMPANION_RECALL_VOICE = "Vantage_Tac_Echo_Voice_Recall"
const string SOUND_COMPANION_PERCH_VOICE = "Vantage_Tac_Holster"

                                                                                                

     
const FX_COMPANION_TRAIL = $"P_van_tac_echo_trail"
const FX_COMPANION_TRAIL_ENEMY = $"P_van_tac_echo_trail_enemy"
const FX_COMPANION_ORDER_AR_GROUND = $"P_van_tac_echo_AR_ping_ground"
const FX_COMPANION_ORDER_AR_WALL = $"P_van_tac_echo_AR_ping_CP"
const FX_COMPANION_ORDER_AR_CORNER = $"P_van_tac_echo_AR_ping_wall_dir"                                 
const FX_COMPANION_ORDER_AR_CORNER_TOP = $"P_van_tac_echo_AR_ping_wall_top"                                 
const FX_COMPANION_ORDER_AR_AIR = $"P_van_tac_echo_AR_ping_air"


const asset FX_PROJECTILE_DESTROYED = $"P_projectile_melted"

const asset FX_LOC_LINE = $"P_van_tac_echo_AR_line"
const asset FX_LOC_LINE_END = $"P_van_tac_echo_AR_end"

const float COMPANION_AR_MARKER_LIFETIME = 2.0
const float COMPANION_AR_SPEED_THRESHOLD_SQR = 100 * 100
      

              

        
const float LAUNCH_TARGET_UP_OFFSET = -1.75 * METERS_TO_INCHES
const float LAUNCH_TARGET_FWD_OFFSET = 0 * METERS_TO_INCHES
                                       
                                       
                                 
                                 


const float VANTAGE_COMPANION_BASE_SPEED = 800
                                              
                                                                 
const float VANTAGE_COMPANION_ANG_ACCEL_LOW_SPEED = 180        
const float VANTAGE_COMPANION_ANG_ACCEL_MAX_SPEED = 360        

const float VANTAGE_COMPANION_LOW_SPEED_THRESHOLD = 75
const float VANTAGE_COMPANION_SLOW_DOWN_RANGE = 8.0 * METERS_TO_INCHES
const float VANTAGE_COMPANION_CLOSE_TO_DESTINATION_DIST = 12

const float ECHO_ORDER_LEDGE_CHECK_UP = 2.5 * METERS_TO_INCHES
const float ECHO_ORDER_LEDGE_CHECK_BACK = 1 * METERS_TO_INCHES
const float ECHO_ORDER_MIN_HEIGHT = 6 * METERS_TO_INCHES

const vector VANTAGE_COMPANION_BOUND_MINS = <-10, -10, -10>
const vector VANTAGE_COMPANION_BOUND_MAXS = <10, 10, 15>


const float VANTAGE_COMPANION_RANGE_BASE = 40.0 * METERS_TO_INCHES
const float VANTAGE_COMPANION_RANGE_MAX = 55.0 * METERS_TO_INCHES

                                                      
                                                                        
                                                     

const float VANTAGE_COMPANION_PERCHED_RANGE = 60
const float VANTAGE_COMPANION_ICON_FADE_DIST_NEAR = 3 * METERS_TO_INCHES

const float  VANTAGE_COMPANION_GROUND_UI_MIN_DIST = 6 * METERS_TO_INCHES
const float  VANTAGE_COMPANION_GROUND_UI_MIN_DIST_SQR = VANTAGE_COMPANION_GROUND_UI_MIN_DIST * VANTAGE_COMPANION_GROUND_UI_MIN_DIST

const float  VANTAGE_COMPANION_RETREAT_DIST = 3 * METERS_TO_INCHES

const string VANTAGE_COMPANION_USE_PATHFINDING_PLAYLIST_VAR = "vantage_companion_use_pathfinding"
const string VANTAGE_COMPANION_HIGHT_ADJUST_INITIAL_ORDER_PLAYLIST_VAR = "vantage_companion_initial_height_adjust"
const string VANTAGE_COMPANION_ENABLE_SIMPLE_PATHFIND_PLAYLIST_VAR = "vantage_companion_enable_simple_pathfind"
const string VANTAGE_COMPANION_ENABLE_SIMPLE_PATHFIND_COMBAT_PLAYLIST_VAR = "vantage_companion_enable_simple_pathfind_combat"
const string VANTAGE_COMPANION_PATHFIND_DURING_COMBAT_PLAYLIST_VAR = "vantage_companion_pathfind_during_combat"
const string VANTAGE_COMPANION_PATHFIND_MAX_LENGTH_RATIO_PLAYLIST_VAR = "vantage_companion_pathfind_max_ratio"
const string VANTAGE_COMPANION_PATHFIND_MAX_TIME_DIFF_PLAYLIST_VAR = "vantage_companion_pathfind_max_diff"

const string VANTAGE_COMPANION_PATHFINDING_ROUTE_CLEARED_SIGNAL = "vantage_companion_pathfinding_route_cleared"
const float VANTAGE_COMPANION_PATHFINDING_NODE_COMPLETION_DIST = 16

const int VANTAGE_COMPANION_MAX_PATH_LEN = 30
const float VANTAGE_COMPANION_INIT_HEIGHT_OFFSET = 50
const float VANTAGE_COMPANION_FINAL_HEIGHT_OFFSET = -20
const float VANTAGE_COMPANION_ENTER_DOOR_HEIGHT = 70
const float VANTAGE_COMPANION_DOOR_ERROR_RADIUS = 12
const float VANTAGE_COMPANION_NEAR_POINT_DIST = 1.75 * METERS_TO_INCHES
const int VANTAGE_COMPANION_MAX_LOOK_AHEAD = 5

         
global const string VANTAGE_COMPANION_STATE_NETINT = "vantage_companion_state"

                          
             
#if DEV
#if SERVER
                                                      
#endif         
bool VANTAGE_COMPANION_DEBUG_DRAW = false
bool VANTAGE_COMPANION_ORDER_DEBUG_DRAW = false
bool VANTAGE_COMPANION_FOLLOW_DEBUG_DRAW = false
bool VANTAGE_COMPANION_VORTEX_DEBUG_DRAW = false
bool VANTAGE_COMPANION_LAUNCH_DEBUG_DRAW = false
#endif      
global enum eCompanionState
{
	UNKNOWN,
	PERCHED,
	RECALLING,
	ORDERED_TO_POSITION,
	ORDERED_TO_TARGET,
	AT_POSITION,

	COUNT
}

#if DEV
array<string> sCompanionStateStrings =
[
	"Unknown"
	"Perched",
	"Recalling",
	"Ordered to Position",
	"Ordered to Target",
	"At Position"
]
#endif

global enum ePlayerLaunchState
{
	NONE,

	PRELAUNCHING,
	LAUNCHING,
	COUNT
}

#if DEV
array<string> sPlayerLaunchStateStrings =
[
	"None"
	"Prelaunching",
	"Launching"
]
#endif

struct CompanionData
{
	entity companionEnt
	int    playerLaunchState

#if SERVER
	                   
	                            

	                        
	                               
	                   
	                      
	                         
	                     
	                        
	                        
	                                

	                     
	                        
	                          

#endif
}

array<string> sOrderTypeStrings =
[
	"None"
	"GROUND",
	"WALL",
	"AIR",
	"CORNER"
]

enum eOrderType
{
	NONE,

	GROUND,
	WALL,
	AIR,
	CORNER
}

struct OrderPosData
{
	vector orderPos
	vector arPos
	vector arNormal
	vector arPosSecondary
	vector arNormalSecondary
	int		orderType
}

struct
{
	table<entity, CompanionData> companionData

	float TUNING_VANTAGE_COMPANION_RANGE_BASE
	float TUNING_VANTAGE_COMPANION_RANGE_MAX

	var vantageTacticalRui

	int previousLittleHawkState
	float recallStartDistanceTo = 0
} file


void function VantageCompanion_Init()
{
	PrecacheModel( VANTAGE_COMPANION_MODEL )
	PrecacheParticleSystem( FX_COMPANION_TRAIL )
	PrecacheParticleSystem( FX_COMPANION_TRAIL_ENEMY )
	PrecacheParticleSystem( FX_PROJECTILE_DESTROYED )
	PrecacheParticleSystem( FX_COMPANION_ORDER_AR_GROUND )
	PrecacheParticleSystem( FX_COMPANION_ORDER_AR_WALL )
	PrecacheParticleSystem( FX_COMPANION_ORDER_AR_CORNER )
	PrecacheParticleSystem( FX_COMPANION_ORDER_AR_CORNER_TOP )
	PrecacheParticleSystem( FX_COMPANION_ORDER_AR_AIR )

	PrecacheParticleSystem( FX_LOC_LINE )
	PrecacheParticleSystem( FX_LOC_LINE_END )

	RegisterSignal( "EndCompanionLifetime_Signal" )
	RegisterSignal( VANTAGE_COMPANION_PATHFINDING_ROUTE_CLEARED_SIGNAL )

	file.TUNING_VANTAGE_COMPANION_RANGE_BASE = GetCurrentPlaylistVarFloat( "vantage_tactical_base_range", VANTAGE_COMPANION_RANGE_BASE )
	file.TUNING_VANTAGE_COMPANION_RANGE_MAX = GetCurrentPlaylistVarFloat( "vantage_tactical_max_range", VANTAGE_COMPANION_RANGE_MAX )

	#if DEV
	Assert( eCompanionState.COUNT == sCompanionStateStrings.len(), "Must define a string for each state." )
	Assert( ePlayerLaunchState.COUNT == sPlayerLaunchStateStrings.len(), "Must define a string for each state." )
	#endif

	Remote_RegisterServerFunction( "ClientCallback_VantageCompanion_Recall" )
	Remote_RegisterServerFunction( "ClientCallback_SetSendPos", "vector", -FLT_MAX, FLT_MAX, 32 )

	RegisterNetworkedVariable( VANTAGE_COMPANION_STATE_NETINT, SNDC_PLAYER_EXCLUSIVE, SNVT_INT , eCompanionState.UNKNOWN )


#if CLIENT
	AddCreateCallback( "script_mover", VantageCompanion_OnPropScriptCreated )
	RegisterConCommandTriggeredCallback( "+scriptCommand5", AttemptRecallLittleHawk )
	AddCallback_OnWeaponStatusUpdate( VantageCompanion_WeaponStatusCheck )
#endif
}



const float UPDATE_RATE = 0.1


OrderPosData function FindEchoOrderPos( entity player )
{
	OrderPosData orderPosData
#if SERVER
	                                                               
#endif         

	#if DEV
		int devTraces = 0               
	#endif          

	                                
	                                   
	vector startTrace = player.EyePosition()
	vector playerViewVector = player.GetPlayerOrNPCViewVector()
	vector endTrace = startTrace + playerViewVector * file.TUNING_VANTAGE_COMPANION_RANGE_BASE

	TraceResults trInitial = TraceLine( startTrace, endTrace, [ player ], TRACE_MASK_PLAYERSOLID , TRACE_COLLISION_GROUP_PLAYER_MOVEMENT )

	#if DEV
		devTraces++
	#endif          

	vector orderEndPos = trInitial.endPos
	orderPosData.orderPos    = trInitial.endPos
	orderPosData.arPos = trInitial.endPos
	orderPosData.orderType = eOrderType.AIR

	if ( trInitial.fraction < 0.99 )
	{
		float boundsAdj = fabs(VANTAGE_COMPANION_BOUND_MAXS.z)*1.5
		vector startHullTrace = trInitial.endPos + (trInitial.surfaceNormal * boundsAdj) + (playerViewVector * -boundsAdj)

		TraceResults trHull = TraceHull( startHullTrace, trInitial.endPos, VANTAGE_COMPANION_BOUND_MINS*1.5, VANTAGE_COMPANION_BOUND_MAXS*1.5, [ player ], TRACE_MASK_PLAYERSOLID , TRACE_COLLISION_GROUP_PLAYER_MOVEMENT )

		#if DEV
			devTraces++

			if ( VANTAGE_COMPANION_ORDER_DEBUG_DRAW )
			{
				DebugDrawArrow( startHullTrace, trInitial.endPos, 5, COLOR_YELLOW, false, 5.0 )
			}
		#endif          

		if ( trHull.startSolid )
		{
			#if DEV
				if ( VANTAGE_COMPANION_ORDER_DEBUG_DRAW )
				{
					DebugDrawText( startHullTrace, "startsolid (red)", false, 5.0 )
					DebugDrawBox( startHullTrace, VANTAGE_COMPANION_BOUND_MINS, VANTAGE_COMPANION_BOUND_MAXS, COLOR_RED, 1, 5.0 )
				}
			#endif          
			                                      
			TraceResults trInitialHullRedo = TraceHull( startTrace, endTrace, VANTAGE_COMPANION_BOUND_MINS*1.5, VANTAGE_COMPANION_BOUND_MAXS*1.5, [ player ], TRACE_MASK_PLAYERSOLID , TRACE_COLLISION_GROUP_PLAYER_MOVEMENT )

			#if DEV
				devTraces++
			#endif          

			startHullTrace = trInitialHullRedo.endPos + (trInitialHullRedo.surfaceNormal * boundsAdj) + (playerViewVector * -boundsAdj)

			trHull = TraceHull( startHullTrace, trInitialHullRedo.endPos, VANTAGE_COMPANION_BOUND_MINS*1.5, VANTAGE_COMPANION_BOUND_MAXS*1.5, [ player ], TRACE_MASK_PLAYERSOLID , TRACE_COLLISION_GROUP_PLAYER_MOVEMENT )

			#if DEV
				devTraces++

				if ( VANTAGE_COMPANION_ORDER_DEBUG_DRAW )
				{
					DebugDrawArrow( startHullTrace, trInitialHullRedo.endPos, 5, COLOR_ORANGE, false, 5.0 )
				}
			#endif          
		}

		orderPosData.orderPos    = trHull.endPos
		orderPosData.arNormal = trInitial.surfaceNormal
		orderPosData.orderType = eOrderType.GROUND

		float upDot = DotProduct( trInitial.surfaceNormal, UP_VECTOR )
		float upDotAbs  = fabs( upDot )
		bool normalIsFlat = upDotAbs < DOT_45DEGREE

		#if DEV
			if ( VANTAGE_COMPANION_ORDER_DEBUG_DRAW )
			{
				int g = normalIsFlat ? 50 : 255
				int b = normalIsFlat ? 255 : 50
				string normalType = normalIsFlat ? "wall" : ( (upDot > 0) ? "ground" : "ceiling" )
				DebugDrawText( trInitial.endPos, "normal (green): " + normalType, false, 5.0 )
				DebugDrawArrow( trInitial.endPos, trInitial.endPos + (trInitial.surfaceNormal * 30), 5, <0,g,b>, false, 5.0)
			}
		#endif          

		if ( normalIsFlat )
		{
			orderPosData.orderType = eOrderType.WALL
			                                    
			vector flatNormal = FlattenNormalizeVec( trInitial.surfaceNormal )

			                      
			          
			vector traceUpStart = trInitial.endPos + (trInitial.surfaceNormal * ECHO_ORDER_LEDGE_CHECK_BACK / 2.0)
			vector traceUpEnd = traceUpStart + (UP_VECTOR * ECHO_ORDER_LEDGE_CHECK_UP )
			TraceResults trUp = TraceLine( traceUpStart, traceUpEnd, [ player ], TRACE_MASK_PLAYERSOLID , TRACE_COLLISION_GROUP_PLAYER_MOVEMENT )

			#if DEV
				devTraces++

				if ( VANTAGE_COMPANION_ORDER_DEBUG_DRAW )
				{
					DebugDrawArrow( traceUpStart, trUp.endPos, 10, COLOR_ORANGE, false, 5.0 )
				}
			#endif          

			if ( trUp.fraction > 0.99 )
			{

				                       
				             
				vector traceBackStart = trUp.endPos
				vector traceBackEnd = traceBackStart - (flatNormal * ECHO_ORDER_LEDGE_CHECK_BACK * 1.5 )
				TraceResults trBack = TraceLine( traceBackStart, traceBackEnd, [ player ], TRACE_MASK_PLAYERSOLID , TRACE_COLLISION_GROUP_PLAYER_MOVEMENT )

				#if DEV
					devTraces++

					if ( VANTAGE_COMPANION_ORDER_DEBUG_DRAW )
					{
						DebugDrawArrow( traceBackStart, trBack.endPos, 10, COLOR_YELLOW, false, 5.0 )
					}
				#endif          

				if ( trBack.fraction > 0.99 )
				{
					vector ledgeStartTrace = trBack.endPos                                                                                                          
					vector ledgeEndTrace = ledgeStartTrace - (UP_VECTOR * ECHO_ORDER_LEDGE_CHECK_UP * 2)

					                                                                                                                                                
					TraceResults trLedge = TraceHull( ledgeStartTrace, ledgeEndTrace, VANTAGE_COMPANION_BOUND_MINS, VANTAGE_COMPANION_BOUND_MAXS, [ player ], TRACE_MASK_PLAYERSOLID, TRACE_COLLISION_GROUP_PLAYER_MOVEMENT)

					#if DEV
						devTraces++

						if ( VANTAGE_COMPANION_ORDER_DEBUG_DRAW )
						{
							DebugDrawArrow( ledgeStartTrace, ledgeEndTrace, 10, COLOR_LIGHT_GREEN, false, 5.0 )
						}
					#endif          

					if ( !trLedge.startSolid && trLedge.fraction < 0.99 )
					{
						        
						#if DEV
							if ( VANTAGE_COMPANION_ORDER_DEBUG_DRAW )
							{
								DebugDrawText( trLedge.endPos,"CornerPos", false, 5.0 )
								DebugDrawSphere( trLedge.endPos, 8,COLOR_LIGHT_GREEN,false, 5.0 )
							}
						#endif          
						orderPosData.orderPos = trLedge.endPos
						orderPosData.arPosSecondary = trLedge.endPos
						orderPosData.arNormalSecondary = trLedge.surfaceNormal
						orderPosData.orderType = eOrderType.CORNER
					}
				}
			}
		}
	}


	                                 
	                                                                   

	vector adjustedPoint = AdjustCompanionPosForHeight( orderPosData.orderPos )
	float lastPointGroundHeight = orderPosData.orderPos.z
	orderPosData.orderPos  = adjustedPoint

#if SERVER
	                           	                                               
	                                                    
#endif         

	Assert( orderPosData.orderType != eOrderType.NONE, "FindEchoOrderPos: Tried to find a position but orderType was NONE" )

	#if DEV
		if ( VANTAGE_COMPANION_DEBUG_DRAW || VANTAGE_COMPANION_ORDER_DEBUG_DRAW )
		{
			float distanceMeters = Distance( player.GetOrigin(), orderPosData.orderPos ) * INCHES_TO_METERS
			printt( "SENDING ECHO TO " + orderPosData.orderPos + ", " + distanceMeters + "m away. OrderType: " + sOrderTypeStrings[orderPosData.orderType] + " Traces: " + devTraces )
		}
	#endif          

#if SERVER
	                                                                                         
		                   

	                                                  
	                                                                                                                                             
	                                                                                                                                                     

	          
	                                                                             
	 
		                                                                                     
		                                                
		                                                               
		                                                                             
		                                                                                            
		                                                           
		 
			                                                                 
		 
		    
		 
			                                                                  
			                                       
			                                                
			                                           
			                                        
			                                                

			                                                                               
		 
		                   
	 
	
	                                                                  
	                                       
	                                                
	                                           
	                                        
	                                                

	                                               
	                       
	                                                                                                        
	                                           

	                    
	 
		                                                                                                    
			                   

		                                                                                     
		                                                        
	 

	                                                                                                                                                 
	                                                                            
	                           
	 
		                   
	 

	                    
	 
		                                                                                         
		                                                                              
		                                                              
		                                                         

		                                                       
		                                                             

		                                                          
		 
			                                        
			                   
		 

		                                                                                       
		                                                                    
		                                                                             
		                              

		                                                                                
		                                                                                                            
		                                                                                                                                                
		                                                                                                                

		                                                                                                                                                                                                                                              
		                                                                                             
		                                                                        
		                                                                                                   

		                                                  
		                                                               
		                                                                                              
		                                           
		                                                

		                                               
		                                                                         
		                                                              
		                                                                                          

		       
			                                         
			 
				                                                            
				                                                                                  
				                                                                        
			 
		                
		                   
	 

	                                                                                                           
	                                                                                                                
	                                                                                                                            
	 
		                                 
		                                                 
		                                                                

		               
		                            
		                                                      
		 
			                                                                           
		 
		                                          
		 
			                                                                                                    
			 
				                       
				                              
				                                    
				                                                                                                                                                   
				       
					           
				                
				                                  
				 
					                                                                        
					                      
				 
			 
		 
		    
		 
			                                                                                                                                                                     
			                                
			                       
			                                    
			                                                                                                                                          
			       
				           
			                

			                                  
			 
				                                                             

				                                                                                                                                                 
				       
					           
				                

				                                
				 
					                      
					                                                                                                                                   
					                              
					                                                                                               

					                                                                                                                                                

					                                   
					 
						                       
					 
				 
			 
		 

		                      
		 
			                                                  
			                                                               
			                                                                                              
			                                           
			                                                

			                                               
			                                                                         
			                                                              
			                                                                                          

			       
				                                         
				 
					                                                            
					                                                                                  
					                                                                        
				 
			                
			                   
		 
	 

	                               
	 
		                   
	 

	                                                                                                           
	                                         
	                                                                                                                                                                                    
	                                    

	                                                  
	                                                                                                                                                                                    
	                                          

	       
		                                         
		 
			                                                                                    
			                                                                                             
		 
	                

	                                                                                                                                           

	                          
	 
		                   
	 

	                                                              
	 
		                   
	 

	                                                                             
	                                                                                

	                                                                                                                          
	                                                                          
			                   

	                                                                                                                      
	                                                                                                                

	                                                                                       
	                                                           	                            

	       
		                                         
		 
			                                                                                                                                                                            
		 
	                


	                                                                                           
		                   

	       
		                                         
		 
			                                                   
		 
	      

	                                                 
	                                                                     
	                                                

	                           
	                                               
	                                                                 
	 
		                                                      
	 
	                                                                                                  

	                                                                                               
	                                   
	                                                                                          
	                                                                   

	       
		                                         
		 
			                                                                   
			                                    
		 
	      

	                                               
	                                                                         
	                                                              
	                                                                                          

	       
		                                         
		 
			                                
			                                                                   
			                                                                                                              
		 
	                
#endif

	return orderPosData
}

#if SERVER
                                                                                                
 
	                                               
	                             
	                               
	                                                 
	                                                                      
	                             

	                                                                                                                
	                                                                                                                 
	                
	                                                               
	                
	                
	                         
	                    
	                    
	                 
	                                                                     
	 
		                                                 
		                                                         
		                                               
		                                                   

		                                                   
		 
			                                                                               
			                                                  
		 
		                                                       
		 
			                                                                                       
			                                                      
		 

		       
			                                         
			 
				                    
				                                                                               
			 
		                

		                                                 
		                                                     
		                    
		                                                    
		 
			                                                                                                        
			                                                                                                                                  
			                                                                        
			 
				                                                  
				                                                                           
				                                                      
				                                 
				                   
			 
			                                                                             
			 
				                                                      
				                                                                       
				                                                  
				                                 
				                   
			 
			                   
			 
				                                                                                                                                                                                 

				                                   
				 
					                                                  
					                                                      
					                                                                      
					                                                                                                                  
				 
			 
			       
				                                         
				 
					                                                            
					                                                                                  
					                                                                        
				 
			                
		 

		           
	 
 
#endif             

vector function VantageCompanion_FindAndDisplayOrderPos( entity player )
{
	OrderPosData companionOrderData = FindEchoOrderPos( player )

	#if CLIENT
		CreateCompanionARIndicator( player,  companionOrderData )
	#endif


	return companionOrderData.orderPos
}


void function VantageCompanion_OrderCompanion( entity player, bool showAR = true, vector ornull overrideOrderPos = null)
{
	OrderPosData companionOrderData
	if ( overrideOrderPos != null )
	{
		companionOrderData.orderType = eOrderType.GROUND                                                                  
		companionOrderData.orderPos = expect vector(overrideOrderPos)
	}
	else
	{
		companionOrderData = FindEchoOrderPos( player )
	}

	if ( showAR )
	{
		#if CLIENT
			CreateCompanionARIndicator( player, companionOrderData )
		#endif
	}

	#if SERVER
		                                                 
	#endif
}

void function VantageCompanion_SetPlayerLaunchState( entity player, int launchState )
{
	if ( player in file.companionData )
	{
		file.companionData[player].playerLaunchState = launchState
	}
}

int function VantageCompanion_GetPlayerLaunchState( entity player )
{
	if ( player in file.companionData )
	{
		return file.companionData[player].playerLaunchState
	}

	return ePlayerLaunchState.NONE
}

vector function AdjustCompanionPosForHeightSingle( vector proposedHawkPoint )
{
	vector adjustedPoint = proposedHawkPoint

	vector endTracePoint    = proposedHawkPoint + UP_VECTOR * ECHO_ORDER_MIN_HEIGHT

	TraceResults trHullUp = TraceHull( adjustedPoint , endTracePoint , VANTAGE_COMPANION_BOUND_MINS, VANTAGE_COMPANION_BOUND_MAXS, [  ], TRACE_MASK_PLAYERSOLID , TRACE_COLLISION_GROUP_PLAYER_MOVEMENT )

	adjustedPoint = trHullUp.endPos + ( UP_VECTOR * VANTAGE_COMPANION_FINAL_HEIGHT_OFFSET )

	#if DEV
		if ( VANTAGE_COMPANION_ORDER_DEBUG_DRAW )
		{
			float drawTime = 5.0
			vector drawColor = (trHullUp.fraction >= 1.0) ? COLOR_LIGHT_GREEN : COLOR_ORANGE

			                                                                 
			DebugDrawMark( adjustedPoint, 5, COLOR_LIGHT_GREEN, false, drawTime )
			DebugDrawBox( adjustedPoint, VANTAGE_COMPANION_BOUND_MINS, VANTAGE_COMPANION_BOUND_MAXS, drawColor, 1, drawTime )
		}
	#endif          

	return adjustedPoint
}

vector function AdjustCompanionPosForHeight( vector proposedHawkPoint )
{
	vector adjustedPoint = proposedHawkPoint

	bool traceDownHit = false

	                                                
	vector endTracePoint    = proposedHawkPoint - UP_VECTOR * ECHO_ORDER_MIN_HEIGHT
	TraceResults trHullDown = TraceHull( proposedHawkPoint, endTracePoint, VANTAGE_COMPANION_BOUND_MINS, VANTAGE_COMPANION_BOUND_MAXS, [  ], TRACE_MASK_PLAYERSOLID , TRACE_COLLISION_GROUP_PLAYER_MOVEMENT )
	TraceResults trHullUp
	if ( trHullDown.fraction < 1.0 )
	{
		traceDownHit = true

		                                                       
		trHullUp = TraceHull( trHullDown.endPos, trHullDown.endPos + UP_VECTOR * ECHO_ORDER_MIN_HEIGHT, VANTAGE_COMPANION_BOUND_MINS, VANTAGE_COMPANION_BOUND_MAXS, [  ], TRACE_MASK_PLAYERSOLID , TRACE_COLLISION_GROUP_PLAYER_MOVEMENT )

		                                                                                                             
		                                                   
		adjustedPoint = trHullUp.endPos                                                                                                                            
	}

	#if DEV
		if ( VANTAGE_COMPANION_ORDER_DEBUG_DRAW )
		{
			float drawTime = 5.0
			vector drawColor = !traceDownHit ? COLOR_GREEN : COLOR_ORANGE

			if ( !traceDownHit )
			{
				DebugDrawText( trHullDown.endPos, "All Clear",false, drawTime )
				DebugDrawLine( proposedHawkPoint, trHullDown.endPos, drawColor,false, drawTime )
			}
			else
			{

				DebugDrawText( trHullDown.endPos, "Down Hit Something", false, drawTime )
				DebugDrawArrow( proposedHawkPoint, trHullDown.endPos, 3, drawColor,false, drawTime )
				DebugDrawMark( trHullDown.endPos, 3, COLOR_RED, false, drawTime )

				drawColor = (trHullUp.fraction >= 1.0) ? COLOR_LIGHT_GREEN : COLOR_ORANGE

				DebugDrawArrow( trHullDown.endPos, trHullUp.endPos, 3,drawColor, false, drawTime )

				DebugDrawText( adjustedPoint, "Adjusted pos", false, drawTime )
				DebugDrawMark( adjustedPoint, 5, COLOR_LIGHT_GREEN, false, drawTime )
				DebugDrawBox( adjustedPoint, VANTAGE_COMPANION_BOUND_MINS, VANTAGE_COMPANION_BOUND_MAXS, drawColor, 1, drawTime )
			}
		}
	#endif          

	return adjustedPoint
}

void function TestCompanionSendPoint_Thread( entity player, entity companion )
{
	player.EndSignal( "OnDestroy" )
	companion.EndSignal( "OnDestroy" )

	while (true)
	{
		TraceResults tr = TraceLine( player.EyePosition(), player.EyePosition() + player.GetPlayerOrNPCViewVector() * (file.TUNING_VANTAGE_COMPANION_RANGE_BASE - 15) , [ player, companion ], TRACE_MASK_PLAYERSOLID , TRACE_COLLISION_GROUP_PLAYER_MOVEMENT )

		int pointInRange = tr.fraction < 1.0 ? 1 : 0

		entity weapon = player.GetOffhandWeapon( OFFHAND_RIGHT )

		                                                                             
		            
		  	                          
		                 
		  
		                            
		{
			if ( IsValid( weapon ) )
			{
				bool isPredictableEnt = false
				#if CLIENT
				isPredictableEnt = weapon.GetPredictable()
				#endif
				#if SERVER
					                       
				#endif         
				if ( isPredictableEnt )
					weapon.SetScriptInt0( pointInRange )
			}
		}
		WaitFrame()
	}

}


entity function VantageCompanion_GetEnt( entity player )
{
	if ( player in file.companionData )
	{
		return file.companionData[player].companionEnt
	}
	else
	{
		Assert( false, "Player " + player + " not in companionData table" )
	}

	return null
}

const vector DEBUGDRAW_HAWK_COLOR = <0, 100, 255>

void function DebugDrawLittleHawk( entity littleHawk, entity littleHawkMover )
{
	if ( IsValid( littleHawk ) )
	{
		DebugDrawBox( littleHawk.GetOrigin(), VANTAGE_COMPANION_BOUND_MINS, VANTAGE_COMPANION_BOUND_MAXS, <255,150,0>, 0.25, 2*UPDATE_RATE )

		DebugDrawSphere( littleHawk.GetOrigin(), 4, <0, 100, 255>, false, 2*UPDATE_RATE )
		                                                                                     
	}
}

void function VantageCompanion_Recall( entity player )
{
	if ( player.GetPlayerNetInt( VANTAGE_COMPANION_STATE_NETINT ) != eCompanionState.RECALLING && player.GetPlayerNetInt( VANTAGE_COMPANION_STATE_NETINT ) != eCompanionState.PERCHED )
	{
		if ( player in file.companionData )
		{
			#if SERVER
				                                             
				                                                 
				                                                                  
				                                            
				                                                                                                              
			#endif

			#if CLIENT
				if ( player.GetPlayerNetInt( VANTAGE_COMPANION_STATE_NETINT ) != eCompanionState.PERCHED )
				{
					entity weapon = player.GetOffhandWeapon( OFFHAND_EQUIPMENT )

					if ( IsValid( weapon ) && weapon.GetWeaponClassName() == VANTAGE_RECALL_WEAPON_NAME )
					{
						ActivateOffhandWeaponByIndex( OFFHAND_EQUIPMENT )
					}
					                                              
				}

				if ( file.vantageTacticalRui != null )
				{
					entity littleHawk           = file.companionData[player].companionEnt
					float recallStartDistanceTo = Distance( player.GetOrigin(), littleHawk.GetOrigin() )
					var rui                     = file.vantageTacticalRui

					RuiSetFloat( rui, "recallStartDistanceTo", recallStartDistanceTo )
					RuiSetFloat( rui, "recallTransitionTime", Time() )
				}
			#endif
		}
	}
}

              
vector function Launch_CalcLaunchToPos( entity player, entity littleHawk )
{
	vector finalLaunchToPos    = littleHawk.GetOrigin() + <0.0, 0.0, LAUNCH_TARGET_UP_OFFSET>

	vector playerToArrivalPos = finalLaunchToPos - player.GetOrigin()
	finalLaunchToPos += Normalize(FlattenVec( playerToArrivalPos )) * LAUNCH_TARGET_FWD_OFFSET

	return finalLaunchToPos
}

#if SERVER
                                                                         
 
	                                               
		      

	                                         
		      

	                              
 

                                                                     
 
	                                               
		      

	                                 
 
                                                         
 
	                                               
 

                                                      
 
	                                   
	 
		                                                                       
	 
	                               
	                                               

	                                                        
 

                                                       
 
	                                              
 

                                                                      
 
	                             
	                               
	                                                 

	                
	                             
	                     
	                                                               

	                                                                                 

	                                           
	                                                

	                                                              
	                                           

	                                             

	                                            

	                                                           

	            
		                                                         
		 
			                        
			 
				                                                         
					                                                           
			 

			                        
			 
				                
				            
			 

			                           
			 
				                                                                                        
				 
					                                           
				 
				                   
			 

			                              
				                      

			                                 
		 
	 

       
	                                          
      

	                     
	              
	 
		                                  

		                                             
		                                                           
		                                              
		                                               
		                                            

		                                                                       

		                                          

		                  
		                                                                    
		 
			                                 
			                                     
		 
		                                                     
		 
			                                                 
			 
				                                                                                           

				                                                       

				                                                
				                                       

				                                                                                                                 

				                                                         
			 
			    
			 
				                                                      
			 
		 
		                                                       
		 
			                                         
			                                                                                             

			                                       

			                                                               
			                                          

			                                                      
			                                                   

			                                                                     
			 
				                                                                            
				                                                  
			 
		 
		                                                                                               
		 
			                                                     
			                                     
		 
		    
		 
			                       
			                                                     
			                         

			                                                                                            
			 
				                                               
				                                                        
				                                                
				                                                         
				                                                        
				                          
				 
					                                                            
				 

			 

			                                                                                   

			                                                        

			                                                  
			 
				                                       
			 
		 


		                                                                         
		              
		                                                  
		 
			                                               
			                                  
			                   

			                                                          
			                                                                                                                                                                                           
			                           
			 
				       
					                                         
					 
						                                                                         
						                                                          

						                                                                                                   
						 
							                                                                                
						 
					 
				                

				                            
				                                       
				                                           
				                                                                  
			 

			                     
			                                                                                                                         
			                                                     
			 
				                                                                                 
				                        
					     
				               
				                                                      
				                              
				                                                            
				                                                                                   
				                                                          
				 
					     
				 

				                                                                                                 
				                                                         
				                                                                                                                                                           
				                          
				 
					       
						                                         
						 
							                                                                                                      
							                                                        
						 
					                
					     
				 

				       
					                                         
					 
						                                                                                                     
						                                                          
						                                                                                                                   
						                                                                                          
						                                                           
						                                                             
					 
				                

				                                      
				                                         
				                                                

				                                                                                                             
				                                                                                                                                           
				                            
			 

			                                                                                             
			                             
			 
				                                                                                                                                                         

				                                                                                                            
				                                                
				                                                                                                                  
				                                                                      
				 
					                                               
				 

				                                                                                                               
				                                                                                
						                       
						                                                                                                                
				 
					       
						                                         
						 
							                                                                   
							                                                                                                                     
						 
					                

					                                      
					                                         
					                                                
					                                                  
					 
						                                                          

						                                                                                                                    
						                                                                                                                                                          
					 
				 
			 

			                                                   
			 
				                                       

				       
					                                         
					 
						                                                                                                  
						                                                             
					 
				                
			 
		 

		                                                                         
		                                               
		 
			                          
		 

		                          
		                                                                                  


		                          
		                                                                                           
		 
			                
			                                                 
			 
				                                                                                                  
			 
			    
			 
				                                        
			 

			                                              
			                      
			                                    
			                                                           
			                                                         
			 
				                                                                                                                                           
				                             
			 
			                                                                
			 
				                                                                                                                                                                                               
			 
			                                                        
			 
				                  
				                                                  
				 
					                                
					                                                      
					                      
					 
						                                                                                                                                      
					 
					    
					 
						                                                                                                    
					 
					                                                                                                                                                                                           

					                                                                                       
					                              
					 
						                                                                                                                
						                                              
						                                                                                                                          
					 
				 
				    
				 
					                                                                                                                          
				 
			 

			                                                    
			 
				                       
			 
			                                                                                                 
			 
				                                                    
				 
					                       
				 
				    
				 
					                                                                                                                              

					                                     
					 
						                                                                                                                   
					 
				 
			 


			                                          
			                                                                                           
			                                                            
			 
				                                        
			 
			                                                  

			                                                                                                             
			                          

			                   
			                                                                                                 
			                                                            

			                                                                                                                                                                                                            
			                                      

			                                                          
			                                                

			                  
			                          
			 
				                                                                     
			 
			                                                                                                              

			                                                                                    
			                                                                                             

			                                                                                

			                                                                            

			                                       
			                                                               
			 
				                             
			 
			                                        

			                                                             
			 
				                                                            
				 
					                      
					                                           
					                                                                                                                                                                 
					                                                                                    
				 
			 
			    
			 
				                                                    
			 

			                                        
			                                                                     
			                                                                   
			                                                
			                                                                                        

			       
				                    
				                                                                         
				 
					                            
					                                                               

					                                                                                                                      

					                                                                                                                        

					                                                                                                                          
					                           
					 
						                                                                    
						                                                                             
					 

					                                                 
					                                                               

				 

			                            
			      
		 

		                
	 
 

                                                                                                                           
 
	                                                                  
	                                                    

	                   
	                      
	 
		                           
	 

	                                                             
	                                                   

	                  
	                   
	                                                                                
	                 
	 
		                                                                        
		                                                                       

		                                                                  
		                                                           
	 
	    
	 
		                                                                        
		                                      

		                                                                  
		                                     
	 


	                                                                 
	                                                

	                                                                     
	                                                    


	                                                                                                                           
 

                                                                                           
 
	                                                          
		            

	                                  
		           

	                              
		           

	            
 

                                                               
 
	                                                     

	                                                                                  
	                                          
	                                           
	                                           
	                                            
	                                              
	                                             
	                                            
	                                             
	                                             

	                                               
	                                                        
	                                                                      
	                                 
	                              

	                                  
	                                                 

	                             

	                                  
	                                                        

	                                                 
	                                                                                                             
	                                



	                   
 
                                                                                                                                                        
 
	       
		                                          
		 
			                                                         
		 
	                

	                         
		      

	                                           
	                           
		      

	                                              
	                           
		      

	                                                                                  
	                                                 
		      

	                                                 
		      


	                                  
	 
		                                                                  
	 
 

                                                                                                      
 
	                
	                                           

	            
	                          
		      

	                                                                                 

	                                       
	 
		                                                             
				                                                                             
		 
			                                                                                                                                            

			                                                                          
			                                                                                                           
			                                                      
		 
	 
 

                                                                      
 
	                                                     

	              

	                           
		                                                     

 


                                                                                                
 
	                                             
	                             
		      

	                                                                                                                 

	                                        
	 
		                                                         

		                                                       
		                                                                 

		                          
		                                     
		                                      

		                    
			                                                                                   
		                                        
		                                         
		                                                    
		                                               
		              
		                

		                                                                                     
	 
	    
	 
		                               
		                     
		              
		                  
	 

 

                                                                                   
   
  	                                   
  	 
  		                                                     
  		                                                  
  	 
   

                                                                                         
 
	                                   
	 
		                                                          
	 
	    
	 
		                                                              
	 
 

                                     
	        
	          
	           
	          
	            
	          
	        
	         
	          
	          
	           
	           
	           
 

                                                           

                                                                                         
 
	                                           
	                                              
	                                            

	                                          
	                                                                         

	                                              
	                                                           

	                                      
	                        
	 
		                                         
		                                                
	 

	                                                                   

	                                
	                                                                                          

	                                                                  

	                  
	                                       
	 
		                         
						                                                 
						                                               
						                                          

		                                         
		                                                                                                                                                                                                       
		                                                                                                                  

		       
			                                          
			 
				                                        
				                                        
				                                                                                                             
				                                                              
			 
		                
		                             
		 
			                          
			            

			       
				                                          
				 
					                                        
					                                                                             
					                                                          
				 
			                

			     
		 
	 

	       
		                                                    
			                                          
	                

	                                                      

	                 
 


                                                       
 
	                                                       
	                                                          
	                                                             
	  
	                                            
	                                                  
	  
	  
	                                                       

	                                                     
	          
 

                                                       
 
	                                                
	                                  

	                      

	                                
	                                                                                                    
	                                                                                                             

	                                                         

	                                                                                          
	                                                           
	                                 
	                                
	                                     
	                                                            
	                                                                                        
	                          
	                                                            

	                                   
	                                               

	                                          

	                                                                
	                                                                   


	                                                                                                                                                                                                                                                       
	                                 
	                                           
	                                                       

	                             
	                                         

	                                                                                                                                                                                                                                                                  
	                                      
	                                                
	                                                         

	                                  
	                                              

	                           

	                                                    
	                             
	                                         



	                                                                             


	                               

	                                                                                        
	 
		                                                                                             
	 

	                      
 

                                                                                                               
 
	                                

	            
		                                      
		 
			                         
			 
				                     
				                 
			 
			                              
			 
				                          
				                      
			 
		 
	 

	                              
	                                            
	                                                     
	                                                          

	             
	 
		                                                                                                                
		  
		                                               
		 
			                                            
			                                                     
			                                                          
			                         
		 
		                                                     
		 
			                                                     
			                                                       
			                                                         
			                          
		 

		           
	 


 


       
                                                                                               
 
	                          
	                                                                                  
	                            
	                 

	       
	                                                                             
	                                                                    
	                                                                       
	                                                                         

	                           
	                                   

	                                                 
 

                                                                    
 
	                                            
 
      

#endif

                                                                                              
         
#if CLIENT
void function VantageCompanion_WeaponStatusCheck( entity player, var rui, int slot )
{
	if ( !PlayerHasPassive( player, ePassives.PAS_VANTAGE ) )
		return

	switch ( slot )
	{
		case OFFHAND_LEFT:
			entity offhandWeapon = player.GetOffhandWeapon( OFFHAND_LEFT )
			RuiSetBool( rui, "isVisible", false )
			break
	}
}
#endif

#if CLIENT
void function AttemptRecallLittleHawk( entity player )
{
	if ( !IsValid( player ) )
		return

	if ( player != GetLocalViewPlayer() )
		return

	if ( !IsAlive( player ) )
		return

	int playerLaunchState = VantageCompanion_GetPlayerLaunchState( player )
	if ( playerLaunchState != ePlayerLaunchState.NONE )
		return

	Remote_ServerCallFunction( "ClientCallback_VantageCompanion_Recall" )
	VantageCompanion_Recall(player)

}
#endif


#if CLIENT
asset function GetARParticleSystemAsset( int orderType )
{
	asset arAsset = FX_COMPANION_ORDER_AR_GROUND
	switch( orderType )
	{
		case eOrderType.GROUND:
			arAsset = FX_COMPANION_ORDER_AR_GROUND
			break
		case eOrderType.WALL:
			arAsset = FX_COMPANION_ORDER_AR_WALL
			break
		case eOrderType.CORNER:
			arAsset = FX_COMPANION_ORDER_AR_CORNER
			break
		case eOrderType.AIR:
			arAsset = FX_COMPANION_ORDER_AR_AIR
			break
	}

	return arAsset
}
#endif

#if CLIENT
void function CreateCompanionARIndicator( entity player, OrderPosData orderPosData )
{
	               
	asset arAsset = GetARParticleSystemAsset( orderPosData.orderType )
	int arID     = GetParticleSystemIndex( arAsset )

	int fxHandle = StartParticleEffectInWorldWithHandle( arID, orderPosData.arPos, <0, 0, 1> )
	vector endAngles = VectorToAngles( orderPosData.arNormal )
	EffectSetControlPointAngles( fxHandle, 0, endAngles )
	EffectSetControlPointVector( fxHandle, 1, FRIENDLY_COLOR_FX )

	thread DestroyHawkARAfterTime( fxHandle, COMPANION_AR_MARKER_LIFETIME )


	if ( orderPosData.orderType == eOrderType.CORNER )
	{
		vector flatVecToPrimary = FlattenNormalizeVec(orderPosData.arPosSecondary - orderPosData.arPos )
		int arID2     = GetParticleSystemIndex( FX_COMPANION_ORDER_AR_CORNER_TOP )
		int fxHandle2 = StartParticleEffectInWorldWithHandle( arID2, orderPosData.arPosSecondary, <0, 0, 1> )
		vector secToPrimAngles = VectorToAngles( flatVecToPrimary )
		vector secAngles = VectorToAngles( orderPosData.arNormalSecondary )
		vector finalAngles = secAngles + secToPrimAngles
		EffectSetControlPointAngles( fxHandle2, 0, finalAngles )
		EffectSetControlPointVector( fxHandle2, 1, FRIENDLY_COLOR_FX )


		thread DestroyHawkARAfterTime( fxHandle2, COMPANION_AR_MARKER_LIFETIME )
	}


	                                                    
	                                                           
}
#endif

#if CLIENT
void function DestroyEchoAROnProximity( int fxHandle, entity echoEnt, vector pos )
{
	echoEnt.EndSignal( "OnDestroy" )

	OnThreadEnd(
		function() : ( fxHandle )
		{
			if ( !EffectDoesExist( fxHandle ) )
				return

			EffectStop( fxHandle, true, true )
		}
	)

	                                                                     
	while ( true )
	{
		                                                                 
		float echoSpeedSqr = LengthSqr( echoEnt.GetVelocity() )
		if ( echoSpeedSqr <= COMPANION_AR_SPEED_THRESHOLD_SQR )
			break
	}

}
#endif

#if CLIENT
void function DestroyHawkARAfterTime( int fxHandle, float time )
{
	OnThreadEnd(
		function() : ( fxHandle )
		{
			if ( !EffectDoesExist( fxHandle ) )
				return

			EffectStop( fxHandle, false, true )
		}
	)
	wait(time)
}
#endif

#if CLIENT
void function VantageCompanion_OnPropScriptCreated( entity ent )
{
	if ( ent.GetScriptName() == VANTAGE_COMPANION_SCRIPTNAME )
	{
		if ( ent.GetOwner() == GetLocalViewPlayer() )
		{
			CompanionData newData
			newData.companionEnt = ent
			file.companionData[ent.GetOwner()] <- newData
			thread VantageCompanion_CreateHUDMarker( ent )

			thread TestCompanionSendPoint_Thread( ent.GetOwner(), ent )
		}
	}
}
#endif

#if CLIENT
void function VantageCompanion_CreateHUDMarker( entity littleHawk )
{
	EndSignal( littleHawk, "OnDestroy" )
	EndSignal( littleHawk.GetOwner(), "OnDestroy" )

	entity localViewPlayer = GetLocalViewPlayer()

	array<var> ruis

	var rui = CreateCockpitRui( $"ui/echo_screen_marker.rpak", RuiCalculateDistanceSortKey( localViewPlayer.EyePosition(), littleHawk.GetOrigin() ) )
	RuiSetImage( rui, "icon", $"rui/hud/tactical_icons/tactical_vantage" )
	RuiSetBool( rui, "isVisible", true )
	RuiSetBool( rui, "pinToEdge", true )
	RuiSetBool( rui, "showClampArrow", true )
	RuiSetFloat( rui, "distanceFade", VANTAGE_COMPANION_ICON_FADE_DIST_NEAR )
	RuiSetFloat( rui, "prelaunchDuration", 1.4 )

	RuiSetBool( rui, "showIconOnScreen", true )

	RuiSetBool( rui, "adsFade", false )
	RuiTrackFloat3( rui, "pos", littleHawk, RUI_TRACK_POINT_FOLLOW, littleHawk.LookupAttachment( "ORIGIN" ))

	ruis.append(rui)

	array<int> fxs

	entity locLineFXMover
	int locLineFXHandle
	int locEndFXHandle

	locLineFXMover = CreateClientsideScriptMover( $"mdl/dev/empty_model.rmdl", <0, 0, 0>, <0, 0, 0> )
	locLineFXMover.SetParent( littleHawk )

	int arID = GetParticleSystemIndex( FX_LOC_LINE )

	locLineFXHandle = StartParticleEffectOnEntity( locLineFXMover, arID, FX_PATTACH_ABSORIGIN, ATTACHMENTID_INVALID )

	int endID       = GetParticleSystemIndex( FX_LOC_LINE_END )
	locEndFXHandle = StartParticleEffectOnEntity( locLineFXMover, endID, FX_PATTACH_ABSORIGIN, ATTACHMENTID_INVALID )
	                                                                     

	fxs.append(locLineFXHandle)
	fxs.append(locEndFXHandle)


	OnThreadEnd(
		function() : ( ruis , fxs , locLineFXMover)
		{
			foreach( rui in ruis )
				RuiDestroy( rui )

			foreach( fxHandle in fxs )
			{
				if ( EffectDoesExist( fxHandle ) )
					EffectStop( fxHandle, true, true )
			}

			if ( IsValid(locLineFXMover) )
				locLineFXMover.Destroy()
		}
	)

	while( true )
	{
		entity vantagePlayer = littleHawk.GetOwner()
		if( IsValid( vantagePlayer ) )
		{
			if ( vantagePlayer in file.companionData )
			{
				int littleHawkState = vantagePlayer.GetPlayerNetInt( VANTAGE_COMPANION_STATE_NETINT )
				int playerLaunchState = VantageCompanion_GetPlayerLaunchState( vantagePlayer )

				                  
				entity hawkTacWeapon = vantagePlayer.GetOffhandWeapon( OFFHAND_TACTICAL )
				bool hasAmmo = false
				if ( IsValid( hawkTacWeapon) )
				{
					hasAmmo = hawkTacWeapon.GetWeaponPrimaryClipCount() >= hawkTacWeapon.GetAmmoPerShot()

					RuiSetBool( rui, "hasAmmo", hasAmmo )
				}

				int canLaunchResult = CanLaunchToCompanion( vantagePlayer, littleHawk )
				bool canLaunch = canLaunchResult == eCanLaunchResult.SUCCESS
				RuiSetBool( rui, "canLaunch", canLaunch )
				RuiSetInt( rui, "launchState", playerLaunchState )

				RuiSetInt( rui, "companionState", littleHawkState )


				#if DEV
				if ( VANTAGE_COMPANION_DEBUG_DRAW )
				{
					vector color = <0, 200, 50>
					string text = "CLIENT"
					       
					text += "\nCompanion state: " + sCompanionStateStrings[littleHawkState]
					text += "\nLaunch state: " + sPlayerLaunchStateStrings[playerLaunchState]

					DebugScreenTextWithColor( 0.7, 0.7, text, color )
				}
				#endif

				UpdateLocLineFX( littleHawk, locLineFXHandle, locEndFXHandle )

				float distanceSqr  = DistanceSqr( littleHawk.GetOrigin(),  vantagePlayer.GetOrigin() )

				bool shouldShowLocFX = littleHawkState != eCompanionState.PERCHED && ( distanceSqr > VANTAGE_COMPANION_GROUND_UI_MIN_DIST_SQR )
				if ( shouldShowLocFX )
				{
					locLineFXMover.Show()
				}
				else
				{
					locLineFXMover.Hide()
				}

				              
				if( file.vantageTacticalRui != null )
				{
					RuiSetInt( file.vantageTacticalRui, "companionState", littleHawkState )

					float distanceTo = Distance( vantagePlayer.GetOrigin(), littleHawk.GetOrigin() )
					RuiSetFloat( file.vantageTacticalRui, "distanceTo", distanceTo )

					if( file.previousLittleHawkState <= eCompanionState.PERCHED && littleHawkState >= eCompanionState.ORDERED_TO_POSITION )
					{
						RuiSetFloat( file.vantageTacticalRui, "orderedTransitionTime", Time() )
					}
				}

				const bool DEBUG_VISIBILITY = false
				if ( DEBUG_VISIBILITY )
				{
					if ( canLaunchResult == eCanLaunchResult.SUCCESS )
					{
						DebugDrawSphere( littleHawk.GetOrigin(), 10, <0, 255,50>, true, 0.1)
					}
					else
					{
						DebugDrawSphere( littleHawk.GetOrigin(), 7, <255, 50,0>, true, 0.1)
						string cantLaunchText = "FAIL"
						if ( canLaunchResult == eCanLaunchResult.NO_OFF_SCREEN )
							cantLaunchText = "OffScreen"
						else if ( canLaunchResult == eCanLaunchResult.NO_LOS_FAIL )
							cantLaunchText = "No LOS"
						else if ( canLaunchResult == eCanLaunchResult.PLAYER_STATE )
							cantLaunchText = "Player State"
						DebugDrawText( littleHawk.GetOrigin(), cantLaunchText,false, 0.1 )
					}

				}
				file.previousLittleHawkState = littleHawkState
			}
		}
		WaitFrame()
	}
}
#endif

#if CLIENT
void function UpdateLocLineFX( entity littleHawk, int lineHandle, int endHandle )
{
	const float TRACE_DIST = 10000
	vector startTrace = littleHawk.GetOrigin()
	vector endTrace = littleHawk.GetOrigin() - UP_VECTOR*TRACE_DIST
	TraceResults tr = TraceLine( startTrace, endTrace , [],TRACE_MASK_PLAYERSOLID_BRUSHONLY, TRACE_COLLISION_GROUP_NONE )

	float endTime = Distance( startTrace, tr.endPos )

	float gravity = GetConVarFloat( "sv_gravity" )
	vector gravityVector = < 0,0,0>
	vector endTimeVector = < 1, 9999,9999 >
	vector offsetVector = ZERO_VECTOR

	                                                                                                  
	if ( EffectDoesExist( lineHandle ) )
	{
		EffectWake( lineHandle )

		                                                   
		                                
		EffectSetControlPointVector( lineHandle, 1, littleHawk.GetOrigin() )
		EffectSetControlPointVector( lineHandle, 0, tr.endPos )
		                                                   

		                          
		                                           
		                                                                      
		                                                                 

		EffectSetControlPointVector( lineHandle, 2, offsetVector )
		  
		EffectSetControlPointVector( lineHandle, 3, gravityVector )                                                                                        
		                                                                       
		EffectSetControlPointVector( lineHandle, 5, ZERO_VECTOR )                                                                                           
		EffectSetControlPointVector( lineHandle, 6, endTimeVector )                                                                                                     
		EffectSetControlPointVector( lineHandle, 7, -UP_VECTOR * endTime )                                  
		                                   
	}


	                               
	   
	  	                                            
	  	                                                    
	   

	if ( EffectDoesExist( endHandle ) )
	{
		EffectWake( endHandle )
		EffectSetControlPointVector( endHandle, 0, tr.endPos )
		                                                        

		vector endAngles = VectorToAngles( tr.surfaceNormal )
		EffectSetControlPointAngles( endHandle, 0, endAngles )
	}

}
#endif

#if CLIENT
var function GetVantageTacticalRui()
{
	return file.vantageTacticalRui
}
#endif

#if CLIENT
void function CreateVantageTacticalRui_Internal()
{
	if( file.vantageTacticalRui == null )
	{
		file.vantageTacticalRui = CreateCockpitPostFXRui( $"ui/vantage_companion_tactical.rpak", HUD_Z_BASE )
	}

	UpdateVantageTacticalRui()
}
#endif

#if CLIENT
void function UpdateVantageTacticalRui()
{
	entity localViewPlayer = GetLocalViewPlayer()
	var rui = file.vantageTacticalRui
	if ( IsValid( localViewPlayer ) )
	{
		                                                                                                                                                     
		RuiTrackFloat( rui, "bleedoutEndTime", localViewPlayer, RUI_TRACK_SCRIPT_NETWORK_VAR, GetNetworkedVariableIndex( "bleedoutEndTime" ) )
		RuiTrackFloat( rui, "reviveEndTime", localViewPlayer, RUI_TRACK_SCRIPT_NETWORK_VAR, GetNetworkedVariableIndex( "reviveEndTime" ) )

		entity offhandWeapon = localViewPlayer.GetOffhandWeapon( OFFHAND_TACTICAL )
		if ( IsValid( offhandWeapon ) )
		{
			RuiTrackFloat( rui, "stockAmmoFrac", offhandWeapon, RUI_TRACK_WEAPON_REMAINING_AMMO_FRACTION )
			RuiTrackFloat( rui, "clipAmmoFrac", offhandWeapon, RUI_TRACK_WEAPON_CLIP_AMMO_FRACTION )
			RuiTrackFloat( rui, "maxMagAmmo", offhandWeapon, RUI_TRACK_WEAPON_CLIP_AMMO_MAX )
			RuiTrackFloat( rui, "maxAmmo", offhandWeapon, RUI_TRACK_WEAPON_AMMO_MAX )
			RuiTrackFloat( rui, "regenAmmoRate", offhandWeapon, RUI_TRACK_WEAPON_AMMO_REGEN_RATE )

			int maxAmmoReady  = offhandWeapon.GetWeaponSettingInt( eWeaponVar.ammo_clip_size )
			int ammoPerShot   = offhandWeapon.GetWeaponSettingInt( eWeaponVar.ammo_per_shot )
			int ammoMinToFire = offhandWeapon.GetWeaponSettingInt( eWeaponVar.ammo_min_to_fire )

			if ( maxAmmoReady == 0 )
				maxAmmoReady = 1

			RuiSetFloat( rui, "minFireFrac", float( ammoMinToFire ) / float( maxAmmoReady ) )
			RuiSetInt( rui, "ammoMinToFire", ammoMinToFire )

			if ( ammoPerShot == 0 )
				ammoPerShot = 1

			RuiSetInt( rui, "segments", maxAmmoReady / ammoPerShot )
			RuiTrackFloat( rui, "chargeFrac", offhandWeapon, RUI_TRACK_WEAPON_CLIP_AMMO_FRACTION )
			RuiTrackFloat( rui, "refillRate", offhandWeapon, RUI_TRACK_WEAPON_AMMO_REGEN_RATE )
			RuiTrackFloat( rui, "readyFrac", offhandWeapon, RUI_TRACK_WEAPON_READY_TO_FIRE_FRACTION )
		}

                 
			if ( StatusEffect_GetSeverity( localViewPlayer, eStatusEffect.is_boxing ) )
				RuiSetBool( file.vantageTacticalRui, "isBoxing", true )
			else
				RuiSetBool( file.vantageTacticalRui, "isBoxing", false )
        
	}
}
#endif

#if CLIENT
void function DestroyVantageTacticalRui()
{
	if ( file.vantageTacticalRui != null )
	{
		RuiDestroy( file.vantageTacticalRui )
		file.vantageTacticalRui = null
	}
}
#endif