global function MpWeaponEchoLocator_Init
global function OnWeaponTossReleaseAnimEvent_WeaponEchoLocator
global function OnWeaponTossPrep_WeaponEchoLocator
global function OnWeaponDeactivate_WeaponEchoLocator
                            
          
                                                   
                                                      
               
                                 

const int ECHO_LOCATOR_RADIUS_SCRIPT = 1350
const int ECHO_LOCATOR_HP = 125
const int ECHO_LOCATOR_MAX_FOOTSTEP_TARGETS_TO_SHOW = 12                                                                  
int COCKPIT_ECHO_LOCATOR_SCREEN_FX

const float TICK_RATE = 0.1
const float SPRINT_FX_WAIT_TIME = 0.15
const float JOG_FX_WAIT_TIME = 0.25
const float WEAPON_FIRE_FX_MIN_WAIT_TIME = 0.15
const float CROUCH_WALK_SPEED = 100
const float MAX_SPRINT_SPEED = 300.0
const float ECHO_LOCATOR_DEPLOY_DELAY = 0.4
const float ECHO_LOCATOR_DEPLOY_CLIENT_DELAY = 1.25
const float ECHO_LOCATOR_AMBIENT_SOUND_RADIUS = 3000
const float INITIAL_IDLE_ANIMATION_PERCENTAGE = 0.95
const float ECHO_LOCATOR_INITIAL_MARKER_DURATION = 1.25
const float LOCK_FX_RESET_TIME = 3.0
const float LOCK_FX_DEBOUNCE_TIME = 0.75
const float MINIMAP_MARKER_DEBOUNCE_TIME = 0.75
const float LOCK_FX_LIFETIME = 1.25
const float TOTAL_FIRE_TIME_BUFFER = 1.75
const float ECHO_LOCATOR_TUNING_DEATHFIELD_DAMAGE_SCALAR = 1.0

const asset ECHO_LOCATOR_HEART_MODEL = $"mdl/props/pariah_heart/pariah_heart.rmdl"
const asset DRONE_CLUSTER_MODEL = $"mdl/props/pariah_drone_cluster/pariah_drone_cluster.rmdl"
const asset KILL_ROOM_VIEW_FX = $"P_killroom_hud_static"
const asset ECHO_LOCATOR_VISUAL_FOOT_PING = $"P_killroom_ground_ping_CP"                              
const asset ECHO_LOCATOR_VISUAL_FOOT_PING_AI = $"P_killroom_ground_ping_CP_AI"
const asset ECHO_LOCATOR_HEART_1P_FX = $"P_killroom_heart_hold"                           
const asset ECHO_LOCATOR_HEART_3P_FX = $"P_killroom_heart_hold_3p"                           
const asset ECHO_LOCATOR_SCAN_FX = $"P_killroom_radius_init"
const asset ECHO_LOCATOR_DESTRUCTION_FX = $"P_killroom_exp"                          
const asset ECHO_LOCATOR_RADIUS_FX = $"P_killroom_radius_marker"
const asset ECHO_LOCATOR_HEART_FX = $"P_killroom_heart"
const asset ECHO_LOCATOR_HEART_ENEMY_FX = $"P_killroom_heart_enemy"
const asset ECHO_LOCATOR_TARGET_NON_ANIMATED = $"P_killroom_lockon_no_intro"
const asset ECHO_LOCATOR_TARGET_ANIMATED = $"P_killroom_lockon"
const asset ECHO_LOCATOR_DRONE_CLUSTER_FX = $"P_killroom_heart_drone_cluster"                                                                     

const string ECHO_LOCATOR_THRESHOLD_SOUND = "Seer_Ultimate_Threshold"
const string ECHO_LOCATOR_AMBIENT_SOUND = "Seer_Ultimate_Dome_And_Center"
const string ECHO_LOCATOR_MOVEMENT_REVEALED_1P = "Seer_Ultimate_StatusEffect_Loop_1P"
const string ECHO_LOCATOR_SPHERE_ENDING = "Seer_Ultimate_Dome_Ending_1p"
const string ECHO_LOCATOR_AMBIENT_LOOP_START = "Seer_Ultimate_Dome_Perimeter_Start"
const string ECHO_LOCATOR_AMBIENT_LOOP = "Seer_Ultimate_Dome_Perimeter"
const string ECHO_LOCATOR_AMBIENT_LOOP_ENDING = "Seer_Ultimate_Dome_Perimeter_Ending"
const string ECHO_LOCATOR_TARGET_ACQUIRED_SOUND = "Seer_AcquireTarget_1P"

global const string ECHO_LOCATOR_SCRIPT_NAME = "echo_locator_script"
global const string ECHO_LOCATOR_TARGET_NAME = "echo_locator_target"
const string ECHO_LOCATOR_DESTRUCTION_SOUND = "Seer_Ultimate_Dome_Destroy"
const string ECHO_LOCATOR_PLAYER_HAS_MOVEMENT_INPUT_NETVAR = "echoLocatorPlayerHasMovementInput"

#if DEV
const bool ECHO_LOCATOR_DEBUG = false
#endif      

struct lastPingData
{
	entity victim
	float time
}

struct lockFXData
{
	int  fxHandle
	bool initialLock
}

struct weaponCheckData
{
	bool checkPassed
	float totalFireTime
}

struct insideEchoLocatorStateData
{
	int insideState
	int numEnemies
}

struct aiVelocityData
{
	float time
	vector origin
	float speed
}

enum eInsideEchoLocatorState
{
	INSIDE_NONE,
	INSIDE_ALLIED,
	INSIDE_ENEMY,
	_count
}

struct
{
	array<entity> echoLocators
	int echoLocatorRadius
	int echoLocatorRadiusSqr
	int echoLocatorHP
	float echoLocatorSphereModelScale
	#if CLIENT
	array<entity> playersInsideEchoLocators
	table<entity, int> enemiesInsideEchoLocator
	table<entity, var> echoLocatorRui
	float echoLocatorDuration
	table<entity, aiVelocityData> aiVelocity
	#endif         
	#if SERVER
	                                             
	                                                      
	                                                             
