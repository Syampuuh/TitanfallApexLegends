untyped

global function MpWeaponTrophy_Init
global function OnWeaponAttemptOffhandSwitch_weapon_trophy_defense_system

global function OnWeaponActivate_weapon_trophy_defense_system
global function OnWeaponDeactivate_weapon_trophy_defense_system
global function OnWeaponPrimaryAttack_weapon_trophy_defense_system

#if SERVER
                                             
                                         
                                         
                                                    
                                              
                                               
                                                 
#endif

#if CLIENT
global function SCB_WattsonRechargeHint
global function OnCreateClientOnlyModel_weapon_trophy_defense_system
#endif

const vector TROPHY_RING_COLOR = <134, 182, 255>

                
const asset TROPHY_START_FX = $"P_wpn_trophy_loop_st"
const asset TROPHY_NO_SHIELDS_FX = $"P_trophy_no_shields"
const asset TROPHY_ELECTRICITY_FX = $"P_wpn_trophy_loop_1"
const asset TROPHY_INTERCEPT_PROJECTILE_SMALL_FX = $"P_wpn_trophy_imp_sm"                        
const asset TROPHY_INTERCEPT_PROJECTILE_LARGE_FX = $"P_wpn_trophy_imp_lg"
const asset TROPHY_INTERCEPT_PROJECTILE_CLOSE_FX = $"P_wpn_trophy_imp_lite"
const asset TROPHY_DAMAGE_SPARK_FX = $"P_trophy_sys_dmg"
const asset TROPHY_DESTROY_FX = $"P_trophy_sys_exp"
const asset TROPHY_COIL_ON_FX = $"P_wpn_trophy_coil_spin"
const asset TROPHY_PLAYER_TACTICAL_CHARGE_FX = $"P_wat_menu_coil_loop"
const asset TROPHY_PLAYER_SHIELD_CHARGE_FX = $"P_armor_3P_loop_CP"

const asset TROPHY_RANGE_RADIUS_REMINDER_FX = $"P_ar_edge_ring_gen"

#if CLIENT
const float TROPHY_COOLDOWN_DRAW_DIST_MIN = 200.0
const float TROPHY_COOLDOWN_DRAW_DIST_MAX = 3000.0
const asset TROPHY_PLACEMENT_RADIUS_FX = $"P_ar_edge_ring_gen"
#endif         

const float TROPHY_AR_EFFECT_SIZE = 768.0                                                                       

                                    
global const string TROPHY_SYSTEM_NAME = "trophy_system"
global const string TROPHY_SYSTEM_MOVER_NAME = "trophy_system_mover"

                     
const TROPHY_TARGET_EXPLOSION_IMPACT_TABLE = "exp_medium"

                   
const asset TROPHY_MODEL = $"mdl/props/wattson_trophy_system/wattson_trophy_system.rmdl"

               
const string TROPHY_PLACEMENT_ACTIVATE_SOUND = "wattson_tactical_a"
const string TROPHY_PLACEMENT_DEACTIVATE_SOUND = "wattson_tactical_b"

const string TROPHY_EXPAND_SOUND = "Wattson_Ultimate_E"
const string TROPHY_EXPAND_ENEMY_SOUND = "Wattson_Ultimate_E_Enemy"
const string TROPHY_ELECTRIC_IDLE_SOUND = "Wattson_Ultimate_F"
const string TROPHY_TACTICAL_CHARGE_SOUND = "Wattson_Ultimate_G"

const string TROPHY_INTERCEPT_BEAM_SOUND = "Wattson_Ultimate_H"
const string TROPHY_INTERCEPT_LARGE = "Wattson_Ultimate_I"
const string TROPHY_INTERCEPT_SMALL = "Wattson_Ultimate_J"
const string TROPHY_DESTROY_SOUND = "Wattson_Ultimate_K"
const string TROPHY_SHIELD_REPAIR_START = "Wattson_Ultimate_L"
const string TROPHY_SHIELD_REPAIR_END = "Wattson_Ultimate_N"

                       
const float TROPHY_PLACEMENT_RANGE_MAX = 94
const float TROPHY_PLACEMENT_RANGE_MIN = 64
const float TROPHY_PLACEMENT_SPACING_MIN = 64
const float TROPHY_PLACEMENT_SPACING_MIN_SQR = TROPHY_PLACEMENT_SPACING_MIN * TROPHY_PLACEMENT_SPACING_MIN
const vector TROPHY_BOUND_MINS = <-32, -32, 0>
const vector TROPHY_BOUND_MAXS = <32, 32, 72>
const vector TROPHY_PLACEMENT_TRACE_OFFSET = <0, 0, 94>
const float TROPHY_PLACEMENT_MAX_GROUND_DIST = 12.0

                          
const vector TROPHY_INTERSECTION_BOUND_MINS = <-16, -16, 0>
const vector TROPHY_INTERSECTION_BOUND_MAXS = <16, 16, 32>

                    
const int TROPHY_DEPLOY_COUNT = 3
const float TROPHY_ANGLE_LIMIT = 0.74
const float TROPHY_DEPLOY_DELAY = 1.0

                   
const int TROPHY_HEALTH_AMOUNT = 150
const float TROPHY_DAMAGE_FX_INTERVAL = 0.25

                                               
const float WATTSON_TROPHY_CHARGE_POPUP_COOLDOWN = 3.5

                           
const float TROPHY_SHIELD_REPAIR_INTERVAL = 0.5
const int TROPHY_SHIELD_REPAIR_AMOUNT = 1
const int TROPHY_DEPLOY_COUNT_UPDATE = 1
const float TROPHY_SHIELD_REPAIR_INTERVAL_UPDATE = 0.2
const int TROPHY_SHIELD_REPAIR_AMOUNT_UPDATE = 1
const float TROPHY_SHIELD_DAMAGED_DELAY = 1.0
const float TROPHY_LOS_CHARGE_TIMEOUT = 1.0
const asset TACTICAL_CHARGE_FX = $"P_player_boost_screen"                      

                           
const float TROPHY_REMINDER_TRIGGER_RADIUS = 300.0
const float TROPHY_REMINDER_TRIGGER_DBOUNCE = 30.0
const float TROPHY_REMINDER_DURATION = 1.0
const float TROPHY_REMINDER_TRIGGER_DBOUNCE_UPDATE = 5.0
const float TROPHY_REMINDER_DURATION_UPDATE = 3.0

                      
const bool TROPHY_DEBUG_DRAW = false
const bool TROPHY_DEBUG_DRAW_PLACEMENT = false
const bool TROPHY_DEBUG_DRAW_INTERSECTION = false

const int TROPHY_SHIELD_AMOUNT = 250

#if CLIENT
const float TROPHY_ICON_HEIGHT = 96.0
#endif         

global enum eTrophySystemIgnores
{
	none = 0,
	friendlyOnly = 1,
	enemyOnly = 2,
	always = 3,
	allowBounce = 4
}

struct TrophyPlacementInfo
{
	vector origin
	vector angles
	entity parentTo
	bool   success = false
}

