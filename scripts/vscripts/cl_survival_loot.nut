global function Cl_Survival_LootInit

global function TryOpenQuickSwap
global function GetPropSurvivalUseEntity
global function GetCrosshairEntity

global function Survival_Health_SetSelectedHealthPickupType
global function Survival_Health_GetSelectedHealthPickupType
global function Survival_UseHealthPack

global function DumpAttachmentTags
global function AttachmentTags
global function UpdateLootRuiWithData
global function LootGoesInPack
global function SetupSurvivalLoot
global function SURVIVAL_Loot_QuickSwap
global function SURVIVAL_Loot_UpdateRuiLastUseTime

global function PlayLootPickupFeedbackFX

global function ServerToClient_OnStartedUsingHealthPack

global function GetLootPromptStyle
global function GetDeathBoxOwnerEHI
global function GetDeathboxPlayerIsLookingAt
global function DeathBoxGetExtendedUseSettings
global function CreateDeathBoxRui

global function HideLootPrompts

global function GetHighlightFillAlphaForLoot
global function GetHighlightFillAlphaForDeathBox

global function ApplyEquipmentColorAndFXOverrides

global function ManageDeathBoxLootThread

global function RegisterCustomItemPromptUpdate

global function ShouldOpenQuickswap

#if DEV
global function DEV_ToggleLootRefs
#endif

global typedef CustomItemPromptUpdateCB_t void functionref( entity player, var rui, LootData data, int lootContext, LootRef lootRef, bool isInMenu )

global const string PING_SOUND_DEFAULT = "ui_mapping_item_1p"
const float LOOT_PING_DISTANCE = 500.0

const bool LINE_COLORS = true

const float MAGIC_DEATHBOX_Z_OFFSET = 1.25

const bool HAS_ITEM_PICKUP_FEEDACK_FX = false
#if HAS_ITEM_PICKUP_FEEDACK_FX
                                                         
#endif   

const asset EVO_ARMOR_FX = $"P_item_evo_armor"
const asset EVO_ARMOR_PICKUP_FX = $"P_item_evo_armor_pickup"

struct VerticalLineStruct
{
	var    topo
	var    rui
	entity ent
}

struct PlayerLookAtItem
{
	entity ent
	float  playerViewDot
}

struct {
#if NX_PROG
	int useAltBind = BUTTON_X
#else
	int useAltBind = BUTTON_Y
#endif

	entity swapOnUseItem
	entity crosshairEntity
	entity currentLootRuiEntity

	var healthUseProgressRui

	var[eLootPromptStyle._COUNT]                lootPromptRui
	table<int, var[eLootPromptStyle._COUNT]>    lootTypePromptRui

	float nextHealthAllowTime = 0
	bool showTeammateUsefulIcon = false

	#if LOOT_GROUND_VERTICAL_LINES
		array<VerticalLineStruct> verticalLines
	#endif                                  

	table< entity, int > equipmentFX

	bool greyTierEnabled = false
	bool checkWeaponDisableForLootPingPrompt = false

	#if DEV
		bool devShowLootRefs = false
	#endif
} file

void function Cl_Survival_LootInit()
{
	if ( !WeaponDrivenConsumablesEnabled() )
	{
		RegisterConCommandTriggeredCallback( "+weaponcycle", AttemptCancelHeal )
	}
	RegisterConCommandTriggeredCallback( "+offhand2", AttemptCancelHeal )
	RegisterConCommandTriggeredCallback( "+attack", AttemptCancelHeal )
	RegisterConCommandTriggeredCallback( "+melee", AttemptCancelHeal )
	RegisterConCommandTriggeredCallback( "+speed", AttemptCancelHeal )
	RegisterConCommandTriggeredCallback( "+scriptCommand4", UseSelectedHealthPickupType )
	RegisterConCommandTriggeredCallback( "scoreboard_toggle_focus", UseSelectedHealthPickupType )
	RegisterConCommandTriggeredCallback( "+use_alt", TryHolsterWeapon )

	RegisterConCommandTriggeredCallback( "weaponSelectPrimary0", OnPlayerSwitchesToWeapon00 )
	RegisterConCommandTriggeredCallback( "weaponSelectPrimary1", OnPlayerSwitchesToWeapon01 )
	RegisterConCommandTriggeredCallback( "+weaponCycle", OnPlayerSwitchesWeapons )

	AddCreateTitanCockpitCallback( OnTitanCockpitCreated )
	AddCreatePilotCockpitCallback( OnPilotCockpitCreated )
	AddCallback_OnBleedoutStarted( Sur_OnBleedoutStarted )

	file.healthUseProgressRui = CreateCockpitRui( $"ui/health_use_progress.rpak", HUD_Z_BASE )

	AddCallback_OnPlayerLifeStateChanged( OnPlayerLifeStateChanged )

	AddCallback_UseEntGainFocus( Sur_OnUseEntGainFocus )
	AddCallback_UseEntLoseFocus( Sur_OnUseEntLoseFocus )

	AddCreateCallback( "prop_survival", OnPropCreated )
	AddCreateCallback( "prop_death_box", OnDeathBoxCreated )

	AddCallback_EntitiesDidLoad( SurvivalLoot_EntitiesDidLoad )

	#if LOOT_GROUND_VERTICAL_LINES
		for ( int i = 0; i < VERTICAL_LINE_COUNT; i++ )
		{
			var topo = RuiTopology_CreatePlane( <0, 0, 0>, <VERTICAL_LINE_WIDTH, 0, 0>, <0, 0, VERTICAL_LINE_HEIGHT>, true )
			var rui  = RuiCreate( $"ui/loot_pickup_line.rpak", topo, RUI_DRAW_WORLD, 0 )
			VerticalLineStruct v
			v.topo = topo
			v.rui = rui
			file.verticalLines.append( v )

			HideVerticalLineStruct( v )
		}
	#endif                                  

	#if HAS_ITEM_PICKUP_FEEDACK_FX
		                                            
	#endif   

	PrecacheParticleSystem( EVO_ARMOR_FX )
	PrecacheParticleSystem( EVO_ARMOR_PICKUP_FX )

	RegisterSignal( "TrackLootToPing" )
	RegisterSignal( "CreateDeathBoxRui" )

	var lootPromptRui   = CreateFullscreenRui( LOOT_PICKUP_HINT_DEFAULT_RUI, 1 )
	var weaponPromptRui = CreateFullscreenRui( WEAPON_PICKUP_HINT_DEFAULT_RUI, 1 )

	var compactLootPromptRui   = CreateFullscreenRui( LOOT_PICKUP_HINT_COMPACT_RUI, 1 )
	var compactWeaponPromptRui = CreateFullscreenRui( WEAPON_PICKUP_HINT_COMPACT_RUI, 1 )

	file.lootPromptRui[eLootPromptStyle.DEFAULT] = lootPromptRui
	file.lootPromptRui[eLootPromptStyle.COMPACT] = compactLootPromptRui

	file.lootTypePromptRui[eLootType.MAINWEAPON] <- _newPromptStyles()
	file.lootTypePromptRui[eLootType.MAINWEAPON][eLootPromptStyle.DEFAULT] = weaponPromptRui
	file.lootTypePromptRui[eLootType.MAINWEAPON][eLootPromptStyle.COMPACT] = compactWeaponPromptRui

	AddCallback_OnRefreshCustomGamepadBinds( OnRefreshCustomGamepadBinds )
	file.useAltBind = GetButtonBoundTo( "+use_alt" )

	file.showTeammateUsefulIcon = GetCurrentPlaylistVarBool( "enable_teammate_useful_icons", true )
	file.greyTierEnabled = GetCurrentPlaylistVarBool( "grey_tier_enabled", false )	                                                                                                   
	file.checkWeaponDisableForLootPingPrompt = GetCurrentPlaylistVarBool( "weapon_disable_disables_loot_prompt", false )
}


var[eLootPromptStyle._COUNT] function _newPromptStyles()
{
	var[eLootPromptStyle._COUNT] newArray;
	return newArray;
}


void function SurvivalLoot_EntitiesDidLoad()
{
	thread ManageDeathBoxLootThread()

	#if LOOT_GROUND_VERTICAL_LINES
		thread ManageVerticalLines()
	#endif                              
}


void function PlayLootPickupFeedbackFX( entity ent )
{
	thread function() : ( ent )
	{
		ent.EndSignal( "OnDestroy" )
		ent.SetPredictiveHideForPickup()
		wait 1.0
		ent.ClearPredictiveHideForPickup()
	}()

	Chroma_PredictedLootPickup( ent )

	#if HAS_ITEM_PICKUP_FEEDACK_FX
		                                                 
		                                   

		                           
		 
			                                                  
			                         

			                                                                                             
			                            

			                                                                                                                                     

			                            
		 
		    
		 
			                                                                                                 
		 
	#endif   

	if ( SURVIVAL_Loot_IsLootIndexValid( ent.GetSurvivalInt() ) )
	{
		vector origin     = ent.GetOrigin() + <0, 0, 15>
		vector angles     = ent.GetAngles()
		LootData lootData = SURVIVAL_Loot_GetLootDataByIndex( ent.GetSurvivalInt() )
		int lootType      = lootData.lootType

		if ( lootType == eLootType.ARMOR )
		{
			vector tierColor = GetFXRarityColorForTier( lootData.tier )

			if ( EvolvingArmor_IsEquipmentEvolvingArmor( lootData.ref ) )
			{
				int fxIdx    = GetParticleSystemIndex( EVO_ARMOR_PICKUP_FX )
				int pickupFX = StartParticleEffectInWorldWithHandle( fxIdx, origin, angles )
				EffectSetControlPointVector( pickupFX, 1, tierColor )
			}
		}
	}
}


void function DelayDestroy( entity mover )
{
	mover.EndSignal( "OnDestroy" )
	wait 0.5
	mover.Destroy()
}


bool function LootGoesInPack( entity player, LootRef lootRef )
{
	LootTypeData lt = GetLootTypeData( lootRef.lootData.lootType )

	if ( lootRef.lootData.inventorySlotCount == 0 )
		return false

	                                                                    
	if( lootRef.lootData.lootType == eLootType.GADGET  )
	{
		return false
	}

	PerfStart( PerfIndexClient.LootGoesInPack )

	bool result = (lt.groundActionFunc( player, lootRef ).action == eLootAction.PICKUP || lt.groundAltActionFunc( player, lootRef ).action == eLootAction.PICKUP)

	PerfEnd( PerfIndexClient.LootGoesInPack )

	return result
}


void function OnPlayerLifeStateChanged( entity player, int oldState, int newState )
{
	if ( player == GetLocalViewPlayer() )
	{
		if ( newState != LIFE_ALIVE )
		{
			RunUIScript( "CloseSurvivalInventoryMenu" )
			RuiSetBool( file.healthUseProgressRui, "isVisible", false )
		}
		else
		{
			thread TrackLootToPing( player )
		}
	}
}


void function Survival_Health_SetSelectedHealthPickupType( int pickup )
{
	Remote_ServerCallFunction( "ClientCallback_SetSelectedHealthPickupType", pickup )
}


int function Survival_Health_GetSelectedHealthPickupType()
{
	entity viewPlayer = GetLocalViewPlayer()
	if ( IsValid( viewPlayer ) )
		return viewPlayer.GetPlayerNetInt( "selectedHealthPickupType" )

	return eHealthPickupType.HEALTH_SMALL
}


