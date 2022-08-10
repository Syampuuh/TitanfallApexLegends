global function MpWeapon_Mortar_Ring_Init

global function OnWeaponPrimaryAttack_ability_mortar_ring
global function OnWeaponActivate_ability_mortar_ring
global function OnWeaponDeactivate_ability_mortar_ring
global function OnWeaponAttemptOffhandSwitch_ability_mortar_ring
global function OnProjectileCollision_ability_mortar_ring
global function OnWeaponReadyToFire_ability_mortar_ring

#if SERVER
                                               
                                                
                                         
                                          
#endif

const string CMDNAME_CLEARANCE_ENABLED = "ClientCallback_ClearanceEnabled"
const string CMDNAME_CLEARANCE_DISABLED = "ClientCallback_ClearanceDisabled"
const string CMDNAME_ARC_ENABLED = "ClientCallback_ArcEnabled"
const string CMDNAME_ARC_DISABLED = "ClientCallback_ArcDisabled"

const string MORTAR_RING_BOMB_FLIGHT_SOUND = "Fuse_Mortar_Projectile"
const string MORTAR_RING_FIRE_1P_SOUND = "Fuse_Mortar_Fire_1p"
const string MORTAR_RING_FIRE_3P_SOUND = "Fuse_Mortar_Fire_3p"
const string MORTAR_RING_ACTIVATE_1P_SOUND = "Fuse_Mortar_Deploy_1p"
const string MORTAR_RING_ACTIVATE_3P_SOUND = "Fuse_Mortar_Deploy_3p"
const string MORTAR_RING_DEACTIVATE_1P_SOUND = "Fuse_Ultimate_Away_1p"
const string MORTAR_RING_DEACTIVATE_3P_SOUND = "Fuse_Ultimate_Away_3p"
const string MORTAR_RING_UI_OPEN_SOUND = "Fuse_Ultimate_UI_InGame_Open"
const string MORTAR_RING_UI_CLOSE_SOUND = "Fuse_Ultimate_UI_InGame_Close"
const string MORTAR_RING_UI_IN_RANGE_SOUND = "Fuse_Ultimate_UI_InGame_True"
const string MORTAR_RING_UI_OUT_OF_RANGE_SOUND = "Fuse_Ultimate_UI_InGame_False"
const string MORTAR_RING_CANT_FIRE_SOUND = "Fuse_Ultimate_UI_InGame_NotReady"
const asset MORTAR_RING_RADIUS_FX = $"P_ar_target_fuse"
                        
const asset MORTAR_RING_RADIUS_INSTANT_FX = $"P_ar_target_fuse_instant"
      
const asset MORTAR_RING_MARKER_FX = $"P_ar_fuse_artillery_marker"

const vector DEFAULT_COLOR = < 10, 255, 0>
const vector CLEARANCE_COLOR = < 255, 125, 0>
const vector OUT_OF_RANGE_COLOR = < 255, 10, 0>

const string MORTAR_RING_IMPACT_TABLE = "exp_frag_grenade"
const float MORTAR_RING_RADIUS = 420.0
const float MORTAR_RING_RADIUS_FX_DIVISOR = 20.0                                                                          
const int MORTAR_RING_NUM_MISSILES = 15

global const bool MORTAR_RING_DEBUG = false

const float MORTAR_RING_AIRBURST_BASE_LAUNCH_SPEED = 375.0
const float MORTAR_RING_AIRBURST_SPEED_MOD_MIN = 0.7
const float MORTAR_RING_AIRBURST_SPEED_MOD_MAX = 1.1
const float MORTAR_RING_LAUNCH_SPEED_MIN = 2750
const float MORTAR_RING_LAUNCH_SPEED_MAX = 4000

