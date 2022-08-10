global function OnWeaponPrimaryAttack_weapon_doubletake
global function OnWeaponChargeLevelIncreased_weapon_doubletake
global function OnWeaponChargeEnd_weapon_doubletake
global function OnProjectileCollision_weapon_doubletake
global function OnWeaponActivate_weapon_doubletake
global function OnWeaponDeactivate_weapon_doubletake

#if SERVER
                                                          
#endif              

struct
{
	EnergyChargeWeaponData chargeWeaponData
} file

void function OnWeaponActivate_weapon_doubletake( entity weapon )
{

		if ( weapon.HasMod( KINETIC_LOADER_HOPUP ) )
		{
			#if SERVER
				                                                                          
					                                      
			#endif
			OnWeaponActivate_Kinetic_Loader( weapon )
		}
#if SERVER
		    
		 
			                                             
				                                         

			                                                                  
			 
				                                   
				                          
			 
		 

		                                       

		                    
			      

		                        
		 
			                                                                                  
		 
	#endif
}

void function OnWeaponDeactivate_weapon_doubletake( entity weapon )
{
	OnWeaponDeactivate_Kinetic_Loader( weapon )
}

var function OnWeaponPrimaryAttack_weapon_doubletake( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	bool playerFired = true
	return Fire_DoubleTake( weapon, attackParams, playerFired)
}

#if SERVER
                                                                                                                
 
	                        
	                                                           
 
#endif              

int function Fire_DoubleTake( entity weapon, WeaponPrimaryAttackParams attackParams, bool playerFired )
{
	float patternScale = 1.0

	if ( playerFired )
	{
		float spreadAngle = weapon.GetAttackSpreadAngle()
		                                      
		patternScale += spreadAngle
	}
	else
	{
		patternScale = weapon.GetWeaponSettingFloat( eWeaponVar.blast_pattern_npc_scale )
	}

	bool ignoreSpread = false
	return Fire_EnergyChargeWeapon( weapon, attackParams, file.chargeWeaponData, playerFired, patternScale, ignoreSpread )
}

bool function OnWeaponChargeLevelIncreased_weapon_doubletake( entity weapon )
{
	return EnergyChargeWeapon_OnWeaponChargeLevelIncreased( weapon, file.chargeWeaponData )
}

void function OnWeaponChargeEnd_weapon_doubletake( entity weapon )
{
	EnergyChargeWeapon_OnWeaponChargeEnd( weapon, file.chargeWeaponData )
}

void function OnProjectileCollision_weapon_doubletake( entity projectile, vector pos, vector normal, entity hitEnt, int hitbox, bool isCritical, bool isPassthrough )
{
	#if SERVER
                           
                                                               
                                

		                                                                                                      
		                                                           
			      

		                                       
	#endif
}