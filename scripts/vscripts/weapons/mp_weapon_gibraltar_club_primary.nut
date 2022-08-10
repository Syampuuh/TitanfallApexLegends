global function MpWeaponGibraltarClubPrimary_Init

global function OnWeaponActivate_weapon_gibraltar_club_primary
global function OnWeaponDeactivate_weapon_gibraltar_club_primary

const asset CLUB_FX_FIRE_FP = $"P_club_glow_mdl"
const asset CLUB_FX_FIRE_3P = $"P_club_glow_mdl_3P"
const asset CLUB_FX_LAVA_A_FP = $"P_club_amb_lava_gapA"
const asset CLUB_FX_LAVA_B_FP = $"P_club_amb_lava_gapB"
const asset CLUB_FX_LAVA_3P = $"P_club_amb_lava_gapA_3P"

void function MpWeaponGibraltarClubPrimary_Init()
{
	PrecacheParticleSystem( CLUB_FX_FIRE_FP )
	PrecacheParticleSystem( CLUB_FX_FIRE_3P )
	PrecacheParticleSystem( CLUB_FX_LAVA_A_FP )
	PrecacheParticleSystem( CLUB_FX_LAVA_B_FP )
	PrecacheParticleSystem( CLUB_FX_LAVA_3P )
}

void function OnWeaponActivate_weapon_gibraltar_club_primary( entity weapon )
{
	weapon.PlayWeaponEffect( CLUB_FX_FIRE_FP, CLUB_FX_FIRE_3P, "fx_base", true )
	weapon.PlayWeaponEffect( CLUB_FX_LAVA_A_FP, CLUB_FX_LAVA_3P, "fx_gapA", true )
	weapon.PlayWeaponEffect( CLUB_FX_LAVA_B_FP, CLUB_FX_LAVA_3P, "fx_gapB", true )
}

void function OnWeaponDeactivate_weapon_gibraltar_club_primary( entity weapon )
{
	weapon.StopWeaponEffect( CLUB_FX_FIRE_FP, CLUB_FX_FIRE_3P )
	weapon.StopWeaponEffect( CLUB_FX_LAVA_A_FP, CLUB_FX_LAVA_3P )
	weapon.StopWeaponEffect( CLUB_FX_LAVA_B_FP, CLUB_FX_LAVA_3P )
}