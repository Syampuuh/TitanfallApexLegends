                                      

global function OnWeaponActivate_weapon_volt_smg
global function OnWeaponDeactivate_weapon_volt_smg

const string ADS_MOD = "in_ads"
const string ADS_THINK_THREAD_ABORT_SIGNAL = "ads_think_abort"
const float ADS_MOD_ZOOM_FRAC_REQUIRED = 0.5

void function OnWeaponActivate_weapon_volt_smg( entity weapon )
{
	OnWeaponActivate_ReactiveKillEffects( weapon )
}

void function OnWeaponDeactivate_weapon_volt_smg( entity weapon )
{
	OnWeaponDeactivate_ReactiveKillEffects( weapon )
}


  
                                    
 
	                                               
 

                                                               
 
	          
		                                       
		                         
			      

		                                     
	      
 

                                                                 
 
	          
		                                              
		                           
	      
 

          
                                                          
 
	                   
	                             
	                               
	                                                 

	            
		                               
		 
			                        
				                           
		 
	 

	              
	 
		                                               
			      

		                                                                                   
		 
			                                
				                        
		 
		                                    
		 
			                           
		 

		           
	 
 
               
  