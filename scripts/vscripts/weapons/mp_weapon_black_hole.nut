global function MpWeaponBlackHole_Init
global function OnWeaponTossPrep_weapon_black_hole
global function OnWeaponPrimaryAttack_weapon_black_hole
global function OnWeaponDeactivate_weapon_black_hole

#if SERVER
                                                     
#endif

global const string BLACKHOLE_PROP_SCRIPTNAME = "newt_blackhole"
global const string BLACKHOLE_MOVER_SCRIPTNAME = "newt_blackhole_mover"
global const string BLACKHOLE_THREAT_TARGETNAME = "newt_blackhole_threat"
global const string BLACKHOLE_WEAPON_CLASS_NAME = "mp_weapon_black_hole"

                
const asset BLACKHOLETROPHY_DESTROY_FX = $"P_newt_exp"                                                
const asset BLACKHOLETROPHY_DAMAGE_SPARK_FX = $"P_newt_dmg"
const asset BLACKHOLETROPHY_DAMAGE_ADD_FX = $"P_newt_dmg2"

                    
const BLACKHOLE_START_FX = $"Sub_P_black_hole_START"
const BLACKHOLE_MAIN_FX = $"P_wpn_black_hole_main"

               
int BLACKHOLE_1P_SCREEN_FX_ID
const asset BLACKHOLE_1P_SCREEN_FX = $"P_black_hole_1p"
int BLACKHOLE_1P_SCREEN_OTHER_FX_ID
const asset BLACKHOLE_1P_SCREEN_OTHER_FX = $"P_black_hole_1p"

const asset BLACKHOLE_PREVIEW_RING_FX = $"P_wpn_black_hole_preview"
float BH_AR_EFFECT_SIZE = 1.0                                                                               

                    
const BLACKHOLE_NEWT_THRUSTER_FX = $"P_newt_thruster"
const BLACKHOLE_NEWT_THRUSTER_LIGHT_FX = $"P_newt_thruster_main_light"

const float BLACKHOLE_NEWT_DAMAGE_FX_INTERVAL = 0.25

                                                  
                                                                   


                   
const asset BLACKHOLETROPHY_MODEL = $"mdl/props/nova_trophy_system/nova_trophy_system.rmdl"

               
const string TROPHY_PLACEMENT_ACTIVATE_SOUND = "wattson_tactical_a"
const string TROPHY_PLACEMENT_DEACTIVATE_SOUND = "wattson_tactical_b"

const string BLACKHOLETROPHY_SOUND_DESTROY = "Nova_Ultimate_Destroy"
const string BLACKHOLETROPHY_SOUND_DAMAGE = "Nova_Ultimate_NewT_Damage"

const string TROPHY_EXPAND_SOUND = "Wattson_Ultimate_E"
const string TROPHY_EXPAND_ENEMY_SOUND = "Wattson_Ultimate_E_Enemy"
const string TROPHY_ELECTRIC_IDLE_SOUND = "Wattson_Ultimate_F"

const string TROPHY_SOUND_BLACKHOLE_END = "Weapon_EnergySyphon_Impact_Lvl1_3P"
const string BLACKHOLE_SOUND_PLAYER_INSIDE_1P = "Nova_Ultimate_BlackHole_Inside_Sustain_1P"


                  

const string BLACKHOLE_SOUND_PHASE_1 = "Nova_Ultimate_BlackHole_Phase1"
const string BLACKHOLE_SOUND_PHASE_2 = "Nova_Ultimate_BlackHole_Phase2"
const string BLACKHOLE_SOUND_PHASE_3 = "Nova_Ultimate_BlackHole_Phase3"
const string BLACKHOLE_SOUND_PHASE_4 = "Nova_Ultimate_BlackHole_Phase4"



                     
const bool BLACKHOLE_DEBUG = false
const bool BLACKHOLE_DEBUG_DRONES = false
const bool BLACKHOLE_DEBUG_TRACE = false
const bool BLACKHOLE_DEBUG_SPHERE = false
const bool BLACKHOLE_DEBUG_VORTEX = false

const float BLACKHOLE_TROPHY_HEALTH_AMOUNT = 175
const float BLACKHOLE_TUNING_RADIUS = 400
const int BLACKHOLE_TUNING_ABOVE_HEIGHT = 200
const int BLACKHOLE_TUNING_BELOW_HEIGHT = 200
const float BLACKHOLE_TUNING_INNER_RADIUS = 100

