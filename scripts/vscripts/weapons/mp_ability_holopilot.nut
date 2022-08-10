global function OnWeaponPrimaryAttack_holopilot
global function OnWeaponChargeLevelIncreased_holopilot
global function OnWeaponActivate_holopilot
global function PlayerCanUseDecoy
#if CLIENT
global function CreateARIndicator
#endif

const string FLASH_DECOY_IMPACT_TABLE = "exp_emp"

global const int DECOY_FADE_DISTANCE = 16000                                          
const float DECOY_PING_MIN_DURATION = 1.5
const float DECOY_PING_MAX_DURATION = 8.0
const float ULTIMATE_DECOY_DURATION = 5.0

global const vector HOLOPILOT_ANGLE_SEGMENT = <0, 60, 0>
global function Decoy_Init

const DECOY_AR_MARKER = $"P_ar_ping_squad_CP"
const float DECOY_TRACE_DIST = 5000.0

global function CodeCallback_PlayerDecoyStateChange
#if SERVER
                                           
                                                
                                              
                                     
                                 
                                         
                                             
                                           
                                                      
#endif          

global const SOUND_DECOY_CONTROL = "Mirage_PsycheOut_ModeSwitch"
global const SOUND_DECOY_RELEASE = "Mirage_PsycheOut_ModeSwitch"

global const string DECOY_SCRIPTNAME = "controllable_decoy"
global const string CONTROLLED_DECOY_SCRIPTNAME = "controlled_decoy"

const DECOY_FLAG_FX = $"P_flag_fx_foe"
const HOLO_EMITTER_CHARGE_FX_1P = $"P_mirage_holo_emitter_glow_FP"
const HOLO_EMITTER_CHARGE_FX_3P = $"P_mirage_emitter_flash"
const asset DECOY_TRIGGERED_ICON = $"rui/hud/tactical_icons/tactical_mirage_in_world"

enum eDecoyReceiveDamage
{
	NORMAL,
	FATAL,
	ZERO_DAMAGE,
}

struct
{
	#if SERVER
		                           
		                            
		                            
	#endif

	float decoyDuration

	float decoy_ping_min_duration = 3.0
	float decoy_ping_max_duration = 8.0
	float decoy_cloak_duration = 0.0
	float decoy_cloak_fadein = 0.0

	bool decoyFlashEnabled
} file

void function Decoy_Init()
{
	file.decoyFlashEnabled = GetCurrentPlaylistVarBool( "mirage_flashbang_decoys", false )

	Remote_RegisterServerFunction( "ClientCallback_ToggleDecoys" )

	#if SERVER
		                                              
		                                 
		                                    
		                                

		                                                   
		                                                   

		                             
			                                                     
	#else
		PrecacheParticleSystem( DECOY_AR_MARKER )

		AddCreateCallback( "player_decoy", OnDecoyCreate )

		RegisterConCommandTriggeredCallback( "+scriptCommand5", AttemptToggleDecoys )
	#endif

	file.decoy_ping_min_duration = GetCurrentPlaylistVarFloat( "mirage_sonar_min_duration", 0.0 )
	file.decoy_ping_max_duration = GetCurrentPlaylistVarFloat( "mirage_sonar_max_duration", 0.0 )

	file.decoy_cloak_duration = GetCurrentPlaylistVarFloat( "mirage_decoy_cloak_duration", 0.0 )
	file.decoy_cloak_fadein = GetCurrentPlaylistVarFloat( "mirage_decoy_cloak_fadein", 2.5 )

	file.decoyDuration = GetCurrentPlaylistVarFloat( "mirage_decoy_duration", 60.0 )
}

#if SERVER
                                                  
 
	                                                                                                                                                     
	 
		                      
		                                   
	 
 

                                                        
 
	                        
		      

	                                            

	                                       
	 
		                    
		 
			                
			                
		 
	 

	                                                                                                                     

	                                                     
	 
		                                        
	 

	                                 
 

                                                  
 
	                                         
	                            
	 
		                                                                                    
		 
			                                                                                                           
			                                                                                                             
		 
	 

	                                   
 

                                                                           
                                                                                                 
 
	             
	                             
 

                                                                                
 
	             
	                             
 

                                                                              
 
	             
 
#endif          

void function CodeCallback_PlayerDecoyStateChange( entity decoy, int previousState, int currentState )
{
	             
}


