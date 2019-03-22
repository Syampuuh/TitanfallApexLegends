untyped

//
global function WeaponUtility_Init

global function ApplyVectorSpread
global function DebugDrawMissilePath
global function DegreesToTarget
global function EntityCanHaveStickyEnts
global function EntityShouldStick
global function FireExpandContractMissiles
global function FireExpandContractMissiles_S2S
global function GetVectorFromPositionToCrosshair
global function GetVelocityForDestOverTime
global function GetPlayerVelocityForDestOverTime
global function GetWeaponBurnMods
global function InitMissileForRandomDriftForVortexLow
global function IsPilotShotgunWeapon
global function PlantStickyEntity
global function PlantStickyEntityThatBouncesOffWalls
global function PlantStickyEntityOnWorldThatBouncesOffWalls
global function PlantStickyGrenade
global function PlantSuperStickyGrenade
global function Player_DetonateSatchels
global function PROTO_CanPlayerDeployWeapon
global function ProximityCharge_PostFired_Init
global function EnergyChargeWeapon_OnWeaponChargeLevelIncreased
global function EnergyChargeWeapon_OnWeaponChargeBegin
global function EnergyChargeWeapon_OnWeaponChargeEnd
global function Fire_EnergyChargeWeapon
global function FireHitscanShotgunBlast
global function FireProjectileShotgunBlast
global function ProjectileShotgun_GetOuterSpread
global function ProjectileShotgun_GetInnerSpread
global function FireProjectileBlastPattern
global function FireGenericBoltWithDrop
global function OnWeaponPrimaryAttack_GenericBoltWithDrop_Player
global function OnWeaponPrimaryAttack_GenericMissile_Player
global function OnWeaponActivate_updateViewmodelAmmo
global function TEMP_GetDamageFlagsFromProjectile
global function WeaponCanCrit
global function GiveEMPStunStatusEffects
global function GetPrimaryWeapons
global function GetSidearmWeapons
global function GetATWeapons
global function GetPlayerFromTitanWeapon
global function GetMaxTrackerCountForTitan
global function FireBallisticRoundWithDrop
global function DoesModExist
global function DoesModExistFromWeaponClassName
global function IsModActive
global function PlayerUsedOffhand
global function GetDistanceString
global function IsWeaponInSingleShotMode
global function IsWeaponInBurstMode
global function IsWeaponOffhand
global function IsWeaponInAutomaticMode
global function OnWeaponReadyToFire_ability_tactical
global function GetMeleeWeapon
global function OnWeaponRegenEndGeneric
global function Ultimate_OnWeaponRegenBegin
global function OnWeaponActivate_RUIColorSchemeOverrides

#if(false)









#endif

#if(CLIENT)
global function ServerCallback_SetWeaponPreviewState
#endif

global function GetRadiusDamageDataFromProjectile
global function OnWeaponAttemptOffhandSwitch_Never

#if(DEV)
global function DevPrintAllStatusEffectsOnEnt
#endif //

#if(false)
















































#endif //

#if(CLIENT)
global function GlobalClientEventHandler
global function UpdateViewmodelAmmo
global function IsOwnerViewPlayerFullyADSed
global function ServerCallback_SatchelPlanted
#endif //

global function AddCallback_OnPlayerAddWeaponMod
global function AddCallback_OnPlayerRemoveWeaponMod

global function CodeCallback_OnPlayerAddedWeaponMod
global function CodeCallback_OnPlayerRemovedWeaponMod

global const bool PROJECTILE_PREDICTED = true
global const bool PROJECTILE_NOT_PREDICTED = false

global const bool PROJECTILE_LAG_COMPENSATED = true
global const bool PROJECTILE_NOT_LAG_COMPENSATED = false

global const PRO_SCREEN_IDX_MATCH_KILLS = 1
global const PRO_SCREEN_IDX_AMMO_COUNTER_OVERRIDE_HACK = 2

const float DEFAULT_SHOTGUN_SPREAD_INNEREXCLUDE_FRAC = 0.4
const bool DEBUG_PROJECTILE_BLAST = false

const float EMP_SEVERITY_SLOWTURN = 0.35
const float EMP_SEVERITY_SLOWMOVE = 0.50
const float LASER_STUN_SEVERITY_SLOWTURN = 0.20
const float LASER_STUN_SEVERITY_SLOWMOVE = 0.30

const asset FX_EMP_BODY_HUMAN = $"P_emp_body_human"
const asset FX_EMP_BODY_TITAN = $"P_emp_body_titan"
const asset FX_VANGUARD_ENERGY_BODY_HUMAN = $"P_monarchBeam_body_human"
const asset FX_VANGUARD_ENERGY_BODY_TITAN = $"P_monarchBeam_body_titan"
const SOUND_EMP_REBOOT_SPARKS = "marvin_weld"
const FX_EMP_REBOOT_SPARKS = $"weld_spark_01_sparksfly"
const EMP_GRENADE_BEAM_EFFECT = $"wpn_arc_cannon_beam"
const DRONE_REBOOT_TIME = 5.0
const GUNSHIP_REBOOT_TIME = 5.0

const bool DEBUG_BURN_DAMAGE = false

const float BOUNCE_STUCK_DISTANCE = 5.0

global struct RadiusDamageData
{
	int   explosionDamage
	int   explosionDamageHeavyArmor
	float explosionRadius
	float explosionInnerRadius
}

global struct EnergyChargeWeaponData
{
	array<vector> blastPattern
	string        fx_barrel_glow_attach
	asset         fx_barrel_glow_final_1p
	asset         fx_barrel_glow_final_3p
}

#if(false)



//





























#endif

struct
{
	#if(false)












#else //
		var satchelHintRUI = null
	#endif

	array<void functionref( entity, entity, string )> playerAddWeaponModCallbacks
	array<void functionref( entity, entity, string )> playerRemoveWeaponModCallbacks
} file

global int HOLO_PILOT_TRAIL_FX


void function WeaponUtility_Init()
{
	level.weaponsPrecached <- {}

	//
	level.stickyClasses <- {}
	level.stickyClasses[ "worldspawn" ]                <- true
	level.stickyClasses[ "player" ]                    <- true
	level.stickyClasses[ "prop_dynamic" ]            <- true
	level.stickyClasses[ "prop_script" ]            <- true
	level.stickyClasses[ "func_brush" ]                <- true
	level.stickyClasses[ "func_brush_lightweight" ]    <- true
	level.stickyClasses[ "phys_bone_follower" ]        <- true
	level.stickyClasses[ "door_mover" ]                <- true
	level.stickyClasses[ "prop_door" ]                <- true
	level.stickyClasses[ "script_mover" ]                <- true

	level.trapChainReactClasses <- {}
	level.trapChainReactClasses[ "mp_weapon_frag_grenade" ]            <- true
	level.trapChainReactClasses[ "mp_weapon_satchel" ]                <- true
	level.trapChainReactClasses[ "mp_weapon_proximity_mine" ]        <- true
	level.trapChainReactClasses[ "mp_weapon_laser_mine" ]            <- true

	RegisterSignal( "Planted" )
	RegisterSignal( "OnKnifeStick" )
	RegisterSignal( "EMP_FX" )
	RegisterSignal( "ArcStunned" )
	RegisterSignal( "CleanupPlayerPermanents" )
	RegisterSignal( "OnSustainedDischargeEnd" )
	RegisterSignal( "EnergyWeapon_ChargeStart" )
	RegisterSignal( "EnergyWeapon_ChargeReleased" )
	RegisterSignal( "WeaponSignal_EnemyKilled" )

	PrecacheParticleSystem( EMP_GRENADE_BEAM_EFFECT )
	PrecacheParticleSystem( FX_EMP_BODY_TITAN )
	PrecacheParticleSystem( FX_EMP_BODY_HUMAN )
	PrecacheParticleSystem( FX_VANGUARD_ENERGY_BODY_HUMAN )
	PrecacheParticleSystem( FX_VANGUARD_ENERGY_BODY_TITAN )
	PrecacheParticleSystem( FX_EMP_REBOOT_SPARKS )

	PrecacheImpactEffectTable( CLUSTER_ROCKET_FX_TABLE )

	#if(false)



















#endif

	HOLO_PILOT_TRAIL_FX = PrecacheParticleSystem( $"P_ar_holopilot_trail" )
}

#if(false)


//
//
//
//
//

#endif

//

#if(CLIENT)
void function GlobalClientEventHandler( entity weapon, string name )
{
	if ( name == "ammo_update" )
		UpdateViewmodelAmmo( false, weapon )

	if ( name == "ammo_full" )
		UpdateViewmodelAmmo( true, weapon )
}

