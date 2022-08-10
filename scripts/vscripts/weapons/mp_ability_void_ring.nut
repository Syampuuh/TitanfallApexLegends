global function VOID_RING_Init

global function OnWeaponActivate_void_ring
global function OnWeaponDeactivate_void_ring
global function OnWeaponReadyToFire_void_ring

global function OnWeaponTossPrep_void_ring
global function OnWeaponTossReleaseAnimEvent_void_ring
global function OnWeaponAttemptOffhandSwitch_void_ring

#if CLIENT
global function ServerToClient_VoidRingHintDetection
global function ServerToClient_VoidRingHintCancelDetection
global function ServerToClient_VoidRingHPToClient
global function ServerToClient_VoidRingStateToClient
#endif

                            
                      
                           
global const string VOID_RING_PROP_SCRIPTNAME = "void_ring"
const string VOID_RING_WEAPON_REF = "mp_ability_void_ring"
const string VOID_RING_MOVER_SCRIPTNAME = "void_ring_mover"

const bool DEBUG_ACTIVE_RING_TEST = false 			                                                             
const int DEBUG_RING_STAGE = 3
const int DEBUG_NUM_STAGES = 6						                                                    
const float DEBUG_RING_DMG_SCALAR = 1 				                                                                                                    

const float VOID_RING_DEPLOY_DELAY = 1.0
const float VOID_RING_DURATION = 45.0
const float VOID_RING_DURATION_WARNING = 5.0
const float VOID_RING_ANGLE_LIMIT = 0.55
const float VOID_RING_PLANT_START_TRACE_OFFSET = 32                                               
const float VOID_RING_PLANT_END_TRACE_DISTANCE = 64                                               
const float VOID_RING_WAYPOINT_LOCAL_OFFSET = 30
const float VOID_RING_WAYPOINT_POI_OFFSET_Z = 10
const float VOID_RING_WAYPOINT_WP_OFFSET_Z = 5
const float VOID_RING_BEAM_ATTACHMENT_LOCAL_OFFSET = 26
const vector VOID_RING_INVALID_PLACEMENT_MIN_AREA = <-15,-15,-50>
const vector VOID_RING_INVALID_PLACEMENT_MAX_AREA = <15,15,50>

const float VOID_RING_THROW_BACKSPIN = -600
const int VOID_RING_RADIUS = 300 							                         
const int VOID_RING_VISUAL_RADIUS_OFFSET = 20 				                                                                                      
const int VOID_RING_AR_RADIUS_OFFSET = 15 					                                                                                                                                                           
const int VOID_RING_MIN_RADIUS = 120 						                                                           
const int VOID_RING_BELOW_RANGE = 2500 						                                                                                    
const int VOID_RING_NORMAL_WARNING_PULSE_COUNT 		= 2 	                                                              
const int VOID_RING_FINAL_CIRCLE_WARNING_PULSE_COUNT= 0		                                                                                  
const float VOID_RING_EXPAND_TIME = 0.4 					                                                     
const float VOID_RING_WP_HP_DRAW_DIST_MIN = 350 			                                                    
const float VOID_RING_WP_HP_DRAW_DIST_MAX = 2500 			                                                    

const float VOID_RING_HEALTH = 100.0
const float VOID_RING_MAX_HEALTH = 100.0

const bool VOID_RING_FAST_HEAL = false

              
const asset VOID_RING_PROJECTILE = $"mdl/props/void_ring/void_ring.rmdl"

const asset VOID_RING_BEAM_FX = $"P_wpn_voidring_beam"
const asset VOID_RING_BEAM_PULSE_FX = $"P_wpn_voidring_dmg_pulse_beam"
const asset VOID_RING_BEAM_WARNING_FX = $"P_wpn_voidring_dmg_warning_beam"
                                                                
const asset VOID_RING_DESTROY_FX = $"P_wpn_voidring_exp"
const asset VOID_RING_SHIELD_FX = $"P_wpn_voidring_shield"
const asset VOID_RING_DMG_PULSE_FX = $"P_wpn_voidring_dmg_pulse"
const asset VOID_RING_SHIELD_WARNING_FX = $"P_wpn_voidring_dmg_warning"
const asset VOID_RING_FLARE_SHIELD_FX = $"P_wpn_voidring_fury_shield"
const asset VOID_RING_FLARE_DMG_PULSE_FX = $"P_wpn_voidring_fury_dmg_pulse"
const asset VOID_RING_FLARE_SHIELD_WARNING_FX = $"P_wpn_voidring_fury_dmg_warning"
const asset VOID_RING_POV_WPN_FX = $"P_wpn_voidring_pov"
const asset VOID_RING_3P_WPN_FX = $"P_wpn_voidring_3p"

