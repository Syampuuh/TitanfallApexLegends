global function MpWeaponDeployableMedic_Init

global function OnWeaponTossReleaseAnimEvent_weapon_deployable_medic
global function OnWeaponAttemptOffhandSwitch_weapon_deployable_medic
global function OnWeaponTossPrep_weapon_deployable_medic

#if(CLIENT)
global function CanDeployHealDrone
#endif

const asset DEPLOYABLE_MEDIC_DRONE_MODEL = $"mdl/props/lifeline_drone/lifeline_drone.rmdl"

//
const float DEPLOYABLE_MEDIC_THROW_POWER = 25.0
const float DEPLOYABLE_MEDIC_ICON_HEIGHT = 32.0

//
const int DEPLOYABLE_MEDIC_HEAL_MAX_TARGETS = 3
const float DEPLOYABLE_MEDIC_HEAL_START_DELAY = 1.0
const float DEPLOYABLE_MEDIC_HEAL_RADIUS = 128.0
const int DEPLOYABLE_MEDIC_HEAL_AMOUNT = 150
const float DEPLOYABLE_MEDIC_MAX_LIFETIME = 20
//
const float DEPLOYABLE_MEDIC_HEAL_PER_SEC = 5

const ROPE_LENGTH = DEPLOYABLE_MEDIC_HEAL_RADIUS + 50
const ROPE_NODE_COUNT = 10
const ROPE_SHOOT_OUT_TIME = 0.25
const ROPE_REAL_IN_TIME = 0.25

const int DEPLOYABLE_MEDIC_RESOURCE_FULL_SKIN_INDEX = 0
const int DEPLOYABLE_MEDIC_RESOURCE_HALF_SKIN_INDEX = 2
const int DEPLOYABLE_MEDIC_RESOURCE_LOW_SKIN_INDEX = 1

global const string DEPLOYABLE_MEDIC_HOVER_SOUND = "Lifeline_Drone_Mvmt_Hover"
const string DEPLOYABLE_MEDIC_DEPLOY_CABLE_SOUND = "Lifeline_Drone_Cable_Deploy_3P"
const string DEPLOYABLE_MEDIC_ATTACH_SOUND_1P = "Lifeline_Drone_Attach_1P"
const string DEPLOYABLE_MEDIC_ATTACH_SOUND_3P = "Lifeline_Drone_Attach_3P"
const string DEPLOYABLE_MEDIC_DETATCH_SOUND_1P = "Lifeline_Drone_Detach_1P"
const string DEPLOYABLE_MEDIC_DETATCH_SOUND_3P = "Lifeline_Drone_Detach_3P"
const string DEPLOYABLE_MEDIC_HEAL_LOOP_SOUND_1P = "Lifeline_Drone_Healing_1P" //
const string DEPLOYABLE_MEDIC_HEAL_LOOP_SOUND_3P = "Lifeline_Drone_Healing_3P" //
global const string DEPLOYABLE_MEDIC_DISSOLVE_SOUND = "Lifeline_Drone_Dissolve"
global const string DEPLOYABLE_MEDIC_DEPLOY_SOUND = ""

const vector DRONE_MINS = <-9, -9, -10>
const vector DRONE_MAXS = <9, 9, 10>

const FX_DRONE_MEDIC_OPEN = $"P_LL_med_drone_open"
const FX_DRONE_MEDIC_JET_CTR = $"P_LL_med_drone_jet_ctr_loop"
const FX_DRONE_MEDIC_EYE = $"P_LL_med_drone_eye"
const FX_DRONE_MEDIC_JET_LOOP = $"P_LL_med_drone_jet_loop"

const FX_DRONE_MEDIC_HEAL_COCKPIT_FX = $"P_heal_loop_screen"

struct HealRopeData
{
	entity ropeStartEnt
	entity playerRope
	entity playerRopeEndEnt
	entity otherRope
	entity otherRopeEndEnt
	int    statusEffectHandle
}

