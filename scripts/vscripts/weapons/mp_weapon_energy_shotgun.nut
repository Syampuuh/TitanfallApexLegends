global function MpWeaponEnergyShotgun_Init
global function OnWeaponPrimaryAttack_weapon_energy_shotgun
global function OnWeaponChargeLevelIncreased_weapon_energy_shotgun
global function OnWeaponChargeEnd_weapon_energy_shotgun

#if(false)

#endif

//
//
array<vector> BLAST_PATTERN_ENERGY_SHOTGUN = [
	//
	//
	< 0.0, 0.0, 	0 >, //
	< 0.0, 13.75, 	0 >, //
	< -9.4, 5.4, 	0 >, //
	< 9.4, 5.4, 	0 >, //
	< -8.75, -9.4, 	0 >, //
	< 8.75, -9.4, 	0 >, //
	< 0.0, 7.5, 	0 >, //
	< -4.35, 3.75, 	0 >, //
	< 4.35, 3.75, 	0 >, //
	< -4.35, -4.3, 	0 >, //
	< 4.35, -4.35, 	0 >, //
]

struct
{
	EnergyChargeWeaponData chargeWeaponData
} file


void function MpWeaponEnergyShotgun_Init()
{
	file.chargeWeaponData.blastPattern = BLAST_PATTERN_ENERGY_SHOTGUN
}

var function OnWeaponPrimaryAttack_weapon_energy_shotgun( entity weapon, WeaponPrimaryAttackParams attackParams)
{
	bool playerFired = true
	return Fire_EnergyShotgun( weapon, attackParams, playerFired )
}

#if(false)





#endif

int function Fire_EnergyShotgun( entity weapon, WeaponPrimaryAttackParams attackParams, bool playerFired )
{
	float patternScale = 1.0
	if ( weapon.HasMod( "npc_shotgunner" ) )
		patternScale = expect float( weapon.GetWeaponInfoFileKeyField( "projectile_blast_pattern_npc_scale" ) )

	return Fire_EnergyChargeWeapon( weapon, attackParams, file.chargeWeaponData, playerFired, patternScale )
}

bool function OnWeaponChargeLevelIncreased_weapon_energy_shotgun( entity weapon )
{
	return EnergyChargeWeapon_OnWeaponChargeLevelIncreased( weapon, file.chargeWeaponData )
}

void function OnWeaponChargeEnd_weapon_energy_shotgun( entity weapon )
{
	EnergyChargeWeapon_OnWeaponChargeEnd( weapon, file.chargeWeaponData )
}
