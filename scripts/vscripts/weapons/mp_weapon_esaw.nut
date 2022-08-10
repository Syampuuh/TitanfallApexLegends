global function OnWeaponActivate_weapon_esaw
global function OnWeaponDeactivate_weapon_esaw


void function OnWeaponActivate_weapon_esaw( entity weapon )
{
	OnWeaponActivate_ReactiveKillEffects( weapon )
}

void function OnWeaponDeactivate_weapon_esaw( entity weapon )
{
	OnWeaponDeactivate_ReactiveKillEffects( weapon )
}