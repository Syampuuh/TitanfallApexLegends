global function MpWeapon_Mortar_Ring_Missile_Init
global function OnProjectileCollision_ability_mortar_ring_missile

#if SERVER
                                  
#endif

#if CLIENT
global function ClientCodeCallback_MortarRingFireSegmentCreated
#endif

const asset MORTAR_RING_MISSILE_PLAYER_BURN_FX	= $"P_mortar_victim_burning_1p"
const string MORTAR_RING_MISSILE_EXPLOSION_SFX = "Firebomb_Mortar_Missile_Explode"
const string MORTAR_RING_MISSILE_FIRE_START_SFX = "Firebomb_Mortar_Ring_Flame_Start"
const string MORTAR_RING_MISSILE_FIRE_LOOP_SFX = "Firebomb_Mortar_Ring_Flame_Burn"
const string MORTAR_RING_MISSILE_MOVEMENT_SFX = "Firebomb_Mortar_Missile_Trails"
const string MORTAR_RING_AIRBURST_EXPLOSION_VFX = $"P_mortar_air_burst"
const string MORTAR_RING_AIRBURST_EXPLOSION_SFX = "Firebomb_Mortar_Explode"
const asset MORTAR_RING_MISSILE_BURN_FX = $"P_wpn_mortar_firewall"
const asset MORTAR_RING_MISSILE_PREBURN_FX = $"P_mortar_preburn"
const string MORTAR_RING_MISSILE_EXPLOSION_VFX = $"P_wpn_mortar_nade_impact"
const string MORTAR_RING_MISSILE_PLAYER_BURN_COLOR_CORRECTION = "materials/correction/mortar_fire.raw_hdr"
const string KILL_THREAT_INDICATOR_THREAD_SIGNAL = "KillThreatIndicatorThread"
const float MORTAR_RING_MISSILE_WAIT_TIME_SECS = 0.0
const vector MORTAR_RING_MISSILE_EXPLOSION_OFFSET = < 0, 0, 10.0 >
global const string MORTAR_RING_FIRE_TARGETNAME = "mortar_ring_fire"
const float MORTAR_RING_MISSILE_THREAT_INDICATOR_DIST = 165.0
const float MORTAR_RING_MISSILE_SHELLSHOCK_DURATION_PER_TICK = 3.8
const float MORTAR_RING_MISSILE_FIRE_FWD_TRACE_HEIGHT = 60.0
const float MORTAR_RING_MISSILE_FIRE_FWD_TRACE_STEP = 15.0
const float MORTAR_RING_MISSILE_FIRE_DOWN_TRACE_LENGTH = 125.0
const float MORTAR_RING_MISSILE_FIRE_HEIGHT_THRESHOLD = 90.0
const float MORTAR_RING_MISSILE_FIRE_DISTANCE_THRESHOLD = 450.0
const string MORTAR_RING_MISSILE_WEAPON = "mp_weapon_mortar_ring_missle"
const float MORTAR_RING_MISSILE_POST_IMPACT_LIFETIME = 2.5
const float MORTAR_RING_MISSILE_PLAYER_BURN_FX_SEVERITY	= 0.3
const float MORTAR_RING_MISSILE_AMBIENT_GENERIC_HEIGHT_OFFSET= 30.0
const float MORTAR_RING_MISSILE_PREBURN_DURATION = 1.0
const float MORTAR_RING_MISSILE_BURN_DURATION = 15.0
global const float MORTAR_RING_FIRE_SEGMENT_HEIGHT = 65.0
const float MORTAR_RING_FIRE_SEGMENT_WIDTH = 50.0
const float MORTAR_RING_FIRE_SEGMENT_WIDTH_SQR = MORTAR_RING_FIRE_SEGMENT_WIDTH * MORTAR_RING_FIRE_SEGMENT_WIDTH
const float MORTAR_RING_FIRE_SEGMENT_DEFAULT_RADIUS = 50.0
const float MORTAR_RING_MISSILE_EXPLOSION_FX_DURATION = 1.0
const float MORTAR_RING_IN_FIRE_DAMAGE_MULTIPLIER = 1.5
const float MORTAR_RING_COLOR_CORRECTION_BASE_SEVERITY = 0.5
const float MORTAR_RING_COLOR_CORRECTION_LERP_TIME = 1.0
const bool MORTAR_RING_MISSILE_DEBUG = false

                    
const float MORTAR_RING_FIRST_TICK_DAMAGE = 35.0
const float MORTAR_RING_SUBSEQUENT_TICK_DAMAGE = 8.0
const float MORTAR_RING_PREBURN_DAMAGE_PLAYER = 5.0
const float MORTAR_RING_PREBURN_DAMAGE_NON_PLAYER = 10.0
const float MORTAR_RING_MISSILE_DAMAGE_PER_TICK = 12
const int MORTAR_RING_MISSILE_NUM_TICKS = 6
const float MORTAR_RING_MISSILE_TICK_INTERVAL = 0.83

                        
const int MORTAR_RING_NON_PLAYER_BURN_DAMAGE = 50
const float MORTAR_RING_NON_PLAYER_BURN_TIME = 2.8
const int MORTAR_RING_NON_PLAYER_BURN_STACKS_MAX = 4
const float MORTAR_RING_NON_PLAYER_BURN_STACK_DEBOUNCE = 0.7
const float MORTAR_RING_NON_PLAYER_BURN_TICK_RATE = 1.2