global const float MORTAR_RING_BOMB_AIRBURST_HEIGHT = 750.0

                   
const float MORTAR_RING_AIM_PITCH_ANGLE_MIN = 25.0
const float MORTAR_RING_AIM_PITCH_ANGLE_MAX = 180.0
const float MORTAR_RING_AIM_PITCH_PARAM_MIN = 0.0
const float MORTAR_RING_AIM_PITCH_PARAM_MAX = 150.0
const float MORTAR_RING_AIM_PITCH_DIFF_SNAP_VALUE = 1.0
const float MORTAR_RING_AIM_PITCH_DIFF_CHECK_MIN = -90.0
const float MORTAR_RING_AIM_PITCH_DIFF_CHECK_MAX = 90.0
const float MORTAR_RING_AIM_PITCH_INCREMENT_MIN = -7
const float MORTAR_RING_AIM_PITCH_INCREMENT_MAX = 7

const float MORTAR_MIN_FIRE_DISTANCE = MORTAR_RING_RADIUS * MORTAR_RING_AIRBURST_SPEED_MOD_MAX + 60
const float MORTAR_MAX_FIRE_DISTANCE = 7875              

struct
{
#if CLIENT
	bool weaponActive = false
	bool activateUI = false
#endif         
} file

struct CrosshairTargetData
{
	bool inRange
	vector crosshairStart
	vector groundTarget
	vector airburstTarget
	float distanceToTarget
	vector directionToTarget
}


void function MpWeapon_Mortar_Ring_Init()
{

	Remote_RegisterServerFunction( CMDNAME_CLEARANCE_ENABLED )
	Remote_RegisterServerFunction( CMDNAME_CLEARANCE_DISABLED )
	Remote_RegisterServerFunction( CMDNAME_ARC_ENABLED )
	Remote_RegisterServerFunction( CMDNAME_ARC_DISABLED )

	RegisterSignal( "MortarRingDeactivate" )

	PrecacheImpactEffectTable( MORTAR_RING_IMPACT_TABLE )
                         
		PrecacheParticleSystem( MORTAR_RING_RADIUS_INSTANT_FX )
      
                                                 
       
	PrecacheParticleSystem( MORTAR_RING_MARKER_FX )
}

bool function OnWeaponAttemptOffhandSwitch_ability_mortar_ring( entity weapon )
{
	entity ownerPlayer = weapon.GetWeaponOwner()

	                                                     
	if ( Bleedout_IsBleedingOut( ownerPlayer ) )
		return false

	entity player = weapon.GetWeaponOwner()
	if ( player.IsPhaseShifted() )
		return false

	                                                      
	if ( player.IsZiplining() )
		return false

	                                          
	if ( weapon == ownerPlayer.GetActiveWeapon( eActiveInventorySlot.mainHand ) )
		return false

	int ammoReq = weapon.GetWeaponSettingInt( eWeaponVar.ammo_min_to_fire )
	int currAmmo = weapon.GetWeaponPrimaryClipCount()
	if ( currAmmo >= ammoReq )
		return true

	return false
}

void function OnWeaponActivate_ability_mortar_ring(entity weapon)
{
	entity owner = weapon.GetWeaponOwner()
	Assert( owner.IsPlayer() )

	#if SERVER
		                                  
		                                                                              
	#endif         

	#if CLIENT
		if ( owner != GetLocalViewPlayer() )
			return

		file.weaponActive = true
		file.activateUI = false

		EmitSoundOnEntity( owner, MORTAR_RING_ACTIVATE_1P_SOUND )
		thread WeaponActiveThread_Client( owner, weapon )
	#endif         
}

void function OnWeaponReadyToFire_ability_mortar_ring( entity weapon )
{
	#if CLIENT
		entity owner = weapon.GetWeaponOwner()
		if ( owner != GetLocalViewPlayer() || !file.weaponActive )
			return

		file.activateUI = true
	#endif         
}

void function OnWeaponDeactivate_ability_mortar_ring(entity weapon)
{
	entity owner = weapon.GetWeaponOwner()
	Assert( owner.IsPlayer() )
	#if SERVER
		                                                                                
	#endif

	#if CLIENT
		if ( owner != GetLocalViewPlayer() )
			return

		file.weaponActive = false
		file.activateUI = false

		EmitSoundOnEntity(owner, MORTAR_RING_DEACTIVATE_1P_SOUND)
	#endif          


	owner.Signal( "MortarRingDeactivate" )
}

