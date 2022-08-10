global function MpWeaponPhaseBreach_Init
global function OnWeaponActivate_weapon_phase_breach
global function OnWeaponDeactivate_weapon_phase_breach
global function OnWeaponPrimaryAttack_ability_phase_breach
global function OnWeaponPrimaryAttackAnimEvent_ability_phase_breach
global function OnWeaponAttemptOffhandSwitch_weapon_phase_breach
#if SERVER && DEV
                                          
#endif
#if CLIENT
global function ServerToClient_PhaseBreachPortalCancelled
#endif

const string SOUND_PORTAL_ENTRANCE_OPEN_1P = "Ash_PhaseBreach_Activate_1p"
const string SOUND_PORTAL_ENTRANCE_OPEN_3P = "Ash_PhaseBreach_Activate_3p"
const string SOUND_PORTAL_EXIT_OPEN = "Ash_PhaseBreach_PortalOpen_Exit_3p"
const string SOUND_PORTAL_LOOP = "Ash_PhaseBreach_Portal_Loop"                                                                                                                         
const string SOUND_PORTAL_CLOSE = "Ash_PhaseBreach_Portal_Expire"                                                                    

const string SIGNAL_PHASE_BREACH_STOP_PLACEMENT = "PhaseBreach_StopPlacement"

const string FUNCNAME_ENEMY_BREACHED_NEARBY = "PhaseBreach_EnemyBreachedNearby"

const string ABILITY_USED_MOD = "ability_used_mod"

const vector BREACH_OFFSET = <0, 0, 42>
const vector BREACH_HULLCHECK_MINS   = <-5.0, -5.0, 36.0 - 5.0>
const vector BREACH_HULLCHECK_MAXS   = < 5.0,  5.0, 36.0 + 5.0>

const float PHASE_BREACH_SPEED = 1200.0
const float PHASE_BREACH_TRAVEL_TIME_MIN = 0.3
const float PHASE_BREACH_TRAVEL_TIME_MAX = 1.8
const float PHASE_BREACH_PORTAL_LIFETIME = 15.0
const float PHASE_BREACH_MAX_2D_DIST_DEFAULT = 2500.0
const float PHASE_BREACH_MAX_ANGLE_FOR_FULL_DIST_DEFAULT = 45.0
const bool  PHASE_BREACH_ALLOW_START_ON_MOVERS_DEFAULT = true
const bool  PHASE_BREACH_ALLOW_END_ON_MOVERS_DEFAULT = true
const float PHASE_BREACH_MOVERS_MAX_SPEED_FOR_END_DEFAULT = 12.0
const bool  PHASE_BREACH_ALLOW_END_ON_OOB = true
const float PHASE_BREACH_MIN_VIEW_DOT = 0.95

const bool DEBUG_DRAW_PLACEMENT_TRACES = false
const bool DEBUG_DRAW_ENDING_SCORES    = false
const bool DEBUG_DRAW_PUSHER_MOVEMENT  = false

const asset BREACH_TARGET_FX = $"P_ar_ping_squad_CP_altZ"
const asset BREACH_STARTPOINT_FX = $"P_ash_breach_start"
const asset BREACH_ENDPOINT_FX = $"P_ash_breach_end"
const asset BREACH_AIM_FX = $"P_wrp_trl_end"

const string FUNC_BREACH_FAILED = "ServerToClient_PhaseBreachPortalCancelled"
const string PLACEMENT_FAILED_HINT = "#PHASE_BREACH_CANT_PLACE"
global const string PHASE_BREACH_BLOCKER_SCRIPTNAME = "phase_breach_blocker"

struct PhaseBreachTargetInfo
{
	array<vector> posList
	vector        finalPos
	float         pathDistance

	vector        startPos
	bool 		  startCrouched
	bool 		  startBlocked

	float         portalQuality
}

struct PhaseBreachTraceResults
{
	TraceResults& results
	vector        adjustedEndPos
	bool          foundValidEnd
}

struct
{
	table<entity, PhaseTunnelPortalData>          triggerStartpoint
	table<entity, PhaseBreachTargetInfo>          portalTargetTable
	table<entity, PhaseTunnelData>                tunnelData

	#if SERVER
		                   						                        
		     									                
	#elseif CLIENT
		int targetingFxHandle
		string targetingHint
	#endif

