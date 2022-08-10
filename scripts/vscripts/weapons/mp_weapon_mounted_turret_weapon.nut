global function MpWeaponMountedTurretWeapon_Init
global function OnWeaponActivate_weapon_mounted_turret_weapon
global function OnWeaponDeactivate_weapon_mounted_turret_weapon
global function OnWeaponPrimaryAttack_weapon_mounted_turret_weapon
global function OnWeaponStartZoomIn_weapon_mounted_turret_weapon
global function OnWeaponStartZoomOut_weapon_mounted_turret_weapon
global function OnWeaponReload_weapon_mounted_turret_weapon
global function OnAnimEvent_weapon_mounted_turret_weapon
global function OnWeaponZoomFOVToggle_weapon_mounted_turret_weapon

#if SERVER
                                                  
                                                  
                                                                      
#endif

#if CLIENT
global function OnClientAnimEvent_weapon_mounted_turret_weapon
#endif

global const string MOUNTED_TURRET_WEAPON_NAME = "mp_weapon_mounted_turret_weapon"

        
const string TURRET_BUTTON_PRESS_SOUND_1P = "weapon_sheilaturret_triggerpull"
const string TURRET_BUTTON_PRESS_SOUND_3P = "weapon_sheilaturret_triggerpull_3p"
const string TURRET_BARREL_SPIN_LOOP_1P = "weapon_sheilaturret_motorloop_1p"
const string TURRET_BARREL_SPIN_LOOP_3P = "Weapon_sheilaturret_MotorLoop_3P"
const string TURRET_WINDUP_1P = "weapon_sheilaturret_windup_1p"
const string TURRET_WINDUP_3P = "weapon_sheilaturret_windup_3p"
const string TURRET_WINDDOWN_1P = "weapon_sheilaturret_winddown_1P"
const string TURRET_WINDDOWN_3P = "weapon_sheilaturret_winddown_3P"
const string TURRET_RELOAD_3P = "weapon_sheilaturret_reload_generic_comp_3p"
const string TURRET_RELOAD_RAMPART_3P = "weapon_sheilaturret_reload_rampart_comp_3p"
const string TURRET_RELOAD = "weapon_sheilaturret_reload_rampart_null"
const string TURRET_FIRED_LAST_SHOT_1P = "weapon_sheilaturret_lastshot_1p"
const string TURRET_FIRED_LAST_SHOT_3P = "weapon_sheilaturret_lastshot_3p"
const string TURRET_DISMOUNT_1P = "weapon_sheilaturret_dismount_1p"
const string TURRET_SIGHT_FLIP_UP_1P = "weapon_sheilaturret_sightflipup"
const string TURRET_SIGHT_FLIP_DOWN_1P = "weapon_sheilaturret_sightflipdown"

const string TURRET_DRAWFIRST_1P = "weapon_sheilaturret_drawfirst_1p"
const string TURRET_DRAW_1P = "weapon_sheilaturret_draw_1p"

           
const float GLOBAL_TURRET_CHATTER_DEBOUNCE = 7.0
const float SUSTAINED_FIRE_QUIP_CHANCE = 0.15

     
const TURRET_1P_DAMAGE_FX_ATTACH	= "__illumPosition"
const TURRET_DAMAGE_FX_1P			= $"P_ramp_tur_dmg_FP"
const TURRET_LASER_1P				= $"P_wpn_rampart_laser_aim_FP"

struct
{
	int turret1pDamageFxIndex = -1

	#if SERVER
	                                 
	                                  
	                                                      
	#endif

	#if CLIENT
		int laserFXHandle = -1
	#endif

} file

void function MpWeaponMountedTurretWeapon_Init()
{
	RegisterWeaponForUse( MOUNTED_TURRET_WEAPON_NAME )
	RegisterAdditionalMainWeapon( MOUNTED_TURRET_WEAPON_NAME )

	PrecacheParticleSystem( TURRET_LASER_1P )
	PrecacheParticleSystem( $"wpn_muzzleflash_rampart_turret_FP" )
	PrecacheParticleSystem( $"wpn_muzzleflash_rampart_turret" )
	PrecacheParticleSystem( $"wpn_muzzleflash_turret_center_FP" )
	file.turret1pDamageFxIndex = PrecacheParticleSystem( TURRET_DAMAGE_FX_1P )

	RegisterSignal( "DeactivateMountedTurret" )
}

