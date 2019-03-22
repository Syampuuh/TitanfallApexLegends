
global function MpAbilityGibraltarShield_Init

global function OnWeaponActivate_ability_gibraltar_shield
global function OnWeaponDeactivate_ability_gibraltar_shield
global function OnWeaponAttemptOffhandSwitch_ability_gibraltar_shield
global function OnWeaponPrimaryAttack_ability_gibraltar_shield
global function OnWeaponChargeBegin_ability_gibraltar_shield
global function OnWeaponChargeEnd_ability_gibraltar_shield
global function OnWeaponOwnerChanged_ability_gibraltar_shield

global function GibraltarShield_RegisterNetworkFunctions

const vector SHIELD_ANGLE_OFFSET = <0,-90,0>
const asset FX_GUN_SHIELD_WALL = $"P_gun_shield_gibraltar_3P"
const asset FX_GUN_SHIELD_BREAK = $"P_gun_shield_gibraltar_break_CP_3P"
const asset FX_GUN_SHIELD_BREAK_FP = $"P_gun_shield_gibraltar_break_CP_FP"
const asset FX_GUN_SHIELD_SHIELD_COL = $"mdl/fx/gibralter_gun_shield.rmdl"

const string SOUND_PILOT_GUN_SHIELD_3P = "Gibraltar_GunShield_Sustain_3P"
const string SOUND_PILOT_GUN_SHIELD_1P = "Gibraltar_GunShield_Sustain_1P"
const string SOUND_PILOT_GUN_SHIELD_BREAK_1P = "Gibraltar_GunShield_Destroyed_1P"
const string SOUND_PILOT_GUN_SHIELD_BREAK_3P = "Gibraltar_GunShield_Destroyed_3P"

const bool PILOT_GUN_SHIELD_DRAIN_AMMO = false
const float PILOT_GUN_SHIELD_DRAIN_AMMO_RATE = 1.0

const PLAYER_GUN_SHIELD_WALL_RADIUS = 18
const PLAYER_GUN_SHIELD_WALL_HEIGHT = 32
const PLAYER_GUN_SHIELD_WALL_FOV = 85

const int PILOT_SHIELD_OFFHAND_INDEX = OFFHAND_EQUIPMENT

struct
{
	var shieldRegenRui
} file

void function MpAbilityGibraltarShield_Init()
{
	PrecacheWeapon( "mp_ability_gibraltar_shield" )

	PrecacheModel( FX_GUN_SHIELD_SHIELD_COL )

	PrecacheParticleSystem( FX_GUN_SHIELD_WALL )
	PrecacheParticleSystem( FX_GUN_SHIELD_BREAK_FP )
	PrecacheParticleSystem( FX_GUN_SHIELD_BREAK )

	RegisterSignal( "ShieldWeaponThink" )
	RegisterSignal( "DestroyPlayerShield" )

	#if(CLIENT)
	RegisterConCommandTriggeredCallback( "+scriptCommand5", GunShieldTogglePressed )
	#endif

	#if(false)


#endif
}

bool function OnWeaponChargeBegin_ability_gibraltar_shield( entity weapon )
{
	entity player = weapon.GetWeaponOwner()
	if ( player.IsPlayer() )
	{
		#if(false)

#elseif(CLIENT)
		if ( file.shieldRegenRui == null )
		{
			CreateShieldRegenRui( weapon )
		}
		if ( InPrediction() && IsFirstTimePredicted() )
		{
			if ( player.GetSharedEnergyCount() > 0 )
			{
				weapon.EmitWeaponSound_1p3p( SOUND_PILOT_GUN_SHIELD_1P, SOUND_PILOT_GUN_SHIELD_3P )
			}
		}
		//
		#endif

	}
	return true
}


void function GibraltarShield_RegisterNetworkFunctions()
{
}