const vector VOID_RING_COLOR_FX =  < 204, 188, 255>
const vector VOID_RING_WARNING_COLOR_FX =  < 255, 188, 188>

const asset VOID_RING_PREVIEW_RING_FX = $"P_wpn_voidring_preview"
float VR_AR_EFFECT_SIZE = 1.0                                                                               

               
const string VOID_RING_SOUND_ENDING = "VoidRing_Ending"
const string VOID_RING_SOUND_ENDING_IN_CIRCLE = "VoidRing_Ending_InCircle"
const string VOID_RING_SOUND_SUSTAIN = "VoidRing_Sustain"
const string VOID_RING_SOUND_SUSTAIN_COLUMN = "VoidRing_Sustain_Column"
const string VOID_RING_SOUND_DAMAGE = "VoidRing_Damage"
const string VOID_RING_SOUND_DAMAGE_COLUMN = "VoidRing_Damage_Column"
const string VOID_RING_SOUND_DESTROY = "VoidRing_Destroy"
const string VOID_RING_SOUND_TIMEOUT = "VoidRing_Deactivate"
const string VOID_RING_SOUND_INSIDE = "VoidRing_Inside_1P"
const string VOID_RING_DEACTIVATE_1P_SOUND = "VoidRing_Holster_1P"
const string VOID_RING_DEACTIVATE_3P_SOUND = "VoidRing_Holster_3P"
const string SOUND_DEATHFIELD_START = "Survival_Circle_Enter_3p"
const string SOUND_DEATHFIELD_STOP = "Survival_Circle_Exit_3p"

                                                                                                         
const float VOID_RING_DMG_TICK_R0 = 0.05                                 
const float VOID_RING_DMG_TICK_R1 = 0.05
const float VOID_RING_DMG_TICK_R2 = 0.06
const float VOID_RING_DMG_TICK_R3 = 0.08                                                                  
const float VOID_RING_DMG_TICK_R4 = 0.15                                              
const float VOID_RING_DMG_TICK_R5 = 0.25                                                   
const float VOID_RING_DMG_TICK_R6 = 1.00                        
const float VOID_RING_DMG_TICK_R7 = 1.00                                                           
const float VOID_RING_DMG_TICK_R8 = 1.00          

array<float> ringStageVRDamageTable = [

	        VOID_RING_DMG_TICK_R0,                   
	        VOID_RING_DMG_TICK_R1,
	        VOID_RING_DMG_TICK_R2,
	        VOID_RING_DMG_TICK_R3,
	        VOID_RING_DMG_TICK_R4,
	        VOID_RING_DMG_TICK_R5,
	        VOID_RING_DMG_TICK_R6,                        
	        VOID_RING_DMG_TICK_R7,
	        VOID_RING_DMG_TICK_R8,
]

struct
{
	#if SERVER
	                   				                        
	                              	                
	                    			                          
	                    			                          
	                     			               
	                     			                    
	                  				                   
	#endif

	#if CLIENT
		var 	voidRingHUDRui
		var 	voidRingHUDStatusRui
		float 	cl_voidHP = 100.0
		bool 	cl_voidActive = false
	#endif
} file


