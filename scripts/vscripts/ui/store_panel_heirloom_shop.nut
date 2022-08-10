global function HeirloomShopPanel_Init

global function StorePanelHeirloomShopEvent_LevelInit
global function StorePanelHeirloomShopEvent_LevelShutdown

global function HeirloomShop_GetTabText
global function HeirloomShop_GetGRXOfferLocation
global function HeirloomShop_GetTabBGDefaultCol
global function HeirloomShop_GetTabBarDefaultCol
global function HeirloomShop_GetTabBGFocusedCol
global function HeirloomShop_GetTabBarFocusedCol
global function HeirloomShop_GetTabBGSelectedCol
global function HeirloomShop_GetTabBarSelectedCol
global function HeirloomShop_GetItemButtonBGImage
global function HeirloomShop_GetItemButtonFrameImage
global function HeirloomShop_GetItemButtonLowerBGDecoImage
global function HeirloomShop_GetItemButtonBorderCol
global function HeirloomShop_GetItemButtonSpecialIcon
global function HeirloomShop_GetItemGroupHeaderImage
global function HeirloomShop_GetItemGroupHeaderText
global function HeirloomShop_GetItemGroupHeaderTextColor
global function HeirloomShop_GetItemGroupBackgroundImage

global function HeirloomShop_IsVisibleWithoutCurrency

global struct ShopThemeStruct
{
	      
	string tabText
	string grxOfferLocation
	vector tabBGDefaultCol
	vector tabBarDefaultCol
	vector tabBGFocusedCol
	vector tabBarFocusedCol
	vector tabBGSelectedCol
	vector tabBarSelectedCol

	             
	vector shopInfoBoxBGTintCol
	vector shopCurrencyCountTextCol
	vector shopCurrencyCountDecoCol
	vector specialAboutTextCol
	asset  bgPatternImage

	              
	asset  itemBtnHighlightedBGImage
	asset  itemBtnRegularBGImage
	asset  itemBtnHighlightedFrameImage
	asset  itemBtnRegularFrameImage
	asset  itemBtnHighlightedLowerBGDecoImage
	asset  itemBtnRegularLowerBGDecoImage
	vector itemBtnHighlightedBorderCol
	vector itemBtnRegularBorderCol
	asset  itemBtnHighlightedSpecialIcon
	asset  itemBtnRegularSpecialIcon
}

struct {
	var        panel
	var        infoBox
	var		   heirloomList
	var		   mythicList
	array<var> offerButtons

	var		   infoButton
	var		   weaponSkinToggleButton

	table<var, GRXScriptOffer> offerButtonToOfferMap
	var                        WORKAROUND_currentlyFocusedOfferButtonForFooters

	bool mythicSkinsEnabled

	ShopThemeStruct themeStruct
} file

const int NUM_OFFER_BUTTONS = 5