	float maxDist
	float maxAngleForFullDist
	float maxEndingMoverSpeedSqr
	bool allowStartOnMovers
	bool allowEndOnMovers
	array<string> invalidTriggerEndingTypes = ["trigger_slip"]
} file

void function MpWeaponPhaseBreach_Init()
{
	PrecacheParticleSystem( BREACH_ENDPOINT_FX )
	PrecacheParticleSystem( BREACH_TARGET_FX )
	PrecacheParticleSystem( BREACH_AIM_FX )
	PrecacheParticleSystem( BREACH_STARTPOINT_FX )

	RegisterSignal( SIGNAL_PHASE_BREACH_STOP_PLACEMENT )

	file.maxDist = GetCurrentPlaylistVarFloat( "ash_phase_breach_max_2d_dist", PHASE_BREACH_MAX_2D_DIST_DEFAULT )
	file.maxAngleForFullDist = GetCurrentPlaylistVarFloat( "ash_phase_breach_max_angle_for_full_dist", PHASE_BREACH_MAX_ANGLE_FOR_FULL_DIST_DEFAULT )
	file.maxEndingMoverSpeedSqr = pow( GetCurrentPlaylistVarFloat( "ash_phase_breach_max_mover_speed", PHASE_BREACH_MOVERS_MAX_SPEED_FOR_END_DEFAULT ), 2.0)
	file.allowStartOnMovers = GetCurrentPlaylistVarBool( "ash_phase_breach_allow_start_on_movers", PHASE_BREACH_ALLOW_START_ON_MOVERS_DEFAULT )
	file.allowEndOnMovers = GetCurrentPlaylistVarBool( "ash_phase_breach_allow_end_on_movers", PHASE_BREACH_ALLOW_END_ON_MOVERS_DEFAULT )
	#if SERVER
		                                                                                            
	#endif

	if ( PHASE_BREACH_ALLOW_END_ON_OOB == false )
		file.invalidTriggerEndingTypes.append( "trigger_out_of_bounds" )

	Remote_RegisterClientFunction( FUNC_BREACH_FAILED )
}


void function OnWeaponActivate_weapon_phase_breach( entity weapon )
{
	bool serverOrPredicted = IsServer() || (InPrediction() && IsFirstTimePredicted())
	if ( serverOrPredicted )
	{
		weapon.RemoveMod( ABILITY_USED_MOD )
	}

	#if CLIENT
		entity player = weapon.GetWeaponOwner()
		if ( player == GetLocalViewPlayer() )
			thread PhaseBreachPlacement( weapon )
	#endif
}


void function OnWeaponDeactivate_weapon_phase_breach( entity weapon )
{
	entity player = weapon.GetWeaponOwner()
	if ( player in file.portalTargetTable )
		delete file.portalTargetTable[player]

	#if SERVER
		                                            
		 
			                                             
				                                                                                                                                                

			                                            
		 
	#elseif CLIENT
		if ( player == GetLocalViewPlayer() )
			weapon.Signal( SIGNAL_PHASE_BREACH_STOP_PLACEMENT )
	#endif
}


bool function OnWeaponAttemptOffhandSwitch_weapon_phase_breach( entity weapon )
{
	int ammoReq  = weapon.GetAmmoPerShot()
	int currAmmo = weapon.GetWeaponPrimaryClipCount()
	if ( currAmmo < ammoReq )
		return false

	entity player = weapon.GetWeaponOwner()
	if ( player.IsPhaseShifted() )
		return false

	if ( player.IsZiplining() )
		return false

	return true
}


var function OnWeaponPrimaryAttack_ability_phase_breach( entity weapon, WeaponPrimaryAttackParams params )
{
	entity player = weapon.GetWeaponOwner()

	if ( !IsValid( player ) || player.IsPhaseShifted() )
		return 0

	PhaseBreachTargetInfo info = GetPhaseBreachTargetInfo( player )

	if ( info.portalQuality <= 0 )
		return 0

	file.portalTargetTable[player] <- info

	StatusEffect_AddTimed( player, eStatusEffect.move_slow, 0.5, 0.5, 0.0 )

	#if SERVER
		                                                                        
		                                            
	#endif

	return weapon.GetAmmoPerShot()
}