void function UseSelectedHealthPickupType( entity player )
{
	if ( HealthkitWheelToggleEnabled() && IsCommsMenuActive() )
		return

	if ( WeaponDrivenConsumablesEnabled() )
	{
		Consumable_UseCurrentSelectedItem( player )
	}
	else
	{
		int selectedPickupType = Survival_Health_GetSelectedHealthPickupType()
		if ( selectedPickupType == -1 )
		{
			selectedPickupType = SURVIVAL_GetBestHealthPickupType( player )
			if ( !Survival_CanUseHealthPack( player, selectedPickupType, true ) )
			{
				                                                                                                                     
				  
				int idealKitType = SURVIVAL_GetBestHealthPickupType( player, false )
				Survival_CanUseHealthPack( player, idealKitType, true, true )
				return
			}
		}
		else
		{
			if ( !Survival_CanUseHealthPack( player, selectedPickupType, true, true ) )
				return
		}

		Survival_UseHealthPack( player, SURVIVAL_Loot_GetHealthPickupRefFromType( selectedPickupType ) )
	}
}


void function Survival_UseHealthPack( entity player, string ref )
{
	                                          
	  	      

	                                              
	Remote_ServerCallFunction( "ClientCallback_Sur_UseHealthPack", ref )
}


void function ServerToClient_OnStartedUsingHealthPack( int kitType )
{
	HealthPickup kitData = SURVIVAL_Loot_GetHealthKitDataFromStruct( kitType )
	LootData lootData    = kitData.lootData

	float waitScale
	if ( PlayerHasPassive( GetLocalViewPlayer(), ePassives.PAS_FAST_HEAL ) && (kitData.healAmount > 0) )
		waitScale = 0.5
	else
		waitScale = 1.0
	float waitTime = (kitData.interactionTime * waitScale)

	RuiSetBool( file.healthUseProgressRui, "isVisible", true )
	RuiSetImage( file.healthUseProgressRui, "icon", lootData.hudIcon )

	RuiSetGameTime( file.healthUseProgressRui, "startTime", Time() )
	RuiSetGameTime( file.healthUseProgressRui, "endTime", Time() + waitTime )
}


void function AttemptCancelHeal( entity player )
{
	if ( Survival_IsPlayerHealing( player ) )
	{
		if ( WeaponDrivenConsumablesEnabled() )
		{
			Consumable_CancelHeal( player )
		}
		else
		{
			RuiSetBool( file.healthUseProgressRui, "isVisible", false )
			Remote_ServerCallFunction( "ClientCallback_Sur_CancelHeal" )
		}
	}
}


void function HideHealthProgressRui()
{
	RuiSetBool( file.healthUseProgressRui, "isVisible", false )
}


void function OnPilotCockpitCreated( entity cockpit, entity player )
{
	HideHealthProgressRui()
}


void function OnTitanCockpitCreated( entity cockpit, entity player )
{
	HideHealthProgressRui()
}


void function Sur_OnBleedoutStarted( entity victim, float endTime )
{
	if ( victim != GetLocalViewPlayer() )
		return

	HideHealthProgressRui()
}


void function OnDeathBoxCreated( entity ent )
{
	if ( ent.GetTargetName() == DEATH_BOX_TARGETNAME )
	{
		AddEntityCallback_GetUseEntOverrideText( ent, DeathBoxTextOverride )
		ent.SetDoDestroyCallback( true )
		                                     

		if ( ent.GetOwner() == GetLocalClientPlayer() )
		{
			thread CreateDeathBoxRui( ent )
		}
	}
}


void function AttachCoverToDeathBox( entity ent )
{
	ent.EndSignal( "OnDestroy" )

	entity plane = CreateClientSidePropDynamic( ent.GetOrigin() + <0, 0, MAGIC_DEATHBOX_Z_OFFSET>, ent.GetAngles(), DEATH_BOX_FLAT_PLANE )
	plane.SetParent( ent )

	OnThreadEnd(
		function() : ( plane )
		{
			if ( IsValid( plane ) )
				plane.Destroy()
		}
	)

	WaitForever()
}


void function CreateDeathBoxRui( entity deathBox )
{
	EHI ornull ehi = GetDeathBoxOwnerEHI( deathBox )
	if ( ehi == null )
		return

	expect EHI( ehi )

	clGlobal.levelEnt.Signal( "CreateDeathBoxRui" )
	clGlobal.levelEnt.EndSignal( "CreateDeathBoxRui" )

	deathBox.EndSignal( "OnDestroy" )

	float scale      = 0.0820
	float width      = 264 * scale
	float height     = 720 * scale
	vector ang       = deathBox.GetAngles()
	vector rgt       = AnglesToRight( ang )
	vector up        = AnglesToUp( ang )
	entity player    = GetLocalViewPlayer()
	vector playerDir = player.GetOrigin() - deathBox.GetOrigin()
	bool onBoxRight  = DotProduct2D( rgt, playerDir ) < 0.0
	float direction  = onBoxRight ? 1.0 : -1.0
	vector right     = <0, 1, 0> * height * 0.5 * direction
	vector fwd       = <1, 0, 0> * width * 0.5 * direction * -1.0

	vector org = <0.5, 0, deathBox.GetBoundingMaxs().z + MAGIC_DEATHBOX_Z_OFFSET - 0.9>

	var topo = RuiTopology_CreatePlane( org - right * 0.5 - fwd * 0.5, fwd, right, true )
	RuiTopology_SetParent( topo, deathBox )

	NestedGladiatorCardHandle ornull nestedGCHandleOrNull = null

	var rui
	int ruiOverrideType = deathBox.GetNetInt( "overrideRUIType" )
	if ( ruiOverrideType == 2 )
	{
		const string playlistVar = "deathbox_rui_override_2"
		asset overrideAsset = GetCurrentPlaylistVarAsset( playlistVar )
		if ( overrideAsset == $"" )
		{
			Warning( "%s() - override type #%d specified, but playlist var '%s' is blank.", FUNC_NAME(), ruiOverrideType, playlistVar )
			return
		}
		rui = RuiCreate( overrideAsset, topo, RUI_DRAW_WORLD, MINIMAP_Z_BASE + 10 )
	}
	else
	{
		rui = RuiCreate( $"ui/gladiator_card_deathbox.rpak", topo, RUI_DRAW_WORLD, MINIMAP_Z_BASE + 10 )
		NestedGladiatorCardHandle nestedGCHandle = CreateNestedGladiatorCard( rui, "card", eGladCardDisplaySituation.DEATH_BOX_STILL, eGladCardPresentation.FRONT_DETAILS )
		nestedGCHandleOrNull = nestedGCHandle

		if ( ruiOverrideType == 1 )
			CreateDeathBoxRuiWithOverridenData( deathBox, nestedGCHandle )

		ChangeNestedGladiatorCardOwner( nestedGCHandle, ehi, null, eGladCardLifestateOverride.ALIVE )
	}

	OnThreadEnd (
		void function() : ( topo, rui, nestedGCHandleOrNull )
		{
			if ( nestedGCHandleOrNull != null )
				CleanupNestedGladiatorCard( expect NestedGladiatorCardHandle( nestedGCHandleOrNull ) )
			RuiDestroy( rui )
			RuiTopology_Destroy( topo )
		}
	)

	entity plane = CreateClientSidePropDynamic( deathBox.GetOrigin() + <0, 0, MAGIC_DEATHBOX_Z_OFFSET>, deathBox.GetAngles(), DEATH_BOX_FLAT_PLANE )
	plane.SetParent( deathBox )

	OnThreadEnd(
		function() : ( plane )
		{
			if ( IsValid( plane ) )
				plane.Destroy()
		}
	)

	WaitFrame()
	WaitForever()
}


string function DeathBoxTextOverride( entity ent )
{
	if ( ent.e.isBusy )
		return " "

                 
                                                                           
  
                                
  
       

	entity localViewPlayer = GetLocalViewPlayer()
	if ( ShouldPickupDNAFromDeathBox( ent, localViewPlayer ) )
	{
		string localizedHint = ""
		if ( ent.GetCustomOwnerName() != "" )
			localizedHint = Localize( "#HINT_PICKUP_DNA_USE", ent.GetCustomOwnerName() )
		else
			localizedHint = Localize( "#HINT_PICKUP_DNA_USE", ent.GetOwner().GetPlayerName() )

		if ( DeathboxNetwork_CanPlayerUse( localViewPlayer, ent ) )
			localizedHint = Localize( "#PAS_ASH_ADDITIONAL_USE_PROMPT" ) + "\n" + localizedHint

		if ( ShouldUseAltInteractForArmorSwap() )
		{
			entity ornull armorEnt = GetDeathboxArmorSwap( localViewPlayer, ent )
			if ( armorEnt != null )
			{
				expect entity( armorEnt )
				localizedHint = localizedHint + "\n" + Localize( "#HINT_PICKUP_SWAP_ARMOR", GetPropSurvivalMainPropertyFromEnt( armorEnt ) )
			}
		}

		return localizedHint
	}

	if ( ent.GetLinkEntArray().len() == 0 )
	{
		if ( DeathboxNetwork_CanPlayerUse( localViewPlayer, ent ) )
			return Localize( "#PAS_ASH_ADDITIONAL_USE_PROMPT" )

		return " "
	}

	EHI ornull ehi = GetDeathBoxOwnerEHI( ent )
	if ( ehi == null )
		return ""
	expect EHI( ehi )
	if ( !EHIHasValidScriptStruct( ehi ) )
		return ""

	int team          = EHI_GetTeam( ehi )
	string playerName = GetPlayerNameFromEHI( ehi )

	if ( ent.GetCustomOwnerName() != "" )                                             
		playerName = ent.GetCustomOwnerName()

	string hint = "#DEATHBOX_HINT_NAME"


	if ( IsEnemyTeam( team, localViewPlayer.GetTeam() ) )
		hint = "#DEATHBOX_HINT_ENEMY"

	string localizedHint = Localize( hint, playerName )

	if ( DeathboxNetwork_CanPlayerUse( localViewPlayer, ent ) )
		localizedHint = Localize( "#PAS_ASH_ADDITIONAL_USE_PROMPT" ) + "\n" + localizedHint

	if ( ShouldUseAltInteractForArmorSwap() )
	{
		entity ornull armorEnt = GetDeathboxArmorSwap( localViewPlayer, ent )
		if ( armorEnt != null )
		{
			expect entity( armorEnt )
			localizedHint = localizedHint + "\n" + Localize( "#HINT_PICKUP_SWAP_ARMOR", GetPropSurvivalMainPropertyFromEnt( armorEnt ) )
		}
	}

	return localizedHint
}


void function OnPropCreated( entity prop )
{
	AddEntityCallback_GetUseEntOverrideText( prop, Sur_LootTextOverride )

	ApplyEquipmentColorAndFXOverrides( prop )
}


var function GetLootPrompt( entity lootEnt )
{
	int style = GetLootPromptStyle()

	LootData data = SURVIVAL_Loot_GetLootDataByIndex( lootEnt.GetSurvivalInt() )
	if ( data.lootType in file.lootTypePromptRui )
		return file.lootTypePromptRui[data.lootType][style]

	return file.lootPromptRui[style]
}


