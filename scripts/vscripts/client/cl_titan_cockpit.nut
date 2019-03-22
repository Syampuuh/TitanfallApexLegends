untyped

global function ClTitanCockpit_Init

global function ServerCallback_TitanEMP
global function ServerCallback_TitanCockpitBoot
global function TitanCockpit_DamageFeedback
global function TitanCockpit_AddPlayer
global function RegisterTitanBindings
//
global function DeregisterTitanBindings
global function ServerCallback_TitanEmbark
global function ServerCallback_TitanDisembark
//
//
global function TitanCockpit_IsBooting
global function ServerCallback_TitanCockpitEMP
global function TitanCockpit_EMPFadeScale
global function TitanCockpit_DoEMP
global function TitanEMP_Internal
global function ServerCallback_EjectConfirmed
global function LinkCoreHint

global function AddTitanCockpitManagedRUI
global function UpdateTitanCockpitVisibility
global function TitanCockpitDestroyRui
global function TitanCockpitDoomedThink
global function PlayerEjects
//
global function FlashCockpitLight
global function PlayCockpitSparkFX

global function FlashCockpitHealth

global function UpdateEjectHud_SetButtonPressTime
global function UpdateEjectHud_SetButtonPressCount

global function SetUnlimitedDash
global function NetworkedVarChangedCallback_UpdateVanguardRUICoreStatus
struct TitanCockpitManagedRUI
{
	bool exists = false
	var functionref() create
	void functionref() destroy
	bool functionref() shouldCreate
	int drawGroup = RUI_DRAW_COCKPIT
}

const TITAN_ALARM_SOUND 		= "titan_alarm"
const TITAN_NUCLEAR_DEATH_ALARM = "titan_nuclear_death_alarm"
const TITAN_EJECT_BOOST			= "titan_eject_boost"
const TITAN_EJECT_ASCENT		= "player_eject_windrush"
const TITAN_EJECT_APEX			= "player_eject_apex_wind"
const TITAN_EJECT_DESCENT		= "player_fallingdescent_windrush"

const EJECT_MIN_VELOCITY = 200.0
const EJECT_MAX_VELOCITY = 1000.0

struct
{
	var coreHintRui
	var cockpitRui
	var cockpitLowerRui
	var cockpitAdditionalRui
	array<TitanCockpitManagedRUI> titanCockpitManagedRUIs

	asset lastPilotSettings

	bool isFirstBoot = true
	var scorchHotstreakRui
} file

void function ClTitanCockpit_Init()
{
	if ( reloadingScripts )
		return

	RegisterSignal( "DisembarkCheck" )
	RegisterSignal( "Rumble_Forward_End" )
	RegisterSignal( "Rumble_Back_End" )
	RegisterSignal( "Rumble_Left_End" )
	RegisterSignal( "Rumble_Right_End" )
	RegisterSignal( "EMP" )
	RegisterSignal( "Doomed" )
	RegisterSignal( "Ejecting" )
	RegisterSignal( "TitanEMP_Internal" )
	RegisterSignal( "TitanUnDoomed" )
	RegisterSignal( "MonitorPlayerEjectAnimBeingStuck" )
	RegisterSignal( "DisplayFrontierRank" )
	RegisterSignal( "PlayerPressedEject" )

	PrecacheParticleSystem( $"xo_cockpit_spark_01" )

	if ( !IsModelViewer() && !IsLobby() )
	{
		AddCreateCallback( "titan_cockpit", TitanCockpitInit )
	}

	if ( !reloadingScripts )
	{
		level.cockpitGeoRef <- null
	}

	AddLocalPlayerFunc( TitanCockpit_AddPlayer )

	AddCinematicEventFlagChangedCallback( CE_FLAG_TITAN_3P_CAM, CinematicEventFlagChanged )
	AddCinematicEventFlagChangedCallback( CE_FLAG_INTRO, CinematicEventFlagChanged )

	AddCallback_PlayerClassChanged( UpdateLastPlayerSettings )
}

void function UpdateLastPlayerSettings( entity player )
{
	if ( IsPilot( player ) )
		file.lastPilotSettings = player.GetPlayerSettings()
}

//
//
//
//
//
//
//

bool function RegisterTitanBindings( entity player, TitanBindings bind )
{
	if ( player != GetLocalViewPlayer() )
		return false

	if ( player != GetLocalClientPlayer() )
		return false

	AddCallback_OnUseButtonPressed( player, bind.PlayerPressed_Eject )

	//

	return true
}

void function DeregisterTitanBindings( TitanBindings bind )
{
	RemoveCallback_OnUseButtonPressed( GetLocalViewPlayer(), bind.PlayerPressed_Eject )

	if ( GetMapName() != "" )
	{
		//
	}
}


void function TitanCockpit_AddPlayer( entity player )
{
	if ( IsModelViewer() )
		return

	player.s.lastCockpitDamageSoundTime <- 0
	player.s.inTitanCockpit <- false
	player.s.lastDialogTime <- 0
	player.s.titanCockpitDialogActive <- false
	player.s.titanCockpitDialogAliasList <- []

	player.s.hitVectors <- []
}