	#endif         
} file

                                                                                                                       
              
                                                                                                                       
void function MpWeaponEchoLocator_Init()
{
	COCKPIT_ECHO_LOCATOR_SCREEN_FX = PrecacheParticleSystem( KILL_ROOM_VIEW_FX )
	PrecacheModel( ECHO_LOCATOR_HEART_MODEL )
	PrecacheParticleSystem( ECHO_LOCATOR_VISUAL_FOOT_PING )
	PrecacheParticleSystem( ECHO_LOCATOR_VISUAL_FOOT_PING_AI )
	PrecacheParticleSystem( ECHO_LOCATOR_SCAN_FX )
	PrecacheParticleSystem( ECHO_LOCATOR_DESTRUCTION_FX )
	PrecacheParticleSystem( ECHO_LOCATOR_RADIUS_FX )
	PrecacheParticleSystem( ECHO_LOCATOR_HEART_1P_FX )
	PrecacheParticleSystem( ECHO_LOCATOR_HEART_3P_FX )
	PrecacheParticleSystem( ECHO_LOCATOR_HEART_FX )
	PrecacheParticleSystem( ECHO_LOCATOR_HEART_ENEMY_FX )
	PrecacheParticleSystem( ECHO_LOCATOR_TARGET_ANIMATED )
	PrecacheParticleSystem( ECHO_LOCATOR_TARGET_NON_ANIMATED )
	PrecacheParticleSystem( ECHO_LOCATOR_DRONE_CLUSTER_FX )
	PrecacheModel( DRONE_CLUSTER_MODEL )

	RegisterSignal( "EchoLocator_Exit" )
	RegisterSignal( "EchoLocatorShuttingDown" )

	RegisterNetworkedVariable( ECHO_LOCATOR_PLAYER_HAS_MOVEMENT_INPUT_NETVAR, SNDC_PLAYER_GLOBAL, SNVT_BOOL )

	file.echoLocatorRadius           = GetEchoLocatorRadius()
	file.echoLocatorRadiusSqr        = int( pow( file.echoLocatorRadius, 2 ) )
	file.echoLocatorSphereModelScale = file.echoLocatorRadius / 1050.0                                                                          
	file.echoLocatorHP 		 = GetEchoLocatorHP()

	#if CLIENT
		StatusEffect_RegisterEnabledCallback( eStatusEffect.inside_echo_locator, EchoLocator_StartVisualEffect )
		StatusEffect_RegisterDisabledCallback( eStatusEffect.inside_echo_locator, EchoLocator_StopVisualEffect )
		AddCreateCallback( "script_mover", OnClientEchoLocationChamberCreated )
		AddCreateCallback( PLAYER_WAYPOINT_CLASSNAME, OnWaypointCreated )

		file.echoLocatorDuration = GetWeaponInfoFileKeyField_GlobalFloat( "mp_ability_echo_locator", "fire_duration" )
	#endif         

	#if SERVER
		                                     
		                                                                                           
	#endif         
}

                                                                                                                       
                
                                                                                                                       
var function OnWeaponTossReleaseAnimEvent_WeaponEchoLocator( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	int ammoReq = weapon.GetAmmoPerShot()
	weapon.EmitWeaponSound_1p3p( GetGrenadeThrowSound_1p( weapon ), GetGrenadeThrowSound_3p( weapon ) )

	entity deployable = ThrowDeployable( weapon, attackParams, 1.0, OnEchoLocatorPlanted, null, <0, 0, 850> )
	if ( deployable )
	{
		entity player = weapon.GetWeaponOwner()
		PlayerUsedOffhand( player, weapon, true, deployable )

		#if SERVER
		                                                  
		                                 
		                                      

		                                                            
		                            
			                                                

		                                         

		                                                
		#endif         
	}

	return ammoReq
}

void function OnWeaponTossPrep_WeaponEchoLocator( entity weapon, WeaponTossPrepParams prepParams )
{
	                                      
	                                     
	weapon.PlayWeaponEffect( ECHO_LOCATOR_HEART_1P_FX, ECHO_LOCATOR_HEART_3P_FX, "muzzle_flash" )

	weapon.EmitWeaponSound_1p3p( GetGrenadeDeploySound_1p( weapon ), GetGrenadeDeploySound_3p( weapon ) )
}

void function OnWeaponDeactivate_WeaponEchoLocator( entity weapon )
{
	weapon.StopWeaponEffect( ECHO_LOCATOR_HEART_1P_FX, ECHO_LOCATOR_HEART_3P_FX )
}

                                                                                                                       
                  
                                                                                                                       
#if SERVER
                                                                                                                                                                   
                                                                
 
	                                               
	                                 
	                                   

	            
		                            
		 
			                                                                                                                                                             
			                                                                                                                                                
			                                                                               
			 
				                                        
			 
		 
	 

	             
 
#endif         

void function OnEchoLocatorPlanted( entity projectile, DeployableCollisionParams collisionParams )
{
	#if SERVER
		                               

		                                    

		                        
		 
			                    
			      
		 

		                                      

		                                    
		                                                  
		                                             
		                 

		                                                                                                                                            

		                                         
		                        

		                       
		 
			                                                                                                                               
		 

		                                      
		                                              
		                                                                                       

		                                                               
		                                          
		                                      
		                                                   
		                                     
		                            
		                                        
		                                  
		                               
		                                      
		                                                                   
		                                 
		                                                 
		                                                     
		                                  
		                    
		                                       
		                                
		                                              
		                                           
		                                           
		                                          
		                                         
		                                          
		                                        
		                                              
		                                         
		                            
		                                  
		                                                                                      
		                                                                
		                                                                        
		                                                              
		                                      

		                            

		                                                                   
		                                                                                                  
		                                           
		                                              
		                                                             
		                                                                                 
		                                                  
		                                                           
		                                                 
		                                                                                      
		                                                                               

		                                                                                           
		                                                                                                               
		                                                                                                                

		                                 

                     
		                                             
        

		                                             

		                             
		                                        

		                                                          

		                       
		 
			                                                  
		 

		                                                                                                                            
		 
			                                           
		 
		                                
		 
			                                  
		 

		                                                                            
	#endif         
}

