global function OnWeaponActivate_weapon_pdw
global function OnWeaponDeactivate_weapon_pdw
global function MpWeaponPDW_Init

void function OnWeaponActivate_weapon_pdw( entity weapon )
{
	OnWeaponActivate_ReactiveKillEffects( weapon )
}

void function OnWeaponDeactivate_weapon_pdw( entity weapon )
{
	OnWeaponDeactivate_ReactiveKillEffects( weapon )
}

void function MpWeaponPDW_Init()
{
}


