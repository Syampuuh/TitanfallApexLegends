global function ThemedShopPanel_Init
global function StorePanelThemedShopEvent_LevelInit
global function StorePanelThemedShopEvent_LevelShutdown
global function JumpToThemeShopOffer

struct {
	var        panel
	array<var> offerButtons
	var        itemGroup1Rui
	var        itemGroup2Rui

	ItemFlavor ornull          activeThemedShopEvent
	table<var, GRXScriptOffer> offerButtonToOfferMap
	var                        WORKAROUND_currentlyFocusedOfferButtonForFooters
} file

int NUM_OFFER_BUTTONS = 7

void function ThemedShopPanel_Init( var panel )
{
	file.panel = panel

	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, ThemedShopPanel_OnShow )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, ThemedShopPanel_OnHide )

	file.itemGroup1Rui = Hud_GetRui( Hud_GetChild( panel, "ItemGroup1" ) )
	file.itemGroup2Rui = Hud_GetRui( Hud_GetChild( panel, "ItemGroup2" ) )

	for ( int offerButtonIdx = 0; offerButtonIdx < NUM_OFFER_BUTTONS; offerButtonIdx++ )
	{
		var button = Hud_GetChild( file.panel, format( "OfferButton%d", offerButtonIdx + 1 ) )
		Hud_Show( button )
		Hud_AddEventHandler( button, UIE_GET_FOCUS, OfferButton_OnGetFocus )
		Hud_AddEventHandler( button, UIE_LOSE_FOCUS, OfferButton_OnLoseFocus )
		Hud_AddEventHandler( button, UIE_CLICK, OfferButton_OnActivate )
		Hud_AddEventHandler( button, UIE_CLICKRIGHT, OfferButton_OnAltActivate )
		file.offerButtons.append( button )
	}

	AddPanelFooterOption( panel, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
	AddPanelFooterOption( panel, LEFT, BUTTON_A, false, "#A_BUTTON_INSPECT", "#A_BUTTON_INSPECT", null, IsFocusedOfferInspectable )
	AddPanelFooterOption( panel, LEFT, BUTTON_X, false, "#X_BUTTON_EQUIP", "#X_BUTTON_EQUIP", null, IsFocusedOfferEquippable )
}

void function StorePanelThemedShopEvent_LevelInit()
{
}

void function StorePanelThemedShopEvent_LevelShutdown()
{
	file.WORKAROUND_currentlyFocusedOfferButtonForFooters = null
	file.offerButtonToOfferMap.clear()
}

void function ThemedShopPanel_OnShow( var panel )
{
	UI_SetPresentationType( ePresentationType.WEAPON_CATEGORY )

	file.offerButtonToOfferMap.clear()

	AddCallbackAndCallNow_OnGRXInventoryStateChanged( ThemedShopPanel_UpdateGRXDependantElements )
	AddCallbackAndCallNow_OnGRXOffersRefreshed( ThemedShopPanel_UpdateGRXDependantElements )
	AddCallback_OnGRXBundlesRefreshed( ThemedShopPanel_UpdateBundleOffers )

	if( GRX_HasUpToDateBundleOffers() )
		ThemedShopPanel_UpdateBundleOffers()
}


void function ThemedShopPanel_OnHide( var panel )
{
	file.activeThemedShopEvent = null

	RunClientScript( "UIToClient_StopBattlePassScene" )

	RemoveCallback_OnGRXInventoryStateChanged( ThemedShopPanel_UpdateGRXDependantElements )
	RemoveCallback_OnGRXOffersRefreshed( ThemedShopPanel_UpdateGRXDependantElements )
	RemoveCallback_OnGRXBundlesRefreshed( ThemedShopPanel_UpdateBundleOffers )
}