int lastPromptStyle
int function GetLootPromptStyle()
{
	int style = GetConVarInt( HUD_SETTING_LOOTPROMPTSTYLE )
	Assert( style < eLootPromptStyle._COUNT )

	if ( style != lastPromptStyle )
		HideLootPrompts()

	lastPromptStyle = style

	return style
}


void function HideLootPrompts()
{
	foreach ( lootType, ruis in file.lootTypePromptRui )
	{
		foreach ( rui in ruis )
		{
			RuiSetVisible( rui, false )
			RuiSetBool( rui, "isVisible", false )
		}
	}

	foreach ( rui in file.lootPromptRui )
	{
		RuiSetVisible( rui, false )
		RuiSetBool( rui, "isVisible", false )
	}
}


bool function ShouldOpenQuickswap( LootRef lootRef )
{
	entity player = GetLocalViewPlayer()

	if ( LootGoesInPack( GetLocalViewPlayer(), lootRef ) )
	{
		if ( SURVIVAL_AddToPlayerInventory( player, lootRef.lootData.ref, lootRef.count, false ) == 0 )
			return true
	}

	return false
}


string function Sur_LootTextOverride( entity ent )
{
	var rui = GetLootPrompt( ent )

	if ( Time() - ent.e.lastUseTime < 0.5 )
	{
		RuiSetVisible( rui, false )
	}
	else
	{
		RuiSetVisible( rui, true )
	}

	UpdateUseHintForEntity( ent )

	LootData lootData = SURVIVAL_Loot_GetLootDataByIndex( ent.GetSurvivalInt() )
	LootRef lootRef   = SURVIVAL_CreateLootRef( lootData, ent )
	lootRef.count = ent.GetClipCount()

	if ( ShouldOpenQuickswap( lootRef ) )
	{
		LootActionStruct asMain = SURVIVAL_BuildStringForAction( GetLocalViewPlayer(), eLootContext.GROUND, lootRef, false, false )
		LootActionStruct asAlt  = SURVIVAL_BuildStringForAction( GetLocalViewPlayer(), eLootContext.GROUND, lootRef, true, false )


		if ( asMain.action == eLootAction.PICKUP )
		{
			if ( GetLootPromptStyle() == eLootPromptStyle.COMPACT )
				RuiSetString( rui, "usePromptText", Localize( "#HINT_SWAP_COMPACT" ) )
			else
				RuiSetString( rui, "usePromptText", Localize( "#HINT_SWAP_ON_USE" ) )
		}
		else if ( asAlt.action == eLootAction.PICKUP && ShouldShowButtonHints() )
		{
			if ( GetLootPromptStyle() == eLootPromptStyle.COMPACT )
				RuiSetString( rui, "altUsePromptText", Localize( "#HINT_SWAP_COMPACT_ALT" ) )
			else
				RuiSetString( rui, "altUsePromptText", Localize( "#HINT_SWAP_ON_USE_ALT" ) )
		}
	}

	return ""
}


void function Sur_OnUseEntGainFocus( entity ent )
{
	UpdateUseHintForEntity( ent )

	if ( ent.GetNetworkedClassName() == "prop_survival" )
	{
		GetLocalViewPlayer().Signal( "TrackLootToPing" )

		ent.e.isSelected = true
		SURVIVAL_Loot_UpdateHighlightForLoot( ent )
		RuiSetGameTime( GetLootPrompt( ent ), "lastUseTime", 0 )

		int index = ent.GetSurvivalInt()

		LootData data = SURVIVAL_Loot_GetLootDataByIndex( index )
		if ( data.lootType == eLootType.MAINWEAPON )
			TryStreamHintForWeapon( ent )
	}
	else if ( ent.GetTargetName() == DEATH_BOX_TARGETNAME )
	{
		thread CreateDeathBoxRui( ent )
	}
}


void function TryStreamHintForWeapon( entity ent )
{
	int skinNetworkIdx = GetPropSurvivalMainProperty( ent.GetSurvivalProperty() )
	ItemFlavor ornull weaponSkinOrNull
	if ( skinNetworkIdx > 0 )
	{
		weaponSkinOrNull = GetItemFlavorByNetworkIndex( skinNetworkIdx )
	}
	else
	{
		ItemFlavor ornull weaponItemOrNull = GetWeaponItemFlavorByClass( ent.GetWeaponName() )
		if ( weaponItemOrNull != null )
		{
			expect ItemFlavor( weaponItemOrNull )
			if ( LoadoutSlot_IsReady( ToEHI( GetLocalViewPlayer() ), Loadout_WeaponSkin( weaponItemOrNull  ) ) )
				weaponSkinOrNull = LoadoutSlot_GetItemFlavor( ToEHI( GetLocalViewPlayer() ), Loadout_WeaponSkin( weaponItemOrNull ) )
		}
	}

	if ( weaponSkinOrNull == null )
		return

	expect ItemFlavor( weaponSkinOrNull )


	if ( ItemFlavor_GetType( weaponSkinOrNull ) != eItemType.weapon_skin )                                                                                                    
		return

	asset viewModel = WeaponSkin_GetViewModel( weaponSkinOrNull )

	StreamModelHint( viewModel )
}


void function Sur_OnUseEntLoseFocus( entity ent )
{
	if ( IsValid( GetLocalViewPlayer() ) )
		thread TrackLootToPing( GetLocalViewPlayer() )

	HideLootPrompts()

	clGlobal.levelEnt.Signal( "ClearSwapOnUseThread" )
	                                                 

	if ( IsValid( ent ) && ent.GetNetworkedClassName() == "prop_survival" )
	{
		ent.e.isSelected = false
		SURVIVAL_Loot_UpdateHighlightForLoot( ent )
	}
}


void function SURVIVAL_Loot_UpdateRuiLastUseTime( entity ent, var rui = null )
{
	if ( !IsConnected() )
		return

	if ( rui == null )
		rui = GetLootPrompt( ent )

	RuiSetGameTime( rui, "lastUseTime", Time() )
}


void function UpdateUseHintForEntity( entity ent, var rui = null )
{
	if ( !IsConnected() )
		return

	if ( !ShouldLootHintBeVisible( ent ) )
	{
		HideLootPrompts()
		if ( rui != null )
			RuiSetVisible( rui, false )
		return
	}

	PerfStart( PerfIndexClient.UpdateLootRui )

	if ( rui == null )
		rui = GetLootPrompt( ent )

	entity player                 = GetLocalViewPlayer()
	bool isPinged                 = Waypoint_LootItemIsBeingPingedByAnyone( ent )
	entity focusedWp              = GetFocusedWaypointEnt()
	bool isFocusedOnOtherWaypoint = (IsValid( focusedWp ) && (focusedWp != ent))
	LootData data                 = SURVIVAL_Loot_GetLootDataByIndex( ent.GetSurvivalInt() )

	RuiSetBool( rui, "isTooltip", false )
	RuiSetBool( rui, "isPinged", isPinged )
	RuiSetBool( rui, "isFocusedOnOtherWaypoint", isFocusedOnOtherWaypoint )
	RuiSetGameTime( rui, "localPingBeginTime", ent.e.localPingBeginTime )

	LootRef lootRef = SURVIVAL_CreateLootRef( data, ent )
	lootRef.count = ent.GetClipCount()
	UpdateLootRuiWithData( player, rui, data, eLootContext.GROUND, lootRef, false )

	entity pingWaypoint = Waypoint_GetWaypointForLootItemPingedByPlayer( ent, player )
	RuiSetBool( rui, "isPingedByUs", IsValid( pingWaypoint ) )
	RuiSetInt( rui, "eHandle", ent.GetEncodedEHandle() )
	RuiSetInt( rui, "predictedUseCount", ent.e.predictedUseCount )

	RuiTrackFloat3( rui, "worldPos", ent, RUI_TRACK_ABSORIGIN_FOLLOW )
	RuiSetFloat( rui, "zOffset", ent.GetBoundingMaxs().z )

	PerfEnd( PerfIndexClient.UpdateLootRui )
}


table<string, string> function BuildAttachmentMapForPickupPrompt( entity player, LootData data, LootRef lootRef, LootActionStruct asMain )
{
	                      
	if ( IsValid( lootRef.lootEnt ) && SURVIVAL_Weapon_IsAttachmentLocked( data.ref ) )
	{
		table<string, string> results
		array<string> mods = lootRef.lootEnt.GetWeaponMods()
		foreach ( mod in mods )
		{
			if ( SURVIVAL_Loot_IsRefValid( mod ) && (SURVIVAL_Loot_GetLootDataByRef( mod ).lootType == eLootType.ATTACHMENT) )
			{
				array<string> attachPoints = GetAttachPointsForAttachment( mod )
				foreach ( string attachPoint in attachPoints )
				{
					results[attachPoint] <- mod
				}
			}
		}

		return results
	}

	                                   
	array<entity> weapons = SURVIVAL_GetPrimaryWeaponsSorted( player )
	entity latestPrimary  = (weapons.len() > 0) ? weapons[0] : null
	if ( IsValid( latestPrimary ) && (asMain.action == eLootAction.SWAP) )
	{
		LootData weapData = SURVIVAL_GetLootDataFromWeapon( latestPrimary )
		if ( (weapData.lootType == eLootType.MAINWEAPON) && SURVIVAL_Loot_IsRefValid( weapData.ref ) && !SURVIVAL_Weapon_IsAttachmentLocked( weapData.ref ) )
			return GetCompatibleAttachmentMap( player, latestPrimary, data.ref, true )
	}

	  
	return GetCompatibleAttachmentsFromInventory( player, data.ref )
}


table<string, CustomItemPromptUpdateCB_t> s_customItemPromptUpdateCallbacks
void function RegisterCustomItemPromptUpdate( string lootRef, CustomItemPromptUpdateCB_t func )
{
	Assert( !(lootRef in s_customItemPromptUpdateCallbacks) )
	s_customItemPromptUpdateCallbacks[lootRef] <- func
}


