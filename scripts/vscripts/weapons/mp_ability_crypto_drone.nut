global function MpAbilityCryptoDrone_Init

global function OnWeaponTossReleaseAnimEvent_ability_crypto_drone
global function OnWeaponAttemptOffhandSwitch_ability_crypto_drone
global function OnWeaponTossPrep_ability_crypto_drone
global function OnWeaponToss_ability_crypto_drone
                               
global function OnWeaponRegenEnd_ability_crypto_drone
      

                                      
                                                         
                                            

global function IsPlayerInCryptoDroneCameraView
global function CryptoDrone_SetMaxZ

#if CLIENT
global function OnClientAnimEvent_ability_crypto_drone
global function UpdateCameraVisibility
global function CreateCameraCircleStatusRui
global function DestroyCameraCircleStatusRui
global function GetCameraCircleStatusRui
global function CreateCryptoAnimatedTacticalRui
global function DestroyCryptoAnimatedTacticalRui
global function GetCryptoAnimatedTacticalRui
global function CryptoDrone_OnPlayerTeamChanged
global function TrackCryptoAnimatedTacticalRuiOffhandWeapon

global function AddCallback_OnEnterDroneView
global function RemoveCallback_OnEnterDroneView
global function AddCallback_OnLeaveDroneView
global function RemoveCallback_OnLeaveDroneView
global function AddCallback_OnRecallDrone
global function RemoveCallback_OnRecallDrone

global function ServerToClient_CryptoDroneAutoReloadDone

#endif

#if SERVER
                                                  
                                                     
                                  
                                   
                                             
                                   
                                             
                                              
                                              
                                        
                                                       
                                     
                                     
                                                 
#endif

const asset CAMERA_MODEL = $"mdl/props/crypto_drone/crypto_drone.rmdl"

const asset CAMERA_FX = $"P_drone_camera"
const asset VISOR_FX_3P = $"P_crypto_visor_ui"
const asset DRONE_RECALL_START_FX_3P = $"P_drone_recall_start"
const asset DRONE_RECALL_END_FX_3P = $"P_drone_recall_end"
const asset SCREEN_FX = $"P_crypto_hud_boot"
const asset SCREEN_FAST_FX = $"P_crypto_hud_boot_fast"
const string DRONE_PROPULSION_1P = "Char_11_TacticalA_E"
const string DRONE_PROPULSION_3P = "Char_11_TacticalA_E_3P"
const string DRONE_EXPLOSION_3P = "Char_11_TacticalA_F_3p"
const string DRONE_EXPLOSION_1P = "Char_11_TacticalA_F"

const string DRONE_SCANNING_3P = "Char_11_TacticalA_E2_3p"

const string DRONE_ALERT_1P = "Char_11_TacticalA_Ping"			                      
const string DRONE_ALERT_DOWNED_1P = "Char_11_TacticalA_Ping"	                                                                                
const string DRONE_ALERT_3P = "Char_11_TacticalA_Ping"			                                                      

const string TRANSITION_OUT_CAMERA_1P = "Char_11_TacticalA_D"
const string TRANSITION_OUT_CAMERA_3P = "Char_11_TacticalA_D"
const string HACK_SFX_1P = "Crypto_Drone_Antenna_Hack_1p"                                                                  
const string HACK_SFX_3P = "Crypto_Drone_Antenna_Hack_3p"                                                                  

                                                                                                
const string DRONE_RECALL_1P = "Char_11_TacticalA_A"
const string DRONE_RECALL_3P = "Char_11_TacticalA_A"
const string DRONE_RECALL_CRYPTO_3P = "Char_11_TacticalA_A"

global const float EMP_RANGE = 1181.1
global const float MAX_FLIGHT_RANGE = 7913                                                        
const float WARNING_RANGE = 5906       
const float CAMERA_FLIGHT_SPEED = 450                           
global float CRYPTO_DRONE_DAMAGED_REENTER_DEBOUNCE = 1.4
const asset CAMERA_MAX_RANGE_SCREEN_FX = $"P_crypto_drone_screen_distort_CP"
const asset CAMERA_EXPLOSION_FX = $"P_crypto_drone_explosion"
const asset CAMERA_HIT_FX = $"P_drone_shield_hit"                        
const asset CAMERA_HIT_ENEMY_FX = $"P_drone_shield_hit_enemy"                        

const float NEUROLINK_VIEW_MINDOT = 80.0
const int CRYPTO_DRONE_HEALTH = 60
                               
const float DEPLOYABLE_CAMERA_THROW_POWER = 400.0
const float NEUROLINK_VIEW_MINDOT_BUFFED = 120.0
const int CRYPTO_DRONE_HEALTH_PROJECTILE = 50
const float CRYPTO_DRONE_STICK_RANGE = 670.0

const vector CRYPTO_DRONE_HULL_TRACE_MIN	= <-6, -6, 0>
const vector CRYPTO_DRONE_HULL_TRACE_MAX	= <6, 6, 12>

const asset CRYPTO_DRONE_SIGHTBEAM_FX = $"P_BT_scan_SML_no_streaks"
                                                                      

const bool CRYPTO_DRONE_USE_SONAR_FX = false
const string CRYPTO_DRONE_ATTACH_SOUND_1P = "weapon_tethergun_attach_1p"
const string CRYPTO_DRONE_ATTACH_SOUND_3P = "weapon_tethergun_attach_3p"
      

global const string CRYPTO_DRONE_SCRIPTNAME = "crypto_camera"
global const string CRYPTO_DRONE_TARGETNAME = "drone_no_minimap_object"

global const string DISABLE_WAYPOINT_SCRIPTNAME = "device_disable_waypoint"

struct
{
	#if CLIENT
		var            cameraRui
		var            cameraCircleStatusRui
		var            cryptoAnimatedTacticalRui
		array <entity> allDrones
	                                 
	  	    		                
	        
	#endif
	#if SERVER
		                                                                                 
		                                                            
		                                                             
		                                                             
		                                                             
		                                                                 
		                                                                       
		                                                                      
		                                                                
                                
		                       						                
       
	#endif

	float neurolinkRange
	float droneMaxZ = 100000
	int droneHealth

	array<void functionref()> onEnterDroneViewCallbacks
	array<void functionref()> onLeaveDroneViewCallbacks
	array<void functionref()> onRecallDroneCallbacks
} file

void function MpAbilityCryptoDrone_Init()
{
	PrecacheModel( CAMERA_MODEL )
	PrecacheParticleSystem( CAMERA_FX )
	PrecacheParticleSystem( CAMERA_EXPLOSION_FX )
	PrecacheParticleSystem( CAMERA_MAX_RANGE_SCREEN_FX )
	PrecacheParticleSystem( VISOR_FX_3P )
	PrecacheParticleSystem( DRONE_RECALL_START_FX_3P )
	PrecacheParticleSystem( DRONE_RECALL_END_FX_3P )
	PrecacheParticleSystem( SCREEN_FX )
	PrecacheParticleSystem( SCREEN_FAST_FX )
	PrecacheParticleSystem( CAMERA_HIT_FX )
	PrecacheParticleSystem( CAMERA_HIT_ENEMY_FX )

                               
	PrecacheParticleSystem( CRYPTO_DRONE_SIGHTBEAM_FX )
	                                                       
      

	                                                             

	Remote_RegisterServerFunction( "ClientCallback_AttemptDroneRecall" )

	#if SERVER
		                                  
		                                    
		                                                 
		                                                                          
		                                                     
		                                                      
		                                                      
	#else
		RegisterSignal( "StopUpdatingCameraRui" )
		RegisterSignal( "CameraViewEnd" )
		RegisterSignal( "CameraViewStart" )
		StatusEffect_RegisterEnabledCallback( eStatusEffect.crypto_camera_is_recalling, Camera_OnBeginRecall )
		StatusEffect_RegisterDisabledCallback( eStatusEffect.crypto_camera_is_recalling, Camera_OnEndRecall )
		StatusEffect_RegisterEnabledCallback( eStatusEffect.camera_view, Camera_OnBeginView )
		StatusEffect_RegisterDisabledCallback( eStatusEffect.camera_view, Camera_OnEndView )
		StatusEffect_RegisterEnabledCallback( eStatusEffect.crypto_has_camera, Camera_OnCreate )
		StatusEffect_RegisterDisabledCallback( eStatusEffect.crypto_has_camera, Camera_OnDestroy )
		AddCreateCallback( "player_vehicle", CryptoDrone_OnPropScriptCreated )
		AddDestroyCallback( "player_vehicle", CryptoDrone_OnPropScriptDestroyed )
		AddCallback_OnPlayerChangedTeam( CryptoDrone_OnPlayerTeamChanged )
		RegisterConCommandTriggeredCallback( "+scriptCommand5", AttemptDroneRecall )
		AddCallback_OnWeaponStatusUpdate( CryptoDrone_WeaponStatusCheck )
		AddCallback_OnPlayerLifeStateChanged( CryptoDrone_OnLifeStateChanged )

		RegisterMinimapPackage( "prop_script", eMinimapObject_prop_script.CRYPTO_DRONE, MINIMAP_OBJECT_RUI, MinimapPackage_CryptoDrone, FULLMAP_OBJECT_RUI, MinimapPackage_CryptoDrone )
                                
		                               
		                                                                                                                                                                                  
       
	#endif

	if ( AutoReloadWhileInCryptoDroneCameraView() )
		Remote_RegisterClientFunction( "ServerToClient_CryptoDroneAutoReloadDone", "entity" )

	file.neurolinkRange = GetCurrentPlaylistVarFloat( "crypto_neurolink_range", EMP_RANGE )
                                
		                                                                 
		RegisterSignal( "Crypto_Immediate_Camera_Access_Confirmed" )
		RegisterSignal( "Crypto_StopSendPointThink" )
		file.droneHealth = GetCurrentPlaylistVarInt( "crypto_drone_health", CRYPTO_DRONE_HEALTH_PROJECTILE )
      
                                                                                           
       
}

                                  
                                  
                                  

