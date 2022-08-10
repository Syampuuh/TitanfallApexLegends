global function LockOnSniperUlt_Init
global function OnWeaponActivate_ability_lockon_sniper_ult
global function OnWeaponDeactivate_ability_lockon_sniper_ult
global function OnWeaponPrimaryAttack_ability_lockon_sniper_ult
global function OnWeaponAttemptOffhandSwitch_ability_lockon_sniper_ult


#if CLIENT
global function OnClientAnimEvent_ability_lockon_sniper_ult
#endif              


global const float SNIPERULT_CRIPPLED_DURATION = 15
global const string IS_CRIPPLED_NETVAR = "IsCrippled"

    
int SNIPER_ULT_1P_SCREEN_FX_ID
const asset SNIPER_ULT_1P_SCREEN_FX = $"P_adrenaline_screen_CP"


const float SNIPERULT_EMP_FX_DURATION = 15

       

const string SNIPER_ULT_SOUND_PLAYER_LOCKING_ON_START_1P = "weapon_havoc_windup_1p"
const string SNIPER_ULT_SOUND_PLAYER_LOCKING_ON_LOOP_1P = "weapon_havoc_loop_1p"
const string SNIPER_ULT_SOUND_PLAYER_LOCKING_ON_END_1P = "weapon_havoc_winddown_1p"


const float SNIPER_ULT_LOCK_ON_TIME = 2.0
const float SNIPER_ULT_TRACKING_FOV = 2.0
const bool SNIPER_ULT_DEBUG = false


const string SNIPER_ULT_LOCK_TARGET_NETVAR = "sniperUltLockingTarget"

struct LockOnTarget
{
	entity target
	float lockOnTimeElapsed
}


struct
{
	table < entity, LockOnTarget > ownerLockOnTarget

	table < entity, array <entity> > ownerTargetSnipeList
} file

void function LockOnSniperUlt_Init()
{
	         
	RegisterSignal( "SniperUltEndLockOn" )
	RegisterSignal( "SniperUltThreadEnd" )

	RegisterNetworkedVariable( IS_CRIPPLED_NETVAR, SNDC_PLAYER_EXCLUSIVE, SNVT_BOOL )

	RegisterNetworkedVariable( SNIPER_ULT_LOCK_TARGET_NETVAR, SNDC_PLAYER_EXCLUSIVE, SNVT_ENTITY )

#if CLIENT
	RegisterSignal( "SniperUlt_Stop1PFXSignal" )

	                
	                                                                                                         
	                                                                                                         
#endif

	          
	#if CLIENT
		RegisterSignal( "SniperUlt_StopCrippledFXSignal" )

		                
		StatusEffect_RegisterEnabledCallback( eStatusEffect.is_crippled, SniperUlt_Crippled_Start1PFX )
		StatusEffect_RegisterDisabledCallback( eStatusEffect.is_crippled, SniperUlt_Crippled_Stop1PFX )
	#endif


	    
	SNIPER_ULT_1P_SCREEN_FX_ID = PrecacheParticleSystem( SNIPER_ULT_1P_SCREEN_FX )
}

void function OnWeaponActivate_ability_lockon_sniper_ult( entity weapon )
{
	#if CLIENT
	if ( InPrediction() )
	#endif
	{
		weapon.SetForcedADS()
	}

	entity owner = weapon.GetWeaponOwner()
	Assert( owner.IsPlayer() )

	if ( !( owner in file.ownerLockOnTarget) )
	{
		LockOnTarget lockOnTarget
		file.ownerLockOnTarget[owner] <- lockOnTarget
	}

	if ( !( owner in file.ownerTargetSnipeList) )
	{
		array<entity> targets
		file.ownerTargetSnipeList[owner] <- targets
	}

	weapon.SetTargetingLaserEnabled( true )
	thread SniperUlt_ScopeSearchThread( owner, weapon, SNIPER_ULT_TRACKING_FOV, file.ownerTargetSnipeList[owner])
}