void function UpdateLootRuiWithData( entity player, var rui, LootData data, int lootContext, LootRef lootRef, bool isInMenu )
{
	RuiSetVisible( rui, true )
	RuiDestroyNestedIfAlive( rui, "compatibleWeaponsHandle" )
	var nestedCompatibleWeaponsRui = RuiCreateNested( rui, "compatibleWeaponsHandle", $"ui/loot_pickup_tag_text.rpak" )
	RuiSetBool( rui, "teammateNeedsThis", false )

	if ( file.showTeammateUsefulIcon )
	{
		foreach ( teammate in GetPlayerArrayOfTeam_Alive( player.GetTeam() ) )
		{
			if ( teammate == player )
				continue

			if ( SURVIVAL_IsLootAnUpgrade( teammate, lootRef.lootEnt, data, lootContext ) )
			{
				RuiSetBool( rui, "teammateNeedsThis", true )
				break
			}
		}
	}

	RuiSetBool( rui, "isVisible", true )
	RuiSetBool( rui, "isFocused", true )

	RuiSetImage( rui, "iconImage", data.hudIcon )
	RuiSetInt( rui, "lootTier", data.tier )

	vector iconScale = data.lootType == eLootType.MAINWEAPON ? <2.0, 1.0, 0.0> : <1.0, 1.0, 0.0>
	RuiSetFloat2( rui, "iconScale", iconScale )

	RuiSetString( rui, "titleText", Localize( data.pickupString ).toupper() )
	#if DEV
		if ( file.devShowLootRefs )
			RuiSetString( rui, "titleText", Localize( data.pickupString ).toupper() + " | " + data.ref )
	#endif
	RuiSetString( rui, "subText", SURVIVAL_Loot_GetDesc( data, player ) )

	RuiSetBool( rui, "canPing", ShouldShowButtonHints() && IsPingEnabledForPlayer( player ) && IsValid( lootRef.lootEnt ) )

	string passiveName = data.passive != ePassives.INVALID ? PASSIVE_NAME_MAP[data.passive] : ""
	string passiveDesc = data.passive != ePassives.INVALID ? PASSIVE_DESCRIPTION_SHORT_MAP[data.passive] : ""
	RuiSetString( rui, "passiveText", passiveName )
	RuiSetString( rui, "passiveDesc", passiveDesc )

	LootActionStruct asMain = SURVIVAL_BuildStringForAction( player, lootContext, lootRef, false, isInMenu )
	LootActionStruct asAlt  = SURVIVAL_BuildStringForAction( player, lootContext, lootRef, true, isInMenu )

	RuiSetInt( rui, "lootTierReplace", 0 )
	RuiSetImage( rui, "replaceImage", $"" )
	RuiSetString( rui, "replacePassive", "" )
	RuiSetString( rui, "replaceName", "" )
	RuiSetBool( rui, "hasReplace", false )
	RuiSetInt( rui, "propertyValue", -1 )
	RuiSetInt( rui, "replacePropertyValue", -1 )
	RuiSetInt( rui, "extraPropertyValue", -1 )
	RuiSetInt( rui, "replaceExtraPropertyValue", -1 )
	RuiSetString( rui, "replaceSlot", Localize("#REPLACE" ) )

	if ( lootRef.lootData.lootType == eLootType.ARMOR )
	{
		RuiSetBool( rui, "isEvolvingArmor", EvolvingArmor_IsEquipmentEvolvingArmor( lootRef.lootData.ref ) )
	}

	RuiSetString( rui, "usePromptText", asMain.displayString )
	if ( asMain.additionalData.ref != ""
	&& !SURVIVAL_EquipmentPretendsToBeBlank( asMain.additionalData.ref ) )
	{
		RuiSetInt( rui, "lootTierReplace", asMain.additionalData.tier )
		RuiSetImage( rui, "replaceImage", asMain.additionalData.hudIcon )
		if ( asMain.additionalData.pickupString.len() <= 1 )
			RuiSetString( rui, "replaceName", "#EMPTY" )
		else
			RuiSetString( rui, "replaceName", asMain.additionalData.pickupString )

		RuiSetBool( rui, "hasReplace", true )

		if ( asMain.additionalData.passive != ePassives.INVALID )
		{
			RuiSetString( rui, "replacePassive", PASSIVE_NAME_MAP[asMain.additionalData.passive] )
		}

		if ( asMain.additionalData.lootType == eLootType.ARMOR )
		{
			int replacePropertyValue = int( SURVIVAL_GetPlayerShieldHealthFromArmor( player ) / float(SURVIVAL_GetCharacterShieldHealthMaxForArmor( player, asMain.additionalData )) * 100)
			                                                                                                                                                                                

			if ( EvolvingArmor_IsEquipmentEvolvingArmor( asMain.additionalData.ref ) )
			{
				                                                                                                                                                                                 
                                 
                                                                                                                                                                                
         
					replacePropertyValue = int( SURVIVAL_GetPlayerShieldHealthFromArmor( player ) / float(SURVIVAL_GetCharacterShieldHealthMaxForArmor( player, asMain.additionalData )) * 125)
          
				RuiSetBool( rui, "isReplaceEvolvingArmor", EvolvingArmor_IsEquipmentEvolvingArmor( asMain.additionalData.ref ) )

				RuiSetInt( rui, "replaceExtraPropertyValue", EvolvingArmor_GetEvolutionProgress( player ) )
			}
			else
			{
				RuiSetBool( rui, "isReplaceEvolvingArmor", false )
			}
			RuiSetInt( rui, "replacePropertyValue", replacePropertyValue )
		}
	}

	RuiSetString( rui, "altUsePromptText", "" )

	if ( asMain.action != asAlt.action )
	{
		if ( ShouldShowButtonHints() || isInMenu )
			RuiSetString( rui, "altUsePromptText", asAlt.displayString )

		if ( asAlt.additionalData.ref != "" )
		{
			RuiSetInt( rui, "lootTierReplace", asAlt.additionalData.tier )
			RuiSetImage( rui, "replaceImage", asAlt.additionalData.hudIcon )
			RuiSetString( rui, "replaceName", asAlt.additionalData.pickupString )
			RuiSetBool( rui, "hasReplace", true )
		}
	}

	RuiSetBool( rui, "isSurvivalGadget", false )

	if ( (data.lootType == eLootType.HEALTH || data.lootType == eLootType.AMMO || data.lootType == eLootType.ORDNANCE ) && lootRef.count > 1 )
	{
		RuiSetString( rui, "titleText", Localize( "#SURVIVAL_PICKUP_STACK_COUNT", Localize( data.pickupString ).toupper(), lootRef.count ) )
		#if DEV
			if ( file.devShowLootRefs )
				RuiSetString( rui, "titleText", Localize( "#SURVIVAL_PICKUP_STACK_COUNT", Localize( data.pickupString ).toupper(), lootRef.count ) + " | " + data.ref )
		#endif
	}
	else if ( data.lootType == eLootType.GADGET )
	{
		RuiSetBool( rui, "isSurvivalGadget", true )
		RuiSetInt( rui, "propertyValue", lootRef.count )
		RuiSetInt( rui, "extraPropertyValue", lootRef.lootData.inventorySlotCount )
	}
	else if ( data.lootType == eLootType.ARMOR )
	{
		if ( !isInMenu && GetLootPromptStyle() == eLootPromptStyle.COMPACT )
		{
			RuiSetString( rui, "titleText", Localize( "#SURVIVAL_PICKUP_ARMOR_STATUS", Localize( data.pickupString ).toupper(), GetPropSurvivalMainProperty( lootRef.lootProperty ), SURVIVAL_GetArmorShieldCapacity( data.tier ) ) )

			if ( EvolvingArmor_IsEquipmentEvolvingArmor( data.ref ) )
				RuiSetString( rui, "titleText", Localize( "#SURVIVAL_PICKUP_ARMOR_STATUS", Localize( data.pickupString ).toupper(), GetPropSurvivalMainProperty( lootRef.lootProperty ), EvolvingArmor_GetEvolvingArmorHealthForTier( data.tier ) ) )
		}

		int shieldPropertyValue = 0
		if ( EvolvingArmor_IsEquipmentEvolvingArmor( data.ref ) )
		{
			int propertyValue = GetPropSurvivalMainProperty( lootRef.lootProperty )
			int armorHealthForTier = EvolvingArmor_GetEvolvingArmorHealthForTier( data.tier )

			if ( armorHealthForTier > 0.0 )
			{
				float armorPct = propertyValue / float(armorHealthForTier)
                                 
                                              
         
				shieldPropertyValue = int( armorPct * 125)
          
			}
		}
		else
		{
			int armorHealthForTier = SURVIVAL_GetArmorShieldCapacity( data.tier )
			if ( armorHealthForTier > 0.0 )
			{
				float armorPct = lootRef.lootProperty / float(armorHealthForTier)
				shieldPropertyValue = int( armorPct * 100 )
			}
		}
		RuiSetInt( rui, "propertyValue", shieldPropertyValue )
		RuiSetInt( rui, "extraPropertyValue", lootRef.lootExrtaProperty )
	}

	if ( data.lootType == eLootType.MAINWEAPON && GetWeaponInfoFileKeyField_GlobalBool( data.baseWeapon, "uses_ammo_pool" ) )
	{
		string ammoType   = data.ammoType
		LootData ammoData = SURVIVAL_Loot_GetLootDataByRef( ammoType )
		RuiSetImage( rui, "ammoImage", ammoData.hudIcon )
	}
	else
	{
		asset icon = data.fakeAmmoIcon
		RuiSetImage( rui, "ammoImage", icon )
	}

	RuiSetImage( rui, "attachWeapon1Icon", $"" )
	RuiSetBool( rui, "hasAttach1", false )

	for( int weaponIndex = WEAPON_INVENTORY_SLOT_PRIMARY_0; weaponIndex <= WEAPON_INVENTORY_SLOT_PRIMARY_1; ++weaponIndex )
	{
		entity weapon = player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_0 + weaponIndex )
		if ( !IsValid( weapon ) )
			continue

		string weaponName = weapon.GetWeaponClassName()

		if ( GetWeaponInfoFileKeyField_GlobalInt_WithDefault ( weaponName, "has_energized", 0 ) == 1 )
		{
			string energizedConsumableData = GetWeaponInfoFileKeyField_GlobalString ( weaponName, "energized_consumable" )
			string weaponNameString = GetWeaponInfoFileKeyField_WithMods_GlobalString ( weaponName, weapon.GetMods(), "printname" )
			string consumableHint = GetWeaponInfoFileKeyField_GlobalString ( weaponName, "energized_consumable_hint" )

			LootData weaponData = SURVIVAL_Loot_GetLootDataByRef ( weaponName )
			LootData ordanenceData = SURVIVAL_Loot_GetLootDataByRef ( energizedConsumableData )

			if ( lootRef.lootData.baseWeapon == energizedConsumableData )
			{
				RuiSetString( rui, "replaceSlot", Localize( weaponNameString ) )
				RuiSetString( rui, "replaceName", Localize( consumableHint ) )
				RuiSetImage( rui, "attachWeapon1Icon", weaponData.hudIcon )
				RuiSetImage( rui, "replaceImage", ordanenceData.hudIcon )
				RuiSetBool( rui, "hasReplace", true )
				RuiSetBool( rui, "hasAttach1", true )
			}
		}

	}

	const int MAX_ATTACHMENT_TAGS = 6
	const int NUM_OF_CATEGORIES_TO_BE_CONSIDERED_UNIVERSAL = 5                                                                                                                     
	for ( int index = 0; index < MAX_ATTACHMENT_TAGS; index++ )
	{
		RuiSetString( nestedCompatibleWeaponsRui, "tagText" + (index + 1), "" )
	}
	RuiSetInt( nestedCompatibleWeaponsRui, "numTags", 0 )

	RuiSetString( rui, "typeText", "" )
	RuiSetString( rui, "typeTextTag", "" )

	string generalType = SURVIVAL_Loot_GetGeneralTypeString( data )
	string detailType  = SURVIVAL_Loot_GetDetailTypeString( data )
	string detailType2  = SURVIVAL_Loot_GetDetailType2String( data )

	if ( data.lootType == eLootType.MAINWEAPON )
	{
		RuiSetString( rui, "skinName", "" )
		RuiSetInt( rui, "skinTier", 0 )

		RuiSetBool( rui, "isFullyKitted", SURVIVAL_Weapon_IsAttachmentLocked( data.ref ) )

		int skinNetworkIdx = GetPropSurvivalMainProperty( lootRef.lootProperty )
		if ( skinNetworkIdx > 0 )
		{
			ItemFlavor weaponSkin = GetItemFlavorByNetworkIndex( skinNetworkIdx )
			if ( ItemFlavor_HasQuality( weaponSkin ) )
			{
				string weaponName = GetWeaponInfoFileKeyField_WithMods_GlobalString( data.baseWeapon, data.baseMods,"shortprintname" )
				RuiSetString( rui, "titleText", Localize( weaponName ).toupper() )
				RuiSetString( rui, "skinName", ItemFlavor_GetLongName( weaponSkin ) )
				RuiSetInt( rui, "skinTier", ItemFlavor_GetQuality( weaponSkin ) + 1 )
			}
		}

		for ( int index = 0; index < 5; index++ )
		{
			RuiSetImage( rui, "attachEmptyImage" + (index + 1), $"" )
			RuiSetImage( rui, "attachImage" + (index + 1), $"" )
			RuiSetInt( rui, "attachTier" + (index + 1), -1 )
		}

		RuiSetString( rui, "typeText", Localize( "#LOOT_TYPE_WEAPON", Localize( generalType ) ) )
		RuiSetString( rui, "typeTextTag", detailType )
		                                                                                                                          

		int attachmentCount                 = 0
		int numSwaps                        = 0
		table<string, string> attachmentMap = BuildAttachmentMapForPickupPrompt( player, data, lootRef, asMain )
		foreach ( string attachmentPoint in data.supportedAttachments )
		{
			attachmentCount++

			string attachmentStyle = GetAttachmentPointStyle( attachmentPoint, data.ref )
			if ( attachmentPoint in attachmentMap && attachmentMap[attachmentPoint] != "" )
			{
				LootData attachmentData = SURVIVAL_Loot_GetLootDataByRef( attachmentMap[attachmentPoint] )
				RuiSetImage( rui, "attachImage" + attachmentCount, attachmentData.hudIcon )
				RuiSetInt( rui, "attachTier" + attachmentCount, attachmentData.tier )

				if ( SURVIVAL_IsAttachmentPointLocked( data.ref, attachmentPoint ) )
					RuiSetInt( rui, "attachTier" + attachmentCount, data.tier )
				else if ( !SURVIVAL_Weapon_IsAttachmentLocked( data.ref ) )
					numSwaps++
			}
			else
			{
				RuiSetImage( rui, "attachImage" + attachmentCount, $"" )
				RuiSetInt( rui, "attachTier" + attachmentCount, 0 )
			}

			RuiSetImage( rui, "attachEmptyImage" + attachmentCount, emptyAttachmentSlotImages[attachmentStyle] )
		}

		if ( numSwaps > 1 )
			RuiSetString( rui, "attachSwapText", Localize( "#LOOT_SWAP_COUNT_N", numSwaps ) )
		else if ( numSwaps == 1 )
			RuiSetString( rui, "attachSwapText", Localize( "#LOOT_SWAP_COUNT_1", numSwaps ) )
		else
			RuiSetString( rui, "attachSwapText", "" )
	}
	else if ( detailType != "" )
	{
		RuiSetString( rui, "typeText", Localize( "#LOOT_TYPE_GENERAL", Localize( generalType ), Localize( detailType ) ) )
	}
	else
	{
		RuiSetString( rui, "typeText", Localize( generalType ) )
	}


	if ( data.lootType == eLootType.ATTACHMENT )
	{
		array<entity> weapons = SURVIVAL_GetPrimaryWeaponsSorted( player )

		int action = asAlt.action

		if ( action != eLootAction.ATTACH_TO_ACTIVE && action != eLootAction.ATTACH_TO_STOWED )
			action = asMain.action

		int slot = -1
		if ( action == eLootAction.ATTACH_TO_ACTIVE )
		{
			slot = 0
		}

		if ( action == eLootAction.ATTACH_TO_STOWED )
		{
			slot = 1
		}

		if ( slot != -1 && slot < weapons.len() )
		{
			entity weapon = weapons[slot]
			if ( SURVIVAL_Loot_IsRefValid( weapon.GetWeaponClassName() ) )
			{
				LootData weaponData = SURVIVAL_Loot_GetLootDataByRef( weapon.GetWeaponClassName() )
				RuiSetImage( rui, "attachWeapon1Icon", weaponData.hudIcon )
				RuiSetBool( rui, "hasAttach1", true )
			}
		}

		AttachmentTagData attachmentTagData = AttachmentTags( data.ref )
		RuiSetInt( nestedCompatibleWeaponsRui, "numTags", attachmentTagData.attachmentTags.len() )

		if ( attachmentTagData.ammoRef != "" )
		{
			LootData ammoData = SURVIVAL_Loot_GetLootDataByRef( attachmentTagData.ammoRef )

			string lootFitTip
			if ( !AttachesToAllWeaponsOfAmmoType( data.ref ) )
				lootFitTip = "#LOOT_FIT_MOST_AMMO"
			else
				lootFitTip = "#LOOT_FIT_AMMO"

			RuiSetString( nestedCompatibleWeaponsRui, "tagText1", Localize( lootFitTip, ammoData.hudIcon ) )
		}
		else
		{
			if ( attachmentTagData.attachmentTags.len() >= NUM_OF_CATEGORIES_TO_BE_CONSIDERED_UNIVERSAL && passiveDesc == "" )
			{
				RuiSetString( nestedCompatibleWeaponsRui, "tagText1", "#TAG_ALL_WEAPONS" )
			}
			else
			{
				int tagIndex = 0
				foreach ( int tagId in attachmentTagData.attachmentTags )
				{
					if ( tagIndex < MAX_ATTACHMENT_TAGS && passiveDesc == "" )
					{
						if ( tagId in attachmentTagData.exceptionToTheRuleForThisWeaponClass )
							RuiSetString( nestedCompatibleWeaponsRui, "tagText" + (tagIndex + 1), Localize( "#WEAPON_CLASS_HAS_EXCEPTION", Localize( GetStringForTagId( tagId ) ) ) )                                                                                       
						else
							RuiSetString( nestedCompatibleWeaponsRui, "tagText" + (tagIndex + 1), GetStringForTagId( tagId ) )

						tagIndex++
					}
				}

				foreach ( index, weaponRef in attachmentTagData.weaponRefs )
				{
					if ( tagIndex < MAX_ATTACHMENT_TAGS && passiveDesc == "" )
					{
						string weaponName = GetWeaponInfoFileKeyField_GlobalString( weaponRef, "shortprintname" )
						if ( index < attachmentTagData.weaponRefs.len() - 1 && tagIndex < MAX_ATTACHMENT_TAGS - 1 )
							weaponName += ","

						RuiSetString( nestedCompatibleWeaponsRui, "tagText" + (tagIndex + 1), weaponName )

						tagIndex++
					}
				}

				int exceptionIndex = 0
				foreach ( int tagId in attachmentTagData.attachmentTags )
				{
					if ( tagIndex < MAX_ATTACHMENT_TAGS && passiveDesc == "" )
					{
						if ( tagId in attachmentTagData.exceptionToTheRuleForThisWeaponClass )
						{
							string exceptionName = GetWeaponInfoFileKeyField_GlobalString( attachmentTagData.exceptionToTheRuleForThisWeaponClass[tagId], "shortprintname" )
							if ( exceptionIndex < attachmentTagData.exceptionToTheRuleForThisWeaponClass.len() - 1 && tagIndex < MAX_ATTACHMENT_TAGS - 1 )
								exceptionName += ","

							                                                                                                                                                         
							                                                                                                                                                              
							if ( tagIndex == 2 )
								tagIndex = 3

							RuiSetString( nestedCompatibleWeaponsRui, "tagText" + ( tagIndex + 1 ), Localize( "#EXCEPT_WEAPON", exceptionName ) )

							tagIndex++
							exceptionIndex++
						}
					}
				}
			}
		}
	}
	else if ( data.lootType == eLootType.AMMO )
	{
		array<entity> weapons = SURVIVAL_GetPrimaryWeaponsSorted( player )

                           
                                                                                             
                                                                 
        

		array<string> weaponNames
		foreach ( weapon in weapons )
		{
			weaponNames.append( weapon.GetWeaponClassName() )
		}


                   
                                                                              
                                              
    
                                                                   
                                              
    
        

		foreach ( weaponRef in weaponNames )
		{
			if ( SURVIVAL_Loot_IsRefValid( weaponRef ) && IsWeaponKeyFieldDefined( weaponRef, "ammo_pool_type" ) )
			{
				string ammoType = GetWeaponAmmoType( weaponRef )
				string secondaryAmmoType = GetWeaponInfoFileKeyField_GlobalString( weaponRef, "secondary_ammo_pool_type" )
				if ( ammoType == data.ref || secondaryAmmoType == data.ref )
				{
					LootData weaponData = SURVIVAL_Loot_GetLootDataByRef( weaponRef )
                             
                                                                                               
                                                   
         
                                                                 
         
					RuiSetImage( rui, "attachWeapon1Icon", weaponData.hudIcon )
          

					RuiSetBool( rui, "hasAttach1", true )
					break
				}
			}
		}
	}

	if ( data.ref in s_customItemPromptUpdateCallbacks )
		(s_customItemPromptUpdateCallbacks[data.ref])( player, rui, data, lootContext, lootRef, isInMenu )
}


