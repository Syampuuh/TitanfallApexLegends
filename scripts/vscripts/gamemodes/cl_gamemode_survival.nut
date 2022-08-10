global function ClGamemodeSurvival_Init
global function CLSurvival_RegisterNetworkFunctions

global function Survival_MinimapPackage_ObjectiveAreaInit

global function AddCallback_PlayerPressedInventory

global function ServerCallback_AnnounceCircleClosing
global function ServerCallback_SUR_PingMinimap
global function ServerCallback_SurvivalHint
global function ServerCallback_PlayerBootsOnGround
global function ServerCallback_ClearHints
global function ServerCallback_MatchEndAnnouncement
global function ServerCallback_AddWinningSquadData
global function ServerCallback_PromptSayThanks
global function ServerCallback_PromptSayThanksRevive
global function ServerCallback_PromptTaunt
global function ServerCallback_PromptSayGetOnTheDropship
                            
global function ServerCallback_PromptMarkMyLastDeathbox
      
global function ServerCallback_PromptRespawnThanks
global function ServerCallback_RefreshInventoryAndWeaponInfo
global function ServerCallback_RefreshDeathBoxHighlight

global function ServerCallback_AnnounceDevRespawn

global function ServerCallback_AutoReloadComplete

                         
global function ServerCallback_SetLaserSightVMLaserEnabled
      

global function CreateQuickchatFunction

global function AddCallback_OnUpdateShowButtonHints
global function AddCallback_OnVictoryCharacterModelSpawned

global function OnHealthPickupTypeChanged

global function UpdateFallbackMatchmaking
global function UpdateInventoryCounter

global function OverrideHUDHealthFractions

global function OpenSurvivalMenu

global function SURVIVAL_PopulatePlayerInfoRui
global function SURVIVAL_SetGameStateAssetOverrideCallback

global function MarkDpadAsBlocked

global function ScorebarInitTracking

global function PlayerHudSetWeaponInspect
global function UpdateDpadHud

global function PROTO_ServerCallback_Sur_HoldForUltimate

global function PROTO_OpenInventoryOrSpecifiedMenu

global function UICallback_UpdateCharacterDetailsPanel
global function UICallback_OpenCharacterSelectNewMenu
global function UICallback_QueryPlayerCanBeRespawned
global function UICallback_DieAndChangeCharacters

global function HealthkitWheelToggleEnabled
global function HealthkitWheelUseOnRelease
global function HealthkitUseOnHold

global function OrdnanceWheelToggleEnabled
global function OrdnanceWheelUseOnRelease
global function OrdnanceUseOnHold

global function GetSquadSummaryData
global function GetWinnerSquadSummaryData
global function SetSquadDataToLocalTeam
global function SetVictorySequenceEffectPackage
global function SetVictorySequenceLocation
global function SetVictorySequenceSunSkyIntensity
global function IsShowingVictorySequence
global function GetVictoryScreenCharacterModelForEHI
global function ServerCallback_NessyMessage
global function ShowChampionVictoryScreen
global function GetVictorySequenceRui
global function SetVictoryScreenTeamName

global function CanReportPlayer

global function UIToClient_ToggleMute
global function SetSquadMuteState
global function ToggleSquadMute
global function IsSquadMuted
global function AddCallback_OnSquadMuteChanged
global function AddCallback_ShouldRunCharacterSelection

global function OverwriteWithCustomPlayerInfoTreatment
global function SetCustomPlayerInfoCharacterIcon
global function SetCustomPlayerInfoTreatment
global function SetCustomPlayerInfoColor
global function SetCustomPlayerInfoShadowFormState
global function GetPlayerInfoColor
global function ClearCustomPlayerInfoColor

global function SetNextCircleDisplayCustomStarting
global function SetNextCircleDisplayCustomClosing
global function SetNextCircleDisplayCustomClear
global function SetGamestateCountdown
global function SetGamestateCountdownClear

global function SetPreVictoryScreenCallback
global function SetChampionScreenRuiAsset
global function SetChampionScreenSound
global function SetChampionScreenRuiAssetExtraFunc

global function InitSurvivalHealthBar

global function GetCompassRui
global function GetPilotRui
global function GetDpadMenuRui

global function EvolvingArmor_SetEvolutionRuiAnimTime

                          
global function ShowTeamNameInHud
global function HideTeamNameInHud
      

#if DEV
global function Dev_ShowVictorySequence
global function Dev_AdjustVictorySequence
global function Dev_SpoofMatchData
#endif

global function CircleAnnouncementsEnable
global function CircleBannerAnnouncementsEnable
global function Survival_SetVictorySoundPackageFunction

global function GetVictorySquadFormationActivity

global function ClientCodeCallback_OnTryCycleOrdnance

global function SetSummaryDataDisplayStringsCallback

                   
                                   
      

global struct NextCircleDisplayCustomData
{
	float  circleStartTime
	float  circleCloseTime
	float  countdownGoalTime
	int    roundNumber
	string roundString

	vector deathFieldOrigin
	vector safeZoneOrigin

	float deathfieldDistance
	float deathfieldStartRadius
	float deathfieldEndRadius

	asset  altIcon = $""
	string altIconText
	vector altColor = <1, 1, 1>
}

global struct VictorySoundPackage
{
	string youAreChampPlural
	string youAreChampSingular
	string theyAreChampPlural
	string theyAreChampSingular
}

struct VictoryCameraPackage
{
	vector camera_offset_start
	vector camera_offset_end
	vector camera_focus_offset
	float  camera_fov
}

global struct VictoryEffectPackage
{
	vector position
	vector angles
	asset effect = $""
}

const VICTORY_PODIUM_RUI = $"ui/victory_podium_ui.rpak"
const ENTRY_PODIUM_RUI = $"ui/entry_podium_ui.rpak"

const float CROUCH_SPAM_DETECT_TIMEOUT = 1.25

const string SOUND_UI_TEAMMATE_KILLED = "UI_DeathAlert_Friendly"

const string CIRCLE_CLOSING_IN_SOUND = "UI_InGame_RingMoveWarning"                                   

const float TITAN_DESYNC_TIME = 1.0

                                          
const int HEALTH_STATE_DEFAULT = 0
const int HEALTH_STATE_BLEED = 1
const int HEALTH_STATE_REVIVE = 2

const string SFX_DROPSELECTION_ME = "UI_Survival_DropSelection_Player"
const string SFX_DROPSELECTION_TEAM = "UI_Survival_DropSelection_TeamMember"

global const vector SAFE_ZONE_COLOR = <1, 1, 1>
global const float SAFE_ZONE_ALPHA = 0.05
global const float OBSERVER_SURVEY_ZONE_ALPHA = 0.6

global const string HEALTHKIT_BIND_COMMAND = "+scriptCommand2"
global const string ORDNANCEMENU_BIND_COMMAND = "+strafe"
global const string GADGETSLOT_BIND_COMMAND = "+scriptCommand6"

const asset SOLO_DEATH_SCREEN_RUI = $"ui/header_data_solo.rpak"

global struct SummaryDisplayData
{
	string displayString
	int	displayValue
}

global struct SquadSummaryPlayerData
{
	int eHandle
	int kills
	int assists
	int knockdowns
	int damageDealt
	int survivalTime
	int revivesGiven
	int respawnsGiven
	entity victoryScreenCharacterModel

	                        
	                       
	                                              
	                                 
	                                   
	                               
	                                  
	                                         
	                                   
	                                    
	array< SummaryDisplayData > modeSpecificSummaryData
	                                                                              
	bool summary3IsTime
}

global struct SquadSummaryData
{
	array<SquadSummaryPlayerData> playerData
	int                           squadPlacement = -1
	int 						  gameResultFlags = 0
	int 						  gameScoreFlags = 0
}

struct
{
	var titanLinkProgressRui
	var dpadMenuRui
	var pilotRui

	var fallbackMMRui

	var compassRui


	bool cameFromWaitingForPlayersState = false
	bool knowsHowToUseAmmo = false
	bool superHintAllowed = true

	bool                        toggleMuteKeysEnabled = false
	bool                        isSquadMuted = false
	array< void functionref() > squadMuteChangeCallbacks

	entity lastPrimaryWeapon




	bool autoLoadoutDone = false

	bool haveEverSetOwnDropPoint = false

	string playerState

	string                  rodeoOfferingHintShown = ""
	ConsumableInventoryItem rodeoOfferedItem

	bool  wantsGroundItemUpdate = false
	float nextGroundItemUpdate = 0

	bool requestReviveButtonRegistered = false

	table<entity, entity> playerWaypointData



	table<string, string> toggleAttachments

	vector victorySequencePosition = < 0, 0, 10000 >
	vector victorySequenceAngles = < 0, 0, 0 >
	float  victorySunIntensity = 1.0
	float  victorySkyIntensity = 1.0
	var            	youAreChampionSplashRui = null
	var		victoryPodiumRui = null
	bool   IsShowingVictorySequence = false
	VictoryEffectPackage victoryEffectData

	string victoryScreenTeamOverride = ""

	SquadSummaryData squadSummaryData
	SquadSummaryData winnerSquadSummaryData

	var inventoryCountRui

	bool shouldShowButtonHintsLocal

	float nextAllowToggleFireRateTime = 0.0

	bool circleAnnouncementsEnabled = true

	bool circleBannerAnnouncementsEnabled = true

	bool functionref() shouldRunCharacterSelectionCallback
	void functionref() gameStateOverrideCallback
	VictorySoundPackage functionref() victorySoundPackageCallback

	table<entity, asset>  customPlayerInfoTreatment
	table<entity, vector> customCharacterColor
	table<entity, asset>  customCharacterIcon

	asset customChampionScreenRuiAsset
	string customChampionScreenSound
	void functionref( bool) onPreVictoryScreenCallback

	int   crouchSpamCount
	float lastPressedCrouchTime

	array<bool functionref(entity) > tryAccessInventoryCallbacks

	string clubName = ""

	void functionref( SquadSummaryPlayerData ) getSquadSummaryDisplayStringsCallback
} file

void function ClGamemodeSurvival_Init()
{
	Sh_ArenaDeathField_Init()
	ClSurvivalCommentary_Init()
	ObjectiveResourceSystem_Init()
	BleedoutClient_Init()
	ClSurvivalShip_Init()
	SurvivalFreefall_Init()
	ClUnitFrames_Init()
	Cl_Survival_InventoryInit()
	Cl_Survival_LootInit()
	Cl_SquadDisplay_Init()
	Teams_RegisterSignals()

	Bleedout_SetFirstAidStrings( "#SURVIVAL_APPLYING_FIRST_AID", "#SURVIVAL_RECIEVING_FIRST_AID" )

	RegisterSignal( "Sur_EndTrackOffhandWeaponSlot0" )
	RegisterSignal( "Sur_EndTrackAmmo" )
	RegisterSignal( "Sur_EndTrackPrimary" )
	RegisterSignal( "StopShowingRodeoOfferingPrompt" )
	RegisterSignal( "ReloadPressed" )
	RegisterSignal( "ClearSwapOnUseThread" )
	RegisterSignal( "DroppodLanded" )
	RegisterSignal( "SquadEliminated" )

	FlagInit( "SquadEliminated" )

	ClGameState_RegisterGameStateAsset( $"ui/gamestate_info_survival.rpak" )
	if ( file.gameStateOverrideCallback != null )
	{
		file.gameStateOverrideCallback()
	}

	SetGameModeScoreBarUpdateRulesWithFlags( GameModeScoreBarRules, sbflag.SKIP_STANDARD_UPDATE )
	AddCallback_OnPlayerMatchStateChanged( OnPlayerMatchStateChanged )

	AddCallback_OnClientScriptInit( Cl_Survival_AddClient )

	AddCreateCallback( "prop_survival", OnPropCreated )
	AddCreateCallback( "prop_script", OnPropScriptCreated )

	AddCreateCallback( "player", OnPlayerCreated )
	AddDestroyCallback( "player", OnPlayerDestroyed )
	AddOnDeathCallback( "player", OnPlayerKilled )

	AddCreatePilotCockpitCallback( OnPilotCockpitCreated )
	AddCallback_PlayerClassChanged( Survival_OnPlayerClassChanged )

	RegisterConCommandTriggeredCallback( "-offhand4", AllowSuperHint )
	RegisterConCommandTriggeredCallback( "+scriptCommand3", ToggleFireSelect )

	RegisterConCommandTriggeredCallback( "+reload", ReloadPressed )
	RegisterConCommandTriggeredCallback( "+use", UsePressed )
	RegisterConCommandTriggeredCallback( "+useAndReload", ReloadPressed )

	RegisterConCommandTriggeredCallback( "+duck", CrouchPressed )
	RegisterConCommandTriggeredCallback( "+toggle_duck", CrouchPressed )

	RegisterConCommandTriggeredCallback( HEALTHKIT_BIND_COMMAND, HealthkitButton_Down )
	RegisterConCommandTriggeredCallback( "-" + HEALTHKIT_BIND_COMMAND.slice( 1 ), HealthkitButton_Up )

	RegisterConCommandTriggeredCallback( ORDNANCEMENU_BIND_COMMAND, OrdnanceMenu_Down )
	RegisterConCommandTriggeredCallback( "-" + ORDNANCEMENU_BIND_COMMAND.slice( 1 ), OrdnanceMenu_Up )

	RegisterConCommandTriggeredCallback( GADGETSLOT_BIND_COMMAND, GadgetSlot_Down )

	file.inventoryCountRui = CreateFullscreenRui( $"ui/inventory_count_meter.rpak", 0 )

	RegisterMinimapPackages()
	AddCallback_MinimapEntShouldCreateCheck( DontCreatePlayerRuisForEnemies )

	AddCallback_LocalClientPlayerSpawned( OnLocalPlayerSpawned )

	AddCallback_ClientOnPlayerConnectionStateChanged( OnPlayerConnectionStateChanged )

	AddCallback_OnBleedoutStarted( Sur_OnBleedoutStarted )
	AddCallback_OnBleedoutEnded( Sur_OnBleedoutEnded )

	AddFirstPersonSpectateStartedCallback( OnFirstPersonSpectateStarted )

	AddCallback_OnViewPlayerChanged( OnViewPlayerChanged )
	AddCallback_OnPlayerConsumableInventoryChanged( UpdateDpadHud )

	AddCallback_GameStateEnter( eGameState.WaitingForPlayers, Survival_WaitForPlayers )
	AddCallback_GameStateEnter( eGameState.WaitingForPlayers, EnableToggleMuteKeys )
	AddCallback_GameStateEnter( eGameState.PickLoadout, Survival_RunCharacterSelection )
	AddCallback_GameStateEnter( eGameState.PickLoadout, DisableToggleMuteKeys )
	AddCallback_GameStateEnter( eGameState.Prematch, OnGamestatePrematch )
	AddCallback_GameStateEnter( eGameState.Playing, DisableToggleMuteKeys )
	AddCallback_GameStateEnter( eGameState.Playing, StreamHintPlayers )
	AddCallback_GameStateEnter( eGameState.WaitingForCustomStart, SetDpadMenuVisible )
	AddCallback_GameStateEnter( eGameState.Playing, SetDpadMenuVisible )
	AddCallback_GameStateEnter( eGameState.Playing, OnGamestatePlaying )
	AddCallback_GameStateEnter( eGameState.WinnerDetermined, Survival_ClearHints )
	AddCallback_GameStateEnter( eGameState.Resolution, OnGamestateResolution )

	{
		GenericFullmapSetupStruct fullmapData
		fullmapData.ruiAsset = $"ui/in_world_minimap_plane_path.rpak"
		fullmapData.friendlyOnly = false
		fullmapData.hudMapOnly = false
		fullmapData.setupFunc = null
		AddCallback_Targetname_AddToFullMapAndInWorldMapCustom( "pathCenterEnt", fullmapData )
	}

	{
		GenericFullmapSetupStruct fullmapData
		fullmapData.defaultIcon = $"rui/survival_ship"
		fullmapData.iconScale = <1.5, 1.5, 0.0>
		fullmapData.iconColor = <0.5, 0.5, 0.5>
		fullmapData.friendlyOnly = false
		fullmapData.hudMapOnly = false
		AddCallback_Targetname_AddToFullMapAndInWorldMapGeneric( "planeEnt", fullmapData )
	}


	if ( SquadMuteIntroEnabled() )
		AddCallback_OnSquadMuteChanged( OnSquadMuteChanged )

	AddCallback_OnGameStateChanged( OnGameStateChanged )

	if ( GetCurrentPlaylistVarBool( "inventory_counter_enabled", true ) )
		AddCallback_LocalPlayerPickedUpLoot( TryUpdateInventoryCounter )

	Obituary_SetEnabled( GetCurrentPlaylistVarBool( "enable_obituary", true ) )

	foreach ( equipSlot, data in EquipmentSlot_GetAllEquipmentSlots() )
	{
		if ( data.trackingNetInt != "" )
		{
			AddCallback_OnEquipSlotTrackingIntChanged( equipSlot, EquipmentChanged )
		}
	}

	AddCallback_OnEquipSlotTrackingIntChanged( "backpack", BackpackChanged )

	if ( IsSoloMode() )
		SetCommsDialogueEnabled( false )                                               

	AddCallback_OnSettingsUpdated( OnSettingsUpdated )
}


void function SURVIVAL_SetGameStateAssetOverrideCallback( void functionref() func )
{
	file.gameStateOverrideCallback = func
}



bool function SprintFXAreEnabled()
{
	if ( Freelance_IsHubLevel() )
		return false

	bool enabled = GetCurrentPlaylistVarBool( "fp_sprint_fx", false )
	return enabled
}


void function OnPlayerCreated( entity player )
{
	if ( SprintFXAreEnabled() )
	{
		if ( player == GetLocalViewPlayer() )
			thread TrackSprint( player )
	}

	if ( (player.GetTeam() == GetLocalClientPlayer().GetTeam()) && (SquadMuteIntroEnabled() || SquadMuteLegendSelectEnabled()) )
	{
		                                                                                                
		if ( IsSquadMuted() )
			SetSquadMuteState( IsSquadMuted() )
	}
}


void function OnPlayerDestroyed( entity player )
{

}


void function TrackSprint( entity player )
{
	player.EndSignal( "OnDestroy" )

	table<string, bool> e
	e[ "sprintingVisuals" ] <- false
	int fxHandle

	while ( 1 )
	{
		bool isSprint     = e[ "sprintingVisuals" ]
		bool shouldSprint = ShouldShowSprintVisuals( player )

		if ( isSprint && !shouldSprint )
		{
			e[ "sprintingVisuals" ] = false
			player.SetFOVScale( 1, 2 )
			EffectStop( fxHandle, false, true )
			fxHandle = -1
		}
		else if ( !isSprint && shouldSprint )
		{
			e[ "sprintingVisuals" ] = true
			                                 
			if ( IsValid( player.GetCockpit() ) )
				fxHandle = StartParticleEffectOnEntity( player.GetCockpit(), GetParticleSystemIndex( SPRINT_FP ), FX_PATTACH_ABSORIGIN_FOLLOW, ATTACHMENTID_INVALID )
		}

		                                                         
		if ( shouldSprint )
			player.SetFOVScale( 1.15, 2 )

		WaitFrame()
	}
}

bool function ShouldShowSprintVisuals( entity player )
{
	if ( player.GetParent() != null )
		return false

	if ( player.GetPhysics() == MOVETYPE_NOCLIP )
		return false

	entity activeWeapon = player.GetActiveWeapon( eActiveInventorySlot.mainHand )
	if ( IsValid( activeWeapon ) && activeWeapon.GetWeaponSettingFloat( eWeaponVar.move_speed_modifier ) > 1 && player.IsSprinting() )
		return true

	float max = PLAYER_STANDING_SPRINT_SPEED                                                          

	vector fwd = player.GetViewVector()
	float dot  = DotProduct( fwd, player.GetVelocity() )
	float dot2 = DotProduct( fwd, Normalize( player.GetVelocity() ) )

	return (dot > max * 1.01) && (dot2 > 0.85)
}

void function Cl_Survival_AddClient( entity player )
{
	file.dpadMenuRui = CreateCockpitPostFXRui( SURVIVAL_HUD_DPAD_RUI, HUD_Z_BASE )
	RuiTrackFloat( file.dpadMenuRui, "reviveEndTime", player, RUI_TRACK_SCRIPT_NETWORK_VAR, GetNetworkedVariableIndex( "reviveEndTime" ) )

                               
                               
   
                                                                                                                                     
                                                                                        
   
       

	getroottable().testRui <- file.dpadMenuRui
	SetDpadMenuVisible()

	#if DEV
		if ( GetBugReproNum() == 1972 )
			file.pilotRui = CreatePermanentCockpitPostFXRui( $"ui/survival_player_hud_editor_version.rpak", HUD_Z_BASE )
		else
			file.pilotRui = CreatePermanentCockpitPostFXRui( SURVIVAL_HUD_PLAYER, HUD_Z_BASE )
	#else
		file.pilotRui = CreatePermanentCockpitPostFXRui( SURVIVAL_HUD_PLAYER, HUD_Z_BASE )
	#endif
	RuiSetBool( file.pilotRui, "isVisible", GetHudDefaultVisibility() )
	RuiSetBool( file.pilotRui, "useShields", true )

                     
                                                                      
   
                                                       
                                                                                                                                                 
   
       

	if ( GetCurrentPlaylistVarBool( "compass_flat_enabled", true ) )
	{

		file.compassRui = CreatePermanentCockpitRui( $"ui/compass_flat.rpak", HUD_Z_BASE )
		RuiTrackFloat3( file.compassRui, "playerAngles", player, RUI_TRACK_CAMANGLES_FOLLOW )
		RuiTrackInt( file.compassRui, "gameState", null, RUI_TRACK_SCRIPT_NETWORK_VAR_GLOBAL_INT, GetNetworkedVariableIndex( "gameState" ) )
	}

	#if PC_PROG
		if ( GetCurrentPlaylistVarBool( "pc_force_pushtotalk", false ) )
			player.ClientCommand( "+pushtotalk" )
	#endif           

	SetConVarFloat( "dof_variable_blur", 0.0 )

	RuiTrackInt( file.pilotRui, "squadID", player, RUI_TRACK_SQUADID )

	WaitingForPlayersOverlay_Setup( player )
}


void function InitSurvivalHealthBar()
{
	Assert( IsNewThread(), "Must be threaded off" )

	entity player = GetLocalViewPlayer()
	SURVIVAL_PopulatePlayerInfoRui( player, file.pilotRui )
}