void function TitanCockpitInit( entity cockpit )
{
	entity player = GetLocalViewPlayer()
	Assert( player.GetCockpit() == cockpit )

	cockpit.s.ejectStartTime <- 0 //

	if ( !IsAlive( player ) )
		return

	if ( !IsTitanCockpitModelName( cockpit.GetModelName() ) || IsWatchingThirdPersonKillReplay() )
	{
		player.s.inTitanCockpit = false
		return
	}

	if ( !player.s.inTitanCockpit )
		TitanEmbarkDSP( 0.5 )

	player.s.inTitanCockpit = true

	//
	CodeCallback_PlayerInTitanCockpit( GetLocalViewPlayer(), GetLocalViewPlayer() )

	//
	array<entity> targets = GetClientEntArrayBySignifier( "info_target" )
	foreach ( target in targets )
	{
		if ( target.GetTargetName() != "cockpit_geo_ref" )
			continue

		level.cockpitGeoRef = target
	}

	entity cockpitParent = expect entity( level.cockpitGeoRef )

	if ( !IsValid( cockpitParent ) )
		cockpitParent = GetLocalViewPlayer()

	cockpit.s.empInfo <- {}
	cockpit.s.empInfo["xOffset"] <- 0
	cockpit.s.empInfo["yOffset"] <- 0
	cockpit.s.empInfo["startTime"] <- 0
	cockpit.s.empInfo["duration"] <- 0
	cockpit.s.empInfo["sub_count"] <- 0
	cockpit.s.empInfo["sub_start"] <- 0
	cockpit.s.empInfo["sub_duration"] <- 0
	cockpit.s.empInfo["sub_pause"] <- 0
	cockpit.s.empInfo["sub_alpha"] <- 0

	cockpit.s.cockpitType <- 1
	cockpit.s.FOV <- 70

	cockpit.e.body = CreateCockpitBody( cockpit, player, cockpitParent )

	thread TitanCockpitAnimThink( cockpit, cockpit.e.body )

	if ( player.IsTitan() && IsAlive( player ) ) //
		thread TitanCockpitDoomedThink( cockpit, player )

	SetCockpitLightingEnabled( 0, true )
	ShowRUIHUD( cockpit )
}

//
void function ShowRUIHUD( entity cockpit )
{
	//
	int cameraAttachId = cockpit.LookupAttachment( "CAMERA" )
	vector cameraOrigin = cockpit.GetAttachmentOrigin( cameraAttachId )

	int lowerScreenAttachId = cockpit.LookupAttachment( "COCKPIT_HUD_BOTTOM" )
	vector lowerScreenOrigin = cockpit.GetAttachmentOrigin( lowerScreenAttachId )
	vector lowerScreenAngles = cockpit.GetAttachmentAngles( lowerScreenAttachId )

	int instrument1AttachId = cockpit.LookupAttachment( "COCKPIT_OBJ_1" )
	vector instrument1Origin = cockpit.GetAttachmentOrigin( instrument1AttachId )
	vector instrument1Angles = cockpit.GetAttachmentAngles( instrument1AttachId )

	lowerScreenOrigin = lowerScreenOrigin - cameraOrigin
	vector lowerScreenPosition = <lowerScreenOrigin.x, lowerScreenOrigin.y + TITAN_COCKPIT_LOWER_RUI_SCREEN_SQUARE_SIZE * 0.5, lowerScreenOrigin.z + (TITAN_COCKPIT_LOWER_RUI_SCREEN_SQUARE_SIZE) * 0.5>

	instrument1Origin = instrument1Origin - cameraOrigin
	vector instrument1Position = <instrument1Origin.x, instrument1Origin.y, instrument1Origin.z>
	vector instrument1RightVector = AnglesToRight( instrument1Angles ) * -1
	vector instrument1DownVector = AnglesToUp( instrument1Angles ) * -1

	RuiTopology_UpdatePos( clGlobal.topoTitanCockpitLowerHud, lowerScreenPosition, <0, -TITAN_COCKPIT_LOWER_RUI_SCREEN_SQUARE_SIZE, 0>, <0, 0, -(TITAN_COCKPIT_LOWER_RUI_SCREEN_SQUARE_SIZE * TITAN_COCKPIT_LOWER_RUI_SCREEN_HEIGHT_SCALE)> )
	RuiTopology_UpdatePos( clGlobal.topoTitanCockpitInstrument1, instrument1Position - (instrument1RightVector *  TITAN_COCKPIT_INSTRUMENT1_RUI_SCREEN_SQUARE_SIZE * 0.5) - (instrument1DownVector * TITAN_COCKPIT_INSTRUMENT1_RUI_SCREEN_SQUARE_SIZE * 0.5), instrument1RightVector * TITAN_COCKPIT_INSTRUMENT1_RUI_SCREEN_SQUARE_SIZE, instrument1DownVector * TITAN_COCKPIT_INSTRUMENT1_RUI_SCREEN_SQUARE_SIZE )

	//
	entity player = GetLocalViewPlayer()

	file.cockpitRui = CreateTitanCockpitRui( $"ui/ajax_cockpit_base.rpak" )
	RuiTrackFloat3( file.cockpitRui, "playerOrigin", player, RUI_TRACK_ABSORIGIN_FOLLOW )
	RuiTrackFloat3( file.cockpitRui, "playerEyeAngles", player, RUI_TRACK_EYEANGLES_FOLLOW )
	RuiTrackFloat( file.cockpitRui, "healthFrac", player, RUI_TRACK_HEALTH )
	RuiTrackFloat( file.cockpitRui, "shieldFrac", player, RUI_TRACK_SHIELD_FRACTION )
	RuiTrackFloat( file.cockpitRui, "dashFrac", player, RUI_TRACK_PLAYER_SUIT_POWER )
	RuiSetFloat( file.cockpitRui, "ejectManualTimeOut", EJECT_FADE_TIME )
	//
	RuiSetGameTime( file.cockpitRui, "ejectManualStartTime", -60.0 )
	RuiSetGameTime( file.cockpitRui, "ejectButtonPressTime", -60.0 )
	string titanName = "Bob"//
	//
	//
	//
	//
	//
	//
	//

	file.cockpitAdditionalRui = CreateTitanCockpitRui( $"ui/ajax_cockpit_fd.rpak" )
	RuiSetFloat( file.cockpitAdditionalRui, "ejectManualTimeOut", EJECT_FADE_TIME )
	//
	RuiSetGameTime( file.cockpitAdditionalRui, "ejectManualStartTime", -60.0 )

	RuiSetVisible( file.cockpitAdditionalRui, false )

	bool ejectIsAllowed = !TitanEjectIsDisabled()
	RuiSetBool( file.cockpitRui, "ejectIsAllowed", ejectIsAllowed )

	asset playerSettings = GetLocalViewPlayer().GetPlayerSettings()
	float health = float( player.GetMaxHealth() ) //
	float healthPerSegment = GetGlobalSettingsFloat( playerSettings, "healthPerSegment" )
	RuiSetInt( file.cockpitRui, "numHealthSegments", int( health / healthPerSegment ) )
	RuiTrackFloat( file.cockpitRui, "cockpitColor", player, RUI_TRACK_STATUS_EFFECT_SEVERITY, eStatusEffect.cockpitColor )

	file.cockpitLowerRui = CreateTitanCockpitLowerRui( $"ui/ajax_cockpit_lower.rpak" )
	RuiTrackFloat( file.cockpitLowerRui, "dashFrac", player, RUI_TRACK_PLAYER_SUIT_POWER )
	RuiTrackFloat3( file.cockpitLowerRui, "playerEyeAngles", player, RUI_TRACK_EYEANGLES_FOLLOW )
	RuiTrackFloat( file.cockpitLowerRui, "cockpitColor", player, RUI_TRACK_STATUS_EFFECT_SEVERITY, eStatusEffect.cockpitColor )

	var instrument1Rui = CreateTitanCockpitInstrument1Rui( $"ui/ajax_cockpit_insturment1.rpak" )
	RuiTrackFloat3( instrument1Rui, "playerEyeAngles", player, RUI_TRACK_EYEANGLES_FOLLOW )

	int numDashPips = int( floor( 100 / GetLocalViewPlayer().GetPlayerSettingFloat( "dodgePowerDrain" ) ) )
	RuiSetInt( file.cockpitRui, "numDashSegments", numDashPips )
	RuiSetInt( file.cockpitLowerRui, "numDashSegments", numDashPips )

	thread CockpitDoomedThink( cockpit )
	thread TitanCockpitDestroyRuisOnDeath( cockpit )
	thread TitanCockpitHealthChangedThink( cockpit, player )

	file.isFirstBoot = false

	UpdateTitanCockpitVisibility()
}