bool function OnWeaponAttemptOffhandSwitch_ability_crypto_drone( entity weapon )
{
	int ammoReq  = weapon.GetAmmoPerShot()
	int currAmmo = weapon.GetWeaponPrimaryClipCount()
	if ( currAmmo < ammoReq )
		return false

	entity player = weapon.GetWeaponOwner()

	if ( IsPlayerInCryptoDroneCameraView( player ) )
		return false

	if ( StatusEffect_GetSeverity( player, eStatusEffect.script_helper ) > 0.0 )
		return false

	if ( StatusEffect_GetSeverity( player, eStatusEffect.crypto_camera_is_recalling ) > 0.0 )
		return false

	if ( !PlayerCanUseCamera( player, false ) )
		return false

                                      
                                                        
              
                                            

	Holospray_DisableForTime( player, 2.0 )
	return true
}


var function OnWeaponToss_ability_crypto_drone( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	entity player = weapon.GetWeaponOwner()

                                
		Signal( player, "Crypto_Immediate_Camera_Access_Confirmed" )

		if ( StatusEffect_GetSeverity( player, eStatusEffect.crypto_has_camera ) == 0.0 )
		{
                                         
                                                 
              

                                                        
                                                              
              
                                             
      
                                 
                                      
      
          
                                                                                                                                    
                                                
                                        
                                                                                                                                                             
             
                         
                   
     
                                                     
                                                      
     

                                                                                          

                                              
				entity camera = CryptoDrone_ReleaseCamera( weapon, attackParams, DEPLOYABLE_CAMERA_THROW_POWER )
				Signal( player, "Crypto_StopSendPointThink" )
         
			#if SERVER
				                                                                                          
			#endif          

			return -1
		}
		else
		{
                                        
            
                                               

			if ( weapon.HasMod( "crypto_drone_access" ) )
			{
				return -1
			}
			else
			{
			#if CLIENT
				ServerCallback_SurvivalHint( eSurvivalHints.CRYPTO_DRONE_ACCESS )
			#endif
				return 0
			}
		}
                                      

	return -1
}

                                      
                                                                                                                                                                       
 
                          
        

          
                                     
                           
                                         
  
                                                    
                                                
  
                     
                                                                              
               
 

                                                               
 
                        
  
           
                       
                 
                                                      
  

             
                         
   
                          
    
             
                         
                   
                                                          
    
   
  

                                  
                              
             
 
                                            

var function OnWeaponTossReleaseAnimEvent_ability_crypto_drone( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	entity player = weapon.GetWeaponOwner()

                                       
                                                         
           
                                             

	#if SERVER
                                  
                                                                                                                                     
                         
                                        
	#endif          

	PlayerUsedOffhand( player, weapon )
	if ( StatusEffect_GetSeverity( player, eStatusEffect.crypto_has_camera ) > 0.0 && StatusEffect_GetSeverity( player, eStatusEffect.camera_view ) == 0.0 )
	{
		#if SERVER
			                                          
				        

                                  
				                                                                                                                                      
				                      
                                        
			                                                                                                
			                                                                     
		#endif          
		return 0
	}

	int ammoReq = weapon.GetAmmoPerShot()
	if ( !weapon.HasMod( "crypto_has_camera" ) )
	{
		weapon.EmitWeaponSound_1p3p( "null_remove_soundhook", "null_remove_soundhook" )
		#if SERVER
			                                                                                          
		#endif          
	}

#if SERVER
                                       
                                               
   
                                             
           
   
      
   
           
   
       

                                 
                                            
       
	        
#endif          
}

void function OnWeaponTossPrep_ability_crypto_drone( entity weapon, WeaponTossPrepParams prepParams )
{
                                
	#if CLIENT
		if ( InPrediction() )
	#endif          
			weapon.AddMod( "crypto_drone_access" )
                                       
                                                                                                                 
   
            
                        
                  
                                             

         
   
      
		entity player = weapon.GetOwner()
		if ( StatusEffect_GetSeverity( player, eStatusEffect.crypto_has_camera ) <= 0.0 && StatusEffect_GetSeverity( player, eStatusEffect.camera_view ) == 0.0 )
			thread CryptoDrone_WeaponInputThink( weapon.GetWeaponOwner(), weapon )
                                             
                                      

	if ( weapon.HasMod( "crypto_has_camera" ) )
		weapon.EmitWeaponSound_1p3p( "Char_11_Tactical_Secondary_Deploy", "" )
	else
		weapon.EmitWeaponSound_1p3p( "Char_11_Tactical_Deploy", "Char_11_Tactical_Deploy_3p" )
}

                               
void function OnWeaponRegenEnd_ability_crypto_drone( entity weapon )
{
	entity player = weapon.GetOwner()
	if ( StatusEffect_GetSeverity( player, eStatusEffect.crypto_has_camera ) <= 0.0 )
		thread CryptoDrone_TestSendPoint_Think( player )
}
      


#if CLIENT
void function OnClientAnimEvent_ability_crypto_drone( entity weapon, string name )
{
	if ( name != "screen_transition" )
		return

	entity localViewPlayer = GetLocalViewPlayer()
	if ( !IsValid( localViewPlayer ) )
		return

	entity weaponOwner = weapon.GetWeaponOwner()
	if ( weaponOwner != localViewPlayer )
		return

                               
	Crypto_TryPlayScreenTransition( weaponOwner, weapon, weapon.HasMod( "crypto_has_camera" ) )
     
                                                                                 
      
}

                               
void function Crypto_TryPlayScreenTransition( entity player, entity weapon, bool playFastTransition )
{
	if ( weapon.HasMod( "crypto_drone_access" ) )
		thread PlayScreenTransition( player, playFastTransition )
}
      

void function PlayScreenTransition( entity player, bool playFastTransition )
{
	EndSignal( player, "OnDeath", "OnDestroy" )

	entity cockpit = player.GetCockpit()
	if ( !IsValid( cockpit ) )
		return

	                                       
	int systemIndex = playFastTransition ? GetParticleSystemIndex( SCREEN_FAST_FX ) : GetParticleSystemIndex( SCREEN_FX )
	int fxID1       = StartParticleEffectOnEntity( player, systemIndex, FX_PATTACH_POINT_FOLLOW, cockpit.LookupAttachment( "CAMERA" ) )
	EffectSetIsWithCockpit( fxID1, true )

	var transitionRui
	if ( playFastTransition )
	{
		transitionRui = CreateFullscreenRui( $"ui/camera_transition_fast.rpak", 1000 )
	}
	else
	{
		transitionRui = CreateFullscreenRui( $"ui/camera_transition.rpak", 1000 )
		if ( IsValid( file.cryptoAnimatedTacticalRui ) )
		{
			RuiSetFloat( file.cryptoAnimatedTacticalRui, "loopStartTime", Time() )
			RuiSetFloat( file.cryptoAnimatedTacticalRui, "transitionEndTime", Time() + 0.66 )
			RuiSetBool( file.cryptoAnimatedTacticalRui, "inTransition", true )
			entity offhandWeapon = player.GetOffhandWeapon( OFFHAND_LEFT )
			if ( IsValid( offhandWeapon ) )
				RuiTrackFloat( file.cryptoAnimatedTacticalRui, "clipAmmoFrac", offhandWeapon, RUI_TRACK_WEAPON_CLIP_AMMO_FRACTION )
		}
	}

	                                      
	OnThreadEnd(
		function() : ( player, fxID1, transitionRui )
		{
			if ( IsValid( player ) && IsAlive( player ) )
			{
				if ( EffectDoesExist( fxID1 ) )
					EffectStop( fxID1, false, true )
			}

			RuiDestroyIfAlive( transitionRui )

			if ( IsValid( file.cameraRui ) )
				RuiSetBool( file.cameraRui, "inTransition", false )

			if ( IsValid( file.cameraCircleStatusRui ) )
				RuiSetBool( file.cameraCircleStatusRui, "isVisible", true )

			if ( IsValid( file.cryptoAnimatedTacticalRui ) )
				RuiSetBool( file.cryptoAnimatedTacticalRui, "inTransition", false )
		}
	)

	float endTime = playFastTransition ? 1.4 + Time() : 1.75 + Time()
                                
		bool needsButtonHeldDown = !playFastTransition
       
	while( Time() < endTime )
	{
                                 
			                                                                  
			                                                                   
			                                                                         
			  	     
        

		if ( IsValid( file.cameraRui ) )
			RuiSetBool( file.cameraRui, "inTransition", true )
		if ( IsValid( file.cameraCircleStatusRui ) )
			RuiSetBool( file.cameraCircleStatusRui, "isVisible", false )
		WaitFrame()
	}
}
#endif

  
                                                                                                                                      
                                                                                                                                                       
                                                                                                                                           
                                                                                                                                           
                                                                                                                                         
                                                                                                                                 
  

