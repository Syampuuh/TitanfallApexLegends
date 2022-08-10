global function MpWeaponMobileHMG_Init
global function OnWeaponActivate_weapon_mobile_hmg
global function OnWeaponDeactivate_weapon_mobile_hmg
global function OnWeaponPrimaryAttack_weapon_mobile_hmg
global function OnWeaponStartZoomIn_weapon_mobile_hmg
global function OnWeaponStartZoomOut_weapon_mobile_hmg
global function OnWeaponReload_weapon_mobile_hmg
global function OnAnimEvent_weapon_mobile_hmg
global function OnWeaponZoomFOVToggle_weapon_mobile_hmg
global function OnWeaponAttemptOffhandSwitch_weapon_mobile_hmg
global function MobileHMG_RegisterNetworkFunctions

#if SERVER
                                                            
                                          
                                                
                                                           
                                  
                                            
#endif

#if CLIENT
global function OnClientAnimEvent_weapon_mobile_hmg
#endif

global const string MOBILE_HMG_WEAPON_NAME = "mp_weapon_mobile_hmg"

        
const string TURRET_BUTTON_PRESS_SOUND_1P = "weapon_sheilaturret_triggerpull"
const string TURRET_BUTTON_PRESS_SOUND_3P = "weapon_sheilaturret_triggerpull_3p"
const string TURRET_BARREL_SPIN_LOOP_1P = "weapon_sheilaturret_motorloop_1p"
const string TURRET_BARREL_SPIN_LOOP_3P = "Weapon_sheilaturret_mobile_motorLoop_3P"
const string TURRET_WINDUP_1P = "weapon_sheilaturret_windup_1p"
const string TURRET_WINDUP_3P = "weapon_sheilaturret_windup_3p"
const string TURRET_WINDDOWN_1P = "weapon_sheilaturret_mobile_winddown_1p"
const string TURRET_WINDDOWN_3P = "weapon_sheilaturret_winddown_3P"
const string TURRET_RELOAD_3P = "weapon_sheilaturret_reload_generic_comp_3p"
const string TURRET_RELOAD_RAMPART_3P = "weapon_sheilaturret_reload_rampart_comp_3p"
const string TURRET_RELOAD = "weapon_sheilaturret_reload_rampart_null"
const string TURRET_FIRED_LAST_SHOT_1P = "weapon_sheilaturret_lastshot_1p"
const string TURRET_FIRED_LAST_SHOT_3P = "weapon_sheilaturret_lastshot_3p"
const string TURRET_DISMOUNT_1P = "weapon_sheilaturret_mobile_dismount_1p"
const string TURRET_SIGHT_FLIP_UP_1P = "weapon_sheilaturret_sightflipup"
const string TURRET_SIGHT_FLIP_DOWN_1P = "weapon_sheilaturret_sightflipdown"

const string TURRET_DRAWFIRST_1P = "weapon_sheilaturret_drawfirst_1p"
const string TURRET_DRAW_1P = "weapon_sheilaturret_draw_1p"

           
const float GLOBAL_TURRET_CHATTER_DEBOUNCE = 7.0
const float SUSTAINED_FIRE_QUIP_CHANCE = 0.15

     
const TURRET_LASER_1P				= $"P_wpn_rampart_laser_aim_FP"

         
const string MOBILE_HMG_COOLDOWN_SIGNAL = "mobile_hmg_cooldown"
const string MOBILE_HMG_KILL_UI_SIGNAL = "mobile_hmg_kill_ui"
const string MOBILE_HMG_ACTIVATE_SIGNAL = "mobile_hmg_activate"

      
global const string MOBILE_HMG_ACTIVE_MOD = "mobile_hmg_active"
global const string MOBILE_HMG_FAST_SWITCH_MOD = "mobile_hmg_fast_switch"

        
const float MAX_REFUND_PERCENTAGE = 0.75

struct
{
	#if SERVER
		                                                      
		                                   
		                                            
	#endif
	#if CLIENT
		int laserFXHandle = -1
	#endif
} file