void function OnWeaponDeactivate_ability_lockon_sniper_ult( entity weapon )
{
	#if CLIENT
	if ( InPrediction() )
	#endif
	{
		weapon.ClearForcedADS()
	}

	entity owner = weapon.GetWeaponOwner()
	Assert( owner.IsPlayer() )
	owner.Signal( "SniperUltThreadEnd" )
	ScopeTracking_EndThread(owner)
}


var function OnWeaponPrimaryAttack_ability_lockon_sniper_ult( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	if ( weapon.IsWeaponInAds() )
	{
		entity owner = weapon.GetWeaponOwner()
		Assert( owner.IsPlayer() )
		                         
		                     
		if (  owner in file.ownerLockOnTarget && IsValid(file.ownerLockOnTarget[owner].target ) )
		{
			if ( file.ownerLockOnTarget[owner].lockOnTimeElapsed >= SNIPER_ULT_LOCK_ON_TIME )
			{
				int ammoUsed = SniperUlt_FireAtTarget(owner, weapon, file.ownerLockOnTarget[owner].target, attackParams )
				owner.Signal( "SniperUltEndLockOn" )
				return ammoUsed
			}
		}
		else
		{
			entity bestTarget = ScopeTracking_GetBestTarget( owner )
			if ( IsValid(bestTarget) )
			{
				                                                   
				                     
				thread SniperUlt_LockOnTargetThread( owner, bestTarget , weapon)
			}
		}
	}
	return 0
}


bool function OnWeaponAttemptOffhandSwitch_ability_lockon_sniper_ult( entity weapon )
{
	return true
}

#if CLIENT
void function OnClientAnimEvent_ability_lockon_sniper_ult( entity weapon, string name )
{
	GlobalClientEventHandler( weapon, name )

	if ( name == "muzzle_flash" )
	{
		if ( IsOwnerViewPlayerFullyADSed( weapon ) )
			return

		weapon.PlayWeaponEffect( $"wpn_mflash_snp_hmn_smoke_side_FP", $"wpn_mflash_snp_hmn_smoke_side", "muzzle_flash_L" )
		weapon.PlayWeaponEffect( $"wpn_mflash_snp_hmn_smoke_side_FP", $"wpn_mflash_snp_hmn_smoke_side", "muzzle_flash_R" )
	}
}
#endif

void function SniperUlt_ScopeSearchThread( entity owner, entity weapon, float trackingFOV, array <entity> targetExcludeList )
{
	owner.EndSignal( "OnDestroy" )
	owner.EndSignal( "SniperUltThreadEnd" )

	while ( owner.GetZoomFrac() < 1.0 )
	{
		if ( SNIPER_ULT_DEBUG )
		{
			printt( "zoomFrac" + owner.GetZoomFrac() )
		}
		WaitFrame()
	}
	thread ScopeTracking_Thread( owner, weapon , trackingFOV, true, false, file.ownerTargetSnipeList[owner])
}

void function SniperUlt_LockOnTargetThread(  entity owner , entity target , entity weapon )
{
	LockOnTarget lockOnTarget
	lockOnTarget.target = target
	lockOnTarget.lockOnTimeElapsed = 0.0
	file.ownerLockOnTarget[owner] <- lockOnTarget

	owner.EndSignal("OnDestroy")
	owner.EndSignal( "SniperUltEndLockOn" )
	owner.EndSignal( "SniperUltThreadEnd" )
	target.EndSignal("OnDestroy")

	                                         

	int statusEffectHandle
	#if SERVER
		                                                              
		                                                                                                   
		                            
	#endif

	#if CLIENT
		ScopeTracking_StartLock( target, SNIPER_ULT_LOCK_ON_TIME )
	#endif

	OnThreadEnd(
		function() : ( owner , target, weapon, statusEffectHandle)
		{
			                                          
			#if SERVER
			                                                            
			                                               
			#endif
			delete file.ownerLockOnTarget[owner]
			#if CLIENT
			ScopeTracking_StopLock()
			#endif
		}
	)

	#if CLIENT
	wait 0.5
	#endif

	while ( true )
	{
		float lockOnTime = 0.0

		#if SERVER
		                                                                                 
		 
			                                                      

			                                                                                                      
			 
				                           
				                      
				                                                                          
			 
		 
		    
		 
			            
			     
		 
		                         
		   
		  	                                                                         
		  	                                                                                                               
		   
		#endif
		#if CLIENT
		entity lockTarget = owner.GetPlayerNetEnt( SNIPER_ULT_LOCK_TARGET_NETVAR )
		if ( !IsValid(lockTarget) )
		{
			break
		}
		#endif
		wait 0.1
	}
}