void function VOID_RING_Init()
{
	PrecacheModel( VOID_RING_PROJECTILE )
	                                                 
	PrecacheParticleSystem( VOID_RING_BEAM_FX )
	PrecacheParticleSystem( VOID_RING_BEAM_PULSE_FX )
	PrecacheParticleSystem( VOID_RING_BEAM_WARNING_FX )
	PrecacheParticleSystem( VOID_RING_SHIELD_FX )
	PrecacheParticleSystem( VOID_RING_DESTROY_FX )
	PrecacheParticleSystem( VOID_RING_PREVIEW_RING_FX )
	PrecacheParticleSystem( VOID_RING_DMG_PULSE_FX )
	PrecacheParticleSystem( VOID_RING_SHIELD_WARNING_FX )
	PrecacheParticleSystem( VOID_RING_FLARE_SHIELD_FX )
	PrecacheParticleSystem( VOID_RING_FLARE_DMG_PULSE_FX )
	PrecacheParticleSystem( VOID_RING_FLARE_SHIELD_WARNING_FX )
	PrecacheParticleSystem( VOID_RING_POV_WPN_FX )
	PrecacheParticleSystem( VOID_RING_3P_WPN_FX )

	Remote_RegisterClientFunction( "ServerToClient_VoidRingHintDetection", "entity" )
	Remote_RegisterClientFunction( "ServerToClient_VoidRingHintCancelDetection", "entity" )
	Remote_RegisterClientFunction( "ServerToClient_VoidRingHPToClient", "entity", "float", 0.0, 500.0, 16 )                                            
	Remote_RegisterClientFunction( "ServerToClient_VoidRingStateToClient", "entity", "bool" )

	ringStageVRDamageTable[0] = GetCurrentPlaylistVarFloat( "heatshield_dmgTickPercent_ring0", VOID_RING_DMG_TICK_R0 )
	ringStageVRDamageTable[1] = GetCurrentPlaylistVarFloat( "heatshield_dmgTickPercent_ring1", VOID_RING_DMG_TICK_R1 )
	ringStageVRDamageTable[2] = GetCurrentPlaylistVarFloat( "heatshield_dmgTickPercent_ring2", VOID_RING_DMG_TICK_R2 )
	ringStageVRDamageTable[3] = GetCurrentPlaylistVarFloat( "heatshield_dmgTickPercent_ring3", VOID_RING_DMG_TICK_R3 )
	ringStageVRDamageTable[4] = GetCurrentPlaylistVarFloat( "heatshield_dmgTickPercent_ring4", VOID_RING_DMG_TICK_R4 )
	ringStageVRDamageTable[5] = GetCurrentPlaylistVarFloat( "heatshield_dmgTickPercent_ring5", VOID_RING_DMG_TICK_R5 )
	ringStageVRDamageTable[6] = GetCurrentPlaylistVarFloat( "heatshield_dmgTickPercent_ring6", VOID_RING_DMG_TICK_R6 )
	ringStageVRDamageTable[7] = GetCurrentPlaylistVarFloat( "heatshield_dmgTickPercent_ring7", VOID_RING_DMG_TICK_R7 )
	ringStageVRDamageTable[8] = GetCurrentPlaylistVarFloat( "heatshield_dmgTickPercent_ring8", VOID_RING_DMG_TICK_R8 )

	#if SERVER
		                                  
		                                   
		                                      

		                                                        
	#endif

	#if CLIENT
		StatusEffect_RegisterEnabledCallback( eStatusEffect.in_void_ring, VoidRing_EnterDome )
		StatusEffect_RegisterDisabledCallback( eStatusEffect.in_void_ring, VoidRing_ExitDome )
		RegisterSignal( "VoidRingEquipped" )
		RegisterSignal( "VoidRing_EndPreview" )
		RegisterSignal( "VoidRing_DestroyHUD" )
		AddCreateCallback( PLAYER_WAYPOINT_CLASSNAME, OnWaypointCreated )

	#endif
}

void function OnWeaponActivate_void_ring( entity weapon )
{
	entity ownerPlayer = weapon.GetWeaponOwner()
	Assert( ownerPlayer.IsPlayer() )

	#if CLIENT
		if ( !InPrediction() )                             
			return
		RunUIScript( "CloseSurvivalInventoryMenu" )
	#endif

}

bool function OnWeaponAttemptOffhandSwitch_void_ring( entity weapon )
{
	int ammoReq = weapon.GetAmmoPerShot()
	int currAmmo = weapon.GetWeaponPrimaryClipCount()
	if ( currAmmo < ammoReq )
		return false

	entity player = weapon.GetWeaponOwner()
	if ( player.IsPhaseShifted() )
		return false

	return true
}

void function OnWeaponReadyToFire_void_ring (entity weapon )
{
	entity ownerPlayer = weapon.GetWeaponOwner()
	Assert( ownerPlayer.IsPlayer() )

	#if SERVER
	                                                                                         
	                                          
		                                        
	#endif

}

void function OnWeaponTossPrep_void_ring( entity weapon, WeaponTossPrepParams prepParams )
{
	weapon.EmitWeaponSound_1p3p( GetGrenadeDeploySound_1p( weapon ), GetGrenadeDeploySound_3p( weapon ) )

	#if SERVER
		                                            
		                                     
	#endif

	#if CLIENT                                                                                                                                
		if( weapon.GetWeaponOwner() == GetLocalViewPlayer() )
			thread ShowVoidRingRadius( weapon )
	#endif
}