void function UpdateViewmodelAmmo( bool forceFull, entity weapon )
{
	Assert( weapon != null ) //

	if ( !IsValid( weapon ) )
		return
	if ( !IsLocalViewPlayer( weapon.GetWeaponOwner() ) )
		return

	int bodyGroupCount = weapon.GetWeaponSettingInt( eWeaponVar.bodygroup_ammo_index_count )
	if ( bodyGroupCount <= 0 )
		return

	int rounds                = weapon.GetWeaponPrimaryClipCount()
	int maxRoundsForClipSize  = weapon.GetWeaponPrimaryClipCountMax()
	int maxRoundsForBodyGroup = (bodyGroupCount - 1)
	int maxRounds             = minint( maxRoundsForClipSize, maxRoundsForBodyGroup )

	if ( forceFull || (rounds > maxRounds) )
		rounds = maxRounds

	//
	weapon.SetViewmodelAmmoModelIndex( rounds )
}
#endif //

void function OnWeaponActivate_updateViewmodelAmmo( entity weapon )
{
	#if(CLIENT)
		UpdateViewmodelAmmo( false, weapon )
	#endif //
}

//

void function OnWeaponActivate_RUIColorSchemeOverrides( entity weapon )
{
	#if(false)

#endif
}

#if(false)





//
//












//


#endif

#if(false)











#endif

int function Fire_EnergyChargeWeapon( entity weapon, WeaponPrimaryAttackParams attackParams, EnergyChargeWeaponData chargeWeaponData, bool playerFired = true, float patternScale = 1.0, bool ignoreSpread = true )
{
	weapon.EmitWeaponNpcSound( LOUD_WEAPON_AI_SOUND_RADIUS_MP, 0.2 )

	bool shouldCreateProjectile = false
	if ( IsServer() || weapon.ShouldPredictProjectiles() )
		shouldCreateProjectile = true

	#if(CLIENT)
		if ( !playerFired )
			shouldCreateProjectile = false
	#endif

	int chargeLevel = EnergyChargeWeapon_GetChargeLevel( weapon )
	//
	if ( chargeLevel == 0 )
		return 0

	if ( shouldCreateProjectile )
	{
		//
		float spreadChokeFrac = 1.0
		//
		switch( chargeLevel )
		{
			case 1:
				spreadChokeFrac = expect float( weapon.GetWeaponInfoFileKeyField( "projectile_spread_choke_frac_1" ) )
				break

			case 2:
				spreadChokeFrac = expect float( weapon.GetWeaponInfoFileKeyField( "projectile_spread_choke_frac_2" ) )
				break

			case 3:
				spreadChokeFrac = expect float( weapon.GetWeaponInfoFileKeyField( "projectile_spread_choke_frac_3" ) )
				break

			case 4:
				spreadChokeFrac = expect float( weapon.GetWeaponInfoFileKeyField( "projectile_spread_choke_frac_4" ) )
				break

			default:
				Assert( false, "chargeLevel " + chargeLevel + " doesn't have matching weaponsetting for projectile_spread_choke_frac_" + chargeLevel )
		}
		patternScale *= spreadChokeFrac

		FireProjectileBlastPattern( weapon, attackParams, playerFired, chargeWeaponData.blastPattern, patternScale, ignoreSpread )
	}

	if ( weapon.IsChargeWeapon() )
		EnergyChargeWeapon_StopCharge( weapon, chargeWeaponData )

	return weapon.GetWeaponSettingInt( eWeaponVar.ammo_per_shot )
}


int function EnergyChargeWeapon_GetChargeLevel( entity weapon )
{
	if ( !IsValid( weapon ) )
		return 0

	entity owner = weapon.GetWeaponOwner()
	if ( !IsValid( owner ) )
		return 0

	if ( !owner.IsPlayer() )
		return 1

	if ( !weapon.IsReadyToFire() )
		return 0

	if ( !weapon.IsChargeWeapon() )
		return 1

	int chargeLevel = weapon.GetWeaponChargeLevel()
	return chargeLevel
}


bool function EnergyChargeWeapon_OnWeaponChargeLevelIncreased( entity weapon, EnergyChargeWeaponData chargeWeaponData )
{
	#if(CLIENT)
		if ( InPrediction() && !IsFirstTimePredicted() )
			return true
#endif

#if(false)
//
#endif

	int level    = weapon.GetWeaponChargeLevel()
	int maxLevel = weapon.GetWeaponChargeLevelMax()

	string tickSound
	string tickSound_3p

	if ( level == maxLevel )
	{
		tickSound = expect string( weapon.GetWeaponInfoFileKeyField( "sound_energy_charge_leveltick_final" ) )
		tickSound_3p = expect string( weapon.GetWeaponInfoFileKeyField( "sound_energy_charge_leveltick_final_3p" ) )
	}
	else
	{
		switch ( level )
		{
			case 1:
				tickSound = expect string( weapon.GetWeaponInfoFileKeyField( "sound_energy_charge_leveltick_1" ) )
				tickSound_3p = expect string( weapon.GetWeaponInfoFileKeyField( "sound_energy_charge_leveltick_1_3p" ) )

				break

			case 2:
				if ( chargeWeaponData.fx_barrel_glow_attach != "" )
					weapon.PlayWeaponEffect( chargeWeaponData.fx_barrel_glow_final_1p, chargeWeaponData.fx_barrel_glow_final_3p, chargeWeaponData.fx_barrel_glow_attach )

				tickSound = expect string( weapon.GetWeaponInfoFileKeyField( "sound_energy_charge_leveltick_2" ) )
				tickSound_3p = expect string( weapon.GetWeaponInfoFileKeyField( "sound_energy_charge_leveltick_2_3p" ) )

				break

			case 3:
				tickSound = expect string( weapon.GetWeaponInfoFileKeyField( "sound_energy_charge_leveltick_3" ) )
				tickSound_3p = expect string( weapon.GetWeaponInfoFileKeyField( "sound_energy_charge_leveltick_3_3p" ) )
				break
		}
	}

	if ( tickSound != "" || tickSound_3p != "" )
		weapon.EmitWeaponSound_1p3p( tickSound, tickSound_3p )

	return true
}


void function EnergyChargeWeapon_StopCharge( entity weapon, EnergyChargeWeaponData chargeWeaponData )
{
	if ( chargeWeaponData.fx_barrel_glow_attach != "" )
		weapon.StopWeaponEffect( chargeWeaponData.fx_barrel_glow_final_1p, chargeWeaponData.fx_barrel_glow_final_3p )

	weapon.StopWeaponSound( expect string( weapon.GetWeaponInfoFileKeyField( "sound_energy_charge_loop" ) ) )
	weapon.StopWeaponSound( expect string( weapon.GetWeaponInfoFileKeyField( "sound_energy_charge_loop_3p" ) ) )

	#if(CLIENT)
		//
		float chargeTime          = weapon.GetWeaponSettingFloat( eWeaponVar.charge_time )
		int chargeLevels          = weapon.GetWeaponSettingInt( eWeaponVar.charge_levels )
		int chargeLevelBase       = weapon.GetWeaponSettingInt( eWeaponVar.charge_level_base )
		float weaponMinChargeTime = chargeTime / (chargeLevels - chargeLevelBase).tofloat()

		if ( Time() - weapon.w.startChargeTime >= weaponMinChargeTime )
		{
			weapon.EmitWeaponSound( expect string( weapon.GetWeaponInfoFileKeyField( "sound_energy_charge_end" ) ) )
		}
	#elseif(false)





#endif
}


bool function EnergyChargeWeapon_OnWeaponChargeBegin( entity weapon )
{
	weapon.Signal( "EnergyWeapon_ChargeStart" )

	if ( weapon.GetWeaponChargeFraction() == 0 )
	{
		weapon.w.startChargeTime = Time()

		string chargeStart    = expect string( weapon.GetWeaponInfoFileKeyField( "sound_energy_charge_start" ) )
		string chargeStart_3p = expect string( weapon.GetWeaponInfoFileKeyField( "sound_energy_charge_start_3p" ) )
		weapon.EmitWeaponSound_1p3p( chargeStart, chargeStart_3p )
	}

	string chargeLoop    = expect string( weapon.GetWeaponInfoFileKeyField( "sound_energy_charge_loop" ) )
	string chargeLoop_3p = expect string( weapon.GetWeaponInfoFileKeyField( "sound_energy_charge_loop_3p" ) )
	weapon.EmitWeaponSound_1p3p( chargeLoop, chargeLoop_3p )

	return true
}


void function EnergyChargeWeapon_OnWeaponChargeEnd( entity weapon, EnergyChargeWeaponData chargeWeaponData )
{
	//
	weapon.Signal( "EnergyWeapon_ChargeReleased" )

	thread EnergyChargeWeapon_StopCharge_Think( weapon, chargeWeaponData )
}


