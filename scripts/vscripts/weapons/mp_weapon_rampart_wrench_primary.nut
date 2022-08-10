global function MpWeaponRampartWrenchPrimary_Init

global function OnWeaponActivate_weapon_rampart_wrench_primary
global function OnWeaponDeactivate_weapon_rampart_wrench_primary
                                                             
global function OnWeaponCustomActivityStart_weapon_rampart_wrench_primary
global function OnWeaponCustomActivityEnd_weapon_rampart_wrench_primary

const asset WRENCH_FX_TASER_FP = $"P_wrench_electric_beam"
const asset WRENCH_FX_MDL_FP = $"P_wrench_mdl_energy"
const asset WRENCH_FX_MDL_3P = $"P_wrench_mdl_energy_3P"
                                                             
const asset WRENCH_FX_TASER_3P = $"P_wrench_electric_beam_3P"


                                                                                        

void function MpWeaponRampartWrenchPrimary_Init()
{
	                                                     
	PrecacheParticleSystem( WRENCH_FX_TASER_FP )
	PrecacheParticleSystem( WRENCH_FX_TASER_3P )
	PrecacheParticleSystem( WRENCH_FX_MDL_FP )
	PrecacheParticleSystem( WRENCH_FX_MDL_3P )
	                                                
	                               

}


void function OnWeaponActivate_weapon_rampart_wrench_primary( entity weapon )
{
	                                                  
	weapon.PlayWeaponEffect( WRENCH_FX_TASER_FP, WRENCH_FX_TASER_3P, "energy_arc_bottom", true )
	weapon.PlayWeaponEffect( WRENCH_FX_MDL_FP, WRENCH_FX_MDL_3P, "BASE", true )
	                                                                                        
	                                                                                                                                                                     
	                                                     
}

void function OnWeaponDeactivate_weapon_rampart_wrench_primary( entity weapon )
{
	                                                          
	weapon.StopWeaponEffect( WRENCH_FX_TASER_FP, WRENCH_FX_TASER_3P )
	weapon.StopWeaponEffect( WRENCH_FX_MDL_FP, WRENCH_FX_MDL_3P )
}

void function OnWeaponCustomActivityStart_weapon_rampart_wrench_primary( entity weapon )
{
	if ( weapon.GetWeaponActivity() == ACT_VM_WEAPON_INSPECT )
		{
			                             
			weapon.StopWeaponEffect( WRENCH_FX_TASER_FP, WRENCH_FX_TASER_3P )
			weapon.StopWeaponEffect( WRENCH_FX_MDL_FP, WRENCH_FX_MDL_3P )
		}

}

void function OnWeaponCustomActivityEnd_weapon_rampart_wrench_primary( entity weapon , int activity )
{
	if ( activity == ACT_VM_WEAPON_INSPECT )
		{
			                           
			weapon.PlayWeaponEffect( WRENCH_FX_TASER_FP, WRENCH_FX_TASER_3P, "energy_arc_bottom", true )
			weapon.PlayWeaponEffect( WRENCH_FX_MDL_FP, WRENCH_FX_MDL_3P, "BASE", true )
		}

}


                                                                            
   
	                                         
  	                                                               
   

  
                                                                   
 
	                    

	                                     

	                                
	                                                                                  
	                                 
		      

	                                                

	                        
		                                          
 
  