struct HealData
{
	entity healTarget
	int    healResourceID
}

struct TrophyShieldData
{
	int healResource = 1
	array<entity> healTargets = []
	array<int> statusEffectHandles = []
}

#if SERVER
                       
 
	             
 
#endif         


struct
{
	#if SERVER
		                                                    
		                                                    
		                       					                 
		                                                      
		                                                                
		                                                                      
		                                                              
		                                                          
		                                                               
		                                                               
		                                                                       
	#else
		int tacticalChargeFXHandle
	#endif

	float trophy_interceptProjectileRange
	float trophy_interceptProjectileRangeMin
	float trophy_interceptProjectileRangeSqr
	float trophy_interceptProjectileRangeMinSqr
	int   trophy_maxCount
	int trophy_shieldPoolAmount
	int trophy_shieldRegenAmount
	float trophy_shieldRegenInterval
	float trophy_shieldRegenDelayOnDamage
} file

function MpWeaponTrophy_Init()
{
	PrecacheParticleSystem( TROPHY_START_FX )
	PrecacheParticleSystem( TROPHY_ELECTRICITY_FX )
	PrecacheParticleSystem( TROPHY_INTERCEPT_PROJECTILE_SMALL_FX )
	PrecacheParticleSystem( TROPHY_INTERCEPT_PROJECTILE_LARGE_FX )
	PrecacheParticleSystem( TROPHY_INTERCEPT_PROJECTILE_CLOSE_FX )
	PrecacheParticleSystem( TROPHY_DAMAGE_SPARK_FX )
	PrecacheParticleSystem( TROPHY_DESTROY_FX )
	PrecacheParticleSystem( TROPHY_COIL_ON_FX )
	PrecacheParticleSystem( TROPHY_PLAYER_TACTICAL_CHARGE_FX )
	PrecacheParticleSystem( TROPHY_PLAYER_SHIELD_CHARGE_FX )
	PrecacheParticleSystem( TROPHY_RANGE_RADIUS_REMINDER_FX )
	PrecacheParticleSystem( TROPHY_NO_SHIELDS_FX )

	file.trophy_interceptProjectileRange = GetCurrentPlaylistVarFloat( "wattson_trophy_interceptProjectileRange", 512.0 )
	file.trophy_interceptProjectileRangeMin = GetCurrentPlaylistVarFloat( "wattson_trophy_interceptProjectileRangeMin", 498.0 )

	file.trophy_maxCount = GetCurrentPlaylistVarInt( "wattson_trophy_max_count", TROPHY_DEPLOY_COUNT )
	PrecacheParticleSystem( TROPHY_NO_SHIELDS_FX )
	file.trophy_shieldPoolAmount 			= GetCurrentPlaylistVarInt( "wattson_trophy_shieldPoolAmount", TROPHY_SHIELD_AMOUNT )
	file.trophy_shieldRegenAmount 			= GetCurrentPlaylistVarInt( "wattson_trophy_shieldRegenAmount", TROPHY_SHIELD_REPAIR_AMOUNT_UPDATE )
	file.trophy_shieldRegenInterval 		= GetCurrentPlaylistVarFloat( "wattson_trophy_shieldRegenTick", TROPHY_SHIELD_REPAIR_INTERVAL_UPDATE )
	file.trophy_shieldRegenDelayOnDamage	= GetCurrentPlaylistVarFloat( "wattson_trophy_shieldRegenDelayOnDamage", TROPHY_SHIELD_DAMAGED_DELAY )
	file.trophy_maxCount 					= GetCurrentPlaylistVarInt( "wattson_trophy_max_count", TROPHY_DEPLOY_COUNT_UPDATE )

	file.trophy_interceptProjectileRangeSqr = file.trophy_interceptProjectileRange * file.trophy_interceptProjectileRange
	file.trophy_interceptProjectileRangeMinSqr = file.trophy_interceptProjectileRangeMin * file.trophy_interceptProjectileRangeMin
	#if SERVER
		                                                                 
		                                 
		                                                     
		                                           
		                                                                         

		                                                                       
		                                                                   

		                                                    
	#endif         

	#if CLIENT
		PrecacheParticleSystem( TACTICAL_CHARGE_FX )
		PrecacheParticleSystem( TROPHY_PLACEMENT_RADIUS_FX )

		RegisterSignal( "Trophy_StopPlacementProxy" )
		RegisterSignal( "EndTacticalChargeRepair" )
		RegisterSignal( "EndTacticalShieldRepair" )
		RegisterSignal( "UpdateShieldRepair" )

		StatusEffect_RegisterEnabledCallback( eStatusEffect.trophy_tactical_charge, TacticalChargeVisualsEnabled )
		StatusEffect_RegisterDisabledCallback( eStatusEffect.trophy_tactical_charge, TacticalChargeVisualsDisabled )

		StatusEffect_RegisterEnabledCallback( eStatusEffect.trophy_shield_repair, ShieldRepairVisualsEnabled )
		StatusEffect_RegisterDisabledCallback( eStatusEffect.trophy_shield_repair, ShieldRepairVisualsDisabled )

		AddCallback_OnWeaponStatusUpdate( Trophy_OnWeaponStatusUpdate )

		AddCreateCallback( PLAYER_WAYPOINT_CLASSNAME, OnWaypointCreated )
		AddCallback_MinimapEntShouldCreateCheck_Scriptname( TROPHY_SYSTEM_NAME, Minimap_DontCreateRuisForEnemies )

		RegisterMinimapPackage( "prop_script", eMinimapObject_prop_script.TROPHY_SYSTEM, MINIMAP_OBJ_AREA_RUI, MinimapPackage_TrophySystem, FULLMAP_OBJECT_RUI, FullmapPackage_TrophySystem )
	#endif         

	thread MpWeaponTrophyLate_Init()
}


void function MpWeaponTrophyLate_Init()
{
	WaitEndFrame()

	#if CLIENT
		AddCallback_OnEquipSlotTrackingIntChanged( "armor", ArmorChanged )
	#endif         
}


void function OnWeaponActivate_weapon_trophy_defense_system( entity weapon )
{
}


void function OnWeaponDeactivate_weapon_trophy_defense_system( entity weapon )
{
}


bool function OnWeaponAttemptOffhandSwitch_weapon_trophy_defense_system( entity weapon )
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


var function OnWeaponPrimaryAttack_weapon_trophy_defense_system( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	entity ownerPlayer = weapon.GetWeaponOwner()
	Assert( ownerPlayer.IsPlayer() )

	TrophyPlacementInfo placementInfo

	                       
	if ( !weapon.ObjectPlacementHasValidSpot() )
	{
		weapon.DoDryfire()
		return 0
	}

	#if SERVER
		                                                        
		                                                        
		                                                          
		                                                            

		                                                  
	#endif
	PlayerUsedOffhand( ownerPlayer, weapon, true, null, {pos = placementInfo.origin} )

	int ammoReq = weapon.GetAmmoPerShot()
	return ammoReq
}

  
                                                                                                            
                                                                                                             
                                                                                                             
                                                                                                              
                                                                                                             

  