void function SURVIVAL_PopulatePlayerInfoRui( entity player, var rui )
{
	Assert( IsValid( player ) )
	EndSignal( player, "OnDestroy" )

	#if MEMBER_COLORS
		RuiTrackInt( rui, "teamMemberIndex", player, RUI_TRACK_PLAYER_TEAM_MEMBER_INDEX )
	#endif
	RuiTrackString( rui, "name", player, RUI_TRACK_PLAYER_NAME_STRING )
	RuiTrackInt( rui, "micStatus", player, RUI_TRACK_MIC_STATUS )

	ItemFlavor character = LoadoutSlot_WaitForItemFlavor( ToEHI( player ), Loadout_Character() )
	asset classIcon      = CharacterClass_GetGalleryPortrait( character )

	RuiSetImage( rui, "playerIcon", classIcon )
	RuiSetInt( rui, "playerBaseHealth", GetPlayerSettingBaseHealth( player ) )
	RuiSetInt( rui, "playerBaseShield", GetPlayerSettingBaseShield( player ) )

	RuiSetGameTime( rui, "trackedPlayerChangeTime", Time() )
	RuiTrackFloat( rui, "playerHealthFrac", player, RUI_TRACK_HEALTH )
	RuiTrackFloat( rui, "playerTargetHealthFrac", player, RUI_TRACK_HEAL_TARGET )
	RuiTrackFloat( rui, "playerShieldFrac", player, RUI_TRACK_SHIELD_FRACTION )
                
                                                                                                                             
       
	RuiTrackFloat( rui, "cameraViewFrac", player, RUI_TRACK_STATUS_EFFECT_SEVERITY, eStatusEffect.camera_view )                                                                                                 
	vector shieldFrac = < SURVIVAL_GetArmorShieldCapacity( 0 ) / 100.0,
	SURVIVAL_GetArmorShieldCapacity( 1 ) / 100.0,
	SURVIVAL_GetArmorShieldCapacity( 2 ) / 100.0 >

	RuiSetColorAlpha( rui, "shieldFrac", shieldFrac, float( SURVIVAL_GetArmorShieldCapacity( 3 ) ) )
	RuiTrackFloat( rui, "playerTargetShieldFrac", player, RUI_TRACK_STATUS_EFFECT_SEVERITY, eStatusEffect.target_shields )
	RuiTrackFloat( rui, "playerTargetHealthFrac", player, RUI_TRACK_STATUS_EFFECT_SEVERITY, eStatusEffect.target_health )
	RuiTrackFloat( rui, "playerTargetHealthFracTemp", player, RUI_TRACK_HEAL_TARGET )

		string platformString = ""
		if ( GetLocalClientPlayer() != GetLocalViewPlayer() && CrossplayUserOptIn() )
			platformString = PlatformIDToIconString( GetHardwareFromName( GetLocalViewPlayer().GetHardwareName() ) )
		RuiSetString( rui, "platformString", platformString )

	bool isSwitchHardware = player.GetHardwareName() == "HARDWARE_SWITCH"
	if ( isSwitchHardware )
		RuiSetFloat( rui, "nxPlatformTextOffsetX", -1.5 )

	OverwriteWithCustomPlayerInfoTreatment( player, rui )

	RuiSetBool( rui, "disconnected", !player.IsConnectionActive() )
}


void function OverwriteWithCustomPlayerInfoTreatment( entity player, var rui )
{
	if ( player in file.customCharacterIcon )
		RuiSetImage( rui, "playerIcon", file.customCharacterIcon[player] )

	if ( player in file.customPlayerInfoTreatment )
	{
		RuiSetImage( rui, "customTreatment", file.customPlayerInfoTreatment[player] )
	}
	else
	{
		RuiSetImage( rui, "customTreatment", $"" )
	}

	if ( player in file.customCharacterColor )
	{
		RuiSetColorAlpha( rui, "customCharacterColor", SrgbToLinear( GetPlayerInfoColor( player ) / 255.0 ), 1.0 )
		RuiSetBool( rui, "useCustomCharacterColor", true )
	}
	else
	{
		RuiSetBool( rui, "useCustomCharacterColor", false )
	}
}


void function SetCustomPlayerInfoCharacterIcon( entity player, asset customIcon )
{
	if ( !(player in file.customCharacterIcon) )
		file.customCharacterIcon[player] <- customIcon
	file.customCharacterIcon[player] = customIcon
	if ( file.pilotRui != null )
		RuiSetImage( file.pilotRui, "playerIcon", file.customCharacterIcon[player] )
}


void function SetCustomPlayerInfoTreatment( entity player, asset treatmentImage )
{
	if ( !(player in file.customPlayerInfoTreatment) )
		file.customPlayerInfoTreatment[player] <- treatmentImage
	file.customPlayerInfoTreatment[player] = treatmentImage
	if ( file.pilotRui != null )
		RuiSetImage( file.pilotRui, "customTreatment", file.customPlayerInfoTreatment[player] )
}


void function SetCustomPlayerInfoShadowFormState( entity player, bool state )
{
	if ( file.pilotRui != null )
		RuiSetBool( file.pilotRui, "useShadowFormFrame", state )
}


void function SetCustomPlayerInfoColor( entity player, vector characterColor )
{
	if ( !(player in file.customCharacterColor) )
		file.customCharacterColor[player] <- characterColor
	file.customCharacterColor[player] = characterColor
	if ( file.pilotRui != null && player == GetLocalClientPlayer())
	{
		RuiSetColorAlpha( file.pilotRui, "customCharacterColor", SrgbToLinear( file.customCharacterColor[player] / 255.0 ), 1.0 )
		RuiSetBool( file.pilotRui, "useCustomCharacterColor", true )
	}
}


vector function GetPlayerInfoColor( entity player )
{
	if ( player in file.customCharacterColor )
		return file.customCharacterColor[player]

	return GetKeyColor( COLORID_MEMBER_COLOR0, player.GetTeamMemberIndex() )
}


void function ClearCustomPlayerInfoColor( entity player )
{
	if ( player in file.customCharacterColor )
	{
		delete file.customCharacterColor[player]
		RuiSetBool( file.pilotRui, "useCustomCharacterColor", false )
	}
}


void function OverrideHUDHealthFractions( entity player, float targetHealthFrac = -1, float targetShieldFrac = -1 )
{
	if ( targetHealthFrac < 0 )
		RuiTrackFloat( file.pilotRui, "playerTargetHealthFrac", player, RUI_TRACK_STATUS_EFFECT_SEVERITY, eStatusEffect.target_health )
	else
		RuiSetFloat( file.pilotRui, "playerTargetHealthFrac", targetHealthFrac )

	if ( targetShieldFrac < 0 )
		RuiTrackFloat( file.pilotRui, "playerTargetShieldFrac", player, RUI_TRACK_STATUS_EFFECT_SEVERITY, eStatusEffect.target_shields )
	else
		RuiSetFloat( file.pilotRui, "playerTargetShieldFrac", targetShieldFrac )
}


void function RegisterMinimapPackages()
{
	RegisterMinimapPackage( "prop_script", eMinimapObject_prop_script.OBJECTIVE_AREA, MINIMAP_OBJECTIVE_AREA_RUI, Survival_MinimapPackage_ObjectiveAreaInit, $"ui/in_world_minimap_objective_area.rpak", Survival_MinimapPackage_ObjectiveAreaInit )
	RegisterMinimapPackage( "prop_script", eMinimapObject_prop_script.FD_HARVESTER, MINIMAP_OBJECT_RUI, MinimapPackage_PlaneInit )
}

void function MinimapPackage_PlaneInit( entity ent, var rui )
{
	#if MINIMAP_DEBUG
		printt( "Adding 'rui/survival_ship' icon to minimap" )
	#endif
	if ( ent.GetTargetName() != "planeMapEnt" )
		return

	RuiSetImage( rui, "defaultIcon", $"rui/survival_ship" )
	RuiSetImage( rui, "clampedDefaultIcon", $"rui/survival_ship" )
	RuiSetBool( rui, "useTeamColor", false )
}

void function RuiSetObjectRadius( entity ent, var rui )
{
	if ( ent.IsClientOnly() )
		RuiSetFloat( rui, "objectRadius", ent.e.clientEntMinimapScale )
	else
		RuiTrackFloat( rui, "objectRadius", ent, RUI_TRACK_MINIMAP_SCALE )
}


void function Survival_MinimapPackage_ObjectiveAreaInit( entity ent, var rui )
{
	RuiSetFloat( rui, "radiusScale", SURVIVAL_MINIMAP_RING_SCALE )
	RuiSetObjectRadius( ent, rui )
	RuiSetImage( rui, "clampedImage", $"" )
	RuiSetImage( rui, "centerImage", $"" )
	RuiSetBool( rui, "blink", true )

	switch ( ent.GetTargetName() )
	{
		case "safeZone":
			RuiTrackFloat3( rui, "playerPos", GetLocalViewPlayer(), RUI_TRACK_ABSORIGIN_FOLLOW )
			RuiSetColorAlpha( rui, "objColor", SrgbToLinear( SAFE_ZONE_COLOR ), SAFE_ZONE_ALPHA )                      
			RuiSetBool( rui, "drawLine", true )
			break

		case "safeZone_noline":
			                                                                                      
			RuiSetColorAlpha( rui, "objColor", SrgbToLinear( SAFE_ZONE_COLOR ), SAFE_ZONE_ALPHA )                      
			                                     
			break

		case "observerSurveyZone":
			printt( "OBS_SURVEY: inititialising ObsSurveyRui" )
			RuiSetBool( rui, "blink", false )
			RuiSetColorAlpha( rui, "objColor", SrgbToLinear( SAFE_ZONE_COLOR ), SAFE_ZONE_ALPHA )                      

			var nestedRui = RuiCreateNested( rui, "nestedArea", $"ui/minimap_dashed_ellipse_32.rpak" )
			RuiSetColorAlpha( nestedRui, "arcColor", SrgbToLinear( SAFE_ZONE_COLOR ), OBSERVER_SURVEY_ZONE_ALPHA )
			RuiSetFloat( nestedRui, "mapScale", max( Minimap_GetFloatForKey( "scale" ), 1.0 ) )
			RuiSetFloat( nestedRui, "radiusScale", SURVIVAL_MINIMAP_RING_SCALE )
			RuiTrackFloat( nestedRui, "zoomFactor", null, RUI_TRACK_BIG_MAP_ZOOM_SCALE )
			RuiSetObjectRadius( ent, nestedRui )
			break

		case "surveyZone":
			RuiSetBool( rui, "blink", false )
			RuiSetColorAlpha( rui, "objColor", SrgbToLinear( TEAM_COLOR_PARTY / 255.0 ), SAFE_ZONE_ALPHA )                      
			break

                         

		case "trainIcon":
			                          
			                            
			RuiSetBool( rui, "blink", false )
			RuiSetColorAlpha( rui, "objColor", SrgbToLinear( TEAM_COLOR_PARTY / 255.0 ), 1.0 )                      
			break
      

		case "risingWallIconDown":
		case "risingWallIconMoving":
		case "risingWallIconUp":
			RuiSetBool( rui, "blink", false )
			RuiSetColorAlpha( rui, "objColor", SrgbToLinear( TEAM_COLOR_PARTY / 255.0 ), 1.0 )                      
			break

                      

                             
                                                                                     
                                                                                          
                                   
                                          
                                                       
        

                      
                                                                                 
                                                                                          
                                    
                                          
                                                       
        
      

		case "hotZone":
			RuiSetColorAlpha( rui, "objColor", SrgbToLinear( <128, 188, 255> / 255.0 ), 0.25 )
			RuiSetColorAlpha( rui, "objBorderColor", SrgbToLinear( <128, 188, 255> / 255.0 ), 0.5 )
			RuiSetBool( rui, "blink", true )
			RuiSetBool( rui, "borderBlink", true )
			break
		case "airdropClusterWhite":
			RuiSetColorAlpha( rui, "objColor", SrgbToLinear( GetKeyColor( COLORID_HUD_LOOT_TIER1 ) / 255.0 ), 0.25 )
			RuiSetColorAlpha( rui, "objBorderColor", SrgbToLinear( GetKeyColor( COLORID_HUD_LOOT_TIER1 ) / 255.0 ), 0.5 )
			RuiSetBool( rui, "blink", true )
			RuiSetBool( rui, "borderBlink", true )
			break
		case "airdropClusterBlue":
			RuiSetColorAlpha( rui, "objColor", SrgbToLinear( GetKeyColor( COLORID_HUD_LOOT_TIER2 ) / 255.0 ), 0.25 )
			RuiSetColorAlpha( rui, "objBorderColor", SrgbToLinear( GetKeyColor( COLORID_HUD_LOOT_TIER2 ) / 255.0 ), 0.5 )
			RuiSetBool( rui, "blink", true )
			RuiSetBool( rui, "borderBlink", true )
			break
		case "airdropClusterPurple":
			RuiSetColorAlpha( rui, "objColor", SrgbToLinear( GetKeyColor( COLORID_HUD_LOOT_TIER3 ) / 255.0 ), 0.25 )
			RuiSetColorAlpha( rui, "objBorderColor", SrgbToLinear( GetKeyColor( COLORID_HUD_LOOT_TIER3 ) / 255.0 ), 0.5 )
			RuiSetBool( rui, "blink", true )
			RuiSetBool( rui, "borderBlink", true )
			break
		case "airdropClusterGold":
			RuiSetColorAlpha( rui, "objColor", SrgbToLinear( GetKeyColor( COLORID_HUD_LOOT_TIER4 ) / 255.0 ), 0.25 )
			RuiSetColorAlpha( rui, "objBorderColor", SrgbToLinear( GetKeyColor( COLORID_HUD_LOOT_TIER4 ) / 255.0 ), 0.5 )
			RuiSetBool( rui, "blink", true )
			RuiSetBool( rui, "borderBlink", true )
			break
		case "airdropClusterRed":
			RuiSetColorAlpha( rui, "objColor", SrgbToLinear( GetKeyColor( COLORID_HUD_LOOT_TIER5 ) / 255.0 ), 0.25 )
			RuiSetColorAlpha( rui, "objBorderColor", SrgbToLinear( GetKeyColor( COLORID_HUD_LOOT_TIER5 ) / 255.0 ), 0.5 )
			RuiSetBool( rui, "blink", true )
			RuiSetBool( rui, "borderBlink", true )
			break

                         
		case "campfireZone":
			RuiSetColorAlpha( rui, "objColor", SrgbToLinear( <173, 216, 255> / 255.0 ), 0.25 )
			RuiSetColorAlpha( rui, "objBorderColor", SrgbToLinear( <173, 216, 230> / 255.0 ), 0.0 )
			RuiSetBool( rui, "blink", false )
			RuiSetBool( rui, "borderBlink", false )
			break
      

                
		case "craftingZone":
			RuiSetColorAlpha( rui, "objColor", SrgbToLinear( <255, 255, 255> / 255.0 ), 1 )
			RuiSetColorAlpha( rui, "objBorderColor", SrgbToLinear( <235, 207, 52> / 255.0 ), 0 )
			RuiSetAsset( rui, "areaImage", CRAFTING_ZONE_ASSET )
			RuiSetBool( rui, "blink", false )
			break
      

                              
                               
                                                                                                  
                                                                                                       
                                   
                                         
        

                    
                                                                                                   
                                                                                                                
                                    
                                          
        
      

		case ECHO_LOCATOR_TARGET_NAME:
			entity localViewPlayer = GetLocalViewPlayer()
			bool isFriendly = IsFriendlyTeam( localViewPlayer.GetTeam(), ent.GetTeam() )

			if ( isFriendly )
			{
				RuiSetColorAlpha( rui, "objColor", SrgbToLinear( FRIENDLY_COLOR_FX / 255.0 ), 0.3 )
				RuiSetColorAlpha( rui, "objBorderColor", SrgbToLinear( FRIENDLY_COLOR_FX / 255.0 ), 0.5 )
			}
			else
			{
				RuiSetColorAlpha( rui, "objColor", SrgbToLinear( ENEMY_COLOR_FX / 255.0 ), 0.35 )
				RuiSetColorAlpha( rui, "objBorderColor", SrgbToLinear( ENEMY_COLOR_FX / 255.0 ), 0.5 )
			}

			RuiSetBool( rui, "blink", false )
			RuiSetBool( rui, "borderBlink", false )
			break
	}
}


void function CLSurvival_RegisterNetworkFunctions()
{
	if ( IsLobby() )
		return

	                                                             
	                                                                      
	RegisterNetVarTimeChangeCallback( "circleCloseTime", CircleCloseTimeChanged )
	RegisterNetVarTimeChangeCallback( "nextCircleStartTime", NextCircleStartTimeChanged )
	                                                                                           
	                                                                                                   

	RegisterNetworkedVariableChangeCallback_bool( "isHealing", OnIsHealingChanged )
	RegisterNetworkedVariableChangeCallback_ent( "killLeader", KillLeaderChangeCallback )
}


void function ScorebarInitTracking( entity player, var statusRui )
{
	RuiTrackInt( statusRui, "connectedPlayerCount", null, RUI_TRACK_SCRIPT_NETWORK_VAR_GLOBAL_INT, GetNetworkedVariableIndex( "connectedPlayerCount" ) )
	RuiTrackInt( statusRui, "livingPlayerCount", null, RUI_TRACK_SCRIPT_NETWORK_VAR_GLOBAL_INT, GetNetworkedVariableIndex( "livingPlayerCount" ) )
	RuiTrackInt( statusRui, "squadsRemainingCount", null, RUI_TRACK_SCRIPT_NETWORK_VAR_GLOBAL_INT, GetNetworkedVariableIndex( "squadsRemainingCount" ) )
	RuiTrackFloat( statusRui, "deathfieldDistance", player, RUI_TRACK_DEATHFIELD_DISTANCE )
	RuiTrackInt( statusRui, "teamMemberIndex", player, RUI_TRACK_PLAYER_TEAM_MEMBER_INDEX )

	UpdateKillLeaderOnGameStateRui( statusRui )

	if  (GameSateHudIsDisabled())
		RuiSetBool( statusRui, "isVisible", false )

                    
                                                               
       
  
	                                                                                                                        
	                                                                            
	 
		                                                                         
		                                                                                                                                                 
		                                                                                                                                                        
	 
  
}


void function OnHealthPickupTypeChanged( entity player, int kitType )
{
	if ( WeaponDrivenConsumablesEnabled() )
	{
		Consumable_OnSelectedConsumableTypeNetIntChanged( player, kitType )
	}

	if ( !IsLocalViewPlayer( player ) )
		return

	UpdateDpadHud( player )
}


void function UpdateDpadHud( entity player )
{
	if ( !IsValid( player ) || file.pilotRui == null || file.dpadMenuRui == null )
		return

	if ( !IsLocalViewPlayer( player ) )
		return

	PerfStart( PerfIndexClient.SUR_HudRefresh )

	PerfStart( PerfIndexClient.SUR_HudRefresh_1 )
	int healthItems = SURVIVAL_Loot_GetTotalHealthItems( player, eHealthPickupCategory.HEALTH )
	PerfEnd( PerfIndexClient.SUR_HudRefresh_1 )
	RuiSetInt( file.dpadMenuRui, "totalHealthPackCount", healthItems )
	PerfStart( PerfIndexClient.SUR_HudRefresh_2 )
	int shieldItems = SURVIVAL_Loot_GetTotalHealthItems( player, eHealthPickupCategory.SHIELD )
	PerfEnd( PerfIndexClient.SUR_HudRefresh_2 )
	RuiSetInt( file.dpadMenuRui, "totalShieldPackCount", shieldItems )

	int kitType = Survival_Health_GetSelectedHealthPickupType()

                         
                                                                                            
                                                                                                                                                        
   
                                                                  
                                                                            
                                                         
    
                                                                    
                                                                                  
    
   
      
   
                                                                   
                                                                    
   
       

                             
                                                                                           
                                                                                                                                                                   
  
                                                                 
                                                                           
  
     
  
                                                                  
                                                                   
  
       

	if ( kitType != -1 )
	{
		PerfStart( PerfIndexClient.SUR_HudRefresh_3 )
		string kitRef    = SURVIVAL_Loot_GetHealthPickupRefFromType( kitType )

		if ( SURVIVAL_Loot_IsRefValid (kitRef) )                             
		{
			LootData kitData = SURVIVAL_Loot_GetLootDataByRef( kitRef )
			PerfEnd( PerfIndexClient.SUR_HudRefresh_3 )

                           
                                                                                                          
                                                                 
       
         
				RuiSetInt( file.dpadMenuRui, "selectedHealthPickupCount", SURVIVAL_CountItemsInInventory( player, kitRef ) )
			RuiSetImage( file.dpadMenuRui, "selectedHealthPickupIcon", kitData.hudIcon )
			if ( PlayerHasPassive( player, ePassives.PAS_INFINITE_HEAL ) )
				RuiSetBool( file.dpadMenuRui, "isInfinite", true )
			else
				RuiSetBool( file.dpadMenuRui, "isInfinite", false )
		}
		else
		{
			PerfEnd( PerfIndexClient.SUR_HudRefresh_3 )
		}
	}
	else
	{
		RuiSetInt( file.dpadMenuRui, "selectedHealthPickupCount", -1 )
		RuiSetImage( file.dpadMenuRui, "selectedHealthPickupIcon", $"rui/hud/gametype_icons/survival/health_pack_auto" )
	}
	PerfEnd( PerfIndexClient.SUR_HudRefresh )

                   
                   
                                                             
       

	RuiSetInt( file.dpadMenuRui, "healthTypeCount", GetCountForLootType( eLootType.HEALTH ) )

	entity ordnanceWeapon = player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_ANTI_TITAN )
	int ammo              = 0
	asset ordnanceIcon    = $""

	if ( IsValid( ordnanceWeapon ) )
	{
		ammo = SURVIVAL_CountItemsInInventory( player, ordnanceWeapon.GetWeaponClassName() )
		ordnanceIcon = ordnanceWeapon.GetWeaponSettingAsset( eWeaponVar.hud_icon )
	}

	RuiSetImage( file.dpadMenuRui, "ordnanceIcon", ordnanceIcon )
	RuiSetInt( file.dpadMenuRui, "ordnanceCount", ammo )
	RuiSetInt( file.dpadMenuRui, "ordnanceTypeCount", GetCountForLootType( eLootType.ORDNANCE ) )
	RuiSetBool( file.dpadMenuRui, "gadgetChargeUIEnabled", false )
	RuiSetBool( file.dpadMenuRui, "gadgetUIEnabled", true )
	asset gadgetIcon = $"rui/hud/dpad/empty_slot"                         
	LootData lootData = EquipmentSlot_GetEquippedLootDataForSlot( player, "gadgetslot" )
	string equipRef = EquipmentSlot_GetLootRefForSlot( player, "gadgetslot" )
	int maxAmmoCount = 0
	if ( IsLootTypeValid( lootData.lootType ) )
	{
		gadgetIcon   = lootData.hudIcon
		maxAmmoCount = lootData.inventorySlotCount

		entity gadgetWeapon = player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_GADGET )
		if ( IsValid( gadgetWeapon ) )
		{
			ammo = gadgetWeapon.GetWeaponPrimaryClipCount()
                          
                                                                                                                                          
     
                                                                  

                                                              
     
         
		}
	}
	else
	{
		ammo = 0
	}
	RuiSetImage( file.dpadMenuRui, "gadgetIcon", gadgetIcon )
	RuiSetInt( file.dpadMenuRui, "gadgetCount", ammo )
	RuiSetInt( file.dpadMenuRui, "maxGadgetCount", maxAmmoCount )

	int useSurvivalSlotButton = GetConVarInt("gamepad_toggle_survivalSlot_to_weaponInspect")
	bool showGadgetButtonText = true
	if ( useSurvivalSlotButton == 0 )                                         
		showGadgetButtonText = true
	else
		showGadgetButtonText = false
	RuiSetBool( file.dpadMenuRui, "showGadgetButtonText", showGadgetButtonText )

                
		if ( StatusEffect_GetSeverity( player, eStatusEffect.is_boxing ) )
		{
			RuiSetBool( file.dpadMenuRui, "isBoxing", true )
		}
		else
		{
			RuiSetBool( file.dpadMenuRui, "isBoxing", false )
		}
       
}

