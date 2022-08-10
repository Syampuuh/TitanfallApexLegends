global function MpWeaponDefender_Init
global function OnWeaponActivate_weapon_defender
global function OnWeaponSustainedDischargeBegin_Defender
global function OnWeaponReload_weapon_defender


const asset DEFENDER_FX_RELOAD_1P = $"P_wpn_defender_reload_FP"
const asset DEFENDER_FX_RELOAD_3P = $"P_wpn_defender_reload"

               
const asset DEFENDER_FX_OW = $"P_wpn_defender_beam_ow"
const asset DEFENDER_FX_CHRG_OW = $"P_wpn_defender_charge_ow"
const asset DEFENDER_FX_ARC_OW = $"P_wpn_defender_charge_arc_ow"
const asset DEFENDER_FX_BEAM_OW = $"P_wpn_defender_beam_ow_loop"



void function MpWeaponDefender_Init()
{
	PrecacheParticleSystem( DEFENDER_FX_RELOAD_1P )
	PrecacheParticleSystem( DEFENDER_FX_RELOAD_3P )

	               
	PrecacheParticleSystem( DEFENDER_FX_OW )
	PrecacheParticleSystem( DEFENDER_FX_CHRG_OW )
	PrecacheParticleSystem( DEFENDER_FX_ARC_OW )
	PrecacheParticleSystem( DEFENDER_FX_BEAM_OW )
}

void function OnWeaponActivate_weapon_defender( entity weapon )
{
	#if CLIENT
		                                                                 
		weapon.w.useRapidHitbeep = true
	#endif         
}

int function OnWeaponSustainedDischargeBegin_Defender( entity weapon )
{
	if ( !IsValid( weapon ) )
		return 3
	return weapon.GetWeaponSettingInt( eWeaponVar.ammo_per_shot )
}

void function OnWeaponReload_weapon_defender( entity weapon, int milestoneIndex )
{
	weapon.PlayWeaponEffect( DEFENDER_FX_RELOAD_1P, DEFENDER_FX_RELOAD_3P, "shell" )
	weapon.PlayWeaponEffect( DEFENDER_FX_RELOAD_1P, DEFENDER_FX_RELOAD_3P, "shell2" )
}