var function OnWeaponPrimaryAttack_ability_mortar_ring( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	entity owner = weapon.GetWeaponOwner()
	var ammo = weapon.GetWeaponSettingInt( eWeaponVar.ammo_min_to_fire )

	CrosshairTargetData crosshairData = GetCrosshairTargetData( owner )
	bool inRange = crosshairData.inRange
	if( inRange )
	{
		float launchSpeed = GraphCapped( crosshairData.distanceToTarget, 0, MORTAR_MAX_FIRE_DISTANCE, MORTAR_RING_LAUNCH_SPEED_MIN, MORTAR_RING_LAUNCH_SPEED_MAX  )
		ArcSolution as = SolveBallisticArc( weapon.GetAttackPosition(), launchSpeed, crosshairData.airburstTarget, GetConVarFloat( "sv_gravity" ) )
		vector arcPos = weapon.SimulateGrenadeImpactPos( as.fire_velocity, as.duration )
		float distanceToArcPos =  Distance( arcPos, owner.CameraPosition() )
		inRange = InRange( distanceToArcPos )
	}

	if( inRange )
	{
		#if CLIENT
			owner.Signal( "MortarRingDeactivate" )
		#endif
		LaunchBomb( owner, weapon, crosshairData.airburstTarget, attackParams.pos, crosshairData.distanceToTarget )
	}
	else
	{
		#if CLIENT
			EmitSoundOnEntity( owner, MORTAR_RING_CANT_FIRE_SOUND )
		#endif
		ammo = 0
	}

	return ammo
}

void function OnProjectileCollision_ability_mortar_ring( entity projectile, vector pos, vector normal, entity hitEnt, int hitbox, bool isCritical, bool isPassthrough )
{
	#if SERVER
	                                     

	                         
		      

	                       
		      

	                                               
		      

	                            
		      

	                          
		      

	                                                                                                                                                                                              
	#endif
}

