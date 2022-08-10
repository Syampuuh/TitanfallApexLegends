  

#if CLIENT || UI
global function SurvivalGroundList_LevelInit
#endif

#if UI
global function InitSurvivalGroundList
global function OpenSurvivalGroundListMenu

global function ClientToUI_SurvivalGroundList_OpenQuickSwap
global function ClientToUI_SurvivalGroundList_RefreshQuickSwap
global function ClientToUI_SurvivalGroundList_CloseQuickSwap
global function ClientToUI_RestrictedLootConfirmDialog_Open
#endif

#if CLIENT
global function IsGroundListMenuOpen
global function UpdateSurvivalGroundList

global function UIToClient_SurvivalGroundListOpened
global function UIToClient_SurvivalGroundListClosed
global function UIToClient_SurvivalGroundList_UpdateQuickSwapItem
global function UIToClient_SurvivalGroundList_OnQuickSwapItemClick
global function UIToClient_SurvivalGroundList_OnMouseLeftPressed
global function UIToClient_RestrictedLootConfirmDialog_DoIt

global function UIToClient_CloseQuickSwapIfOpen
#endif

#if CLIENT
global struct SurvivalGroundListUpdateParams
{
	entity        player
	array<entity> currentLootEnts
	bool          isBlackMarket
	int           blackMarketUseCount
}
#endif


#if CLIENT
struct DeathBoxEntryData
{
	string        key
	LootData&     lootFlav
	array<entity> lootEnts                              
	bool          isClickable
	bool          isUsable
	bool          isRelevant
	bool          isUpgrade
	bool          isBlocked
	int           pingCounter
	int           useCounter
	bool		  isRestrictedItem
	int			  restrictedType

	int            totalCount = 0
	int            lastSeenTotalCount = 0
	EncodedEHandle lastSeenBestLootEntEEH = EncodedEHandle_null

	bool wasLastLootPickedUpByLocalPlayer = false
	bool predictingNewEntToBeCreated = false
}
#endif


#if CLIENT
struct PredictedLootActionData
{
	int   type
	float time

	                                               
	string lootFlavRef
	int    count                          

	                                                                     
	EncodedEHandle bestLootEntEEH

	int        expectedInventoryContribution = 0
	int ornull backpackSwapSlot = null

	#if DEV
		bool devMsgPrinted = false
	#endif
}
#endif


#if CLIENT || UI
struct FileStruct_LifetimeLevel
{
	table signalDummy

	#if CLIENT
		var menu
		var holdToUseElem

		var backer
		var listPanel
		var scrollBar

		var quickSwapBacker
		var quickSwapGrid
		var quickSwapHeader
		var inventorySwapIcon

		var blackMarketWidget

		EncodedEHandle                         currentDeathBoxEEH
		table<string, DeathBoxEntryData>       deathBoxEntryDataByKey
		table<entity, DeathBoxEntryData>       deathBoxEntryDataByLootEnt
		DeathBoxEntryData ornull               currentQuickSwapEntry
		var                                    currentQuickSwapItemButton
		bool                                   currentQuickSwapIsAltAction
		string                                 specialStateSamenessKey
		array<PredictedLootActionData>         predictedActions
		bool                                   predictedActionsDirty = false

		vector categoryHeaderTextCol
	#endif
}
#endif
#if CLIENT
FileStruct_LifetimeLevel fileLevel                             
#elseif UI
FileStruct_LifetimeLevel& fileLevel                             

struct {
	var menu

	var quickSwapBacker
	var quickSwapGrid
	var quickSwapHeader
	var inventorySwapIcon
} fileVM                            
#endif


#if CLIENT || UI
void function SurvivalGroundList_LevelInit()
{
	#if UI
		FileStruct_LifetimeLevel newFileLevel
		fileLevel = newFileLevel
	#endif

	#if CLIENT
		RegisterSignal( "SurvivalGroundList_Closed" )
		RegisterSignal( "DeathBoxEntryData_Update" )
		RegisterSignal( "DeathBoxEntryData_Unbind" )
		AddCallback_OnPingCreatedByAnyPlayer( OnPingCreatedByAnyPlayer )

		if ( !IsLobby() )
		{
			foreach ( equipSlot, data in EquipmentSlot_GetAllEquipmentSlots() )
			{
				if ( data.trackingNetInt == "" )
					continue
				AddCallback_OnEquipSlotTrackingIntChanged( equipSlot, OnPlayerEquipmentChanged )
			}
		}
	#endif
}
#endif


#if UI
void function InitSurvivalGroundList( var menu )
{
	fileVM.menu = menu

	Survival_RegisterInventoryMenu( menu )

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnMenuOpen )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, OnMenuNavBack )
	AddMenuEventHandler( menu, eUIEvent.MENU_SHOW, OnMenuShow )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, OnMenuClose )

	Survival_AddPassthroughCommandsToMenu( menu )
	AddMenuFooterOption( menu, LEFT, KEY_TAB, true, "", "", TryCloseSurvivalInventory, PROTO_ShouldInventoryFooterHack )
	AddMenuFooterOption( menu, RIGHT, BUTTON_B, true, "#B_BUTTON_CLOSE", "#B_BUTTON_CLOSE" )
    
#if NX_PROG
                                                                                                                                                 
	AddMenuFooterOption( menu, LEFT, BUTTON_X, true, "", "", SurvivalMenuSwapWeapon )
#endif
    
	fileVM.quickSwapBacker = Hud_GetChild( menu, "QuickSwapBacker" )
	fileVM.inventorySwapIcon = Hud_GetChild( menu, "SwapIcon" )
	fileVM.quickSwapHeader = Hud_GetChild( menu, "QuickSwapHeader" )
	fileVM.quickSwapGrid = Hud_GetChild( menu, "QuickSwapGrid" )
	RuiSetString( Hud_GetRui( fileVM.quickSwapHeader ), "headerText", "#PROMPT_QUICK_SWAP" )
	RuiSetImage( Hud_GetRui( fileVM.inventorySwapIcon ), "basicImage", $"rui/hud/loot/loot_swap_icon" )
	GridPanel_Init( fileVM.quickSwapGrid, INVENTORY_ROWS, INVENTORY_COLS, OnQuickSwapItemBind, GetInventoryItemCount, Survival_CommonButtonInit )
	GridPanel_SetButtonHandler( fileVM.quickSwapGrid, UIE_CLICK, OnQuickSwapItemClick )
	GridPanel_SetButtonHandler( fileVM.quickSwapGrid, UIE_CLICKRIGHT, OnQuickSwapItemClickRight )
	RegisterButtonPressedCallback( MOUSE_LEFT, OnMouseLeftPressed )

	RegisterStickMovedCallback( ANALOG_RIGHT_Y, HandleAnalogStickScroll )
	RegisterButtonPressedCallback( MOUSE_WHEEL_UP, OnMouseWheelScrollUp )
	RegisterButtonPressedCallback( MOUSE_WHEEL_DOWN, OnMouseWheelScrollDown )

}
#endif


#if UI
void function OnMenuOpen()
{
	RunClientScript( "UIToClient_SurvivalGroundListOpened", fileVM.menu )
}
#endif


#if UI
void function OnMenuNavBack()
{
	if ( Hud_IsVisible( fileVM.quickSwapGrid ) )
	{
		RunClientScript( "UIToClient_CloseQuickSwapIfOpen" )
		return
	}

	CloseActiveMenu()
}
#endif


#if UI
void function OnMenuShow()
{
	SetMenuReceivesCommands( fileVM.menu, true )
	SetBlurEnabled( false )

	RunClientScript( "UICallback_UpdatePlayerInfo", Hud_GetChild( fileVM.menu, "PlayerInfo" ) )
	RunClientScript( "UICallback_UpdateTeammateInfo", Hud_GetChild( fileVM.menu, "TeammateInfo0" ) )
	RunClientScript( "UICallback_UpdateTeammateInfo", Hud_GetChild( fileVM.menu, "TeammateInfo1" ) )

#if NX_PROG
	RunClientScript( "DeathBoxListPanel_UpdateAfterSwitching" )
#endif
}
#endif


#if UI
void function OnMenuClose()
{
	SetBlurEnabled( false )
	RunClientScript( "UIToClient_SurvivalGroundListClosed" )
}
#endif

#if UI
void function OpenSurvivalGroundListMenu()
{
	CloseAllMenus()
	AdvanceMenu( fileVM.menu )
}
#endif


