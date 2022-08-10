global function CollectionEventPanel_Init
global function StorePanelCollectionEvent_LevelInit
global function StorePanelCollectionEvent_LevelShutdown

struct {
	var panel
	var bigInfoBox
	var aboutButton
	var purchaseSinglePackButton
	var purchaseMultiplePacksButton
	var completionRewardBox
	                            
	var rewardBarPanel
	var rewardBarBacker
	var itemDetailsBox
	var openPackButton

	array<var>             allRewardButtons
	array<array<var> >     rewardButtonRows
	table<var, ItemFlavor> rewardButtonToRewardFlavMap

	ItemFlavor ornull activeCollectionEvent = null

	var WORKAROUND_currentlyFocusedRewardButtonForFooters = null
	int WORKAROUND_purchaseMultiplePacksButton_currentQty = -1

	array<var>			   mythicIndicatorButtons
	int                      activeMythicTier = 0
	bool                     focusedButtonIsntMythic = true
	bool                     autoRunning = false
} file

const REWARD_BUTTONS_ROW_COUNT = 2
const REWARD_BUTTONS_COL_COUNT = 12

const PACK_BULK_PURCHASE_COUNT = 10

const MYTHIC_INIDICATOR_COUNT = 3
const MYTHIC_INDICATOR_NAME = "MythicIndicatorButton"

void function CollectionEventPanel_Init( var panel )
{
	file.panel = panel
	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, CollectionEventPanel_OnPanelShow )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, CollectionEventPanel_OnPanelHide )

	file.bigInfoBox = Hud_GetChild( panel, "BigInfoBox" )
	file.aboutButton = Hud_GetChild( panel, "AboutButton" )
	file.purchaseSinglePackButton = Hud_GetChild( panel, "Purchase1PackButton" )
	file.purchaseMultiplePacksButton = Hud_GetChild( panel, "PurchaseNPacksButton" )
	file.completionRewardBox = Hud_GetChild( panel, "CompletionRewardBox" )
	                                                                               
	file.rewardBarPanel = Hud_GetChild( panel, "RewardBarPanel" )
	file.rewardBarBacker = Hud_GetChild( file.rewardBarPanel, "RewardBarBacker" )
	file.itemDetailsBox = Hud_GetChild( panel, "ItemDetailsBox" )
	file.openPackButton = Hud_GetChild( panel, "OpenPackButton" )

	for ( int rewardButtonRowIdx = 0; rewardButtonRowIdx < REWARD_BUTTONS_ROW_COUNT; rewardButtonRowIdx++ )
	{
		array<var> row = []
		for ( int rewardButtonColIdx = 0; rewardButtonColIdx < REWARD_BUTTONS_COL_COUNT; rewardButtonColIdx++ )
		{
			var rewardButton = Hud_GetChild( file.rewardBarPanel, format( "RewardButton%02dx%02d", rewardButtonColIdx + 1, rewardButtonRowIdx + 1 ) )
			Hud_Show( rewardButton )
			Hud_AddEventHandler( rewardButton, UIE_GET_FOCUS, RewardButton_OnGetFocus )
			Hud_AddEventHandler( rewardButton, UIE_LOSE_FOCUS, RewardButton_OnLoseFocus )
			Hud_AddEventHandler( rewardButton, UIE_CLICK, RewardButton_OnActivate )
			Hud_AddEventHandler( rewardButton, UIE_CLICKRIGHT, RewardButton_OnAltActivate )
			row.append( rewardButton )
			file.allRewardButtons.append( rewardButton )
		}
		file.rewardButtonRows.append( row )
	}

	Hud_AddEventHandler( file.aboutButton, UIE_CLICK, AdvanceMenuEventHandler( GetMenu( "CollectionEventAboutPage" ) ) )

	Hud_AddEventHandler( file.purchaseSinglePackButton, UIE_CLICK, void function( var button ) {
		PurchasePackButton_OnClick( button, 1 )
	} )
	Hud_AddEventHandler( file.purchaseMultiplePacksButton, UIE_CLICK, void function( var button ) {
		PurchasePackButton_OnClick( button, file.WORKAROUND_purchaseMultiplePacksButton_currentQty )
	} )

	Hud_AddEventHandler( file.purchaseSinglePackButton, UIE_GET_FOCUS, RewardButton_OnGetFocus )
	Hud_AddEventHandler( file.purchaseSinglePackButton, UIE_LOSE_FOCUS, RewardButton_OnLoseFocus )
	Hud_AddEventHandler( file.purchaseMultiplePacksButton, UIE_GET_FOCUS, RewardButton_OnGetFocus )
	Hud_AddEventHandler( file.purchaseMultiplePacksButton, UIE_LOSE_FOCUS, RewardButton_OnLoseFocus )

	                                                                                                      
	                                                                                                        
	                                                                                               

	Hud_AddEventHandler( file.completionRewardBox, UIE_GET_FOCUS, CompletionRewardBox_OnGetFocus )
	Hud_AddEventHandler( file.completionRewardBox, UIE_LOSE_FOCUS, CompletionRewardBox_OnLoseFocus )
	Hud_AddEventHandler( file.completionRewardBox, UIE_CLICK, CompletionRewardBox_OnClick )

	Hud_AddEventHandler( file.openPackButton, UIE_CLICK, OpenPackButton_OnClick )

	AddPanelFooterOption( panel, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
	AddPanelFooterOption( panel, LEFT, BUTTON_A, false, "#A_BUTTON_INSPECT_BUY", "#A_BUTTON_INSPECT_BUY", null, IsFocusedItemInspectableAndBuyable )
	AddPanelFooterOption( panel, LEFT, BUTTON_A, false, "#A_BUTTON_INSPECT", "#A_BUTTON_INSPECT", null, IsFocusedItemInspectableButNotBuyable )
	AddPanelFooterOption( panel, LEFT, BUTTON_X, false, "#X_BUTTON_EQUIP", "#X_BUTTON_EQUIP", null, IsFocusedItemEquippable )

	RegisterSignal( "OnCollectionEventPanelMenu_Hide" )

	for ( int indicatorIndex = 0; indicatorIndex < MYTHIC_INIDICATOR_COUNT; indicatorIndex++ )
	{
		var button = Hud_GetChild( panel, MYTHIC_INDICATOR_NAME + string( indicatorIndex ) )
		HudElem_SetRuiArg( button, "buttonTier", indicatorIndex + 1 )
		file.mythicIndicatorButtons.append( button )
		Hud_Hide( button )
		Hud_AddEventHandler( button, UIE_GET_FOCUS, MythicInidicatorButton_OnGetFocus )
		Hud_AddEventHandler( button, UIE_LOSE_FOCUS, MythicInidicatorButton_OnLoseFocus )
	}
}

