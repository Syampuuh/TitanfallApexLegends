  
                                                              
                                                                                                                             
                                                                    
                                 
                                                       
                   
                                 
                                                                                                     

                                                                                                 
  

global function ShDrones_Init
global function ShDrones_IsValidDrone
global function ShDrones_IsValidDroneMover
global function ShDrones_DroneSpawned

#if CLIENT
global function ServerCallback_AddDroneClientData
global function ShDrones_GetDroneClientData
global function ServerCallback_SetDroneTrailFXType
global function ServerCallback_ClearDroneTrailFXType
global function ServerCallback_ClearAllDroneFX
#endif

global const string SIGNAL_DRONE_FALL_START = "signalDroneSpiral"
global const string SIGNAL_DRONE_STOP_PANIC = "droneStopPanicking"
global const string DEFAULT_DRONE_FX_ATTACH_NAME = "fx_center"

global const float DEFAULT_DRONE_HEALTH_MAX = 1.0
global const float DEFAULT_DRONE_FLIGHT_SPEED_MAX = 175.0
global const float DEFAULT_DRONE_FLIGHT_ACCEL = 100.0
global const float DEFAULT_DRONE_FLIGHT_SPEED_PANIC = 500.0
global const float DEFAULT_DRONE_PANIC_DURATION = 5.0
global const float DEFAULT_DRONE_FALLING_SPEED_MAX = 800.0
global const float DEFAULT_DRONE_FALLING_ACCEL = 300.0
global const float DEFAULT_DRONE_FALLING_GRAVITY = 350.0
global const float DEFAULT_DRONE_MIN_FALL_DIST_TO_SURFACE = 32.0
global const float DEFAULT_DRONE_ROLL = 45.0

#if SERVER
                                                                                        
                                                                                             
                                                                                              
#endif         

global enum eDroneType
{
	                                                                  
	INVALID,
	LOOT_DRONE,
	AD_DRONE,
	_count
}

global enum eDroneTrailFXType
{
	TRAIL,
	PANIC,
	FALL,

	_count
}

global struct DroneData
{
	entity model
	entity mover
	entity rotator
	array<entity> path
	array<vector> pathVec
	entity roller
	entity soundEntity
	vector lastSafeRollerPosition
	float health 		= DEFAULT_DRONE_HEALTH_MAX
	bool __isDead
	float __speed
	float __accel 		= DEFAULT_DRONE_FLIGHT_ACCEL
	float __maxSpeed 	= DEFAULT_DRONE_FLIGHT_SPEED_MAX
	float __panicSpeed  = DEFAULT_DRONE_FLIGHT_SPEED_PANIC
	float __panicDuration = DEFAULT_DRONE_PANIC_DURATION
	float __fallingSpeedMax = DEFAULT_DRONE_FALLING_SPEED_MAX
	float __fallingAccel = DEFAULT_DRONE_FALLING_ACCEL

	bool isPanicking
	float lastPanicTime = 0.0
	int droneType
}

#if CLIENT
global struct DroneClientData
{
	entity model
	int droneType
	int trailFXHandle
	int panicFXHandle
	int fallFXHandle
}
#endif

struct
{
	#if CLIENT
		table<entity, DroneClientData> droneToClientData
	#endif
} file

void function ShDrones_Init()
{
	                                                                      
	ShLootDrones_Init()
	ShAdDrones_Init()

	#if SERVER
		                                                                             
		                                                                                                                           
		                                                                                                                          
		                                                         
		                                                       
		                                                                             
	#endif
	#if CLIENT
		AddCreateCallback( "prop_dynamic", ShDrones_DroneSpawned )
	#endif
}

#if SERVER
                                        
 
	                       

	                                                                                             
 
#endif          

#if SERVER
                                           
 
	                                                                                           
	                                                                                         
 
#endif          



#if SERVER
                                             
 
	                                                             
 
#endif          

#if SERVER
                                               
 
	                                                               
 
#endif          

void function ShDrones_DroneSpawned( entity droneEnt )
{
	int droneType = GetDroneTypeFromDroneEntity( droneEnt )

	if ( droneType == eDroneType.INVALID )
		return

	#if CLIENT
		printf( "DroneClientDebug: Adding Drone to Client Data" )
		AddDroneClientData( droneEnt )
	#endif         


	#if SERVER
		                                       
		 
			                                                                 
			                                                                                                                       
			 
				                                   
				                                                        
			 
		 
	#endif         
}

int function GetDroneTypeFromDroneEntity( entity droneEnt )
{
	                                                                                                                   
	int droneType = eDroneType.INVALID
	if ( droneEnt.GetModelName().tolower() == LOOT_DRONE_MODEL.tolower() && droneEnt.GetScriptName().tolower() == LOOT_DRONE_MODEL_SCRIPTNAME.tolower() )
	{
		droneType = eDroneType.LOOT_DRONE
	}
	else if ( droneEnt.GetModelName().tolower() == AD_DRONE_MODEL.tolower() && droneEnt.GetScriptName().tolower() == AD_DRONE_MODEL_SCRIPTNAME.tolower() )
	{
		droneType = eDroneType.AD_DRONE
	}

	return droneType
}