TrophyPlacementInfo function Trophy_GetPlacementInfo( entity player, entity proxy )
{
	vector eyePos              = player.EyePosition()
	vector viewVec             = player.GetViewVector()

	TrophyPlacementInfo info = _GetPlacementInfo( player, proxy, eyePos, viewVec )

	if ( !info.success && player.IsStanding() )
	{
		TrophyPlacementInfo crouchInfo = _GetPlacementInfo( player, proxy, eyePos - <0,0,32>, viewVec, false )

		if ( crouchInfo.success )
			return crouchInfo
	}

	return info
}

TrophyPlacementInfo function _GetPlacementInfo( entity player, entity proxy, vector eyePos, vector viewVec, bool doUpTrace = true )
{
	vector angles              = < 0, VectorToAngles( viewVec ).y, 0 >
	array< entity > ignoreEnts = [player, proxy]

	float maxRange = TROPHY_PLACEMENT_RANGE_MAX

	TraceResults viewTraceResults = TraceLine( eyePos, eyePos + player.GetViewVector() * (TROPHY_PLACEMENT_RANGE_MAX * 2), ignoreEnts, TRACE_MASK_SOLID, TRACE_COLLISION_GROUP_NONE, player )
	if ( viewTraceResults.fraction < 1.0 )
	{
		float slope = fabs( viewTraceResults.surfaceNormal.x ) + fabs( viewTraceResults.surfaceNormal.y )
		if ( slope < TROPHY_ANGLE_LIMIT )
			maxRange = min( Distance( eyePos, viewTraceResults.endPos ), TROPHY_PLACEMENT_RANGE_MAX )
	}

	int collisionGroup 	= TRACE_COLLISION_GROUP_PLAYER
	int traceMask		= TRACE_MASK_NPCSOLID

	vector idealPos          = player.GetOrigin() + (AnglesToForward( angles ) * TROPHY_PLACEMENT_RANGE_MAX)
	vector defaultUpVector   = < 0, 0, 1.0 >
	TraceResults fwdResults  = TraceHull( eyePos, eyePos + viewVec * maxRange, TROPHY_BOUND_MINS, TROPHY_BOUND_MAXS, ignoreEnts, traceMask, collisionGroup, defaultUpVector, player )
	TraceResults downResults = TraceHull( fwdResults.endPos, fwdResults.endPos - TROPHY_PLACEMENT_TRACE_OFFSET, TROPHY_BOUND_MINS, TROPHY_BOUND_MAXS, ignoreEnts, traceMask, collisionGroup, defaultUpVector, player )
	TraceResults useResults  = downResults

	bool isScriptedPlaceable = false
	bool isUpTraced = false

	vector upStart	= ( fwdResults.endPos + viewVec * 60.0 ) + <0, 0, 40.0>
	vector upEnd	= upStart - <0, 0, 80.0>
	TraceResults upResults = TraceHull( upStart, upEnd, TROPHY_BOUND_MINS, TROPHY_BOUND_MAXS, ignoreEnts, traceMask, collisionGroup, <0, 0, 1>, player )

	vector roofTraceEnd = <eyePos.x, eyePos.y, upResults.endPos.z> + ( <viewVec.x, viewVec.y, 0> * 20.0 )
	TraceResults roofTraceResults = TraceLine( eyePos, roofTraceEnd, ignoreEnts, TRACE_MASK_SOLID, TRACE_COLLISION_GROUP_NONE, player )


	if ( doUpTrace && roofTraceResults.fraction >= 0.99 )
	{
		if ( IsValid( upResults.hitEnt ) )
			isScriptedPlaceable = Placement_IsHitEntScriptedPlaceable( upResults.hitEnt, 1 )

		if ( !upResults.startSolid && upResults.fraction < 1.0 && (upResults.hitEnt.IsWorld() || isScriptedPlaceable) )
		{
			useResults = upResults
			isUpTraced = true
		}
	}

	if ( TROPHY_DEBUG_DRAW_PLACEMENT )
	{
		DebugDrawBox( fwdResults.endPos, TROPHY_BOUND_MINS, TROPHY_BOUND_MAXS, COLOR_GREEN, 1, 1.0 )                                 
		DebugDrawBox( downResults.endPos, TROPHY_BOUND_MINS, TROPHY_BOUND_MAXS, COLOR_BLUE, 1, 1.0 )                                  
		DebugDrawLine( eyePos + viewVec * min( TROPHY_PLACEMENT_RANGE_MIN, maxRange ), fwdResults.endPos, COLOR_GREEN, true, 1.0 )                    
		DebugDrawLine( fwdResults.endPos, eyePos + viewVec * maxRange, COLOR_RED, true, 1.0 )                            
		DebugDrawLine( fwdResults.endPos, downResults.endPos, COLOR_BLUE, true, 1.0 )                     
		DebugDrawBox( upResults.endPos, TROPHY_BOUND_MINS, TROPHY_BOUND_MAXS, COLOR_CYAN, 1, 1.0 )                                  
		DebugDrawLine( upStart, upResults.endPos, COLOR_CYAN, true, 1.0 )                     
		DebugDrawLine( eyePos, roofTraceEnd, COLOR_MAGENTA, true, 1.0 )             
		DebugDrawLine( player.GetOrigin(), player.GetOrigin() + (AnglesToForward( angles ) * TROPHY_PLACEMENT_RANGE_MAX), COLOR_GREEN, true, 1.0 )                     
		DebugDrawLine( eyePos + <0, 0, 8>, eyePos + <0, 0, 8> + (viewVec * TROPHY_PLACEMENT_RANGE_MAX), COLOR_GREEN, true, 1.0 )                     
	}

	                                                           
	if ( !isUpTraced && IsValid( useResults.hitEnt ) )
		isScriptedPlaceable = Placement_IsHitEntScriptedPlaceable( useResults.hitEnt, 1 )

	bool success = isUpTraced || ( !useResults.startSolid && useResults.fraction < 1.0 && (useResults.hitEnt.IsWorld() || isScriptedPlaceable) )

	entity parentTo
	if ( IsValid( useResults.hitEnt ) && (useResults.hitEnt.GetNetworkedClassName() == "func_brush" || useResults.hitEnt.GetNetworkedClassName() == "script_mover") )
	{
		parentTo = useResults.hitEnt
	}

	if ( downResults.startSolid && downResults.fraction < 1.0 && (downResults.hitEnt.IsWorld() || isScriptedPlaceable) )
	{
		TraceResults hullResults = TraceHull( downResults.endPos, downResults.endPos, TROPHY_BOUND_MINS, TROPHY_BOUND_MAXS, ignoreEnts, TRACE_MASK_SOLID, TRACE_COLLISION_GROUP_NONE )
		if ( hullResults.startSolid )
			success = false
	}

	vector surfaceAngles = angles

	                        
	                                                                
	if ( !isUpTraced )
	{
		if ( success && !PlayerCanSeePos( player, useResults.endPos, true, 90 ) )
		{
			surfaceAngles = angles
			success = false
			                                                             
		}
	}

	              
	if ( success && viewTraceResults.hitEnt != null && (!viewTraceResults.hitEnt.IsWorld() && !isScriptedPlaceable) )
	{
		surfaceAngles = angles
		success = false
		  	                                                               
	}

	                                           
	if ( success && useResults.fraction < 1.0 )
	{
		surfaceAngles = AnglesOnSurface( useResults.surfaceNormal, AnglesToForward( angles ) )
		vector newUpDir = AnglesToUp( surfaceAngles )
		vector oldUpDir = AnglesToUp( angles )

		                   
		proxy.SetOrigin( useResults.endPos )
		proxy.SetAngles( surfaceAngles )

		vector right   = proxy.GetRightVector()
		vector forward = proxy.GetForwardVector()

		float length = Length( TROPHY_BOUND_MINS ) / 1.5
		length = length / 1.5

		array< vector > groundTestOffsets = [
			Normalize( right * 2 + forward ) * length,
			Normalize( -right * 2 + forward ) * length,
			Normalize( right * 2 + -forward ) * length,
			Normalize( -right * 2 + -forward ) * length
		]

		if ( TROPHY_DEBUG_DRAW_PLACEMENT )
		{
			DebugDrawLine( proxy.GetOrigin(), proxy.GetOrigin() + (right * 64), COLOR_GREEN, true, 1.0 )                      
			DebugDrawLine( proxy.GetOrigin(), proxy.GetOrigin() + (forward * 64), COLOR_BLUE, true, 1.0 )                        
		}

		                                                 
		foreach ( vector testOffset in groundTestOffsets )
		{
			vector testPos           = proxy.GetOrigin() + testOffset
			TraceResults traceResult = TraceLine( testPos + (proxy.GetUpVector() * TROPHY_PLACEMENT_MAX_GROUND_DIST), testPos + (proxy.GetUpVector() * -TROPHY_PLACEMENT_MAX_GROUND_DIST), ignoreEnts, traceMask, collisionGroup )

			if ( TROPHY_DEBUG_DRAW_PLACEMENT )
				DebugDrawLine( testPos + (proxy.GetUpVector() * TROPHY_PLACEMENT_MAX_GROUND_DIST), traceResult.endPos, COLOR_RED, true, 1.0 )                   

			if ( traceResult.fraction == 1.0 )
			{
				surfaceAngles = angles
				success = false
				                                                                    
				break
			}
		}

		                     
		if ( success && DotProduct( newUpDir, oldUpDir ) < TROPHY_ANGLE_LIMIT )
		{
			                        
			success = false
			                                                        
		}
	}

	                           
	if ( success && IsValid( useResults.hitEnt ) && IsEntInvalidForPlacingPermanentOnto( useResults.hitEnt ) )
		success = false

	if ( success && IsOriginInvalidForPlacingPermanentOnto( useResults.endPos ) )
		success = false


	if( success )
	{
		TraceResults playerResults = TraceHull( useResults.endPos, useResults.endPos, TROPHY_BOUND_MINS, TROPHY_BOUND_MAXS, [proxy], TRACE_MASK_SOLID, TRACE_COLLISION_GROUP_NONE, defaultUpVector, player  )
		if( IsValid( playerResults.hitEnt ) && playerResults.hitEnt.IsPlayer() )
			success = false
	}

	TrophyPlacementInfo placementInfo
	placementInfo.success = success
	placementInfo.origin = useResults.endPos
	placementInfo.angles = surfaceAngles
	placementInfo.parentTo = parentTo

	return placementInfo
}