var function OnWeaponTossReleaseAnimEvent_void_ring( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	int ammoReq = weapon.GetAmmoPerShot()
	entity player = weapon.GetWeaponOwner()

	weapon.EmitWeaponSound_1p3p( GetGrenadeThrowSound_1p( weapon ), GetGrenadeThrowSound_3p( weapon ) )

	entity deployable = ThrowDeployable( weapon, attackParams, 1.0, OnVoidRingPlanted, null,  <0,VOID_RING_THROW_BACKSPIN,0> )
	if ( deployable )
	{
		PlayerUsedOffhand( player, weapon, true, deployable )

		#if SERVER
			                                 

			                                                            
			                            
				                                                

			                                         

		#endif

		#if SERVER
			                                                
			                                                                                     
			                                      
		#endif

		#if CLIENT
			Signal( weapon, "VoidRing_EndPreview" )
		#endif
	}

	return ammoReq
}

void function OnWeaponDeactivate_void_ring( entity weapon )
{
	entity ownerPlayer = weapon.GetWeaponOwner()
	Assert( ownerPlayer.IsPlayer() )

	#if SERVER
		                                                                                            
		                                      
	#endif

	#if CLIENT
		if ( ownerPlayer != GetLocalViewPlayer() )
			return

		                                                                 
		Signal( weapon, "VoidRing_EndPreview" )
	#endif
}

                                       
                                       
                                      

void function OnVoidRingPlanted( entity projectile, DeployableCollisionParams collisionParams )
{
	#if SERVER
		                               

		                                    

		                        
		 
			                    
			      
		 

		                                      

		                                                                    
		                                                
		                                                                               
		                                                  
		                                             

		                                                                                                                                           
		                                 
		 
			                                                               
			                                                                     

			                                             
			                                                               
				                                           
		 

		                                         
		                        

		                               
		                                  

		                                                                                                 

		                                                                        
		                                   
		                                                   

		                               


		                                                    


		                                             
		                                                                                                                                       
		                                                                                                                               

		                                                                     
		                                                                                           
			                                             
		                                
			                                    

		                        
		                       
		  	                                           
		        
		                                                                                                                                                                                                                   
		   
		  	                                             
		   
		                                  
		   
		  	                                    
		  
		  	                     
		  		                
		  		 
		  			                                       
		  			                                                                                   
		  		 
		  	                           
		   

		                    
		                                                          

	#endif
}