bool function AttachesToAllWeaponsOfAmmoType( string attachmentRef )
{
	Assert( IsValidAttachment( attachmentRef ), "must be valid attachment" )

	AttachmentData aData = GetAttachmentData( attachmentRef )
	Assert( aData.tagData.ammoRef != "", "attachment tag data must have ammo ref" )

	array<LootData> allWeapons = SURVIVAL_Loot_GetByType( eLootType.MAINWEAPON )
	foreach ( LootData wData in allWeapons )
	{
		if ( wData.ammoType != aData.tagData.ammoRef )
			continue

		if ( WeaponLootRefIsLockedSet( wData.ref ) )
			continue

		if ( SURVIVAL_Loot_IsRefDisabled( wData.ref ) )
			continue

		if ( !aData.compatibleWeapons.contains( wData.ref ) )
			return false
	}

	return true
}


bool function HasWeaponForTag( entity player, int tagId )
{
	array<entity> weapons = player.GetMainWeapons()
	foreach ( weapon in weapons )
	{
		string weaponRef = weapon.GetWeaponClassName()
		if ( !SURVIVAL_Loot_IsRefValid( weaponRef ) )
			continue

		LootData weaponData = SURVIVAL_Loot_GetLootDataByRef( weaponRef )
		if ( weaponData.lootType != eLootType.MAINWEAPON )
			continue

		switch ( tagId )
		{
			case eAttachmentTag.ALL:
				return true;

			case eAttachmentTag.PISTOL:
			case eAttachmentTag.ASSAULT:
			case eAttachmentTag.SHOTGUN:
			case eAttachmentTag.LMG:
			case eAttachmentTag.SNIPER:
			case eAttachmentTag.SMG:
			case eAttachmentTag.LAUNCHER:
				if ( weaponClassToTag[weaponData.lootTags[0]] == tagId )
					return true
				break

			case eAttachmentTag.BARREL:
				if ( AttachmentPointSupported( "barrel", weaponRef ) )
					return true
				break

			default:
				Assert( 0, "Unhandled tag " + tagId )
		}
	}

	return false
}