entity function Trophy_CreateTrapPlacementProxy( asset modelName )
{
	#if SERVER
		                                                                   
	#else
		entity proxy = CreateClientSidePropDynamic( <0, 0, 0>, <0, 0, 0>, modelName )
	#endif
	proxy.EnableRenderAlways()
	proxy.kv.rendermode = 3
	proxy.kv.renderamt = 1
	proxy.Anim_PlayOnly( "prop_trophy_idle_closed" )
	proxy.Hide()

	return proxy
}

#if CLIENT
void function SCB_WattsonRechargeHint()
{
	if ( !IsAlive( GetLocalClientPlayer() ) )
		return

	CreateTransientCockpitRui( $"ui/wattson_ult_charge_tactical.rpak", HUD_Z_BASE )
}

void function OnCreateClientOnlyModel_weapon_trophy_defense_system( entity weapon, entity model, bool validHighlight )
{
	model.Anim_PlayOnly( "prop_trophy_idle_closed" )

	if ( validHighlight )
		DeployableModelHighlight( model )
	else
		DeployableModelInvalidHighlight( model )
}
#endif         

  
                                                                                                                                        
                                                                                                                                         
                                                                                                                                       
                                                                                                                                        
                                                                                                                                         
                                                                                                                                        
  

#if SERVER
                                                                              
 
	                              

	                                
	                                                          

	                                    
	                                    

	                       
	                                                                                   
	                                                     
	                                                                 
	                    
	                        
	                             
	                                        
	                                  
	                           
	                                           
	                                        
	                                      
	                                     
	                                     
	                                       
	                                          
	                                           
	                                     
	                                                                                      
	                                                                                                          
	                                                                                                                                          
                
                   
                                                
       

	                                                          

	                                                                        
	                      
	                                                
	                                 

	                             
	                                                         
	                                             
	                                   

	                         
	                        

	                                                                             
		                   
	    
		                  

	                                                                                                                                              

                 
                                 
       

	                       
	                                   
	                                                                                 

	                                                                         
	                                                   

	                                                                                                                                                                         
	                                                                                    

	                                                                                        
	                                      
	                           

	                                                 
	                               

	                                                             
	                                                                     

	                                                     
	                                                        
	                                                        

	                                                                 
	                                        
	                                                     

	                                      
	                                       

	            
	                                     
	 
		                                                                     
		                                         
		                         
	 
	    
	 
		              
	 

	            
		                                     
		 
			                       
			 
				                                                                   
				 
					                                               
					 
						                                       
					 
				 
			 

			                                  
			 
				                                  
				 
					                                             
						                                     

					                                  
				 

				                                    

				                                     
				                                           
				                                 
				                
			 

			                       
				               
		 
	 

	                                               

	                                                 

	                      
	                                                      
	                                     

	         

	                        
		      

	                                                                       
	                                                                                

	                                           
	                               

	                                                                                                     
	                        
		      

	                                                         
	                       

	                                                   
	                                       
	                           
	                          
	                                                                 
	                             
	                             
	                                      

	                        

	                                                                                                                                    
	                                                       
	                                      

	                                    
	                                    

	                                                 

	                                                              
	                                                                  
	                                                                                                                       

	                                                        
	                                                        
	                                                               

	                                                                                                                     
	                                                                                                                      

	                                                 
	                                   
	                                                              
	                                            
	                                                 
	                         

	                         
	                                                           
	                                           
	                                               
	                                   
	                                  
	                                                                   
	                                                                
	                                                                
	                                              
	                                              

	                                

	                                                                                                                                    
	                                  
	                                                              
	                                                              
	                                                                 
	                                            
	                                            

	            
		                                                                                 
		 
			                         
				                 

			                                 
			 
				                                                     
				                                                           
				                         
			 

			                        
				                    

			                        
				                    

			                         
				                     

			                        
				                
		 
	 

	                                               
	                                                                                                                  
	 
		                                                      
		                             
			                     
	 

	                
	                                                          
	                                                             
	                                                                                        

	                                            

	             
 

                                                                  
 
	                                                      
		        

	                                                   
 

                                                                              
 
	                                                      
		                                                 

	                                                    
 

                                                                         
 
	                      
		      

	                                
	                                         
		      

	                                                             
 

                                                                                  
 
	                                
	                                        

	                       
	                                                   
	                                            
	                                                    
	                                             

	                                   
	 
		                                                            
		                                           
			                    

		                                                       
		 
			                                                  
			 
				                                                                          
				 
					                                                                         
					                                                                                                                                
					                                                                                                             
					                                                       
					                                           
					                                               
					                  
				 

				                                                    
			 
			    
			 
				                                                                         
				                                                                                                                                
				                                                                                                             
				                                                       
				                                           
				                                               
				                  

				                                                     
			 

			      
		 

		           
	 
 

                                                          
 
	                                   
	 
		                              
			        

		                                                                                        
			           
	 
	            
 

                                                                                        
 
	                                   
	 
		                                
			        

		                                                                              
			        

		                                                                                                    
			                   
	 
	           
 

                                                               
 
	                                   
		        

	                                                                                                             
 

                                                       
 
	                                                           
	 
		                               
			                          
	 
	           
 

                                                                               
 
	                                                   
		            

	                                                         
	                   
	                                             
	 
		                             
		 
			                      
			     
		 
	 

	                                                                                           
	 
		                                       
		                                                                          
		 
			                                                      
			                                                 
			                                         
			                    
			                                                
			                                                                           
			           
		 
	 

	            
 

                                                                           
                                                                    
 
	                                            
		            

	                                                         
	                   
	                                             
	 
		                             
		 
			                      
			     
		 
	 

	                              
	 
		                                       
		                                                            
		 
			                                               
			                                          
			                                  
			             
			                                                
			                                                                           
			           
		 
	 

	            
 

                                                                       
 
	                      
		      

	                                          
	                                               
		                                           

	                                                                                     
	                                            
		                                       

	                                                           
	                                           

	                                                                                                                        
	                                                             
		                                                   

	                                                                                     
	                                                             
		                                                   
 

                                                                                   
 
	                                                
	                                                              
	                                 

	                                                                                                                                                       
	                                               
	                                                               
		      

	                        
	                                                    

	                                  

	                         
		      

	                         
		      

	                               

	            
		                                                  
		 
			                        
			 
				                                                           
				 
					                                    
					                                                                           
					                                                    
				 

				                                                                                              
				                                                                                           
				 
					                
					                                                                 
					 
						                               
							        

						                                                                                                                      
						 
							                                    
							                                                                                                               
							     
						 
					 

					                           
						                                                     
				 
			 

			                                            
			 
				                                                                 
				                                                       
					                                            
			 

			                                           
			 
				                                                                 
				                                                      
					                                           
			 
		 
	 

	                       
	              
	 
		                                    
		 
			        
			                                    
				      
		 

		                                                                                      

		                                             
		 
			                                               	                                          
			                                                                                                                                                                 
			                                                                                                                                                                                                                       
			 
				                                           
				                                                                    
			 
			                    
		 

		                                                                              
		 
			                                                           
			 
				                             
				                                                                                                                             
			 
		 
		                                                                
		 
			                             
			                                                                                           
			 
				                                                     
			 
			                                                                           
			                                                   
		 

		           
	 
 

                                                                  
 
	                                                
	                                                                                                                     

	                                                                   

	                                 
		      

	                                                       
	                                           
		      

	                                                             
	                                                              
	                                                                              

	                                              
	 
		                 
		      
	 

	                                                                                                                    
	                                                                                
	                         

	                                                                                                                      
	                                                                                 
	                          

	            
		                                        
		 
			                        
			 
				                        
					                

				                         
					                 
			 
		 
	 

	             
 

                                                                   
 
	                                                              
	                                 

	                         
		      

	                                                              
	                                               
	                                                               
		      

	                                  

	                         
		      

	                        
	                                                  
	                             

	            
		                                          
		 
			                        
			 
				                                                                  
				 
					                                                         
						                                                     
				 

				                                                    
				                                                         
					                                                                         

				                                  
				                                                                  
				 
					                                          
					 
						                                                                         
						     
					 
				 
			 

			                                            
			 
				                                                                 
				                                                       
					                                            
			 
		 
	 

	                                

	                                                          

	                                 

	                       
	                            
	                             
	              
	 
		           

		                                    
		 
			        
			                                    
				      
		 

		                                                             

		                                                                                                
		 
			                    

			                                                        
			 
				                                    
				 
					                                                         
					 
						                                                     
						                                                    
					 
				 

				                       
				 
					                                                         
						                                                                         
					                        
				 

				        
			 

			                                                                        
			 
				                  
				                                    
				 
					                                                          
					 
						                                                  
						                                                            
							                    
					 
				 

				                    
				 
					                                                    

					                                                                                                    
					 
						                                                                  
						                                                      
					 
				 
			 

			                                                                                                                                             
			 
				                                                  
				 
					                                                                  
					 
						                                          
						 
							                                                                         
							     
						 
					 

					                       
					 
						                                                         
							                                                                         
						                        
					 

					        
				 

				                                                                           
				                                             

				                                     
				 
					                                                         

					                                                                                                                                
					                                                  
					 
						                                                      

						                                                    
						 
							                                                                   
								        

							                                                           
							                                                                  
							 
								                                                    
								 
									                                                                         
									     
								 
							 

							                                                     
								                                                                        
								                                                                                                                                
							 
						 
					 
				 
				                             

				                                 
				 
					                                 
					 
						                                          
						                             
					 
					                                                    
					                                                  

					                                                                                                          
					                                                                

					                       
					 
						                                                                                              

						                                         
						                                                                                 
					 

					                        
					 
						                       
						                                                                                                                         
					 

					                                                                  
				 

			 
			                            
			 
				                                                         
					                                                                         
				                        

				                                                               
				                           
			 
		 
	 
 

                                                                                             
 
	                                                                                
	 
		                                          
		 
			                                                                                             
			                 
				                                                                                      
		 

		                                             
		                                                      
	 
	    
	 
		                                          
			                                          

		                                                                
		                 
			                                                         
	 
 

                                                       
 
	                                   
		        

	                                                  
 

                                                                    
 
	                                                                                    

	                                                                       

	                        
	 
		                                 
		                                
                              
                                                     
      
		                                            
			      

		        
			     
	 

	                                           
	                                                                               
 

                                                                          
 
	                             

	                                                                   
	                                                                   

	                                                                                                  
		                                       

	                     
 

                                                                  
 
	                                         
		            

	                                                                                 
		            

	                                              
 

                                                                   
 
	                                                           
	                                                           

	                                                       
	                                                                                     
	                                                                                                                                                      
	                                                                          

	                                                                                                                                            

	                             
	 
		                           
			           
	 

	                                                          
	                           

	                                
		                     
		                                                          
		                                                                                            
		                                                                                             
		                             
	 

	                                                 
	                                        
	 
		                               
		                              

		                                                                                                                                           

		                        
		 
			                                                                    
			                                                                        
		 

		                                   
			           
	 


	            
 

                                                             
 
	                                                 
	                               

	              
	 
		                                                 
		                           

		                                                                  
		                                                 

		                                                                                                                                                                                      

		                                     
		 
			                                                                                                                                                    
		 

		                              

		                         
		 
			                              
			                        
			 
				                                              

				                                                                                                                                                                                                          
				 
					                                 
					                
				 
			 
		 

		         
	 
 


                                                          
 
	                                                 
	                               

	                                                             
	                                                                    

	                                
	                                                                                       
	                                
	                                                     

	                                                  
	                           
	                                                             
	                                                             
	                                
	                                             
	                                             
	                                 
	                                       
	                                       

	                                               
	                                          
	                                
	                             

	                             
	                                   
		                                                     

	                                

	                                                          
	                     
	                    
	                                       

	                                                                                                                     
	                                                                                                            
	                                                 
	                                                                                           
	                                                                                                   

	                             
	                                                                                                                 

	                                              

	            
		                             
		 
			                              
			 
				                                      
				                      
			 
		 
	 

	             
 

                                                            
 
	                                                  

	                 
		      

	                                

	                                                                 
	                                  
	                                  
	                                 
	                             
	                             
	                                   
	                                  
	                                
	                      
	                              
	                                          

	            
		                   
		 
			            
		 
	 

	                                    
	 
		                                                              
		           
	 

	             
 

                                                                              
 
	                                                                         

	                 
		      

	                                     
	                               

	                                                                 
	                                  
	                                  
	                             
	                             
	                                   
	                                  
	                                
	                      
	                              
	                                          

	            
		                   
		 
			            
		 
	 

	                                                                                            

	                        
		                             

	                                    
	 
		                                                    
		                                                 
		                                                  
	 

	        

	                                 

	                
 

                                           
 
	                           

	              
	 
		                                                                                              
		 
			                                                  
			                                                  
			        
		 
		           
	 
 

                                                                         
 
	                                                                                   

	                 
	 
		                                                         
		      
	 

	                                     
	                               

	                                                                                         
	 
		                                                    
	 

	                                                                  
	                                  
	                                  
	                                   
	                                           
	                                  
	                              
	                                
	                      

	            
		                   
		 
			            
		 
	 

	          

	                                 

	                
 

                                                                                                   
 
	                                       
	      
 

                                                                                                                                              
 
	                                           
	                                                       
	                                   

	                         
		      

	                             
		      

	                              
	                                            
		      

	                                   
	                                
		      

	                                     
	                                                     

	                                                            
	                                                                       
		      

	                                       
	                                                              
	 
		                                                      
		                                                 
		                                         
		                    
		                                                
		                                                                           
	 
 

                                                                      
 
	                                                

	                                                        

	                                            

	                          
		      

	                                                      
	                                           

	                                                                

	                                                  
	                                                                                

	                                        
	                          

	                                                      
	                                    
	                       

	                                   
	 
		                                               
	 

	            
		                        
		 
			                        
				                
		 
	 

	        
 

                                                                        
 
	                                                
	                                                                       
	                                                          
		                                           

	                                
	 
		                                                                                             
		                                                                                               
	 

	                                           
 

                                                       
 
	                                
	 
		                                                                                             
		                                                                   
	 

	                             
 

                                                                                                  
 

	                                                                                             
	                                   
		             

	                                                               
		            

	                                        

	                                                                                    
	                                                                            
	            
		           
	                                                                                        
		            

	                                                                              
	                                                                             
	                                                              
	 
		                                                                  
		                                                   
	 
	    
	 
		                                                                                                                 
		                                                             
		 
			                                                                  
			                                                   
		 
	 

	                                                
	                                                                             
	                                                 
	                                           

	                                                                                               
	                                                           
	                                                           
	                                                                  

	                        
	 
		                                                                                                
		                                                                                                   
	 

	                                                         
	                                                    
	                                                   
	  	                                  
	  	                       
	  	                             


	                                                                                                                                                     
	                                                            
	                    
	                                                                            
	 
		                          
		                    
		                                                                                                                                                                                                               

		                                  
		 
			                        
				                                                                             

			                                                                                                               
			                                                          
			                                          
				              

			                                                                        
			                                                                 
				            

		 
		    
		 
			            
		 
	 

	                                                                                      
	                                     
		               

	                     
	                
	                                                                                                                                                 

	                                         
	 
		                                      
			               
			     

		                               
		        
			           
			     
	 

	           
 

                                                                                    
 
	                                                                                      
	                                     
		               

	                                                                                            

	                                                                  
	   	                                                                                                       
	   	                                                                                                     
	 
	 
		           
	 

	            
 

                                                                                      
 
	                                                
	                                        
	                               

	                                                                                                                                                       
	                              

	                        
	 
		                                                                 
		                                                                     
	 

	                              
		           

	            
 

                                                                                                 
 
	                                                     
	          
		                           
		                                
		                                 
		            
		                      
		                    
		                    
		                                        
		                                       
		                      
		                                           
		                                                                     
		                                                    
 

                                                      
 
	                                                                
	                                                               
	                                                                          

	                                                                  
	                                                             
	                                                                                                                                                                            
	                        
	 
		                        
		                                    
	 
 

                                                   
 
	                                                                       
	                                                             

	                                   
		      

	                                                                                                                          

	                                                           
 

                                                                     
 
	                          

	                                                      
	
	                           
		      

	                                   
	                                                        
	                            
		      

	                                                                       
	                                        
	                                                                                                                                          
	                                                                                                                                                                                      

	                                                                                
	 
		                                       
		      
	 

                 
                              
                                                                               
       
 

                                                                         
 
	                                                      

	                           
		      

	                                   
	                                     

	                                                        
	                            
		      

	                         
		      

	                                                 

	                  
		      

	                                       

	                                     
	                                  

	                                             

	                       
		                                                                                                                                             

	                                        

	                              
	                                                                
	                                                                             
	 
		                              
		                                        
	 

	                                                              

	                                                        
	 
		                                                                                                                              
			                                                                
			                                                                                                                            
	 
	                             
 

                                                     
 
	                                                                   
	 
		                                                                             

		                               
			      

		                                                                             
			      
		                                             
	 
	    
	 
		                                                
		      
	 

	                                                                              
	                                   
 
#endif         