const float BLACKHOLE_TUNING_PROJECTILE_PULL_SPEED = 80

const float BLACKHOLE_TUNING_CODE_PULL_OUTER_SPEED = 300
const float BLACKHOLE_TUNING_CODE_PULL_INNER_SPEED = 400
const float BLACKHOLE_TUNING_CODE_MOVE_OUTER_SPEED = 85
const float BLACKHOLE_TUNING_CODE_MOVE_INNER_SPEED = 135

const float BLACKHOLE_TUNING_DEATHFIELD_DAMAGE_SCALAR = 1.0
const float BLACKHOLE_TUNING_TAKE_EXPLOSIVE_DAMAGE_MULTIPLIER = 1.5

const float BLACKHOLE_TUNING_ACTIVATION_TIME = 1.75
const float BLACKHOLE_TUNING_PULL_ACTIVATION_FX_LEAD_TIME = 1.0
const float BLACKHOLE_TUNING_START_FX_STOP_OFFSET = 0.0
const float BLACKHOLE_TUNING_PULL_TIME = 0.8
const float BLACKHOLE_TUNING_STABLE_TIME = 10

struct
{
	#if SERVER
		                                              
		                                                        
		                                                       
	#endif
} file

void function MpWeaponBlackHole_Init()
{
	PrecacheParticleSystem( BLACKHOLETROPHY_DESTROY_FX )
	PrecacheParticleSystem( BLACKHOLETROPHY_DAMAGE_SPARK_FX )
	PrecacheParticleSystem( BLACKHOLETROPHY_DAMAGE_ADD_FX )

	                                                  
	                                               
	BLACKHOLE_1P_SCREEN_FX_ID = PrecacheParticleSystem( BLACKHOLE_1P_SCREEN_FX )

	                                                           
	PrecacheParticleSystem( BLACKHOLE_PREVIEW_RING_FX )
	PrecacheParticleSystem( BLACKHOLE_NEWT_THRUSTER_FX )
	PrecacheParticleSystem( BLACKHOLE_NEWT_THRUSTER_LIGHT_FX )
	                                                      
	                                                        
	                                                     
	BLACKHOLE_1P_SCREEN_OTHER_FX_ID = PrecacheParticleSystem( BLACKHOLE_1P_SCREEN_OTHER_FX )

	PrecacheParticleSystem( BLACKHOLE_START_FX )
	PrecacheParticleSystem( BLACKHOLE_MAIN_FX )

	PrecacheModel( BLACKHOLETROPHY_MODEL )

	#if SERVER
		                                 
		                                        
	#endif         


	#if CLIENT
		RegisterSignal( "Blackhole_EndPreview" )
		RegisterSignal( "Blackhole_Stop1PFXSignal" )

		StatusEffect_RegisterEnabledCallback( eStatusEffect.in_black_hole_field, Blackhole_Start1PFX )
		StatusEffect_RegisterDisabledCallback( eStatusEffect.in_black_hole_field, Blackhole_Stop1PFX )

		AddTargetNameCreateCallback( BLACKHOLE_THREAT_TARGETNAME, AddBlackholeThreatIndicator )
		AddCallback_ModifyDamageFlyoutForScriptName( BLACKHOLE_PROP_SCRIPTNAME, BlackHole_OffsetDamageNumbersLower )

	#endif         

	#if SERVER
		                                                   
		                                                        
		                                                        
		                                                        
		                                                        
		                                                      
		                                                              
		                                                           
		                                                       
	#endif         
}

#if SERVER
                                                 
 
	                                                                   
 
#endif

void function OnWeaponTossPrep_weapon_black_hole( entity weapon, WeaponTossPrepParams prepParams )
{
	weapon.EmitWeaponSound_1p3p( GetGrenadeDeploySound_1p( weapon ), GetGrenadeDeploySound_3p( weapon ) )

	#if CLIENT
		thread ShowBlackHoleRadius( weapon )
	#endif
}