void function StorePanelCollectionEvent_LevelInit()
{
}

void function StorePanelCollectionEvent_LevelShutdown()
{
	file.WORKAROUND_currentlyFocusedRewardButtonForFooters = null
	file.rewardButtonToRewardFlavMap.clear()
	file.focusedButtonIsntMythic = true
	Signal( uiGlobal.signalDummy, "OnCollectionEventPanelMenu_Hide" )
}

void function CollectionEventPanel_OnPanelShow( var panel )
{
	UI_SetPresentationType( ePresentationType.COLLECTION_EVENT )

	if ( GetCurrentPlaylistVarBool( "collection_event_panel_clear", true  ) )                                  
		file.rewardButtonToRewardFlavMap.clear()

	AddCallbackAndCallNow_OnGRXInventoryStateChanged( CollectionEventPanel_UpdateGRXDependantElements )
	AddCallbackAndCallNow_OnGRXOffersRefreshed( CollectionEventPanel_UpdateGRXDependantElements )

	if ( !GetCurrentPlaylistVarBool( "disableCollectionEventAutoAward", false ) )
		thread TryOpenLootCeremonyAndCompletionRewardPack()
}


void function CollectionEventPanel_OnPanelHide( var panel )
{
	file.activeCollectionEvent = null

	RunClientScript( "UIToClient_StopBattlePassScene" )

	RemoveCallback_OnGRXInventoryStateChanged( CollectionEventPanel_UpdateGRXDependantElements )
	RemoveCallback_OnGRXOffersRefreshed( CollectionEventPanel_UpdateGRXDependantElements )

	RunClientScript( "UIToClient_StopTempBattlePassPresentationBackground" )

	Signal( uiGlobal.signalDummy, "OnCollectionEventPanelMenu_Hide" )
}


