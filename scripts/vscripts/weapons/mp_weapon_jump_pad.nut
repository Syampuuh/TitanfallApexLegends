global function OnWeaponTossReleaseAnimEvent_weapon_jump_pad
global function OnWeaponTossPrep_weapon_jump_pad

const float JUMP_PAD_ANGLE_LIMIT = 0.70

const bool JUMP_PAD_NEW_DEPLOY_FUNC = true


var function OnWeaponTossReleaseAnimEvent_weapon_jump_pad( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	int ammoReq = weapon.GetAmmoPerShot()
	weapon.EmitWeaponSound_1p3p( GetGrenadeThrowSound_1p( weapon ), GetGrenadeThrowSound_3p( weapon ) )

	entity deployable = ThrowDeployable( weapon, attackParams, 1.0, OnJumpPadPlanted, null, null )
	if ( deployable )
	{
		entity player = weapon.GetWeaponOwner()
		PlayerUsedOffhand( player, weapon, true, deployable )

		#if SERVER
		                                      
		                                                                   

		                                                            
		                            
			                                                

		                                         
		#endif

		#if SERVER
			                                                           
		#endif
	}

	return ammoReq
}

void function OnWeaponTossPrep_weapon_jump_pad( entity weapon, WeaponTossPrepParams prepParams )
{
	weapon.EmitWeaponSound_1p3p( GetGrenadeDeploySound_1p( weapon ), GetGrenadeDeploySound_3p( weapon ) )
}

void function OnJumpPadPlanted( entity projectile, DeployableCollisionParams collisionParams )
{
#if SERVER
                            

	                                                                                                                                            
	                 	     
	                 	                                                              
	               		                                                              
	                                                                                                                             
	                                    
	 
		                                                             
		                                                                                  
		                                        
	 

	                                                          

                                     

	                               
	                                      

	                                    
	                                                
	                                               
	                                                  
	                                             

	                                                                                                                      
	                                 
	 
		                                                               
		                                                                     

		                                             
		                                                              
			                                           
	 

	                                         
	                        
	                                                                    

	                            
	                              
                      
		                                                       
                            
	                                                                                                              
	 
		                                     
		                                          
	 
	                                
	 
		                                 
	 

	                                                    
	                                                                                 

	                                                          

                                               
#endif              
}