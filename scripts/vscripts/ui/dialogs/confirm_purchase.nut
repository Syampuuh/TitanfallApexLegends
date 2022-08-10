global function InitConfirmPurchaseDialog
global function InitConfirmPackBundlePurchaseDialog

global function PurchaseDialog

global enum ePurchaseDialogStatus
{
	INACTIVE = 0,
	AWAITING_USER_CONFIRMATION = 1,
	WORKING = 2,
	FINISHED_SUCCESS = 3,
	FINISHED_FAILURE = 4,
}

const int MAX_PURCHASE_BUTTONS = 5

struct PurchaseDialogState
{
	PurchaseDialogConfig&                   cfg
	array<GRXScriptOffer>                   purchaseOfferList
	table<var, GRXScriptOffer>              purchaseButtonOfferMap
	table<var, ItemFlavorBag>               purchaseButtonPriceMap
	string                                  purchaseSoundOverride = ""
}

struct
{
	var activeDialog
	var genericPurchaseDialog
	var packBundlePurchaseDialog
	var contentRui
	var buttonsPanel
	var processingButton

	var dialogFrame
	var dialogContent

	var        cancelButton
	array<var> purchaseButtonBottomToTopList

	int                  status = ePurchaseDialogStatus.INACTIVE
	PurchaseDialogState& state
} file

void function InitConfirmPurchaseDialog( var newMenuArg )
                                              
{
	var menu = GetMenu( "ConfirmPurchaseDialog" )
	file.genericPurchaseDialog = menu
	                                                                         
	                                                                  
	                                                           

	var cancelButton = Hud_GetChild( menu, "CancelButton" )
	HudElem_SetRuiArg( cancelButton, "buttonText", "#B_BUTTON_CANCEL" )
	Hud_AddEventHandler( cancelButton, UIE_CLICK, CancelButton_Activate )

	for ( int purchaseButtonIdx = 0; purchaseButtonIdx < MAX_PURCHASE_BUTTONS; purchaseButtonIdx++ )
	{
		var button = Hud_GetChild( menu, "PurchaseButton" + purchaseButtonIdx )
		Hud_AddEventHandler( button, UIE_CLICK, PurchaseButton_Activate )
	}
	                                        

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, ConfirmPurchaseDialog_OnOpen )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, ConfirmPurchaseDialog_OnClose )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, ConfirmPurchaseDialog_OnNavigateBack )

	                                                                                                       
	                                                                                  

	RegisterSignal( "ConfirmPurchaseClosed" )
}

void function InitConfirmPackBundlePurchaseDialog( var newMenuArg )
{
	var menu = GetMenu( "ConfirmPackBundlePurchaseDialog" )
	file.packBundlePurchaseDialog = menu

	var cancelButton = Hud_GetChild( menu, "CancelButton" )
	HudElem_SetRuiArg( cancelButton, "buttonText", "#B_BUTTON_CANCEL" )
	Hud_AddEventHandler( cancelButton, UIE_CLICK, CancelButton_Activate )

	for ( int purchaseButtonIdx = 0; purchaseButtonIdx < MAX_PURCHASE_BUTTONS; purchaseButtonIdx++ )
	{
		var button = Hud_GetChild( menu, "PurchaseButton" + purchaseButtonIdx )
		Hud_AddEventHandler( button, UIE_CLICK, PurchaseButton_Activate )
	}

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, ConfirmPurchaseDialog_OnOpen )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, ConfirmPurchaseDialog_OnClose )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, ConfirmPurchaseDialog_OnNavigateBack )

	RegisterSignal( "ConfirmPurchaseClosed" )
}