#if CLIENT
void function UIToClient_SurvivalGroundListOpened( var menu )
{
	CloseQuickSwapIfOpen()

	if ( !IsValid( fileLevel.menu ) )
	{
		fileLevel.menu = menu
		fileLevel.holdToUseElem = Hud_GetChild( menu, "HoldToUseElem" )

		fileLevel.backer = Hud_GetChild( menu, "Backer" )
		fileLevel.listPanel = Hud_GetChild( menu, "ListPanel" )
		fileLevel.scrollBar = Hud_GetChild( menu, "ScrollBar" )

		fileLevel.quickSwapBacker = Hud_GetChild( menu, "QuickSwapBacker" )
		fileLevel.inventorySwapIcon = Hud_GetChild( menu, "SwapIcon" )
		fileLevel.quickSwapHeader = Hud_GetChild( menu, "QuickSwapHeader" )
		fileLevel.quickSwapGrid = Hud_GetChild( menu, "QuickSwapGrid" )

		fileLevel.blackMarketWidget = Hud_GetChild( menu, "BlackMarketWidget" )

		DeathBoxListPanelData data = InitDeathBoxListPanel( fileLevel.listPanel, fileLevel.scrollBar, ItemButtonSetup )
		data.edgePadding = 17
		data.maxRowWidth = 406 + 110
		data.sortAscending = false
		data.anchorCategoryHeadersToTop = true
		data.categoryHeaderBindCallback = OnCategoryHeaderBind
		data.categoryHeaderUnbindCallback = OnCategoryHeaderUnbind
		data.itemBindCallback = OnItemBind
		data.itemUnbindCallback = OnItemUnbind
		data.itemClickCallback = OnItemClick
		data.itemClickRightCallback = OnItemClickRight
		data.itemFocusGetCallback = OnItemFocusGet
		data.itemFocusLoseCallback = OnItemFocusLose
		data.itemKeyEventHandler = OnItemKeyEvent
		data.itemCommandEventHandler = OnItemCommandEvent
	}

	entity deathBox = Survival_GetDeathBox()
	Assert( IsValid( deathBox ) )
	if ( !IsValid( deathBox ) )
	{
		RunUIScript( "CloseAllMenus" )
		return
	}
	fileLevel.currentDeathBoxEEH = deathBox.GetEncodedEHandle()
	fileLevel.deathBoxEntryDataByKey.clear()
	fileLevel.deathBoxEntryDataByLootEnt.clear()
	fileLevel.specialStateSamenessKey = ""


	fileLevel.categoryHeaderTextCol = SrgbToLinear( <240, 240, 240> / 255.0 * 0.85 )
	DeathBoxListPanel_SetScrollBarColorAlpha( fileLevel.listPanel, <1.0, 1.0, 1.0>, 1.0 )

	bool isBlackMarket = (deathBox.GetNetworkedClassName() == "prop_loot_grabber")
	if ( isBlackMarket )
	{
		EmitUISound( "Loba_Ultimate_BlackMarket_Open" )
		fileLevel.categoryHeaderTextCol = SrgbToLinear( <255, 255, 255> / 255.0 )
		DeathBoxListPanel_SetScrollBarColorAlpha( fileLevel.listPanel, <218.0 / 255.0, 235.0 / 255.0, 245.0 / 255.0>, 1.0 )
	}

	DeathBoxListPanel_Reset( fileLevel.listPanel )
	DeathBoxListPanel_SetActive( fileLevel.listPanel, true )

	foreach ( string enumKey, int enumVal in eLootSortCategories )
	{
		DeathBoxListPanelCategory category
		category.key = format( "%02d", 99 - enumVal )
		category.sortOrdinal = category.key
		category.headerLabel = GetCategoryTitleFromPriority( enumVal )
		category.headerHeight = 30
		if ( enumVal == eLootSortCategories.WEAPONS )
		{
			category.itemWidth = 200 + 55
			category.itemHeight = 100
			category.itemPadding = 6
		}
		else if ( enumVal == eLootSortCategories.AMMO )
		{
			category.itemWidth = 100    
			category.itemHeight = 100
			category.itemPadding = 4
		}
		else
		{
			category.itemWidth = 406 + 110
			category.itemHeight = 68
			category.itemPadding = 6
		}
		category.bottomPadding = 27
		DeathBoxListPanel_AddCategory( fileLevel.listPanel, category )
	}

	                             
	foreach ( string ammoPoolTypeKey, int ammoPoolTypeVal in eAmmoPoolType )
	{
		if ( !ArrowsCanBePickedUp() && ammoPoolTypeVal == eAmmoPoolType.arrows )
			continue

		DeathBoxEntryData entryData
		entryData.lootFlav = SURVIVAL_Loot_GetLootDataByRef( ammoPoolTypeKey )
		entryData.key = entryData.lootFlav.ref
		fileLevel.deathBoxEntryDataByKey[entryData.key] <- entryData
		entryData.lootEnts = []

		DeathBoxListPanelItem item
		item.categoryKey = format( "%02d", 99 - eLootSortCategories.AMMO )
		item.key = entryData.key
		item.sortOrdinal = format( "%02d", 50 - ammoPoolTypeVal )
		DeathBoxListPanel_AddItem( fileLevel.listPanel, item )
	}

	thread Delayed_SetCursorToObject( fileLevel.backer )

	string headerMainText       = Localize( "#DEATHBOX_MENU_HEADER" )
	string headerOwnerText      = ""
	string headerRightText      = ""
	asset headerImage           = $""
	asset headerBackgroundImage = $""

	if ( isBlackMarket )
	{
		headerMainText = Localize( "#BLACK_MARKET_MENU_HEADER" )
		headerRightText = Localize( "#NEARBY_ITEMS" )

		entity deathBoxOwner = deathBox.GetOwner()
		if ( IsValid( deathBoxOwner ) && deathBoxOwner.IsPlayer() )
		{
			headerOwnerText = Localize( "#DEATHBOX_OWNER_SUFFIX", deathBoxOwner.GetPlayerName() )
		}
	}
	else
	{
		string customOwnerName = deathBox.GetCustomOwnerName()
		if ( customOwnerName != "" )
		{
			headerOwnerText = Localize( "#DEATHBOX_OWNER_SUFFIX", customOwnerName )
			int characterIdx = deathBox.GetNetInt( "characterIndex" )
			if ( IsValidLoadoutSlotContentsIndexForItemFlavor( Loadout_Character(), characterIdx ) )
			{
				ItemFlavor char = ConvertLoadoutSlotContentsIndexToItemFlavor( Loadout_Character(), characterIdx )
				headerImage = CharacterClass_GetGalleryPortrait( char )
				headerBackgroundImage = CharacterClass_GetGalleryPortraitBackground( char )
			}
		}
		else
		{
			EHI ornull ownerEHI = GetDeathBoxOwnerEHI( deathBox )
			if ( ownerEHI != null )
			{
				expect EHI( ownerEHI )
				if ( EHIHasValidScriptStruct( ownerEHI ) )
				{
					headerOwnerText = Localize( "#DEATHBOX_OWNER_SUFFIX", GetPlayerNameFromEHI( ownerEHI ) )
					if ( LoadoutSlot_IsReady( ownerEHI, Loadout_Character() ) )
					{
						ItemFlavor char = LoadoutSlot_GetItemFlavor( ownerEHI, Loadout_Character() )
						headerImage = CharacterClass_GetGalleryPortrait( char )
						headerBackgroundImage = CharacterClass_GetGalleryPortraitBackground( char )
					}
				}
			}
		}
	}

	                                                                          
	HudElem_SetRuiArg( fileLevel.backer, "headerMainText", headerMainText )
	HudElem_SetRuiArg( fileLevel.backer, "headerOwnerText", headerOwnerText )
	HudElem_SetRuiArg( fileLevel.backer, "headerRightText", headerRightText )
	HudElem_SetRuiArg( fileLevel.backer, "headerImage", headerImage )
	HudElem_SetRuiArg( fileLevel.backer, "headerBackgroundImage", headerBackgroundImage )
	HudElem_SetRuiArg( fileLevel.backer, "isBlackMarket", isBlackMarket )

	UIToClient_GroundlistOpened()

	if ( deathBox.GetNetworkedClassName() == "prop_loot_grabber" )
		BlackMarket_OnDeathBoxMenuOpened( deathBox )

	WeaponStatusSetDeathBoxMenuOpen( true )
}
#endif


#if CLIENT
void function UIToClient_SurvivalGroundListClosed()
{
	Signal( fileLevel.signalDummy, "SurvivalGroundList_Closed" )

	entity deathBox = Survival_GetDeathBox()
	if ( IsValid( deathBox ) && deathBox.GetNetworkedClassName() == "prop_loot_grabber" )
		EmitUISound( "Loba_Ultimate_BlackMarket_Close" )

	fileLevel.currentDeathBoxEEH = EncodedEHandle_null
	DeathBoxListPanel_SetActive( fileLevel.listPanel, false )
	UIToClient_GroundlistClosed()

	WeaponStatusSetDeathBoxMenuOpen( false )
}
#endif


#if CLIENT
void function OnPlayerEquipmentChanged( entity player, string equipSlot, int idx )
{
	if ( player != GetLocalViewPlayer() )
		return

	fileLevel.specialStateSamenessKey = "haha ur equipment changed"                                         
}
#endif