#if CLIENT
void function AttemptDroneRecall( entity player )
{
	if ( !TryCharacterButtonCommonReadyChecks( player ) )
		return
	Remote_ServerCallFunction( "ClientCallback_AttemptDroneRecall" )
}
#endif          

#if SERVER
                                                                
 
	                         
		      

	                                                        
		      

	                                              
		      

	                                                                                   
		      

	                                                                                         
		      

	                                                                                 
		      

	                           
 

                                                                     
 
	                                                                       
	                                                   
		      

                               
                                                            
                                                                        
         
       

	                                      
	                                                      
	                                                                              
		      

	                                                        
	                                                                                
		      

	                                                    
	 
		                                                               
		                        
			                                                                                                                                       
	 

	                                     
 
#endif          

                               
entity function CryptoDrone_ReleaseCamera( entity weapon, WeaponPrimaryAttackParams attackParams, float throwPower, vector ornull angularVelocity = null )
{
	#if CLIENT
		if ( !weapon.ShouldPredictProjectiles() )
			return null
	#endif          

	entity player = weapon.GetWeaponOwner()
	vector angles   = VectorToAngles( attackParams.dir )
	entity deployable = ThrowDeployable( weapon, attackParams, throwPower, CryptoDrone_CameraImpact, CryptoDrone_CameraImpact, <0,0,0> )

	if ( deployable )
	{
		deployable.SetAngles( <0, angles.y - 180, 0> )
		deployable.kv.collisionGroup = TRACE_COLLISION_GROUP_PLAYER
		#if SERVER
			                        
				                                                              

			                                                                                       
			                                         
		#endif          
	}

	return deployable
}

void function CryptoDrone_CameraImpact( entity projectile, DeployableCollisionParams collisionParams )
{
	#if SERVER
		                                    
		                                                   
		                          
			      

		                                    
		                                                                                     
		                                                                           

		                                                            
		                                                                        
				                                                            

		                                                                   
		                                                  

		                                
			                                               
	#endif         
	projectile.SetVelocity( <0, 0, 0> )
}

#if SERVER
                                                             
 
	        

	                                
		      

	                                       

	                        
		      

	                                                                                                                                                                                              
 
#endif

bool function CryptoDrone_WeaponInputCheck( entity player, entity weapon )
{
	if ( !IsValid( player ) || !IsValid( weapon ) )
		return false

	return player.IsInputCommandHeld( IN_OFFHAND1 )
}

void function CryptoDrone_WeaponInputThink( entity player, entity weapon )
{
	                                                                  
	EndSignal( player, "Crypto_Immediate_Camera_Access_Confirmed" )

	if ( !IsValid( player ) || !IsValid( weapon ) )
		return

	EndSignal( player, "OnDestroy" )
	EndSignal( weapon, "OnDestroy" )

	while ( player.IsInputCommandHeld( IN_OFFHAND1 ) && weapon.HasMod( "crypto_drone_access" ) )
		WaitFrame()

	if ( weapon.HasMod( "crypto_drone_access" ) )
	{
	#if CLIENT
		if ( InPrediction() )
	#endif          
			weapon.RemoveMod( "crypto_drone_access" )
	}
}
                                     