var function OnWeaponPrimaryAttack_holopilot( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	entity weaponOwner = weapon.GetWeaponOwner()
	Assert( weaponOwner.IsPlayer() )

	if ( !PlayerCanUseDecoy( weaponOwner ) )
		return 0

	int chargeLevel = weapon.IsChargeWeapon() ? weapon.GetWeaponChargeLevel() : 1
	if ( weapon.GetWeaponChargeLevelMax() > 1 )
		chargeLevel *= 2                                                                              
	                                                                                                                                         
	#if SERVER
		                                                
                       
			                                                       
			 
				                                              
				                                  
				                                                                               
			 
                             
		                                                                                         
		                                           
		                                      
			           
		                             

		                      
		 
			                                   
			                          
		 
		                             

		                                           
		                       
		 
			                                                                                      
		 
	#else
		if ( chargeLevel == 1 )
			CreateARIndicator( weaponOwner )
	#endif

	PlayerUsedOffhand( weaponOwner, weapon )

	return weapon.GetWeaponSettingInt( eWeaponVar.ammo_min_to_fire )                
}

#if SERVER
                                                    
 
	                             
	                                  

	                        
	                              

	                                                  
	 
		                        
		 
			                                          
			      
		 

		           
	 
 

                                                        
 
	                             
	                                  

	                                                           

	                        
	 
		                                          
		 
			                       
			 
				                                                            
			 
		 
	 

	                                                  
	 
		           
	 

	                                     
 

                                                          
 
	                               

	                                     
		      

	                              
 

                                                   
 
	                                                           

	                        
	 
		                                       
		 
			                                                                                        
			                                      
		 
	 
 

#endif

#if CLIENT
void function CreateARIndicator( entity player )
{
	vector decoyPos
	bool validPos = false
	if ( player.HasThirdPersonAttackFocus() )
	{
		decoyPos = player.GetThirdPersonAttackFocus()
		validPos = true
	}
	else
	{
		vector eyePos      = player.EyePosition()
		vector viewVector  = player.GetViewVector()
		TraceResults trace = TraceLine( eyePos, eyePos + (viewVector * DECOY_TRACE_DIST), player, TRACE_MASK_PLAYERSOLID, TRACE_COLLISION_GROUP_PLAYER )
		if ( trace.fraction < 1.0 )
		{
			decoyPos = trace.endPos
			validPos = true
		}
	}

	if ( validPos )
	{
		TraceResults trace = TraceLine( decoyPos, decoyPos + <0, 0, -2000>, player, TRACE_MASK_PLAYERSOLID, TRACE_COLLISION_GROUP_PLAYER )
		int arID           = GetParticleSystemIndex( DECOY_AR_MARKER )
		int fxHandle       = StartParticleEffectInWorldWithHandle( arID, trace.endPos, trace.surfaceNormal )
		EffectSetControlPointVector( fxHandle, 1, FRIENDLY_COLOR_FX )
		thread DestroyAfterTime( fxHandle, 1.0 )
	}
}

void function DestroyAfterTime( int fxHandle, float time )
{
	OnThreadEnd(
		function() : ( fxHandle )
		{
			if ( !EffectDoesExist( fxHandle ) )
				return

			EffectStop( fxHandle, true, true )
		}
	)
	wait(time)
}
#endif