struct HealData
{
	entity healTarget
	int    healResourceID
}

struct SignalStruct
{
	entity trigger
	entity player
}

struct HealDeployableData
{
	int                 healResource = DEPLOYABLE_MEDIC_HEAL_AMOUNT
	array<entity>       healTargets = []
	array<HealData>     healDataArray = []
	array<entity>       particles = []
}

struct
{
	#if(false)


#else
		int healFxHandle
	#endif
} file

void function MpWeaponDeployableMedic_Init()
{
	RegisterSignal( "DeployableMedic_HealDepleated" )
	RegisterSignal( "DeployableMedic_HealAborted" )
	RegisterSignal( "DeployableMedic_Attached" )
	RegisterSignal( "DeployableMedic_LeftHealingTrigger" )
	RegisterSignal( "CleanupAllDroneMedics" )

	PrecacheModel( DEPLOYABLE_MEDIC_DRONE_MODEL )
	PrecacheMaterial( $"models/cable/drone_medic_cable" )

	PrecacheParticleSystem( FX_DRONE_MEDIC_OPEN )
	PrecacheParticleSystem( FX_DRONE_MEDIC_JET_CTR )
	PrecacheParticleSystem( FX_DRONE_MEDIC_EYE )
	PrecacheParticleSystem( FX_DRONE_MEDIC_JET_LOOP )

	PrecacheParticleSystem( FX_DRONE_MEDIC_HEAL_COCKPIT_FX )

	#if(false)

#endif

	#if(CLIENT)
		AddCreateCallback( "script_mover", DeployableMedic_OnPropScriptCreated )

		StatusEffect_RegisterEnabledCallback( eStatusEffect.drone_healing, DeployableMedic_HealVisualsEnabled )
		StatusEffect_RegisterDisabledCallback( eStatusEffect.drone_healing, DeployableMedic_HealVisualsDisabled )
	#endif
}


bool function OnWeaponAttemptOffhandSwitch_weapon_deployable_medic( entity weapon )
{
	int ammoReq  = weapon.GetAmmoPerShot()
	int currAmmo = weapon.GetWeaponPrimaryClipCount()
	if ( currAmmo < ammoReq )
		return false

	entity player = weapon.GetWeaponOwner()
	if ( player.IsPhaseShifted() )
		return false

	return true
}


var function OnWeaponTossReleaseAnimEvent_weapon_deployable_medic( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	int ammoReq = weapon.GetAmmoPerShot()
	weapon.EmitWeaponSound_1p3p( GetGrenadeThrowSound_1p( weapon ), GetGrenadeThrowSound_3p( weapon ) )

	entity deployable = ReleaseDrone( weapon, attackParams, DEPLOYABLE_MEDIC_THROW_POWER, OnDeployableMedicPlanted )
	if ( deployable )
	{
		entity player = weapon.GetWeaponOwner()
		PlayerUsedOffhand( player, weapon )

		#if(false)








#endif
	}

	return ammoReq
}


