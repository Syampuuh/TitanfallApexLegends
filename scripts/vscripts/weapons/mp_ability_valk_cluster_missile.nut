global function MpAbilityValkClusterMissile_Init
global function OnWeaponActivate_ability_valk_cluster_missile
global function OnProjectileCollision_ability_valk_cluster_missile
global function OnWeaponAttemptOffhandSwitch_ability_valk_cluster_missile
global function OnWeaponPrimaryAttack_valk_cluster_missile
global function OnWeaponDeactivate_ability_valk_cluster_missile

#if CLIENT
global function OnClientAnimEvent_ability_valk_cluster_missile
global function ValkTacShowTargetLocsThread
#endif

                                                            

const float MAX_ATTACK_RANGE = 4000.0                                                          
const float MIN_ATTACK_RANGE = 500.0                             
const float MIN_TRAVEL_TIME = 2.0
const float MAX_TRAVEL_TIME = 4.5
const int SIDE_STEPS = 2
const int FORWARD_STEPS = 4
                                                                      
const float STEP_HEIGHT = 300.0                                                             
const float STEP_SIDE = 155.0                               
const float STEP_FORWARD = 185.0                           
const float MISSILE_SPEED = 1600             
const float MISSILE_APEX_HEIGHT = 400
const float GRENADE_LOB_TIME = 0.75

const float STUN_DURATION = 2.0
const float STUN_EASEOUT = 1.5

const float STUN_MOVESLOW = 0.5
const float STUN_TURNSLOW = 0.0

const float EXPLOSION_DAMAGE = 25
const float EXPLOSION_FOLLOWUP_FACTOR = 0.15                                                                    
const float EXPLOSION_FOLLOWUP_TIME = 5                                                                          
const float EXPLOSION_RADIUS = 125

const float IN_ROW_DELAY = 0.05
const float ROW_TO_ROW_DELAY = 0.3

const float INITIAL_DELAY = 0.75                                            

global const VALK_TAC_WARNING_ENTITY = "valk_tac_warning_entity"
const asset CREEPING_BOMBARDMENT_WEAPON_BOMB_MODEL = $"mdl/weapons_r5/misc_bangalore_rockets/bangalore_rockets_projectile.rmdl"

struct {
	#if SERVER
		                                                                 
		                                                                     
		                                                                   
		                                                                  
		                                                                                    
	#endif
	#if CLIENT
		array<entity> valkTacWarnEntities
	#endif

} file

struct ValkMissileInfo
{
	float  missileSpeed
	vector phase1Vector
	vector phase2Vector
	vector phase3Vector
	vector firePos
	vector targetPos
	float  phase1Time
	float  phase1To2Time
	float  phase2Time
	float  phase2To3Time
	float  phase3ToTarTime
}

array< int > fanAdjustments =
[
	-1,
	1,
	-2,
	2,
	-3,
	3,
	-4,
	4,
	-5,
	5,
	-6,
	6
]


struct TraceStepResult
{
	vector pos
	vector normal
}

enum eCanFireTactical
{
	YES,
	NO_CLEARANCE,
	NO_OTHER
}

const asset FX_BOMBARDMENT_MARKER = $"P_valk_rckt_AR_marker"
const asset FX_BOMBARDMENT_LOCKED = $"P_valk_rckt_AR_lock"


const asset FX_MUZZLE_FLASH_FP = $"P_wpn_mflash_bang_rocket_FP"
const asset FX_MUZZLE_FLASH_3P = $"P_wpn_mflash_bang_rocket"
const asset MISSILE_TRAIL = $"P_valk_rckt_stg2"
const asset GRENADE_TRAIL = $"P_valk_rckt_stg1"
const asset ROCKET_PROJECTILE = $"mdl/humans_r5/pilots_r5/pilot_valkyrie/w_valkyrie_rocket_projectile.rmdl"

void function MpAbilityValkClusterMissile_Init()
{
	PrecacheModel( ROCKET_PROJECTILE )
	PrecacheParticleSystem( FX_MUZZLE_FLASH_FP )
	PrecacheParticleSystem( FX_MUZZLE_FLASH_3P )
	PrecacheParticleSystem( FX_BOMBARDMENT_MARKER )
	PrecacheParticleSystem( FX_BOMBARDMENT_LOCKED )
	PrecacheParticleSystem( GRENADE_TRAIL )
	PrecacheParticleSystem( MISSILE_TRAIL )
	RegisterSignal( "ValkTacTargetingEnd" )
	#if SERVER
		                                                                
	#endif
	#if CLIENT
		AddTargetNameCreateCallback( VALK_TAC_WARNING_ENTITY, ValkTacAddWarning )
	#endif         


	PrecacheImpactEffectTable( "exp_valk_rocket" )
}