#if CLIENT
void function UpdateSurvivalGroundList( SurvivalGroundListUpdateParams params )
{
	entity deathBox = GetEntityFromEncodedEHandle( fileLevel.currentDeathBoxEEH )
	if ( !IsValid( deathBox ) || Distance( params.player.GetOrigin(), deathBox.GetOrigin() ) > DEATH_BOX_MAX_DIST || GetGameState() >= eGameState.WinnerDetermined )
	{
		RunUIScript( "CloseAllMenus" )
		return
	}

	float maxPredictedPickupTimeBeforeAssumingMispredict = GetCurrentPlaylistVarFloat( "death_box_menu_max_predicted_pickup_time", 0.55 )
	for ( int predictedPickupIdx = 0; predictedPickupIdx < fileLevel.predictedActions.len(); predictedPickupIdx++ )
	{
		PredictedLootActionData plad = fileLevel.predictedActions[predictedPickupIdx]

		if ( Time() > plad.time + maxPredictedPickupTimeBeforeAssumingMispredict )
		{
			entity ent = GetEntityFromEncodedEHandle( plad.bestLootEntEEH )
			Warning( "Mispredicted loot action for %s x%d (%s)", plad.lootFlavRef, plad.count, IsValid( ent ) ? string(ent) : ("invalid: " + plad.bestLootEntEEH) )
			fileLevel.predictedActions.remove( predictedPickupIdx )
			predictedPickupIdx--                                             
			fileLevel.predictedActionsDirty = true
			RefreshQuickSwapIfOpen()
		}

		#if DEV
			if ( !plad.devMsgPrinted )
			{
				plad.devMsgPrinted = true
				entity ent = GetEntityFromEncodedEHandle( plad.bestLootEntEEH )
				printf( "Death box loot action prediction: %s, %s x%d (%s)", DEV_GetEnumStringSafe( "eLootAction", plad.type ), plad.lootFlavRef, plad.count, IsValid( ent ) ? string(ent) : ("invalid: " + plad.bestLootEntEEH) )
			}
		#endif
	}

	table<entity, DeathBoxEntryData> previousDeathBoxEntryDataByLootEnt = clone fileLevel.deathBoxEntryDataByLootEnt

	table<DeathBoxEntryData, void> entriesToUpdateSet = {}

	                               
	foreach ( entity lootEnt in params.currentLootEnts )
	{
		Assert( IsValid( lootEnt ) )
		Assert( lootEnt.GetNetworkedClassName() == "prop_survival" )
		if ( !IsValid( lootEnt ) || lootEnt.GetNetworkedClassName() != "prop_survival" )
			continue

		                                                                    
		if ( lootEnt in fileLevel.deathBoxEntryDataByLootEnt )
		{
			Assert( lootEnt in previousDeathBoxEntryDataByLootEnt )
			delete previousDeathBoxEntryDataByLootEnt[lootEnt]                                      

			if ( lootEnt.GetClipCount() != lootEnt.e.deathBoxMenu_lastSeenClipCount )
			{
				lootEnt.e.deathBoxMenu_lastSeenClipCount = lootEnt.GetClipCount()
				DeathBoxEntryData entryData = fileLevel.deathBoxEntryDataByLootEnt[lootEnt]
				entriesToUpdateSet[entryData] <- IN_SET
			}
			continue
		}

		                  

		DeathBoxEntryData entryData

		LootData lootFlavor = SURVIVAL_Loot_GetLootDataByIndex( lootEnt.GetSurvivalInt() )
		bool isArmor        = (lootFlavor.lootType == eLootType.ARMOR)
		bool hasSpecialAmmo = (lootFlavor.lootType == eLootType.MAINWEAPON && !GetWeaponInfoFileKeyField_GlobalBool( lootFlavor.baseWeapon, "uses_ammo_pool" ))

		string itemKey = (hasSpecialAmmo ? format( "specialammo%d", lootEnt.GetEncodedEHandle() ) : lootFlavor.ref)
		if ( itemKey in fileLevel.deathBoxEntryDataByKey )
		{
			                                       
			entryData = fileLevel.deathBoxEntryDataByKey[itemKey]
		}
		else
		{
			                                              
			fileLevel.deathBoxEntryDataByKey[itemKey] <- entryData
			entryData.key = itemKey
			entryData.lootFlav = lootFlavor
		}

		                                                                   
		                                    
		int otherLootEntIdx = 0
		bool closerIsBetter = GetCurrentPlaylistVarBool( "loba_ult_prefer_closer_loot", false )                                                                                                                 
		for ( ; otherLootEntIdx < entryData.lootEnts.len(); otherLootEntIdx++ )
		{
			entity otherLootEnt = entryData.lootEnts[otherLootEntIdx]

			if ( !IsValid( otherLootEnt ) )
				continue                                                                                                  

			bool continueForRestricted = false
			foreach ( int restrictedLootType in eRestrictedLootTypes )
			{
				entity restrictedPanel             = SURVIVAL_Loot_GetRestrictedPanel( restrictedLootType, lootEnt )
				bool lootEntIsRestrictedItem       = ( IsValid( restrictedPanel ) && SURVIVAL_Loot_IsRestrictedPanelLocked( restrictedLootType, restrictedPanel ) )
				entity otherLootEntRestrictedPanel = SURVIVAL_Loot_GetRestrictedPanel( restrictedLootType, otherLootEnt )
				bool otherLootEntIsRestrictedItem  = ( IsValid( otherLootEntRestrictedPanel ) && SURVIVAL_Loot_IsRestrictedPanelLocked( restrictedLootType, otherLootEntRestrictedPanel ) )
				if ( lootEntIsRestrictedItem && !otherLootEntIsRestrictedItem )
				{
					continueForRestricted = true                                          
					break
				}
				else if ( !lootEntIsRestrictedItem && otherLootEntIsRestrictedItem )
				{
					break                                                
				}
			}
			if ( continueForRestricted )
				continue
			else
			{
				if(isArmor)
				{
					                                                                                                                             
					if ( GetPropSurvivalMainPropertyFromEnt( lootEnt ) < GetPropSurvivalMainPropertyFromEnt( otherLootEnt ) )
						continue                             

					else if ( GetPropSurvivalMainPropertyFromEnt( lootEnt ) <= GetPropSurvivalMainPropertyFromEnt( otherLootEnt ) && SURVIVAL_CreateLootRef(lootFlavor, lootEnt).lootExrtaProperty > SURVIVAL_CreateLootRef(lootFlavor, otherLootEnt).lootExrtaProperty )
						continue                       
				}
				break
			}

			if ( hasSpecialAmmo && lootEnt.GetClipCount() < otherLootEnt.GetClipCount() )
				break                             

			if ( isArmor && GetPropSurvivalMainPropertyFromEnt( lootEnt ) > GetPropSurvivalMainPropertyFromEnt( otherLootEnt ) )
				break                             

			if ( closerIsBetter == (DistanceSqr( lootEnt.GetOrigin(), params.player.EyePosition() ) < DistanceSqr( otherLootEnt.GetOrigin(), params.player.EyePosition() )) )
				break
		}
		int lootEntPlacementIdx = otherLootEntIdx
		entryData.lootEnts.insert( lootEntPlacementIdx, lootEnt )

		lootEnt.e.deathBoxMenu_lastSeenClipCount = lootEnt.GetClipCount()

		fileLevel.deathBoxEntryDataByLootEnt[lootEnt] <- entryData

		entriesToUpdateSet[entryData] <- IN_SET
	}

	                                                                                                                
	foreach ( entity deletedLootEnt, DeathBoxEntryData entryData in previousDeathBoxEntryDataByLootEnt )
	{
		entryData.lootEnts.removebyvalue( deletedLootEnt )                 
		entriesToUpdateSet[entryData] <- IN_SET

		delete fileLevel.deathBoxEntryDataByLootEnt[deletedLootEnt]
	}

	                                                              
	bool deathBoxBlocked = false
	{
		string specialStateSamenessKey = ""

		array<entity> mainWeapons = SURVIVAL_GetPrimaryWeaponsSorted( params.player )
		specialStateSamenessKey += mainWeapons.join( "|" )

		if ( deathBox.GetNetworkedClassName() == "prop_loot_grabber" && GetBlackMarketUseCount( deathBox, GetLocalClientPlayer() ) >= GetBlackMarketUseLimit() )
			deathBoxBlocked = true

		specialStateSamenessKey += "|" + (deathBoxBlocked ? "blocked" : "usable")

		if ( specialStateSamenessKey != fileLevel.specialStateSamenessKey || fileLevel.predictedActionsDirty )
		{
			fileLevel.specialStateSamenessKey = specialStateSamenessKey
			fileLevel.predictedActionsDirty = false

			                                                                                  
			foreach ( string entryDataKey, DeathBoxEntryData entryData in fileLevel.deathBoxEntryDataByKey )
				entriesToUpdateSet[entryData] <- IN_SET
		}
	}

	                                             
	string removeMode = GetCurrentPlaylistVarString( "death_box_menu_remove_on_taken", "mine" )
	foreach ( DeathBoxEntryData entryData, void _ in entriesToUpdateSet )
	{
		entity bestLootEnt = (entryData.lootEnts.len() > 0 && IsValid( entryData.lootEnts[0] ) ? entryData.lootEnts[0] : null)

		entryData.totalCount = 0
		bool isMainWeapon   = (entryData.lootFlav.lootType == eLootType.MAINWEAPON)
		bool hasSpecialAmmo = (isMainWeapon && !GetWeaponInfoFileKeyField_GlobalBool( entryData.lootFlav.baseWeapon, "uses_ammo_pool" ))
		bool isAmmo = (entryData.lootFlav.lootType == eLootType.AMMO)
		bool isBlackMarket = (deathBox.GetNetworkedClassName() == "prop_loot_grabber")

		foreach ( entity lootEnt in entryData.lootEnts )
		{
			if ( !IsValid( lootEnt ) )
				continue

			if ( isMainWeapon )
				entryData.totalCount += 1
			else
				entryData.totalCount += lootEnt.GetClipCount()
		}

		int amountDelta             = entryData.lastSeenTotalCount - entryData.totalCount
		int amountPredictedPickedUp = 0
		for ( int predictedPickupIdx = 0; predictedPickupIdx < fileLevel.predictedActions.len(); predictedPickupIdx++ )
		{
			PredictedLootActionData plad = fileLevel.predictedActions[predictedPickupIdx]
			if ( plad.lootFlavRef != entryData.lootFlav.ref )
				continue

			if ( hasSpecialAmmo && plad.bestLootEntEEH != entryData.lastSeenBestLootEntEEH )
				continue

			if ( signum( amountDelta ) == signum( plad.count ) && abs( amountDelta ) >= abs( plad.count ) )
			{
				amountDelta -= plad.count
				fileLevel.predictedActions.remove( predictedPickupIdx )
				predictedPickupIdx--                                             
			}
			else
			{
				amountPredictedPickedUp += plad.count
			}
		}
		entryData.lastSeenTotalCount = entryData.totalCount
		entryData.lastSeenBestLootEntEEH = (IsValid( bestLootEnt ) ? bestLootEnt.GetEncodedEHandle() : EncodedEHandle_null)

		entryData.totalCount = maxint( 0, entryData.totalCount - amountPredictedPickedUp )
		entryData.predictingNewEntToBeCreated = (amountPredictedPickedUp < 0)

		if ( entryData.totalCount > 0 )
			entryData.wasLastLootPickedUpByLocalPlayer = false

		if ( SURVIVAL_IsLootAnUpgrade( params.player, bestLootEnt, entryData.lootFlav, eLootContext.GROUND ) )
		{
			entryData.isRelevant = true
			entryData.isUpgrade = (entryData.lootFlav.lootType != eLootType.MAINWEAPON && entryData.lootFlav.lootType != eLootType.AMMO)
		}
		else
		{
			entryData.isRelevant = !SURVIVAL_IsLootIrrelevant( params.player, bestLootEnt, entryData.lootFlav, eLootContext.GROUND )
			entryData.isUpgrade = false
		}
		if (!(isAmmo && isBlackMarket))
			entryData.isBlocked = deathBoxBlocked

		bool shouldBeVisible = true
		if ( entryData.lootFlav.lootType == eLootType.AMMO )
		{
			                                   
		}
		if ( entryData.lootFlav.lootType == eLootType.GADGET )
		{
			                                     
		}
		else if ( removeMode == "all" )
		{
			shouldBeVisible = (entryData.totalCount > 0)
		}
		else if ( removeMode == "mine" )
		{
			shouldBeVisible = (entryData.totalCount > 0 || !entryData.wasLastLootPickedUpByLocalPlayer)
		}

		DeathBoxListPanelItem ornull item = DeathBoxListPanel_GetItemByKey( fileLevel.listPanel, entryData.key )
		if ( shouldBeVisible )
		{
			if ( item == null )
			{
				DeathBoxListPanelItem newItem
				int enumVal = GetPriorityForLootType( entryData.lootFlav )
				newItem.categoryKey = format( "%02d", 99 - enumVal )
				newItem.key = entryData.key
				newItem.sortOrdinal = format( "%02d,%02d,%02d,%d",
					entryData.lootFlav.lootType,
					entryData.lootFlav.tier,
					entryData.lootFlav.index,
					hasSpecialAmmo ? entryData.lastSeenBestLootEntEEH : 0
				)
				DeathBoxListPanel_AddItem( fileLevel.listPanel, newItem )
				item = newItem
			}

			UpdateItem( expect DeathBoxListPanelItem(item) )
		}
		else if ( item != null )
		{
			DeathBoxListPanel_RemoveItem( fileLevel.listPanel, expect DeathBoxListPanelItem(item) )
		}
	}

	array<entity> teammates   = []
	bool isMyTeamsBlackMarket = true
	var widgetRui             = Hud_GetRui( fileLevel.blackMarketWidget )
	if ( params.isBlackMarket )
	{
		Hud_Show( fileLevel.blackMarketWidget )

		int localPlayerUseCount = GetBlackMarketUseCount( deathBox, GetLocalViewPlayer() )
		int useCountMax         = GetBlackMarketUseLimit()
		RuiSetInt( widgetRui, "useCountMax", useCountMax )
		isMyTeamsBlackMarket = (deathBox.GetTeam() == params.player.GetTeam())                                                     
		RuiSetBool( widgetRui, "isMyTeamsBlackMarket", isMyTeamsBlackMarket )

		HudElem_SetRuiArg( fileLevel.backer, "blackMarketStage", localPlayerUseCount == useCountMax ? 2 : localPlayerUseCount == useCountMax - 1 ? 1 : 0 )

		teammates = GetPlayerArrayOfTeam_Connected( params.player.GetTeam() )
		teammates.removebyvalue( params.player )
		teammates.sort( int function( entity a, entity b ) {
			return a.GetTeamMemberIndex() - b.GetTeamMemberIndex()
		} )
		teammates.insert( 0, params.player )
	}
	else
	{
		Hud_Hide( fileLevel.blackMarketWidget )
	}

	const int BLACK_MARKET_UI_TEAMMATES_SUPPORTED = 3
	for ( int playerIdx = 0; playerIdx < BLACK_MARKET_UI_TEAMMATES_SUPPORTED; playerIdx++ )
	{
		entity player = (playerIdx < teammates.len() && IsValid( teammates[playerIdx] ) ? teammates[playerIdx] : null)
		if ( !isMyTeamsBlackMarket && playerIdx > 0 )
			player = null                                                         

		RuiSetString( widgetRui, format( "player%dName", playerIdx ), player != null ? GetPlayerNameFromEHI( ToEHI( player ) ) : "" )
		RuiSetInt( widgetRui, format( "player%dUseCount", playerIdx ), player != null ? GetBlackMarketUseCount( deathBox, player ) : -1 )
		RuiSetFloat( widgetRui, format( "player%dLastPickupTime", playerIdx ), player != null ? GetBlackMarketLastUseTime( deathBox, player ) : -9999.0 )

		asset charImage           = $""
		asset charBackgroundImage = $""
		if ( player != null && LoadoutSlot_IsReady( ToEHI( player ), Loadout_Character() ) )
		{
			ItemFlavor char = LoadoutSlot_GetItemFlavor( ToEHI( player ), Loadout_Character() )
			charImage = CharacterClass_GetGalleryPortrait( char )
			charBackgroundImage = CharacterClass_GetGalleryPortraitBackground( char )
		}
		RuiSetAsset( widgetRui, format( "player%dCharImage", playerIdx ), charImage )
		RuiSetAsset( widgetRui, format( "player%dCharBGImage", playerIdx ), charBackgroundImage )

		array<LootRef> useItemRefs = []
		if ( player != null )
			useItemRefs = GetBlackMarketUseItemRefs( deathBox, player )
		const int BLACK_MARKET_UI_ITEMS_SUPPORTED = 2
		for ( int itemIdx = 0; itemIdx < BLACK_MARKET_UI_ITEMS_SUPPORTED; itemIdx++ )
		{
			var itemButton    = Hud_GetChild( fileLevel.menu, format( "BlackMarketWidget_Player%d_ItemButton%d", playerIdx, itemIdx ) )
			var itemButtonRui = Hud_GetRui( itemButton )

			Hud_ClearToolTipData( itemButton )

			Hud_SetVisible( itemButton, player != null )

			if ( playerIdx == 1 && itemIdx == 0 )
				Hud_SetX( itemButton, int( (teammates.len() > 2 ? -141 : 9) * GetContentFixedScaleFactor( Hud ).x ) )

			if ( itemIdx >= useItemRefs.len() || useItemRefs[itemIdx].lootData.index < 0 )
			{
				RunUIScript( "ClientToUI_Tooltip_Clear", itemButton )

				RuiSetImage( itemButtonRui, "iconImage", $"" )
				RuiSetInt( itemButtonRui, "lootType", eLootType.INVALID )
				RuiSetInt( itemButtonRui, "lootTier", 0 )
				RuiSetInt( itemButtonRui, "count", 0 )
				RuiSetImage( itemButtonRui, "ammoTypeImage", $"" )

				continue
			}

			LootData lootFlavor = useItemRefs[itemIdx].lootData

			Hud_SetEnabled( itemButton, true )
			Hud_SetLocked( itemButton, false )
			Hud_SetSelected( itemButton, false )

			asset icon     = lootFlavor.hudIcon
			asset ammoIcon = $""
			if ( lootFlavor.lootType == eLootType.MAINWEAPON )
			{
				ItemFlavor ornull weaponFlav = GetWeaponItemFlavorByClass( lootFlavor.baseWeapon )
				if ( weaponFlav != null )
					icon = ItemFlavor_GetIcon( expect ItemFlavor( weaponFlav ) )

				ammoIcon = lootFlavor.fakeAmmoIcon == $"" ? $"rui/hud/gametype_icons/survival/sur_ammo_unique" : lootFlavor.fakeAmmoIcon
				string ammoType = GetWeaponAmmoType( lootFlavor.baseWeapon )
				if ( GetWeaponInfoFileKeyField_GlobalBool( lootFlavor.baseWeapon, "uses_ammo_pool" ) )
				{
					LootData ammoData = SURVIVAL_Loot_GetLootDataByRef( ammoType )
					ammoIcon = ammoData.hudIcon
				}
			}
			RuiSetImage( itemButtonRui, "iconImage", icon )
			RuiSetImage( itemButtonRui, "ammoTypeImage", ammoIcon )
			RuiSetInt( itemButtonRui, "lootType", lootFlavor.lootType )
			RuiSetInt( itemButtonRui, "lootTier", lootFlavor.tier )
			RuiSetInt( itemButtonRui, "count", useItemRefs[itemIdx].count )
			RuiSetBool( itemButtonRui, "isFullyKitted", lootFlavor.lootType == eLootType.MAINWEAPON && lootFlavor.tier == 4 )

			ToolTipData toolTipData
			toolTipData.titleText = lootFlavor.pickupString
			toolTipData.descText = SURVIVAL_Loot_GetPickupString( lootFlavor, params.player )
			                                               
			toolTipData.tooltipFlags = toolTipData.tooltipFlags | eToolTipFlag.PING_DISSABLED
			Hud_SetToolTipData( itemButton, toolTipData )
			RunUIScript( "ClientToUI_Tooltip_MarkForClientUpdate", itemButton, eTooltipStyle.DEFAULT )
		}
	}
}
#endif


