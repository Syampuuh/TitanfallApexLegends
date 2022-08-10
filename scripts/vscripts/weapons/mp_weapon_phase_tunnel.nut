global function MpWeaponPhaseTunnel_Init
global function OnWeaponActivate_weapon_phase_tunnel
global function OnWeaponDeactivate_weapon_phase_tunnel
global function OnWeaponAttemptOffhandSwitch_weapon_phase_tunnel

global function OnWeaponChargeBegin_weapon_phase_tunnel
global function OnWeaponChargeEnd_weapon_phase_tunnel

global function OnWeaponPrimaryAttack_ability_phase_tunnel
#if SERVER
                                                             

                                                       
                                                                
                                          

                                            
                                         
                                          
                                        
                                         

                                           

                                            
                                                
                                                        
                                       

       
                                          
      
#endif
global function PhaseTunnel_IsPortalExitPointValid

global const float PHASE_TUNNEL_CROUCH_HEIGHT = 48

const string SOUND_ACTIVATE_1P = "Wraith_PhaseGate_FirstGate_DeviceActivate_1p"                                                                                                                                                                                   
const string SOUND_ACTIVATE_3P = "Wraith_PhaseGate_FirstGate_DeviceActivate_3p"                                                                                                                
const string SOUND_SUCCESS_1P = "Wraith_PhaseGate_FirstGate_Place_1p"                                                                                                                         
const string SOUND_SUCCESS_3P = "Wraith_PhaseGate_FirstGate_Place_3p"                                                                                                                    
const string SOUND_PREPORTAL_LOOP = "Wraith_PhaseGate_PrePortal_Loop"                                                                                                                                                                        
const string SOUND_PORTAL_OPEN = "Wraith_PhaseGate_Portal_Open"                                                                                                                                                         
const string SOUND_PORTAL_LOOP = "Wraith_PhaseGate_Portal_Loop"                                                                                                                         
const string SOUND_PORTAL_CLOSE = "Wraith_PhaseGate_Portal_Expire"                                                                    
const string SOUND_PORTAL_TRAVEL_1P = "Wraith_phasegate_Travel_1p"
const string SOUND_PORTAL_TRAVEL_3P = "Wraith_phasegate_Travel_3p"
const string SOUND_PORTAL_TRAVEL_1P_BREACH = "Ash_PhaseBreach_Travel_1p"
const string SOUND_PORTAL_TRAVEL_3P_BREACH = "Ash_PhaseBreach_Travel_3p"

global const string PHASETUNNEL_BLOCKER_SCRIPTNAME = "phase_tunnel_blocker"
global const string PHASETUNNEL_PRE_BLOCKER_SCRIPTNAME = "pre_phase_tunnel_blocker"
const string PHASETUNNEL_MOVER_SCRIPTNAME = "phase_tunnel_mover"

const float FRAME_TIME = 0.1

const asset PHASE_TUNNEL_3P_FX = $"P_ps_gauntlet_arm_3P"
const asset PHASE_TUNNEL_PREPLACE_FX = $"P_phasegate_pre_portal"
const asset PHASE_TUNNEL_FX = $"P_phasegate_portal"
const asset PHASE_TUNNEL_CROUCH_FX = $"P_phasegate_portal_rnd"
const asset PHASE_TUNNEL_ABILITY_ACTIVE_FX = $"P_phase_dash_start"
const asset PHASE_TUNNEL_1P_FX = $"P_phase_tunnel_player"

const float PHASE_TUNNEL_WEAPON_DRAW_DELAY = 0.75

global const float PHASE_TUNNEL_TRIGGER_RADIUS = 16.0
global const float PHASE_TUNNEL_TRIGGER_HEIGHT = 32.0
global const float PHASE_TUNNEL_TRIGGER_HEIGHT_CROUCH = 16.0
const float PHASE_TUNNEL_TRIGGER_RADIUS_PROJECTILE = 42.0
const float PHASE_TUNNEL_TRIGGER_RADIUS_PROJECTILE_CROUCH = 24.0

                             
const float PHASE_TUNNEL_PLACEMENT_HEIGHT_STANDING = 45.0
const float PHASE_TUNNEL_PLACEMENT_HEIGHT_CROUCHING = 20

                                 
const float PHASE_TUNNEL_LIFETIME = 60.0
const float PHASE_TUNNEL_VALIDITY_TEST_TIME = 0.25
const float PHASE_TUNNEL_TELEPORT_TRAVEL_TIME_MIN = 0.3
const float PHASE_TUNNEL_TELEPORT_TRAVEL_TIME_MAX = 2.0
const float PHASE_TUNNEL_TELEPORT_DBOUNCE = 0.5
const float PHASE_TUNNEL_TELEPORT_DBOUNCE_PROJECTILE = 1.0

