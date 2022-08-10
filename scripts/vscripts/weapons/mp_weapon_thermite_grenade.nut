
global function MpWeaponThermiteGrenade_Init
global function OnProjectileCollision_weapon_thermite_grenade
global function OnWeaponActivate_ThermiteGrenade
global function OnWeaponDeactivate_ThermiteGrenade

#if SERVER
                                   
#endif

const asset PREBURN_EFFECT_ASSET = $"P_wpn_meteor_wall_preburn"
const asset BURN_EFFECT_ASSET = $"P_wpn_meteor_wall"

#if SERVER
	                                                
#endif          

struct SegmentData
{
	           
	vector startPos
	vector endPos
	vector angles
	string sound
	entity moveParent
}

void function MpWeaponThermiteGrenade_Init()
{
	PrecacheParticleSystem( PREBURN_EFFECT_ASSET )
	PrecacheParticleSystem( BURN_EFFECT_ASSET )
}

void function OnWeaponActivate_ThermiteGrenade( entity weapon )
{
	#if CLIENT
		thread FadeModelIntensityOverTime( weapon, 2, 0, 255)
	#endif

	weapon.EmitWeaponSound_1p3p( "", "weapon_thermitegrenade_draw_3p" )
	Grenade_OnWeaponActivate( weapon )
}

void function OnWeaponDeactivate_ThermiteGrenade( entity weapon )
{
	#if CLIENT
		thread FadeModelIntensityOverTime( weapon, 0.25, 255, 0 )
	#endif

	Grenade_OnWeaponDeactivate( weapon )
}

void function OnProjectileCollision_weapon_thermite_grenade( entity projectile, vector pos, vector normal, entity hitEnt, int hitBox, bool isCritical, bool isPassthrough )
{
               
                                                     
  
            
                                           
        
                                                                                                     
        
  
       

	entity player = projectile.GetOwner()
	if ( hitEnt == player )
		return

	projectile.proj.projectileBounceCount++
	                                                                 

	int maxBounceCount = projectile.GetProjectileWeaponSettingInt( eWeaponVar.projectile_ricochet_max_count )

	bool forceExplode = false
	if ( projectile.proj.projectileBounceCount > maxBounceCount )
	{
		                                                    
		forceExplode = true
	}

	bool projectileIsOnGround = normal.Dot( <0,0,1> ) > 0.75
	if ( !projectileIsOnGround && !forceExplode )
		return

	                      
	  	                                                                 

	DeployableCollisionParams cp
	cp.pos = pos
	cp.normal = normal
	cp.hitEnt = hitEnt
	cp.hitBox = hitBox
	cp.isCritical = isCritical
                      
		cp.deployableFlags = eDeployableFlags.VEHICLES_NO_STICK
                            

	if ( IsPVEMode() && player && !player.IsPlayer() )
		cp.hitEnt = GetEntByIndex( 0 )

	vector dir = projectile.proj.savedDir
	dir.z = 0
	dir = Normalize( dir )

	if ( !PlantStickyEntity( projectile, cp, <0, 0, 0>, true ) && !forceExplode )
		return

	projectile.SetDoesExplode( false )

#if SERVER
	                         
	 
		                    
		      
	 
	                         
	                                                   
	                       
	 
		                                 
			                     
	 

	                    
		                                 

	                         
	                  
	            
	            
	                  
	                                
	                             
#endif          
}


void function ExplodeFunc( entity projectile, ProximityExplodeParams ep )
{
	#if SERVER
		                               
		                            		                                          
		                             		                                                                                      
		                          			                                                                                   
		                        			                                                                               
		                      				                                                                               
		                          			                                                                                    
		                              		                                                                                         
		                              		                                                                                         
		                                   	                                                                                               
		                                                                                                                                    
		                                 	                                                                                             
		                                                                                                                                    
		                               		                                                                                         
		                           			                                                                                   
		                                	                                                                                               

		                                                                                                 

		                                    
		                                                                                      

		                       
		 
			                                                                                                                       
			                                                                                                                           
		 
		    
		 
			                                                                                                                           
		 

		                                 
		                                      
	#endif
}


