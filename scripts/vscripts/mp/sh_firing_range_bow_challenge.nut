#if SERVER || CLIENT
global function ShFRC_Bow_Init
#endif

const asset TARGET_SPINNING_BASE = $"mdl/barriers/shooting_range_target_02_stand.rmdl"
const asset TARGET_SPINNING_MODEL = $"mdl/barriers/shooting_range_target_02.rmdl"
const vector TARGET_ORIGIN = <32390, -5678, -28953>
const vector TARGET_END = <TARGET_ORIGIN.x, -4654, TARGET_ORIGIN.z>

const float TRAVEL_LENGTH_1Q = ( TARGET_END.y - TARGET_ORIGIN.y ) / 4.0
const vector TRAVEL_1Q_POINT = <TARGET_ORIGIN.x, TARGET_ORIGIN.y + ( TRAVEL_LENGTH_1Q ), TARGET_ORIGIN.z>
const vector TRAVEL_MID_POINT = <TARGET_ORIGIN.x, TARGET_ORIGIN.y + ( 2 * TRAVEL_LENGTH_1Q ), TARGET_ORIGIN.z>
const vector TRAVEL_3Q_POINT = <TARGET_ORIGIN.x, TARGET_ORIGIN.y + ( 3 * TRAVEL_LENGTH_1Q ), TARGET_ORIGIN.z>

const array< vector > MOVE_TARGETS =[ TARGET_ORIGIN , TRAVEL_1Q_POINT, TRAVEL_MID_POINT , TRAVEL_3Q_POINT, TARGET_END]

const string BOW_CHALLENGE_TARGET_MOVER_SCRIPTNAME = "bow_challenge_target_mover"

struct NextMoveIndexData
{
	int nextIndex = -1
	bool changedDirections = false
}


struct ChallengeData
{
	entity target = null
}

struct
{
	table< int, ChallengeData > challengeDataByRealm
} file

#if SERVER || CLIENT
void function ShFRC_Bow_Init()
{
	if ( GetMapName() != "mp_rr_canyonlands_staging" )                                                  
		return

	if ( !IsFiringRangeGameMode() )
		return

	if ( !FRC_IsEnabled() )
		return

	FiringRangeChallengeRegistrationData data
	data.challengeKey = "mp_weapon_bow_challenge"
	data.gunRackOrigin = <30712.15, -5278.97, -29163.97>
	data.gunRackAngles = <0, 180, 0>
	data.gunRackScriptName = "gunrack_model2"
	data.weaponRef = "mp_weapon_bow"
	data.weaponMods = [ "optic_cq_holosight_variable", "hopup_shatter_rounds", "hopup_marksmans_tempo" ]
	data.weaponMdl = $"mdl/weapons/compound_bow/w_compound_bow.rmdl"
	data.challengeTime = 60.0
	data.challengeType = eFiringRangeChallengeType.FR_CHALLENGE_TYPE_BEST_DAMAGE
	data.statTemplate = CAREER_STATS.s12e04_challenge_2
	data.challengeName = "#FRC_CHALLENGE_2_NAME"
	data.challengeInteractStr = "#FRC_CHALLENGE_2_INTERACT"
	data.challengeStartHint = "#FR_CHALLENGE_TARGET_HINT"
	data.rewardTracker = $"settings/itemflav/gcard_tracker/frc_challenge2_score.rpak"

	data.borderName = "frc_challenge2_border"
	data.borderType = 0
	data.outOfBoundsTriggerScriptName = "frc_challenge2_trigger"

	data.playerTeleportPosition = <30840.5, -5287.0, -29164>
	data.squadSafePosition = [<30595.6, -5535.3, -29162.3>, <30593.2, -5073.2, -29138.2>]

	#if SERVER
		                                        
		                                        
		                                          
	#endif

	FRC_RegisterChallenge( "mp_weapon_bow_challenge", data )

	RegisterSignal("ChallengeTargetDamaged")
}
#endif

#if SERVER
                                             
 
	                         
		      

	                                 
	                                            
	 
		                  
		                                        
	 

	                                      
 

                                         
 
	                                            
		      

	                                       
 

                                                               
 
	                         
		      

	                  
	                
	                                 
	                                 
	                          
	                                

	                                                                                                                                   
	                                
	                              

	                                      

	                                                                                                 

	                                                                                               
	                                                
	                                             

	                                                                                               
	                                                    

	                                                                                                                  
	                                                                   
	                          

	                                
	                
	                               
	                             

	                              
	                                

	                                            
	                             

	                               
	                             
	                                 
	                               

	                                                                             

	                                    
	                                         
	                              

	                                      
	                                        

	                                                     

	                                                               
 

                                                                           
 
	                      
		      

	                                              
		      

	                                                      
	          
	                            

	                                            

	                                            

	                                                                                                                                     
	 
		                         
			                                        
			                                                                                         
			                                                                            
			                                                                         
			                                                
		 

		                                                                                                          
	 
 

                                                                                               
 
	                                               
		      

	                                
	                                
	       
		                                       
	      

	                                              
	                                                                           
 

                                             
 
	                                                      
 

                                                        
 
	                       
		      

	                                
	                                       
	       
		                                       
	      

	                                                          
		      

	                                                                   

	                     
	                                  

	            
		                                 
		 
			                                
				                                                                         
		   


	                                                                                    

	         
	                                
 

                                                                   
 
	                                

	                                       
	                               
		      

	                                     

	                                           
	                              
		      

	                                    

	                                                                                                            
	                                      

	                  

	           
	                 
		            

	                       

	                                                                                                           
	              
	                       
	                               
	                           
	                                                                                                       
	              
	                 
	                                 
	                             
	                                                                                                       
	              
	                 
	                                                          
	                              
	                              
	 
		                                                                                                       
		              
		                 
	 

	                                                                 
	                                                                 
	                                      
	                                         
	                                   
	                                        

	              
	 
		                                                                                                                                          
		                                                                                             
		                         

		                                    
		 
			                                    
			                              
			                                  
		 

		                                                                                                                  
			                                                   
		    
			                                                                                                                      
		
		                                               
		                                                    
	 
 

                                                                                                                  
 
	                      
	                       
	 
		       
			                  
			     
		       
			                  
			     
		       
		       
		       
		 
			                                                                     
			                                                                                                                           
			     
		 
		        
			     
	 

	           
 

                                                                               
 
	                                
	                                     

	              
	 
		                                 
		                                                                                
		                                        
		                          

		        

		                                                                                 
		                                         
		                           
	 
 
#endif