#if CLIENT
void function WeaponActiveThread_Client( entity owner, entity weapon )
{	
	owner.EndSignal( "OnDestroy" )
	owner.EndSignal( "MortarRingDeactivate" )
	weapon.EndSignal( "OnDestroy" )

	var overlayRui = CreateCockpitPostFXRui( $"ui/mortar_binoculars.rpak", HUD_Z_BASE )
	RuiSetVisible( overlayRui, false )
	RuiSetFloat( overlayRui, "maxRangeDist", MORTAR_MAX_FIRE_DISTANCE )
	RuiSetBool( overlayRui, "useWeaponCycleToCancel", GetKeyCodeForBinding( "weaponCycle", IsControllerModeActive().tointeger() ) != -1 )

	int ringFX
                         
		ringFX = StartParticleEffectInWorldWithHandle( GetParticleSystemIndex( MORTAR_RING_RADIUS_INSTANT_FX ), ZERO_VECTOR, ZERO_VECTOR )
      
                                                                                                                            
       
	EffectSetControlPointVector( ringFX, 1, DEFAULT_COLOR )
	EffectSetControlPointVector( ringFX, 2, <MORTAR_RING_RADIUS / MORTAR_RING_RADIUS_FX_DIVISOR, 0, 0> )

	int markerFX = StartParticleEffectInWorldWithHandle( GetParticleSystemIndex( MORTAR_RING_MARKER_FX ), ZERO_VECTOR, < 0, 0, 1> )
	EffectSetControlPointVector( markerFX, 1, DEFAULT_COLOR )

	bool lastInRange = true
	bool lastClearance = true
	bool firstLoop = true
	bool firstUILoop = false
	bool visibleUI = false

	OnThreadEnd(
		function() : ( owner, ringFX, markerFX, weapon, overlayRui )
		{
			if( EffectDoesExist( ringFX ) )
				EffectStop( ringFX, true, false )

			if( EffectDoesExist( markerFX ) )
				EffectStop( markerFX, true, false )

			if( IsValid( weapon ) )
				weapon.ClearIndicatorEffectOverrides()

			EmitSoundOnEntity( owner, MORTAR_RING_UI_CLOSE_SOUND )

			RuiDestroyIfAlive( overlayRui )
			file.activateUI = false
		}
	)

	while( true )
	{
		CrosshairTargetData crosshairData = GetCrosshairTargetData( owner )
		bool newInRange = crosshairData.inRange
		bool newClearance = false
		vector arcPos = crosshairData.airburstTarget

		                         
		                                                                          
		                         

		if( newInRange )
		{
			float launchSpeed = GraphCapped( crosshairData.distanceToTarget, 0, MORTAR_MAX_FIRE_DISTANCE, MORTAR_RING_LAUNCH_SPEED_MIN, MORTAR_RING_LAUNCH_SPEED_MAX  )
			ArcSolution as = SolveBallisticArc( weapon.GetAttackPosition(), launchSpeed, crosshairData.airburstTarget, GetConVarFloat( "sv_gravity" ) )
			weapon.SetIndicatorEffectVelocityOverride( as.fire_velocity )
			weapon.SetIndicatorEffectDurationOverride( as.duration )
			arcPos = weapon.SimulateGrenadeImpactPos( as.fire_velocity, as.duration )
			float distanceToArcPos =  Distance( arcPos, crosshairData.crosshairStart )
			newInRange = InRange( distanceToArcPos )
			newClearance = ( Distance( crosshairData.airburstTarget, arcPos ) <= 50 )

			                         
			                                                
			                         
			float angle = DotToAngle( crosshairData.directionToTarget.Dot( Normalize( as.fire_velocity ) ) )
			float desiredAimPitch = GraphCapped( angle, MORTAR_RING_AIM_PITCH_ANGLE_MIN, MORTAR_RING_AIM_PITCH_ANGLE_MAX, MORTAR_RING_AIM_PITCH_PARAM_MIN, MORTAR_RING_AIM_PITCH_PARAM_MAX  )

			DoPoseParamLerp( weapon, desiredAimPitch, firstLoop )
		}
		else
		{
			weapon.ClearIndicatorEffectOverrides()
			DoPoseParamLerp( weapon, 0, firstLoop )
		}

		if( file.activateUI && !visibleUI)
		{
			RuiSetVisible( overlayRui, true )
			EmitSoundOnEntity( owner, MORTAR_RING_UI_OPEN_SOUND )
			visibleUI = true
			firstUILoop = true
		}

		                         
		                                    
		                         
		if( newInRange )
		{
			if( firstLoop || newInRange != lastInRange )
				Remote_ServerCallFunction( CMDNAME_ARC_ENABLED )

			if( newClearance )
			{
				if( firstLoop || newClearance != lastClearance || newInRange != lastInRange )
					Remote_ServerCallFunction( CMDNAME_CLEARANCE_ENABLED )

				if( EffectDoesExist( ringFX ) )
					EffectSetControlPointVector( ringFX, 1, DEFAULT_COLOR )
				if( EffectDoesExist( markerFX ) )
					EffectSetControlPointVector( markerFX, 1, DEFAULT_COLOR )
			}
			else
			{
				if( firstLoop || newClearance != lastClearance || newInRange != lastInRange )
					Remote_ServerCallFunction( CMDNAME_CLEARANCE_DISABLED )

				if( EffectDoesExist( ringFX ) )
					EffectSetControlPointVector( ringFX, 1, CLEARANCE_COLOR )
				if( EffectDoesExist( markerFX ) )
					EffectSetControlPointVector( markerFX, 1, CLEARANCE_COLOR )
			}

			if( firstUILoop || ( visibleUI && newInRange != lastInRange ) )
				EmitSoundOnEntity( owner, MORTAR_RING_UI_IN_RANGE_SOUND )
		}
		else
		{
			if( firstLoop || newInRange != lastInRange )
				Remote_ServerCallFunction( CMDNAME_ARC_DISABLED )

			if( EffectDoesExist( ringFX ) )
				EffectSetControlPointVector( ringFX, 1, OUT_OF_RANGE_COLOR )
			if( EffectDoesExist( markerFX ) )
				EffectSetControlPointVector( markerFX, 1, OUT_OF_RANGE_COLOR )

			if( firstUILoop || ( visibleUI && newInRange != lastInRange ) )
				EmitSoundOnEntity( owner, MORTAR_RING_UI_OUT_OF_RANGE_SOUND )
		}

		if( newInRange && !newClearance )
		{
			vector blockedVec = arcPos
			blockedVec.z -= MORTAR_RING_BOMB_AIRBURST_HEIGHT
			if( EffectDoesExist( ringFX ) )
				EffectSetControlPointVector( ringFX, 0, blockedVec )
			if( EffectDoesExist( markerFX ) )
				EffectSetControlPointVector( markerFX, 0, blockedVec )
		}
		else
		{
			if( EffectDoesExist( ringFX ) )
				EffectSetControlPointVector( ringFX, 0, crosshairData.groundTarget )
			if( EffectDoesExist( markerFX ) )
				EffectSetControlPointVector( markerFX, 0, crosshairData.groundTarget )
		}

		                         
		                    
		                         
		RuiSetBool( overlayRui, "inRange", newInRange )
		RuiSetBool( overlayRui, "hasClearance", newClearance )
		RuiSetFloat( overlayRui, "rangeDist",  crosshairData.distanceToTarget )

		lastInRange = newInRange
		lastClearance = newClearance
		firstLoop = false
		firstUILoop = false
		WaitFrame()
	}
}

