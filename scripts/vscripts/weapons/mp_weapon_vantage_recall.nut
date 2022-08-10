global function MpWeaponVantageRecall_Init

global function OnWeaponActivate_ability_vantage_recall
global function OnWeaponDeactivate_ability_vantage_recall
global function OnWeaponPrimaryAttack_ability_vantage_recall
global function OnWeaponAttemptOffhandSwitch_ability_vantage_recall


global const string  VANTAGE_RECALL_WEAPON_NAME = "mp_weapon_vantage_recall"

void function MpWeaponVantageRecall_Init()
{
	PrecacheWeapon( VANTAGE_RECALL_WEAPON_NAME )

	AddCallback_OnPassiveChanged( ePassives.PAS_VANTAGE, OnPassiveChangedVantageRecall )
}

void function OnPassiveChangedVantageRecall( entity player, int passive, bool didHave, bool nowHas )
{
	#if CLIENT
		if ( !IsValid( GetLocalClientPlayer() ) || player != GetLocalClientPlayer() )
			return
	#endif

	if ( didHave && !nowHas )
	{
		#if SERVER
			                                                            

			                                                                                     
			 
				                                             
			 
		#endif
	}
	else if ( nowHas && !didHave )
	{
		#if SERVER
			                                                                             

			                                                              

		#endif
	}
}

bool function OnWeaponAttemptOffhandSwitch_ability_vantage_recall( entity weapon )
{
	#if SERVER
	#endif
	return true
}

var function OnWeaponPrimaryAttack_ability_vantage_recall( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	bool serverOrPredicted = IsServer() || (InPrediction() && IsFirstTimePredicted())
	if ( serverOrPredicted )
	{

	}
	return 0
}

void function OnWeaponActivate_ability_vantage_recall( entity weapon )
{
}

void function OnWeaponDeactivate_ability_vantage_recall( entity weapon )
{
	#if SERVER
	#endif
}