#if SERVER
                                                                 
 
	                                   

	                                    

	                        
	 
		                    
		      
	 
	                          

	                                                                                                                                                 

	                                                                                                                                
	                                         

	                           
		                            

	                             
	                                                     
	                                                                                                
	                                             

	                                

	                              
	                              

	                                                           

	                                    
	                                                     
	                                                                                                                               
	                                    
	                                                         

	                                           
	                                                         
	                                                                                                                                               

	            
		                                                           
		 
			                            
			 
				                           
					                                 
				    
					                        

				                                                              
				                                       
			 

			                            
			 
				                      
			 

			                       
			 
				               
			 
		 
	 

	                                                                                    
	                                                            
 

                                                                  
 
	                                   
	                              

	                                                                       
	                                      
	                     
	                      

	                                                                  

	                               
	 
		                                              
			                                                 

		                                   
		 
			                                        
			              
			 
				                            
				 
					                    

					              
					 
						                                                                      
					 
					    
						                                                                  
				 
			 
			    
			 
				                                                              
				                                                                          
				     
			 
		 

		           
	 
 

                                                     
 
	                                                                                                                                       

	                                         

	                           
		                            

	                             

	                                   
	                                        

	            
		                      
		 
			                       
				               
		 
	 

	                                                        
	                                                                   
	                                           
	                                     
 
                                              


                                       
                                       
                                       
                                                             
 
	                                    
	                                  

	                                                                           
	 
		              			                        
		              			                                                                 
		                  		                                
		                     	                                
		                 		                                                              

		                                                                                             

		              		                                                                         
		                	                                                
		                  	                                                                            

		                                               
		 
			                                                     
		 
		                                                          
		                                                                  
		                                                               

		                                                                                                  
		 
			                                              
		 
		    
			                                               

		           
	 
 

                                                                          
 
                               
                                                                                             
                                                                                                                                                                                          
                                                                                            
                                 
               

                                                                         
                                
   
                                          
    
                                           
                                                 

                                                        
                                                            
                                                                                        

                                                            

                                                              
                                                                      
                                                                   

                                      
     
                
     
    
   
       

	            
 

                                   
                                   
                                   

                                                                                 
 
	                                    
	                                  

	                             
		      

	             
	                                      
	            		                                    


	                                           
	                                       
	                                            
	                	                   
	                	                        
	              		                                                         

	                                                                                                           
	                                          

	                  		                                          
	                    	                                                                                                                                                      
	             			                                               
	                 		                                             
	                      	                                                   
	                    	                                                     
	                      	                                                 
	                		                                                  
	                 		                                                       

	              			                                                     
	                 		                                                        
	                  		                                                             

	                                                                                                   
	                                       

	                         
	                                               
	                                               
	                                               

	                       
	                                                                                                                             

	                        
	               
	                    
	                     

	                        
	                       
	                            

	                
	                                                                                                            
	                   
	                     

	                               
	                                                        

	                                             
	                                                                     
	                                                                                                                                                  
	                                        
	                                  
	                                     
	                                            
	                                               
	                                    
	                                      
	                            
	                                    
	                     

	                                         
	                                                                                                 
	                  

	            
		                                                                                                                                                                                         
		 
			                          
				                      
			                        
				                    
			                         
				                 
			                         
			 
				                                        
				                                             
				                                             
			 
			                   
			 
				              
			 

			                       
				                  
			                          
				                     

			                                  
				                              
			                                
				                            
			                              
				                          
			                               
				                           
			                                       
				                                   

			                                      

			                                                        
		 
	 

	                        
	                        
	                       

	                                               
	 
		                                             
		 
			                                                                                             
			                                                                                               
		 
		    
		 
			                                                                                       
			                                                                                          
		 
	 

	                          

	                                                                                                                         

	                        
	                        
	                       
	                                      
	                                                                                                        
	                                                                                                    


	                                                                                                
	 
		                                                                                             

		              		                                                                         
		                	                                                
		             		                                      
		              		                                   

		                  
			            

		                                              
			         	                              

		                                                                                                         
		                                                         

		                                                                  
		                                        
		 
			                                  
			                                                                     

			                                         
			 
				         		                                          
			 
		 

		                            
		 
			         		                  
			         		                  
		 

		            		                                           
		              		                                                                                              

		                            
			        		                                                                                                                                        


		                            
			                     

		                                  
		                                 
		                                
		                                                                                 
		 
			                         
			                           
			                                                       

			                                                                       
			 
				                                          
				                    
				 
					                                                                                                  
					                                             
					 
						                                      
					 
				 
			 
			                                     
			 
				                                                                        
				                                                                                      
				               
			 

			                             
			 
				          
				          
			 

			                      
			                                               
			 
				                                             
					                   
			 

			                                                                                            
			                                                                                                           
			                                                                                         
			                                                                                                                
			                                                                             

			                                                             
			                                                  
			                                             
			                                                    

			                                                                                                              

		 
		                            
		 
			                
			 
				                       
				 
					                                                                                                                           
				 
				                    
				 
					                                                      
					                      
				 
			 
		 

		                                                        
		                                                                                                

		                                             
		                                             
		                                             

		                                       
		                 
		  
			                 
			                                         
				              	                                                                                                    
			     
				              	                                                                                                                

			                               
			  
				                                                
				  
					                                              
					  
						                                                                                                                                       
					  
					     
					  
						                                                                                                                                 
					  
				  

				                                                                                                                  
				                                                                                

				                    
				  
					                                                                  
				  
				            
			  
			     
			  
				                                      
				                                                          
				                                         
				                                   
				                                        
				                                              
				                                              
				                     
			  
		  

		                                          
		                                      
	 

	                                             
	                                  
	                                             

	                        
		                    

	                                                                                                             
	                                                                                                                       

	            
		                                      
		 
			                           
				                       
			                            
				                                                       
		 
	 

	                                                       

	                                                   

	                                                      
	 
		                       
		 
			                                            
			 
				                                                                            
			 
			    
			 
				                                                                            
			 
		 
		           
	 
	                                     

 

                                                                                                                
 
	                              
	                                

	                         
	                            
	                               

	            
		                                    
		 
			                          
			 
				                                                             
			 
		 
	 

	                                 
	 
		                                                                                  
		                          
		 
			                                                                           
		 

		           
		                                    
	 

 

                                                                                                                                                         
 
	                                   
	                                          

	            
		                                        
		 
			                          
			 
				                      
				                      
			 
			                               
			 
				                           
				                           
			 
		 
	 

	                        
	                         
	                            
	                                                                           
	 
		                                            
		 
			                                                    

			                                               
			 
				                 
				 
					                                                                                                
					                   
					                       
				 
				    
				 
					                                                                                          
					                         
					 
						                                                                            
					 
					                    
					                      
				 

			 
			    
			 
				                                      
				 
					                         
					 
						                                                                            
						                    
						                      
					 
				 
			 

			         
			                   
			   
			  	                                                                             
			   
			      
			  	                                                                               
			        

		 
		                    
		 
			                                                                                          
			                    
			                       
		 

		           

	 


 

                                                                                                                             
 
	                             
		                                                         

	                          
	                              
	 
		                                                                                        
	 

	                                                       

	                                                                                      
 


                                                                                        
 

	                                                   
	                                            
	                              
	                                              
	                                
	                                  
	                                                                                                             
	                           

	               
 


                                                                                           
 
	                                          
	                                     
	                     
	 
		                                  
		                                            
	 
 

                                                                                                
 
	                                   
	                                 
	                                                
	 
		                                          
		                                         
		 
			                                     
		 
		    
		 
			                                          
			 
				                                     
			 
		 
		           
	 
 

                                                                         
 
	                                       
	 
		                        
			        

		                                                                       
			                                                                

		                                      
		                                                                               
		              
		 
			                                                                          
				                                                                  
			                                   
		 
	 
 

                                                                    
 
	                                                                               
	 
		                       
			        

		                                                                      
			                                                               

		                                    
		                                                                             
		              
		 
			                                                                         
				                                                                 
		 
	 
 

                                                                           
 
	                                                       
	 
		                            
			        

		                                              
			        

		                                                      
		                                                  

		                                           
			        

		                                                                           
			                                                                    

		                                                                                                                       

		              
		 
			                                                                              
				                                                                      
		 
	 
 


                                                    
 

	                                       
	 
		                        
			        

		                                                                       
			                                                                
	 

	                                                                               
	 
		                       
			        

		                                                                      
			                                                               

	 

	                                                       
	 
		                            
			        

		                                                                           
			                                                                    
	 

 
                                                        
 
	                                                                     
	                                                                                        
	                                                    

	            
		                       
		 
			                        
				                    
		 
	 
	                                                                                      
 



                                        
                                        
                                        

                                                                                                     
 
	                                                                                                      
	                              
	                                              
	                               

	                                                      
	                                                                               

	                       
	                                            
	 
		                                                     
	 
	    
	 
		                                                     
	 

	               
 

                                                                                                                                   
 
	                                                                                                         
	                              
	                            
	                                            
	                                                                                             
	                                                                                                                
	                                                                       


	             
 
                                   


                           
                           
                           

                                                                                                              
 
	                                                                                                   
	                             
	                                             
	                               
	                                            
	                                           
	                                    

	              
 
                                                            
 
	                     
	 

		                                           
		 
			                                  
			                                                        
		 
		    
		 
			                               
		 

		                                                
	 

 

                                                           
 
	                     
	 
	 
 

                                                                     
 
	                             
	                           
	                                 

	                              
	                              
	                                       

	            
		                                         
		 
			                     
			 

				                                       
					                               

				                                         
				 

					                                                           
					                                    

					                                                                       
					 
						                                                              
					 

					                                                                      
						                                                             

					                                                      
					 
						                                           
					 

					                             
				 


				                           
				 
					                                               
					 
						                                                                                                                                             
						 
							                                                
						 
					 
				 

				                                             
			 
		 
	 

	                                                                                                            
	                                  
	 
		                                                                                                                                                                           
		                                                                               

		              
		 
			                                  
				                                               

			                                                                                       

			                                               
			 
				                                                                                                                                           
				 
					                                                                      
					 
						                                               
						                            
					                                                                                                                                 

					                                                                                    
					                                  
						                                               

					                                                                                        

					                                                                                                                                                         
					                                                                                            

					                                                                         
					 
						                                           
					 

				 
				    
					                                                                  

				                                                                                                                      
			 

			                                    
			 
				                                                                                                        
			 

			                                                                    
			                            
				                                                      

		 
		    
		 
			                                                                
			                                               
		 

		           
	 
 
                                                                                              
 
	                                                                                                                                                         
	                                                                                             

	                                                                                                                                                             
	                                                                                                                                                              

	                                           

	              
 

                                                                                                  
 
	                                 
	 
		                                               

		                                                      
		 
			                                           
		 

		                                             
	 
 

                                                                                         
 
	                                                                                                                                      
	                                                                                                                 
	                                                                                                  

	                                                                                               
	                                                                                                                  
	                                                                                         

	                                                                                         
	 
		                                              
		 
			                                                           
			 
				                                               
			 
		 
	 
	    
	 
		                                             
	 
 

                                                                         
 
	                                           
	 
		                        
		                                       
		                                                        
		 
			                                                          
		 
	 
 

                                                                 
 
	                                                                       
	                                     

	                                                   
		                               

                               
                                                            
                                                                        
                                  
       

	                               
	 
		                                                                                                                                       
		                                     
	 
 


                                                                                                                              
                                                 
 
	                                                                         
	                                      
	 
		                                                                                    
	 
	    
	 
		                                                                                          
	 
 