#if SERVER
                                                                        
 
	                                     

	             
	 
		                                      

		                                                                                             
		                                                                                                                        
		                      
		 
			                                                                                                                                                      
			                                                                                                                                                              
		 

                                
                                                                                                                                   
                                                                                                                                         
    
                                                                                                                                                          
                                                                                                                                                                                     
    
        
	 
 

                                                                        
 
	                                                       
	                                                        

	                              
		      

	                           
		      

	                            
		      

	                                           
	                                        

	                                                                                                 
		      

	                                                                               

	                                                                               
	 
		                                                           
		 
			                                     
			      
		 

                                
                                                             
                                                                                 
    
                                         
          
    
        
	 

	                                                              
	                                                    

	                                                                                 
	 
		                                                       
		                                                 
	 

	                                                              
		                                                                        
 

                                                                            
 
	                                                       
	                                                        
	                                                      

	                              
		      

	                           
		      

	                            
		      

	                                           
	                                        

	                                                                                                 
		      

	                                                              
	                                                    
	                  
		      

	                                                                   

	                                                          
	 
		                           
			                                                         


		                                                                                                                                   
		                                                                                            
		                                                                                                                            
	 

	                                          
	                                       

	                                              

	                           
	 
		                                                                                                                                                               
	 

	                                  
 

                                                                       
 
	                                                                                                                 
	                                                            
	                                                            
	                                                                                                                                     

	                                                                         
	                                         
 

                                                              
 
	                                                                         
	                                           
	                             
	 
		                                                                        
		                                
		 
			                                                                                                                                                           
			                                             
		 
	 
 

                                                                                                       
 
	                                               
	                                  
	                                    

	                                     

	                        
	 
		                     
		      
	 
	                               
	                                                 

	                                                       
	                               

	                                                 

	                                   
	                                    

	                

	                                                                                                    
	                       
	 
		                                                                                                                                        
		                                                         
		                           
	 

	            
		                                                           
		 
			                    
				            

			                                                    
			 
				                                                                         

				                            
				 
					                                                          
				 

				                                                  
			 

			                             
			 
				                                               
			 
			                                    
			 
				                            
			 
		 
	 

	                                                  

	                                                                           

	                                                                                                                                                                                                          
	                                    
	                                                               

	                                                                                                                                                                                                               
	                                   
	                                                           

	                                                                                                                                                                                                     

	                              

	                                                                          
	
	                                                                   
	                                                                  
	                                                               

	             
 

                                                                                                          
 
	                                               
	                                    

	                                                                                                                                 
	                                                                                                                                  

	                                                                    
	                                                                     

	       
	                         
	 
		                                                                                             
	 
	            

	                                        
	                                         

	                                                                   
	                                                                 

	                                           
	                                            

	                                                                                                      
	                                                                                                        

 

                                                                                                                                             
 
	                                               
	                                    
	                                                  
	                                     

	                                         

	                                                                    
	                                                    

	            
		                             
		 
			                              
			 
				                                                                                                                                                                           
				                                                       
			 
		 
	 

	                                                                   
	                                

	                                                                                                            
	                                      

	                    

	                                                                     

	                      
 

                                                                     
 
	                                               
	                                     

	                                                                 
	                                
	                      
 


                                                                                            
 
	                                                           
	 
		                                                          
		                  
		 
			                                                  
		 
	 

	                                            

	                                                                                                                                                                         
	                                                                                               
 

                                                              
 
	                                               
	                                   

	                                                            
	                              
	                                                           
 

                                                             
 
	                                               
	                                    

	                                               

	                                                         
	                               
	                                            
	                                      
 

                                                                   
 
	                                      
		      

	                     
		      

	                                                        
 

                                                                             
 
	                                               
	                                 
	                             
	                           
	
	       
	                                                                  
	
	                         
	 
		                                                                       
	 
	            

	                                               
	                                     

	                      
		      

	                                                                                   
		      

	                                      
		      

	                                      
	                                    

	                                                                    

	                                    
	 
		                                                    
		 
			                                                                   
			 
				                                                         
			 
		 
	 

	            
		                             
		 
			                     
			 
				       
				                                                                  
				                         
				 
					                                                                                                           
				 
				            

				                                                             
				 
					       
						                         
						 
							                                                                                                                          
						 
					            
					                                                               
				 

				                                                    
				 
					                                                                                  
					 
						       
						                         
						 
							                                                                                
						 
						            
						                                                                    
						                                
					 
				 

				                     
				 
					                                                                            
				 
			 
		 
	 

	                                                
	 
		                          
		                                                  
	 

	                                  
	 
		                      
		 
			      
		 

		                                                                       

		                                              
		 
			                                                                                   
			 
				       
					                         
					 
						                                                    
					 
				            
				                                                                      
			 
			                                                              
			 
				       
				                         
				 
					                                                                                                                      
				 
				            

				                                                    

				                                                                               
				 
					                            
					 
						                                       
					 
				 
			 

			                     
			 
				                                                                                                   
				                                                                                                  
			 
		 

		    
		 
			                                                                               
			 
				                            
				 
					                                 
				 
			 

			                                           
			 
				                                                             
				 
					       
					                         
					 
						                                                                                                                          
					 
					            
					                                                               
				 
			 

			                                                    
			 
				                                                                                  
				 
					
					       
					                         
					 
						                                                                                                                        
					 
					            
					                                                                    
					                                
				 
			 

			                     
			 
				                                                                            
			 
		 

		              
	 

 
#endif         
                                                                                                                       
                
                                                                                                                       
#if SERVER
                                                                                            
 
	                                               
	                                   

	                                      
	                                               
	                                   
	                        
	                        

	                                                                                  
	                             
	                                             
	                              
	                               
	                        
	                                   
	                                      
	                                        

	                                                   
	                                                                                              

	                                                   


	                                 

	            
		                                     
		 
			                                                 
			 
				                                               
			 

			                         
				                 
		 
	 

	             
 
#endif         

#if SERVER
                                                                      
 
	                                       

	                                                       
 
#endif         

void function EchoLocationChamberMonitor_Thread( entity echoLocator )
{
	Assert( IsNewThread(), "Must be threaded off" )
	echoLocator.EndSignal( "OnDestroy" )
	echoLocator.EndSignal( "OnDeath" )

	OnThreadEnd(
		function () : ( echoLocator )
		{
			if ( file.echoLocators.contains( echoLocator ) )
			{
				file.echoLocators.removebyvalue( echoLocator )
			}
		}
	)

	WaitForever()
}

#if CLIENT
void function OnClientEchoLocationChamberCreated( entity echoLocator )
{
	if ( echoLocator.GetScriptName() != ECHO_LOCATOR_SCRIPT_NAME )
		return

	thread ClientEchoLocatorManager_Thread( echoLocator )
}

void function OnWaypointCreated( entity wp )
{
	int wpType = wp.GetWaypointType()
	entity localViewPlayer = GetLocalViewPlayer()

	if ( Waypoint_GetPingTypeForWaypoint( wp ) == ePingType.ABILITY_ECHO_LOCATOR )
	{
		entity echoLocator = GetPingedEntForLocWaypoint( wp )

		if ( IsValid( echoLocator ) )
		{
			if ( IsFriendlyTeam( wp.GetTeam(), localViewPlayer.GetTeam() ) || echoLocator.GetBossPlayer() == localViewPlayer )
			{
				thread UpdateWayPointEnemyCount_Thread( wp )
			}
		}
	}
}

void function UpdateWayPointEnemyCount_Thread( entity waypoint )
{
	Assert( IsNewThread(), "Must be threaded off" )
	waypoint.EndSignal( "OnDestroy" )


	entity echoLocator = GetPingedEntForLocWaypoint( waypoint )

	while ( true )
	{
		if ( IsValid( waypoint.wp.ruiHud ) )
		{
			int enemiesInside = 0

			if ( IsValid( echoLocator ) )
			{
				enemiesInside = GetEnemyCountInsideEchoLocator( echoLocator )

				entity localViewPlayer = GetLocalViewPlayer()
				if ( IsValid( localViewPlayer ) )
				{
					if ( IsFriendlyTeam( localViewPlayer.GetTeam(), echoLocator.GetTeam() ) || echoLocator.GetBossPlayer() == localViewPlayer )
					{
						if ( IsPlayerInsideEchoLocator( localViewPlayer, echoLocator ) )
						{
							RuiSetBool( waypoint.wp.ruiHud, "isHidden", true )
						}
						else
						{
							RuiSetBool( waypoint.wp.ruiHud, "isHidden", false )
						}
					}
				}

				string messageText 		= enemiesInside == 1 ? "#WPN_ECHO_LOCATOR_SINGLE_ENEMY_HINT" : "#WPN_ECHO_LOCATOR_HINT"
				string messageTextShort 	= enemiesInside == 1 ? "#WPN_ECHO_LOCATOR_SINGLE_ENEMY_HINT_SHORT" : "#WPN_ECHO_LOCATOR_HINT_SHORT"
				string prompt      		= string( enemiesInside ) + " " + Localize( messageText )
				string promptShort      	= string( enemiesInside ) + " " + Localize( messageTextShort )
				RuiSetString( waypoint.wp.ruiHud, "pingPrompt", prompt )
				RuiSetString( waypoint.wp.ruiHud, "pingPromptForOwner", prompt )
				RuiSetString( waypoint.wp.ruiHud, "additionalInfoText", promptShort )
			}
		}
		
		WaitFrame()
	}
}