#if CLIENT
void function ShowBlackHoleRadius( entity weapon )
{
	EndSignal( weapon, "Blackhole_EndPreview" )
	EndSignal( weapon, "OnDestroy" )

	wait 0.2

	int fxHandle
	if ( IsValid( weapon ) )
	{
		fxHandle = StartParticleEffectInWorldWithHandle( GetParticleSystemIndex( BLACKHOLE_PREVIEW_RING_FX ), weapon.GetOrigin(), ZERO_VECTOR )
		EffectSetControlPointVector( fxHandle, 1, <BLACKHOLE_TUNING_RADIUS, 0, 0> )
		                                                             
	}

	OnThreadEnd(
		function() : ( fxHandle )
		{
			if ( fxHandle != -1 )
				EffectStop( fxHandle, true, false )
		}
	)

	while( IsValid( fxHandle ) )
	{
		vector dropPosition = weapon.GetMostRecentGrenadeImpactPos()
		                                                                                  
		EffectSetControlPointVector( fxHandle, 0, dropPosition )
		WaitFrame()
	}
}

vector function BlackHole_OffsetDamageNumbersLower( entity newt, vector damageFlyoutPosition )
{
	return ( damageFlyoutPosition - < 0, 0, newt.GetBoundingMaxs().z/2.0 > )
}
#endif


var function OnWeaponPrimaryAttack_weapon_black_hole( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	entity ownerPlayer = weapon.GetWeaponOwner()
	int ammoReq        = weapon.GetAmmoPerShot()
	Assert( ownerPlayer.IsPlayer() )

	weapon.EmitWeaponSound_1p3p( GetGrenadeThrowSound_1p( weapon ), GetGrenadeThrowSound_3p( weapon ) )

	#if CLIENT
		Signal( weapon, "Blackhole_EndPreview" )
	#endif
	                                                                   
	                    
	entity deployable = ThrowDeployable( weapon, attackParams, 1.0, BLACKHOLE_ProjectileLanded, null, <0, 0, 400> )
	if ( deployable )
	{
		entity player = weapon.GetWeaponOwner()
		PlayerUsedOffhand( player, weapon, true, deployable )

		#if SERVER
			                                      

			                                                                                                                           
			                              
				                                                  

			                                                            
			                            
				                                                

			                                         

			                                                                                                      
			                                                                       
			                                                                                                                                                                       
			                                                                                                                                                                        
			                                                                                                                                                                        

		#endif
	}
	                                                                   

	#if SERVER
		                                                                      
	#endif

	return ammoReq
}


void function OnWeaponDeactivate_weapon_black_hole( entity weapon )
{
	#if CLIENT
		if ( weapon.GetWeaponOwner() != GetLocalViewPlayer() )
			return

		Signal( weapon, "Blackhole_EndPreview" )
	#endif

}


void function BLACKHOLE_ProjectileLanded( entity projectile, DeployableCollisionParams collisionParams )
{
	#if SERVER
		                               

		                                                                                       
		                                             
		                                                           
		                                                  
		                                                  

		                                                                                                                       
		                                 
		 
			                                                               
			                                                                     

			                                             
			                                                                       
			  	                                           
		 
		                                        
		                                                                                                                            
		 
			                             
		 

		                                        

		                            
			                    


		                  
		                                                                                 
	#endif
}