const float PHASE_TUNNEL_MIN_PORTAL_DIST_SQR = 128.0 * 128.0
const float PHASE_TUNNEL_MIN_GEO_REVERSE_DIST = 48.0

const bool PHASE_TUNNEL_DEBUG_DRAW_PROJECTILE_TELEPORT = false
const bool PHASE_TUNNEL_DEBUG_DRAW_PLAYER_TELEPORT = false

global struct PhaseTunnelPathNodeData
{
	vector origin
	vector angles
	vector velocity
	bool   wasInContextAction
	bool   wasCrouched
	bool   validExit
	float  time
}

global struct PhaseTunnelPathEndData
{
	PhaseTunnelPathNodeData nodeData
	vector safeRelativeOrigin
}

global struct PhaseTunnelTravelState
{
	bool                                                      completed
	bool                                                      thirdPersonShoulderModeWasOn
	bool                                                      holsterWeapons = true
	float                                                     holsterRemoveDelay
	float                                                     controlRestoreDelay
	int                                                       shiftStyle
	bool                                                      doEndSeekCheck = true
	int functionref( entity, array<PhaseTunnelPathNodeData>, int, int ) endSeekCheckOverrideFunc
}

global struct PhaseTunnelPathData
{
	float                            pathDistance = 0
	float                            pathTime = 0
	array< PhaseTunnelPathNodeData > pathNodes

	array< int >					 frameSteps
	float							 phaseTime
}

global struct PhaseTunnelPortalData
{
	vector               startOrigin
	vector               startAngles
	entity               portalFX
	vector               endOrigin
	vector               endAngles
	bool                 crouchPortal
	PhaseTunnelPathData& pathData
}

#if SERVER
                          
 
	                  
	                  
	                
	              
 
#endif

global struct PhaseTunnelData
{
	int 					   shiftStyle
	entity                     tunnelEnt
	int                        activeUsers = 0
	array< entity >            entUsers
	table< entity, float >     entPhaseTime
	PhaseTunnelPortalData&     startPortal
	PhaseTunnelPortalData&     endPortal
	bool                       expired

	#if SERVER
		                  
	#endif
}

struct
{
	float maxPlacementDist
	float travelTimeMin
	float travelTimeMax
	float travelSpeed

	#if SERVER
		                                                  
		                                                         
		                                                       
		                                                        
		                                                      
		                                                     
		                                                            
	#endif         
} file

void function MpWeaponPhaseTunnel_Init()
{
	PrecacheParticleSystem( PHASE_TUNNEL_PREPLACE_FX )
	PrecacheParticleSystem( PHASE_TUNNEL_FX )
	PrecacheParticleSystem( PHASE_TUNNEL_CROUCH_FX )
	PrecacheParticleSystem( PHASE_TUNNEL_ABILITY_ACTIVE_FX )
	PrecacheParticleSystem( PHASE_TUNNEL_1P_FX )
	PrecacheParticleSystem( PHASE_TUNNEL_3P_FX )

	AddCallback_PlayerCanUseZipline( PhaseTunnel_CanUseZipline )

	#if SERVER
		                                                               
		                                               
		                                            
		                                                      
		                                                
		                                                    
		                                                  
		                                             
		                                                                               
		                                                          
	#endif         

	#if CLIENT
		RegisterSignal( "EndTunnelVisual" )

		AddCreateCallback( "prop_script", PhaseTunnel_OnPropScriptCreated )
		StatusEffect_RegisterEnabledCallback( eStatusEffect.placing_phase_tunnel, PhaseTunnel_OnBeginPlacement )
		StatusEffect_RegisterDisabledCallback( eStatusEffect.placing_phase_tunnel, PhaseTunnel_OnEndPlacement )

		StatusEffect_RegisterEnabledCallback( eStatusEffect.phase_tunnel_visual, TunnelVisualsEnabled )
		StatusEffect_RegisterDisabledCallback( eStatusEffect.phase_tunnel_visual, TunnelVisualsDisabled )

		AddCreateCallback( PLAYER_WAYPOINT_CLASSNAME, PlayerWaypoint_CreateCallback )
	#endif

	                                            
	                                                         
	                                                         
	file.maxPlacementDist = GetCurrentPlaylistVarFloat( "wraith_portal_max_distance", 3000.0 )
	                                                                                            
	                                                                                            
	file.travelSpeed      = GetCurrentPlaylistVarFloat( "wraith_portal_max_travel_speed", 1024.0 )
}

