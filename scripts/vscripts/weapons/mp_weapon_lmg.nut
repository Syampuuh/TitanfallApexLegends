global function OnWeaponPrimaryAttack_lmg
global function OnWeaponActivate_lmg
global function OnWeaponBulletHit_weapon_lmg

#if(false)

#endif //

const float LMG_SMART_AMMO_TRACKER_TIME = 10.0

void function OnWeaponActivate_lmg( entity weapon )
{
	//
	SmartAmmo_SetAllowUnlockedFiring( weapon, true )
	SmartAmmo_SetUnlockAfterBurst( weapon, (SMART_AMMO_PLAYER_MAX_LOCKS > 1) )
	SmartAmmo_SetWarningIndicatorDelay( weapon, 9999.0 )
}

var function OnWeaponPrimaryAttack_lmg( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	if ( weapon.HasMod( "smart_lock_dev" ) )
	{
		int damageFlags = weapon.GetWeaponDamageFlags()
		//
		return SmartAmmo_FireWeapon( weapon, attackParams, damageFlags, damageFlags )
	}
	else
	{
		weapon.EmitWeaponNpcSound( LOUD_WEAPON_AI_SOUND_RADIUS_MP, 0.2 )
		weapon.FireWeaponBullet( attackParams.pos, attackParams.dir, 1, weapon.GetWeaponDamageFlags() )
	}
}

#if(false)





#endif //

void function OnWeaponBulletHit_weapon_lmg( entity weapon, WeaponBulletHitParams hitParams )
{
	if ( !weapon.HasMod( "smart_lock_dev" ) )
		return

	entity hitEnt = hitParams.hitEnt //

	if ( IsValid( hitEnt ) )
	{
		weapon.SmartAmmo_TrackEntity( hitEnt, LMG_SMART_AMMO_TRACKER_TIME )

		#if(false)
//




#endif
	}
}