#if SERVER
                                             
 
	                                 
 

                                                                                                                                
                                               
 
	                                           
	                         
		      

	                                                                                                                                                                                                         
	                              
	 
		                                                      
		                                                      
		                                           
		                        
		                                                                 
		 
			                                
				                                
			    
				                               
			              
		 
		                                                                                      
		 
			                                                      
			              
		 
		                                
		 
			                                                            
				              
		 
		                                
		 
			                                             
				              
		 
		                                                                                                                       
		 
			                                        
			              
		 
              
		                                        
		 
			                                                              

			                                                             
			 
				                              
				                                             
					                                      

				                                                     
				 
					                                                                           
					                                          
				 

				                                                                                
				 
					                                                             
					                                  
				 
				              
			 
		 
                    
		                                                                                                      
		 
			                                                             
			 
				                                                         
				              
			 
		 

		              
		 
			                                                            
			                                                              
		 
	 
 

                                                   
 
	                                           
	                         
		      

	                                                                                                                                                                                                         
	                              
	 
		                                                                                                     
		                                                                                              
		 
			                   
				                                                              
		 
		                                                                                                                                           
		 
			                                                           
			                                                                                     
		 
	 
 

                                           
 
	                                                                                         
		      

	                                                        
	                     
	 
		                                                     
		                                                                                                                                                                       
		                                                                                                          
		 
			                                                                                                        
			                         
			                                  
		 
	 
 

                                                
 
	                                           

	                         
		            

	                                        
		            

	                                          

	           
 

                                                               
 
	                                
	                  
	                                      

	                                
	                       
	 
		                                                                                            
		                                                                                                         
		                                                                                                          
		                                                                                                     
	 

	                                        

                                
		                                          
		                                    
       

	                                                                                                                                                                                               
	                          
	                                               
		                                                                                  
	    
		                                                        
	                                   

	                                            

	                          

	                                        
	                                                                           

	                                                                                                       

                               
	                                                
      
	                
 

                                                    
 
	                                                                                  

	                                                                                               
	 
		                                                                                                                                   
		                                                                                                 
		                            
	 

	                         
	 
		                                                                                                                                                                               

		                                                                                                                                             
	 
 

                               
                                                                                                                                           
 
	                                
		            

	                                                   
	                                  
	 
		                           

		                                                  
		                                                                                                             

		                        
		 
			                                         
			                                                    
			                                                                     
		 
		                          
		                                        

		           
	 
	            
 
      

                                                                                                             
 
	                                         
	                                       
	                                                                                                                                                                                                       
	                                           
	                                                   
	                                                                   
	                                                      
	                                               
	                                 
	                                
	                                          
	                                       
	                                       

                               
	                                              
	 
		                                              
		                                              
	 
	    
      
	 
		                                    
		                               
	 

	                                 
	                                            

	                            

                               
	                                              
		                                  
	    
      
		                                                                           

	                                                   
	                                                         

                               
	                                                                
     
                                           
      
	                                
	                                           
	                                            
	                                         
	                                          
	                                          
	                                                    
	                                                     
	                                          
	                                                                   
	                             
	                                                         
	                                     

	                                   
	                                                                           
	                                            
	                            
	                                                                            
	                                           
	                                         
	                               
	                                   
	                                        
	                                                    
	                                        
	                             
	 
		                                                 
	 
	                                           

	                                                                                                                                                                         
	                                                                             

	                            
	                                                           
	                                                                   
	                                                            
	                                  
	                                                             
	                                                  
	                                                                                           
	                              
	                                        
	                                        
	                                             
	                                  
	                                    

	                                                                       
	                                                                    

	                                        

                                
		                                                                            
		                                              
			                                                                 

		                      
		 
			                                                                
		 
       

	                  
 

                                      
                                                                                                              
 
                         
        

                                           

                                                   
                                                       
                                                
                                  
                                 
                                           
                                        
                                        

                                  
                                

                                  
                                             

                             

                                            
                                         

                                                                                                                                                        

                           
                                                                                  

                                                    
                                                          
                                           

                                 
                                            
                                             
                                          
                                           
                                           
                                                     
                                                      
                                           
                                                                    
                              
                                                          
                                      

                                                 

                                                              
                                            

             
                                                   
   
                          
    
                                                                        
                                                                                 
                                                                           
                                                                 
                                   
                                                   
                                       
    

                                
                         

                                 
                          
   
  

                                    
                                                                              
                                             
                                                                             
                                            
                                          
                                
                                    
                                         
                                                     
                                         
                              
  
                                                   
  
                                            

                                                                                                                                                                          
                                                                              

                             
                                                            
                                                                    
                                                             
                                   
                                                              
                                                   
                                                                                            
                               
                                         
                                         
                                              
                                   
                                     

                                                                        
                                                                     

                                                                 

                                         

                                                              
                                                                     
             

                                                                  
                                                                                                                                            
                                
  
                                             
                                                            
  
              
  
                                                                                 
                                                                                                
   
                                                                                                                                                                            
                              
   
          
  
 
                                            

                               
                                                      
 
	                                                                   
	                                       
	                                    

	                                             
		      

	                                                 
	                                                   
	                                       

	                                                
		                                               

	                                                               
	                                           

	            
		                                                                     
		 
			                       
			 
				                                                                    
				                                                                             
				                                                                       
				                                                             
				                               
					                                              
				                                   
			 

			                                  
				                          

			                               
				                       

			                              
				                      
		 
	 

	                                                                                                                                                                       
	                                                                                                                                                                                                                                                                 
	                                     
	                                                                                           

	                                
		                                                                                                                                                                                                            

	                     
	                                                                                                                       
	                                                                                          
	                

	                                                                                                                                           
	                                                             
	                               
		                                           

	                                                    

	             
	 
		                                                                                 
		                                                                                                
		 
			                                                                                                                                                                         
				                          
		 
		               
	 
 

                                                                                                                     
 
	                                   
	                                        
	                               
	                                     
	                             

	                                                                
		      

	                                                     

	            
		                              
		 
			                               
				                                                 
		 
	 

	                             
	                                                 
	                           
	                          
	                                     
	                                                                
	 
		                                                                                     
		                                          
		                                                              
		 
			                                                       
			 
				                     
			 
		 
		                                              
		                                                         	                                                                                                                          
		 
			                               
			                      
			 
				                    
			 
		 
		                    
		 
			                                       
			             
		 

		                                             
		                                                                        
		                                                  
		                                   
		                                      
		                                                                                                                                                                                   

		                                                   
		 
			                                                                                      
			                            
			     
		 
		                             
		 
			                                                                                   
			                         
			     
		 
		           
	 
 
                                     

                                                       
 
	                                          
	                                       
	                                    

	                                                                                
	                                     

	                                                                                                                                           
	                                                             
	                               
		                                           

	                                                             
	                                           

	                                        
	                                                    

	            
		                                                 
		 
			                       
			 
				                                                                    
				                                                                             
				                                                                       
				                                                             
				                               
					                                              
				                                   
			 

			                             
				                     

			                              
				                      
		 
	 

	             
	 
		                                                                               
		                                                                                              
		 
			                                                                                                                                                                         
				                          
		 
		               
	 
 

                                                         
 
	                                                     

	                                                          
	                                          
	                                           
	                                           
	                                            
	                                              
	                                             
	                                            
	                                             
	                                             

	                                               
	                                                              
	                                                                   
	                                 
	                              

	                                  
	                                              

	                             

	                                                 
	                                
	                               
	                                                              

	                   
 

                                                                    
 
	                                                             
	                                                                        
	                                            
	                                            
	                             

	                                                      
	                                                        
	                                                
	                             
	                                                                                
	                              
	                                   
	                       

	                                                           
	                                                             
	                                                           
	                                  
	                                                        
	                                   
	                                        
	                            

	            
		                                                   
		 
			                        
				                

			                             
				                     

			                              
				                      
		 
	 

	        
 

                               
                                                                          
 
	                                                                                   
		                                                                     
 

                                                           
 
	                              

	                                                  
		           

	                                                                          
 
      

                                                                          
 
	                                                                                                                          
	                                                 

                      
		                               
			      

		                                            
       

                 
		                                            
			      

		                                             
       

                                
		                                                
       

	                                               

	                                                                
	                                  
	                                                        
                                 
                                                       
       

                                
		                                          
		 
			                                                                                      
			                                           
			                                                                            
			                                           
			                                         
			                               
			                             
			                                        
			                                                    

			                                            
		 
       

	                                      
	                                                        

	                     
		                                                                

	                                                                   
	                                                                                      

	                                        
	 
		                    
			                                                                            
	 
	                                                
	 
		                    
			                                                  
	 
	                                             
	 
		                    
			                                               
	 

	                                               
		                                                 

	                                                                          
	                                                                                           
	                                                                                         

	                                      
	 
		                                                    
		                                                                         
	 

                                
		                                                                                                 
		                                                                                      
		                                            
      
                                                                                                                            
                                                                           
       
	                                                                     
	                                                                       
	                                                                      
	                                                                               

	                                

	                                    

	                                                                                                                                                                         
	                                           

	                                                                   
	                               
		                                     

	                                                               
		                                                                          

	            
		                                                                       
		 
			                                       
			                                                                                      
		 
	 

	                                                                                                                 
	                                                                                                       
	                                     
	                                               
	 
		                                    
		 
			                                                    
		 
		                                                                                                   
			                                     
			                                     
			                                                                         
				         
			                                                                              
				        

			        
		   
	 
	                                      
	                          

	             
	 
		                                                                                               

		                                               
		 
			                                           
			 
				                                    
				 
					                                       

					                             
						        

					                                     
						        

					                                                                                          
						        

					                                                    
					                                                                      
					                         
						        

					                                     
					                                                                                                             
					     
				 
			 

			                                          
			 
				                             
				 
					                                                                            
					                                                                               
					                                                                      
					                                                                                        
					                                          
					                                                             
					                                            
					                                                     

					                                                  
					 
						                                                             
						                                                                                                                                                          
					 
					    
					 
						                                                             
						                                                                                  
					 

					                                                                                          
					                                                                                                         

					                               
				 
			 
			        
		 
		    
		 
			        
		 
	 
 

                                                              
 
	                                    

	                                           
	                     
		      

	                  
	               
		              

	                                                    
 

                                                               
 
	                                                                                                   

	                               
	                       
	                             
	 
		                                       
			        

		                      
			        

		                                                                                               
		                          
			        

		                                 
		                                              
			        

		                                         
			        

		                                      
	 

	                             
 

                                                                                                                       
 
	                       
	 
		                                                                            
		                                                                        
		                                                                          
		                                                                         
		                                                                                  

		                                                       
		 
			                      
			                                                                                   
			               
		 
		                                
		                       
			                    
	 

	                         
	 
		                                                     
		                     
		                 
	 

	                              
	 
		                                                            
		                                        
		 
			                    
				                                                  
		 
		                                                
		 
			                    
				                                                                            
		 
		                                             
		 
			                    
				                                               
		 
		                                               
			                                                   
		                                                             
		                                                                      
		                                                                      
		                                                                          

		                                      
		 
			                                                    
			                                                    
		 

		                       
		 
			                                  
			                 
		 
	 

	                       
	 
		                                                                           
		                                                                       
		                                                                         
		                                          
		                            
		                         
		                        
		                                                              
		                                                           
                                  
                                                           
        

		                                                                                                                                                  
		                                    
		                                                               
			                                                                          
		                                                     

		                              
			                                                                                             

		                               
			                                    
	 
 

                                                              
 
	                                                         
	                                                          
	                                                           
	                                                                       

	                       

	                                                  
	 
		                                                                                                  
		                                                                                                                        
		 
			                                     
			                 
		 
		                                                                   
		 
			                       
			                              
				                                          
		 
		                                                  
		 
			                       
			                                                          
		 
	 
 

                                                                  
 
	                                                         
	                                                          
	                                                        
	                                                           
	                                                                       

	                                              
		      

	                                                              
	                                                              
	                    
		                               

	                                                                                

	                                               

	                                                 
		                                                                     
			                                           
			                                             
			                                   
			                                                        
			                                     
			                                   
			                                                  
 

                                                     
 
	                                                                                   

	                                                                                                               
		      

	                                               
	                                             
	                                                                          

	                                     
	                       
	 
		                                 
		                                                             

		                               
			                                            

		                                                                      
		                                                                              
	 
 

                                                                  
 
	                                        
	                                          
 
#endif         

#if CLIENT
void function Camera_OnCreate( entity player, int statusEffect, bool actuallyChanged )
{
	if ( player != GetLocalViewPlayer() )
		return

	thread TempUpdateRuiDistance( player )
}

void function Camera_OnDestroy( entity player, int statusEffect, bool actuallyChanged )
{
	if ( player != GetLocalViewPlayer() )
		return

	player.Signal( "StopUpdatingCameraRui" )

	if ( IsValid( file.cryptoAnimatedTacticalRui ) )
	{
		RuiSetFloat( file.cryptoAnimatedTacticalRui, "loopStartTime", Time() )
		RuiSetFloat( file.cryptoAnimatedTacticalRui, "recallTransitionEndTime", Time() + 0.66 )
		RuiSetFloat( file.cryptoAnimatedTacticalRui, "distanceToCrypto", 0 )
	}
}

void function AddCallback_OnEnterDroneView( void functionref() cb )
{
	Assert( !file.onEnterDroneViewCallbacks.contains( cb ) )
	file.onEnterDroneViewCallbacks.append( cb )
}

void function RemoveCallback_OnEnterDroneView( void functionref() cb )
{
	Assert( file.onEnterDroneViewCallbacks.contains( cb ) )
	file.onEnterDroneViewCallbacks.removebyvalue( cb )
}

void function Camera_OnBeginView( entity player, int statusEffect, bool actuallyChanged )
{
	thread Camera_OnBeginView_Think( player, statusEffect, actuallyChanged )
}

