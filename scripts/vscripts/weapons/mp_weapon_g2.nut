global function OnWeaponActivate_G7
global function OnWeaponDeactivate_G7


void function OnWeaponActivate_G7( entity weapon )
{
	OnWeaponActivate_ReactiveKillEffects( weapon )
}

void function OnWeaponDeactivate_G7( entity weapon )
{
	OnWeaponDeactivate_ReactiveKillEffects( weapon )
}