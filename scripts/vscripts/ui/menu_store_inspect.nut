global function InitStoreInspectMenu
global function StoreInspectMenu_SetStoreOfferData
global function StoreInspectMenu_IsItemPresentationSupported
global function StoreInspectMenu_AttemptOpenWithOffer
global function AddItemToFakeOffer
global function StoreInspectMenu_UpdatePrices
global function StoreInspectMenu_UpdatePurchaseButton
global function StoreInspectMenu_EquipOwnedItem

#if DEV
global function DEV_PrintInspectedOffer
global function DEV_DisplayAllInspectElements
global function DEV_AddFakeItemToOffer
global function DEV_AddFakeItemsToOffer
#endif

struct
{
	var menu
	var inspectPanel
	var mouseCaptureElem
	var purchaseLimit
	var pageHeader
	var itemGrid
	var itemInfo
} file

global struct StoreInspectUIData
{
	var discountInfo
	var purchaseButton
}

global struct StoreInspectOfferData
{
	string originalPriceStr
	string displayedPriceStr
	string purchaseText
	string purchaseDescText
	int discountPct
	int itemCount
	int originalPrice
	int displayedPrice
	int purchaseLimit
	bool isOwnedItemEquippable
	bool isPurchasable

	array<GRXScriptOffer> currentOffers
	array<ItemFlavor> itemFlavors
	array<string> exclusiveItems
}

StoreInspectOfferData s_inspectOffers
StoreInspectUIData s_inspectUIData

const int ITEM_GRID_ROWS = 4
const int ITEM_GRID_COLUMNS = 6

void function InitStoreInspectMenu( var newMenuArg )
{
	var menu = GetMenu( "StoreInspectMenu" )
	file.menu = menu

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, StoreInspectMenu_OnOpen )
	AddMenuEventHandler( menu, eUIEvent.MENU_SHOW, StoreInspectMenu_OnShow )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, StoreInspectMenu_OnClose )
	AddMenuEventHandler( menu, eUIEvent.MENU_HIDE, StoreInspectMenu_OnHide )

	file.inspectPanel = Hud_GetChild( menu, "InspectPanel" )
	file.mouseCaptureElem = Hud_GetChild( menu, "ModelRotateMouseCapture" )

	file.pageHeader = Hud_GetChild( file.inspectPanel, "InspectHeader" )
	file.itemGrid = Hud_GetChild( file.inspectPanel, "ItemGridPanel" )
	s_inspectUIData.discountInfo = Hud_GetChild( file.inspectPanel, "DiscountInfo" )
	file.itemInfo = Hud_GetChild( file.inspectPanel, "IndividualItemInfo" )
	file.purchaseLimit = Hud_GetChild( file.inspectPanel, "PurchaseLimit" )
	s_inspectUIData.purchaseButton = Hud_GetChild( file.inspectPanel, "PurchaseOfferButton" )

	AddButtonEventHandler( s_inspectUIData.purchaseButton, UIE_CLICK, PurchaseOfferButton_OnClick )
#if NX_PROG	
	AddMenuThinkFunc( menu, StoreInspectMenuOnThink )
#endif
	GridPanel_Init( file.itemGrid, ITEM_GRID_ROWS, ITEM_GRID_COLUMNS, OnBindItemGridButton, ItemGridButtonCountCallback, ItemGridButtonInitCallback )
	GridPanel_SetFillDirection( file.itemGrid, eGridPanelFillDirection.RIGHT )
	GridPanel_SetButtonHandler( file.itemGrid, UIE_CLICK, OnStoreGridItemClicked )
	GridPanel_SetButtonHandler( file.itemGrid, UIE_GET_FOCUS, OnStoreGridItemHover )

	Hud_AddEventHandler( Hud_GetChild( newMenuArg, "CoinsPopUpButton" ), UIE_CLICK, OpenVCPopUp )

	AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
}

#if NX_PROG
void function StoreInspectMenuOnThink(var menu)
{
	                                                                                                           
	                                                                                                                                        
	                                                                                                                     
	                                                                                   
	                                                                                  
	GridPanel_Refresh( file.itemGrid )
}
#endif

void function StoreInspectMenu_OnOpen()
{

}

