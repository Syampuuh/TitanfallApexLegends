global function ShAdDrones_Init

#if CLIENT
global function AdDrones_SetAdDroneTrailFX
global function AdDrones_SetAdDroneTrailFXType
global function ServerCallback_AdDroneSetBillboardVFX
global function ServerCallback_AdDroneKillBillboardVFX
#endif

#if SERVER
                                                
                                                      
                                                         
#endif          

#if DEV && SERVER
                                                    
#endif                 

global const asset AD_DRONE_MODEL = $"mdl/props/loot_drone/loot_drone.rmdl"
global const asset AD_DRONE_BILLBOARD_PROJECTOR_MODEL = $"mdl/props/loot_projector/loot_projector.rmdl"
global const float AD_DRONE_HEALTH_MAX = 450.0
global const float AD_DRONE_ROLL = 9.0

global const asset AD_DRONE_FX_EXPLOSION = $"P_loot_drone_explosion"
global const asset AD_DRONE_BILLBOARD_PROJECTOR_FX_EXPLOSION = $"P_drone_ads_destroy"
const asset AD_DRONE_FX_TRAIL = $"P_loot_drone_exhaust"
const asset AD_DRONE_FX_TRAIL_PANIC = $"P_loot_drone_exhaust_afterburn"
const asset AD_DRONE_FX_TRAIL_FALL = $"p_loot_drone_body_trail"
global const asset AD_DRONE_FX_FALL_EXPLOSION = $"P_loot_drone_explosion_air"

                          
const asset AD_DRONE_BILLBOARD_1 = $"P_drone_ads_chevrex"
const asset AD_DRONE_BILLBOARD_2 = $"P_drone_ads_chickenbique"
const asset AD_DRONE_BILLBOARD_3 = $"P_drone_ads_hammond"
const asset AD_DRONE_BILLBOARD_4 = $"P_drone_ads_koalakola"
const asset AD_DRONE_BILLBOARD_5 = $"P_drone_ads_paradinha"
const asset AD_DRONE_BILLBOARD_6 = $"P_drone_ads_powerizer"
const asset AD_DRONE_BILLBOARD_7 = $"P_drone_ads_silva"
const asset AD_DRONE_BILLBOARD_8 = $"P_drone_ads_ziptec"

global const string AD_DRONE_LIVING_SOUND = "LootDrone_Mvmt_Flying"
global const string AD_DRONE_DEATH_SOUND = "LootDrone_KillShot"
global const string AD_DRONE_CRASHING_SOUND = "LootDrone_Mvmt_Crashing"
global const string AD_DRONE_CRASHED_SOUND = "LootDrone_Explo"

global const string AD_DRONE_DAMAGE_VO = "bc_cargoBotDamaged"

global const float AD_DRONE_FLIGHT_SPEED_MAX = 175.0
global const float AD_DRONE_FLIGHT_ACCEL = 100.0
global const float AD_DRONE_FLIGHT_SPEED_PANIC = 500.0
global const float AD_DRONE_PANIC_DURATION = 5.0

global const float AD_DRONE_FALLING_SPEED_MAX = 800.0
global const float AD_DRONE_FALLING_ACCEL = 300.0
global const float AD_DRONE_FALLING_GRAVITY = 350.0
global const float AD_DRONE_MIN_FALL_DIST_TO_SURFACE = 32.0

global const string AD_DRONE_MODEL_SCRIPTNAME = "AdDroneModel"
global const string AD_DRONE_MOVER_SCRIPTNAME = "AdDroneMover"
global const string AD_DRONE_ROTATOR_SCRIPTNAME = "AdDroneRotator"
global const string AD_DRONE_PROJECTOR_MODEL_SCRIPTNAME = "AdDroneProjectorModel"

global const int AD_DRONE_DEFAULT_LOOT_AMOUNT_TO_SPAWN = 0
global const string AD_DRONE_DEFAULT_LOOT_GROUP = "control_ordnance"

struct
{
	array< asset > availableAdDroneBillboardVFX
	#if CLIENT
		table<entity, int> projectorModelToBillboardVFXTable
	#endif          

	#if SERVER
		                                      
		                                                      
	#endif          
} file