#if SERVER
                                                    
 
	                                                   
 
#endif

void function OnWeaponActivate_weapon_phase_tunnel( entity weapon )
{
	entity ownerPlayer = weapon.GetWeaponOwner()
	Assert( ownerPlayer.IsPlayer() )

	float raise_time = weapon.GetWeaponSettingFloat( eWeaponVar.raise_time )

	#if SERVER
		                                                                
		                                                                              
	#endif

	#if CLIENT
		if ( !InPrediction() )                             
			return

		EmitSoundOnEntity( ownerPlayer, SOUND_ACTIVATE_1P )
		                                                                             
	#endif

	StatusEffect_AddTimed( ownerPlayer, eStatusEffect.move_slow, 0.8, raise_time, raise_time )
}


void function OnWeaponDeactivate_weapon_phase_tunnel( entity weapon )
{
	entity ownerPlayer = weapon.GetWeaponOwner()
	Assert( ownerPlayer.IsPlayer() )
	#if CLIENT
		if ( !InPrediction() )                             
			return

		                                                                
	#endif
}


bool function OnWeaponAttemptOffhandSwitch_weapon_phase_tunnel( entity weapon )
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


bool function OnWeaponChargeBegin_weapon_phase_tunnel( entity weapon )
{
	entity player   = weapon.GetWeaponOwner()
	float shiftTime = PHASE_TUNNEL_PLACEMENT_DURATION

	                                

	if ( IsAlive( player ) )
	{
		if ( player.IsPlayer() )
		{
			PlayerUsedOffhand( player, weapon, false )
			int attachIndex = player.LookupAttachment( "R_FOREARM" )

			Assert( attachIndex > 0 )
			if ( attachIndex == 0 )
			{
				return false
			}

			#if SERVER
				                                
				                                                                                  
					            

				                                
				                                        
				                                    
					            

				                                             

				                       
				  	                            
				        

				                                                                                                                                                 
				                    
				                              
				                                                                           
				                              

				                  
				                                                                   
			#elseif CLIENT
				AddPlayerHint( PHASE_TUNNEL_PLACEMENT_DURATION, 0, $"", "#WPN_PHASE_TUNNEL_PLAYER_DEPLOY_STOP_HINT" )
				HidePlayerHint( "#WPN_PHASE_TUNNEL_PLAYER_DEPLOY_START_HINT" )
			#endif
		}
		                                                             
	}
	return true
}


void function OnWeaponChargeEnd_weapon_phase_tunnel( entity weapon )
{
	entity player = weapon.GetWeaponOwner()

	                              

	#if CLIENT
		HidePlayerHint( "#WPN_PHASE_TUNNEL_PLAYER_DEPLOY_STOP_HINT" )
	#endif         

	#if SERVER
		                                  
		 
			                        
			 
				                                               
			 

			                                    
			 
				                
			 
			                          
		 
	#endif
}


bool function PhaseTunnel_CanUseZipline( entity player, entity zipline, vector ziplineClosestPoint )
{
	if ( StatusEffect_GetSeverity( player, eStatusEffect.placing_phase_tunnel ) )
		return false

	return true
}

#if SERVER
                                                   
 
	                                                                  
	                                                                                                                                                        

	                                                   
	 
		                                           
		                                         
		                                           
		                                     
	 
 
#endif

var function OnWeaponPrimaryAttack_ability_phase_tunnel( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	                           
	entity player = weapon.GetWeaponOwner()

	float shiftTime = PHASE_TUNNEL_PLACEMENT_DURATION

	if ( IsAlive( player ) )
	{
		#if SERVER
			                                           
		#endif         
	}

	return weapon.GetWeaponSettingInt( eWeaponVar.ammo_per_shot )
}