void function ClientEchoLocatorManager_Thread( entity echoLocator )
{
	Assert( IsNewThread(), "Must be threaded off" )
	echoLocator.EndSignal( "OnDeath" )
	echoLocator.EndSignal( "OnDestroy" )

	OnThreadEnd(
		function() : ( echoLocator )
		{
			delete file.enemiesInsideEchoLocator[echoLocator]
		}
	)

	                                                                                                                                                                     
	if ( !file.echoLocators.contains( echoLocator ) )
	{
		file.echoLocators.append( echoLocator )
		file.enemiesInsideEchoLocator[echoLocator] <- 0

		                                      
		thread EchoLocationChamberMonitor_Thread( echoLocator )
		thread EchoLocatorAmbientSound_Thread( echoLocator )

		wait ECHO_LOCATOR_DEPLOY_CLIENT_DELAY

		                                                                                                                                                                             
		if ( IsFriendlyTeam( echoLocator.GetTeam(), GetLocalViewPlayer().GetTeam() ) || echoLocator.GetBossPlayer() == GetLocalViewPlayer() )
		{
			                                                
			thread EchoLocatorFootstepVFX_Thread( echoLocator )
			thread EchoLocatorRUI_Thread( echoLocator )
		}
	}

	wait file.echoLocatorDuration
}

void function EchoLocatorAmbientSound_Thread( entity echoLocator )
{
	Assert( IsNewThread(), "Must be threaded off" )
	echoLocator.EndSignal( "OnDeath" )
	echoLocator.EndSignal( "OnDestroy" )

	vector echoLocatorCenter = echoLocator.GetOrigin()

	EmitSoundOnSphere( echoLocator.GetOrigin(), ECHO_LOCATOR_RADIUS_SCRIPT, ECHO_LOCATOR_AMBIENT_LOOP_START, true )

	float deployAnimDuration = echoLocator.GetSequenceDuration( "prop_pariah_heart_deploy" )
	wait deployAnimDuration

	echoLocatorCenter = echoLocator.GetAttachmentOrigin( echoLocator.LookupAttachment( "HEART_CENTER" ) )

	var ambientLoop = EmitSoundOnSphere( echoLocator.GetOrigin(), ECHO_LOCATOR_RADIUS_SCRIPT, ECHO_LOCATOR_AMBIENT_LOOP, true )
	EmitSoundOnEntity( echoLocator, ECHO_LOCATOR_AMBIENT_SOUND )

	float endTime = Time() + file.echoLocatorDuration
	float initialAnimTime = file.echoLocatorDuration * INITIAL_IDLE_ANIMATION_PERCENTAGE
	float loopEndingTime = Time() + initialAnimTime
	bool playingLoopEndingSound = false

	OnThreadEnd(
		function() : ( echoLocator, ambientLoop, echoLocatorCenter, loopEndingTime )
		{
			StopSoundOnEntity( echoLocator, ECHO_LOCATOR_AMBIENT_SOUND )

			                                                                                                                                 
			if ( IsValid( GetLocalViewPlayer() ) )
			{
				                                                                                                       
				                                                                  
				if ( Time() < loopEndingTime )
				{
					EmitSoundOnSphere( echoLocator.GetOrigin(), ECHO_LOCATOR_RADIUS_SCRIPT, ECHO_LOCATOR_AMBIENT_LOOP_ENDING, true )
					EmitSoundAtPosition( TEAM_ANY, echoLocatorCenter, ECHO_LOCATOR_SPHERE_ENDING )
				}
			}

			StopSound( ambientLoop )
		}
	)

	while ( Time() < endTime )
	{
		                                                                                                                                                                                           
		if ( echoLocator.GetCurrentSequenceName() == $"animseq/props/pariah_heart/pariah_heart/prop_pariah_heart_shutdown.rseq" )
			break

		if ( ( Time() > loopEndingTime ) && ( !playingLoopEndingSound ) )
		{
			playingLoopEndingSound = true
			EmitSoundOnSphere( echoLocator.GetOrigin(), ECHO_LOCATOR_RADIUS_SCRIPT, ECHO_LOCATOR_AMBIENT_LOOP_ENDING, true )
			EmitSoundOnEntity( echoLocator, ECHO_LOCATOR_SPHERE_ENDING )
		}

		WaitFrame()
	}
}


void function EchoLocatorRUI_Thread( entity echoLocator )
{
	Assert( IsNewThread(), "Must be threaded off" )
	echoLocator.EndSignal( "OnDeath" )
	echoLocator.EndSignal( "OnDestroy" )

	entity localViewPlayer = GetLocalViewPlayer()

	localViewPlayer.EndSignal( "OnDeath" )
	localViewPlayer.EndSignal( "OnDestroy" )

	int lastEnemyCount = -1
	float endTime = Time() + file.echoLocatorDuration

	var rui = CreateCockpitRui( $"ui/echo_locator.rpak" )
	file.echoLocatorRui[echoLocator] <- rui

	int attachment = echoLocator.LookupAttachment( "ref" )
	RuiTrackFloat3( rui, "pos", echoLocator, RUI_TRACK_ABSORIGIN_FOLLOW )
	RuiTrackFloat( rui, "bleedoutEndTime", localViewPlayer, RUI_TRACK_SCRIPT_NETWORK_VAR, GetNetworkedVariableIndex( "bleedoutEndTime" ) )
	RuiTrackFloat( rui, "reviveEndTime", localViewPlayer, RUI_TRACK_SCRIPT_NETWORK_VAR, GetNetworkedVariableIndex( "reviveEndTime" ) )

	OnThreadEnd(
		function () : ( echoLocator )
		{
			if ( echoLocator in file.echoLocatorRui )
			{
				if ( file.echoLocatorRui[echoLocator] != null )
				{
					RuiDestroy( file.echoLocatorRui[echoLocator] )
					delete file.echoLocatorRui[echoLocator]
				}
			}
		}
	)

	while ( Time() < endTime )
	{
		int currentEnemyCount = file.enemiesInsideEchoLocator[echoLocator]
		bool insideEchoLocator = IsPlayerInsideEchoLocator( localViewPlayer, echoLocator )
		bool subtitlesEnabled = GetConVarBool( "closecaption" )
		int ccSize = GetConVarInt( "cc_text_size" )
		UISize screenSize = GetScreenSize()

		RuiSetBool( file.echoLocatorRui[echoLocator], "insideEchoLocator", insideEchoLocator )

		if ( lastEnemyCount != currentEnemyCount )
		{
			RuiSetInt( file.echoLocatorRui[echoLocator], "enemiesInside", currentEnemyCount )
			lastEnemyCount = currentEnemyCount
		}

		if ( PlayerHasPassive( localViewPlayer, ePassives.PAS_PARIAH ) )
		{
			RuiSetBool( file.echoLocatorRui[echoLocator], "playerIsSeer", true )
		}
		else
		{
			RuiSetBool( file.echoLocatorRui[echoLocator], "playerIsSeer", false )
		}

		RuiSetBool( file.echoLocatorRui[echoLocator], "closecaptionEnabled", subtitlesEnabled )
		RuiSetInt( file.echoLocatorRui[echoLocator], "closeCaptionSize", ccSize )

		RuiSetFloat2( file.echoLocatorRui[echoLocator], "screenSize", <screenSize.width, screenSize.height, 0> )

		wait TICK_RATE
	}
}


int function GetEnemyCountInsideEchoLocator( entity echoLocator )
{
	if ( echoLocator in file.enemiesInsideEchoLocator )
	{
		return file.enemiesInsideEchoLocator[echoLocator]
	}

	return 0
}

