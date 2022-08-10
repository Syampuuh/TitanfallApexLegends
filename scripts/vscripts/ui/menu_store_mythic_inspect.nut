global function InitStoreMythicInspectMenu
global function StoreMythicInspectMenu_SetStoreOfferData
global function StoreMythicInspectMenu_AttemptOpenWithOffer

struct
{
	var menu
	var inspectPanel
	var mouseCaptureElem

	var pageHeader
	var itemGrid
	var itemInfo
	var purchaseLimit
	var ownedIndicator

	array< var > mythicInspectButtons
	var          mythicExecutionButton

	int activeTierIndex
	int lastTierIndex                                                                         
} file

StoreInspectOfferData s_inspectOffers
StoreInspectUIData s_inspectUIData

const int MYTHIC_TIERS_PLUS_FINSHER = 4
const string MYTHIC_INSPECT_BUTTON_NAME = "MythicInspectButton"

void function InitStoreMythicInspectMenu( var newMenuArg )
{
	file.menu = newMenuArg

	AddMenuEventHandler( newMenuArg, eUIEvent.MENU_OPEN, StoreMythicInspectMenu_OnOpen )
	AddMenuEventHandler( newMenuArg, eUIEvent.MENU_SHOW, StoreMythicInspectMenu_OnShow )
	AddMenuEventHandler( newMenuArg, eUIEvent.MENU_CLOSE, StoreMythicInspectMenu_OnClose )
	AddMenuEventHandler( newMenuArg, eUIEvent.MENU_HIDE, StoreMythicInspectMenu_OnHide )

	file.inspectPanel = Hud_GetChild( newMenuArg, "InspectPanel" )
	file.mouseCaptureElem = Hud_GetChild( newMenuArg, "ModelRotateMouseCapture" )

	file.pageHeader = Hud_GetChild( file.inspectPanel, "InspectHeader" )
	s_inspectUIData.discountInfo = Hud_GetChild( file.inspectPanel, "DiscountInfo" )
	file.itemInfo = Hud_GetChild( file.inspectPanel, "IndividualItemInfo" )
	s_inspectUIData.purchaseButton = Hud_GetChild( file.inspectPanel, "PurchaseOfferButton" )
	file.purchaseLimit = Hud_GetChild( file.inspectPanel, "PurchaseLimit" )
	file.ownedIndicator = Hud_GetChild( file.inspectPanel, "MythicOwned" )

	AddButtonEventHandler( s_inspectUIData.purchaseButton, UIE_CLICK, PurchaseOfferButton_OnClick )

	for ( int index = 0; index < MYTHIC_TIERS_PLUS_FINSHER; index++ )
	{
		string inspectIndexName	= MYTHIC_INSPECT_BUTTON_NAME + string( index )
		var inspectButton = Hud_GetChild( file.inspectPanel, inspectIndexName )
		Hud_AddEventHandler( inspectButton, UIE_CLICK, MythicInspectButtonClicked )
		Hud_AddEventHandler( inspectButton, UIE_GET_FOCUS, MythicInspectButtonHover )

		if ( index == MYTHIC_TIERS_PLUS_FINSHER - 1 )
			file.mythicExecutionButton = inspectButton
		else
			file.mythicInspectButtons.append( inspectButton )
	}

	Hud_AddEventHandler( Hud_GetChild( newMenuArg, "CoinsPopUpButton" ), UIE_CLICK, OpenVCPopUp )

	AddMenuFooterOption( newMenuArg, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
}

void function StoreMythicInspectMenu_OnOpen()
{
}

void function StoreMythicInspectMenu_OnShow()
{
	UI_SetPresentationType( ePresentationType.STORE_INSPECT )

	AddCallbackAndCallNow_OnGRXInventoryStateChanged( StoreMythicInspectMenu_OnGRXUpdated )
	AddCallback_OnGRXOffersRefreshed( StoreMythicInspectMenu_OnGRXUpdated )
	AddCallback_OnGRXBundlesRefreshed( StoreMythicInspectMenu_OnGRXBundlesUpdated )

	RegisterButtonPressedCallback( KEY_TAB, ToggleVCPopUp )
	RegisterButtonPressedCallback( BUTTON_BACK, ToggleVCPopUp )

	file.lastTierIndex = -1
	if( file.mythicInspectButtons.len() > 0 && IsValid( file.mythicInspectButtons[0] ) )
		MythicInspectButtonHover( file.mythicInspectButtons[0] )
	StoreMythicUpdateInspectButtons()

}

void function StoreMythicInspectMenu_OnClose()
{
	RunClientScript( "UIToClient_UnloadItemInspectPakFile" )
}

void function StoreMythicInspectMenu_OnHide()
{
	DeregisterButtonPressedCallback( KEY_TAB, ToggleVCPopUp )
	DeregisterButtonPressedCallback( BUTTON_BACK, ToggleVCPopUp )

	RemoveCallback_OnGRXInventoryStateChanged( StoreMythicInspectMenu_OnGRXUpdated )
	RemoveCallback_OnGRXOffersRefreshed( StoreMythicInspectMenu_OnGRXUpdated )
	RemoveCallback_OnGRXBundlesRefreshed( StoreMythicInspectMenu_OnGRXBundlesUpdated )

}

void function StoreMythicInspectMenu_OnGRXBundlesUpdated()
{
	if ( s_inspectOffers.currentOffers.len() == 0 )
		return

	if( !GRX_IsInventoryReady() )
		return

	StoreInspectMenu_UpdatePrices( s_inspectOffers, s_inspectOffers.currentOffers[0], true, s_inspectUIData )
	StoreInspectMenu_UpdatePurchaseButton( s_inspectOffers.currentOffers[0], s_inspectOffers, s_inspectUIData )
}

void function StoreMythicInspectMenu_OnGRXUpdated()
{
	if( !GRX_IsInventoryReady() || !GRX_AreOffersReady() )
		return

	GRXScriptOffer storeOffer = s_inspectOffers.currentOffers[0]
	s_inspectOffers.itemFlavors.clear()

	var currMenu = GetActiveMenu()
	uiGlobal.menuData[ currMenu ].pin_metaData[ "tab_name" ] <- Hud_GetHudName( file.inspectPanel )
	uiGlobal.menuData[ currMenu ].pin_metaData[ "item_name" ] <- storeOffer.offerAlias

	foreach( ItemFlavor flav in storeOffer.output.flavors )
		s_inspectOffers.itemFlavors.append( flav )

	s_inspectOffers.purchaseLimit = ( "purchaselimit" in storeOffer.attributes ? storeOffer.attributes["purchaselimit"].tointeger() : -1 )

	StoreInspectMenu_UpdatePrices( s_inspectOffers, storeOffer, false, s_inspectUIData )
	StoreInspectMenu_UpdatePurchaseButton( storeOffer, s_inspectOffers, s_inspectUIData)

	HudElem_SetRuiArg( file.pageHeader, "offerName", storeOffer.titleText )
	HudElem_SetRuiArg( file.pageHeader, "offerDesc", storeOffer.descText )

	if( file.mythicInspectButtons.len() > 0 && IsValid( file.mythicInspectButtons[0] ) )
		MythicInspectButtonHover( file.mythicInspectButtons[0] )
	StoreMythicUpdateInspectButtons()

	bool hasPurchaseLimit = s_inspectOffers.purchaseLimit > 0
	HudElem_SetRuiArg( file.purchaseLimit, "limitText", Localize( "#STORE_LIMIT_N", s_inspectOffers.purchaseLimit ) )
	Hud_SetVisible( file.purchaseLimit, hasPurchaseLimit )
}

ItemFlavor ornull function GetItemFromButtonIndex( int index )
{
	GRXScriptOffer storeOffer = s_inspectOffers.currentOffers[0]

	if( storeOffer.items.len() < 1 )
		return null

	ItemFlavor baseItem = GetItemFlavorByGRXIndex( storeOffer.items[0].itemIdx )

	return Mythics_GetItemTierForSkin( baseItem, index )
}

void function SetupInspectButton( var button, int index )
{
	ItemFlavor ornull itemFlav = GetItemFromButtonIndex( index )

	if( itemFlav == null )
	{
		return
	}

	expect ItemFlavor( itemFlav )

	asset itemThumbnail = CustomizeMenu_GetRewardButtonImage( itemFlav )

	int tiersUnlocked = 0

	if ( index == MYTHIC_TIERS_PLUS_FINSHER - 1 )
	{
		ItemFlavor finalTierSkinFlav = expect ItemFlavor( GetItemFromButtonIndex( index - 1 ) )

		tiersUnlocked = Mythics_GetNumTiersUnlockedForSkin( GetLocalClientPlayer(), finalTierSkinFlav ) + 1
	}
	else
	{
		tiersUnlocked = Mythics_GetNumTiersUnlockedForSkin( GetLocalClientPlayer(), itemFlav )
	}

	var rui = Hud_GetRui( button )

	if ( index == 0 )
	{
		bool isOwned = GRX_IsItemOwnedByPlayer( itemFlav )
		Hud_SetVisible( file.ownedIndicator, isOwned )                                         
		RuiSetBool( rui, "isOwned", isOwned )
	}
	else
	{
		RuiSetBool( rui, "isOwned", tiersUnlocked > index )
	}

	RuiSetImage( rui, "itemThumbnail", itemThumbnail )
	RuiSetInt( rui, "mythicTier", index + 1 )
}

void function MythicInspectButtonClicked( var button )
{
}

void function MythicInspectButtonHover( var button )
{
	int index = int( Hud_GetScriptID( button ) )

	if( index == file.lastTierIndex )
		return

	file.lastTierIndex = index

	ItemFlavor itemFlav

	string rarityText
	string descText

	bool isLocked = false
	int tiersUnlocked = 0
	bool isOwned = GRX_IsItemOwnedByPlayer( expect ItemFlavor( GetItemFromButtonIndex(0 ) ) )
	ItemFlavor ornull finalTierSkinFlav

	if ( index == MYTHIC_TIERS_PLUS_FINSHER - 1 )
	{
		finalTierSkinFlav = GetItemFromButtonIndex( index - 1 )

		if( finalTierSkinFlav == null )
			return

		expect ItemFlavor( finalTierSkinFlav )

		if ( Mythics_SkinHasCustomExecution( finalTierSkinFlav ) )
			itemFlav = Mythics_GetCustomExecutionForCharacterOrSkin( finalTierSkinFlav )

		rarityText = "#DEATH_HUMAN_EXECUTION"
		tiersUnlocked = Mythics_GetNumTiersUnlockedForSkin( GetLocalClientPlayer(), finalTierSkinFlav )
		descText = Challenge_GetDescription ( Mythics_GetChallengeForSkin( finalTierSkinFlav ), 1 )
		index--
	}
	else
	{
		ItemFlavor ornull skinFlav = GetItemFromButtonIndex( index )

		if( skinFlav == null )
			return

		expect ItemFlavor( skinFlav )

		itemFlav = skinFlav
		rarityText = Localize( "#TIER", index + 1 )
		tiersUnlocked = Mythics_GetNumTiersUnlockedForSkin( GetLocalClientPlayer(), itemFlav )

		if ( index == 0 )
			 descText = "#S12ACE_MYTHIC_INSPECT_UNLOCK_DESC"
		else
			descText = Challenge_GetDescription( Mythics_GetChallengeForSkin( itemFlav ), index - 1  )
	}

	if ( index == 0 && isOwned )
		isLocked = true
	else
		isLocked = isOwned ? tiersUnlocked > index : true

	var rui = Hud_GetRui( file.itemInfo )
	RuiSetBool( rui, "isOwned", isOwned )
	RuiSetBool( rui, "isLocked", !isLocked )
	RuiSetString( rui, "rarityText", rarityText )
	RuiSetString( rui, "descText", descText )

	if( IsItemFlavorStructValid( itemFlav ) )
		RunClientScript( "UIToClient_PreviewStoreItem", ItemFlavor_GetGUID( itemFlav ) )

	if( index == 0 )
	{
		StoreInspectMenu_UpdatePurchaseButton( s_inspectOffers.currentOffers[index], s_inspectOffers, s_inspectUIData )
	}
	else if ( isOwned )
	{
		if( finalTierSkinFlav != null )
			itemFlav = expect ItemFlavor( finalTierSkinFlav )

		MythicInspect_UpdatePurchaseButton( itemFlav, s_inspectOffers, s_inspectUIData, !isLocked )
	}

	file.activeTierIndex = isOwned ? index : 0
}

void function MythicInspect_UpdatePurchaseButton( ItemFlavor itemFlav, StoreInspectOfferData offerData, StoreInspectUIData uiData, bool isLocked )
{
	Hud_SetVisible( uiData.discountInfo, false )

	string buttonText = isLocked ? offerData.purchaseText + " | "  + Localize( "#LOCKED" ) : offerData.purchaseText

	HudElem_SetRuiArg( uiData.purchaseButton, "buttonText", buttonText )
	HudElem_SetRuiArg( uiData.purchaseButton, "buttonDescText", offerData.purchaseDescText )

	bool isEquiped = IsItemEquipped( itemFlav )
	Hud_SetLocked( uiData.purchaseButton, isEquiped || isLocked )
	HudElem_SetRuiArg( uiData.purchaseButton, "isDisabled", isEquiped || isLocked )

	if( isLocked )
		s_inspectOffers.isOwnedItemEquippable = false
	else
		MythicInspect_UpdateButtonForEquips( itemFlav, uiData )
}

void function MythicInspect_UpdateButtonForEquips( ItemFlavor itemFlav, StoreInspectUIData uiData )
{
	int itemType = ItemFlavor_GetType( itemFlav )
	var rui = Hud_GetRui( uiData.purchaseButton )

	if ( IsItemEquipped( itemFlav ) )
	{
		int rarity = ItemFlavor_HasQuality( itemFlav ) ? ItemFlavor_GetQuality( itemFlav ) : 0

		RuiSetString( rui, "buttonText", "#EQUIPPED_LOOT_REWARD" )
		RuiSetString( rui, "buttonDescText", Localize( "#CURRENTLY_EQUIPPED_ITEM", Localize( ItemFlavor_GetLongName( itemFlav ) ) ) )
		RuiSetInt( rui, "buttonDescRarity", rarity )
	}
	else
	{
		RuiSetString( rui, "buttonText", "#EQUIP_LOOT_REWARD" )
		RuiSetString( rui, "buttonDescText", Localize( "#CURRENTLY_EQUIPPED_ITEM", Localize( GetCurrentlyEquippedItemNameForItemTypeSlot( itemFlav ) ) ) )
		RuiSetInt( rui, "buttonDescRarity", GetCurrentlyEquippedItemRarityForItemTypeSlot( itemFlav ) )
	}
}

void function PurchaseOfferButton_OnClick( var button )
{
	if ( Hud_IsLocked( button ) )
	{
		EmitUISound( "menu_deny" )
		return
	}

	if ( file.activeTierIndex == 0 )
	{
		GRXScriptOffer offer = s_inspectOffers.currentOffers[file.activeTierIndex]

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
	else
	{
		ItemFlavor ornull skinFlav = GetItemFromButtonIndex( file.activeTierIndex )

		if( skinFlav == null )
			return

		expect ItemFlavor( skinFlav )

		StoreInspectMenu_EquipOwnedItem( skinFlav, s_inspectUIData )
	}
}

void function StoreMythicInspectMenu_SetStoreOfferData( array<GRXScriptOffer> storeOffers )
{
	s_inspectOffers.currentOffers.clear()
	foreach( GRXScriptOffer offer in storeOffers )
		s_inspectOffers.currentOffers.append( offer )

	GRXScriptOffer storeOffer = s_inspectOffers.currentOffers[0]

	Assert( storeOffer.output.flavors.len() == storeOffer.output.quantities.len() )

	s_inspectOffers.itemCount = storeOffer.output.flavors.len()

	Assert( s_inspectOffers.itemCount > 0,"Mythic skin offer was not found" )

	for( int i; i < file.mythicInspectButtons.len(); i++ )
	{
		if( !IsValid( file.mythicInspectButtons[i] ) )
			continue
		Hud_SetVisible( file.mythicInspectButtons[i], s_inspectOffers.itemCount > 0  )
	}

	Hud_SetVisible( file.itemInfo, s_inspectOffers.itemCount > 0 )
}

void function StoreMythicInspectMenu_AttemptOpenWithOffer( GRXScriptOffer offer )
{
	StoreMythicInspectMenu_SetStoreOfferData( [offer] )
	AdvanceMenu( GetMenu( "StoreMythicInspectMenu" ) )
}

void function StoreMythicUpdateInspectButtons()
{
	if ( !IsFullyConnected() )
		return

	var button
	for( int i; i < file.mythicInspectButtons.len(); i++ )
	{
		if( !IsValid( file.mythicInspectButtons[i] ) )
			continue

		button = file.mythicInspectButtons[i]

		SetupInspectButton( button, i )
	}

	SetupInspectButton( file.mythicExecutionButton, MYTHIC_TIERS_PLUS_FINSHER - 1 )
}