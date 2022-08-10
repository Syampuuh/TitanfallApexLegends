global function MpWeaponIncapShield_Init

global function OnWeaponChargeBegin_weapon_incap_shield
global function OnWeaponChargeEnd_weapon_incap_shield
global function OnWeaponOwnerChanged_weapon_incap_shield
global function OnWeaponPrimaryAttack_incap_shield
global function OnWeaponPrimaryAttackAnimEvent_incap_shield
global function OnWeaponActivate_incap_shield
global function OnWeaponDeactivate_incap_shield

#if CLIENT
global function OnCreateChargeEffect_incap_shield
#endif              

                                                                                                      
const bool INCAP_SHIELD_PERSIST_LOGIC = true
const bool INCAP_SHIELD_DEBUG = false

const float INCAP_SHIELD_MOVE_SLOW_SEVERITY = 0.55

const INCAP_SHIELD_FX_WALL_FP = $"P_down_shield_CP"                               
const INCAP_SHIELD_FX_WALL = $"P_down_shield_CP"                               
const INCAP_SHIELD_FX_COL = $"mdl/fx/down_shield_01.rmdl"                                      
const INCAP_SHIELD_FX_BREAK = $"P_down_shield_break_CP"

const string SOUND_PILOT_INCAP_SHIELD_3P = "BleedOut_Shield_Sustain_3p"
const string SOUND_PILOT_INCAP_SHIELD_1P = "BleedOut_Shield_Sustain_1p"

const string SOUND_PILOT_INCAP_SHIELD_END_3P = "BleedOut_Shield_Break_3P"
const string SOUND_PILOT_INCAP_SHIELD_END_1P = "BleedOut_Shield_Break_1P"


struct
{
} file

                                                                                                                                    
                                                                                                                                    
                                                                                                                                    
                                                                                                                                    
  
                                                            
                                                             
                                                             
                                                             
                                                             
                                                             
                                                            
  
                                                                                                                                    
                                                                                                                                    
                                                                                                                                    
                                                                                                                                    

void function MpWeaponIncapShield_Init()
{
	PrecacheModel( INCAP_SHIELD_FX_COL )

	PrecacheParticleSystem( INCAP_SHIELD_FX_WALL_FP )
	PrecacheParticleSystem( INCAP_SHIELD_FX_WALL )
	PrecacheParticleSystem( INCAP_SHIELD_FX_BREAK )

	RegisterSignal( "IncapShieldBeginCharge" )

}


#if CLIENT
void function OnCreateChargeEffect_incap_shield( entity weapon, int fxHandle )
{
	int shieldEnergy = weapon.GetScriptInt0()
	if ( shieldEnergy <= 0 )
	{
		weapon.StopWeaponEffect( INCAP_SHIELD_FX_WALL_FP, INCAP_SHIELD_FX_WALL_FP )
		return
	}

	thread UpdateFirstPersonIncapShieldColor_Thread( weapon, fxHandle, INCAP_SHIELD_FX_WALL_FP )
}
#endif              

                                                                                                                                    
                                                                                                                                    
                                                                                                                                    
                                                                                                                                    
  
                                                                                                                    
                                                                                                                     
                                                                                                               
                                                                                                               
                                                                                                               
                                                                                                                     
                                                                                                                    
  
                                                                                                                                    
                                                                                                                                    
                                                                                                                                    
                                                                                                                                    

#if !INCAP_SHIELD_PERSIST_LOGIC
bool function OnWeaponChargeBegin_weapon_incap_shield( entity weapon )
{
	entity player = weapon.GetWeaponOwner()

	if ( player.IsPlayer() )
	{
#if SERVER
		                                                                    

		                                                                                                                          
			                                   
#endif              
	}

	return true
}

void function OnWeaponChargeEnd_weapon_incap_shield( entity weapon )
{
	weapon.Signal( "OnChargeEnd" )

	foreach( effect in weapon.w.statusEffects )
		StatusEffect_Stop( weapon.GetWeaponOwner(), effect )
}

void function OnWeaponOwnerChanged_weapon_incap_shield( entity weapon, WeaponOwnerChangedParams changeParams )
{
	entity newOwner = weapon.GetWeaponOwner()
	entity oldOwner = changeParams.oldOwner

#if SERVER
	                           
		                
	    
		                                                                                                      
#endif              
}

var function OnWeaponPrimaryAttack_incap_shield( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	return 0
}

var function OnWeaponPrimaryAttackAnimEvent_incap_shield( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	return 0
}

void function OnWeaponActivate_incap_shield( entity weapon )
{
}

void function OnWeaponDeactivate_incap_shield( entity weapon )
{
}

