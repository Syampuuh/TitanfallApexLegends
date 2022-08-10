global function MpWeaponCar_Init
global function OnWeaponActivate_Car
global function OnWeaponDeactivate_Car
global function OnWeaponPrimaryAttack_weapon_Car
global function OnWeaponReadyToFire_Car

global const string CMDNAME_CAR_AMMO_SWAP = "ClientCallback_CarHandleAmmoSwap"

#if SERVER
                                     
                                                
                                                         
#endif

#if CLIENT
global function Weapon_CAR_TryApplyAmmoSwap
#endif

const string CAR_ALT_AMMO_MOD = "alt_ammo"
const string CAR_AMMO_SWAP_MOD_FOR_RELOAD = "ammo_type_swap"
const string CAR_AMMO_SWAP_FAIL_SFX = "weapon_car_CantSwapAmmo"

void function MpWeaponCar_Init()
{
#if SERVER
	                                                                     
#endif
	Remote_RegisterServerFunction( CMDNAME_CAR_AMMO_SWAP, "entity" )
}

void function OnWeaponActivate_Car( entity weapon )
{
	entity player = weapon.GetWeaponOwner()
	if ( !IsValid( player ) )
		return
#if SERVER
	                                                  
		                          
#endif
}

void function OnWeaponDeactivate_Car( entity weapon )
{
}


void function OnWeaponReadyToFire_Car( entity weapon )
{
	if ( !IsValid( weapon ) )
		return

#if SERVER
	                                                    
		                                                
#endif
}

var function OnWeaponPrimaryAttack_weapon_Car( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	if ( !IsValid( weapon ) )
		return 0

	if ( !weapon.IsWeaponX() )
		return 0

	int clipCount = weapon.GetWeaponPrimaryClipCount()

	if ( clipCount > 0 )
	{
		weapon.FireWeapon_Default( attackParams.pos, attackParams.dir, 1.0, 1.0, false )
		return weapon.GetWeaponSettingInt( eWeaponVar.ammo_per_shot )
	}
	else if ( clipCount <= 0 )
	{
		entity player = weapon.GetWeaponOwner()

		if ( !IsValid(player) )
			return 0
#if SERVER
		                                     
#endif
#if CLIENT
		HandleCarDryFire( player, weapon, clipCount )
#endif
		return 0
	}

}

#if CLIENT
void function Weapon_CAR_TryApplyAmmoSwap( entity player, entity weapon )
{
	if ( !IsValid( player ) || !IsValid( weapon ) )
		return

	if ( weapon.HasMod( CAR_AMMO_SWAP_MOD_FOR_RELOAD ) || weapon.IsReloading() )
		return

	Remote_ServerCallFunction( CMDNAME_CAR_AMMO_SWAP, weapon )
}
#endif

#if SERVER
                                                                              
 
	                                              
		      

	                          
		      

	                                                                              
	 
		                                                                                                
			                           

		                              
	 
 
#endif

#if SERVER
                                                            
 
	                                              
		      

	                            		                                                   
	                            		                                                  
	                    				                                   

	                                                     
	 
		                                               
		                                  
		                                                      
		                                                                                  
	 
	                                                         
	 
		                                            
		                                 
		                                                       
		                                                                                  
	 
	    
	 
		                                                                       
	 
 
#endif

#if SERVER
                                                                 
 
	                                              
		      

	                          
		      

	                            		                                                   
	                            		                                                  

	                            		                                                            
	                            		                           
	                            		                                          

	                         			                                                                                                 
	                          			                                    
	                                 	                                                 

	                            		                                    
	                            		                               

	                    				                                 


                        
	                                                                                             
	 
		                          
		      
	 
                              

	                                
	 
		                          
		      
	 

	                                                                                   
	 
		      
	 

	                     
	 
		                                                   
		 
			                           
		 
		                                                           
		 
			                           
		 
		                                                                                        
		 
			                                               
			                                    
			                                                        
			                                                                                  
		 
		                                                                                       
		 
			                                            
			                                 
			                                                       
			                                                                                  
		 
	 
 
#endif

#if SERVER
                                                                               
 
	                              
	 
		                         
			      

		                          
			      

		                                       
		                       
			      

		                                                                
		                                                           
		                                                                               
		                                                                              
		                                                                                        
		                                                       
		                   			   

		                                           
			                                       
		                                                 
			                                      

		                                                                        


		                                
		                                                                                                                        
		                                                          
		                                     
			                              
		                                                            

		                                
		 
			                                     
		 

		                                                        
		                                        
		                     
		 
			                                                                                                                                       
			                                                                

			                                                        
			                                               
		 

		               
		 
			                                                           
			                                
			 
				                                             
				                          
			 
		 
		    
		 
			                                                                                  
			                                  
			 
				                                             
				                          
			 
		 
	 
 
#endif

#if SERVER
                                                                                
 
	                                            
			      

	                                       
		                                         
	                                             
		                                          
 
#endif

#if SERVER
                                                                        
 
	                         
		      

	                                                    
		                                                
 
#endif

#if CLIENT
void function HandleCarDryFire( entity player, entity weapon, int clipCount )
{
	if ( !IsValid( player ) )
	{
		Warning( "CAR HandleCarDryFire reached with invalid player" )
		return
	}
	int currentHighcalStockPile 		= player.AmmoPool_GetCount( eAmmoPoolType.highcal )
	int currentLightStockPile   		= player.AmmoPool_GetCount( eAmmoPoolType.bullet )
	if ( clipCount <= 0 && currentHighcalStockPile <= 0 && currentLightStockPile <= 0 && player.IsInputCommandPressed(IN_ATTACK) )
	{
		weapon.DoDryfire()
	}
}
#endif
