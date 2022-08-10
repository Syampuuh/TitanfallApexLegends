global function MpWeaponWattsonGadgetPrimary_Init

global function OnWeaponActivate_weapon_wattson_gadget_primary
global function OnWeaponDeactivate_weapon_wattson_gadget_primary

const asset watt_rod_amb = $"P_watt_heir_rod_amb"
const asset watt_rod_amb_3P = $"P_watt_heir_rod_amb_3P"
const asset watt_rod_front_amb = $"P_watt_heir_frnt_amb"
const asset watt_rod_front_amb_3P = $"P_watt_heir_frnt_amb_3P"
const asset watt_screen_dlight = $"P_watt_heir_dlight"
const asset watt_screen_dlight_3P = $"P_watt_heir_dlight_3P"

void function MpWeaponWattsonGadgetPrimary_Init()
{
	PrecacheParticleSystem( watt_rod_amb )
	PrecacheParticleSystem( watt_rod_front_amb )
	PrecacheParticleSystem( watt_rod_front_amb_3P )
	PrecacheParticleSystem( watt_rod_amb_3P )
	PrecacheParticleSystem( watt_screen_dlight )
	PrecacheParticleSystem( watt_screen_dlight_3P )

	#if CLIENT
		AddOnSpectatorTargetChangedCallback( OnSpectatorTargetChanged_Callback )
	#endif
}

#if CLIENT
void function OnSpectatorTargetChanged_Callback( entity player, entity prevTarget, entity newTarget )
{
	if( !IsValid( newTarget ) )
		return

	entity weapon = newTarget.GetActiveWeapon( eActiveInventorySlot.mainHand  )
	if( IsValid( weapon ) && weapon.GetWeaponClassName() == "mp_weapon_wattson_gadget_primary")
		PlayEffects( weapon )
}
#endif

void function PlayEffects( entity weapon )
{
	weapon.PlayWeaponEffect( watt_rod_amb, watt_rod_amb_3P, "fx_l_arm_bot", true )
	weapon.PlayWeaponEffect( watt_rod_amb, watt_rod_amb_3P, "fx_r_arm_bot", true )
	weapon.PlayWeaponEffect( watt_rod_amb, watt_rod_amb_3P, "fx_l_arm_top", true )
	weapon.PlayWeaponEffect( watt_rod_amb, watt_rod_amb_3P, "fx_r_arm_top", true )
	weapon.PlayWeaponEffect( watt_rod_front_amb, watt_rod_front_amb_3P, "fx_center_rod_tip", true )
	weapon.PlayWeaponEffect( watt_screen_dlight, watt_screen_dlight_3P, "fx_top", true )
}

void function StopEffects( entity weapon )
{
	weapon.StopWeaponEffect( watt_rod_amb, watt_rod_amb_3P )
	weapon.StopWeaponEffect( watt_rod_front_amb, watt_rod_front_amb_3P )
	weapon.StopWeaponEffect( watt_screen_dlight, watt_screen_dlight_3P )
}

void function OnWeaponActivate_weapon_wattson_gadget_primary( entity weapon )
{
	                         
	StopAttackEffects_melee_wattson_gadget( weapon )
	StopEffects( weapon )

	PlayEffects( weapon )
}

void function OnWeaponDeactivate_weapon_wattson_gadget_primary( entity weapon )
{
	StopEffects( weapon )
}