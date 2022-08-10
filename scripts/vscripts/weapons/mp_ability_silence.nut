global function MpAbilitySilence_Init
global function OnProjectileCollision_ability_silence
global function OnWeaponReadyToFire_ability_silence
global function OnWeaponTossReleaseAnimEvent_ability_silence
global function OnWeaponDeactivate_ability_silence

global function Silence_GetEffectDuration

#if SERVER
                                        
#endif

                   
const float SILENCE_AREA_DURATION = 10.0
const float SILENCE_AREA_RADIUS = 175.0                               

            
const asset FX_SILENCE_READY_1P = $"P_wpn_bSilence_glow_FP"
const asset FX_SILENCE_READY_3P = $"P_wpn_bSilence_glow_3P"

const asset FX_SILENCE_SMOKE_CENTER = $"P_bSilent_orb"
const asset FX_SILENCE_SMOKE = $"P_bSilent_fill"
const vector FX_SILENCE_SMOKE_OFFSET = <0,0,-20>

                                                                     

global const string SILENCE_MOVER_SCRIPTNAME = "silence_mover"
global const string SILENCE_TRACE_SCRIPTNAME = "silence_trace_blocker"

const float SILENCE_BOUNCE_DOT_MAX = 0.5

const bool SILENCE_DEBUG = false
const bool SILENCE_DEBUG_STATUSEFFECT = false
const bool SILENCE_DEBUG_WEAPONEFFECT = false

struct
{
	float effectDuration
} file

void function MpAbilitySilence_Init()
{
	PrecacheParticleSystem( FX_SILENCE_READY_1P )
	PrecacheParticleSystem( FX_SILENCE_READY_3P )
	PrecacheParticleSystem( FX_SILENCE_SMOKE )
	PrecacheParticleSystem( FX_SILENCE_SMOKE_CENTER )

	file.effectDuration = GetCurrentPlaylistVarFloat( "revenant_silence_effect_duration", 15.0 )

	#if SERVER
	                                                                             
	                                                                         
	                                                                                    
	#endif
}

void function OnWeaponReadyToFire_ability_silence( entity weapon )
{
	if ( SILENCE_DEBUG_WEAPONEFFECT )
		printt( "WEAPON: READY TO FIRE")

	weapon.PlayWeaponEffect( FX_SILENCE_READY_1P, FX_SILENCE_READY_3P, "muzzle_flash" )

	#if CLIENT
		thread PROTO_FadeModelIntensityOverTime( weapon, 1.0, 0, 255)
	#endif

}

void function OnWeaponDeactivate_ability_silence( entity weapon )
{
	if ( SILENCE_DEBUG_WEAPONEFFECT )
		printt( "WEAPON: DEACTIVATE")

	weapon.StopWeaponEffect( FX_SILENCE_READY_1P, FX_SILENCE_READY_3P )

	#if CLIENT
		thread PROTO_FadeModelIntensityOverTime( weapon, 0.25, 255, 0)
	#endif

	Grenade_OnWeaponDeactivate( weapon )
}

var function OnWeaponTossReleaseAnimEvent_ability_silence( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	if ( SILENCE_DEBUG_WEAPONEFFECT )
		printt( "WEAPON: TOSS RELEASE")

	weapon.StopWeaponEffect( FX_SILENCE_READY_1P, FX_SILENCE_READY_3P )
	Grenade_OnWeaponTossReleaseAnimEvent( weapon, attackParams )
	return weapon.GetWeaponSettingInt( eWeaponVar.ammo_per_shot )
}

#if SERVER
                                                  
 
	                         
		            

                      
		                                  
			            
                            

	           
 
#endif          

void function OnProjectileCollision_ability_silence( entity projectile, vector pos, vector normal, entity hitEnt, int hitbox, bool isCritical, bool isPassthrough )
{
	projectile.proj.projectileBounceCount++

	if ( projectile.proj.projectileBounceCount <= projectile.GetProjectileWeaponSettingInt( eWeaponVar.projectile_ricochet_max_count )
			&& DotProduct( normal, <0, 0, 1> ) < SILENCE_BOUNCE_DOT_MAX )
	{
		return
	}


	#if SERVER
		                                     
		                                                
		                        
		 
			                                              
			                                                                                                                                                                                          
			                            
			                                                                                                                                                                
			                               
			 
				                                           
				                                                                                                                                                                          
				                       
			 

			            
			                                    
			 
				                                                                                                      

				                                                       
					                                                         

				                           
				                                       
			 
			                                                          
		 
	#endif
	projectile.GrenadeExplode( normal )
}

#if SERVER
                                                                                             
 
	                               
	         
	                         	                                                     
		      

	                                                                       
	                                  
	                               
	                                           

	                    
		                                                                                      

	                       
	 
		                                                      
	 
	    
	 
		                                                                                  
	 

	                                                                          

	                      
	                                  
	                                               

	                           
	                               
	                         
	                              
	                               
	                               
	                                
	                                
	                                
	                                
	                               
	 

	                                   
	                                           
	 
		                          
	 

	            
	                                        
		 
			                                
			 
				                             
				 
					                     
				 
				                             
				 
					                     
				 
			 
			                       
			 
				                                                      
				               
			 
			    
			 
				                                                         
			 
		 
	 

	                        

	                                                                     
	                       
		                              
	                           
	             
	 
		                                           
		 
			                                      
			                                           
			                                  
			                                                                                                             

			                  

			                                                                                                               
			                                            
			 
				                                                       
				                           

				                   
				 
					                           
					 
						                                                                    
							                        

						        
					 
					    
					 
						               
						   
							                                 
							 
								         
								                        
								 
									                                                                                                      
									                                                                      
								 
								    
								 
									                                                                                                                                                                                 
									                                                                                                                                                       
								 

								                   
								                                                                                                                                                                 

								                       
									                                 

								                        
								 
									                                
									 
										                         
										                                     
									 
								 
							 
							    
							 
								                                                   
								                        
								 
									                                
										                               
									                                
										                               
									                    
										                                                 
								 
							 
						   
					 
				 
			 
			                        
			 
				                                 
				 
					         

					                        
					 
						                                                                                                      
						                                                                     
					 
					    
					 
						                                                                                                                                                                                 
						                                                                                                                                                       
					 

					                   
					                                                                                                                                                                 

					                       
						                                 

					                        
					 
						                                
						 
							                         
							                                     
						 
					 
				 
				    
				 
					                                                   
					                        
					 
						                                
							                               
						                                
							                               
						                    
							                                                 
					 
				 
			 
		 

		                                                                      
		                                                                                                           
		           
	 
 

                                                                          
                                                                    
 
	                                                                       

	                                                                  
	 
                                             
		                                             
       
                        
        
		 
			                                       
			      
		 
	 
 

                                                        
 
	                                                          
		      

	                                                                         
		                    

	                                        
		      

	                        
	                                                             
	                                                 
	 
		                                                                                       
			                  
	 
	    
	 
		                                                                                         
			                  
	 
	                  
	 
		                                                          
		                                                  
		                                                                               
	 
	    
	 
		                                       
		                                                        
		                           
			                                                    
	 
 
#endif         

float function Silence_GetEffectDuration()
{
	return file.effectDuration
}