#if SERVER

                                                                                                                   
 
	                                                                         
 

                                                                                                 
 
	                                              
 

                                                                                      
 
	                                                
	                             
	                               
	                                                 
	                               
	                                        

	                         

	                                        
	                                
	                                       
		                           

	                                 
	                           

	              
	                                                                               
	                                                                                       

	                                                                               

	                                                                                            
	                                                                                     

	                                                                 
	                                                                   


	            
		                                        
		 
			                        
			 
				                      

				                                 
				                              
					                          
				                                        
				                                      
				                                 

				                            
				                                                                                               
				                                                                                        

				                     
					                               

				                    
				 
					              
					            
				 

				                                                                                                    
				                                                            
					                                     
			 
		   

	                             
	                           

	                                                                                                                       
	                                                       

	            
		                         
		 
			                         
			 
				                 
			 
		 
	 

	                                                                       
	                                                                                                 

	                                                   
	                                               
	                                          

	                                                                           
	                                                             
	 
		                                                                         
		      
	 

	                                                                       
	                                                                       
	 
		                                                                         
		      
	 

	                                                                             
	                                          
	                                                      
	                                                                         
	                                        
	                                                    

	                                                                                                                                                                   

	                          
	                                    
	                                  
	                                         

	                                                   
 

                                                                                           
 
	                                                                
	                                                                            
	                                                               

	                                                                                                                             
	                                                                                     

	                                             
	                                
	                                              
	                                              
	                                            
	                                            
	                                                   
	                                                                                                                                                           

	                                                          
	                              

	                 
 

  
                                                                                         
 
	                                                
	                               
	                             
	                                              

	                                                                                                                                          
	             
	                                           
 

                                                                                                         
 
	                                                
	                               
	                             
	                                              

	                                                                  
	                                                                                                                                                        
	                                     

	                                   
	                                                               

	            
		                                            
		 
			                        
			 
				                                                                      
					                                                                                      
			 
		   

	              
	 
		                                                             

		                                                            

		                                                                      
		 
			                                                                                      
			                                                              
		 

		                                                                                                                                             

		                                           
		                                       
			     

		           
	 

	                                           
 
  

                                                                                            
 
	                                                
	                               
	                             
	                                              
	                                                 
	                                        

	                                                                  
	                                                                                                                                                        
	                                     

	                                   
	                                                               

	                                                                              

	            
		                                                          
		 
			                        
			 
				                                                                                 

				                                                                      
					                                                                                      

				                              
					                                           
			 
		   

	                     
	                                                    
	              
	 
		                                                
		                                            
		                                      

		                                             

		                                                                      
		 
			                                                                                      
			                                                              
		 

		                                                                                                                                             

		                            
			     

		                   

		           
	 

	                                           
 

                                                                                 
 
	                                                 
	                                   
	                                                                                                      
	                               
	                                           
	                              
	                          
	                            

	                                        
	                                      

	                                                                  
	                                                                                                                                                        

	                                
	                                           

	                                                                                                                                                                  
	                                                                       

	                                                                                                                                                            
	                                                                   

	                                

	                                       
	                                                                   

	                                         
	                                          

	            
		                                                      
		 
			                                         
			                                       

			                           
			 
				                                   
				                   
			 

			                         
			 
				                 
			 
			                       
			 
				               
			 
		   

	                                                                                                                                                            
	                                                                                                                                                          

	                                                  
	                                                                                               
	                                                                                               

	                                                                     

	                                                                                                
 

       
                                          
 
	                                          
	 
		                                                       
	 
 
      

                                                                                                                   
 
	                                                               
	                                                    
	                                                                                                                                 

	                                      
	 
		                                                             
		                                             
	 

	                                      
	 
		                                             
		                                                  
	 

	                                 
	                         
	 
		                                               
		 
			                                      
			                  
			     
		 

		                                                                                                                           
		                                                                                                                       

		                  
		 
			               
			 
				                                                                   
				     
			 
			    
			 
				                                                                
				     
			 
		 
		                     
		 
			                                                                 
			     
		 

		                                                
		                                 
		                          
			                   

		             
	 

	                         
	                                         

	                                                                       
	 
		                                                          
		                                
			           
	 
	    
	 
		                                              
		 
			                                                                               
			 
				                                                                           
			 
			                                                                                
			 
				                                                                 
			 
			                                                                              
			 
				                                                                   
			 
			    
			 
				                                                                         
				                                                                       
			 
		 
	 
 

                                                                                                                                         
 
	                                                
	                                  
	                                              

	                                                       
	                                                       
	                                                                                                                  
	                                                                                                                                        

	                                                   
	                             
	                                            
	                             
	                                                        
	                                       
	                                       
	                           
	                              
	                                          
	                                                      
	                        

	                                                      
	                                                  
	                                                     

	                           
	                              

	                                
	                                                                                       
	                                
	                                                       
	  
	                                                    
	                             
	                                       
	                                       
	                                  
	                                               
	                                               
	                                   
	                                         
	                                         
	  
	                                               
	                                  
	                                  
	                               
	  
	                               
	  
	                                                                                                                       
	                                                                                                              
	                                                   
	                                                                                                  
	                                                                                                          
	  
	                               
	                                                                                                                   
	                                    
	  
	                                        	                 
	                                      	               

	                                                                                                     
	                                             
	                                 
	                                  
	                                                 

	                                                                                                                                               
	                                  
	                                                 
	                                     
	                                  

	                                                    
	                                                    

	            
		                                                    
		 
			                         
			 
				                                        
				                                      
				                 
			 

			                                
			   
			  	                                            
			  	                                          
			  	                      
			   

			                              
			 
				                                                    
				                                                                                             
				                      
			 

			                              
				                      
		   

	                                                        

	                                                  
	 
		                                                                                                                                                                                   
	 

	             
 

                                                                     
 
	                                        
		                                                         
 

                                                                              
 
	                                     
	                                
	                                  
	                            

	                                          
		      

	                                                                  

	                                  
	                                         
	                                                                                                       
 

                                                                                                        
 
	                                       
	      
 

                                                                                                                                                   
 
	                                           
	                                                               
	                                                                             
	                                                                           

	                            
		      

	                                           
	                                                       
		      

	                                 
	                                
		      

	                                                              
	                                                                               

	                                                                                                      
	                                                               

	                                                

	                                                                                                                               
	                        
	                                                                  
		                                                                                                     
	                                                                       
		                                                                                                     

	                                                         
	                                                                                                                                                                                                      
	                                                                       
	                           
	                                                            

	                                          

	                                         
	                                               
	                                                                     

	                                    

	                                                  
	 
		                                                                                                   
		                                                                                                                                                                                        

		                                                                                                            
		                                                                                                    

		                                                                                                  

		                                                                                                                                    
		                                                                                                                               
		                                                                                                                                
	 
 

                                                                                                                                                        
 
	                               
	                              
	                                                         
	                    
	                                                                                                                                                                                
	                                                                               
	                                                                                                                                                                                
	                                                                                                  

	                    
	                                                                                                                                                                                 
	                                                                                                                                                                                                               
	                                                                                                                                                                                                             
	                                                                                                  

	                                                  
	 
		                                                              
		                                                              
		                                                              

		                                                                
		                                                                
		                                                                
	 

	                                     
	                                                      
	                                                      
	                                                       
 

                                                                                                                                                                       
 
	                                                 
	                          
	                            
	                                                   
	                                  

	                         
		      

	                                        
		      

	                                   
	                                     
	 
		                             
		                                              
			      
		    
			                                                                       
	 
	    
	 
		                                                                        
	 

	                                               

	            
		                                
		 
			                        

			                     
			 
				                                            
				                                             
			 
		   

	                        
	                                 

	                                                 
	 
		                                                                   
		                                                                            
	 
	                                                      
	 
		                                                    
	 

	                                                                                
 

                                                                                                                             
 
	                             
	                                                      

	                                                                                                        

	                                   
	                                                             
	                                                             
	                                                                          
	                                                              
	                                                    

	                                                                                                                                                                                                  
	            
		                                                        
		 
			                                      
			                                      

			                         

			                                         
			 
				                                                                                                                                                                              
				                                 
				                  
					                        
			 

			                        
			 
				                                                        
				 
					                                                                                                         
				 
			 

			                             
			 
				                                     
				                    
				                                	                                                                           
			 

			                                                                                                                                                  
				                                                                                                                                                                                                                                                                                                                   
			 
				                                                                                                                                                                             
			 

			                       
				               

			                                                                       
		 
	 

	                                                                     

	                                    
	                                       
	                                

	                                                                                 
	                                        

	                                                                       
	                                                                        

	                                              
	 
		                                                                 
		 
			                         
			 
				                                                                          
			 
			    
			 
				                                                                        
			 
		 
	 

	                                                                     
	                                                                    
	
	                                             
	                   
	                   
	                                            
	 
		                        

		                
			     

		                                  
		                                                                                                                                                                                                                         

		                                              
		 
			                                           
			 
				                                                                                                                             
			 
			    
			 
				                                                                                                                           
			 
		 

		                                 
		 
			                                                                                              
			                  
			                                              
			 
				                      
			 

			                                                   
			 
				                                        
					                                                                                             
			 
			    
			 
				                                
				                                             
				 
					                          
					                                                       

					                                    
					                                          
					                                          
					               
						                                                  

					                                                                                                                                                                        
					                         
					 
						                                                                 
						                        
					 
					    
					 
						     
					 
				 
			 
		 

		                       
		 
			                                      
			                                                                           
			                     
			 
				                                      
				                                                            
				                                                                            
			 
			                                                                          
			                                                       
			                                                                            
			                                                                                      
			                                                                               
			                                                     
			                                        
			 
				                                     
				                                                   
			 

			                                               
			 
				                                                              
			 
		 

		                 
		           
	 

	                    
	                            

	                                                                                                                 
	                                                                                                                                                      
	           
	                                                   

	                                                                                                                                                  
		                                                                                                                                                                                                                                                                                                                   
	 
		                                                                                                                                                                             
	 
 

                                                                                                          
 
	                              
	                     
	                      
	                                    
	                               

	              
	                                               

	                              
	 
		                          
	 

	                                                    
	                                                                                                                

	                                       
		                            

	                                                                               
	                                               
		                                      

	                                                              

	                                                                                                                                  
	                                            

	                                                     
	                                                                                                                  
	 
		                                           
		                                  
	 


	                               

	                                        

	                                                 
	 
		                                                                                                              
	 
	                                                      
	 
		                                                                                                                            
	 

	                             
 

                                                                                                                   
 
	                                                     
	 
		                                             

		                                   
		                                

		             
		                                              

		                                                                                            

		                      
		                                             
			                                 
		    
			                                                                                             

		                                                                    
			                                     

		                                                 
		 
			                                                   
			                                                   
		 
		                                                     
		 
			                                                          
			                                                          
		 
	 
 

                                                                                       
 
	                                                                 
	                             

	                          
	                                          
	 
		                                          
			                            

		                                          
	 

	                             
		      


	                                      
		                        
			                                
	   

	          
 

                                                                                       
 
	                              

	                                      
		                        
			                                 
	   

	          
 

                                                                                                                      
 
	                        
	                        
	                                                             
	                                          

	                    
		                                             

	                                   

	                                         
	 
		                                                                 

		           
		       
		                            
	 

	                                   

	                                              
	 
		                                                            
		                                                                   
	 

	                                                     
 

                                                                                    
 
	                                                      
	                              
	                                                         
	                       
	                                                                      
	            
		                                          
		 
			                        
			 
				                        
				                                              
				                                                                  
					                                                                                 
			 
		 
	 
	          
 

                                                         
 
	                         
		            

	                       
		            

	                                
	  	            

                 
		                                             
			            
       


	                                        
	 
                   
		                                      
			            
        
	 

	                                            
	 
                   
		                                           
			            
        
	 

	                                                                                               
		            
	
	                                       
		            

	                                                                    
	                                                                                          
		            

	                                                                 
	                                                                             
		            

	                               
		            

	                         
		            

	                           
		            

	                               
		            

	                                    
		            

	                                              
		            

	                                         
	 
		                            
	 

	                                         
		            

                             
		                                                      
			            
       

                 
		                                                             
			            
       

	           
 

                                                                    
 
	                             
		            

	                                                                                            
		            

	                                                                  
	                                    
	 
		                     
			           
			     

		               
			           
			     

		                   
			           
			     

		        
			            
			     
	 
	           
 

                                                                                                                             
 
	                                                 
	                             
	                                        

	                                                                                                                                            

	                                                                                    

	                        
	 
		                                                        
		                              
			                                              

		                        
		 
			                                                
			                                  
			                                        

			                                                                       

			                                                        
			                                                                                                  
			                                                              

			                                     
			                                         
			                                         
			                                                       
			                                                                  
			                                             
			                                                          
			                                         

			                                                           

			                                   
			                                       
			                                                                     
			                                                     
			                                                                
			                                           
			                                                        
			                                       

			                                                                                                                
			                                                  
			                                               
			                                                                                  
			 
				                                                           
				                             
			 

			                                              
			                                       
		 

		                                                                        
	 

	                                                                                                                                                    
	                                                                                                                                                  

	                                                                                                                                                                                   
	                                                                                                                                                                            
 

                                                                                                                                      
 
	                                                 
	                                              
	                             

	                                                        
	                                                        
	                            

	                             

	            
		                              
		 
			                                       
			 
				                     
					             
			 
		 
	 

	           
	 
		                        
		 
			                                                
			                                  
			                                        
			                                                     

			                                                                                                                                                        
			                                                                                                     
			                                                              

			                                              
			                                                                                        
			 
				                                     
				                                         
				                                         
				                                                       
				                                                                  
				                                              
				                                                                                    
				                                         

				                                                           

				                                   
				                                       
				                                                                     
				                                                     
				                                                                
				                                            
				                                                                                  
				                                       

				                
				 
					                       
					                      

					                                                                                                                
					                                                  
					                                               
					                                                                                   
					 
						                                                           
						                             
					 

					                                                                                                                       
					                                                                           
					                                                                            
					                                                                                                                    
					                        
					                                    
					                                             

					            
						                   
						 
							                    
							 
								                                             
							 
						 
					 

					                          

					                                                                                                                                                 
					                                  
					                                              
					                               
					                                    
				 

				                                              
				                                       
			 

			                   
		 

		           
	 
 

                                                                                                                                                  
 
	                    
	 
		                  
		                                                    
		 
			                                        
			 
				              
				     
			 
		 

		                
		                                                        
		 
			                                        
			 
				            
				     
			 
		 

		  	                                         
		  	                                     
		  	                                                     

		                                                           
		                                                
		                                              
		 
			                                              
			                                                   
			                                              
			                                 
			                   
		 

		                                      
	 

	                                                        
	                                                                 

	                                                     
	                                                                                          
	                         
		      

	                                                                     
	                                                                      
	                                                        

	                           
	                                                   
	                               
	                                         
	 
		                                              
		                                  
	 

	                                                        
	                                                                        
	 
		                                                     
		                                                         
		               
	 

	                                                                                           
	                               										                                                                        
	                                                                 	                                                                            
 
