global function OnWeaponPrimaryAttack_hunt_mode
global function MpAbilityHuntModeWeapon_Init
global function MpAbilityHuntModeWeapon_OnWeaponTossPrep
global function OnWeaponDeactivate_hunt_mode

#if(false)

#endif //

//
const asset HUNT_MODE_ACTIVATION_SCREEN_FX = $"P_hunt_screen"
const asset HUNT_MODE_BODY_FX = $"P_hunt_body"

struct
{
	#if(CLIENT)
	int colorCorrection
	#endif //
} file

void function MpAbilityHuntModeWeapon_Init()
{
	#if(false)


#endif //

	RegisterSignal( "HuntMode_ForceAbilityStop" )
	AddCallback_GameStateEnter( eGameState.WinnerDetermined, StopHuntMode )

	#if(CLIENT)
		RegisterSignal( "HuntMode_StopColorCorrection" )
		//
		file.colorCorrection = ColorCorrection_Register( "materials/correction/ability_hunt_mode.raw_hdr" )
		PrecacheParticleSystem( HUNT_MODE_ACTIVATION_SCREEN_FX )
		StatusEffect_RegisterEnabledCallback( eStatusEffect.hunt_mode, HuntMode_StartEffect )
		StatusEffect_RegisterDisabledCallback( eStatusEffect.hunt_mode, HuntMode_StopEffect )
		StatusEffect_RegisterEnabledCallback( eStatusEffect.hunt_mode_visuals, HuntMode_StartVisualEffect )
		StatusEffect_RegisterDisabledCallback( eStatusEffect.hunt_mode_visuals, HuntMode_StopVisualEffect )
	#endif
}

void function MpAbilityHuntModeWeapon_OnWeaponTossPrep( entity weapon, WeaponTossPrepParams prepParams )
{
	entity weaponOwner = weapon.GetWeaponOwner()
	weapon.SetScriptTime0( 0.0 )

	#if(false)







//


#endif
}

var function OnWeaponPrimaryAttack_hunt_mode( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	entity weaponOwner = weapon.GetWeaponOwner()
	Assert ( weaponOwner.IsPlayer() )

	//
	#if(false)

#endif //

	#if(CLIENT)
		thread HuntMode_PlayActivationScreenFX( weaponOwner )
	#endif //

	PlayerUsedOffhand( weaponOwner, weapon )

	return weapon.GetWeaponSettingInt( eWeaponVar.ammo_min_to_fire )
}

void function OnWeaponDeactivate_hunt_mode( entity weapon )
{
	entity weaponOwner = weapon.GetWeaponOwner()

	#if(false)




#endif //
}

#if(false)
















//










































//



























#endif //

#if(CLIENT)
void function HuntMode_UpdatePlayerScreenColorCorrection( entity player )
{
	Assert ( IsNewThread(), "Must be threaded off." )
	Assert ( player == GetLocalViewPlayer() )

	player.EndSignal( "OnDeath" )
	player.EndSignal( "OnDestroy" )
	player.EndSignal( "HuntMode_ForceAbilityStop" )
	player.EndSignal( "HuntMode_StopColorCorrection" )
	player.EndSignal( "BleedOut_OnStartDying" )

	OnThreadEnd(
	function() : ( player )
		{
			if ( IsValid( player ) )
				player.SetFOVScale( 1.0, 1 )

			ColorCorrection_SetWeight( file.colorCorrection, 0.0 )
			ColorCorrection_SetExclusive( file.colorCorrection, false )
		}
	)

	ColorCorrection_SetExclusive( file.colorCorrection, true )
	ColorCorrection_SetWeight( file.colorCorrection, 1.0 )

	const FOV_SCALE = 1.2
	const LERP_IN_TIME = 0.0125	//
	float startTime = Time()

	while ( true )
	{
		float weight = StatusEffect_GetSeverity( player, eStatusEffect.hunt_mode_visuals )
		//
		weight = GraphCapped( Time() - startTime, 0, LERP_IN_TIME, 0, weight )

		ColorCorrection_SetWeight( file.colorCorrection, weight )

		float fovScale = GraphCapped( weight, 0, 1, 1, FOV_SCALE )
		player.SetFOVScale( fovScale, 1 )	//

		WaitFrame()
	}
}

void function HuntMode_StartEffect( entity ent, int statusEffect, bool actuallyChanged )
{
	if ( !actuallyChanged && GetLocalViewPlayer() == GetLocalClientPlayer() )
		return

	if ( ent != GetLocalViewPlayer() )
		return
}

void function HuntMode_StopEffect( entity ent, int statusEffect, bool actuallyChanged )
{
	if ( !actuallyChanged && GetLocalViewPlayer() == GetLocalClientPlayer() )
		return

	if ( ent != GetLocalViewPlayer() )
		return
}

void function HuntMode_StartVisualEffect( entity ent, int statusEffect, bool actuallyChanged )
{
	if ( !actuallyChanged && GetLocalViewPlayer() == GetLocalClientPlayer() )
		return

	if ( ent != GetLocalViewPlayer() )
		return

	GfxDesaturate( true )
	Chroma_StartHuntMode()
	thread HuntMode_UpdatePlayerScreenColorCorrection( ent )
}

void function HuntMode_StopVisualEffect( entity ent, int statusEffect, bool actuallyChanged )
{
	if ( !actuallyChanged && GetLocalViewPlayer() == GetLocalClientPlayer() )
		return

	if ( ent != GetLocalViewPlayer() )
		return

	GfxDesaturate( false )
	Chroma_EndHuntMode()
	ent.Signal( "HuntMode_StopColorCorrection" )
}

void function HuntMode_PlayActivationScreenFX( entity clientPlayer )
{
	Assert ( IsNewThread(), "Must be threaded off." )
	clientPlayer.EndSignal( "OnDeath" )
	clientPlayer.EndSignal( "OnDestroy" )
	clientPlayer.EndSignal( "HuntMode_ForceAbilityStop" )
	clientPlayer.EndSignal( "BleedOut_OnStartDying" )

	entity viewPlayer = GetLocalViewPlayer()
	int fxid        = GetParticleSystemIndex( HUNT_MODE_ACTIVATION_SCREEN_FX )

	int fxHandle = StartParticleEffectOnEntity( viewPlayer, fxid, FX_PATTACH_ABSORIGIN_FOLLOW, -1 )
	EffectSetIsWithCockpit( fxHandle, true )
	Effects_SetParticleFlag( fxHandle, PARTICLE_SCRIPT_FLAG_NO_DESATURATE, true )


	OnThreadEnd(
		function() : ( clientPlayer, fxHandle )
		{
			if ( IsValid( clientPlayer ) && IsAlive( clientPlayer ) )
			{
				if ( EffectDoesExist( fxHandle ) )
					EffectStop( fxHandle, false, true )
			}
		}
	)

	wait HUNT_MODE_DURATION
}

#endif //

void function StopHuntMode()
{
	#if(CLIENT)
		entity player = GetLocalViewPlayer()
		player.Signal( "HuntMode_ForceAbilityStop" )
	#else
		array<entity> playerArray = GetPlayerArray()
		foreach ( player in playerArray )
			player.Signal( "HuntMode_ForceAbilityStop" )
	#endif
}
