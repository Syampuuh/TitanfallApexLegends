global function MpAbilityWreckingBall_Init
global function OnWeaponAttemptOffhandSwitch_ability_WreckingBall
global function OnWeaponTossReleaseAnimEvent_WeaponWreckingBall
global function OnWeaponTossPrep_WeaponWreckingBall
global function OnProjectileCollision_ability_WreckingBall_Piece
global function OnProjectileCollision_ability_WreckingBall

#if SERVER
                                               
                                                  
                   
                                               
                                              
      
#endif

#if CLIENT
global function ServerCallback_RT_SpeedupHudForPlayer
global function ServerCallback_PrototypeManageHighlight
global function ServerCallback_RT_CleanupSpeedupHudForPlayer
#endif

#if SERVER && DEV
                                                  
#endif

global const string WRECKING_BALL_BALL_SCRIPT_NAME			= "wreckingball_ball"
global const string WRECKING_BALL_ANIMCHILD_SCRIPT_NAME		= "wreckingball_animchild"
global const string WRECKING_BALL_MAGNET_SCRIPT_NAME 		= "wreckingball_magnet"
global const string WRECKING_BALL_SPEEDTRIGGER_SCRIPT_NAME 	= "wreckingball_speedtrigger"

                      
const int WRECKING_BALL_DAMAGE_FINAL				= 20			                                                                            
const float WRECKING_BALL_FINAL_EXPLOSION_RADIUS	= 300.0			                                                                                           
                   
const float WRECKING_BALL_BALL_DURATION 			= 10.0			                                                  
     
                                                                                                     
      
const float WRECKING_BALL_WAKE_DURATION 			= 60.0			                                                                
const float WRECKING_BALL_PROXY_DELAY				= 0.5			                                                      
const float WRECKING_BALL_WAKE_BUFF_DURATION 		= 2				                                                                 
const float WRECKING_BALL_SHELLSHOCK_CHARGE_TIME 	= 3.0			                                                                                                                                                                       
const float WRECKING_BALL_SHELLSHOCK_DURATION_MIN 	= 3.0			                                        
const float WRECKING_BALL_SHELLSHOCK_DURATION_MAX 	= 6.0			                                        
const float WRECKING_BALL_SHELLSHOCK_DURATION_ALLY 	= 3.0			                                                                                                                
const float WRECKING_BALL_WAKE_BUFF_SEVERITY		= 0.15			                                      
const float WRECKING_BALL_PUNT_POWER				= 300.0			                                                     
const float WRECKING_BALL_PUNT_POWER_ALLY			= 200.0			                                                            
const float WRECKING_BALL_PLAYER_PROXIMITY_DIST		= 225.0			                                                            
const float WRECKING_BALL_SPEED_TRIGGER_RADIUS		= 88.0			                                           
const float WRECKING_BALL_SPEED_TRIGGER_HEIGHT		= 16.0			                                           
const float WRECKING_BALL_JUMP_PAD_WINDOW			= 0.2			                                                                                    
const float WRECKING_BALL_FORCE_TO_MOVE				= 600.0			                                                                           
const float WRECKING_BALL_TRACE_RADIUS				= 40.0			                                                                                                                                                    

                   
const float WRECKING_BALL_DESTORY_DEVICE_RANGE 		= 450
const float WRECKING_BALL_DAMAGE_DEVICE_RANGE 		= 100
      

         
const asset WRECKING_BALL_PROJ_WRECKING_BALL 		= $"mdl/props/madmaggie_ultimate_ball_static/madmaggie_ultimate_ball_static.rmdl"
const asset WRECKING_BALL_ANIM_MODEL 				= $"mdl/props/madmaggie_ultimate_ball/madmaggie_ultimate_ball.rmdl"
const asset WRECKING_BALL_PIECE_MODEL				= $"mdl/props/madmaggie_ultimate_mine/madmaggie_ultimate_mine.rmdl"                                                     

                
const asset WRECKING_BALL_GROUND_IMPACT_SMALL_FX	= $"earthshaker_impact_exp_OS_small"
const asset WRECKING_BALL_FINAL_EXPLODE_FX			= $"P_mm_ball_exp_default"
const asset WRECKING_BALL_PIECE_LOOP_FX				= $"P_mm_roll_pcs_hld"
const asset WRECKING_BALL_PIECE_FLYING_FX			= $"P_mm_roll_pcs_brk"
const asset FX_SPEED_BOOST_ACTIVE 					= $"P_mm_boost_body_human"
const asset FX_SPEED_BOOST_HUD 						= $"P_mm_player_boost_screen"
const asset WRECKING_BALL_RADIUS_FX 				= $"P_mm_roll_ball_hld"
const vector COLOR_SPEEDBOOST_START 				= <250, 247, 93>
const vector COLOR_SPEEDBOOST_MID 					= <250, 255, 185>
const vector COLOR_SPEEDBOOST_END 					= <255, 255, 255>

             
const string SOUND_SPEED_BOOST_ACTIVE_1P 			= "Maggie_Ult_SpeedBoost"
const string SOUND_SPEED_BOOST_ACTIVE_3P 			= "Maggie_Ult_SpeedBoost_3p"
const string SOUND_SPEED_BOOST_LOOP_1P				= "Maggie_Ult_SpeedBoost_Loop_1P"
const string SOUND_SPEED_BOOST_END					= "Maggie_Ult_SpeedBoost_Deactivate_1P"
const string SOUND_SPEED_BOOST_REACTIVE_1P 			= "Maggie_Ult_SpeedBoost_Reactive"
const string SOUND_SPEED_BOOST_REACTIVE_3P 			= "Maggie_Ult_SpeedBoost_Reactive_3p"
const string SOUND_WRECKING_BALL_WARNING_SOUND 		= "Maggie_Ultimate_Ball_Enemy_Warning"					                                                                                  
const string SOUND_WRECKING_BALL_GROUND_IMPACT		= "Maggie_Ultimate_Phys_Imp_Lootball_Hard_Default"
const string SOUND_WRECKING_BALL_OTHER_IMPACT		= "Maggie_Ultimate_Phys_Imp_Lootball_Hard_Default"
const string SOUND_WRECKING_BALL_FINAL 				= "Maggie_Ult_Ball_Explode"								                 
const string SOUND_WRECKING_BALL_ACTIVE				= "Maggie_Ultimate_Ball_Actve_Loop"						                                                  
const string SOUND_WRECKING_BALL_EJECT				= "Maggie_Ultimate_Ball_Sides_Eject"