#if CLIENT
void function UpdateItem( DeathBoxListPanelItem item )
{
	var button        = item.allocatedButton
	entity viewPlayer = GetLocalViewPlayer()

	Assert( item.key in fileLevel.deathBoxEntryDataByKey )
	if ( !(item.key in fileLevel.deathBoxEntryDataByKey) )
		return
	DeathBoxEntryData entryData = fileLevel.deathBoxEntryDataByKey[item.key]

	LootData lootFlavor   = entryData.lootFlav
	LootTypeData lootType = GetLootTypeData( lootFlavor.lootType )

	Signal( entryData, "DeathBoxEntryData_Update" )

	if ( button == null )
		return

	var rui = Hud_GetRui( button )

	bool isAmmo         = (lootFlavor.lootType == eLootType.AMMO)
	bool isMainWeapon   = (lootFlavor.lootType == eLootType.MAINWEAPON)
	bool isGadget		= (lootFlavor.lootType == eLootType.GADGET)
	bool isArmor   		= (lootFlavor.lootType == eLootType.ARMOR)
	bool hasSpecialAmmo = (isMainWeapon && !GetWeaponInfoFileKeyField_GlobalBool( lootFlavor.baseWeapon, "uses_ammo_pool" ))

	bool pingsAreIndirect = false
	bool isBlackMarket    = false
	entity deathBox       = GetEntityFromEncodedEHandle( fileLevel.currentDeathBoxEEH )
	if ( IsValid( deathBox ) && deathBox.GetNetworkedClassName() == "prop_loot_grabber" )
	{
		isBlackMarket = true
		pingsAreIndirect = true
	}

	array<entity> pingWaypoints = []
	int team                    = viewPlayer.GetTeam()
	foreach ( entity lootEnt in entryData.lootEnts )
	{
		if ( !IsValid( lootEnt ) )
			continue

		array<entity> lootEntPingWaypoints = Waypoint_GetWaypointsForLootItemPingedByTeam( lootEnt, team, pingsAreIndirect )
		pingWaypoints.extend( lootEntPingWaypoints )
	}

	RuiSetInt( rui, "count", hasSpecialAmmo ? 1 : entryData.totalCount )

	bool isPinged     = false
	bool isPingedByUs = false
	foreach ( entity pingWaypoint in pingWaypoints )
	{
		if ( Waypoint_IsHiddenFromLocalHud( pingWaypoint ) )
			continue

		isPinged = true
		if ( pingWaypoint.GetOwner() == viewPlayer )
			isPingedByUs = true
	}

	RuiSetBool( rui, "isPinged", isPinged )
	if ( isPinged )
		thread ItemPingUpdateThread( item, entryData, pingWaypoints )
	else
		RuiSetAsset( rui, "dibsAvatar", $"" )

	string title = lootFlavor.pickupString
	if ( isAmmo )
	{
		title = (entryData.totalCount == 0 ? "--" : format( "%d", entryData.totalCount ))
	}
	else if ( hasSpecialAmmo )
	{
		Assert( entryData.lootEnts.len() <= 1 )
		if ( entryData.lootEnts.len() > 0 )
		{
			entity lootEnt = entryData.lootEnts[0]
			if ( IsValid( lootEnt ) )
			{
				int maxAmmo  = GetWeaponInfoFileKeyField_GlobalInt( lootFlavor.baseWeapon, "ammo_default_total" )
				int currAmmo = lootEnt.GetClipCount()
				if ( currAmmo < 0 )
					currAmmo = maxAmmo

				title = Localize( "#HUD_LOOT_WITH_CLIP", Localize( lootFlavor.pickupString ), format( "%d/%d", currAmmo, maxAmmo ) )
			}
		}
	}
	else if ( isMainWeapon )
	{
		title = (entryData.totalCount > 1 ? format( "%s   x%d", title, entryData.totalCount ) : title)
	}
	else if ( lootFlavor.passive != ePassives.INVALID )
	{
		string passiveName = PASSIVE_NAME_MAP[lootFlavor.passive]
		title = Localize( "#HUD_LOOT_WITH_PASSIVE", Localize( lootFlavor.pickupString ), Localize( passiveName ) )
	}
	RuiSetString( rui, "buttonText", title )

	RuiSetImage( rui, "iconImage", lootFlavor.hudIcon )
	RuiSetInt( rui, "lootTier", lootFlavor.tier )
	RuiSetInt( rui, "lootType", lootFlavor.lootType )

	asset ammoTypeIcon = $""
	if ( hasSpecialAmmo )
	{
		ammoTypeIcon = lootFlavor.fakeAmmoIcon
	}
	else if ( isMainWeapon && SURVIVAL_Loot_IsRefValid( lootFlavor.ammoType ) )
	{
		LootData ammoData = SURVIVAL_Loot_GetLootDataByRef( lootFlavor.ammoType )
		ammoTypeIcon = ammoData.hudIcon
	}
	RuiSetAsset( rui, "ammoTypeImage", ammoTypeIcon )

	entity bestLootEnt = (entryData.lootEnts.len() > 0 && IsValid( entryData.lootEnts[0] ) ? entryData.lootEnts[0] : null)
	entryData.isUsable = (entryData.totalCount > 0 || isGadget ) && (IsValid( bestLootEnt ) || entryData.predictingNewEntToBeCreated)

	bool isBackpackItem = ( lootType.index != eLootType.MAINWEAPON && lootType.equipmentSlot == "" && lootFlavor.inventorySlotCount > 0 )
	entryData.isClickable = entryData.isUsable && !entryData.isBlocked && ( entryData.isRelevant || isBackpackItem )

	Hud_SetEnabled( button, true )
	RuiSetBool( rui, "isUsable", entryData.isUsable )
	Hud_SetLocked( button, !entryData.isUsable )
	RuiSetBool( rui, "isRelevant", entryData.isRelevant )
	RuiSetBool( rui, "isUpgrade", entryData.isUpgrade )
	RuiSetBool( rui, "isDimmed", (fileLevel.currentQuickSwapEntry != null && fileLevel.currentQuickSwapEntry != entryData) )
	RuiSetBool( rui, "isBlocked", entryData.isBlocked )
	RuiSetBool( rui, "isClickable", entryData.isClickable )

	if(bestLootEnt != null && isArmor)
	{
		                 
		bool isEvolving = EvolvingArmor_IsEquipmentEvolvingArmor( lootFlavor.ref )
		entity localPlayer = GetLocalClientPlayer()
		int armorTier = EquipmentSlot_GetEquipmentTier( localPlayer, "armor" )

		RuiSetFloat( rui, "shieldFrac", float(GetPropSurvivalMainPropertyFromEnt( bestLootEnt )) )
		RuiSetBool( rui, "isEvolvingShield", isEvolving )
		RuiSetInt( rui, "shieldEvolutionProgress", SURVIVAL_CreateLootRef(lootFlavor, bestLootEnt).lootExrtaProperty)
		RuiSetInt( rui, "replaceShieldEvolutionProgress", EvolvingArmor_GetEvolutionProgress(localPlayer))
		RuiSetInt( rui, "lootTierReplace", armorTier )
	}





	entryData.isRestrictedItem = false
	entryData.restrictedType = NORMAL_UNRESTRICTED_LOOT

	bool hasTooltip = false
	if ( IsValid( bestLootEnt ) && entryData.isUsable )
	{
		if ( isBlackMarket )
		{
			foreach ( int restrictedLootType in eRestrictedLootTypes )
			{
				entity restrictedPanel = SURVIVAL_Loot_GetRestrictedPanel( restrictedLootType, bestLootEnt )
				if ( IsValid( restrictedPanel ) && SURVIVAL_Loot_IsRestrictedPanelLocked( restrictedLootType, restrictedPanel ) && lootType.index != eLootType.AMMO )
				{
					entryData.isRestrictedItem = true
					entryData.restrictedType = restrictedLootType
					break
				}
			}
		}

		if ( !entryData.isBlocked )
		{
			hasTooltip = true
			ToolTipData dt
			dt.tooltipStyle = isMainWeapon ? eTooltipStyle.WEAPON_LOOT_PROMPT : eTooltipStyle.LOOT_PROMPT
			dt.lootPromptData.lootContext = eLootContext.GROUND
			dt.lootPromptData.index = lootFlavor.index
			dt.lootPromptData.count = entryData.totalCount
			dt.lootPromptData.isPinged = isPinged
			dt.lootPromptData.isPingedByUs = isPingedByUs
			dt.lootPromptData.isInDeathBox = true
			dt.tooltipFlags = dt.tooltipFlags | (IsPingEnabledForPlayer( viewPlayer ) ? eToolTipFlag.PING_DISSABLED : 0)
			                               
			{
				dt.lootPromptData.guid = bestLootEnt.GetEncodedEHandle()
				dt.lootPromptData.property = GetPropSurvivalMainPropertyFromEnt( bestLootEnt )
				if ( isMainWeapon )
					dt.lootPromptData.mods = bestLootEnt.GetWeaponMods()
			}
			Hud_SetToolTipData( button, dt )
			RunUIScript( "ClientToUI_Tooltip_MarkForClientUpdate", button, isMainWeapon ? eTooltipStyle.WEAPON_LOOT_PROMPT : eTooltipStyle.LOOT_PROMPT )
		}
	}

	if ( !hasTooltip )
	{
		Hud_ClearToolTipData( button )
		RunUIScript( "ClientToUI_Tooltip_Clear", button )
	}

	RuiSetBool( rui, "isSpecialItem", entryData.isRestrictedItem )

	RuiSetInt( rui, "useCounter", entryData.useCounter )
	RuiSetInt( rui, "pingCounter", entryData.pingCounter )
}
#endif