void function CollectionEventPanel_UpdateGRXDependantElements()
{
	bool isInventoryReady                   = GRX_IsInventoryReady()
	bool offersReady                        = GRX_AreOffersReady()
	ItemFlavor ornull activeCollectionEvent = GetActiveCollectionEvent( GetUnixTimestamp() )
	bool haveActiveCollectionEvent          = (activeCollectionEvent != null)
	bool menuIsUsable                       = isInventoryReady && haveActiveCollectionEvent
	int currentMaxEventPackPurchaseCount    = 0

	file.activeCollectionEvent = activeCollectionEvent
	file.rewardButtonToRewardFlavMap.clear()

	file.focusedButtonIsntMythic = true
	file.activeMythicTier = 0

	if ( haveActiveCollectionEvent )
	{
		expect ItemFlavor( activeCollectionEvent )
		Newness_IfNecessaryMarkItemFlavorAsNoLongerNewAndInformServer( activeCollectionEvent )

		array<CollectionEventRewardGroup> rewardGroups = CollectionEvent_GetRewardGroups( activeCollectionEvent )
		Assert( rewardGroups.len() == 2, format( "Only collection events with two reward groups are supported right now. (%s)", ItemFlavor_GetHumanReadableRef( activeCollectionEvent ) ) )

		HudElem_SetRuiArg( file.bigInfoBox, "title", ItemFlavor_GetShortName( activeCollectionEvent ) )
		HudElem_SetRuiArg( file.bigInfoBox, "isOfferRestricted", GRX_IsOfferRestricted() )

		DisplayTime dt = SecondsToDHMS( maxint( 0, CalEvent_GetFinishUnixTime( activeCollectionEvent ) - GetUnixTimestamp() ) )
		HudElem_SetRuiArg( file.bigInfoBox, "timeRemainingText", Localize( "#DAYS_REMAINING", string( dt.days ), string( dt.hours ) ) )

		HudElem_SetRuiArg( file.bigInfoBox, "mainThemeCol", SrgbToLinear( CollectionEvent_GetMainThemeCol( activeCollectionEvent ) ) )
		HudElem_SetRuiArg( file.bigInfoBox, "frontPageBGTintCol", SrgbToLinear( CollectionEvent_GetFrontPageBGTintCol( activeCollectionEvent ) ) )
		HudElem_SetRuiArg( file.bigInfoBox, "frontPageTitleCol", SrgbToLinear( CollectionEvent_GetFrontPageTitleCol( activeCollectionEvent ) ) )
		HudElem_SetRuiArg( file.bigInfoBox, "frontPageSubtitleCol", SrgbToLinear( CollectionEvent_GetFrontPageSubtitleCol( activeCollectionEvent ) ) )
		HudElem_SetRuiArg( file.bigInfoBox, "frontPageTimeRemainingCol", SrgbToLinear( CollectionEvent_GetFrontPageTimeRemainingCol( activeCollectionEvent ) ) )
		HudElem_SetRuiArg( file.bigInfoBox, "bgPatternImage", CollectionEvent_GetBGPatternImage( activeCollectionEvent ) )
		HudElem_SetRuiArg( file.bigInfoBox, "headerIcon", CollectionEvent_GetHeaderIcon( activeCollectionEvent ) )

		                                                                                    
		                                                                                               
		                                                                                          
		                                                                                                                                      

		ItemFlavor completionRewardPack = HeirloomEvent_GetCompletionRewardPack( activeCollectionEvent )
		array<ItemFlavor> rewardPackContents = GRXPack_GetPackContents( completionRewardPack )
		bool isOwned = false;
		foreach ( ItemFlavor flav in rewardPackContents )
		{
			isOwned = isInventoryReady && GRX_IsItemOwnedByPlayer( flav );
		}

		HudElem_SetRuiArg( file.completionRewardBox, "isOwned", isOwned );
		HudElem_SetRuiArg( file.completionRewardBox, "bgPatternImage", CollectionEvent_GetBGTabPatternImage( activeCollectionEvent ) )
		HudElem_SetRuiArg( file.completionRewardBox, "itemImage", HeirloomEvent_GetHeirloomButtonImage( activeCollectionEvent ) )
		HudElem_SetRuiArg( file.completionRewardBox, "itemsOwnedCount", HeirloomEvent_GetItemCount( activeCollectionEvent, true, GetLocalClientPlayer() ) )
		HudElem_SetRuiArg( file.completionRewardBox, "totalItemsCount", HeirloomEvent_GetItemCount( activeCollectionEvent, false, GetLocalClientPlayer() ) )
		HudElem_SetRuiArg( file.completionRewardBox, "headerText", HeirloomEvent_GetHeirloomHeaderText( activeCollectionEvent ) )
		HudElem_SetRuiArg( file.completionRewardBox, "unlockDesc", HeirloomEvent_GetHeirloomUnlockDesc( activeCollectionEvent ) )

		HudElem_SetRuiArg( file.rewardBarBacker, "title", CollectionEvent_GetFrontPageRewardBoxTitle( activeCollectionEvent ) )
		HudElem_SetRuiArg( file.rewardBarBacker, "bgPatternImage", CollectionEvent_GetBGTabPatternImage( activeCollectionEvent ) )
		HudElem_SetRuiArg( file.rewardBarBacker, "itemsOwnedNum", HeirloomEvent_GetItemCount( activeCollectionEvent, true, GetLocalClientPlayer() ) )
		HudElem_SetRuiArg( file.rewardBarBacker, "totalItemsNum", HeirloomEvent_GetItemCount( activeCollectionEvent, false, GetLocalClientPlayer() ) )

		foreach ( int rewardButtonRowIdx, array<var> rewardButtonRow in file.rewardButtonRows )
		{
			int rewardGroupIdx                     = rewardButtonRowIdx
			CollectionEventRewardGroup rewardGroup = rewardGroups[rewardButtonRowIdx]
			Assert( rewardGroup.rewards.len() <= rewardButtonRow.len(), format( "Collection event reward group has too many rewards. (%s)", ItemFlavor_GetHumanReadableRef( activeCollectionEvent ) ) )

			                                                                                                             
			                                                                                                                   
			                                                                                                           

			foreach ( int rewardButtonColIdx, var rewardButton in rewardButtonRow )
			{
				ItemFlavor rewardFlav = rewardGroup.rewards[rewardButtonColIdx]
				file.rewardButtonToRewardFlavMap[rewardButton] <- rewardFlav

				isOwned = isInventoryReady && GRX_IsItemOwnedByPlayer( rewardFlav )
				HudElem_SetRuiArg( rewardButton, "isOwned", isOwned )

				int quality = ItemFlavor_HasQuality( rewardFlav ) ? ItemFlavor_GetQuality( rewardFlav ) : 0
				Assert( quality == rewardGroup.quality, format( "Reward quality does not match collection event reward group quality. (%s, %s)", ItemFlavor_GetHumanReadableRef( activeCollectionEvent ), ItemFlavor_GetHumanReadableRef( rewardFlav ) ) )
				HudElem_SetRuiArg( rewardButton, "rarity", quality )
				RuiSetImage( Hud_GetRui( rewardButton ), "buttonImage", CustomizeMenu_GetRewardButtonImage( rewardFlav ) )
			}
		}

		if ( offersReady )
		{
			currentMaxEventPackPurchaseCount = CollectionEvent_GetCurrentMaxEventPackPurchaseCount( activeCollectionEvent, GetLocalClientPlayer() )

			                                                                                                               
			                                            
			   
			  	                                                  
			  	                                                       
			  	                                                                                 
			  	                                                                                                                     
			   
		}
		UpdateMythicElements( activeCollectionEvent )
	}

	if ( !menuIsUsable )
	{
		foreach ( var rewardButton in file.allRewardButtons )
			Hud_SetEnabled( rewardButton, false )

		foreach( var but in file.mythicIndicatorButtons )
			Hud_SetVisible( but, false )

		HudElem_SetRuiArg( file.completionRewardBox, "activeMythicTier", 0 )
	}

	var focus = GetFocus()
	if ( !file.allRewardButtons.contains( GetFocus() ) && focus != file.completionRewardBox )
		focus = null
	UpdateFocusStuff( focus )

	Hud_SetVisible( file.purchaseSinglePackButton, !GRX_IsOfferRestricted() )
	Hud_SetLocked( file.purchaseSinglePackButton, currentMaxEventPackPurchaseCount < 1 )
	HudElem_SetRuiArg( file.purchaseSinglePackButton, "numPacks", 1 )
	int packBulkPurchaseCount = (currentMaxEventPackPurchaseCount < 2 ? PACK_BULK_PURCHASE_COUNT : ClampInt( currentMaxEventPackPurchaseCount, 2, PACK_BULK_PURCHASE_COUNT ))
	Hud_SetVisible( file.purchaseMultiplePacksButton, !GRX_IsOfferRestricted() )
	Hud_SetLocked( file.purchaseMultiplePacksButton, currentMaxEventPackPurchaseCount < packBulkPurchaseCount )
	HudElem_SetRuiArg( file.purchaseMultiplePacksButton, "numPacks", packBulkPurchaseCount )
	file.WORKAROUND_purchaseMultiplePacksButton_currentQty = packBulkPurchaseCount

	if ( isInventoryReady && GRX_IsOfferRestricted() )
		Hud_SetY( file.aboutButton, ContentScaledY( -480 ) )

	                                                       
	                    
	   
	  	                                                       
	  	                                
	  	 
	  		                                                                                                                           
	  		                                                     
	  		 
	  			                                             
	  			                                                                   
	  		 
	  		    
	  		 
	  			                                                                                                                                                              
	  		 
	  	 
	  	                                                                                                    
	   
	                                                                                         
}