void function HeirloomShopPanel_Init( var panel )
{
	file.panel = panel

	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, HeirloomShopPanel_OnShow )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, HeirloomShopPanel_OnHide )

	file.infoBox = Hud_GetChild( panel, "InfoBox" )
	file.infoButton = Hud_GetChild( panel, "MoreInfoButton" )

	file.heirloomList = Hud_GetChild( panel, "HeirloomList" )
	file.mythicList = Hud_GetChild( panel, "MythicList" )

	Hud_AddEventHandler( file.infoButton, UIE_CLICK, void function( var button ) : () {
		ConfirmDialogData dialogData
		dialogData.headerText = "#CURRENCY_HEIRLOOM_NAME_SHORT_ICON"
		dialogData.messageText = Localize( "#CURRENCY_HEIRLOOM_DESC_LONG" )
		OpenOKDialogFromData( dialogData )
	} )

	file.mythicSkinsEnabled = false
	file.weaponSkinToggleButton = Hud_GetChild( file.panel, "WeaponSkinToggle" )
	HudElem_SetRuiArg( file.weaponSkinToggleButton, "showMythic", false )
	Hud_AddEventHandler( file.weaponSkinToggleButton, UIE_CLICK, ToggleWeaponOrMythicSkin )

	                                                                                      
	   
	  	                                                                                      
	  	                  
	  	                                                                    
	  	                                                                      
	  	                                                                
	  	                                                                        
	  	                                  
	   

	file.themeStruct.tabText = "#MENU_STORE_PANEL_PRESTIGE_SHOP"
	file.themeStruct.grxOfferLocation = "heirloom_set_shop"
	file.themeStruct.tabBGDefaultCol = <116.0 / 255.0, 40.0 / 255.0, 29.0 / 255.0>
	file.themeStruct.tabBarDefaultCol = <188.0 / 255.0, 94.0 / 255.0, 57.0 / 255.0>
	file.themeStruct.tabBGFocusedCol = <139.0 / 255.0, 55.0 / 255.0, 25.0 / 255.0>
	file.themeStruct.tabBarFocusedCol = <219.0 / 255.0, 103.0 / 255.0, 55.0 / 255.0>
	file.themeStruct.tabBGSelectedCol = <159.0 / 255.0, 33.0 / 255.0, 5.0 / 255.0>
	file.themeStruct.tabBarSelectedCol = <255.0 / 255.0, 88.0 / 255.0, 23.0 / 255.0>

	file.themeStruct.shopInfoBoxBGTintCol = <0.2, 0.02, 0.02>
	file.themeStruct.shopCurrencyCountTextCol = <1.0, 1.0, 1.0>
	file.themeStruct.shopCurrencyCountDecoCol = <.85, 0.035, 0.013>
	file.themeStruct.specialAboutTextCol = <.6, .6, .6>
	file.themeStruct.bgPatternImage = $"white"

	file.themeStruct.itemBtnHighlightedBGImage = $"white"
	file.themeStruct.itemBtnRegularBGImage = $"white"
	file.themeStruct.itemBtnHighlightedFrameImage = $"white"
	file.themeStruct.itemBtnRegularFrameImage = $"white"
	file.themeStruct.itemBtnHighlightedLowerBGDecoImage = $"white"
	file.themeStruct.itemBtnRegularLowerBGDecoImage = $"white"
	file.themeStruct.itemBtnHighlightedBorderCol = <0, 0, 0>
	file.themeStruct.itemBtnRegularBorderCol = <0, 0, 0>
	file.themeStruct.itemBtnHighlightedSpecialIcon = $"white"
	file.themeStruct.itemBtnRegularSpecialIcon = $"white"

	AddPanelFooterOption( panel, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
	AddPanelFooterOption( panel, LEFT, BUTTON_A, false, "#A_BUTTON_INSPECT", "#A_BUTTON_INSPECT", null, IsFocusedItemInspectable )
	AddPanelFooterOption( panel, LEFT, BUTTON_X, false, "#X_BUTTON_EQUIP", "#X_BUTTON_EQUIP", null, IsFocusedItemEquippable )
}

void function StorePanelHeirloomShopEvent_LevelInit()
{
}

void function StorePanelHeirloomShopEvent_LevelShutdown()
{
	foreach ( offerButton, offer in file.offerButtonToOfferMap )
	{
		Hud_RemoveEventHandler( offerButton, UIE_GET_FOCUS, OfferButton_OnGetFocus )
		Hud_RemoveEventHandler( offerButton, UIE_LOSE_FOCUS, OfferButton_OnLoseFocus )
		Hud_RemoveEventHandler( offerButton, UIE_CLICK, OfferButton_OnActivate )
		Hud_RemoveEventHandler( offerButton, UIE_CLICKRIGHT, OfferButton_OnAltActivate )
	}

	file.WORKAROUND_currentlyFocusedOfferButtonForFooters = null
	file.offerButtonToOfferMap.clear()
}

void function HeirloomShopPanel_OnShow( var panel )
{
	SetCurrentTabForPIN( Hud_GetHudName( panel ) )
	UI_SetPresentationType( ePresentationType.WEAPON_CATEGORY )

	AddCallbackAndCallNow_OnGRXInventoryStateChanged( HeirloomShopPanel_UpdateGRXDependantElements )
	AddCallbackAndCallNow_OnGRXOffersRefreshed( HeirloomShopPanel_UpdateGRXDependantElements )

	thread HeirloomShopPanel_Think( panel )
}