const string KILL_BURN_FX_SIGNAL = "MortarRingBurn_Stop"

                        
const float FUSE_MORTAR_SCAN_RADIUS_BASE 	= 300.0
const float FUSE_MORTAR_SCAN_LENGTH_BASE 	= 1000.0
const float FUSE_MORTAR_SCAN_LENGTH_MIN		= 350.0
      

struct
{
	#if SERVER
		                                          
		                                                  
	#endif
	#if CLIENT
		array<entity> mortarRingClientAGs
		int colorCorrection
	#endif
} file

struct FireSegmentData
{
	vector startPos
	vector endPos
	vector angles
	vector dirToCenter
	entity projectile
	entity moveParent
}

void function MpWeapon_Mortar_Ring_Missile_Init()
{
#if CLIENT
	StatusEffect_RegisterEnabledCallback( eStatusEffect.mortar_ring_burn, MortarRingBurn_StartVisualEffect )
	StatusEffect_RegisterDisabledCallback( eStatusEffect.mortar_ring_burn, MortarRingBurn_StopVisualEffect )
	RegisterSignal( KILL_BURN_FX_SIGNAL )
	RegisterSignal( KILL_THREAT_INDICATOR_THREAD_SIGNAL )
	file.colorCorrection = ColorCorrection_Register( MORTAR_RING_MISSILE_PLAYER_BURN_COLOR_CORRECTION )

                        
	StatusEffect_RegisterEnabledCallback( eStatusEffect.mortar_ring_reveal, MortarRingReveal_RevealStatusChanged )
	StatusEffect_RegisterDisabledCallback( eStatusEffect.mortar_ring_reveal, MortarRingReveal_RevealStatusChanged )
      
#endif
#if SERVER
	                                                                                                

                        
	                                                       
	                                                            
	                                                            
	                                                            
	                                                            
                          
		                                                                  
       
	                                                          
	                                                                  
	                                                               
	                                                           
      
#endif

	PrecacheParticleSystem( MORTAR_RING_MISSILE_BURN_FX )
	PrecacheParticleSystem( MORTAR_RING_MISSILE_PREBURN_FX )
	PrecacheParticleSystem( MORTAR_RING_MISSILE_PLAYER_BURN_FX )
	PrecacheParticleSystem( MORTAR_RING_MISSILE_EXPLOSION_VFX )
	PrecacheParticleSystem( MORTAR_RING_AIRBURST_EXPLOSION_VFX )
	PrecacheWeapon( MORTAR_RING_MISSILE_WEAPON )
}

void function OnProjectileCollision_ability_mortar_ring_missile( entity projectile, vector pos, vector normal, entity hitEnt, int hitbox, bool isCritical, bool isPassthrough )
{
	#if SERVER
		                                     

		                       
			      

		                                               
			      

		                            
			      

		                        
			      

		                          
			      

		                                                                               
		  	      

		                                       
		                                                                                                             

		                         
		                                                             
		 
			                                                    
			                   
		 

		                                                        
		                            
		            
		                  
		                  
		                  
		                          
                       
			                                                       
                             

		                   
		 
			                                                                    
				      
		 

		                                                                                          
	#endif          

}