void function MpWeaponMobileHMG_Init()
{
	RegisterAdditionalMainWeapon( MOBILE_HMG_WEAPON_NAME  )

	PrecacheParticleSystem( TURRET_LASER_1P )
	PrecacheParticleSystem( $"wpn_muzzleflash_rampart_turret_FP" )
	PrecacheParticleSystem( $"wpn_muzzleflash_rampart_turret" )
	PrecacheParticleSystem( $"wpn_muzzleflash_turret_center_FP" )
	PrecacheWeapon( MOUNTED_TURRET_PLACEABLE_WEAPON_NAME )
	RegisterSignal( MOBILE_HMG_COOLDOWN_SIGNAL )
	RegisterSignal( MOBILE_HMG_KILL_UI_SIGNAL )
	RegisterSignal( MOBILE_HMG_ACTIVATE_SIGNAL )

#if CLIENT
	RegisterConCommandTriggeredCallback( "+scriptCommand5", PlacementModeTogglePressed )
	RegisterConCommandTriggeredCallback( "+scriptCommand3", ForceCooldownPressed )
#endif
}

void function OnWeaponActivate_weapon_mobile_hmg( entity weapon )
{
	OnWeaponActivate_weapon_basic_bolt( weapon )
	entity weaponOwner = weapon.GetOwner()
	bool serverOrPredicted = IsServer() || ( InPrediction() && IsFirstTimePredicted() )
	if( serverOrPredicted && !weapon.HasMod( MOBILE_HMG_FAST_SWITCH_MOD ) )
	{
		weapon.w.startChargeTime = Time()
	}
#if SERVER
	                                           
	                                                
#endif          
#if CLIENT
	if ( weaponOwner != GetLocalViewPlayer() )
		return

	weapon.Signal( MOBILE_HMG_KILL_UI_SIGNAL )
	weapon.Signal( MOBILE_HMG_ACTIVATE_SIGNAL )
	thread PlacementModeHintRuiThread( weaponOwner, weapon )
	thread MobileHMG_WeaponActiveThreadClient( weapon )
#endif


	if ( serverOrPredicted )
	{
		weapon.SetTargetingLaserEnabled( false )
		#if SERVER
			                                             
			 
				                                      
				                                                   
			 
		#endif
	}
}

void function OnWeaponDeactivate_weapon_mobile_hmg( entity weapon )
{
	weapon.StopWeaponSound( TURRET_BARREL_SPIN_LOOP_1P )
	weapon.StopWeaponSound( TURRET_BARREL_SPIN_LOOP_3P )
	weapon.StopWeaponSound( TURRET_BUTTON_PRESS_SOUND_1P )
	weapon.StopWeaponSound( TURRET_BUTTON_PRESS_SOUND_3P )
	StopSoundOnEntity( weapon, TURRET_WINDUP_1P )
	StopSoundOnEntity( weapon, TURRET_WINDUP_3P )
	StopSoundOnEntity( weapon, TURRET_WINDDOWN_1P )
	StopSoundOnEntity( weapon, TURRET_RELOAD_3P )
	StopSoundOnEntity( weapon, TURRET_RELOAD_RAMPART_3P )

	entity weaponOwner = weapon.GetOwner()

	if ( !IsValid( weaponOwner ) )
		return

	StopSoundOnEntity( weaponOwner, TURRET_DRAWFIRST_1P )
	StopSoundOnEntity( weaponOwner, TURRET_DRAW_1P )

#if CLIENT
	SetTurretVMLaserEnabled( weapon, false )

	if ( weaponOwner == GetLocalViewPlayer() )
	{
		EmitSoundOnEntity( weaponOwner, TURRET_DISMOUNT_1P )
	}
#endif          

	bool serverOrPredicted = IsServer() || ( InPrediction() && IsFirstTimePredicted() )
	if ( serverOrPredicted )
	{
		weapon.SetTargetingLaserEnabled( false )
	#if SERVER
		                                              
	#endif
	}
}

bool function OnWeaponAttemptOffhandSwitch_weapon_mobile_hmg( entity weapon )
{
	int ammoReq = weapon.GetAmmoPerShot()
	int currAmmo = weapon.GetWeaponPrimaryClipCount()
	if ( currAmmo < ammoReq )
		return false

	entity player = weapon.GetWeaponOwner()
	if ( player.IsPhaseShifted() )
		return false

	return true
}

