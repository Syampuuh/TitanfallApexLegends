                 
global function MpAbilityShieldThrow_Init
global function OnWeaponActivate_ability_shield_throw
global function OnWeaponAttemptOffhandSwitch_ability_shield_throw
global function OnWeaponToss_ability_shield_throw
global function OnWeaponTossPrep_ability_shield_throw
global function OnWeaponTossReleaseAnimEvent_ability_shield_throw

global function IsMobileShieldEnt
global function MobileShield_IsAllowedStickyEnt
global function CodeCallback_ScriptMoverTraversalStopped

#if SERVER
                                                           
#endif

#if CLIENT
global function ServerToClient_ShieldThrowToggleHint
global function ServerToClient_MobileShield_Complete
global function ServerToClient_UpdateShieldStopState
#endif

global const string SHIELD_THROW_SCRIPTNAME 		= "shield_throw"
global const string MOBILE_SHIELD_SCRIPTNAME 		= "mobile_shield"


                        
const asset SHIELD_MODEL 							= $"mdl/props/newcastle_tactical_prop/newcastle_tactical_v21_base_w.rmdl"                                                    
const float SHIELD_THROW_POWER 						= 1                                             
const float SHIELD_THROW_DURATION 					= 20.0
const float SHIELD_THROW_WARNING_DURATION 			= 3.0
const float SHIELD_THROW_HOVER_HEIGHT 				= 50.0

const float SHIELD_THROW_TEST_STEP 					= 64.0	                                                                                                       
const float SHEILD_THROW_DROP_HEIGHT_MAX			= 200.0                                                                                                      
const float SHIELD_HOVER_HEIGHT						= 40.0
const float SHIELD_GROUND_CHECK_DIST				= 3000.0


                         
const MOBILE_SHIELD_MODEL 							= $"mdl/fx/newcastle_tac_hex_shield.rmdl"
const MOBILE_SHIELD_FX 								= $"P_NC_shield_hex_CP"
const MOBILE_SHIELD_TOP_MODEL 						= $"mdl/fx/newcastle_tac_hex_shield.rmdl"
const MOBILE_SHIELD_TOP_FX 							= $"P_NC_shield_hex_CP_top"
const MOBILE_SHIELD_DRONE_PROJECTOR_FX				= $"P_NC_shield_drone_projector"
const MOBILE_SHIELD_DRONE_ENGINE_FX					= $"P_NC_shield_drone_engine"
const MOBILE_SHIELD_DRONE_WARNING_FX				= $"P_nc_drone_warning"

const MOBILE_SHIELD_DRONE_HEALTH					= 150	                      
const MOBILE_SHIELD_WALL_HEALTH 					= 500	     	     

const float MOBILE_SHIELD_SPEED						= 160	    

const vector MOBILE_SHIELD_FX_COLOR 				= < 40, 210, 255 >
const vector MOBILE_SHIELD_ENEMY_FX_COLOR 			= < 255, 100, 12 >
const vector MOBILE_SHIELD_AR_MARKER_COLOR			= < 64, 220, 255 >
const vector MOBILE_SHIELD_ENEMY_PROJECTOR_FX_COLOR	= < 255, 150, 12 >

const string MOBILE_SHIELD_PROPULSION_SFX_3P 		= "Newcastle_Tactical_ShieldActivation"
const string MOBILE_SHIELD_COMMAND_SFX_3P 			= "Newcastle_Tactical_Command"
const string MOBILE_SHIELD_STOP_SFX_3P 				= "Char_11_TacticalA_A"
const string MOBILE_SHIELD_WARNING_SFX_3P			= "Newcastle_Tactical_ShieldPower_Shutdown"
const string MOBILE_SHIELD_DISSOLVE_SFX_3P			= "Newcastle_Drone_dissolve"                                                        
const string MOBILE_SHIELD_DESTROY_SFX_1P 			= "Newcastle_Tactical_ShieldBreak"                                      
const string MOBILE_SHIELD_DESTROY_SFX_3P 			= "Newcastle_Tactical_ShieldBreak_3p"                                      

const float MOBILE_SHIELD_UPDATE_CHATTER_BUFFER 			= 8
const string MOBILE_SHIELD_TACTICAL_ADJUST_POSITION_VO_1P 	= "diag_mp_newcastle_bc_tacticalAdjust_1p"
const string MOBILE_SHIELD_TACTICAL_ADJUST_POSITION_VO_3P 	= "diag_mp_newcastle_bc_tacticalAdjust_3p"

                                
const MOBILE_SHIELD_AR_MARKER 						= $"P_ar_ping_squad_CP"
const float MOBILE_SHIELD_TRACE_DIST 				= 2000.0
const float MOBILE_SHIELD_IGNORE_CLIFF_RESET_DELAY	= 3.0