#if SERVER
                        
                                                     
 
	                                                         
 
      

                                                                                                                             
 
	                                   

	                                                           
	                                                              
	                                    
	                 
	                        
	                                                                                          
	                                                  

	                                                                           

	                              
	                                                                                             
	                                   
	 
		                                                                                                                                                                            
			        

		                                         
		                                                                                                                                                         
		                             
			                                                                                                                                    

		                             
		 
			                                                 
			                                               
			                                                               

			                                                                               

			                                                                     
			                                                            
			 
				                                                                             
				                                                                                     
				        
				                                              
			 

			                                                                   
			                                                                                             
				                                                                                                     
		 
	 


	                                                                 
	             
	 
		                       
		 
			                                                                           
			     
		 
		                                    
		 
			                                       
			 
				                                                                                     
				     
			 
		 
		           
	 

	                                     
 

                                                                                                       
 
	                                                                                                                                                             
	                                 
	                                                 
	                                                             
	                                                                                                   

	            
		                            
		 
			                             
				                         
		 
	 

	                                              
 

                                                                                                                     
 
	                                    

	                                        
	                                      
	                     
	                        
	                            
	 
		                                
		                                 
	 

	                              
			                                                                                                                                 
	 
		                                                                                                           
		                               
	 
	    
	 
		                                 
		                                
		                                 
		                                                         

		                                                                                                                       
		                                          
		 
			                                                                                                         
			                               
		 
		    
		 
			                                                                                                            
			                               

			                                                    
			                                                                                                                
			                                                                                                             
			                                
		 
	 


	                                    
	 
		                                    
			                                                                            
			                                                                             
			                                                              
		      
	 


	                                                                        
 

                                                                                                                                                  
 
	                       
	                           
	                       
	                                      
	                                 
	                               
	                        
	 
		                           
		                                                                        
		                                                                            
		                                                                        
	 

	              
 

                                                                                                                                                       
 
	                                                
	                                                                                  
	                                
	                      
	                                             


	                                                                        
	                                                                                                            
	                                                                                                                     
	                                                                                                                                                                             
	                                           
	                   
	 
		                                                         
		                                             
		 
			                             
			                
		 

		                                                          
		                                                                                                                                   
		                                 
		 
			                
		 
		                                    
			                                                                         
		      

		                                                                                                 
		                                                                                                                                          
		                                
			                                                              
			                                                                                        
		 
			                
		 
		    
		 
			                                 
			                                                                                   
		 
		                                    
			                                                                              
		      

		                                                                                               
		 
			                
		 
		                                                                                                      
	 

	                     
 

                                                                                                         
 
	                                    
	 
		                                                    
		           
	 
 


                                                                                  
 
	                                      
	                            
		      
	                                   

	                                         
	                                         
	                                                 
	                                    
	 
		                                                                                       
		                                                                                       
		                                                                                               
	 
	                                                                                                       
	                   
		                                                

	                                                                
	                                                                                 
	                                          
	                                                              
	                                                                                                                                                                                                                        
	                                   
	 
		                                             
		                                              
		                                              
		                                                         
		                                                
		                                              
	 
	                                                                                                                                          

	                                         

	                                                             
	                                                                              
	                                       
	                                                           
	                                                                                                                                                                                                            
	                                   
	 
		                                          
		                                           
		                                           
		                                                      
		                                                         
		                                                       
	 
	                                                                                                    
	                                                                                                                                     

	                                               
		                                                                   
 


                                                                                                                                                                      
 
	                                     
	                                                 
	                                                         
	                                                             

	                                                         
	                               
	                                       
	                                   
	                                                                  
	                                
	                                                
	              
		                                                             
	                                   
	                                      
	                                        
	                                       
	                                             
	                          
	                           
	                        

	                            
	 
		                               
		                                   
	 

	                             
	                                             

	                               
	                                
	                                   

	            
		                                                                   
		 
			                    

			                         
				                 

			                              
				                      

			                                       
				                    
		 
	 

	                                                             
	                                    

	              
	 
		                                    
			                                                                                                                             
			                                                                                            
			                                                                 
			                                                                                   
			                                                                                        
			                                                                                     
		      
		           
	 
 

                                                                             
 
	                                      
		      

	                     
		      

	                                                           
 

                                                                                
 
	                            
	                                

	                                           
	                        
		      
	                               

	                                                 
	                              
		      
	                                     

	                                  
	                               
	                                             
	                                 
	                        

	                                        
	                                                                     
	                                                                
	                                                                            
	                                                                                    
	                                                                          
	                                                                            

	                                  
	                            
	            
		                                     
		 
			                                                              
			 
				                                             
				 
					                                         
				 
			 
		 
	 

	                                   
	 
		                                        
		                                          
		                                  
		                                                                                              
		                             
		                                                                                              
		                                                                
		                                                   
		                                                               
		                                                                               

		                                  
		                                                                                                                            
		                                                                                                    
		                                                                                                                                   
		                                
			                         
			                                                                                                 
			                                           
		 
			             
			 
				                                                          
					                                                
			 
			    
			 
				                                        
				 
					                                  
						                                                                                          

					                                                       
						                                    
				 
				    
				 
					                                                                                        
					              
					 
						                               
						                                                   
						 
							                                                              
							                                  
						 
						                       
						 
							                   

							                                    
								                               

							                                     
								                                                                                                

							                                                          
								                                       
						 
						    
						 
							                 
						 
					 
					                                                                 
				 
			 
		 
		    
		 
			                                                              
			 
				                                             
				 
					                                         
					                           
				 
			 
		 
		           
	 
 
                                                                                  
 
	                               
	                                

	            
		                                 
		 
			                        
				                                                                  
		 
	 

	                                                         
	                                                       
	                                                                         
	                    
	 
		                                                                                             
			                                                                                                                                            
	 
	    
	 
		                                                                                                                                                
	 

	             
 

                                                               
 
	                       
	 
		                             
		                                             
	 
	                               

	                                                                                       
	                                                                                         
	                                                    

	                       
	 
		                                                                            
		                                                                              
	 
	    
	 
		                                                        
	 

	            
		                                                                 
		 
			                        
			 
				                                             
				                                         
				                                                        
				                                                        
				                                                               
			 
		 
	 

	                        
	                 
	              
	 
		           
		                                                                                    
		                                                                         
		                                                                                                                                     
		                                                                                                                        
		                                                                                             
			                                                                                                                 

		                                      

		                                                
			     
	 
 

                                                                                                                                                                      
 
	                                                                                                                
	                            
	                                            

	                                                      
	                                                     

	                   
		                                                           

	             
 

                                                                           
 
	                                                                                                         
	                              
		      
 

                                                           
 
	                                                                    
 

                                                                                                                                                                            
 
	                                                
	                                                                                                                                              
	                                                                                                 

	                    

	                        
		      

	                                                                     
	                                          
		      

	                                                     

	                                                                                                                                        

                        
	                                                   
		                                                                                                                                                  
      

	                                                                                                                                        
	                                    
		                                                               
	      

	                    
	                                                                
	                                  
	                            
	                                               
	 
		                                        
			     

		              

		                           
			        

		                                                                                                               
	 

	                                           
	                                                                     
	 
		                       
		                                                                                  
		                                 
		 
			                                 
		 

		                                                                                         
		                                        
		 
			                                          
			                        
			 
				                                                                                                         
			 
		 
	 

	                                                           
 

                                                                                                                                     
 
	                        
		      

	                                                             
	                                                                                                 
	                                                                               
                                    
	               
		                                                    
	    
		                                                     
      


	                                         
	                              
	                                
	                                                               
	                                                                      
	                                                                   
	                                         
	                                       
	                                          
	                                                           

	                     
	 
		                      
		                                                 
		                                                                                                                           
		                                  

	 

	                        
 

                                                
 
	                             

	                                            
		      

	            
		                     
		 
			                      
			 
				                                                           
			 
		 
	 

	                                                           
	                                 
		           
 

                                                                                                                                                                                 
 
	                    
	                                      
	 
		                  
		                                                       
		               

		                   
		               
		                          
		                       

		                                  
		                                  

		                                                                                              
		                                                                                                                  
		                               

		                            
	 

	             
 

                        
                                                                                                                      
 
	                         
	                     

	                                          

	                          
	                               
	                       

	                                                                      
	                                                            
	                                                                                                
	                                                                                                                                                         
	                             	               
	                       			                                    
	                             	   
	                        
	                         
	                             
	                                        

	            
		                        
		 
			                 
		 
	 

	                                                                                     
	                                                                                     

	                                                   

	               
		                                                                                                                                                              

	                 
 

                                                                                                                                                                                                    
 
	                             
	 
		                                    
		                                      
			                                                                                                                                                                      
	 
 

                                                                              
 
	                         
		      

	                                            
		      

	                                                          
		      

	                                         
		      

	                                                   
	                                                                          
	                                                                   
	                               
	                                 

	                                                                                                
	                                                                        
	                                                                                                             
	                         
		      

	                                            
		                                      

	                                                                  
	                                                                                                 
	                                                                                           
	                                                       
 

                                                                              
 
	                                   
	                                                    
		      

	                                            
		      

	                                            
		      

	                                                     
	                                                                                                 

	                         
		      

	                                             
	 
		                                                      
		                                         
		                                                                  
	 
 
      