#if CLIENT
void function ItemPingUpdateThread( DeathBoxListPanelItem item, DeathBoxEntryData entryData, array<entity> pingWaypoints )
{
	EndSignal( fileLevel.signalDummy, "SurvivalGroundList_Closed" )
	EndSignal( entryData, "DeathBoxEntryData_Update" )
	EndSignal( entryData, "DeathBoxEntryData_Unbind" )

	var button = item.allocatedButton
	var rui    = Hud_GetRui( button )

	while ( true )
	{
		ArrayRemoveInvalid( pingWaypoints )
		if ( pingWaypoints.len() == 0 )
			break

		entity dibsPlayer = null
		foreach ( entity pingWaypoint in pingWaypoints )
		{
			entity pingWaypointDibsPlayer = Waypoint_GetLootPingDibsPlayer( pingWaypoint )
			if ( IsValid( pingWaypointDibsPlayer ) )
				dibsPlayer = pingWaypointDibsPlayer
		}

		asset dibsPlayerIcon = $""
		if ( IsValid( dibsPlayer ) && LoadoutSlot_IsReady( ToEHI( dibsPlayer ), Loadout_Character() ) )
			dibsPlayerIcon = CharacterClass_GetGalleryPortrait( LoadoutSlot_GetItemFlavor( ToEHI( dibsPlayer ), Loadout_Character() ) )
		RuiSetAsset( rui, "dibsAvatar", dibsPlayerIcon )

		WaitFrame()
	}

	entryData.pingCounter = 0

	thread UpdateItem( item )                                                                                                                       
	             
}
#endif