void function ThemedShopPanel_UpdateGRXDependantElements()
{
	bool isInventoryReady                   = GRX_IsInventoryReady()
	ItemFlavor ornull activeThemedShopEvent = GetActiveThemedShopEvent( GetUnixTimestamp() )
	bool haveActiveThemedShopEvent          = (activeThemedShopEvent != null)
	bool menuIsUsable                       = isInventoryReady && haveActiveThemedShopEvent

	file.activeThemedShopEvent = activeThemedShopEvent
	file.offerButtonToOfferMap.clear()

	if ( menuIsUsable )
	{
		expect ItemFlavor( activeThemedShopEvent )

		RuiSetImage( file.itemGroup1Rui, "headerImage", ThemedShopEvent_GetItemGroupHeaderImage( activeThemedShopEvent, 1 ) )
		RuiSetString( file.itemGroup1Rui, "headerText", Localize( ThemedShopEvent_GetItemGroupHeaderText( activeThemedShopEvent, 1 ) ) )
		RuiSetColorAlpha( file.itemGroup1Rui, "headerTextColor", SrgbToLinear( ThemedShopEvent_GetItemGroupHeaderTextColor( activeThemedShopEvent, 1 ) ), 1.0 )
		RuiSetString( file.itemGroup1Rui, "bgImage", ThemedShopEvent_GetItemGroupBackgroundImage( activeThemedShopEvent, 1 ) )

		RuiSetImage( file.itemGroup2Rui, "headerImage", ThemedShopEvent_GetItemGroupHeaderImage( activeThemedShopEvent, 2 ) )
		RuiSetString( file.itemGroup2Rui, "headerText", Localize( ThemedShopEvent_GetItemGroupHeaderText( activeThemedShopEvent, 2 ) ) )
		RuiSetColorAlpha( file.itemGroup2Rui, "headerTextColor", SrgbToLinear( ThemedShopEvent_GetItemGroupHeaderTextColor( activeThemedShopEvent, 2 ) ), 1.0 )
		RuiSetString( file.itemGroup2Rui, "bgImage", ThemedShopEvent_GetItemGroupBackgroundImage( activeThemedShopEvent, 2 ) )

		string offerGRXLocation      = ThemedShopEvent_GetGRXOfferLocation( activeThemedShopEvent )
		array<GRXScriptOffer> offers = GRX_GetLocationOffers( offerGRXLocation )

		                                                           
		             
		                                                                         
		                                                                                         
		   
		  	                   
		  	                                
		  	                                                                                                                          
		  	                                                                                                   
		  	                      
		   
		                                           

		offers.sort( int function( GRXScriptOffer a, GRXScriptOffer b ) {
			int aSlot = ("slot" in a.attributes ? int(a.attributes["slot"]) : 99999)
			int bSlot = ("slot" in b.attributes ? int(b.attributes["slot"]) : 99999)
			if ( aSlot != bSlot )
				return aSlot - bSlot

			if ( a.expireTime != b.expireTime )
				return a.expireTime - b.expireTime

			Assert( a.output.flavors.len() > 0 && b.output.flavors.len() > 0 )
			return ItemFlavor_GetGUID( a.output.flavors[0] ) - ItemFlavor_GetGUID( b.output.flavors[0] )
		} )

		                                               
		                                                               
		GRXScriptOffer lastOffer
		foreach ( index, offer in clone offers )
		{
			if ( index == 0 )
				continue

			int thisSlot = ("slot" in offer.attributes ? int(offer.attributes["slot"]) : 99999)
			int lastSlot = ("slot" in lastOffer.attributes ? int(lastOffer.attributes["slot"]) : 99999)

			if ( thisSlot == lastSlot )
			{
				if ( offer.expireTime > lastOffer.expireTime )
					offers.removebyvalue( lastOffer )
				else
					offers.removebyvalue( offer )
			}

			lastOffer = offer
		}

		if ( offers.len() != file.offerButtons.len() )
		{
			string details = ""
			foreach ( GRXScriptOffer offer in offers )
				foreach ( ItemFlavor flav in offer.output.flavors )
					details += format( "\n - %s", ItemFlavor_GetHumanReadableRef( flav ) )
			Warning( "Themed shop expected %d offers with location '%s' but received %d: %s", file.offerButtons.len(), offerGRXLocation, offers.len(), details )
		}

		foreach ( int offerButtonIdx, var offerButton in file.offerButtons )
		{
			if ( offerButtonIdx >= offers.len() )
			{
				Hud_Hide( offerButton )
				continue
			}

			GRXScriptOffer offerData = offers[offerButtonIdx]

			file.offerButtonToOfferMap[offerButton] <- offerData
			bool shouldHighlight = (offerButtonIdx < 4)

			int dlType
			if(offerButtonIdx == 0 || offerButtonIdx == 1)            
				dlType = ePakType.DL_STORE_EVENT_WIDE_MEDIUM
			else if(offerButtonIdx == 2 || offerButtonIdx == 3)
				dlType = ePakType.DL_STORE_EVENT_WIDE_SHORT
			else if(offerButtonIdx == 4)
				dlType = ePakType.DL_STORE_EVENT_TALL
			else
				dlType = ePakType.DL_STORE_EVENT_SHORT

			Hud_Show( offerButton )
			OfferButton_SetDisplay( offerButton, offerData, activeThemedShopEvent, shouldHighlight, dlType )
		}
	}
	else
	{
		foreach ( var offerButton in file.offerButtons )
			Hud_SetEnabled( offerButton, false )
	}

	var focus = GetFocus()
	if ( !file.offerButtons.contains( GetFocus() ) )
		focus = null
	UpdateFocusStuff( focus )
}

