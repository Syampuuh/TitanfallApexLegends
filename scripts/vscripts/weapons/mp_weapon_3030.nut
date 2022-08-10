global function MpWeapon3030_Init

global function OnWeaponActivate_weapon_3030
global function OnWeaponDeactivate_weapon_3030
global function OnWeaponChargeLevelIncreased_weapon_3030
global function OnWeaponChargeEnd_weapon_3030
global function OnWeaponPrimaryAttack_weapon_3030
#if CLIENT
global function OnClientAnimEvent_weapon_3030
#endif

const string ADS_MOD = "in_ads"
const string ADS_THINK_THREAD_ABORT_SIGNAL = "ads_think_abort"
const float ADS_MOD_ZOOM_FRAC_REQUIRED = 0.5

const string HAMMER_THREAD_ABORT_SIGNAL = "hammer_thread_abort"
const string HAMMER_OPEN_CL_ANIM_EVENT = "weapon_3030_open_hammer"
const float HAMMER_CLOSE_LERP_TIME = 0.0
const float HAMMER_OPEN_LERP_TIME = 0.0


struct
{
	EnergyChargeWeaponData chargeWeaponData
} file

void function MpWeapon3030_Init()
{
	RegisterSignal( ADS_THINK_THREAD_ABORT_SIGNAL )
	RegisterSignal( HAMMER_THREAD_ABORT_SIGNAL )
}

void function OnWeaponActivate_weapon_3030( entity weapon )
{
	#if SERVER
		                                       
		                         
			      

		                                       
	#endif
	#if CLIENT
		if ( InPrediction() )
		{
			if ( weapon.GetWeaponPrimaryClipCount() == 0 )
			{
				thread CloseHammerThread( weapon, true )
			}
			else
			{
				thread OpenHammerThread( weapon, true )
			}
		}
	#endif

	thread ShatterRounds_UpdateShatterRoundsThink( weapon )
	#if SERVER
	                                               
		                                                
	    
		                                              
	#endif
}

void function OnWeaponDeactivate_weapon_3030( entity weapon )
{
	#if SERVER
		                                              
		                           
	#endif
	#if CLIENT
		if ( InPrediction() )
		{
			weapon.Signal( HAMMER_THREAD_ABORT_SIGNAL )
		}
		weapon.Signal( SHATTER_ROUNDS_THINK_END_SIGNAL )

		#if SERVER
		                                                             
		#endif
	#endif
}

#if SERVER
                                                            
 
	                   
	                             
	                               
	                                                 

	            
		                               
		 
			                        
				                           
		 
	 

	              
	 
		                                               
			      

		                                                                                   
		 
			                                
				                        
		 
		                                    
		 
			                           
		 

		                                                   
		                                                

		           
	 
 

#endif         

#if CLIENT
void function OnClientAnimEvent_weapon_3030( entity weapon, string name )
{
	GlobalClientEventHandler( weapon, name )

	if ( name == HAMMER_OPEN_CL_ANIM_EVENT )
	{
		thread OpenHammerThread( weapon, false )
	}
}

void function CloseHammerThread( entity weapon, bool skipLerp )
{
	weapon.Signal( HAMMER_THREAD_ABORT_SIGNAL )

	entity player = weapon.GetWeaponOwner()
	if ( !IsValid( player ) )
		return

	player.EndSignal( "OnDeath" )
	weapon.EndSignal( "OnDestroy" )
	weapon.EndSignal( HAMMER_THREAD_ABORT_SIGNAL )

	float startTime = Time()
	float endTime   = startTime + HAMMER_CLOSE_LERP_TIME

	while( true )
	{
		float poseParam = GraphCapped( Time(), startTime, endTime, 0.0, 1.0 )
		poseParam = (skipLerp) ? 1.0 : poseParam
		weapon.SetScriptPoseParam0( poseParam )
		WaitFrame()
	}
}

void function OpenHammerThread( entity weapon, bool skipLerp )
{
	weapon.Signal( HAMMER_THREAD_ABORT_SIGNAL )

	entity player = weapon.GetWeaponOwner()
	if ( !IsValid( player ) )
		return

	player.EndSignal( "OnDeath" )
	weapon.EndSignal( "OnDestroy" )
	weapon.EndSignal( HAMMER_THREAD_ABORT_SIGNAL )

	float startTime = Time()
	float endTime   = startTime + HAMMER_OPEN_LERP_TIME

	while( true )
	{
		float poseParam = GraphCapped( Time(), startTime, endTime, 1.0, 0.0 )
		poseParam = (skipLerp) ? 0.0 : poseParam
		weapon.SetScriptPoseParam0( poseParam )
		WaitFrame()
	}
}
#endif
bool function OnWeaponChargeLevelIncreased_weapon_3030( entity weapon )
{
	return EnergyChargeWeapon_OnWeaponChargeLevelIncreased( weapon, file.chargeWeaponData )
}

void function OnWeaponChargeEnd_weapon_3030( entity weapon )
{
	EnergyChargeWeapon_OnWeaponChargeEnd( weapon, file.chargeWeaponData )
}

var function OnWeaponPrimaryAttack_weapon_3030( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	bool ignoreSpread = weapon.HasMod( SHATTER_ROUNDS_HIPFIRE_MOD )
	weapon.FireWeapon_Default( attackParams.pos, attackParams.dir, 1.0, 1.0, ignoreSpread )
	#if CLIENT
		if ( InPrediction() )
		{
			thread CloseHammerThread( weapon, false )
		}
	#endif
	return weapon.GetWeaponSettingInt( eWeaponVar.ammo_per_shot )
}

