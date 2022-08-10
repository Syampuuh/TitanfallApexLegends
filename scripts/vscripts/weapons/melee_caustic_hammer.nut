global function MeleeCausticHammer_Init

global function OnWeaponActivate_melee_caustic_hammer
global function OnWeaponDeactivate_melee_caustic_hammer

const HAMMER_FX_ATTACK_SWIPE_FP = $"P_wpn_cHammer_swipe_FP"
const HAMMER_FX_ATTACK_SWIPE_3P = $"P_wpn_cHammer_swipe_3P"

void function MeleeCausticHammer_Init()
{
	PrecacheParticleSystem( HAMMER_FX_ATTACK_SWIPE_FP )
	PrecacheParticleSystem( HAMMER_FX_ATTACK_SWIPE_3P )
}

                                                                              
                                                          
void function OnWeaponActivate_melee_caustic_hammer( entity weapon )
{
	                                            
	weapon.PlayWeaponEffect( HAMMER_FX_ATTACK_SWIPE_FP, HAMMER_FX_ATTACK_SWIPE_3P, "FX_GASMASK_C" )
}

void function OnWeaponDeactivate_melee_caustic_hammer( entity weapon )
{
	                                              
	weapon.StopWeaponEffect( HAMMER_FX_ATTACK_SWIPE_FP, HAMMER_FX_ATTACK_SWIPE_3P )

}
