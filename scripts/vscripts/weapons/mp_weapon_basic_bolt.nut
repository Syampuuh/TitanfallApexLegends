
global function MpWeaponBasicBolt_Init

global function OnWeaponActivate_weapon_basic_bolt
global function OnWeaponPrimaryAttack_weapon_basic_bolt
global function OnProjectileCollision_weapon_basic_bolt

#if(CLIENT)
global function OnClientAnimEvent_weapon_basic_bolt
#endif //

#if(false)

#endif //

void function MpWeaponBasicBolt_Init()
{
	BasicBoltPrecache()
}

void function BasicBoltPrecache()
{
	PrecacheParticleSystem( $"wpn_mflash_snp_hmn_smoke_side_FP" )
	PrecacheParticleSystem( $"wpn_mflash_snp_hmn_smoke_side" )
}

void function OnWeaponActivate_weapon_basic_bolt( entity weapon )
{
#if(CLIENT)
	UpdateViewmodelAmmo( false, weapon )
#endif //
}

#if(CLIENT)
void function OnClientAnimEvent_weapon_basic_bolt( entity weapon, string name )
{
	GlobalClientEventHandler( weapon, name )
}

#endif //

var function OnWeaponPrimaryAttack_weapon_basic_bolt( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	weapon.EmitWeaponNpcSound( LOUD_WEAPON_AI_SOUND_RADIUS_MP, 0.2 )

	return FireWeaponPlayerAndNPC( weapon, attackParams, true )
}

#if(false)






#endif //

int function FireWeaponPlayerAndNPC( entity weapon, WeaponPrimaryAttackParams attackParams, bool playerFired )
{
	bool shouldCreateProjectile = false
	if ( IsServer() || weapon.ShouldPredictProjectiles() )
		shouldCreateProjectile = true

	#if(CLIENT)
		if ( !playerFired )
			shouldCreateProjectile = false
	#endif

	if ( shouldCreateProjectile )
		entity bolt = FireBallisticRoundWithDrop( weapon, attackParams.pos, attackParams.dir, playerFired, false, 0, false )

	return 1
}

void function OnProjectileCollision_weapon_basic_bolt( entity projectile, vector pos, vector normal, entity hitEnt, int hitbox, bool isCritical )
{
	#if(false)





















#endif
}