array<void functionref( bool )> s_callbacks_OnUpdateShowButtonHints
void function AddCallback_OnUpdateShowButtonHints( void functionref( bool ) func )
{
	Assert( !s_callbacks_OnUpdateShowButtonHints.contains( func ) )
	s_callbacks_OnUpdateShowButtonHints.append( func )
}

array<void functionref( entity, ItemFlavor, int )> s_callbacks_OnVictoryCharacterModelSpawned
void function AddCallback_OnVictoryCharacterModelSpawned( void functionref( entity, ItemFlavor, int ) func )
{
	Assert( !s_callbacks_OnVictoryCharacterModelSpawned.contains( func ) )
	s_callbacks_OnVictoryCharacterModelSpawned.append( func )
}

bool s_didScorebarSetup = false
void function GameModeScoreBarRules( var gamestateRui )
{
	if ( !s_didScorebarSetup )
	{
		entity player = GetLocalViewPlayer()
		if ( !IsValid( player ) )
			return

		ScorebarInitTracking( player, gamestateRui )
		RuiSetBool( gamestateRui, "hideSquadsRemaining", GetCurrentPlaylistVarBool( "scorebar_hide_squads_remaining", false ) )
		RuiSetBool( gamestateRui, "hideWaitingForPlayers", GetCurrentPlaylistVarBool( "scorebar_hide_waiting_for_players", false ) )

		s_didScorebarSetup = true

		UpdateGamestateRuiTracking( player )

		               
		file.shouldShowButtonHintsLocal = !ShouldShowButtonHints()
	}

	PerfStart( PerfIndexClient.SUR_ScoreBoardRules_1 )
	PerfStart( PerfIndexClient.SUR_ScoreBoardRules_2 )

	if ( file.shouldShowButtonHintsLocal != ShouldShowButtonHints() )
	{
		entity player = GetLocalViewPlayer()
		if ( !IsValid( player ) )
			return

		bool showButtonHints = ShouldShowButtonHints()

		Minimap_UpdateShowButtonHint()
		ClWeaponStatus_UpdateShowButtonHint()
		if ( file.dpadMenuRui != null )
			RuiSetBool( file.dpadMenuRui, "showButtonHints", showButtonHints )

		  
		foreach ( func in s_callbacks_OnUpdateShowButtonHints )
			func( showButtonHints )

		file.shouldShowButtonHintsLocal = showButtonHints
	}

	PerfEnd( PerfIndexClient.SUR_ScoreBoardRules_2 )

	PerfStart( PerfIndexClient.SUR_ScoreBoardRules_3 )

	float endTime = GetNV_PreGameStartTime()
	if ( endTime > 0.0 )
		RuiSetGameTime( gamestateRui, "endTime", endTime )

	PerfEnd( PerfIndexClient.SUR_ScoreBoardRules_3 )
	PerfEnd( PerfIndexClient.SUR_ScoreBoardRules_1 )
}


void function OnIsHealingChanged( entity player, bool isHealing )
{
	if ( player != GetLocalClientPlayer() )
		return

	bool hideHealth = GetCurrentPlaylistVarBool( "hide_ui_playerinfo", false )
	if ( hideHealth && file.pilotRui != null )
		RuiSetBool( file.pilotRui, "isVisible", isHealing )


	UpdateHealHint( player )
}

void function SetNextCircleDisplayCustom_( NextCircleDisplayCustomData data )
{
	entity localViewPlayer = GetLocalViewPlayer()
	if ( !IsValid( localViewPlayer ) )
		return

	var gamestateRui = ClGameState_GetRui()
	array<var> ruis  = [gamestateRui]
	var cameraRui    = GetCameraCircleStatusRui()
	if ( IsValid( cameraRui ) )
		ruis.append( cameraRui )

	foreach ( rui in ruis )
	{
		RuiTrackFloat3( rui, "playerOrigin", localViewPlayer, RUI_TRACK_ABSORIGIN_FOLLOW )

		RuiSetGameTime( rui, "circleStartTime", data.circleStartTime )
		RuiSetGameTime( rui, "circleCloseTime", data.circleCloseTime )
		RuiSetGameTime( rui, "countdownGoalTime", data.countdownGoalTime )
		RuiSetInt( rui, "roundNumber", data.roundNumber )
		RuiSetString( rui, "roundClosingString", data.roundString )

		RuiSetFloat3( rui, "deathFieldOrigin", data.deathFieldOrigin )
		RuiSetFloat3( rui, "safeZoneOrigin", data.safeZoneOrigin )

		RuiSetFloat( rui, "deathfieldDistance", data.deathfieldDistance )
		RuiSetFloat( rui, "deathfieldStartRadius", data.deathfieldStartRadius )
		RuiSetFloat( rui, "deathfieldEndRadius", data.deathfieldEndRadius )

		RuiSetBool( rui, "hasAltIcon", (data.altIcon != $"") )
		RuiSetImage( rui, "altIcon", data.altIcon )
		RuiSetString( rui, "altIconText", data.altIconText )
		RuiSetColorAlpha( rui, "altColor", data.altColor, 1.0 )
	}
}


void function SetGamestateCountdown( float goalTime, asset altIcon, string altIconText, vector altColor = <1, 1, 1> )
{
	NextCircleDisplayCustomData data
	data.countdownGoalTime = goalTime
	data.altIcon = altIcon
	data.altIconText = altIconText
	data.altColor = altColor
	SetNextCircleDisplayCustom_( data )
}


void function SetGamestateCountdownClear()
{
	NextCircleDisplayCustomData data
	SetNextCircleDisplayCustom_( data )
}


void function SetNextCircleDisplayCustomStarting( float circleStartTime, asset altIcon, string altIconText, vector altColor = <1, 1, 1> )
{
	NextCircleDisplayCustomData data
	data.circleStartTime = circleStartTime
	data.roundNumber = -1
	data.altIcon = altIcon
	data.altIconText = altIconText
	data.altColor = altColor
	SetNextCircleDisplayCustom_( data )
}


void function SetNextCircleDisplayCustomClosing( float circleCloseTime, string prompt, vector altColor = <1, 1, 1> )
{
	NextCircleDisplayCustomData data
	data.circleStartTime = Time() - 4.0
	data.circleCloseTime = circleCloseTime
	data.roundString = prompt
	data.roundNumber = -1
	data.altColor = altColor
	SetNextCircleDisplayCustom_( data )
}


void function SetNextCircleDisplayCustomClear()
{
	NextCircleDisplayCustomData data
	SetNextCircleDisplayCustom_( data )
}

string function GetRingClosingString(int roundNumber)
{
	if ( !SURVIVAL_IsFinalDeathFieldStage() )
		return Localize( "#" + GameRules_GetGameMode().toupper() + "_CIRCLE_STATUS_ROUND_CLOSING", roundNumber )

	return Localize( "#" + GameRules_GetGameMode().toupper() + "_CIRCLE_STATUS_ROUND_CLOSING_FINAL" )
}


string function GetAnnouncementSubtextString(int roundNumber)
{
	if ( !SURVIVAL_IsFinalDeathFieldStage() )
		return Localize( "#" + GameRules_GetGameMode().toupper() + "_CIRCLE_ROUND", roundNumber )

	return Localize( "#" + GameRules_GetGameMode().toupper() + "_CIRCLE_ROUND_FINAL" )
}


void function NextCircleStartTimeChanged( entity player, float new )
{
	if ( !CircleAnnouncementsEnabled() )
		return

	var gamestateRui = ClGameState_GetRui()

	UpdateFullmapRuiTracks()
	array<var> ruis  = [gamestateRui]
	var cameraRui    = GetCameraCircleStatusRui()
	if ( IsValid( cameraRui ) )
		ruis.append( cameraRui )


	int roundNumber    = (SURVIVAL_GetCurrentDeathFieldStage() + 1)
	string roundString = GetRingClosingString(roundNumber)

	float currentRadius      = Cl_SURVIVAL_GetDeathFieldCurrentRadius()
	float endRadius          = currentRadius
	if( SURVIVAL_GetCurrentDeathFieldStage() >= 0 )
	{
		DeathFieldStageData data = Cl_GetDeathFieldStage( SURVIVAL_GetCurrentDeathFieldStage() )
		endRadius            = data.endRadius
	}

	foreach ( rui in ruis )
	{
		RuiSetGameTime( rui, "circleStartTime", new )
		RuiSetInt( rui, "roundNumber", roundNumber )
		RuiSetString( rui, "roundClosingString", roundString )

		entity localViewPlayer = GetLocalViewPlayer()
		if ( IsValid( localViewPlayer ) )
		{
			RuiSetFloat( rui, "deathfieldStartRadius", currentRadius )
			RuiSetFloat( rui, "deathfieldEndRadius", endRadius )
			RuiTrackFloat3( rui, "playerOrigin", localViewPlayer, RUI_TRACK_ABSORIGIN_FOLLOW )

			#if MEMBER_COLORS
				RuiTrackInt( rui, "teamMemberIndex", localViewPlayer, RUI_TRACK_PLAYER_TEAM_MEMBER_INDEX )
			#endif
		}
	}

	if ( new < Time() )
		return

	if ( GamePlaying() && CircleBannerAnnouncementsEnabled() )
	{
		if ( !GetCurrentPlaylistVarBool( "deathfield_starts_after_ship_flyout", true ) && SURVIVAL_GetCurrentDeathFieldStage() == 0 )
			return                                                                      

		roundString = GetAnnouncementSubtextString(roundNumber)

		float duration = 7.0

		AnnouncementData announcement
		announcement = Announcement_Create( "" )
		Announcement_SetSubText( announcement, roundString )
		Announcement_SetHeaderText( announcement, "#SURVIVAL_CIRCLE_WARNING" )
		Announcement_SetDisplayEndTime( announcement, new )
		Announcement_SetStyle( announcement, ANNOUNCEMENT_STYLE_CIRCLE_WARNING )
		Announcement_SetSoundAlias( announcement, CIRCLE_CLOSING_IN_SOUND )
		Announcement_SetPurge( announcement, true )
		Announcement_SetPriority( announcement, 200 )                                                        
		Announcement_SetDuration( announcement, duration )

		AnnouncementFromClass( GetLocalViewPlayer(), announcement )
	}
}


void function CircleCloseTimeChanged( entity player, float new )
{
	var gamestateRui = ClGameState_GetRui()
	array<var> ruis  = [gamestateRui]
	var cameraRui    = GetCameraCircleStatusRui()
	if ( IsValid( cameraRui ) )
		ruis.append( cameraRui )
	foreach ( rui in ruis )
	{
		RuiSetGameTime( rui, "circleCloseTime", new )
	}

	UpdateFullmapRuiTracks()
}


void function InventoryCountChanged( entity player, int new )
{
	ResetInventoryMenu( player )
}


asset function GetArmorIconForTypeIndex( int typeIndex )
{
	switch ( typeIndex )
	{
		case 1:
			return $"rui/hud/gametype_icons/survival/sur_armor_icon_l1"

		case 2:
			return $"rui/hud/gametype_icons/survival/sur_armor_icon_l2"

		case 3:
			return $"rui/hud/gametype_icons/survival/sur_armor_icon_l3"

		default:
			return $""
	}

	unreachable
}


void function EquipmentChanged( entity player, string equipSlot, int new )
{
	int tier          = 0
	EquipmentSlot es  = Survival_GetEquipmentSlotDataByRef( equipSlot )
	asset hudIcon     = es.emptyImage
	int armorCapacity = -1

	bool isEvo   = false
	int evoCount = 0

                         
                                      
  
                                       
   
                                                            
                           
   
  
       

	if ( new > -1 )
	{
		LootData data = SURVIVAL_Loot_GetLootDataByIndex( new )
		tier = data.tier
		hudIcon = data.hudIcon

		if ( data.lootType == eLootType.ARMOR )
		{
			armorCapacity = player.GetShieldHealthMax()
		}

		if ( es.attachmentPoint != "" )
		{
			string attachmentStyle = GetAttachmentPointStyle( es.attachmentPoint, data.ref )
			hudIcon = emptyAttachmentSlotImages[attachmentStyle]
		}
	}

		LootData data = EquipmentSlot_GetEquippedLootDataForSlot( player, "armor" )
		if ( data.lootType == eLootType.ARMOR && EvolvingArmor_IsEquipmentEvolvingArmor( data.ref ) )
		{
			isEvo = true
			evoCount = EvolvingArmor_GetRequirementForEvolution( data.tier )
		}

	if ( player == GetLocalViewPlayer() )
	{
		if ( es.unitFrameTierVar != "" )
		RuiSetInt( file.pilotRui, es.unitFrameTierVar, tier )
		if ( es.unitFrameImageVar != "" )
		RuiSetImage( file.pilotRui, es.unitFrameImageVar, hudIcon )

		if ( armorCapacity >= 0 )
		{
			RuiSetInt( file.pilotRui, "armorShieldCapacity", armorCapacity )
		}
			if ( data.lootType == eLootType.ARMOR )
			{
				if ( EvolvingArmor_IsEquipmentEvolvingArmor( data.ref ) )
				{
					RuiSetBool( file.pilotRui, "evoShieldDoubleDisplayAmount", EvolvingArmor_ExceedsMaxIntLimit( data ) )
					RuiSetBool( file.pilotRui, "isEvolvingShield", isEvo )
					RuiTrackInt( file.pilotRui, "evolvingShieldKillCounter", player, RUI_TRACK_SCRIPT_NETWORK_VAR_INT, GetNetworkedVariableIndex( NV_EVOLVING_ARMOR_KILL_COUNT ) )
				}
				else
				{
					RuiSetBool( file.pilotRui, "isEvolvingShield", false )
				}
			}
			else if ( data.ref == "" )
			{
				RuiSetBool( file.pilotRui, "isEvolvingShield", false )
			}

                               
                                                              
       
			RuiSetBool( file.pilotRui, "hasReducedShieldValues", false )
        

		UpdateActiveLootPings()
	}
	else
	{
		if ( PlayerHasUnitFrame( player ) )
		{
			var rui = GetUnitFrame( player ).rui

			RuiSetInt( rui, "armorShieldCapacity", armorCapacity )
		}
	}

	if ( player == GetLocalClientPlayer() )
	{
		ResetInventoryMenu( player )
	}
}


void function BackpackChanged( entity player, string equipSlot, int new )
{
	int tier         = 0
	EquipmentSlot es = Survival_GetEquipmentSlotDataByRef( equipSlot )
	asset hudIcon    = es.emptyImage

	if ( new > -1 )
	{
		LootData data = SURVIVAL_Loot_GetLootDataByIndex( new )
		tier = data.tier
		hudIcon = data.hudIcon
	}

	if ( player == GetLocalViewPlayer() )
	{
		RuiSetImage( file.dpadMenuRui, "backpackIcon", hudIcon )
		RuiSetInt( file.dpadMenuRui, "backpackTier", tier )
	}
}


void function UpdateActiveLootPings()
{
	entity player           = GetLocalViewPlayer()
	array<entity> waypoints = Waypoints_GetActiveLootPings()
	foreach ( wp in waypoints )
	{
		entity owner = wp.GetOwner()
		if ( owner != player )
		{
			entity lootItem = Waypoint_GetItemEntForLootWaypoint( wp )
			if ( !IsValid( lootItem ) )
				continue

			LootData lootData = SURVIVAL_Loot_GetLootDataByIndex( lootItem.GetSurvivalInt() )
			RuiSetBool( wp.wp.ruiHud, "isImportant", SURVIVAL_IsLootAnUpgrade( player, lootItem, lootData, eLootContext.GROUND ) )
		}
	}
}


void function LinkContestedChanged( entity player, bool old, bool new )
{
	if ( player != GetLocalClientPlayer() )
		return

	if ( player != GetLocalViewPlayer() )
		return

	RuiSetBool( file.titanLinkProgressRui, "isContested", new )
}


void function LinkInUseChanged( entity player, bool old, bool new )
{
	if ( player != GetLocalClientPlayer() )
		return

	if ( player != GetLocalViewPlayer() )
		return

	RuiSetBool( file.titanLinkProgressRui, "isInUse", new )
}


void function OnPilotCockpitCreated( entity cockpit, entity player )
{
	if ( file.pilotRui != null )
		RuiSetBool( file.pilotRui, "isVisible", GetHudDefaultVisibility() )

	if ( PlayerInfoIsDisabled())
		   RuiSetBool( file.pilotRui, "isVisible", false )

	if ( player == GetLocalViewPlayer() )
	{
		RuiTrackBool( file.dpadMenuRui, "inventoryEnabled", GetLocalViewPlayer(), RUI_TRACK_SCRIPT_NETWORK_VAR_BOOL, GetNetworkedVariableIndex( "inventoryEnabled" ) )
		RuiTrackInt( file.dpadMenuRui, "selectedHealthPickup", GetLocalViewPlayer(), RUI_TRACK_SCRIPT_NETWORK_VAR_INT, GetNetworkedVariableIndex( "selectedHealthPickupType" ) )
		RuiTrackFloat( file.dpadMenuRui, "bleedoutEndTime", GetLocalViewPlayer(), RUI_TRACK_SCRIPT_NETWORK_VAR, GetNetworkedVariableIndex( "bleedoutEndTime" ) )

		EquipmentSlot es = Survival_GetEquipmentSlotDataByRef( "backpack" )
		RuiSetImage( file.dpadMenuRui, "backpackIcon", es.emptyImage )
		RuiSetInt( file.dpadMenuRui, "backpackTier", 0 )

		foreach ( equipSlot, data in EquipmentSlot_GetAllEquipmentSlots() )
		{
			if ( data.trackingNetInt != "" )
			{
				EquipmentChanged( GetLocalViewPlayer(), equipSlot, EquipmentSlot_GetEquippedLootDataForSlot( player, equipSlot ).index )
			}
		}
	}
}


void function ToggleFireSelect( entity player )
{
	                                           

	if ( file.nextAllowToggleFireRateTime > Time() )
		return

	file.nextAllowToggleFireRateTime = Time() + 0.05

	entity weapon = player.GetActiveWeapon( eActiveInventorySlot.mainHand )

	if ( !IsValid( weapon ) )
		return

	                                          
		        

	if ( weapon.IsDiscarding() )
		return

	if ( player.GetWeaponDisableFlags() == WEAPON_DISABLE_FLAGS_ALL )
		return

	foreach ( mod, toggleMod in GetAttachmentsWithToggleModsList() )
	{
		if ( IsModActive( weapon, mod ) )
		{
			WeaponModCommand_Toggle( toggleMod )
			return
		}
	}

	bool canToggleAltfire = DoesModExist( weapon, "altfire" ) && !DoesModExist( weapon, "hopup_selectfire" )
                       
		if ( canToggleAltfire && IsModActive( weapon, "hopup_highcal_rounds" ) )	                                                                                                                
			canToggleAltfire = false
       
	if ( canToggleAltfire )
	{
		WeaponModCommand_Toggle( "altfire" )
		return
	}

                           
                                                                                
          
                                              
  
                                                                                                         
                                           
        
  
      


                          
               
                                         
   
                                      
         
   
       


	if ( weapon.GetWeaponClassName() == "mp_weapon_car")
		Weapon_CAR_TryApplyAmmoSwap( player, weapon )

                  
                                                      
                                             
      



	                    
	if ( DoesModExist( weapon, "vertical_firestar" ) )
	{
		WeaponModCommand_Toggle( "vertical_firestar" )
		return
	}

	                      
	if ( DoesModExist( weapon, "double_link_mod" ) )
	{
		WeaponModCommand_Toggle( "double_link_mod" )
		return
	}

               
                                                                                                      
  
                                                                        
        
  
       
}

void function ServerCallback_SUR_PingMinimap( vector origin, float duration, float spreadRadius, float ringRadius, int colorID, float frequency, float frequencyVariation, int airdropType )
{
	asset altIcon = $""
                
	if ( airdropType == eAirdropType.CRAFTING_REPLICATOR )
		altIcon = $"rui/hud/ping/hex_pulse"
      

	vector color = ColorPalette_GetColorFromID(colorID)
	thread ServerCallback_SUR_PingMinimap_Internal( origin, duration, spreadRadius, ringRadius, color, frequency, frequencyVariation, altIcon )
}