#if SERVER
                                                                              
 
	                                                                 
	                                                                  
		      

	                    
	                                                  
	                                            
	 
		                                         
		                                                       
	 

	                                                                         

	                                     
	 
		                                
	 

	                                             
	                               

	                              

	                                                  
	 
		                                     
		                                          
		 
			                                                
			                                                                                                                                                                     
			                        
		 
	 
	                                          
	 
		                                    
		                                                                                    
		                                                                                             
		                                                                                            
		                        
			                                                                       

		                                                                       

		                                                                              
			                                        
	 
 
#endif

void function ValkTac_Cancelled( entity valk )
{
	                     
}


void function OnWeaponActivate_ability_valk_cluster_missile( entity weapon )
{
#if CLIENT

	entity owner = weapon.GetOwner()
	if ( GetLocalViewPlayer() == owner )
	{
		thread ValkTacShowTargetLocsThread( owner, weapon )
	}
#endif
	#if SERVER
		                                                   
	#endif
}

#if SERVER
                                                                 
 
	                                     
	                              
	                                          
	                                        

	            
		                             
		 

		 
	 

	           
	                                                               
	 
		           
	 
	                      
	                                                          
		                                                 
	  
	                                                                      
		                                 
 
#endif

void function OnWeaponDeactivate_ability_valk_cluster_missile( entity weapon )
{
	entity owner = weapon.GetOwner()
	if ( IsValid( owner ) )
		owner.Signal( "ValkTacTargetingEnd" )
}

                     
                                                                                
#if CLIENT
void function ValkTacShowTargetLocsThread( entity owner, entity weapon )
{
	EndSignal( owner, "ValkTacTargetingEnd", "OnDeath" )
	EndSignal( weapon, "OnDestroy" )
	array<int> vfxRefs = []

	OnThreadEnd( void function() : ( vfxRefs ) {
		foreach ( ref in vfxRefs )
		{
			CleanupFXHandle( ref, true, false )
		}
	} )

	                           

	int systemIndex = GetParticleSystemIndex( FX_BOMBARDMENT_MARKER )

	array<WeaponMissileMultipleTargetData> targetLocs = GetValkTacTargets( weapon, owner )
	vector normalAngle

	for ( int i = 0; i < targetLocs.len(); i++ )
	{
		WeaponMissileMultipleTargetData res = targetLocs[i]

		normalAngle = VectorToAngles( res.normal )
		normalAngle = FlattenVec( normalAngle )
		int thisRef = StartParticleEffectInWorldWithHandle( systemIndex, res.pos, normalAngle )
		                       
		EffectSetDistanceCullingScalar( thisRef, 999.0 )
		vfxRefs.append( thisRef )
	}

	                                                                       
	while ( true )
	{
		targetLocs = GetValkTacTargets( weapon, owner )

		for ( int i = 0; i < targetLocs.len(); i++ )
		{
			WeaponMissileMultipleTargetData res = targetLocs[i]
			normalAngle = VectorToAngles( res.normal )
			EffectSetControlPointVector( vfxRefs[i], 0, res.pos )
			EffectSetControlPointAngles( vfxRefs[i], 0, normalAngle )
		}
		WaitFrame()
	}
}
#endif

#if CLIENT
array<WeaponMissileMultipleTargetData> function GetValkTacTargets( entity weapon, entity owner )
{
	vector attackDir = weapon.GetAttackDirection()
	vector attackPos = weapon.GetAttackPosition()

	array<WeaponMissileMultipleTargetData> targetLocs = weapon.GetWeaponMissileMultipleTargets( attackPos, attackDir, owner, FORWARD_STEPS, SIDE_STEPS, STEP_FORWARD, STEP_SIDE, STEP_HEIGHT, INITIAL_DELAY, IN_ROW_DELAY, ROW_TO_ROW_DELAY, MAX_ATTACK_RANGE, MIN_ATTACK_RANGE )

	return targetLocs
}
#endif