const bool DEBUG_PROP_COUNT							= false

struct WakeInfo
{
	int touchingTriggers = 0
	array<int> statusEffectHandles = []
	entity fxHandle_3p = null
}

struct
{
	table< entity, WakeInfo > entitiesTouchingSpeedTriggers
	table< entity, WeaponPrimaryAttackParams > storedAttackParams
	table< entity, entity > playerBallWeapons
#if SERVER && DEV
	             
	                                  
#endif

#if CLIENT
	int fxHandle_1p = -1
#endif

	bool balance_wreckingBallSlipSlide
	bool balance_wreckingBallPauseRegen
	bool balance_wreckingBallFindWayAroundWalls
	bool balance_wreckingBallBounce
	bool balance_wreckingBallPunt
	bool balance_wreckingBallProximityDetonate
	int balance_wreckingBallDamageFinal
	float balance_wreckingBallBallDuration
	float balance_wreckingBallWakeDuration
	float balance_wreckingBallWakeBuffDuration
	float balance_wreckingBallShellshockChargeTime
	float balance_wreckingBallShellshockDurationMin
	float balance_wreckingBallShellshockDurationMax
	float balance_wreckingBallShellshockDurationAlly
	float balance_wreckingBallPuntPower
	float balance_wreckingBallPuntPowerAlly

	                     
	bool fxOption_pieceHighlight
	bool fxOption_pieceLoopFX
	bool fxOption_playTempFX

	bool fxOption_playTempSound

	bool pingWreckingBallOnCast

                   
#if SERVER
	                              
	                             
#endif
      
} file