void function UpdateDialogElementReferences( bool hasEventPack, bool hasThematicPack, bool hasEventThematicPack, string disclaimerSpecifics )
{
	file.cancelButton = Hud_GetChild( file.activeDialog, "CancelButton" )

	file.purchaseButtonBottomToTopList.clear()
	for ( int purchaseButtonIdx = 0; purchaseButtonIdx < MAX_PURCHASE_BUTTONS; purchaseButtonIdx++ )
	{
		var button = Hud_GetChild( file.activeDialog, "PurchaseButton" + purchaseButtonIdx )
		file.purchaseButtonBottomToTopList.append( button )
	}

	if ( hasEventPack )
	{
		file.dialogContent = Hud_GetChild( file.activeDialog, "EventDialogContent" )
		Hud_SetVisible( Hud_GetChild( file.activeDialog, "DialogContent" ), false )
		Hud_SetVisible( Hud_GetChild( file.activeDialog, "ThematicDialogContent" ), false )
		Hud_SetVisible( Hud_GetChild( file.activeDialog, "EventThematicDialogContent" ), false )
	}
	else if ( hasThematicPack )
	{
		file.dialogContent = Hud_GetChild( file.activeDialog, "ThematicDialogContent" )
		Hud_SetVisible( Hud_GetChild( file.activeDialog, "DialogContent" ), false )
		Hud_SetVisible( Hud_GetChild( file.activeDialog, "EventDialogContent" ), false )
		Hud_SetVisible( Hud_GetChild( file.activeDialog, "EventThematicDialogContent" ), false )
	}
	else if ( hasEventThematicPack )
	{
		file.dialogContent = Hud_GetChild( file.activeDialog, "EventThematicDialogContent" )
		HudElem_SetRuiArg( file.dialogContent, "eventName", disclaimerSpecifics )
		Hud_SetVisible( Hud_GetChild( file.activeDialog, "DialogContent" ), false )
		Hud_SetVisible( Hud_GetChild( file.activeDialog, "EventDialogContent" ), false )
		Hud_SetVisible( Hud_GetChild( file.activeDialog, "ThematicDialogContent" ), false )
	}
	else
	{
		file.dialogContent = Hud_GetChild( file.activeDialog, "DialogContent" )

		if( file.activeDialog == file.packBundlePurchaseDialog )
		{
			Hud_SetVisible( Hud_GetChild( file.activeDialog, "EventDialogContent" ), false )
			Hud_SetVisible( Hud_GetChild( file.activeDialog, "ThematicDialogContent" ), false )
			Hud_SetVisible( Hud_GetChild( file.activeDialog, "EventThematicDialogContent" ), false )
		}
	}

	Hud_SetVisible( file.dialogContent, true )
	InitButtonRCP( file.dialogContent )

	SetDialog( file.activeDialog, true )
	SetClearBlur( file.activeDialog, false )

	file.dialogFrame = Hud_GetChild( file.activeDialog, "DialogFrame" )
	InitButtonRCP( file.dialogFrame )
}