const vector MOBILE_SHIELD_INVALID_PLACEMENT_MIN_AREA 	= <-15,-15,-50>
const vector MOBILE_SHIELD_INVALID_PLACEMENT_MAX_AREA 	= <15,15,50>
const float MOBILE_SHIELD_WP_DRAW_DIST_MIN 				= 100 			                                                     

const vector MOBILE_SHIELD_DRONE_VEHICLE_ATTACH_OFFSET = <0,0,8>
const vector MOBILE_SHIELD_DRONE_VEHICLE_LEAVE_OFFSET = <0,0,20>

const vector DRONE_MINS = <-9, -9, -10>
const vector DRONE_MAXS = <9, 9, 10>

#if DEV
const bool DEBUG_CODE_SCRIPT_MOVER_TRAVERSAL = false
const bool DEBUG_WALL_CHECK = false
const bool DEBUG_THROW_CHECK = false
#endif      


struct
{
	int mobileShieldHealth			= MOBILE_SHIELD_WALL_HEALTH
	float mobileShieldDuration		= SHIELD_THROW_DURATION
	float mobileShieldSpeed			= MOBILE_SHIELD_SPEED

	#if SERVER
	                                      
	                                          
	                                            
	                                                      
	#endif

	table<entity, entity> mobileShield = {}
	table<entity, array<vector> > cornerPosList = {}
	table<entity, bool > shieldStopState = {}
	table<entity, bool > shieldIgnoreCliffs = {}
	table<entity, bool> canDoTacticalAdjustChatter = {}
	table<entity, entity> attachToVehicle = {}

	#if CLIENT
	bool cl_StopShield = false
	bool cl_shieldActive = false
	#endif

} file

void function MpAbilityShieldThrow_Init()
{
	PrecacheModel( SHIELD_MODEL )
	PrecacheModel( MOBILE_SHIELD_MODEL )
	PrecacheModel( MOBILE_SHIELD_TOP_MODEL )
	PrecacheParticleSystem( MOBILE_SHIELD_FX )
	PrecacheParticleSystem( MOBILE_SHIELD_TOP_FX )
	PrecacheParticleSystem( MOBILE_SHIELD_AR_MARKER )
	PrecacheParticleSystem( MOBILE_SHIELD_DRONE_PROJECTOR_FX )
	PrecacheParticleSystem( MOBILE_SHIELD_DRONE_ENGINE_FX )
	PrecacheParticleSystem( MOBILE_SHIELD_DRONE_WARNING_FX )

	RegisterSignal( "MobileShield_TriggerEnd" )
	RegisterSignal( "MobileShield_Complete" )
	RegisterSignal( "MobileShield_UpdateDestination" )
	RegisterSignal( "MobileShield_Deactivate" )
	RegisterSignal( "MobileShield_Shutdown" )
	RegisterSignal( "MobileShield_Projectile_Deployed" )

	Remote_RegisterServerFunction("ClientCallback_AttemptChangeShieldDirection", "vector", -100000.0, 100000.0, 32 )
	Remote_RegisterClientFunction( "ServerToClient_ShieldThrowToggleHint", "entity" )
	Remote_RegisterClientFunction( "ServerToClient_UpdateShieldStopState", "entity", "bool" )
	Remote_RegisterClientFunction( "ServerToClient_MobileShield_Complete", "entity" )

	#if CLIENT
		RegisterConCommandTriggeredCallback( "+offhand1", AttemptChangeDirection )                 
		AddCreateCallback( PLAYER_WAYPOINT_CLASSNAME, OnWaypointCreated )
		AddCallback_ModifyDamageFlyoutForScriptName( MOBILE_SHIELD_SCRIPTNAME, MobileShield_OffsetDamageNumbersLower )
	#endif

	file.mobileShieldHealth			= GetCurrentPlaylistVarInt( "newcastle_mobile_shield_HP", MOBILE_SHIELD_WALL_HEALTH )
	file.mobileShieldDuration		= GetCurrentPlaylistVarFloat( "newcastle_mobile_shield_duration", SHIELD_THROW_DURATION )
	file.mobileShieldSpeed			= GetCurrentPlaylistVarFloat( "newcastle_mobile_shield_speed", MOBILE_SHIELD_SPEED )
}



                                     
                                     
                                     