void function Camera_OnBeginView_Think( entity player, int statusEffect, bool actuallyChanged )
{
	if ( player != GetLocalViewPlayer() )
		return

	foreach ( void functionref() cb in file.onEnterDroneViewCallbacks )
		cb()

                               
	entity activeCamera
	while ( !IsValid( activeCamera ) )
	{
		array<entity> cameras = GetEntArrayByScriptName( CRYPTO_DRONE_SCRIPTNAME )
		foreach ( camera in cameras )
		{
			if ( camera.GetOwner() == player )
			{
				activeCamera = camera
				break
			}
		}
		WaitFrame()
	}

	Signal( activeCamera, "CameraViewStart" )

	                                              
	  	                                             

	                                                                                                                                                                       
	                                                                         
	                               
      

	file.cameraRui = CreateFullscreenRui( $"ui/camera_view.rpak" )
	RuiTrackFloat( file.cameraRui, "empFrac", player, RUI_TRACK_STATUS_EFFECT_SEVERITY, eStatusEffect.crypto_camera_is_emp )
                        
                                                                                                                                            
       
	RuiTrackFloat( file.cameraRui, "recallFrac", player, RUI_TRACK_STATUS_EFFECT_SEVERITY, eStatusEffect.crypto_camera_is_recalling )
	RuiTrackFloat( file.cameraRui, "beaconFrac", player, RUI_TRACK_STATUS_EFFECT_SEVERITY, eStatusEffect.crypto_beacon_scan )
                                
		                               
		                                               
		RuiSetBool( file.cameraRui, "droneHealth", true )
		RuiTrackFloat( file.cameraRui, "playerHealthFrac", activeCamera, RUI_TRACK_HEALTH )
      
                                                    
                                                                               
                                                                                        
       
	RuiTrackFloat3( file.cameraRui, "playerAngles", player, RUI_TRACK_CAMANGLES_FOLLOW )
	RuiTrackFloat3( file.cameraRui, "playerOrigin", player, RUI_TRACK_ABSORIGIN_FOLLOW )
	RuiSetFloat( file.cameraRui, "shieldSegments", float( player.GetShieldHealthMax() / 25 ) )
	RuiSetBool( file.cameraRui, "isVisible", !Fullmap_IsVisible() )
	                                                  

                                
		Minimap_SetSizeScale( 0.7 )
		Minimap_SetMasterTint( < .21, .79, .34 > )
		Minimap_SetOffset( 0.01, 0.022 )
		if ( GetCompassRui() != null )
			RuiSetBool( GetCompassRui(), "isVisible", false )
       

	entity offhandWeapon = player.GetOffhandWeapon( OFFHAND_ULTIMATE )
	if ( IsValid( offhandWeapon ) )
	{
		RuiTrackFloat( file.cameraRui, "clipAmmoFrac", offhandWeapon, RUI_TRACK_WEAPON_CLIP_AMMO_FRACTION )
		RuiSetFloat( file.cameraRui, "refillRate", offhandWeapon.GetWeaponSettingFloat( eWeaponVar.regen_ammo_refill_rate ) )
	}
	if ( IsControllerModeActive() )
		RuiSetString( file.cameraRui, "ultimateHint", "#WPN_CAMERA_EMP_CONTROLLER" )
	else
		RuiSetString( file.cameraRui, "ultimateHint", "#WPN_CAMERA_EMP" )

	ClGameState_SetHasScreenBorder( true )

	HideLootPrompts()

	                                  

	thread CameraView_CreateHUDMarker( player )
}

void function UpdateCameraVisibility()
{
	if ( file.cameraRui != null )
	{
		RuiSetBool( file.cameraRui, "isVisible", !Fullmap_IsVisible() )
	}
	if ( file.cameraCircleStatusRui != null )
	{
		bool isVisible = !Fullmap_IsVisible() && file.cameraRui != null
		RuiSetBool( file.cameraCircleStatusRui, "isVisible", isVisible )
	}
}


void function AddCallback_OnLeaveDroneView( void functionref() cb )
{
	Assert( !file.onLeaveDroneViewCallbacks.contains( cb ) )
	file.onLeaveDroneViewCallbacks.append( cb )
}

void function RemoveCallback_OnLeaveDroneView( void functionref() cb )
{
	Assert( file.onLeaveDroneViewCallbacks.contains( cb ) )
	file.onLeaveDroneViewCallbacks.removebyvalue( cb )
}

void function Camera_OnEndView( entity player, int statusEffect, bool actuallyChanged )
{
	if ( player != GetLocalViewPlayer() )
		return

	player.Signal( "CameraViewEnd" )

	foreach ( void functionref() cb in file.onLeaveDroneViewCallbacks )
		cb()

	if ( IsValid( file.cameraCircleStatusRui ) )
		RuiSetBool( file.cameraCircleStatusRui, "isVisible", false )

	ClGameState_SetHasScreenBorder( false )

                                
		Minimap_SetSizeScale( 1.0 )
		Minimap_SetMasterTint( < 1.0, 1.0, 1.0 > )
		Minimap_SetOffset( 0.0, 0.0 )
		if ( GetCompassRui() != null )
			RuiSetBool( GetCompassRui(), "isVisible", true )

		entity drone = CryptoDrone_GetPlayerDrone( player )
		if ( IsValid( drone ) )
			thread CryptoDrone_CreateHUDMarker( drone )

		                                              
		  	                                             

		                                                                                                                                                                 
		                                                                         
		                               
       

	                                    

	RuiDestroyIfAlive( file.cameraRui )
	file.cameraRui = null
}


void function AddCallback_OnRecallDrone( void functionref() cb )
{
	Assert( !file.onRecallDroneCallbacks.contains( cb ) )
	file.onRecallDroneCallbacks.append( cb )
}


void function RemoveCallback_OnRecallDrone( void functionref() cb )
{
	Assert( file.onRecallDroneCallbacks.contains( cb ) )
	file.onRecallDroneCallbacks.removebyvalue( cb )
}


void function Camera_OnBeginRecall( entity player, int statusEffect, bool actuallyChanged )
{
	foreach ( void functionref() cb in file.onRecallDroneCallbacks )
		cb()
}