#endif         

#if SERVER
                                                   
 
	                                      
	                                
	                                         
	                                   
	                                     

	                                
	                  		                                      

	                                                                                                                                                     
	                   
	                                                                                            
	                          
	                                                
		                                                                                                      

	            
		                   
		 
			                  
			 
				                
			 
		 
	 
	           
		           
 
#endif
#if CLIENT
void function ShowVoidRingRadius( entity weapon )
{
	EndSignal( weapon, "VoidRing_EndPreview" )
	EndSignal( weapon, "OnDestroy" )

	WaitFrame()

	int fxHandle = -1
	int fxPovHandle = -1

	if ( IsValid( weapon ) )
	{
		fxHandle = StartParticleEffectInWorldWithHandle( GetParticleSystemIndex( VOID_RING_PREVIEW_RING_FX ), weapon.GetMostRecentGrenadeImpactPos(), ZERO_VECTOR )
		EffectSetControlPointVector( fxHandle, 1, <VOID_RING_RADIUS - VOID_RING_AR_RADIUS_OFFSET, 0, 0> )
		EffectSetControlPointVector( fxHandle, 2, <VOID_RING_RADIUS, 0, 0> )                            

		                                                                                        
		fxPovHandle = weapon.PlayWeaponEffectReturnViewEffectHandle( VOID_RING_POV_WPN_FX, $"", "fx_beam" )
	}

	OnThreadEnd(
		function() : ( fxHandle, fxPovHandle )
		{
			if ( fxHandle != -1 )
				EffectStop( fxHandle, true, false )
			if ( fxPovHandle != -1 )
				EffectStop( fxPovHandle, true, false )
		}
	)

	while( IsValid( fxHandle ) )
	{
		vector dropPosition = weapon.GetMostRecentGrenadeImpactPos()
		                                                                           
		EffectSetControlPointVector( fxHandle, 0, dropPosition )
		WaitFrame()
	}
}
#endif