#endif


entity function GetDoorForHitEnt( entity hitEnt )
{
	if ( IsDoor( hitEnt ) )
		return hitEnt

	entity parentEnt = hitEnt.GetParent()
	if ( IsValid( parentEnt ) && IsDoor( parentEnt ) )
		return parentEnt

	return null
}

bool function IsValidWorldExitPos( TraceResults results )
{
	if ( !IsValid( results.hitEnt ) )
		return true

	if ( results.hitEnt.GetNetworkedClassName() == "prop_death_box" )
		return true

	if ( results.hitEnt.IsPlayerVehicle() )
		return true

	entity hitDoor = GetDoorForHitEnt( results.hitEnt )
	if ( IsValid( hitDoor ) )
		return true

	if ( results.hitEnt.GetScriptName() == BASE_WALL_SCRIPT_NAME )
		return true

	if ( results.hitEnt.GetScriptName() == MOUNTED_TURRET_PLACEABLE_SCRIPT_NAME )
		return true

	return false
}

bool function PhaseTunnel_IsPortalExitPointValid( entity player, vector testOrg, entity ignoreEnt = null, bool onlyCheckWorld = false, bool isCrouched = false )
{
	int solidMask            = onlyCheckWorld ? TRACE_MASK_PLAYERSOLID_BRUSHONLY : TRACE_MASK_PLAYERSOLID
	vector mins
	vector maxs
	int collisionGroup       = TRACE_COLLISION_GROUP_PLAYER
	array<entity> ignoreEnts = [ player ]

	if ( IsValid( ignoreEnt ) )
		ignoreEnts.append( ignoreEnt )
                      
		entity vehicle = HoverVehicle_GetVehicleOccupiedByPlayer( player )
		if ( IsValid( vehicle ) )
			ignoreEnts.append( vehicle )
                            

	TraceResults result

	mins = player.GetPlayerStandingMins()
	maxs = player.GetPlayerStandingMaxs()

	if ( isCrouched )
		maxs = < maxs.x, maxs.y, PHASE_TUNNEL_CROUCH_HEIGHT >

	result = TraceHull( testOrg, testOrg + <0, 0, 1>, mins, maxs, ignoreEnts, solidMask, collisionGroup )
	                             

	if ( result.startSolid || result.fraction < 1 || result.surfaceNormal != <0, 0, 0> )
	{
		if ( PHASE_TUNNEL_DEBUG_DRAW_PLAYER_TELEPORT )
			DebugDrawBox( result.endPos, mins, maxs, COLOR_RED, 1, 20.0 )

		if ( !onlyCheckWorld )
			return false

		if ( !IsValidWorldExitPos( result ) )
			return false
	}

	if ( PHASE_TUNNEL_DEBUG_DRAW_PLAYER_TELEPORT )
		DebugDrawBox( result.endPos, mins, maxs, COLOR_GREEN, 1, 20.0 )

	return true
}