void function MpAbilityWreckingBall_Init()
{
	RegisterSignal( "WreckingBall_CleanupFX" )
	RegisterSignal( "WreckingBall_PieceHitGround" )
	RegisterSignal( "WreckingBall_SpeedBoostEnd" )

	PrecacheParticleSystem( FX_SPEED_BOOST_HUD )
	PrecacheParticleSystem( WRECKING_BALL_GROUND_IMPACT_SMALL_FX )
	PrecacheParticleSystem( WRECKING_BALL_FINAL_EXPLODE_FX )
	PrecacheParticleSystem( FX_SPEED_BOOST_ACTIVE )
	PrecacheParticleSystem( WRECKING_BALL_PIECE_LOOP_FX )
	PrecacheParticleSystem( WRECKING_BALL_PIECE_FLYING_FX )
	PrecacheParticleSystem( WRECKING_BALL_RADIUS_FX )

	PrecacheModel( WRECKING_BALL_PROJ_WRECKING_BALL )
	PrecacheModel( WRECKING_BALL_PIECE_MODEL )
	PrecacheModel( WRECKING_BALL_ANIM_MODEL )

	file.balance_wreckingBallPauseRegen			= GetCurrentPlaylistVarBool( "wrecking_ball_pause_regen_override", false )
	file.balance_wreckingBallFindWayAroundWalls	= GetCurrentPlaylistVarBool( "wrecking_ball_find_way_around_override", true )
	file.balance_wreckingBallBounce 			= GetCurrentPlaylistVarBool( "wrecking_ball_bounce_override", true )
	file.balance_wreckingBallProximityDetonate 	= GetCurrentPlaylistVarBool( "wrecking_ball_proxy_detonate_override", true )
	file.balance_wreckingBallPunt 				= GetCurrentPlaylistVarBool( "wrecking_ball_punt_override", true )
	file.balance_wreckingBallSlipSlide 			= GetCurrentPlaylistVarBool( "wrecking_ball_slipslide_override", true )
	file.balance_wreckingBallDamageFinal 		= GetCurrentPlaylistVarInt( "wrecking_ball_damage_final_override", WRECKING_BALL_DAMAGE_FINAL )
	file.balance_wreckingBallBallDuration 		= GetCurrentPlaylistVarFloat( "wrecking_ball_ball_duration_override", WRECKING_BALL_BALL_DURATION )
	file.balance_wreckingBallWakeDuration 		= GetCurrentPlaylistVarFloat( "wrecking_ball_wake_duration_override", WRECKING_BALL_WAKE_DURATION )
	file.balance_wreckingBallWakeBuffDuration 	= GetCurrentPlaylistVarFloat( "wrecking_ball_wake_duration_override", WRECKING_BALL_WAKE_BUFF_DURATION )
	file.balance_wreckingBallShellshockChargeTime = GetCurrentPlaylistVarFloat( "wrecking_ball_shellshock_charge_time_override", WRECKING_BALL_SHELLSHOCK_CHARGE_TIME )
	file.balance_wreckingBallShellshockDurationMin = GetCurrentPlaylistVarFloat( "wrecking_ball_shellshock_duration_min_override", WRECKING_BALL_SHELLSHOCK_DURATION_MIN )
	file.balance_wreckingBallShellshockDurationMax = GetCurrentPlaylistVarFloat( "wrecking_ball_shellshock_duration_max_override", WRECKING_BALL_SHELLSHOCK_DURATION_MAX )
	if ( file.balance_wreckingBallShellshockDurationMin > file.balance_wreckingBallShellshockDurationMax )
		file.balance_wreckingBallShellshockDurationMin = file.balance_wreckingBallShellshockDurationMax
	file.balance_wreckingBallShellshockDurationAlly = GetCurrentPlaylistVarFloat( "wrecking_ball_shellshock_duration_ally_override", WRECKING_BALL_SHELLSHOCK_DURATION_ALLY )
	file.balance_wreckingBallPuntPower 			= GetCurrentPlaylistVarFloat( "wrecking_ball_punt_power_override", WRECKING_BALL_PUNT_POWER )
	file.balance_wreckingBallPuntPowerAlly 		= GetCurrentPlaylistVarFloat( "wrecking_ball_punt_power_ally_override", WRECKING_BALL_PUNT_POWER_ALLY )

	                     
	file.fxOption_pieceHighlight				= GetCurrentPlaylistVarBool( "wrecking_ball_fx_piece_highlight", false )
	file.fxOption_pieceLoopFX					= GetCurrentPlaylistVarBool( "wrecking_ball_fx_piece_loop_fx", true )
	file.fxOption_playTempFX					= GetCurrentPlaylistVarBool( "wrecking_ball_fx_play_temp_fx", true )

	                         
	file.fxOption_playTempSound					= GetCurrentPlaylistVarBool( "wrecking_ball_fx_play_temp_sounds", true )

	file.pingWreckingBallOnCast					= GetCurrentPlaylistVarBool( "wrecking_ball_ping_on_cast", false )

	#if SERVER
		                                                                                     
		                                                                                 
		                                                                                           
		                                                                                                  
		                                                 
		                                              
		                                                 
		                                             
		                                          
		                                                        
		                                                    

                     
		                                                               
		                                                              
        

	#endif         

	#if CLIENT
		RegisterSignal( "WreckingBall_Throw" )
	#endif

	#if SERVER && DEV
		                                                                   
	#endif

	Remote_RegisterClientFunction( "ServerCallback_RT_SpeedupHudForPlayer", "int", 0, 999 )
	Remote_RegisterClientFunction( "ServerCallback_RT_CleanupSpeedupHudForPlayer" )
	Remote_RegisterClientFunction( "ServerCallback_PrototypeManageHighlight", "entity" )
}

                                  
                                  
                                  