void function OnWeaponStartZoomIn_weapon_mobile_hmg( entity weapon )
{
	entity weaponOwner = weapon.GetWeaponOwner()

	if ( !IsValid( weaponOwner ) )
		return

	float zoomFrac = weaponOwner.GetZoomFrac()
	float zoomTimeIn = weapon.GetWeaponSettingFloat( eWeaponVar.zoom_time_in )

	#if SERVER
		                                                                                                       
	#endif
	#if CLIENT
		if ( weaponOwner == GetLocalViewPlayer() )
		{
			EmitSoundOnEntityWithSeek( weapon, TURRET_WINDUP_1P, zoomFrac * zoomTimeIn )

			if ( !InPrediction() || IsFirstTimePredicted() )
			{
				                                         
			}
		}
	#endif

	bool serverOrPredicted = IsServer() || ( InPrediction() && IsFirstTimePredicted() )
	if ( serverOrPredicted )
	{
		weapon.SetTargetingLaserEnabled( true )
	}
}

void function OnWeaponStartZoomOut_weapon_mobile_hmg( entity weapon )
{
	weapon.StopWeaponSound( TURRET_BARREL_SPIN_LOOP_1P )
	weapon.StopWeaponSound( TURRET_BARREL_SPIN_LOOP_3P )
	weapon.StopWeaponSound( TURRET_BUTTON_PRESS_SOUND_1P )
	weapon.StopWeaponSound( TURRET_BUTTON_PRESS_SOUND_3P )
	StopSoundOnEntity( weapon, TURRET_WINDUP_1P )
	StopSoundOnEntity( weapon, TURRET_WINDUP_3P )

	entity weaponOwner = weapon.GetWeaponOwner()
	if ( !IsValid( weaponOwner ) )
		return

	float zoomFrac = weaponOwner.GetZoomFrac()
	float zoomOutTime = weapon.GetWeaponSettingFloat( eWeaponVar.zoom_time_out )

	#if SERVER
		                                                                                                                
	#endif

	#if CLIENT
		SetTurretVMLaserEnabled( weapon, false )
		if ( weaponOwner == GetLocalViewPlayer() )
			EmitSoundOnEntityWithSeek( weapon, TURRET_WINDDOWN_1P, (1 - zoomFrac) * zoomOutTime )
	#endif
	bool serverOrPredicted = IsServer() || ( InPrediction() && IsFirstTimePredicted() )
	if ( serverOrPredicted )
	{
		weapon.SetTargetingLaserEnabled( false )
	}
}

var function OnWeaponPrimaryAttack_weapon_mobile_hmg( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	entity weaponOwner = weapon.GetOwner()

	if ( !IsValid( weaponOwner ) )
		return 0


	if ( weapon.IsWeaponInAds() && weaponOwner.GetZoomFrac() >= 1.0 )
	{
		           
		#if SERVER
			                                                                                          
				                                                                  

			                                                                                                                        
				                                                                   
		#endif          

		        
		if ( weapon.GetWeaponPrimaryClipCount() == 1 )
		{
			#if SERVER
				                                                                                 
				                                                     
			#elseif CLIENT
				if ( weaponOwner == GetLocalViewPlayer() )
					EmitSoundOnEntity( weapon, TURRET_FIRED_LAST_SHOT_1P )
				weapon.Signal( MOBILE_HMG_KILL_UI_SIGNAL )
			#endif
		}

		  	                      
		#if SERVER
			                                                      
		#endif

		if( weapon.GetWeaponPrimaryClipCount() == weapon.GetWeaponPrimaryClipCountMax() )
		{
			PlayerUsedOffhand( weaponOwner, weapon )
		}

		return OnWeaponPrimaryAttack_weapon_basic_bolt( weapon, attackParams )
	}
	else
	{
		return 0
	}
}

void function OnWeaponReload_weapon_mobile_hmg( entity weapon, int milestoneIndex )
{
	#if SERVER

		                          
		                         
		 
			       
				                                                
				     
			       
				                                                
				     
			       
				                                                
				     
			       
				                                                
				     
			       
				                                                
				     
		 

		              
		                                                                                                                                                        

		                                       
			                                                                                                        
		    
			                                                                                                
	#endif
}

void function OnAnimEvent_weapon_mobile_hmg( entity weapon, string eventName )
{
	switch ( eventName )
	{
		case "rampart_turret_mobile_button_press":
			weapon.EmitWeaponSound_1p3p( TURRET_BUTTON_PRESS_SOUND_1P, TURRET_BUTTON_PRESS_SOUND_3P )
			break
		case "rampart_turret_mobile_spin_up":
			weapon.EmitWeaponSound_1p3p( TURRET_BARREL_SPIN_LOOP_1P, TURRET_BARREL_SPIN_LOOP_3P )
			break
		default:
			return
	}
}