void function ShAdDrones_Init()
{
	PrecacheModel( AD_DRONE_MODEL )
	PrecacheModel( AD_DRONE_BILLBOARD_PROJECTOR_MODEL )
	PrecacheParticleSystem( AD_DRONE_FX_TRAIL )
	PrecacheParticleSystem( AD_DRONE_FX_TRAIL_PANIC )
	PrecacheParticleSystem( AD_DRONE_FX_EXPLOSION )
	PrecacheParticleSystem( AD_DRONE_BILLBOARD_PROJECTOR_FX_EXPLOSION )
	PrecacheParticleSystem( AD_DRONE_FX_FALL_EXPLOSION )
	PrecacheParticleSystem( AD_DRONE_FX_TRAIL_FALL )

	file.availableAdDroneBillboardVFX = [ AD_DRONE_BILLBOARD_1, AD_DRONE_BILLBOARD_2, AD_DRONE_BILLBOARD_3, AD_DRONE_BILLBOARD_4, AD_DRONE_BILLBOARD_5, AD_DRONE_BILLBOARD_6, AD_DRONE_BILLBOARD_7, AD_DRONE_BILLBOARD_8 ]

	foreach ( particleSystem in file.availableAdDroneBillboardVFX )
	{
		PrecacheParticleSystem( particleSystem )
	}

	#if SERVER
		                                                                             
	#endif          
}

#if SERVER
                                              
                                               
 
	                                                                                                                           
	                                               
	 
		                                                                   
		 
			                                          
		 
	 

	                                                                                                                              
	                                                               
	                                                                  

	                     
 

                                              
                                                                             
 
	                                
	 
		                                                          
		                                                                               
		                                                                                                             
		                                      
		 
			                        
			 
				                                                                                                                   
			 
		 
	 
 

                                                                                    
                                                                                
 
	                                                                 
		                                                                 

	                                      
	 
		                        
			                                                                                                 
	 
 

                                                                                             
                                                                  
 
	                        
	 
		                                                                          
		                                                                 
		 
			                     
				                                                                                            
		 
	 
 
#endif          

#if CLIENT
void function ServerCallback_AdDroneSetBillboardVFX( entity projectorEnt, int billboardToDisplay )
{
	printf( "AdDrone: ServerCallback_AdDroneSetBillboardVFX" )

	if ( !IsValid( projectorEnt ) )
		return

	if ( billboardToDisplay < 0 || billboardToDisplay >= file.availableAdDroneBillboardVFX.len() )
		return

	AdDroneSetBillboardVFX( projectorEnt, billboardToDisplay )
}

void function AdDroneSetBillboardVFX( entity projectorEnt, int billboardToDisplay )
{
	int fxId = GetParticleSystemIndex( file.availableAdDroneBillboardVFX[ billboardToDisplay ] )
	int billboardFXHandle = StartParticleEffectOnEntity( projectorEnt, fxId, FX_PATTACH_ABSORIGIN_FOLLOW, ATTACHMENTID_INVALID )
	file.projectorModelToBillboardVFXTable[ projectorEnt ] <- billboardFXHandle
}

void function ServerCallback_AdDroneKillBillboardVFX( entity projectorEnt )
{
	if ( projectorEnt in file.projectorModelToBillboardVFXTable )
	{
		int fxHandle = file.projectorModelToBillboardVFXTable[ projectorEnt ]
		if ( EffectDoesExist( fxHandle ) )
			EffectStop( fxHandle, false, true )
	}
}

void function AdDrones_SetAdDroneTrailFX( DroneClientData droneData )
{
	entity droneEnt = droneData.model

	int fxId          = GetParticleSystemIndex( AD_DRONE_FX_TRAIL )
	int attachIdx     = droneEnt.LookupAttachment( DEFAULT_DRONE_FX_ATTACH_NAME )
	int trailFXHandle = StartParticleEffectOnEntity( droneEnt, fxId, FX_PATTACH_POINT_FOLLOW, attachIdx )

	droneData.trailFXHandle = trailFXHandle
}

void function AdDrones_SetAdDroneTrailFXType( entity droneEnt, int trailType )
{
	printf( "LootDroneClientDebug: AdDrones_SetAdDroneTrailFXType" )
	if ( !ShDrones_IsValidDrone( droneEnt ) )
		return

	asset fxAsset
	int fxHandle
	DroneClientData clientData = ShDrones_GetDroneClientData( droneEnt )
	switch( trailType )
	{
		case eDroneTrailFXType.PANIC:
			fxAsset = AD_DRONE_FX_TRAIL_PANIC
			fxHandle = clientData.panicFXHandle
			break
		case eDroneTrailFXType.FALL:
			fxAsset = AD_DRONE_FX_TRAIL_FALL
			fxHandle = clientData.fallFXHandle
			break
		case eDroneTrailFXType.TRAIL:
		default:
			fxAsset = AD_DRONE_FX_TRAIL
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

#if DEV && SERVER
                                                                           
 
	                                                        
	 
		                                                                                                                                                                
		 
			                                                                            
			                                      
			 
				                        
				 
					                                                                                              
					                                                                                                                
				 
			 
		 
	 
 
#endif                 