#endif

#if CLIENT
                        
void function MortarRingReveal_RevealStatusChanged( entity ent, int statusEffect, bool actuallyChanged )
{
	ManageHighlightEntity( ent )
}
      

void function AddThreatIndicator( entity bomb )
{
	entity player = GetLocalViewPlayer()
	ShowGrenadeArrow( player, bomb, MORTAR_RING_MISSILE_THREAT_INDICATOR_DIST, 0.0 )
}

void function MortarRingBurn_StartVisualEffect( entity ent, int statusEffect, bool actuallyChanged )
{
	if ( !actuallyChanged && GetLocalViewPlayer() == GetLocalClientPlayer() )
		return

	if ( ent != GetLocalViewPlayer() )
		return

	ent.Signal( KILL_BURN_FX_SIGNAL )
	thread MortarRingBurnVFXThink( ent )
}

void function MortarRingBurn_StopVisualEffect( entity ent, int statusEffect, bool actuallyChanged )
{
	if ( !actuallyChanged && GetLocalViewPlayer() == GetLocalClientPlayer() )
		return

	if ( ent != GetLocalViewPlayer() )
		return

	ent.Signal( KILL_BURN_FX_SIGNAL )
}

void function MortarRingBurnVFXThink( entity player )
{
	player.EndSignal( KILL_BURN_FX_SIGNAL )
	player.EndSignal( "OnDeath" )

	int fxid = GetParticleSystemIndex( MORTAR_RING_MISSILE_PLAYER_BURN_FX )
	int fxHandle = StartParticleEffectOnEntityWithPos( player, fxid, FX_PATTACH_ABSORIGIN_FOLLOW, ATTACHMENTID_INVALID, player.EyePosition(), <0,0,0> )
	EffectSetIsWithCockpit( fxHandle, true )
	EffectSetControlPointVector( fxHandle, 1, <MORTAR_RING_MISSILE_PLAYER_BURN_FX_SEVERITY, 999, 0> )
	thread ColorCorrection_LerpWeight( file.colorCorrection, 0, MORTAR_RING_COLOR_CORRECTION_BASE_SEVERITY, MORTAR_RING_COLOR_CORRECTION_LERP_TIME )

	OnThreadEnd(
		function() : ( fxHandle )
		{
			thread ColorCorrection_LerpWeight( file.colorCorrection, MORTAR_RING_COLOR_CORRECTION_BASE_SEVERITY, 0, MORTAR_RING_COLOR_CORRECTION_LERP_TIME )
			if ( EffectDoesExist( fxHandle ) )
				EffectStop( fxHandle, false, true )
		}
	)
	WaitForever()
}

