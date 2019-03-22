//

#if(false)



#endif //

global function MpWeaponZipline_Init
global function OnWeaponPrimaryAttack_weapon_zipline
global function OnProjectileCollision_weapon_zipline
global function OnWeaponReadyToFire_weapon_zipline
global function OnWeaponRaise_weapon_zipline

#if(CLIENT)
global function OnCreateClientOnlyModel_weapon_zipline
#endif

const ZIPLINE_STATION_MODEL_VERTICAL = $"mdl/IMC_base/scaffold_tech_horz_rail_c.rmdl"
const ZIPLINE_STATION_MODEL_HORIZONTAL = $"mdl/industrial/zipline_arm.rmdl"
const ZIPLINE_TEMP_ZIPLINE_GUN_STATION_MODEL = $"mdl/props/pathfinder_zipline/pathfinder_zipline.rmdl"
const ZIPLINE_TEMP_ZIPLINE_GUN_STATION_WALL_MODEL = $"mdl/props/pathfinder_zipline/pathfinder_zipline.rmdl"
const float ZIPLINE_DIST_MIN = 350.0
const float ZIPLINE_DIST_MAX = 10000.0
const ZIPLINE_STATION_EXPLOSION = $"p_impact_exp_small_full"
const float ZIPLINE_REFUND_TIME = 3
const float ZIPLINE_AUTO_DETACH_DISTANCE = 100.0

struct
{
	table<int, entity> activeWeaponBolts
} file

void function MpWeaponZipline_Init()
{
	PrecacheModel( ZIPLINE_STATION_MODEL_VERTICAL )
	PrecacheModel( ZIPLINE_STATION_MODEL_HORIZONTAL )
	PrecacheModel( ZIPLINE_TEMP_ZIPLINE_GUN_STATION_MODEL )
	PrecacheModel( ZIPLINE_TEMP_ZIPLINE_GUN_STATION_WALL_MODEL )
	PrecacheParticleSystem( ZIPLINE_STATION_EXPLOSION )

	PrecacheMaterial( $"cable/zipline" )
	PrecacheModel( $"cable/zipline.vmt" )
}

#if(false)




#endif //

#if(false)















//
//



//









#endif

var function OnWeaponPrimaryAttack_weapon_zipline( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	if ( !weapon.ZiplineGrenadeHasValidSpot() )
	{
		weapon.DoDryfire()
		return 0
	}

	#if(false)


//



#endif

	weapon.EmitWeaponNpcSound( LOUD_WEAPON_AI_SOUND_RADIUS_MP, 0.2 )
	entity weaponOwner = weapon.GetWeaponOwner()

	bool shouldCreateProjectile = false
	if ( IsServer() || weapon.ShouldPredictProjectiles() )
		shouldCreateProjectile = true

	if ( shouldCreateProjectile )
	{
		WeaponFireGrenadeParams fireGrenadeParams
		fireGrenadeParams.pos = attackParams.pos
		fireGrenadeParams.vel = attackParams.dir
		fireGrenadeParams.angVel = <0, 0, 0>
		fireGrenadeParams.fuseTime = 0.0
		fireGrenadeParams.scriptTouchDamageType = 0
		fireGrenadeParams.scriptExplosionDamageType = 0
		fireGrenadeParams.clientPredicted = true
		fireGrenadeParams.lagCompensated = true
		fireGrenadeParams.useScriptOnDamage = true
		fireGrenadeParams.isZiplineGrenade = true

		entity projectile = weapon.FireWeaponGrenade( fireGrenadeParams )

		#if(false)









#else
			PlayerUsedOffhand( weaponOwner, weapon )
		#endif //

	}

	return weapon.GetWeaponSettingInt( eWeaponVar.ammo_min_to_fire )
}

#if(false)




//










//








//




























































































#endif

bool function CanTetherEntities( entity startEnt, entity endEnt )
{
	TraceResults traceResult = TraceLine( startEnt.GetOrigin(), endEnt.GetOrigin(), [], TRACE_MASK_NPCWORLDSTATIC, TRACE_COLLISION_GROUP_NONE )
	if ( traceResult.fraction < 1 )
		return false

	return true
}


void function OnProjectileCollision_weapon_zipline( entity projectile, vector pos, vector normal, entity hitEnt, int hitbox, bool isCritical )
{
	#if(false)


























//




//






































#endif
}


void function OnWeaponReadyToFire_weapon_zipline( entity weapon )
{
	#if(false)

#endif
}

#if(CLIENT)
void function OnCreateClientOnlyModel_weapon_zipline( entity weapon, entity model, bool validHighlight )
{
	if ( validHighlight )
	{
		DeployableModelHighlight( model )
	}
	else
	{
		DeployableModelInvalidHighlight( model )
	}
}
#endif

#if(false)


//

//
//


















//






//







//






//





//




#endif

void function OnWeaponRaise_weapon_zipline( entity weapon )
{
	weapon.EmitWeaponSound_1p3p( "pathfinder_zipline_predeploy", "pathfinder_zipline_predeploy" )
}