void function HeirloomShopPanel_OnHide( var panel )
{
	RunClientScript( "UIToClient_StopBattlePassScene" )

	RemoveCallback_OnGRXInventoryStateChanged( HeirloomShopPanel_UpdateGRXDependantElements )
	RemoveCallback_OnGRXOffersRefreshed( HeirloomShopPanel_UpdateGRXDependantElements )
}


GRXScriptOffer function DEV_FakeHeirloomOffer( asset packAsset )
{
	GRXScriptOffer fakeOffer
	ItemFlavorBag priceBag
	priceBag.flavors.append( GRX_CURRENCIES[GRX_CURRENCY_HEIRLOOM] )
	priceBag.quantities.append( 100 )
	fakeOffer.prices.append( priceBag )

	ItemFlavorBag outputBag
	outputBag.flavors.append( GetItemFlavorByAsset( packAsset ) )
	outputBag.quantities.append( 1 )
	fakeOffer.output = outputBag

	return fakeOffer
}


void function HeirloomShopPanel_UpdateGRXDependantElements()
{
	bool isInventoryReady    = GRX_IsInventoryReady()
	bool hasHeirloomCurrency = true
	bool menuIsUsable        = isInventoryReady && hasHeirloomCurrency

	foreach ( offerButton, offer in file.offerButtonToOfferMap )
	{
		Hud_RemoveEventHandler( offerButton, UIE_GET_FOCUS, OfferButton_OnGetFocus )
		Hud_RemoveEventHandler( offerButton, UIE_LOSE_FOCUS, OfferButton_OnLoseFocus )
		Hud_RemoveEventHandler( offerButton, UIE_CLICK, OfferButton_OnActivate )
		Hud_RemoveEventHandler( offerButton, UIE_CLICKRIGHT, OfferButton_OnAltActivate )
	}
	file.offerButtonToOfferMap.clear()

	var listPanel


	if ( file.mythicSkinsEnabled )
	{
		listPanel = file.mythicList
		Hud_Show( file.mythicList )
		Hud_Hide( file.heirloomList )
	}
	else
	{
		listPanel = file.heirloomList
		Hud_Show( file.heirloomList )
		Hud_Hide( file.mythicList )
	}

	var focus = GetFocus()
	if ( !(focus in file.offerButtonToOfferMap) )
		focus = null
	UpdateFocusStuff( focus )

	if ( menuIsUsable )
	{
		HudElem_SetRuiArg( file.weaponSkinToggleButton, "showMythic", file.mythicSkinsEnabled )

		ItemFlavor currencyFlav = GRX_CURRENCIES[GRX_CURRENCY_HEIRLOOM]
		ShopThemeStruct themeStruct = file.themeStruct
		HudElem_SetRuiArg( file.infoBox, "currencyIcon", ItemFlavor_GetIcon( currencyFlav ) )

		if ( isInventoryReady )
			HudElem_SetRuiArg( file.infoBox, "currencyAmount", GRXCurrency_GetPlayerBalance( GetLocalClientPlayer(), currencyFlav ) )
		else
			HudElem_SetRuiArg( file.infoBox, "currencyAmount", 0 )

		int heirloomCost = GetCurrentPlaylistVarInt( "grx_currency_bundle_heirloom_count", 50 ) * 3
		HudElem_SetRuiArg( file.infoBox, "heirloomCost", heirloomCost )

		array<GRXScriptOffer> offers
		int buttonCount

		bool hasMythicOffers = GRX_IsLocationActive( "prestige_set_shop" )
		HeirloomShopPanel_SetupInfoLayout( hasMythicOffers )

		if ( file.mythicSkinsEnabled )
		{
			offers = GRX_GetLocationOffers( "prestige_set_shop" )
			buttonCount = offers.len() > 1 ? 2 : 1
		}
		else
		{
			offers = GRX_GetLocationOffers( themeStruct.grxOfferLocation )
			buttonCount = 5
		}

		                                                
		   
		  	                   
		  	                                          
		  		                                                                                                                                
		  	                                                                                                                                                              
		   

		         
		  	                                
		  		                                              
		  		                                                
		  		                                                  
		  		                                                  
		  	 
		  	                          
		  	 
		  		                                                                       
		  	 
		        
		  
		if ( offers.len() == 0 )
		{
			Hud_InitGridButtonsDetailed( listPanel, 0, 1, 6 )
			return
		}

		offers.sort( int function( GRXScriptOffer a, GRXScriptOffer b ) {
			int aSlot = ("slot" in a.attributes ? int(a.attributes["slot"]) : 99999)
			int bSlot = ("slot" in b.attributes ? int(b.attributes["slot"]) : 99999)
			if ( aSlot != bSlot )
				return bSlot - aSlot

			return 0
		} )

		int numTiles = offers.len()

		Hud_InitGridButtonsDetailed( listPanel, numTiles, 1, buttonCount )
		var scrollPanel = Hud_GetChild( listPanel, "ScrollPanel" )
		foreach ( offerIndex, offer in offers )
		{
			var offerButton = Hud_GetChild( scrollPanel, "GridButton" + offerIndex )

			file.offerButtonToOfferMap[offerButton] <- offer

			ItemFlavor skinFlavor = GetItemFlavorFromOffer( offer.output  )
			ItemFlavor character

			bool isOwned = GRX_IsItemOwnedByPlayer_AllowOutOfDateData( skinFlavor )
			if ( file.mythicSkinsEnabled )
			{
				character = Mythics_GetCharacterForSkin( skinFlavor )

				Assert( Mythics_CharacterHasMythic( character ) )
				HudElem_SetRuiArg( offerButton, "itemImg0", Mythics_GetStoreImageForCharacter( character, 0 ), eRuiArgType.IMAGE )
				HudElem_SetRuiArg( offerButton, "itemImg1", Mythics_GetStoreImageForCharacter( character, 1 ), eRuiArgType.IMAGE )
				HudElem_SetRuiArg( offerButton, "itemImg2", Mythics_GetStoreImageForCharacter( character, 2 ), eRuiArgType.IMAGE )
				HudElem_SetRuiArg( offerButton, "finImg", ItemFlavor_GetIcon( Mythics_GetCustomExecutionForCharacterOrSkin( character ) ), eRuiArgType.IMAGE )
				HudElem_SetRuiArg( offerButton, "itemDesc", isOwned ? "#COLLECTED" : Mythics_GetSkinBaseNameForCharacter( character ) )
			}
			else
			{

				character = MeleeSkin_GetCharacterFlavor( skinFlavor )
				HudElem_SetRuiArg( offerButton, "itemImg", MeleeSkin_GetStoreImage( skinFlavor ), eRuiArgType.IMAGE )
				HudElem_SetRuiArg( offerButton, "itemDesc", isOwned ? "#COLLECTED" : ItemFlavor_GetLongName( skinFlavor ) )
			}

			HudElem_SetRuiArg( offerButton, "itemName", ItemFlavor_GetLongName( character ) )
			HudElem_SetRuiArg( offerButton, "itemRarity", ItemFlavor_GetQuality( skinFlavor ) )
			HudElem_SetRuiArg( offerButton, "charImg", ItemFlavor_GetIcon( character ), eRuiArgType.IMAGE )
			Assert( offer.prices.len() == 1 )
			HudElem_SetRuiArg( offerButton, "isOwned", isOwned )

			Hud_AddEventHandler( offerButton, UIE_GET_FOCUS, OfferButton_OnGetFocus )
			Hud_AddEventHandler( offerButton, UIE_LOSE_FOCUS, OfferButton_OnLoseFocus )
			Hud_AddEventHandler( offerButton, UIE_CLICK, OfferButton_OnActivate )
			Hud_AddEventHandler( offerButton, UIE_CLICKRIGHT, OfferButton_OnAltActivate )
		}
		  
		                                                                    
		 
			                                    
			 
				                       
				                                             
				                                                

				                                                                                            
				                                                                            
				                                                          

				                                  

				                                                                                        
				                                                                                                                       
				                                                                                         
				                                                                                                                                                           
				                                 
				                                                                                         
				                                                                                                           
			 
			    
			 
				                       
			 
		   
		Hud_ScrollToItemIndex(listPanel, 0 )
	}
	else
	{
		Hud_InitGridButtonsDetailed( listPanel, 0, 1, 6 )

		                                                  
		  	                                    
	}
}