void function EnergyChargeWeapon_StopCharge_Think( entity weapon, EnergyChargeWeaponData chargeWeaponData )
{
	weapon.EndSignal( "OnDestroy" )
	weapon.EndSignal( "EnergyWeapon_ChargeStart" )
	weapon.EndSignal( "EnergyWeapon_ChargeReleased" )

	while ( 1 )
	{
		WaitFrame()

		if ( EnergyChargeWeapon_GetChargeLevel( weapon ) <= 1 )
			break
	}

	EnergyChargeWeapon_StopCharge( weapon, chargeWeaponData )
}


void function FireHitscanShotgunBlast( entity weapon, vector pos, vector dir, int numBlasts, int damageType, float damageScaler = 1.0, float ornull maxAngle = null, float ornull maxDistance = null )
{
	Assert( numBlasts > 0 )
	int numBlastsOriginal = numBlasts

	/*




*/

	if ( maxDistance == null )
		maxDistance = weapon.GetMaxDamageFarDist()
	expect float( maxDistance )

	if ( maxAngle == null )
		maxAngle = weapon.GetAttackSpreadAngle() * 0.5
	expect float( maxAngle )

	entity owner                  = weapon.GetWeaponOwner()
	array<entity> ignoredEntities = [ owner ]
	int traceMask                 = TRACE_MASK_SHOT
	int visConeFlags              = VIS_CONE_ENTS_TEST_HITBOXES | VIS_CONE_ENTS_CHECK_SOLID_BODY_HIT | VIS_CONE_ENTS_APPOX_CLOSEST_HITBOX | VIS_CONE_RETURN_HIT_VORTEX

	entity antilagPlayer
	if ( owner.IsPlayer() )
	{
		if ( owner.IsPhaseShifted() )
			return

		antilagPlayer = owner
	}

	//
	Assert( maxAngle > 0.0, "JFS returning out at this instance. We need to investigate when a valid mp_titanweapon_laser_lite weapon returns 0 spread" )
	if ( maxAngle == 0.0 )
		return

	array<VisibleEntityInCone> results = FindVisibleEntitiesInCone( pos, dir, maxDistance, (maxAngle * 1.1), ignoredEntities, traceMask, visConeFlags, antilagPlayer, weapon )
	foreach ( result in results )
	{
		float angleToHitbox = 0.0
		if ( !result.solidBodyHit )
			angleToHitbox = DegreesToTarget( pos, dir, result.approxClosestHitboxPos )

		numBlasts -= HitscanShotgunBlastDamageEntity( weapon, pos, dir, result, angleToHitbox, maxAngle, numBlasts, damageType, damageScaler )
		if ( numBlasts <= 0 )
			break
	}

	//
	owner = weapon.GetWeaponOwner()
	if ( !IsValid( owner ) )
		return

	//
	const int MAX_TRACERS = 16
	bool didHitAnything   = ((numBlastsOriginal - numBlasts) != 0)
	bool doTraceBrushOnly = (!didHitAnything)
	if ( numBlasts > 0 )
	{
		WeaponFireBulletSpecialParams fireBulletParams
		fireBulletParams.pos = pos
		fireBulletParams.dir = dir
		fireBulletParams.bulletCount = minint( numBlasts, MAX_TRACERS )
		fireBulletParams.scriptDamageType = damageType
		fireBulletParams.skipAntiLag = false
		fireBulletParams.dontApplySpread = false
		fireBulletParams.doDryFire = true
		fireBulletParams.noImpact = false
		fireBulletParams.noTracer = false
		fireBulletParams.activeShot = false
		fireBulletParams.doTraceBrushOnly = doTraceBrushOnly
		weapon.FireWeaponBullet_Special( fireBulletParams )
	}
}


vector function ApplyVectorSpread( vector vecShotDirection, float spreadDegrees, float bias = 1.0 )
{
	vector angles   = VectorToAngles( vecShotDirection )
	vector vecUp    = AnglesToUp( angles )
	vector vecRight = AnglesToRight( angles )

	float sinDeg = deg_sin( spreadDegrees / 2.0 )

	//
	float x
	float y
	float z

	if ( bias > 1.0 )
		bias = 1.0
	else if ( bias < 0.0 )
		bias = 0.0

	//
	float shotBiasMin = -1.0
	float shotBiasMax = 1.0

	//
	float shotBias = ((shotBiasMax - shotBiasMin) * bias) + shotBiasMin
	float flatness = (fabs( shotBias ) * 0.5)

	while ( true )
	{
		x = RandomFloatRange( -1.0, 1.0 ) * flatness + RandomFloatRange( -1.0, 1.0 ) * (1 - flatness)
		y = RandomFloatRange( -1.0, 1.0 ) * flatness + RandomFloatRange( -1.0, 1.0 ) * (1 - flatness)
		if ( shotBias < 0 )
		{
			x = (x >= 0) ? 1.0 - x : -1.0 - x
			y = (y >= 0) ? 1.0 - y : -1.0 - y
		}
		z = x * x + y * y

		if ( z <= 1 )
			break
	}

	vector addX        = vecRight * (x * sinDeg)
	vector addY        = vecUp * (y * sinDeg)
	vector m_vecResult = vecShotDirection + addX + addY

	return m_vecResult
}


float function DegreesToTarget( vector origin, vector forward, vector targetPos )
{
	vector dirToTarget = targetPos - origin
	dirToTarget = Normalize( dirToTarget )
	float dot         = DotProduct( forward, dirToTarget )
	float degToTarget = (acos( dot ) * 180 / PI)

	return degToTarget
}


const SHOTGUN_ANGLE_MIN_FRACTION = 0.1
const SHOTGUN_ANGLE_MAX_FRACTION = 1.0
const SHOTGUN_DAMAGE_SCALE_AT_MIN_ANGLE = 0.8
const SHOTGUN_DAMAGE_SCALE_AT_MAX_ANGLE = 0.1

int function HitscanShotgunBlastDamageEntity( entity weapon, vector barrelPos, vector barrelVec, VisibleEntityInCone result, float angle, float maxAngle, int numPellets, int damageType, float damageScaler )
{
	entity target = result.ent

	//
	if ( !target.IsTitan() && damageScaler > 1 )
		damageScaler = max( damageScaler * 0.4, 1.5 )

	entity owner = weapon.GetWeaponOwner()
	//
	if ( !IsValid( target ) || !IsValid( owner ) )
		return 0

	//
	vector hitLocation = result.visiblePosition
	vector vecToEnt    = (hitLocation - barrelPos)
	vecToEnt.Norm()
	if ( Length( vecToEnt ) == 0 )
		vecToEnt = barrelVec

	//
	WeaponFireBulletSpecialParams fireBulletParams
	fireBulletParams.pos = barrelPos
	fireBulletParams.dir = vecToEnt
	fireBulletParams.bulletCount = 1
	fireBulletParams.scriptDamageType = damageType
	fireBulletParams.skipAntiLag = true
	fireBulletParams.dontApplySpread = true
	fireBulletParams.doDryFire = true
	fireBulletParams.noImpact = false
	fireBulletParams.noTracer = false
	fireBulletParams.activeShot = false
	fireBulletParams.doTraceBrushOnly = false
	weapon.FireWeaponBullet_Special( fireBulletParams ) //

	#if(false)
//


//





//




//



//
//

//

//

//






//






//
//
//
//
//
//
//
//
#endif //

	return 1
}


void function FireProjectileShotgunBlast( entity weapon, WeaponPrimaryAttackParams attackParams, bool playerFired, float outerSpread, float innerSpread, int numProjectiles )
{
	vector vecFwd   = attackParams.dir
	vector vecRight = AnglesToRight( VectorToAngles( attackParams.dir ) )

	array<vector> spreadVecs = GetProjectileShotgunBlastVectors( attackParams.pos, vecFwd, vecRight, outerSpread, innerSpread, numProjectiles )

	for ( int i = 0; i < spreadVecs.len(); i++ )
	{
		vector spreadVec = spreadVecs[i]
		attackParams.dir = spreadVec

		bool ignoreSpread = true  //
		bool deferred     = i > (spreadVecs.len() / 2)
		entity bolt       = FireBallisticRoundWithDrop( weapon, attackParams.pos, attackParams.dir, playerFired, ignoreSpread, i, deferred )
	}
}


array<vector> function GetProjectileShotgunBlastVectors( vector pos, vector forward, vector right, float outerSpread, float innerSpead, int numSegments )
{
	#if(false)



#endif

	int numRadialSegments = numSegments - 1

	float degPerSegment = 360.0 / numRadialSegments
	array<vector> randVecs

	//
	for ( int i = 0 ; i < numRadialSegments ; i++ )
	{
		vector randVec = VectorRotateAxis( forward, right, RandomFloatRange( innerSpead, outerSpread ) )
		randVec = VectorRotateAxis( randVec, forward, RandomFloatRange( degPerSegment * i, degPerSegment * (i + 1) ) )
		randVec.Norm()
		randVecs.append( randVec )

		#if(false)









#endif
	}

	//
	//
	//
	//
	//

	//
	randVecs.append( forward )

	#if(false)
















#endif

	return randVecs
}