bool function ShouldLootHintBeVisible( entity prop )
{
	if ( !IsValid( prop ) )
		return false

	if ( prop.GetNetworkedClassName() != "prop_survival" )
		return false

	if ( prop.GetSurvivalInt() < 0 )
		return false

	if ( prop.e.isBusy )
		return false

                     
                                   
                   
   
                                                            
                                                
                
   
       

                        
                                   
                   
   
                                                            
                                                    
                
   
                              

	entity player = GetLocalViewPlayer()

	if ( file.checkWeaponDisableForLootPingPrompt && player.GetWeaponDisableFlags() == WEAPON_DISABLE_FLAGS_ALL )
	{
		return false
	}

	if ( GetAimAssistCurrentTarget() )
		return false

	return true
}


void function ManageDeathBoxLootThread()
{
	while ( 1 )
	{
		WaitFrame()

		ManageDeathBoxLoot()
	}
}


void function ManageDeathBoxLoot()
{
	entity player = GetLocalViewPlayer()

	if ( !IsValid( player ) )
		return

	if ( player != GetLocalClientPlayer() )
		return

	if ( player.IsPhaseShifted() )
		return

	if ( !Survival_IsGroundlistOpen() )
		return

	bool isBlackMarket      = false
	int blackMarketUseCount = -1
	array<entity> loot
	entity currentDeathBox = Survival_GetDeathBox()
	if ( IsValid( currentDeathBox ) )
	{
		loot = GetDeathBoxLootEnts( currentDeathBox )

		if ( currentDeathBox.GetScriptName() == BLACK_MARKET_SCRIPTNAME )
		{
			isBlackMarket = true
			blackMarketUseCount = GetBlackMarketUseCount( currentDeathBox, GetLocalClientPlayer() )
		}
	}

	if ( IsGroundListMenuOpen() )
	{
		SurvivalGroundListUpdateParams params
		params.player = player
		params.currentLootEnts = loot
		params.isBlackMarket = isBlackMarket
		UpdateSurvivalGroundList( params )
	}
	else
	{
		GroundItemUpdate( player, loot )
	}
}

#if LOOT_GROUND_VERTICAL_LINES
void function ManageVerticalLines()
{
	while ( 1 )
	{
		WaitFrame()

		entity player = GetLocalViewPlayer()

		if ( !IsValid( player ) )
			continue

		if ( player != GetLocalClientPlayer() )
			continue

		if ( !IsPingEnabledForPlayer( player ) )
			continue

		if( IsSpectating() )
			continue

		array<entity> loot

		int l
		int v

		entity useEntity = GetPropSurvivalUseEntity( player )
		float scalar     = GraphCapped( GetFovScalar( player ), 1.0, 2.0, 1.0, 3.0 )

		if ( !player.IsPhaseShifted() )
		{
			vector org
			if ( player.ContextAction_IsInVehicle() )
				org = player.EyePosition()
			else
				org = player.GetOrigin()

			if ( !Survival_IsGroundlistOpen() )
			{
				loot = GetSurvivalLootNearbyPos( org, VERTICAL_LINE_DIST_MAX, false, true, false, player )

				if ( useEntity != null )
				{
					vector fwd = AnglesToForward( player.CameraAngles() )
					fwd = Normalize( < fwd.x, fwd.y, 0.0 > )
					vector rgt  = CrossProduct( fwd, <0, 0, 1> )
					float width = VERTICAL_LINE_WIDTH

					if ( useEntity == player.GetUsePromptEntity() )
						width *= 3.0

					float dist = Distance( useEntity.GetOrigin(), player.CameraPosition() ) / scalar
					if ( LOOT_PING_DISTANCE > VERTICAL_LINE_DIST_MAX )
						width *= GraphCapped( dist, VERTICAL_LINE_DIST_MAX, LOOT_PING_DISTANCE, 1.0, 2.0 )

					RuiTopology_UpdatePos( file.verticalLines[v].topo, useEntity.GetRenderOrigin() - (0.5 * rgt * width), rgt * width, <0, 0, VERTICAL_LINE_HEIGHT> )
					ShowVerticalLineStruct( file.verticalLines[v], useEntity )
					RuiSetBool( file.verticalLines[v].rui, "isSelected", true )

					file.verticalLines[v].ent = useEntity

					v++
				}
			}
		}

		while ( v < VERTICAL_LINE_COUNT )
		{
			if ( loot.len() > l )
			{
				entity item = loot[ l++ ]

				if ( IsValid( item.GetParent() ) )
				{
					entity p = item.GetParent()
					if ( p.IsPlayer() )
						continue

					if ( p.GetTargetName() == DEATH_BOX_TARGETNAME )
						continue
				}

				if ( IsValid( item ) && !item.DoesShareRealms( player ) )
					continue

				if ( !PlayerCanSeePos( player, item.GetOrigin(), false, 65 ) )
					continue

				if ( PropSurvivalFlagsHas( item, ePropSurvivalFlag.HIDE_LOOT_LINE ) )
					continue

				vector fwd = AnglesToForward( player.CameraAngles() )
				fwd = Normalize( < fwd.x, fwd.y, 0.0 > )
				vector rgt = CrossProduct( fwd, <0, 0, 1> )

				RuiTopology_UpdatePos( file.verticalLines[v].topo, item.GetRenderOrigin() - (0.5 * rgt * VERTICAL_LINE_WIDTH / scalar), rgt * VERTICAL_LINE_WIDTH / scalar, <0, 0, VERTICAL_LINE_HEIGHT> )
				ShowVerticalLineStruct( file.verticalLines[v], item )

				file.verticalLines[v].ent = item

				v++
			}
			else
			{
				file.verticalLines[v].ent = null
				HideVerticalLineStruct( file.verticalLines[v] )
				v++
			}
		}
	}
}

void function ShowVerticalLineStruct( VerticalLineStruct lineStruct, entity ent )
{
	if ( !IsValid( ent ) || (ent.GetNetworkedClassName() != "prop_survival") || (ent.GetSurvivalInt() < 0) || ent.HasPredictiveHideForPickup() )
	{
		HideVerticalLineStruct( lineStruct )
		return
	}

	entity player = GetLocalViewPlayer()

	RuiSetBool( lineStruct.rui, "isSelected", false )
	RuiSetVisible( lineStruct.rui, true )
	RuiSetFloat3( lineStruct.rui, "worldPos", ent.GetRenderOrigin() )
	RuiSetBool( lineStruct.rui, "isVisible", true )

	#if LINE_COLORS
		LootData data = SURVIVAL_Loot_GetLootDataByIndex( ent.GetSurvivalInt() )
		RuiSetInt( lineStruct.rui, "tier", data.tier )

		                                                                                                   
		if ( file.greyTierEnabled && ( data.lootType == eLootType.MAINWEAPON ) && !SURVIVAL_Weapon_IsAttachmentLocked( data.ref ) )
			RuiSetBool( lineStruct.rui, "isGreyTier", true )
		else
			RuiSetBool( lineStruct.rui, "isGreyTier", false )
	#else
		RuiSetInt( lineStruct.rui, "tier", 1 )
	#endif

	bool isPinged = Waypoint_LootItemIsBeingPingedByAnyone( ent )
	RuiSetBool( lineStruct.rui, "isPinged", isPinged )
}

void function HideVerticalLineStruct( VerticalLineStruct lineStruct )
{
	RuiSetBool( lineStruct.rui, "isVisible", false )
	RuiSetVisible( lineStruct.rui, false )
}
#endif                                  

bool function TryOpenQuickSwap( entity overrideItem = null )
{
	entity itemToUse = overrideItem
	if ( !IsValid( itemToUse ) )
	{
		itemToUse = file.swapOnUseItem
	}

	if ( IsValid( itemToUse ) && GetLocalViewPlayer() == GetLocalClientPlayer() && !IsWatchingReplay() )
	{
		entity player = GetLocalClientPlayer()

		entity deathBox = player.GetUsePromptEntity()
		if ( IsValid( deathBox ) && deathBox.GetTargetName() != DEATH_BOX_TARGETNAME )
			deathBox = null

		if ( itemToUse.GetTargetName() != DEATH_BOX_TARGETNAME )
		{
			LootData data = SURVIVAL_Loot_GetLootDataByIndex( itemToUse.GetSurvivalInt() )
			thread OpenSwapForItem( data.ref, string( itemToUse.GetEncodedEHandle() ) )
		}
		else
		{
			OpenSurvivalGroundList( player, deathBox )
		}

		return true
	}

	return false
}

const int PF_IS_WEAPON = 1 << 0
const int PF_IS_AMMO = 1 << 1
const int PF_IS_KITTED = 1 << 2

void function TrackLootToPing( entity player )
{
	if ( player != GetLocalClientPlayer() )
		return

	player.Signal( "TrackLootToPing" )
	player.EndSignal( "TrackLootToPing" )
	player.EndSignal( "OnDeath" )
	player.EndSignal( "OnDestroy" )

	if ( !IsPingEnabledForPlayer( player ) )
		return

	table e
	e.farRui <- null

	OnThreadEnd(
		function() : ( e, player )
		{
			if ( IsValid( player ) && player.HasPassive( ePassives.PAS_ASH ) )
				DeathboxNetwork_UntrackIfTracking()

			if ( e.farRui != null )
				RuiDestroy( e.farRui )
			file.crosshairEntity = null
		}
	)

	entity lastEnt

	while ( IsValid( player ) )
	{
		bool shouldLookForLoot = ( GetAimAssistCurrentTarget() == null &&
									player.GetTargetInCrosshairRange() == null &&
									!player.IsPhaseShifted() )
		array<entity> loot
		if ( shouldLookForLoot )
		{
			if ( player.HasPassive( ePassives.PAS_ASH ) )
			{
				entity box = GetDeathboxPlayerIsLookingAt( player )
				if ( DeathboxNetwork_CanPlayerUse( player, box ) )
				{
					if ( lastEnt != box )
					{
						DeathboxNetwork_UntrackIfTracking()

						DeathboxNetwork_TrackBoxTargets( box )
						lastEnt = box
					}

					WaitFrame()
					continue
				}
				else if ( IsValid( lastEnt ) && lastEnt.GetTargetName() == DEATH_BOX_TARGETNAME )
				{
					DeathboxNetwork_UntrackBoxTargets( lastEnt )
				}
			}

			if ( player.ContextAction_IsInVehicle() )
				loot = GetSurvivalLootNearbyPos( player.EyePosition(), LOOT_PING_DISTANCE * GetFovScalar( player ), false, false, false, player )
			else
				loot = GetSurvivalLootNearbyPlayer( player, LOOT_PING_DISTANCE * GetFovScalar( player ), false, false, false )
			file.crosshairEntity = GetEntityPlayerIsLookingAt( player, loot )
		}
		else
		{
			file.crosshairEntity = null
			if ( IsValid( player ) && player.HasPassive( ePassives.PAS_ASH ) )
				DeathboxNetwork_UntrackIfTracking()
		}

		if ( IsValid( file.crosshairEntity ) )
		{
			if ( e.farRui == null )
			{
				LootData lootData = SURVIVAL_Loot_GetLootDataByIndex( file.crosshairEntity.GetSurvivalInt() )
				switch ( lootData.lootType )
				{
					case eLootType.MAINWEAPON:
						e.farRui = CreateFullscreenRui( $"ui/loot_pickup_hint_weapon_far.rpak", -1 )
						break

					case eLootType.AMMO:
						e.farRui = CreateFullscreenRui( $"ui/loot_pickup_hint_far.rpak", -1 )
						                                                  
						break

					default:
						e.farRui = CreateFullscreenRui( $"ui/loot_pickup_hint_far.rpak", -1 )
				}

				RuiSetGameTime( e.farRui, "lastItemChangeTime", Time() )
			}

			UpdateUseHintForEntity( file.crosshairEntity, e.farRui )
		}
		else
		{
			if ( e.farRui != null )
				RuiSetBool( e.farRui, "isVisible", false )
		}

		if ( lastEnt != file.crosshairEntity )
		{
			if ( e.farRui != null )
			{
				RuiDestroy( e.farRui )
				e.farRui = null
			}

			lastEnt = file.crosshairEntity
		}

		WaitFrame()
	}
}