insideEchoLocatorStateData function GetPlayerInsideEchoLocatorState( entity player )
{
	insideEchoLocatorStateData data
	data.insideState = eInsideEchoLocatorState.INSIDE_NONE
	data.numEnemies = 0
	int maxEnemies = 0

	foreach ( entity echoLocator in file.echoLocators )
	{
		if ( IsPlayerInsideEchoLocator( player, echoLocator ) )
		{
			if ( !IsFriendlyTeam( echoLocator.GetTeam(), player.GetTeam() )  && echoLocator.GetBossPlayer() != player )
			{
				data.insideState = eInsideEchoLocatorState.INSIDE_ENEMY
				data.numEnemies = 0
				return data
			}

			data.insideState = eInsideEchoLocatorState.INSIDE_ALLIED
			maxEnemies = maxint( maxEnemies, GetEnemyCountInsideEchoLocator( echoLocator ) )
		}
	}

	data.numEnemies = maxEnemies
	return data
}
#endif         

bool function IsPlayerInsideAlliedEchoLocator( entity localViewPlayer, entity player, int friendlyTeam )
{
	foreach ( entity echoLocator in file.echoLocators )
	{
		if ( IsPlayerInsideEchoLocator( player, echoLocator ) )
		{
			                                
			if ( IsFriendlyTeam( echoLocator.GetTeam(), friendlyTeam ) || echoLocator.GetBossPlayer() == localViewPlayer )
			{
				return true
			}
		}
	}

	return false
}

bool function IsPlayerInsideEchoLocator( entity player, entity echoLocator )
{
	float distance = Distance( player.EyePosition(), echoLocator.GetOrigin() )

	return distance <= file.echoLocatorRadius
}

#if CLIENT
float function GetPlayerSpeedForEchoLocator( entity player )
{
	float playerSpeed = 0.0

	                             
	if ( IsCloaked( player ) )
		return 0.0

	vector playerVelocity = GetIsolatedPlayerVelocityFromGround( player )

	if ( player.IsPlayerDecoy() )
	{
		playerSpeed = Length( playerVelocity )
	}
	else if ( IsTrainingDummie( player ) || player.IsNPC() )
	{
		if ( player in file.aiVelocity )
		{
			playerSpeed = file.aiVelocity[player].speed
		}
	}
	else
	{
		entity hoverVehicle = HoverVehicle_GetVehicleOccupiedByPlayer( player )
		                                                                                                                                         
		if ( player.IsSliding() )
		{
			playerSpeed = Length( playerVelocity )
		}
		else if ( IsValid( hoverVehicle ) )
		{
			playerSpeed = Length( hoverVehicle.GetVehicleVelocity() )
			                                                                                       
			if ( playerSpeed < 2.0 )
				playerSpeed = 0.0
		}
		else
		{
			                                                                                                                                                           
			bool playerMovementInput = player.GetPlayerNetBool( ECHO_LOCATOR_PLAYER_HAS_MOVEMENT_INPUT_NETVAR )

			if ( !playerMovementInput )
			{
				playerSpeed = 0
			}
			else
			{
				playerSpeed = Length( player.GetVelocity() )
			}
		}
	}

	return playerSpeed
}

vector function GetIsolatedPlayerVelocityFromGround( entity player )
{
	vector playerVelocity = player.IsPlayerDecoy() ? player.GetDecoyVelocity() : player.GetVelocity()
	entity groundEnt = player.GetGroundEntity()

	if ( IsValid( groundEnt ) )
	{
		                                                                                                                                                                                                        
		playerVelocity -= groundEnt.GetVelocity()
	}

	return playerVelocity
}

bool function GetIsPlayerOnGroundForEchoLocator( entity player )
{
	bool isOnGround = true

	if ( player.IsPlayerDecoy() )
	{
		isOnGround = player.DecoyIsOnGround()
	}
	else
	{
		isOnGround = player.IsOnGround()
	}

	                                                                                             
	if ( !isOnGround )
	{
		TraceResults traceResult = TraceLine( player.GetOrigin() + ( player.GetUpVector() * 2 ), player.GetOrigin() - ( player.GetUpVector() * 5 ), [ player ], TRACE_MASK_SOLID, TRACE_COLLISION_GROUP_BLOCK_WEAPONS_AND_PHYSICS )
		isOnGround = ( traceResult.fraction < 0.99 )
	}

	return isOnGround
}

bool function DoesPlayerPassEchoLocatorMovementCheck( entity player, float playerSpeed )
{
	             
	if ( playerSpeed > 0 )
	{
		if ( player.IsPlayerDecoy() )
		{
			if ( !player.DecoyIsCrouched() || player.DecoyIsSliding() )
			{
				return true
			}
		}
		else if ( IsTrainingDummie( player ) || player.IsNPC() )
		{
			return true
		}
		else
		{
			                     
			                                                                               
			if ( !player.IsCrouched() || player.IsSliding() )
			{
				return true
			}
		}
	}

	return false
}

weaponCheckData function DoesPlayerPassEchoLocatorWeaponDischargeCheck( entity player )
{
	weaponCheckData result
	result.checkPassed = false
	result.totalFireTime = 0.0

	if ( player.IsPlayer() )
	{
		entity weapon     = player.GetActiveWeapon( eActiveInventorySlot.mainHand )

		if ( IsValid( weapon ) )
		{
			float rechamberDuration = weapon.GetWeaponSettingFloat( eWeaponVar.rechamber_time )
			float fireRate = weapon.GetWeaponSettingFloat( eWeaponVar.fire_rate )

			float fireCooldown = fireRate > 0.0 ? 1.0 / fireRate : 0.0
			float totalFireTime = rechamberDuration + fireCooldown

			float lastFireTimeWeapon = player.GetLastFiredTime()
			float fireTimeDelta = Time() - lastFireTimeWeapon

			float checkTime = max( totalFireTime, WEAPON_FIRE_FX_MIN_WAIT_TIME )

			result.checkPassed = fireTimeDelta < checkTime
			result.totalFireTime = totalFireTime
		}
	}
	else if ( IsTrainingDummie( player ) )
	{
		entity weapon     = player.GetActiveWeapon( eActiveInventorySlot.mainHand )

		if ( IsValid( weapon ) )
		{
			float rechamberDuration = weapon.GetWeaponSettingFloat( eWeaponVar.rechamber_time )
			float fireCooldown      = 1.0 / weapon.GetWeaponSettingFloat( eWeaponVar.fire_rate )
			float totalFireTime = rechamberDuration + fireCooldown

			int weaponActivity = weapon.GetWeaponActivity()
			                                                                                                                                  
			if ( ( weaponActivity >= ACT_RANGE_ATTACK1 ) && ( weaponActivity <= ACT_RANGE_ATTACK_SMG1 ) )
			{
				result.checkPassed = true
			}
			else
			{
				result.checkPassed = false
			}
			
			result.totalFireTime = totalFireTime
		}
	}

	return result
}

                                                                                                                       
             
                                                                                                                       
void function EchoLocator_StartVisualEffect( entity ent, int statusEffect, bool actuallyChanged )
{
	if ( !file.playersInsideEchoLocators.contains( ent ) )
	{
		file.playersInsideEchoLocators.append( ent )
	}

	if ( !actuallyChanged && GetLocalViewPlayer() == GetLocalClientPlayer() )
		return

	if ( ent != GetLocalViewPlayer() )
		return

	EmitSoundOnEntity( ent, ECHO_LOCATOR_THRESHOLD_SOUND )

	entity viewPlayer = GetLocalViewPlayer()

	int fxHandle = StartParticleEffectOnEntityWithPos( viewPlayer, COCKPIT_ECHO_LOCATOR_SCREEN_FX, FX_PATTACH_ABSORIGIN_FOLLOW, ATTACHMENTID_INVALID, viewPlayer.EyePosition(), <0,0,0> )
	EffectSetIsWithCockpit( fxHandle, true )

	thread EchoLocator_UpdateIntensity_Thread( viewPlayer, fxHandle )
	thread EchoLocatorScreenFXThink( viewPlayer, fxHandle )
}