void function ServerCallback_SUR_PingMinimap_Internal( vector origin, float duration, float spreadRadius, float ringRadius, vector color, float frequency, float frequencyVariation, asset altIcon = $"" )
{
	entity player = GetLocalViewPlayer()
	player.EndSignal( "OnDestroy" )

	float endTime = Time() + duration

	float randMin = -1 * spreadRadius
	float randMax = spreadRadius

	float pulseDuration = 1.5
	float lifeTime      = 1.5

	float minWait = ( frequency - frequencyVariation )
	float maxWait = min( frequency + frequencyVariation, lifeTime )

	while ( Time() < endTime )
	{
		vector newOrigin = origin + < RandomIntRange( randMin, randMax ), RandomIntRange( randMin, randMax ), 0 >                                       

		Minimap_RingPulseAtLocation( newOrigin, ringRadius, color / 255.0, pulseDuration, lifeTime, false, altIcon )
		FullMap_PingLocation( newOrigin, ringRadius, color / 255.0, pulseDuration, lifeTime, false, altIcon )

		wait RandomFloatRange( minWait, maxWait )
	}
}

void function AllowSuperHint( entity player )
{
	file.superHintAllowed = true
}


void function Survival_OnPlayerClassChanged( entity player )
{
	if ( file.pilotRui == null )
		return

	if ( player != GetLocalViewPlayer() )
		return

	UpdateDpadHud( player )

	if ( player.IsTitan() )
	{
		if ( file.playerState != "titan" )
		{
			ResetInventoryMenu( player )
			file.playerState = "titan"
		}
	}
	else
	{
		bool resetInventory = false

		if ( file.playerState != "pilot" )
		{
			resetInventory = true
			file.playerState = "pilot"
		}

		if ( resetInventory )
		{
			ResetInventoryMenu( player )
		}

		bool isReady = LoadoutSlot_IsReady( ToEHI( player ), Loadout_Character() )
		if ( isReady )
		{
			thread InitSurvivalHealthBar()
		}
	}

	if ( player == GetLocalClientPlayer() )
	{
		thread PeriodicHealHint()
		thread TrackAmmoPool( player )
		thread TrackPrimaryWeapon( player )
		if ( file.pilotRui != null )
			thread TrackPrimaryWeaponEnabled( player, file.pilotRui, "Sur_EndTrackPrimary" )
	}

	ServerCallback_ClearHints()
}

void function OnPropScriptCreated( entity prop )
{
	if ( prop.GetTargetName() == "hotZone" )
		SetMapFeatureItem( 300, "#HOT_ZONE", "#HOT_ZONE_DESC", $"rui/hud/gametype_icons/survival/hot_zone" )
}


void function OnPropCreated( entity prop )
{
	if ( prop.GetSurvivalInt() < 0 )
	{
		PROTO_OnContainerCreated( prop )
		return
	}
}


string function DroppodButtonUseTextOverride( entity prop )
{
	if ( GetLocalViewPlayer().GetParent() != null )
		return " "
	return ""
}


void function OpenSurvivalMenu()
{
	entity player = GetLocalClientPlayer()

	if ( !IsAlive( player ) )
		RunUIScript( "ServerCallback_OpenSurvivalExitMenu", false )
	else
		PROTO_OpenInventoryOrSpecifiedMenu( player )
}


void function AddCallback_PlayerPressedInventory( bool functionref(entity) func )
{
	file.tryAccessInventoryCallbacks.append( func )
}


void function PROTO_OpenInventoryOrSpecifiedMenu( entity player )
{
	HideScoreboard()

	foreach ( func in file.tryAccessInventoryCallbacks )
	{
		if ( !func( player ) )
			return
	}

	if ( IsPrivateMatch() && player.GetTeam() == TEAM_SPECTATOR && GetGameState() >= eGameState.Playing )
		PrivateMatch_OpenGameStatusMenu()
	else
		OpenSurvivalInventory( player )
}


void function OpenQuickSwap( entity player )
{
	thread TryOpenQuickSwap()
}


void function PeriodicHealHint()
{
	while ( IsAlive( GetLocalClientPlayer() ) )
	{
		wait 30.0
		UpdateHealHint( GetLocalClientPlayer() )
	}
}


void function TrackAmmoPool( entity player )
{
	if ( player != GetLocalViewPlayer() )
		return
	if ( player != GetLocalClientPlayer() )
		return

	player.Signal( "Sur_EndTrackAmmo" )
	player.EndSignal( "Sur_EndTrackAmmo" )
	player.EndSignal( "OnDeath" )

	table<string, int> oldAmmo
	foreach ( ammoRef, value in eAmmoPoolType )
	{
		oldAmmo[ ammoRef ] <- 0
	}

	while ( IsAlive( player ) )
	{
		bool resetAmmo = false
		foreach ( ammoRef, value in eAmmoPoolType )
		{
			int ammo = player.AmmoPool_GetCount( value )

			if ( ammo != oldAmmo[ ammoRef ] )
			{
				resetAmmo = true
				oldAmmo[ ammoRef ] = ammo
			}
		}

		if ( resetAmmo )
			ResetInventoryMenu( player )
		WaitFrame()
	}
}


void function TrackPrimaryWeapon( entity player )
{
	if ( player != GetLocalViewPlayer() )
		return

	if ( player != GetLocalClientPlayer() )
		return

	player.Signal( "Sur_EndTrackPrimary" )
	player.EndSignal( "Sur_EndTrackPrimary" )
	player.EndSignal( "OnDeath" )

	entity oldWeapon = player.GetActiveWeapon( eActiveInventorySlot.mainHand )
	int oldBitField  = 0

	if ( oldWeapon != null && oldWeapon.IsWeaponOffhand() )
		oldWeapon = null

	bool firstRun = true

	while ( IsAlive( player ) )
	{
		entity weapon = player.GetActiveWeapon( eActiveInventorySlot.mainHand )
		if ( IsValid( weapon ) && weapon.IsWeaponMelee() )
		{
			WaitFrame()
			continue
		}

		int bitField = 0

		if ( !player.IsTitan() )
		{
			if ( player.GetWeaponDisableFlags() != WEAPON_DISABLE_FLAGS_ALL )
			{
				if ( weapon != null && weapon.IsWeaponOffhand() )
					weapon = IsValid( oldWeapon ) ? oldWeapon : null
			}
			if ( weapon )
				bitField = weapon.GetModBitField()
		}

		if ( (weapon != oldWeapon || bitField != oldBitField || firstRun) )
		{
			firstRun = false

			if ( IsValid( weapon ) && weapon.GetWeaponType() != WT_ANTITITAN )
				file.lastPrimaryWeapon = weapon
			else
				file.lastPrimaryWeapon = null

			ServerCallback_ClearHints()

			if ( IsValid( weapon ) )
			{
				if ( weapon.GetWeaponType() == WT_ANTITITAN )
				{
                                    
					if ( PlayerHasPassive( player, ePassives.PAS_FUSE ) )
					{
						if ( SURVIVAL_GetAllPlayerOrdnance( player ).len() > 1 )
							ServerCallback_SurvivalHint( eSurvivalHints.ORDNANCE_FUSE_MULTI )
						else
							ServerCallback_SurvivalHint( eSurvivalHints.ORDNANCE_FUSE )
					}
					else
           
                   
                                                                                                         
      
                                                
       
                                                                          
       
          
       
                                                                           
       
      
         
           
					{
						if ( SURVIVAL_GetAllPlayerOrdnance( player ).len() > 1 )
							ServerCallback_SurvivalHint( eSurvivalHints.ORDNANCE )
					}
				}
			}

			UpdateActiveLootPings()
			ResetInventoryMenu( player )
			oldWeapon = weapon
			oldBitField = bitField
		}
		WaitFrame()
	}
}


void function ServerCallback_SurvivalHint( int hintType )
{
	string hintString
	float duration = 8.0

	switch ( hintType )
	{
		case eSurvivalHints.EQUIP:
			hintString = "#SURVIVAL_ATTACH_HINT"
			break

		case eSurvivalHints.ORDNANCE:
			duration = 2.0
			hintString = "#SURVIVAL_ORDNANCE_HINT"
			break
                                 
		case eSurvivalHints.ORDNANCE_FUSE:
			duration = 3.0
			hintString = "#FUSE_PASSIVE_TOGGLE_THROW_POWER"
			break

		case eSurvivalHints.ORDNANCE_FUSE_MULTI:
			duration = 3.0
			hintString = "#FUSE_PASSIVE_TOGGLE_THROW_POWER_MULTI"
			break
        
                                 
		case eSurvivalHints.CRYPTO_DRONE_ACCESS:
			duration = 3.0
			hintString = "#CRYPTO_DRONE_ACCESS_HINT"
			break
        
                
                                            
                                         
                                       
        
                                             
                                          
                                      
        
        
		default:
			return
	}
	AddPlayerHint( duration, 0.5, $"", hintString )
}


void function ServerCallback_ClearHints()
{
	HidePlayerHint( "#SURVIVAL_ATTACH_HINT" )
	HidePlayerHint( "#SURVIVAL_DROPPOD_LAUNCH_HINT" )
	HidePlayerHint( "#SURVIVAL_DROPPOD_STEER_HINT" )
	HidePlayerHint( "#SURVIVAL_DROPPOD_ACTIVATE_HINT" )
	HidePlayerHint( "#SURVIVAL_TITAN_HOVER_HINT" )
               
                                       
                                        
       
}


void function SurvivalTitanHoverHint()
{
	ServerCallback_ClearHints()
	wait 4
	AddPlayerHint( 6.0, 0.5, $"", "#SURVIVAL_TITAN_HOVER_HINT" )
}

void function Survival_WaitForPlayers()
{
	file.cameFromWaitingForPlayersState = true
	SetDpadMenuVisible()
	SetMapSetting_FogEnabled( true )
	Minimap_UpdateMinimapVisibility( GetLocalClientPlayer() )
}


void function EnableToggleMuteKeys()
{
	if ( !SquadMuteIntroEnabled() )
		return

	if ( file.toggleMuteKeysEnabled )
		return

	RegisterButtonPressedCallback( BUTTON_Y, OnToggleMute )
	RegisterButtonPressedCallback( KEY_F, OnToggleMute )

	file.toggleMuteKeysEnabled = true
}


void function DisableToggleMuteKeys()
{
	if ( !SquadMuteIntroEnabled() )
		return

	if ( !file.toggleMuteKeysEnabled )
		return

	DeregisterButtonPressedCallback( BUTTON_Y, OnToggleMute )
	DeregisterButtonPressedCallback( KEY_F, OnToggleMute )

	file.toggleMuteKeysEnabled = false
}


void function OnToggleMute( var button )
{
	ToggleSquadMute()
}


void function StreamHintPlayers()
{
	thread (void function() : () {
		array<entity> players = GetPlayerArray_Alive()
		foreach ( player in players )
		{
			if ( !IsValid( player ) )
				continue

			StreamModelHint( player.GetModelName() )
			wait 0.1
		}
	})()
}


bool function GetWaitingForPlayersOverlayEnabled( entity player )
{
	if ( IsTestMap() )
		return false
	if ( player.GetTeam() == TEAM_SPECTATOR )
		return false
	if ( GetCurrentPlaylistVarBool( "survival_staging_area_enabled", false ) )
		return false

	return true
}

var s_overlayRui = null
void function WaitingForPlayersOverlay_Setup( entity player )
{
	if ( !GetWaitingForPlayersOverlayEnabled( player ) )
		return

	s_overlayRui = CreatePermanentCockpitPostFXRui( $"ui/waiting_for_players_blackscreen.rpak", HUD_Z_BASE )
	RuiSetResolutionToScreenSize( s_overlayRui )
	RuiSetBool( s_overlayRui, "isOpaque", PreGame_GetWaitingForPlayersHasBlackScreen() )

	UpdateWaitingForPlayersMuteHint()
}


void function WaitingForPlayersOverlay_Destroy()
{
	if ( s_overlayRui == null )
		return

	RuiDestroyIfAlive( s_overlayRui )
	s_overlayRui = null
}


void function UpdateWaitingForPlayersMuteHint()
{
	if ( !s_overlayRui )
		return

	string muteString = ""
	if ( SquadMuteIntroEnabled() && !IsSoloMode() )
		muteString = Localize( IsSquadMuted() ? "#CHAR_SEL_BUTTON_UNMUTE" : "#CHAR_SEL_BUTTON_MUTE" )
	RuiSetString( s_overlayRui, "squadMuteHint", muteString )
}


void function OnGamestatePlaying()
{
	WaitingForPlayersOverlay_Destroy()
}


void function Survival_RunCharacterSelection()
{
	if ( file.shouldRunCharacterSelectionCallback != null )
	{
		if ( !file.shouldRunCharacterSelectionCallback() )
			return
	}

	SetDpadMenuHidden()
	WaitingForPlayersOverlay_Destroy()
	thread Survival_RunCharacterSelection_Thread()
}


void function Survival_RunCharacterSelection_Thread()
{
	FlagWait( "ClientInitComplete" )

	if ( !Survival_CharacterSelectEnabled() )
		return

	while( GetGlobalNetBool( "characterSelectionReady" ) == false )
		WaitFrame()
	for ( ; ; )
	{
		entity player = GetLocalClientPlayer()
		if ( IsValid( player ) && (player.GetPlayerNetInt( CHARACTER_SELECT_NETVAR_LOCK_STEP_PLAYER_INDEX ) >= 0) )
			break
		WaitFrame()
	}

	Fullmap_SetVisible( false )

	                                                                                                                                    
	CloseCharacterSelectNewMenu()
	WaitFrame()
	OpenCharacterSelectNewMenu()

	while( Time() < GetGlobalNetTime( "allSquadsPresentationStartTime" ) )
		WaitFrame()


	if(Control_IsModeEnabled())
	{
		float startSequenceTime = 6

		CloseCharacterSelectNewMenu()
		thread ShowMatchStartSequence( true, startSequenceTime )

		float savedTime =  Time()
		while( Time() < savedTime + startSequenceTime )
			WaitFrame()

		thread ShowMatchStartSequence( false, startSequenceTime )
	}
                        
                           
  
                                     
                                     

                           
                                                               
                                                     
                                                                             
                                                                        
      
                                

                                                                        
                                                                                  

                                                                               
                                                                         
  
       
	else
	{
		waitthread PanAwayCharacterSelect()

		                         
		if ( GetCurrentPlaylistVarInt( "survival_enable_squad_intro", 1 ) == 1 )
			waitthread DoSquadCardsPresentation("championSquadPresentationStartTime", false)
		else
			CloseCharacterSelectNewMenu()

		if ( GetCurrentPlaylistVarInt( "survival_enable_gladiator_intros", 1 ) == 1 )
			thread DoChampionSquadCardsPresentation("pickLoadoutGamestateEndTime")
	}
}

void function OnGameStateChanged( int newVal )
{
	int gamestate = newVal

	if ( Clubs_AreDisabledByPlaylist() == false && Clubs_AreObituaryTagsEnabledByPlaylist() )
	{
		bool shouldRequestAtLoadoutState
                         
			shouldRequestAtLoadoutState = GameRules_GetGameMode() == GAMEMODE_ARENAS                                                                                                                          
        

		if ( (shouldRequestAtLoadoutState && gamestate == eGameState.PickLoadout) || (!shouldRequestAtLoadoutState && gamestate == eGameState.Playing) )
		{
			array<entity> players = GetPlayerArray()
			int myTeam = GetLocalClientPlayer().GetTeam()
			foreach ( otherPlayer in players )
			{
				if ( otherPlayer.GetTeam() != myTeam )
					otherPlayer.RequestClubData()
			}
		}
	}
	
	var gamestateRui = ClGameState_GetRui()
	if ( gamestateRui == null )
		return

	bool gamestateIsPlaying         = GamePlaying()
	bool gamestateIsEpilogue		= GameEpilogue()
	bool gamestateWaitingForPlayers = gamestate == eGameState.WaitingForPlayers
	RuiSetBool( gamestateRui, "gamestateIsEpilogue", gamestateIsEpilogue )
	RuiSetBool( gamestateRui, "gamestateIsPlaying", gamestateIsPlaying )
	RuiSetBool( gamestateRui, "gamestateWaitingForPlayers", gamestateWaitingForPlayers )
	RuiSetInt( gamestateRui, "gamestate", gamestate )

	                                                                                                
	if (IsFiringRangeGameMode())
	{
		RuiSetBool( gamestateRui, "gamestateIsPlaying", true )
		RuiSetBool( gamestateRui, "gamestateWaitingForPlayers", false )
	}

	if ( file.pilotRui != null )
	{
		RuiSetBool( file.pilotRui, "gamestateIsPlaying", gamestateIsPlaying )
		RuiSetBool( file.dpadMenuRui, "gamestateIsPlaying", gamestateIsPlaying )

		RuiSetBool( file.pilotRui, "gamestateWaitingForPlayers", gamestateWaitingForPlayers )
		RuiSetBool( file.dpadMenuRui, "gamestateWaitingForPlayers", gamestateWaitingForPlayers )
	}

	var netGraphRui = CLGameState_GetNetGraphRui()
	if ( netGraphRui != null )
	{
		float graphAlpha = 1.0
		if ( gamestateWaitingForPlayers )
			graphAlpha = 0.0

		if ( gamestate > eGameState.Playing )
			graphAlpha = 0.0

		string currentPlaylist = GetCurrentPlaylistName()
		if ( currentPlaylist == "survival_training" || currentPlaylist == "survival_firingrange" )
			graphAlpha = 1.0

		RuiSetFloat( netGraphRui, "graphAlpha", graphAlpha )
	}
}


void function OnGamestatePrematch()
{
	SetDpadMenuHidden()
	WaitingForPlayersOverlay_Destroy()
	Minimap_UpdateMinimapVisibility( GetLocalClientPlayer() )

	                                                                                                           
	if ( IsSoloMode() )
		DeathScreen_SetDataRuiAssetForGamemode( SOLO_DEATH_SCREEN_RUI )
}


void function SetDpadMenuVisible()
{
	Assert( IsValid(file.dpadMenuRui) )
	if (!DpadHudIsDisabled())
		RuiSetBool( file.dpadMenuRui, "isVisible", GetHudDefaultVisibility() )
	else SetDpadMenuHidden()
}


void function SetDpadMenuHidden()
{
	Assert( IsValid(file.dpadMenuRui) )
	RuiSetBool( file.dpadMenuRui, "isVisible", false )
}


void function Survival_ClearHints()
{
	UpdateHealHint( GetLocalViewPlayer() )
}


void function ServerCallback_PlayerBootsOnGround()
{
	NotifyDropSequence( false )

	Signal( GetLocalClientPlayer(), "DroppodLanded" )
	Fullmap_ClearInWorldMinimaps()

	DoF_LerpFarDepthToDefault( 0.5 )
	DoF_LerpNearDepthToDefault( 0.5 )
	SetConVarFloat( "dof_variable_blur", 0.0 )
}

void function ServerCallback_AnnounceCircleClosing()
{
	if ( !CircleAnnouncementsEnabled() )
		return

	float duration            = 4.0
	string circleClosingSound = "survival_circle_close_alarm_02"
                                                
		if ( IsFallLTM() || IsShadowRoyaleMode() )
			circleClosingSound = "survival_circle_close_alarm_02_ss"
       

	AnnouncementData announcement = Announcement_Create( Localize( "#SURVIVAL_CIRCLE_STARTING" ) )
	Announcement_SetSoundAlias( announcement, circleClosingSound )
	Announcement_SetStyle( announcement, ANNOUNCEMENT_STYLE_CIRCLE_WARNING )
	Announcement_SetPurge( announcement, true )
	Announcement_SetOptionalTextArgsArray( announcement, [ "true" ] )
	Announcement_SetPriority( announcement, 200 )                                                        
	announcement.duration = duration
	AnnouncementFromClass( GetLocalViewPlayer(), announcement )
}


void function Sur_OnBleedoutStarted( entity victim, float endTime )
{
	if ( victim != GetLocalViewPlayer() )
		return

	RuiSetGameTime( file.pilotRui, "bleedoutEndTime", endTime )
	RuiSetBool( file.pilotRui, "isDowned", true )

                                
                                                     
  
                                                 
  
      

	if ( victim == GetLocalClientPlayer() )
		RunUIScript( "TryCloseSurvivalInventory", null )
}


void function Sur_OnBleedoutEnded( entity victim )
{
	if ( victim != GetLocalViewPlayer() )
		return

	RuiSetGameTime( file.pilotRui, "bleedoutEndTime", 0.0 )
	RuiSetBool( file.pilotRui, "isDowned", false )

                
		RuiSetBool( file.pilotRui, "isCrippled", false )
       
}


bool function DontCreatePlayerRuisForEnemies( entity ent )
{
	if ( ent.IsPlayer() || ent.IsNPC() )
	{
		if ( IsPVEMode() && !IsSingleTeamMode() )
		{
			if ( ent.IsPlayer() && IsFriendlyTeam( ent.GetTeam(), GetLocalViewPlayer().GetTeam() ) )
			{
				return true
			}
			else
			{
				return false
			}
		}

		if ( GameMode_DoesModeDisplayIconsForAllFriendlyTeams( GameRules_GetGameMode() ) )
		{
			if ( IsFriendlyTeam( ent.GetTeam(), GetLocalViewPlayer().GetTeam() ) )
				return true
		}

		if ( ent.GetTeam() != GetLocalViewPlayer().GetTeam() && GetLocalViewPlayer().GetTeam() != TEAM_SPECTATOR )                                                                                                                                          
		{
			return false
		}
	}

	return true
}


void function MarkDpadAsBlocked( bool isBlocked )
{
	if ( file.dpadMenuRui != null )
		RuiSetBool( file.dpadMenuRui, "dpadNotAvailable", isBlocked )
}

                                    
                                    
                                    
                                    
                                    
struct PROTO_LootContainerState
{
	entity container
	bool   isLit = false
	entity light = null
}

bool proto_isContainerThinkRunning = false
array<PROTO_LootContainerState> proto_lootContainerStateList = []
void function PROTO_OnContainerCreated( entity container )
{
	PROTO_LootContainerState state
	state.container = container
	proto_lootContainerStateList.append( state )

	if ( !proto_isContainerThinkRunning )
	{
		thread PROTO_ContainersThink()
	}

	                            
}


