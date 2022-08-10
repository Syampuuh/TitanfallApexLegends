global function MpWeaponLmg_Init

global function OnWeaponActivate_weapon_lmg


void function MpWeaponLmg_Init()
{
	BasicBoltPrecache()
}


void function OnWeaponActivate_weapon_lmg( entity weapon )
{
	#if CLIENT
		UpdateViewmodelAmmo( false, weapon )
	#endif              
}