global function OnWeaponActivate_companion_launch_entry
global function OnWeaponAttemptOffhandSwitch_companion_launch_entry
global function OnWeaponPrimaryAttack_companion_launch_entry
global function OnWeaponPrimaryAttackAnimEvent_companion_launch_entry


bool function OnWeaponAttemptOffhandSwitch_companion_launch_entry( entity weapon )
{
	entity player = weapon.GetWeaponOwner()
	if ( !IsValid( player ) )
		return false

	                                             
	  	            

	if ( VantageCompanion_GetPlayerLaunchState( player ) != ePlayerLaunchState.NONE )
		return false

	return true
}

var function OnWeaponPrimaryAttack_companion_launch_entry( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	return -1
}

var function OnWeaponPrimaryAttackAnimEvent_companion_launch_entry( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	return -1
}

void function OnWeaponActivate_companion_launch_entry( entity weapon )
{
	entity player = weapon.GetWeaponOwner()
	if ( !IsValid( player ) )
		return

	#if CLIENT
	if ( player == GetLocalViewPlayer() )
	{
		entity whistleWeapon = player.GetOffhandWeapon( OFFHAND_RIGHT )

		if ( IsValid( whistleWeapon ) && whistleWeapon.GetWeaponClassName() == VANTAGE_COMPANION_LAUNCH_WEAPON_NAME )
		{
			ActivateOffhandWeaponByIndex( OFFHAND_RIGHT )
		}
	}
	#endif

}
