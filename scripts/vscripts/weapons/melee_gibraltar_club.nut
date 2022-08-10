global function MeleeGibraltarClub_Init

global function OnWeaponActivate_melee_gibraltar_club
global function OnWeaponDeactivate_melee_gibraltar_club

const GIB_CLUB_FX_ATTACK_SWIPE_FP = $"P_club_swipe_FP"
const GIB_CLUB_FX_ATTACK_SWIPE_3P = $"P_club_swipe_3P"


void function MeleeGibraltarClub_Init()
{
	PrecacheParticleSystem( GIB_CLUB_FX_ATTACK_SWIPE_FP )
	PrecacheParticleSystem( GIB_CLUB_FX_ATTACK_SWIPE_3P )
}

                                                                              
                                                          
void function OnWeaponActivate_melee_gibraltar_club( entity weapon )
{
	weapon.PlayWeaponEffect( GIB_CLUB_FX_ATTACK_SWIPE_FP, GIB_CLUB_FX_ATTACK_SWIPE_3P, "fx_gapA" )
}

void function OnWeaponDeactivate_melee_gibraltar_club( entity weapon )
{
	weapon.StopWeaponEffect( GIB_CLUB_FX_ATTACK_SWIPE_FP, GIB_CLUB_FX_ATTACK_SWIPE_3P )
}