#if CLIENT
bool function IsGroundListMenuOpen()
{
	return IsValid( fileLevel.menu ) && Hud_IsVisible( fileLevel.menu )
}
#endif


#if CLIENT
void function ItemButtonSetup( var button )
{
	RunUIScript( "Survival_CommonButtonInit", button )
}
#endif


#if CLIENT
void function OnCategoryHeaderBind( DeathBoxListPanelData listPanelData, DeathBoxListPanelCategory category )
{
	RuiSetColorAlpha( Hud_GetRui( category.allocatedHeaderPanel ), "categoryHeaderTextCol", fileLevel.categoryHeaderTextCol, 1.0 )

	entity deathBox    = GetEntityFromEncodedEHandle( fileLevel.currentDeathBoxEEH )
	bool isBlackMarket = (IsValid( deathBox ) && deathBox.GetNetworkedClassName() == "prop_loot_grabber")
	RuiSetBool( Hud_GetRui( category.allocatedHeaderPanel ), "isBlackMarket", isBlackMarket )
}
#endif


#if CLIENT
void function OnCategoryHeaderUnbind( DeathBoxListPanelData listPanelData, DeathBoxListPanelCategory category )
{
	  
}
#endif


#if CLIENT
void function OnItemBind( DeathBoxListPanelData listPanelData, DeathBoxListPanelItem item )
{
	UpdateItem( item )
}
#endif


#if CLIENT
void function OnItemUnbind( DeathBoxListPanelData listPanelData, DeathBoxListPanelItem item )
{
	if ( !(item.key in fileLevel.deathBoxEntryDataByKey) )
		return

	DeathBoxEntryData entryData = fileLevel.deathBoxEntryDataByKey[item.key]
	Signal( entryData, "DeathBoxEntryData_Unbind" )
}
#endif


#if CLIENT
void function OnItemClick( DeathBoxListPanelData listPanelData, DeathBoxListPanelItem item )
{
	CloseQuickSwapIfOpen()

	bool isAltAction            = false
	bool fromExtendedUse        = false
	bool isFromQuickSwap        = false
	int ornull backpackSwapSlot = null
	PerformItemAction( item, isAltAction, fromExtendedUse, isFromQuickSwap, backpackSwapSlot )
}
#endif


#if CLIENT
void function OnItemClickRight( DeathBoxListPanelData listPanelData, DeathBoxListPanelItem item )
{
	CloseQuickSwapIfOpen()

	bool isAltAction            = true
	bool fromExtendedUse        = false
	bool isFromQuickSwap        = false
	int ornull backpackSwapSlot = null
	PerformItemAction( item, isAltAction, fromExtendedUse, isFromQuickSwap, backpackSwapSlot )
}
#endif


#if CLIENT
void functionref() wtfLootVaultConfirmDialogDoItFunc = null
void function PerformItemAction( DeathBoxListPanelItem item, bool isAltAction, bool fromExtendedUse, bool isFromQuickSwap, int ornull backpackSwapSlot )
{
	entity player               = GetLocalClientPlayer()
	DeathBoxEntryData entryData = fileLevel.deathBoxEntryDataByKey[item.key]
	if ( !entryData.isClickable )
		return
	LootData lootFlavor = entryData.lootFlav
	entity bestLootEnt  = (entryData.lootEnts.len() > 0 && IsValid( entryData.lootEnts[0] ) ? entryData.lootEnts[0] : null)
	                                
	  	      

	entity deathBox    = GetEntityFromEncodedEHandle( fileLevel.currentDeathBoxEEH )
	bool isBlackMarket = (IsValid( deathBox ) && deathBox.GetNetworkedClassName() == "prop_loot_grabber")

	int count = SURVIVAL_GetInventorySlotCountForPlayer( player, entryData.lootFlav )
	if ( entryData.lootFlav.lootType == eLootType.AMMO && !isBlackMarket )
	{
		int countToFillStack = SURVIVAL_GetCountToFillStack( player, entryData.lootFlav.ref )
		if ( countToFillStack < count )
			count += countToFillStack                                                       
	}

	array<ConsumableInventoryItem> predictedInventory = GetPredictedInventory()
	int inventoryLimit                                = SURVIVAL_GetInventoryLimit( player )
	int amountThatWouldBePickedUp                     = SURVIVAL_AddToInventory( predictedInventory, inventoryLimit, lootFlavor, count, SURVIVAL_GetInventorySlotCountForPlayer( player, lootFlavor ), true )
	bool isInventoryFull                              = (amountThatWouldBePickedUp == 0)                                       

	LootRef lootRef  = SURVIVAL_CreateLootRef( lootFlavor, bestLootEnt )
	int groundAction = SURVIVAL_GetActionForGroundItem( player, lootRef, isAltAction ).action

	bool showUseHighlight     = false
	bool shouldCloseQuickSwap = true
	
	if ( groundAction == eLootAction.NONE || groundAction == eLootAction.IGNORE )
	{
		  
	}
	else if ( !fromExtendedUse && !isFromQuickSwap && (groundAction == eLootAction.SWAP || isBlackMarket) )
	{
		bool requiresButtonFocus = true
		float duration = 0.4
		StartMenuExtendedUse( item.allocatedButton, fileLevel.holdToUseElem, duration, requiresButtonFocus, void function( bool success ) : (item, isAltAction, backpackSwapSlot) {
			if ( success )
				PerformItemAction( item, isAltAction, true, false, backpackSwapSlot )
		}, "UI_Survival_PickupTicker", "" )
	}
	else if ( count > 0 && isInventoryFull && backpackSwapSlot == null && groundAction == eLootAction.PICKUP && lootRef.lootData.ref != "s4t_item0" && lootRef.lootData.lootType != eLootType.GADGET )
	{
		OpenQuickSwap( item.allocatedButton, entryData, isAltAction )
		showUseHighlight = true
		shouldCloseQuickSwap = false
	}
	else
	{
		void functionref() doIt = void function() : ( entryData, count, bestLootEnt, groundAction, isAltAction, backpackSwapSlot ) {
			SendItemActionCommand( entryData, count, bestLootEnt, groundAction, isAltAction, backpackSwapSlot )
		}

		if ( isBlackMarket && entryData.isRestrictedItem )
		{
			wtfLootVaultConfirmDialogDoItFunc = doIt
			RunUIScript( "ClientToUI_RestrictedLootConfirmDialog_Open", deathBox.GetOwner() == player, entryData.restrictedType )
		}
		else
		{
			doIt()
		}

		showUseHighlight = true
	}

	if ( showUseHighlight )
	{
		entryData.useCounter += 1
		UpdateItem( item )
		EmitUISound( "ui_menu_accept" )
	}

	if ( shouldCloseQuickSwap )
		CloseQuickSwapIfOpen()
}
#endif

#if UI
void function ClientToUI_RestrictedLootConfirmDialog_Open( bool isBlackMarketOwner, int restrictedLootType )
{
	ConfirmDialogData data
	                                                                                                               
	array<string> dialogArray = SURVIVAL_Loot_GetRestrictedDialogArray( restrictedLootType )
	data.headerText = Localize( dialogArray[0] )

                      
	if ( isBlackMarketOwner && restrictedLootType != eRestrictedLootTypes.SPECTRE_SHACK )
     
                          
      
	{
		data.messageText = Localize( dialogArray[1] )

		data.resultCallback = void function( int result ) {
			if ( result == eDialogResult.YES )
				RunClientScript( "UIToClient_RestrictedLootConfirmDialog_DoIt" )
		}
		OpenConfirmDialogFromData( data )
	}
	else
	{
		data.messageText = Localize( dialogArray[2] )
		OpenOKDialogFromData( data )
	}
}
#endif

#if CLIENT
void function UIToClient_RestrictedLootConfirmDialog_DoIt()
{
	wtfLootVaultConfirmDialogDoItFunc()
	wtfLootVaultConfirmDialogDoItFunc = null
}
#endif

#if CLIENT
array<ConsumableInventoryItem> function GetPredictedInventory()
{
	entity localPlayer                                = GetLocalClientPlayer()
	int inventoryLimit                                = SURVIVAL_GetInventoryLimit( localPlayer )
	array<ConsumableInventoryItem> predictedInventory = SURVIVAL_GetPlayerInventory( localPlayer )

	foreach ( PredictedLootActionData plad in fileLevel.predictedActions )
	{
		LootData pladLootFlav = SURVIVAL_Loot_GetLootDataByRef( plad.lootFlavRef )

		if ( plad.count > 0 )
			SURVIVAL_AddToInventory( predictedInventory, inventoryLimit, pladLootFlav, plad.count, SURVIVAL_GetInventorySlotCountForPlayer( localPlayer, pladLootFlav ), true )
		else
			SURVIVAL_RemoveFromInventory( localPlayer, predictedInventory, pladLootFlav, -plad.count )
	}

	return predictedInventory
}
#endif