#if CLIENT
void function Trophy_OnWeaponStatusUpdate( entity player, var rui, int slot )
{
	if ( slot != OFFHAND_TACTICAL )
		return

	entity weapon = player.GetOffhandWeapon( slot )
	if ( !IsValid( weapon ) )
		return

	bool activeSuperChargeApplied = weapon.HasMod( "interception_pylon_super_charge" )
	RuiSetBool( rui, "rechargeBoosted", activeSuperChargeApplied )
}
#endif


#if CLIENT
void function TacticalChargeVisualsEnabled( entity ent, int statusEffect, bool actuallyChanged )
{
	if ( ent != GetLocalViewPlayer() )
		return

	entity player = ent

	entity cockpit = player.GetCockpit()
	if ( !IsValid( cockpit ) )
		return

	thread TacticalChargeFXThink( player, cockpit )
}

void function TacticalChargeVisualsDisabled( entity ent, int statusEffect, bool actuallyChanged )
{
	if ( ent != GetLocalViewPlayer() )
		return

	ent.Signal( "EndTacticalChargeRepair" )
}

void function TacticalChargeFXThink( entity player, entity cockpit )
{
	EndSignal( player, "EndTacticalChargeRepair", "OnDeath" )
	EndSignal( cockpit, "OnDestroy" )

	entity tacticalWeapon = player.GetOffhandWeapon( OFFHAND_TACTICAL )

	if ( !IsValid( tacticalWeapon ) )
		return

	string weaponName = tacticalWeapon.GetWeaponClassName()
	if ( weaponName != "mp_weapon_tesla_trap" )
		return

	tacticalWeapon.EndSignal( "OnDestroy" )

	OnThreadEnd(
		function() : ()
		{
			if ( !EffectDoesExist( file.tacticalChargeFXHandle ) )
				return

			EffectStop( file.tacticalChargeFXHandle, false, true )
		}
	)

	for ( ; ; )
	{
		if ( !EffectDoesExist( file.tacticalChargeFXHandle ) )
		{
			file.tacticalChargeFXHandle = StartParticleEffectOnEntity( cockpit, GetParticleSystemIndex( TACTICAL_CHARGE_FX ), FX_PATTACH_ABSORIGIN_FOLLOW, ATTACHMENTID_INVALID )
			EffectSetIsWithCockpit( file.tacticalChargeFXHandle, true )
			EmitSoundOnEntity( player, TROPHY_TACTICAL_CHARGE_SOUND )
		}

		vector controlPoint = <1, 1, 1>
		EffectSetControlPointVector( file.tacticalChargeFXHandle, 1, controlPoint )
		WaitFrame()
	}
}