void function StoreInspectMenu_OnShow()
{
	UI_SetPresentationType( ePresentationType.STORE_INSPECT )

	AddCallbackAndCallNow_OnGRXInventoryStateChanged( StoreInspectMenu_OnGRXUpdated )
	AddCallback_OnGRXOffersRefreshed( StoreInspectMenu_OnGRXUpdated )
	AddCallback_OnGRXBundlesRefreshed( StoreInspectMenu_OnGRXBundlesUpdated )

	StoreInspectMenu_OnUpdate()

	RegisterButtonPressedCallback( KEY_TAB, ToggleVCPopUp )
	RegisterButtonPressedCallback( BUTTON_BACK, ToggleVCPopUp )
}

void function StoreInspectMenu_OnClose()
{
	RemoveCallback_OnGRXInventoryStateChanged( StoreInspectMenu_OnGRXUpdated )
	RemoveCallback_OnGRXOffersRefreshed( StoreInspectMenu_OnGRXUpdated )
	RemoveCallback_OnGRXBundlesRefreshed( StoreInspectMenu_OnGRXBundlesUpdated )

	RunClientScript( "UIToClient_UnloadItemInspectPakFile" )
}

void function StoreInspectMenu_OnHide()
{
	DeregisterButtonPressedCallback( KEY_TAB, ToggleVCPopUp )
	DeregisterButtonPressedCallback( BUTTON_BACK, ToggleVCPopUp )
}

void function StoreInspectMenu_OnUpdate()
{
	if ( !IsFullyConnected() )
		return

	GridPanel_Refresh( file.itemGrid )
}

void function StoreInspectMenu_UpdatePrices( StoreInspectOfferData offerData ,GRXScriptOffer storeOffer, bool isBundlesRefresh, StoreInspectUIData uiData )
{
	if( isBundlesRefresh && storeOffer.offerType != GRX_OFFERTYPE_BUNDLE )
		return

	bool isMarketplaceBundle = storeOffer.offerType == GRX_OFFERTYPE_BUNDLE
	bool hasMultipleItems = storeOffer.output.flavors.len() > 1
	bool isHeirloomPack = GRXOffer_IsHeirloomPack( storeOffer )
	bool isBundle = isMarketplaceBundle || (hasMultipleItems && !isHeirloomPack)

	bool isBundlePriceMissing = false
	string ineligibleReason = ""
	int purchaseCount = 0

	if ( isMarketplaceBundle )
	{
		if( !isBundlesRefresh && !GRX_HasUpToDateBundleOffers() )
		{
			printt( "StoreInspectMenu: Client never received bundle offers but we're trying to display a bundle." )
			isBundlePriceMissing = true
		}
		else
		{
			                                                                                                             
			GRX_CheckBundleAndUpdateOfferPrices( storeOffer )

			GRXBundleOffer bundle = GRX_GetUserBundleOffer( storeOffer.offerAlias )
			purchaseCount = bundle.purchaseCount
		}
	}

	offerData.displayedPrice = storeOffer.prices[0].quantities[0]

	                                                                                                                 
	if ( storeOffer.prices.len() == 2 )
	{
		string firstPrice = GRX_GetFormattedPrice( storeOffer.prices[0], 1 )
		string secondPrice = GRX_GetFormattedPrice( storeOffer.prices[1], 1 )
		offerData.displayedPriceStr = Localize( "#STORE_PRICE_N_N", firstPrice, secondPrice )

	}
	else
	{
		offerData.displayedPriceStr = GRX_GetFormattedPrice( storeOffer.prices[0], 1 )
	}


	offerData.discountPct = 0

	ItemFlavorBag originalPriceFlavBag
	if ( storeOffer.originalPrice != null )
		originalPriceFlavBag = expect ItemFlavorBag( storeOffer.originalPrice )

	if( originalPriceFlavBag.quantities.len() > 0 )
	{
		offerData.originalPrice = originalPriceFlavBag.quantities[0]
		offerData.originalPriceStr = GRX_GetFormattedPrice( originalPriceFlavBag, 1 )
		float discount = 100 - ( offerData.displayedPrice / (offerData.originalPrice * 1.0) * 100 )
		offerData.discountPct = int( floor( discount ) )                                                      
	}

	string bundleRestrictionsStr = GRXOffer_GetBundleOfferRestrictions( storeOffer )
	bool hasBundleRestrictions = bundleRestrictionsStr != ""

	bool isOfferFullyClaimed = GRXOffer_IsFullyClaimed( storeOffer )
	bool isPurchaseLimitReached = offerData.purchaseLimit > 0 && purchaseCount >= offerData.purchaseLimit

	int numOfferItemsOwned = GRXOffer_GetOwnedItemsCount( storeOffer )
	HudElem_SetRuiArg( uiData.discountInfo, "ownedItemsDesc", numOfferItemsOwned > 0 ? Localize( "#BUNDLE_OWNED_ITEMS_DESC", numOfferItemsOwned ) : "" )

	offerData.isPurchasable = !isOfferFullyClaimed && !hasBundleRestrictions && !isPurchaseLimitReached && storeOffer.isAvailable
	offerData.purchaseText = isBundle ? Localize( "#PURCHASE_BUNDLE" ) : Localize( "#PURCHASE" )
	offerData.purchaseDescText = Localize( offerData.displayedPriceStr )

	if ( !storeOffer.isAvailable )
	{
		                                                                           
		offerData.purchaseText = Localize( "#UNAVAILABLE" )
		offerData.purchaseDescText = ""
	}
	else if ( isMarketplaceBundle && isBundlePriceMissing )
	{
		offerData.purchaseText = Localize( "#UNAVAILABLE" )
		offerData.purchaseDescText = Localize( "#BUNDLE_UNABLE_TO_RETREIVE_DATA" )
	}
	else if ( isBundle && hasBundleRestrictions )
	{
		offerData.purchaseText = Localize( "#LOCKED" )
		offerData.purchaseDescText = Localize( bundleRestrictionsStr )
	}
	else if ( isBundle && isOfferFullyClaimed )
	{
		offerData.purchaseText = Localize( "#OWNED" )
		offerData.purchaseDescText = Localize( "#BUNDLE_OWNED_DESC" )
	}
	else if ( isPurchaseLimitReached )
	{
		offerData.purchaseText = Localize( "#UNAVAILABLE" )
		offerData.purchaseDescText = Localize( "#PURCHASE_LIMIT_REACHED" )
	}
	else if ( isOfferFullyClaimed )
	{
		offerData.purchaseText = Localize( "#OWNED" )
		offerData.purchaseDescText = hasBundleRestrictions ? bundleRestrictionsStr : ""
	}
	                                                                                                                                       
	                                                                                                                               
}

