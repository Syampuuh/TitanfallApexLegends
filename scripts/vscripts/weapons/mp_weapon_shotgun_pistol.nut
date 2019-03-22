global function OnWeaponPrimaryAttack_weapon_shotgun_pistol

#if(false)

#endif //

//
//
array<vector> BLAST_PATTERN_SHOTGUN_PISTOL = [
	//
	< 0.0, 8.0, 	0 >, //
	< -6.0, -6.0, 	0 >, //
	< 6.0, -6.0, 	0 >, //
]

const float BLAST_PATTERN_ADS_SCALE_REDUCTION = 0.5  //


var function OnWeaponPrimaryAttack_weapon_shotgun_pistol( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	bool playerFired = true
	return Fire_ShotgunPistol( weapon, attackParams, playerFired )
}

#if(false)





#endif //

int function Fire_ShotgunPistol( entity weapon, WeaponPrimaryAttackParams attackParams, bool playerFired = true )
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
		if ( playerFired )
		{
			//
			entity owner = weapon.GetWeaponOwner()
			patternScale *= GraphCapped( owner.GetZoomFrac(), 0.0, 1.0, 1.0, BLAST_PATTERN_ADS_SCALE_REDUCTION )
		}
		else
		{
			patternScale = expect float( weapon.GetWeaponInfoFileKeyField( "projectile_blast_pattern_npc_scale" ) )
		}

		FireProjectileBlastPattern( weapon, attackParams, playerFired, BLAST_PATTERN_SHOTGUN_PISTOL, patternScale )
	}

	return weapon.GetWeaponSettingInt( eWeaponVar.ammo_per_shot )
}