void function UpdateMythicElements( ItemFlavor activeCollectionEvent )
{
	bool awardMythic = HeirloomEvent_IsRewardMythicSkin( activeCollectionEvent )

	HudElem_SetRuiArg( file.completionRewardBox, "isMythicActive", awardMythic )

	if ( !awardMythic )
		return

	HudElem_SetRuiArg( file.completionRewardBox, "activeMythicTier", file.activeMythicTier + 1 )

	ItemFlavor charFlav = expect ItemFlavor( GetItemFlavorAssociatedCharacterOrWeapon( HeirloomEvent_GetPrimaryCompletionRewardItem( activeCollectionEvent ) ) )

	for( int i = 0; i < file.mythicIndicatorButtons.len(); i++ )
	{
		var button = file.mythicIndicatorButtons[i]

		Hud_SetVisible( button, true )

		ItemFlavor mythicSkin = expect ItemFlavor( Mythics_GetSkinTierForCharacter( charFlav, i ) )
		HudElem_SetRuiArg( button, "skinIcon", ItemFlavor_GetIcon( mythicSkin ), eRuiArgType.IMAGE )

		bool isOwned = false

		if ( ItemFlavor_GetGRXMode( mythicSkin ) == eItemFlavorGRXMode.REGULAR )
			isOwned = GRX_IsItemOwnedByPlayer( mythicSkin )
		else
			isOwned = false

		HudElem_SetRuiArg( button, "isOwned", isOwned )
	}
}