float function ProjectileShotgun_GetOuterSpread( entity weapon )
{
	return weapon.GetAttackSpreadAngle()
}


float function ProjectileShotgun_GetInnerSpread( entity weapon )
{
	float innerSpread = 0

	var innerSpreadVar = expect float ornull( weapon.GetWeaponInfoFileKeyField( "shotgun_spread_radial_innerexclude" ) )
	if ( innerSpreadVar == null )
		innerSpread = ProjectileShotgun_GetOuterSpread( weapon ) * DEFAULT_SHOTGUN_SPREAD_INNEREXCLUDE_FRAC
	else
		innerSpread = expect float ( weapon.GetWeaponInfoFileKeyField( "shotgun_spread_radial_innerexclude" ) )

	return innerSpread
}


void function FireProjectileBlastPattern( entity weapon, WeaponPrimaryAttackParams attackParams, bool playerFired, array<vector> blastPattern, float patternScale = 1.0, bool ignoreSpread = true )
{
	if ( !IsValid( weapon ) )
		return

	int projectilesPerShot = weapon.GetProjectilesPerShot()
	int patternLength      = blastPattern.len()
	Assert( projectilesPerShot <= patternLength, "Not enough blast pattern points (" + patternLength + ") for " + projectilesPerShot + " projectiles per shot" )

	float defaultPatternScale = expect float( weapon.GetWeaponInfoFileKeyField( "projectile_blast_pattern_default_scale" ) )
	patternScale *= defaultPatternScale
	#if(false)

#endif

	array<vector> scaledBlastPattern = clone blastPattern

	if ( patternScale != 1.0 )
	{
		for ( int i = 0; i < scaledBlastPattern.len(); i++ )
		{
			scaledBlastPattern[i] *= patternScale
		}
	}

	float patternZeroDistance = expect float( weapon.GetWeaponInfoFileKeyField( "projectile_blast_pattern_zero_distance" ) )

	array<vector> spreadVecs = GetProjectileBlastPatternVectors( attackParams, scaledBlastPattern, patternZeroDistance )

	for ( int i = 0; i < projectilesPerShot; i++ )
	{
		vector spreadVec = spreadVecs[i]
		attackParams.dir = spreadVec

		bool deferred = i > (spreadVecs.len() / 2)
		entity bolt   = FireBallisticRoundWithDrop( weapon, attackParams.pos, attackParams.dir, playerFired, ignoreSpread, i, deferred )
	}
}


array<vector> function GetProjectileBlastPatternVectors( WeaponPrimaryAttackParams attackParams, array<vector> blastPattern, float patternZeroDistance )
{
	vector startPos            = attackParams.pos
	vector forward             = attackParams.dir
	vector right               = AnglesToRight( VectorToAngles( attackParams.dir ) )
	vector up                  = AnglesToUp( VectorToAngles( forward ) )
	vector patternCenterAtZero = startPos + (forward * patternZeroDistance)

	array<vector> patternVecs

	foreach ( offsetVec in blastPattern )
	{
		vector offsetPos = patternCenterAtZero + (right * offsetVec.x)
		offsetPos += (up * offsetVec.y)

		vector vecToTarget = Normalize( offsetPos - startPos )
		patternVecs.append( vecToTarget )

		#if(false)

#endif
	}

	return patternVecs
}


entity function FireBallisticRoundWithDrop( entity weapon, vector pos, vector dir, bool isPlayerFired, bool ignoreSpread, int projectileIndex, bool deferred )
{
	int boltSpeed   = int( weapon.GetWeaponSettingFloat( eWeaponVar.projectile_launch_speed ) )
	int damageFlags = weapon.GetWeaponDamageFlags()

	float boltGravity  = 0.0
	vector originalDir = dir
	if ( weapon.GetWeaponSettingBool( eWeaponVar.bolt_gravity_enabled ) )
	{
		var zeroDistance = weapon.GetWeaponSettingFloat( eWeaponVar.bolt_zero_distance )
		if ( zeroDistance == null )
			zeroDistance = 4096.0

		expect float( zeroDistance )

		boltGravity = weapon.GetWeaponSettingFloat( eWeaponVar.projectile_gravity_scale )
		float worldGravity = GetConVarFloat( "sv_gravity" ) * boltGravity
		float time         = zeroDistance / float( boltSpeed )

		if ( DEBUG_BULLET_DROP <= 1 )
			dir += (GetZVelocityForDistOverTime( zeroDistance, time, worldGravity ) / boltSpeed)
	}

	WeaponFireBoltParams fireBoltParams
	fireBoltParams.pos = pos
	fireBoltParams.dir = dir
	fireBoltParams.speed = 1
	fireBoltParams.scriptTouchDamageType = damageFlags
	fireBoltParams.scriptExplosionDamageType = damageFlags
	fireBoltParams.clientPredicted = isPlayerFired
	fireBoltParams.additionalRandomSeed = 0
	fireBoltParams.dontApplySpread = ignoreSpread
	fireBoltParams.projectileIndex = projectileIndex
	fireBoltParams.deferred = deferred
	entity bolt = weapon.FireWeaponBolt( fireBoltParams )

	if ( bolt != null )
	{
		bolt.proj.savedDir = originalDir
		bolt.proj.savedShotTime = Time()

		#if(false)


#endif
	}

#if(CLIENT)
	Chroma_FiredWeapon( weapon )
#endif

	return bolt
}


string function GetDistanceString( float distInches )
{
	float distFeet   = distInches / 12.0
	float distYards  = distInches / 36.0
	float distMeters = distInches / 39.3701

	return format( "%.2fm %.2fy %.2ff %.2fin", distMeters, distYards, distFeet, distInches )
}


vector function GetZVelocityForDistOverTime( float distance, float duration, float gravity )
{
	vector startPoint = <0, 0, 0>
	vector endPoint   = <distance, 0, 0>

	float vox = distance / duration
	float voz = 0.5 * gravity * duration * duration / duration
	return <0, 0, voz>

	//
	//
	//
	//
}


int function FireGenericBoltWithDrop( entity weapon, WeaponPrimaryAttackParams attackParams, bool isPlayerFired )
{
	#if(CLIENT)
		if ( !weapon.ShouldPredictProjectiles() )
			return 1
	#endif //

	weapon.EmitWeaponNpcSound( LOUD_WEAPON_AI_SOUND_RADIUS_MP, 0.2 )

	const float PROJ_SPEED_SCALE = 1
	const float PROJ_GRAVITY = 1
	int damageFlags = weapon.GetWeaponDamageFlags()
	WeaponFireBoltParams fireBoltParams
	fireBoltParams.pos = attackParams.pos
	fireBoltParams.dir = attackParams.dir
	fireBoltParams.speed = PROJ_SPEED_SCALE
	fireBoltParams.scriptTouchDamageType = damageFlags
	fireBoltParams.scriptExplosionDamageType = damageFlags
	fireBoltParams.clientPredicted = isPlayerFired
	fireBoltParams.additionalRandomSeed = 0
	entity bolt = weapon.FireWeaponBolt( fireBoltParams )
	if ( bolt != null )
	{
		bolt.kv.gravity = PROJ_GRAVITY
		bolt.kv.rendercolor = "0 0 0"
		bolt.kv.renderamt = 0
		bolt.kv.fadedist = 1
	}
#if(CLIENT)
	Chroma_FiredWeapon( weapon )
#endif


	return 1
}


var function OnWeaponPrimaryAttack_GenericBoltWithDrop_Player( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	return FireGenericBoltWithDrop( weapon, attackParams, true )
}


var function OnWeaponPrimaryAttack_EPG( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	WeaponFireMissileParams fireMissileParams
	fireMissileParams.pos = attackParams.pos
	fireMissileParams.dir = attackParams.dir
	fireMissileParams.speed = 1
	fireMissileParams.scriptTouchDamageType = damageTypes.largeCaliberExp
	fireMissileParams.scriptExplosionDamageType = damageTypes.largeCaliberExp
	fireMissileParams.doRandomVelocAndThinkVars = false
	fireMissileParams.clientPredicted = false
	entity missile = weapon.FireWeaponMissile( fireMissileParams )
	if ( missile )
	{
		EmitSoundOnEntity( missile, "Weapon_Sidwinder_Projectile" )
		missile.InitMissileForRandomDriftFromWeaponSettings( attackParams.pos, attackParams.dir )
	}

	return missile
}

#if(false)




#endif //