void function HeirloomShopPanel_SetupInfoLayout( bool hasMythicOffers )
{
	Hud_SetVisible( file.weaponSkinToggleButton, hasMythicOffers )
	Hud_SetPos( file.infoBox, hasMythicOffers ? Hud_GetWidth( file.infoBox ) * 0.23 : Hud_GetWidth( file.infoBox ) * -0.13, 0.0 )
}

void function HeirloomShopPanel_Think( var panel )
{
	var focusedOfferButton = null
	float offerLostFocusTime = 0
	bool offerFocusNeedsUpdate = true

	var menu = GetParentMenu( panel )
	while ( GetActiveMenu() == menu && uiGlobal.activePanels.contains( panel ) )
	{
		var focus = GetFocus()

		if ( focus in file.offerButtonToOfferMap )
		{
			if ( focus != focusedOfferButton )
			{
				offerFocusNeedsUpdate = false
				focusedOfferButton = focus
				printt( "new offer focus" )
				foreach ( offerButton, offer in file.offerButtonToOfferMap )
				{
					if ( offerButton != focusedOfferButton )
						HudElem_SetRuiArg( offerButton, "isOtherFocused", true )
					else
						HudElem_SetRuiArg( offerButton, "isOtherFocused", false )
				}
			}
		}
		else if ( focusedOfferButton != null )
		{
			focusedOfferButton = null
			offerLostFocusTime = UITime()
			offerFocusNeedsUpdate = true
			printt( "lost offer focus" )
		}
		else if ( UITime() > offerLostFocusTime + 0.25 && offerFocusNeedsUpdate )
		{
			offerFocusNeedsUpdate = false
			printt( "it's been long enough" )
			foreach ( offerButton, offer in file.offerButtonToOfferMap )
			{
				HudElem_SetRuiArg( offerButton, "isOtherFocused", false )
			}
		}

		WaitFrame()
	}
}


