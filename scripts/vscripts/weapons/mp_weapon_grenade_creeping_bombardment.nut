
global function MpWeaponGrenadeCreepingBombardment_Init
global function OnProjectileCollision_WeaponCreepingBombardment
global function OnWeaponReadyToFire_WeaponCreepingBombardment
global function OnWeaponTossReleaseAnimEvent_WeaponCreepingBombardment
global function OnWeaponDeactivate_WeaponCreepingBombardment

#if(false)

#endif

//
const string CREEPING_BOMBARDMENT_MISSILE_WEAPON = "mp_weapon_creeping_bombardment_weapon"
const SFX_BOMBARDMENT_EXPLOSION_BANGALORE = "skyway_scripted_titanhill_mortar_explode"

const float CREEPING_BOMBARDMENT_WIDTH 		 	= 2750 //
const float CREEPING_BOMBARDMENT_BOMBS_PER_STEP = 6
const int 	CREEPING_BOMBARDMENT_STEP_COUNT		= 6//
const float CREEPING_BOMBARDMENT_STEP_INTERVAL 	= 0.75//
const float CREEPING_BOMBARDMENT_DELAY 			= 2.0 //

const float CREEPING_BOMBARDMENT_SHELLSHOCK_DURATION = 8.0

const asset FX_CREEPING_BOMBARDMENT_FLARE = $"P_bFlare"
const asset FX_CREEPING_BOMBARDMENT_GLOW_FP = $"P_bFlare_glow_FP"
const asset FX_CREEPING_BOMBARDMENT_GLOW_3P = $"P_bFlare_glow_3P"

const string CREEPING_BOMBARDMENT_FLARE_SOUND 	= "Bangalore_Ultimate_Flare_Hiss"

void function MpWeaponGrenadeCreepingBombardment_Init()
{
	PrecacheWeapon( CREEPING_BOMBARDMENT_MISSILE_WEAPON )

	PrecacheParticleSystem( FX_CREEPING_BOMBARDMENT_FLARE )
	PrecacheParticleSystem( FX_CREEPING_BOMBARDMENT_GLOW_FP )
	PrecacheParticleSystem( FX_CREEPING_BOMBARDMENT_GLOW_3P )

	#if(false)
//

#endif //

}

void function OnWeaponReadyToFire_WeaponCreepingBombardment( entity weapon )
{
	weapon.PlayWeaponEffect( FX_CREEPING_BOMBARDMENT_GLOW_FP, FX_CREEPING_BOMBARDMENT_GLOW_3P, "FX_TRAIL" )
}

void function OnWeaponDeactivate_WeaponCreepingBombardment( entity weapon )
{
	weapon.StopWeaponEffect( FX_CREEPING_BOMBARDMENT_GLOW_FP, FX_CREEPING_BOMBARDMENT_GLOW_3P )
	Grenade_OnWeaponDeactivate( weapon )
}

var function OnWeaponTossReleaseAnimEvent_WeaponCreepingBombardment( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	Grenade_OnWeaponTossReleaseAnimEvent( weapon, attackParams )

	weapon.StopWeaponEffect( FX_CREEPING_BOMBARDMENT_GLOW_FP, FX_CREEPING_BOMBARDMENT_GLOW_3P )

	entity weaponOwner = weapon.GetWeaponOwner()
	Assert( weaponOwner.IsPlayer() )

	#if(false)




#endif

	return weapon.GetWeaponSettingInt( eWeaponVar.ammo_per_shot )
}

void function OnProjectileCollision_WeaponCreepingBombardment( entity projectile, vector pos, vector normal, entity hitEnt, int hitbox, bool isCritical )
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

#if(false)


//



//
//














































#endif