int function SniperUlt_FireAtTarget( entity owner, entity weapon, entity target, WeaponPrimaryAttackParams attackParams )
{
	weapon.SetTargetingLaserEnabled( false )
	                                                                                                       

	vector targetShotPosition = target.GetWorldSpaceCenter() + <0,0,10>
	vector toTarget = targetShotPosition - attackParams.pos
	vector attackDirection = Normalize(toTarget)

	float bulletSpeed = weapon.GetWeaponSettingFloat( eWeaponVar.projectile_launch_speed )
	float timeToTarget = toTarget.Length() / bulletSpeed

	#if SERVER
	                        
	                                               

	            
	                          
	                                         
	        

	                                                                         
	                                                                
	                                                        


	                       
	 
		                                                               
		                                                                                                            

		                                                                
		                                                                                                                           
	 

	                                                                                

	            
	                                                                      
	                                                                                                            
	                                                                                                                                                                                                             
	                                                                                              
	                                                                                                

	                                                                                                           
	                                                                                                             
	#endif

	ScopeTracking_EndThread(owner)

	PlayerUsedOffhand( owner, weapon, true)
	int ammoReq = weapon.GetAmmoPerShot()
	return ammoReq
}

#if SERVER
                                                                                 
 
	                                                                 
	                                                        
		      

	                        
	 
		                                                    
			      
		                                    
		                                                                                                                                    
		                                                                                                                                             

		                                                                                            

		                                                                       

		                                                     

		                       
		                                                            
		                                     


		                                                                     
		                                                                 


		                                                                                   

		                                                                                     
		                                                                                                 
		                                                                                              

		                                                                                                      

		                           
		  	                                        
	 
 

                                                                                                             
 
	                               

	                                                   
	                                                 
	                                                           

	                                                                                          
	            
		                                           
		 
			                        
			 
				                                               
				                        
				 
					                            
					                                        
					                                                
				 
				                                                    
				                                
			 
		 
	 

	             
 
#endif


#if CLIENT
void function SniperUlt_Victim_Start1PFX( entity ent, int statusEffect, bool actuallyChanged )
{
	if ( !actuallyChanged && GetLocalViewPlayer() == GetLocalClientPlayer() )
		return

	if ( ent != GetLocalViewPlayer() )
		return

	entity viewPlayer = GetLocalViewPlayer()

	int fxHandle
	fxHandle = StartParticleEffectOnEntityWithPos( viewPlayer, SNIPER_ULT_1P_SCREEN_FX_ID, FX_PATTACH_ABSORIGIN_FOLLOW, ATTACHMENTID_INVALID, viewPlayer.EyePosition(), <0, 0, 0> )
	EffectSetIsWithCockpit( fxHandle, true )

	EffectSetControlPointVector( fxHandle, 1, <1,999,0> )

	EmitSoundOnEntity( viewPlayer, "diag_mp_wraith_voices_sniper_1p" )

	EmitSoundOnEntity( viewPlayer, SNIPER_ULT_SOUND_PLAYER_LOCKING_ON_START_1P )

	thread SniperUlt_Victim_1PFXThread( viewPlayer, fxHandle )
}