#if SERVER
                                                      
                                                                                                                                                                                                          
 
	                                  
	                

	                   

	                                          

	                                 

	                                                                                         

	                          
	                                                                                        
	                                                                                                       

	                                        
	                                          
	                                                
	 
		            
		                         
		 
			                         
			                                                                                                                                    
			                                                        
			                                                                                          
			                                                         
			                                                                                                                                        
			                                                                                                
			                                  
			                      
			                                     
			                                                                                                                     
			                                                                                                                            
			                                                                         
			                      
			                         
		 
		                            
		 
			                               
			                                                                                                              
			                                                
			 
				                                                      
				                                                     
				                      
				                        
			 
			    
			 
				        
			 
		 
		    
		 
			                              
			                                                             
			                                                    
			                 
			                                                                        

			               
			                                         
			 
				                                             
			 
			    
			 
				                                                                                                                                                
				                       
			 
			                                                                                                    
			                                                                       
			 
				                                                      
				                                                                
			 
			                      
			                         
		 

		                        
			        

		                                             
		                                                 
		                       
		 
			                          
			                       
			                             
			                                 
		 

		                                       
		                          
		                     
	 

	            
 

                                                                          
 
	                                         
	                              

	            
		                              
		 
			                                               
				                      
			                                                          
		 
	 

	                            
 

  
                                                                     
 
	                      
	                                                                                                              
	                                                                                                                              
	          
 
  

                                                           
 
	                            

	                                                                                         
	                                 
 

                                                                                                   
 
	                             
	                                        
	                              
	            
		                              
		 
			                       
			 
				                             
			 
		 
	 
	                
 

                                                                                                                                                               
 
	                                                                                                                 
	                                  
	                                                                       
	                                 
	                              
	                                                                                         
	                            
	                            
	                                
	                        
	                                 

	                                             
	                                                                        

	                        
	                           

	                                             
	                                                                                                
		                        
			                                                         
	   
	                                                                                                    
		                        
			                                                      
	   
	            
 

                                                                                                                                                                                  
 
	                                                                                                                                
	                                  
	                                                                       
	                                 
	                              
	                                                                                         
	                            
	                            
	                                
	                        
	                                 

	                        
	                                       
	                           

	                                             
	                                                                                                
		                        
			                                                         
	   
	                                                                                                    
		                        
			                                                      
	   
	            
 

                                                                        
 
	                                                      

	                           
		                                 

	                                                          
		                                 

	                       
		                                 

	                                                                                              
	                            
	 
		                                                                                                                                                                  
		 
			                                      
			                                      
		 
	 

	                          
		                                 

	                                 
 

                                                                                        
 
	                                                                    

	                                                 
	 
		                                                     
	 
	                                                            
	 
		                                     
	 
 

                                                                                     
 
	                                                      

	                                                                                                          
		      

	                                                
		      

	                                              
	 
		                                                                                                                                                          
		 
			                                                        
			                                                                 
				      
		 
		    
		 
			      
		 
	 

	                                                                         

	                                       

	                                                             

	                                                          
 

                                                                                                             
 
	                             
		                                                                               

	                                         
	                                                                                        
	                          

	                                                                                     
	                                                                                     

	                                   

	                                                     
		                                                    

	                                                                                             

	                                        
	                                                                                           

	                                      

	                                                                                                 
		                                                        

	                                         

	                  
	 
		                                                  
		                                                                     
	 

	                                    
		                                 

	         
 

          
                                                        
 
	                                   
 

                                                        
 
	                                   
 

                                          
 
	                             

	                                                                         
 

                                                                            
 
	                                   
	                                      
	                             

	                           

	                                               
	                                                                                                                               

	                                                                                              
	                                                      

	            
		                                                         
		 
			                                               

			                        
			 
				                                
			 
		 
	 

	                 
 
      

                                                             
 
	                           
	                                      

	            
		                   
		 
			                    
				            
		 
	 

	        
 

                                                                                          
                                                                    
 
	                                   
	                                  
	                                   
	                                      
	                                   
	                                                                 
	                                            
	                             
	                                         
	                             
	                        
	                                           
	                                       
	                            

	                                                                                      

	                        
	 
		                                                            
	 

	                                  
	                    
	 
		                                                                                            
		                                                                                                      
		                                                                                                  
	 
	    
	 
		                                                                                               
		                                                                                                         
		                                                                                                        
	 

	                                                                
	                                                             
	                                                                    
	                                   

	                                                     

	                                      
	                          
	 
		                         

		                           
		                           
		                                  
		 
			                          
			 
				                
				                     
				     
			 

			                 
			 
				                     
				     
			 
		 

		                                         
		                                                                                 
		 
			                                                                              
			                                                   
			                                                                

			                
				                                              
			    
				                                           
		 

		                                  
	 

	                                                                                                                                   
	                                         
	                                                                

	                                                
	                              
	                                 

	                            
		                               
	  
	                                                         
 

                                                                                       
 
	                             
	                              

	                                                      

	            
		                      
		 
			                       
			 
				                             
			 
		 
	 

	              
	 
		                                                                          

		                                     
			     

		        
	 
 

                                                                                       
 
	                         
		                

	                             
		                                              
	    
		                                               

	           
 

                                                                   
 
	                            
	                                               

	            
		                              
		 
			                               
				                       
		 
	 

	             
 

                                                                
 
	                            
	                                               

	                                         
	                                                                                                                                                                                            
	                                                        

	            
		                                           
		 
			                             
				                     

			                               
				                       
		 
	 

	             
 

