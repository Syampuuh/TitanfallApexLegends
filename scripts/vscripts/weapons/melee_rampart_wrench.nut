global function MeleeRampartWrench_Init

global function OnWeaponActivate_melee_rampart_wrench
global function OnWeaponDeactivate_melee_rampart_wrench

const WRENCH_FX_ATTACK_SWIPE_FP = $"P_wrench_swipe_FP"
const WRENCH_FX_ATTACK_SWIPE_3P = $"P_wrench_swipe_3P"
const WRENCH_FX_ATTACK_DLIGHT_FP = $"wrench_dlight"
const WRENCH_FX_ATTACK_DLIGHT_3P = $"wrench_dlight"
const WRENCH_FX_ATTACK_TASER_FP = $"P_wrench_electric_beam"
const WRENCH_FX_ATTACK_TASER_3P = $"P_wrench_electric_beam_3P"
const WRENCH_FX_MDL_FP = $"P_wrench_mdl_energy"
const WRENCH_FX_MDL_3P = $"P_wrench_mdl_energy_3P"

void function MeleeRampartWrench_Init()
{
	PrecacheParticleSystem( WRENCH_FX_ATTACK_SWIPE_FP )
	PrecacheParticleSystem( WRENCH_FX_ATTACK_SWIPE_3P )
	PrecacheParticleSystem( WRENCH_FX_ATTACK_DLIGHT_FP )
	PrecacheParticleSystem( WRENCH_FX_ATTACK_DLIGHT_3P )
	PrecacheParticleSystem( WRENCH_FX_ATTACK_TASER_FP )
	PrecacheParticleSystem( WRENCH_FX_ATTACK_TASER_3P )
	PrecacheParticleSystem( WRENCH_FX_MDL_FP )
	PrecacheParticleSystem( WRENCH_FX_MDL_3P )
}

                                                                              
                                                          
void function OnWeaponActivate_melee_rampart_wrench( entity weapon )
{
	                                            
	weapon.PlayWeaponEffect( WRENCH_FX_ATTACK_SWIPE_FP, WRENCH_FX_ATTACK_SWIPE_3P, "energy_arc_bottom", true )
	weapon.PlayWeaponEffect( WRENCH_FX_ATTACK_TASER_FP, WRENCH_FX_ATTACK_TASER_3P, "energy_arc_bottom", true )
	weapon.PlayWeaponEffect( WRENCH_FX_ATTACK_DLIGHT_FP, WRENCH_FX_ATTACK_DLIGHT_3P, "energy_arc_bottom", true )
	weapon.PlayWeaponEffect( WRENCH_FX_MDL_FP, WRENCH_FX_MDL_3P, "BASE", true )
}

void function OnWeaponDeactivate_melee_rampart_wrench( entity weapon )
{
	                                              
	weapon.StopWeaponEffect( WRENCH_FX_ATTACK_SWIPE_FP, WRENCH_FX_ATTACK_SWIPE_3P )
	weapon.StopWeaponEffect( WRENCH_FX_ATTACK_TASER_FP, WRENCH_FX_ATTACK_TASER_3P )
	weapon.StopWeaponEffect( WRENCH_FX_ATTACK_DLIGHT_FP, WRENCH_FX_ATTACK_DLIGHT_3P )
	weapon.StopWeaponEffect( WRENCH_FX_MDL_FP, WRENCH_FX_MDL_3P )

}