#if SERVER
                                                                 
 
	                                                                                       
	                                                                              

	                                
	                                        

	                                                                             
	                     
	             

	                           
	 
		                                                                    
		                                                 
		                                       
		                                                                                          
		                            
		                                        
		                                                     
		                        
	 
	                        

	            
		                        
		 
			                         
			 
				                
			 
		 
	 
	                                                 
	 
		            
		                               
			     
	 
 
#endif

vector function SanitizePos ( vector pos )
{
	float posX = Clamp( pos.x, -64000, 64000  )                                                                                                                                                                     
	float posY = Clamp( pos.y, -64000, 64000  )                                                                                                                                                                     
	float posZ = Clamp( pos.z, -64000, 64000  )                                                                                                                                                                     
	return <posX, posY, posZ>
}

#if SERVER
                                                                                
 
	                              
	                                                                                                                  
	                             
	                                        
	                              
	                                                 
	                                              
		                                        

	                                                            

	                                

	            
		                                              
		 
			                         
				                 

			                                    
			                                                                   
				                                                        
		 
	 

	                                                                                                                          
	                                        
 
#endif

#if SERVER
                                                                    
 
	                               
	                                              
		      

	                                                             
	 
		                                                           
	 

	                                                                  
	                          
	 
		                                 
		      
	 

	                 
	                                                     
 
#endif

#if CLIENT
void function ValkTacAddWarning( entity warnEntity )
{
	                             
	file.valkTacWarnEntities.append( warnEntity )
	thread Thread_WaitForWarnEntDeletion( warnEntity )

	                                                            
	if ( file.valkTacWarnEntities.len() == 1 )
		thread ValkTacManageThreatIndicator()
}
#endif

#if CLIENT

void function Thread_WaitForWarnEntDeletion( entity warnEnt )
{
	warnEnt.EndSignal( "OnDestroy" )

	OnThreadEnd(
		function() : ( warnEnt )
		{
			file.valkTacWarnEntities.fastremovebyvalue( warnEnt )
		}
	)

	WaitForever()
}

#endif

#if CLIENT
void function ValkTacManageThreatIndicator()
{
	entity localPlayer = GetLocalViewPlayer()
	if ( !IsValid( localPlayer ) )
		return

	localPlayer.EndSignal( "OnDestroy" )

	asset indicatorModel   = GRENADE_INDICATOR_GENERIC
	vector indicatorOffset = <-5, 0, 0>

	entity arrow = CreateClientSidePropDynamic( <0, 0, 0>, <0, 0, 0>, GRENADE_INDICATOR_ARROW_MODEL )
	entity mdl   = CreateClientSidePropDynamic( <0, 0, 0>, <0, 0, 0>, indicatorModel )
	EndSignal( arrow, "OnDestroy" )

	OnThreadEnd(
		function() : ( arrow, mdl )
		{
			if ( IsValid( arrow ) )
			{
				arrow.Destroy()
			}
			if ( IsValid( mdl ) )
			{
				mdl.Destroy()
			}
		}
	)
	entity cockpit = localPlayer.GetCockpit()
	if ( !cockpit )
		return

	EndSignal( cockpit, "OnDestroy" )

	arrow.SetParent( cockpit, "CAMERA_BASE" )
	arrow.SetAttachOffsetOrigin( <25, 0, -4> )

	mdl.SetParent( arrow, "BACK" )
	mdl.SetAttachOffsetOrigin( indicatorOffset )

	float lastVisibleTime = 0
	bool shouldBeVisible  = true

	while ( IsValid( localPlayer ) && file.valkTacWarnEntities.len() > 0 )
	{
		cockpit = localPlayer.GetCockpit()
		vector playerOrigin = localPlayer.GetOrigin()

		bool firstLoop = true
		vector closestPoint
		foreach ( warningLoc in file.valkTacWarnEntities )
		{
			if ( !IsValid( warningLoc ) )
				continue

			vector point = warningLoc.GetOrigin()
			                                                      
			if ( firstLoop )
			{
				closestPoint = point
			}
			else if ( DistanceSqr( playerOrigin, closestPoint ) > DistanceSqr( playerOrigin, point ) )
			{
				closestPoint = point
			}
			firstLoop = false
		}
		float dist = Distance( playerOrigin, closestPoint )
		if ( dist > (EXPLOSION_RADIUS * 1.3) || !cockpit || localPlayer.IsPhaseShifted() )
		{
			shouldBeVisible = false
		}
		else
		{
			TraceResults result = TraceLine( closestPoint, localPlayer.EyePosition(), [ localPlayer ], TRACE_MASK_SHOT, TRACE_COLLISION_GROUP_NONE )

			if ( result.fraction == 1.0 )
			{
				lastVisibleTime = Time()
			}
			else
			{
				shouldBeVisible = false
			}
		}

		if ( shouldBeVisible || Time() - lastVisibleTime < 0.25 )
		{
			arrow.EnableDraw()
			mdl.EnableDraw()

			arrow.DisableRenderWithViewModelsNoZoom()
			arrow.EnableRenderWithCockpit()
			arrow.EnableRenderWithHud()
			mdl.DisableRenderWithViewModelsNoZoom()
			mdl.EnableRenderWithCockpit()
			mdl.EnableRenderWithHud()

			vector damageArrowAngles = AnglesInverse( localPlayer.EyeAngles() )
			vector vecToDamage       = closestPoint - (localPlayer.EyePosition() + (localPlayer.GetViewVector() * 20.0))

			                                
			if ( arrow.GetParent() == null )
				arrow.SetParent( cockpit, "CAMERA_BASE", true )

			arrow.SetAttachOffsetAngles( AnglesCompose( damageArrowAngles, VectorToAngles( vecToDamage ) ) )
		}
		else
		{
			mdl.DisableDraw()
			arrow.DisableDraw()
		}
		WaitFrame()
	}
}