void function StoreInspectMenu_UpdatePurchaseButton( GRXScriptOffer storeOffer, StoreInspectOfferData offerData, StoreInspectUIData uiData )
{
	bool isExtraInfoVisible = false
	bool isOfferFullyClaimed = GRXOffer_IsFullyClaimed( storeOffer )

	if ( storeOffer.prereq != null )
	{
		isExtraInfoVisible = false
		ItemFlavor prereqFlav = expect ItemFlavor( storeOffer.prereq )

		int eventType = ItemFlavor_GetType( prereqFlav )

		if ( eventType == eItemType.calevent_collection || eventType == eItemType.calevent_themedshop )
		{
			offerData.isPurchasable = false
			if( !isOfferFullyClaimed && HeirloomEvent_IsRewardMythicSkin( prereqFlav ) )
				offerData.purchaseText = Localize( GRX_IsItemOwnedByPlayer( storeOffer.output.flavors[0] ) ? "#OWNED" : "#LOCKED" )
			else
				offerData.purchaseText = Localize( isOfferFullyClaimed ? "#OWNED" : "#LOCKED" )

			string eventName = Localize( eventType == eItemType.calevent_themedshop ?  ThemedShopEvent_GetItemGroupHeaderText( prereqFlav, 1 ) : CollectionEvent_GetCollectionName( prereqFlav ) )
			offerData.purchaseDescText = Localize( ( isOfferFullyClaimed ? "#STORE_REQUIRES_OWNED" : "#STORE_REQUIRES_LOCKED" ), eventName )

		}
		else if ( !GRX_IsItemOwnedByPlayer( prereqFlav ) )
		{
			offerData.isPurchasable = false
			offerData.purchaseText = Localize( "#LOCKED" )
			offerData.purchaseDescText = Localize( "#STORE_REQUIRES_LOCKED", Localize( ItemFlavor_GetLongName( prereqFlav ) ) )
		}
	}
	else
	{
		HudElem_SetRuiArg( uiData.discountInfo, "discountPct", Localize( "#N_PERCENT", offerData.discountPct ) )
		HudElem_SetRuiArg( uiData.discountInfo, "originalPrice", Localize( offerData.originalPriceStr ) )
		isExtraInfoVisible = offerData.isPurchasable && offerData.discountPct > 0.0
	}

	Hud_SetVisible( uiData.discountInfo, isExtraInfoVisible )

	HudElem_SetRuiArg( uiData.purchaseButton, "buttonText", offerData.purchaseText )
	HudElem_SetRuiArg( uiData.purchaseButton, "buttonDescText", offerData.purchaseDescText )

	if( offerData.itemCount == 1 && isOfferFullyClaimed )
	{
		StoreInspectMenu_UpdateButtonForEquips( offerData, uiData )
		Hud_SetLocked( uiData.purchaseButton, !offerData.isOwnedItemEquippable )
		HudElem_SetRuiArg( uiData.purchaseButton, "isDisabled", !offerData.isOwnedItemEquippable )
	}
	else
	{
		s_inspectOffers.isOwnedItemEquippable = false
		Hud_SetLocked( uiData.purchaseButton, !offerData.isPurchasable )
		HudElem_SetRuiArg( uiData.purchaseButton, "isDisabled", !offerData.isPurchasable )
	}

                                                                 
         
  	                          
  	 
  		                                                                                    
  		                                                                                    
  	 
  	                                                                  
  	 
  		                                                                                    
  		                                                                              
  	 
        
}

