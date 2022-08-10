
global function MpSpaceElevatorAbility_Init
global function OnWeaponReadyToFire_weapon_space_elevator_tac
global function OnWeaponDeactivate_weapon_space_elevator_tac
global function OnWeaponTossRelease_weapon_space_elevator_tac


const asset ELEVATOR_GRENADE_FX_GLOW_FP = $"P_repulsor_ptpov"
const asset ELEVATOR_GRENADE_FX_GLOW_3P = $"P_repulsor_pt3p"

const int CHANCE_TO_BATTLE_CHATTER_ELEVATOR = 50

void function MpSpaceElevatorAbility_Init()
{
	PrecacheParticleSystem( ELEVATOR_GRENADE_FX_GLOW_FP )
	PrecacheParticleSystem( ELEVATOR_GRENADE_FX_GLOW_3P )
}


void function OnWeaponReadyToFire_weapon_space_elevator_tac( entity weapon )
{
	weapon.PlayWeaponEffect( ELEVATOR_GRENADE_FX_GLOW_FP, ELEVATOR_GRENADE_FX_GLOW_3P, "muzzle_flash" )
}

void function OnWeaponDeactivate_weapon_space_elevator_tac( entity weapon )
{
	weapon.StopWeaponEffect( ELEVATOR_GRENADE_FX_GLOW_FP, ELEVATOR_GRENADE_FX_GLOW_3P )
	Grenade_OnWeaponDeactivate( weapon )
}

var function OnWeaponTossRelease_weapon_space_elevator_tac( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	entity ownerPlayer = weapon.GetWeaponOwner()
	Assert( ownerPlayer.IsPlayer() )

	weapon.StopWeaponEffect( ELEVATOR_GRENADE_FX_GLOW_FP, ELEVATOR_GRENADE_FX_GLOW_3P )
	weapon.EmitWeaponSound_1p3p( GetGrenadeThrowSound_1p( weapon ), GetGrenadeThrowSound_3p( weapon ) )

	                                                                   
	                    
	entity deployable = ThrowDeployable( weapon, attackParams, 1.0, SpaceElevatorTac_ProjectileLanded, null, ZERO_VECTOR )
	if ( deployable )
	{
		entity player = weapon.GetWeaponOwner()
		PlayerUsedOffhand( player, weapon, true, deployable )

		#if SERVER
			                                                      

			                                                            
			                            
				                                                

			                                         

		#endif
		#if SERVER
			                                                                    
			 
				                                                
			 
		#endif
	}
	                                                                   


	int ammoReq = weapon.GetAmmoPerShot()
	return ammoReq
}

void function SpaceElevatorTac_ProjectileLanded( entity projectile, DeployableCollisionParams collisionParams )
{
	#if SERVER
		                               

		                   
		                                        
		                                                                                                                                        
		 
			                                 
		 

		                                        

		                    

		                  
		                                                                                        
	#endif
}