int function PlayerLookSort( PlayerLookAtItem entA, PlayerLookAtItem entB )
{
	if ( entA.playerViewDot < entB.playerViewDot )
		return 1

	if ( entA.playerViewDot > entB.playerViewDot )
		return -1

	return 0
}


entity function GetEntityPlayerIsLookingAt( entity player, array<entity> ents, float degrees = 8 )
{
	entity theEnt
	float largestDot = -1.0

	float minDot = deg_cos( degrees )
	float dot

	array<PlayerLookAtItem> finalLootEnts

	vector playerEyePos = player.EyePosition()

	foreach ( ent in ents )
	{
		if ( IsValid( ent.GetParent() ) )
		{
			if ( ent.GetParent().GetTargetName() == DEATH_BOX_TARGETNAME )
				continue
		}

		dot = DotProduct( Normalize( ent.GetWorldSpaceCenter() - playerEyePos ), player.GetViewVector() )
		if ( dot < minDot )
			continue

		if ( ent.e.canUseEntityCallback != null )
		{
			if ( !ent.e.canUseEntityCallback( player, ent, USE_FLAG_NONE ) )
				continue
		}

		PlayerLookAtItem lootItem
		lootItem.ent = ent
		lootItem.playerViewDot = dot
		finalLootEnts.append( lootItem )

		#if DEV
			                                                                           
			                                                                                          
		#endif
	}

	finalLootEnts.sort( PlayerLookSort )

	foreach ( item in finalLootEnts )
	{
		int index     = item.ent.GetSurvivalInt()
		LootData data = SURVIVAL_Loot_GetLootDataByIndex( index )

		                   
		                                                                                                                        
		   
		  	                  
		  	      
		   
		      
		        
		if ( PlayerHasPassive( GetLocalViewPlayer(), ePassives.PAS_LOBA_EYE_FOR_QUALITY ) && data.tier - 1 >= eRarityTier.EPIC )
		{
			theEnt = item.ent
			break
		}
		else
		{
			TraceResults result = TraceLineHighDetail( playerEyePos, item.ent.GetWorldSpaceCenter(), player, TRACE_MASK_SOLID_BRUSHONLY, TRACE_COLLISION_GROUP_PLAYER )
			if ( result.fraction == 1.0 )
			{
				                                                                                                 
				if ( IsValid( item.ent.GetParent() ) && item.ent.GetParent().GetScriptName() == CARE_PACKAGE_SCRIPTNAME )
				{
					if ( item.ent.GetParent().GetCurrentSequenceName().find( "droppod_loot_closed_idle" ) > 0 )
						break
				}
				theEnt = item.ent
				break
			}
		}
	}

	return theEnt
}

entity function GetDeathboxPlayerIsLookingAt( entity player, float degrees = 8.0, float maxDistSqr = 1000000.0 )
{
	array<entity> deathboxArray = GetAllDeathBoxes()

	entity theEnt
	float largestDot = -1.0

	float minDot = deg_cos( degrees )
	float dot

	array<PlayerLookAtItem> finalLootEnts

	vector playerEyePos = player.EyePosition()

	foreach ( ent in deathboxArray )
	{
		if ( ent.GetTargetName() != DEATH_BOX_TARGETNAME )
			continue

		dot = DotProduct( Normalize( ent.GetWorldSpaceCenter() - playerEyePos ), player.GetViewVector() )
		if ( dot < minDot )
			continue

		float distanceSqr = DistanceSqr( ent.GetOrigin(), player.GetOrigin() )
		if ( distanceSqr > maxDistSqr )
			continue

		PlayerLookAtItem lootItem
		lootItem.ent = ent
		lootItem.playerViewDot = dot
		finalLootEnts.append( lootItem )

		#if DEV
			                                                                           
			                                                                                          
		#endif
	}

	finalLootEnts.sort( PlayerLookSort )

	foreach ( item in finalLootEnts )
	{
		TraceResults result = TraceLineHighDetail( playerEyePos, item.ent.GetWorldSpaceCenter(), [player, item.ent], TRACE_MASK_SOLID_BRUSHONLY, TRACE_COLLISION_GROUP_PLAYER )
		if ( result.fraction == 1.0 )
		{
			theEnt = item.ent
			break
		}
	}

	return theEnt
}

entity function GetPropSurvivalUseEntity( entity player )
{
	entity useEnt = player.GetUsePromptEntity() != null ? player.GetUsePromptEntity() : file.crosshairEntity
	if ( !IsValid( useEnt ) )
		return null

	if ( Bleedout_IsBleedingOut( player ) )
		return null

	if ( useEnt.GetNetworkedClassName() != "prop_survival" )
		return null

	if ( useEnt.GetSurvivalInt() < 0 )
		return null

	return useEnt
}

entity function GetCrosshairEntity( entity player )
{
	return file.crosshairEntity
}


void function DumpAttachmentTags()
{
	var attachmentMatrix = GetDataTable( $"datatable/weapon_attachment_matrix.rpak" )
	for ( int row = 0; row < GetDataTableRowCount( attachmentMatrix ); row++ )
	{
		string attachment      = GetDataTableString( attachmentMatrix, row, GetDataTableColumnByName( attachmentMatrix, "attachmentName" ) )
		AttachmentTags( attachment )
	}
}


AttachmentTagData function AttachmentTags( string attachment )
{
	AttachmentData aData = GetAttachmentData( attachment )
	return aData.tagData
}


void function SetupSurvivalLoot( var categories )
{
	string cats              = expect string( categories )
	array<string> stringCats = split( cats, WHITESPACE_CHARACTERS )

	                                             
	array<int> catTypes
	foreach ( string cat in stringCats )
		catTypes.append( SURVIVAL_Loot_GetLootTypeFromString( cat ) )

	       
	if ( catTypes.contains( eLootType.ATTACHMENT ) )
		RunUIScript( "SetupDevCommand", "Spawn All Optics", "script SpawnAllOptics()" )

	array<string> refs
	table< string, LootData > lootTable = SURVIVAL_Loot_GetLootDataTable()
	foreach( ref, data in lootTable )
		refs.append( ref )
	refs.sort( int function( string aa, string bb ) : (lootTable)
	{
		                                                     
		                                                     
		string aaS = CreateLootDevDisplayString( lootTable[aa] )
		string bbS = CreateLootDevDisplayString( lootTable[bb] )
		int aaLen = aaS.len()
		int bbLen = bbS.len()
		int maxLen = minint( aaLen, bbLen )
		for( int idx = 0; idx < maxLen; ++idx )
		{
			int aaC = expect int( aaS[idx] )
			int bbC = expect int( bbS[idx] )
			if ( aaC < bbC )
				return -1
			if ( aaC > bbC )
				return 1
		}

		if ( aaLen < bbLen )
			return -1
		if ( aaLen > bbLen )
			return 1

		return 0
	} )

	foreach ( ref in refs )
	{
		LootData data = lootTable[ref]
		if ( !IsLootTypeValid( data.lootType ) )
			continue
		if ( !catTypes.contains( data.lootType ) )
			continue

		string displayString = CreateLootDevDisplayString( data )
		RunUIScript( "SetupDevCommand", displayString, "script SpawnGenericLoot( \"" + data.ref + "\", gp()[0].GetOrigin(), <-1,-1,-1>, " + data.countPerDrop + " )" )
	}
}


string function CreateLootDevDisplayString( LootData data )
{
	string displayString = Localize( data.pickupString )

	if ( data.passive != ePassives.INVALID )
		displayString += " - " + Localize( PASSIVE_NAME_MAP[data.passive] )

	if ( ShouldAppendLootLevel( data ) )
		displayString += " [Lv" + data.tier + "]"

	if ( data.lootTags.contains( WEAPON_LOCKEDSET_MOD_GOLD ) )
		displayString = "[GOLD]/ GOLD " + displayString
	if ( data.lootTags.contains( WEAPON_LOCKEDSET_MOD_WHITESET ) )
		displayString = "[WHITE]/ WHITE " + displayString
	if ( data.lootTags.contains( WEAPON_LOCKEDSET_MOD_BLUESET ) )
		displayString = "[BLUE]/ BLUE " + displayString
	if ( data.lootTags.contains( WEAPON_LOCKEDSET_MOD_PURPLESET ) )
		displayString = "[PURPLE]/ PURPLE " + displayString
	if ( data.baseMods.contains( WEAPON_LOCKEDSET_MOD_GOLDPAINTBALL ) )
		displayString = "[GOLD PAINTBALL]/ GOLD " + displayString
	if ( data.baseMods.contains( WEAPON_LOCKEDSET_MOD_PURPLEPAINTBALL ) )
		displayString = "[PURPLE PAINTBALL]/ PURPLE " + displayString
	if ( data.baseMods.contains( WEAPON_LOCKEDSET_MOD_BLUEPAINTBALL ) )
		displayString = "[BLUE PAINTBALL]/ BLUE " + displayString

	return displayString
}


bool function ShouldAppendLootLevel( LootData data )
{
	switch ( data.lootType )
	{
		case eLootType.MAINWEAPON:
			return false

		case eLootType.AMMO:
			return false

		case eLootType.ORDNANCE:
			return false
	}

	return true
}
  
                   
  

bool function SURVIVAL_Loot_QuickSwap( entity pickup, entity player, int pickupFlags, entity deathBox, int ornull desiredCount )
{
	if ( pickup.GetSurvivalInt() == -1 )
		return false

	LootData data   = SURVIVAL_Loot_GetLootDataByIndex( pickup.GetSurvivalInt() )
	int numPickedUp = SURVIVAL_AddToPlayerInventory( player, data.ref, pickup.GetClipCount() )
	if ( numPickedUp > 0 )
		return false

	thread SURVIVAL_Loot_QuickSwap_Internal( pickup, player, pickupFlags, deathBox )

	return false
}