void function StoreInspectMenu_UpdateButtonForEquips( StoreInspectOfferData offerData, StoreInspectUIData uiData )
{
	ItemFlavor itemFlav = offerData.itemFlavors[0]
	int itemType = ItemFlavor_GetType( itemFlav )
	var rui = Hud_GetRui( uiData.purchaseButton )

	if ( itemType == eItemType.weapon_charm || itemType == eItemType.account_pack || itemType == eItemType.emote_icon || itemType == eItemType.skydive_emote  )
	{
		                                                           
		                                             
		                                                                                                 
		offerData.isOwnedItemEquippable = false
	}
	else if ( IsItemEquipped( itemFlav ) )
	{
		int rarity = ItemFlavor_HasQuality( itemFlav ) ? ItemFlavor_GetQuality( itemFlav ) : 0

		RuiSetString( rui, "buttonText", "#EQUIPPED_LOOT_REWARD" )
		RuiSetString( rui, "buttonDescText", Localize( "#CURRENTLY_EQUIPPED_ITEM", Localize( ItemFlavor_GetLongName( itemFlav ) ) ) )
		RuiSetInt( rui, "buttonDescRarity", rarity )
		offerData.isOwnedItemEquippable = false
	}
	else
	{
		                                                                                                                                                                                                  
		RuiSetString( rui, "buttonText", "#EQUIP_LOOT_REWARD" )
		RuiSetString( rui, "buttonDescText", Localize( "#CURRENTLY_EQUIPPED_ITEM", Localize( GetCurrentlyEquippedItemNameForItemTypeSlot( itemFlav ) ) ) )
		RuiSetInt( rui, "buttonDescRarity", GetCurrentlyEquippedItemRarityForItemTypeSlot( itemFlav ) )
		offerData.isOwnedItemEquippable = true
	}
}

void function StoreInspectMenu_OnGRXBundlesUpdated()
{
	if ( s_inspectOffers.currentOffers.len() == 0 )
		return

	if( !GRX_IsInventoryReady() )
		return

	StoreInspectMenu_UpdatePrices( s_inspectOffers, s_inspectOffers.currentOffers[0], true, s_inspectUIData )
	StoreInspectMenu_UpdatePurchaseButton( s_inspectOffers.currentOffers[0], s_inspectOffers, s_inspectUIData )
}