#if CLIENT
void function ServerToClient_VoidRingHintDetection( entity player)
{
	if ( player != GetLocalViewPlayer() )
		return

	thread CL_VoidRingHintThread( GetLocalViewPlayer() )
}

void function ServerToClient_VoidRingHintCancelDetection( entity player )
{
	if ( player != GetLocalViewPlayer() )
		return

	player.Signal( "VoidRingEquipped" )
}

                                                                                                                                       
void function CL_VoidRingHintThread( entity player )
{
	EndSignal( player, "VoidRingEquipped" )

	while( IsValid( player ) )
	{
		LootData lootData = EquipmentSlot_GetEquippedLootDataForSlot( player, "gadgetslot" )
		if( lootData.ref != VOID_RING_WEAPON_REF )
			break

		vector eyePos      = player.EyePosition()
		float frontierDist = DeathField_PointDistanceFromFrontier( eyePos, player.DeathFieldIndex() )
		entity heldGadget = player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_GADGET )
		entity activeWeapon = player.GetActiveWeapon( eActiveInventorySlot.mainHand )
		int hasDownedState = BleedoutState_GetPlayerBleedoutState( player )
		bool isInsideFissure = false
                               
                                                                                     
       

		if( frontierDist < 0 || isInsideFissure )
		{
			if ( IsValid( heldGadget ) )
			{
				if ((heldGadget != activeWeapon) && hasDownedState <= 0)
				{
					if( IsControllerModeActive() )
					{
						int useSurvivalSlotButton = GetConVarInt("gamepad_toggle_survivalSlot_to_weaponInspect")

						if ( useSurvivalSlotButton == 0 )                                         
							AnnouncementMessageRight( player, "#HINT_USE_VOID_RING_CONSOLE" , "Void Ring Warning", <1, 1, 1> )
					}
					else
						AnnouncementMessageRight( player, "#HINT_USE_VOID_RING_PC" , "Void Ring Warning", <1, 1, 1> )
				}
			}
		}
		wait 1.5
	}

}