void function SetUnlimitedDash( bool active )
{
	if ( file.cockpitLowerRui == null )
		return

	RuiSetBool( file.cockpitLowerRui, "hasUnlimitedDash", active )
}

void function UpdateEjectHud_SetManualEjectStartTime( entity player )
{
	float timeNow = Time()
	player.p.ejectEnableTime = timeNow

	if ( file.cockpitRui != null )
		RuiSetGameTime( file.cockpitRui, "ejectManualStartTime", timeNow )

	if ( file.cockpitAdditionalRui != null )
		RuiSetGameTime( file.cockpitAdditionalRui, "ejectManualStartTime", timeNow )
}

void function UpdateEjectHud_SetButtonPressTime( entity player )
{
	float timeNow = Time()
	player.p.ejectPressTime	= timeNow

	if ( file.cockpitRui != null )
		RuiSetGameTime( file.cockpitRui, "ejectButtonPressTime", timeNow )

	//
	//
}

void function UpdateEjectHud_SetButtonPressCount( entity player, int buttonCount )
{
	player.p.ejectPressCount = buttonCount

	if ( file.cockpitRui != null )
		RuiSetInt( file.cockpitRui, "ejectButtonCount", buttonCount )

	//
	//
}

void function UpdateTitanCockpitVisibility()
{
	entity player = GetLocalViewPlayer()
	if ( !IsValid( player ) )
		return

	if ( Tone_ShouldCreateTrackerHud( player ) )
		thread Tone_HudThink( player )
	else
		player.Signal( "StopToneHud" )

	foreach ( managedRUI in file.titanCockpitManagedRUIs )
	{
		bool shouldCreate = managedRUI.shouldCreate()
		if ( !managedRUI.exists && shouldCreate )
		{
			var rui = managedRUI.create()

			bool found = false
			foreach ( cockpitRui in player.p.titanCockpitRUIs )
			{
				if ( cockpitRui.rui == rui )
					found = true
			}
			if ( !found )
			{
				TitanCockpitRUI tcRUI
				tcRUI.rui = rui
				tcRUI.drawGroup = managedRUI.drawGroup
				player.p.titanCockpitRUIs.append( tcRUI )
			}

			managedRUI.exists = true
		}
		else if ( managedRUI.exists && !shouldCreate )
		{
			managedRUI.destroy()
			managedRUI.exists = false
		}
	}

	bool isVisible = true

	int ceFlags = player.GetCinematicEventFlags()
	if ( (ceFlags & CE_FLAG_INTRO) || (ceFlags & CE_FLAG_TITAN_3P_CAM) )
		isVisible = false
	if ( clGlobal.isSoloDialogMenuOpen )
		isVisible = false

	for ( int i = player.p.titanCockpitRUIs.len() - 1; i >= 0; i-- )
	{
		TitanCockpitRUI tcRUI = player.p.titanCockpitRUIs[ i ]
		RuiSetVisible( tcRUI.rui, isVisible )
	}
}

void function AddTitanCockpitManagedRUI( var functionref() createFunc, void functionref() destroyFunc, bool functionref() shouldCreateFunc, int drawGroup )
{
	TitanCockpitManagedRUI managedRUI
	managedRUI.create = createFunc
	managedRUI.destroy = destroyFunc
	managedRUI.shouldCreate = shouldCreateFunc
	managedRUI.drawGroup = drawGroup

	file.titanCockpitManagedRUIs.append( managedRUI )
}

void function CinematicEventFlagChanged( entity player )
{
	UpdateTitanCockpitVisibility()
}

void function CockpitDoomedThink( entity cockpit )
{
	entity player = GetLocalViewPlayer()
	cockpit.EndSignal( "OnDestroy" )

	while ( IsAlive( player ) )
	{
		entity soul = player.GetTitanSoul()
		if ( !IsValid( soul ) ) //
			return
		if ( !soul.IsDoomed() )
			player.WaitSignal( "Doomed" )

		SetCockpitUIDoomedState( true )

		if ( !IsValid( soul ) ) //
			return
		if ( soul.IsDoomed() )
			player.WaitSignal( "TitanUnDoomed" )

		SetCockpitUIDoomedState( false )
	}
}