#endif


var function OnWeaponPrimaryAttack_valk_cluster_missile( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	#if CLIENT
		if ( !InPrediction() || !IsFirstTimePredicted() )
		{
			return
		}
	#endif

	entity owner     = weapon.GetOwner()
	vector attackPos = attackParams.pos
	vector attackDir = attackParams.dir



	if ( attackParams.burstIndex == 0 )
	{
		               
		owner.Signal( "ValkTacTargetingEnd" )
		#if CLIENT
			ClientScreenShake( 10, 100, 0.5, attackDir )
			EmitSoundOnEntity( owner, "Valk_ShoulderRocket_Fire_Comp_1P" )

		#endif
		weapon.w.valkTac_targetData = weapon.GetWeaponMissileMultipleTargets( attackPos, attackDir, owner, FORWARD_STEPS, SIDE_STEPS, STEP_FORWARD, STEP_SIDE, STEP_HEIGHT, INITIAL_DELAY, IN_ROW_DELAY, ROW_TO_ROW_DELAY, MAX_ATTACK_RANGE, MIN_ATTACK_RANGE )

		#if SERVER
			                                                                                                                                           

			                                       

			                                        
			                                           
			                                                                  
			                                                                                   
		#endif

	}
	else
	{
		#if SERVER
			                                     
		#endif
	}

	                                                                                                                         
	#if CLIENT
		if ( GetLocalViewPlayer() != owner )
			return
	#endif

	if (weapon.w.valkTac_targetData.len() < 1)
		return

	WeaponMissileMultipleTargetData thisResult = weapon.w.valkTac_targetData[attackParams.burstIndex]
	vector curTar                              = thisResult.pos


	float curDownDelay = thisResult.delay

	                                                                                            
	                                                                                       
	                                                      

	ValkMissileInfo thisMissileInfo

	WeaponFireMissileParams fireMissileParams
	fireMissileParams.pos                       = attackPos
	fireMissileParams.scriptTouchDamageType     = damageTypes.projectileImpact              
	fireMissileParams.scriptExplosionDamageType = damageTypes.explosive
	fireMissileParams.clientPredicted           = false
	fireMissileParams.speed                     = 0

	vector swarmVector = attackParams.dir
	swarmVector = Normalize( swarmVector )

	vector flatRight = RotateVector( attackParams.dir, <0, -90, 0> )
	flatRight.z = 0
	flatRight   = Normalize( flatRight )

	float fanAdjust = float(fanAdjustments[attackParams.burstIndex])

	swarmVector += flatRight * fanAdjust * 0.1                                                    
	swarmVector.z = 0.7
	swarmVector   = Normalize( swarmVector )


	                    
	vector dir2d = (curTar - attackPos);
	dir2d.z = 0;
	dir2d   = Normalize( dir2d )
	vector phase1Vec = Normalize( swarmVector ) * 0.6
	vector phase2Vec = Normalize ( dir2d + <0, 0, 0.7> ) * 0.8
	vector phase3Vec = dir2d * 0.9
	thisMissileInfo.phase1Vector = phase1Vec
	thisMissileInfo.phase2Vector = phase2Vec
	thisMissileInfo.phase3Vector = phase3Vec

	                                                                    
	fireMissileParams.dir     = phase1Vec
	fireMissileParams.pos     = attackPos
	thisMissileInfo.firePos   = fireMissileParams.pos                                                       
	thisMissileInfo.targetPos = curTar

	WeaponFireGrenadeParams fireGrenadeParams

	                                                                                                                      
	if ( fanAdjust < 0 )
	{
		fireGrenadeParams.pos = attackPos + (flatRight * -18) + <0, 0, 0>
	}
	else
	{
		fireGrenadeParams.pos = attackPos + (flatRight * 10) + <0, 0, 0>
	}

	fireGrenadeParams.angVel            = <180, 0, 0>
	fireGrenadeParams.fuseTime          = 10
	fireGrenadeParams.clientPredicted   = true
	fireGrenadeParams.lagCompensated    = true
	fireGrenadeParams.useScriptOnDamage = true

	int rocketsInRow = 1 + (SIDE_STEPS * 2)

	                                                   
	int row = attackParams.burstIndex / rocketsInRow

	                  
	float distance = (curTar - attackPos).Length()

	float travelTime = log( distance )
	travelTime = GraphCapped( travelTime, log( MIN_ATTACK_RANGE ), log( MAX_ATTACK_RANGE ), MIN_TRAVEL_TIME, MAX_TRAVEL_TIME )
	travelTime += row * ROW_TO_ROW_DELAY
	int indexInRow = attackParams.burstIndex % rocketsInRow
	travelTime += indexInRow * IN_ROW_DELAY
	                                                         
	float thisLobTime          = GRENADE_LOB_TIME + RandomFloatRange( -0.2, 0.1 )                      
	fireGrenadeParams.vel      = (swarmVector + <0, 0, 0.75>) * (0.04 * (0.8 + thisLobTime))
	                               
	float rocketTravelTime     = travelTime - thisLobTime
	float rocketTravelDistance = distance - 200                                      
	float speed                = (rocketTravelDistance / rocketTravelTime) * 3


	                                                 
	float phase1Time      = 0.01
	float phase1To2Time   = 0.01
	float phase2Time      = rocketTravelTime * 0.1
	float phase2To3Time   = rocketTravelTime * 0.16
	float phase3ToTarTime = rocketTravelTime * 0.1
	thisMissileInfo.phase1Time      = phase1Time
	thisMissileInfo.phase1To2Time   = phase1To2Time
	thisMissileInfo.phase2Time      = phase2Time
	thisMissileInfo.phase2To3Time   = phase2To3Time
	thisMissileInfo.phase3ToTarTime = phase3ToTarTime
	thisMissileInfo.missileSpeed    = speed

	               
	entity grenade    = weapon.FireWeaponGrenade( fireGrenadeParams )
	if( IsValid(grenade) )
	{
		int grenadeHandle = grenade.GetEncodedEHandle()

		grenade.SetPhysics( MOVETYPE_FLYGRAVITY )
		grenade.SetAngles( FlattenAngles( VectorToAngles( attackParams.dir ) ) + <-15, 0, 0> )                               
		#if SERVER
			                                                          
			                                       
			                                                       

		#endif

		grenade.SetProjectileLifetime( thisLobTime )
	}

#if SERVER
	                                                                                                                                                   

	                                   
	 
		                                                 
		                                                                                    
	 
#endif
	            
	  	                             
	  		                                                           
	        

                        
		if ( weapon.HasMod( "arenas_tac_max" ) )
		{
			return weapon.GetAmmoPerShot()
		}
       

	                                                                                       
	if ( attackParams.burstIndex == weapon.GetWeaponSettingInt( eWeaponVar.burst_fire_count ) - 1 )
	{
		#if SERVER
			                                                                                    
		#endif
		int curAmmo = weapon.GetWeaponPrimaryClipCount()
		owner.Signal( "ValkTacTargetingEnd" )
		return curAmmo
	}
	else
	{
		#if SERVER
			               
		#endif
		return weapon.GetAmmoPerShot()
	}
}


