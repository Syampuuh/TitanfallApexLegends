global function PhaseDriver_Init
#if DEV && SERVER
                                   
                                        
                              
                               
#endif                 

global const asset PHASEDRIVER_VFX_LOOTSPAWN = $"P_phase_tower_loot_spawn"
global const asset PHASEDRIVER_VFX_AMBIENT = $"P_phase_tower_ambient"
global const asset PHASEDRIVER_VFX_ACTIVE = $"P_phase_tower_active"
global const asset PHASEDRIVER_VFX_SPARKS_BATTERY_1 = $"P_phase_twr_batt_exp_01"
global const asset PHASEDRIVER_VFX_SPARKS_BATTERY_2 = $"P_phase_twr_batt_exp_02"
global const asset PHASEDRIVER_VFX_SPARKS_PORTAL_1 = $"P_phase_twr_batt_exp_03"
global const asset PHASEDRIVER_VFX_SPARKS_PORTAL_2 = $"P_env_sparks_dir_LG_02"

const float LOOT_ROLLER_SPAWN_DELAY = 0.0       

table< asset, float > vfxLifetime = {}

struct PhaseDriverStruct
{
	float lastUsedTime = -100.0
	float cooldown = 45.0
	bool isUsable = true
	array<entity> panels
	array<entity> spawnPoints
	array<entity> activeProps
	int propBudget = 40
	int nodesPerUse = 5
	array<entity> cargoBins
	vector emitSFX_origin
	vector vfx_origin
	vector vfx_angles
	entity vfx_ambient
	entity vfx_active

	float spark_stutter_battery_ambient_min = 2.5
	float spark_stutter_battery_ambient_max = 4.0
	float spark_stutter_battery_active_min = 1.0
	float spark_stutter_battery_active_max = 1.5

	float spark_stutter_portal_ambient_min = 0.2
	float spark_stutter_portal_ambient_max = 0.6
	float spark_stutter_portal_active_min = 0.05
	float spark_stutter_portal_active_max = 0.2

	array< vector > sparks_battery_origins =
	[
		< -17819.5, -23259.5, -2811.5 >,
	 	< -17651.5, -23261.4, -2811.32 >,
		< -17135.5, -22745.4, -2811.32 >,
		< -17127.7, -22565.6, -2811.13 >,
		< -17647.2, -22058.1, -2809.29 >,
		< -17820.3, -22027.1, -2818.74 >,
		< -18333.9, -22576.6, -2808.5 >,
		< -18354.0, -22751.4, -2807.92 >,
	]
	array< vector > sparks_battery_angles =
	[
		< 0.0612351, 89.3366, 32.1913 >,
		< 0.0612351, 89.3366, 32.1913 >,
		< 0.0612356, 177.506, 32.1913 >,
		< 0.0612356, 177.506, 32.1913 >,
		< -4.39719, -94.1236, 27.3742 >,
		< -4.39719, -94.1236, 27.3742 >,
		< 0.187968, -6.56482, 25.2541 >,
		< 0.187968, -6.56482, 25.2541 >,
	]

	array< vector > sparks_portal_origins =
	[
		< -17733.9, -21784.3, -3244.4 >,                             
		< -17416.3, -21845.6, -3246.4 >,
		< -17121.2, -22041.9, -3246.4 >,                              
		< -16926.8, -22337.6, -3248.4 >,
		< -16866.1, -22657.2, -3248.4 >,
		< -16928.1, -22974.5, -3248.4 >,
		< -17122.6, -23270.2, -3248.4 >,                             
		< -17416.5, -23464.9, -3248.4 >,
		< -17735.9, -23526.3, -3244.4 >,
		< -18054.3, -23464.4, -3244.4 >,
		< -18351.3, -23270.9, -3244.4 >,                             
		< -18543.9, -22975.9, -3244.4 >,
		< -18603.2, -22656.1, -3244.4 >,
		< -18541.1, -22338.1, -3244.4 >,
		< -18350.1, -22041.3, -3244.4 >,
		< -18054.8, -21846.7, -3244.4 >,
	]

	array< vector > sparks_portal_angles =
	[
		< 85.5456, -1.181, 91.4244 >,
		< 85.9973, 159.013, -83.2925 >,
		< 84.1598, -84.9124, 54.1261 >,
		< 77.5916, 109.961, -89.4222 >,
		< 81.7195, 79.8108, -99.7312 >,
		< 85.2865, -12.46, -180 >,
		< 84.1767, 43.8258, -88.4144 >,
		< 80.7317, 21.7975, -90.4662 >,
		< 86.502, 93.191, 3.18506 >,
		< 84.3374, -22.4576, -88.0305 >,
		< 87.9906, -47.2809, -93.363 >,
		< 85.6525, -68.4407, -89.3891 >,
		< 88.9014, -91.0186, -89.338 >,
		< 85.2598, -113.474, -86.3478 >,
		< 87.1546, -134.874, -92.6642 >,
		< 87.6447, -158.202, -84.224 >,
	]
#if DEV
	bool bypassCooldown = false
	bool flipVFX = false
#endif       
}
PhaseDriverStruct phaseDriverStruct