void function OnWeaponActivate_weapon_mounted_turret_weapon( entity weapon )
{
	OnWeaponActivate_weapon_basic_bolt( weapon )
	weapon.SetTargetingLaserEnabled( false )

#if SERVER
	                                      
	                              
	                                    

	                                        
		                                  

	                                                                                                                                                     
	 
		                                            
	 

	                                                  
	                                                                                         
	                                                 
	                                                                            
	                                                                       

	                                                              
#endif          

#if CLIENT
	if( IsValid ( GetCompassRui() ) && IsValid( weapon.GetOwner() ) )
	{
		if( weapon.GetOwner() == GetLocalClientPlayer() )
		{
			RuiSetBool( GetCompassRui(), "showCompassAreaModifier", true )
			RuiTrackFloat( GetCompassRui(), "viewConeMin", weapon.GetOwner(), RUI_TRACK_VIEWCONE_MINYAW )
			RuiTrackFloat( GetCompassRui(), "viewConeMax", weapon.GetOwner(), RUI_TRACK_VIEWCONE_MAXYAW )
		}
	}
#endif
}

void function OnWeaponDeactivate_weapon_mounted_turret_weapon( entity weapon )
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

#if SERVER
	                                    
	                                                 
	                             
	 
		                                                                                           
	 
#endif          

	entity weaponOwner = weapon.GetOwner()

	if ( !IsValid( weaponOwner ) )
		return

	StopSoundOnEntity( weaponOwner, TURRET_DRAWFIRST_1P )
	StopSoundOnEntity( weaponOwner, TURRET_DRAW_1P )

#if SERVER
	                                
	                                   
#endif          

#if CLIENT
	SetTurretVMLaserEnabled( weapon, false )

	if ( weaponOwner == GetLocalViewPlayer() )
	{
		EmitSoundOnEntity( weaponOwner, TURRET_DISMOUNT_1P )
	}

	if ( IsValid( GetCompassRui() ) )
	{
		if ( weaponOwner == GetLocalClientPlayer() )
		{
			RuiSetBool( GetCompassRui(), "showCompassAreaModifier", false )
			RuiSetFloat( GetCompassRui(), "viewConeMin", 0 )
			RuiSetFloat( GetCompassRui(), "viewConeMax", 0 )
		}
	}
#endif          

	weaponOwner.Signal( "DeactivateMountedTurret" )
	weapon.SetTargetingLaserEnabled( false )
}


void function OnWeaponStartZoomIn_weapon_mounted_turret_weapon( entity weapon )
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
				SetTurretVMLaserEnabled( weapon, true )
			}
		}
	#endif


	weapon.SetTargetingLaserEnabled( true )
}

void function OnWeaponStartZoomOut_weapon_mounted_turret_weapon( entity weapon )
{
	weapon.StopWeaponSound( TURRET_BARREL_SPIN_LOOP_1P )
	weapon.StopWeaponSound( TURRET_BARREL_SPIN_LOOP_3P )
	weapon.StopWeaponSound( TURRET_BUTTON_PRESS_SOUND_1P )
	weapon.StopWeaponSound( TURRET_BUTTON_PRESS_SOUND_3P )
	StopSoundOnEntity( weapon, TURRET_WINDUP_1P )
	StopSoundOnEntity( weapon, TURRET_WINDUP_3P )

	entity weaponOwner = weapon.GetWeaponOwner()
	entity turretEnt = weaponOwner.GetTurret()

	if ( !IsValid( weaponOwner ) )
		return

	float zoomFrac = weaponOwner.GetZoomFrac()
	float zoomOutTime = weapon.GetWeaponSettingFloat( eWeaponVar.zoom_time_out )

	if ( IsValid( turretEnt ) )
	{
		#if SERVER
			                                                                                                                   
		#endif
		#if CLIENT
			SetTurretVMLaserEnabled( weapon, false )

			if ( weaponOwner == GetLocalViewPlayer() )
				EmitSoundOnEntityWithSeek( turretEnt, TURRET_WINDDOWN_1P, (1 - zoomFrac) * zoomOutTime )
		#endif
	}

	weapon.SetTargetingLaserEnabled( false )
}

