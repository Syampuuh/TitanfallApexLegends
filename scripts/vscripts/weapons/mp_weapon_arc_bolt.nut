global function MpWeaponArcBolt_Init
global function OnWeaponActivate_arc_bolt
global function OnWeaponDeactivate_arc_bolt
global function OnWeaponAttemptOffhandSwitch_arc_bolt
global function OnWeaponToss_arc_bolt
global function OnWeaponTossReleaseAnimEvent_arc_bolt
global function OnProjectileCollision_arc_bolt

#if SERVER
                                           

                                     
#elseif CLIENT
global function ArcBolt_ServerToClient_NewTetherAdded
global function ArcBolt_ServerToClient_TetherRemoved
#endif

         
const string ARC_BOLT_SOUND_PROJECTILE_FIRE_3P      = "ash_tactical_glaive_fire_3p"
const string ARC_BOLT_SOUND_PROJECTILE_FIRE_1P      = "ash_tactical_glaive_fire_1p"
const string ARC_BOLT_SOUND_PROJECTILE_HOLD_3P      = "ash_tactical_glaive_hold_3p"
const string ARC_BOLT_SOUND_PROJECTILE_HOLD_1P      = "ash_tactical_glaive_hold_1p"
const string ARC_BOLT_SOUND_PROJECTILE_IDLE_1P		= "Ash_Tactical_Glaive_Idle_1p"
const string ARC_BOLT_SOUND_PROJECTILE_LOOP         = "Ash_Tactical_Glaive_Projectile_Loop_3p"
const string ARC_BOLT_SOUND_TRAP_LOOP				= "Phys_Glaive_Imp_Loop"
const string ARC_BOLT_SOUND_TETHER_CONNECT_3P       = "Ash_Tactical_Glaive_Connect_3P"
const string ARC_BOLT_SOUND_TETHER_CONNECT_1P       = "Ash_Tactical_Glaive_Connect_1P"
const string ARC_BOLT_SOUND_TETHER_CONNECT_FEEDBACK = "Ash_Tactical_Glaive_Connect_Feedback_1p"
const string ARC_BOLT_SOUND_TETHER_LOOP_3P          = "Ash_Tactical_Glaive_TetherLoop_3P"
const string ARC_BOLT_SOUND_TETHER_LOOP_1P          = "Ash_Tactical_Glaive_TetherLoop_1P"
const string ARC_BOLT_SOUND_TETHER_LOOP_FEEDBACK    = "Ash_Tactical_Glaive_TetherLoop_Feedback_1P"
const string ARC_BOLT_SOUND_DAMAGE_BREAK_3P         = "Ash_Tactical_Glaive_tetherbreak_3P"
const string ARC_BOLT_SOUND_DAMAGE_BREAK_1P         = "Ash_Tactical_Glaive_tetherbreak_1P"
const string ARC_BOLT_SOUND_DAMAGE_BREAK_FEEDBACK   = "Ash_Tactical_Glaive_tetherbreak_Feedback_1p"

const float ARC_BOLT_SOUND_FEEDBACK_FALLOUT_DISTANCE_SQR = 1000.0 * 1000.0

      
const asset ARC_BOLT_PROJECTILE_FX = $"P_ash_arcbolt_projectile"               
const asset ARC_BOLT_PROJECTILE_CRAWL_FX = $"P_ash_arcbolt_crawl"                               
const asset ARC_BOLT_PROJECTILE_PLANTED_FX = $"P_ash_arcbolt_trap"

const asset ARC_BOLT_ZAP_CONNECT_FX = $"P_ash_arcbolt_active_hit"
const asset ARC_BOLT_ZAP_FX = $"P_ash_arcbolt_tether"                     
const asset ARC_BOLT_TETHER_RADIUS_FX = $"P_ash_arcbolt_tether_radius"                            
const asset ARC_BOLT_TETHER_SCREEN_FX = $"P_ash_tether_screen_edge"                            
const asset ARC_BOLT_TETHER_INDICATOR_FX = $"P_ash_tether_indicator_cp10"                             

const asset ARC_BOLT_TETHER_ANCHOR = $"mdl/weapons_r5/misc_ash_glaive/ash_glaive_solo_fx.rmdl"

                         
const string SIGNAL_TETHER_REMOVED = "ArcBolt_TetherRemoved"
const string SIGNAL_KILL_CRAWL_FX = "ArcBolt_ArcEffectCreated"