void function UpdateFocusStuff( var focusedRewardButtonOrNull )
{
	ItemFlavor ornull activeCollectionEvent = file.activeCollectionEvent
	if ( activeCollectionEvent == null )
		return
	expect ItemFlavor(activeCollectionEvent)

	                                                                                 
	                                                                                                                     
	if ( focusedRewardButtonOrNull == null && HeirloomEvent_IsRewardMythicSkin( activeCollectionEvent ) && file.WORKAROUND_currentlyFocusedRewardButtonForFooters == file.completionRewardBox )
	{
		focusedRewardButtonOrNull = file.WORKAROUND_currentlyFocusedRewardButtonForFooters
	}
	else
	{
		file.WORKAROUND_currentlyFocusedRewardButtonForFooters = focusedRewardButtonOrNull
	}

	bool isCompletionReward = false

	ItemFlavor focusFlav
	if ( focusedRewardButtonOrNull == null || !GRX_IsInventoryReady() )
	{
		if ( !GRX_IsOfferRestricted() )
		{
			focusFlav = CollectionEvent_GetMainPackFlav( activeCollectionEvent )
		}
		else
		{
			focusFlav = HeirloomEvent_GetPrimaryCompletionRewardItem( activeCollectionEvent )
			isCompletionReward = true
		}
	}
	else if ( focusedRewardButtonOrNull in file.rewardButtonToRewardFlavMap )
	{
		focusFlav = file.rewardButtonToRewardFlavMap[focusedRewardButtonOrNull]
	}
	else if ( focusedRewardButtonOrNull == file.completionRewardBox )
	{
		focusFlav = HeirloomEvent_GetPrimaryCompletionRewardItem( activeCollectionEvent )
		isCompletionReward = true
	}
	else if ( focusedRewardButtonOrNull == file.purchaseSinglePackButton || focusedRewardButtonOrNull == file.purchaseMultiplePacksButton )
	{
		if ( !GRX_IsOfferRestricted() )
		{
			focusFlav = CollectionEvent_GetMainPackFlav( activeCollectionEvent )
		}
	}
	else
	{
		return
	}

	vector rarityCol
	string rarityText
	string nameText
	string descText
	bool showUnlockWithPack = false
	int premiumPrice        = -1
	int craftingPrice       = -1
	bool hasBonus           = false
	string bonusString      = ""

	bool isPack = (ItemFlavor_GetType( focusFlav ) == eItemType.account_pack)
	Hud_SetVisible( file.openPackButton, isPack )
	bool isMythicSkin = false

	if ( isPack )
	{
		nameText = ItemFlavor_GetShortName( focusFlav )
		rarityCol = SrgbToLinear( CollectionEvent_GetMainThemeCol( activeCollectionEvent ) )
		rarityText = "#PACK"
		descText = "#COLLECTION_EVENT_PACK_DESCRIPTION"

		ItemFlavor completionRewardPack = HeirloomEvent_GetCompletionRewardPack( activeCollectionEvent )
		UpdateLootBoxButton( file.openPackButton, [ focusFlav, completionRewardPack ] )
	}
	else if ( isCompletionReward )
	{
		isMythicSkin = Mythics_IsItemFlavorMythicSkin( focusFlav )
		rarityCol = SrgbToLinear( GetKeyColor( COLORID_TEXT_LOOT_TIER0, ItemFlavor_GetQuality( focusFlav ) + 1 ) / 255.0 )

		if ( HeirloomEvent_AwardHeirloomShards( activeCollectionEvent ) )
		{
			nameText = Localize( "#N_HEIRLOOM_SHARDS", 150 )
			rarityText = ItemFlavor_GetQualityName( focusFlav )
		}
		else if( isMythicSkin )
		{
			focusFlav = expect ItemFlavor( Mythics_GetItemTierForSkin( focusFlav, file.activeMythicTier ) )
			nameText = Localize( "#TIER", file.activeMythicTier + 1 )
			descText = GetLocalizedItemFlavorDescriptionForOfferButton( focusFlav, false )
			descText += " - "
			descText += Localize( GRX_IsInventoryReady() ? ( GRX_IsItemOwnedByPlayer( focusFlav ) ? "#OWNED" : "#LOCKED" ) : "" )
			rarityText = "#MYTHIC_SKIN"
		}
		else
		{
			nameText = ItemFlavor_GetLongName( focusFlav )
			descText = GetLocalizedItemFlavorDescriptionForOfferButton( focusFlav, false )
			descText += " - "
			descText += Localize( GRX_IsInventoryReady() ? ( GRX_IsItemOwnedByPlayer( focusFlav ) ? "#OWNED" : "#LOCKED" ) : "" )
			rarityText = ItemFlavor_GetQualityName( focusFlav )
		}
	}
	else                   
	{
		file.focusedButtonIsntMythic = true
		nameText = ItemFlavor_GetLongName( focusFlav )
		rarityCol = SrgbToLinear( GetKeyColor( COLORID_TEXT_LOOT_TIER0, ItemFlavor_GetQuality( focusFlav ) + 1 ) / 255.0 )
		rarityText = ItemFlavor_GetQualityName( focusFlav )
		descText = GetLocalizedItemFlavorDescriptionForOfferButton( focusFlav, false )
		descText += " - "
		descText += Localize( GRX_IsInventoryReady() ? (GRX_IsItemOwnedByPlayer( focusFlav ) ? "#OWNED" : "#LOCKED") : "" )

		if ( !GRX_IsItemOwnedByPlayer( focusFlav ) )
		{
			if ( GRX_AreOffersReady() && GRX_IsInventoryReady() )
			{
				string offerLocation         = CollectionEvent_GetFrontPageGRXOfferLocation( activeCollectionEvent )
				array<GRXScriptOffer> offers = GRX_GetItemDedicatedStoreOffers( focusFlav, offerLocation )
				if ( offers.len() > 0 )
				{
					Assert( offers.len() == 1 )
					GRXScriptOffer offer = offers[0]
					Assert( offer.prices.len() == 2 )
					foreach ( ItemFlavorBag price in offer.prices )
					{
						Assert( price.flavors.len() == 1, "No price given for ItemFlavor bag in GRX offer." )
						if ( price.flavors[0] == GRX_CURRENCIES[GRX_CURRENCY_PREMIUM] )
						{
							Assert( premiumPrice == -1, "Inherited existing (NOT -1) Premium Currency price for ItemFlavor bag in GRX offer." )
							premiumPrice = price.quantities[0]
						}
						else if ( price.flavors[0] == GRX_CURRENCIES[GRX_CURRENCY_CRAFTING] )
						{
							Assert( craftingPrice == -1, "Inherited existing (NOT -1) Crafting Materials price for ItemFlavor bag in GRX offer." )
							craftingPrice = price.quantities[0]
						}
						else
						{
							Assert( false, "Invalid currency - something that is *NOT* AC or CM - price for ItemFlavor bag in GRX offer." )
						}
					}
				}
			}

			if ( CollectionEvent_GetPackOffer( activeCollectionEvent ) != null )
				showUnlockWithPack = true
		}
	}

	if ( GRX_IsInventoryReady() && GRX_IsOfferRestricted()
			&& focusFlav == HeirloomEvent_GetPrimaryCompletionRewardItem( activeCollectionEvent )
			&& GRX_GetPackCount( ItemFlavor_GetGRXIndex( HeirloomEvent_GetCompletionRewardPack( activeCollectionEvent ) ) ) > 0 )
	{
		Hud_SetVisible( file.openPackButton, true )
		ItemFlavor completionRewardPack = HeirloomEvent_GetCompletionRewardPack( activeCollectionEvent )
		UpdateLootBoxButton( file.openPackButton, [ completionRewardPack ] )
		isPack = true
	}

	var rui = Hud_GetRui( file.itemDetailsBox )
	RuiSetColorAlpha( rui, "rarityCol", rarityCol, 1.0 )
	RuiSetString( rui, "itemRarityText", rarityText )
	RuiSetString( rui, "itemNameText", nameText )
	RuiSetString( rui, "itemDescText", descText )
	RuiSetBool( rui, "isPack", isPack )
	RuiSetBool( rui, "showUnlockWithPack", showUnlockWithPack )
	RuiSetInt( rui, "premiumPrice", premiumPrice )
	RuiSetInt( rui, "craftingPrice", craftingPrice )
	RuiSetString( rui, "packName", CollectionEvent_GetMainPackShortPluralName( activeCollectionEvent ) )
	RuiSetImage( rui, "packImage", CollectionEvent_GetMainPackImage( activeCollectionEvent ) )

	bool shouldPlayAudioPreview = true

	UpdateMythicUI( isMythicSkin )

	bool isNxHH = false
#if NX_PROG || PC_PROG_NX_UI
	isNxHH = IsNxHandheldMode()
#endif

	RunClientScript( "UIToClient_ItemPresentation", ItemFlavor_GetGUID( focusFlav ), -1, 1.19, false, null, shouldPlayAudioPreview, "collection_event_ref", isNxHH )
	UpdateFooterOptions()                             
}