void function StoreInspectMenu_OnGRXUpdated()
{
	if( !GRX_IsInventoryReady() || !GRX_AreOffersReady() )
		return

	GRXScriptOffer storeOffer = s_inspectOffers.currentOffers[0]
	s_inspectOffers.itemFlavors.clear()

	                
	var currMenu = GetActiveMenu()
	uiGlobal.menuData[ currMenu ].pin_metaData[ "tab_name" ] <- Hud_GetHudName( file.inspectPanel )

	printt( "StoreInspectMenu_OnGRXUpdated offer is from store:", storeOffer.offerAlias )
	uiGlobal.menuData[ currMenu ].pin_metaData[ "item_name" ] <- storeOffer.offerAlias

	foreach( ItemFlavor flav in storeOffer.output.flavors )
		s_inspectOffers.itemFlavors.append( flav )

	s_inspectOffers.purchaseLimit = ( "purchaselimit" in storeOffer.attributes ? storeOffer.attributes["purchaselimit"].tointeger() : -1 )

	s_inspectOffers.exclusiveItems.clear()
	string exclusiveItemsAttr = ( "offerexclusives" in storeOffer.attributes ? storeOffer.attributes["offerexclusives"] : "" )
	s_inspectOffers.exclusiveItems = split( exclusiveItemsAttr, "," )

	StoreInspectMenu_UpdatePrices( s_inspectOffers, storeOffer, false, s_inspectUIData )
	StoreInspectMenu_UpdatePurchaseButton( storeOffer, s_inspectOffers, s_inspectUIData )

	HudElem_SetRuiArg( file.pageHeader, "offerName", storeOffer.titleText )
	HudElem_SetRuiArg( file.pageHeader, "isSingleItem", s_inspectOffers.itemCount == 1 )

	if( s_inspectOffers.itemCount == 1 )
	{
		ItemFlavor itemFlav = s_inspectOffers.itemFlavors[0]

		HudElem_SetRuiArg( file.pageHeader, "singleItemRarity", ItemFlavor_GetQuality( itemFlav ) )
		HudElem_SetRuiArg( file.pageHeader, "singleItemRarityText", ItemFlavor_GetQualityName( itemFlav ) )
		HudElem_SetRuiArg( file.pageHeader, "singleItemTypeText", ItemFlavor_GetRewardShortDescription( itemFlav ) )
	}
	else
	{
		HudElem_SetRuiArg( file.pageHeader, "offerDesc", storeOffer.descText )
	}

	                                               
	OnStoreGridItemHover( null, null, 0 )
	GridPanel_Refresh( file.itemGrid )

	bool hasPurchaseLimit = s_inspectOffers.purchaseLimit > 0
	HudElem_SetRuiArg( file.purchaseLimit, "limitText", Localize( "#STORE_LIMIT_N", s_inspectOffers.purchaseLimit ) )
	Hud_SetVisible( file.purchaseLimit, hasPurchaseLimit )
}

GRXStoreOfferItem function GetItemFromGridIndex( int index )
{
	GRXScriptOffer storeOffer = s_inspectOffers.currentOffers[0]
	return storeOffer.items[index]
}

void function OnBindItemGridButton( var panel, var button, int index )
{
	GRXStoreOfferItem item = GetItemFromGridIndex( index )

	ItemFlavor itemFlav
	itemFlav = GetItemFlavorByGRXIndex( item.itemIdx )
	asset itemThumbnail = CustomizeMenu_GetGenericRewardButtonImage( itemFlav )

	var rui = Hud_GetRui( button )
	if( ItemFlavor_GetGRXMode( itemFlav ) == eItemFlavorGRXMode.REGULAR )
		RuiSetBool( rui, "isOwned", GRX_IsItemOwnedByPlayer( itemFlav ) )
	else
		RuiSetBool( rui, "isOwned", false )

	RuiSetImage( rui, "itemThumbnail", itemThumbnail )
	RuiSetInt( rui, "rarity", ItemFlavor_GetQuality( itemFlav ) )
	RuiSetInt( rui, "itemQty", item.itemQuantity )

	string specialItemDesc = ""
	foreach( string itemName in s_inspectOffers.exclusiveItems )
		if( ItemFlavor_GetHumanReadableRef( itemFlav ) == itemName )
			specialItemDesc = "#BUNDLE_ITEM_DESC_EXCLUSIVE"

	if ( item.itemType == GRX_OFFERITEMTYPE_BONUS )
		specialItemDesc = "#BUNDLE_ITEM_DESC_BONUS"

	RuiSetString( rui, "specialItemDesc", Localize( specialItemDesc ) )

	if ( ItemFlavor_GetType( itemFlav ) == eItemType.loadscreen )
		RunClientScript( "UIToClient_LoadItemInspectPakFile", ItemFlavor_GetGUID( itemFlav ) )
}