void function PurchaseDialog( PurchaseDialogConfig cfg )
{
	Assert( GRX_IsInventoryReady() )
	Assert( file.status == ePurchaseDialogStatus.INACTIVE )

	PurchaseDialogState state
	file.state = state
	file.status = ePurchaseDialogStatus.AWAITING_USER_CONFIRMATION
	file.state.cfg = cfg
	file.activeDialog = file.genericPurchaseDialog

	bool hasEventPack = false
	bool hasThematicPack = false
	bool hasEventThematicPack = false
	string specialPackName = ""

	if ( cfg.flav != null )
	{
		ItemFlavor flav = expect ItemFlavor(cfg.flav)
		printt( "PurchaseDialog", ItemFlavor_GetHumanReadableRef( flav ) )

		Assert( ItemFlavor_GetGRXMode( flav ) != GRX_ITEMFLAVORMODE_NONE )

		if ( ItemFlavor_IsItemDisabledForGRX( flav ) )
		{
			EmitUISound( "menu_deny" )
			return
		}

		if ( ItemFlavor_GetGRXMode( flav ) == GRX_ITEMFLAVORMODE_REGULAR && GRX_IsItemOwnedByPlayer( flav ) )
		{
			Assert( false, "Called PurchaseDialog with an already-owned item: " + ItemFlavor_GetHumanReadableRef( flav ) )
			EmitUISound( "menu_deny" )
			return
		}

		uiGlobal.menuData[ file.activeDialog ].pin_metaData[ "item_name" ] <- ItemFlavor_GetHumanReadableRef( flav )

		ItemFlavorPurchasabilityInfo ifpi = GRX_GetItemPurchasabilityInfo( flav )
		Assert( ifpi.isPurchasableAtAll )

		if ( ifpi.craftingOfferOrNull != null )
			file.state.purchaseOfferList.append( GRX_ScriptOfferFromCraftingOffer( expect GRXScriptCraftingOffer(ifpi.craftingOfferOrNull) ) )

		foreach ( string location, array<GRXScriptOffer> locationOfferList in ifpi.locationToDedicatedStoreOffersMap )
			foreach ( GRXScriptOffer locationOffer in locationOfferList )
				if ( locationOffer.offerType != GRX_OFFERTYPE_BUNDLE && locationOffer.output.flavors.len() == 1 )
					file.state.purchaseOfferList.append( locationOffer )
	}
	else if ( cfg.offer != null )
	{
		GRXScriptOffer offer = expect GRXScriptOffer(cfg.offer)
		printt( "PurchaseDialog", DEV_GRX_DescribeOffer( offer ) )
		if ( GRXOffer_IsFullyClaimed( offer ) )
		{
			Assert( false, "Called PurchaseDialog with an already-fully-claimed offer: " + DEV_GRX_DescribeOffer( offer ) )
			EmitUISound( "menu_deny" )
			return
		}

		uiGlobal.menuData[ file.activeDialog ].pin_metaData[ "item_name" ] <- offer.offerAlias
		SetCachedOfferAlias( offer.offerAlias )

		if( GRXOffer_ContainsPack( offer ) )
		{
			file.activeDialog = file.packBundlePurchaseDialog
			hasEventPack = GRXOffer_ContainsEventPack( offer )
			hasThematicPack = GRXOffer_ContainsThematicPack( offer )
			hasEventThematicPack = GRXOffer_ContainsEventThematicPack( offer )
			specialPackName = Localize( GRXOffer_GetSpecialPackName( offer ) )
		}

		file.state.purchaseOfferList.append( offer )
	}
	else
	{
		Assert( false, "Called PurchaseDialog with no flav or offer" )
		return
	}

	UpdateDialogElementReferences( hasEventPack, hasThematicPack, hasEventThematicPack, specialPackName )

	EmitUISound( "UI_Menu_Cosmetic_Unlock" )
	AdvanceMenu( file.activeDialog )
}


void function GotoPremiumStoreTab()
{
	Assert( IsLobby() )

	if ( GetActiveMenu() == GetMenu( "ConfirmPurchaseDialog" ) || GetActiveMenu() == GetMenu( "ConfirmPackBundlePurchaseDialog" ) )
		CloseActiveMenu()

	OpenVCPopUp( null )
}