var function OnWeaponTossReleaseAnimEvent_WeaponWreckingBall( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	entity player = weapon.GetWeaponOwner()

	file.storedAttackParams[ player ] <- attackParams
	weapon.EmitWeaponSound_1p3p( GetGrenadeThrowSound_1p( weapon ), GetGrenadeThrowSound_3p( weapon ) )
	vector throwerVelocity = player.GetVelocity()

	bool projectilePredicted      = PROJECTILE_PREDICTED
	bool projectileLagCompensated = PROJECTILE_LAG_COMPENSATED
	#if SERVER
		                                        
		 
			                           
			                                
		 
	#endif
	entity ballProjectile = WreckingBall_Launch( weapon, attackParams.pos, (attackParams.dir), projectilePredicted, projectileLagCompensated )
	if ( ballProjectile )
	{
		PlayerUsedOffhand( player, weapon, true, ballProjectile )
		#if SERVER
			                                          
			                                     
			                                   

			                                                            
			                            
				                                                    

			                                                                          
			                     
			                                                                                                      
			                                                           

			                                             

			                                                           

		                                                                                                                                                            

		                                          
				                                             
		#endif         

		#if CLIENT
			Signal( weapon, "WreckingBall_Throw" )

		#endif
	}

	return weapon.GetAmmoPerShot()
}

void function OnWeaponTossPrep_WeaponWreckingBall( entity weapon, WeaponTossPrepParams prepParams )
{
	weapon.EmitWeaponSound_1p3p( GetGrenadeDeploySound_1p( weapon ), GetGrenadeDeploySound_3p( weapon ) )
}

bool function OnWeaponAttemptOffhandSwitch_ability_WreckingBall( entity weapon )
{
	if ( weapon.GetAmmoPerShot() < weapon.GetWeaponPrimaryClipCount() )
		return false

	entity player = weapon.GetWeaponOwner()
	if ( player.IsPhaseShifted() )
		return false

	return true
}

void function OnProjectileCollision_ability_WreckingBall( entity projectile, vector pos, vector normal, entity hitEnt, int hitbox, bool isCritical, bool isPassthrough )
{
#if SERVER
	                                     

	                         
	 
		                    
		      
	 
	                                                                                                                 

	                                                                                      
	                                                             
#endif         
}

void function OnProjectileCollision_ability_WreckingBall_Piece( entity projectile, vector pos, vector normal, entity hitEnt, int hitbox, bool isCritical, bool isPassthrough )
{
	if ( hitEnt.IsPlayer() )
		return

	if ( hitEnt.IsProjectile() )
		return

	if ( !LegalOrigin( pos ) )
		return

	                      
	if ( projectile.GrenadeHasIgnited() )
		return

	projectile.GrenadeIgnite()
	projectile.SetVelocity( <0,0,0> )
	projectile.ClearParent()
	projectile.SetPhysics( MOVETYPE_FLY )

	#if SERVER
		                                                  
		                                                          
	#endif
}

entity function WreckingBall_Launch( entity weapon, vector attackPos, vector throwVelocity, bool isPredicted, bool isLagCompensated )
{
	#if CLIENT
		if ( !weapon.ShouldPredictProjectiles() || !isPredicted )
			return null
	#endif

	int damageFlags = weapon.GetWeaponDamageFlags()
	WeaponFireGrenadeParams fireGrenadeParams
	fireGrenadeParams.pos = attackPos
	fireGrenadeParams.vel = throwVelocity
	fireGrenadeParams.angVel = <10, 1600, 10>
	fireGrenadeParams.fuseTime = weapon.GetGrenadeFuseTime()
	fireGrenadeParams.scriptTouchDamageType = (damageFlags & ~DF_EXPLOSION)                                                                                 
	fireGrenadeParams.scriptExplosionDamageType = damageFlags
	fireGrenadeParams.clientPredicted = isPredicted
	fireGrenadeParams.lagCompensated = isLagCompensated
	fireGrenadeParams.useScriptOnDamage = true
	entity ball = weapon.FireWeaponGrenade( fireGrenadeParams )
	if ( ball == null )
		return null

	#if SERVER
		                                      
		                       
		 
			                                
			 
				                                 
			 
			    
			 
				                          
				                                     
			 
		 
	#endif

	ball.proj.savedOrigin = attackPos
	Grenade_Init( ball, weapon )

	return ball
}