entity function ReleaseDrone( entity weapon, WeaponPrimaryAttackParams attackParams, float throwPower, void functionref(entity) deployFunc, vector ornull angularVelocity = null )
{
	#if(CLIENT)
		if ( !weapon.ShouldPredictProjectiles() )
			return null
	#endif

	entity player = weapon.GetWeaponOwner()

	vector attackPos
	if ( IsValid( player ) )
		attackPos = GetDroneThrowStartPos( player, attackParams.pos )
	else
		attackPos = attackParams.pos

	vector angles   = VectorToAngles( attackParams.dir )
	vector velocity = GetDroneThrowVelocity( player, angles, throwPower )
	if ( angularVelocity == null )
		angularVelocity = <600, RandomFloatRange( -300, 300 ), 0>
	expect vector( angularVelocity )

	float fuseTime = 0.0    //

	bool isPredicted = PROJECTILE_PREDICTED
	if ( player.IsNPC() )
		isPredicted = PROJECTILE_NOT_PREDICTED

	WeaponFireGrenadeParams fireGrenadeParams
	fireGrenadeParams.pos = attackPos
	fireGrenadeParams.vel = velocity
	fireGrenadeParams.angVel = angularVelocity
	fireGrenadeParams.fuseTime = fuseTime
	fireGrenadeParams.scriptTouchDamageType = damageTypes.explosive
	fireGrenadeParams.scriptExplosionDamageType = damageTypes.explosive
	fireGrenadeParams.clientPredicted = isPredicted
	fireGrenadeParams.lagCompensated = true
	fireGrenadeParams.useScriptOnDamage = true
	entity deployable = weapon.FireWeaponGrenade( fireGrenadeParams )

	if ( deployable )
	{
		deployable.SetAngles( <0, angles.y - 180, 0> )
		#if(false)

#endif
	}

	return deployable
}


vector function GetDroneThrowStartPos( entity player, vector baseStartPos )
{
	//
	vector attackPos = player.OffsetPositionFromView( baseStartPos, <20, 0, 2.5> )    //
	return attackPos
}


vector function GetDroneThrowVelocity( entity player, vector baseAngles, float throwPower )
{
	baseAngles += <-8, 0, 0>
	vector forward = AnglesToForward( baseAngles )

	if ( baseAngles.x < 80 )
		throwPower = GraphCapped( baseAngles.x, 0, 80, throwPower, throwPower * 3 )

	vector velocity = forward * throwPower

	return velocity
}


void function OnWeaponTossPrep_weapon_deployable_medic( entity weapon, WeaponTossPrepParams prepParams )
{
	weapon.EmitWeaponSound_1p3p( GetGrenadeDeploySound_1p( weapon ), GetGrenadeDeploySound_3p( weapon ) )

	#if(false)

#endif
}


void function OnDeployableMedicPlanted( entity projectile )
{
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
void function DeployableMedic_OnPropScriptCreated( entity ent )
{
}

void function DeployableMedic_HealVisualsEnabled( entity ent, int statusEffect, bool actuallyChanged )
{
	if ( !actuallyChanged )
		return

	if ( ent != GetLocalViewPlayer() )
		return

	entity player = ent

	entity cockpit = player.GetCockpit()
	if ( !IsValid( cockpit ) )
		return

	Assert( !EffectDoesExist( file.healFxHandle ), "tried to start a second screen fx" )

	int fxID = GetParticleSystemIndex( FX_DRONE_MEDIC_HEAL_COCKPIT_FX )
	file.healFxHandle = StartParticleEffectOnEntity( cockpit, fxID, FX_PATTACH_ABSORIGIN_FOLLOW, -1 )
	EffectSetIsWithCockpit( file.healFxHandle, true )

	Chroma_StartHealingDroneEffect()
}

void function DeployableMedic_HealVisualsDisabled( entity ent, int statusEffect, bool actuallyChanged )
{
	if ( !actuallyChanged )
		return

	if ( ent != GetLocalViewPlayer() )
		return

	if ( !EffectDoesExist( file.healFxHandle ) )
		return

	EffectStop( file.healFxHandle, false, true )

	Chroma_EndHealingDroneEffect()
}

bool function CanDeployHealDrone( entity player )
{
	if ( !player.HasPassive( ePassives.PAS_MEDIC ) )
		return false

	entity weapon = player.GetOffhandWeapon( OFFHAND_TACTICAL )

	if ( !IsValid( weapon ) )
		return false

	if ( weapon.GetWeaponClassName() != "mp_weapon_deployable_medic" )
		return false

	int ammoReq  = weapon.GetAmmoPerShot()
	int currAmmo = weapon.GetWeaponPrimaryClipCount()
	if ( currAmmo < ammoReq )
		return false

	return true
}

#endif //