int function GetDroneTypeFromDroneMover( entity droneEnt )
{
	                                                                                                                   
	int droneType = eDroneType.INVALID
	string scriptName = droneEnt.GetScriptName()
	if ( ( scriptName == LOOT_DRONE_MOVER_SCRIPTNAME ) || ( scriptName == LOOT_DRONE_ROTATOR_SCRIPTNAME ) )
	{
		droneType = eDroneType.LOOT_DRONE
	}
	else if ( ( scriptName == AD_DRONE_MOVER_SCRIPTNAME ) || ( scriptName == AD_DRONE_ROTATOR_SCRIPTNAME ) )
	{
		droneType = eDroneType.AD_DRONE
	}

	return droneType
}

#if CLIENT
void function ServerCallback_AddDroneClientData( entity droneEnt )
{
	printf( "DroneClientDebug: ServerCallback_AddDroneClientData" )
	AddDroneClientData( droneEnt )
}

void function AddDroneClientData( entity droneEnt )
{
	int droneType = GetDroneTypeFromDroneEntity( droneEnt )
	if ( droneType == eDroneType.INVALID )
	{
		printf( "DroneClientDebug: DroneType is the INVALID type, will not setup client data for it" )
		return
	}

	if ( droneEnt in file.droneToClientData )
		return

	printf( "DroneClientDebug: Adding Clientside Drone Data entry for a Drone of Type: " + GetEnumString( "eDroneType", droneType ) )
	DroneClientData clientData
	clientData.droneType = droneType
	clientData.model = droneEnt
	SetDroneTrailFX( clientData )

	file.droneToClientData[ droneEnt ] <- clientData
}

DroneClientData function ShDrones_GetDroneClientData( entity droneEnt )
{
	Assert( ShDrones_IsValidDrone( droneEnt ), "Requested Drone client data from invalid entity!" )
	Assert( (droneEnt in file.droneToClientData), "Requested entity not part of Drone client table!" )

	return file.droneToClientData[ droneEnt ]
}

void function SetDroneTrailFX( DroneClientData droneData )
{
	int droneType = droneData.droneType

	                                                                                         
	switch( droneType )
	{
		case eDroneType.LOOT_DRONE:
			SetLootDroneTrailFX( droneData )
			break

		case eDroneType.AD_DRONE:
			AdDrones_SetAdDroneTrailFX( droneData )
			break

		default:
			break
	}
}

void function ServerCallback_SetDroneTrailFXType( entity droneEnt, int trailType )
{
	printf( "LootDroneClientDebug: ServerCallback_SetDroneTrailFXType" )
	if ( !ShDrones_IsValidDrone( droneEnt ) )
		return

	DroneClientData clientData = ShDrones_GetDroneClientData( droneEnt )
	                                                                                        
	switch( clientData.droneType )
	{
		case eDroneType.LOOT_DRONE:
			SetLootDroneTrailFXType( droneEnt, trailType )
			break

		case eDroneType.AD_DRONE:
			AdDrones_SetAdDroneTrailFXType( droneEnt, trailType )

		default:
			break
	}
}

void function ServerCallback_ClearDroneTrailFXType( entity droneEnt, int trailType )
{
	printf( "DroneClientDebug: ServerCallback_ClearDroneTrailFXType" )

	if ( !ShDrones_IsValidDrone( droneEnt ) )
		return

	int fxHandle
	DroneClientData clientData = ShDrones_GetDroneClientData( droneEnt )
	switch( trailType )
	{
		case eDroneTrailFXType.TRAIL:
			fxHandle = clientData.trailFXHandle
			break
		case eDroneTrailFXType.PANIC:
			fxHandle = clientData.panicFXHandle
			break
		case eDroneTrailFXType.FALL:
			fxHandle = clientData.fallFXHandle
			break
	}

	if ( !EffectDoesExist( fxHandle ) )
		return

	EffectStop( fxHandle, false, true )
}

void function ServerCallback_ClearAllDroneFX( entity droneEnt )
{
	printf( "DroneClientDebug: ServerCallback_ClearAllDroneFX" )
	DroneClientData clientData = ShDrones_GetDroneClientData( droneEnt )
	if ( EffectDoesExist( clientData.trailFXHandle ) )
		EffectStop( clientData.trailFXHandle, false, true )
	if ( EffectDoesExist( clientData.panicFXHandle ) )
		EffectStop( clientData.panicFXHandle, false, true )
	if ( EffectDoesExist( clientData.fallFXHandle ) )
		EffectStop( clientData.fallFXHandle, false, true )
}
#endif         

bool function ShDrones_IsValidDrone( entity ent )
{
	if ( !IsValid( ent ) )
		return false

	bool isValidDrone = false

	if ( GetDroneTypeFromDroneEntity( ent ) != eDroneType.INVALID )
		isValidDrone = true

	return isValidDrone
}

bool function ShDrones_IsValidDroneMover( entity ent )
{
	if ( !IsValid( ent ) )
		return false

	bool isValidDroneMover = false

	if ( GetDroneTypeFromDroneMover( ent ) != eDroneType.INVALID )
		isValidDroneMover = true

	return isValidDroneMover
}