void function PROTO_ContainersThink()
{
	proto_isContainerThinkRunning = true
	while( true )
	{
		if ( proto_lootContainerStateList.len() == 0 )
		{
			proto_isContainerThinkRunning = false
			return
		}

		entity player = GetLocalViewPlayer()

		array<int> stateIndexesToRemove = []
		foreach ( int stateIndex, PROTO_LootContainerState state in proto_lootContainerStateList )
		{
			if ( !IsValid( state.container ) )
			{
				stateIndexesToRemove.append( stateIndex )
				continue
			}

			float dist           = Distance2D( state.container.GetWorldSpaceCenter(), player.GetWorldSpaceCenter() )
			float fullOnPoint    = 100.0
			float offPoint       = 120.0
			bool shouldBecomeLit = (dist < offPoint)
			                                            

			if ( shouldBecomeLit )
			{
				if ( !state.isLit )
				{
					state.light = CreateClientSideDynamicLight( state.container.GetWorldSpaceCenter(), <0, 0, 0>, <0, 0, 0>, 0.0 )
					                                                                                                      
					state.isLit = true
				}
			}
			else                           
			{
				if ( state.isLit )
				{
					state.light.Destroy()
					state.light = null
					state.isLit = false
				}
			}

			if ( state.isLit )
			{
				vector lightCol  = <0, 1, 1>
				float brightness = GraphCapped( dist, fullOnPoint, offPoint, 1.0, 0.0 )
				state.light.SetLightColor( lightCol * brightness )
				state.light.SetLightRadius( 220.0 )
			}
		}

		for ( int i = stateIndexesToRemove.len() - 1; i >= 0; i-- )
		{
			PROTO_LootContainerState state = proto_lootContainerStateList[ stateIndexesToRemove[i] ]
			if ( state.light != null )
			{
				state.light.Destroy()
			}
			proto_lootContainerStateList.fastremove( stateIndexesToRemove[i] )
		}

		wait 0.1
	}
}


void function ClientCodeCallback_OnTryCycleOrdnance( entity player )
{
	if ( player == GetLocalClientPlayer() && player == GetLocalViewPlayer() && !Fullmap_IsVisible() )
	{
		entity weapon = player.GetActiveWeapon( eActiveInventorySlot.mainHand )

		if ( IsValid( weapon ) && player.GetWeaponDisableFlags() != WEAPON_DISABLE_FLAGS_ALL )
		{
			if ( weapon.GetWeaponType() == WT_ANTITITAN )
			{
				array<string> allOrdnance = SURVIVAL_GetAllPlayerOrdnance( player )

				if ( allOrdnance.len() > 1 || !allOrdnance.contains( weapon.GetWeaponClassName() ) )
				{
					Remote_ServerCallFunction( "ClientCallback_Sur_SwapToNextOrdnance" )
				}
			}
		}
	}
}


void function CrouchPressed( entity player )
{
	if ( !GetCurrentPlaylistVarBool( "survival_autoprompt_taunt_on_crouch_spam", false ) )
		return

	if ( player != GetLocalClientPlayer() || player != GetLocalViewPlayer() )
		return

	if ( IsPlayerInCryptoDroneCameraView( player ) )
		return
                     
	if ( HoverVehicle_IsPlayerInAnyVehicle( player ) )
		return
      
	if ( Time() - file.lastPressedCrouchTime > CROUCH_SPAM_DETECT_TIMEOUT )
		file.crouchSpamCount = 0
	else
		file.crouchSpamCount += 1

	file.lastPressedCrouchTime = Time()

	if ( file.crouchSpamCount == 4 )
	{
		ServerCallback_PromptTaunt()
	}
}


void function ReloadPressed( entity player )
{
	player.Signal( "ReloadPressed" )

	if ( player != GetLocalClientPlayer() || player != GetLocalViewPlayer() )
		return

	int weaponDisableFlags = player.GetWeaponDisableFlags()
	if ( weaponDisableFlags == WEAPON_DISABLE_FLAGS_ALL )
		return

	entity weapon = player.GetActiveWeapon( eActiveInventorySlot.mainHand )

	if ( !IsValid( weapon ) )
		return

	if ( weapon.GetWeaponType() == WT_ANTITITAN )
		return

	if ( weapon.GetWeaponPrimaryClipCountMax() <= 0 || !weapon.GetWeaponSettingBool( eWeaponVar.uses_ammo_pool ) || player.AmmoPool_GetCount( weapon.GetWeaponAmmoPoolType() ) > 0 )
		return

	bool isUsePressed   = player.IsInputCommandPressed( IN_USE )
	entity playerUseEnt = player.GetUseEntity()
	if ( isUsePressed && playerUseEnt != null )
		return

	NotifyReloadAttemptButNoReserveAmmo()
}


void function UsePressed( entity player )
{
	int gamepadUseType = GetConVarInt( "gamepad_use_type" )
	if ( gamepadUseType == eGamepadUseSchemeType.TAP_TO_USE_HOLD_TO_RELOAD && player == GetLocalClientPlayer() && player == GetLocalViewPlayer() )
	{
		if ( !player.HasUsePrompt() )
		{
			entity weapon = player.GetActiveWeapon( eActiveInventorySlot.mainHand )
			if ( IsValid( weapon ) && player.GetWeaponDisableFlags() != WEAPON_DISABLE_FLAGS_ALL )
			{
				if ( !weapon.GetWeaponSettingBool( eWeaponVar.reload_enabled ) )
					return

				if ( weapon.GetWeaponType() == WT_ANTITITAN )
				{
					array<string> allOrdnance = SURVIVAL_GetAllPlayerOrdnance( player )

                                    
					if ( PlayerHasPassive( player, ePassives.PAS_FUSE ) )
					{
						if ( allOrdnance.len() > 1 )
							ServerCallback_SurvivalHint( eSurvivalHints.ORDNANCE_FUSE_MULTI )
						else
							ServerCallback_SurvivalHint( eSurvivalHints.ORDNANCE_FUSE )
					}
					else
           
					{
						if ( allOrdnance.len() > 1 )
							ServerCallback_SurvivalHint( eSurvivalHints.ORDNANCE )
					}
				}
				else if ( IsControllerModeActive() && player.AmmoPool_GetCount( weapon.GetWeaponAmmoPoolType() ) > 0 )
				{
					float lowAmmoFrac = weapon.GetWeaponSettingFloat( eWeaponVar.low_ammo_fraction )

					float weaponClipMax = float( weapon.GetWeaponPrimaryClipCountMax() )
					float currClipCount = float( weapon.GetWeaponPrimaryClipCount() )
					float ammoFrac      = 0
					if ( weaponClipMax > 0 )
						ammoFrac = currClipCount / weaponClipMax

					if ( weaponClipMax > currClipCount && ammoFrac > lowAmmoFrac )
						AddPlayerHint( 2.0, 0.5, $"", "#HINT_RELOAD_TAP_TO_USE" )
				}
			}
		}
	}
}

void function UpdateFallbackMatchmaking( string fallbackPlaylistName, string fallbackStatusText )
{
	if ( fallbackPlaylistName == "" )
	{
		if ( file.fallbackMMRui != null )
			RuiDestroy( file.fallbackMMRui )

		file.fallbackMMRui = null
		return
	}

	if ( file.fallbackMMRui == null )
	{
		file.fallbackMMRui = RuiCreate( $"ui/fallback_status_text.rpak", clGlobal.topoFullScreen, RUI_DRAW_HUD, 100 )
		RuiSetGameTime( file.fallbackMMRui, "queueStartTime", Time() )
	}

	string playlistName = Localize( GetPlaylistVarString( fallbackPlaylistName, "name", "Undefined: " + fallbackPlaylistName ) )

	RuiSetString( file.fallbackMMRui, "fallbackPlaylistText", playlistName )
	RuiSetString( file.fallbackMMRui, "fallbackStatusText", fallbackStatusText )
}


void function PROTO_ServerCallback_Sur_HoldForUltimate()
{
	AddPlayerHint( 4.0, 0.25, $"", "Hold %offhand4%" )
}

void function SetVictorySequenceEffectPackage( vector position, vector angles, asset effect )
{
	file.victoryEffectData.position = position
	file.victoryEffectData.angles = angles
	file.victoryEffectData.effect = effect

	PrecacheParticleSystem( effect )
}

void function SetVictorySequenceLocation( vector position, vector angles )
{
	file.victorySequencePosition = position
	file.victorySequenceAngles = angles
}


void function SetVictorySequenceSunSkyIntensity( float sunIntensity, float skyIntensity )
{
	file.victorySunIntensity = sunIntensity
	file.victorySkyIntensity = skyIntensity
}


void function ServerCallback_MatchEndAnnouncement( bool victory, int winningTeam )
{
	clGlobal.levelEnt.Signal( "SquadEliminated" )

	DeathScreenCreateNonMenuBlackBars()
	DeathScreenUpdate()
	entity clientPlayer = GetLocalClientPlayer()
	Assert( IsValid( clientPlayer ) )

	bool isPureSpectator = clientPlayer.GetTeam() == TEAM_SPECTATOR

	                                                                                                                                
	if ( clientPlayer.GetTeam() == winningTeam || IsAlive( clientPlayer ) || isPureSpectator )
		ShowChampionVictoryScreen( winningTeam )
}

void function SetVictoryScreenTeamName( string teamName )
{
	file.victoryScreenTeamOverride = teamName
}

void function ShowChampionVictoryScreen( int winningTeam )
{
	if ( file.youAreChampionSplashRui != null )
		return

	                                                                                               
	HideGladiatorCardSidePane( true )
	UpdateRespawnStatus( eRespawnStatus.NONE )

	bool onWinningTeam
	if ( IsPrivateMatch() )
		onWinningTeam = GetLocalClientPlayer().GetTeam() == winningTeam
	else
		onWinningTeam = GetLocalViewPlayer().GetTeam() == winningTeam

	if ( file.onPreVictoryScreenCallback != null )
	{
		file.onPreVictoryScreenCallback( onWinningTeam )
	}

	asset ruiAsset = GetChampionScreenRuiAsset()
	asset mainRuiAsset = $"ui/champion_screen_holder.rpak"
	file.youAreChampionSplashRui = CreateFullscreenRui( mainRuiAsset, 5000 )
	var rui = RuiCreateNested( file.youAreChampionSplashRui, "title", ruiAsset )
	RuiSetGameTime( file.youAreChampionSplashRui, "startTime", Time() )

	RuiSetBool( rui, "onWinningTeam", onWinningTeam )
	RuiSetBool( file.youAreChampionSplashRui, "onWinningTeam", onWinningTeam )

	if( file.victoryScreenTeamOverride != "" )
	{
		string locID = onWinningTeam ? "#GAMEMODE_CLUB_ARE_THE" : "#TEAM_WINS"
		string topLineText = Localize( locID, file.victoryScreenTeamOverride.toupper() )

		RuiSetString( rui, "topLineText", topLineText )
		RuiSetString( file.youAreChampionSplashRui, "topLineText", topLineText )
	}
	else if ( onWinningTeam )
	{
		if ( GetBugReproNum() == 8675309 )
		{
			RuiSetString( rui, "topLineText", "WWWWWWWWWWWWWWWW" )
		}
		else if ( GetClubPartyBool() == true )
		{
			string clubName = Clubs_GetMyStoredClubName()
			if( clubName != CLUB_NAME_EMPTY )
			{
				clubName = Localize( "#GAMEMODE_CLUB_ARE_THE", clubName.toupper() )
				RuiSetString( rui, "topLineText", clubName )
				RuiSetString( file.youAreChampionSplashRui, "topLineText", clubName )
			}
		}
	}

	if ( s_championScreenExtraFunc != null )
		s_championScreenExtraFunc( rui )

                         
		if ( !Control_IsModeEnabled() )
       
		{
			EmitSoundOnEntity( GetLocalClientPlayer(), GetChampionScreenSound() )
		}
			
	Chroma_VictoryScreen()
}

string function GetChampionScreenSound()
{
	if ( file.customChampionScreenSound != "" )
		return file.customChampionScreenSound

	return "UI_InGame_ChampionVictory"
}

asset function GetChampionScreenRuiAsset()
{
	if ( file.customChampionScreenRuiAsset != $"" )
		return file.customChampionScreenRuiAsset

	return $"ui/champion_screen.rpak"
}

void functionref( var ) s_championScreenExtraFunc = null
void function SetChampionScreenRuiAssetExtraFunc( void functionref( var ) func )
{
	s_championScreenExtraFunc = func
}


void function SetChampionScreenRuiAsset( asset ruiAsset )
{
	file.customChampionScreenRuiAsset = ruiAsset
}

void function SetChampionScreenSound( string alias )
{
	file.customChampionScreenSound = alias
}

void function SetPreVictoryScreenCallback( void functionref(bool) func )
{
	file.onPreVictoryScreenCallback = func
}

void function ShowSquadSummary()
{
	entity player = GetLocalClientPlayer()
	EndSignal( player, "OnDestroy" )
}

void function ServerCallback_AddWinningSquadData( int index, int eHandle, int kills, int assists, int knockdowns, int damageDealt, int survivalTime, int revivesGiven, int respawnsGiven,
													bool displayData3IsTime, int displayData0, int displayData1, int displayData2, int displayData3, int displayData4, int displayData5, int displayData6, int resultFlags, int scoreFlags )
{
	if ( index == -1 )
	{
		file.winnerSquadSummaryData.playerData.clear()
		file.winnerSquadSummaryData.squadPlacement = -1
		file.winnerSquadSummaryData.gameResultFlags = 0
		file.winnerSquadSummaryData.gameScoreFlags = 0
		return
	}

	SquadSummaryPlayerData data
	data.eHandle = eHandle
	data.kills = kills
	data.assists = assists
	data.knockdowns = knockdowns
	data.damageDealt = damageDealt
	data.survivalTime = survivalTime
	data.revivesGiven = revivesGiven
	data.respawnsGiven = respawnsGiven

	data.summary3IsTime = displayData3IsTime

	SummaryDisplayData displayData
	for ( int j = 0; j < NUMBER_OF_SUMMARY_DISPLAY_VALUES; j++ )
	{
		data.modeSpecificSummaryData.append( clone displayData )
	}

	data.modeSpecificSummaryData[0].displayValue = displayData0
	data.modeSpecificSummaryData[1].displayValue = displayData1
	data.modeSpecificSummaryData[2].displayValue = displayData2
	data.modeSpecificSummaryData[3].displayValue = displayData3
	data.modeSpecificSummaryData[4].displayValue = displayData4
	data.modeSpecificSummaryData[5].displayValue = displayData5
	data.modeSpecificSummaryData[6].displayValue = displayData6

	if ( file.getSquadSummaryDisplayStringsCallback != null )
		file.getSquadSummaryDisplayStringsCallback( data )
	else
		PopulateSummaryDataStrings( data, GameRules_GetGameMode() )

	file.winnerSquadSummaryData.playerData.append( data )
	file.winnerSquadSummaryData.squadPlacement = 1

	file.winnerSquadSummaryData.gameScoreFlags = scoreFlags
	file.winnerSquadSummaryData.gameResultFlags = resultFlags
}


SquadSummaryData function GetSquadSummaryData()
{
	return file.squadSummaryData
}


SquadSummaryData function GetWinnerSquadSummaryData()
{
	return file.winnerSquadSummaryData
}

#if DEV
                                                                                                                                      
void function Dev_ShowVictorySequence()
{
	ServerCallback_AddWinningSquadData( -1, -1, 0, 0, 0, 0, 0, 0, 0,
										true, 0, 0, 0, 0, 0, 0, 0, 0, 0 )


	foreach ( int i, entity player in GetPlayerArrayOfTeam( GetLocalClientPlayer().GetTeam() ) )
		ServerCallback_AddWinningSquadData( i, player.GetEncodedEHandle(), 2, 3, 4, 1234, 600, 3, 1,
										    true, 2, 3, 4, 1234, 600, 3, 1, 123, 456 )
	thread ShowVictorySequence( false, true )
}

void function Dev_AdjustVictorySequence()
{
	ServerCallback_AddWinningSquadData( -1, -1, 0, 0, 0, 0, 0, 0, 0,
										true, 0, 0, 0, 0, 0, 0, 0, 0, 0 )
	foreach ( int i, entity player in GetPlayerArrayOfTeam( GetLocalClientPlayer().GetTeam() ) )
		ServerCallback_AddWinningSquadData( i, player.GetEncodedEHandle(), 2, 3, 4, 1234, 600, 3, 1,
										    true, 2, 3, 4, 1234, 600, 3, 1, 123, 456 )
	GetLocalClientPlayer().FreezeControlsOnClient()
	thread ShowVictorySequence( true, true )
}

void function Dev_SpoofMatchData()
{
	int i = 0
    entity player = GetLocalClientPlayer()
	ServerCallback_AddWinningSquadData( i, player.GetEncodedEHandle(), 2, 3, 4, 1234, 600, 3, 1,
	                                    true, 2, 3, 4, 1234, 600, 3, 1, 123, 456 )
}
#endif
 
void function OnGamestateResolution()
{
	if ( IsPVEMode() )
		return

                         
	if ( ShGameModeExplore_IsActive() )
		return
       

	if ( IsShowingVictorySequence() )
		return

	thread ShowVictorySequence()
}

void function SetSquadDataToLocalTeam()
{
	entity player = GetLocalClientPlayer()

	int maxTrackedSquadMembers = PersistenceGetArrayCount( "lastGameSquadStats" )

	#if DEV
		printt( "PD: Reading Match Summary Persistet Vars for", player, "and", maxTrackedSquadMembers, "maxTrackedSquadMembers" )
	#endif

	file.squadSummaryData.playerData.clear()
	for ( int i = 0 ; i < maxTrackedSquadMembers ; i++ )
	{
		int eHandle = player.GetPersistentVarAsInt( "lastGameSquadStats[" + i + "].eHandle" )

		#if DEV
			printt( "PD: ", i, "eHandle", player.GetPersistentVarAsInt( "lastGameSquadStats[" + i + "].eHandle" ) )
		#endif

		if ( eHandle <= 0 )
			continue

		SquadSummaryPlayerData data

		data.eHandle = eHandle
		data.kills = player.GetPersistentVarAsInt( "lastGameSquadStats[" + i + "].kills" )
		data.assists = player.GetPersistentVarAsInt( "lastGameSquadStats[" + i + "].assists" )
		data.knockdowns = player.GetPersistentVarAsInt( "lastGameSquadStats[" + i + "].knockdowns" )
		data.damageDealt = player.GetPersistentVarAsInt( "lastGameSquadStats[" + i + "].damageDealt" )
		data.survivalTime = player.GetPersistentVarAsInt( "lastGameSquadStats[" + i + "].survivalTime" )
		data.revivesGiven = player.GetPersistentVarAsInt( "lastGameSquadStats[" + i + "].revivesGiven" )
		data.respawnsGiven = player.GetPersistentVarAsInt( "lastGameSquadStats[" + i + "].respawnsGiven" )

		                             
		data.summary3IsTime = expect bool( player.GetPersistentVar( "lastGameSquadStats[" + i + "].displayData3IsTime" ) )

		SummaryDisplayData displayData
		for ( int j = 0; j < NUMBER_OF_SUMMARY_DISPLAY_VALUES; j++ )
		{
			data.modeSpecificSummaryData.append( clone displayData )
		}

		data.modeSpecificSummaryData[0].displayValue = player.GetPersistentVarAsInt( "lastGameSquadStats[" + i + "].displayData1" )
		data.modeSpecificSummaryData[1].displayValue = player.GetPersistentVarAsInt( "lastGameSquadStats[" + i + "].displayData1a" )
		data.modeSpecificSummaryData[2].displayValue = player.GetPersistentVarAsInt( "lastGameSquadStats[" + i + "].displayData1b" )
		data.modeSpecificSummaryData[3].displayValue = player.GetPersistentVarAsInt( "lastGameSquadStats[" + i + "].displayData2" )
		data.modeSpecificSummaryData[4].displayValue = player.GetPersistentVarAsInt( "lastGameSquadStats[" + i + "].displayData3" )
		data.modeSpecificSummaryData[5].displayValue = player.GetPersistentVarAsInt( "lastGameSquadStats[" + i + "].displayData4" )
		data.modeSpecificSummaryData[6].displayValue = player.GetPersistentVarAsInt( "lastGameSquadStats[" + i + "].displayData5" )
		                    

		if ( file.getSquadSummaryDisplayStringsCallback != null )
			file.getSquadSummaryDisplayStringsCallback( data )
		else
			PopulateSummaryDataStrings( data, expect string( player.GetPersistentVar( "lastGameMode" ) ) )

		#if DEV
			printt( "PD: ", i, "kills", player.GetPersistentVarAsInt( "lastGameSquadStats[" + i + "].kills" ) )
			printt( "PD: ", i, "assists", player.GetPersistentVarAsInt( "lastGameSquadStats[" + i + "].assists" ) )
			printt( "PD: ", i, "knockdowns", player.GetPersistentVarAsInt( "lastGameSquadStats[" + i + "].knockdowns" ) )
			printt( "PD: ", i, "damageDealt", player.GetPersistentVarAsInt( "lastGameSquadStats[" + i + "].damageDealt" ) )
			printt( "PD: ", i, "survivalTime", player.GetPersistentVarAsInt( "lastGameSquadStats[" + i + "].survivalTime" ) )
			printt( "PD: ", i, "revivesGiven", player.GetPersistentVarAsInt( "lastGameSquadStats[" + i + "].revivesGiven" ) )
			printt( "PD: ", i, "respawnsGiven", player.GetPersistentVarAsInt( "lastGameSquadStats[" + i + "].respawnsGiven" ) )

			printt( "PD: ", i, "displayData3IsTime", expect bool( player.GetPersistentVar( "lastGameSquadStats[" + i + "].displayData3IsTime" ) ) )
			printt( "PD: ", i, "displayData1", player.GetPersistentVarAsInt( "lastGameSquadStats[" + i + "].displayData1" ) )
			printt( "PD: ", i, "displayData1a", player.GetPersistentVarAsInt( "lastGameSquadStats[" + i + "].displayData1a" ) )
			printt( "PD: ", i, "displayData1b", player.GetPersistentVarAsInt( "lastGameSquadStats[" + i + "].displayData1b" ) )
			printt( "PD: ", i, "displayData2", player.GetPersistentVarAsInt( "lastGameSquadStats[" + i + "].displayData2" ) )
			printt( "PD: ", i, "displayData3", player.GetPersistentVarAsInt( "lastGameSquadStats[" + i + "].displayData3" ) )
			printt( "PD: ", i, "displayData4", player.GetPersistentVarAsInt( "lastGameSquadStats[" + i + "].displayData4" ) )
			printt( "PD: ", i, "displayData5", player.GetPersistentVarAsInt( "lastGameSquadStats[" + i + "].displayData5" ) )
		#endif

		file.squadSummaryData.playerData.append( data )
	}

	file.squadSummaryData.squadPlacement = player.GetPersistentVarAsInt( "lastGameRank" )
	file.squadSummaryData.gameResultFlags = player.GetPersistentVarAsInt( "lastGameResultFlags" )
	file.squadSummaryData.gameScoreFlags = player.GetPersistentVarAsInt( "lastGameScoreFlags" )

	#if DEV
		printt( "PD: squadPlacement", player.GetPersistentVarAsInt( "lastGameRank" ) )
	#endif

}