#if SERVER
                                                                                              
 
	                                                               
	 
		                            
			        

		                                                                          
			        

		                                                                                   
			               
	 
	           
 

                                                                                                                           
 
	                         
	 
		            
	 
	                              
	 
		            
	 

	                                                                                             
	                                                                                  
	                                                                                                                
	 
		            
	 

	           
 

                                                                                                  
 
	                                                                                                        

	                          
	                                    
		                        
		                                             
		                                                                                               

	                             
	 
		                                                                         
		                                              
		                                                                                                                                                 

		       
			                            
			 
				               
				                                  
				 
					       
				 
				    
				 
					       
				 

				                                                  
			 
		      
		                                   
		 
			           
		 
	 

	            
 


                                                                                             
 
	                                    

	                                                                                           
	                                                         

	                   
	 
		                          
		                               
		                                    
	 

	                                                                                                                            

	                             
	                                              
	                                           
	                                        
	                                       
	                                      
	                                         
	                                                   
	                                       
	                                                                                        
	                                                                                                            
	                                                                                                                                          

	                   
	 
		                                                                                                                                           
	 

	                               
	                                                           
	                   
	 
		                                               
		                                     
	 

	                           
	                                          
	                              

                    
	                                          
       

	                                          
	                                          
	                                           
	                                          
	                                          
	                                                                                   

	                             

	                                                                 
	                                                                         
	                                                               

	               
 
                                                                                                         
 
	                  
	                                                                   
	                  

	            
	                       
	 
		                                                                       
		                           
		                                         
		                           

		                              
		                                         
		                           
	 
	    
	 
		                
	 

	                                         
	                                                  
	                                              

	                                                   
	                                 

	                                                                                       
	                                                                                       

	                                         
	                                                       
	                                         
	                                                                 

	                                                          
	                                                                                                                                             
	                                                                                      


	                             
	                                                                                                                                                                                                                                                      

	                                                                         
	                                                                                                                                                                                         
	                                                                                                                                                                                         
	                                                                                                                                                                                         

	                                                                                   
	                                                                                                                                                                                             
	                                     
	                                     
	                                     
	                                         

	                                                   
	                                     
	                                                                
	                                              
	                                                   
	                           

	                                                                      
	                                                                                                                                                                                                      
	                                                                                     
	                                                                 
	                                          
	                                                         
	                                        
	                     

	            
		                                                                               
		 
			                                      
			                                                
			                                               

			                                 
			 
				                    
				 
					                                               
					                
					            
				 
			 

			                       
				               

			                                
				                        

			                              
				                      
		 
	 

	                                              

	                                                

	                                                      

	                                                                                                                           
	                                                                                                                   
	             

	                                                                    
	                                                                                                                                                                                                    
	                                                                                    
	                                                                
	                                         
	                                                      

	                                                  

	                                     
		                             

	                                                
	                                                              
	                                                                 
	                                                              

	                                       
	                         
	                                                                                                                           
	                                                                   

	                                         
	                                            
	                                         

	                                     
	                             
	                                                      
	                                                 

	                             
		                         
	                             
		                         
	                             
		                         

	                                                     
 

                                                                   
 
	                                  
	                                                            
	                                                           
 

                                                              
 
	                                  

	             
	 
		                                      

		                                                                                             
		                                                                                                                     
		                      
		 
			                                                                                                                                                
			                                                                                                                                                           
		 

                                
                                                                                                                                   
                                                                                                                                      
    
                                                                                                                                                    
                                                                                                                                                                                  
    
        
	 
 

                                                                       
 
	                                                                                                                           
	                                                                                                                                                           
	             

	                                  
	 
		                              
	 
 

                                                          
 
	                                                    
	                                     
		      

	                                     
		      

	                                             
	                                                                                                                   


	                                      
	 
		       
			                      
			 
				                                                          
			 
		            

		                                    
		                                                                                  
		                                                                                              
		                                                                                                                                                                                                                     

		                                                            
		                                                                                              
	 
 


                                                                                                         
 
	                                                                                 
	                                                                       
	                                                                                           
	                                                                                         
	                                                              
	                                                                                                
	                                                                                                         
	                                      
	                                                     
	                                                                                                       
	                                          
	                                               
	                                            
	                                           
	                                          
	                                            
	                                          
	                                          
	                                   
	                                              
	                                
	                             
	                              
	                                                                           
	                                                       

	                             

	                                  
	                                                

	                                                                                                                     
	                                                                                                            
	                                                 
	                                                                                                      
	                                

	                                 
	                                                 

	                   
 

                                                                                                                                                 
 
	                                                                                                                                              
	                             
	 
		                                                  
		                                                      
	 
	                                      
	   
	  	                     
	  
	  		     
	  
	  	        
	  		                         
	   

	                      

	                                             
	 
		                                                                
	 
 


                                                                                
 
	                                    
	                                 

	              
	 
		                                              
		                                                                  
		                                                                                    

		                                               
		                                     
		                                                                        

		                              
		 
			                                                                    
			      
		 

		           
	 
 

                                                                                 
 
	                                                      
	                                       

	                                              
	                                               
	                                               

	                                                                                                                                  
	                                                                                                                                  
	                                                                                                                                  
	                                                                                                                                  

	                                                         
	                                      
	                                           
	                                                                                                                                                                    
	                                   
	                                     
	                                     
	                                            
	                                            
	                                        
	                           
	                        

	                

	                             
	                                           

	                                                   
	                                          


	                                                  
	                                                                                              


	                                 

	                      
	 
		                                                  
	 

	                                                                                                      
	             

	            
		                                      
		 
			                      
			 
				                                                
			 
			                         
			 
				                 
			 
		 
	 

	                                                                                                           
	                                                                                                               
	                                                                                               
	                             
	 
		                                                                                                  
		                                                                                                                              
		                                                                                                                        
	 

	                      

	                                            


	                                                      

	                        
 


                                                                                 
 
	                       
	                                  
	 
		                                          
		                 
		 
			                             
		 

		                                                                                                      

		                   
		         
	 
 


                                                                      
 
	                                                         
	                                                                  

	                                                                           

	                                             
	                                              
	                              
	 
		                                          
	 

	                                                                

	                                                                                       
	                      
	                                         

	                             
	        
 



                                                                                   
 
	                          
	 
		                                     
			      

		                                                                                
		                                                          
		                                                                                                                                   

		                      
		 
			                                                                                 
			                                                                     
			                                                                                                                                            
		 

		                                                           
	 
 
                                                                        
 
	                                                                       
	                                             

	                       
	 
		                                                        
		 
			                        
			 
				                                                          
				                                                                                      
				 
					                                
					                                         
				 
			 
		 
	 
 

                                                                         
 
	                                                       
	                                                        

	                           
		      

	                           
		      

	                            
		      

	                                           
	 
                                             
                                             

                                                           
                  
	 

	                                                                               

	                                                                            
	 
		                                                           
		 
			                                     
			      
		 

                                
                                                             
                                                                                 
    
                                         
          
    
        
	 

	                                                              
	                                                    

	                                 
		                                                                                       
	                                                                                 
	 
		                                                    
		                                                 
	 
 

                                                                             
 
	                                                       
	                                                        
	                                                      

	                           
		      

	                           
		      

	                            
		      

	                                           
	 
                                             
                                             

                                                           
                  
	 

	                                                              
	                                                    
	                  
		      

	                                           
	                                                         

	                          
	 
                            
                                                                     
            
                                                                 

                                                                                                                                        
                                                                                                        
                                                                                                                                        
	 

	                                       
	                                    

	                                              
	                                        

	                       
	                                           
		                                           

	                                                                  
	                                                                                     
	 
		                                       
		                                                  
		 
			                                                                      
		 

		                                                                    

		                                          
	 


	                    
	 
		                                           
		                                     
		              
	 
 

                                                                
 
	                                                                
	                                                                 
	                                                                           

	                                                                           
	                                                                  
	                                                                                                                                                                   
 