int function ItemGridButtonCountCallback( var panel )
{
	return s_inspectOffers.itemCount
}

void function ItemGridButtonInitCallback( var button )
{
}

void function OnStoreGridItemClicked( var panel, var button, int index )
{
}

void function OnStoreGridItemHover( var panel, var button, int index )
{
	GRXStoreOfferItem item = GetItemFromGridIndex( index )
	ItemFlavor itemFlav

	itemFlav = GetItemFlavorByGRXIndex( item.itemIdx )

	bool isOwned = false
	if( ItemFlavor_GetGRXMode( itemFlav ) == GRX_ITEMFLAVORMODE_REGULAR )
		isOwned = GRX_IsItemOwnedByPlayer( itemFlav )

	int itemType = ItemFlavor_GetType( itemFlav )
	string rarityText = itemType == eItemType.character ? "" : ItemFlavor_GetQualityName( itemFlav )

	HudElem_SetRuiArg( file.itemInfo, "isOwned", isOwned )
	HudElem_SetRuiArg( file.itemInfo, "rarity", ItemFlavor_GetQuality( itemFlav ) )
	HudElem_SetRuiArg( file.itemInfo, "rarityText", rarityText )
	HudElem_SetRuiArg( file.itemInfo, "itemName", ItemFlavor_GetLongName( itemFlav ) )
	HudElem_SetRuiArg( file.itemInfo, "itemType", ItemFlavor_GetRewardShortDescription( itemFlav ) )

	RunClientScript( "UIToClient_PreviewStoreItem", ItemFlavor_GetGUID( itemFlav ), s_inspectOffers.currentOffers[0].items.len() == 1 )
}

void function PurchaseOfferButton_OnClick( var button )
{
	if ( Hud_IsLocked( button ) )
	{
		EmitUISound( "menu_deny" )
		return
	}

	GRXScriptOffer offer = s_inspectOffers.currentOffers[0]

	if ( s_inspectOffers.isOwnedItemEquippable && offer.output.flavors.len() == 1 )
	{
		StoreInspectMenu_EquipOwnedItem( offer.output.flavors[0], s_inspectUIData )
		return
	}

	PurchaseDialogConfig pdc
	pdc.offer = offer
	pdc.quantity = 1
	PurchaseDialog( pdc )
}

void function StoreInspectMenu_EquipOwnedItem( ItemFlavor itemFlavToEquip, StoreInspectUIData uiData )
{
	int itemType = ItemFlavor_GetType( itemFlavToEquip )
	array<LoadoutEntry> entries = EquipButton_GetItemLoadoutEntries( itemFlavToEquip, false )

	EmitUISound( "UI_Menu_Equip_Generic" )

	if ( entries.len() != 1 )
	{
		OpenSelectSlotDialog( entries, itemFlavToEquip, GetItemFlavorAssociatedCharacterOrWeapon( itemFlavToEquip ), void function( int slotIndex ) : ( entries, itemFlavToEquip ) {
			RequestSetItemFlavorLoadoutSlot_WithDuplicatePrevention( LocalClientEHI(), entries, itemFlavToEquip, slotIndex )
			PIN_Customization( null, itemFlavToEquip, "equip", slotIndex )
		} )
	}
	else
	{
		RequestSetItemFlavorLoadoutSlot_WithDuplicatePrevention( LocalClientEHI(), entries, itemFlavToEquip, 0 )
		PIN_Customization( null, itemFlavToEquip, "equip", 0 )
	}

	Newness_IfNecessaryMarkItemFlavorAsNoLongerNewAndInformServer( itemFlavToEquip )

	var rui = Hud_GetRui( uiData.purchaseButton )
	RuiSetString( rui, "buttonText", "#EQUIPPED_LOOT_REWARD" )
	RuiSetString( rui, "buttonDescText", Localize( "#CURRENTLY_EQUIPPED_ITEM", Localize( ItemFlavor_GetLongName( itemFlavToEquip ) ) ) )
	Hud_SetLocked( uiData.purchaseButton, true )
}

