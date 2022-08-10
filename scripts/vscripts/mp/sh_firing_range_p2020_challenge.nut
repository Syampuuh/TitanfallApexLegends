#if SERVER || CLIENT
global function ShFRC_p2020_Init
#endif

const vector CHALLENGE_ORIGIN = < 31914.67, -5707.44, -29218.94 >
const float CHALLENGE_SPAWN_RADIUS = 225.0
const array<vector> SMOKE_COORDINATES = [ <31899.125, -5695.9375, -29216.0938>, <31900.7813, -5902, -29224.2188>, <31897.1875, -5492.5625, -29214.375> ]

struct ChallengeData
{
	entity npc = null
}

struct
{
	table< int, ChallengeData > challengeDataByRealm
} file

#if SERVER || CLIENT
void function ShFRC_p2020_Init()
{
	if ( GetMapName() != "mp_rr_canyonlands_staging" )                                                  
		return

	if ( !IsFiringRangeGameMode() )
		return

	if ( !FRC_IsEnabled() )
		return

	FiringRangeChallengeRegistrationData data
	data.challengeKey = "mp_weapon_semipistol_challenge"
	data.gunRackOrigin = <31218.45, -5631.31, -29235.98>
	data.gunRackAngles = <0, 180, 0>
	data.gunRackScriptName = "gunrack_model3"
	data.weaponRef = "mp_weapon_semipistol"
	data.weaponMods = [ "optic_cq_threat", "bullets_mag_l4", "hopup_unshielded_dmg" ]
	data.weaponMdl = $"mdl/weapons/p2011/w_p2011.rmdl"
	data.challengeTime = 60.0
	data.challengeType = eFiringRangeChallengeType.FR_CHALLENGE_TYPE_BEST_DAMAGE
	data.statTemplate = CAREER_STATS.s12e04_challenge_3
	data.challengeName = "#FRC_CHALLENGE_3_NAME"
	data.challengeInteractStr = "#FRC_CHALLENGE_3_INTERACT"
	data.challengeStartHint = "#FR_CHALLENGE_DUMMIE_HINT"
	data.rewardTracker = $"settings/itemflav/gcard_tracker/frc_challenge3_score.rpak"

	data.borderName = "frc_challenge3_border"
	data.borderType = 1
	data.outOfBoundsTriggerScriptName = "frc_challenge3_trigger"

	data.playerTeleportPosition = < 31338,  -5733.5, -29224 >
	data.squadSafePosition = [<31240.2, -6096.4, -29235.9>, <31226.7, -5358.7, -29235.8>]

	#if SERVER
		                                        
		                                        
		                                          
	#endif

	FRC_RegisterChallenge( "mp_weapon_semipistol_challenge", data )

	RegisterSignal("ChallengeTargetDamaged")
}
#endif

#if SERVER
                                             
 
	                         
		      

	                                 
	                                            
	 
		                  
		                                        
	 

	                                           
 

                                         
 
	                                            
		      

	                                                       
		                                              

	                                       
 

                                                             
 
	                          
		      

	                                
	                                       
	       
		                                       
	      

	                                                                      
	                         
	                       
	                  
	                        
	                                                                      

	            
		                    
		 
				                   
					             
		   

	                                          

	                                                                           
 

                                                                     
 
	                                
	                                       

	                                      

	              
	 
		                                                                                  

		                                            
		 
			     
		 

		                                 
		 
			                                                                                      
		 
		    
		 
			                                                                                     
			                                                                
			                                                                                                 
			                                                                
			                                                                      
			                                                                
			                                                                                                              
			                                               
		 

		                                                                                      
		                                                          
		                                                        

		                                                                                                       
		                                                                                                                 
		                                                                           
	 
 


                                             
 
	                                                      
 

                                                        
 
	                        
		      

	                                
	                                       
	       
		                                       
	      

	                     
	                                  

	            
		                                 
		 
			                                
				                                                                         
		   

	                                            
	                                                   
	         
	                                
 

                                                              
 
	                         
		      

	                                
	                                       

	                                                  
	 
		                             
		                                               
		                                         
		                              
		                                           
		                                               
		                                                                     

		                              
		                                   
		                           
		                                       
		                             
		                              
		                           
		                                     
		                                     
		                                     
		                             
		                        
		                        
		                                                       
		                                                       
		                                                          
		                                                          
		                                  

		                                                        
	 
 

                                                                                           
 
	                         
		      

	                                
	                                       

	                                    
	                                                            
	                            
	                   

	                                                                                  
	                             
	                           

	                                                    
	                                                                                              

	                                  
	                                 

	            
		                         
		 
			                         
				                 
		 
	 

	                                             

	               
 

                                                                    
 
	                                                        
 

                                                                             
 
	                                 
	                             
	                           

	                      
		      

	                                      
		      

	                     

	            
		                    
		 
			                                                                           
			                                                            
			                                                                           
		 
	 

	                                                    
	                                        
	                           
	                                  
	 
		                                                                    
		                                                                                                            

		                               
			                                            
		                                                                                        

		              
	 
 

                                                                                                         
 
	                      
		      

	                                              
		      

	                                                      
	          
	                            

	                                                                                                 
	 
		      
	 

	                          
	 
		                                                                                          
	 
 

                                                                         
 
	                      
		      

	                                              
		      

	                                                      
	          
	                            

	                                                                                                 
	 
		                                     
		      
	 

	                          
	 
		                                                                                                          
	 
 
#endif