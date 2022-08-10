global function MeleeWattsonGadget_Init

global function OnWeaponActivate_melee_wattson_gadget
global function OnWeaponDeactivate_melee_wattson_gadget
global function StopAttackEffects_melee_wattson_gadget

const WATT_GADGET_FX_ATTACK_Rod_FP = $"P_watt_heir_rod_attk"
const WATT_GADGET_FX_ATTACK_Center_FP = $"P_watt_heir_frnt_attk"
const WATT_GADGET_FX_ATTACK_Rod_3P = $"P_watt_heir_rod_attk_3P"
const WATT_GADGET_FX_ATTACK_Center_3P = $"P_watt_heir_frnt_attk_3P"
const WATT_GADGET_FX_ATTACK_Dlight_FP = $"P_watt_heir_attk_dlight"
const WATT_GADGET_FX_ATTACK_Dlight_3P = $"P_watt_heir_attk_dlight_3P"


void function MeleeWattsonGadget_Init()
{
	PrecacheParticleSystem( WATT_GADGET_FX_ATTACK_Rod_FP )
	PrecacheParticleSystem( WATT_GADGET_FX_ATTACK_Center_FP )
	PrecacheParticleSystem( WATT_GADGET_FX_ATTACK_Rod_3P )
	PrecacheParticleSystem( WATT_GADGET_FX_ATTACK_Center_3P )
	PrecacheParticleSystem( WATT_GADGET_FX_ATTACK_Dlight_FP )
	PrecacheParticleSystem( WATT_GADGET_FX_ATTACK_Dlight_3P )
}

void function PlayAttackEffects( entity weapon )
{
	weapon.PlayWeaponEffect( WATT_GADGET_FX_ATTACK_Rod_FP, WATT_GADGET_FX_ATTACK_Rod_3P, "fx_l_arm_bot" )
	weapon.PlayWeaponEffect( WATT_GADGET_FX_ATTACK_Rod_FP, WATT_GADGET_FX_ATTACK_Rod_3P, "fx_r_arm_bot" )
	weapon.PlayWeaponEffect( WATT_GADGET_FX_ATTACK_Rod_FP, WATT_GADGET_FX_ATTACK_Rod_3P, "fx_l_arm_top" )
	weapon.PlayWeaponEffect( WATT_GADGET_FX_ATTACK_Rod_FP, WATT_GADGET_FX_ATTACK_Rod_3P, "fx_r_arm_top" )
	weapon.PlayWeaponEffect( WATT_GADGET_FX_ATTACK_Center_FP, WATT_GADGET_FX_ATTACK_Center_3P, "fx_center_rod_tip" )
	weapon.PlayWeaponEffect( WATT_GADGET_FX_ATTACK_Dlight_FP, WATT_GADGET_FX_ATTACK_Dlight_3P, "fx_top" )
}

void function StopAttackEffects_melee_wattson_gadget( entity weapon )
{
	weapon.StopWeaponEffect( WATT_GADGET_FX_ATTACK_Rod_FP, WATT_GADGET_FX_ATTACK_Rod_3P )
	weapon.StopWeaponEffect( WATT_GADGET_FX_ATTACK_Rod_FP, WATT_GADGET_FX_ATTACK_Rod_3P )
	weapon.StopWeaponEffect( WATT_GADGET_FX_ATTACK_Rod_FP, WATT_GADGET_FX_ATTACK_Rod_3P )
	weapon.StopWeaponEffect( WATT_GADGET_FX_ATTACK_Rod_FP, WATT_GADGET_FX_ATTACK_Rod_3P )
	weapon.StopWeaponEffect( WATT_GADGET_FX_ATTACK_Center_FP, WATT_GADGET_FX_ATTACK_Center_3P )
	weapon.StopWeaponEffect( WATT_GADGET_FX_ATTACK_Dlight_FP, WATT_GADGET_FX_ATTACK_Dlight_3P )
}

                                                                              
                                                          
void function OnWeaponActivate_melee_wattson_gadget( entity weapon )
{
	PlayAttackEffects( weapon )
}

void function OnWeaponDeactivate_melee_wattson_gadget( entity weapon )
{
	StopAttackEffects_melee_wattson_gadget( weapon )
}