var function OnWeaponPrimaryAttackAnimEvent_ability_phase_breach( entity weapon, WeaponPrimaryAttackParams params )
{
	entity player = weapon.GetWeaponOwner()

	if ( !IsValid( player ) || !(player in file.portalTargetTable) )
		return 0

	if ( player.IsPhaseShifted() )
	{
		delete file.portalTargetTable[player]
		return 0
	}

	bool serverOrPredicted = IsServer() || (InPrediction() && IsFirstTimePredicted())
	if ( serverOrPredicted )
	{
		weapon.AddMod( ABILITY_USED_MOD )
	}

	PhaseBreachTargetInfo info = file.portalTargetTable[player]

	PlayerUsedOffhand( player, weapon, false )
	#if SERVER
		                                                                                                                                                      
	#endif

	#if SERVER
		                                             

		                                                                    
		                         

		                        

		                               
		 
			                         
			              
			                 

			                             
		 

		                                                                           
		                                     
		                                                                                                                              

                       
			                                       
        

		                                                            
	#endif

	#if CLIENT
		if ( player == GetLocalViewPlayer() )
			weapon.Signal( SIGNAL_PHASE_BREACH_STOP_PLACEMENT )
	#endif

	return 0
}

#if SERVER
                                                                                                
 
	                                                                                                                                                                  
	                                   
	                                               

	                                                                                                                                                               
	                                  
	                                              
	                                     
	                               

	                                                                                       

	                                                                        
	                                          
	                                                      

	                          
	                                    
	                                         
	                                                                                                          

	                                  
	                                                       
	                                          
	                                                                

	            
		                                                        
		 
			                                                 
				                                             

			                               
				                           

			                              
				                      
		 
	 

	                                                                                                    

	                                    	                                                     
	                                
	 
		           

		                         
			      

		                                                                                   
		 
			                                                    
			                                                           
			                                                                                   
			 
				                                
			 

			                              
				                          

			                                                                               
			                                                           

			      
		 
	 

	                                                                                                                                                  
	                                                                                                                                       

	                                                                 
 
#endif

#if CLIENT
void function ServerToClient_PhaseBreachPortalCancelled()
{
	entity localPlayer = GetLocalViewPlayer()
	if ( !IsValid( localPlayer ) )
		return

	AddPlayerHint( 3.0, 0.5, $"", "Phase Breach Failed" )

	StopSoundOnEntity( localPlayer, "Ash_PhaseBreach_Enter_1p" )
}
#endif

#if SERVER
                                                                                           
 
	                                                                
	                                                                            
	                                                               

	                                     


	                                             
	                                
	                                              
	                                              
	                                            
	                                            
	                                                   
	                                                                                                                                     

	                                                          
	                              

	                 
 

                                     
 
	                                          
	 
		                                                       
	 
 

                                                                                           
 
	                                   
	                                       

	                                

	                                
	                                          

	              
	                          
		                                                                                                                                   

	            
		                                               
		 
			                           
			 
				                                   
					                                   

				                   
			 

			                         
				                 
		 
	 

	                               
	                                           
	                              
	                          
	                            
	                                                                         

	                                                                                                       
 

       
                                          
 
	                                          
	 
		                                                       
	 
 
      

                                                                                                     
 
	                                                
	                                  
	                                                

	                                                         
	                                                         
	                                                                                                                    

	                                                   
	                             
	                                            
	                             
	                                                        
	                                       
	                                       
	                           
	                              
	                                                      
	                                          
	                        

	                                                      
	                                                     

	                           
	                              

	                                                                                                     
	                                             
	                                 
	                                  
	                                                 

	                                                                                                                                                
	                                  
	                                                 
	                                     
	                                  

	                                                                                                                                                      
	                                                    

	            
		                                                    
		 
			                         
			 
				                                        
				                 
			 

			                              
			 
				                                                    
				                                                                                             
				                      
			 

			                              
				                      
		   

	             
 


                                                                     
 
	                                        
		                                                         
 

                                                                                 
 
	                                     

	                                                                              
		      

	                                
	                                  
	                               

	                                  	                                             
	                                                       
	                                                                
	                                                                                                                                     
 

                                                                                                                           
 
	                                                          
	                                                                                                                                                                                                                       
	                             
		        

	                                                                                                                             
	                                                                                                                                                                                                                         
	                                  
		                

	            
 
#endif

const float DOWN_TRACE_DISTANCE = 1000.0
const float BACK_TRACE_STEP_DIST = 50.0
const float BACK_TRACE_MAX_STEP = 200.0
const float TUNNEL_STEP_DIST = 16.0

