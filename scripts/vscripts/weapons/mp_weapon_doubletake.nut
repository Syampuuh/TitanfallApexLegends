global function MpWeaponDoubletake_Init
global function OnWeaponPrimaryAttack_weapon_doubletake
global function OnWeaponChargeLevelIncreased_weapon_doubletake
global function OnWeaponChargeEnd_weapon_doubletake
global function OnProjectileCollision_weapon_doubletake

#if(false)

#endif //

//
//

//
//
const array<vector> BLAST_PATTERN_TRIPLE_TAKE = [
	//
	< 0.0, 0.0, 	0 >,
	< -1.0, 0.0, 	0 >,
	< 1.0, 0.0, 	0 >,
]

struct
{
	EnergyChargeWeaponData chargeWeaponData
} file


void function MpWeaponDoubletake_Init()
{
	//
	//

	file.chargeWeaponData.blastPattern = BLAST_PATTERN_TRIPLE_TAKE
	//
	//
	//
}

var function OnWeaponPrimaryAttack_weapon_doubletake( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	bool playerFired = true
	return Fire_DoubleTake( weapon, attackParams, playerFired)
}

#if(false)





#endif //

int function Fire_DoubleTake( entity weapon, WeaponPrimaryAttackParams attackParams, bool playerFired )
{
	float patternScale = 1.0

	if ( playerFired )
	{
		float spreadAngle = weapon.GetAttackSpreadAngle()
		//
		patternScale += spreadAngle
	}
	else
	{
		patternScale = expect float( weapon.GetWeaponInfoFileKeyField( "projectile_blast_pattern_npc_scale" ) )
	}

	bool ignoreSpread = false
	return Fire_EnergyChargeWeapon( weapon, attackParams, file.chargeWeaponData, playerFired, patternScale, ignoreSpread )
}

bool function OnWeaponChargeLevelIncreased_weapon_doubletake( entity weapon )
{
	return EnergyChargeWeapon_OnWeaponChargeLevelIncreased( weapon, file.chargeWeaponData )
}

void function OnWeaponChargeEnd_weapon_doubletake( entity weapon )
{
	EnergyChargeWeapon_OnWeaponChargeEnd( weapon, file.chargeWeaponData )
}

void function OnProjectileCollision_weapon_doubletake( entity projectile, vector pos, vector normal, entity hitEnt, int hitbox, bool isCritical )
{
	#if(false)





#endif
}