void function OnWeaponActivate_ability_shield_throw( entity weapon )
{
	entity ownerPlayer = weapon.GetWeaponOwner()
	Assert( ownerPlayer.IsPlayer() )

	#if SERVER

	#endif

	#if CLIENT
		if ( !InPrediction() )
			return
	#endif
}


bool function OnWeaponAttemptOffhandSwitch_ability_shield_throw( entity weapon )
{
	if ( weapon.GetWeaponPrimaryClipCount() < weapon.GetAmmoPerShot() )
		return false

	entity owner = weapon.GetWeaponOwner()

	#if SERVER
		                                                                             
		 
			            
		 
	#endif

	#if CLIENT
	if ( !InPrediction() )
		return false
	#endif
	return true
}

void function OnWeaponTossPrep_ability_shield_throw( entity weapon, WeaponTossPrepParams prepParams )
{
	entity weaponOwner = weapon.GetWeaponOwner()
}


var function OnWeaponToss_ability_shield_throw( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	entity weaponOwner = weapon.GetWeaponOwner()

	#if SERVER
		                                                                   
		                                          
		                                      
	#endif         

	#if CLIENT
		file.cl_shieldActive = true
	#endif
	return true
}



var function OnWeaponTossReleaseAnimEvent_ability_shield_throw( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	int ammoReq = weapon.GetAmmoPerShot()
	weapon.EmitWeaponSound_1p3p( GetGrenadeThrowSound_1p( weapon ), GetGrenadeThrowSound_3p( weapon ) )

	entity weaponOwner = weapon.GetWeaponOwner()
	vector desiredPos = ShieldThrow_GetThrowDestination( weaponOwner, weapon, true )

	#if SERVER
		                                          
		                                               
		 
			                                               
			                                                                      
		 
	#endif         

	entity deployable = ThrowShield( weapon, attackParams, SHIELD_THROW_POWER, OnDeployableShieldPlanted )
	if ( deployable )
	{
		entity player = weapon.GetWeaponOwner()
		PlayerUsedOffhand( player, weapon )

		#if SERVER
			                                               
			                                                            
			                            
				                                                

			                                                                                    
			                                         
		#endif
	}

	return ammoReq
}

#if SERVER
                                                                    
 
	                                                
	                                 
	                                   
	                                                          

	            
		                           
		 
			                                           
		 
	 

	                           

	                        
	 
		                                            
		       
		                       
		 
			                                                                   
		 
		      
	 

	                                                     

	              
	 
		       
		                       
		 
			                                                                     
		 
		      
		
		                                                                        
		           		
	 
 
#endif

                                      
                                      
                                      

entity function ThrowShield( entity weapon, WeaponPrimaryAttackParams attackParams, float throwPower, void functionref(entity) deployFunc, vector ornull angularVelocity = null )
{
	#if CLIENT
		if ( !weapon.ShouldPredictProjectiles() )
			return null
	#endif

	entity player = weapon.GetWeaponOwner()

	vector attackPos
	if ( IsValid( player ) )
		attackPos = GetShieldThrowStartPos( player, attackParams.pos )
	else
		attackPos = attackParams.pos



	                                                                                                                             
	TraceResults tr = TraceHull( player.EyePosition(), attackPos, DRONE_MINS, DRONE_MAXS, [player], TRACE_MASK_PLAYERSOLID_BRUSHONLY, TRACE_COLLISION_GROUP_PLAYER_MOVEMENT )

	#if DEV
	if ( DEBUG_THROW_CHECK )
	{
		DebugDrawMark( attackPos, 5, COLOR_RED, true, 5.0 )
		DebugDrawArrow( player.EyePosition(), attackPos, 8, COLOR_RED, true, 5.0 )
		printt("ThrowShield: looking fraction: " + tr.fraction )
	}
	#endif      

	if ( tr.fraction < 1.0 )
	{
		#if DEV
		if ( DEBUG_THROW_CHECK )
			DebugDrawMark( attackPos, 5, COLOR_GREEN, true, 5.0 )
		#endif      

		attackPos = tr.endPos
	}

	vector angles   = VectorToAngles( attackParams.dir )
	vector velocity = GetShieldThrowVelocity( player, angles, throwPower )
	if ( angularVelocity == null )
		angularVelocity = <600, RandomFloatRange( -300, 300 ), 0>
	expect vector( angularVelocity )

	float fuseTime = 0.0               

	bool isPredicted = PROJECTILE_PREDICTED
	if ( player.IsNPC() )
		isPredicted = PROJECTILE_NOT_PREDICTED

	WeaponFireGrenadeParams fireGrenadeParams
	fireGrenadeParams.pos = attackPos
	fireGrenadeParams.vel = velocity
	fireGrenadeParams.angVel = <0,0,0>
	fireGrenadeParams.fuseTime = fuseTime
	fireGrenadeParams.scriptTouchDamageType = damageTypes.projectileImpact
	fireGrenadeParams.scriptExplosionDamageType = damageTypes.explosive
	fireGrenadeParams.clientPredicted = isPredicted
	fireGrenadeParams.lagCompensated = true
	fireGrenadeParams.useScriptOnDamage = true
	entity deployable = weapon.FireWeaponGrenade( fireGrenadeParams )

	if ( deployable )
	{
		#if SERVER
		                                                                                                               
		                                             
			                                                                                      
		#endif         

		deployable.SetAngles( <0, angles.y - 180, 0> )
		#if SERVER
			                        
				                                                              
			                        
			                                                 
		#endif
	}

	return deployable
}