void function SURVIVAL_Loot_QuickSwap_Internal( entity pickup, entity player, int pickupFlags = 0, entity deathBox = null )
{
	ExtendedUseSettings settings
	settings.loopSound = "UI_Survival_PickupTicker"
	settings.successSound = "UI_Survival_DeathBoxOpen"
	settings.displayRui = $"ui/extended_use_hint.rpak"
	settings.displayRuiFunc = DefaultExtendedUseRui
	settings.icon = $""
	settings.hint = "#PROMPT_SWAP"
	settings.duration = 0.3
	settings.startFunc = ExtendedQuickSwap_Start
	settings.successFunc = ExtendedTryOpenQuickSwap
	settings.useInputFlag = IN_USE_LONG
	settings.requireMatchingUseEnt = true

	pickup.EndSignal( "OnDestroy" )
	player.EndSignal( "OnDeath" )

	LootData lootData = SURVIVAL_Loot_GetLootDataByIndex( pickup.GetSurvivalInt() )
	LootRef lootRef   = SURVIVAL_CreateLootRef( lootData, pickup )

	LootActionStruct asMain = SURVIVAL_BuildStringForAction( GetLocalViewPlayer(), eLootContext.GROUND, lootRef, false, false )
	LootActionStruct asAlt  = SURVIVAL_BuildStringForAction( GetLocalViewPlayer(), eLootContext.GROUND, lootRef, true, false )

	if ( asMain.action != eLootAction.PICKUP && asAlt.action == eLootAction.PICKUP )
	{
		settings.holdHint = "%use_alt%"
		settings.useInputFlag = IN_USE_ALT
	}

	waitthread ExtendedUse( pickup, player, settings )
}


ExtendedUseSettings function DeathBoxGetExtendedUseSettings( entity ent, entity playerUser )
{
	ExtendedUseSettings settings
	settings.loopSound = "UI_Survival_PickupTicker"
	settings.successSound = "UI_Survival_DeathBoxOpen"
	settings.displayRui = $"ui/extended_use_hint.rpak"
	settings.displayRuiFunc = DefaultExtendedUseRui
	settings.icon = $""
	settings.hint = "#PROMPT_OPEN"
	settings.successFunc = ExtendedTryOpenGroundList

	return settings
}


void function ExtendedQuickSwap_Start( entity item, entity player, ExtendedUseSettings settings )
{
	file.swapOnUseItem = item
}


void function ExtendedTryOpenQuickSwap( entity ent, entity player, ExtendedUseSettings settings )
{
	TryOpenQuickSwap()
}


void function ExtendedTryOpenGroundList( entity ent, entity player, ExtendedUseSettings settings )
{
	OpenSurvivalGroundList( player, ent )
}


EHI ornull function GetDeathBoxOwnerEHI( entity box )
{
	EHI eHandle = box.GetNetInt( "ownerEHI" )

	if ( eHandle == -1 )
		return null

	return eHandle
}


void function TryHolsterWeapon( entity player )
{
	if ( !IsGamepadEnabled() )
		return

	if ( file.useAltBind == -1 )
		return

	                                         
	if ( !InputIsButtonDown( file.useAltBind ) )
		return

	entity useEnt = player.GetUsePromptEntity()

	if ( IsValid( useEnt ) )
	{
		if ( useEnt.GetNetworkedClassName() == "prop_survival" )
		{
			LootData lootData = SURVIVAL_Loot_GetLootDataByIndex( useEnt.GetSurvivalInt() )
			LootRef lootRef   = SURVIVAL_CreateLootRef( lootData, useEnt )
			if ( SURVIVAL_GetActionForItem( player, eLootContext.GROUND, lootRef, true ).action != eLootAction.NONE )
			{
				return
			}
		}
	}

	entity activeWeapon = player.GetActiveWeapon( eActiveInventorySlot.mainHand )
	if ( activeWeapon == player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_2 ) )
	{
		player.ClientCommand( "invnext" )
		return
	}

	                              
	                         
	                            
	                                                    
	                                                 
	                     
	                    
	                         
	                                           
	                                 
	                                    
	  
	                                                

	player.ClientCommand( "weaponSelectPrimary2" )
}


void function ExtendedTryHolster( entity ent, entity player, ExtendedUseSettings settings )
{
	player.ClientCommand( "weaponSelectPrimary2" )
}


void function OnPlayerSwitchesToWeapon00( entity player )
{
	Remote_ServerCallFunction( CMDNAME_PLAYER_SWITCHED_WEAPONS, 0 )
}


void function OnPlayerSwitchesToWeapon01( entity player )
{
	Remote_ServerCallFunction( CMDNAME_PLAYER_SWITCHED_WEAPONS, 1 )
}


void function OnPlayerSwitchesWeapons( entity player )
{
	Remote_ServerCallFunction( CMDNAME_PLAYER_SWITCHED_WEAPONS, -1 )
}


void function OnRefreshCustomGamepadBinds( entity player )
{
	file.useAltBind = GetButtonBoundTo( "+use_alt" )
}

const float LOOT_FILL_VOLUME_MIN = 200.0
const float LOOT_FILL_VOLUME_MAX = 2000.0
const float LOOT_FILL_ALPHA_MIN = 0.4
const float LOOT_FILL_ALPHA_MAX = 0.9

table<int, float> s_highlightFillCache
float function GetHighlightFillAlphaForLoot( entity lootEnt )
{
	int survivalInt = lootEnt.GetSurvivalInt()

	                       
	                                              
	  	                                        

	if ( !(survivalInt in s_highlightFillCache) )
	{
		vector mins = lootEnt.GetBoundingMins()
		vector maxs = lootEnt.GetBoundingMaxs()

		float volume = (maxs.x - mins.x) * (maxs.y - mins.y) * (maxs.z - mins.z)

		s_highlightFillCache[survivalInt] <- GraphCapped( volume, LOOT_FILL_VOLUME_MIN, LOOT_FILL_VOLUME_MAX, LOOT_FILL_ALPHA_MAX, LOOT_FILL_ALPHA_MIN )
	}

	return s_highlightFillCache[survivalInt]

}

float s_deathboxHighlightFillCache = 0
float function GetHighlightFillAlphaForDeathBox( entity deathbox )
{
	if (s_deathboxHighlightFillCache == 0)
	{
		vector mins = deathbox.GetBoundingMins()
		vector maxs = deathbox.GetBoundingMaxs()

		float volume = (maxs.x - mins.x) * (maxs.y - mins.y) * (maxs.z - mins.z)

		s_deathboxHighlightFillCache = GraphCapped( volume, LOOT_FILL_VOLUME_MIN, LOOT_FILL_VOLUME_MAX, LOOT_FILL_ALPHA_MAX, LOOT_FILL_ALPHA_MIN )
	}

	return s_deathboxHighlightFillCache
}

                         
void function CreateDeathBoxRuiWithOverridenData( entity deathBox, NestedGladiatorCardHandle nestedGCHandle )
{
	printt( "Creating with overriden profile data" )
	SetNestedGladiatorCardOverrideName( nestedGCHandle, deathBox.GetCustomOwnerName() )

	int characterIndex                 = deathBox.GetNetInt( "characterIndex" )
	LoadoutEntry characterLoadoutEntry = Loadout_Character()
	ItemFlavor character               = ConvertLoadoutSlotContentsIndexToItemFlavor( characterLoadoutEntry, characterIndex )
	SetNestedGladiatorCardOverrideCharacter( nestedGCHandle, character )

	int skinIndex                 = deathBox.GetNetInt( "skinIndex" )
	LoadoutEntry skinLoadoutEntry = Loadout_CharacterSkin( character )
	SetNestedGladiatorCardOverrideSkin( nestedGCHandle, ConvertLoadoutSlotContentsIndexToItemFlavor( skinLoadoutEntry, skinIndex ) )

	int frameIndex                 = deathBox.GetNetInt( "frameIndex" )
	LoadoutEntry frameLoadoutEntry = Loadout_GladiatorCardFrame( character )
	SetNestedGladiatorCardOverrideFrame( nestedGCHandle, ConvertLoadoutSlotContentsIndexToItemFlavor( frameLoadoutEntry, frameIndex ) )

	int stanceIndex                 = deathBox.GetNetInt( "stanceIndex" )
	LoadoutEntry stanceLoadoutEntry = Loadout_GladiatorCardStance( character )
	SetNestedGladiatorCardOverrideStance( nestedGCHandle, ConvertLoadoutSlotContentsIndexToItemFlavor( stanceLoadoutEntry, stanceIndex ) )

	int firstBadgeIndex                 = deathBox.GetNetInt( "firstBadgeIndex" )
	LoadoutEntry firstBadgeLoadoutEntry = Loadout_GladiatorCardBadge( character, 0 )
	int firstBadgeDataInt               = deathBox.GetNetInt( "firstBadgeDataInt" )
	SetNestedGladiatorCardOverrideBadge( nestedGCHandle, 0, ConvertLoadoutSlotContentsIndexToItemFlavor( firstBadgeLoadoutEntry, firstBadgeIndex ), firstBadgeDataInt )

	int secondBadgeIndex                 = deathBox.GetNetInt( "secondBadgeIndex" )
	LoadoutEntry secondBadgeLoadoutEntry = Loadout_GladiatorCardBadge( character, 1 )
	int secondBadgeDataInt               = deathBox.GetNetInt( "secondBadgeDataInt" )
	SetNestedGladiatorCardOverrideBadge( nestedGCHandle, 1, ConvertLoadoutSlotContentsIndexToItemFlavor( secondBadgeLoadoutEntry, secondBadgeIndex ), secondBadgeDataInt )

	int thirdBadgeIndex                 = deathBox.GetNetInt( "thirdBadgeIndex" )
	LoadoutEntry thirdBadgeLoadoutEntry = Loadout_GladiatorCardBadge( character, 2 )
	int thirdBadgeDataInt               = deathBox.GetNetInt( "thirdBadgeDataInt" )
	SetNestedGladiatorCardOverrideBadge( nestedGCHandle, 2, ConvertLoadoutSlotContentsIndexToItemFlavor( thirdBadgeLoadoutEntry, thirdBadgeIndex ), thirdBadgeDataInt )
}
      

void function ApplyEquipmentColorAndFXOverrides( entity prop )
{
	if ( !IsValid( prop ) )
		return

	if ( IsLootEntInsideDeathBox( prop ) )
		return

	LootData lootData = SURVIVAL_Loot_GetLootDataByIndex( prop.GetSurvivalInt() )
	int lootType      = lootData.lootType

	if ( (lootType == eLootType.ARMOR || lootType == eLootType.HELMET) && lootData.skinOverride <= 0 )
	{
		vector tierColor       = GetFXRarityColorForTier( lootData.tier )
		string tierColorString = format( "%f %f %f", tierColor.x, tierColor.y, tierColor.z )
		prop.kv.rendercolor = tierColorString

		if ( EvolvingArmor_IsEquipmentEvolvingArmor( lootData.ref ) )
		{
			int fxIdx   = GetParticleSystemIndex( EVO_ARMOR_FX )

			if( (prop in file.equipmentFX) && EffectDoesExist( file.equipmentFX[prop] ) )
				EffectStop( file.equipmentFX[prop], true, false )

			int armorFX = StartParticleEffectOnEntityWithPos( prop, fxIdx, FX_PATTACH_ABSORIGIN_FOLLOW, ATTACHMENTID_INVALID, < 0, 0, 15>, <0, 0, 0> )
			EffectSetControlPointVector( armorFX, 1, tierColor )
			file.equipmentFX[prop] <- armorFX
		}
	}
}

#if DEV
void function DEV_ToggleLootRefs()
{
	file.devShowLootRefs = !(file.devShowLootRefs)
}
#endif