void function SetCockpitUIEjectingState( bool state )
{
	if ( file.cockpitRui != null )
		RuiSetBool( file.cockpitRui, "isEjecting", state )

	if ( file.cockpitAdditionalRui != null )
		RuiSetBool( file.cockpitAdditionalRui, "isEjecting", state )

	if ( file.cockpitLowerRui != null )
	{
		RuiSetBool( file.cockpitLowerRui, "isEjecting", state )
		if ( state )
			RuiSetString( file.cockpitLowerRui, "ejectPrompt", Localize( RollRandomEjectString() ) )
		else
			RuiSetString( file.cockpitLowerRui, "ejectPrompt", "" )
	}
}

void function SetCockpitUIDoomedState( bool state )
{
	if ( file.cockpitRui != null )
		RuiSetBool( file.cockpitRui, "isDoomed", state )

	if ( file.cockpitAdditionalRui != null )
		RuiSetBool( file.cockpitAdditionalRui, "isDoomed", state )
}

void function TitanCockpitDestroyRui( var ruiToDestroy )
{
	if ( ruiToDestroy == null )
		return

	entity player = GetLocalViewPlayer()

	for ( int i = player.p.titanCockpitRUIs.len() - 1; i >= 0; i-- )
	{
		TitanCockpitRUI tcRUI = player.p.titanCockpitRUIs[ i ]
		if ( tcRUI.rui == ruiToDestroy )
		{
			RuiDestroy( tcRUI.rui )
			player.p.titanCockpitRUIs.remove( i )
		}
	}
}

void function TitanCockpitDestroyRuisOnDeath( entity cockpit )
{
	entity player = GetLocalViewPlayer()

	OnThreadEnd(
	function() : ( cockpit )
		{
			foreach ( managedRUI in file.titanCockpitManagedRUIs )
			{
				if ( managedRUI.exists )
				{
					managedRUI.destroy()
					managedRUI.exists = false
				}
			}

			entity player = GetLocalViewPlayer()
			for ( int i = player.p.titanCockpitRUIs.len() - 1; i >= 0; i-- )
			{
				RuiDestroy( player.p.titanCockpitRUIs[ i ].rui )
				player.p.titanCockpitRUIs.remove( i )
			}

			player = GetLocalClientPlayer()
			if ( IsValid( player ) )
				player.Signal( "DisplayFrontierRank" )
			file.cockpitAdditionalRui = null
			file.cockpitRui = null
			file.cockpitLowerRui = null
			file.coreHintRui = null
		}
	)

	player.EndSignal( "OnDeath" )
	cockpit.EndSignal( "OnDestroy" )
	WaitForever()
}

void function CockpitBodyThink( entity cockpit, entity cockpitBody )
{
	cockpitBody.EndSignal( "OnDestroy" )

	cockpit.WaitSignal( "OnDestroy" )

	cockpitBody.Destroy()
}

entity function CreateCockpitBody( entity cockpit, entity player, entity cockpitParent )
{
	asset bodySettings = file.lastPilotSettings
	//
	//
	//
		bodySettings = DEFAULT_PILOT_SETTINGS

	asset bodyModelName = GetGlobalSettingsAsset( bodySettings, "armsModel" )
	#if(DEV)
	if ( bodyModelName == $"" )
	{
		Warning( "Couldn't find armsmodel for set file: " + bodySettings )
	}
	#endif

	entity cockpitBody = CreateClientSidePropDynamic( cockpitParent.GetOrigin(), <0,0,0>, bodyModelName )
	cockpitBody.EnableRenderWithCockpit()
	cockpitBody.SetOrigin( cockpit.GetOrigin() )
	cockpitBody.SetParent( cockpit )

	thread CockpitBodyThink( cockpit, cockpitBody )

	return cockpitBody
}

void function TitanEmbarkDSP( float transitionTime )
{
}

void function TitanDisembarkDSP( float transitionTime )
{
}

float function TitanCockpit_EMPFadeScale( entity cockpit, float elapsedMod = 0 )
{
	float fadeInTime = 0.0
	float fadeOutTime = 1.5
	float elapsedTime = expect float( Time() - cockpit.s.empInfo.startTime )
	elapsedTime += elapsedMod

	//
	//
	//

	//
	//
	//

	//
	if ( elapsedTime < cockpit.s.empInfo.duration - fadeOutTime )
	{
		return 1.0
	}

	if ( elapsedTime >= fadeInTime + cockpit.s.empInfo.duration + fadeOutTime )
	{
		cockpit.s.empInfo.startTime = 0
		return 0.0
	}

	//
	//
	//

	if ( elapsedTime < fadeInTime )
	{
		return GraphCapped( elapsedTime, 0.0, fadeInTime, 0.0, 1.0 )
	}

	//
	//
	//

	if ( elapsedTime > fadeInTime + cockpit.s.empInfo.duration )
	{
		cockpit.s.empInfo["sub_count"] = 0
		return GraphCapped( elapsedTime, fadeInTime + cockpit.s.empInfo.duration, fadeInTime + cockpit.s.empInfo.duration + fadeOutTime, 1.0, 0.0 )
	}

	//
	//
	//

	//
	if ( cockpit.s.empInfo["sub_start"] == 0 )
	{
		cockpit.s.empInfo["sub_start"] 		<- Time()
		if ( cockpit.s.empInfo["sub_count"] == 0 )
			cockpit.s.empInfo["sub_pause"] 	<- RandomFloatRange( 0.5, 1.5 )
		else
			cockpit.s.empInfo["sub_pause"] 	<- RandomFloat( 0.5 )
		cockpit.s.empInfo["sub_duration"] 	<- RandomFloatRange( 0.1, 0.4 )
		cockpit.s.empInfo["sub_alpha"] 		<- RandomFloatRange( 0.4, 0.9 )
		cockpit.s.empInfo["sub_count"]++
	}
	float flickerElapsedTime = expect float( Time() - cockpit.s.empInfo["sub_start"] )

	//
	if ( flickerElapsedTime > cockpit.s.empInfo["sub_pause"] + cockpit.s.empInfo["sub_duration"] )
		cockpit.s.empInfo["sub_start"] = 0

	if ( flickerElapsedTime < cockpit.s.empInfo["sub_pause"] )
	{
		//
		return 1.0
	}
	else if ( flickerElapsedTime < cockpit.s.empInfo["sub_pause"] + ( cockpit.s.empInfo["sub_duration"] / 2.0 ) )
	{
		//
		return GraphCapped( flickerElapsedTime, 0.0, cockpit.s.empInfo["sub_duration"] / 2.0, 1.0, cockpit.s.empInfo["sub_alpha"] )
	}
	else
	{
		//
		return GraphCapped( flickerElapsedTime, cockpit.s.empInfo["sub_duration"] / 2.0, cockpit.s.empInfo["sub_duration"], cockpit.s.empInfo["sub_alpha"], 1.0 )
	}

	unreachable
}

