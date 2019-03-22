global function OnWeaponActivate_ability_grapple
global function OnWeaponPrimaryAttack_ability_grapple
global function OnWeaponAttemptOffhandSwitch_ability_grapple
global function OnWeaponReadyToFire_ability_grapple
global function CodeCallback_OnGrappleActivate
global function CodeCallback_OnGrappleAttach
global function CodeCallback_OnGrappleDetach
global function GrappleWeaponInit

#if(false)







#endif //

struct
{
	int grappleExplodeImpactTable
	array<void functionref( entity player, entity hitent, vector hitpos, vector hitNormal )> onGrappledCallbacks
	array<void functionref( entity player )> onGrappleDetachCallbacks
} file

const int GRAPPLEFLAG_CHARGED	= (1<<0)
const int CHANCE_TO_COMMENT_GRAPPLE = 33

void function GrappleWeaponInit()
{
	file.grappleExplodeImpactTable = PrecacheImpactEffectTable( "exp_rocket_archer" )

#if(false)

#endif //

#if(false)


//
#endif
}

void function OnWeaponActivate_ability_grapple( entity weapon )
{
	entity weaponOwner = weapon.GetWeaponOwner()
	int pmLevel = -1
	#if(false)

#endif
	if ( (pmLevel >= 2) && IsValid( weaponOwner ) )
		weapon.SetScriptTime0( Time() )
	else
		weapon.SetScriptTime0( 0.0 )

	//
	{
		int oldFlags = weapon.GetScriptFlags0()
		weapon.SetScriptFlags0( oldFlags & ~GRAPPLEFLAG_CHARGED )
	}
}

#if(false)











#endif

var function OnWeaponPrimaryAttack_ability_grapple( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	entity owner = weapon.GetWeaponOwner()

	if ( owner.IsPlayer() )
	{
		int pmLevel = -1
		#if(false)

#endif
		float scriptTime = weapon.GetScriptTime0()
		if ( (pmLevel >= 2) && (scriptTime != 0.0) )
		{
			float chargeMaxTime = weapon.GetWeaponSettingFloat( eWeaponVar.custom_float_0 )
			float chargeTime = (Time() - scriptTime)
			if ( chargeTime >= chargeMaxTime )
			{
				int oldFlags = weapon.GetScriptFlags0()
				weapon.SetScriptFlags0( oldFlags | GRAPPLEFLAG_CHARGED )
			}
		}
	}

	PlayerUsedOffhand( owner, weapon )

	vector grappleDirection = attackParams.dir
	entity grappleAutoAimTarget = null
	if ( owner.IsPlayer() )
	{
		if ( !owner.IsGrappleActive() )
		{
			entity autoAimTarget = GrappleAutoAim_FindTarget( owner )
			if ( autoAimTarget )
			{
				vector ownerToTarget = autoAimTarget.GetWorldSpaceCenter() - attackParams.pos
				grappleDirection = Normalize( ownerToTarget )
				grappleAutoAimTarget = autoAimTarget
			}
		}
	}
	owner.Grapple( grappleDirection )

	if ( owner.IsPlayer() && owner.IsGrappleActive() && grappleAutoAimTarget )
	{
		owner.SetGrappleAutoAimTarget( grappleAutoAimTarget )
	}
	if ( weapon.HasMod( "survival_finite_ordnance" ) )
		return 0
	else
		return weapon.GetWeaponSettingInt( eWeaponVar.ammo_min_to_fire )
}

#if(false)








#endif

bool function OnWeaponAttemptOffhandSwitch_ability_grapple( entity weapon )
{
	entity ownerPlayer = weapon.GetWeaponOwner()
	bool allowSwitch = (ownerPlayer.GetSuitGrapplePower() >= 100.0)

	if ( !allowSwitch )
	{
		Assert( ownerPlayer == weapon.GetWeaponOwner() )
		ownerPlayer.Grapple( <0,0,1> )
	}

	return allowSwitch
}

void function OnWeaponReadyToFire_ability_grapple( entity weapon )
{
	#if(false)

#endif
}

void function DoGrappleImpactExplosion( entity player, entity grappleWeapon, entity hitent, vector hitpos, vector hitNormal )
{
#if(CLIENT)
	if ( !grappleWeapon.ShouldPredictProjectiles() )
		return
#endif //

	vector origin = hitpos + hitNormal * 16.0
	int damageType = (DF_RAGDOLL | DF_EXPLOSION | DF_ELECTRICAL)
	WeaponFireGrenadeParams fireGrenadeParams
	fireGrenadeParams.pos = origin
	fireGrenadeParams.vel = hitNormal
	fireGrenadeParams.angVel = <0,0,0>
	fireGrenadeParams.fuseTime = 0.01
	fireGrenadeParams.scriptTouchDamageType = damageType
	fireGrenadeParams.scriptExplosionDamageType = damageType
	fireGrenadeParams.clientPredicted = true
	fireGrenadeParams.lagCompensated = true
	fireGrenadeParams.useScriptOnDamage = true
	entity nade = grappleWeapon.FireWeaponGrenade( fireGrenadeParams )
	if ( !nade )
		return

	nade.SetImpactEffectTable( file.grappleExplodeImpactTable )
	nade.GrenadeExplode( hitNormal )
}

void function CodeCallback_OnGrappleActivate( entity player )
{
}

void function CodeCallback_OnGrappleAttach( entity player, entity hitent, vector hitpos, vector hitNormal )
{
#if(false)




//






//










#endif //

	//
	{
		if ( !IsValid( player ) )
			return

		entity grappleWeapon = player.GetOffhandWeapon( OFFHAND_LEFT )
		if ( !IsValid( grappleWeapon ) )
			return
		if ( !grappleWeapon.GetWeaponSettingBool( eWeaponVar.grapple_weapon ) )
			return

		if ( grappleWeapon.HasMod( "survival_finite_ordnance" ) )
		{
			int newAmmo = maxint( 0, grappleWeapon.GetWeaponPrimaryClipCount() - grappleWeapon.GetWeaponSettingInt( eWeaponVar.ammo_min_to_fire ) )
			grappleWeapon.SetWeaponPrimaryClipCount( newAmmo )
		}

		int flags = grappleWeapon.GetScriptFlags0()
		if ( ! (flags & GRAPPLEFLAG_CHARGED) )
			return

		int expDamage = grappleWeapon.GetWeaponSettingInt( eWeaponVar.explosion_damage )
		if ( expDamage <= 0 )
			return

		DoGrappleImpactExplosion( player, grappleWeapon, hitent, hitpos, hitNormal )
	}
}

void function CodeCallback_OnGrappleDetach( entity player )
{
	#if(false)
//





//
#endif
}

#if(false)























































































//













#endif //