var function OnWeaponPrimaryAttack_GenericMissile_Player( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	weapon.EmitWeaponNpcSound( LOUD_WEAPON_AI_SOUND_RADIUS_MP, 0.2 )

	vector bulletVec = ApplyVectorSpread( attackParams.dir, weapon.GetAttackSpreadAngle() - 1.0 )
	attackParams.dir = bulletVec

	if ( IsServer() || weapon.ShouldPredictProjectiles() )
	{
		WeaponFireMissileParams fireMissileParams
		fireMissileParams.pos = attackParams.pos
		fireMissileParams.dir = attackParams.dir
		fireMissileParams.speed = 1.0
		fireMissileParams.scriptTouchDamageType = weapon.GetWeaponDamageFlags()
		fireMissileParams.scriptExplosionDamageType = weapon.GetWeaponDamageFlags()
		fireMissileParams.doRandomVelocAndThinkVars = false
		fireMissileParams.clientPredicted = true
		entity missile = weapon.FireWeaponMissile( fireMissileParams )
		if ( missile )
		{
			missile.InitMissileForRandomDriftFromWeaponSettings( attackParams.pos, attackParams.dir )
		}
	}
}

#if(false)


















#endif //

bool function PlantStickyEntityOnWorldThatBouncesOffWalls( entity ent, table collisionParams, float bounceDot, vector angleOffset = <0, 0, 0> )
{
	entity hitEnt = expect entity( collisionParams.hitEnt )
	if ( hitEnt && (hitEnt.IsWorld() || hitEnt.HasPusherAncestor()) )
	{
		float dot = expect vector( collisionParams.normal ).Dot( <0, 0, 1> )

		if ( dot < bounceDot )
		{
			#if(false)











#else
				return false
			#endif
		}

		return PlantStickyEntity( ent, collisionParams, angleOffset )
	}

	return false
}


bool function PlantStickyEntityThatBouncesOffWalls( entity ent, table collisionParams, float bounceDot, vector angleOffset = <0, 0, 0> )
{
	//
	float dot = expect vector( collisionParams.normal ).Dot( <0, 0, 1> )

	if ( dot < bounceDot )
		return false

	return PlantStickyEntity( ent, collisionParams, angleOffset )
}


bool function PlantStickyEntity( entity ent, table collisionParams, vector angleOffset = <0, 0, 0> )
{
	if ( !EntityShouldStick( ent, expect entity( collisionParams.hitEnt ) ) )
		return false

	//
	if ( collisionParams.hitEnt.IsProjectile() )
		return false

	//
	vector plantAngles   = AnglesCompose( VectorToAngles( collisionParams.normal ), angleOffset )
	vector plantPosition = expect vector( collisionParams.pos )

	vector up = AnglesToUp( ent.GetAngles() )
	vector normal = expect vector( collisionParams.normal )
	float dot = DotProduct( up, normal )

	vector fwd = AnglesToForward( ent.GetAngles() )

	if ( !LegalOrigin( plantPosition ) )
		return false

	#if(false)



#else
		ent.SetOrigin( plantPosition )
		ent.SetAngles( plantAngles )
	#endif
	ent.SetVelocity( <0, 0, 0> )

	//
	if ( !collisionParams.hitEnt.IsWorld() )
	{
		if ( !ent.IsMarkedForDeletion() && !collisionParams.hitEnt.IsMarkedForDeletion() )
		{
			if ( collisionParams.hitbox > 0 )
				ent.SetParentWithHitbox( collisionParams.hitEnt, collisionParams.hitbox, true )

			//
			else
				ent.SetParent( collisionParams.hitEnt )

			if ( collisionParams.hitEnt.IsPlayer() )
			{
				thread HandleDisappearingParent( ent, expect entity( collisionParams.hitEnt ) )
			}
		}
	}
	else
	{
		ent.SetVelocity( <0, 0, 0> )
		ent.StopPhysics()
	}
#if(CLIENT)
	if ( ent instanceof C_BaseGrenade )
#else
	if ( ent instanceof CBaseGrenade )
#endif
	ent.MarkAsAttached()

	ent.Signal( "Planted" )

	return true
}


bool function PlantStickyGrenade( entity ent, vector pos, vector normal, entity hitEnt, int hitbox, float depth = 0.0, bool allowBounce = true, bool allowEntityStick = true, bool onlyTitansAllowed = true )
{
	if ( IsFriendlyTeam( ent.GetTeam(), hitEnt.GetTeam() ) )
		return false

	if ( ent.IsMarkedForDeletion() || hitEnt.IsMarkedForDeletion() )
		return false

	vector plantAngles   = VectorToAngles( normal )
	vector plantPosition = pos + normal * -depth

	if ( !allowBounce )
		ent.SetVelocity( <0, 0, 0> )

	if ( !LegalOrigin( plantPosition ) )
		return false

	#if(false)



#else
		ent.SetOrigin( plantPosition )
		ent.SetAngles( plantAngles )
	#endif

	if ( !hitEnt.IsWorld() && !hitEnt.IsFuncBrush() && ((onlyTitansAllowed && !hitEnt.IsTitan()) || !allowEntityStick) )
		return false

	//
	if ( ent.IsMarkedForDeletion() )
		return false

	ent.SetVelocity( <0, 0, 0> )

	if ( hitEnt.IsWorld() )
	{
		ent.SetParent( hitEnt, "", true )
		ent.StopPhysics()
	}
	else
	{
		if ( hitbox > 0 )
			ent.SetParentWithHitbox( hitEnt, hitbox, true )
		else //
			ent.SetParent( hitEnt )

		if ( hitEnt.IsPlayer() )
		{
			thread HandleDisappearingParent( ent, hitEnt )
		}
	}

	#if(CLIENT)
		if ( ent instanceof C_BaseGrenade )
			ent.MarkAsAttached()
	#else
		if ( ent instanceof CBaseGrenade )
			ent.MarkAsAttached()
	#endif

	return true
}


bool function PlantSuperStickyGrenade( entity ent, vector pos, vector normal, entity hitEnt, int hitbox )
{
	if ( IsFriendlyTeam( ent.GetTeam(), hitEnt.GetTeam() ) )
		return false

	vector plantAngles   = VectorToAngles( normal )
	vector plantPosition = pos

	if ( !LegalOrigin( plantPosition ) )
		return false

	#if(false)


//

#else
		ent.SetOrigin( plantPosition )
		ent.SetAngles( plantAngles )
	#endif

	if ( !hitEnt.IsWorld() && !hitEnt.IsPlayer() && !hitEnt.IsNPC() )
		return false

	ent.SetVelocity( <0, 0, 0> )

	if ( hitEnt.IsWorld() )
	{
		ent.StopPhysics()
	}
	else
	{
		if ( !ent.IsMarkedForDeletion() && !hitEnt.IsMarkedForDeletion() )
		{
			if ( hitbox > 0 )
				ent.SetParentWithHitbox( hitEnt, hitbox, true )
			else //
				ent.SetParent( hitEnt )

			if ( hitEnt.IsPlayer() )
			{
				thread HandleDisappearingParent( ent, hitEnt )
			}
		}
	}

	#if(CLIENT)
		if ( ent instanceof C_BaseGrenade )
			ent.MarkAsAttached()
	#else
		if ( ent instanceof CBaseGrenade )
			ent.MarkAsAttached()
	#endif

	return true
}

#if(false)














#else
void function HandleDisappearingParent( entity ent, entity parentEnt )
{
	parentEnt.EndSignal( "OnDeath" )
	ent.EndSignal( "OnDestroy" )

	parentEnt.WaitSignal( "StartPhaseShift" )

	ent.ClearParent()
}
#endif

bool function EntityShouldStick( entity stickyEnt, entity hitent )
{
	if ( !EntityCanHaveStickyEnts( stickyEnt, hitent ) )
		return false

	if ( hitent == stickyEnt )
		return false

	if ( hitent == stickyEnt.GetParent() )
		return false

	return true
}


bool function EntityCanHaveStickyEnts( entity stickyEnt, entity ent )
{
	if ( !IsValid( ent ) )
		return false

	if ( ent.GetModelName() == $"" ) //
		return false

	var entClassname = ent.GetNetworkedClassName()
	if ( entClassname == null || !(string( entClassname ) in level.stickyClasses) && !ent.IsNPC() )
		return false

#if(CLIENT)
	if ( stickyEnt instanceof C_Projectile )
#else
	if ( stickyEnt instanceof CProjectile )
#endif
	{
		string weaponClassName = stickyEnt.ProjectileGetWeaponClassName()
		local stickPlayer      = GetWeaponInfoFileKeyField_Global( weaponClassName, "stick_pilot" )
		local stickTitan       = GetWeaponInfoFileKeyField_Global( weaponClassName, "stick_titan" )
		local stickNPC         = GetWeaponInfoFileKeyField_Global( weaponClassName, "stick_npc" )

		if ( ent.IsTitan() && stickTitan == 0 )
			return false
		else if ( ent.IsPlayer() && stickPlayer == 0 )
			return false
		else if ( ent.IsNPC() && stickNPC == 0 )
			return false
	}

	return true
}

