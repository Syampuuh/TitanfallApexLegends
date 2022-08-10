global function MpWeaponClusterBombLauncher_Init
global function OnProjectileCollision_weapon_cluster_bomb_launcher
global function OnWeaponOwnerChanged_weapon_cluster_bomb_launcher

                           
const asset CLUSTER_BOMB_MODEL = $"mdl/weapons_r5/misc_fuse_tactical_grenade/w_fuse_tactical_grenade_projectile.rmdl"
const asset CLUSTER_BOMB_FIRST_EXPLOSION_FX = $"P_fuse_tac_exp_air"
const asset CLUSTER_BOMB_SECONDARY_EXPLOSION_FX = $"P_fuse_tac_exp_air"
const asset CLUSTER_BOMB_TRAIL_FX = $"P_fuse_tac_bomb_trail"
const asset CLUSTER_BOMB_LAUNCHER_IMPACT_FX = $"P_fuse_tac_impact"
const asset CLUSTER_BOMB_LAUNCHER_LIGHT_FX = $"P_fuse_tac_light"
const string CLUSTER_BOMB_INITIAL_IMPACT_TABLE = "exp_fuse_tac_bomb"
const string CLUSTER_BOMB_FIRST_EXPLOSION_IMPACT_TABLE = "exp_fuse_tac_bomb_first_explo"
const string CLUSTER_BOMB_SECONDARY_EXPLOSION_IMPACT_TABLE = "exp_fuse_tac_bomb_secondary_explo"
const string CLUSTER_BOMB_TIMER_SFX = "Fuse_Tactical_Timer_3p"

          
const vector CLUSTER_BOMB_EXPLOSION_POS_OFFSET = < 0, 0, 5>
const float CLUSTER_BOMB_LAUNCHER_FIRST_EXPLOSION_DELAY = 1.7
const float CLUSTER_BOMB_LAUNCHER_DAMAGE_INFLICTOR_LIFETIME = 20.0
const float CLUSTER_BOMB_SUBSEQUENT_DAMAGE_PERCENTAGE = 0.5
const float CLUSTER_BOMB_EXPLOSION_DURATION = 1.0
const float CLUSTER_BOMB_BURST_ROUGH_DURATION = 2.0
const int CLUSTER_BOMB_MAX_HITS = 6
const float CLUSTER_BOMB_EXPLOSION_RADIUS = 150.0
const float CLUSTER_BOMB_DEFAULT_DAMAGE = 10.0
const string CLUSTER_BOMB_WEAPON = "mp_weapon_cluster_bomb"
const int CLUSTER_BOMB_WEAPON_SLOT = OFFHAND_EQUIPMENT
const float CLUSTER_BOMB_FIRST_LAUNCH_OFFSET = 3.0

       
const bool CLUSTER_BOMB_LAUNCHER_DEBUG = false

struct ClusterBurstData
{
	array<float> yawOffset = [ 0.0 ]
	float zVelMin = 0.0
	float zVelMax = 0.0
	float xyVel = 0.0
	float explodeDelayMin = 0.5
	float explodeDelayMax = 0.5
	float nextSpawnDelayMin = 0.1
	float nextSpawnDelayMax = 0.1
}

struct
{
#if SERVER
	                                                       
	                                  
#endif
} file

void function MpWeaponClusterBombLauncher_Init()
{
	PrecacheModel( CLUSTER_BOMB_MODEL )
	PrecacheWeapon( CLUSTER_BOMB_WEAPON )
	PrecacheParticleSystem( CLUSTER_BOMB_LAUNCHER_IMPACT_FX )
	PrecacheParticleSystem( CLUSTER_BOMB_TRAIL_FX )
	PrecacheParticleSystem( CLUSTER_BOMB_LAUNCHER_LIGHT_FX )
	PrecacheParticleSystem( CLUSTER_BOMB_FIRST_EXPLOSION_FX )
	PrecacheParticleSystem( CLUSTER_BOMB_SECONDARY_EXPLOSION_FX )
	PrecacheImpactEffectTable( CLUSTER_BOMB_INITIAL_IMPACT_TABLE )
	PrecacheImpactEffectTable( CLUSTER_BOMB_FIRST_EXPLOSION_IMPACT_TABLE )
	PrecacheImpactEffectTable( CLUSTER_BOMB_SECONDARY_EXPLOSION_IMPACT_TABLE )

#if SERVER
	                                                                                              
#endif
}

void function OnWeaponOwnerChanged_weapon_cluster_bomb_launcher( entity weapon, WeaponOwnerChangedParams changeParams )
{
	#if SERVER
		                                       
		                         
			                                 
	#endif
}