#if CLIENT
void function SendItemActionCommand( DeathBoxEntryData entryData, int count, entity preferredLootEnt, int actionType, bool isAltAction, int ornull backpackSwapSlot )
{
	count = maxint( 1, count )

	entity localPlayer = GetLocalClientPlayer()
	int pickupFlags    = PICKUP_FLAG_FROM_MENU
	if ( isAltAction )
		pickupFlags = pickupFlags | PICKUP_FLAG_ALT
	if ( actionType == eLootAction.ATTACH_TO_ACTIVE )
		pickupFlags = pickupFlags | PICKUP_FLAG_ATTACH_ACTIVE_ONLY
	if ( actionType == eLootAction.ATTACH_TO_STOWED )
		pickupFlags = pickupFlags | PICKUP_FLAG_ATTACH_STOWED_ONLY

	                                                                                                              
	  	        
	Remote_ServerCallFunction("ClientCallback_PickupSurvivalLootFromDeathbox",
		entryData.lootFlav.index,
		count,
		preferredLootEnt,
		GetEntityFromEncodedEHandle( fileLevel.currentDeathBoxEEH ),
		pickupFlags,
		(backpackSwapSlot != null ? expect int(backpackSwapSlot) : -1)
	)
	      

	PredictedLootActionData plad
	plad.type = actionType
	plad.time = Time()
	plad.lootFlavRef = entryData.lootFlav.ref
	plad.bestLootEntEEH = IsValid( preferredLootEnt ) ? preferredLootEnt.GetEncodedEHandle() : EncodedEHandle_null
	plad.backpackSwapSlot = backpackSwapSlot

	plad.count = minint( count, entryData.totalCount )
	if ( actionType == eLootAction.PICKUP || actionType == eLootAction.PICKUP_ALL || actionType == eLootAction.SWAP )
	{
		array<ConsumableInventoryItem> predictedInventory = GetPredictedInventory()

		                                 
		   
		  	                            
		  	                                                                          
		  	                                                                                                                                        
		   

		int inventoryLimit = SURVIVAL_GetInventoryLimit( localPlayer )
		int numAdded       = SURVIVAL_AddToInventory( predictedInventory, inventoryLimit, entryData.lootFlav, plad.count, SURVIVAL_GetInventorySlotCountForPlayer( localPlayer, entryData.lootFlav ), true )
		plad.count = numAdded
	}

	fileLevel.predictedActions.append( plad )
	fileLevel.predictedActionsDirty = true

	if ( plad.count >= entryData.totalCount )
		entryData.wasLastLootPickedUpByLocalPlayer = true
}
#endif


#if CLIENT
void function OnItemFocusGet( DeathBoxListPanelData listPanelData, DeathBoxListPanelItem item )
{
	RunUIScript( "UpdateFooterOptions" )
}
#endif


#if CLIENT
void function OnItemFocusLose( DeathBoxListPanelData listPanelData, DeathBoxListPanelItem item )
{
	RunUIScript( "UpdateFooterOptions" )
}
#endif


#if CLIENT
bool function OnItemKeyEvent( DeathBoxListPanelData listPanelData, DeathBoxListPanelItem item, int keyId, bool isDown )
{
	if ( keyId == BUTTON_SHOULDER_RIGHT && isDown )
	{
		PingItem( item )
		return true
	}

	                                                                                                             
	                                                                    
	   
	  	                                  
	  	           
	   

	return false
}
#endif


#if CLIENT
void function OnItemCommandEvent( DeathBoxListPanelData listPanelData, DeathBoxListPanelItem item, string command )
{
	if ( command == "+ping" )
		PingItem( item )

}
#endif


#if CLIENT
void function PingItem( DeathBoxListPanelItem item )
{
	DeathBoxEntryData entryData = fileLevel.deathBoxEntryDataByKey[item.key]
	entity bestLootEnt          = (entryData.lootEnts.len() > 0 && IsValid( entryData.lootEnts[0] ) ? entryData.lootEnts[0] : null)
	if ( !IsValid( bestLootEnt ) )
		return

	entity deathBox = GetEntityFromEncodedEHandle( fileLevel.currentDeathBoxEEH )

	bool pingsAreIndirect = false
	if ( IsValid( deathBox ) && deathBox.GetNetworkedClassName() == "prop_loot_grabber" )
		pingsAreIndirect = true

	entity localPlayer       = GetLocalClientPlayer()
	entity lootEntPingedByUs = null
	foreach ( entity lootEnt in entryData.lootEnts )
	{
		if ( IsValid( lootEnt ) && IsValid( Waypoint_GetWaypointForLootItemPingedByPlayer( lootEnt, localPlayer, pingsAreIndirect ) ) )
		{
			lootEntPingedByUs = lootEnt
			break
		}
	}

	if ( IsValid( lootEntPingedByUs ) )
	{
		                      
		PingGroundLoot( lootEntPingedByUs, deathBox )
		entryData.pingCounter = 0
	}
	else
	{
		                   
		PingGroundLoot( bestLootEnt, deathBox )
		entryData.pingCounter += 1
	}

	UpdateItem( item )
}
#endif


#if CLIENT
void function OnPingCreatedByAnyPlayer( entity pingingPlayer, int pingType, entity focusEnt, vector pingLoc, entity wayPoint )
{
	if ( pingType != ePingType.LOOT )
		return

	entity lootEnt = Waypoint_GetItemEntForLootWaypoint( wayPoint )
	if ( !(lootEnt in fileLevel.deathBoxEntryDataByLootEnt) )
		return
	DeathBoxEntryData entryData       = fileLevel.deathBoxEntryDataByLootEnt[lootEnt]
	DeathBoxListPanelItem ornull item = DeathBoxListPanel_GetItemByKey( fileLevel.listPanel, entryData.key )
	if ( item == null )
		return
	expect DeathBoxListPanelItem(item)
	UpdateItem( item )
}
#endif


#if CLIENT
void function OpenQuickSwap( var itemButton, DeathBoxEntryData entryData, bool isAltAction )
{
	fileLevel.currentQuickSwapEntry = entryData
	fileLevel.currentQuickSwapItemButton = itemButton
	fileLevel.currentQuickSwapIsAltAction = isAltAction

	if ( IsValid( itemButton ) )
	{
		Hud_SetSelected( itemButton, true )
		if ( Hud_HasToolTipData( fileLevel.currentQuickSwapItemButton ) )
		{
			ToolTipData ttd = Hud_GetToolTipData( itemButton )
			ttd.tooltipFlags = ttd.tooltipFlags | eToolTipFlag.HIDDEN
			Hud_SetToolTipData( itemButton, ttd )
		}
	}

	foreach ( string entryDataKey, DeathBoxEntryData _ in fileLevel.deathBoxEntryDataByKey )
	{
		DeathBoxListPanelItem ornull item = DeathBoxListPanel_GetItemByKey( fileLevel.listPanel, entryDataKey )
		if ( item == null )
			continue
		expect DeathBoxListPanelItem(item)
		if ( IsValid( item.allocatedButton ) )
			HudElem_SetRuiArg( item.allocatedButton, "isDimmed", true )
	}
	HudElem_SetRuiArg( itemButton, "isDimmed", false )

	RunUIScript( "ClientToUI_SurvivalGroundList_OpenQuickSwap", itemButton )
}
#endif


#if CLIENT
void function CloseQuickSwapIfOpen()
{
	RunUIScript( "ClientToUI_SurvivalGroundList_CloseQuickSwap", fileLevel.currentQuickSwapItemButton )

	if ( IsValid( fileLevel.currentQuickSwapItemButton ) )
	{
		Hud_SetSelected( fileLevel.currentQuickSwapItemButton, false )
		if ( Hud_HasToolTipData( fileLevel.currentQuickSwapItemButton ) )
		{
			ToolTipData ttd = Hud_GetToolTipData( fileLevel.currentQuickSwapItemButton )
			ttd.tooltipFlags = ttd.tooltipFlags & ~eToolTipFlag.HIDDEN
			Hud_SetToolTipData( fileLevel.currentQuickSwapItemButton, ttd )
		}
	}

	fileLevel.currentQuickSwapEntry = null
	fileLevel.currentQuickSwapItemButton = null

	foreach ( string entryDataKey, DeathBoxEntryData entryData in fileLevel.deathBoxEntryDataByKey )
	{
		DeathBoxListPanelItem ornull item = DeathBoxListPanel_GetItemByKey( fileLevel.listPanel, entryDataKey )
		if ( item == null )
			continue
		expect DeathBoxListPanelItem(item)
		if ( IsValid( item.allocatedButton ) )
			HudElem_SetRuiArg( item.allocatedButton, "isDimmed", false )
	}
}
#endif


#if CLIENT
void function UIToClient_CloseQuickSwapIfOpen()
{
	CloseQuickSwapIfOpen()
}
#endif


#if CLIENT
void function RefreshQuickSwapIfOpen()
{
	RunUIScript( "ClientToUI_SurvivalGroundList_RefreshQuickSwap" )
}
#endif


#if UI
void function ClientToUI_SurvivalGroundList_RefreshQuickSwap()
{
	GridPanel_Refresh( fileVM.quickSwapGrid )
}
#endif


#if UI
void function ClientToUI_SurvivalGroundList_OpenQuickSwap( var itemButton )
{
	GridPanel_Refresh( fileVM.quickSwapGrid )

	Hud_Show( fileVM.quickSwapGrid )
	Hud_Show( fileVM.quickSwapHeader )
	Hud_Show( fileVM.inventorySwapIcon )
	Hud_Show( fileVM.quickSwapBacker )

	int buttonY    = Hud_GetY( itemButton ) + (Hud_GetHeight( itemButton ) / 2)
	int gridHeight = Hud_GetHeight( fileVM.quickSwapGrid )
	int gridOffset = -buttonY + (gridHeight / 2)
	Hud_SetY( fileVM.quickSwapGrid, gridOffset )

	int gridWidth = Hud_GetWidth( fileVM.quickSwapGrid )
	Hud_SetSize( fileVM.quickSwapHeader, gridWidth + ContentScaledXAsInt( 18 ), ContentScaledYAsInt( 64 ) )
	Hud_SetSize( fileVM.quickSwapBacker, gridWidth + ContentScaledXAsInt( 18 ), gridHeight - ContentScaledYAsInt( 14 ) )

	var firstGridButton  = Hud_GetChild( fileVM.quickSwapGrid, "GridButton0x0" )
	var secondGridButton = Hud_GetChild( fileVM.quickSwapGrid, "GridButton1x0" )
	Hud_SetNavRight( itemButton, firstGridButton )
	Hud_SetNavLeft( secondGridButton, itemButton )
	Hud_SetNavLeft( secondGridButton, itemButton )
	if ( GetDpadNavigationActive() )
		Hud_SetFocused( firstGridButton )
}
#endif


