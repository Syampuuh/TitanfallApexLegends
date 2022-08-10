global function MpWeaponGrenadeGas_Init
global function OnProjectileCollision_weapon_grenade_gas
global function OnWeaponReadyToFire_weapon_grenade_gas
global function OnWeaponTossReleaseAnimEvent_weapon_greande_gas
global function OnWeaponDeactivate_weapon_grenade_gas

const float WEAPON_GAS_GRENADE_DELAY = 1.0
const float WEAPON_GAS_GRENADE_DURATION = 15.0

const string GAS_GRENADE_WARNING_SOUND 	= "weapon_vortex_gun_explosivewarningbeep"

const string GAS_GRENADE_MOVER_SCRIPTNAME = "caustic_gas_nade_mover"

const asset GAS_GRENADE_FX_GLOW_FP = $"P_wpn_grenade_gas_glow_FP"
const asset GAS_GRENADE_FX_GLOW_3P = $"P_wpn_grenade_gas_glow_3P"

void function MpWeaponGrenadeGas_Init()
{
	PrecacheParticleSystem( GAS_GRENADE_FX_GLOW_FP )
	PrecacheParticleSystem( GAS_GRENADE_FX_GLOW_3P )
}


void function OnWeaponReadyToFire_weapon_grenade_gas( entity weapon )
{
	weapon.PlayWeaponEffect( GAS_GRENADE_FX_GLOW_FP, GAS_GRENADE_FX_GLOW_3P, "FX_TRAIL" )
}

void function OnWeaponDeactivate_weapon_grenade_gas( entity weapon )
{
	weapon.StopWeaponEffect( GAS_GRENADE_FX_GLOW_FP, GAS_GRENADE_FX_GLOW_3P )
	Grenade_OnWeaponDeactivate( weapon )
}

var function OnWeaponTossReleaseAnimEvent_weapon_greande_gas( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	weapon.StopWeaponEffect( GAS_GRENADE_FX_GLOW_FP, GAS_GRENADE_FX_GLOW_3P )

	var result = Grenade_OnWeaponToss( weapon, attackParams, 1.0 )
	return result
}


void function OnProjectileCollision_weapon_grenade_gas( entity projectile, vector pos, vector normal, entity hitEnt, int hitBox, bool isCritical, bool isPassthrough )
{
	entity player = projectile.GetOwner()
	if ( hitEnt == player )
		return

	if ( projectile.GrenadeHasIgnited() )
		return

	DeployableCollisionParams cp
	cp.pos = pos
	cp.normal = normal
	cp.hitEnt = hitEnt
	cp.hitBox = hitBox
	cp.isCritical = isCritical
                     
	cp.deployableFlags = eDeployableFlags.VEHICLES_NO_STICK
                           

	bool result = PlantStickyEntityOnWorldThatBouncesOffWalls( projectile, cp, 0.7, <0, 0, 0>, true )

	#if SERVER
	                                       
	                                                              
		      

	                     
	                              
	#endif

	projectile.GrenadeIgnite()
}

#if SERVER

                                            
 
	                                                 
	                                   

	            
		                           
		 
			                            
				                    
		 
	 

	                                   

	                                                          

	        

	                                          
		      
	                                                            
		      

	                                       
 

                                                     
 
	                                      
	                                      
	                        
		      
	                                        

	                              
	                                    

	                                    

	        

	                                                                        
	                       
	         
	 
		                           
		                                      
	 

	                          
	 
		                           
	 

	                                                     
	                               
	                                             
	                                          

	                                                                                                                                

	            
		                                      
		 
			                       
				               

			                                
				                        
		 
	 

	                                                                                                                                   
	                                                         

	                                                               
 

#endif