#if(false)
//















//



















#endif //

void function ProximityCharge_PostFired_Init( entity proximityMine, entity player )
{
	#if(false)

#endif
}

void function ExplodePlantedGrenadeAfterDelay( entity grenade, float delay )
{
	grenade.EndSignal( "OnDeath" )
	grenade.EndSignal( "OnDestroy" )

	float endTime = Time() + delay

	while ( Time() < endTime )
	{
		EmitSoundOnEntity( grenade, DEFAULT_WARNING_SFX )
		wait 0.1
	}

	grenade.GrenadeExplode( grenade.GetForwardVector() )
}


void function Player_DetonateSatchels( entity player )
{
	player.Signal( "DetonateSatchels" )

	#if(false)











#endif
}

#if(false)






















#endif //

#if(DEV)
void function ShowExplosionRadiusOnExplode( entity ent )
{
	ent.WaitSignal( "OnDestroy" )

	float innerRadius = expect float( ent.GetWeaponInfoFileKeyField( "explosion_inner_radius" ) )
	float outerRadius = expect float( ent.GetWeaponInfoFileKeyField( "explosionradius" ) )

	vector org    = ent.GetOrigin()
	vector angles = <0, 0, 0>
	thread DebugDrawCircle( org, angles, innerRadius, 255, 255, 51, true, 3.0 )
	thread DebugDrawCircle( org, angles, outerRadius, 255, 255, 255, true, 3.0 )
}
#endif //

#if(false)
//






//

















































//








//




















//



















//






















//







//

















//





















//


























#endif //

bool function WeaponCanCrit( entity weapon )
{
	//
	if ( !weapon )
		return false

	return weapon.GetWeaponSettingBool( eWeaponVar.critical_hit )
}


#if(false)


//

















//














#endif //

vector function GetVectorFromPositionToCrosshair( entity player, vector startPos )
{
	Assert( IsValid( player ) )

	//
	vector traceStart        = player.EyePosition()
	vector traceEnd          = traceStart + (player.GetViewVector() * 20000)
	array<entity> ignoreEnts = [ player ]
	TraceResults traceResult = TraceLine( traceStart, traceEnd, ignoreEnts, TRACE_MASK_SHOT, TRACE_COLLISION_GROUP_NONE )

	//
	vector vec = traceResult.endPos - startPos
	vec = Normalize( vec )
	return vec
}

/*






*/

void function InitMissileForRandomDriftForVortexHigh( entity missile, vector startPos, vector startDir )
{
	missile.InitMissileForRandomDrift( startPos, startDir, 8, 2.5, 0, 0, 100, 100, 0 )
}


void function InitMissileForRandomDriftForVortexLow( entity missile, vector startPos, vector startDir )
{
	missile.InitMissileForRandomDrift( startPos, startDir, 0.3, 0.085, 0, 0, 0.5, 0.5, 0 )
}

/*




















































































































*/

#if(false)




















































//

















//
//
//
//



//


















//
//
//

//

















//
//






















































































//


















#endif //

vector function GetVelocityForDestOverTime( vector startPoint, vector endPoint, float duration )
{
	const GRAVITY = 750

	float vox = (endPoint.x - startPoint.x) / duration
	float voy = (endPoint.y - startPoint.y) / duration
	float voz = (endPoint.z + 0.5 * GRAVITY * duration * duration - startPoint.z) / duration

	return <vox, voy, voz>
}


vector function GetPlayerVelocityForDestOverTime( vector startPoint, vector endPoint, float duration )
{
	//

	float gravityScale = GetGlobalSettingsFloat( DEFAULT_PILOT_SETTINGS, "gravityScale" )
	float GRAVITY      = 750 * gravityScale //

	float vox = (endPoint.x - startPoint.x) / duration
	float voy = (endPoint.y - startPoint.y) / duration
	float voz = (endPoint.z + 0.5 * GRAVITY * duration * duration - startPoint.z) / duration

	return <vox, voy, voz>
}


bool function HasLockedTarget( entity weapon )
{
	if ( weapon.SmartAmmo_IsEnabled() )
	{
		array< SmartAmmoTarget > targets = weapon.SmartAmmo_GetTargets()
		if ( targets.len() > 0 )
		{
			foreach ( target in targets )
			{
				if ( target.fraction == 1 )
					return true
			}
		}
	}
	return false
}


bool function CanWeaponShootWhileRunning( entity weapon )
{
	if ( "primary_fire_does_not_block_sprint" in weapon.s )
		return expect bool( weapon.s.primary_fire_does_not_block_sprint )

	if ( weapon.GetWeaponSettingBool( eWeaponVar.primary_fire_does_not_block_sprint ) )
	{
		weapon.s.primary_fire_does_not_block_sprint <- true
		return true
	}

	weapon.s.primary_fire_does_not_block_sprint <- false
	return false
}

#if(CLIENT)

bool function IsOwnerViewPlayerFullyADSed( entity weapon )
{
	entity owner = weapon.GetOwner()
	if ( !IsValid( owner ) )
		return false

	if ( !owner.IsPlayer() )
		return false

	if ( owner != GetLocalViewPlayer() )
		return false

	float zoomFrac = owner.GetZoomFrac()
	if ( zoomFrac < 1.0 )
		return false

	return true
}
#endif //

array<entity> function FireExpandContractMissiles( entity weapon, WeaponPrimaryAttackParams attackParams, vector attackPos, vector attackDir, int damageType, int explosionDamageType, bool shouldPredict, int rocketsPerShot, missileSpeed, launchOutAng, launchOutTime, launchInAng, launchInTime, launchInLerpTime, launchStraightLerpTime, applyRandSpread, int burstFireCountOverride = -1, debugDrawPath = false )
{
	array<table> missileVecs = GetExpandContractRocketTrajectories( weapon, attackParams.burstIndex, attackPos, attackDir, rocketsPerShot, launchOutAng, launchInAng, burstFireCountOverride )
	entity owner             = weapon.GetWeaponOwner()
	array<entity> firedMissiles

	vector missileEndPos = owner.EyePosition() + (attackDir * 5000)

	for ( int i = 0; i < rocketsPerShot; i++ )
	{
		WeaponFireMissileParams fireMissileParams
		fireMissileParams.pos = attackPos
		fireMissileParams.dir = attackDir
		fireMissileParams.speed = expect float( missileSpeed )
		fireMissileParams.scriptTouchDamageType = damageType
		fireMissileParams.scriptExplosionDamageType = explosionDamageType
		fireMissileParams.doRandomVelocAndThinkVars = false
		fireMissileParams.clientPredicted = shouldPredict
		entity missile = weapon.FireWeaponMissile( fireMissileParams )

		if ( missile )
		{
			/*










*/

			missile.InitMissileExpandContract( missileVecs[i].outward, missileVecs[i].inward, launchOutTime, launchInLerpTime, launchInTime, launchStraightLerpTime, missileEndPos, applyRandSpread )

			if ( IsServer() && debugDrawPath )
				thread DebugDrawMissilePath( missile )

			//
			missile.InitMissileForRandomDriftFromWeaponSettings( attackPos, attackDir )

			firedMissiles.append( missile )
		}
	}

	return firedMissiles
}


array<entity> function FireExpandContractMissiles_S2S( entity weapon, WeaponPrimaryAttackParams attackParams, vector attackPos, vector attackDir, bool shouldPredict, int rocketsPerShot, missileSpeed, launchOutAng, launchOutTime, launchInAng, launchInTime, launchInLerpTime, launchStraightLerpTime, applyRandSpread, int burstFireCountOverride = -1, debugDrawPath = false )
{
	array<table> missileVecs = GetExpandContractRocketTrajectories( weapon, attackParams.burstIndex, attackPos, attackDir, rocketsPerShot, launchOutAng, launchInAng, burstFireCountOverride )
	entity owner             = weapon.GetWeaponOwner()
	array<entity> firedMissiles

	vector missileEndPos = attackPos + (attackDir * 5000)

	for ( int i = 0; i < rocketsPerShot; i++ )
	{
		WeaponFireMissileParams fireMissileParams
		fireMissileParams.pos = attackPos
		fireMissileParams.dir = attackDir
		fireMissileParams.speed = expect float( missileSpeed )
		fireMissileParams.scriptTouchDamageType = DF_GIB | DF_IMPACT
		fireMissileParams.scriptExplosionDamageType = damageTypes.explosive
		fireMissileParams.doRandomVelocAndThinkVars = false
		fireMissileParams.clientPredicted = shouldPredict
		entity missile = weapon.FireWeaponMissile( fireMissileParams )
		missile.SetOrigin( attackPos )//
		if ( missile )
		{
			/*










*/

			missile.InitMissileExpandContract( missileVecs[i].outward, missileVecs[i].inward, launchOutTime, launchInLerpTime, launchInTime, launchStraightLerpTime, missileEndPos, applyRandSpread )

			if ( IsServer() && debugDrawPath )
				thread DebugDrawMissilePath( missile )

			//
			missile.InitMissileForRandomDriftFromWeaponSettings( attackPos, attackDir )

			firedMissiles.append( missile )
		}
	}

	return firedMissiles
}


