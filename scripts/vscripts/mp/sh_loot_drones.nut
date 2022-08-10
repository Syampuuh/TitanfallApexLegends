global function ShLootDrones_Init

#if CLIENT
global function SetLootDroneTrailFX
global function SetLootDroneTrailFXType
#endif

global const asset LOOT_DRONE_MODEL = $"mdl/props/loot_drone/loot_drone.rmdl"                                                            

global const float LOOT_DRONE_START_FALL_HEALTH_FRAC = 0.95
global const float LOOT_DRONE_HEALTH_MAX = 1.0

global const asset LOOT_DRONE_FX_EXPLOSION = $"P_loot_drone_explosion"
global const asset LOOT_DRONE_FX_TRAIL = $"P_loot_drone_exhaust"
global const asset LOOT_DRONE_FX_TRAIL_PANIC = $"P_loot_drone_exhaust_afterburn"
global const asset LOOT_DRONE_FX_TRAIL_FALL = $"p_loot_drone_body_trail"
global const asset LOOT_DRONE_FX_FALL_EXPLOSION = $"P_loot_drone_explosion_air"

global const string LOOT_DRONE_LIVING_SOUND = "LootDrone_Mvmt_Flying"
global const string LOOT_DRONE_DEATH_SOUND = "LootDrone_KillShot"
global const string LOOT_DRONE_CRASHING_SOUND = "LootDrone_Mvmt_Crashing"
global const string LOOT_DRONE_CRASHED_SOUND = "LootDrone_Explo"

global const string LOOT_DRONE_DAMAGE_VO = "bc_cargoBotDamaged"

global const float LOOT_DRONE_FLIGHT_SPEED_MAX = 175.0
global const float LOOT_DRONE_FLIGHT_ACCEL = 100.0
global const float LOOT_DRONE_FLIGHT_SPEED_PANIC = 500.0
global const float LOOT_DRONE_PANIC_DURATION = 5.0

global const float LOOT_DRONE_FALLING_SPEED_MAX = 800.0
global const float LOOT_DRONE_FALLING_ACCEL = 300.0
global const float LOOT_DRONE_FALLING_GRAVITY = 350.0
                                                 			                                                    
global const float LOOT_DRONE_MIN_FALL_DIST_TO_SURFACE = 32.0

global const float LOOT_DRONE_RAND_TOSS_MIN = 700.0
global const float LOOT_DRONE_RAND_TOSS_MAX = 700.0

global const string LOOT_DRONE_MODEL_SCRIPTNAME = "LootDroneModel"
global const string LOOT_DRONE_MOVER_SCRIPTNAME = "LootDroneMover"
global const string LOOT_DRONE_ROTATOR_SCRIPTNAME = "LootDroneRotator"

void function ShLootDrones_Init()
{
	PrecacheModel( LOOT_DRONE_MODEL )
	PrecacheParticleSystem( LOOT_DRONE_FX_TRAIL )
	PrecacheParticleSystem( LOOT_DRONE_FX_TRAIL_PANIC )
	PrecacheParticleSystem( LOOT_DRONE_FX_EXPLOSION )
	PrecacheParticleSystem( LOOT_DRONE_FX_FALL_EXPLOSION )
	PrecacheParticleSystem( LOOT_DRONE_FX_TRAIL_FALL )
}

#if CLIENT
void function SetLootDroneTrailFX( DroneClientData droneData )
{
	entity droneEnt = droneData.model

	int fxId          = GetParticleSystemIndex( LOOT_DRONE_FX_TRAIL )
	int attachIdx     = droneEnt.LookupAttachment( DEFAULT_DRONE_FX_ATTACH_NAME )
	int trailFXHandle = StartParticleEffectOnEntity( droneEnt, fxId, FX_PATTACH_POINT_FOLLOW, attachIdx )

	droneData.trailFXHandle = trailFXHandle
}

void function SetLootDroneTrailFXType( entity droneEnt, int trailType )
{
	printf( "LootDroneClientDebug: SetLootDroneTrailFXType" )
	if ( !ShDrones_IsValidDrone( droneEnt ) )
		return

	asset fxAsset
	int fxHandle
	DroneClientData clientData = ShDrones_GetDroneClientData( droneEnt )
	switch( trailType )
	{
		case eDroneTrailFXType.PANIC:
			fxAsset = LOOT_DRONE_FX_TRAIL_PANIC
			fxHandle = clientData.panicFXHandle
			break
		case eDroneTrailFXType.FALL:
			fxAsset = LOOT_DRONE_FX_TRAIL_FALL
			fxHandle = clientData.fallFXHandle
			break
		case eDroneTrailFXType.TRAIL:
		default:
			fxAsset = LOOT_DRONE_FX_TRAIL
			fxHandle = clientData.trailFXHandle
	}

	if ( EffectDoesExist( fxHandle ) )
		return

	int fxId = GetParticleSystemIndex( fxAsset )
	int attachIdx = droneEnt.LookupAttachment( ( DEFAULT_DRONE_FX_ATTACH_NAME ) )
	int trailFXHandle = StartParticleEffectOnEntity( droneEnt, fxId, FX_PATTACH_POINT_FOLLOW, attachIdx )

	switch( trailType )
	{
		case eDroneTrailFXType.PANIC:
			clientData.panicFXHandle = trailFXHandle
			break
		case eDroneTrailFXType.FALL:
			clientData.fallFXHandle = trailFXHandle
			break
		case eDroneTrailFXType.TRAIL:
		default:
			clientData.trailFXHandle = trailFXHandle
	}
}
#endif         