void function ShieldRepairVisualsEnabled( entity player, int statusEffect, bool actuallyChanged )
{
	if ( player == GetLocalViewPlayer() )
	{
		EmitSoundOnEntity( player, TROPHY_SHIELD_REPAIR_START )
		return
	}

	thread TacticalShieldRepairFXStart( player )
}

void function ShieldRepairVisualsDisabled( entity player, int statusEffect, bool actuallyChanged )
{
	if ( player == GetLocalViewPlayer() )
	{
		if ( player.GetShieldHealth() == player.GetShieldHealthMax() )
			EmitSoundOnEntity( player, TROPHY_SHIELD_REPAIR_END )
	}

	player.Signal( "EndTacticalShieldRepair" )
}

void function TacticalShieldRepairFXStart( entity player )
{
	player.Signal( "EndTacticalShieldRepair" )
	EndSignal( player, "EndTacticalShieldRepair", "OnDeath", "OnDestroy" )

	int oldArmorTier     = -1
	int attachID         = player.LookupAttachment( "CHESTFOCUS" )
	int shieldChargeFXID = GetParticleSystemIndex( TROPHY_PLAYER_SHIELD_CHARGE_FX )
	int fxID             = StartParticleEffectOnEntity( player, shieldChargeFXID, FX_PATTACH_POINT_FOLLOW, attachID )

	OnThreadEnd(
		function() : ( fxID )
		{
			if ( EffectDoesExist( fxID ) )
				EffectStop( fxID, true, true )
		}
	)

	while( true )
	{
		if( player.IsCloaked( true ) )
		{
			if ( EffectDoesExist( fxID ) )
				EffectSetControlPointVector( fxID, 2, < 0, 0, 0> )
		}
		else
		{
			int armorTier = EquipmentSlot_GetEquipmentTier( player, "armor" )
			vector shieldColor = GetFXRarityColorForTier( armorTier )
			if ( EffectDoesExist( fxID ) )
				EffectSetControlPointVector( fxID, 2, shieldColor )
		}

		WaitFrame()
	}
}