void function PhaseDriver_Init()
{
#if SERVER
	                                
	                                                            
	                                                        
	                                                   

	                                                   
	                                                 
	                                                
	                                                          
	                                                          
	                                                         
	                                                         

	                                              
	                                       
	                                      

	                                             
	                                                    
	                                                    
	                                                   
	                                                   
#endif
}

void function PhaseDriverBootstrap()
{
#if SERVER
	                   
	                       
#endif
}

void function PhaseDriverPanelInit( entity panel )
{
#if SERVER
	                                                     
	                                                       
	 
		                                          
		                                        
		                              
	 
#endif          
}

void function PhaseDriverSpawnPointInit( entity spawnPoint )
{
	#if SERVER
		                                                                         

		                                                               
		 
			                                              
			                                                  
		 

		                                                                  
		 
			                                                  
			                                                         
		 

		                                                                             
		 
			                                                  
			                                                     
			                                                     
			                                                                                                                                                                                        
			                                                                                                                                                                                      
		 

	#endif          
}

void function PhaseDriverLootbinInit( entity bin )
{
	                              
#if CLIENT
	printf( "client | bin instance name: %s", bin.GetInstanceName() )
#endif          
#if SERVER
	                                                                 
	                                                   
	   
	  	                                         
	  	                                            
	   
#endif          
}

void function SetupPhaseDriverPanel( entity panel )
{
#if SERVER
	                                                                   
	                                                                       
	                                  
	                                              
	                                           
	                 
#endif          
}

void function OnUse_PhaseDriverPanel( entity panel, entity player, int useInputFlags )
{
#if SERVER
	                                
	 
		      
	 

       
	                                                              
      
	                                                                      
	                                                                    
#endif          

	thread PhaseDriverSequence_Thread( )
}

void function PhaseDriverSequence_Thread()
{
#if SERVER
	                                                                     

	                                  
	                                                  
	 
		                   
		                                                            
	 

	                                                                                                                
	                  
	                     

	                        

	           

	                                                  
	 
		                 
		                                                                           
	 

	                                                                                                                

	                    

	                            
	 
		                                                   
	 

	                                  
	                              

	                              
	                          
	                                  
	                                                             
	 
		                                          
		                                
		                           
		                            
		                        
			                                                          
		                         
		                            
		                      
		                        
		                                                                                                                      
		                                                                                

		                                                                                                                                                                         

		                                                                                          
		                                                                                                                                    
		                                 
		                                                                                    
		         
	 

	                            

	                   
	        
	                       

#endif          
}

void function SpawnLootRollerOnDelay_Thread( vector spawnPos, vector angles, int lootTier, vector launchDir, float launchSpeed, vector spinDir, float spinSpeed )
{
#if SERVER
	                            
	                                                                                       
	                                                                                        
#endif          
}

void function ResetLootBins()
{
#if SERVER
	                                                    
	 
		                    
		 
			                                                         
		 
	 
	        
	                                                    
	 
		                   
		                                                                                          
		                                                                               
	 
#endif          
}

bool function CanUse_PhaseDriverPanel()
{
	return phaseDriverStruct.isUsable
}

void function PhaseDriverCooldown()
{
#if SERVER
	                                                                       
	                                                                                                               

       
	                                       
	 
		                               
	 
     
	                               
      
	                                 
	                                                  
	 
		                                                                       
		                                                   

	 
#endif          
}

#if SERVER
                                            
 
	                                                   

	         
	 
		                                                                     
		                                                                                                               
		                                                                                                                                                                                      
		                                 
		                                                              
		                                                                                                                                             
		             
	 
 

                                           
 
	                                                   
	         
	 
		                                                                    
		                               
		                                                                                             
		                                                                                                                                                                                    
		                                 
		               
		 
			                                                                                                                                
		 
		                                                              
		                                                                                                                                           
		             
	 
 

                                           
 
	                                                    

	         
	 
		                                                                     
		                                                                                                               
		                                                                                                                                                                                      
		                                 
		                                                              
		                                                                                                                                           
		             
	 
 

                                          
 
	                                                    
	         
	 
		                                                                    
		                               
		                                                                                             
		                                                                                                                                                                                    
		                                 
		               
		 
			                                                                                                                                
		 
		                                                              
		                                                                                                                                         
		             
	 
 

                                
 
	                                                

	                                              
	 
		                                          
	 
	                                             
	 
		                                            
	 

	       
	                                
      
 

                                   
 
	                                    
	                                   
 

                                 
 
	                                                 

	                                              
	 
		                                           
	 
	                                             
	 
		                                           
	 

	       
	                                 
      
 

                                     
 
	                                     
	                                    
 

#endif          

#if DEV && SERVER
                                   
 
	                                                                  
	                                        
	 
		                  
		                     
	 
	    
	 
		                   
		                       
	 
 

                                        
 
	                                                                    
	                                                                                       
 
#endif                 