void function EchoLocatorFootstepVFX_Thread( entity echoLocator )
{
	Assert( IsNewThread(), "Must be threaded off" )
	echoLocator.EndSignal( "OnDeath" )
	echoLocator.EndSignal( "OnDestroy" )

	table<entity, float> lastPingTimeForLoco
	table<entity, bool> wasInAir

	table<entity, lockFXData> lockFXID
	table<entity, var> minimapMarkerRui
	array<entity> dummiesAddedToInsideEchoLocatorList

	float endTime = Time() + file.echoLocatorDuration

	OnThreadEnd(
		function () : ( echoLocator, lockFXID, minimapMarkerRui, dummiesAddedToInsideEchoLocatorList )
		{
			foreach ( entity ent, lockFXData data in lockFXID )
			{
				if ( EffectDoesExist( data.fxHandle ) )
				{
					EffectStop( data.fxHandle, false, true )
				}
			}

			foreach ( entity ent, var minimapRui in minimapMarkerRui )
			{
				if ( minimapRui != null )
				{
					Minimap_CommonCleanup( minimapRui )
				}
			}

			file.aiVelocity.clear()

			if ( IsFiringRangeGameMode() )
			{
				foreach ( entity dummy in dummiesAddedToInsideEchoLocatorList )
				{
					if ( file.playersInsideEchoLocators.contains( dummy ) )
					{
						file.playersInsideEchoLocators.fastremovebyvalue( dummy )
					}
				}
			}
		}
	)

	bool firstLoopIteration = true

	while ( true )
	{
		bool echoLocatorOwner = GetLocalViewPlayer() == echoLocator.GetBossPlayer()

		if ( file.echoLocators.len() == 0 )
		{
			return
		}

		if ( Time() > endTime )
		{
			return
		}

		if ( IsFiringRangeGameMode() )
		{
			array<entity> dummies = GetEntArrayByScriptName( FIRING_RANGE_DUMMIE_SCRIPT_NAME )

			foreach ( entity dummy in dummies )
			{
				if ( IsValid( dummy ) )
				{
					if ( IsPlayerInsideAlliedEchoLocator( GetLocalViewPlayer(), dummy, GetLocalViewPlayer().GetTeam() ) )
					{
						if ( !file.playersInsideEchoLocators.contains( dummy ) )
						{
							file.playersInsideEchoLocators.append( dummy )

							if ( !dummiesAddedToInsideEchoLocatorList.contains( dummy ) )
							{
								dummiesAddedToInsideEchoLocatorList.append( dummy )
							}
						}
					}
					else
					{
						if ( file.playersInsideEchoLocators.contains( dummy ) )
						{
							file.playersInsideEchoLocators.fastremovebyvalue( dummy )

							if ( dummiesAddedToInsideEchoLocatorList.contains( dummy ) )
							{
								dummiesAddedToInsideEchoLocatorList.fastremovebyvalue( dummy )
							}
						}
					}

					if ( !( dummy in file.aiVelocity ) )
					{
						aiVelocityData data
						data.time                  = Time()
						data.origin                = dummy.GetOrigin()
						data.speed                 = 0
						file.aiVelocity[dummy] <- data
					}
				}
			}
		}

		array<entity> validTouchingEnts

		foreach ( entity ent in file.playersInsideEchoLocators )
		{
			if ( !IsValid( ent ) )
			{
				continue
			}

			bool isCombatNPC = IsCombatNPC( ent )

			if ( !ent.IsPlayer() && !ent.IsPlayerDecoy() && !IsTrainingDummie( ent ) && !isCombatNPC )
			{
				continue
			}

			if ( isCombatNPC )
			{
				if ( !( ent in file.aiVelocity ) )
				{
					aiVelocityData data
					data.time                  = Time()
					data.origin                = ent.GetOrigin()
					data.speed                 = 0
					file.aiVelocity[ent] <- data
				}
			}

			                                                                                                                     
			                            
			   
			  	                                
			  	 
			  		        
			  	 
			   

			if ( ent.IsPhaseShifted() )
			{
				continue
			}

			if ( IsCloaked( ent ) )
			{
				continue
			}

			if ( IsFriendlyTeam( ent.GetTeam(), GetLocalViewPlayer().GetTeam() ) || ( ent == echoLocator.GetBossPlayer() ) )
			{
				continue
			}
			
			                                                                                                                            
			if ( IsPlayerInsideAlliedEchoLocator( GetLocalViewPlayer(), ent, GetLocalViewPlayer().GetTeam() ) )
			{
				validTouchingEnts.append( ent )

				if ( !( ent in lastPingTimeForLoco ) )
				{
					lastPingTimeForLoco[ent] <- 0.0
				}

				if ( !( ent in wasInAir ) )
				{
					wasInAir[ent] <- false
				}

				if ( !( ent in lockFXID ) )
				{
					lockFXData data
					data.fxHandle    = -1
					data.initialLock = false
					lockFXID[ent] <- data
				}

				if ( !( ent in minimapMarkerRui ) )
				{
					minimapMarkerRui[ent] <- null
				}
			}
		}

		                                                 
		if ( firstLoopIteration )
		{
			foreach ( entity potentialVictim in validTouchingEnts )
			{
				bool isCombatDummie = IsCombatNPC( potentialVictim ) && IsTrainingDummie( potentialVictim )

				if ( potentialVictim.IsPlayer() || isCombatDummie || potentialVictim.IsPlayerDecoy() )
				{
					lockFXID[potentialVictim].fxHandle = StartParticleEffectOnEntity( potentialVictim, GetParticleSystemIndex( ECHO_LOCATOR_TARGET_ANIMATED ), FX_PATTACH_POINT_FOLLOW, potentialVictim.LookupAttachment( "CHESTFOCUS" ) )
					lockFXID[potentialVictim].initialLock = true
					lastPingTimeForLoco[potentialVictim]  = Time()
				}
			}
			if ( echoLocatorOwner && validTouchingEnts.len() > 0 )
			{
				EmitSoundOnEntity( GetLocalViewPlayer(), ECHO_LOCATOR_TARGET_ACQUIRED_SOUND )
			}
		}

		file.enemiesInsideEchoLocator[echoLocator] = validTouchingEnts.len()
		
		                                              
		if ( validTouchingEnts.len() > ECHO_LOCATOR_MAX_FOOTSTEP_TARGETS_TO_SHOW )
		{
			validTouchingEnts.sort( SortPlayersByDistFromLocalViewPlayer )
			validTouchingEnts.resize( ECHO_LOCATOR_MAX_FOOTSTEP_TARGETS_TO_SHOW )
		}

		foreach ( entity potentialVictim in validTouchingEnts )
		{
			#if DEV
			string playerName = potentialVictim.IsPlayer() ? potentialVictim.GetPlayerName() : "DECOY"
			#endif      
			
			bool onGround = GetIsPlayerOnGroundForEchoLocator( potentialVictim )
			bool isCombatDummie = IsCombatNPC( potentialVictim ) && IsTrainingDummie( potentialVictim )

			if ( onGround )
			{
				float playerSpeed = GetPlayerSpeedForEchoLocator( potentialVictim )
				entity hoverVehicle = HoverVehicle_GetVehicleOccupiedByPlayer( potentialVictim )
				bool insideHoverVehicle = IsValid( hoverVehicle )

				float deltaTime                 = ( Time() - lastPingTimeForLoco[potentialVictim] )
				bool movementCheckPassed        = DoesPlayerPassEchoLocatorMovementCheck( potentialVictim, playerSpeed )
				weaponCheckData weaponCheckResult = DoesPlayerPassEchoLocatorWeaponDischargeCheck( potentialVictim )

				if ( movementCheckPassed || weaponCheckResult.checkPassed )
				{
					float footstepFxDelta = Time() - lastPingTimeForLoco[potentialVictim]

					if ( !EffectDoesExist( lockFXID[potentialVictim].fxHandle ) )
					{
						if ( potentialVictim.IsPlayer() || isCombatDummie || potentialVictim.IsPlayerDecoy() )
						{
							                                                                    
							if ( footstepFxDelta > LOCK_FX_RESET_TIME )
							{
								if ( echoLocatorOwner )
								{
									EmitSoundOnEntity( GetLocalViewPlayer(), ECHO_LOCATOR_TARGET_ACQUIRED_SOUND )
								}

								lockFXID[potentialVictim].fxHandle    = StartParticleEffectOnEntity( potentialVictim, GetParticleSystemIndex( ECHO_LOCATOR_TARGET_ANIMATED ), FX_PATTACH_POINT_FOLLOW, potentialVictim.LookupAttachment( "CHESTFOCUS" ) )
								lockFXID[potentialVictim].initialLock = false
							}
							                                                              
							else
							{
								lockFXID[potentialVictim].fxHandle    = StartParticleEffectOnEntity( potentialVictim, GetParticleSystemIndex( ECHO_LOCATOR_TARGET_NON_ANIMATED ), FX_PATTACH_POINT_FOLLOW, potentialVictim.LookupAttachment( "CHESTFOCUS" ) )
								lockFXID[potentialVictim].initialLock = false
							}
						}
					}


					if ( !IsValid( minimapMarkerRui[potentialVictim] ) )
					{
						minimapMarkerRui[potentialVictim] = Minimap_AddEnemyToMinimap( potentialVictim )
					}

					float waitTime = FLT_MAX

					if ( movementCheckPassed )
					{
						waitTime = GraphCapped( playerSpeed, CROUCH_WALK_SPEED, MAX_SPRINT_SPEED, JOG_FX_WAIT_TIME, SPRINT_FX_WAIT_TIME )
					}
					else if ( weaponCheckResult.checkPassed )
					{
						waitTime = max( weaponCheckResult.totalFireTime, WEAPON_FIRE_FX_MIN_WAIT_TIME )
					}

					#if DEV
						if ( ECHO_LOCATOR_DEBUG )
						{
							printt("EcholocateEnemy_Thread() wait time: " + waitTime + " deltaTime: " + deltaTime + " player name: " + playerName + " player speed: " + playerSpeed + " max speed: " + MAX_SPRINT_SPEED + " fraction: " + GraphCapped( playerSpeed, CROUCH_WALK_SPEED, MAX_SPRINT_SPEED, 0.0, 1.0 ) )
						}
					#endif      

					if ( deltaTime > waitTime )
					{
						                                                         
						if ( !insideHoverVehicle )
						{
							thread EchoLocatorFootstepVFXClient( potentialVictim, GetLocalViewPlayer().GetTeam() )
						}

						lastPingTimeForLoco[potentialVictim] = Time()
					}
				}
				if ( wasInAir[potentialVictim] )
				{
					             
					#if DEV
						if ( ECHO_LOCATOR_DEBUG )
						{
							printt( "EcholocateEnemy_Thread " + playerName + " Landed." )
						}
					#endif      
					wasInAir[potentialVictim] = false

					                                                                                                             
					if ( deltaTime > SPRINT_FX_WAIT_TIME )
					{
						thread EchoLocatorFootstepVFXClient( potentialVictim, GetLocalViewPlayer().GetTeam() )
						lastPingTimeForLoco[potentialVictim] = Time()
					}
				}
			}
			else
			{
				if ( minimapMarkerRui[potentialVictim] != null )
				{
					Minimap_CommonCleanup( minimapMarkerRui[potentialVictim] )
					minimapMarkerRui[potentialVictim] = null
				}

				if ( !wasInAir[potentialVictim] )
				{
					             
					#if DEV
						if ( ECHO_LOCATOR_DEBUG )
						{
							printt( "EcholocateEnemy_Thread " + playerName + " Jumped." )
						}
					#endif      
					float deltaTime = ( Time() - lastPingTimeForLoco[potentialVictim] )
					if ( deltaTime > SPRINT_FX_WAIT_TIME )
					{
						thread EchoLocatorFootstepVFXClient( potentialVictim, GetLocalViewPlayer().GetTeam() )
						lastPingTimeForLoco[potentialVictim] = Time()
					}
				}

				wasInAir[potentialVictim] = true
			}
		}

		                                       
		foreach ( entity potentialVictim, var minimapRUI in minimapMarkerRui )
		{
			if ( IsValid( minimapRUI ) )
			{
				if ( !IsValid( potentialVictim ) )
				{
					Minimap_CommonCleanup( minimapMarkerRui[potentialVictim] )
					minimapMarkerRui[potentialVictim] = null
				}
				else
				{
					float deltaLastPingTime = Time() - lastPingTimeForLoco[potentialVictim]

					if ( deltaLastPingTime > MINIMAP_MARKER_DEBOUNCE_TIME )
					{
						Minimap_CommonCleanup( minimapMarkerRui[potentialVictim] )
						minimapMarkerRui[potentialVictim] = null
					}
					else
					{
						RuiSetFloat3( minimapRUI, "objectPos", potentialVictim.GetOrigin() )
						RuiSetFloat3( minimapRUI, "objectAngles", potentialVictim.GetAngles() )
					}
				}
			}
		}

		                            
		foreach ( entity potentialVictim, lockFXData data in lockFXID )
		{
			if ( EffectDoesExist( data.fxHandle ) )
			{
				if ( !IsValid( potentialVictim ) )
				{
					EffectStop( data.fxHandle, false, true )
				}
				else if ( IsCloaked( potentialVictim ) )
				{
					EffectStop( data.fxHandle, false, true )
				}
				else
				{
					float deltaLastPingTime = Time() - lastPingTimeForLoco[potentialVictim]

					                                                                                  
					float deltaCheck = data.initialLock ? ECHO_LOCATOR_INITIAL_MARKER_DURATION : LOCK_FX_DEBOUNCE_TIME
					bool isPlayerInsideEchoLocator = IsPlayerInsideEchoLocator( potentialVictim, echoLocator )

					if ( deltaLastPingTime > deltaCheck || !isPlayerInsideEchoLocator )
					{
						EffectStop( data.fxHandle, false, true )
					}
				}
			}
		}

		foreach ( entity aiEnt, aiVelocityData data in file.aiVelocity )
		{
			if ( IsValid( aiEnt ) )
			{
				if ( IsAlive( aiEnt ) && aiEnt.IsOnGround() )
				{
					vector distDiff = aiEnt.GetOrigin() - data.origin
					float timeDelta = Time() - data.time
					float speed     = ( timeDelta > 0.0 ) ? Length( distDiff ) / timeDelta : 0.0

					data.time   = Time()
					data.origin = aiEnt.GetOrigin()
					data.speed  = speed
				}
				else
				{
					data.speed = 0
				}
			}
		}

		firstLoopIteration = false
		WaitFrame()
	}
}

