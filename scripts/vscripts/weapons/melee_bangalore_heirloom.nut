global function MeleeBangaloreHeirloom_Init

global function OnWeaponActivate_melee_bangalore_heirloom
global function OnWeaponDeactivate_melee_bangalore_heirloom

const GHURKA_FX_ATTACK_SWIPE_FP = $"P_wpn_ghurka_swipe_FP"
const GHURKA_FX_ATTACK_SWIPE_3P = $"P_wpn_ghurka_swipe_3P"

void function MeleeBangaloreHeirloom_Init()
{
	PrecacheParticleSystem( GHURKA_FX_ATTACK_SWIPE_FP )
	PrecacheParticleSystem( GHURKA_FX_ATTACK_SWIPE_3P )
}


void function OnWeaponActivate_melee_bangalore_heirloom( entity weapon )
{
	weapon.PlayWeaponEffect( GHURKA_FX_ATTACK_SWIPE_FP, GHURKA_FX_ATTACK_SWIPE_3P, "blade_front" )
}

void function OnWeaponDeactivate_melee_bangalore_heirloom( entity weapon )
{
	weapon.StopWeaponEffect( GHURKA_FX_ATTACK_SWIPE_FP, GHURKA_FX_ATTACK_SWIPE_3P )
}