void function ServerCallback_TitanCockpitEMP( float duration )
{
	thread TitanCockpit_DoEMP( duration / 4 )
}

void function TitanCockpit_DoEMP( float duration )
{
	entity player = GetLocalViewPlayer()
	entity cockpit = player.GetCockpit()

	if ( !IsValid( cockpit ) )
		return

	if ( !player.IsTitan() )
		return

	if ( !player.s.inTitanCockpit )
		return

	Signal( player, "EMP" )
	EndSignal( player, "EMP" )
	player.EndSignal( "OnDestroy" )

	//
	ClientCockpitShake( 0.25, 3, 1.0, <0,0,1> ) //

	thread PlayCockpitEMPLights( cockpit, duration )

	//
	cockpit.s.empInfo.xOffset = RandomFloatRange( 0.5, 0.75 )
	cockpit.s.empInfo.yOffset = RandomFloatRange( 0.5, 0.75 )
	if ( CoinFlip() )
		cockpit.s.empInfo.xOffset *= -1
	if ( CoinFlip() )
		cockpit.s.empInfo.yOffset *= -1

	cockpit.s.empInfo.startTime = Time()
	cockpit.s.empInfo.duration = duration

	EmitSoundOnEntity( player, EMP_IMPARED_SOUND )
	wait duration
	FadeOutSoundOnEntity( player, EMP_IMPARED_SOUND, 1.5 )
}

void function PlayCockpitEMPLights( entity cockpit, float duration )
{
	duration += 1.5 //
	int attachID
	vector origin
	vector angles
	array<table> fxLights

	string tagName = "COCKPIT" //
	attachID = cockpit.LookupAttachment( tagName )
	origin = cockpit.GetAttachmentOrigin( attachID )
	origin.z -= 25
	angles = <0,0,0>

	table lightTable
	lightTable.light <- CreateClientSideDynamicLight( origin, angles, <0,0,0>, 80.0 )
	lightTable.modulate <- true
	fxLights.append( lightTable )

	wait 0.5

	foreach ( fxLight in fxLights )
	{
		fxLight.light.SetCockpitLight( true )
	}

	float startTime = Time()
	float rate = 1.2

	float endTime = Time() + duration

	while ( IsValid( cockpit ) )
	{
		if ( Time() > endTime )
			break

		float subtractColor = GraphCapped( Time(), endTime - 0.25, endTime, 1.0, 0.0 )
		float pulseFrac = GetPulseFrac( rate, startTime )
		pulseFrac *= subtractColor
		//

		foreach ( index, fxLight in fxLights )
		{
			Assert( fxLight.modulate )
			fxLight.light.SetLightColor( <pulseFrac,0,0> )

			//
			//
		}

		WaitFrame()
	}

	foreach ( fxLight in fxLights )
	{
		fxLight.light.Destroy()
	}
}

bool function TitanCockpit_IsBooting( entity cockpit )
{
	return cockpit.GetTimeInCockpit() < 1.3
}

void function TitanCockpitAnimThink( entity cockpit, entity body )
{
	cockpit.SetOpenViewmodelOffset( 20.0, 0.0, 10.0 )
	cockpit.Anim_NonScriptedPlay( "atpov_cockpit_hatch_close_idle" )

	if ( body )
		body.Anim_NonScriptedPlay( "atpov_cockpit_hatch_close_idle" )
}

//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//

//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//

string function RollRandomEjectString()
{
	const int COCKPIT_EJECT_COMMON_COUNT = 6
	const int COCKPIT_EJECT_RARE_COUNT = 36
	const float CHANCE_FOR_RARE = 0.15

	float randForType = RandomFloat( 1.0 )
	if ( randForType < CHANCE_FOR_RARE )
	{
		int index = RandomInt( COCKPIT_EJECT_RARE_COUNT )
		string result = "#COCKPIT_EJECT_RARE_" + index
		return result
	}

	int index = RandomInt( COCKPIT_EJECT_COMMON_COUNT )
	string result = "#COCKPIT_EJECT_COMMON_" + index
	return result
}