#if SERVER
                                                               
 
	                                         
	                                                                                                                                             
 

                                                                    
 
	                                            
	                                       
	                                     

	             
	 
		                                                         
		                             
		 
			                                        
				                                                
		 
		    
		 
			                                                                        
		 

		           
	 
 

                                                               
 
	                             
	                               
	                                            
	                               
	                                 

	                                                            

	                               
	                                                                                                                                                                                 

	                                             
	                                  
	                                          

	                                                                      

	                                                                              
	                                                                            

	            
		                                           
		 
			                        
			 
				                                                        
				                                                        
			 

			                           
			 
				                                          
					                                      
				                                             
					                

				                                             
				                   
			 

			                                     
		 
	 

	                                                                   
	             
 

                                                                 
 
	                                                 
	                                                      
	                                                                

	                 
	 
		                                          
			                                     
	 

	                                           
	                 
	 
		                                                 
			                                                                                                                     

		                                                           

		                              
		                        
		 
			                                                          
			                                               
		 

		                                 
		                        
			                                       

		                        
		 
			                           
			 
				                         
				                                                           
				                                                                                                                                                                                                                                            
				                                                                                                            
				                                                                                  
				                                                                                
				             
			 
		 
	 
 

                                                                       
 
	                    
	                       
	                                                                                                     

	                               
	                                            
		                                              

	                                                                     
	                       
	                 
	                                  
	                     
	                               
	                             
	                            
	                                                               
	                              
	                   
	                                   
	                                 

	                                                           
	                
 

                                                          
 
	                                                    
	                                                   

	                                
 
#endif              
#endif                                   

                                                                                                                                    
                                                                                                                                    
                                                                                                                                    
                                                                                                                                    
  
                                                                                                             
                                                                                                              
                                                                                                        
                                                                                                        
                                                                                                        
                                                                                                              
                                                                                                             
  
                                                                                                                                    
                                                                                                                                    
                                                                                                                                    
                                                                                                                                    

#if INCAP_SHIELD_PERSIST_LOGIC

var function OnWeaponPrimaryAttack_incap_shield( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	return 0
}

var function OnWeaponPrimaryAttackAnimEvent_incap_shield( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	return 0
}

void function OnWeaponOwnerChanged_weapon_incap_shield( entity weapon, WeaponOwnerChangedParams changeParams )
{
#if SERVER
	                                         
	                          
		                                                                                                      
	    
		                
#endif              
}

void function OnWeaponActivate_incap_shield( entity weapon )
{
#if SERVER
	                                                     
	                              
	 
		                                      
		                      
		                                     
	 

	                                            
	                              
		      

                  
	                                                           
	 
		                                                                                                               
		                                                                                                             

		                                                             
		                    
			              

		                                                                                       
	 
       

	                                                                                                                   
	                           
	 
		                         
			                                                                   
			
		      
	 
	
	                                         
	                        
	 
		                         
			                                                                    

		      
	 

	                    
	               			       
	            			                 
	                      	                                                   
	              			        
	        				             
	            			             
	                   		           
	        				                     
	            			      
	                      	            

	                                                           

	                                                               
	                                   

	                         
		                                                                           

	                                                     

	                                          
	                                                                            
#endif              
}

void function OnWeaponDeactivate_incap_shield( entity weapon )
{
#if SERVER
	                                                     
	                              
	 
		                      
		                                     
	 
#endif              
}

bool function OnWeaponChargeBegin_weapon_incap_shield( entity weapon )
{
#if SERVER
	                                            
	                              
		           

	                                                      
#endif              

	return true
}

void function OnWeaponChargeEnd_weapon_incap_shield( entity weapon )
{
	weapon.Signal( "OnChargeEnd" )
}

#if SERVER
                                                                                
 
	          			                                           
	               		                                      
	                   	                                            

	                  
		      

	                          
	 
		                                                                
			      

		                          
			                                                                                                                           
	 

	                                                           

	                         
		                                                                                         

	                                

	                     
		                                      

	                                       
	                                    

	                                             
	 
		                                 

		                                               
		                     
		 
			                                                           

			         			                                                 
			             		                                      
			                   	                                         
			                   	                                         

			                                                                                           
			                                                                                                               

			                                                                                  
			                                                                                
		 
	 
 

                                                                      
 
	                
	                
	                                                

	                                                  
	                            
	 
		                         
			                                                         

		      
	 

	                                              
	                                         
	                                            

	                                 
	                               
	                               
	                             
	                                            
	                                  

	                                                       
	                                                
	                                 
		           

	                         
		                                                         

	                                                                    

	            
	                                                    

	                                                 
	 
		        
	 

	      
	                    
	        				        
	           				                      
	                     	       
	                     	      
	                  		                                            
	                   		             
	                  		                                           
	                                                              

	      
	                                                                            
	                                                                              

	                
	                                                                                                                    

	            
		                                                               
		 
			                         
				                                                         

			                           
			 
				                                                     

				                                                
					                   

				                                   
			 

			                        
			 
				                                                        
				                                                        

				                                               
			 
		 
	 

	              
	 
		                                                            

		           
	 
 

#endif              

#endif                                  