const bool DEBUG_CONNECT_POINT = false                                            

const string FUNCNAME_NEW_TETHER = "ArcBolt_ServerToClient_NewTetherAdded"
const string FUNCNAME_REMOVED_TETHER = "ArcBolt_ServerToClient_TetherRemoved"
global const string TETHER_TRAP_SCRIPTNAME = "arc_snare"
global const string TETHER_SCRIPTNAME = "arc_tether"
global const string TETHER_BLOCKER_SCRIPTNAME = "tether_blocker"

           
const float SHIELD_SCALE_DAMAGE_MULT_DEFAULT = 2.0
const float TETHER_RADIUS_DEFAULT = 190
const float TETHER_MAX_PULL_VELOCITY_DEFAULT = 100.0
const float TETHER_DEFAULT_STRENGTH = 80.0
const float TETHER_STRENGTH_HEALTH_SCALE = 0.6
const float TETHER_MAX_STRETCH_DAMAGE_DEFAULT = 4.0                                                                        
const float TETHER_HEALTH_BASE = 1000.0
const float TETHER_HEALTH_DRAIN_PER_SEC_DEFAULT = 250
const float TETHER_HEALTH_DRAIN_DELAY = 1.0
const float TETHER_HEALTH_DRAIN_CUTOFF_PCT = 0.0
const float TETHER_HEALTH_STRETCH_DAMAGE_SCALE_DEFAULT = 0.11
const float TETHER_HEALTH_VELOCITY_DAMAGE_SCALE_DEFAULT = 0.011

const float TETHER_GRAV_DMG_FRAC_PER_SEC = 0.5
const float TETHER_ZIPLINE_SCALING_MIN_VEL = 200
const float TETHER_ZIPLINE_STRENGTH_SCALE = 0.15

const vector TETHER_SPAWN_OFFSET = <0, 0, 12>

const float PROJECTILE_REFUND_MAX_LIFETIME = 1.0
const float PROJECTILE_REFUND_AMOUNT_DEFAULT = 0.5

enum eBoltType
{
	PROJECTILE,
	PLANTED,
}

struct boltState
{
	entity threatIndicator
	int    type
	float  timeBeforePlanted
	entity plantedRadiusFx
}

struct
{
	#if SERVER
		                                         
		                                       

		                     
		                 
		                 
		                              

		                       
		                       
		                              
		                               
		                            
	#elseif CLIENT
		var        tetherRui
		array<int> affectedTethers
	#endif
	float tetherRadius
	float tetherRadiusSqr
	bool  doOnHitPing
} file

void function MpWeaponArcBolt_Init()
{
	PrecacheParticleSystem( ARC_BOLT_PROJECTILE_FX )
	PrecacheParticleSystem( ARC_BOLT_ZAP_FX )
	PrecacheParticleSystem( ARC_BOLT_TETHER_RADIUS_FX )
	PrecacheParticleSystem( ARC_BOLT_PROJECTILE_CRAWL_FX )
	PrecacheParticleSystem( ARC_BOLT_TETHER_SCREEN_FX )
	PrecacheParticleSystem( ARC_BOLT_PROJECTILE_PLANTED_FX )
	PrecacheParticleSystem( ARC_BOLT_ZAP_CONNECT_FX )
	PrecacheParticleSystem( ARC_BOLT_TETHER_INDICATOR_FX )

	PrecacheModel( ARC_BOLT_TETHER_ANCHOR )

	file.doOnHitPing = GetCurrentPlaylistVarBool( "ash_tether_do_hit_ping", true )
	#if SERVER
		                                                                                
		                                                   

		                                                                                                                               
		                                                                                                                                      
		                                                                                                                                          
		                                                                                                                                            
		                                                                                                                            
	#elseif CLIENT
		if ( file.doOnHitPing )
			AddCreateCallback( PLAYER_WAYPOINT_CLASSNAME, OnWaypointCreated )
	#endif
	file.tetherRadius                   = GetCurrentPlaylistVarFloat( "ash_tether_radius", TETHER_RADIUS_DEFAULT )
	file.tetherRadiusSqr                = file.tetherRadius * file.tetherRadius

	RegisterSignal( SIGNAL_TETHER_REMOVED )
	RegisterSignal( SIGNAL_KILL_CRAWL_FX )

	Remote_RegisterClientFunction( FUNCNAME_NEW_TETHER, "int", INT_MIN, INT_MAX, "entity" )
	Remote_RegisterClientFunction( FUNCNAME_REMOVED_TETHER, "int", INT_MIN, INT_MAX )

	SetConVarFloat( "tether_maxvel", GetCurrentPlaylistVarFloat( "ash_tether_pull_maxvel", TETHER_MAX_PULL_VELOCITY_DEFAULT ) )
	SetConVarFloat( "tether_default_strength", TETHER_DEFAULT_STRENGTH )
	SetConVarFloat( "tether_strength_healthScale", TETHER_STRENGTH_HEALTH_SCALE )
	SetConVarFloat( "tether_maxStretchDamage", GetCurrentPlaylistVarFloat( "ash_tether_max_stretch_damage", TETHER_MAX_STRETCH_DAMAGE_DEFAULT ) )

	SetConVarFloat( "tether_gravity_dmg_frac_per_sec", TETHER_GRAV_DMG_FRAC_PER_SEC )
	SetConVarFloat( "tether_zipline_scaling_min_vel", TETHER_ZIPLINE_SCALING_MIN_VEL )
	SetConVarFloat( "tether_zipline_strength_scale", TETHER_ZIPLINE_STRENGTH_SCALE )

}