void function DoPoseParamLerp( entity weapon, float target, bool immeadiate )
{
	if( !immeadiate )
	{
		float currentAimPitch = weapon.GetScriptPoseParam0()

		float diff = target - currentAimPitch
		float aimPitchIncrement = GraphCapped( diff, MORTAR_RING_AIM_PITCH_DIFF_CHECK_MIN, MORTAR_RING_AIM_PITCH_DIFF_CHECK_MAX, MORTAR_RING_AIM_PITCH_INCREMENT_MIN, MORTAR_RING_AIM_PITCH_INCREMENT_MAX )
		float aimPitch = 0
		if( fabs( diff ) < MORTAR_RING_AIM_PITCH_DIFF_SNAP_VALUE )
			aimPitch = target
		else
			aimPitch = currentAimPitch + aimPitchIncrement

		weapon.SetScriptPoseParam0( aimPitch )
	}
	else
	{
		weapon.SetScriptPoseParam0( target )
	}
}
#endif

void function LaunchBomb( entity player, entity weapon, vector target, vector pos, float distance )
{
	if( !IsValid( weapon ) )
		return

#if CLIENT
	if ( !weapon.ShouldPredictProjectiles() )
		return
#endif

	#if SERVER
		                                                           
		                                                                            
	#endif

	#if CLIENT
		EmitSoundOnEntity( player, MORTAR_RING_FIRE_1P_SOUND )
	#endif

	float launchSpeed = GraphCapped( distance, 0, MORTAR_MAX_FIRE_DISTANCE, MORTAR_RING_LAUNCH_SPEED_MIN, MORTAR_RING_LAUNCH_SPEED_MAX  )
	ArcSolution as = SolveBallisticArc( pos, launchSpeed, target, GetConVarFloat( "sv_gravity" ) )
	if( !as.valid )
	{
		Assert( false, FUNC_NAME() + "Valid arc not found" )
		return
	}

	entity bomb = null
	WeaponFireGrenadeParams fireGrenadeParams
	fireGrenadeParams.pos = pos
	fireGrenadeParams.vel = as.fire_velocity
	fireGrenadeParams.scriptTouchDamageType = damageTypes.projectileImpact
	fireGrenadeParams.scriptExplosionDamageType = damageTypes.explosive
	fireGrenadeParams.clientPredicted = true
	fireGrenadeParams.lagCompensated = true
	fireGrenadeParams.useScriptOnDamage = true
	bomb = weapon.FireWeaponGrenade( fireGrenadeParams )

	if ( !IsValid( bomb ) )
		return

	#if SERVER
		                                  
		                                                        
		                       
			                                                                                                                                                   
	#endif

	thread BombFlightThread( bomb, player, target )
}

