global function MeleeCryptoHeirloom_Init

global function OnWeaponActivate_melee_crypto_heirloom
global function OnWeaponDeactivate_melee_crypto_heirloom

const CRYPTO_FX_ATTACK_SWIPE_TOP_FP = $"P_crypto_sword_swipe_top"
const CRYPTO_FX_ATTACK_SWIPE_TOP_3P = $"P_crypto_sword_swipe_top_3P"                           
const CRYPTO_FX_ATTACK_SWIPE_FP = $"P_crypto_sword_swipe"
const CRYPTO_FX_ATTACK_SWIPE_3P = $"P_crypto_sword_swipe_3P"                                                        

#if SERVER
                                                  
                                                  
#endif              

#if CLIENT
global function OnClientAnimEvent_CryptoMelee
#endif              

void function MeleeCryptoHeirloom_Init()
{
	PrecacheParticleSystem( CRYPTO_FX_ATTACK_SWIPE_FP )
	PrecacheParticleSystem( CRYPTO_FX_ATTACK_SWIPE_3P )
	PrecacheParticleSystem( CRYPTO_FX_ATTACK_SWIPE_TOP_FP )
	PrecacheParticleSystem( CRYPTO_FX_ATTACK_SWIPE_TOP_3P )
}

void function OnWeaponActivate_melee_crypto_heirloom( entity weapon )
{
	                                                                                                 
    weapon.PlayWeaponEffect( CRYPTO_FX_ATTACK_SWIPE_FP, CRYPTO_FX_ATTACK_SWIPE_TOP_3P, "Fx_def_blade_01" )
	weapon.PlayWeaponEffect( CRYPTO_FX_ATTACK_SWIPE_FP, CRYPTO_FX_ATTACK_SWIPE_TOP_3P, "Fx_def_blade_03" )
	weapon.PlayWeaponEffect( CRYPTO_FX_ATTACK_SWIPE_FP, CRYPTO_FX_ATTACK_SWIPE_TOP_3P, "Fx_def_blade_05" )
	weapon.PlayWeaponEffect( CRYPTO_FX_ATTACK_SWIPE_FP, CRYPTO_FX_ATTACK_SWIPE_TOP_3P, "Fx_def_blade_07" )
	float tmp = 1.00
}

void function OnWeaponDeactivate_melee_crypto_heirloom( entity weapon )
{
	weapon.StopWeaponEffect( CRYPTO_FX_ATTACK_SWIPE_FP, CRYPTO_FX_ATTACK_SWIPE_3P )
	weapon.StopWeaponEffect( CRYPTO_FX_ATTACK_SWIPE_TOP_FP, CRYPTO_FX_ATTACK_SWIPE_TOP_3P )
	float tmp = 1.00
}

#if SERVER
                                                                 
 
	                                          
 

                                                                 
 
	                                         
 
#endif              

#if CLIENT
void function OnClientAnimEvent_CryptoMelee( entity weapon, string name )
{
	if ( !IsValid( weapon ) )
		return
	
	if ( !InPrediction() )
		return
	
	if ( name == "crypto_melee_sword" )
		UpdateSwordDrone_Internal( weapon, false )
	else if ( name == "crypto_melee_drone" )
		UpdateSwordDrone_Internal( weapon, true )
}
#endif              

void function UpdateSwordDrone_Internal( entity weapon, bool usingDrone )
{
	if ( usingDrone )
	{
		if ( weapon.HasMod( "proto_door_kick_impact_table" ) )
			weapon.RemoveMod( "proto_door_kick_impact_table" )
			
		weapon.AddMod( "melee_crypto_drone" )
	}
	else
	{
		if ( weapon.HasMod( "melee_crypto_drone" ) )
			weapon.RemoveMod( "melee_crypto_drone" )
		
		if ( weapon.HasMod( "proto_door_kick" ) && !weapon.HasMod( "proto_door_kick_impact_table" ) )
			weapon.AddMod( "proto_door_kick_impact_table" )
	}
}