#if SERVER
                                                                                                                 
 
	                                                 
	           
	           
	                                                       
	                                     

	                           
		                              
	                   

	                                       
	                                       
	                                                                                                     
	                                                                                                                                 
	                             

	                          
	 
		                                              
			                                                             

		            
	 

	                                              
		                                                               

	           
 

                                                          
 
	                                                                       

	                        
	 
		                                                                                         
		 
			                               
			                                              
			                                           
		 
	 
 
#endif         

#if CLIENT
void function PlayerWaypoint_CreateCallback( entity wp )
{
	int pingType = Waypoint_GetPingTypeForWaypoint( wp )

	int wpType = wp.GetWaypointType()

	if ( WaypointOwnerIsMuted( wp ) )
		return

	if ( pingType == ePingType.ABILITY_WORMHOLE && wpType == eWaypoint.PING_LOCATION )
	{
		thread TrackIsVisible( wp )
	}
}


                                                       

                                                                                              
                                                                 
                                                                      

                                                       

void function TrackIsVisible( entity wp )
{
	entity viewPlayer = GetLocalViewPlayer()

	if ( !IsValid( viewPlayer ) )
		return

	viewPlayer.EndSignal( "OnDeath" )

	while( IsValid( wp ) )
	{
		if ( wp.wp.ruiHud != null )
		{
			RuiSetBool( wp.wp.ruiHud, "hideIcon", PlayerCanSeePos( viewPlayer, wp.GetOrigin(), true, 25.0 ) )
		}

		WaitFrame()
	}
}

