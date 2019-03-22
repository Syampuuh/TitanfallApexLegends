global function OnWeaponChargeBegin_ability_heal
global function OnWeaponPrimaryAttack_ability_heal
global function OnWeaponChargeEnd_ability_heal

bool function OnWeaponChargeBegin_ability_heal( entity weapon )
{
	entity ownerPlayer = weapon.GetWeaponOwner()
	float duration     = weapon.GetWeaponSettingFloat( eWeaponVar.charge_time )
	StimPlayer( ownerPlayer, duration )
	#if(false)







#endif
	PlayerUsedOffhand( ownerPlayer, weapon )

	#if(false)







#else
		Rumble_Play( "rumble_stim_activate", {} )
	#endif
	return true
}


void function OnWeaponChargeEnd_ability_heal( entity weapon )
{
	entity player = weapon.GetWeaponOwner()
	#if(false)
//
//

#endif
}


var function OnWeaponPrimaryAttack_ability_heal( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	entity player = weapon.GetWeaponOwner()
	return weapon.GetWeaponSettingInt( eWeaponVar.ammo_per_shot )
}