int function SortPlayersByDistFromLocalViewPlayer( entity a, entity b )
{
	entity localViewPlayer = GetLocalViewPlayer()

	float distanceA = Distance( localViewPlayer.EyePosition(), a.EyePosition() )
	float distanceB = Distance( localViewPlayer.EyePosition(), b.EyePosition() )

	if ( distanceA > distanceB )
		return 1

	if ( distanceA < distanceB )
		return -1

	return 0
}

void function EchoLocatorFootstepVFXClient( entity victim, int team )
{
	int particleSystemID = ( victim.IsPlayer() || victim.IsPlayerDecoy() ) ? GetParticleSystemIndex( ECHO_LOCATOR_VISUAL_FOOT_PING ) : GetParticleSystemIndex( ECHO_LOCATOR_VISUAL_FOOT_PING_AI )

	TraceResults traceResult = TraceLine( victim.GetOrigin() + ( victim.GetUpVector() * 20 ), victim.GetOrigin() - ( victim.GetUpVector() * 200 ), [ victim ], TRACE_MASK_SOLID, TRACE_COLLISION_GROUP_BLOCK_WEAPONS_AND_PHYSICS )

	vector angles = AnglesOnSurface( traceResult.surfaceNormal, victim.GetForwardVector() )
	int handle = -1

	if ( IsValid( traceResult.hitEnt ) )
	{
		                                                                                                                                                                                                      
		entity mover = CreateClientsideScriptMover( $"mdl/dev/empty_model.rmdl", traceResult.endPos, angles )
		mover.SetParent( traceResult.hitEnt )
		handle = StartParticleEffectOnEntity( mover, particleSystemID, FX_PATTACH_CUSTOMORIGIN_FOLLOW, ATTACHMENTID_INVALID )
		thread DelayDestroy( mover )
	}
	else
	{
		handle = StartParticleEffectInWorldWithHandle( particleSystemID, traceResult.endPos, angles )
	}

	                                                                                                                                        
	bool isCombatDummie = IsCombatNPC( victim ) && IsTrainingDummie( victim )

	vector color = ( victim.IsPlayer() || isCombatDummie || victim.IsPlayerDecoy() ) ? ENEMY_COLOR_FX : NEUTRAL_COLOR_FX
	EffectSetControlPointVector( handle, 1, color )
}