var function OnWeaponPrimaryAttack_weapon_mounted_turret_weapon( entity weapon, WeaponPrimaryAttackParams attackParams )
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
			#endif
		}

		         
		if ( weapon.GetWeaponPrimaryClipCount() == weapon.GetWeaponPrimaryClipCountMax() )
		{
			#if SERVER
				                                                                                    
				                                   
			#elseif CLIENT
				entity turretEnt = GetPlaceableTurretEntForPlayer( weaponOwner )
				if ( IsValid( turretEnt ) )
					MountedTurretPlaceable_SetEligibleForRefund( GetPlaceableTurretEntForPlayer( weaponOwner ), false )
			#endif
		}

		  	                      
		#if SERVER
			                                                   
			                                    
			 
				                                                    
				                              
				 
					                                            
					                             
					 
						                                                      
					 
				 
			 
		#endif

		return OnWeaponPrimaryAttack_weapon_basic_bolt( weapon, attackParams )
	}
	else
	{
		return 0
	}
}

void function OnWeaponReload_weapon_mounted_turret_weapon( entity weapon, int milestoneIndex )
{
	#if SERVER

		                          
		                         
		 
			       
				                                                
				     
			       
				                                                
				     
			       
				                                                
				     
			       
				                                                
				     
			       
				                                                
				     
		 

		              
		                                                                                                                                                        

		                                       
			                                                                                                        
		    
			                                                                                                
	#endif
}

void function OnAnimEvent_weapon_mounted_turret_weapon( entity weapon, string eventName )
{
	switch ( eventName )
	{
		case "rampart_turret_button_press":
			weapon.EmitWeaponSound_1p3p( TURRET_BUTTON_PRESS_SOUND_1P, TURRET_BUTTON_PRESS_SOUND_3P )
			break
		case "rampart_turret_spin_up":
			weapon.EmitWeaponSound_1p3p( TURRET_BARREL_SPIN_LOOP_1P, TURRET_BARREL_SPIN_LOOP_3P )
			break
		default:
			return
	}
}

void function OnWeaponZoomFOVToggle_weapon_mounted_turret_weapon( entity weapon, float targetFOV )
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

#if SERVER
                                                                 
 
	                                       

	                                          
		                                      

	                                                                                                                                                                                                              
	                                           
		                                                            
 

                                                  
 
	                                          
		                                      

	                               
 

                                                                                                 
 
	                                                    
 

                                                                    
 
	                                                     
		      

	                                                     
	                                                                        

 

                                                                  
 
	                         
		            

	                                                      
		            

	                                                                                                                                                        
 
#endif

#if CLIENT
void function OnClientAnimEvent_weapon_mounted_turret_weapon( entity weapon, string eventName )
{
	GlobalClientEventHandler( weapon, eventName )

	OnAnimEvent_weapon_mounted_turret_weapon( weapon, eventName )
	                                                          

	if ( eventName == "muzzle_flash" )
		weapon.PlayWeaponEffect( $"wpn_muzzleflash_turret_center_FP", $"", "muzzle_flash" )
}

void function SetTurretVMLaserEnabled( entity weapon, bool enabled )
{
	if ( !IsValid( weapon ) )
		return

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

entity function GetPlaceableTurretEntForPlayer( entity player )
{
	if ( player.GetParent().GetScriptName() == MOUNTED_TURRET_PLACEABLE_SCRIPT_NAME )
		return player.GetParent()

	return null
}
#endif          