void function OnWeaponActivate_arc_bolt( entity weapon )
{
	#if SERVER
		                                                                             
		 
			                                                                                       
			                                                                                       
			                           
		 
	#endif

	weapon.EmitWeaponSound_1p3p( ARC_BOLT_SOUND_PROJECTILE_HOLD_1P, ARC_BOLT_SOUND_PROJECTILE_HOLD_3P )
}


void function OnWeaponDeactivate_arc_bolt( entity weapon )
{
	weapon.StopWeaponSound( ARC_BOLT_SOUND_PROJECTILE_HOLD_1P )
	weapon.StopWeaponSound( ARC_BOLT_SOUND_PROJECTILE_HOLD_3P )

	if ( IsValid( weapon.GetOwner() ) )
		StopSoundOnEntity( weapon.GetOwner(), ARC_BOLT_SOUND_PROJECTILE_IDLE_1P )	                                                                             
}


bool function OnWeaponAttemptOffhandSwitch_arc_bolt( entity weapon )
{
	return true
}


var function OnWeaponToss_arc_bolt( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	#if SERVER
		                                   
			                                                                         
	#endif
	return true
}


var function OnWeaponTossReleaseAnimEvent_arc_bolt( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	#if CLIENT
		if ( !(InPrediction() && IsFirstTimePredicted()) )
			return
	#endif

	weapon.StopWeaponSound( ARC_BOLT_SOUND_PROJECTILE_HOLD_1P )
	weapon.StopWeaponSound( ARC_BOLT_SOUND_PROJECTILE_HOLD_3P )
	weapon.EmitWeaponSound_1p3p( ARC_BOLT_SOUND_PROJECTILE_FIRE_1P, ARC_BOLT_SOUND_PROJECTILE_FIRE_3P )

	entity player = weapon.GetWeaponOwner()
	if ( IsValid( player ) )
		StopSoundOnEntity( weapon.GetOwner(), ARC_BOLT_SOUND_PROJECTILE_IDLE_1P )	                                                                             

	{
		if ( player.IsPlayer() )
			PlayerUsedOffhand( player, weapon )

		float lifetime = weapon.GetWeaponSettingFloat( eWeaponVar.projectile_lifetime )
		thread WeaponAttackBolt( weapon, attackParams.pos, attackParams.dir, lifetime )
	}

	return weapon.GetAmmoPerShot()
}


void function WeaponAttackBolt( entity weapon, vector pos, vector dir, float lifetime )
{
	entity owner = weapon.GetOwner()
	if ( !IsValid( weapon.GetOwner() ) )
		return

	int damage = weapon.GetWeaponSettingInt( eWeaponVar.damage_near_value )

	WeaponFireBoltParams fireBoltParams
	fireBoltParams.pos                       = pos
	fireBoltParams.dir                       = dir
	fireBoltParams.speed                     = 1
	fireBoltParams.scriptTouchDamageType     = damage
	fireBoltParams.scriptExplosionDamageType = damage
	fireBoltParams.clientPredicted           = true
	fireBoltParams.additionalRandomSeed      = 0
	fireBoltParams.dontApplySpread           = true
	fireBoltParams.projectileIndex           = 0
	fireBoltParams.deferred                  = false

	DeployableCollisionParams emptyParams
	entity bolt = CreateBolt( weapon.GetOwner(), weapon, fireBoltParams, false, emptyParams )

	if ( bolt == null )
		return

	#if SERVER
		                                                       
	#endif
}