void function PlayerEjects( entity player, entity cockpit ) //
{
	//
	if ( player.ContextAction_IsActive() && !player.ContextAction_IsBusy() )
		return

	player.Signal( "Ejecting" )

	SetCockpitUIEjectingState( true )

	string ejectAlarmSound
	cockpit.s.ejectStartTime = Time()
	string animationName
	if ( GetNuclearPayload( player ) > 0 )
	{
		animationName = "atpov_cockpit_eject_nuclear"
		cockpit.Anim_NonScriptedPlay( animationName )
		if ( IsValid( cockpit.e.body ) )
			cockpit.e.body.Anim_NonScriptedPlay( "atpov_cockpit_eject_nuclear" )
		ejectAlarmSound = TITAN_NUCLEAR_DEATH_ALARM
	}
	else
	{
		animationName = "atpov_cockpit_eject"
		cockpit.Anim_NonScriptedPlay( animationName )
		if ( IsValid( cockpit.e.body ) )
			cockpit.e.body.Anim_NonScriptedPlay( "atpov_cockpit_eject" )

		ejectAlarmSound = TITAN_ALARM_SOUND
	}

	thread LightingUpdateAfterOpeningCockpit()
	thread EjectAudioThink( player, ejectAlarmSound )

	float animDuration = cockpit.GetSequenceDuration( animationName )

	thread MonitorPlayerEjectAnimBeingStuck( player, animDuration )
}

void function MonitorPlayerEjectAnimBeingStuck( entity player, float duration )
{
	player.Signal( "MonitorPlayerEjectAnimBeingStuck" )
	player.EndSignal( "MonitorPlayerEjectAnimBeingStuck" )
	player.EndSignal( "OnDeath" )
	player.EndSignal( "OnDestroy" )
	player.EndSignal( "SettingsChanged" )


	wait duration + 2.0 //

	if ( player.IsTitan() )
	{
		entity cockpit = player.GetCockpit()
		cockpit.Anim_NonScriptedPlay( "atpov_cockpit_hatch_close_idle" )
		if ( IsValid( cockpit.e.body ) )
			cockpit.e.body.Anim_NonScriptedPlay( "atpov_cockpit_hatch_close_idle" )

		SetCockpitUIEjectingState( false )
	}
}

void function ServerCallback_EjectConfirmed()
{
	if ( !IsWatchingReplay() )
		return

	entity player = GetLocalViewPlayer()
	entity cockpit = player.GetCockpit()

	if ( !cockpit || !IsTitanCockpitModelName( cockpit.GetModelName() ) )
		return

	PlayerEjects( player, cockpit )
}

void function EjectAudioThink( entity player, string ejectAlarmSound = TITAN_ALARM_SOUND )
{
	EmitSoundOnEntity( player, ejectAlarmSound )
	TitanCockpit_PlayDialog( player, "manualEjectNotice" )

	player.EndSignal( "OnDeath" )

	player.WaitSignal( "SettingsChanged" )

	if ( player.GetPlayerClass() != "pilot" )
		return

	OnThreadEnd(
		function() : ( player )
		{
			if ( !IsAlive( player ) )
			{
				StopSoundOnEntity( player, TITAN_EJECT_ASCENT )
				StopSoundOnEntity( player, TITAN_EJECT_DESCENT )
			}
			else
			{
				FadeOutSoundOnEntity( player, TITAN_EJECT_ASCENT, 0.25 )
				FadeOutSoundOnEntity( player, TITAN_EJECT_DESCENT, 0.25 )
			}

			StopSoundOnEntity( player, TITAN_EJECT_APEX )
		}
	)

	EmitSoundOnEntity( player, TITAN_EJECT_BOOST )

	float startTime = Time()
	float duration = GetSoundDuration( TITAN_EJECT_ASCENT )
	EmitSoundOnEntity( player, TITAN_EJECT_ASCENT )
	float timeOut = duration - 0.25
	vector velocity
	float diff = 0.0

	const int STAGE_ASCENT = 1
	const int STAGE_APEX = 2
	const int STAGE_DESCENT = 3

	int ejectStage = STAGE_ASCENT

	string currentSound = TITAN_EJECT_ASCENT

	while ( diff < timeOut )
	{
		PerfStart( 127 )

		diff = (Time() - startTime)

		velocity = player.GetVelocity()
		float length = Length( velocity )

		if ( diff > 0.5 )
		{
			if ( player.IsOnGround() )
			{
				PerfEnd( 127 )
				break
			}
		}

		if ( ejectStage != STAGE_DESCENT && velocity.z < 0 )
		{
			FadeOutSoundOnEntity( player, TITAN_EJECT_ASCENT, 0.25 )
			timeOut = GetSoundDuration( TITAN_EJECT_DESCENT )
			EmitSoundOnEntity( player, TITAN_EJECT_DESCENT )
			currentSound = TITAN_EJECT_DESCENT
			ejectStage = STAGE_DESCENT
		}
		else if ( ejectStage == STAGE_ASCENT && length < 400 )
		{
			EmitSoundOnEntity( player, TITAN_EJECT_APEX )
			ejectStage = STAGE_APEX
		}

		PerfEnd( 127 )

		WaitFrame()
	}
}

void function LightingUpdateAfterOpeningCockpit()
{
 	while ( true )
 	{
 		if ( !GetLocalViewPlayer().s.inTitanCockpit )
 			break
 		WaitFrame()
 	}

	SetCockpitLightingEnabled( 0, false )
}

void function TonemappingUpdateAfterOpeningCockpit() //
{
	float duration = 3.0
	float tonemapMin = 2.0
	float tonemapMax = 5.0

 	while ( true )
 	{
 		if ( !GetLocalViewPlayer().s.inTitanCockpit )
 			break
 		WaitFrame()
 	}

	SetCockpitLightingEnabled( 0, false )

	AutoExposureSetExposureCompensationBias( tonemapMax )
	AutoExposureSnap()
	wait( 0.1 )

	TitanDisembarkDSP( 0.5 )

	float startTime = Time()
	while ( true )
	{
		float time = Time() - startTime
		float factor = GraphCapped( time, 0.0, duration, 1.0, 0.0 )
		factor = factor * factor * factor
		float toneMapScale = tonemapMin + (tonemapMax - tonemapMin) * factor
		AutoExposureSetExposureCompensationBias( toneMapScale )
		AutoExposureSnap()
		wait  0
		if ( factor == 0 )
			break
	}

	AutoExposureSetExposureCompensationBias( 0 )
}

void function ServerCallback_TitanEmbark()
{
	TitanCockpit_PlayDialog( GetLocalViewPlayer(), "embark" )
}