vector function GetShieldThrowStartPos( entity player, vector baseStartPos )
{
	                                                                                                         
	vector attackPos = player.OffsetPositionFromView( baseStartPos, <20, 0, 2.5> )                         
	return attackPos
}


vector function GetShieldThrowVelocity( entity player, vector baseAngles, float throwPower )
{
	vector forward = AnglesToForward( baseAngles )

	if ( baseAngles.x < 80 )
		throwPower = GraphCapped( baseAngles.x, 0, 80, throwPower, throwPower )

	vector velocity = forward * throwPower

	return velocity
}

void function OnDeployableShieldPlanted( entity projectile )
{
	#if SERVER
		                                                                                 
		                                                
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

#if SERVER
                                                                             
 
                                                    
                                          
                                                      


                                          
	                                 
	                     
                                                           

                                                                                  
                                                                            

                                                                                                                          
	                        

	                                                                      
	                                                                                                                                                                                           
	                                                                                                                                                                  
	                                     
	                                    
	                                                                                             
	                                        
	                                  
	 
		                                         
		                                                           
	 

	                                                                             
	                                   

	                       
	                                                                                                                                   
	                                                                                                                                                               
	                                  
	                                 
	                                                             
	                                     
	                                      
	                                                        

	                                                                                                                         
	                                


	            
		                        
		 
			                       
			 
				                    
					                
			 
		 
	 

	             
 
#endif         

#if SERVER
                                                                               
 
	                                      
	                                                  

	                                      
	               						       
	                        			       
	                    				                                       
	                                 	             
	                                 	                                  

	                                                                  

	                               
	                              

	                                    
	 
		                  	      
		                   	      
	 

	                        
		                                                                                      

	                          
	                                

	             
	 
		                              
			      

		                                      
			                         

		                                               
		 
			                                     
			                                                                                      
			                          
		 

		                                                             
		                        
		 
			                                   
			 
				                                       

				                      			                                                                                   
				                            	                                                                            
				                   				                                                                         

				                				                                                            
				                   				                                                    
				             					                                                               

				                                                                       
				 
					                                                                                                 
					 
						                                                                                                                   
						                      
						 
							                 
							                                                                 
							                        
						 
						                                                                                                          
						 
							                 
							                                                            
						 
						    
							                  
					 
					    
					 
						                 
						                                                            
					 
				 
				    
					                  	                                                 

				                                         
				 
					                             
					                                                                                          
					                                                              

				 

				                                  
			 

			                     
			 
				                               
				 
					                                                                                                                                                                              
					                                                                                                                                                                          

					                                                               
						                                         

					                                                                      
					                       
				 

				                 
				 
					                        
					 
						       
							                                        
								                                             
						            

						                                                                         
						                       
					 
				 
				    
				 
					                       
					 
						       
							                                        
								                                           
						            

						                              
						                        
					 
				 
			 
		 


		       
		                                        
		 
			                                                                                                         
			                                                               
		 
		            

		           
	 
 

#endif         

#if SERVER
                                                                                                                        
 
	                                       		                                                                                      
	                                       
	                                                                 
	                                       
	                                                         
	                                       
	                                                                                                                             
	                                                                                             
	                  				      
	                   		 	 	     

	                                     
	                                  
	                 
	                                  
	                                 
	              
	                                    
	                                     
	                                          
	                               
	                                  
	                  
	                                    
	                                    
	                                             
	                                              
	         
	                                                                                                                              

	                                                                                                                                                                                                                                                                
	                                                                                                                                             
	                                    
	                                                                                                    
	                                                                             

	                                                            
	                                                                                                                                
	                                                                                                                                                                                                                                                    
	                                                                                                
	                                                        

 
#endif         

void function CodeCallback_ScriptMoverTraversalStopped( entity ent, bool isBlocked )
{
	if ( ent.GetScriptName() != SHIELD_THROW_SCRIPTNAME )
		return

	#if SERVER
		                             
		                       
		 
			                                   
			                 
			                                                                                                               
		 

		                
			                                                   
	#endif         
}


#if SERVER
                                                                                                                               
 

	                                                                                                                                                       
	                                                   
	                                                                
	                                                                 

	                          

	                
	                              
	                               
	                                                 
	                                                 
	                                              
	                           
	                          
	                                         
	                                        
	                                                                    
	                                         
	                                                                         


	                                             

	                                                                                                                                                                                                     
	                                      
	                                     
	                                                                                              
	                                         
	                                                          

	                                      
	 
		                                          
		                                                            
	 

	                                                                                                                                                                                                  
	                                   
	                                  
	                                                              
	                                      
	                                                       

	                                   
	 
		                                       
		                                                         
	 

	                                      
	                                            
	                                       
	                          
	                                  
	                                    
	                                           
	                                        

	                                                                                                      
	                                                                                 

	                               

                    
	                                           
       

	                                                                            

	                
 
#endif


#if SERVER
                                                    
 
	                          
	 
		                                                      

		                                  
		 
			                     
				        

			                                                                         
				        

			                                                                                           
		 
	 

 
#endif

#if SERVER
                                                                                
 
	                           
		      

	                                                      
	                                                  
	                                   

	                      
	 
		                                                                                                                                               
	 

	                           
		      

	                                                                                              

	                          
	 
		                                                           
		                                                                          

		                          
			                                                         

		                                                                                                                                 
			                                                                                                                           
			                                                                                                                            

	 

	                                             
	                                                                                            
	                                                                                                  
	                                                                        
	                                                                        

	                         
	 
		                                           
		                        

		                                            
		 
			                   
				        

			                                                                                                           
			 
				                  
				     
			 
		 

		                               

		                                                          
		                         
			                                                                                                  
		                                                                            

		                  
			                                                 
	 
 
#endif

bool function IsMobileShieldEnt( entity ent )
{
	return ent.GetScriptName() == MOBILE_SHIELD_SCRIPTNAME
}

#if CLIENT
vector function MobileShield_OffsetDamageNumbersLower( entity shieldEnt, vector damageFlyoutPosition )
{
	vector flyoutPosition = ZERO_VECTOR

	const float MOBILE_SHIELD_DAMAGE_POS_VERT_OFFSET = 25.0
	const float MOBILE_SHIELD_DAMAGE_POS_FWD_OFFSET = 64.0
	vector origin = shieldEnt.GetOrigin() - shieldEnt.GetForwardVector() * MOBILE_SHIELD_DAMAGE_POS_FWD_OFFSET

	if( DotProduct(shieldEnt.GetUpVector(), <0,0,1> ) > 0 )
	{
		flyoutPosition = origin + <0,0,MOBILE_SHIELD_DAMAGE_POS_VERT_OFFSET>             
	}
	else
	{
		flyoutPosition = origin - <0,0,MOBILE_SHIELD_DAMAGE_POS_VERT_OFFSET>             
	}

	return flyoutPosition
}
#endif


#if SERVER
                                                       
 
	                     
	 
		                                
		                                 
			                                

		                                   
			                                   
		                                                           
		                                                                             
			                                                    

		                                                                                       
	 
 
                                                        
 
	                           
	 
		                                              
		                                                               
		                                                                  
		                                                                
		                                                 
		                                               
                       
			                                                     
                             
		                          
		                                             
	 

 
#endif


array<entity> function MobileShieldIgnoreArray()
{
	array<entity> ignoreArray = GetPlayerArray_Alive()

	array<entity> mobileShields = GetEntArrayByScriptName( MOBILE_SHIELD_SCRIPTNAME )                             
	foreach ( shieldWall in mobileShields )
	{
		if( !IsValid(shieldWall) )
			continue
		ignoreArray.append( shieldWall )
	}

	array<entity> thrownShields = GetEntArrayByScriptName( SHIELD_THROW_SCRIPTNAME )                        
	foreach ( shield in thrownShields )
	{
		if( !IsValid(shield) )
			continue
		ignoreArray.append( shield )
	}

	array<entity> bubbleShields = GetEntArrayByScriptName( BUBBLE_SHIELD_SCRIPTNAME )              
	foreach ( bubble in bubbleShields )
	{
		if( !IsValid(bubble) )
			continue
		ignoreArray.append( bubble )
	}

	array<entity> holoEnts = GetPlayerDecoyArray()                
	ignoreArray.extend( holoEnts )

	return ignoreArray
}


                                        
                                        
                                        
#if CLIENT
void function AttemptChangeDirection( entity player )                       
{
	if ( player != GetLocalViewPlayer() )
		return

	if ( AreAbilitiesSilenced( player ) )
		return

	if ( Bleedout_IsBleedingOut( player ) )
		return

	if ( player.IsPhaseShifted() )
		return

	if( player.HasPassive( ePassives.PAS_AXIOM ) )
	{
		vector desiredPos = <0,0,0>
		entity weapon = player.GetOffhandWeapon( OFFHAND_TACTICAL )

		if( file.cl_shieldActive == true )
		{
			if ( IsValid( weapon ) )
			{
				desiredPos = ShieldThrow_GetThrowDestination( player, weapon )
			}
			Remote_ServerCallFunction( "ClientCallback_AttemptChangeShieldDirection", desiredPos )
		}

	}
}
#endif

#if SERVER
                                                                                             
 
	                                     
		      

	                                 
	 
		                                      
			      

		                                          
		 
			                                     

			                                            
				                                       
		 

		                                          
		 
			                                          


		 
		                                                  
		 
			                                         
		 

		                                    
		 
			                                                                                                                                                    
				      

			                                               
			                             
			 
				                                              
				                                       
				 
					                          
					                                                                                                                                                          
					                                   
				 
			 
		 

		                                                         

		                                               
		 
			                                             
			 
				                                                                                             
				                                                                                                                     
				                                                                 
			 
		 

		                                                                                                                  
	 
 
#endif

#if SERVER
                                                                               
 
	                                                     
	                              
	                                

	                   
	                                 
	 
		                                        
		                                                  
		                                                    
	 

	                                                
	            
		                       
		 
			                       
				                                                
		 
	 

	                                                                 
	                              
	 
		           
	 
	                                               

	             
 
#endif

#if SERVER
                                                          
 
	                                                                                    
 
#endif

#if CLIENT
void function ServerToClient_UpdateShieldStopState( entity player, bool shieldStop )
{
	if ( player != GetLocalViewPlayer() )
		return

	file.cl_StopShield = shieldStop
}
#endif

#if CLIENT
void function ServerToClient_ShieldThrowToggleHint( entity player )
{
	if ( player != GetLocalViewPlayer() )
		return

	thread ShieldThrow_ShieldCommandPromptsRUI_Thread( player )
}
#endif

#if CLIENT
void function ServerToClient_MobileShield_Complete( entity player )
{
	Signal( player, "MobileShield_Complete" )

	file.cl_shieldActive = false

}

void function ShieldThrow_ShieldCommandPromptsRUI_Thread( entity player )
{
	EndSignal( player, "MobileShield_Complete" )
	EndSignal( player, "OnDeath" )

	if ( !IsValid( GetLocalClientPlayer() ) )
		return

	array<var> ruis
	var rui = CreateCockpitRui( $"ui/mobile_shield_command_prompt.rpak", HUD_Z_BASE )

	const string SHIELD_THROW_TEXT_REDIRECT = "#NEWCASTLE_MOBILE_SHIELD_REDIRECT"


	ruis.append( rui )

	OnThreadEnd(
		function() : ( ruis )
		{
			foreach ( rui in ruis )
				RuiDestroyIfAlive( rui )
		}
	)

	RuiSetString( rui, "promptText_Redirect", SHIELD_THROW_TEXT_REDIRECT )

	while ( IsValid( rui ) )
	{
		WaitFrame()
	}
}
#endif


vector function ShieldThrow_GetThrowDestination( entity ent, entity weapon, bool fromInitialToss=false )
{
	vector eyeHitPos
	array<entity> ignoreArray = MobileShieldIgnoreArray()

	vector eyePos = ent.EyePosition()
	vector eyeDir = ent.GetViewVector()
	eyeDir          = Normalize( eyeDir )

	float rangeNormal = MOBILE_SHIELD_TRACE_DIST
	float rangeSqr    = rangeNormal * rangeNormal

	                                                                           
	float pitchClamped   = clamp( ent.EyeAngles().x, -70.0, 70.0 )
	float rangeEffective = rangeNormal / deg_cos( pitchClamped )

	                                                                                          
	TraceResults initialTrace

	                                                                  
	if ( fromInitialToss )
	{
		initialTrace = TraceLineHighDetail( eyePos, eyePos + (eyeDir * rangeEffective), ignoreArray, TRACE_MASK_SHOT_HULL, TRACE_COLLISION_GROUP_BLOCK_WEAPONS )
	}
	else                                                                                                                   
	{
		initialTrace = TraceLine( eyePos, eyePos + (eyeDir * rangeEffective), ignoreArray, TRACE_MASK_PLAYERSOLID_BRUSHONLY, TRACE_COLLISION_GROUP_PLAYER_MOVEMENT )                                                              
	}
	eyeHitPos = initialTrace.endPos

	TraceResults trace = TraceLineHighDetail( eyeHitPos, eyeHitPos + <0, 0, -200000>, ent, TRACE_MASK_PLAYERSOLID_BRUSHONLY, TRACE_COLLISION_GROUP_PLAYER_MOVEMENT )                                                             
	Signal( ent, "MobileShield_UpdateDestination" )
	#if CLIENT
		thread ShieldThrow_CreateDestinationMarker( ent, trace.endPos, trace.surfaceNormal, trace.hitEnt )
	#endif

	return trace.endPos + <0, 0, SHIELD_HOVER_HEIGHT>

}

#if CLIENT
void function ShieldThrow_CreateDestinationMarker( entity player, vector endPos, vector normal, entity hitEnt )
{
	if( player != GetLocalClientPlayer() )
		return

	EndSignal( player, "MobileShield_Complete" )
	EndSignal( player, "OnDeath" )
	EndSignal( player, "MobileShield_UpdateDestination" )

	entity mover = null
	int fxHandle = -1
	int arID           = GetParticleSystemIndex( MOBILE_SHIELD_AR_MARKER )

	                                                                                                                                                                 
	entity groundMoverEnt               = hitEnt ? hitEnt.GetRootMoveParentScriptMover() : null
	if ( IsValid ( groundMoverEnt ) && GetConVarBool( "script_mover_traversal_mover_support" ) )
	{
		mover  = CreateClientsideScriptMover( $"mdl/dev/empty_model.rmdl", endPos, normal )
		mover.SetParent( groundMoverEnt, "", true )
		fxHandle = StartParticleEffectOnEntity( mover, arID, FX_PATTACH_ABSORIGIN_FOLLOW, ATTACHMENTID_INVALID )
	}
	else
	{
		fxHandle = StartParticleEffectInWorldWithHandle( arID, endPos, normal )
	}

	if ( EffectDoesExist( fxHandle) )
	{
		EffectSetControlPointVector( fxHandle, 1, MOBILE_SHIELD_AR_MARKER_COLOR )
	}

	OnThreadEnd(
		function() : ( fxHandle, mover )
		{
			if ( !EffectDoesExist( fxHandle ) )
				return

			EffectStop( fxHandle, true, true )

			if ( IsValid( mover ) )
			{
				mover.Destroy()
			}
		}
	)

	wait 1                                                   

	while( !file.cl_StopShield )
	{
		WaitFrame()
	}
}
#endif

#if CLIENT
void function OnWaypointCreated( entity wp )
{
	int wpType = wp.GetWaypointType()

	if ( wpType == eWaypoint.NEWCASTLE_MOBILE_SHIELD_LOCATOR )
	{
		thread MobileShield_WaypointUI_Thread( wp )
		AddRefEntAreaToInvalidOriginsForPlacingPermanentsOnto( wp, MOBILE_SHIELD_INVALID_PLACEMENT_MIN_AREA, MOBILE_SHIELD_INVALID_PLACEMENT_MAX_AREA )
	}

}


void function MobileShield_WaypointUI_Thread( entity wp )
{
	wp.SetDoDestroyCallback( true )
	wp.EndSignal( "OnDestroy" )

	array<var> ruis

	bool isOwned = IsFriendlyTeam( wp.GetTeam(), GetLocalViewPlayer().GetTeam() )
	entity player = GetLocalViewPlayer()

	var ownedRui
	if ( isOwned )
	{
		ownedRui = CreateCockpitRui( $"ui/mobile_shield_waypoint.rpak", 1 )
		RuiTrackFloat3( ownedRui, "playerAngles", player, RUI_TRACK_EYEANGLES_FOLLOW )
		RuiTrackFloat3( ownedRui, "worldPos", wp, RUI_TRACK_ABSORIGIN_FOLLOW )
		RuiTrackFloat( ownedRui, "curHP", wp, RUI_TRACK_WAYPOINT_FLOAT, 0 )
		RuiTrackFloat( ownedRui, "maxHP", wp, RUI_TRACK_WAYPOINT_FLOAT, 1 )
		ruis.append( ownedRui )
	}

	OnThreadEnd(
		function() : ( ruis )
		{
			foreach ( rui in ruis )
				RuiDestroy( rui )
		}
	)

	if ( isOwned )
	{
		while ( IsValid( wp ) )
		{
			bool displayRui = false

			if ( IsValid( player ) )
			{
				vector adjWPOrigin			= wp.GetOrigin() + <0,0,-10>
				vector eyeDir				= player.GetViewVector()
				vector dirToWP				= Normalize( adjWPOrigin - player.EyePosition() )
				float dotShield				= DotProduct( eyeDir, dirToWP )
				array<entity> ignoreArray	= MobileShieldIgnoreArray()

				TraceResults results = TraceLine( player.EyePosition(), adjWPOrigin, ignoreArray, TRACE_MASK_VISIBLE, TRACE_COLLISION_GROUP_NONE )
				bool hasLoS		= results.fraction > 0.95
				bool isInFrame 	= dotShield > 0.9

				if ( !isInFrame || !hasLoS )
				{
					float dist = Distance( player.EyePosition(), wp.GetOrigin() )
					bool isInRange = ( dist > MOBILE_SHIELD_WP_DRAW_DIST_MIN )
					if ( isInRange )
						displayRui = true
				}

			}

			RuiSetBool( ownedRui, "isVisible", ( displayRui ) )

			WaitFrame()

			player = GetLocalViewPlayer()
		}
	}
	else
	{
		WaitForever()
	}
}
#endif         


                                                                                             
bool function GetShieldThrowIsScriptMoverTraversal()
{
	return GetCurrentPlaylistVarBool( "newcastle_tac_code_traversal", true )
}

                                                                               
bool function EnableFindBetterShieldStartingPos()
{
	return GetCurrentPlaylistVarBool( "newcastle_tac_find_better_starting_pos", true )
}

                                        
bool function MobileShield_IsAllowedStickyEnt( entity mobileShield, entity stickyEnt, string stickyEntWeaponClassName )
{
	bool allowStick = false

	if ( stickyEntWeaponClassName == "mp_weapon_cluster_bomb_launcher" )
		allowStick = true

	if ( stickyEntWeaponClassName == "mp_weapon_arc_bolt" )
		allowStick = true

	if ( stickyEntWeaponClassName == "mp_weapon_grenade_emp" )
		allowStick = true

	if( allowStick )
		thread MobileShield_TrackStickyEnt_Thread( mobileShield, stickyEnt )

	return allowStick
}

                                                                                         
void function MobileShield_TrackStickyEnt_Thread( entity mobileShield, entity stickyEnt )
{
	EndSignal( mobileShield, "OnDestroy" )
	EndSignal( stickyEnt, "OnDestroy" )

	bool hadLoS = true

	array<entity> ignoreArray	= MobileShieldIgnoreArray()
	TraceResults initialTrace = TraceLine( mobileShield.GetOrigin(), stickyEnt.GetOrigin(), ignoreArray, TRACE_MASK_VISIBLE, TRACE_COLLISION_GROUP_NONE )

	if(initialTrace.fraction < 1)
		hadLoS = false

	WaitFrame()                                                              

	while ( true )
	{
		if( !IsValid( mobileShield ) )
			return
		if( !IsValid( stickyEnt ) )
			return

		ignoreArray	= MobileShieldIgnoreArray()
		TraceResults results = TraceLine( mobileShield.GetOrigin(), stickyEnt.GetOrigin(), ignoreArray, TRACE_MASK_VISIBLE, TRACE_COLLISION_GROUP_NONE )
		if(	results.fraction < 1 )
		{
			#if SERVER
			                       
			            
				                                        
			#endif
			return
		}

		WaitFrame()
	}

}


      