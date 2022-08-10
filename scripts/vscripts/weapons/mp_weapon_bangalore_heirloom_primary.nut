global function MpWeaponBangaloreHeirloomPrimary_Init

global function OnWeaponActivate_weapon_bangalore_heirloom_primary
global function OnWeaponDeactivate_weapon_bangalore_heirloom_primary


const asset GHURKA_AMB_FP = $"P_ghurka_amb_plasma_FP"
const asset GHURKA_AMB_3P = $"P_ghurka_amb_plasma_3P"
const asset GHURKA_AMB_PLASMA_FP = $"P_ghurka_plasma_mdl"
const asset GHURKA_AMB_PLASMA_3P = $"P_ghurka_plasma_mdl_3P"


void function MpWeaponBangaloreHeirloomPrimary_Init()
{

	PrecacheParticleSystem( GHURKA_AMB_FP )
	PrecacheParticleSystem( GHURKA_AMB_3P )
	PrecacheParticleSystem( GHURKA_AMB_PLASMA_FP )
	PrecacheParticleSystem( GHURKA_AMB_PLASMA_3P )

}

void function OnWeaponActivate_weapon_bangalore_heirloom_primary( entity weapon )
{
	weapon.PlayWeaponEffect( GHURKA_AMB_FP, GHURKA_AMB_3P, "blade_front", true )
	weapon.PlayWeaponEffect( GHURKA_AMB_PLASMA_FP, GHURKA_AMB_PLASMA_3P, "fx_main", true )
}

void function OnWeaponDeactivate_weapon_bangalore_heirloom_primary( entity weapon )
{
	weapon.StopWeaponEffect( GHURKA_AMB_FP, GHURKA_AMB_3P )
	weapon.StopWeaponEffect( GHURKA_AMB_PLASMA_FP, GHURKA_AMB_PLASMA_3P )
}