void function ServerCallback_TitanDisembark()
{
	entity player = GetLocalViewPlayer()

	thread LightingUpdateAfterOpeningCockpit()

	//

	//
}

void function PlayerPressed_QuickDisembark( entity player )
{
	player.ClientCommand( "TitanDisembark" )
}

//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//

float function CalcJoltMagnitude( player, cockpit, joltDir, float damageAmount, damageType, int damageSourceID )
{
	const float COCKPIT_MAX_JOLT_DAMAGE = 2000.0

	float resultRaw = damageAmount / COCKPIT_MAX_JOLT_DAMAGE
	return clamp( resultRaw, 0.0, 1.0 )
}

void function JoltCockpit( entity cockpit, entity player, vector joltDir, float damageAmount, damageType, damageSourceId )
{
	float severity = CalcJoltMagnitude( player, cockpit, joltDir, damageAmount, damageType, expect int( damageSourceId ) )
	player.CockpitJolt( joltDir, severity )
}

/*







*/

void function TitanCockpitDoomedThink( entity cockpit, entity player )
{
	cockpit.EndSignal( "OnDestroy" )

	entity titanSoul = player.GetTitanSoul()

	if ( titanSoul == null || !titanSoul.IsDoomed() )
		WaitSignal( player, "Doomed", "Ejecting" )

	vector color = <0.6,0.06,0>
	float radius = 70.0

	FlashCockpitLight( cockpit, color, radius, -1 )
}

void function TitanCockpitHealthChangedThink( entity cockpit, entity player )
{
	cockpit.EndSignal( "OnDestroy" )

	while ( true )
	{
		table results = WaitSignal( player, "HealthChanged" )

		if ( !IsAlive( player ) )
			continue

		float oldHealthFrac = float( results.oldHealth ) / float( player.GetMaxHealth() )
		float newHealthFrac = float( results.newHealth ) / float( player.GetMaxHealth() )

		if ( oldHealthFrac > newHealthFrac )
		{
			var rui = RuiCreate( $"ui/ajax_cockpit_lost_health_segment.rpak", clGlobal.topoTitanCockpitHud, RUI_DRAW_COCKPIT, 10 )
			RuiSetGameTime( rui, "startTime", Time() )
			RuiSetFloat( rui, "oldHealthFrac", oldHealthFrac )
			RuiSetFloat( rui, "newHealthFrac", newHealthFrac )

			asset playerSettings = GetLocalViewPlayer().GetPlayerSettings()
			float health = player.GetPlayerModHealth() //
			float healthPerSegment = GetGlobalSettingsFloat( playerSettings, "healthPerSegment" )
			RuiSetInt( rui, "numHealthSegments", int( health / healthPerSegment ) )
		}
	}
}

void function FlashCockpitLight( entity cockpit, vector color, float radius, float duration, string tag = "SCR_CL_BL" )
{
	cockpit.EndSignal( "TitanUnDoomed" )
	cockpit.EndSignal( "OnDestroy" )

	int attachID = cockpit.LookupAttachment( tag )
	vector origin = cockpit.GetAttachmentOrigin( attachID )
	vector angles = <0,0,0>

	entity fxLight = CreateClientSideDynamicLight( origin, angles, color, radius )
	fxLight.SetCockpitLight( true )
	fxLight.SetParent( cockpit )

	OnThreadEnd(
		function() : ( fxLight )
		{
			fxLight.Destroy()
		}
	)

	float startTime = Time()
	float rate = 3.0

	while ( IsValid( cockpit ) && (Time() < startTime + duration || duration == -1 ) )
	{
		float pulseFrac = GetPulseFrac( rate, startTime )
		pulseFrac += 0.5
		fxLight.SetLightColor( <color.x * pulseFrac, color.y * pulseFrac, color.z * pulseFrac> )

		WaitFrame()
	}
}

void function PlayCockpitSparkFX_Internal( entity cockpit, string tagName )
{
	//
	if ( !IsValid( cockpit ) )
		return

	int attachID = cockpit.LookupAttachment( tagName )
	if ( attachID == 0 )
	{
		tagName = CoinFlip() ? "FX_TL_PANEL" : "FX_TR_PANEL"
		attachID = cockpit.LookupAttachment( tagName )
		Assert( attachID, "Could not find fallback attachment index " + attachID + " for '" + tagName + "'' in model " + GetLocalViewPlayer().GetCockpit().GetModelName() )
	}

	int fxID = GetParticleSystemIndex( $"xo_cockpit_spark_01" )
	int fxInstID = PlayFXOnTag( cockpit, fxID, attachID )

	EffectSetIsWithCockpit( fxInstID, true )
}

void function PlayCockpitSparkFX( entity cockpit, int sparkCount )
{
	const int TAG_COUNT = 6
	const string[TAG_COUNT] cockpitFXEmitTags = [ "FX_TL_PANEL", "FX_TR_PANEL", "FX_TC_PANELA", "FX_TC_PANELB", "FX_BL_PANEL", "FX_BR_PANEL" ]
	array<int> playlist = [0,1,2,3,4,5]
	playlist.randomize()

	for ( int idx = 0; idx < sparkCount; idx++ )
	{
		int lookup = (idx % TAG_COUNT)
		int tagIndex = playlist[lookup]
		string tagName = cockpitFXEmitTags[tagIndex]
		PlayCockpitSparkFX_Internal( cockpit, tagName )
	}
}

const int DAMAGE_PER_SPARK = 1000
const int SPARK_MULTIPLIER = 3

int function CalSparkCountForHit( entity player, float damageAmount, bool becameDoomed )
{
	if ( becameDoomed )
		return 20
	if ( damageAmount <= 0 )
		return 0

	int healthNow = player.GetHealth()
	int healthPrev = healthNow + int( damageAmount )
	int healthMax = player.GetMaxHealth()

	bool isDoomed = GetDoomedState( player )
	int sparksNow = (healthNow / DAMAGE_PER_SPARK)
	int sparksPrev = (healthPrev / DAMAGE_PER_SPARK)
	if ( (healthPrev == healthMax) && !isDoomed )
		--sparksPrev	//

	int delta = (sparksPrev - sparksNow)
	if ( delta < 0 )
		return 0

	return (delta * SPARK_MULTIPLIER)
}

