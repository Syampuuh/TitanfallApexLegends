global function OnWeaponActivate_weapon_r97
global function OnWeaponDeactivate_weapon_r97


void function OnWeaponActivate_weapon_r97( entity weapon )
{
	OnWeaponActivate_ReactiveKillEffects( weapon )
}

void function OnWeaponDeactivate_weapon_r97( entity weapon )
{
	OnWeaponDeactivate_ReactiveKillEffects( weapon )
}