PhaseBreachTargetInfo function GetPhaseBreachTargetInfo( entity player )
{
	PhaseBreachTargetInfo info
	info.startPos   = player.GetOrigin()
	info.finalPos   = player.GetOrigin()
	info.startCrouched = player.IsCrouched()

	vector eyePos = player.EyePosition()
	vector eyeDir = player.GetViewVector()
	eyeDir          = Normalize( eyeDir )

	vector mins = player.GetPlayerMins()
	vector maxs = player.GetPlayerMaxs()

	                                                       
	if ( !file.allowStartOnMovers )
	{
		entity groundEnt = player.GetGroundEntity()
		if ( GetPusherEnt( groundEnt ) )
			return info
	}

	                                                                                                 
	                                                                                       
	if ( ! PhaseTunnel_IsPortalExitPointValid( player, info.startPos, player, true, info.startCrouched ) )
	{
		info.startBlocked = true
		return info
	}

	float rangeNormal = file.maxDist
	float rangeSqr    = rangeNormal * rangeNormal

	                            
	float pitchClamped   = clamp( player.EyeAngles().x, -file.maxAngleForFullDist, file.maxAngleForFullDist )
	float rangeEffective = rangeNormal / deg_cos( pitchClamped )

	array<entity> ignoredEnts = [ player ]

	                                           
	PhaseBreachTraceResults eyeTrace = DoEyeTrace( eyePos, eyeDir, rangeEffective, ignoredEnts, mins, maxs )
	if ( eyeTrace.foundValidEnd && IsBreachPositionValid( player, eyeTrace.adjustedEndPos, eyeTrace.results.hitEnt, eyeDir, eyeTrace.results.surfaceNormal ) )
	{
		bool success = GenerateBreachPathInfo( player, info, eyeTrace.adjustedEndPos )

		if ( success )
		{
			info.portalQuality = FLT_MAX
			return info
		}
	}

	array<vector> possibleEndings

	                                                                                             
	{
		if ( eyeTrace.results.fraction < 1.0 )
		{
			vector ledgeTraceEndPos     = eyeTrace.results.endPos + 32 * Normalize( <eyeDir.x, eyeDir.y, 0> ) - <0, 0, 24>
			vector aboveLedgeEndPos     = ledgeTraceEndPos + <0, 0, 60>

			                                                    
			TraceResults eyeToAboveLedgeTrace = TraceHull( eyePos,aboveLedgeEndPos, <-5,-5,-5>, <5,5,5>, ignoredEnts, TRACE_MASK_ABILITY_HULL, TRACE_COLLISION_GROUP_PLAYER )
			if ( eyeToAboveLedgeTrace.fraction == 1.0 )
			{
				TraceResults ledgeDownTrace = TraceHull( aboveLedgeEndPos, ledgeTraceEndPos, <-5,-5,-5>, <5,5,5>, ignoredEnts, TRACE_MASK_ABILITY_HULL, TRACE_COLLISION_GROUP_PLAYER )
				DrawDebugSphereIfDebugging( ledgeDownTrace.endPos, 150, 150, 0 )

				if ( ledgeDownTrace.fraction < 1.0 )
				{
					TraceResults hullTrace = DoHullTraceForExit( mins, maxs, ledgeDownTrace.endPos )

					if ( !hullTrace.startSolid && IsBreachPositionValid( player, hullTrace.endPos, hullTrace.hitEnt != null ? hullTrace.hitEnt : ledgeDownTrace.hitEnt, eyeDir, ledgeDownTrace.surfaceNormal ) )
					{
						possibleEndings.append( hullTrace.endPos )
					}
				}
			}
		}
	}

	                                                                                                                                 
	{
		PhaseBreachTraceResults lowerEyeTrace = DoEyeTrace( eyePos, VectorRotateAxis( eyeDir, player.GetRightVector(), -1 ), rangeEffective, ignoredEnts, player.GetPlayerMins(), player.GetPlayerMaxs() )

		if ( lowerEyeTrace.results.fraction < 1.0 )
		{
			vector ledgeTraceEndPos     = lowerEyeTrace.results.endPos + 24 * Normalize( <eyeDir.x, eyeDir.y, 0> ) - <0, 0, 24>
			vector aboveLedgeEndPos     = ledgeTraceEndPos + <0, 0, 60>

			                                                    
			TraceResults eyeToAboveLedgeTrace = TraceHull( eyePos,aboveLedgeEndPos, <-5,-5,-5>, <5,5,5>, ignoredEnts, TRACE_MASK_ABILITY_HULL, TRACE_COLLISION_GROUP_PLAYER )
			if ( eyeToAboveLedgeTrace.fraction == 1.0 )
			{
				TraceResults ledgeDownTrace = TraceHull( ledgeTraceEndPos + <0, 0, 60>, ledgeTraceEndPos, <-5,-5,-5>, <5,5,5>,ignoredEnts, TRACE_MASK_ABILITY_HULL, TRACE_COLLISION_GROUP_PLAYER )
				DrawDebugSphereIfDebugging( ledgeDownTrace.endPos, 150, 150, 0 )

				if ( ledgeDownTrace.fraction < 1.0 )
				{
					TraceResults hullTrace = DoHullTraceForExit( mins, maxs, ledgeDownTrace.endPos )

					if ( !hullTrace.startSolid && IsBreachPositionValid( player, hullTrace.endPos, hullTrace.hitEnt != null ? hullTrace.hitEnt : ledgeDownTrace.hitEnt, eyeDir, ledgeDownTrace.surfaceNormal ) )
					{
						possibleEndings.append( hullTrace.endPos )
					}
				}
			}
		}
	}

	                                      
	{
		TraceResults downTrace = TraceHull( eyeTrace.adjustedEndPos, eyeTrace.adjustedEndPos - <0.0, 0.0, DOWN_TRACE_DISTANCE>, <-5,-5,-5>, <5,5,5>, ignoredEnts, TRACE_MASK_ABILITY_HULL, TRACE_COLLISION_GROUP_PLAYER )
		DrawDebugSphereIfDebugging( downTrace.endPos, 0, 255, 0 )

		if ( downTrace.fraction < 1.0 )
		{
			TraceResults hullTrace = DoHullTraceForExit( mins, maxs, downTrace.endPos )

			if ( !hullTrace.startSolid && IsBreachPositionValid( player, hullTrace.endPos, hullTrace.hitEnt != null ? hullTrace.hitEnt : downTrace.hitEnt, eyeDir, downTrace.surfaceNormal ) )
			{
				possibleEndings.append( hullTrace.endPos )
			}
		}
	}

	                                                                                     
	{
		vector airPos      = eyeTrace.adjustedEndPos - eyeDir * BACK_TRACE_STEP_DIST
		float airTraceDist = BACK_TRACE_STEP_DIST
		int i              = 0
		while ( airTraceDist < (rangeEffective - 250.0) && (DotProduct( eyeTrace.adjustedEndPos - eyePos, airPos - eyePos ) > 0) )
		{
			TraceResults airDownTrace = TraceHull( airPos, airPos - <0.0, 0.0, DOWN_TRACE_DISTANCE>, <-5,-5,-5>, <5,5,5>, ignoredEnts, TRACE_MASK_ABILITY_HULL, TRACE_COLLISION_GROUP_PLAYER )
			DrawDebugSphereIfDebugging( airPos, 0, 255, 255 )
			DrawDebugSphereIfDebugging( airDownTrace.endPos, 255, 0, 255 )
			if ( airDownTrace.fraction < 1.0 )
			{
				TraceResults hullTrace = DoHullTraceForExit( mins, maxs, airDownTrace.endPos )

				if ( !hullTrace.startSolid && IsBreachPositionValid( player, hullTrace.endPos, hullTrace.hitEnt != null ? hullTrace.hitEnt : airDownTrace.hitEnt, eyeDir, airDownTrace.surfaceNormal ) )
				{
					possibleEndings.append( hullTrace.endPos )
				}
			}

			i++
			float nextStepDist = min( BACK_TRACE_STEP_DIST * i, BACK_TRACE_MAX_STEP )
			airTraceDist += nextStepDist
			airPos -= eyeDir * nextStepDist
		}
	}

	PortalEndingSortStruct end = GetBestEnding( possibleEndings, player,eyeDir, eyePos, info )
	return info
}


