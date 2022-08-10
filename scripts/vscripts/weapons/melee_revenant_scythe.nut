global function MeleeRevenantScythe_Init

global function OnWeaponActivate_melee_revenant_scythe
global function OnWeaponDeactivate_melee_revenant_scythe

const REV_SCY_FX_ATTACK_SWIPE_FP = $"P_scy_blade_swipe_FP"
const REV_SCY_FX_ATTACK_SWIPE_3P = $"P_scy_blade_swipe_3P"

void function MeleeRevenantScythe_Init()
{
	PrecacheParticleSystem( REV_SCY_FX_ATTACK_SWIPE_FP )
	PrecacheParticleSystem( REV_SCY_FX_ATTACK_SWIPE_3P )
}

                                                                              
                                                          
void function OnWeaponActivate_melee_revenant_scythe( entity weapon )
{
	weapon.PlayWeaponEffect( REV_SCY_FX_ATTACK_SWIPE_FP, REV_SCY_FX_ATTACK_SWIPE_3P, "blade_base_fx" )
}

void function OnWeaponDeactivate_melee_revenant_scythe( entity weapon )
{
	weapon.StopWeaponEffect( REV_SCY_FX_ATTACK_SWIPE_FP, REV_SCY_FX_ATTACK_SWIPE_3P )
}