void function ServerToClient_VoidRingHPToClient( entity player, float voidHP )
{
	if ( player != GetLocalViewPlayer() )
		return
	file.cl_voidHP = voidHP
}
void function ServerToClient_VoidRingStateToClient( entity player, bool voidRingIsActive )
{
	if ( player != GetLocalViewPlayer() )
		return
	file.cl_voidActive = voidRingIsActive
}

void function CL_TrackVoidHP_Thread( entity player )
{
	player.EndSignal( "VoidRing_DestroyHUD" )
	if ( player != GetLocalViewPlayer() )
		return

	array<var> ruis
	var rui = CreateCockpitRui( $"ui/void_ring_protection_status.rpak", HUD_Z_BASE )

	                                                                                                  
	                                                              
	file.cl_voidHP = -1 

	ruis.append( rui )

	OnThreadEnd(
		function() : ( ruis )
		{
			foreach ( rui in ruis )
				RuiDestroyIfAlive( rui )
		}
	)

	while ( IsValid( rui ) )
	{
		RuiSetFloat( rui, "curHP", file.cl_voidHP )
		WaitFrame()
	}
}

                                                                                                                         
void function VoidRing_EnterDome( entity player, int statusEffect, bool actuallyChanged )
{
	if ( player != GetLocalViewPlayer() )
		return
	EmitSoundOnEntity( player, VOID_RING_SOUND_INSIDE )

	thread CL_TrackVoidHP_Thread( player )

}

void function VoidRing_ExitDome( entity player, int statusEffect, bool actuallyChanged )
{
	if ( player != GetLocalViewPlayer() )
		return

	StopSoundOnEntity( player, VOID_RING_SOUND_INSIDE )

	                                    
	if( file.voidRingHUDRui != null )
	{
		RuiDestroyIfAlive( file.voidRingHUDRui )
		file.voidRingHUDRui = null
	}

	Signal( player, "VoidRing_DestroyHUD" )

}

void function OnWaypointCreated( entity wp )
{
	int wpType = wp.GetWaypointType()

	if ( wpType == eWaypoint.VOID_RING_TROPHY_LIFE )
	{
		thread VoidRing_WaypointUI_Thread( wp )
		AddRefEntAreaToInvalidOriginsForPlacingPermanentsOnto( wp, VOID_RING_INVALID_PLACEMENT_MIN_AREA, VOID_RING_INVALID_PLACEMENT_MAX_AREA )
	}

}


void function VoidRing_WaypointUI_Thread( entity wp )
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

	var rui 		= RuiCreate( $"ui/void_ring_hp_meter_cockpit.rpak", topo, RUI_DRAW_WORLD, 1 )

	ruis.append( rui )

	bool isOwned = IsFriendlyTeam( wp.GetTeam(), GetLocalViewPlayer().GetTeam() )
	entity player = GetLocalViewPlayer()

	var ownedRui
	if ( isOwned )
	{
		ownedRui = CreateCockpitRui( $"ui/void_ring_hp_meter_cockpit.rpak", 1 )
		RuiTrackFloat3( ownedRui, "playerAngles", player, RUI_TRACK_EYEANGLES_FOLLOW )
		RuiTrackFloat3( ownedRui, "worldPos", wp, RUI_TRACK_ABSORIGIN_FOLLOW )
		RuiTrackFloat( ownedRui, "curHP", wp, RUI_TRACK_WAYPOINT_FLOAT, 0 )
		RuiTrackFloat( ownedRui, "maxHP", wp, RUI_TRACK_WAYPOINT_FLOAT, 1 )
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
			bool displayRui = false

			if ( IsValid( player ) )
			{
				float dist = Distance( player.EyePosition(), wp.GetOrigin() )
				bool isInRange = ( dist > VOID_RING_WP_HP_DRAW_DIST_MIN ) && ( dist < VOID_RING_WP_HP_DRAW_DIST_MAX )
				if ( isInRange )
				{
					TraceResults results = TraceLine( player.EyePosition(), wp.GetOrigin(), [player], TRACE_MASK_VISIBLE, TRACE_COLLISION_GROUP_NONE )
					displayRui = results.fraction > 0.95
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