PhaseBreachTraceResults function DoEyeTrace( vector eyePos, vector eyeDir, float effectiveRange, array<entity> ignoredEntities, vector mins, vector maxs )
{
	PhaseBreachTraceResults eyeTraceResults

	                                                                                
	TraceResults initialTrace = TraceHull( eyePos, eyePos + (eyeDir * effectiveRange), <-5,-5,-5>, <5,5,5>, ignoredEntities, TRACE_MASK_ABILITY_HULL, TRACE_COLLISION_GROUP_PLAYER )
	eyeTraceResults.adjustedEndPos = initialTrace.endPos
	eyeTraceResults.results        = initialTrace

	DrawDebugSphereIfDebugging( initialTrace.endPos, 255, 0, 0 )

	if ( initialTrace.fraction < 1.0 )
	{
		if ( IsNormalMostlyVertical( initialTrace.surfaceNormal ) )
			eyeTraceResults.foundValidEnd = true
		else
			eyeTraceResults.adjustedEndPos = initialTrace.endPos - eyeDir * 30.0

		DrawDebugSphereIfDebugging( eyeTraceResults.adjustedEndPos, 150, 0, 0 )
	}

	if ( eyeTraceResults.foundValidEnd )
	{
		TraceResults hullTrace = DoHullTraceForExit( mins, maxs, eyeTraceResults.adjustedEndPos )

		if ( hullTrace.startSolid )
			eyeTraceResults.foundValidEnd = false
		else
			eyeTraceResults.adjustedEndPos = hullTrace.endPos
	}

	return eyeTraceResults
}