void function OnWreckingBallDeployed( entity projectile, DeployableCollisionParams collisionParams )
{
	#if SERVER
	                                     

	                         
		      

	                                                                                                                 

	                                                                                      
	                                                             
	#endif         
}

#if SERVER
                                                                    
 
	                         
		      

	                                                                 
	 
		                                       
		      
	 

	                                                        
	                                                      

	                                                                         
	                                                                                                      
	                          

	                                             
	 
		                                                                                                                           
		                                                                                                                                                              

		                                                                                             
	 

	                                                    

	                          
	 
		                                          
		                                                                                     
		 
			                                       
			                                                                    
			                                                  
		 
	 

	                        
		                                                         

	                                    
		                                                                                                                                         
 

                                                                      
 
	                         
		      

	                                                                                                                    
	 
		                                     
		      
	 

	                                       
 

                                                                                                         
 
	                                                                                                                              
	                                                                  
	                                
	                                  
	                        
	                                            
	                                  
	                               
	                                             
	                                            
	                                     

	                    
 

                                                                      
                                     
                                                                     
 
	                            
		      

	             

	                                              

	            
		                          
		 
			                                         
			                 

			                                        
				                                                           

			                           
				                   
		 
	 

	                                                                                                   
	                                        
	                                      

	                                                          

	                     
	 
		                                                         
		                                   
		                             
	 

	                                                                                                
	 
		                                   
		                                                                                 
		 
			           
		 
	 
 

                                                                                           
 
	                                    
	                                      
	                                     

	                                                 
	                      
	                                                 
	                        
	                        
	                         
	                       
	                          
	                   
	                              
	                                                    
	                          
	                                     
	                                        
	                                
	                     

	                       
		                                 

	                                         

	                                                                           
	                          
	                                             
	 
		                                                                   
			        

		                    
		                       
		                                                          
	 

	                    
		           

	                    

	           
 

                                                                       
 
	                       				       
	                                   	     		                                             
                    
	                                   	     		                                     
      
                                                                                 
       
	                                	       		                                                                           
	                                	      		                                                                                         
	                              		      		                                                                                  

	                               		     
	                                 	     
	                                	     

	                                	   			                                                                                     

	                                                                      
                    
	                                       			    	                                                                                                                                   
      
                                                                                                                                                                                    
       
	                                  				      	                                                                                                                                                            
	                                    			       	                                                     

	             				                 
	                         	        
	                  			                                                            
	                          	     
	                                   
	              				                       
	            				                             
	                  			                            
	                    		   

	                                                                                             
	                                
	                             

       
	                       
		                  
      

	                       
	                                  
	 
		                                                                                                                          
		                                                                
		                                            
	 
	                   
	                                                                                         
	                              
		      

	                      

	                    
	                                                                                                                                         
	                                                                                                                                                                           
	                                                                                                                                                                  
	                                                          
	                                      
	                             
	                                                                                  
	                                                           

	                   
	                                                                                                                                                               
	                                     
	                                               
	                                 

	            
		                                         
		 
			                                                              
			 
				                                                          
				                                                                         
					                                                
			 

			                             
				                     

			                      
				              
		 
	 

	                        

	                                                     
	 
                     
		                                         
		                                                                              
		                                    
		 
			                                                         
				        

			                             
			                        
			                                                            

			                                                                
		 

		                                                                             
		                                    
		 
			                                                         
				        

			                             
			                        
			                                                            

			                                                                                                   
		 
		                                       
        


		                         
		                      
			                          

		                                                 
		 
			                                                                   
			 
				                                                            
				     
			 
			                                                                                              
			 
				                             
				                                                         
				                                                            
			 
		 

		                                       
		 
			                                         
			                                                                                                                

			                 
			                          
				                                                                                                                                   
			    
				                                                                                                                                   

			                                                                                                             

			                                                                                                                                                                                                                
			                                                                                                                                                                                                  

			                                          

			                                                    
		 

		                           
	 

	                                                                                                                
	                      
		                                         
 
                   
                                                                             
 
	                                                                                                                                              
 

                                                                            
 
	                                                                                                                                            
 

                                                            
 
	                                                                   
 

                                                             
 
	                                                                    
 
      

                                          
                                          
                                          

                                                                                                      
 
	                                    

	                               
		                                                                                                         
 

                                                                                          
 
	                                                                          
	                                                              
	                                                                                                                            

	                                      
	 
		                                      

		                                                                                                                                                                         
		                                   
			           

		                                                                       
			           

		                                    
			           
	 

	            
 

                                                              
 
	                                      
	                              

	                         
		                                                                                             

	                                        
	                                                                                     

	                                                                                                                                 

	                                  
		                                                                              

	                                                                                                             
	                                                              
	                           
	                                     

	                                                                                                                                                                

	                                         
	                                                                    

	                                                                                                                 
	                                                                                                                 
 

                                          
                                          
                                          

                                                                                                             
 
	                                                   
	                         
	                                                               
	                                                            
	                             
	                             
	                           
	                                                       
	                                                       
	                                   
	                                      
	                                        
	                                                                 
	                                                               
	                             

	                                               
	 
		                                          
		                            
	 
	                        
	                                    

	                                                                  
	                                                                             

	            
		                         
		 
			                         
				                 
		 
	 

	                                                    
	  	                                          
	      
	             
 

                                                                       
 
	                                                        
		      

	                                                   
	 
		           
		                                               
		                                                                          
	 

	                                                                      
	 
		                                                            
		                                                                                 

		                                                                      
		 
			                                                                      
			                                                                        
			                                                                    
		 
		    
		 
			                                                                        
			                                                                          
		 

		                                                       
		                                                                                                        
		                                                               
		                                                                              

		                                              

		                                                                                                                                                   
	 
	                                                                          
	 
		                                                               
	 
 

                                                                       
 
	                                                                                                                                        
	 
		                                                               

		                                                                       
			                                           
	 
 

  
                                                                                    
 
	                                                                                                                              
	 

	 
 
  

                                                                                                     
 
	                                                                         

	                                                              
	                                                                                       
	 
		                                                                           
		 
			                                      
			                                                                                                        
		 
		    
		 
			                                                                                                      
		 
	 

	            
		                                            
		 
			                        
			 
				                                                                   
				                                               
				                                                                                                                                             

				                        
					                                           
			 
		 
	 

	                                                                                   
	                                           	       
	                                           	      
	             
	 
		                                                                                                
			                                                                
		                                                                                                       
			                                                                

		                                                                                             
		                                                   

		                                              
		 
			                                                                           
				                                      
			                                                                                                        
		 
		                                                                                                                            
		 
			                                                                          
				                                                                                              
		 
		           
	 
 

                                                           
 
	                                                                                                                     
		                                                                  
	                                                                   
	                                                                                     
	                            
	                                                                    
 

                                                      
 
	                                                     
	                                                                    
	 
		                                     
		      
	 
	                                                                                                   

	                                                   

	                                                                       
		                                                                                                

	                                         
		                                                              

	            
		                     
		 
			                                                                                                                                        
				                                     
			                                
				                                               
		 
	 

	                                                    
	                                                                

	                                              
 

                                                          
 
	                                                                       
		                                                                                           

	                                         
		                                 

	                                                   
	                                                                  
	                                                   
	                                                
	                                           
 

                                                                             
 
	                      
		            

	                                      
		            

	                      
		            

	                                                                
		            

	                                    
		            

	           
 

                                                                        
 
	                                           

	              

	                          
	 
		                                                                             
		                                                                 
		                                                                                                                     
		                                              

		           
	 
 

                                                                                                         
 
	                             
	                  
	                                                                                 
	                                     
	 
		                                                               
		                                                          
		 
			                                                                        
			                         
			                       
		 
	 

	                                       
	                                                                               

	                                            
	 
		                                  
		                       
		                   
		                                
		                                                                                                           
		 
			                       
	 

	                              
	                                            
	 
		                                            
		                          
	 

	              
 

                      
                                                                                                         
 
	                                      		      	                                                                                       
	                                       		      	                                                                                          
	                             				     	                   
	                                      		      
	                                      		      
	                      						     

	                                                                                                                                  

	                                                                                                                                
	                                                                                                                
	                                                              
	                             
	                       
	                              
	                                         
	                                      
	                                           
	                                           
	                                  
	                                           
	                                                

	                 
		                                                                               
	      

	                                                                                                              
	                                  

	                       
		                                         

	  
	                                               
	                                                                                                                      
	                                      
	                     
	                                            
	                                         
	                                                                
	                 
	                        
	                                         

	                                    
	  

       
	                       
	 
		                 
		                                                  
	 

	            
	 
		                                          
		                                                                
		                                                            
		                                                                      
	 
      

	                                   
	 
		                                                                                                                                     
		                                                                                            
	 

	                               
	                                            
	                                          
	                                                      

	                     
		                                           

	                                                         
	                                                                      
	                                                    

	                                                            
 

                                                                 
 
	                               
	                                    
	                                            

	                            
	 
		                                          
		                                 
		                                                                                    
	 
 

                                                                 
 
	                                    
	                              

	            
		                                 
		 
			                            
				                    
		 
	 

	                                     
 


                                                                       
 
	                                                                                                      

	                                                                                                                                   

	                                                                                                                               
		                                                                    

	            
		                      
		 
			                       
				               
		 
	 

	             
 

                                                                          
 
	                               
		      

	                                                          
	                                                    
	                                                                       

	                                                                                                                    
	             
		                         
		                                   
		                         
		  
		  
		                                                  
		                                                  
		                                 
		                          
		                    
		             
		                                              

	                                                                                                                                
		                                                                    

	                                                                                                                                                       

	            
		                                       
		 
			                          
				                  

			                              
			 
				                                                        
				                      
			 
		 
	 

	                                                  
		                                          
	    
		             
 

                                                                                                   
 
	                                         
	                                                                                

	                                         
	              
	 
		           

		                               
		 
			                                                      
			                                                                                                       
			                                                                    
			                            
		 
		    
		 
			     
		 
	 
 
#endif         