void function VictorySequenceOrderLocalPlayerFirst( entity player )
{
	int playerEHandle   = player.GetEncodedEHandle()
	bool hadLocalPlayer = false
	array<SquadSummaryPlayerData> playerDataArray
	SquadSummaryPlayerData localPlayerData

	foreach ( SquadSummaryPlayerData data in file.winnerSquadSummaryData.playerData )
	{
		if ( data.eHandle == playerEHandle )
		{
			localPlayerData = data
			hadLocalPlayer = true
			continue
		}

		playerDataArray.append( data )
	}

	file.winnerSquadSummaryData.playerData = playerDataArray
	if ( hadLocalPlayer )
		file.winnerSquadSummaryData.playerData.insert( 0, localPlayerData )
}

array<entity> function GetTeamPlayers( bool friendly )
{
	if ( IsLocalPlayerOnTeamSpectator() )
		return []

	entity localPlayer = GetLocalClientPlayer()
	array<entity> friendlies = GetPlayerArrayOfTeam( localPlayer.GetTeam() )

	int enemyTeam = GetOtherTeam( GetLocalClientPlayer().GetTeam() )
	array<entity> enemies = GetPlayerArrayOfTeam( enemyTeam )

                         
		if ( Control_IsModeEnabled() )
		{
			friendlies.clear()
			enemies.clear()
			foreach( matchPlayer in GetPlayerArray() )
			{
				if ( IsValid( matchPlayer ) && AllianceProximity_GetAllianceFromTeam( matchPlayer.GetTeam() ) == AllianceProximity_GetAllianceFromTeam( GetLocalClientPlayer().GetTeam() ) )
				{
					friendlies.append( matchPlayer )
				}
				else if ( IsValid( matchPlayer ) )
				{
					enemies.append( matchPlayer )
				}
			}
		}
                               

	array<entity> teamPlayers = friendly ? friendlies : enemies
	return teamPlayers
}

int function VictorySequence_GetPlayerTeamFromEHI( EHI playerEHI )
{
	Assert( EHIHasValidScriptStruct( playerEHI ), "Tried to run VictorySequence_GetPlayerTeamFromEHI on an invalid EHI handle" )

	int playerTeam
                         
		                                                                                                                            
		                                                                                                                                      
		if ( Control_IsModeEnabled() )
		{
			playerTeam = AllianceProximity_GetOriginalPlayerTeam_FromPlayerEHI( playerEHI )
		}
		else
                               
		{
			playerTeam = EHI_GetTeam( playerEHI )
		}

	return playerTeam
}

void function ShowMatchStartSequence( bool friendly, float camera_move_duration = 11.5,  bool placementMode = false, bool isDevTest = false )
{
	#if !DEV
		                     
	#endif

	entity player 				= GetLocalClientPlayer()
	int playerTeam 				= player.GetTeam()
	int playerEncodedEHandle 	= player.GetEncodedEHandle()
	var entryPodiumRui

                  
		array<int> offsetArray = [90, 78, 78, 90, 90, 78, 78, 90, 90, 78]
       

	                                                            
	ScreenFade( player, 255, 255, 255, 255, 0.4, 2.0, FFADE_OUT | FFADE_PURGE )

	if ( IsSquadDataPersistenceEmpty( player ) && !isDevTest )
		Remote_ServerCallFunction( "ClientCallback_Sur_RequestSquadDataPersistence" )

	if ( IsValid ( player ) )
	{
		ScreenFade( player, 255, 255, 255, 255, 0.4, 0.0, FFADE_IN | FFADE_PURGE )
	}

	                                              
	asset defaultModel                = GetGlobalSettingsAsset( DEFAULT_PILOT_SETTINGS, "bodyModel" )
	LoadoutEntry loadoutSlotCharacter = Loadout_Character()
	vector characterAngles            = < file.victorySequenceAngles.x / 2.0, file.victorySequenceAngles.y, file.victorySequenceAngles.z >

	array<entity> cleanupEnts
	array<var> overHeadRuis

	                               
	VictoryPlatformModelData victoryPlatformModelData = GetVictorySequencePlatformModel()
	entity platformModel
	int maxTotalPlayers = GetCurrentPlaylistVarInt( "max_players", MAX_PLAYERS )
	int maxTeams = GetCurrentPlaylistVarInt( "max_teams", MAX_TEAMS )
	int squadSize = maxTotalPlayers / maxTeams
	int maxPlayersToShow = GetCurrentPlaylistVarInt( "podium_max_players_to_show", squadSize )

	if ( victoryPlatformModelData.isSet && IsValid ( player ) )
	{
		printf( "VICTORY: Getting platform model" )
		platformModel = CreateClientSidePropDynamic( file.victorySequencePosition + victoryPlatformModelData.originOffset, victoryPlatformModelData.modelAngles, victoryPlatformModelData.modelAsset )
                   
			                         
			if ( IsFallLTM() )
			{
				entity platformModel2 = CreateClientSidePropDynamic( PositionOffsetFromEnt( platformModel, -284, 1000, 0 ), victoryPlatformModelData.modelAngles, victoryPlatformModelData.modelAsset )
				entity platformModel3 = CreateClientSidePropDynamic( PositionOffsetFromEnt( platformModel, -284, 0, 0 ), victoryPlatformModelData.modelAngles, victoryPlatformModelData.modelAsset )                                  
				entity platformModel4 = CreateClientSidePropDynamic( PositionOffsetFromEnt( platformModel, -500, 200, 0 ), victoryPlatformModelData.modelAngles, victoryPlatformModelData.modelAsset )
				entity platformModel5 = CreateClientSidePropDynamic( PositionOffsetFromEnt( platformModel, -284, 500, 0 ), victoryPlatformModelData.modelAngles, victoryPlatformModelData.modelAsset )
				entity platformModel6 = CreateClientSidePropDynamic( PositionOffsetFromEnt( platformModel, 0, 500, 0 ), victoryPlatformModelData.modelAngles, victoryPlatformModelData.modelAsset )                                 
				entity platformModel7 = CreateClientSidePropDynamic( PositionOffsetFromEnt( platformModel, 300, 300, 0 ), victoryPlatformModelData.modelAngles, victoryPlatformModelData.modelAsset )
				entity platformModel8 = CreateClientSidePropDynamic( PositionOffsetFromEnt( platformModel, 0, 1000, 0 ), victoryPlatformModelData.modelAngles, victoryPlatformModelData.modelAsset )
				cleanupEnts.append( platformModel2 )
				cleanupEnts.append( platformModel3 )
				cleanupEnts.append( platformModel4 )
				cleanupEnts.append( platformModel5 )
				cleanupEnts.append( platformModel6 )
				cleanupEnts.append( platformModel7 )
				cleanupEnts.append( platformModel8 )
			}
                        

		cleanupEnts.append( platformModel )
		int playersOnPodium = 0

		              
		if ( file.victoryEffectData.effect != $"" )
		{
			StartParticleEffectInWorld( GetParticleSystemIndex( file.victoryEffectData.effect ), file.victoryEffectData.position, file.victoryEffectData.angles )
		}

		                                                                
		VictorySequenceOrderLocalPlayerFirst( player )                                                 

		      
		entryPodiumRui = CreateFullscreenRui( ENTRY_PODIUM_RUI )
		RuiSetBool( entryPodiumRui, "isFriendly", friendly )

		                                                                                                                                                                                
		int teamOfCurrentPlayer = -1
		int squadFormationIndex = 0
		int teamIndex

		                                                                                                                                                         
		array<bool> isFilledPodiumSpotsArray = []
		isFilledPodiumSpotsArray.resize( maxPlayersToShow, false )

		                                                                                                                                          
		array<int> uniqueTeamNumbers = []
		                                                                                                                         
		if ( friendly )
			uniqueTeamNumbers.append( playerTeam )

		foreach ( int i, entity teamPlayer in GetTeamPlayers( friendly ) )
		{
			if ( i > maxPlayersToShow )
				break

			int eHandle = teamPlayer.GetEncodedEHandle()
			if ( !EHIHasValidScriptStruct( eHandle ) )
				continue

			string playerName = GetPlayerNameUnlessAnonymized( eHandle )

			if ( !LoadoutSlot_IsReady( eHandle, loadoutSlotCharacter ) )
				continue

			ItemFlavor character = LoadoutSlot_GetItemFlavor( eHandle, loadoutSlotCharacter )

			if ( !LoadoutSlot_IsReady( eHandle, Loadout_CharacterSkin( character ) ) )
				continue

			ItemFlavor characterSkin = LoadoutSlot_GetItemFlavor( eHandle, Loadout_CharacterSkin( character ) )

			teamOfCurrentPlayer = teamPlayer.GetTeam()
			if ( !uniqueTeamNumbers.contains( teamOfCurrentPlayer ) )
				uniqueTeamNumbers.append( teamOfCurrentPlayer )

			teamIndex = uniqueTeamNumbers.find( teamOfCurrentPlayer )

			                                                                                                                                                                
			for ( int index = 0; index < squadSize; ++index)
			{
				squadFormationIndex = index + teamIndex * squadSize
				if (!isFilledPodiumSpotsArray[squadFormationIndex])
				{
					isFilledPodiumSpotsArray[squadFormationIndex] = true
					break
				}
			}
			vector pos = GetVictorySquadFormationPosition( file.victorySequencePosition, file.victorySequenceAngles, squadFormationIndex )

			                         
			entity characterNode = CreateScriptRef( pos, characterAngles )
			characterNode.SetParent( platformModel, "", true )
			entity characterModel = CreateClientSidePropDynamic( pos, characterAngles, defaultModel )
			SetForceDrawWhileParented( characterModel, true )
			characterModel.MakeSafeForUIScriptHack()
			CharacterSkin_Apply( characterModel, characterSkin )
			cleanupEnts.append( characterModel )

			#if DEV
				if ( GetBugReproNum() == 1111 )
				{
					var topo = CreateRUITopology_Worldspace( OffsetPointRelativeToVector( pos, < 0, -50, 0 >, characterModel.GetForwardVector() ), characterAngles + <0, 180, 0>, 1000, 500 )
					var rui  = RuiCreate( $"ui/dev_blue_screen.rpak", topo, RUI_DRAW_WORLD, 1000 )
					characterModel.Hide()
				}
				else if ( GetBugReproNum() == 2222 )
				{
					if ( i == 0 )
						characterModel.Hide()
				}
			#endif

			                                                                                        
			foreach ( func in s_callbacks_OnVictoryCharacterModelSpawned )
				func( characterModel, character, eHandle)

			                
			characterModel.SetParent( characterNode, "", false )
			string victoryAnim = GetVictorySquadFormationActivity( characterModel, eHandle )
			characterModel.SetupForSequenceTransitions()
			characterModel.Anim_Play( victoryAnim )
			characterModel.Anim_EnableUseAnimatedRefAttachmentInsteadOfRootMotion()
                                               
			if ( IsFallLTM() || IsShadowRoyaleMode() )
			{
				                                                                                   
				float duration    = characterModel.GetSequenceDuration( victoryAnim )
				float initialTime = RandomFloatRange( 0, duration )
				characterModel.Anim_SetInitialTime( initialTime )
			}
                                                    


			#if DEV
				if ( GetBugReproNum() == 1111 || GetBugReproNum() == 2222 )
				{
					playersOnPodium++
					continue
				}
			#endif

			                      
			bool createOverheadRui = true
                    
				if ( ( IsFallLTM() && IsShadowVictory() ) && ( playerEncodedEHandle != eHandle ) )
				{
					createOverheadRui = false
				}
                         
			if ( createOverheadRui )
			{
				int offset = 78
                     
					if ( IsFallLTM() )
						offset = offsetArray[i]
          

				entity overheadEnt = CreateClientSidePropDynamic( pos + (AnglesToUp( file.victorySequenceAngles ) * offset), <0, 0, 0>, $"mdl/dev/empty_model.rmdl" )
				overheadEnt.Hide()
				var overheadRui = RuiCreate( $"ui/winning_squad_member_overhead_name.rpak", clGlobal.topoFullScreen, RUI_DRAW_HUD, 0 )
				RuiSetString( overheadRui, "playerName", playerName )
				RuiTrackFloat3( overheadRui, "position", overheadEnt, RUI_TRACK_ABSORIGIN_FOLLOW )
				overHeadRuis.append( overheadRui )
			}

			playersOnPodium++
		}

		         
		VictoryCameraPackage victoryCameraPackage = GetVictoryCameraPackage()

		vector camera_offset_start = victoryCameraPackage.camera_offset_start
		vector camera_offset_end   = victoryCameraPackage.camera_offset_end
		vector camera_focus_offset = victoryCameraPackage.camera_focus_offset
		float camera_fov           = victoryCameraPackage.camera_fov

		vector camera_start_pos = OffsetPointRelativeToVector( file.victorySequencePosition, camera_offset_start, AnglesToForward( file.victorySequenceAngles ) )
		vector camera_end_pos   = OffsetPointRelativeToVector( file.victorySequencePosition, camera_offset_end, AnglesToForward( file.victorySequenceAngles ) )
		vector camera_focus_pos = OffsetPointRelativeToVector( file.victorySequencePosition, camera_focus_offset, AnglesToForward( file.victorySequenceAngles ) )

		vector camera_start_angles = VectorToAngles( camera_focus_pos - camera_start_pos )
		vector camera_end_angles   = VectorToAngles( camera_focus_pos - camera_end_pos )

		entity cameraMover = CreateClientsideScriptMover( $"mdl/dev/empty_model.rmdl", camera_start_pos, camera_start_angles )
		entity camera      = CreateClientSidePointCamera( camera_start_pos, camera_start_angles, camera_fov )
		player.SetMenuCameraEntity( camera )
		camera.SetTargetFOV( camera_fov, true, EASING_CUBIC_INOUT, 0.0 )
		camera.SetParent( cameraMover, "", false )
		cleanupEnts.append( camera )

		                             
		GetLightEnvironmentEntity().ScaleSunSkyIntensity( file.victorySunIntensity, file.victorySkyIntensity )

		              
		                                          
		cameraMover.NonPhysicsMoveTo( camera_end_pos, camera_move_duration, 0.0, camera_move_duration / 2.0 )
		cameraMover.NonPhysicsRotateTo( camera_end_angles, camera_move_duration, 0.0, camera_move_duration / 2.0 )
		cleanupEnts.append( cameraMover )

		wait camera_move_duration        

		#if DEV
			if ( placementMode )
			{
				if ( IsValid( platformModel ) )
					platformModel.SetParent( cameraMover, "", true )

				while( true )
				{
					vector pos        = cameraMover.GetOrigin()
					vector ang        = cameraMover.GetAngles()
					vector flatAngles = FlattenAngles( ang )

					vector forward = AnglesToForward( flatAngles )
					vector right   = AnglesToRight( flatAngles )
					vector up      = <0, 0, 1>


					float LTrig = InputGetAxis( ANALOG_L_TRIGGER ) * InputGetAxis( ANALOG_L_TRIGGER )
					float RTrig = InputGetAxis( ANALOG_R_TRIGGER ) * InputGetAxis( ANALOG_R_TRIGGER )

					float moveSpeed = 800.0 + (LTrig * 5000.0)
					moveSpeed *= max( 1.0 - RTrig, 0.0005 )

					float rotateSpeed = 2.0 + (LTrig * 10.0)
					rotateSpeed *= max( 1.0 - RTrig, 0.0005 )

					float XStick = fabs( InputGetAxis( ANALOG_LEFT_X ) ) * InputGetAxis( ANALOG_LEFT_X )
					float YStick = fabs( InputGetAxis( ANALOG_LEFT_Y ) ) * InputGetAxis( ANALOG_LEFT_Y )

					if ( InputGetAxis( ANALOG_LEFT_Y ) > 0.15 || InputGetAxis( ANALOG_LEFT_Y ) < -0.15 )
						pos += forward * YStick * -moveSpeed
					if ( InputGetAxis( ANALOG_LEFT_X ) > 0.15 || InputGetAxis( ANALOG_LEFT_X ) < -0.15 )
						pos += right * XStick * moveSpeed
					if ( InputIsButtonDown( BUTTON_STICK_LEFT ) )
						pos += up * moveSpeed * 0.1
					if ( InputIsButtonDown( BUTTON_STICK_RIGHT ) )
						pos -= up * moveSpeed * 0.1

					if ( InputGetAxis( ANALOG_RIGHT_X ) > 0.15 || InputGetAxis( ANALOG_RIGHT_X ) < -0.15 )
					{
						float yaw = ang.y + (InputGetAxis( ANALOG_RIGHT_X ) * -rotateSpeed)
						ang = ClampAngles( < ang.x, yaw, ang.z > )
					}

					cameraMover.NonPhysicsMoveTo( pos, 0.1, 0.0, 0.0 )
					cameraMover.NonPhysicsRotateTo( ang, 0.1, 0.0, 0.0 )

					printt( "SetVictorySequenceLocation(" + (platformModel.GetOrigin() - victoryPlatformModelData.originOffset) + ", " + ClampAngles( < 0, camera.GetAngles().y + 180, 0 > ) + " )" )

					WaitFrame()
				}
			}
		#endif
	}

	GetLightEnvironmentEntity().ScaleSunSkyIntensity( 1.0, 1.0 )

	foreach ( rui in overHeadRuis )
		RuiDestroyIfAlive( rui )

	if ( entryPodiumRui != null )
		RuiDestroyIfAlive( entryPodiumRui )

	foreach ( entity ent in cleanupEnts )
		ent.Destroy()
}