bool function IsBreachPositionValid( entity player, vector position, entity traceHitEnt, vector eyeDir, vector normal )
{
	if ( IsValid( traceHitEnt ) )
	{
		if ( traceHitEnt.IsPlayer() || traceHitEnt.IsNPC() || IsDeathboxFlyer( traceHitEnt ) )
			return false

		if ( traceHitEnt.GetScriptName() == CRYPTO_DRONE_SCRIPTNAME  )
			return false

		if ( traceHitEnt.IsProjectile() )
			return false

		entity pusher = GetPusherEnt( traceHitEnt )
		if ( pusher )
		{
			if ( ! file.allowEndOnMovers )
				return false

			if ( DEBUG_DRAW_PUSHER_MOVEMENT )
			{
				vector pusherVelAtPoint = pusher.GetAbsVelocityAtPoint(position)
				DebugScreenText( 0.1,0.6, "Pusher " + pusher + ", speed is " + Length(pusherVelAtPoint) + " , vel is " + pusherVelAtPoint )
			}

			if ( LengthSqr(pusher.GetAbsVelocityAtPoint(position)) > file.maxEndingMoverSpeedSqr )	                                                                                    
				return false
		}
	}

	vector eyePos = player.EyePosition()
	if ( DotProduct( eyeDir, Normalize( position - eyePos ) ) < PHASE_BREACH_MIN_VIEW_DOT )
		return false

	if ( !IsNormalMostlyVertical( normal ) )
		return false

	foreach ( entity trigger in GetTriggersByClassesInRealms_HullSize(
		file.invalidTriggerEndingTypes,
		position, position,
		player.GetRealms(), TRACE_MASK_PLAYERSOLID,
		player.GetPlayerMins(), player.GetPlayerMaxs() ) )
	{
		return false
	}

	TraceResults eyeToDownTrace = TraceLine( eyePos, position + <0, 0, 48.0>, [player], TRACE_MASK_ABILITY, TRACE_COLLISION_GROUP_PLAYER )
	if ( eyeToDownTrace.fraction < 1.0 )
		return false

	return true
}


bool function IsNormalMostlyVertical( vector normal )
{
	if ( DotProduct( normal, <0, 0, 1> ) > 0.71 )	                                                   
		return true

	return false
}


TraceResults function DoHullTraceForExit( vector mins, vector maxs, vector pos, float zClearance = 12.0 )
{
	return TraceHull( pos + <0, 0, zClearance>, pos, mins, maxs, null, TRACE_MASK_PLAYERSOLID, TRACE_COLLISION_GROUP_NONE )
}

struct PortalEndingSortStruct
{
	vector pos
	float  val = -1.0
}