array<table> function GetExpandContractRocketTrajectories( entity weapon, int burstIndex, vector attackPos, vector attackDir, int rocketsPerShot, launchOutAng, launchInAng, int burstFireCount = -1 )
{
	bool DEBUG_DRAW_MATH = false

	if ( burstFireCount == -1 )
		burstFireCount = weapon.GetWeaponBurstFireCount()

	float additionalRotation = ((360.0 / rocketsPerShot) / burstFireCount) * burstIndex
	//
	//
	//

	vector ang     = VectorToAngles( attackDir )
	vector forward = AnglesToForward( ang )
	vector right   = AnglesToRight( ang )
	vector up      = AnglesToUp( ang )

	if ( DEBUG_DRAW_MATH )
		DebugDrawLine( attackPos, attackPos + (forward * 1000), 255, 0, 0, true, 30.0 )

	//
	float offsetAng = 360.0 / rocketsPerShot
	for ( int i = 0; i < rocketsPerShot; i++ )
	{
		float a    = offsetAng * i + additionalRotation
		vector vec = <0, 0, 0>
		vec += up * deg_sin( a )
		vec += right * deg_cos( a )

		if ( DEBUG_DRAW_MATH )
			DebugDrawLine( attackPos, attackPos + (vec * 50), 10, 10, 10, true, 30.0 )
	}

	//
	vector x  = right * deg_sin( launchOutAng )
	vector y  = up * deg_sin( launchOutAng )
	vector z  = forward * deg_cos( launchOutAng )
	vector rx = right * deg_sin( launchInAng )
	vector ry = up * deg_sin( launchInAng )
	vector rz = forward * deg_cos( launchInAng )
	array<table> missilePoints
	for ( int i = 0; i < rocketsPerShot; i++ )
	{
		table points

		//
		float a       = offsetAng * i + additionalRotation
		float s       = deg_sin( a )
		float c       = deg_cos( a )
		vector vecOut = z + x * c + y * s
		vecOut = Normalize( vecOut )
		points.outward <- vecOut

		//
		vector vecIn = rz + rx * c + ry * s
		points.inward <- vecIn

		//
		missilePoints.append( points )

		if ( DEBUG_DRAW_MATH )
		{
			DebugDrawLine( attackPos, attackPos + (vecOut * 50), 255, 255, 0, true, 30.0 )
			DebugDrawLine( attackPos + vecOut * 50, attackPos + vecOut * 50 + (vecIn * 50), 255, 0, 255, true, 30.0 )
		}
	}

	return missilePoints
}


void function DebugDrawMissilePath( entity missile )
{
	EndSignal( missile, "OnDestroy" )
	vector lastPos = missile.GetOrigin()
	while ( true )
	{
		WaitFrame()
		if ( !IsValid( missile ) )
			return
		DebugDrawLine( lastPos, missile.GetOrigin(), 0, 255, 0, true, 20.0 )
		lastPos = missile.GetOrigin()
	}
}


bool function IsPilotShotgunWeapon( string weaponName )
{
	if ( IsWeaponKeyFieldDefined( weaponName, "weaponSubClass" ) && GetWeaponInfoFileKeyField_GlobalString( weaponName, "weaponSubClass" ) == "shotgun" )
		return true

	return false
}


array<string> function GetWeaponBurnMods( string weaponClassName )
{
	array<string> burnMods = []
	array<string> mods     = GetWeaponMods_Global( weaponClassName )
	string prefix          = "burn_mod"
	foreach ( mod in mods )
	{
		if ( mod.find( prefix ) == 0 )
			burnMods.append( mod )
	}

	return burnMods
}


int function TEMP_GetDamageFlagsFromProjectile( entity projectile )
{
	var damageFlagsString = projectile.ProjectileGetWeaponInfoFileKeyField( "damage_flags" )
	if ( damageFlagsString == null )
		return 0
	expect string( damageFlagsString )

	return TEMP_GetDamageFlagsFromString( damageFlagsString )
}


int function TEMP_GetDamageFlagsFromString( string damageFlagsString )
{
	int damageFlags = 0

	array<string> damageFlagTokens = split( damageFlagsString, "|" )
	foreach ( token in damageFlagTokens )
	{
		damageFlags = damageFlags | getconsttable()[strip( token )]
	}

	return damageFlags
}

#if(false)


//



















































































































































#endif //

bool function PROTO_CanPlayerDeployWeapon( entity player )
{
	if ( player.IsPhaseShifted() )
		return false

	if ( player.ContextAction_IsActive() == true )
	{
		if ( player.IsZiplining() )
			return true
		else
			return false
	}

	return true
}

#if(false)





























































#endif //

void function GiveEMPStunStatusEffects( entity ent, float duration, float fadeoutDuration = 0.5, float slowTurn = EMP_SEVERITY_SLOWTURN, float slowMove = EMP_SEVERITY_SLOWMOVE )
{
	entity target = ent
	int slowEffect = StatusEffect_AddTimed( target, eStatusEffect.turn_slow, slowTurn, duration, fadeoutDuration )
	int turnEffect = StatusEffect_AddTimed( target, eStatusEffect.move_slow, slowMove, duration, fadeoutDuration )

	#if(false)





#endif
}

#if(DEV)
string ornull function FindEnumNameForValue( table searchTable, int searchVal )
{
	foreach ( string keyname, int value in searchTable )
	{
		if ( value == searchVal )
			return keyname
	}
	return null
}

void function DevPrintAllStatusEffectsOnEnt( entity ent )
{
	printt( "Effects:", ent )
	array<float> effects = StatusEffect_GetAllSeverity( ent )
	int length           = effects.len()
	int found            = 0
	for ( int idx = 0; idx < length; idx++ )
	{
		float severity = effects[idx]
		if ( severity <= 0.0 )
			continue
		string ornull name = FindEnumNameForValue( eStatusEffect, idx )
		Assert( name )
		expect string( name )
		printt( " eStatusEffect." + name + ": " + severity )
		found++
	}
	printt( found + " effects active.\n" )
}
#endif //

entity function GetMeleeWeapon( entity player )
{
	array<entity> weapons = player.GetMainWeapons()
	foreach ( weaponEnt in weapons )
	{
		if ( weaponEnt.IsWeaponMelee() )
			return weaponEnt
	}

	return null
}


array<entity> function GetPrimaryWeapons( entity player )
{
	array<entity> primaryWeapons
	array<entity> weapons = player.GetMainWeapons()
	foreach ( weaponEnt in weapons )
	{
		int weaponType = weaponEnt.GetWeaponType()
		if ( weaponType == WT_SIDEARM || weaponType == WT_ANTITITAN )
			continue

		primaryWeapons.append( weaponEnt )
	}
	return primaryWeapons
}


array<entity> function GetSidearmWeapons( entity player )
{
	array<entity> sidearmWeapons
	array<entity> weapons = player.GetMainWeapons()
	foreach ( weaponEnt in weapons )
	{
		if ( weaponEnt.GetWeaponType() != WT_SIDEARM )
			continue

		sidearmWeapons.append( weaponEnt )
	}
	return sidearmWeapons
}


array<entity> function GetATWeapons( entity player )
{
	array<entity> atWeapons
	array<entity> weapons = player.GetMainWeapons()
	foreach ( weaponEnt in weapons )
	{
		if ( weaponEnt.GetWeaponType() != WT_ANTITITAN )
			continue

		atWeapons.append( weaponEnt )
	}
	return atWeapons
}


entity function GetPlayerFromTitanWeapon( entity weapon )
{
	entity titan = weapon.GetWeaponOwner()
	entity player

	if ( titan == null )
		return null

	if ( !titan.IsPlayer() )
		player = titan.GetBossPlayer()
	else
		player = titan

	return player
}

#if(false)







//
//


//
//

















//






//
//
//
//













//




//
























































//
//














































































































































































//










//







//







//
























//

































































//




















































































//


























//




//
//











//









//
//
//


















//
//
//




//
/*








*/





//











//







//
//

















//
//
//
























//
//
//



































































































//
//
//
//
//
//
//
//
//
//
//
//
//
//




























//





//









//
//

//
















//










//






































































































//






























//










//
//
//
//

































































//
//
//










//
//









































//

//






























































#endif //


#if(CLIENT)
void function ServerCallback_SatchelPlanted()
{
	entity player = GetLocalViewPlayer()
	thread SatchelDetonationHint( player )
}