void function TitanCockpit_DamageFeedback( entity player, entity cockpit, float damageAmount, int damageType, vector damageOrigin, int damageSourceId, bool doomedNow, int doomedDamage )
{
	RumbleForTitanDamage( damageAmount )

	vector joltDir = Normalize( player.CameraPosition() - damageOrigin )
	float joltDamage = doomedNow ? float( doomedDamage ) : damageAmount
	JoltCockpit( cockpit, player, joltDir, joltDamage, damageType, damageSourceId )

	bool isShieldHit = (damageType & DF_SHIELD_DAMAGE) ? true : false
	if ( isShieldHit )
		return

	int sparkCount = CalSparkCountForHit( player, damageAmount, doomedNow )
	//
	PlayCockpitSparkFX( cockpit, sparkCount )
}

void function ServerCallback_TitanCockpitBoot()
{
	thread ServerCallback_TitanCockpitBoot_Internal()
}

void function ServerCallback_TitanCockpitBoot_Internal()
{
	AutoExposureSetExposureCompensationBias( -6.0 )
	AutoExposureSnap()
	wait 0.1
	AutoExposureSetExposureCompensationBias( 0 )
}

void function ServerCallback_TitanEMP( float maxValue, float duration, float fadeTime, bool doFlash = true, bool doSound = true )
{
	thread TitanEMP_Internal( maxValue, duration, fadeTime, doFlash, doSound )
}

void function TitanEMP_Internal( float maxValue, float duration, float fadeTime, bool doFlash = true, bool doSound = true )
{
	entity player = GetLocalViewPlayer()

	player.Signal( "TitanEMP_Internal" )
	player.EndSignal( "TitanEMP_Internal" )

	player.EndSignal( "OnDeath" )
	player.EndSignal( "SettingsChanged" )

	vector angles = <0,-90,90>

	float wide = 16.0
	float tall = 9.0

	float fovOffset = Graph( player.GetFOV(), 75, 120, 4, 2.5 )

	entity empVgui = CreateClientsideVGuiScreen( "vgui_titan_emp", VGUI_SCREEN_PASS_VIEWMODEL, <0,0,0>, <0,0,0>, wide, tall )

	//
	empVgui.SetRefract( true ) //
	empVgui.SetParent( player )
	empVgui.SetAttachOffsetOrigin( <fovOffset, wide / 2, -tall / 2> )
	empVgui.SetAttachOffsetAngles( angles )

	empVgui.GetPanel().WarpEnable()

	local EMPScreenFX = HudElement( "EMPScreenFX", empVgui.GetPanel() )
	local EMPScreenFlash = HudElement( "EMPScreenFlash", empVgui.GetPanel() )

	OnThreadEnd(
		function() : ( player, empVgui )
		{
			empVgui.Destroy()
		}
	)

	EMPScreenFX.Show()
	EMPScreenFX.SetAlpha( maxValue * 255 )
	EMPScreenFX.FadeOverTimeDelayed( 0, fadeTime, duration )

	if ( doFlash )
	{
		EMPScreenFlash.Show()
		EMPScreenFlash.SetAlpha( 255 )
		EMPScreenFlash.FadeOverTimeDelayed( 0, fadeTime + duration, 0 )
	}

	if ( doSound )
	{
		EmitSoundOnEntity( player, EMP_IMPARED_SOUND )
		wait duration
		FadeOutSoundOnEntity( player, EMP_IMPARED_SOUND, fadeTime )
	}

	wait fadeTime
}

void function LinkCoreHint( entity soul )
{
	if ( file.coreHintRui == null )
		return

	RuiTrackFloat( file.coreHintRui, "coreFrac", soul, RUI_TRACK_SCRIPT_NETWORK_VAR, GetNetworkedVariableIndex( "coreAvailableFrac" ) )
}

void function FlashCockpitHealth( vector color )
{
	if ( file.cockpitRui == null )
		return

	RuiSetGameTime( file.cockpitRui, "startFlashTime", Time() )
	RuiSetFloat3( file.cockpitRui, "flashColor", color )
}

void function UpdateHealthSegmentCount()
{
	if ( file.cockpitRui == null )
		return

	entity player = GetLocalViewPlayer()
	asset playerSettings = player.GetPlayerSettings()
	float health = player.GetPlayerModHealth()
	float healthPerSegment = GetGlobalSettingsFloat( playerSettings, "healthPerSegment" )
	RuiSetInt( file.cockpitRui, "numHealthSegments", int( health / healthPerSegment ) )
}

void function NetworkedVarChangedCallback_UpdateVanguardRUICoreStatus( entity soul, int oldValue, int newValue, bool actuallyChanged )
{
	if ( file.cockpitRui == null )
		return

	if ( actuallyChanged == false )
		return

	entity player = GetLocalViewPlayer()
	if ( !IsValid( player ) || !player.IsTitan() )
		return

	UpdateHealthSegmentCount()

	string titanName = "Alice"//
	//
	//
	//
	//
	//
	//
	//
}

void function Scorch_DestroyHotstreakBar()
{
	TitanCockpitDestroyRui( file.scorchHotstreakRui )
	file.scorchHotstreakRui = null
}

bool function Scorch_ShouldCreateHotstreakBar()
{
	entity player = GetLocalViewPlayer()

	if ( !IsAlive( player ) )
		return false

	array<entity> mainWeapons = player.GetMainWeapons()
	if ( mainWeapons.len() == 0 )
		return false

	entity primaryWeapon = mainWeapons[0]
	return primaryWeapon.HasMod( "fd_hot_streak" )
}