#if SERVER
                                                                                                                                                                                                                
 
	                          
		      

	                                               

	                                
	            
		                                                                                                                    
		 
			                                              
				      


			                                                                     
			                                                    
			                                                    
			                                                    
			                                                    
			                            
			                            
			                                                  
			                                                     
			                                                       
			                                                 
			                                           
			                                           
			                  
			                                                                     

			                          
				      


			                      
			 
				                                                                             
				                                                                                                       
				                                                                                                     
			 

			                                                 

			                             
			                                     
			                                                              
			                                           

			                                              
			                                                                                                                                                                                                                                             
			                                                                                                                                                                                                                                                          
			                                                                                                                                                                                                                                                                          

			                                 
			                                 
			                                 
			                                 
			                                 
			                                 
			                                 
			                                 
			                                 
			                               
			                               

			                                                                                                                                                 
			                                                                                                                                 
			                                                                                                                         
			                             
			 
				                                                      
				                         
				                           
			 
			    
			 
				                                                                                                                            
				                                  
				 
					                
					                           
					                         
					                           
				 
			 
			                                                                                                                                                                 

			                                                                        
			                                             
				                

			                                                                                                                                                                                                                                          
		 
	 
	             
 
#endif

void function DebugTimeMissile( entity missile, int burstNumber, float expectedTime )
{
	float startTime = Time()
	missile.EndSignal( "OnDestroy" )
	OnThreadEnd( function(): (missile, burstNumber, startTime, expectedTime)
	{
		float totalTravelTime = Time() - startTime
		#if SERVER
			                                                                                                                                                               
		#endif
	} )
	WaitForever()
}