void function Camera_OnEndRecall( entity player, int statusEffect, bool actuallyChanged )
{
}


                                                                                  
void function TempUpdateRuiDistance( entity player )
{
	EndSignal( player,  "OnDestroy", "StopUpdatingCameraRui" )

	entity activeCamera
	while( !IsValid( activeCamera ) )
	{
		array<entity> cameras = GetEntArrayByScriptName( CRYPTO_DRONE_SCRIPTNAME )
		foreach ( camera in cameras )
		{
			if ( camera.GetOwner() == player )
			{
				activeCamera = camera
				break
			}
		}
		WaitFrame()
	}

	EndSignal( activeCamera, "OnDestroy" )
	OnThreadEnd(
		function() : ( activeCamera )
		{
			if ( EffectDoesExist( activeCamera.e.cameraMaxRangeFXHandle ) )
				EffectStop( activeCamera.e.cameraMaxRangeFXHandle, true, false )
		}
	)
	bool outOfRange          = false
	bool inWarningRange      = false
	bool useInputWasDownLast = player.IsUserCommandButtonHeld( IN_USE )
	while( true )
	{
		bool useInputIsDown  = player.IsUserCommandButtonHeld( IN_USE )
		bool useInputPressed = (useInputIsDown && !useInputWasDownLast)
		useInputWasDownLast = useInputIsDown

		bool flightModeInputIsHeld = player.IsUserCommandButtonHeld( IN_ZOOM | IN_ZOOM_TOGGLE )

		float distanceToCrypto = Distance( player.GetOrigin(), activeCamera.GetOrigin() )
		inWarningRange = distanceToCrypto > WARNING_RANGE || activeCamera.GetOrigin().z > file.droneMaxZ - 400.0
		if ( activeCamera.e.cameraMaxRangeFXHandle > -1 && (!inWarningRange || !IsValid( file.cameraRui )) )                                            
		{
			if ( EffectDoesExist( activeCamera.e.cameraMaxRangeFXHandle ) )
				EffectStop( activeCamera.e.cameraMaxRangeFXHandle, true, false )
			activeCamera.e.cameraMaxRangeFXHandle = -1
		}
		if ( IsValid( file.cameraRui ) )
		{
			if ( inWarningRange )
			{
				if ( activeCamera.e.cameraMaxRangeFXHandle == -1 )
				{
					entity cockpit = player.GetCockpit()
					if ( IsValid( cockpit ) )
					{
						activeCamera.e.cameraMaxRangeFXHandle = StartParticleEffectOnEntity( cockpit, GetParticleSystemIndex( CAMERA_MAX_RANGE_SCREEN_FX ), FX_PATTACH_ABSORIGIN_FOLLOW, ATTACHMENTID_INVALID )
						EffectSetIsWithCockpit( activeCamera.e.cameraMaxRangeFXHandle, true )
					}
				}
				outOfRange = distanceToCrypto > MAX_FLIGHT_RANGE || activeCamera.GetOrigin().z > file.droneMaxZ
				if ( EffectDoesExist( activeCamera.e.cameraMaxRangeFXHandle ) )
				{
					if ( outOfRange )
						EffectSetControlPointVector( activeCamera.e.cameraMaxRangeFXHandle, 1, <1, 0, 0> )
					else
						EffectSetControlPointVector( activeCamera.e.cameraMaxRangeFXHandle, 1, <0.1, 0, 0> )
				}
			}
			float distanceToTarget = Distance( player.GetCrosshairTraceEndPos(), activeCamera.GetOrigin() )
			RuiSetFloat( file.cameraRui, "crossDist", distanceToTarget )
			string targetString = ""
			TraceResults trace  = TraceLineHighDetail( activeCamera.GetOrigin(), activeCamera.GetOrigin() + activeCamera.GetForwardVector() * 300, [activeCamera], TRACE_MASK_SHOT | TRACE_MASK_BLOCKLOS, TRACE_COLLISION_GROUP_NONE )
			if ( IsValid( trace.hitEnt ) )
			{
				entity isLootBin = GetLootBinForHitEnt( trace.hitEnt )
				entity isAirdrop = GetAirdropForHitEnt( trace.hitEnt )
				entity parentEnt = trace.hitEnt.GetParent()
				if ( IsDoor( trace.hitEnt ) && DroneCanOpenDoor( trace.hitEnt ) )
				{
					targetString = "#CAMERA_INTERACT_DOOR"
				}
				else if ( IsValid( parentEnt ) && IsDoor( parentEnt ) && DroneCanOpenDoor( parentEnt ) )
				{
					targetString = "#CAMERA_INTERACT_DOOR"
				}
              
				else if ( (IsVaultPanel( trace.hitEnt ) || IsVaultPanel( parentEnt )) )
				{
					UniqueVaultData vaultData = GetUniqueVaultData( trace.hitEnt )
					if ( player.GetPlayerNetBool( vaultData.hasVaultKeyString ) )
						targetString = vaultData.hintVaultKeyUse
				}
                    
				else if ( IsValid( isLootBin ) && !LootBin_IsBusy( isLootBin ) && !LootBin_IsFullyOpenedForPlayer( isLootBin, player ) )
				{
					targetString = "#CAMERA_INTERACT_LOOT_BIN"
				}
				else if ( IsValid( isAirdrop ) && !GradeFlagsHas( isAirdrop, eGradeFlags.IS_BUSY ) && !isAirdrop.e.isBusy )
				{
					targetString = "#CAMERA_INTERACT_AIRDROP"
				}
				else if ( trace.hitEnt.GetTargetName() == DEATH_BOX_TARGETNAME && ShouldPickupDNAFromDeathBox( trace.hitEnt, player ) )
				{
					if ( trace.hitEnt.GetCustomOwnerName() != "" )
						targetString = Localize( "#CAMERA_INTERACT_DEATHBOX", trace.hitEnt.GetCustomOwnerName() )
					else
						targetString = Localize( "#CAMERA_INTERACT_DEATHBOX", trace.hitEnt.GetOwner().GetPlayerName() )
				}
				else if ( IsRespawnBeacon( trace.hitEnt ) && CountTeammatesWaitingToBeRespawned( player.GetTeam() ) > 0 && trace.hitEnt.e.isBusy == false )
				{
					targetString = "#CAMERA_INTERACT_RESPAWN"
				}
				else if ( IsBunkerLoreScreen( trace.hitEnt ) && !IsBunkerLoreScreenHacked( trace.hitEnt, player ) )
				{
					targetString = "#CAMERA_HOLD_INTERACT_LORE_MESSAGE"
				}
				else if ( trace.hitEnt.GetScriptName() == SURVEY_BEACON_SCRIPTNAME )
				{
					if ( ControlPanel_CanUseFunction( player, trace.hitEnt, 0 ) )
					{
						if ( HasActiveSurveyZone( player ) )
							targetString = "#SURVEY_ALREADY_ACTIVE"
						else
							targetString = "#CAMERA_INTERACT_SURVEY_BEACON"
					}
				}

				if ( (targetString != "") && useInputPressed )
					RuiSetGameTime( file.cameraRui, "playerAttemptedUse", Time() )
			}

			RuiSetString( file.cameraRui, "interactHint", targetString )
			RuiSetFloat( file.cameraRui, "distanceToCrypto", distanceToCrypto )
			RuiSetFloat( file.cameraRui, "maxFlightRange", MAX_FLIGHT_RANGE )
			RuiSetFloat( file.cameraRui, "maxZ", file.droneMaxZ )
			RuiSetBool( file.cameraRui, "flightModeInputIsHeld", flightModeInputIsHeld )
			RuiSetFloat3( file.cameraRui, "cameraOrigin", activeCamera.GetOrigin() )

			vector cameraVel   = activeCamera.GetVehicleVelocity()
			vector cameraVel2D = < cameraVel.x, cameraVel.y, 0.0 >
			float cameraSpeed  = Length( cameraVel2D ) / 350.0
			RuiSetFloat( file.cameraRui, "velocityScale", cameraSpeed )
		}
		if ( IsValid( file.cryptoAnimatedTacticalRui ) )
		{
			RuiSetFloat( file.cryptoAnimatedTacticalRui, "distanceToCrypto", distanceToCrypto )
		}
		WaitFrame()
	}
}
#endif         

bool function PlayerCanUseCamera( entity ownerPlayer, bool needsValidCamera )
{
	if ( ownerPlayer.IsTraversing() )
		return false

	if ( ownerPlayer.ContextAction_IsActive() )                                                                                                     
		return false

	if ( ownerPlayer.IsPhaseShifted() )
		return false

	if ( needsValidCamera && !IsValid( ownerPlayer.p.cryptoActiveCamera ) )
		return false

                      
		if ( ownerPlayer.IsDrivingVehicle() )
			return false
       

	array <entity> activeWeapons = ownerPlayer.GetAllActiveWeapons()
	if ( activeWeapons.len() > 1 )
	{
		entity offhandWeapon = activeWeapons[1]

		if ( IsValid( offhandWeapon ) && offhandWeapon.GetWeaponClassName() == HOLO_PROJECTOR_WEAPON_NAME )
		{
			return false
		}
	}

	return true
}

#if SERVER
                                                    
 
	                                     
 

                                                    
 
	                                                                                 
		                                    
 
#endif

  
                                                                                                                                                                                     
                                                                                                                                                                                                 
                                                                                                                                                                                          
                                                                                                                                                                                              
                                                                                                                                                                                                               
                                                                                                                                                                                                   
  

                                   
                                   
                                   

#if SERVER
                                                                     
 
	                                      
 

                                                                        
 
	                                       
 

                                                 
 
	                                                           
 

                                                    
 
	                                                                
 

                                                                                                          
 
	                                                            

	                                         
 

                                                            
 
	                                                            
 

                                                     
 
	                                                                 
 

                                                                                              
 
	                                                            
	                                                            
 

                                                     
 
	                                                                 
 

                                                       
 
	                                                                                                         
	                                                   
 

                                             
 
	                                                    
	                                      
	                                    

	                                                   
		                                             

	                       			                                              
	                            	                                                                             
	                                                                                    

	                
                               
	                                                                                                                                                                                            
	                                 
	                                                      
      

	                                                       

	            
		                                                                          
		 
			                           
				                   

			                                         
			                                 
			 
				                          
				 
					                                                                      
					                                                                                          
					 
						                                                                               
					 
				 
			 
		 
	 

	                                              
	                                 
	                                          

	             
	 
		                                                    
		                                                              
		 
			                                         
			                                 
			 
				                          
				 
					                                                                      
					                                          
						                                                                                 
				 
			 

			                 
			                      

			                                                      
		 

                                 
			                                                                               
				                                                       
			    
				                                                      
        

		                                        
                                 
			                                         
        

		                                 
		                                                                                                                              
		                                                                                                                     
		                                                                             
		                                               

		                                                             
		 
			                                 
			                                                                             
		 
		                                                                  
		 
			                                                     
				                                                                         
			    
				                                                                             
			                                
		 

		                                                                                                                
		                  

		                                       
		 
			                            
				        

			                                            
			                                      
			 
				                                       
				                                              
				 
					                           
						                                                                             
				 
				        
			 

			                                                             
			                                                                                                

			                                                
			 
				                                                       
				                                                           
				 
					                                                                         
					 
						                                                    
						                                                           
					 
				 
				    
				 
					                                                    
					                                                            
				 
				                                       

				                           
				                           
					                                                                             
			 
			                             
		 

		                                                                             
		                                 
		 
			                           
			 
				                                       
				        
			 

			                                          
				        

			                                                              
			                                          
				                                                                                 

			                                        
			 
				                                                             
				 
					                                                                      
					                                       
				 
			 
		 
		           
	 
 

                                                                                                        
 
	                                                                                                 

	                                            
		                                  

	                                                    
		                                                                        
	    
		                                                                   

	                     
 

                                                                                                           
 
	                                                                               

	                                                        
		                                            

	                     
 

                                                                                
 
	                                                                     

	                                  
	                                          
		                                  

	                             
		                                                              
 

                                                                               
 
	                                                                                             
	                                                                                           

                      
		                                                                         
       

	                  
	                                            
	 
		   	 
			                              
			                                                                                             
			 
			                       
	 

	                              
	                                            
	 
		                                            
		                          
	 

	              
 

                                                                                                      
 
	                                                   
	                                                                                                                                      

	                                             
	 
		                                  
			                                                         
	 

	                
	 
		                                   

		                                      
		 
			                                           
				                                      
		 

		                                                    
		 
			                                                     
		 
	 

	                       
 

                                                                     
 
	                                                                                                             
 

                                                                      
 
	                                                                                                              
 

                                                                      
 
	                                                                                                              
 

                                                      
 
	                                                            

	                                                                                      
		           

	                                                                                         
		           

	            
 