void function RewardButton_OnGetFocus( var btn )
{
	file.focusedButtonIsntMythic = true
	UpdateFocusStuff( btn )
}


void function RewardButton_OnLoseFocus( var btn )
{
	UpdateFocusStuff( null )
}


void function RewardButton_OnActivate( var btn )
{
	if ( !Hud_IsEnabled( btn ) )
		return

	ItemFlavor rewardFlav = file.rewardButtonToRewardFlavMap[btn]
	if ( !IsItemFlavorInspectable( rewardFlav ) )
		return

	if ( !GRX_AreOffersReady() )
		return

	ItemFlavor activeCollectionEvent = expect ItemFlavor( file.activeCollectionEvent )
	string offerLocation             = CollectionEvent_GetFrontPageGRXOfferLocation( activeCollectionEvent )
	array<GRXScriptOffer> offers     = GRX_GetItemDedicatedStoreOffers( rewardFlav, offerLocation )

	if ( offers.len() > 0 )
	{
		if ( Mythics_IsItemFlavorMythicSkin( rewardFlav ) )
			StoreMythicInspectMenu_AttemptOpenWithOffer( offers[0] )
		else
			StoreInspectMenu_AttemptOpenWithOffer( offers[0] )
	}
}


void function RewardButton_OnAltActivate( var btn )
{
	if ( !Hud_IsEnabled( btn ) )
		return

	ItemFlavor rewardFlav = file.rewardButtonToRewardFlavMap[btn]
	if ( !IsItemFlavorEquippable( rewardFlav ) )
		return

	EmitUISound( "UI_Menu_Equip_Generic" )
	EquipItemFlavorInAppropriateLoadoutSlot( rewardFlav )
}