void function ThemedShopPanel_UpdateBundleOffers()
{
	foreach ( int offerButtonIdx, var offerButton in file.offerButtons )
	{
		if( offerButton in file.offerButtonToOfferMap )
		{
			GRXScriptOffer offer = file.offerButtonToOfferMap[offerButton]

			if ( GRX_CheckBundleAndUpdateOfferPrices( offer ) )
				OfferButton_SetPrice( offerButton, offer )
		}
	}
}

void function OfferButton_SetPrice( var button, GRXScriptOffer offer )
{
	var rui = Hud_GetRui( button )
	int remainingTime = offer.expireTime - GetUnixTimestamp()
	bool isOfferFullyClaimed = GRXOffer_IsFullyClaimed( offer )
	GRX_PackCollectionInfo packCollectionInfo = GRXOffer_GetEventThematicPackCollectionInfoFromScriptOffer( offer )

	string originalPriceText = ""
	if ( offer.originalPrice != null && !isOfferFullyClaimed )
	{
		PriceDisplayData originalPriceData = GRX_GetPriceDisplayData( expect ItemFlavorBag(offer.originalPrice) )
		originalPriceText = originalPriceData.amount
	}
	RuiSetString( rui, "originalPriceString", originalPriceText )

	PriceDisplayData priceData = GRX_GetPriceDisplayData( offer.prices[0] )
	RuiSetBool( rui, "isAvailable", offer.isAvailable )
	RuiSetBool( rui, "isOwned", isOfferFullyClaimed )
	RuiSetImage( rui, "priceSymbol", priceData.symbol )
	RuiSetString( rui, "priceAmount", priceData.amount )
	RuiSetInt( rui, "numCollected", packCollectionInfo.numCollected )
	RuiSetInt( rui, "numTotalInCollection", packCollectionInfo.numTotalInCollection )
	RuiSetGameTime( rui, "expireTime", remainingTime > 0 ? (ClientTime() + remainingTime) : RUI_BADGAMETIME )
}

void function OfferButton_SetDisplay( var button, GRXScriptOffer offerData, ItemFlavor activeThemedShopEvent, bool shouldHighlight, int dlType )
{
	Assert( offerData.output.flavors.len() > 0 )
	ItemFlavor firstItemFlav = offerData.output.flavors[0]

	var rui = Hud_GetRui( button )
	RuiSetImage( rui, "gradientBGImage", ThemedShopEvent_GetItemButtonBGImage( activeThemedShopEvent, shouldHighlight ) )

	asset itemImage
	if ( GetConVarBool( "assetdownloads_enabled" ) )
	{

		itemImage = GetDownloadedImageAsset( offerData.imageRef, offerData.imageRef, dlType, button )
	}
	else
		itemImage = ItemFlavor_GetIcon( firstItemFlav )
	RuiSetImage( rui, "imageAsset", itemImage )

	if ( offerData.output.flavors.len() > 1 )
		RuiSetString( rui, "itemName", Localize( offerData.titleText ) )
	else
		RuiSetString( rui, "itemName", ItemFlavor_GetLongName( firstItemFlav ) )

	OfferButton_SetPrice( button, offerData )

	int highestItemQuality = 0
	asset sourceIconImage = $""
	asset featuresIconImage = $""
	foreach( ItemFlavor flav in offerData.output.flavors )
	{
		sourceIconImage = ItemFlavor_GetSourceIcon( flav )

		if( ItemFlavor_HasQuality( flav ) )
			highestItemQuality = maxint( highestItemQuality, ItemFlavor_GetQuality( flav ) )

		if( ItemFlavor_HasFeatures( flav ) )
			featuresIconImage = $"rui/events/themed_shop_events/bonus_features_icon"
	}
	RuiSetInt( rui, "itemRarity", highestItemQuality )
	RuiSetImage( rui, "sourceIcon", sourceIconImage )
	RuiSetImage( rui, "featureIcon", featuresIconImage )

	if ( featuresIconImage != $"" )
	{
		ToolTipData ttd
		ttd.descText = "#FEATURES_TOOLTIP"
		Hud_SetToolTipData( button, ttd )
	}
	else
	{
		Hud_ClearToolTipData( button )
	}
}