#if UI
void function ClientToUI_SurvivalGroundList_CloseQuickSwap( var itemButton )
{
	Hud_Hide( fileVM.quickSwapGrid )
	Hud_Hide( fileVM.quickSwapHeader )
	Hud_Hide( fileVM.inventorySwapIcon )
	Hud_Hide( fileVM.quickSwapBacker )
}
#endif


#if UI
void function OnQuickSwapItemBind( var panel, var button, int index )
{
	Hud_ClearToolTipData( button )
	RunClientScript( "UIToClient_SurvivalGroundList_UpdateQuickSwapItem", button, TranslateBackpackGridPosition( index ) )
}
#endif


#if CLIENT
void function UIToClient_SurvivalGroundList_UpdateQuickSwapItem( var button, int backpackSwapSlot )
{
	entity viewPlayer = GetLocalViewPlayer()
	var buttonRui     = Hud_GetRui( button )

	Hud_ClearToolTipData( button )

	array<ConsumableInventoryItem> predictedInventory = GetPredictedInventory()
	if ( backpackSwapSlot >= predictedInventory.len() )
	{
		RunUIScript( "ClientToUI_Tooltip_Clear", button )
		Hud_SetEnabled( button, false )
		return
	}
	ConsumableInventoryItem item = predictedInventory[backpackSwapSlot]
	LootData lootFlavor          = SURVIVAL_Loot_GetLootDataByIndex( item.type )

	Hud_SetEnabled( button, true )
	Hud_SetLocked( button, SURVIVAL_IsLootIrrelevant( viewPlayer, null, lootFlavor, eLootContext.BACKPACK ) )
	Hud_SetSelected( button, IsOrdnanceEquipped( viewPlayer, lootFlavor.ref ) )

	RuiSetImage( buttonRui, "iconImage", lootFlavor.hudIcon )
	RuiSetInt( buttonRui, "lootTier", lootFlavor.tier )
	RuiSetInt( buttonRui, "count", item.count )
	RuiSetInt( buttonRui, "maxCount", SURVIVAL_GetInventorySlotCountForPlayer( viewPlayer, lootFlavor ) )
	RuiSetInt( buttonRui, "numPerPip", lootFlavor.lootType == eLootType.AMMO ? lootFlavor.countPerDrop : 1 )

	ToolTipData toolTipData
	toolTipData.titleText = lootFlavor.pickupString
	toolTipData.descText = SURVIVAL_Loot_GetDesc( lootFlavor, viewPlayer )
	toolTipData.actionHint1 = Localize( "#LOOT_SWAP", Localize( lootFlavor.pickupString ) ).toupper()
	toolTipData.tooltipFlags = toolTipData.tooltipFlags | (IsPingEnabledForPlayer( viewPlayer ) ? eToolTipFlag.PING_DISSABLED : 0)
	if ( Survival_PlayerCanDrop( viewPlayer ) )
		toolTipData.actionHint2 = Localize( "#LOOT_ALT_DROP" ).toupper()
	Hud_SetToolTipData( button, toolTipData )
	RunUIScript( "ClientToUI_Tooltip_MarkForClientUpdate", button, eTooltipStyle.DEFAULT )
}
#endif


#if UI
void function OnQuickSwapItemClick( var panel, var button, int index )
{
	RunClientScript( "UIToClient_SurvivalGroundList_OnQuickSwapItemClick", button, TranslateBackpackGridPosition( index ), false )
}
#endif


#if UI
void function OnQuickSwapItemClickRight( var panel, var button, int index )
{
	RunClientScript( "UIToClient_SurvivalGroundList_OnQuickSwapItemClick", button, TranslateBackpackGridPosition( index ), true )
}
#endif


#if CLIENT
void function UIToClient_SurvivalGroundList_OnQuickSwapItemClick( var button, int backpackSwapSlot, bool isRightClick )
{
	entity localPlayer = GetLocalClientPlayer()

	DeathBoxEntryData entryData = expect DeathBoxEntryData(fileLevel.currentQuickSwapEntry)
	entity bestLootEnt          = (entryData.lootEnts.len() > 0 && IsValid( entryData.lootEnts[0] ) ? entryData.lootEnts[0] : null)
	if ( !IsValid( bestLootEnt ) )
		return

	array<ConsumableInventoryItem> predictedInventory = GetPredictedInventory()
	if ( !predictedInventory.isvalidindex( backpackSwapSlot ) )
		return         

	ConsumableInventoryItem inventoryEntry = predictedInventory[backpackSwapSlot]
	LootData dropLootFlav                  = SURVIVAL_Loot_GetLootDataByIndex( inventoryEntry.type )

                
	if ( dropLootFlav.noDrop )
		return
       

	PredictedLootActionData plad
	plad.type = eLootAction.DROP_ALL
	plad.time = Time()
	plad.lootFlavRef = dropLootFlav.ref

	plad.count = -inventoryEntry.count

	fileLevel.predictedActions.append( plad )
	fileLevel.predictedActionsDirty = true

	string itemKey = dropLootFlav.ref
	if ( !(itemKey in fileLevel.deathBoxEntryDataByKey) )
	{
		DeathBoxEntryData newEntry
		newEntry.key = itemKey
		newEntry.lootFlav = dropLootFlav
		fileLevel.deathBoxEntryDataByKey[itemKey] <- newEntry
	}

	if ( isRightClick )
	{
		                                                                    
		Remote_ServerCallFunction( "ClientCallback_Sur_DropBackpackItem_UI", dropLootFlav.ref, inventoryEntry.count, fileLevel.currentDeathBoxEEH )
		RefreshQuickSwapIfOpen()
	}
	else
	{
		DeathBoxListPanelItem ornull item = DeathBoxListPanel_GetItemByKey( fileLevel.listPanel, entryData.key )
		if ( item != null )
		{
			expect DeathBoxListPanelItem(item)
			bool isAltAction       = fileLevel.currentQuickSwapIsAltAction
			bool isFromExtendedUse = false
			bool isFromQuickSwap   = true
			PerformItemAction( item, isAltAction, isFromExtendedUse, isFromQuickSwap, backpackSwapSlot )
		}
	}
}
#endif

#if UI
void function OnMouseLeftPressed( var _ )
{
	if ( CanRunClientScript() )
		RunClientScript( "UIToClient_SurvivalGroundList_OnMouseLeftPressed" )
}
#endif

#if UI
void function OnMouseWheelScrollUp( var button )
{
	if ( CanRunClientScript() )
		RunClientScript( "UIToClient_DeathBoxListPanel_OnMouseWheelScrollUp", button )
}
#endif

#if UI
void function OnMouseWheelScrollDown( var button )
{
	if ( CanRunClientScript() )
		RunClientScript( "UIToClient_DeathBoxListPanel_OnMouseWheelScrollDown", button )
}
#endif

#if UI
void function HandleAnalogStickScroll( entity player, float val )
{
	if ( CanRunClientScript() )
		RunClientScript( "UIToClient_DeathBoxListPanel_HandleAnalogStickScroll", player, val )
}
#endif

#if CLIENT
void function UIToClient_SurvivalGroundList_OnMouseLeftPressed()
{
	if ( fileLevel.currentDeathBoxEEH == EncodedEHandle_null )
		return

	var focus = GetFocus()
	if ( !IsValid( focus ) )
		return

	if ( focus != fileLevel.currentQuickSwapItemButton && !IsCursorInElementBounds( fileLevel.currentQuickSwapItemButton )
	&& focus != fileLevel.quickSwapBacker && !IsCursorInElementBounds( fileLevel.quickSwapBacker )
	&& focus != fileLevel.quickSwapGrid && !IsCursorInElementBounds( fileLevel.quickSwapGrid )
	&& Hud_GetParent( focus ) != fileLevel.quickSwapGrid
	&& focus != fileLevel.quickSwapHeader && !IsCursorInElementBounds( fileLevel.quickSwapHeader )
	&& focus != fileLevel.inventorySwapIcon && !IsCursorInElementBounds( fileLevel.inventorySwapIcon ) )
	{
		CloseQuickSwapIfOpen()
	}
}
#endif

#if UI
void function OnWeaponSwapButtonClick( var button )
{
	RunClientScript( "UIToClient_WeaponSwap" )
}
#endif


#if CLIENT
void function Delayed_SetCursorToObject( var obj )
{
	RegisterSignal( "Delayed_SetCursorToObject" )
	Signal( clGlobal.signalDummy, "Delayed_SetCursorToObject" )
	EndSignal( clGlobal.signalDummy, "Delayed_SetCursorToObject" )

	wait 0.1                              

	float width  = 1920
	float height = 1080

	UISize screenSize = GetScreenSize()
	float x           = float( Hud_GetAbsX( obj ) + Hud_GetWidth( obj ) / 2 ) / screenSize.width
	float y           = float( Hud_GetAbsY( obj ) + Hud_GetHeight( obj ) / 2 ) / screenSize.height

	SetCursorPosition( <width * x, height * y, 0> )
}
#endif


#if CLIENT
bool function IsCursorInElementBounds( var element )
{
	if ( !IsValid( element ) )
		return false

	vector cursorPos  = GetCursorPosition()
	UISize screenSize = GetScreenSize()
	cursorPos.x *= screenSize.width / 1920.0
	cursorPos.y *= screenSize.height / 1080.0

	UISize elementSize = REPLACEHud_GetSize( element )
	UIPos elementPos   = REPLACEHud_GetAbsPos( element )

	return PointInBounds( cursorPos, elementPos, elementSize )
}
#endif