#endif         


void function BLACKHOLE_TriggerEnter( entity trigger, entity ent )
{
	if ( !ent.DoesShareRealms( trigger ) )
		return

	#if SERVER
		                  
		 
			                    
			 
				                                          
				                                                                                                                                                     
			 
			      
		 
		                                                                                                                 
		 
			                                                                              
			 
				                                                     
			 
			      
		 
	#endif         

	if ( !ent.IsPlayer() )
		return

	thread BLACKHOLE_InTriggerThread( trigger, ent )
}


void function BLACKHOLE_InTriggerThread( entity trigger, entity player )
{
	EndSignal( trigger, "OnDestroy" )
	EndSignal( player, "OnDestroy" )
	EndSignal( player, "OnDeath" )


	array<entity> player3PBlackholeFXArray

	entity newtProp = trigger.GetParent()

	OnThreadEnd(
		function() : ( player, player3PBlackholeFXArray, newtProp )
		{
			if ( IsValid( player ) )
			{
				#if SERVER
					                                                                                       
					                                                                  
					                                      
					                                                                                                      
				#endif
				StatusEffect_StopAllOfType( player, eStatusEffect.in_black_hole_field )
			}
		}
	)


	#if SERVER
		                                                 
		 
			                                                                   
			 
				             
				                                                       
				                                              
				 
					                                          
					                               
					 
						                                                                                     
					 
				 
			 
		 

		                                                                                                      
	#endif


	const TICK_RATE = 0.1
	float currentTime = Time()
	float frameTime   = 0
	while( trigger.IsTouching( player ) )
	{
		frameTime   = Time() - currentTime
		currentTime = Time()
		#if SERVER
			                                                                                               
			 
				                            

				                                         
					                            

				                                         
				 
					                      
					                                       
				 

				                                                                                 
				 
					                                                                         
					                                                                      
				 

				                                                  
				                                                                    
				                                                         
				                                                                                                      
				                                                      

				                                                                                                                                                                      

				                      
				 
					                                                                
					                                                                       
					                                                                        

					                                                                                                   
					                                                                                                                                 
					                                                                                                                  
					                                                                                                                  
				 
			 
			    
			 
				                                                                                       
				                                                                       
			 
		#endif

		WaitFrame()
	}
}