void function BombFlightThread( entity projectile, entity player, vector target )
{
	EndSignal( projectile, "OnDestroy" )
	EndSignal( player, "OnDestroy" )

	vector launchDirection = player.GetViewForward()

#if SERVER
	                                               
		                           
			                    
	   
#endif

	vector projectileOriginStart = projectile.GetOrigin()
	float startDistance = Distance2D( projectileOriginStart, target )

	while ( true )
	{
		vector projectileOrigin = projectile.GetOrigin()
		vector projectileOriginXY = FlattenVec( projectileOrigin )
		vector projectileDir = Normalize( projectile.GetVelocity() )
		projectile.SetAngles( VectorToAngles( projectileDir ) )
		#if SERVER
			                                                                                
			 
				           
				        
			 
			    
			 
				                              
			 
			                                                                                                                                                                                              
			      
		#endif
		WaitFrame()
	}
	unreachable
}

CrosshairTargetData function GetCrosshairTargetData( entity player )
{
	CrosshairTargetData data
	data.crosshairStart = player.CameraPosition()
	vector crosshairEnd = data.crosshairStart + player.GetViewForward() * MORTAR_MAX_FIRE_DISTANCE
	DoTraceCoordCheck( false )
	array< entity > ignoreEnts = [ player ]
	ignoreEnts.extend( GetEntArrayByScriptName( CRYPTO_DRONE_SCRIPTNAME ) )
	TraceResults crosshairResults = TraceLineHighDetail( data.crosshairStart, crosshairEnd, ignoreEnts, (TRACE_MASK_SHOT | CONTENTS_BLOCKLOS ) & ~CONTENTS_WINDOW, TRACE_COLLISION_GROUP_PROJECTILE )
	data.groundTarget = crosshairResults.endPos
	data.airburstTarget = data.groundTarget + < 0, 0, MORTAR_RING_BOMB_AIRBURST_HEIGHT >
	data.distanceToTarget = Distance( data.groundTarget, data.crosshairStart )
	data.directionToTarget =  Normalize( data.groundTarget - data.crosshairStart )
	float flattenedDistanceToTarget = Distance2D( data.groundTarget, data.crosshairStart )
	if( flattenedDistanceToTarget < MORTAR_MIN_FIRE_DISTANCE )
	{
		data.groundTarget = crosshairResults.endPos + ( FlattenNormalizeVec ( data.directionToTarget ) * ( MORTAR_MIN_FIRE_DISTANCE - flattenedDistanceToTarget ) )
		vector downTraceEnd = < data.groundTarget.x, data.groundTarget.y, data.groundTarget.z - 250 >
		TraceResults downTraceResults = TraceLineHighDetail( data.groundTarget, downTraceEnd, ignoreEnts, (TRACE_MASK_SHOT | CONTENTS_BLOCKLOS ) & ~CONTENTS_WINDOW, TRACE_COLLISION_GROUP_PROJECTILE )
		if( downTraceResults.startSolid || downTraceResults.fraction < 1.0 )
			data.groundTarget = downTraceResults.endPos
		data.airburstTarget = data.groundTarget + < 0, 0, MORTAR_RING_BOMB_AIRBURST_HEIGHT >
		data.distanceToTarget = Distance( data.groundTarget, data.crosshairStart )
		data.inRange = true
	}
	else
	{
		data.inRange = ( crosshairResults.fraction < 1.0 )
	}
	DoTraceCoordCheck( true )

	return data
}

bool function InRange( float distance )
{
	return ( distance <= MORTAR_MAX_FIRE_DISTANCE )
}

#if SERVER
                                                               
 
	                         
		      

	                                                           
	                       
		                                                 
 

                                                              
 
	                         
		      

	                                                           
	                       
	 
		                                                       
			                                                    
	 
 

                                                         
 
	                         
		      

	                                                           
	                       
		                                               
 

                                                        
 
	                         
		      

	                                                           
	                       
	 
		                                                     
			                                                  
	 
 
#endif