void function StoreInspectMenu_SetStoreOfferData( array<GRXScriptOffer> storeOffers )
{
	s_inspectOffers.currentOffers.clear()
	foreach( GRXScriptOffer offer in storeOffers )
		s_inspectOffers.currentOffers.append( offer )

	GRXScriptOffer storeOffer = s_inspectOffers.currentOffers[0]

	Assert( storeOffer.output.flavors.len() == storeOffer.output.quantities.len() )

	s_inspectOffers.itemCount = storeOffer.output.flavors.len()

	Assert( s_inspectOffers.itemCount > 0 )

	Hud_SetVisible( file.itemGrid, s_inspectOffers.itemCount > 1 )
	Hud_SetVisible( file.itemInfo, s_inspectOffers.itemCount > 1 )
}

bool function StoreInspectMenu_IsItemPresentationSupported( ItemFlavor itemFlav )
{
	                                                                   
	switch ( ItemFlavor_GetType( itemFlav ) )
	{
		case eItemType.account_pack:
		case eItemType.apex_coins:
		case eItemType.character:
		case eItemType.character_emote:
		case eItemType.character_execution:
		case eItemType.character_skin:
		case eItemType.emote_icon:
		case eItemType.gladiator_card_badge:
		case eItemType.gladiator_card_frame:
		case eItemType.gladiator_card_intro_quip:
		case eItemType.gladiator_card_kill_quip:
		case eItemType.gladiator_card_stance:
		case eItemType.gladiator_card_stat_tracker:
		case eItemType.loadscreen:
		case eItemType.melee_skin:
		case eItemType.music_pack:
		case eItemType.skydive_emote:
		case eItemType.weapon_charm:
		case eItemType.weapon_skin:
                
                         
      
			return true

		                            
		                                   
	}

	printf( "Offer has item '%s' [eItemType: %d] which is currently unsupported in bundle inspect view.",
		ItemFlavor_GetHumanReadableRef( itemFlav ), ItemFlavor_GetType( itemFlav ) )
	return false
}