void function ShowVictorySequence( bool placementMode = false, bool isDevTest = false )
{
	#if !DEV
		                     
	#endif

	entity player 				= GetLocalClientPlayer()
	int playerTeam 				= player.GetTeam()
	int playerEncodedEHandle 	= player.GetEncodedEHandle()

	if ( EHIHasValidScriptStruct( playerEncodedEHandle ) )
		playerTeam = VictorySequence_GetPlayerTeamFromEHI( playerEncodedEHandle )

	                                                                                                                                                                         

                  
		array<int> offsetArray = [90, 78, 78, 90, 90, 78, 78, 90, 90, 78]
       

	                                                            
	ScreenFade( player, 255, 255, 255, 255, 0.4, 2.0, FFADE_OUT | FFADE_PURGE )

	EmitSoundOnEntity( player, "UI_InGame_ChampionMountain_Whoosh" )

	file.IsShowingVictorySequence = true

	if ( IsSquadDataPersistenceEmpty( player ) && !isDevTest )
		Remote_ServerCallFunction( "ClientCallback_Sur_RequestSquadDataPersistence" )
	wait 0.4

	DeathScreenUpdate()

	if ( IsViewingDeathScreen() )                                                                                      
	{
		                                                   
		SwitchDeathScreenTab( eDeathScreenPanel.SPECTATE )
		EnableDeathScreenTab( eDeathScreenPanel.SQUAD_SUMMARY, false )
		EnableDeathScreenTab( eDeathScreenPanel.DEATH_RECAP, false )
	}

	bool displayChampionOnPodium = GetCurrentPlaylistVarBool( "endflow_display_champion_on_podium", false )
	if ( !displayChampionOnPodium &&  file.youAreChampionSplashRui != null )
		RuiDestroyIfAlive( file.youAreChampionSplashRui )

	UpdateRespawnStatus( eRespawnStatus.NONE )
	HideGladiatorCardSidePane( true )

	if ( IsValid ( player ) )
	{
		Signal( player, "Bleedout_StopBleedoutEffects" )
		ScreenFade( player, 255, 255, 255, 255, 0.4, 0.0, FFADE_IN | FFADE_PURGE )
	}

	                                              
	asset defaultModel                = GetGlobalSettingsAsset( DEFAULT_PILOT_SETTINGS, "bodyModel" )
	LoadoutEntry loadoutSlotCharacter = Loadout_Character()
	vector characterAngles            = < file.victorySequenceAngles.x / 2.0, file.victorySequenceAngles.y, file.victorySequenceAngles.z >

	array<entity> cleanupEnts
	array<var> overHeadRuis

	                               
	VictoryPlatformModelData victoryPlatformModelData = GetVictorySequencePlatformModel()
	entity platformModel
	int maxTotalPlayers = GetCurrentPlaylistVarInt( "max_players", MAX_PLAYERS )
	int maxTeams = GetCurrentPlaylistVarInt( "max_teams", MAX_TEAMS )
	int squadSize = maxTotalPlayers / maxTeams
	int maxPlayersToShow = GetCurrentPlaylistVarInt( "podium_max_players_to_show", squadSize )

	if ( victoryPlatformModelData.isSet && IsValid ( player ) )
	{
		printf( "VICTORY: Getting platform model" )
		platformModel = CreateClientSidePropDynamic( file.victorySequencePosition + victoryPlatformModelData.originOffset, victoryPlatformModelData.modelAngles, victoryPlatformModelData.modelAsset )
                   
			                         
			if ( IsFallLTM() )
			{
				entity platformModel2 = CreateClientSidePropDynamic( PositionOffsetFromEnt( platformModel, -284, 1000, 0 ), victoryPlatformModelData.modelAngles, victoryPlatformModelData.modelAsset )
				entity platformModel3 = CreateClientSidePropDynamic( PositionOffsetFromEnt( platformModel, -284, 0, 0 ), victoryPlatformModelData.modelAngles, victoryPlatformModelData.modelAsset )                                  
				entity platformModel4 = CreateClientSidePropDynamic( PositionOffsetFromEnt( platformModel, -500, 200, 0 ), victoryPlatformModelData.modelAngles, victoryPlatformModelData.modelAsset )
				entity platformModel5 = CreateClientSidePropDynamic( PositionOffsetFromEnt( platformModel, -284, 500, 0 ), victoryPlatformModelData.modelAngles, victoryPlatformModelData.modelAsset )
				entity platformModel6 = CreateClientSidePropDynamic( PositionOffsetFromEnt( platformModel, 0, 500, 0 ), victoryPlatformModelData.modelAngles, victoryPlatformModelData.modelAsset )                                 
				entity platformModel7 = CreateClientSidePropDynamic( PositionOffsetFromEnt( platformModel, 300, 300, 0 ), victoryPlatformModelData.modelAngles, victoryPlatformModelData.modelAsset )
				entity platformModel8 = CreateClientSidePropDynamic( PositionOffsetFromEnt( platformModel, 0, 1000, 0 ), victoryPlatformModelData.modelAngles, victoryPlatformModelData.modelAsset )
				cleanupEnts.append( platformModel2 )
				cleanupEnts.append( platformModel3 )
				cleanupEnts.append( platformModel4 )
				cleanupEnts.append( platformModel5 )
				cleanupEnts.append( platformModel6 )
				cleanupEnts.append( platformModel7 )
				cleanupEnts.append( platformModel8 )
			}
                        

		cleanupEnts.append( platformModel )
		int playersOnPodium = 0

		              
		if ( file.victoryEffectData.effect != $"" )
		{
			StartParticleEffectInWorld( GetParticleSystemIndex( file.victoryEffectData.effect ), file.victoryEffectData.position, file.victoryEffectData.angles )
		}

		                                                                
		VictorySequenceOrderLocalPlayerFirst( player )

		      
		file.victoryPodiumRui = CreateFullscreenRui( VICTORY_PODIUM_RUI )

		                                                                                                                                                                                
		int teamOfCurrentPlayer = -1
		int squadFormationIndex = 0
		int teamIndex

		                                                                                                                                                         
		array<bool> isFilledPodiumSpotsArray = []
		isFilledPodiumSpotsArray.resize( maxPlayersToShow, false )

		                                                                                                                                             
		array<int> uniqueTeamNumbers = []

		                                                                                                                
		foreach ( SquadSummaryPlayerData data in file.winnerSquadSummaryData.playerData )
		{
			if ( data.eHandle == playerEncodedEHandle )
			{
				uniqueTeamNumbers.append( playerTeam )
				break
			}
		}

		foreach ( int i, SquadSummaryPlayerData data in file.winnerSquadSummaryData.playerData )
		{
			if ( i > maxPlayersToShow )
				break

			if ( !EHIHasValidScriptStruct( data.eHandle ) )
				continue

			string playerName = GetPlayerNameUnlessAnonymized( data.eHandle )

			if ( !LoadoutSlot_IsReady( data.eHandle, loadoutSlotCharacter ) )
				continue

			ItemFlavor character = LoadoutSlot_GetItemFlavor( data.eHandle, loadoutSlotCharacter )

			if ( !LoadoutSlot_IsReady( data.eHandle, Loadout_CharacterSkin( character ) ) )
				continue

			ItemFlavor characterSkin = LoadoutSlot_GetItemFlavor( data.eHandle, Loadout_CharacterSkin( character ) )

			                                                       
			teamOfCurrentPlayer = VictorySequence_GetPlayerTeamFromEHI( data.eHandle )

			if ( !uniqueTeamNumbers.contains( teamOfCurrentPlayer ) )
				uniqueTeamNumbers.append( teamOfCurrentPlayer )

			teamIndex = uniqueTeamNumbers.find( teamOfCurrentPlayer )

			                                                                                                                                                                
			for ( int index = 0; index < squadSize; ++index)
			{
				squadFormationIndex = index + teamIndex * squadSize
				if (!isFilledPodiumSpotsArray[squadFormationIndex])
				{
					isFilledPodiumSpotsArray[squadFormationIndex] = true
					break
				}
			}

			vector pos = GetVictorySquadFormationPosition( file.victorySequencePosition, file.victorySequenceAngles, squadFormationIndex )

			                         
			entity characterNode = CreateScriptRef( pos, characterAngles )
			characterNode.SetParent( platformModel, "", true )
			entity characterModel = CreateClientSidePropDynamic( pos, characterAngles, defaultModel )
			SetForceDrawWhileParented( characterModel, true )
			characterModel.MakeSafeForUIScriptHack()
			CharacterSkin_Apply( characterModel, characterSkin )
			cleanupEnts.append( characterModel )

			data.victoryScreenCharacterModel = characterModel

			#if DEV
				if ( GetBugReproNum() == 1111 )
				{
					var topo = CreateRUITopology_Worldspace( OffsetPointRelativeToVector( pos, < 0, -50, 0 >, characterModel.GetForwardVector() ), characterAngles + <0, 180, 0>, 1000, 500 )
					var rui  = RuiCreate( $"ui/dev_blue_screen.rpak", topo, RUI_DRAW_WORLD, 1000 )
					characterModel.Hide()
				}
				else if ( GetBugReproNum() == 2222 )
				{
					if ( i == 0 )
						characterModel.Hide()
				}
			#endif

			                                                                                        
			foreach ( func in s_callbacks_OnVictoryCharacterModelSpawned )
				func( characterModel, character, data.eHandle )

			                
			characterModel.SetParent( characterNode, "", false )
			string victoryAnim = GetVictorySquadFormationActivity( characterModel, data.eHandle )
			characterModel.SetupForSequenceTransitions()
			characterModel.Anim_Play( victoryAnim )
			characterModel.Anim_EnableUseAnimatedRefAttachmentInsteadOfRootMotion()
                                               
			if ( IsFallLTM() || IsShadowRoyaleMode() )
			{
				                                                                                   
				float duration    = characterModel.GetSequenceDuration( victoryAnim )
				float initialTime = RandomFloatRange( 0, duration )
				characterModel.Anim_SetInitialTime( initialTime )
			}
                                                    


			#if DEV
				if ( GetBugReproNum() == 1111 || GetBugReproNum() == 2222 )
				{
					playersOnPodium++
					continue
				}
			#endif

			                      
			bool createOverheadRui = true
                    
				if ( ( IsFallLTM() && IsShadowVictory() ) && ( playerEncodedEHandle != data.eHandle ) )
				{
					createOverheadRui = false
				}
                         
			if ( createOverheadRui )
			{
				int offset = 78
                     
					if ( IsFallLTM() )
						offset = offsetArray[i]
          

				entity overheadEnt = CreateClientSidePropDynamic( pos + (AnglesToUp( file.victorySequenceAngles ) * offset), <0, 0, 0>, $"mdl/dev/empty_model.rmdl" )
				overheadEnt.Hide()
				var overheadRui = RuiCreate( $"ui/winning_squad_member_overhead_name.rpak", clGlobal.topoFullScreen, RUI_DRAW_HUD, 0 )
				RuiSetString( overheadRui, "playerName", playerName )
				RuiTrackFloat3( overheadRui, "position", overheadEnt, RUI_TRACK_ABSORIGIN_FOLLOW )
				overHeadRuis.append( overheadRui )
			}

			playersOnPodium++
		}

		                                                   
		VictorySoundPackage victorySoundPackage = GetVictorySoundPackage()
		string dialogueApexChampion
		if ( playerTeam == GetWinningTeam() )
		{
			              
			if ( playersOnPodium > 1 )
				dialogueApexChampion = victorySoundPackage.youAreChampPlural
			else
				dialogueApexChampion = victorySoundPackage.youAreChampSingular
		}
		else
		{
			if ( playersOnPodium > 1 )
				dialogueApexChampion = victorySoundPackage.theyAreChampPlural
			else
				dialogueApexChampion = victorySoundPackage.theyAreChampSingular
		}

		EmitSoundOnEntityAfterDelay( platformModel, dialogueApexChampion, 0.5 )

		         
		VictoryCameraPackage victoryCameraPackage = GetVictoryCameraPackage()

		vector camera_offset_start = victoryCameraPackage.camera_offset_start
		vector camera_offset_end   = victoryCameraPackage.camera_offset_end
		vector camera_focus_offset = victoryCameraPackage.camera_focus_offset
		float camera_fov           = victoryCameraPackage.camera_fov

		vector camera_start_pos = OffsetPointRelativeToVector( file.victorySequencePosition, camera_offset_start, AnglesToForward( file.victorySequenceAngles ) )
		vector camera_end_pos   = OffsetPointRelativeToVector( file.victorySequencePosition, camera_offset_end, AnglesToForward( file.victorySequenceAngles ) )
		vector camera_focus_pos = OffsetPointRelativeToVector( file.victorySequencePosition, camera_focus_offset, AnglesToForward( file.victorySequenceAngles ) )

		vector camera_start_angles = VectorToAngles( camera_focus_pos - camera_start_pos )
		vector camera_end_angles   = VectorToAngles( camera_focus_pos - camera_end_pos )

		entity cameraMover = CreateClientsideScriptMover( $"mdl/dev/empty_model.rmdl", camera_start_pos, camera_start_angles )
		entity camera      = CreateClientSidePointCamera( camera_start_pos, camera_start_angles, camera_fov )
		player.SetMenuCameraEntity( camera )
		camera.SetTargetFOV( camera_fov, true, EASING_CUBIC_INOUT, 0.0 )
		camera.SetParent( cameraMover, "", false )
		cleanupEnts.append( camera )

		                             
		GetLightEnvironmentEntity().ScaleSunSkyIntensity( file.victorySunIntensity, file.victorySkyIntensity )

		              
		float camera_move_duration = 11.5       
		cameraMover.NonPhysicsMoveTo( camera_end_pos, camera_move_duration, 0.0, camera_move_duration / 2.0 )
		cameraMover.NonPhysicsRotateTo( camera_end_angles, camera_move_duration, 0.0, camera_move_duration / 2.0 )
		cleanupEnts.append( cameraMover )

		wait camera_move_duration - 0.5

		#if DEV
			if ( placementMode )
			{
				if ( IsValid( platformModel ) )
					platformModel.SetParent( cameraMover, "", true )

				while( true )
				{
					vector pos        = cameraMover.GetOrigin()
					vector ang        = cameraMover.GetAngles()
					vector flatAngles = FlattenAngles( ang )

					vector forward = AnglesToForward( flatAngles )
					vector right   = AnglesToRight( flatAngles )
					vector up      = <0, 0, 1>


					float LTrig = InputGetAxis( ANALOG_L_TRIGGER ) * InputGetAxis( ANALOG_L_TRIGGER )
					float RTrig = InputGetAxis( ANALOG_R_TRIGGER ) * InputGetAxis( ANALOG_R_TRIGGER )

					float moveSpeed = 800.0 + (LTrig * 5000.0)
					moveSpeed *= max( 1.0 - RTrig, 0.0005 )

					float rotateSpeed = 2.0 + (LTrig * 10.0)
					rotateSpeed *= max( 1.0 - RTrig, 0.0005 )

					float XStick = fabs( InputGetAxis( ANALOG_LEFT_X ) ) * InputGetAxis( ANALOG_LEFT_X )
					float YStick = fabs( InputGetAxis( ANALOG_LEFT_Y ) ) * InputGetAxis( ANALOG_LEFT_Y )

					if ( InputGetAxis( ANALOG_LEFT_Y ) > 0.15 || InputGetAxis( ANALOG_LEFT_Y ) < -0.15 )
						pos += forward * YStick * -moveSpeed
					if ( InputGetAxis( ANALOG_LEFT_X ) > 0.15 || InputGetAxis( ANALOG_LEFT_X ) < -0.15 )
						pos += right * XStick * moveSpeed
					if ( InputIsButtonDown( BUTTON_STICK_LEFT ) )
						pos += up * moveSpeed * 0.1
					if ( InputIsButtonDown( BUTTON_STICK_RIGHT ) )
						pos -= up * moveSpeed * 0.1

					if ( InputGetAxis( ANALOG_RIGHT_X ) > 0.15 || InputGetAxis( ANALOG_RIGHT_X ) < -0.15 )
					{
						float yaw = ang.y + (InputGetAxis( ANALOG_RIGHT_X ) * -rotateSpeed)
						ang = ClampAngles( < ang.x, yaw, ang.z > )
					}

					cameraMover.NonPhysicsMoveTo( pos, 0.1, 0.0, 0.0 )
					cameraMover.NonPhysicsRotateTo( ang, 0.1, 0.0, 0.0 )

					printt( "SetVictorySequenceLocation(" + (platformModel.GetOrigin() - victoryPlatformModelData.originOffset) + ", " + ClampAngles( < 0, camera.GetAngles().y + 180, 0 > ) + " )" )

					WaitFrame()
				}
			}
		#endif
	}

	if ( IsPrivateMatch() )
	{
		wait 60.0                                                                                                                                                                            
	}

	file.IsShowingVictorySequence = false

	if ( displayChampionOnPodium && file.youAreChampionSplashRui != null )
		RuiDestroyIfAlive( file.youAreChampionSplashRui )

	#if DEV
		if ( IsValid( player ) )
			printt( "PD: IsSquadDataPersistenceEmpty", IsSquadDataPersistenceEmpty( player ) )
	#endif

	if ( playerTeam != TEAM_SPECTATOR )
	{
		if ( IsValid( player ) )
		{
			while ( IsSquadDataPersistenceEmpty( player ) && !isDevTest )
			{
				Remote_ServerCallFunction( "ClientCallback_Sur_RequestSquadDataPersistence" )
				wait 1.0
			}

			SetSquadDataToLocalTeam()
			ShowDeathScreen( eDeathScreenPanel.SQUAD_SUMMARY )
			EnableDeathScreenTab( eDeathScreenPanel.SPECTATE, false )
			EnableDeathScreenTab( eDeathScreenPanel.DEATH_RECAP, !IsAlive( player ) )
			SwitchDeathScreenTab( eDeathScreenPanel.SQUAD_SUMMARY )
		}
		else
		{
			SetSquadDataToLocalTeam()
			ShowDeathScreen( eDeathScreenPanel.SQUAD_SUMMARY )
			EnableDeathScreenTab( eDeathScreenPanel.SPECTATE, false )
			EnableDeathScreenTab( eDeathScreenPanel.DEATH_RECAP, true )
			SwitchDeathScreenTab( eDeathScreenPanel.SQUAD_SUMMARY )
		}

		                                                                               
		wait 1.0
	}

	foreach ( rui in overHeadRuis )
		RuiDestroyIfAlive( rui )

	if ( file.victoryPodiumRui != null )
		RuiDestroyIfAlive( file.victoryPodiumRui )

	foreach ( entity ent in cleanupEnts )
		ent.Destroy()
}

entity function GetVictoryScreenCharacterModelForEHI( int playerEHI )
{
	if ( !IsShowingVictorySequence() )
		return null

	foreach ( int i, SquadSummaryPlayerData data in file.winnerSquadSummaryData.playerData )
	{
		if ( data.eHandle == playerEHI )
			return data.victoryScreenCharacterModel
	}

	return null
}

var function GetVictorySequenceRui()
{
	return file.victoryPodiumRui
}

bool function IsShowingVictorySequence()
{
	return file.IsShowingVictorySequence
}

void function Survival_SetVictorySoundPackageFunction( VictorySoundPackage functionref() func )
{
	file.victorySoundPackageCallback = func
}

VictorySoundPackage function GetVictorySoundPackage()
{
	VictorySoundPackage victorySoundPackage

	if ( file.victorySoundPackageCallback != null )
		return file.victorySoundPackageCallback()

	victorySoundPackage.youAreChampPlural = "diag_ap_aiNotify_winnerFound_07"                                 
	victorySoundPackage.youAreChampSingular = "diag_ap_aiNotify_winnerFound_10"                                
	victorySoundPackage.theyAreChampPlural = "diag_ap_aiNotify_winnerFound_08"                                 
	victorySoundPackage.theyAreChampSingular = "diag_ap_ainotify_introchampion_01_02"                            

	return victorySoundPackage
}


VictoryCameraPackage function GetVictoryCameraPackage()
{
	VictoryCameraPackage victoryCameraPackage

                  
		if ( IsFallLTM() )
		{
			if ( IsShadowVictory() )
			{
				victoryCameraPackage.camera_offset_start = <0, 725, 100>
				victoryCameraPackage.camera_offset_end = <0, 400, 48>
			}
			else
			{
				victoryCameraPackage.camera_offset_start = <0, 735, 68>
				victoryCameraPackage.camera_offset_end = <0, 625, 48>
			}

			victoryCameraPackage.camera_focus_offset = <0, 0, 36>
			victoryCameraPackage.camera_fov = 35.5

			return victoryCameraPackage
		}
                       

                         

		if ( Control_IsModeEnabled() )
		{
			victoryCameraPackage.camera_offset_start = <0, 480, 108>
			victoryCameraPackage.camera_offset_end = <0, 350, 88>
			victoryCameraPackage.camera_focus_offset = <0, 0, 56>
			victoryCameraPackage.camera_fov = 35.5

			return victoryCameraPackage
		}

       

	victoryCameraPackage.camera_offset_start = <0, 320, 68>
	victoryCameraPackage.camera_offset_end = <0, 200, 48>
	victoryCameraPackage.camera_focus_offset = <0, 0, 36>
	victoryCameraPackage.camera_fov = 35.5

	return victoryCameraPackage
}


vector function GetVictorySquadFormationPosition( vector mainPosition, vector angles, int index )
{
	if ( index == 0 )
		return mainPosition - <0, 0, 8>

	float offset_side = 48.0
	float offset_back = -28.0

                  
		if ( IsFallLTM() )
		{
			if ( IsShadowVictory() )
			{
				if ( index < 7 )
				{
					offset_side = 48.0
					offset_back = -48.0
				}
				else if ( index == 7 )
					return OffsetPointRelativeToVector( mainPosition, <24, 16, -8>, AnglesToForward( angles ) )
				else if ( index == 8 )
					return OffsetPointRelativeToVector( mainPosition, <48, 16, -8>, AnglesToForward( angles ) )
				else if ( index == 9 )
					return OffsetPointRelativeToVector( mainPosition, <72, 16, -8>, AnglesToForward( angles ) )
				else if ( index == 10 )
					return OffsetPointRelativeToVector( mainPosition, <96, 16, -8>, AnglesToForward( angles ) )
				else if ( index == 11 )
					return OffsetPointRelativeToVector( mainPosition, <120, 16, -8>, AnglesToForward( angles ) )
				else if ( index == 12 )
					return OffsetPointRelativeToVector( mainPosition, <-24, 16, -8>, AnglesToForward( angles ) )
				else if ( index == 13 )
					return OffsetPointRelativeToVector( mainPosition, <-48, 16, -8>, AnglesToForward( angles ) )
				else if ( index == 14 )
					return OffsetPointRelativeToVector( mainPosition, <-96, 16, -8>, AnglesToForward( angles ) )
				else if ( index == 15 )
					return OffsetPointRelativeToVector( mainPosition, <-120, 16, -8>, AnglesToForward( angles ) )
				else if ( index == 16 )
					return OffsetPointRelativeToVector( mainPosition, <12, 32, -8>, AnglesToForward( angles ) )
			}
			else
			{
				if ( index > 2 )
				{
					                                        
					offset_side = 56.0
					offset_back = -28.0
				}
			}
		}

                       

                         

		if ( Control_IsModeEnabled() )
		{
			int groupOffsetIndex = index / 3
			int internalGroupOffsetIndex = index % 3

			float internalGroupOffsetSide = 34.0                                                                                           
			float internalGroupOffsetBack = -38.0                                                                              

			float groupOffsetSide = 114.0                                                                                            
			float groupOffsetBack = -64.0                                                                               

			float finalOffsetSide = ( groupOffsetSide * ( groupOffsetIndex % 2 == 0 ? 1 : -1 ) * ( groupOffsetIndex == 0 ? 0 : 1 ) ) +
									( internalGroupOffsetSide * ( internalGroupOffsetIndex % 2 == 0 ? 1 : -1 ) * ( internalGroupOffsetIndex == 0 ? 0 : 1 ) )
			float finalOffsetBack = ( groupOffsetBack * ( groupOffsetIndex == 0 ? 0 : 1 ) ) +
									( internalGroupOffsetBack * ( internalGroupOffsetIndex == 0 ? 0 : 1 ) )

			vector offset = < finalOffsetSide, finalOffsetBack, -8 >
			return OffsetPointRelativeToVector( mainPosition, offset, AnglesToForward( angles ) )
		}

       

	int countBack = (index + 1) / 2
	vector offset = < offset_side, offset_back, 0 > * countBack

	if ( index % 2 == 0 )
		offset.x *= -1

	vector point = OffsetPointRelativeToVector( mainPosition, offset, AnglesToForward( angles ) )
	return point - <0, 0, 8>
}


string function GetVictorySquadFormationActivity( entity characterModel, int eHandle )
{
                                                
		entity playerEnt = GetEntityFromEncodedEHandle( eHandle )
		if ( ( IsFallLTM() && IsShadowVictory() ) || ( IsShadowRoyaleMode() && IsPlayerShadowZombie( playerEnt ) ) )
		{
			bool animExists = characterModel.LookupSequence( "ACT_VICTORY_DANCE" ) != -1
			if ( animExists )
				return "ACT_VICTORY_DANCE"
			else
			{
				Assert( characterModel.LookupSequence( "ACT_MP_MENU_LOBBY_SELECT_IDLE" ) != -1, "Unable to find victory idle for " + characterModel )
				return "ACT_MP_MENU_LOBBY_SELECT_IDLE"
			}
		}

                                                     

	return "ACT_MP_MENU_LOBBY_SELECT_IDLE"
	  
	                 
		                                      

	                     
		                                     

	                                    
	  
}


bool function HealthkitWheelToggleEnabled()
{
	return false
}


bool function HealthkitWheelUseOnRelease()
{
	return false && !HealthkitUseOnHold()
}


bool function HealthkitUseOnHold()
{
	return false && !HealthkitWheelToggleEnabled()
}


void function HealthkitButton_Down( entity player )
{
	if ( !CommsMenu_CanUseMenu( player ) )
		return

                   
                         
         
                         

	if ( !IsFiringRangeGameMode() )
	{
		int ms = PlayerMatchState_GetFor( player )
		if ( ms < ePlayerMatchState.NORMAL )
			return
	}

	if ( player.ContextAction_IsInVehicle() )
			return

	CommsMenu_OpenMenuTo( player, eChatPage.INVENTORY_HEALTH, eCommsMenuStyle.INVENTORY_HEALTH_MENU, false )
}


void function HealthkitButton_Up( entity player )
{
	if ( !IsCommsMenuActive() )
		return

	if ( CommsMenu_GetCurrentCommsMenu() != eCommsMenuStyle.INVENTORY_HEALTH_MENU )
		return

	if ( HealthkitWheelToggleEnabled() )
		return

	if ( CommsMenu_HasValidSelection() )
		CommsMenu_ExecuteSelection( eWheelInputType.NONE )

	CommsMenu_Shutdown( true )
}


