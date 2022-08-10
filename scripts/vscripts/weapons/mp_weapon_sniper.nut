
global function MpWeaponSniper_Init

global const string KRABER_WEAPON_NAME = "mp_weapon_sniper"

#if SERVER
                                                
#endif         

#if CLIENT
global function OnClientAnimEvent_weapon_sniper
#endif              

void function MpWeaponSniper_Init()
{
	SniperPrecache()
}

void function SniperPrecache()
{
	PrecacheParticleSystem( $"wpn_mflash_snp_hmn_smoke_side_FP" )
	PrecacheParticleSystem( $"wpn_mflash_snp_hmn_smoke_side" )
}

bool function MpWeaponSniper_IsValidModCommand( entity player, entity weapon, string mod, bool isAdd )
{
	if ( DoesModExist( weapon, "optic_toggle" ) )
	{
		string opticToggleMod = expect string( weapon.GetWeaponInfoFileKeyField( "script_optic_toggle_name" ) )
		if ( mod == opticToggleMod )
			return true
	}

	return false
}

#if CLIENT
void function OnClientAnimEvent_weapon_sniper( entity weapon, string name )
{
	GlobalClientEventHandler( weapon, name )

	if ( name == "muzzle_flash" )
	{
		if ( IsOwnerViewPlayerFullyADSed( weapon ) )
			return

		weapon.PlayWeaponEffect( $"wpn_mflash_snp_hmn_smoke_side_FP", $"wpn_mflash_snp_hmn_smoke_side", "muzzle_flash_L" )
		weapon.PlayWeaponEffect( $"wpn_mflash_snp_hmn_smoke_side_FP", $"wpn_mflash_snp_hmn_smoke_side", "muzzle_flash_R" )
	}
}
#endif
