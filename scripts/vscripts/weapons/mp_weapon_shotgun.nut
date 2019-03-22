
global function OnWeaponPrimaryAttack_weapon_shotgun

#if(false)

#endif //


//
//
const array<vector> BLAST_PATTERN_EVA_SHOTGUN = [
	//
	< -7.0, 7.0, 	0 >, //
	< 0.0, 11.0, 	0 >,
	< 7.0, 7.0, 	0 >,
	< -6.0, 0.0, 	0 >, //
	< 0.0, 0.0, 	0 >,
	< 6.0, 0.0, 	0 >,
	< -7.0, -7.0, 	0 >, //
	< 0.0, -11.0, 	0 >,
	< 7.0, -7.0, 	0 >,
]


var function OnWeaponPrimaryAttack_weapon_shotgun( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	bool playerFired = true
	Fire_EVA_Shotgun( weapon, attackParams, playerFired )
}

#if(false)





#endif //

int function Fire_EVA_Shotgun( entity weapon, WeaponPrimaryAttackParams attackParams, bool playerFired = true )
{
	weapon.EmitWeaponNpcSound( LOUD_WEAPON_AI_SOUND_RADIUS_MP, 0.2 )

	bool shouldCreateProjectile = false
	if ( IsServer() || weapon.ShouldPredictProjectiles() )
		shouldCreateProjectile = true

	#if(CLIENT)
		if ( !playerFired )
			shouldCreateProjectile = false
	#endif

	if ( shouldCreateProjectile )
	{
		float patternScale = 1.0
		if ( !playerFired )
			patternScale = expect float( weapon.GetWeaponInfoFileKeyField( "projectile_blast_pattern_npc_scale" ) )

		FireProjectileBlastPattern( weapon, attackParams, playerFired, BLAST_PATTERN_EVA_SHOTGUN, patternScale )
	}

	return weapon.GetWeaponSettingInt( eWeaponVar.ammo_per_shot )
}