entity function CreateBolt( entity owner, entity weapon, WeaponFireBoltParams fireBoltParams, bool isPlanted, DeployableCollisionParams collisionParams )
{
	entity bolt

	if ( !IsValid( owner ) )
		return bolt

	if ( !isPlanted )
	{
		bolt = weapon.FireWeaponBoltAndReturnEntity( fireBoltParams )
	}
	else
	{
		#if SERVER
			                                                                                                                     
			                                            
			                          
			                                     
		#endif
	}

	#if SERVER
		                      
		 
			                                      

			               
			                                                                            
			                                    
		 
	#endif

	return bolt
}

void function OnProjectileCollision_arc_bolt( entity projectile, vector pos, vector normal, entity hitEnt, int hitBox, bool isCritical, bool isPassthrough )
{
	#if SERVER
		                                                                     
			      

		                         
			      

		                                    
		                                          
			      

		                                                                                           
			      

		                                                                                                                 
		 
			                                                                                              
			 
				                                                                                                                                                                           
				      
			 
			                                                                    
				      
		 

		                                         
		                         
		                               
		                               
		                          
		                                       

		                                                            
			      

		                         
	#endif
}

#if SERVER
                                                                                                                     
 
	                                
	                                                                              

	                      
		            

	                                                                      
	 
		                      
		            
	 

	                                                                                    

	                                                         
	           
 


                                                                                                                 
 
	                              
	                            
	                               
	                             

	      
	                         
	                     
	 
		                                                                                                                                                                                     
		                                                                                               
	 
	    
	 
		                                                                                                                                                                                             

		                                                                                                                                                                           
		                                                      
		                                                        
		                                     
		                           
		                                                                                
		                               

		                                                       
	 

	        
	                     
		                                                         
	    
		                                                   

	           
	                   
	                     
	 
		                                                                                                            
	 
	    
	 
		                                                                                                         

		                                                                                                                                                             
		                                  
		                                             
		                                     
		                              
	 

	            
		                                                       
		 
			                                     
				                                     

			                             
			 
				                    
					                
			 

			                              
				                      

			                      
			 
				                                                         
				                                                   
			 

			                                                                                                                                             
			                                                                                                                                 
			                                                                                                                     
			                   
		 
	 

	                    

	                                                         
		      

	                  
	                     
	 
		                                                                                                                                
		                                                                                                                                
		                                                                                                                                           
		                                                                                                                                         
		                   
	 

	            
		                            
		 
			                             
				                     
		 
	 

	                        
	                    
		                                                          

	                      
	                                  
	                               
	                            
	 
		                                                                              
			      

		                        
		                                      
		                                                      
		 
			                                                                                
			                                                   	                                       

			                                                                          

			                                                                            
			 
				                                                                                                      
			 
		 
		                                                                                                       
		 
			                                                                                                      
			                        
		 

		                                         
		                    
		 
			                                                                                                   
			                                                                                                            
			                                                
		 

		             
			                
			                 
			                 
			                 
			                 
			                                
			                                
			                               
			                          
			                    
			                           
			                                    

		           
		                
	 
 

                                        
 
	                                            

	                                                                                                          
	                                                                   
	                                                                    
	                                                                
 


                                                                                     
 
	                              
	                            

	              
	 
		                                                                          

		                     
		 
			           
			        
		 

		                       

		                                                                          
		                                                                                                                                           
		                                                    

		                                 

		                             
			                    
	 
 


                                                                                               
 
	                                                                                                                                                                                                                           
	                         

	                              
		                                                                                     
	                              
		                                                                                   
	                              
		                                                                                

	                                      

	                                                                                                                                    

	                          
	 
		                               
			                                                             
		    
			                                                                
	 

	                                                        
 
#endif