void function DelayDestroy( entity mover )
{
	mover.EndSignal( "OnDestroy" )
	wait 2.5
	mover.Destroy()
}

void function EchoLocator_UpdateIntensity_Thread( entity player, int fxHandle )
{
	Assert( IsNewThread(), "Must be threaded off" )
	player.EndSignal( "EchoLocator_Exit" )
	player.EndSignal( "OnDeath" )

	float lastStrength = 0.0
	float goalStrength = 0.1
	float targetStrength = 0.0
	const float goalStrengthRevealed = 1.0
	const float goalStrengthStationary = 0.1
	const float goalStrengthAlliedWithEnemiesInside = 0.5
	const float strengthIncrement = 0.01
	bool lastInsideEnemyEchoLocator = false
	EffectSetControlPointVector( fxHandle, 3, FRIENDLY_COLOR_FX )


	while( true )
	{
		                         
		if ( !EffectDoesExist( fxHandle ) )
			return

		insideEchoLocatorStateData insideStateData = GetPlayerInsideEchoLocatorState( player )
		float playerSpeed = GetPlayerSpeedForEchoLocator( player )

		if ( insideStateData.insideState == eInsideEchoLocatorState.INSIDE_ENEMY )
		{
			if ( !lastInsideEnemyEchoLocator )
			{
				lastInsideEnemyEchoLocator = true
				EffectSetControlPointVector( fxHandle, 3, ENEMY_COLOR_FX )
			}

			entity weapon                   = player.GetActiveWeapon( eActiveInventorySlot.mainHand )
			bool movementCheckPassed        = DoesPlayerPassEchoLocatorMovementCheck( player, playerSpeed ) && player.IsOnGround()
			weaponCheckData weaponCheckData = DoesPlayerPassEchoLocatorWeaponDischargeCheck( player )

			if ( movementCheckPassed || weaponCheckData.checkPassed )
			{
				goalStrength = goalStrengthRevealed
			}
			else
			{
				goalStrength = goalStrengthStationary
			}
		}
		else if ( insideStateData.insideState == eInsideEchoLocatorState.INSIDE_ALLIED )
		{
			if ( lastInsideEnemyEchoLocator )
			{
				EffectSetControlPointVector( fxHandle, 3, FRIENDLY_COLOR_FX )
				lastInsideEnemyEchoLocator = false
			}

			goalStrength = insideStateData.numEnemies > 0 ? goalStrengthAlliedWithEnemiesInside : goalStrengthStationary
		}
		else
		{
			goalStrength = 0.0
		}

		if ( fabs( goalStrength - lastStrength ) > FLT_EPSILON )
		{
			if ( goalStrength > lastStrength )
			{
				targetStrength = Clamp( lastStrength + strengthIncrement, 0.0, 1.0 )
			}
			else
			{
				targetStrength = Clamp( lastStrength - strengthIncrement, 0.0, 1.0 )
			}

			EffectSetControlPointVector( fxHandle, 2, <targetStrength, 0, 0> )
			lastStrength = targetStrength
		}

		WaitFrame()
	}
}

void function EchoLocator_StopVisualEffect( entity ent, int statusEffect, bool actuallyChanged )
{
	if ( file.playersInsideEchoLocators.contains( ent ) )
	{
		file.playersInsideEchoLocators.fastremovebyvalue( ent )
	}

	if ( !actuallyChanged && GetLocalViewPlayer() == GetLocalClientPlayer() )
		return

	if ( ent != GetLocalViewPlayer() )
		return

	EmitSoundOnEntity( ent, ECHO_LOCATOR_THRESHOLD_SOUND )

	ent.Signal( "EchoLocator_Exit" )
}

void function EchoLocatorScreenFXThink( entity player, int fxHandle )
{
	Assert( IsNewThread(), "Must be threaded off" )
	player.EndSignal( "EchoLocator_Exit" )
	player.EndSignal( "OnDeath" )

	OnThreadEnd(
		function() : ( fxHandle )
		{
			if ( !EffectDoesExist( fxHandle ) )
				return

			EffectStop( fxHandle, false, true )
		}
	)


	for ( ;; )
	{
		if ( !EffectDoesExist( fxHandle ) )
			break

		EffectSetControlPointVector( fxHandle, 1, <1,999,0> )

		WaitFrame()
	}
}

#endif         

int function GetEchoLocatorRadius()
{
	return GetCurrentPlaylistVarInt( "seer_ult_radius", ECHO_LOCATOR_RADIUS_SCRIPT )
}

int function GetEchoLocatorHP()
{
	return GetCurrentPlaylistVarInt( "seer_ult_hp", ECHO_LOCATOR_HP )
}