bool function CheckInspectableBuyable( ItemFlavor flav, bool wantBuyable )
{
	if ( !IsItemFlavorInspectable( flav ) )
		return false

	if ( file.activeCollectionEvent == null )
		return false

	if ( !GRX_IsInventoryReady() || !GRX_AreOffersReady() )
		return !wantBuyable

	if ( GRX_IsItemOwnedByPlayer( flav ) )
		return !wantBuyable

	ItemFlavor activeCollectionEvent = expect ItemFlavor(file.activeCollectionEvent)
	string offerLocation             = CollectionEvent_GetFrontPageGRXOfferLocation( activeCollectionEvent )
	array<GRXScriptOffer> offers     = GRX_GetItemDedicatedStoreOffers( flav, offerLocation )
	if ( offers.len() == 0 )
		return !wantBuyable

	return wantBuyable
}


bool function IsFocusedItemInspectableButNotBuyable()
{
	var focus = file.WORKAROUND_currentlyFocusedRewardButtonForFooters                                                                            
	if ( !(focus in file.rewardButtonToRewardFlavMap) )
		return false
	ItemFlavor focusFlav = file.rewardButtonToRewardFlavMap[focus]

	return CheckInspectableBuyable( focusFlav, false )
}


bool function IsFocusedItemInspectableAndBuyable()
{
	var focus = file.WORKAROUND_currentlyFocusedRewardButtonForFooters                                                                            
	if ( !(focus in file.rewardButtonToRewardFlavMap) )
		return false
	ItemFlavor focusFlav = file.rewardButtonToRewardFlavMap[focus]

	return CheckInspectableBuyable( focusFlav, true )
}


bool function IsFocusedItemEquippable()
{
	var focus = file.WORKAROUND_currentlyFocusedRewardButtonForFooters                                                                            
	if ( !(focus in file.rewardButtonToRewardFlavMap) )
		return false
	ItemFlavor focusFlav = file.rewardButtonToRewardFlavMap[focus]

	if ( !IsItemFlavorEquippable( focusFlav ) )
		return false

	return true
}


void function PurchasePackButton_OnClick( var btn, int count )
{
	if ( Hud_IsLocked( btn ) )
	{
		EmitUISound( "menu_deny" )
		return
	}

	                                                                                                   
	ItemFlavor activeCollectionEvent = expect ItemFlavor(file.activeCollectionEvent)
	ItemFlavor packFlav              = CollectionEvent_GetMainPackFlav( activeCollectionEvent )

	PurchaseDialogConfig pdc
	pdc.flav = packFlav
	pdc.quantity = count
	pdc.markAsNew = false
	PurchaseDialog( pdc )
}


                                                            
   
  	                       
   
  
  
                                                             
   
  	                        
   


void function CompletionRewardBox_OnGetFocus( var btn )
{
	file.focusedButtonIsntMythic = false
	UpdateFocusStuff( btn )
}


void function CompletionRewardBox_OnLoseFocus( var btn )
{
	UpdateFocusStuff( null )
}


