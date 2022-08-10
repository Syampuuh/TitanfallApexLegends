
global function MpWeaponGrenadeDefensiveBombardment_Init
global function OnProjectileCollision_WeaponDefensiveBombardment
global function OnProjectileCollision_WeaponDefensiveBombardmentExplosion
global function OnWeaponTossReleaseAnimEvent_WeaponDefensiveBombardment
global function OnWeaponOwnerChanged_WeaponDefensiveBombardment

const string DEFENSIVE_BOMBARDMENT_MISSILE_WEAPON = "mp_weapon_defensive_bombardment_weapon"

                           
const asset FX_BOMBARDMENT_MARKER = $"P_ar_artillery_marker"

                        
                                                                                            
                                                                                        
                                                                                                                                 
                                                           
     
const float DEFENSIVE_BOMBARDMENT_DURATION			= 6.0                                          
const float DEFENSIVE_BOMBARDMENT_RADIUS 		 	= 1024                                      
const int	DEFENSIVE_BOMBARDMENT_DENSITY			= 6	                                                  
const float DEFENSIVE_BOMBARDMENT_SHELLSHOCK_DURATION = 4.0
      

const float DEFENSIVE_BOMBARDMENT_DELAY 			= 2.0                                                                       



const asset FX_DEFENSIVE_BOMBARDMENT_SCAN = $"P_artillery_marker_scan"

void function MpWeaponGrenadeDefensiveBombardment_Init()
{
	PrecacheWeapon( DEFENSIVE_BOMBARDMENT_MISSILE_WEAPON )

	PrecacheParticleSystem( FX_DEFENSIVE_BOMBARDMENT_SCAN )
	PrecacheParticleSystem( FX_BOMBARDMENT_MARKER )

	#if SERVER
		                                                                                                                
                          
                                                                                                                        
        
	#endif         
}

void function OnWeaponOwnerChanged_WeaponDefensiveBombardment( entity weapon, WeaponOwnerChangedParams changeParams )
{
	#if SERVER
	                                       
	 
		                                       
		 
			                                                        
		 
	 

	                                       
	 
		                                       
		 
			                                                                                                  
		 
	 
	#endif
}

var function OnWeaponTossReleaseAnimEvent_WeaponDefensiveBombardment( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	entity owner = weapon.GetWeaponOwner()

	if ( !IsValid( owner ) )
		return

	#if SERVER
	                                                                  
	                                    
		                                                                                  

		                                                          
	#endif

	Grenade_OnWeaponTossReleaseAnimEvent( weapon, attackParams )
	return weapon.GetWeaponSettingInt( eWeaponVar.ammo_per_shot )
}

void function OnProjectileCollision_WeaponDefensiveBombardment( entity projectile, vector pos, vector normal, entity hitEnt, int hitBox, bool isCritical, bool isPassthrough )
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
                           
	bool didStick = PlantStickyEntityOnWorldThatBouncesOffWalls( projectile, cp, 0.7 )

	#if SERVER
		                
		 
                        
				                                  
					                                                                 
                              

			      
		 
		                                                                             
	#endif
	projectile.GrenadeIgnite()
	projectile.SetDoesExplode( false )
}

void function OnProjectileCollision_WeaponDefensiveBombardmentExplosion( entity projectile, vector pos, vector normal, entity hitEnt, int hitbox, bool isCritical, bool isPassthrough )
{
	#if SERVER
		                                     
		                         
			      

		                                            

                          
                                                                                                               
       
			                                                                                                      
        
	#endif
}

#if SERVER
                                                        
 
	                                                    
		            

                  
		                                       
		                                                              
			            
                       

	           
 

#endif         
#if SERVER
                                                                                 
 
	                                                                                                         
	                              
		      

	                                           
	 
		                                     
		      
	 

	                                                         
	                                                               
	                                                      
	                          
	 
		                                                                                     
			                                       
	 

	                        
		                                                                                
 

                                                                      
 
	                                      

	                        
		      

	                                                                                                 
	                                    
		      

	                                      

	                                            
	                                                                                                                                     

	                                                                                                                                 

	                       
	                                                                                             
		                                              
	    
		                                               

	                                                                                                                                                       
		                             
		                              
		                               
		                             

	                                                                 

	                         
		                     
 
#endif