void function  SniperUlt_Victim_1PFXThread( entity player, int fxHandle )
{
	player.EndSignal( "SniperUlt_Stop1PFXSignal" )
	player.EndSignal( "OnDeath" )

	OnThreadEnd(
		function() : ( fxHandle, player )
		{
			if ( !EffectDoesExist( fxHandle ) )
				return

			EffectStop( fxHandle, false, true )

			if ( IsValid( player ) )
			{
				StopSoundOnEntity( player, SNIPER_ULT_SOUND_PLAYER_LOCKING_ON_START_1P )
			}
		}
	)

	if ( IsValid( player ) )
	{
		EmitSoundOnEntity( player, SNIPER_ULT_SOUND_PLAYER_LOCKING_ON_START_1P )
	}

	while ( EffectDoesExist( fxHandle ) )
	{
		WaitFrame()
	}
}

void function SniperUlt_Victim_Stop1PFX( entity ent, int statusEffect, bool actuallyChanged )
{
	if ( !actuallyChanged && GetLocalViewPlayer() == GetLocalClientPlayer() )
		return

	if ( ent != GetLocalViewPlayer() )
		return

	entity viewPlayer = GetLocalViewPlayer()

	EmitSoundOnEntity( viewPlayer, SNIPER_ULT_SOUND_PLAYER_LOCKING_ON_END_1P )

	ent.Signal( "SniperUlt_Stop1PFXSignal" )
}


void function SniperUlt_AddThreatIndicator( entity shooter )
{
	entity player = GetLocalViewPlayer()
	ShowGrenadeArrow( player, shooter, 10000000, 0.0 )
}

#endif         

          
#if CLIENT
void function SniperUlt_Crippled_Start1PFX( entity ent, int statusEffect, bool actuallyChanged )
{
	if ( !actuallyChanged && GetLocalViewPlayer() == GetLocalClientPlayer() )
		return

	if ( ent != GetLocalViewPlayer() )
		return

	entity viewPlayer = GetLocalViewPlayer()

	int fxHandle
	                                                                                                                                                               
	                                          
	  
	                                                       
	  
	                                                                    
	  
	                                                                              

	thread SniperUlt_Crippled_1PFXThread( viewPlayer, fxHandle )
}

void function  SniperUlt_Crippled_1PFXThread( entity player, int fxHandle )
{
	player.EndSignal( "SniperUlt_StopCrippledFXSignal" )
	player.EndSignal( "OnDeath" )

	                                                               
	                                            
	                                                                        
	                                                                 
	                                              


	var rui = CreateFullscreenRui( $"ui/health_use_progress.rpak" )
	RuiSetBool( rui, "isVisible", true )
	RuiSetImage( rui, "icon", $"rui/hud/gametype_icons/survival/dna_station" )
	RuiSetGameTime( rui, "startTime", Time() )
	RuiSetGameTime( rui, "endTime", Time() + SNIPERULT_CRIPPLED_DURATION )
	RuiSetString( rui, "hintKeyboardMouse", "#HAWK_SURVIVAL_CRIPPLED" )
	RuiSetString( rui, "hintController", "#HAWK_SURVIVAL_CRIPPLED" )

	OnThreadEnd(
		function() : ( fxHandle, player, rui )
		{
			RuiDestroy( rui )

			if ( !EffectDoesExist( fxHandle ) )
				return

			EffectStop( fxHandle, false, true )
		}
	)

	while ( true )                                
	{
		WaitFrame()
	}
}

void function SniperUlt_Crippled_Stop1PFX( entity ent, int statusEffect, bool actuallyChanged )
{
	if ( !actuallyChanged && GetLocalViewPlayer() == GetLocalClientPlayer() )
		return

	if ( ent != GetLocalViewPlayer() )
		return

	entity viewPlayer = GetLocalViewPlayer()

	                                                                            

	ent.Signal( "SniperUlt_StopCrippledFXSignal" )
}

#endif         
              