void function StoreInspectMenu_AttemptOpenWithOffer( GRXScriptOffer offer )
{
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

void function AddItemToFakeOffer( GRXScriptOffer offer, ItemFlavor itemFlav )
{
	if ( !StoreInspectMenu_IsItemPresentationSupported( itemFlav ) )
	{
		Warning( "item is unsupported right now, skipping for now, support will be added later. item:", ItemFlavor_GetHumanReadableRef( itemFlav ) )
		return
	}

	offer.output.flavors.append( itemFlav )
	offer.output.quantities.append( 1 )

	GRXStoreOfferItem item
	item.itemType = GRX_OFFERITEMTYPE_DEFAULT
	item.itemQuantity = 1
	item.itemIdx = ItemFlavor_GetGRXIndex( itemFlav )

	offer.items.append( item )
}

#if DEV
void function DEV_PrintInspectedOffer()
{
	if ( s_inspectOffers.currentOffers.len() == 0 )
	{
		printt( "Must be viewing the store inspect menu to see the inspected offer" )
		return
	}

	GRXScriptOffer offer = s_inspectOffers.currentOffers[0]

	printt( "DEV_PrintInspectedOffer" )
	printt( "------------------------------------" )
	printt( "Name:", Localize( offer.titleText ) )
	printt( "Desc:", Localize( offer.descText ) )
	printt( "Item Count:", s_inspectOffers.itemCount )
	printt( "Offer Type:", offer.offerType == GRX_OFFERTYPE_DEFAULT ? "Default" : "Bundle" )
	printt( "Displayed Price:", s_inspectOffers.displayedPrice )
	printt( "Original Price:", s_inspectOffers.originalPrice )
	printt( "Discount Pct:", s_inspectOffers.discountPct )
	printt( "Limit:", s_inspectOffers.purchaseLimit )
	printt( "IsAvailable:", offer.isAvailable )
	printt( "Unavailable Reason:", Localize( offer.unavailableReason ) )
	printt( "------------------------------------" )
	printt( "Item Flavors:" )
	foreach( ItemFlavor flav in s_inspectOffers.itemFlavors )
	{
		printt( ItemFlavor_GetHumanReadableRef( flav ), "[", ItemFlavor_GetGRXIndex( flav ), "]" )
	}
	printt( "------------------------------------" )

	                                                                                                               
	                                                                                      
}

void function DEV_DisplayAllInspectElements( bool shouldShow )
{
	Hud_SetVisible( file.itemGrid, shouldShow )
	Hud_SetVisible( file.itemInfo, shouldShow )
	Hud_SetVisible( s_inspectUIData.discountInfo, shouldShow )
}

void function DEV_AddFakeItemToOffer( string grxRef )
{
	ItemFlavor flav = GetItemFlavorByHumanReadableRef( grxRef )
	array<GRXScriptOffer> fakeOffers = clone s_inspectOffers.currentOffers
	fakeOffers[0].output.flavors.append( flav )
	fakeOffers[0].output.quantities.append( 1 )
	GRXStoreOfferItem item
	item.itemType = GRX_OFFERITEMTYPE_DEFAULT
	item.itemQuantity = 1
	item.itemIdx = ItemFlavor_GetGRXIndex( flav )
	fakeOffers[0].items.append( item )
	StoreInspectMenu_SetStoreOfferData( fakeOffers )
	StoreInspectMenu_OnGRXUpdated()
	                                                                                   
	                                                                      
}


void function DEV_AddFakeItemsToOffer()
{
	const array<string> fakeGRXRefs =
	[
		                       
		                       
		                       
		                       
		                       
		                            
		                                 
		                                 
		                                
		                                
		                                    
		                                     
		                                    
		                                  
		                                    
		                                      
		                                        
		                                                      
		                                       
		                                  
		                                     
		                                        
		                                  
		                                     
		                                    
		                                 

		"sticker_rare_01",
		"sticker_rare_02",
		"sticker_epic_01",
		"sticker_epic_02",
		"sticker_epic_bangalore",

		                                  
		                              
		                              
		                              
		                     
		                              
		                             
		                            
		                                 
		                              
		                              

		                  
		                                     
		                                    
		                                   
		                                     
		                                 
		                                    

		             
		                      
		                     
		                     
		                      
		                     
		                       
		                   
		                      
		                      
		                   
		                       

		             		
		                               

		               
		                        
		                        

                         
                                           

		            
		                                        
		
		              
		                            

                        
                                                

		         
		                                                

                
                                                 
                                                      

		              
		                                  
		                             

		                
		                          
		                                   
		                                  
		                              

		                   
		                                          
		                                         
		                                              
		                                              
		                                          
		                                            
		                                                
		                                         
		                                              
		                                     
		                                             
		                                               
		                                          
		                                                  
		                                          
		                                        
		                                      
		                                               
		                                           
		                                                
	]

	const int MAX_GRID_ITEMS = ITEM_GRID_ROWS * ITEM_GRID_COLUMNS
	array<GRXScriptOffer> fakeOffers = clone s_inspectOffers.currentOffers
	foreach( string grxRef in fakeGRXRefs )
	{
		if( fakeOffers[0].output.flavors.len() >= MAX_GRID_ITEMS )
			continue

		ItemFlavor flav = GetItemFlavorByHumanReadableRef( grxRef )
		fakeOffers[0].output.flavors.append( flav )
		fakeOffers[0].output.quantities.append( 1 )
		GRXStoreOfferItem item
		item.itemType = GRX_OFFERITEMTYPE_DEFAULT
		item.itemQuantity = 1
		item.itemIdx = ItemFlavor_GetGRXIndex( flav )
		fakeOffers[0].items.append( item )
	}

	StoreInspectMenu_SetStoreOfferData( fakeOffers )
	StoreInspectMenu_OnGRXUpdated()
}
#endif       