#endif              

  
                                                              
                                                                 
                                                                 
                                                                 
                                                                       
                                                                
  

                             
                             
                             

                               
void function CryptoDrone_TestSendPoint_Think( entity player )
{
	EndSignal( player, "OnDestroy", "Crypto_StopSendPointThink" )

	OnThreadEnd(
		function() : ( player )
		{
			entity weapon = player.GetOffhandWeapon( OFFHAND_TACTICAL )
			bool isPredictedOrServer = InPrediction() && IsFirstTimePredicted()
			#if SERVER
				                          
			#endif         

			if ( isPredictedOrServer )
			{
				if ( IsValid( weapon ) )
					weapon.SetScriptInt0( 0 )
			}
		}
	)

	while ( true )
	{
		                                                                                                                                                                           
		TraceResults tr = TraceHull( player.EyePosition(), player.EyePosition() + player.GetPlayerOrNPCViewVector() * CRYPTO_DRONE_STICK_RANGE, CRYPTO_DRONE_HULL_TRACE_MIN, CRYPTO_DRONE_HULL_TRACE_MAX, [ player ], TRACE_MASK_NPCSOLID, TRACE_COLLISION_GROUP_PLAYER )
		int pointInRange = tr.fraction < 1.0 ? 1 : 0

		entity weapon = player.GetOffhandWeapon( OFFHAND_TACTICAL )

		bool isPredictedOrServer = InPrediction() && IsFirstTimePredicted()
		#if SERVER
			                          
		#endif         

		if ( isPredictedOrServer )
		{
			if ( IsValid( weapon ) )
				weapon.SetScriptInt0( pointInRange )
		}
		WaitFrame()
	}


}
      

#if CLIENT
void function CryptoDrone_OnPropScriptCreated( entity ent )
{
	if ( ent.GetScriptName() == CRYPTO_DRONE_SCRIPTNAME )
	{
		ModelFX_EnableGroup( ent, "thrusters_friend" )
		ModelFX_EnableGroup( ent, "thrusters_foe" )
		if ( ent.GetOwner() == GetLocalViewPlayer() )
			thread CryptoDrone_CreateHUDMarker( ent )

		file.allDrones.append( ent )
	}
}

void function CryptoDrone_OnPropScriptDestroyed( entity ent )
{
	if ( ent.GetScriptName() == CRYPTO_DRONE_SCRIPTNAME )
	{
		file.allDrones.fastremovebyvalue( ent )
	}
}

void function CryptoDrone_OnPlayerTeamChanged( entity player, int oldTeam, int newTeam )
{
	foreach ( drone in file.allDrones )
	{
		if ( IsValid( drone ) )
		{
			                                                                
			ModelFX_DisableGroup( drone, "thrusters_friend" )
			ModelFX_DisableGroup( drone, "thrusters_foe" )

			ModelFX_EnableGroup( drone, "thrusters_friend" )
			ModelFX_EnableGroup( drone, "thrusters_foe" )
		}
	}
}

entity function CryptoDrone_GetPlayerDrone( entity player )
{
	foreach ( drone in file.allDrones )
	{
		if ( !IsValid( drone ) )
			continue

		entity owner = drone.GetOwner()

		if ( !IsValid( owner ) )
			continue

		if ( owner == player )
			return drone
	}

	return null
}

void function CryptoDrone_CreateHUDMarker( entity drone )
{
	EndSignal( drone, "OnDestroy", "CameraViewStart" )
	entity localViewPlayer = GetLocalViewPlayer()

	var rui = CreateFullscreenRui( $"ui/crytpo_drone_offscreen.rpak", RuiCalculateDistanceSortKey( localViewPlayer.EyePosition(), drone.GetOrigin() ) )
	RuiSetImage( rui, "icon", $"rui/hud/tactical_icons/tactical_crypto" )
	RuiSetBool( rui, "isVisible", true )
	RuiSetBool( rui, "pinToEdge", true )
	RuiSetBool( rui, "showClampArrow", true )

                               
	RuiSetBool( rui, "useBackground", true )
	RuiSetBool( rui, "showIconOnScreen", true )
	RuiSetImage( rui, "backgroundIcon", $"rui/hud/gametype_icons/obj_background_diamond_semi_fill_thin" )
      

	RuiSetBool( rui, "adsFade", true )
	RuiTrackFloat3( rui, "pos", drone, RUI_TRACK_OVERHEAD_FOLLOW )

	OnThreadEnd(
		function() : ( rui )
		{
			RuiDestroy( rui )
		}
	)

	WaitForever()
}

void function CameraView_CreateHUDMarker( entity player )
{
	EndSignal( player, "OnDestroy", "CameraViewEnd" )

	var rui = CreateFullscreenRui( $"ui/crytpo_drone_offscreen.rpak", RuiCalculateDistanceSortKey( player.EyePosition(), player.GetOrigin() ) )
	RuiSetImage( rui, "icon", $"rui/hud/common/crypto_logo" )
	RuiSetBool( rui, "isVisible", true )
	RuiSetBool( rui, "pinToEdge", true )
	RuiSetBool( rui, "showClampArrow", true )
	RuiSetBool( rui, "showIconOnScreen", true )
                                
                                                   
      
	RuiTrackFloat3( rui, "pos", player, RUI_TRACK_POINT_FOLLOW, player.LookupAttachment( "CHESTFOCUS" ) )

                               
	RuiSetBool( rui, "useBackground", true )
	RuiSetImage( rui, "backgroundIcon", $"rui/hud/gametype_icons/obj_background_diamond_semi_fill_thin" )
      

	OnThreadEnd(
		function() : ( rui )
		{
			RuiDestroy( rui )
		}
	)

	WaitForever()
}

var function GetCameraCircleStatusRui()
{
	return file.cameraCircleStatusRui
}

void function CreateCameraCircleStatusRui()
{
                           
		if ( IsDeathTriggerGameMode() )
		{
			file.cameraCircleStatusRui = CreateFullscreenRui( $"ui/camera_circle_status_death_trigger.rpak" )
		}
		else
		{
			file.cameraCircleStatusRui = CreateFullscreenRui( $"ui/camera_circle_status.rpak" )
		}
      
                                                                                     
       
	entity localViewPlayer = GetLocalViewPlayer()
	RuiTrackFloat( file.cameraCircleStatusRui, "deathfieldDistance", localViewPlayer, RUI_TRACK_DEATHFIELD_DISTANCE )
	RuiTrackFloat( file.cameraCircleStatusRui, "cameraViewFrac", localViewPlayer, RUI_TRACK_STATUS_EFFECT_SEVERITY, eStatusEffect.camera_view )
                                
		RuiSetBool( file.cameraCircleStatusRui, "cryptoHudUpdate", true )
       
}

void function DestroyCameraCircleStatusRui()
{
	if ( file.cameraCircleStatusRui != null )
	{
		RuiDestroyIfAlive( file.cameraCircleStatusRui )
		file.cameraCircleStatusRui = null
	}
}

var function GetCryptoAnimatedTacticalRui()
{
	return file.cryptoAnimatedTacticalRui
}

var function CreateCryptoAnimatedTacticalRui()
{
	file.cryptoAnimatedTacticalRui = CreateCockpitPostFXRui( $"ui/crypto_tactical.rpak", HUD_Z_BASE )
	UpdateCryptoAnimatedTacticalRui()
	return file.cryptoAnimatedTacticalRui
}