void function OnWeaponZoomFOVToggle_weapon_mobile_hmg( entity weapon, float targetFOV )
{
	#if CLIENT
	if ( weapon.GetOwner() != GetLocalViewPlayer() )
		return

	if ( targetFOV == weapon.GetWeaponSettingFloat( eWeaponVar.zoom_fov ) )             
	{
		EmitSoundOnEntity( weapon, TURRET_SIGHT_FLIP_DOWN_1P )
		StopSoundOnEntity( weapon, TURRET_SIGHT_FLIP_UP_1P )
	}
	else           
	{
		EmitSoundOnEntity( weapon, TURRET_SIGHT_FLIP_UP_1P )
		StopSoundOnEntity( weapon, TURRET_SIGHT_FLIP_DOWN_1P )
	}
	#endif
}

void function MobileHMG_RegisterNetworkFunctions()
{
	Remote_RegisterServerFunction( "ClientCallback_ToggleMobileHMGPlacementMode" )
	Remote_RegisterServerFunction( "ClientCallback_ForceCooldown" )
}

#if SERVER
                                                                 
 
	                                               

	                                
	                                            

	                              
		      
	                                     

	                                                                         
	                                  
		      
	                                         

	            
		                       
		 
			                       
			 
				                                         
			 
		 
	 

	             
	 
		                                                                                  
		                              
		 
			                                                                                                                                           
				      
		 
		           
	 
 

                                                           
 
	                                                              
	                            
		      

	                                                                    
	                                  
		      

	                                                                             


	                                                                                                
			                                                                                                                 
	 
		                                                    
		                               
		                                   
		                                              
	 
 

                                                                     
 
	                                
	                                

	                                           

	                                                                             
	                               
		      

	                                                                       
		                                                     
 

                                                                                       
 
	                                                    
 

                                                                             
 
	                       
		                                             
 

                                                                             
 
	                       
		                                                
 

                                                 
 
	                                       
	                        
		      

	                                                  
	                                                        
	                                                                       
	                               
	 
		                                                      
		                                                
	 
 

                                                                    
 
	                                                     
		      

	                                                     
	                                                              

 

                                                                  
 
	                         
		            

	                                                      
		            

	                                                                                                                                                        
 

                                                                          
 
	                         
		      

	                                                                             
	                               
		      

	                                                              
	                            
		      

	                                                                                                
		      

	                                                                                                
	                                  
		      

	                                                                                           
	 
		                                                
		                                                    
		                                                                                                   
	 
	                                                                                                                                                                       
	 
		                            
			      

		                                              
		                                                                                     
	 
 
#endif

#if CLIENT
void function MobileHMG_WeaponActiveThreadClient( entity weapon )
{
	EndSignal( weapon, MOBILE_HMG_ACTIVATE_SIGNAL )
	EndSignal( weapon, "OnDestroy" )
	entity weaponOwner = weapon.GetWeaponOwner()

	if ( !IsValid( weaponOwner ) )
		return
	EndSignal( weaponOwner, "OnDestroy" )
	EndSignal( weaponOwner, "OnDeath" )

	OnThreadEnd(
		function() : ( weaponOwner )
		{
			if( IsValid( weaponOwner ) )
			{
				InitWeaponStatusRuis( weaponOwner )
			}
		}
	)

	while( !weapon.HasMod( MOBILE_HMG_ACTIVE_MOD ) )
		WaitFrame()

	while( weapon.HasMod( MOBILE_HMG_ACTIVE_MOD ) )
	{
		InitWeaponStatusRuis( weaponOwner )
		WaitFrame()
	}
}

void function OnClientAnimEvent_weapon_mobile_hmg( entity weapon, string eventName )
{
	GlobalClientEventHandler( weapon, eventName )

	OnAnimEvent_weapon_mobile_hmg( weapon, eventName )

	if ( eventName == "muzzle_flash" )
		weapon.PlayWeaponEffect( $"wpn_muzzleflash_turret_center_FP", $"", "muzzle_flash" )

	if( eventName == "rampart_turret_mobile_laser_on" )
		SetTurretVMLaserEnabled( weapon, true )
}