void function FadeModelIntensityOverTime( entity model, float duration, int startColor = 255, int endColor = 0 )
{
	EndSignal( model, "OnDestroy" )

	float startTime = Time()
	float endTime = startTime + duration

	                         

	while ( Time() <= endTime )
	{
		float alphaResult = GraphCapped( Time(), startTime, endTime, startColor, endColor )
		string colorString = alphaResult + " " + alphaResult + " " + alphaResult
		model.kv.rendercolor = colorString
		model.kv.renderamt = 255
		                                                                                                                                                                                           
		WaitFrame()
	}

	model.kv.rendercolor = endColor + " " + endColor + " " + endColor
	model.kv.renderamt = 255

}


#if SERVER
                                                                                                                                                                                                   
 
	                              

	                                                                                                                                   
	                                  
	                           
		      

	                    
		                         
	                                                                        
 

                                                                                                                               
 
	                              

	                                    
	 
		                                                           
		           
	 
 

                                                                       
 
	                               
	                                  

	                                   
	                                      

	            
  		                                          
  		 
  			                               
  			 
  				                       
  			 
  		 
  	 

  	             
 

                                                                                                               
 
	                              

	                                         
	                                         
	                                                 

	                                    
	 
		                                                                                       
		                                                                                       
		                                                                                               
	 

	                                                                                                                                                                      
	                                    
	 
		                                             
		                                              
		                                              

		                                                         
		                                                                          
		                                   
		                                                  
		                                                     
		                                                          

		                                                                   
	 

	                                 

	                                                                                                                                                             
	                                    
	 
		                                          
		                                           
		                                           

		                                                         
		                                                                          
		                                   
		                                                  
		                                                     
		                                                       

		                                                                
	 

	                                                                                                                               
	                                                                            
	
	                          
		                                              
 

                                                                                                
 
	                                

	                                                                                                                                           
	                                            

	                                                                                                                                                 
	                                           

	                                        
		                                                                                   
		                                                                               
	      

	                                                                                                                        
	                                        
		                                                                             
	      
	                                                                                           
		           

	                                                                                                                        
	                                        
		                                                                               
	      
	                                                                                           
		           

	            
 

                                                                                                                                                                                                     
 
	                              

	             
	                        
	                                

	         
	                      
	                                     

	                                                                                           
	                                                                                                                                                                              

	                                     
	 
		                          

		                   
		                  
			                                               

		                       
		                             
		                            

		                       
		                           
			                                
		                                                           
			                                          

		                  
		 
			                                   

			                      
			 
				                                                                                                                                  

				                                        
					                                                                          
				      

				                               
			 

			                                                       
			                                                                                                                                                                                                                  
		 

		                                        
			                                                                   
		      

		                                                                                                                                     
		                                   
		 
			                                              
			                 
				                                                

			                                                                                                                                                            

			                                        
				                                                                           
			      

			                                                                                                     
				     

			                   
			                   
			                              
			                                 
			                       
			                                                                

			                         
			                                  
			 
				                                  
				 
					                                                                                       
					 
						                                     
						                                                                                  
						                                                                                  
						                                                                                      
					 
				 
			 
			                                                     
			 
				                                  
				 
					                                                              
					 
						                                     
						                                                                                  
						                                                                                  
						                                                                                      
					 
				 
			 

			                                                                             
			                               

			                                                                      
				     

			                              
			                         

			        
		 

		                                        
		 
			     
		 

		                                    
		 
			                                                                                                                                  

			                                        
				                                                                          
			      

			                                 
				        
		 

		                                                                                                                                         

		                                        
			                                                                 
		      

		                                       
		 
			                                                                                                                                
				     
		 
		    
		 
			                                                                           
			                                                                                                                                                              

			                                        
				                                                                                  
			      

			                                                                                                     
				     

			                   
			                   
			                              
			                                 
			                       
			                                                                

			                         
			                                  
			 
				                                  
				 
					                                                                                       
					 
						                                     
						                                                                                  
						                                                                                  
						                                                                                      
					 
				 
			 

			                                                                             
			                               

			                                                                     
				     

			                              
			                         
		 
	 

	                                        
		                                                
	      

	                    
 

                                                                                                                                     
 
	                          

	                                                                                                                
	                        
	                                   

	                                                  

	                   
		                                                           

	             
 

                                                                                         
 
	                            
	                      

	                 
		                                               
	                                
		                                             
	                            
		                                                

	                 
 

#endif          
