global function MpWeaponCausticHammerPrimary_Init

global function OnWeaponActivate_weapon_caustic_hammer_primary
global function OnWeaponDeactivate_weapon_caustic_hammer_primary
global function OnWeaponAttack_melee_caustic_hammer_primary

const asset HAMMER_FX_GLOW_FP = $"P_wpn_cHammer_gas_FP"
const asset HAMMER_FX_GLOW_3P = $"P_wpn_cHammer_gas_3P"
const asset HAMMER_FX_EYE_FP = $"P_wpn_cHammer_eye_pulse_FP"
const asset HAMMER_FX_EYE_3P = $""



void function MpWeaponCausticHammerPrimary_Init()
{
	PrecacheParticleSystem( HAMMER_FX_GLOW_FP )
	PrecacheParticleSystem( HAMMER_FX_GLOW_3P )
	PrecacheParticleSystem( HAMMER_FX_EYE_FP )
}

void function OnWeaponActivate_weapon_caustic_hammer_primary( entity weapon )
{
	                                                        
	weapon.PlayWeaponEffect( HAMMER_FX_GLOW_FP, HAMMER_FX_GLOW_3P, "FX_GASMASK_L", true )
	weapon.PlayWeaponEffect( HAMMER_FX_GLOW_FP, HAMMER_FX_GLOW_3P, "FX_GASMASK_R", true )
	weapon.PlayWeaponEffect( HAMMER_FX_EYE_FP, HAMMER_FX_EYE_3P, "FX_EYE_L", true )
	weapon.PlayWeaponEffect( HAMMER_FX_EYE_FP, HAMMER_FX_EYE_3P, "FX_EYE_R", true )
}

void function OnWeaponDeactivate_weapon_caustic_hammer_primary( entity weapon )
{
	                                                          
	weapon.StopWeaponEffect( HAMMER_FX_GLOW_FP, HAMMER_FX_GLOW_3P )
	weapon.StopWeaponEffect( HAMMER_FX_EYE_FP, HAMMER_FX_EYE_3P )
}

void function OnWeaponAttack_melee_caustic_hammer_primary( entity weapon )
{
	                                         
	weapon.StopWeaponEffect( HAMMER_FX_GLOW_FP, HAMMER_FX_GLOW_3P )
}