#if CLIENT
void function ServerCallback_RT_SpeedupHudForPlayer( int statusEffect )
{
	entity player  = GetLocalViewPlayer()

	if ( !IsValid( player.GetCockpit() ) )
		return

	if ( file.fxHandle_1p != -1 )
		return

	int fxHandle   = StartParticleEffectOnEntity( player.GetCockpit(), GetParticleSystemIndex( FX_SPEED_BOOST_HUD ),
		FX_PATTACH_ABSORIGIN_FOLLOW, ATTACHMENTID_INVALID)
	EffectSetIsWithCockpit( fxHandle, true )
	file.fxHandle_1p = fxHandle

	thread WreckingBall_SpeedupHudThread( player, fxHandle, statusEffect )}

void function ServerCallback_RT_CleanupSpeedupHudForPlayer()
{
	Signal( GetLocalViewPlayer(), "WreckingBall_CleanupFX" )
}

void function ServerCallback_PrototypeManageHighlight( entity prop )
{
	if ( IsValid( prop ) )
		ManageHighlightEntity( prop )
}

void function WreckingBall_SpeedupHudThread( entity viewPlayer, int fxHandle, int statusEffect )
{
	EndSignal( viewPlayer, "OnDeath", "WreckingBall_CleanupFX" )

	OnThreadEnd(
		function() : ( viewPlayer, fxHandle )
		{
			if ( !EffectDoesExist( fxHandle ) )
				return

			EffectStop( fxHandle, false, true )

			if ( file.fxHandle_1p != -1 )
				file.fxHandle_1p = -1
		}
	)

	while ( StatusEffect_GetSeverity( viewPlayer, statusEffect ) > 0.0 )
		WaitFrame()
}
#endif         

#if SERVER && DEV
                                                  
 
	                                                          
	                                     
	 
		                        
			                 
	 
 

                                                        
 
	                                                                      
 
#endif

#if SERVER
                                                                                        
 
	                      
		      

	                                                  
	 
		                                                                      
		                                 
		 
			                                                  
		 

		                                                           
		                                                              
	 
	                                                     
	 
		                                                           
	 

 

                                                                              
 
	                                                            
	 
		                                                         
		                              
		                     
		 
			                                                                     
				                                                                
					                                                       
					                                        
				   
		 
		            
	 

	           
 
#endif