void function SatchelDetonationHint( entity player )
{
	player.EndSignal( "OnDeath" )
	player.EndSignal( "DetonateSatchels" )

	OnThreadEnd(
		function() : ( player )
		{
			if ( IsValid( player ) )
				SatchelDetonationHint_Destroy( player )
		}
	)

	string satchelClassName = "mp_weapon_satchel"

	if ( SHOW_SATCHEL_DETONATION_HINT_WITH_CLACKER )
		SatchelDetonationHint_Show( player )

	while ( PlayerHasWeapon( player, satchelClassName ) )
	{
		wait 0.1

		if ( !SHOW_SATCHEL_DETONATION_HINT_WITH_CLACKER )
		{
			//
			if ( player.GetActiveWeapon( OFFHAND_ORDNANCE ).GetWeaponClassName() != satchelClassName )
			{
				SatchelDetonationHint_Show( player )
			}
			else
			{
				SatchelDetonationHint_Destroy( player )
			}
		}
	}
}

void function SatchelDetonationHint_Show( entity player )
{
	if ( file.satchelHintRUI != null )
		return

	SatchelDetonationHint_Destroy( player )

	int sorting = 0
	file.satchelHintRUI = RuiCreate( $"ui/satchel_detonation_hint.rpak", clGlobal.topoFullScreen, RUI_DRAW_HUD, sorting )
}

void function SatchelDetonationHint_Destroy( entity player )
{
	if ( file.satchelHintRUI != null )
		RuiDestroyIfAlive( file.satchelHintRUI )

	file.satchelHintRUI = null
}
#endif //


void function PlayerUsedOffhand( entity player, entity offhandWeapon, bool sendPINEvent = true, entity trackedProjectile = null, table pinAdditionalData = {} )
{
	#if(false)






















//












#endif //

	#if(CLIENT)
		if ( offhandWeapon == player.GetOffhandWeapon( OFFHAND_ULTIMATE ) )
			UltimateWeaponStateSet( eUltimateState.ACTIVE )
		Chroma_PlayerUsedAbility( player, offhandWeapon )
	#endif //
}


RadiusDamageData function GetRadiusDamageDataFromProjectile( entity projectile, entity owner )
{
	RadiusDamageData radiusDamageData

	radiusDamageData.explosionDamage = -1
	radiusDamageData.explosionDamageHeavyArmor = -1

	if ( owner.IsNPC() )
	{
		radiusDamageData.explosionDamage = projectile.GetProjectileWeaponSettingInt( eWeaponVar.npc_explosion_damage )
		radiusDamageData.explosionDamageHeavyArmor = projectile.GetProjectileWeaponSettingInt( eWeaponVar.npc_explosion_damage_heavy_armor )
	}

	if ( radiusDamageData.explosionDamage == -1 )
		radiusDamageData.explosionDamage = projectile.GetProjectileWeaponSettingInt( eWeaponVar.explosion_damage )

	if ( radiusDamageData.explosionDamageHeavyArmor == -1 )
		radiusDamageData.explosionDamageHeavyArmor = projectile.GetProjectileWeaponSettingInt( eWeaponVar.explosion_damage_heavy_armor )

	radiusDamageData.explosionRadius = projectile.GetProjectileWeaponSettingFloat( eWeaponVar.explosionradius )
	radiusDamageData.explosionInnerRadius = projectile.GetProjectileWeaponSettingFloat( eWeaponVar.explosion_inner_radius )

	Assert( radiusDamageData.explosionRadius > 0, "Created RadiusDamageData with 0 radius" )
	Assert( radiusDamageData.explosionDamage > 0 || radiusDamageData.explosionDamageHeavyArmor > 0, "Created RadiusDamageData with 0 damage" )
	return radiusDamageData
}


void function AddCallback_OnPlayerAddWeaponMod( void functionref( entity, entity, string ) callbackFunc )
{
	file.playerAddWeaponModCallbacks.append( callbackFunc )
}


void function AddCallback_OnPlayerRemoveWeaponMod( void functionref( entity, entity, string ) callbackFunc )
{
	file.playerRemoveWeaponModCallbacks.append( callbackFunc )
}


void function CodeCallback_OnPlayerAddedWeaponMod( entity player, entity weapon, string mod )
{
	if ( !IsValid( player ) )
		return

	foreach ( callback in file.playerAddWeaponModCallbacks )
	{
		callback( player, weapon, mod )
	}

	//

	#if(false)


#endif
}


void function CodeCallback_OnPlayerRemovedWeaponMod( entity player, entity weapon, string mod )
{
	if ( !IsValid( player ) )
		return

	foreach ( callback in file.playerRemoveWeaponModCallbacks )
	{
		callback( player, weapon, mod )
	}

	//

	#if(false)


#endif
}


#if(false)

































































































































//


//
//
















//
//



























//
































//












//













































































//


//































//





//















































































//


#endif //

int function GetMaxTrackerCountForTitan( entity titan )
{
	array<entity> primaryWeapons = titan.GetMainWeapons()
	if ( primaryWeapons.len() > 0 && IsValid( primaryWeapons[0] ) )
	{
		if ( primaryWeapons[0].HasMod( "pas_lotech_helper" ) )
			return 4
	}

	return 3
}


bool function DoesModExist( entity weapon, string modName )
{
	array<string> mods = GetWeaponMods_Global( weapon.GetWeaponClassName() )
	return mods.contains( modName )
}


bool function DoesModExistFromWeaponClassName( string weaponName, string modName )
{
	array<string> mods = GetWeaponMods_Global( weaponName )
	return mods.contains( modName )
}


bool function IsModActive( entity weapon, string modName )
{
	array<string> activeMods = weapon.GetMods()
	return activeMods.contains( modName )
}


bool function IsWeaponInSingleShotMode( entity weapon )
{
	if ( weapon.GetWeaponSettingBool( eWeaponVar.attack_button_presses_melee ) )
		return false

	if ( weapon.GetWeaponSettingEnum( eWeaponVar.fire_mode, eWeaponFireMode ) != eWeaponFireMode.semiauto )
		return false

	return weapon.GetWeaponSettingInt( eWeaponVar.burst_fire_count ) == 0
}


bool function IsWeaponInBurstMode( entity weapon )
{
	return weapon.GetWeaponSettingInt( eWeaponVar.burst_fire_count ) > 1
}


bool function IsWeaponOffhand( entity weapon )
{
	switch( weapon.GetWeaponSettingEnum( eWeaponVar.fire_mode, eWeaponFireMode ) )
	{
		case eWeaponFireMode.offhand:
		case eWeaponFireMode.offhandInstant:
		case eWeaponFireMode.offhandHybrid:
			return true
	}
	return false
}


bool function IsWeaponInAutomaticMode( entity weapon )
{
	return weapon.GetWeaponSettingEnum( eWeaponVar.fire_mode, eWeaponFireMode ) == eWeaponFireMode.automatic
}


bool function OnWeaponAttemptOffhandSwitch_Never( entity weapon )
{
	return false
}


#if(CLIENT)
void function ServerCallback_SetWeaponPreviewState( bool newState )
{
	#if(DEV)
		entity player = GetLocalClientPlayer()

		if ( newState )
		{
			printt( "Weapon Skin Preview Enabled" )
			player.ClientCommand( "bind LEFT \"WeaponPreviewPrevSkin\"" )
			player.ClientCommand( "bind RIGHT \"WeaponPreviewNextSkin\"" )
			player.ClientCommand( "bind UP \"WeaponPreviewNextCamo\"" )
			player.ClientCommand( "bind DOWN \"WeaponPreviewPrevCamo\"" )

			player.ClientCommand( "bind_held LEFT weapon_inspect" )
		}
		else
		{
			player.ClientCommand( "bind LEFT \"+ability 12\"" )
			player.ClientCommand( "bind RIGHT \"+ability 13\"" )
			player.ClientCommand( "bind UP \"+ability 10\"" )
			player.ClientCommand( "bind DOWN \"+ability 11\"" )

			SetStandardAbilityBindingsForPilot( player )
			printt( "Weapon Skin Preview Disabled" )
		}
	#endif
}
#endif

void function OnWeaponReadyToFire_ability_tactical( entity weapon )
{
	#if(false)

#endif
}

void function OnWeaponRegenEndGeneric( entity weapon )
{
	#if(false)



#endif
	#if(CLIENT)
		entity owner = weapon.GetWeaponOwner()
		if ( !IsValid( owner ) || !owner.IsPlayer() )
			return
		if ( owner.GetOffhandWeapon( OFFHAND_ULTIMATE ) == weapon )
			Chroma_UltimateReady()
	#endif
}

void function Ultimate_OnWeaponRegenBegin( entity weapon )
{
	#if(CLIENT)
		UltimateWeaponStateSet( eUltimateState.CHARGING )
	#endif
}

#if(false)














#endif