void function ColorCorrection_LerpWeight( int colorCorrection, float startWeight, float endWeight, float lerpTime = 0 )
{
	float startTime = Time()
	float endTime = startTime + lerpTime
	ColorCorrection_SetExclusive( colorCorrection, true )

	while ( Time() <= endTime )
	{
		WaitFrame()
		float weight = GraphCapped( Time(), startTime, endTime, startWeight, endWeight )
		ColorCorrection_SetWeight( colorCorrection, weight )
	}

	ColorCorrection_SetWeight( colorCorrection, endWeight )
}

void function ClientCodeCallback_MortarRingFireSegmentCreated( entity trigger, entity start, entity end )
{
	if ( !IsValid( trigger ) || !IsValid( start ) || !IsValid( end ) )                                                       
		return

	thread MortarRingFireSegmentClientEffects( trigger, start, end )
}

void function MortarRingFireSegmentClientEffects( entity trigger, entity start, entity end )
{
	trigger.EndSignal( "OnDestroy" )
	start.EndSignal( "OnDestroy" )
	end.EndSignal( "OnDestroy" )

	entity localPlayer = GetLocalViewPlayer()
	if( !IsValid( localPlayer ) )
		return
	localPlayer.EndSignal( "OnDestroy" )

	vector startPoint = start.GetOrigin() + ( < 0, 0, 1 > * MORTAR_RING_MISSILE_AMBIENT_GENERIC_HEIGHT_OFFSET )
	vector endPoint = end.GetOrigin() + ( < 0, 0, 1 > * MORTAR_RING_MISSILE_AMBIENT_GENERIC_HEIGHT_OFFSET )
	entity clientAG = CreateClientSideAmbientGeneric( startPoint , MORTAR_RING_MISSILE_FIRE_LOOP_SFX, 0 )
	clientAG.SetSegmentEndpoints( startPoint, endPoint )
	clientAG.SetEnabled( true )
	clientAG.RemoveFromAllRealms()
	clientAG.AddToOtherEntitysRealms( trigger )
	clientAG.SetParent( trigger, "", true )
	file.mortarRingClientAGs.append( clientAG )

	if( file.mortarRingClientAGs.len() == 1 )
		thread ThreatIndicatorThink( localPlayer, MORTAR_RING_MISSILE_THREAT_INDICATOR_DIST )

	OnThreadEnd(
		function() : ( clientAG, localPlayer )
		{
			if ( IsValid( clientAG ) )
			{
				clientAG.Destroy()
			}

			file.mortarRingClientAGs.fastremovebyvalue( clientAG )
			if( IsValid( localPlayer ) && file.mortarRingClientAGs.len() == 0 )
				localPlayer.Signal( KILL_THREAT_INDICATOR_THREAD_SIGNAL )
		}
	)

	WaitForever()
}