#if SERVER
                                                              
 
	                                                   
 


                                                                     
 
	                                                       
	                                                        

	                                                                                                
	 
		                                     
		      
	 

	                                                                                 
	 
		                                     
		      
	 

	                     
	 
		                                                                      
		 
			                                     
			      
		 

		                                            
	 
	                              
	 
		                                     
		      
	 

	                                                                  
	                                                                   
	 
		                                     
		                                                                 
		      
	 

	                                               
 

                                                               
 
	                                                                                               
		          

	                             
 

                                                                    
 
	                                          
		      

	                              
	                                
	                                    
	                                      
	                                      
	                                   
	                       
	 
		                                     
		                               
	 

	                                                                            
	                                                                                            
	                                                                                                                                                                              

	                                  
	                                                 
	                                                       
	                                 
	                                  
	                                   
	                                   
	                                   
	                                             
	                                
	                                            
	                                                          
	                                     
	                                           
	                            
	                               
	                                           
	                                

	                                            
	                                        
		                          
	    
		                                                                                       

	                                       
	                                         
	                          
	                  
	 
		                                                      
	 
	    
	 
		                                                          	                                                                                                                     
		                                       	                                                            
			                                            
		                          
	 

	             
	                           
	 
		                                                                                                                                                                                 
		                                                     
		                           
		                                                                                    
		                                
	 

	                                                                  
	 
		                                                                                                                                                                                                
		                                                         
		                                                                        
		                                       
	 

	 
		                                                                                                                                                                                  
		                                                                        
		                                                          
		                                        
		                              
		                                                                                  
		                                   
	 

	                      
	                         
	 
		                                                                                                                                 
		                                                                                                                                                                                      
		                                               
		                            
		                               
		                                           
		                                                                                   
		                               

		          
		                                                                     
		                                                                                                                                             
		                                                  
		                                                 
		                                                                                                                                                           
		                                                 
		                              
		                                 
		                                             
		                                                        
		                                 
	 

	                               
	                                                                                                                                                                                                                                                              
	                        
		                                                                                 

	         
	                       
	 
		                                                                       
		                       
		 
			                                                                                                                
			                              
		 
		                                                      
			                                     
	 

	                        

	            
		                                                                                                               
		 
			                           
			 
				                                                                   
				                                                             
				                                                             
				                                                                      
				                                                                
				                                                                

				                        
					                                                                                                                                 

				                                                                                                                                   
					                                                                                       

				                                          
			 

			                        
			 
				                        
					                                     

				                                         
					                               
			 

			                               
			 
				                    
					                
			 

			                               
			 
				                      
					              
			 

			                                 
				                         

			                    
				            

			                                      
			                                                        
		 
	 

	                        
	 
		                        
		 
			                                                              
			                                      
		 

		                                                                                                                                  
		                       
			                                                                                      
	 

	                           
	 
		                                                                                                                               
		                       
			                                                                                      
	 

	                                                                             

	                        

	                                                                                                                                                       

	              
	 
		                                                                 

		                                          
			      
	 
 

                                                                     
 
	                               
	                                   

	                                                     
	                                                                                                                                                     
	                            
	                               
	 
		                            
		                                   
		                            
		                            

		                                                                        
	 
	                      
	 
		                           
		      
	 

	                                           
	                            
	 
		                                                                                                                                                    
		                                  
		 
			                            
			                                                                      
			                            
			                            

			                                                      
		 
		                           
	 
 

                                                                                                                    
 
	                                   
	                                

	                                                           

	        

	                            
	             
	 
		                                          
			      

		                                                          
		                                                     

		                                                                             

		                                                     
		           
	 
 
#endif

#if CLIENT
void function ArcBolt_ServerToClient_NewTetherAdded( int tetherID, entity tetherEnt )
{
	entity player = GetLocalViewPlayer()

	if ( IsValid( player ) && IsValid( tetherEnt ) )
	{
		file.affectedTethers.append( tetherID )

		thread TetherScreenEffects_Thread( player, tetherID, tetherEnt )
		thread TetherDirectionalEffect_Thread( player, tetherID, tetherEnt )
	}
}