#if SERVER
                                                                            
 
	                                 
	                               

	                                
	                                     

	            
		                              
		 
			                                       
			                                    
			 
				                                     
			 
			                                                                      
		 
	 


	                                                                        

	                                                                     
	 
		                             
		 
			                                                                 
		 

		                                                  
		                                                                   
		                                                        

		                                                            
		 
			                                                                                                                                                                                                    
			                                                                     
			                                                          
			                                                             
			                                
			                                
		 
		    
		 
			                                       
			                                     
		 

		                               
		   
		  	                                                                                                              
		  	                                                                                                                        
		  	                                                                                                           
		   

		           
	 
 
#endif         

#if SERVER
                                                                                                       
 
	             
	                         
	                           


	              
	               
	                                                             
	                                                                                                                                                               

	                                                                           
	                           
	                                                                                                               
	                                   

	                                                                                                                                                                                                                
	                             
	                                                                                                               
	                                     
   

                                                                        
 
	                      
	 
		                                    
	 

	             
	                                  
	 
		                    
			            
	 
	                        
 
#endif         

#if CLIENT
                                    
void function Blackhole_Start1PFX( entity ent, int statusEffect, bool actuallyChanged )
{
	ManageHighlightEntity( ent )

	if ( !actuallyChanged && GetLocalViewPlayer() == GetLocalClientPlayer() )
		return

	if ( ent != GetLocalViewPlayer() )
		return

	entity viewPlayer = GetLocalViewPlayer()

	int fxHandle
	fxHandle = StartParticleEffectOnEntityWithPos( viewPlayer, BLACKHOLE_1P_SCREEN_OTHER_FX_ID, FX_PATTACH_ABSORIGIN_FOLLOW, ATTACHMENTID_INVALID, viewPlayer.EyePosition(), <0, 0, 0> )

	EffectSetIsWithCockpit( fxHandle, true )

	thread Blackhole_1PFXThread( viewPlayer, fxHandle )
}

void function Blackhole_Stop1PFX( entity ent, int statusEffect, bool actuallyChanged )
{
	ManageHighlightEntity( ent )

	if ( !actuallyChanged && GetLocalViewPlayer() == GetLocalClientPlayer() )
		return

	if ( ent != GetLocalViewPlayer() )
		return

	foreach ( player in GetPlayerArray() )
	{
		ManageHighlightEntity( player )
	}

	ent.Signal( "Blackhole_Stop1PFXSignal" )
}
void function  Blackhole_1PFXThread( entity player, int fxHandle )
{
	player.EndSignal( "Blackhole_Stop1PFXSignal" )
	player.EndSignal( "OnDeath" )

	OnThreadEnd(
		function() : ( fxHandle, player )
		{
			if ( !EffectDoesExist( fxHandle ) )
				return

			EffectStop( fxHandle, false, true )

			if ( IsValid( player ) )
			{
				StopSoundOnEntity( player, BLACKHOLE_SOUND_PLAYER_INSIDE_1P )
			}
		}
	)

	if ( IsValid( player ) )
	{
		EmitSoundOnEntity( player, BLACKHOLE_SOUND_PLAYER_INSIDE_1P )
	}

	while ( EffectDoesExist( fxHandle ) )
	{
		WaitFrame()
	}
}


void function AddBlackholeThreatIndicator( entity newtProp )
{
	entity player = GetLocalViewPlayer()
	ShowGrenadeArrow( player, newtProp, BLACKHOLE_TUNING_RADIUS, 0.0 )
}

#endif         
