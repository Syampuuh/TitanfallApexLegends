global function MpAbilityCryptoDroneEMP_Init
global function OnWeaponAttemptOffhandSwitch_ability_crypto_drone_emp
global function OnWeaponPrimaryAttack_ability_crypto_drone_emp
#if SERVER
                        
                           
#endif

const asset EMP_CHARGE_UP_FX = $"P_emp_chargeup"
const CAMERA_EMP_EXPLOSION = "exp_drone_emp"
const asset FX_EMP_SUPPORT_FX = $"P_emp_explosion"
const asset EMP_WARNING_FX_SCREEN = $"P_emp_screen_player"
const asset EMP_WARNING_FX_3P = $"P_emp_body_human"
const asset EMP_WARNING_FX_GROUND = $"P_emp_body_human"
const asset EMP_RADIUS_FX = $"P_emp_charge_radius_MDL"


                                                                                                
const string EMP_CHARGING_3P = "Char11_UltimateA_A_3p"
const string EMP_CHARGING_CRYPTO_3P = "Char11_UltimateA_A_3p"
const string EMP_CHARGING_1P = "Char11_UltimateA_A"

struct
{
	#if CLIENT
		int colorCorrection
		int screenFxHandle
	#endif         
} file

void function MpAbilityCryptoDroneEMP_Init()
{
	PrecacheParticleSystem( EMP_CHARGE_UP_FX )
	PrecacheParticleSystem( FX_EMP_SUPPORT_FX )
	PrecacheImpactEffectTable( CAMERA_EMP_EXPLOSION )
	PrecacheParticleSystem( EMP_WARNING_FX_SCREEN )
	PrecacheParticleSystem( EMP_WARNING_FX_3P )
	PrecacheParticleSystem( EMP_RADIUS_FX )
	RegisterSignal( "Emp_Detonated" )
	RegisterSignal( "EMP_Destroy" )
	#if CLIENT
		RegisterSignal( "EndEMPWarningFX" )
		StatusEffect_RegisterEnabledCallback( eStatusEffect.crypto_emp_warning, EMPWarningVisualsEnabled )
		StatusEffect_RegisterDisabledCallback( eStatusEffect.crypto_emp_warning, EMPWarningVisualsDisabled )
	#endif
	RegisterNetworkedVariable( "isDoingEMPSequence", SNDC_PLAYER_EXCLUSIVE, SNVT_BOOL, false )
}


bool function OnWeaponAttemptOffhandSwitch_ability_crypto_drone_emp( entity weapon )
{
	int ammoReq  = weapon.GetAmmoPerShot()
	int currAmmo = weapon.GetWeaponPrimaryClipCount()
	if ( currAmmo < ammoReq )
		return false

	entity player = weapon.GetWeaponOwner()
	if ( player.IsPhaseShifted() )
		return false

                        
	if ( StatusEffect_GetSeverity( player, eStatusEffect.crypto_has_camera ) == 0.0 )
	{
		#if CLIENT
			AddPlayerHint( 1.0, 0.25, $"rui/hud/tactical_icons/tactical_crypto", "#CRYPTO_ULTIMATE_CAMERA_NOT_READY" )
		#endif
		return false
	}
      

	if ( StatusEffect_GetSeverity( player, eStatusEffect.crypto_camera_is_recalling ) > 0.0 )
	{
		                                                    
		return false
	}

	printt( "\t| Attempting offhand switch. Player net bool for emp sequence false?", player.GetPlayerNetBool( "isDoingEMPSequence" ) )
	if ( player.GetPlayerNetBool( "isDoingEMPSequence" ) )
		return false

	return true
}


var function OnWeaponPrimaryAttack_ability_crypto_drone_emp( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	entity weaponOwner = weapon.GetWeaponOwner()
                       
                                                    
     
	if ( StatusEffect_GetSeverity( weaponOwner, eStatusEffect.crypto_has_camera ) == 0.0 )                                                                                                          
      
	{
                         
            
                                
        
       
			return 0
        
	}
	else if ( StatusEffect_GetSeverity( weaponOwner, eStatusEffect.crypto_camera_is_recalling ) > 0.0 )
	{
		return 0
	}
	else
	{
		#if SERVER
			                              
		#endif
	}

	PlayerUsedOffhand( weaponOwner, weapon )

	int ammoReq = weapon.GetAmmoPerShot()
	return ammoReq
}