void function TetherScreenEffects_Thread( entity player, int tetherID, entity tetherEnt )
{
	EndSignal( player, "OnDeath", "OnDestroy")
	int tetheredScreenFx = StartParticleEffectOnEntity( player, GetParticleSystemIndex( ARC_BOLT_TETHER_SCREEN_FX ), FX_PATTACH_ABSORIGIN_FOLLOW, ATTACHMENTID_INVALID )

	OnThreadEnd(
		function() : ( tetheredScreenFx )
		{
			EffectStop( tetheredScreenFx, true, true )
		}
	)

	WaitFrame()

	while ( true )
	{
		if ( !file.affectedTethers.contains( tetherID ) || !IsValid( tetherEnt ) )
			return

		float dist = DistanceSqr( player.GetOrigin(), tetherEnt.GetOrigin() )
		if ( dist > file.tetherRadiusSqr )
			EffectSetControlPointVector( tetheredScreenFx, 1, <100, 0, 0> )
		else
			EffectSetControlPointVector( tetheredScreenFx, 1, <25, 0, 0> )

		WaitFrame()
	}
}

void function TetherDirectionalEffect_Thread( entity player, int tetherID, entity tetherEnt )
{
	EndSignal( player, "OnDeath", "OnDestroy")
	EndSignal( tetherEnt, "OnDeath", "OnDestroy" )

	                                                    
	while ( file.affectedTethers.len() > 2 )
	{
		WaitFrame()
	}

	int tetherDirectionalIndicator = StartParticleEffectOnEntity( player, GetParticleSystemIndex( ARC_BOLT_TETHER_INDICATOR_FX ), FX_PATTACH_ABSORIGIN_FOLLOW, ATTACHMENTID_INVALID )

	OnThreadEnd(
		function() : ( tetherDirectionalIndicator )
		{
			EffectStop( tetherDirectionalIndicator, true, true )
		}
	)

	float i = 0
	while ( true )
	{
		bool tetherIsAttached = false
		foreach ( tether in file.affectedTethers )
		{
			if ( tether == tetherID )
			{
				tetherIsAttached = true
				break
			}
		}

		if ( !tetherIsAttached || !EffectDoesExist( tetherDirectionalIndicator ) )
			return

		vector playerToTether = tetherEnt.GetOrigin() - player.GetOrigin()

		vector playerToTetherAngles = VectorToAngles( FlattenVec( playerToTether ) )
		playerToTetherAngles -= <0, 180.0, 0>

		vector eyeAngles = player.EyeAngles()
		eyeAngles = FlattenAngles( eyeAngles )

		vector fxAngle = playerToTetherAngles - eyeAngles + <0, 90, 0>
		fxAngle.y = AngleNormalize( fxAngle.y )
		if ( fabs( fxAngle.y + 90.0 ) < 70.0 )
			fxAngle.y = fxAngle.y > -90.0 ? -20.0 : -160.0

		EffectSetControlPointAngles( tetherDirectionalIndicator, 10, fxAngle )
		EffectSetControlPointVector( tetherDirectionalIndicator, 4, tetherEnt.GetOrigin() )

		float tetherHealth = player.GetTetherHealth( tetherID )
		tetherHealth =  tetherHealth / TETHER_HEALTH_BASE
		EffectSetControlPointVector( tetherDirectionalIndicator, 1, <tetherHealth * 70.0 + 30.0, 0, 0> )

		WaitFrame()
	}
}

void function ArcBolt_ServerToClient_TetherRemoved( int tetherID )
{
	file.affectedTethers.removebyvalue( tetherID )
}

void function OnWaypointCreated( entity wp )
{
	if ( !IsValid( wp ) || Waypoint_GetPingTypeForWaypoint( wp ) != ePingType.ENEMY_TETHERED )
		return

	thread RemoveWaypointPopout( wp )
}

void function RemoveWaypointPopout( entity wp )
{
	                                                                                                                 
	WaitFrame()

	if ( IsValid( wp ) && wp.wp.ruiHud != null )
		RuiSetBool( wp.wp.ruiHud, "doCenterOffset", false )
}
#endif

#if SERVER
                                                                               
 
	                                                                                                                                                    
	                                                                                                                                          
	                                                         
	                                       
	                        
	 
		                                                                                 
	 
 

                                                                      
 
	                                                                   
	 
		                       
		 
			                                                                  
			                                                                                               
				                                                                                                                                                                                                                      
		 
	 
 

                                                                                
 
	                                   
	 
		                                                      
		                                                                                                                                                                                                              
		                               
		                                         
		                           
		                
	 
	                                     
	 
		                                                                                                                                                                                       
		                               
		                                         
		                           
		                
	 
	           
 

                                        
 
	                      
	 
		                                  
		 
			                                             

			                                       
				                               

			                                  
		 

		              
	 
 

                                                  
 
	                                     
		            

	                                                          
 
#endif