void function PurchaseButton_Activate( var button )
{
	Assert( file.status == ePurchaseDialogStatus.AWAITING_USER_CONFIRMATION )

	if ( Hud_IsLocked( button ) )
		return

	if( !( button in file.state.purchaseButtonOfferMap ) && file.state.cfg.deepLinkConfig != null )
	{
		PurchaseDialogDeepLinkConfig pdlc = expect PurchaseDialogDeepLinkConfig( file.state.cfg.deepLinkConfig )

		if( pdlc.onPurchaseCallback != null )
			pdlc.onPurchaseCallback()
		return
	}

	GRXScriptOffer offer = file.state.purchaseButtonOfferMap[button]
	ItemFlavorBag price  = file.state.purchaseButtonPriceMap[button]

	bool isPremiumOnly = GRX_IsPremiumPrice( price )
	int quantity       = file.state.cfg.quantity
	bool canAfford     = GRX_CanAfford( price, quantity )
	if ( isPremiumOnly && !canAfford )
	{
		GotoPremiumStoreTab()
		return
	}

	Assert( canAfford )

	file.status = ePurchaseDialogStatus.WORKING


	int queryGoal
	if ( offer.isCraftingOffer )
	{
		queryGoal = GRX_HTTPQUERYGOAL_CRAFT_ITEM
	}
	else if( offer.offerType == GRX_OFFERTYPE_BUNDLE )
	{
		queryGoal = GRX_HTTPQUERYGOAL_PURCHASE_BUNDLE_OFFER
	}
	else
	{
		queryGoal = GRX_HTTPQUERYGOAL_PURCHASE_STORE_OFFER

		if ( file.state.cfg.flav != null )
		{
			int itemType = ItemFlavor_GetType( expect ItemFlavor(file.state.cfg.flav) )
			if ( itemType == eItemType.character )
				queryGoal = GRX_HTTPQUERYGOAL_PURCHASE_CHARACTER
			else if ( itemType == eItemType.account_pack )
				queryGoal = GRX_HTTPQUERYGOAL_PURCHASE_PACK
		}
	}

	ScriptGRXOperationInfo operation
	operation.expectedQueryGoal = queryGoal
	operation.doOperationFunc = (void function( int opId ) : (queryGoal, offer, price, quantity) {
		GRX_PurchaseOffer( opId, queryGoal, offer, price, quantity )
	})
	operation.onDoneCallback = (void function( int status ) : ( offer, price )
	{
		OnPurchaseOperationFinished( status, offer, price )
	})

	if ( file.state.cfg.onPurchaseStartCallback != null )
	{
		file.state.cfg.onPurchaseStartCallback()
		file.state.cfg.onPurchaseStartCallback = null
	}

	QueueGRXOperation( GetLocalClientPlayer(), operation )

	UpdateProcessingElements()
	HudElem_SetRuiArg( button, "isProcessing", true )
}


void function CancelButton_Activate( var button )
{
	UICodeCallback_NavigateBack()
}


void function UpdateProcessingElements()
{
	bool isWorking = (file.status == ePurchaseDialogStatus.WORKING)

	                               
	                                   
	Hud_SetEnabled( file.cancelButton, !isWorking )
	HudElem_SetRuiArg( file.cancelButton, "isProcessing", isWorking )
	HudElem_SetRuiArg( file.cancelButton, "processingState", file.status )

	foreach ( button in file.purchaseButtonBottomToTopList )
	{
		Hud_SetEnabled( button, !isWorking )
		HudElem_SetRuiArg( button, "isProcessing", false )
	}
}


