global function OnWeaponChargeBegin_ability_mirage_ultimate
global function OnWeaponChargeEnd_ability_mirage_ultimate
global function OnWeaponAttemptOffhandSwitch_ability_mirage_ultimate

bool function OnWeaponAttemptOffhandSwitch_ability_mirage_ultimate( entity weapon )
{
	entity player = weapon.GetWeaponOwner()
	if ( player.IsPhaseShifted() )
		return false

	if ( !PlayerCanUseDecoy( player ) )
		return false

	return true
}

var function OnWeaponPrimaryAttack_mirage_ultimate( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	var ammoToReturn = OnWeaponPrimaryAttack_holopilot( weapon, attackParams )
	#if(false)


#endif
	return ammoToReturn
}

void function OnWeaponChargeEnd_ability_mirage_ultimate( entity weapon )
{
	if ( weapon.GetWeaponPrimaryClipCount() == 0 ) //
		return

	weapon.SetWeaponPrimaryClipCount( 0 )
	WeaponPrimaryAttackParams attackParams
	OnWeaponPrimaryAttack_mirage_ultimate( weapon, attackParams )
}

#if(false)
















































#endif

bool function OnWeaponChargeBegin_ability_mirage_ultimate( entity weapon )
{
	weapon.EmitWeaponSound_1p3p( "Mirage_Vanish_Activate_1P", "Mirage_Vanish_Activate_3P" )
	entity ownerPlayer = weapon.GetWeaponOwner()
	PlayerUsedOffhand( ownerPlayer, weapon, false )
	#if(false)


//

#endif
	return true
}