void function UpdateCryptoAnimatedTacticalRui()
{
	entity localViewPlayer = GetLocalViewPlayer()
	if ( IsValid( localViewPlayer ) )
	{
		RuiTrackFloat( file.cryptoAnimatedTacticalRui, "empFrac", localViewPlayer, RUI_TRACK_STATUS_EFFECT_SEVERITY, eStatusEffect.crypto_camera_is_emp )
                        
                                                                                                                                                     
       
		RuiTrackFloat( file.cryptoAnimatedTacticalRui, "recallFrac", localViewPlayer, RUI_TRACK_STATUS_EFFECT_SEVERITY, eStatusEffect.crypto_camera_is_recalling )
		RuiTrackFloat( file.cryptoAnimatedTacticalRui, "hasCamera", localViewPlayer, RUI_TRACK_STATUS_EFFECT_SEVERITY, eStatusEffect.crypto_has_camera )
		RuiSetFloat( file.cryptoAnimatedTacticalRui, "maxFlightRange", MAX_FLIGHT_RANGE )
		RuiTrackFloat( file.cryptoAnimatedTacticalRui, "bleedoutEndTime", localViewPlayer, RUI_TRACK_SCRIPT_NETWORK_VAR, GetNetworkedVariableIndex( "bleedoutEndTime" ) )
		RuiTrackFloat( file.cryptoAnimatedTacticalRui, "reviveEndTime", localViewPlayer, RUI_TRACK_SCRIPT_NETWORK_VAR, GetNetworkedVariableIndex( "reviveEndTime" ) )

		entity offhandWeapon = localViewPlayer.GetOffhandWeapon( OFFHAND_LEFT )
		if ( IsValid( offhandWeapon ) )
		{
			RuiTrackFloat( file.cryptoAnimatedTacticalRui, "stockAmmoFrac", offhandWeapon, RUI_TRACK_WEAPON_REMAINING_AMMO_FRACTION )
			RuiTrackFloat( file.cryptoAnimatedTacticalRui, "clipAmmoFrac", offhandWeapon, RUI_TRACK_WEAPON_CLIP_AMMO_FRACTION )
			RuiTrackFloat( file.cryptoAnimatedTacticalRui, "maxMagAmmo", offhandWeapon, RUI_TRACK_WEAPON_CLIP_AMMO_MAX )
			RuiTrackFloat( file.cryptoAnimatedTacticalRui, "maxAmmo", offhandWeapon, RUI_TRACK_WEAPON_AMMO_MAX )
			RuiTrackFloat( file.cryptoAnimatedTacticalRui, "regenAmmoRate", offhandWeapon, RUI_TRACK_WEAPON_AMMO_REGEN_RATE )

			int maxAmmoReady  = offhandWeapon.GetWeaponSettingInt( eWeaponVar.ammo_clip_size )
			int ammoPerShot   = offhandWeapon.GetWeaponSettingInt( eWeaponVar.ammo_per_shot )
			int ammoMinToFire = offhandWeapon.GetWeaponSettingInt( eWeaponVar.ammo_min_to_fire )

			if ( maxAmmoReady == 0 )
				maxAmmoReady = 1

			RuiSetFloat( file.cryptoAnimatedTacticalRui, "minFireFrac", float( ammoMinToFire ) / float( maxAmmoReady ) )
			RuiSetInt( file.cryptoAnimatedTacticalRui, "ammoMinToFire", ammoMinToFire )

			if ( ammoPerShot == 0 )
				ammoPerShot = 1

			RuiSetInt( file.cryptoAnimatedTacticalRui, "segments", maxAmmoReady / ammoPerShot )
		}

                 
			if ( StatusEffect_GetSeverity( localViewPlayer, eStatusEffect.is_boxing ) )
				RuiSetBool( file.cryptoAnimatedTacticalRui, "isBoxing", true )
			else
				RuiSetBool( file.cryptoAnimatedTacticalRui, "isBoxing", false )
        
	}
}

void function TrackCryptoAnimatedTacticalRuiOffhandWeapon()
{
	if ( file.cryptoAnimatedTacticalRui != null )
	{
		entity localViewPlayer = GetLocalViewPlayer()
		if ( IsValid( localViewPlayer ) )
		{
			entity offhandWeapon = localViewPlayer.GetOffhandWeapon( OFFHAND_LEFT )
			if ( IsValid( offhandWeapon ) )
			{
				RuiTrackFloat( file.cryptoAnimatedTacticalRui, "clipAmmoFrac", offhandWeapon, RUI_TRACK_WEAPON_CLIP_AMMO_FRACTION )

				if ( IsArenaMode() )
				{
					RuiTrackFloat( file.cryptoAnimatedTacticalRui, "maxMagAmmo", offhandWeapon, RUI_TRACK_WEAPON_CLIP_AMMO_MAX )
					RuiTrackFloat( file.cryptoAnimatedTacticalRui, "maxAmmo", offhandWeapon, RUI_TRACK_WEAPON_AMMO_MAX )
					RuiTrackFloat( file.cryptoAnimatedTacticalRui, "stockpileFrac", offhandWeapon, RUI_TRACK_WEAPON_REMAINING_AMMO_FRACTION )
					RuiSetBool( file.cryptoAnimatedTacticalRui, "displayStockpileCharges", true )
				}
			}
		}
	}
}

void function DestroyCryptoAnimatedTacticalRui()
{
	if ( file.cryptoAnimatedTacticalRui != null )
	{
		RuiDestroyIfAlive( file.cryptoAnimatedTacticalRui )
		file.cryptoAnimatedTacticalRui = null
	}
}

void function CryptoDrone_WeaponStatusCheck( entity player, var rui, int slot )
{
	if ( !PlayerHasPassive( player, ePassives.PAS_CRYPTO ) )
		return

	switch ( slot )
	{
		case OFFHAND_LEFT:
			entity offhandWeapon = player.GetOffhandWeapon( OFFHAND_LEFT )
			if ( IsValid( offhandWeapon ) && file.cryptoAnimatedTacticalRui != null )
			{
				UpdateCryptoAnimatedTacticalRui()
				RuiTrackFloat( file.cryptoAnimatedTacticalRui, "clipAmmoFrac", offhandWeapon, RUI_TRACK_WEAPON_CLIP_AMMO_FRACTION )
			}
			RuiSetBool( rui, "isVisible", false )
			break

		case OFFHAND_INVENTORY:
                         
                                                                                                                                  
                                                                            
       
                                                                          
                             
			if ( StatusEffect_GetSeverity( player, eStatusEffect.crypto_has_camera ) == 0.0 )                                                                                                          
				RuiSetString( rui, "hintText", Localize( "#CRYPTO_DRONE_REQUIRED" ) )
        
			break
	}
}

void function CryptoDrone_OnLifeStateChanged( entity player, int oldLifeState, int newLifeState )
{
	entity localViewPlayer = GetLocalViewPlayer()
	if ( player != localViewPlayer )
		return

	if ( newLifeState != LIFE_ALIVE )
		return

	if ( IsValid( file.cryptoAnimatedTacticalRui ) )
	{
		entity offhandWeapon = localViewPlayer.GetOffhandWeapon( OFFHAND_LEFT )
		if ( IsValid( offhandWeapon ) )
			RuiTrackFloat( file.cryptoAnimatedTacticalRui, "clipAmmoFrac", offhandWeapon, RUI_TRACK_WEAPON_CLIP_AMMO_FRACTION )
	}
}
#endif              

#if CLIENT
void function ServerToClient_CryptoDroneAutoReloadDone( entity weapon )
{
	if ( !IsValid( weapon ) )
		return

	if ( file.cameraRui == null )
		return

	string weaponName = weapon.GetWeaponSettingString( eWeaponVar.shortprintname )
	asset weaponIcon  = weapon.GetWeaponSettingAsset( eWeaponVar.hud_icon )
	RuiSetString( file.cameraRui, "weaponReloadedHintText", format( "%s %%$%s%%",
		Localize( "#CRYPTO_AUTO_RELOAD_DONE", Localize( weaponName ) ),
		string(weaponIcon) ) )
	RuiSetGameTime( file.cameraRui, "weaponReloadedHintChangeTime", Time() )
}
#endif

bool function IsPlayerInCryptoDroneCameraView( entity player )
{
	return StatusEffect_GetSeverity( player, eStatusEffect.camera_view ) > 0.0
}

bool function AutoReloadWhileInCryptoDroneCameraView()
{
	return GetCurrentPlaylistVarBool( "crypto_tactical_auto_reload_weapons", true )
}

float function GetNeurolinkRange( entity player )
{
	return file.neurolinkRange
}

bool function DroneCanOpenDoor( entity door )
{
	if ( IsVaultDoor( door ) )
		return false

	return !IsDoorLocked( door )
}

void function CryptoDrone_SetMaxZ( float maxZ )
{
	file.droneMaxZ = maxZ
}


bool function DroneHasMaxZ()
{
	return file.droneMaxZ < 60000
}

#if CLIENT
                               
void function MinimapPackage_PlayerDummy( entity ent, var rui )
{
	RuiSetImage( rui, "defaultIcon", $"rui/hud/minimap/compass_icon_player" )
	RuiSetImage( rui, "clampedDefaultIcon", $"rui/hud/minimap/compass_icon_player_clamped" )
	RuiSetBool( rui, "useTeamColor", false )
	RuiSetFloat( rui, "iconBlend", 0.0 )
	RuiSetBool( rui, "invertCameraViewFrac", false )

	RuiTrackFloat( rui, "cameraViewFrac", ent, RUI_TRACK_STATUS_EFFECT_SEVERITY, eStatusEffect.camera_view )
}
      

void function MinimapPackage_CryptoDrone( entity ent, var rui )
{
	#if MINIMAP_DEBUG
		printt( "Adding 'rui/hud/tactical_icons/tactical_crypto' icon to minimap" )
	#endif
	RuiSetImage( rui, "defaultIcon", $"rui/hud/tactical_icons/tactical_crypto" )
	RuiSetImage( rui, "clampedDefaultIcon", $"rui/hud/tactical_icons/tactical_crypto" )
	RuiSetBool( rui, "useTeamColor", false )
	RuiSetFloat( rui, "iconBlend", 0.0 )
                               
	                               
	                                                                                                                     
      
}
#endif