PortalEndingSortStruct function GetBestEnding( array<vector> possibleEndings, entity player, vector eyeDir, vector eyePos, PhaseBreachTargetInfo info )
{
	array<PortalEndingSortStruct> endings
	foreach ( vector pos in possibleEndings )
	{
		PortalEndingSortStruct end
		end.pos = pos
		float length = Length( pos - eyePos )
		float dot = DotProduct( eyeDir, ( pos - eyePos ) / length )
		                                                    
		end.val = ( dot - PHASE_BREACH_MIN_VIEW_DOT ) * ( length + 500.0 )	                                                                             
		endings.append( end )

		if ( DEBUG_DRAW_ENDING_SCORES )
			DebugDrawText( end.pos, string( end.val ), false, 0.01 )
	}

	endings.sort( SortEndingStruct )


	foreach ( ending in endings )
	{
		bool success = GenerateBreachPathInfo( player, info, ending.pos )

		if ( success )
		{
			info.portalQuality = ending.val
			return ending
		}
	}

	PortalEndingSortStruct emptyEnding
	return emptyEnding
}


int function SortEndingStruct( PortalEndingSortStruct a, PortalEndingSortStruct b )
{
	if ( a.val > b.val )
		return -1
	else if ( b.val > a.val )
		return 1

	return 0
}


bool function GenerateBreachPathInfo( entity player, PhaseBreachTargetInfo info, vector endPos )
{
	                                                                                                                                                                             
	                                                                                                                                 
	if ( !PhaseTunnel_IsPortalExitPointValid( player, endPos, player, true, false ) )
		return false

	vector portalDir = Normalize( endPos - info.startPos )
	float distCheck  = Distance( info.startPos, endPos )

	if ( info.posList.len() > 0 )
		info.posList.clear()

	info.posList.append( info.startPos )

	while ( info.pathDistance < distCheck )
	{
		float step = min( TUNNEL_STEP_DIST, distCheck - info.pathDistance )

		vector newPos = info.startPos + (portalDir * step)
		info.pathDistance += step
		info.posList.append( newPos )
		info.startPos     = newPos
	}

	info.posList[ info.posList.len() - 1 ] = endPos
	info.finalPos   = endPos

	bool successful = (info.posList.len() > 2) && info.pathDistance > 200.0

	#if CLIENT
		if ( successful )
			DrawDebugSphereIfDebugging( info.finalPos, 0, 0, 255 )
	#endif

	return successful
}


void function DrawDebugSphereIfDebugging( vector origin, int r, int g, int b )
{
	#if DEV
		if ( DEBUG_DRAW_PLACEMENT_TRACES )
			DebugDrawSphere( origin, 5.0, <r, g, b>, false, 0.1 )
	#endif
}


#if CLIENT
void function PhaseBreachPlacement( entity weapon )
{
	Signal( weapon, SIGNAL_PHASE_BREACH_STOP_PLACEMENT )

	weapon.EndSignal( SIGNAL_PHASE_BREACH_STOP_PLACEMENT )
	weapon.EndSignal( "OnDestroy" )

	entity player = weapon.GetWeaponOwner()
	player.EndSignal( "OnDeath" )

	OnThreadEnd(
		function() : ()
		{
			if ( EffectDoesExist( file.targetingFxHandle ) )
				EffectStop( file.targetingFxHandle, true, true )

			if ( file.targetingHint != "'" )
				HidePlayerHint( file.targetingHint )
		}
	)

	int fxID           = GetParticleSystemIndex( BREACH_TARGET_FX )

	while ( true )
	{
		if ( !IsValid( player ) )
			return

		PhaseBreachTargetInfo info
		if ( player in file.portalTargetTable )
			info = file.portalTargetTable[ player ]
		else
			info = GetPhaseBreachTargetInfo( player )

		if ( info.portalQuality > 0 )
		{
			if ( !EffectDoesExist( file.targetingFxHandle ) )
			{
				file.targetingFxHandle = StartParticleEffectInWorldWithHandle( fxID, info.finalPos, <0,0,0> )
				EffectSetControlPointVector( file.targetingFxHandle, 1, TEAM_COLOR_FRIENDLY )
			}
			EffectSetControlPointVector( file.targetingFxHandle, 0, info.finalPos )
			HidePlayerHint( file.targetingHint )
			file.targetingHint = ""
		}
		else
		{
			if ( EffectDoesExist( file.targetingFxHandle ) )
			{
				EffectStop( file.targetingFxHandle, true, false )
			}

			file.targetingHint = PLACEMENT_FAILED_HINT
			AddPlayerHint( 60.0, 0, $"", file.targetingHint )
		}

		WaitFrame()
	}
}
#endif