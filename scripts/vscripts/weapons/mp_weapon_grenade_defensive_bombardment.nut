
global function MpWeaponGrenadeDefensiveBombardment_Init
global function OnProjectileCollision_WeaponDefensiveBombardment
global function OnProjectileCollision_WeaponDefensiveBombardmentExplosion
global function OnWeaponTossReleaseAnimEvent_WeaponDefensiveBombardment
global function OnWeaponOwnerChanged_WeaponDefensiveBombardment

const string DEFENSIVE_BOMBARDMENT_MISSILE_WEAPON = "mp_weapon_defensive_bombardment_weapon"

//
const asset FX_BOMBARDMENT_MARKER = $"P_ar_artillery_marker"

const float DEFENSIVE_BOMBARDMENT_RADIUS 		 	= 1024 //
const int	DEFENSIVE_BOMBARDMENT_DENSITY			= 6	//
const float DEFENSIVE_BOMBARDMENT_DURATION			= 8.0 //
const float DEFENSIVE_BOMBARDMENT_DELAY 			= 2.0 //

const float DEFENSIVE_BOMBARDMENT_SHELLSHOCK_DURATION = 4.0

const asset FX_DEFENSIVE_BOMBARDMENT_SCAN = $"P_artillery_marker_scan"

void function MpWeaponGrenadeDefensiveBombardment_Init()
{
	PrecacheWeapon( DEFENSIVE_BOMBARDMENT_MISSILE_WEAPON )

	PrecacheParticleSystem( FX_DEFENSIVE_BOMBARDMENT_SCAN )
	PrecacheParticleSystem( FX_BOMBARDMENT_MARKER )

	#if(false)

#endif //
}

void function OnWeaponOwnerChanged_WeaponDefensiveBombardment( entity weapon, WeaponOwnerChangedParams changeParams )
{
	#if(false)















#endif
}

var function OnWeaponTossReleaseAnimEvent_WeaponDefensiveBombardment( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	entity owner = weapon.GetWeaponOwner()

	if ( !IsValid( owner ) )
		return

	#if(false)





#endif

	Grenade_OnWeaponTossReleaseAnimEvent( weapon, attackParams )
	return weapon.GetWeaponSettingInt( eWeaponVar.ammo_per_shot )
}

void function OnProjectileCollision_WeaponDefensiveBombardment( entity projectile, vector pos, vector normal, entity hitEnt, int hitbox, bool isCritical )
{
	entity player = projectile.GetOwner()
	if ( hitEnt == player )
		return

	if ( projectile.GrenadeHasIgnited() )
		return

	table collisionParams =
	{
		pos = pos,
		normal = normal,
		hitEnt = hitEnt,
		hitbox = hitbox
	}

	bool result = PlantStickyEntityOnWorldThatBouncesOffWalls( projectile, collisionParams, 0.7 )

	#if(false)








#endif
	projectile.GrenadeIgnite()
	projectile.SetDoesExplode( false )
}

void function OnProjectileCollision_WeaponDefensiveBombardmentExplosion( entity projectile, vector pos, vector normal, entity hitEnt, int hitbox, bool isCritical )
{
	#if(false)





#endif
}

#if(false)


//



//
//








































#endif