void function PhaseTunnel_OnPropScriptCreated( entity ent )
{
	switch ( ent.GetScriptName() )
	{
		case "portal_marker":
			                                           
			break
	}
}

void function PhaseTunnel_CreateHUDMarker( entity portalMarker )
{
	                                 

	entity localClientPlayer = GetLocalClientPlayer()

	portalMarker.EndSignal( "OnDestroy" )

	if ( !PhaseTunnel_ShouldShowIcon( localClientPlayer, portalMarker ) )
		return

	vector pos   = portalMarker.GetOrigin()
	var topology = CreateRUITopology_Worldspace( portalMarker.GetOrigin(), portalMarker.GetAngles(), 24, 24 )
	var ruiPlane = RuiCreate( $"ui/phase_tunnel_timer.rpak", topology, RUI_DRAW_WORLD, 0 )
	RuiSetGameTime( ruiPlane, "startTime", Time() )
	RuiSetFloat( ruiPlane, "lifeTime", PHASE_TUNNEL_LIFETIME )

	OnThreadEnd(
		function() : ( ruiPlane, topology )
		{
			RuiDestroy( ruiPlane )
			RuiTopology_Destroy( topology )
		}
	)

	WaitForever()
}

bool function PhaseTunnel_ShouldShowIcon( entity localPlayer, entity portalMarker )
{
	if ( !GamePlayingOrSuddenDeath() )
		return false

	                           
	  	            

	                                                        
	  	            

	return true
}