#endif          

bool function PlayerCanUseDecoy( entity ownerPlayer )
                                                                       
{
	if ( !ownerPlayer.IsZiplining() )
	{
		if ( ownerPlayer.IsTraversing() )
			return false

		if ( ownerPlayer.ContextAction_IsActive() )                                                                                                     
			return false
	}

	                                                                                                                                

	return true
}

#if SERVER
                                                                                       
 
	                      

	                                  

	                               
	 
		                                                                 
		                                                         

		                                     
		 
			                                              
			 
				                                                                            
				                                  
				                                  
				                       
				                                        
				                                  
				                                                                                        
				                            
				                            
				                                 
				                                
				                                   
				                                                  
				                              
				                                            
				                                                                       
				                         
				                                       
				                                                                                               
					                       
						                                                        
				   
				                                                                                                   
					                       
						                                                     
				   
				                                                           
				             
				                        
			 
			    
			 
				                            
				                            
				                                                                                         
				                                                                                                        

				                                                                                                                   
				                                  
				                                  
				                                
				                                   
				                                       
				                              
				                                            
				                                                                       

				                         
				                                       
				                         
				             
				                        
			 
		 
	 

	                         
	 
		                                                    
			                                                                  
		    
			                                                                  
	 

	               
 
#endif

bool function OnWeaponChargeLevelIncreased_holopilot( entity weapon )
{
	#if CLIENT
		if ( InPrediction() && !IsFirstTimePredicted() )
			return true
	#endif

	int level    = weapon.GetWeaponChargeLevel()
	int maxLevel = weapon.GetWeaponChargeLevelMax()

	if ( level == maxLevel )
	{
		if ( weapon.HasMod( "disguise" ) )
		{
			  	                                                                                                            
			  	                                                                                                  
		}
		else
		{
			  	                                                                                                            
			weapon.PlayWeaponEffect( HOLO_EMITTER_CHARGE_FX_1P, HOLO_EMITTER_CHARGE_FX_3P, "FX_EMITTER_L_01" )
		}
	}
	else
	{
		switch ( level )
		{
			case 1:
				  	                                                                                                  
				  	                                                                                                    
				  	     

			case 2:
				  	                                                                                                  
				  	                                                                                                    
				  	     
			}
	}

	return true
}

#if SERVER
                                             
 
	                                                                
		      

	                                  
 

                                              
 
	                                                                
		      

	                                   
 

                                              
 
	                                                                
		      

	                                   
 

                                                            
 
	                                                                
		      

	                                        
	                                         
	                                         

	                                                                                                            
	                                                  
	                                                                          
	                                                                              
	                               
	 
		                                              
		                            
		 
			                                   
			 
				                               
				                              
				                 
			 
			                                         
			 
				                                
				                               
				                 
			 
			                                         
			 
				                                
				                               
				                 
			 
		 
	 
 
#endif

#if CLIENT
void function OnDecoyCreate( entity decoy )
{
	                                     
}
void function AttemptToggleDecoys( entity player )
{
	if ( !TryCharacterButtonCommonReadyChecks( player ) )
		return

	Remote_ServerCallFunction( "ClientCallback_ToggleDecoys" )
}
#endif

void function OnWeaponActivate_holopilot( entity weapon )
{
	weapon.PlayWeaponEffect( HOLO_EMITTER_CHARGE_FX_1P, HOLO_EMITTER_CHARGE_FX_3P, "FX_EMITTER_L_01" )
	weapon.PlayWeaponEffect( HOLO_EMITTER_CHARGE_FX_1P, HOLO_EMITTER_CHARGE_FX_3P, "FX_EMITTER_L_02" )
	weapon.PlayWeaponEffect( HOLO_EMITTER_CHARGE_FX_1P, HOLO_EMITTER_CHARGE_FX_3P, "FX_EMITTER_L_03" )
	weapon.PlayWeaponEffect( HOLO_EMITTER_CHARGE_FX_1P, HOLO_EMITTER_CHARGE_FX_3P, "FX_EMITTER_L_04" )
	weapon.PlayWeaponEffect( HOLO_EMITTER_CHARGE_FX_1P, HOLO_EMITTER_CHARGE_FX_3P, "FX_EMITTER_L_05" )
}