void function SetTurretVMLaserEnabled( entity weapon, bool enabled )
{
	entity vm = weapon.GetWeaponViewmodel()

	int fxid = GetParticleSystemIndex( TURRET_LASER_1P )

	if ( enabled )
	{
		if ( file.laserFXHandle > -1 )
			SetTurretVMLaserEnabled( weapon, false )

		file.laserFXHandle = StartParticleEffectOnEntityWithPos( vm, fxid, FX_PATTACH_POINT_FOLLOW, vm.LookupAttachment( "LASER" ), <0,0,0>, <0,0,0> )
	}
	else
	{
		if ( file.laserFXHandle > -1 )
		{
			EffectStop( file.laserFXHandle, true, true )
			file.laserFXHandle = -1
		}
	}

}

void function PlacementModeHintRuiThread( entity player, entity weapon )
{
	EndSignal( weapon, "OnDestroy" )
	EndSignal( weapon, MOBILE_HMG_KILL_UI_SIGNAL )
	EndSignal( player, "OnDestroy" )

	var hintRui = CreateCockpitRui( $"ui/mobile_hmg_hint.rpak" )
	RuiTrackBool( hintRui, "weaponIsDisabled", weapon, RUI_TRACK_WEAPON_IS_DISABLED )

	OnThreadEnd(
		function() : ( hintRui )
		{
			RuiDestroyIfAlive( hintRui )
		}
	)

	while( true )
	{
		entity activeWeapon = player.GetActiveWeapon( eActiveInventorySlot.mainHand )
		if ( !IsValid( activeWeapon ) )
			return

		entity placementWeapon = player.GetOffhandWeapon( OFFHAND_RIGHT )

		if( activeWeapon == weapon )
			RuiSetString( hintRui, "hintText", "#WPN_MOBILE_HMG_SWITCH_TO_PLACEMENT" )
		else if( activeWeapon == placementWeapon )
			RuiSetString( hintRui, "hintText", "#WPN_MOBILE_HMG_SWITCH_TO_FIRE" )
		else
			return

		WaitFrame()
	}
}

void function PlacementModeTogglePressed( entity player )
{
	if ( player != GetLocalViewPlayer() )
		return

	entity activeWeapon = player.GetActiveWeapon( eActiveInventorySlot.mainHand )
	if ( !IsValid( activeWeapon ) )
		return

	entity ultWeapon = player.GetOffhandWeapon( OFFHAND_ULTIMATE )
	entity placementWeapon = player.GetOffhandWeapon( OFFHAND_RIGHT )
	if( activeWeapon == ultWeapon && ultWeapon.GetWeaponClassName() == MOBILE_HMG_WEAPON_NAME )
		Remote_ServerCallFunction( "ClientCallback_ToggleMobileHMGPlacementMode" )
	else if( activeWeapon == placementWeapon && placementWeapon.GetWeaponClassName() == MOUNTED_TURRET_PLACEABLE_WEAPON_NAME )
		Remote_ServerCallFunction( "ClientCallback_ToggleMobileHMGPlacementMode" )
}

void function ForceCooldownPressed( entity player )
{
	if ( player != GetLocalViewPlayer() )
		return

	entity activeWeapon = player.GetActiveWeapon( eActiveInventorySlot.mainHand )
	if ( !IsValid( activeWeapon ) )
		return

	entity ultWeapon = player.GetOffhandWeapon( OFFHAND_ULTIMATE )
	entity placementWeapon = player.GetOffhandWeapon( OFFHAND_RIGHT )
	if( activeWeapon == ultWeapon && ultWeapon.GetWeaponClassName() == MOBILE_HMG_WEAPON_NAME )
		Remote_ServerCallFunction( "ClientCallback_ForceCooldown" )
	else if( activeWeapon == placementWeapon && placementWeapon.GetWeaponClassName() == MOUNTED_TURRET_PLACEABLE_WEAPON_NAME )
		Remote_ServerCallFunction( "ClientCallback_ForceCooldown" )
}
#endif          

float function GetMaxRefundPercentage()
{
	return GetCurrentPlaylistVarFloat( "mobile_hmg_max_refund_percentage", MAX_REFUND_PERCENTAGE )
}