bool function OrdnanceWheelToggleEnabled()
{
	return false
}


bool function OrdnanceWheelUseOnRelease()
{
	return true && !OrdnanceUseOnHold()
}


bool function OrdnanceUseOnHold()
{
	return false && !OrdnanceWheelToggleEnabled()
}


void function OrdnanceMenu_Down( entity player )
{
	if ( !SURVIVAL_PlayerCanSwitchOrdnance( player ) )
		return

                   
                         
         
                         

	if ( !CommsMenu_CanUseMenu( player ) )
		return

	if ( Bleedout_IsBleedingOut( player ) )
		return

	CommsMenu_OpenMenuTo( player, eChatPage.ORDNANCE_LIST, eCommsMenuStyle.ORDNANCE_MENU, false )
}


void function OrdnanceMenu_Up( entity player )
{
	if ( !IsCommsMenuActive() )
		return
	if ( CommsMenu_GetCurrentCommsMenu() != eCommsMenuStyle.ORDNANCE_MENU )
		return

	if ( CommsMenu_HasValidSelection() )
		CommsMenu_ExecuteSelection( eWheelInputType.NONE )

	CommsMenu_Shutdown( true )
}


void function GadgetSlot_Down( entity player )
{
	if ( !SURVIVAL_PlayerCanSwitchOrdnance( player ) )
		return

                   
                         
         
                         

	if ( Bleedout_IsBleedingOut( player ) )
		return

	string equipRef = EquipmentSlot_GetLootRefForSlot( player, "gadgetslot" )
	if ( equipRef == "" )
		return
	else
	{
		if( SURVIVAL_Loot_GetLootDataByRef( equipRef ).lootType == eLootType.GADGET )
		{
			Remote_ServerCallFunction( "ClientCallback_Sur_EquipGadget", equipRef )
		}
	}
}

const float MINIMAP_SCALE_SPECTATE = 1.0
void function OnFirstPersonSpectateStarted( entity player, entity currentTarget )
{
	if ( !Flag( "SquadEliminated" ) )
		StopLocal1PDeathSound()

	if ( IsValid( currentTarget ) && currentTarget.IsPlayer() )
		thread InitSurvivalHealthBar()

	Minimap_SetSizeScale( MINIMAP_SCALE_SPECTATE )
}

void function OnViewPlayerChanged( entity newViewPlayer )
{
	if ( IsValid( newViewPlayer ) && newViewPlayer.IsPlayer() )
	{
		bool isReady = ToEHI( newViewPlayer ) != EHI_null && IsLocalClientEHIValid();
		if ( isReady )
		{
			thread InitSurvivalHealthBar()
			ScorebarInitTracking( newViewPlayer, ClGameState_GetRui() )
		}
	}
}


void function OnLocalPlayerSpawned( entity localPlayer )
{
	thread InitSurvivalHealthBar()
	ScorebarInitTracking( localPlayer, ClGameState_GetRui() )

	Minimap_SetSizeScale( 1.0 )
}

void function OnPlayerConnectionStateChanged( entity player )
{
	if ( player == GetLocalViewPlayer() && file.pilotRui != null )
	{
		RuiSetBool( file.pilotRui, "disconnected", !player.IsConnectionActive() )
	}
}

void function OnPlayerMatchStateChanged( entity player, int newState )
{
	switch ( newState )
	{
		case ePlayerMatchState.SKYDIVE_PRELAUNCH:
		case ePlayerMatchState.SKYDIVE_FALLING:
			Minimap_SetSizeScale( MINIMAP_SCALE_SPECTATE )
			break

		case ePlayerMatchState.NORMAL:
		case ePlayerMatchState.STAGING_AREA:
			Minimap_SetSizeScale( 1.0 )
			break
	}

	UpdateIsSonyMP()
	Chroma_UpdateBackground()
}


void function UICallback_UpdateCharacterDetailsPanel( var ruiPanel )
{
	var rui              = Hud_GetRui( ruiPanel )
	ItemFlavor character = LoadoutSlot_GetItemFlavor( ToEHI( GetLocalClientPlayer() ), Loadout_Character() )
	UpdateCharacterDetailsMenu( rui, character, true )
}


void function UICallback_OpenCharacterSelectNewMenu()
{
	entity player = GetLocalClientPlayer()
	if ( IsAlive( player ) && player.ContextAction_IsMeleeExecution() )
		return

	if ( (GetGameState() < eGameState.PickLoadout && !IsSurvivalTraining()) || GetCurrentPlaylistVarBool( "character_reselect_enabled", false ) )
	{
		OpenCharacterSelectNewMenu( true )
	}
}


void function UICallback_QueryPlayerCanBeRespawned()
{
	entity player             = GetLocalClientPlayer()
	bool playerCanBeRespawned = (PlayerIsMarkedAsCanBeRespawned( player ) && (GetGameState() == eGameState.Playing))

	int penaltyLength = 0
	bool penaltyMayBeActive
	if ( IsRankedGame() )
	{
		penaltyMayBeActive = Ranked_IsPlayerAbandoning( player )                                                                            
		penaltyLength = SharedRanked_GetAbandonPenaltyLength( player )
	}
                       
	else if ( IsArenasRankedGame() )
	{
		penaltyMayBeActive = ArenasRanked_IsPlayerAbandoning( player )
		penaltyLength = SharedRanked_GetAbandonPenaltyLength( player )
	}
	else if ( IsArenaMode() )
	{
		penaltyMayBeActive = Arenas_IsPlayerAbandoning( player )
		penaltyLength = SharedRanked_GetAbandonPenaltyLength( player )
	}
      
                                              
	else if ( Control_IsModeEnabled() )
	{
		penaltyMayBeActive = Control_IsPlayerAbandoning( player )
		penaltyLength = Control_GetAbandonPenaltyLength( player )
	}
      
	else
	{
		if ( !GetCurrentPlaylistVarBool( "survival_abandonment_enable", false ) )                                                                                                                 
		{
			penaltyMayBeActive = false
		}
		else
		{
			penaltyMayBeActive = PlayerMatchState_GetFor( GetLocalClientPlayer() ) < ePlayerMatchState.NORMAL
			penaltyMayBeActive = penaltyMayBeActive && GetPlayerArrayOfTeam( player.GetTeam() ).len() == 3
		}
	}

	RunUIScript( "ConfirmLeaveMatchDialog_SetPlayerCanBeRespawned", playerCanBeRespawned, penaltyMayBeActive, penaltyLength )
}


void function UICallback_DieAndChangeCharacters()
{
	entity player = GetLocalClientPlayer()

                         
		if ( Control_IsModeEnabled() )
		{
			                                                                                                                
			if ( player.GetPlayerNetBool( "Control_IsPlayerOnSpawnSelectScreen" )  )
			{
				Control_OpenCharacterSelect()
				return
			}

			                                                                                 
			Remote_ServerCallFunction( "ClientCallback_Control_PlayerRespawningFromMenu" )
		}
       
}


void function ServerCallback_PromptTaunt()
{
	int selectedIndex = -1

	EHI playerEHI        = LocalClientEHI()
	ItemFlavor character = LoadoutSlot_GetItemFlavor( playerEHI, Loadout_Character() )
	bool pickFromFavored = ItemFlavor_GetFavoredQuipArrayForCharacter( character ).len() > 0

	array<ItemFlavor> options
	table<ItemFlavor, int> optionToIndex
	entity localPlayer = FromEHI( playerEHI )
	if ( IsValid( localPlayer ) && !CanPlayerSpeak( localPlayer ) )
		return

	if ( pickFromFavored )
	{
		for ( int i = 0; i < MAX_FAVORED_QUIPS; i++ )
		{
			LoadoutEntry entry = Loadout_FavoredQuip( character, i )
			ItemFlavor quip    = LoadoutSlot_GetItemFlavor( playerEHI, entry )
			if ( !CharacterQuip_IsTheEmpty( quip ) )
			{
				options.append( quip )
				optionToIndex[ quip ] <- i
			}
		}
	}
	else
	{
		for ( int i = 0; i < MAX_QUIPS_EQUIPPED; i++ )
		{
			LoadoutEntry entry = Loadout_CharacterQuip( character, i )
			ItemFlavor quip    = LoadoutSlot_GetItemFlavor( playerEHI, entry )
			if ( !CharacterQuip_IsTheEmpty( quip ) )
			{
				options.append( quip )
				optionToIndex[ quip ] <- i
			}
		}
	}

	string promptString = "#PING_SAY_CELEBRATE"

	if ( options.len() > 0 )
	{
		ItemFlavor flav = options.getrandom()

		if ( ItemFlavor_GetType( flav ) == eItemType.character_emote )
		{
			entity emotePlayer = FromEHI( playerEHI )

			if ( !IsValid( emotePlayer ) )
				return

			promptString = "#PING_SAY_CELEBRATE_EMOTE"
		}

		if ( ItemFlavor_GetType( flav ) == eItemType.emote_icon )
		{
			promptString = "#PING_SAY_CELEBRATE_HOLO"
		}

		selectedIndex = optionToIndex[ flav ]
	}

	AddOnscreenPromptFunction( "quickchat",
		void function( entity player ) : ( selectedIndex, promptString, pickFromFavored )
		{
			if ( selectedIndex == -1 )
				Quickchat( player, eCommsAction.QUICKCHAT_CELEBRATE, null )
			else
			{
				if ( pickFromFavored )
					PerformFavoredQuipAtSlot( selectedIndex )
				else
					PerformQuipAtSlot( selectedIndex )
			}
		},
		6.0, Localize( promptString ) )
}


void function ServerCallback_PromptSayThanks( entity playerBeingAddressed )
{
	if ( ShouldMuteCommsActionForCooldown( GetLocalViewPlayer(), eCommsAction.REPLY_THANKS, null ) )
		return

	AddOnscreenPromptFunction( "quickchat", CreateQuickchatFunction( eCommsAction.REPLY_THANKS, playerBeingAddressed ), 6.0, Localize( "#PING_SAY_THANKS", playerBeingAddressed.GetPlayerName() ) )
}

void function ServerCallback_PromptSayThanksRevive( entity playerBeingAddressed )
{
	if ( ShouldMuteCommsActionForCooldown( GetLocalViewPlayer(), eCommsAction.REPLY_THANKS, null ) )
		return

	AddOnscreenPromptFunction( "quickchat", CreateQuickchatFunction( eCommsAction.REPLY_REVIVE_THANKS, playerBeingAddressed ), 6.0, Localize( "#PING_SAY_THANKS", playerBeingAddressed.GetPlayerName() ) )
}


void function ServerCallback_PromptSayGetOnTheDropship()
{
	AddOnscreenPromptFunction( "quickchat", CreateQuickchatFunction( eCommsAction.QUICKCHAT_GET_ON_THE_DROPSHIP, null ), 6.0, Localize( "#PING_SAY_GETONDROPSHIP" ) )
}

                            
void function ServerCallback_PromptMarkMyLastDeathbox()
{
	AddOnscreenPromptFunction( "quickchat",  CreateQuickchatFunction ( eCommsAction.MARK_MY_LAST_DEATHBOX, null ), 6.0, Localize( "#PROMPT_MARK_MY_LAST_DEATHBOX" ) )
}
      

void function ServerCallback_PromptRespawnThanks()
{
	AddOnscreenPromptFunction( "quickchat",  CreateQuickchatFunction ( eCommsAction.PROMPT_THANKS_RESPAWN, null ), 6.0, Localize( "#PROMPT_REPSAWN_THANKS" ) )
}

void functionref(entity) function CreateQuickchatFunction( int commsAction, entity playerBeingAddressed )
{
	return void function( entity player ) : ( playerBeingAddressed, commsAction )
	{
		Quickchat( player, commsAction, playerBeingAddressed )
	}
}


bool function CanReportPlayer( entity target )
{
	int reportStyle = GetReportStyle()

	if ( !IsValid( target ) )
		return false

	if ( !target.IsPlayer() )
		return false

	#if CONSOLE_PROG
		reportStyle = minint( reportStyle, 1 )
	#endif

	switch ( reportStyle )
	{
		case 0:            
			return false

		case 1:                                                                                                                   
			                                                                                                
			return CrossplayUserOptIn() ? true : target.GetUnspoofedHardware() == GetLocalClientPlayer().GetUnspoofedHardware()
		case 2:               
			break

		default:
			return false
	}

	return true
}


void function OnPlayerKilled( entity player )
{
	entity viewPlayer = GetLocalViewPlayer()
	if ( player.GetTeam() == viewPlayer.GetTeam() && player != viewPlayer )
	{
		EmitSoundOnEntity( viewPlayer, SOUND_UI_TEAMMATE_KILLED )
	}
}


void function UpdateInventoryCounter( entity player, string ref, bool isFull = false )
{
	var rui = file.inventoryCountRui

	RuiSetGameTime( rui, "startTime", Time() )
	RuiSetFloat2( rui, "offset", <0.0, 0.18, 0.0> )
	RuiSetInt( rui, "maxCount", SURVIVAL_GetInventoryLimit( player ) )
	RuiSetInt( rui, "currentCount", SURVIVAL_GetInventoryCount( player ) )
	RuiSetInt( rui, "highlightCount", 0 )                                                    
	RuiSetBool( rui, "isFull", isFull )
}


void function TryUpdateInventoryCounter( entity player, LootData data, int lootAction )
{
	if ( data.inventorySlotCount <= 0 )
		return

	if( GetGameState() == eGameState.Prematch && GetCurrentPlaylistVarBool( "hide_inventory_counter_in_prematch", false ) )
		return

	if ( lootAction == eLootAction.PICKUP || lootAction == eLootAction.PICKUP_ALL || data.lootType == eLootType.BACKPACK )
		UpdateInventoryCounter( player, data.ref )
}


void function PlayerHudSetWeaponInspect( bool inspect )
{
	RuiSetBool( file.pilotRui, "weaponInspect", inspect )
	RuiSetBool( file.dpadMenuRui, "weaponInspect", inspect )

}

void function ServerCallback_NessyMessage( int state )
{
	if ( state == 0 )
		Obituary_Print_Localized( Localize( "#NESSY_APPEARS" ) )
	if ( state == 1 )
		Obituary_Print_Localized( Localize( "#NESSY_SURFACES" ) )
}

void function ServerCallback_RefreshInventoryAndWeaponInfo()
{
	ServerCallback_RefreshInventory()
	ClWeaponStatus_RefreshWeaponInfo()
	UpdateDpadHud( GetLocalViewPlayer() )
}

void function UIToClient_ToggleMute()
{
	ToggleSquadMute()
}


void function ToggleSquadMute()
{
	SetSquadMuteState( !file.isSquadMuted )
}

void function SetSquadMuteState( bool isSquadMuted )
{
	file.isSquadMuted = isSquadMuted
	foreach ( player in GetPlayerArrayOfTeam( GetLocalClientPlayer().GetTeam() ) )
	{
		if ( player == GetLocalClientPlayer() )
			continue

		if ( player.IsVoiceAndTextMuted() != isSquadMuted )
		{
			TogglePlayerVoiceAndTextMute( player )
		}
	}

	foreach ( cb in file.squadMuteChangeCallbacks )
		cb()
}

bool function IsSquadMuted()
{
	return file.isSquadMuted
}

bool function SquadMuteIntroEnabled()
{
	return GetCurrentPlaylistVarBool( "squad_mute_intro_enable", true )
}


void function AddCallback_OnSquadMuteChanged( void functionref() cb )
{
	file.squadMuteChangeCallbacks.append( cb )
}


void function OnSquadMuteChanged()
{
	UpdateWaitingForPlayersMuteHint()
}


void function ServerCallback_RefreshDeathBoxHighlight()
{
	array<entity> boxes = GetAllDeathBoxes()
	ArrayRemoveInvalid( boxes )
	foreach ( box in boxes )
	{
		ManageHighlightEntity( box )
	}
}

const string magAttachmentName = "mag"
void function ServerCallback_AutoReloadComplete( entity weapon )
{
	if ( !IsValid( weapon ) )
		return

	if ( file.pilotRui == null )
		return

	               
	string mod = GetInstalledWeaponAttachmentForPoint( weapon, magAttachmentName )
	int magTier = 4
	asset magIcon = $""

	if ( SURVIVAL_Loot_IsRefValid ( mod ) )                             
	{
		LootData magData = SURVIVAL_Loot_GetLootDataByRef( mod )
		magTier = magData.tier
		magIcon = magData.hudIcon
	}

	                
	LootData weaponData = SURVIVAL_GetLootDataFromWeapon( weapon )
	string ammoTypeRef = AmmoType_GetRefFromIndex( weapon.GetWeaponAmmoPoolType() )
	asset ammoIcon = $""

	if ( SURVIVAL_Loot_IsRefValid( ammoTypeRef ) )
	{
		if ( weaponData.tier != eLootTier.HEIRLOOM )
		{
			LootData ammoData = SURVIVAL_Loot_GetLootDataByRef( ammoTypeRef )
			ammoIcon = ammoData.hudIcon
		}
		else
		{
			ammoIcon = weaponData.fakeAmmoIcon == $"" ? $"rui/hud/gametype_icons/survival/sur_ammo_unique" : weaponData.fakeAmmoIcon
		}
	}

	var rui = ClWeaponStatus_GetWeaponHudRui( GetLocalViewPlayer() )
	if(rui != null)
	{
		RuiSetString( rui, "passiveDesc", Localize( "#RELOADED" ).toupper() )
		RuiSetImage( rui, "passiveMagIcon", magIcon )
		RuiSetImage( rui, "passiveIcon", weapon.GetWeaponSettingAsset( eWeaponVar.hud_icon ) )
		RuiSetImage( rui, "passiveAmmoIcon", ammoIcon )
		RuiSetInt( rui, "passiveTier", magTier )
		RuiSetInt( rui, "passiveAltTier", weaponData.tier )
		RuiSetBool( rui, "displayPassiveBonusPopup", true )
		RuiSetGameTime( rui, "passiveActivationTime", Time() )
	}
}

                         
void function ServerCallback_SetLaserSightVMLaserEnabled( entity weapon, bool enabled )
{
	if ( !IsValid( weapon ) )
		return

	if(!weapon.IsWeaponX())
		return

	weapon.SetTargetingLaserEnabled( enabled )
}
      

bool function CircleAnnouncementsEnabled()
{
	return file.circleAnnouncementsEnabled
}


void function CircleAnnouncementsEnable( bool state )
{
	file.circleAnnouncementsEnabled = state
}

bool function CircleBannerAnnouncementsEnabled()
{
	return file.circleBannerAnnouncementsEnabled
}

void function CircleBannerAnnouncementsEnable( bool state )
{
	file.circleBannerAnnouncementsEnabled = state
}

void function AddCallback_ShouldRunCharacterSelection( bool functionref() func )
{
	file.shouldRunCharacterSelectionCallback = func
}

void function EvolvingArmor_SetEvolutionRuiAnimTime()
{
	if ( file.pilotRui == null )
		return

	RuiSetGameTime( file.pilotRui, "evolvingArmorUpgradeStartTime", Time() )
}

                   
                                                                
 
                               
  
                                                               
                                                                 
  
 
      

void function OnSettingsUpdated()
{
	ServerCallback_RefreshInventoryAndWeaponInfo()
}
                          
void function ShowTeamNameInHud()
{
	entity clientPlayer = GetLocalClientPlayer()
	entity currentObserverTarget = clientPlayer.GetObserverTarget()

	if ( clientPlayer.GetTeam() != TEAM_SPECTATOR )
		return

	if ( currentObserverTarget.GetTeam() == TEAM_SPECTATOR )
		return

	RuiSetString( file.pilotRui, "teamNameString", PrivateMatch_GetTeamName( currentObserverTarget.GetTeam() ) )
	RuiSetBool( file.pilotRui, "shouldShowTeamName", true )
}

void function HideTeamNameInHud()
{
	RuiSetBool( file.pilotRui, "shouldShowTeamName", false )
}
                               

var function GetCompassRui()
{
	return file.compassRui
}

var function GetPilotRui(){
	return file.pilotRui
}

var function GetDpadMenuRui()
{
	return file.dpadMenuRui
}

bool function PlayerInfoIsDisabled()
{
	return GetCurrentPlaylistVarBool( "hide_ui_playerinfo", false )
}

bool function DpadHudIsDisabled()
{
	return GetCurrentPlaylistVarBool( "hide_ui_dpadmenu", false )
}

bool function GameSateHudIsDisabled()
{
	return GetCurrentPlaylistVarBool( "hide_ui_gamestate", false )
}

void function ServerCallback_AnnounceDevRespawn()
{
#if DEV
	AnnouncementMessageSweep( GetLocalViewPlayer(), "Dev Respawn" )
#endif
}

                                                    
                                                             
void function PopulateSummaryDataStrings( SquadSummaryPlayerData data, string lastGameMode )
{
	switch( lastGameMode )
	{

	                         
	  	                  
	  		                                                                             
	  		                                                                               
	  		                                                                                  
	  		                                                                                    
	  		                                                                                     
	  		                                                                               
	  		                                                                                
	  		     
	        
	  
	                          
	  	                   
	  		                                                                             
	  		                                                                               
	  		                                                  
	  		                                                                                    
	  		                                                                                      
	  		                                                                                                   
	  		                                                  
	  		     
	        

		           
		default:
			data.modeSpecificSummaryData[0].displayString = "#DEATH_SCREEN_SUMMARY_KILLS"
			data.modeSpecificSummaryData[1].displayString = "#DEATH_SCREEN_SUMMARY_ASSISTS"
			data.modeSpecificSummaryData[2].displayString = "#DEATH_SCREEN_SUMMARY_KNOCKDOWNS"
			data.modeSpecificSummaryData[3].displayString = "#DEATH_SCREEN_SUMMARY_DAMAGE_DEALT"
			data.modeSpecificSummaryData[4].displayString = "#DEATH_SCREEN_SUMMARY_SURVIVAL_TIME"
			data.modeSpecificSummaryData[5].displayString = "#DEATH_SCREEN_SUMMARY_REVIVES"
			data.modeSpecificSummaryData[6].displayString = "#DEATH_SCREEN_SUMMARY_RESPAWNS"
	}
}

void function SetSummaryDataDisplayStringsCallback( void functionref( SquadSummaryPlayerData ) func )
{
	file.getSquadSummaryDisplayStringsCallback = func
}