void function OnPurchaseOperationFinished( int status, GRXScriptOffer offer, ItemFlavorBag price )
{
	Assert( file.status == ePurchaseDialogStatus.WORKING )

	bool wasSuccessful = (status == eScriptGRXOperationStatus.DONE_SUCCESS)

	file.status = (wasSuccessful ? ePurchaseDialogStatus.FINISHED_SUCCESS : ePurchaseDialogStatus.FINISHED_FAILURE)

	if ( wasSuccessful )
	{
		                                                                        
		foreach ( item in offer.items )
		{
			ItemFlavor itemFlav = GetItemFlavorByGRXIndex( item.itemIdx )
			if ( Mythics_IsItemFlavorMythicSkin( itemFlav ) )
			{
				Remote_ServerCallFunction( "ClientCallback_UpdateMythicChallenges" )
				break
			}
		}
		
		Remote_ServerCallFunction( "ClientCallback_lastSeenPremiumCurrency" )

		string purchaseSound
		if ( file.state.cfg.purchaseSoundOverride != null )
		{
			purchaseSound = expect string(file.state.cfg.purchaseSoundOverride)
		}
		else
		{
			int lowestCurrencyIndex = GRX_CURRENCY_COUNT
			foreach ( int costIndex, ItemFlavor costFlav in price.flavors )
			{
				                                                                                         
				                                                             
				if ( GRXCurrency_GetCurrencyIndex( costFlav ) < lowestCurrencyIndex )
					lowestCurrencyIndex = GRXCurrency_GetCurrencyIndex( costFlav )
			}

			if ( lowestCurrencyIndex != GRX_CURRENCY_COUNT )
				purchaseSound = GRXCurrency_GetPurchaseSound( GRX_CURRENCIES[lowestCurrencyIndex] )
		}
		if ( purchaseSound != "" )
			EmitUISound( purchaseSound )
	}
	else
	{
		EmitUISound( "menu_deny" )
	}

	if ( file.state.cfg.markAsNew )
	{
		foreach ( ItemFlavor outputFlav in offer.output.flavors )
			Newness_TEMP_MarkItemAsNewAndInformServer( outputFlav )
	}

	if ( file.state.cfg.onPurchaseResultCallback != null )
	{
		file.state.cfg.onPurchaseResultCallback( wasSuccessful )
		file.state.cfg.onPurchaseResultCallback = null
	}

	thread ReportStatusAndClose( file.status )
}


void function ReportStatusAndClose( int processingState )
{
	EndSignal( uiGlobal.signalDummy, "CleanupInGameMenus" )
	EndSignal( uiGlobal.signalDummy, "ConfirmPurchaseClosed" )

	HudElem_SetRuiArg( file.cancelButton, "processingState", processingState )

	wait 1.6

	if ( GetActiveMenu() == file.activeDialog )
		thread CloseActiveMenu()
}


void function ConfirmPurchaseDialog_OnOpen()
{
	Assert( file.status == ePurchaseDialogStatus.AWAITING_USER_CONFIRMATION )

	AddCallbackAndCallNow_OnGRXInventoryStateChanged( UpdatePurchaseDialog )
}


