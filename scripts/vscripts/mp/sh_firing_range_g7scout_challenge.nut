#if SERVER || CLIENT
global function ShFRC_G7Scout_Init
#endif

const asset TARGET_SPINNING_BASE = $"mdl/barriers/shooting_range_target_02_stand.rmdl"
const asset TARGET_SPINNING_MODEL = $"mdl/barriers/shooting_range_target_02.rmdl"
const vector STARTING_TARGET_ORIGIN = <32126, -6696, -29018>

const string G7_CHALLENGE_TARGET_MOVER_SCRIPTNAME = "g7_challenge_target_mover"

struct ChallengeData
{
	array< entity > activeTargets
	array< entity > targets

	int targetsHit = 0
	int damageDone = 0
	int critShots = 0
}

struct
{
	table< int, ChallengeData > challengeDataByRealm
} file

#if SERVER || CLIENT
void function ShFRC_G7Scout_Init()
{
	if ( GetMapName() != "mp_rr_canyonlands_staging" )                                                  
		return

	if ( !IsFiringRangeGameMode() )
		return

	if ( !FRC_IsEnabled() )
		return

	FiringRangeChallengeRegistrationData data
	data.challengeKey = "mp_weapon_g2_challenge"
	data.gunRackOrigin = <30712.15, -6688.12, -29163.97>
	data.gunRackAngles = <0, 180, 0>
	data.gunRackScriptName = "gunrack_model1"
	data.weaponRef = "mp_weapon_g2"
	data.weaponMods = [ "optic_cq_hcog_bruiser", "bullets_mag_l3", "barrel_stabilizer_l3", "stock_sniper_l3" ]
	data.weaponMdl = $"mdl/weapons/g2/w_g2a4.rmdl"
	data.challengeTime = 60.0
	data.challengeType = eFiringRangeChallengeType.FR_CHALLENGE_TYPE_TARGETS_HIT
	data.statTemplate = CAREER_STATS.s12e04_challenge_1
	data.challengeName = "#FRC_CHALLENGE_1_NAME"
	data.challengeInteractStr = "#FRC_CHALLENGE_1_INTERACT"
	data.challengeStartHint = "#FR_CHALLENGE_TARGET_HINT"
	data.rewardTracker = $"settings/itemflav/gcard_tracker/frc_challenge1_score.rpak"

	data.playerTeleportPosition = <30885.4, -6689.3, -29164>
	data.squadSafePosition = [<30564.6, -6463.7, -29152.87>, <30550.2, -6972.4, -29160.6>]

	data.borderName = "frc_challenge1_border"
	data.borderType = 0
	data.outOfBoundsTriggerScriptName = "frc_challenge1_trigger"

	#if SERVER
	                                        
	                                        
	                                          
	#endif

	FRC_RegisterChallenge( "mp_weapon_g2_challenge", data )

	RegisterSignal("ChallengeTargetDamaged")
}
#endif

#if SERVER
                                             
 
	                         
		      

	                                 
	                                            
	 
		                  
		                                        
	 

	                                                                     
	 
		                                           
	 


 

                                         
 
	                                            
		      

	                                       
 

                                                                           
 
	                       
		      

	                  
	                
	                                 
	                                 
	                          
	                               

	                                                                                                                  
	                                
	                              

	                                      

	                                                                                     

	                                                                                                
	                                                
	                                             

	                                                                                                 
	                                                   

	                                                                                                                    
	                                                                   
	                          

	                                
	                
	                               
	                             

	                                          
	                                                                         

	                              
	                                

	                                            
	                             

	                               
	                             
	                                 
	                               

	                                                                             

	                                    
	                                        
	                             

	                                      
	                                        

	                                                              

	                                                          
		                                                               

	                                                                                                                                                        
 

                                                                           
 
	                      
		      

	                                              
		      

	                                                      
	          
	                            

	                                            

	                                            

	                                                                                                                                     
	 
		                         
			                                        
			                                                                                         
			                                                                            
			                                                                         
			                                                
		 

		                                                                                                          
	 
 

                                                                                               
 
	                                               
		      

	                                
	                                
	       
		                                       
	      

	                                                               
	                                      
	                                              
	                                                                           
 

                                             
 
	                                                      
 

                                                        
 
	                                
	                                       
	       
		                                       
	      

	                     
	                                  

	            
		                          
		 
			                                
				                                                                         
		   


	                             
	                           
	 
		                                                                                                         
		 
			                     
			                                        
			                                                                    
			                        
			                                                                                 
			 
				                             
				 
					                  
					     
				 
			 

			                   
			 
				                                       
				                                                               
				                                      
			 
		 
		           
	 
	                                
 

                                                      
 
	                            
		      

	                                                 
	                                        
	                               
	                            

	                                          

	                              
		      

	                                   
	                                     

	                              
	                                                                                 
	                                         

	                                                              
	                                                

	                                                 
	 
		                                                                                          
		                                                                                            
	 
	    
	 
		                                                                    
	 

	                             
	                                                                                
	                                        
	           

	                                    
	                                         
		                                                                           

	                                                                  
	      
 
#endif