void function OnProjectileCollision_weapon_cluster_bomb_launcher( entity projectile, vector pos, vector normal, entity hitEnt, int hitbox, bool isCritical, bool isPassthrough )
{
	if ( !IsValid( hitEnt ) )
		return

	if ( IsValid( projectile.GetOwner() ) && hitEnt == projectile.GetOwner() )
		return

	if ( hitEnt.IsPlayer() && IsFriendlyTeam( hitEnt.GetTeam(), projectile.GetTeam() ) )
		return

	if ( hitEnt.IsPlayerVehicle() && IsFriendlyTeam( hitEnt.GetTeam(), projectile.GetTeam() ) )
		return

#if SERVER
	                                                                
	                                                                                     
		      
#endif

	DeployableCollisionParams collisionParams
	collisionParams.pos = pos
	collisionParams.normal = normal
	collisionParams.hitEnt = hitEnt
	collisionParams.hitBox = hitbox
	collisionParams.isCritical = isCritical
	collisionParams.highDetailTrace = true
	collisionParams.ignoreHullSize = true

	if ( hitEnt.IsPlayer() && StatusEffect_GetTimeRemaining(hitEnt, eStatusEffect.death_totem_recall) )
	{
		projectile.SetVelocity( <0,0,0> )
		projectile.ClearParent()
		projectile.SetPhysics( MOVETYPE_FLYGRAVITY )
	}
	else
	{
		PlantStickyEntity( projectile, collisionParams, ZERO_VECTOR, false, ( hitEnt.IsPlayer() || hitEnt.IsNPC() ) ? true : false )
	}

#if SERVER
	                                                     
		                                              
#endif         
}

#if SERVER
                                                                          
 
	                                          
		      
	                                                 

	                                                                  
	                                
		      
	                                       

	                                                  
	                       
		      
	                              

	                                                          
	                                                                                                                                                                                                                                                        
	                                                                                                   
	                                                                                                                                                                                                                                                      
	                                                                     

	            
		                                                                    
		 
			                              
				                          

			                             
				                         

			                                                                     
			                                          
				                                  
		 
	 

	                                                          

	                                                

	                                                                     
	                                                                                                                                                                
	                                                                                                           
	                                                            

	                     
	                                        

                            
	                                
	                    
	                    
	                  
	                          
	                          
	                            
	                                   

	                                
	                    
	                    
	                  
	                          
	                          
	                                   

	                                              
	                   
	                    
	                  
	                          
	                          
	                            
	                                   
        

                         
	  
	                                
	                    
	                    
	                  
	                          
	                          
	                            
	                                   

	                                
	                    
	                    
	                  
	                          
	                          
	                                   

	                                              
	                   
	                    
	                  
	                          
	                          
	                            
	                                   
	  

	                      
	                                         

	                                 
	                     
	                     
	                   
	                           
	                           
	                             
	                                     

	                                 
	                     
	                     
	                   
	                           
	                           
	                                     

	                                               
	                    
	                     
	                   
	                           
	                           
	                             
	                                     
      

	                                              
	                        
		      

	                                                                       
	                                                                           
	                                                                                                                                                 
	                                                                
		                                                                                                                                         

                         
	                                      

	                                                                 
		                                                                                                                                         
      
 

                                                                
 
	                                                
	                          
	                               
	                                          
	                                                            
	                
 

                                                                          
 
	                                  
	                               
	                                                   
	                                                    
	                                            
	                   
 

                                                                        
 
	                                                                                                         
	                              
		      


	                                                      
	                                                        
	                          
	 
		                                                                                           
		 
			                                         
		 
		                
		                           
		 
			                                                      
		 
		                                                                                                                
		 
			                                                         
				                                     
			                       
			                       
			 
				                                                                                              
				                                                              
			 
			                                                                       
			                          
			 
				                      
				                                                  
				 
					                                     
				 
				    
				 
					                                                                                                             
					                                          
				 
			 
			    
			 
				                         
				                                                                 
				                                          
			 
		 
	 
 

                                                                        
 
	                                                                  
	                                       

	                                                  
	                              

	                                                                                                               
                          
		                                                            
       

	                                                     
	                               
	                                                                
	                                          
	                                                                                                                                                                               

	            
		                               
		 
			                                
				                        
		 
	 

	                            
 

                                                                                                                                                    
 
	                             
		      

	                                        
	                                 
	 
		                                             
		                                          
		                                                                                       
		                                                            
		                            
			      

		                                        
		                                  
		                                         

		                                                                       
		                                                       
			                           
		    
			                                                                       
	 
 

                                                                                                                               
 
	                             
		      

	                                        

	                                   

	            
		                           
		 
			                            
				                    
		 
	 

	                               
	 
		                                                   
			                         
		    
			                                                                   
	 

	                                      
	                                     
	                        

	                                                                
	                                                                                 
		      

	                                                                                                                                                                          
	                                                                                                      
 

                                                                                                                          
 
	          
		    
		       
		          
		                           	 
		                            
		                              
		                              
		                                   
		    
		  
		                      
		                                       
		             

	                                                                                                         
 

                                                                                  
 
	                         
		           

	                                         
	                                                    
	                                                      
	                                                       
	                                                                          
	                                                                   
	                                                   
	                                                  
	                                                  
	                                                    
 

                                                      
 
	                                                                   
	                                                                              
		                                                    

	                                                                      
	 
		                                                                         
	 

	                                                          
 

                                                    
 
	                                                                   
	                                                                              
		                                                    
 


#endif         