void function OfferButton_OnGetFocus( var btn )
{
	UpdateFocusStuff( btn )
	                                                              
	   
	  	                                                                                     
	   
}


void function OfferButton_OnLoseFocus( var btn )
{
	var focus = GetFocus()
	                                                              
	   
	  	                                                           
	  	                                                                                                                      
	   

	UpdateFocusStuff( null )
}


void function OfferButton_OnActivate( var btn )
{
	if ( !Hud_IsEnabled( btn ) )
		return

	GRXScriptOffer offer = file.offerButtonToOfferMap[btn]
	ItemFlavor offerFlav = GetItemFlavorFromOffer( offer.output )
	if ( !IsItemFlavorInspectable( offerFlav ) )
		return

	if( file.mythicSkinsEnabled )
		StoreMythicInspectMenu_AttemptOpenWithOffer( offer )
	else
		StoreInspectMenu_AttemptOpenWithOffer( offer )
}


void function OfferButton_OnAltActivate( var btn )
{
	if ( !Hud_IsEnabled( btn ) )
		return

	GRXScriptOffer offer = file.offerButtonToOfferMap[btn]
	ItemFlavor offerFlav = GetItemFlavorFromOffer( offer.output )
	if ( !IsItemFlavorEquippable( offerFlav ) )
		return

	EmitUISound( "UI_Menu_Equip_Generic" )
	EquipItemFlavorInAppropriateLoadoutSlot( offerFlav )
}


bool function IsFocusedItemInspectable()
{
	var focus = file.WORKAROUND_currentlyFocusedOfferButtonForFooters                                                                            
	if ( focus in file.offerButtonToOfferMap )
	{
		GRXScriptOffer offer = file.offerButtonToOfferMap[focus]
		return IsItemFlavorInspectable( GetItemFlavorFromOffer( offer.output ) )
	}

	return false
}