bool function OnWeaponAttemptOffhandSwitch_ability_valk_cluster_missile( entity weapon )
{
	int canFire = ValkCanFireTactical( weapon )

	#if CLIENT
		if ( canFire == eCanFireTactical.NO_CLEARANCE )
		{
			entity owner = weapon.GetWeaponOwner()
			AddPlayerHint( 1.0, 0.75, $"rui/hud/tactical_icons/tactical_valk", "#CLUSTER_MISSILE_CLEARANCE_FAIL" )
			EmitSoundOnEntity( owner, "Valk_Hover_VerticalClearanceWarning_1P" )
		}
	#endif

	return canFire == eCanFireTactical.YES

}


int function ValkCanFireTactical( entity weapon )
{
	if ( weapon.GetWeaponPrimaryClipCount() < weapon.GetWeaponPrimaryClipCountMax() )
		return eCanFireTactical.NO_OTHER

	entity owner = weapon.GetWeaponOwner()
	if ( StatusEffect_GetSeverity( owner, eStatusEffect.skyward_embark ) > 0.0 )
	{
		return eCanFireTactical.NO_OTHER
	}
	float traceDist      = 300
	TraceResults results = TraceLine( owner.EyePosition(), owner.GetOrigin() + <0, 0, traceDist>, [ owner ], TRACE_MASK_BLOCKLOS, TRACE_COLLISION_GROUP_NONE )
	float dist           = traceDist * results.fraction
	if ( dist < 160 )
	{
		return eCanFireTactical.NO_CLEARANCE
	}

	if ( owner.IsPhaseShifted() )
		return eCanFireTactical.NO_OTHER

	return eCanFireTactical.YES
}

#if SERVER
                                                                                             
 
	                             
		      

	                                   
	                                                    
	                                                                                                                                                      
	            
		                                
		 
			             
		 
	 
	             
 
#endif

void function OnProjectileCollision_ability_valk_cluster_missile( entity projectile, vector pos, vector normal, entity hitEnt, int hitbox, bool isCritical, bool isPassthrough )
{


	#if SERVER
		                                                    
		                                             
			      

		                                                                             
		                               
		                                    

		                        
			      

		                                                                
			                                                         

		                                                                                              
		                                   
			                                                                                  

		                                                             

		                                                                  

		                                                                                                                                                                                                                                                         
		                                      
		                    
		                                     
	#endif

}


#if CLIENT
void function OnClientAnimEvent_ability_valk_cluster_missile( entity weapon, string name )
{
	GlobalClientEventHandler( weapon, name )
}
#endif          

