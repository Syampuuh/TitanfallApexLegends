global function OnWeaponActivate_weapon_wingman
global function OnWeaponDeactivate_weapon_wingman
global function OnWeaponReload_weapon_wingman

const string WINGMAN_CLASS_NAME = "mp_weapon_wingman"

void function OnWeaponActivate_weapon_wingman( entity weapon )
{
		if ( weapon.HasMod( "hopup_smart_reload" ) )
		{
			SmartReloadSettings settings
			settings.OverloadedAmmo				 = GetWeaponInfoFileKeyField_GlobalInt( WINGMAN_CLASS_NAME, OVERLOAD_AMMO_SETTING )
			settings.LowAmmoFrac				 = GetWeaponInfoFileKeyField_GlobalFloat( WINGMAN_CLASS_NAME, LOW_AMMO_FAC_SETTING )

			OnWeaponActivate_Smart_Reload ( weapon, settings )
		}
		else
		{
			#if SERVER
				                                     
				                                     
			#endif
		}

	OnWeaponActivate_ReactiveKillEffects( weapon )
}

void function OnWeaponDeactivate_weapon_wingman( entity weapon )
{
	OnWeaponDeactivate_ReactiveKillEffects( weapon )
	OnWeaponDeactivate_Smart_Reload ( weapon )
}

void function OnWeaponReload_weapon_wingman ( entity weapon, int milestoneIndex )
{
	OnWeaponReload_Smart_Reload ( weapon, milestoneIndex )
}