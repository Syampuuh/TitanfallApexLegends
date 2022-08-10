global function MpWeaponRevenantScythePrimary_Init

global function OnWeaponActivate_weapon_revenant_scythe_primary
global function OnWeaponDeactivate_weapon_revenant_scythe_primary

const asset SCY_FX_BLADE_PC = $"P_scy_blade_pc1"
const asset SCY_FX_BLADE_PC_2 = $"P_scy_blade_pc2"
const asset SCY_FX_BLADE_PC_3 = $"P_scy_blade_pc3"
const asset SCY_FX_BASE = $"P_scy_blade_base"

const asset SCY_FX_BLADE_PC_3P = $"P_scy_blade_pc1_3P"
const asset SCY_FX_BLADE_PC_2_3P = $"P_scy_blade_pc2_3P"
const asset SCY_FX_BASE_3P = $"P_scy_blade_base_3P"

void function MpWeaponRevenantScythePrimary_Init()
{
	PrecacheParticleSystem( SCY_FX_BLADE_PC )
	PrecacheParticleSystem( SCY_FX_BLADE_PC_2 )
	PrecacheParticleSystem( SCY_FX_BLADE_PC_3 )
	PrecacheParticleSystem( SCY_FX_BASE )

	PrecacheParticleSystem( SCY_FX_BLADE_PC_3P )
	PrecacheParticleSystem( SCY_FX_BLADE_PC_2_3P )
	PrecacheParticleSystem( SCY_FX_BASE_3P )
}


void function OnWeaponActivate_weapon_revenant_scythe_primary( entity weapon )
{
	weapon.PlayWeaponEffect( SCY_FX_BLADE_PC_3, SCY_FX_BLADE_PC_2_3P, "blade_piece_fx_01", true )
	weapon.PlayWeaponEffect( SCY_FX_BLADE_PC, SCY_FX_BLADE_PC_3P, "blade_piece_fx_02", true )
	weapon.PlayWeaponEffect( SCY_FX_BLADE_PC_2, SCY_FX_BLADE_PC_2_3P, "blade_piece_fx_03", true )
	weapon.PlayWeaponEffect( SCY_FX_BLADE_PC, SCY_FX_BLADE_PC_3P, "blade_piece_fx_04", true )
	weapon.PlayWeaponEffect( SCY_FX_BLADE_PC_3, SCY_FX_BLADE_PC_2_3P, "blade_piece_fx_05", true )
	weapon.PlayWeaponEffect( SCY_FX_BLADE_PC, SCY_FX_BLADE_PC_3P, "blade_piece_fx_06", true )
	weapon.PlayWeaponEffect( SCY_FX_BLADE_PC_2, SCY_FX_BLADE_PC_2_3P, "blade_piece_fx_07", true )
	weapon.PlayWeaponEffect( SCY_FX_BLADE_PC, SCY_FX_BLADE_PC_3P, "blade_piece_fx_08", true )
	weapon.PlayWeaponEffect( SCY_FX_BASE, SCY_FX_BASE_3P, "blade_base_fx", true )
}

void function OnWeaponDeactivate_weapon_revenant_scythe_primary( entity weapon )
{
	weapon.StopWeaponEffect( SCY_FX_BLADE_PC, SCY_FX_BLADE_PC_3P )
	weapon.StopWeaponEffect( SCY_FX_BLADE_PC_2, SCY_FX_BLADE_PC_2_3P )
	weapon.StopWeaponEffect( SCY_FX_BLADE_PC_3, SCY_FX_BLADE_PC_2_3P )
	weapon.StopWeaponEffect( SCY_FX_BASE, SCY_FX_BASE_3P )
}