void function ArmorChanged( entity player, string equipSlot, int new )
{
	player.Signal( "UpdateShieldRepair" )
}

void function OnWaypointCreated( entity wp )
{
	int wpType = wp.GetWaypointType()

	if ( wpType == eWaypoint.WATTSON_TROPHY_TIMER )
		thread WattsonTimerWaypointThink( wp )
	else if ( wpType == eWaypoint.WATTSON_TROPHY_LIFE )
		thread WattsonShieldsWaypointThink( wp )
}

void function WattsonTimerWaypointThink( entity wp )
{
	wp.SetDoDestroyCallback( true )
	wp.EndSignal( "OnDestroy" )

	float width  = 220
	float height = 220
	vector right = <0, 1, 0> * height * 0.5
	vector fwd   = <1, 0, 0> * width * 0.5 * -1.0
	vector org   = <0, 0, 0>

	var topo = RuiTopology_CreatePlane( org - right * 0.5 - fwd * 0.5, fwd, right, true )
	RuiTopology_SetParent( topo, wp )

	array<var> ruis
	var rui = RuiCreate( $"ui/wattson_ult_cooldown_timer.rpak", topo, RUI_DRAW_WORLD, 1 )

	float startTime = wp.GetWaypointGametime( 0 )
	float endTime   = wp.GetWaypointGametime( 1 )

	RuiSetGameTime( rui, "startTime", startTime )
	RuiSetGameTime( rui, "endTime", endTime )

	ruis.append( rui )

	bool isOwned = wp.GetOwner() == GetLocalViewPlayer()

	var ownedRui
	if ( isOwned )
	{
		ownedRui = CreateCockpitRui( $"ui/wattson_ult_cooldown_timer_world.rpak", 1 )
		RuiTrackFloat3( ownedRui, "worldPos", wp, RUI_TRACK_ABSORIGIN_FOLLOW )
		RuiSetGameTime( ownedRui, "startTime", startTime )
		RuiSetGameTime( ownedRui, "endTime", endTime )
		ruis.append( ownedRui )
	}

	OnThreadEnd(
		function() : ( topo, ruis )
		{
			foreach ( rui in ruis )
				RuiDestroy( rui )
			RuiTopology_Destroy( topo )
		}
	)

	if ( isOwned )
	{
		while ( IsValid( wp ) )
		{
			entity player = GetLocalViewPlayer()
			bool canTrace = false
			bool isFar    = Distance( player.EyePosition(), wp.GetOrigin() ) > TROPHY_COOLDOWN_DRAW_DIST_MIN
			if ( !isFar )
			{
				TraceResults results = TraceLine( player.EyePosition(), wp.GetOrigin(), [player], TRACE_MASK_VISIBLE, TRACE_COLLISION_GROUP_NONE )
				canTrace = results.fraction > 0.95
			}
			RuiSetBool( ownedRui, "isVisible", !canTrace || isFar )
			WaitFrame()
		}
	}
	else
	{
		WaitForever()
	}
}

