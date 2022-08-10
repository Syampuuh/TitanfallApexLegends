  

#if SERVER
                                                                 
#endif         
global function OnProjectileCollision_npcweapon_thermite_grenade

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
}

#if SERVER
                                                                                                
 
	                                            

	                                                   
	 
		                                                  
		      
	 

	                                                   
	 
		                             
		                                     
		                       
			                                                                   
		    
			                                                  
	 
 
#endif         

void function OnProjectileCollision_npcweapon_thermite_grenade( entity projectile, vector pos, vector normal, entity hitEnt, int hitbox, bool isCritical, bool isPassthrough )
{
	entity npc = projectile.GetOwner()
	if ( hitEnt == npc )
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

	                      
	  	                                                                 

	DeployableCollisionParams collisionParams
	collisionParams.pos = pos
	collisionParams.normal = normal
	collisionParams.hitEnt = hitEnt
	collisionParams.hitBox = hitbox
	collisionParams.isCritical = isCritical

	if ( npc && !npc.IsPlayer() )
		collisionParams.hitEnt = GetEntByIndex( 0 )

	if ( !PlantStickyEntity( projectile, collisionParams ) && !forceExplode )
		return

	projectile.SetDoesExplode( false )

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