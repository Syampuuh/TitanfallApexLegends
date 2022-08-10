global function MpWeaponCryptoHeirloomPrimary_Init
global function OnWeaponActivate_weapon_crypto_heirloom_primary
global function OnWeaponDeactivate_weapon_crypto_heirloom_primary

             
const asset CRYPTO_AMB_EXHAUST_FP = $"P_crypto_sword_exhaust"
const asset CRYPTO_AMB_EXHAUST_3P = $"P_crypto_sword_base_3P"                                


void function MpWeaponCryptoHeirloomPrimary_Init()
{
	PrecacheParticleSystem( CRYPTO_AMB_EXHAUST_FP )
	PrecacheParticleSystem( CRYPTO_AMB_EXHAUST_3P )
}

void function OnWeaponActivate_weapon_crypto_heirloom_primary( entity weapon )
{
	                
	weapon.PlayWeaponEffect( CRYPTO_AMB_EXHAUST_FP, CRYPTO_AMB_EXHAUST_3P, "Fx_def_blade_01" , true )
	weapon.PlayWeaponEffect( CRYPTO_AMB_EXHAUST_FP, CRYPTO_AMB_EXHAUST_3P, "Fx_def_blade_02" , true )
	weapon.PlayWeaponEffect( CRYPTO_AMB_EXHAUST_FP, CRYPTO_AMB_EXHAUST_3P, "Fx_def_blade_03" , true )
	float tmp = 1.00
}

void function OnWeaponDeactivate_weapon_crypto_heirloom_primary( entity weapon )
{
	weapon.StopWeaponEffect( CRYPTO_AMB_EXHAUST_FP, CRYPTO_AMB_EXHAUST_3P )
	float tmp = 1.00
}