void function WattsonLifeWaypointThink( entity wp )
{
	wp.SetDoDestroyCallback( true )
	wp.EndSignal( "OnDestroy" )

	float width  = 220
	float height = 220
	vector right = <0, 1, 0> * height * 0.5
	vector fwd   = <1, 0, 0> * width * 0.5 * -1.0
	vector org   = <0, 0, 0>

	var topo = RuiTopology_CreatePlane( org - right * 0.5 - fwd * 0.5, fwd, right, true )
	RuiTopology_SetParent( topo, wp )

	array<var> ruis
	var rui = RuiCreate( $"ui/wattson_ult_cooldown_count.rpak", topo, RUI_DRAW_WORLD, 1 )

	int maxCount = wp.GetWaypointInt( 1 )

	RuiTrackInt( rui, "currentCount", wp, RUI_TRACK_WAYPOINT_INT, 0 )
	RuiTrackInt( rui, "maxCount", wp, RUI_TRACK_WAYPOINT_INT, 1 )

	ruis.append( rui )

	bool isOwned = IsFriendlyTeam( wp.GetTeam(), GetLocalViewPlayer().GetTeam() )

	var ownedRui
	if ( isOwned )
	{
		ownedRui = CreateCockpitRui( $"ui/wattson_ult_cooldown_count_world.rpak", 1 )
		RuiTrackFloat3( ownedRui, "worldPos", wp, RUI_TRACK_ABSORIGIN_FOLLOW )
		RuiTrackInt( ownedRui, "currentCount", wp, RUI_TRACK_WAYPOINT_INT, 0 )
		RuiTrackInt( ownedRui, "maxCount", wp, RUI_TRACK_WAYPOINT_INT, 1 )
		ruis.append( ownedRui )
	}

	OnThreadEnd(
		function() : ( topo, ruis )
		{
			foreach ( rui in ruis )
				RuiDestroy( rui )
			RuiTopology_Destroy( topo )
		}
	)

	if ( isOwned )
	{
		while ( IsValid( wp ) )
		{
			entity player = GetLocalViewPlayer()
			bool canTrace = false
			bool isFar    = Distance( player.EyePosition(), wp.GetOrigin() ) > TROPHY_COOLDOWN_DRAW_DIST_MIN
			if ( !isFar )
			{
				TraceResults results = TraceLine( player.EyePosition(), wp.GetOrigin(), [player], TRACE_MASK_VISIBLE, TRACE_COLLISION_GROUP_NONE )
				canTrace = results.fraction > 0.95
			}
			RuiSetBool( ownedRui, "isVisible", !canTrace || isFar )

			WaitFrame()
		}
	}
	else
	{
		WaitForever()
	}
}

void function WattsonShieldsWaypointThink( entity wp )
{
	wp.SetDoDestroyCallback( true )
	EndSignal( wp, "OnDestroy" )

	float width  = 220
	float height = 220
	vector right = <0, 1, 0> * height * 0.5
	vector fwd   = <1, 0, 0> * width * 0.5 * -1.0
	vector org   = <0, 0, 2>

	var topo = RuiTopology_CreatePlane( org - right * 0.5 - fwd * 0.5, fwd, right, true )
	RuiTopology_SetParent( topo, wp )

	array<var> ruis
	var rui = RuiCreate( $"ui/wattson_ult_shields.rpak", topo, RUI_DRAW_WORLD, 1 )

	int maxCount = wp.GetWaypointInt( 1 )

	RuiTrackInt( rui, "currentShields", wp, RUI_TRACK_WAYPOINT_INT, 0 )
	RuiTrackInt( rui, "totalShields", wp, RUI_TRACK_WAYPOINT_INT, 1 )

	ruis.append( rui )

	bool isOwned = IsFriendlyTeam( wp.GetTeam(), GetLocalViewPlayer().GetTeam() )

	var ownedRui
	if ( isOwned )
	{
		ownedRui = CreateCockpitRui( $"ui/wattson_ult_shields_world.rpak", 1 )
		RuiTrackInt( ownedRui, "currentShields", wp, RUI_TRACK_WAYPOINT_INT, 0 )
		RuiTrackInt( ownedRui, "totalShields", wp, RUI_TRACK_WAYPOINT_INT, 1 )
		ruis.append( ownedRui )
	}

	OnThreadEnd(
		function() : ( topo, ruis )
		{
			foreach ( rui in ruis )
				RuiDestroy( rui )
			RuiTopology_Destroy( topo )
		}
	)

	if ( isOwned )
	{
		while ( IsValid( wp ) )
		{
			vector waypointOrigin = wp.GetOrigin() + wp.GetUpVector() * TROPHY_ICON_HEIGHT
			RuiSetFloat3( ownedRui, "worldPos", waypointOrigin )

			entity player = GetLocalViewPlayer()
			bool canTrace = false
			float distance = Distance( player.EyePosition(), waypointOrigin )
			bool isPastRangeMax = distance > TROPHY_COOLDOWN_DRAW_DIST_MAX
			bool isPastRangeMin = distance > TROPHY_COOLDOWN_DRAW_DIST_MIN
			if ( !isPastRangeMax && !isPastRangeMin )
			{
				TraceResults results = TraceLine( player.EyePosition(), wp.GetOrigin(), [player], TRACE_MASK_VISIBLE, TRACE_COLLISION_GROUP_NONE )
				canTrace = results.fraction > 0.95
			}
			RuiSetBool( ownedRui, "isVisible", !isPastRangeMax && ( !canTrace || isPastRangeMin ) )

			WaitFrame()
		}
	}
	else
	{
		WaitForever()
	}
}

void function FullmapPackage_TrophySystem( entity ent, var rui )
{
	RuiSetImage( rui, "defaultIcon", $"rui/hud/gametype_icons/survival/wattson_ult_map_icon" )
	RuiSetImage( rui, "clampedDefaultIcon", $"" )
}

void function MinimapPackage_TrophySystem( entity ent, var rui )
{
	RuiSetImage( rui, "centerImage", $"rui/hud/gametype_icons/survival/wattson_ult_map_icon" )
	RuiSetImage( rui, "clampedImage", $"" )
	if ( ent.IsClientOnly() )
		RuiSetFloat( rui, "objectRadius", ent.e.clientEntMinimapScale )
	else
		RuiTrackFloat( rui, "objectRadius", ent, RUI_TRACK_MINIMAP_SCALE )
}
#endif         