bool function IsFocusedItemEquippable()
{
	var focus = file.WORKAROUND_currentlyFocusedOfferButtonForFooters                                                                            
	if ( focus in file.offerButtonToOfferMap )
	{
		GRXScriptOffer offer = file.offerButtonToOfferMap[focus]
		ItemFlavor offerFlav = GetItemFlavorFromOffer( offer.output )
		return IsItemFlavorEquippable( offerFlav )
	}

	return false
}

ItemFlavor function GetItemFlavorFromOffer( ItemFlavorBag offerBag )
{
	if ( file.mythicSkinsEnabled )
		 return ItemFlavorBag_GetMythicSkinItem( offerBag )

	return ItemFlavorBag_GetMeleeSkinItem( offerBag )
}


void function UpdateFocusStuff( var focusedOfferButtonOrNull )
{
	file.WORKAROUND_currentlyFocusedOfferButtonForFooters = focusedOfferButtonOrNull

	UpdateFooterOptions()                             
}


string function HeirloomShop_GetTabText()
{
	return file.themeStruct.tabText
}


string function HeirloomShop_GetGRXOfferLocation()
{
	return file.themeStruct.grxOfferLocation
}


vector function HeirloomShop_GetTabBGDefaultCol()
{
	return file.themeStruct.tabBGDefaultCol
}


vector function HeirloomShop_GetTabBarDefaultCol()
{
	return file.themeStruct.tabBarDefaultCol
}


vector function HeirloomShop_GetTabBGFocusedCol()
{
	return file.themeStruct.tabBGFocusedCol
}


vector function HeirloomShop_GetTabBarFocusedCol()
{
	return file.themeStruct.tabBarFocusedCol
}


vector function HeirloomShop_GetTabBGSelectedCol()
{
	return file.themeStruct.tabBGSelectedCol
}


vector function HeirloomShop_GetTabBarSelectedCol()
{
	return file.themeStruct.tabBarSelectedCol
}


asset function HeirloomShop_GetItemButtonBGImage( bool isHighlighted )
{
	return isHighlighted ? file.themeStruct.itemBtnHighlightedBGImage : file.themeStruct.itemBtnRegularBGImage
}


asset function HeirloomShop_GetItemButtonFrameImage( bool isHighlighted )
{
	return isHighlighted ? file.themeStruct.itemBtnHighlightedFrameImage : file.themeStruct.itemBtnRegularFrameImage
}


asset function HeirloomShop_GetItemButtonLowerBGDecoImage( bool isHighlighted )
{
	return isHighlighted ? file.themeStruct.itemBtnHighlightedLowerBGDecoImage : file.themeStruct.itemBtnRegularLowerBGDecoImage
}


vector function HeirloomShop_GetItemButtonBorderCol( bool isHighlighted )
{
	return isHighlighted ? file.themeStruct.itemBtnHighlightedBorderCol : file.themeStruct.itemBtnRegularBorderCol
}


asset function HeirloomShop_GetItemButtonSpecialIcon( bool isHighlighted )
{
	return isHighlighted ? file.themeStruct.itemBtnHighlightedSpecialIcon : file.themeStruct.itemBtnRegularSpecialIcon
}


asset function HeirloomShop_GetItemGroupHeaderImage( int group )
{
	return $""                                                                                                       
}


string function HeirloomShop_GetItemGroupHeaderText( int group )
{
	return ""                                                                                                       
}


vector function HeirloomShop_GetItemGroupHeaderTextColor( int group )
{
	return <1, 1, 1>                                                                                                            
}


asset function HeirloomShop_GetItemGroupBackgroundImage( int group )
{
	return $""                                                                                                   
}


asset function HeirloomShop_GetHeaderIcon()
{
	return $""                                                                      
}


bool function HeirloomShop_IsVisibleWithoutCurrency()
{
	return GetCurrentPlaylistVarBool( "heirloom_shop_visible_without_currency", true )
}

void function ToggleWeaponOrMythicSkin( var button )
{
	file.mythicSkinsEnabled = !file.mythicSkinsEnabled
	HeirloomShopPanel_UpdateGRXDependantElements()
}