void function OfferButton_OnGetFocus( var btn )
{
	UpdateFocusStuff( btn )
}


void function OfferButton_OnLoseFocus( var btn )
{
	UpdateFocusStuff( null )
}


void function OfferButton_OnActivate( var btn )
{
	if ( !Hud_IsEnabled( btn ) )
		return

	GRXScriptOffer offer = file.offerButtonToOfferMap[btn]
	Assert( offer.output.flavors.len() > 0 )

	bool canAllItemsBePresented = true
	foreach( ItemFlavor flav in offer.output.flavors )
	{
		if( !StoreInspectMenu_IsItemPresentationSupported( flav ) )
		{
			canAllItemsBePresented = false
			break
		}
	}

	if ( canAllItemsBePresented )
	{
		StoreInspectMenu_SetStoreOfferData( [offer] )
		SetCurrentTabForPIN( "ThemedShopPanel" )                                     
		AdvanceMenu( GetMenu( "StoreInspectMenu" ) )
	}
	else
	{
		PurchaseDialogConfig pdc
		pdc.offer = offer
		pdc.quantity = 1
		PurchaseDialog( pdc )
	}
}


void function OfferButton_OnAltActivate( var btn )
{
	if ( !Hud_IsEnabled( btn ) )
		return

	GRXScriptOffer offer = file.offerButtonToOfferMap[btn]
	if ( !IsOfferEquippable( offer ) )
		return

	EmitUISound( "UI_Menu_Equip_Generic" )
	ItemFlavor offerFlav = ItemFlavorBag_GetSingleOutputItemFlavor_Assert( offer.output )
	EquipItemFlavorInAppropriateLoadoutSlot( offerFlav )
}


bool function IsFocusedOfferInspectable()
{
	var focus = file.WORKAROUND_currentlyFocusedOfferButtonForFooters                                                                            
	if ( focus in file.offerButtonToOfferMap )
	{
		GRXScriptOffer offer = file.offerButtonToOfferMap[focus]
		bool areAllOfferItemsInspectable = true
		foreach( ItemFlavor flav in offer.output.flavors )
		{
			if( !StoreInspectMenu_IsItemPresentationSupported( flav ) )
			{
				areAllOfferItemsInspectable = false
				break
			}
		}
		return areAllOfferItemsInspectable
	}

	return false
}


bool function IsFocusedOfferEquippable()
{
	var focus = file.WORKAROUND_currentlyFocusedOfferButtonForFooters                                                                            
	if ( focus in file.offerButtonToOfferMap )
	{
		GRXScriptOffer offer = file.offerButtonToOfferMap[focus]
		return IsOfferEquippable( offer )
	}

	return false
}


bool function IsOfferEquippable( GRXScriptOffer offer )
{
	if( offer.output.flavors.len() > 1 )
		return false

	ItemFlavor offerFlav = ItemFlavorBag_GetSingleOutputItemFlavor_Assert( offer.output )
	return IsItemFlavorEquippable( offerFlav )
}


void function UpdateFocusStuff( var focusedOfferButtonOrNull )
{
	file.WORKAROUND_currentlyFocusedOfferButtonForFooters = focusedOfferButtonOrNull

	UpdateFooterOptions()                             
}

void function JumpToThemeShopOffer( string storeOfferName )
{
	JumpToSeasonTab( "ThemedShopPanel" )
	
	ItemFlavor ornull themedShopEvent = file.activeThemedShopEvent
	if( themedShopEvent == null)
		return
	expect ItemFlavor( themedShopEvent )
	string offerGRXLocation = ThemedShopEvent_GetGRXOfferLocation( themedShopEvent )
	if( offerGRXLocation == "")
		return
	array<GRXScriptOffer> offers = GRX_GetLocationOffers( offerGRXLocation )

	foreach ( offer in offers)
	{
		if ( offer.offerAlias == storeOfferName )
		{
			StoreInspectMenu_AttemptOpenWithOffer( offer )
			return
		}
	}
}