void function PhaseTunnel_OnBeginPlacement( entity player, int statusEffect, bool actuallyChanged )
{
	if ( player != GetLocalViewPlayer() )
		return
}

void function PhaseTunnel_OnEndPlacement( entity player, int statusEffect, bool actuallyChanged )
{
	if ( player != GetLocalViewPlayer() )
		return

	HidePlayerHint( "#WPN_PHASE_TUNNEL_PLAYER_DEPLOY_STOP_HINT" )
}

void function TunnelVisualsEnabled( entity ent, int statusEffect, bool actuallyChanged )
{
	if ( ent != GetLocalViewPlayer() )
		return

	entity player = ent

	entity cockpit = player.GetCockpit()
	if ( !IsValid( cockpit ) )
		return

	int fxHandle = StartParticleEffectOnEntity( cockpit, GetParticleSystemIndex( PHASE_TUNNEL_1P_FX ), FX_PATTACH_ABSORIGIN_FOLLOW, ATTACHMENTID_INVALID )
	thread TunnelScreenFXThink( player, fxHandle, cockpit )
}

void function TunnelVisualsDisabled( entity ent, int statusEffect, bool actuallyChanged )
{
	if ( ent != GetLocalViewPlayer() )
		return

	ent.Signal( "EndTunnelVisual" )
}

void function TunnelScreenFXThink( entity player, int fxHandle, entity cockpit )
{
	player.EndSignal( "EndTunnelVisual" )
	player.EndSignal( "OnDeath" )
	cockpit.EndSignal( "OnDestroy" )

	OnThreadEnd(
		function() : ( fxHandle )
		{
			if ( !EffectDoesExist( fxHandle ) )
				return

			EffectStop( fxHandle, false, true )
		}
	)

	for ( ; ; )
	{
		float velocityX = Length( player.GetVelocity() )

		if ( !EffectDoesExist( fxHandle ) )
			break

		velocityX = GraphCapped( velocityX, 0.0, 360, 5, 200 )
		EffectSetControlPointVector( fxHandle, 1, <velocityX, 999, 0> )
		WaitFrame()
	}
}
#endif         

#if SERVER
                                                     
 
	                                        
	                         
 

                                                           
 
	                                     
 

                                                              
 
	                                                         
 

                                                            
 
	                                                       
 

                                                           
 
	                                                   
	                   

	 
		                                   
		                                            
		                                            
		                                                                                                                                         
		                                                                           
		                                                                
		                                                                                                        
		                              
	 

	 
		                                 
		                                          
		                                          
		                                                                                                                                       
		                                                                           
		                                                                
		                                                                                                        
		                            
	 
 

                                                   
 
	                            
 
#endif