void function CompletionRewardBox_OnClick( var btn )
{
	ItemFlavor activeCollectionEvent = expect ItemFlavor(file.activeCollectionEvent)
	if ( HeirloomEvent_AwardHeirloomShards( activeCollectionEvent ) )
	{
		JumpToHeirloomShop()                                              
		return
	}

	                                                                                                             
	ItemFlavor completionRewardPack = HeirloomEvent_GetCompletionRewardPack( activeCollectionEvent )
	array<ItemFlavor> packContents = GRXPack_GetPackContents( completionRewardPack )

	                                                                                            
	GRXScriptOffer fakeOffer
	fakeOffer.titleText = ItemFlavor_GetLongName( completionRewardPack )
	fakeOffer.descText = ""
	fakeOffer.prereq = activeCollectionEvent

	ItemFlavorBag priceBag
	priceBag.flavors.append( GRX_CURRENCIES[GRX_CURRENCY_HEIRLOOM] )
	priceBag.quantities.append( 999999999 )
	fakeOffer.prices.append( priceBag )

	foreach ( item in packContents )
		AddItemToFakeOffer( fakeOffer, item )

	if ( HeirloomEvent_IsRewardMythicSkin( activeCollectionEvent ) )
		StoreMythicInspectMenu_AttemptOpenWithOffer( fakeOffer )
	else
		StoreInspectMenu_AttemptOpenWithOffer( fakeOffer )
}


                                                         
   
  	                          
  	 
  		                          
  		      
  	 
  
  	                                                                                                               
  	                                                                                
  	                                                                                                       
  	                                                                                                                      
  		                    
  		 
  			                                                    
  				              
  				 
  					                                
  					                              
  					 
  						           
  					 
  					                                                            
  					 
  						           
  					 
  					                                                     
  					 
  						                                                          
  						     
  					 
  					    
  					 
  						              
  					 
  				 
  			    
  		 
  	   
   

void function TryOpenLootCeremonyAndCompletionRewardPack()
{
	WaitFrame()

	bool grxReady = GRX_IsInventoryReady() && GRX_AreOffersReady()
	if ( !grxReady )
		return

	if ( file.activeCollectionEvent == null )
		return

	ItemFlavor activeCollectionEvent = expect ItemFlavor(file.activeCollectionEvent)
	ItemFlavor completionRewardPack  = HeirloomEvent_GetCompletionRewardPack( activeCollectionEvent )
	if ( GRX_GetPackCount( ItemFlavor_GetGRXIndex( completionRewardPack ) ) > 0 )
		OnLobbyOpenLootBoxMenu_ButtonPress( completionRewardPack )
}

void function OpenPackButton_OnClick( var btn )
{
	if ( Hud_IsLocked( btn ) )
		return

	ItemFlavor activeCollectionEvent = expect ItemFlavor(file.activeCollectionEvent)
	ItemFlavor packFlav              = CollectionEvent_GetMainPackFlav( activeCollectionEvent )
	if ( GRX_GetPackCount( ItemFlavor_GetGRXIndex( packFlav ) ) > 0 )
		OnLobbyOpenLootBoxMenu_ButtonPress( packFlav )

	ItemFlavor completionRewardPack = HeirloomEvent_GetCompletionRewardPack( activeCollectionEvent )
	if ( GRX_GetPackCount( ItemFlavor_GetGRXIndex( completionRewardPack ) ) > 0 )
		OnLobbyOpenLootBoxMenu_ButtonPress( completionRewardPack )
}


void function MythicInidicatorButton_OnGetFocus( var button )
{
	file.focusedButtonIsntMythic = true
	file.activeMythicTier = int( Hud_GetScriptID( button ) )
	UpdateMythicUI( true )
	UpdateFocusStuff( file.completionRewardBox )
}

void function MythicInidicatorButton_OnLoseFocus( var button )
{
	UpdateFocusStuff( null )
	file.focusedButtonIsntMythic = false
	thread MythicInspect_AutoAdvance()
}

void function MythicInspect_AutoAdvance()
{
	if ( !IsLobby() )
		return

	if( file.autoRunning )
		return

	file.autoRunning = true

	while( !file.focusedButtonIsntMythic )
	{
		wait 3.0

		if( file.focusedButtonIsntMythic )
		{
			break
		}

		if ( !IsConnected() )
			return

		if ( !IsLobby() )
			return

		if( file.activeMythicTier < MYTHIC_INIDICATOR_COUNT - 1 )
			file.activeMythicTier++
		else
			file.activeMythicTier = 0

		UpdateMythicUI( true )
		UpdateFocusStuff( file.completionRewardBox )
	}
	file.autoRunning = false
}

void function UpdateMythicUI( bool isMythicActive )
{
	if ( file.activeCollectionEvent != null )
		HudElem_SetRuiArg( file.completionRewardBox, "itemImage", HeirloomEvent_GetMythicButtonImage( expect ItemFlavor( file.activeCollectionEvent ), file.activeMythicTier ) )
	HudElem_SetRuiArg( file.completionRewardBox, "activeMythicTier", file.activeMythicTier + 1 )
	HudElem_SetRuiArg( file.itemDetailsBox, "isMythic", isMythicActive )
	HudElem_SetRuiArg( file.itemDetailsBox, "mythicDescText", "#S12ACE_MYTHIC_COLLECTION_UNLOCK" )

	for( int index; index < file.mythicIndicatorButtons.len(); index++ )
	{
		var button = file.mythicIndicatorButtons[index]
		if( !IsValid( button ) )
			continue

		Hud_SetVisible( button, isMythicActive )

		if( !isMythicActive )
			continue
		var rui = Hud_GetRui( button )

		RuiSetInt( rui, "activeTier", file.activeMythicTier + 1 )
	}

	if( isMythicActive )
	{
		thread MythicInspect_AutoAdvance()
	}
}