void function UpdatePurchaseDialog()
{
	if ( file.status != ePurchaseDialogStatus.AWAITING_USER_CONFIRMATION )
		return

	int quality        = eRarityTier.COMMON
	string messageText = "#PURCHASE"
	string prereqText = ""
	string devDesc

	if ( file.state.cfg.messageOverride != null )
	{
		messageText = expect string(file.state.cfg.messageOverride)
	}
	else if ( file.state.cfg.flav != null )
	{
		ItemFlavor flav = expect ItemFlavor(file.state.cfg.flav)
		devDesc = ItemFlavor_GetHumanReadableRef( flav )

		string flavName = Localize( ItemFlavor_GetLongName( flav ) )
		quality = ItemFlavor_HasQuality( flav ) ? ItemFlavor_GetQuality( flav ) : 0

		switch ( ItemFlavor_GetType( flav ) )
		{
			case eItemType.gladiator_card_intro_quip:
			case eItemType.gladiator_card_kill_quip:
				messageText = Localize( "#QUOTE_STRING", flavName )
				break

			case eItemType.character:
				messageText = flavName
				break

			case eItemType.voucher:
			case eItemType.battlepass_purchased_xp:
				if ( file.state.cfg.quantity > 1 )
					messageText = Localize( "#STORE_ITEM_X_N", flavName, file.state.cfg.quantity )
				else
					messageText = flavName
				break

			default:
				if ( file.state.cfg.quantity > 1 )
					messageText = Localize( "#STORE_ITEM_X_N", flavName, file.state.cfg.quantity ) + "\n`1" + Localize( ItemFlavor_GetQualityName( flav ) )
				else
					messageText = flavName + "\n`1" + Localize( ItemFlavor_GetQualityName( flav ) )
				break
		}
	}
	else if ( file.state.cfg.offer != null )
	{
		GRXScriptOffer offer = expect GRXScriptOffer(file.state.cfg.offer)
		devDesc = DEV_GRX_DescribeOffer( offer )

		messageText = offer.titleText
		prereqText = offer.prereqText

		quality = eRarityTier.COMMON
		foreach ( ItemFlavor outputFlav in offer.output.flavors )
			quality = maxint( quality, ItemFlavor_GetQuality( outputFlav, 0 ) )
	}

	printt( "UpdatePurchaseDialog", devDesc )

	HudElem_SetRuiArg( file.dialogContent, "quality", quality )
	HudElem_SetRuiArg( file.dialogContent, "quantity", file.state.cfg.quantity )
	HudElem_SetRuiArg( file.dialogContent, "headerText", "#CONFIRM_PURCHASE_HEADER" )
	HudElem_SetRuiArg( file.dialogContent, "messageText", messageText )
	HudElem_SetRuiArg( file.dialogContent, "reqsText", prereqText )

	UpdateProcessingElements()

	int purchaseButtonIdx = 0
	file.state.purchaseButtonOfferMap.clear()
	file.state.purchaseButtonPriceMap.clear()

	array<GRXScriptOffer> offerList = clone file.state.purchaseOfferList
	offerList.reverse()                                                                      
	foreach ( GRXScriptOffer offer in offerList )
	{
		array<ItemFlavorBag> priceList = clone offer.prices
		priceList.sort( int function( ItemFlavorBag a, ItemFlavorBag b ) {
			if ( GRXCurrency_GetCurrencyIndex( a.flavors[0] ) > GRXCurrency_GetCurrencyIndex( b.flavors[0] ) )
				return 1

			if ( GRXCurrency_GetCurrencyIndex( a.flavors[0] ) < GRXCurrency_GetCurrencyIndex( b.flavors[0] ) )
				return -1

			return 0
		} )
		                                   
		foreach ( ItemFlavorBag price in priceList )
		{
			Assert( purchaseButtonIdx < file.purchaseButtonBottomToTopList.len(), format( "Item %s had more than %d prices, failed to show purchase dialog", devDesc, file.purchaseButtonBottomToTopList.len() ) )
			if ( purchaseButtonIdx >= file.purchaseButtonBottomToTopList.len() )
				break

			var button = file.purchaseButtonBottomToTopList[purchaseButtonIdx]

			file.state.purchaseButtonOfferMap[button] <- offer
			file.state.purchaseButtonPriceMap[button] <- price

			Hud_Show( button )
			HudElem_SetRuiArg( button, "buttonText", offer.isCraftingOffer ? "#CONFIRM_CRAFT_WITH" : "#CONFIRM_PURCHASE_WITH" )
			HudElem_SetRuiArg( button, "priceText", GRX_GetFormattedPrice( price, file.state.cfg.quantity ) )
			HudElem_SetRuiArg( button, "isProcessing", false )

			bool isLoadingPrice = false
			if ( GRX_IsInventoryReady() )
			{
				bool isPremiumOnly = GRX_IsPremiumPrice( price )
				bool canAfford     = GRX_CanAfford( price, file.state.cfg.quantity )

				isLoadingPrice = false
				Hud_SetEnabled( button, true )
				Hud_SetLocked( button, offer.isAvailable && !canAfford && !isPremiumOnly )

				Hud_ClearToolTipData( button )
				if ( !offer.isAvailable )
				{
					HudElem_SetRuiArg( button, "buttonText", "#UNAVAILABLE" )                           
				}
				#if ( !NX_PROG )
				else if ( isPremiumOnly && !canAfford )
				{
					HudElem_SetRuiArg( button, "buttonText", "#CONFIRM_GET_PREMIUM" )
				}
				#endif
				else if ( !canAfford )
				{
					ToolTipData toolTipData
					toolTipData.titleText = "#CANNOT_AFFORD"
					toolTipData.tooltipFlags = toolTipData.tooltipFlags | eToolTipFlag.SOLID

					string currencyName
					array<int> priceArray = GRX_GetCurrencyArrayFromBag( price )
					foreach ( currencyIndex, priceInt in priceArray )
					{
						if ( priceInt == 0 )
							continue

						ItemFlavor currency = GRX_CURRENCIES[currencyIndex]
						currencyName = ItemFlavor_GetShortName( currency )
						break
					}

					toolTipData.descText = Localize( "#CANNOT_AFFORD_DESC", GRX_CanAffordDelta( price, file.state.cfg.quantity ), Localize( currencyName ) )
					Hud_SetToolTipData( button, toolTipData )
				}
			}
			else
			{
				isLoadingPrice = true
				Hud_SetEnabled( button, false )
			}
			HudElem_SetRuiArg( button, "isLoadingPrice", isLoadingPrice )

			purchaseButtonIdx++
		}
	}

	if( file.state.cfg.deepLinkConfig != null )
	{
		Assert( purchaseButtonIdx < file.purchaseButtonBottomToTopList.len(), format( "Item %s had more than %d prices, failed to show purchase dialog", devDesc, file.purchaseButtonBottomToTopList.len() ) )
		if ( purchaseButtonIdx < file.purchaseButtonBottomToTopList.len() )
		{
			PurchaseDialogDeepLinkConfig pdlc = expect PurchaseDialogDeepLinkConfig( file.state.cfg.deepLinkConfig )
			var button = file.purchaseButtonBottomToTopList[purchaseButtonIdx]

			Hud_Show( button )
			HudElem_SetRuiArg( button, "buttonText", pdlc.message )
			HudElem_SetRuiArg( button, "priceText", pdlc.priceText )
			HudElem_SetRuiArg( button, "isProcessing", false )

			bool isLoadingPrice = false
			Hud_SetEnabled( button, true )
			Hud_SetLocked( button, false )
			purchaseButtonIdx++
		}
	}

	int usedPurchaseButtonCount = purchaseButtonIdx

	for ( int unusedPurchaseButtonIdx = purchaseButtonIdx; unusedPurchaseButtonIdx < file.purchaseButtonBottomToTopList.len(); unusedPurchaseButtonIdx++ )
		Hud_Hide( file.purchaseButtonBottomToTopList[unusedPurchaseButtonIdx] )

	int buttonHeight  = Hud_GetHeight( file.purchaseButtonBottomToTopList[0] )
	int buttonPadding = Hud_GetY( file.purchaseButtonBottomToTopList[0] )

	Hud_SetHeight( file.dialogFrame, Hud_GetBaseHeight( file.dialogFrame ) + ( usedPurchaseButtonCount + 1 ) * ( buttonHeight + buttonPadding ) )

	if( file.activeDialog == file.packBundlePurchaseDialog )
		return

	if( file.state.cfg.purchaseOptionsMessage != null && usedPurchaseButtonCount > 0 )
	{
		HudElem_SetRuiArg( file.dialogContent, "optionsMessageText", expect string( file.state.cfg.purchaseOptionsMessage ) )
		HudElem_SetRuiArg( file.dialogContent, "optionsCount", usedPurchaseButtonCount + 1 )
	}
	else
	{
		HudElem_SetRuiArg( file.dialogContent, "optionsMessageText", "" )
	}
}


void function ConfirmPurchaseDialog_OnClose()
{
	RemoveCallback_OnGRXInventoryStateChanged( UpdatePurchaseDialog )

	file.status = ePurchaseDialogStatus.INACTIVE
	PurchaseDialogState state
	file.state = state

	UpdateProcessingElements()

	Signal( uiGlobal.signalDummy, "ConfirmPurchaseClosed" )
}


void function ConfirmPurchaseDialog_OnNavigateBack()
{
	if ( file.status == ePurchaseDialogStatus.INACTIVE || file.status == ePurchaseDialogStatus.WORKING )
		return

	CloseActiveMenu()
}