void function ThreatIndicatorThink( entity player, float damageRadius )
{
	EndSignal( player, "OnDestroy" )
	EndSignal( player, KILL_THREAT_INDICATOR_THREAD_SIGNAL )

	asset indicatorModel  = GRENADE_INDICATOR_GENERIC
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

	entity cockpit = player.GetCockpit()
	if ( !cockpit )
		return

	EndSignal( cockpit, "OnDestroy" )

	arrow.SetParent( cockpit, "CAMERA_BASE" )
	arrow.SetAttachOffsetOrigin( <25, 0, -4> )

	mdl.SetParent( arrow, "BACK" )
	mdl.SetAttachOffsetOrigin( indicatorOffset )
	
	float lastVisibleTime = 0
	bool shouldBeVisible  = true

	while ( true )
	{
		cockpit = player.GetCockpit()
		vector playerOrigin = player.GetOrigin()

		bool firstLoop = true
		vector closestPoint
		foreach ( clientAG in file.mortarRingClientAGs )
		{
			vector point = clientAG.GetSoundPositionForLocalPlayer()
			if( firstLoop )
			{
				closestPoint = point
			}
			else if( DistanceSqr( playerOrigin, closestPoint ) > DistanceSqr( playerOrigin, point) )
			{
				closestPoint = point
			}
			firstLoop = false
		}

		float dist = Distance( playerOrigin, closestPoint )
		if ( dist > damageRadius || !cockpit || player.IsPhaseShifted() )
		{
			shouldBeVisible = false
		}
		else
		{
			TraceResults result = TraceLine( closestPoint, player.EyePosition(), [ player ], TRACE_MASK_SHOT, TRACE_COLLISION_GROUP_NONE )

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

			vector damageArrowAngles = AnglesInverse( player.EyeAngles() )
			vector vecToDamage       = closestPoint - (player.EyePosition() + (player.GetViewVector() * 20.0))

			                                
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