void function OnWeaponOwnerChanged_ability_gibraltar_shield( entity weapon, WeaponOwnerChangedParams changeParams )
{
	#if(CLIENT)
		if ( file.shieldRegenRui == null && changeParams.newOwner == GetLocalViewPlayer() )
		{
			CreateShieldRegenRui( weapon )
		}
		else if ( changeParams.newOwner != GetLocalViewPlayer() )
		{
			if ( file.shieldRegenRui != null )
			{
				RuiDestroy( file.shieldRegenRui )
				file.shieldRegenRui = null
			}
		}
	#endif
}

#if(CLIENT)
void function CreateShieldRegenRui( entity weapon )
{
	file.shieldRegenRui = CreateCockpitRui( $"ui/gibraltar_shield_regen.rpak" )
	RuiTrackBool( file.shieldRegenRui, "weaponIsDisabled", weapon, RUI_TRACK_WEAPON_IS_DISABLED )

	thread TrackPrimaryWeapon()
}

void function TrackPrimaryWeapon()
{
	entity oldPrimary
	bool oldPlayerUsePrompts

	while ( file.shieldRegenRui != null )
	{
		entity player = GetLocalViewPlayer()

		if ( IsAlive( player ) )
		{
			entity newPrimary = player.GetActiveWeapon( eActiveInventorySlot.mainHand )
			bool newPlayerUsePrompts = GetConVarBool( "disable_player_use_prompts" )

			if ( newPrimary != oldPrimary )
			{
				oldPrimary = newPrimary
				RuiSetBool( file.shieldRegenRui, "weaponAllowedToUseShield", WeaponAllowsShield( newPrimary ) )
			}

			if ( oldPlayerUsePrompts != newPlayerUsePrompts )
			{
				oldPlayerUsePrompts = newPlayerUsePrompts
				RuiSetBool( file.shieldRegenRui, "showPlayerHints", !newPlayerUsePrompts )
			}
		}

		WaitFrame()
	}
}
#endif

void function OnWeaponChargeEnd_ability_gibraltar_shield( entity weapon )
{
	weapon.Signal( "OnChargeEnd" )

	weapon.StopWeaponSound( SOUND_PILOT_GUN_SHIELD_1P )
	weapon.StopWeaponSound( SOUND_PILOT_GUN_SHIELD_3P )
}

void function OnWeaponActivate_ability_gibraltar_shield( entity weapon )
{

}

void function OnWeaponDeactivate_ability_gibraltar_shield( entity weapon )
{

}

bool function OnWeaponAttemptOffhandSwitch_ability_gibraltar_shield( entity weapon )
{
	entity player = weapon.GetWeaponOwner()

	if ( !IsValid( player ) )
		return false

	if ( !player.IsPlayer() )
		return false

	entity mainWeapon = player.GetActiveWeapon( eActiveInventorySlot.mainHand )
	if ( !WeaponAllowsShield( mainWeapon ) )
		return false

	return PlayerHasPassive( player, ePassives.PAS_ADS_SHIELD )
}

var function OnWeaponPrimaryAttack_ability_gibraltar_shield( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	return 0
}

#if(false)






//

























//





















































































//





















































































































































































#endif

#if(CLIENT)
void function GunShieldTogglePressed( entity player )
{
	if ( player != GetLocalViewPlayer() || player != GetLocalClientPlayer() )
		return

	entity activeWeapon = player.GetActiveWeapon( eActiveInventorySlot.mainHand )
	if ( !IsValid( activeWeapon ) )
		return

	if ( activeWeapon.IsWeaponAdsButtonPressed() || activeWeapon.IsWeaponInAds() )
		player.ClientCommand( "ToggleGibraltarShield" )
}
#endif

bool function WeaponAllowsShield( entity weapon )
{
	if ( !IsValid( weapon ) )
		return false

	//
	var allowShield = weapon.GetWeaponInfoFileKeyField( "allow_gibraltar_shield" )
	if ( allowShield != null && allowShield == 0 )
		return false

	return true
}