#if SERVER
                                      
 
	                                          
	                                                                                           
	                                                                                               
		      

	                                                            
	                                                                                                                                      
		      

	                                
	                               

	                                                                 
	                                            
	                                                          

	                                                                    
	                                                             
	                                                                                                                         
	                                                                                                                                                           
	                                                                

	                                   

	                                                    

	                        
	                                                                                                   
	                                
	                                                                   

	                            

	            
		                      
		 
			                                                                 
			                                                
			 
				                                                                 
				                               
				 
					                                                                                       
				 
			 

			                                                     
		 
	 
	                 

	                           
	                                
	                                            
	                              
	                          
	                        
	                    
	                                        
	                                                               

	                                                                                                                                  
	                               
	                                           

	                                        
	                                                                           
	                                                                         
	                                    
	 
		                              
			        

		                                                                                
			        

		                                 
		                                                                          
		 
			                                                                                                 
			                                                                    
				        
		      
		 
			                                                                               
			                 
			                                                                        
				        
		 

		               
		            

                     
		                                  
		 
			              
			                          
		 
		    
      
		 
			                  
			                          
		 

		                                  
		                                         

		                        
		 
			                                          
				                                                                       
			                                                                 
			                                                                            
			                                                                        
		 

		                                                                         
		 
			                                                                    
				        
		 

		                                            
		                                                                

		                                                                   
			                                           

		                                                                                                                                                          
		 
			                                                                                                                                                                   
			                                                        
		 

		                                                                         
		 
			                                                              
			                                          
		 

		                                         
			                                                                                                                                
	 

	                               
		                                                                                       

	                                                                   
		                                           
	    
		                                             

	 
		                                                                       
		                                    
		 
			                                                     
				        

			                                                                  
			                                        
		 

		                                                                     
		                                   
		 
			                                                     
				        

			                                                                                                              
			                                        
		 

		                                                                       
		                                    
		 
			                                                                

			                         
			 
				                                     
				 
					                                                                       
				 
				    
				 
					                  
				 
			 


			                
				        

			                                  
			                                        
		 
	 

	        

	                           
		                   
 

                       
                                     
 
                                                                    

                                                                  
                                            
                                                           

                                                                     
                                                                 
                                                                                                                         
                                                                                                                                                           
                                                                 

                                                     

                         
                                                                                                  
                                 
                                                                   

                             

             
                        
   
                                                                    
                                                   
    
                                                                     
                                   
     
                                                                                            
     
    

                                                        
   
  

                                             
                                  
  
                               
   
                                                            
                                                                  
   
      
   
                                                              
                                                                    
   
             
  

                            
                                
                                            
                               
                           
                         
                     

                              
        

                                                                       
 
      

                                                                                          
 
	                                        
	                                                              

	                                                                                                                                  
	                               
	                                          

	                                       
	                                                                           
	                                                                        
	                                    
	 
		                              
			        

		                                                                                
			        

		                                 
		                                                                          
		 
			                                                                                                 
			                                                                    
				        
		      
		 
			                                                                               
			                 
			                                                                        
				        
		 

		               
		            

                     
		                                  
		 
			              
			                          
		 
		    
      
		 
			                  
			                          
		 

		                                  
		                                         

		                        
		 
			                                          
				                                                                       
			                                                                 
			                                                                            
			                                                                        
		 

		                                                                         
		 
			                                                                    
				        
		 

		                                            
		                                                                

		                                                                   
			                                           

		                                                                                                                                                          
		 
			                                                                                                                                                                   
			                                                         
		 

		                                                                
		 
			                                                              
			                                 
		 

		                                         
			                                                                                                                                
	 

	                               
		                                                                                       

	                                                                       
	                                    
	 
		                                                     
			        

		                                                                  
		                                         
	 

	                                                                     
	                                   
	 
		                                                     
			        

		                                                                                                              
		                                         
	 

	                                                                       
	                                    
	 
		                                                                

		                         
		 
			                                     
			 
				                                                                       
			 
			    
			 
				                  
			 
		 


		                
			        

		                                  
		                                        
	 

	        

	                           
		                   
 

                                                                                                                       
 
	                                                                                                          
	                              
	 
		                                                                 
			        

		                                         
			        

		                                                             
		                                                              
		                                              
		                                                   
	 
 

                                                                                                     
 
	                                                    

	                              
	                                    
	                                                             
	            
		                                                 
		 
			                                      
			 
				                         
					        
				                                                                      
				                                        
					                                
			 
		 
	 

	                                                                                                                                                  
	             
	 
		                                                                                  
		                   
                        
                                     
       

		                                      
		                                      
		 
			                                       
				        

			                                                                      
			                                            
			                                
		 

		                                   
		 
			                         
				        
			                      

			                                          
			 
				             
					                                                                     
				    
					                                                                                                 

				        
			 

			                                 

			                                                                        
			                                 
			                                                                                 
			 
				                                                    
				 
					                                                                
					                                          
				 
			 

			                                                                                                                                                      
			                              
			             
				                                                         
			    
				                                                                                       

			                               
				                                    
			    
				                                     

		 

		           
	 
 
#endif

#if CLIENT
void function EMPWarningVisualsEnabled( entity ent, int statusEffect, bool actuallyChanged )
{
	if ( ent != GetLocalViewPlayer() )
		return

	entity player = ent

	entity cockpit = player.GetCockpit()
	if ( !IsValid( cockpit ) )
		return

	thread EMPWarningFXThink( player, cockpit )
}

void function EMPWarningVisualsDisabled( entity ent, int statusEffect, bool actuallyChanged )
{
	if ( ent != GetLocalViewPlayer() )
		return

	ent.Signal( "EndEMPWarningFX" )
}

void function EMPWarningFXThink( entity player, entity cockpit )
{
	player.EndSignal( "OnDeath" )
	cockpit.EndSignal( "OnDestroy" )

	int fxHandle = StartParticleEffectOnEntity( cockpit, GetParticleSystemIndex( EMP_WARNING_FX_SCREEN ), FX_PATTACH_ABSORIGIN_FOLLOW, ATTACHMENTID_INVALID )
	EffectSetIsWithCockpit( fxHandle, true )
	EmitSoundOnEntity( player, "Wattson_Ultimate_G" )
	vector controlPoint = <1, 1, 1>
	EffectSetControlPointVector( fxHandle, 1, controlPoint )

	                                                                                                                                         
	int fxHandleGround = StartParticleEffectOnEntity( player, GetParticleSystemIndex( EMP_WARNING_FX_GROUND ), FX_PATTACH_ABSORIGIN_FOLLOW, ATTACHMENTID_INVALID )

	player.WaitSignal( "EndEMPWarningFX" )

	if ( EffectDoesExist( fxHandle ) )
		EffectStop( fxHandle, true, false )

	if ( EffectDoesExist( fxHandleGround ) )
		EffectStop( fxHandleGround, true, false )
}
#endif             


#if SERVER
                                                                                                  
 
	                               

	                                                  

	                     
	 
		                                        
			                                             
			                                               
			                                                                                                                              
			     
		                                          
		        
			                                                                                             
			                    
			                                       
			     
	 
 
#endif