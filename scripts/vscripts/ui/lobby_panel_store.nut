global function InitStorePanel
global function InitLootPanel
global function InitOffersPanel
global function InitSpecialsPanel
global function InitVCPopUp

global function OffersPanel_LevelShutdown

global function JumpToStoreTab
global function JumpToStoreSkin
global function JumpToStoreOffer
global function JumpToStorePacks
global function JumpToHeirloomShop
global function JumpToStoreSpecials

global function OpenVCPopUp
global function ToggleVCPopUp

#if DEV
global function DEV_OffersPanel_DoFakeOffers
global function DEV_OffersPanel_DoFakeLayout
#endif

enum eStoreSection
{
	SHOP,
	LOOT,
	CHARACTERS,
	CURRECNY
}

const int MAX_FEATURED_OFFERS = 2
const int MAX_EXCLUSIVE_OFFERS = 2

struct
{
	var  storePanel
	bool tabsInitialized = false
	bool storeCacheValid = false
	var  tabBar
	bool openDLCStoreCallbackCalled = false

	#if DEV
		string DEV_fakeOffers_itemRef = ""
		string DEV_fakeOffers_seasonTag = ""
		int[5] DEV_fakeOffers_columnCounts = [1, 1, 1, 1, 1]
		int[5] DEV_fakeOffers_expireTime
	#endif
} file

struct
{
	var                    panel
	var                    characterSelectInfoPanel
	var                    characterSelectInfoRui
	array<var>             buttons
	table<var, ItemFlavor> buttonToCharacter

	var allLegendsPanel

	var buttonWithFocus

	var characterDetailsPanel
	var characterDetailsRui

} s_characters


const int STORE_VC_NUM_PACKS = 6
struct VCPackDef
{
	int    entitlementId
	string priceString
	string originalPriceString
	int    price
	int    base
	int    bonus
	int    total
	asset  image = $""

	bool valid = false
}

struct
{
	bool packsInitialized = false

	array<int>   vcPackEntitlements = [PREMIUM_CURRENCY_10, PREMIUM_CURRENCY_05, PREMIUM_CURRENCY_20, PREMIUM_CURRENCY_40, PREMIUM_CURRENCY_60, PREMIUM_CURRENCY_100]
	array<int>   vcPackBase = [1000, 500, 2000, 4000, 6000, 10000]
	array<int>   vcPackBonus = [0, 0, 150, 350, 700, 1500]
	array<asset> vcPackImage = [$"rui/menu/store/store_coins_t1", $"rui/menu/store/store_coins_t0", $"rui/menu/store/store_coins_t2", $"rui/menu/store/store_coins_t3", $"rui/menu/store/store_coins_t4", $"rui/menu/store/store_coins_t5"]
	var			 vcPopUpMenu
	var			 vcPopUpPanel
	var			 vcButton

	VCPackDef[STORE_VC_NUM_PACKS] vcPacks
	
#if NX_PROG
	var	taxNoticeMessage
#endif
} s_vc

struct
{
	var lootPanel

	var lootButtonOpen

	var lootButtonPurchase
	var lootButtonPurchaseN
} s_loot


struct SeasonalStoreData
{
	string seasonTag = ""
	asset  tallImage = $""
	asset  squareImage = $""
	asset  tallFrameOverlayImage = $""
	asset  squareFrameOverlayImage = $""
	asset  specialPageHeaderImage = $""
	string specialPageHeaderTitle = ""
	vector headerOutlineOuterColor = <0,0,0>
	float  headerOutlineOuterAlpha = 0.0
	vector headerOutlineInnerColor = <0,0,0>
	float  headerOutlineInnerAlpha = 0.0
}


struct OfferButtonData
{
	int  activeOfferIndex = -1
	int  lastActiveOfferIndex = -1
	var  button
	var  buttonFade
	bool isTall

	array<GRXScriptOffer>    offerData

	void functionref(...)     stickMovedCallback
	void functionref()        wheelUpCallback
	void functionref()        wheelDownCallback

	table                    signalDummy
}


struct
{
	var offersPanel

	var                    buttonAnchor
	array<OfferButtonData> fullOfferButtonDataArray
	array<OfferButtonData> topOfferButtonDataArray
	array<OfferButtonData> bottomOfferButtonDataArray

	var featuredHeader
	var exclusiveHeader
	var specialPageHeader

	array<OfferButtonData> shopButtonDataArray

	       
	table< var, array<GRXScriptOffer> > buttonToOfferData

	table< string, SeasonalStoreData > seasonalDataMap

	var focusedOfferButton

	bool navInputCallbacksRegistered
	bool grxCallbacksRegistered
	bool isShowing
	int  lastStickState
} s_offers

#if NX_PROG
string	NXTaxString
bool	ShowNXTaxString = false
#endif

void function InitStorePanel( var panel )
{
	file.storePanel = panel

	RegisterSignal( "OffersPanel_Think" )

	SetPanelTabTitle( panel, "#STORE" )
	SetTabRightSound( panel, "UI_Menu_StoreTab_Select" )
	SetTabLeftSound( panel, "UI_Menu_StoreTab_Select" )

	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, OnStorePanel_Show )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, OnStorePanel_Hide )

	                          
	   
	  	                                                                                       
	  	                                          
	  	                                         
	  	                                                                                                         
	   

	           
	{
		var tabBody = Hud_GetChild( panel, "SpecialsPanel" )
		AddTab( panel, tabBody, "#MENU_STORE_PANEL_SPECIALS" )
	}

	         
	{
		var tabBody = Hud_GetChild( panel, "ECPanel" )
		                                                                                                       
		AddTab( panel, tabBody, "#MENU_STORE_PANEL_SHOP" )
	}

	           
	{
		var tabBody = Hud_GetChild( panel, "SeasonalPanel" )
		AddTab( panel, tabBody, "#MENU_STORE_PANEL_SEASONAL" )
	}

	             
	{
		var tabBody = Hud_GetChild( panel, "LootPanel" )
		AddTab( panel, tabBody, "#MENU_STORE_PANEL_LOOT" )
	}

	                
	                                                
	{
		var tabBody = Hud_GetChild( panel, "HeirloomShopPanel" )
		AddTab( panel, tabBody, "#MENU_STORE_PANEL_PRESTIGE_SHOP" )
	}

	                   
	{
		s_vc.vcButton = Hud_GetChild( panel, "CoinsPopUpButton" )
		Hud_AddEventHandler( s_vc.vcButton, UIE_CLICK, OpenVCPopUp )
	}
}


void function OnStorePanel_Show( var panel )
{
	SetCurrentHubForPIN( Hud_GetHudName( panel ) )
	TabData tabData = GetTabDataForPanel( panel )

	if ( !file.tabsInitialized )
	{
		SetTabNavigationEndCallback( tabData, eTabDirection.PREV, TabNavigateToLobby )
		file.tabsInitialized = true
	}

	                                                              
	DeactivateTab( tabData )
	SetTabNavigationEnabled( file.storePanel, false )

	foreach ( tabDef in GetPanelTabs( file.storePanel ) )
	{
		SetTabDefEnabled( tabDef, false )
	}

	UI_SetPresentationType( ePresentationType.WEAPON_CATEGORY )	
	
	file.storeCacheValid = false

	AddCallbackAndCallNow_OnGRXInventoryStateChanged( OnGRXStoreUpdate )
	AddCallbackAndCallNow_OnGRXOffersRefreshed( OnGRXStoreUpdate )

	thread AnimateTabBar( tabData )

	RegisterButtonPressedCallback( KEY_TAB, ToggleVCPopUp )
	RegisterButtonPressedCallback( BUTTON_BACK, ToggleVCPopUp )

	InitDLCStore()
}


void function AnimateTabBar( TabData tabData )
{
	Hud_SetY( tabData.tabPanel, Hud_GetHeight( tabData.tabPanel ) )
	Hud_ReturnToBasePosOverTime( tabData.tabPanel, 0.25, INTERPOLATOR_DEACCEL )
}


void function TabNavigateToLobby()
{
	TabData lobbyTabData = GetTabDataForPanel( GetMenu( "LobbyMenu" ) )

	                                   
	ActivateTabPrev( lobbyTabData )
}


void function OnStorePanel_Hide( var panel )
{
	TabData tabData = GetTabDataForPanel( panel )
	DeactivateTab( tabData )

	RemoveCallback_OnGRXInventoryStateChanged( OnGRXStoreUpdate )
	RemoveCallback_OnGRXOffersRefreshed( OnGRXStoreUpdate )

	DeregisterButtonPressedCallback( KEY_TAB, ToggleVCPopUp )
	DeregisterButtonPressedCallback( BUTTON_BACK, ToggleVCPopUp )

	file.storeCacheValid = false
}


void function CallDLCStoreCallback_Safe()
{
	if ( !file.openDLCStoreCallbackCalled )
	{
		file.openDLCStoreCallbackCalled = true	
		if( IsStoreEmpty() == true )
		{
			ShowDLCStoreUnavailableNotice()
			file.openDLCStoreCallbackCalled = false
			CloseActiveMenu()
		}
		else
		{
			OnOpenDLCStore()
		}
	}
}


void function OnGRXStoreUpdate()
{
	TabData tabData = GetTabDataForPanel( file.storePanel )
	int numTabs     = tabData.tabDefs.len()

	if ( !GRX_IsInventoryReady() || !GRX_AreOffersReady() )
	{
		DeactivateTab( tabData )
		SetTabNavigationEnabled( file.storePanel, false )

		foreach ( tabDef in GetPanelTabs( file.storePanel ) )
		{
			SetTabDefEnabled( tabDef, false )
		}

		Hud_SetVisible( Hud_GetChild( file.storePanel, "BusyPanel" ), true )
		
		if ( file.openDLCStoreCallbackCalled )
		{
			OnCloseDLCStore()
		}
		
		file.openDLCStoreCallbackCalled = false;
	}
	else
	{
		bool haveLootTickPurchaseOffer          = ( GetLootTickPurchaseOffer() != null )
		ItemFlavor ornull activeCollectionEvent = GetActiveCollectionEvent( GetUnixTimestamp() )
		bool haveActiveCollectionEvent          = ( activeCollectionEvent != null )
		ItemFlavor ornull activeThemedShopEvent = GetActiveThemedShopEvent( GetUnixTimestamp() )
		bool haveActiveThemedShopEvent          = ( activeThemedShopEvent != null )

		bool haveActiveHeirloomTab				= HeirloomShop_IsVisibleWithoutCurrency() || GRXCurrency_GetPlayerBalance( GetLocalClientPlayer(), GRX_CURRENCIES[GRX_CURRENCY_HEIRLOOM] ) > 0

		SetTabNavigationEnabled( file.storePanel, true )

		foreach ( TabDef tabDef in GetPanelTabs( file.storePanel ) )
		{
			bool showTab   = true
			bool enableTab = true

			if ( Hud_GetHudName( tabDef.panel ) == "ECPanel" )
			{
				tabDef.title = "#MENU_STORE_FEATURED"
			}
			else if ( Hud_GetHudName( tabDef.panel ) == "LootPanel" )
			{
				enableTab = haveLootTickPurchaseOffer
			}
			else if ( Hud_GetHudName( tabDef.panel ) == "CollectionEventPanel" || Hud_GetHudName( tabDef.panel ) == "SpecialCurrencyShopPanel" )
			{
				showTab = haveActiveCollectionEvent
				enableTab = true                                                                                          
				if ( haveActiveCollectionEvent )
				{
					expect ItemFlavor(activeCollectionEvent)

					tabDef.title = CollectionEvent_GetFrontTabText( activeCollectionEvent )

					tabDef.useCustomColors = true
					tabDef.customDefaultBGCol = CollectionEvent_GetTabBGDefaultCol( activeCollectionEvent )
					tabDef.customDefaultBarCol = CollectionEvent_GetTabBarDefaultCol( activeCollectionEvent )
					tabDef.customFocusedBGCol = CollectionEvent_GetTabBGFocusedCol( activeCollectionEvent )
					tabDef.customFocusedBarCol = CollectionEvent_GetTabBarFocusedCol( activeCollectionEvent )
					tabDef.customSelectedBGCol = CollectionEvent_GetTabBGSelectedCol( activeCollectionEvent )
					tabDef.customSelectedBarCol = CollectionEvent_GetTabBarSelectedCol( activeCollectionEvent )
				}
			}
			else if ( Hud_GetHudName( tabDef.panel ) == "HeirloomShopPanel" )
			{
				showTab = haveActiveHeirloomTab
				enableTab = haveActiveHeirloomTab

				  	                                                                       

				tabDef.useCustomColors = false
				                                                               
				                                                                 
				                                                               
				                                                                 
				                                                                 
				                                                                   
			}
			else if ( Hud_GetHudName( tabDef.panel ) == "ThemedShopPanel" )
			{
				showTab = haveActiveThemedShopEvent
				if ( haveActiveThemedShopEvent )
				{
					expect ItemFlavor(activeThemedShopEvent)

					tabDef.title = ThemedShopEvent_GetTabText( activeThemedShopEvent )

					tabDef.useCustomColors = true
					tabDef.customDefaultBGCol = ThemedShopEvent_GetTabBGDefaultCol( activeThemedShopEvent )
					tabDef.customDefaultBarCol = ThemedShopEvent_GetTabBarDefaultCol( activeThemedShopEvent )
					tabDef.customFocusedBGCol = ThemedShopEvent_GetTabBGFocusedCol( activeThemedShopEvent )
					tabDef.customFocusedBarCol = ThemedShopEvent_GetTabBarFocusedCol( activeThemedShopEvent )
					tabDef.customSelectedBGCol = ThemedShopEvent_GetTabBGSelectedCol( activeThemedShopEvent )
					tabDef.customSelectedBarCol = ThemedShopEvent_GetTabBarSelectedCol( activeThemedShopEvent )
				}
			}
			else if ( Hud_GetHudName( tabDef.panel ) == "SpecialsPanel" )
			{
				showTab = GRX_IsLocationActive( "specials" )
				enableTab = showTab
			}
			else if ( Hud_GetHudName( tabDef.panel ) == "SeasonalPanel" )
			{
				showTab = GRX_IsLocationActive( "seasonal" )
				enableTab = showTab
			}

			SetTabDefVisible( tabDef, showTab )
			SetTabDefEnabled( tabDef, enableTab )
		}

		int activeIndex = tabData.activeTabIdx
		if ( !file.storeCacheValid && GetLastMenuNavDirection() == MENU_NAV_FORWARD )
			activeIndex = 0

		while( (!IsTabIndexEnabled( tabData, activeIndex ) || !IsTabIndexVisible( tabData, activeIndex )) && activeIndex < numTabs )
			activeIndex++

		if ( !IsTabActive( tabData ) )
			ActivateTab( tabData, activeIndex )

		file.storeCacheValid = true

		UpdateLootTickTabNewness()

		Hud_SetVisible( Hud_GetChild( file.storePanel, "BusyPanel" ), false )

		if ( GetActiveMenu() == s_vc.vcPopUpMenu )
			CallDLCStoreCallback_Safe()
	}
}


void function UpdateLootTickTabNewness()
{
	if ( !GRX_IsInventoryReady() )
		return

	int packCount = GRX_GetTotalPackCount()
}




  

                                                                                                                                                                                                                                                                                                                            
                                                                                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                                           
                                                                                                                                                                                                                                                                                                            
                                                                                                                                                                                                                                                                                                                                 
                                                                                                                                                                                                                                                                                                               


  

                       
void function InitVCPopUp( var newMenuArg )
{
	s_vc.vcPopUpMenu = newMenuArg

	SetPopup( newMenuArg, true )

	AddMenuEventHandler( newMenuArg, eUIEvent.MENU_OPEN, OnOpenVCPopUp )
	AddMenuEventHandler( newMenuArg, eUIEvent.MENU_CLOSE, OnCloseVCPopUp )
	s_vc.vcPopUpPanel = Hud_GetChild( newMenuArg, "StoreVCPopup" )

	for ( int index = 0; index < STORE_VC_NUM_PACKS; index++ )
	{
		var vcButton
		                                                                                
		if ( index == 0 )
		{
			vcButton  = Hud_GetChild( s_vc.vcPopUpPanel, "VCButton1Tall" )
			var vcRui = Hud_GetRui( vcButton )

			RuiSetString( vcRui, "vcOriginalPrice", GetVCPackOriginalPriceString( index ) )
			RuiSetString( vcRui, "vcPrice", GetVCPackPriceString( index ) )
			RuiSetString( vcRui, "totalValueDesc", "" )
			RuiSetString( vcRui, "baseValueDesc", "" )
			RuiSetString( vcRui, "bonusDesc", "" )

			RuiSetImage( vcRui, "vcImage", GetVCPackImage( index, true ) )

			Hud_AddEventHandler( vcButton, UIE_CLICK, OnVCButtonActivate )
		}
		           

		vcButton  = Hud_GetChild( s_vc.vcPopUpPanel, "VCButton" + (index + 1) )
		var vcRui = Hud_GetRui( vcButton )

		RuiSetString( vcRui, "vcOriginalPrice", GetVCPackOriginalPriceString( index ) )
		RuiSetString( vcRui, "vcPrice", GetVCPackPriceString( index ) )
		RuiSetString( vcRui, "totalValueDesc", "" )
		RuiSetString( vcRui, "baseValueDesc", "" )
		RuiSetString( vcRui, "bonusDesc", "" )

		RuiSetImage( vcRui, "vcImage", GetVCPackImage( index, false ) )

		Hud_AddEventHandler( vcButton, UIE_CLICK, OnVCButtonActivate )
	}

	#if NX_PROG
		s_vc.taxNoticeMessage = Hud_GetChild( s_vc.vcPopUpPanel, "TaxNoticeMessage" )
	#endif

	AddMenuFooterOption( newMenuArg, LEFT, BUTTON_B, true, "#B_BUTTON_CLOSE", "#B_BUTTON_CLOSE" )
}

void function OpenVCPopUp( var button )
{
	if ( GetActiveMenu() != s_vc.vcPopUpMenu )
		AdvanceMenu( GetMenu( "VCPopUp" ) )
}

void function ToggleVCPopUp( var button )
{
	if ( GetActiveMenu() == s_vc.vcPopUpMenu )
	{
		CloseActiveMenu()
		return
	}

	AdvanceMenu( GetMenu( "VCPopUp" ) )
}

void function CloseVCPopUp()
{
	if ( GetActiveMenu() == s_vc.vcPopUpMenu )
		CloseActiveMenu()
}

void function OnOpenVCPopUp()
{
	#if NX_PROG

		if ( IsStoreBlocked() )
		{
			ConfirmDialogData dialogData
			dialogData.headerText = "Switch Blocked from EShop Access"
			dialogData.messageText = "Contact QA Leads to get on eShop whitelist"
			dialogData.contextImage = $"ui/menu/common/dialog_notice"

			OpenOKDialogFromData( dialogData )
		}

		ShowNXTaxString = GetNXShowTaxString()
		if( ShowNXTaxString )
		{
			NXTaxString = GetNXTaxString()
			Hud_SetVisible( s_vc.taxNoticeMessage, true )
			Hud_SetText( s_vc.taxNoticeMessage, NXTaxString )
		}
		else
		{
			Hud_SetVisible( s_vc.taxNoticeMessage, false )
		}
	#endif

	thread VCPanel_Think( s_vc.vcPopUpPanel )
}

void function OnCloseVCPopUp()
{

#if PS5_PROG	
	                                                                             
	                                                                        
	                                                                                         
	TabData tabData = GetTabDataForPanel( file.storePanel )
	
	var activeTabPanel = tabData.tabDefs[tabData.activeTabIdx].panel
	
	if( Hud_GetHudName( activeTabPanel ) != "SKUShopPanel" )
#endif		
	{
		OnCloseDLCStore()
		file.openDLCStoreCallbackCalled = false
	}
	
	if ( ShouldShowPremiumCurrencyDialog() )
		ShowPremiumCurrencyDialog( false )
}

void function VCPanel_Think( var panel )
{
	while ( GetActiveMenu() == s_vc.vcPopUpMenu )
	{
		if ( IsDLCStoreInitialized() )
		{
			CallDLCStoreCallback_Safe()
			InitVCPacks( panel )
		}
		else
		{
			InitDLCStore()
		}

		var discountPanel = Hud_GetChild( panel, "DiscountPanel" )
		Hud_SetVisible( discountPanel, Script_UserHasEAAccess() )
		#if PC_PROG
			HudElem_SetRuiArg( discountPanel, "discountImage", $"rui/menu/common/ea_access_pc", eRuiArgType.IMAGE )
		#else
			HudElem_SetRuiArg( discountPanel, "discountImage", $"rui/menu/common/ea_access", eRuiArgType.IMAGE )
			#if DURANGO_PROG
				HudElem_SetRuiArg( discountPanel, "discountText", "" )
			#endif
		#endif

		WaitFrame()
	}
}


void function InitVCPacks( var panel )
{
	if ( s_vc.packsInitialized )
		return

	s_vc.packsInitialized = true

	array<int> vcPriceInts               = GetEntitlementPricesAsInt( s_vc.vcPackEntitlements )
	array<string> vcPriceStrings         = GetEntitlementPricesAsStr( s_vc.vcPackEntitlements )
	array<string> vcOriginalPriceStrings = GetEntitlementOriginalPricesAsStr( s_vc.vcPackEntitlements )

	                          
	bool useOldVCLayout = false
	if ( IsConnected() )
		useOldVCLayout = GetCurrentPlaylistVarBool( "use_old_vc_layout", false )

	for ( int vcPackIndex = 0; vcPackIndex < STORE_VC_NUM_PACKS; vcPackIndex++ )
	{
		                                                                
		if ( vcPackIndex == 1 && useOldVCLayout )
			continue

		VCPackDef vcPack = s_vc.vcPacks[vcPackIndex]

		vcPack.entitlementId = s_vc.vcPackEntitlements[vcPackIndex]
		vcPack.price = vcPriceInts[vcPackIndex]
		vcPack.priceString = vcPriceStrings[vcPackIndex]
		vcPack.originalPriceString = vcOriginalPriceStrings[vcPackIndex]
		vcPack.image = ( useOldVCLayout && vcPackIndex == 0 ) ? $"rui/menu/store/store_coins_t1_tall" : s_vc.vcPackImage[vcPackIndex]
		vcPack.base = s_vc.vcPackBase[vcPackIndex]
		vcPack.bonus = s_vc.vcPackBonus[vcPackIndex]
		vcPack.total = vcPack.base + vcPack.bonus

		vcPack.valid = vcPack.priceString != ""

		if ( !vcPack.valid )
			continue

		var vcButton
		if ( useOldVCLayout )
		{
			if ( vcPackIndex == 0 )
			{
				Hud_SetVisible( Hud_GetChild( panel, "VCButton1" ), false )
				Hud_SetVisible( Hud_GetChild( panel, "VCButton2" ), false )

				vcButton = Hud_GetChild( panel, "VCButton1Tall" )
				Hud_SetVisible( vcButton, true )
				Hud_SetNavRight( vcButton, Hud_GetChild( panel, "VCButton3" ) )
			}
			else if ( vcPackIndex == 1 )
			{
				vcButton = Hud_GetChild( panel, "VCButton" + (vcPackIndex + 1) )
				Hud_SetVisible( vcButton, false )
				continue
			}
			else if ( vcPackIndex == 2 )
			{
				vcButton = Hud_GetChild( panel, "VCButton" + (vcPackIndex + 1) )
				Hud_SetNavLeft( vcButton, Hud_GetChild( panel, "VCButton1Tall" ) )
			}
			else
			{
				vcButton = Hud_GetChild( panel, "VCButton" + (vcPackIndex + 1) )
			}
		}
		else
		{
			vcButton = Hud_GetChild( panel, "VCButton" + (vcPackIndex + 1) )
		}

		var vcRui    = Hud_GetRui( vcButton )

		RuiSetString( vcRui, "vcOriginalPrice", GetVCPackOriginalPriceString( vcPackIndex ) )
		RuiSetString( vcRui, "vcPrice", GetVCPackPriceString( vcPackIndex ) )
		RuiSetString( vcRui, "totalValueDesc", GetVCPackTotalString( vcPackIndex ) )
		RuiSetString( vcRui, "baseValueDesc", GetVCPackBonusBaseString( vcPackIndex ) )
		RuiSetString( vcRui, "bonusDesc", GetVCPackBonusAddString( vcPackIndex ) )

		RuiSetImage( vcRui, "vcImage", GetVCPackImage( vcPackIndex, useOldVCLayout ) )

		                                          
		                                          
		Hud_SetEnabled( vcButton, true )
		Hud_SetLocked( vcButton, false )
	}
}


void function OnVCButtonActivate( var button )
{
	int vcPackIndex = int( Hud_GetScriptID( button ) )

	if ( Hud_IsLocked( button ) )
	{
		EmitUISound( "menu_deny" )
		return
	}

	#if PC_PROG
		if ( !PCPlat_IsOverlayAvailable() )
		{
			string platname = PCPlat_IsOrigin() ? "ORIGIN" : "STEAM"
			ConfirmDialogData dialogData
			dialogData.headerText = ""
			dialogData.messageText = "#" + platname + "_INGAME_REQUIRED"
			dialogData.contextImage = $"ui/menu/common/dialog_notice"

			OpenOKDialogFromData( dialogData )
			return
		}

		if ( !MeetsAgeRequirements() )
		{
			ConfirmDialogData dialogData
			dialogData.headerText = "#UNAVAILABLE"
			dialogData.messageText = "#ORIGIN_UNDERAGE_STORE"
			dialogData.contextImage = $"ui/menu/common/dialog_notice"

			OpenOKDialogFromData( dialogData )
			return
		}
	#endif

	PurchaseEntitlement( s_vc.vcPacks[vcPackIndex].entitlementId )
}


string function GetVCPackPriceString( int vcPackIndex )
{
	if ( s_vc.vcPacks[vcPackIndex].priceString == "" )
		return Localize( "#UNAVAILABLE" )

	return s_vc.vcPacks[vcPackIndex].priceString
}


string function GetVCPackOriginalPriceString( int vcPackIndex )
{
	return s_vc.vcPacks[vcPackIndex].originalPriceString
}


string function GetVCPackTotalString( int vcPackIndex )
{
	return GetFormattedValueForCurrency( s_vc.vcPacks[vcPackIndex].base + s_vc.vcPacks[vcPackIndex].bonus, GRX_CURRENCY_PREMIUM )
}


string function GetVCPackBonusBaseString( int vcPackIndex )
{
	                                         
	  	         

	return Localize( "#STORE_VC_BONUS_BASE", FormatAndLocalizeNumber( "1", float( s_vc.vcPacks[vcPackIndex].base ), true ) )
}


string function GetVCPackBonusAddString( int vcPackIndex )
{
	if ( !s_vc.vcPacks[vcPackIndex].bonus )
		return ""

	return Localize( "#STORE_VC_BONUS_ADD", FormatAndLocalizeNumber( "1", float( s_vc.vcPacks[vcPackIndex].bonus ), true ) )
}


int function GetVCPackBase( int vcPackIndex )
{
	return s_vc.vcPacks[vcPackIndex].base
}


int function GetVCPackTotal( int vcPackIndex )
{
	return s_vc.vcPacks[vcPackIndex].base + s_vc.vcPacks[vcPackIndex].bonus
}


int function GetVCPackBonus( int vcPackIndex )
{
	return s_vc.vcPacks[vcPackIndex].bonus
}


int function GetVCPackPrice( int vcPackIndex )
{
	return s_vc.vcPacks[vcPackIndex].price
}


asset function GetVCPackImage( int vcPackIndex, bool useOldVCLayout )
{
	return ( useOldVCLayout && vcPackIndex == 0 ) ? $"rui/menu/store/store_coins_t1_tall" : s_vc.vcPackImage[vcPackIndex]
}

  

                                                                                                                                                                         
                                                                                                                                                                                     
                                                                                                                                      
                                                                                                                                      
                                                                                                                                                                     
                                                                                                                                                           


  

void function InitLootPanel( var panel )
{
	var lootPanelA = Hud_GetChild( panel, "LootPanelA" )
	  	                                                               
	  	                                                                  
	                                                                                                             

	s_loot.lootPanel = Hud_GetChild( lootPanelA, "PanelContent" )
	HudElem_SetRuiArg( s_loot.lootPanel, "titleText", Localize( "#RARE_LOOT_TICK" ) )
	HudElem_SetRuiArg( s_loot.lootPanel, "descText", Localize( "#CONTAINS_3_ITEMS" ) )

	HudElem_SetRuiArg( s_loot.lootPanel, "bulletText1", Localize( "#LOOT_CATEGORY_1" ) )
	HudElem_SetRuiArg( s_loot.lootPanel, "bulletText2", Localize( "#LOOT_CATEGORY_2" ) )
	HudElem_SetRuiArg( s_loot.lootPanel, "bulletText3", Localize( "#LOOT_CATEGORY_3" ) )
	HudElem_SetRuiArg( s_loot.lootPanel, "bulletText4", Localize( "#LOOT_CATEGORY_4" ) )
	HudElem_SetRuiArg( s_loot.lootPanel, "bulletText5", Localize( "#LOOT_CATEGORY_5" ) )
	HudElem_SetRuiArg( s_loot.lootPanel, "bulletText6", Localize( "#LOOT_CATEGORY_6" ) )
	HudElem_SetRuiArg( s_loot.lootPanel, "bulletText7", Localize( "#LOOT_CATEGORY_7" ) )
	HudElem_SetRuiArg( s_loot.lootPanel, "bulletText8", Localize( "#LOOT_CATEGORY_8" ) )
	HudElem_SetRuiArg( s_loot.lootPanel, "bulletText9", Localize( "#LOOT_CATEGORY_9" ) )
	HudElem_SetRuiArg( s_loot.lootPanel, "bulletText10", Localize( "#LOOT_CATEGORY_10" ) )
	HudElem_SetRuiArg( s_loot.lootPanel, "bulletText11", Localize( "#LOOT_CATEGORY_11" ) )
	HudElem_SetRuiArg( s_loot.lootPanel, "bulletText12", Localize( "#LOOT_CATEGORY_12" ) )

	HudElem_SetRuiArg( s_loot.lootPanel, "rarityBulletText1", Localize( "#LOOT_RARITY_CHANCE_1" ) )
	HudElem_SetRuiArg( s_loot.lootPanel, "rarityBulletText2", Localize( "#LOOT_RARITY_CHANCE_2" ) )
	HudElem_SetRuiArg( s_loot.lootPanel, "rarityBulletText3", Localize( "#LOOT_RARITY_CHANCE_3" ) )
	HudElem_SetRuiArg( s_loot.lootPanel, "rarityPercentText1", Localize( "#LOOT_RARITY_PERCENT_1" ) )
	HudElem_SetRuiArg( s_loot.lootPanel, "rarityPercentText2", Localize( "#LOOT_RARITY_PERCENT_2" ) )
	HudElem_SetRuiArg( s_loot.lootPanel, "rarityPercentText3", Localize( "#LOOT_RARITY_PERCENT_3" ) )

	HudElem_SetRuiArg( s_loot.lootPanel, "featureBulletText1", Localize( "#LOOT_FEATURE_1" ) )
	HudElem_SetRuiArg( s_loot.lootPanel, "featureBulletText2", Localize( "#LOOT_FEATURE_2" ) )
	HudElem_SetRuiArg( s_loot.lootPanel, "featureBulletText3", Localize( "#LOOT_FEATURE_3" ) )
	HudElem_SetRuiArg( s_loot.lootPanel, "featureBulletText4", Localize( "#LOOT_FEATURE_4" ) )
	HudElem_SetRuiArg( s_loot.lootPanel, "featureBulletText5", Localize( "#LOOT_FEATURE_5" ) )

	s_loot.lootButtonOpen = Hud_GetChild( panel, "OpenOwnedButton" )
	HudElem_SetRuiArg( s_loot.lootButtonOpen, "buttonText", "#ACTIVATE_APEX_PACK" )
	HudElem_SetRuiArg( s_loot.lootButtonOpen, "descText", "" )

	s_loot.lootButtonPurchase = Hud_GetChild( lootPanelA, "PurchaseButton" )
	s_loot.lootButtonPurchaseN = Hud_GetChild( lootPanelA, "PurchaseButtonN" )

	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, LootPanel_OnShow )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, LootPanel_OnHide )

	Hud_AddEventHandler( s_loot.lootButtonOpen, UIE_CLICK, OpenLootBoxButton_OnActivate )

	Hud_AddEventHandler( s_loot.lootButtonPurchase, UIE_CLICK, LootTickPurchaseButton_Activate )
	Hud_AddEventHandler( s_loot.lootButtonPurchaseN, UIE_CLICK, LootTickPurchaseButton_Activate )

	AddPanelFooterOption( panel, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
}


void function LootPanel_OnShow( var panel )
{
	SetCurrentTabForPIN( Hud_GetHudName( panel ) )
	AddCallbackAndCallNow_OnGRXInventoryStateChanged( UpdateLootTickButtons )
	UI_SetPresentationType( ePresentationType.WEAPON_CATEGORY )
}


void function LootPanel_OnHide( var panel )
{
	RemoveCallback_OnGRXInventoryStateChanged( UpdateLootTickButtons )
}


void function OpenLootBoxButton_OnActivate( var button )
{
	if ( Hud_IsLocked( button ) )
		return

	AdvanceMenu( GetMenu( "LootBoxOpen" ) )
}


GRXScriptOffer ornull function GetLootTickPurchaseOffer()
{
	ItemFlavor lootTick          = GetItemFlavorByAsset( $"settings/itemflav/pack/cosmetic_rare.rpak" )
	array<GRXScriptOffer> offers = GRX_GetItemDedicatedStoreOffers( lootTick, "loot" )
	return offers.len() > 0 ? offers[0] : null
}


void function UpdateLootTickButtons()
{
	UpdateLootTickButton( s_loot.lootButtonPurchase, 1 )
	UpdateLootTickButton( s_loot.lootButtonPurchaseN, GetCurrentPlaylistVarInt( "loot_tick_purchase_max", 10 ) )

	UpdateLootBoxButton( s_loot.lootButtonOpen )
}


void function UpdateLootTickButton( var button, int quantity )
{
	HudElem_SetRuiArg( button, "buttonText", "#PURCHASE" )

	bool purchaseLock   = false
	string purchaseDesc = ""
	if ( GRX_IsInventoryReady() && GRX_AreOffersReady() )
	{
		GRXScriptOffer ornull offer = GetLootTickPurchaseOffer()
		if ( offer != null )
		{
			expect GRXScriptOffer( offer )
			purchaseDesc = Localize( "#STORE_PURCHASE_N_FOR_N", quantity, GRX_GetFormattedPrice( offer.prices[0], quantity ) )
			ItemFlavor lootTickFlavor = offer.output.flavors[0]                         

			purchaseLock = false                                             
		}
		else
		{
			purchaseLock = true
		}
	}
	else
	{
		purchaseLock = true
	}

	Hud_SetLocked( button, purchaseLock )
	HudElem_SetRuiArg( button, "descText", purchaseDesc )
}


void function LootTickPurchaseButton_Activate( var button )
{
	if ( Hud_IsLocked( button ) )
		return

	GRXScriptOffer ornull offer = GetLootTickPurchaseOffer()
	if ( offer == null )
	{
		EmitUISound( "menu_deny" )
		return
	}
	expect GRXScriptOffer(offer)

	int quantity = 1
	if ( int( Hud_GetScriptID( button ) ) != 0 )
		quantity = GetCurrentPlaylistVarInt( "loot_tick_purchase_max", 10 )

	PurchaseDialogConfig pdc
	pdc.offer = offer
	pdc.quantity = quantity
	pdc.markAsNew = false
	pdc.onPurchaseResultCallback = OnLootTickPurchaseResult
	PurchaseDialog( pdc )
}


void function OnLootTickPurchaseResult( bool wasSuccessful )
{
	if ( wasSuccessful )
	{
		UpdateLootTickButtons()
	}
}



  

       

  

array<OfferButtonData> function GetButtonOfferData( array<var> buttons, array<var> buttonFades, bool isTall )
{
	array<OfferButtonData> offerButtonDataArray

	Assert( buttons.len() == buttonFades.len() )

	foreach ( var button in buttons )
	{
		OfferButtonData offerButtonData
		offerButtonData.button = button
		offerButtonData.isTall = isTall

		foreach ( buttonFade in buttonFades )
		{
			if ( Hud_GetScriptID( buttonFade ) == Hud_GetScriptID( button ) )
			{
				offerButtonData.buttonFade = buttonFade
				RuiSetBool( Hud_GetRui( buttonFade ), "isFade", true )
			}
		}

		offerButtonDataArray.append( offerButtonData )

		offerButtonData.stickMovedCallback = void function( ... ) : ( offerButtonData )
		{
			OfferButton_OnStickMoved( offerButtonData, expect float( vargv[1] ) )
		}

		offerButtonData.wheelUpCallback = void function() : ( offerButtonData )
		{
			ChangeOfferPageToLeft( offerButtonData )
		}

		offerButtonData.wheelDownCallback = void function() : ( offerButtonData )
		{
			ChangeOfferPageToRight( offerButtonData )
		}
	}

	return offerButtonDataArray
}


void function InitOffersPanel( var panel )
{
	RegisterSignal( "EndAutoAdvanceOffers" )

	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, OffersPanel_OnShow )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, OffersPanel_OnHide )

	AddPanelFooterOption( panel, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )

	AddPanelFooterOption( panel, LEFT, BUTTON_Y, true, "#Y_BUTTON_REDEEM_CODE", "#REDEEM_CODE_TEXT", void function( var button ) : () {
		AdvanceMenu( GetMenu( "CodeRedemptionDialog" ) )
	} )
}

void function InitSpecialsPanel( var panel )
{
	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, OffersPanel_OnShow )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, OffersPanel_OnHide )
	AddPanelFooterOption( panel, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
}

void function OffersPanel_OnShow( var panel )
{
	RemoveOfferPanelCallbacks()
	SetCurrentTabForPIN( Hud_GetHudName( panel ) )
	s_offers.offersPanel = panel

	s_offers.buttonAnchor = Hud_GetChild( panel, "ButtonAnchor" )

	s_offers.featuredHeader = Hud_GetChild( panel, "LeftHeader" )
	s_offers.exclusiveHeader = Hud_GetChild( panel, "RightHeader" )
	s_offers.specialPageHeader = Hud_GetChild( panel, "SpecialPageHeader" )

	if ( Hud_GetHudName( panel ) == "SpecialsPanel" )
	{
		ItemFlavor ornull activeThemedShopEvent = GetActiveThemedShopEvent( GetUnixTimestamp() )
		if( activeThemedShopEvent != null )
		{
			expect ItemFlavor( activeThemedShopEvent )
			RuiSetString( Hud_GetRui( Hud_GetChild( panel, "LeftHeader" ) ), "titleText", ThemedShopEvent_GetItemGroupHeaderText( activeThemedShopEvent, 1 ) )
			RuiSetString( Hud_GetRui( Hud_GetChild( panel, "RightHeader" ) ), "titleText", ThemedShopEvent_GetItemGroupHeaderText( activeThemedShopEvent, 2 ) )
		}
	}
	else
	{
		RuiSetString( Hud_GetRui( Hud_GetChild( panel, "LeftHeader" ) ), "titleText", "#MENU_STORE_FEATURED" )
		RuiSetString( Hud_GetRui( Hud_GetChild( panel, "RightHeader" ) ), "titleText", "#MENU_STORE_EXCLUSIVE" )
	}

	s_offers.fullOfferButtonDataArray = GetButtonOfferData( GetPanelElementsByClassname( panel, "FullOfferButton" ), GetPanelElementsByClassname( panel, "FullOfferButtonFade" ), true )
	s_offers.topOfferButtonDataArray = GetButtonOfferData( GetPanelElementsByClassname( panel, "TopOfferButton" ), GetPanelElementsByClassname( panel, "TopOfferButtonFade" ), false )
	s_offers.bottomOfferButtonDataArray = GetButtonOfferData( GetPanelElementsByClassname( panel, "BottomOfferButton" ), GetPanelElementsByClassname( panel, "BottomOfferButtonFade" ), false )

	s_offers.shopButtonDataArray.clear()
	s_offers.shopButtonDataArray.extend( s_offers.fullOfferButtonDataArray )
	s_offers.shopButtonDataArray.extend( s_offers.topOfferButtonDataArray )
	s_offers.shopButtonDataArray.extend( s_offers.bottomOfferButtonDataArray )

	AddOfferPanelCallbacks()

	UI_SetPresentationType( ePresentationType.WEAPON_CATEGORY )

	thread OffersPanel_Think( panel )
	thread OfferButton_AutoAdvanceOffers()

	s_offers.isShowing = true
}


void function OffersPanel_OnHide( var panel )
{
	RemoveOfferPanelCallbacks()
	s_offers.fullOfferButtonDataArray.clear()
	s_offers.topOfferButtonDataArray.clear()
	s_offers.bottomOfferButtonDataArray.clear()
	s_offers.shopButtonDataArray.clear()

	s_offers.isShowing = false

	Signal( uiGlobal.signalDummy, "EndAutoAdvanceOffers" )
}

void function AddOfferPanelCallbacks()
{
	if( s_offers.grxCallbacksRegistered )
		return

	AddCallbackAndCallNow_OnGRXInventoryStateChanged( UpdateOffersPanel )
	AddCallback_OnGRXOffersRefreshed( UpdateOffersPanel )

	for ( int index = 0; index < s_offers.shopButtonDataArray.len(); index++ )
	{
		Hud_AddEventHandler( s_offers.shopButtonDataArray[index].button, UIE_CLICK, OfferButton_OnActivate )
		Hud_AddEventHandler( s_offers.shopButtonDataArray[index].button, UIE_GET_FOCUS, OfferButton_OnGetFocus )
		Hud_AddEventHandler( s_offers.shopButtonDataArray[index].button, UIE_LOSE_FOCUS, OfferButton_OnLoseFocus )
		Hud_SetEnabled( s_offers.shopButtonDataArray[index].button, false )
	}
	s_offers.grxCallbacksRegistered = true
}

void function RemoveOfferPanelCallbacks()
{
	if( IsValid( s_offers.focusedOfferButton ) )
		OfferButton_RemoveCallbacks( s_offers.focusedOfferButton )

	if( !s_offers.grxCallbacksRegistered )
		return

	RemoveCallback_OnGRXInventoryStateChanged( UpdateOffersPanel )
	RemoveCallback_OnGRXOffersRefreshed( UpdateOffersPanel )

	for ( int index = 0; index < s_offers.shopButtonDataArray.len(); index++ )
	{
		Hud_RemoveEventHandler( s_offers.shopButtonDataArray[index].button, UIE_CLICK, OfferButton_OnActivate )
		Hud_RemoveEventHandler( s_offers.shopButtonDataArray[index].button, UIE_GET_FOCUS, OfferButton_OnGetFocus )
		Hud_RemoveEventHandler( s_offers.shopButtonDataArray[index].button, UIE_LOSE_FOCUS, OfferButton_OnLoseFocus )
	}
	s_offers.grxCallbacksRegistered = false
}

void function OffersPanel_LevelShutdown()
{
	if ( s_offers.isShowing )
		OffersPanel_OnHide( s_offers.offersPanel )
}

void function UpdateOffersPanel()
{
	if ( GRX_IsInventoryReady() )
	{
		if ( GRX_AreOffersReady() )
		{
			if( GRX_HasUpToDateBundleOffers() )
			{
				UpdateBundleOffers()
			}
			InitOffers()
		}
		else
		{
			ClearOffers()
		}
	}
	else
	{
		foreach ( OfferButtonData buttonData in s_offers.shopButtonDataArray )
		{
			Hud_SetEnabled( buttonData.button, false )
			Hud_SetVisible( buttonData.button, false )
		}
	}
}

void function UpdateBundleOffers()
{
	foreach( OfferButtonData buttonData in s_offers.shopButtonDataArray )
	{
		foreach( GRXScriptOffer offer in buttonData.offerData )
		{
			GRX_CheckBundleAndUpdateOfferPrices( offer )
		}
	}
}


void function OffersPanel_Think( var panel )
{
	Signal( uiGlobal.signalDummy, "OffersPanel_Think" )
	EndSignal( uiGlobal.signalDummy, "OffersPanel_Think" )

	var menu = GetParentMenu( panel )
	while ( GetActiveMenu() == menu && uiGlobal.activePanels.contains( panel ) )
	{
		UpdateOffersPanel()

		wait 1.0
	}
}


void function InitOffers()
{
	var dataTable = GetDataTable( $"datatable/seasonal_store_data.rpak" )
	for ( int i = 0; i < GetDataTableRowCount( dataTable ); i++ )
	{
		string seasonTag               = GetDataTableString( dataTable, i, GetDataTableColumnByName( dataTable, "seasonTag" ) ).tolower()
		asset tallImage                = GetDataTableAsset( dataTable, i, GetDataTableColumnByName( dataTable, "tallImage" ) )
		asset squareImage              = GetDataTableAsset( dataTable, i, GetDataTableColumnByName( dataTable, "squareImage" ) )
		asset tallFrameOverlayImage    = GetDataTableAsset( dataTable, i, GetDataTableColumnByName( dataTable, "tallFrameOverlay" ) )
		asset squareFrameOverlayImage  = GetDataTableAsset( dataTable, i, GetDataTableColumnByName( dataTable, "squareFrameOverlay" ) )
		asset specialPageHeaderImage   = GetDataTableAsset( dataTable, i, GetDataTableColumnByName( dataTable, "specialPageHeaderImage" ) )
		string specialPageHeaderTitle  = GetDataTableString( dataTable, i, GetDataTableColumnByName( dataTable, "specialPageHeaderTitle" ) )
		vector headerOutlineOuterColor = GetDataTableVector( dataTable, i, GetDataTableColumnByName( dataTable, "headerOutlineOuterColor" ) )
		float  headerOutlineOuterAlpha = GetDataTableFloat( dataTable, i, GetDataTableColumnByName( dataTable, "headerOutlineOuterAlpha" ) )
		vector headerOutlineInnerColor = GetDataTableVector( dataTable, i, GetDataTableColumnByName( dataTable, "headerOutlineInnerColor" ) )
		float  headerOutlineInnerAlpha = GetDataTableFloat( dataTable, i, GetDataTableColumnByName( dataTable, "headerOutlineInnerAlpha" ) )

		SeasonalStoreData seasonalStoreData
		seasonalStoreData.seasonTag = seasonTag
		seasonalStoreData.tallImage = tallImage
		seasonalStoreData.squareImage = squareImage
		seasonalStoreData.tallFrameOverlayImage = tallFrameOverlayImage
		seasonalStoreData.squareFrameOverlayImage = squareFrameOverlayImage
		seasonalStoreData.specialPageHeaderImage = specialPageHeaderImage
		seasonalStoreData.specialPageHeaderTitle = specialPageHeaderTitle
		seasonalStoreData.headerOutlineOuterColor = headerOutlineOuterColor
		seasonalStoreData.headerOutlineOuterAlpha = headerOutlineOuterAlpha
		seasonalStoreData.headerOutlineInnerColor = headerOutlineInnerColor
		seasonalStoreData.headerOutlineInnerAlpha = headerOutlineInnerAlpha

		s_offers.seasonalDataMap[seasonTag] <- seasonalStoreData
	}

	bool isSpecialPageHeaderDataValid = false
	asset specialPageHeaderImage      = $""
	string specialPageHeaderTitle     = ""
	vector headerOutlineOuterColor    = <0,0,0>
	float  headerOutlineOuterAlpha    = 0.0
	vector headerOutlineInnerColor    = <0,0,0>
	float  headerOutlineInnerAlpha    = 0.0

	const int LAYOUT_NONE = 0
	const int LAYOUT_TALL = 1
	const int LAYOUT_SHORT = 2

	int[5] layout
	int numTallColumns = 0
	int numShortColumns = 0
	int numBlankColumns = 0
	int storeLocation = GetStoreLocationFromPanel( s_offers.offersPanel )
	for ( int col = 0; col < 5; col++ )
	{
		OfferButton_SetVisible( s_offers.fullOfferButtonDataArray[col], false )
		OfferButton_SetVisible( s_offers.topOfferButtonDataArray[col], false )
		OfferButton_SetVisible( s_offers.bottomOfferButtonDataArray[col], false )
		Hud_SetLocked( s_offers.fullOfferButtonDataArray[col].button, false )
		Hud_SetLocked( s_offers.topOfferButtonDataArray[col].button, false )
		Hud_SetLocked( s_offers.bottomOfferButtonDataArray[col].button, false )

		int numRows = GRX_GetStoreOfferColumnNumRows( col, storeLocation )

		array<GRXScriptOffer> topRowOffers    = GRX_GetStoreOfferColumn( col, 0, storeLocation )
		array<GRXScriptOffer> bottomRowOffers = GRX_GetStoreOfferColumn( col, 1, storeLocation )

		#if DEV
			if ( file.DEV_fakeOffers_itemRef != "" )
			{
				topRowOffers = []
				bottomRowOffers = []
				numRows = 0

				array<GRXScriptOffer> fakeOffers
				for ( int fakeOfferIdx = 0; fakeOfferIdx < file.DEV_fakeOffers_columnCounts[col]; fakeOfferIdx++ )
				{
					ItemFlavor flav = GetItemFlavorByHumanReadableRef( file.DEV_fakeOffers_itemRef )
					GRXScriptOffer fakeOffer
					fakeOffer.output.flavors = [flav]
					fakeOffer.output.quantities = [1]
					fakeOffer.prices = [ MakeItemFlavorBag( { [GetItemFlavorByHumanReadableRef( "grx_currency_premium" )] = 550, } ) ]
					fakeOffer.titleText = ItemFlavor_GetLongName( flav )
					fakeOffer.descText = ItemFlavor_GetTypeName( flav )
					fakeOffer.image = ItemFlavor_GetIcon( flav )
					fakeOffer.imageRef = ""
					fakeOffer.tagText = "banana"
					fakeOffer.seasonTag = file.DEV_fakeOffers_seasonTag                                           
					fakeOffer.originalPrice = MakeItemFlavorBag( { [GetItemFlavorByHumanReadableRef( "grx_currency_premium" )] = 700, } )
					fakeOffer.expireTime = int( ceil( GetUnixTimestamp() / 1000.0 ) * 1000.0 )
					                                                  
					fakeOffers.append( fakeOffer )

					if ( IsEven( fakeOfferIdx ) )
						topRowOffers.append( fakeOffer )
					else
						bottomRowOffers.append( fakeOffer )
				}

				if ( topRowOffers.len() > 0 )
					numRows++

				if ( bottomRowOffers.len() > 0 )
					numRows++
			}
		#endif

		array<GRXScriptOffer> allColumnOffers
		allColumnOffers.extend( topRowOffers )
		allColumnOffers.extend( bottomRowOffers )

		foreach ( GRXScriptOffer offerData in allColumnOffers )
		{
			string seasonTag = offerData.seasonTag in s_offers.seasonalDataMap ? offerData.seasonTag : "default"

			if ( isSpecialPageHeaderDataValid )
			{
				if ( s_offers.seasonalDataMap[seasonTag].specialPageHeaderImage != specialPageHeaderImage )
				{
					Warning( "Mismatched store special page header images: \"%s\", \"%s\"", string(specialPageHeaderImage), string(s_offers.seasonalDataMap[seasonTag].specialPageHeaderImage) )
					specialPageHeaderImage = $""
				}
				if ( s_offers.seasonalDataMap[seasonTag].specialPageHeaderTitle != specialPageHeaderTitle )
				{
					Warning( "Mismatched store special page header titles: \"%s\", \"%s\"", specialPageHeaderTitle, s_offers.seasonalDataMap[seasonTag].specialPageHeaderTitle )
					specialPageHeaderTitle = ""
				}
			}
			else
			{
				isSpecialPageHeaderDataValid = true
				specialPageHeaderImage = s_offers.seasonalDataMap[seasonTag].specialPageHeaderImage
				specialPageHeaderTitle = s_offers.seasonalDataMap[seasonTag].specialPageHeaderTitle
				headerOutlineOuterColor = s_offers.seasonalDataMap[seasonTag].headerOutlineOuterColor
				headerOutlineOuterAlpha = s_offers.seasonalDataMap[seasonTag].headerOutlineOuterAlpha
				headerOutlineInnerColor = s_offers.seasonalDataMap[seasonTag].headerOutlineInnerColor
				headerOutlineInnerAlpha = s_offers.seasonalDataMap[seasonTag].headerOutlineInnerAlpha
			}
		}

		if ( numRows == 0 )
		{
			layout[col] = LAYOUT_NONE
			if ( col != 4 )                                            
			numBlankColumns++
		}
		else if ( numRows == 1 )
		{
			layout[col] = LAYOUT_TALL
			numTallColumns++

			OfferButton_SetVisible( s_offers.fullOfferButtonDataArray[col], true )
			OfferButton_SetVisible( s_offers.topOfferButtonDataArray[col], false )
			OfferButton_SetVisible( s_offers.bottomOfferButtonDataArray[col], false )

			s_offers.fullOfferButtonDataArray[col].offerData = topRowOffers.len() > 0 ? topRowOffers : bottomRowOffers
			OfferButton_SetOffer( s_offers.fullOfferButtonDataArray[col], -1 )
		}
		else
		{
			layout[col] = LAYOUT_SHORT
			numShortColumns++

			Assert( numRows == 2 )

			OfferButton_SetVisible( s_offers.fullOfferButtonDataArray[col], false )
			OfferButton_SetVisible( s_offers.topOfferButtonDataArray[col], true )
			OfferButton_SetVisible( s_offers.bottomOfferButtonDataArray[col], true )

			s_offers.topOfferButtonDataArray[col].offerData = topRowOffers
			OfferButton_SetOffer( s_offers.topOfferButtonDataArray[col], -1 )

			s_offers.bottomOfferButtonDataArray[col].offerData = bottomRowOffers
			OfferButton_SetOffer( s_offers.bottomOfferButtonDataArray[col], -1 )
		}
	}

	const int TALL_BUTTON_MIN_WIDTH = 360
	const int TALL_BUTTON_MAX_WIDTH = 420
	const int SHORT_BUTTON_MIN_WIDTH = 360
	const int SHORT_BUTTON_MAX_WIDTH = 370
	const int TALL_WIDER_BUTTON_WIDTH = 600
	const int TALL_2SLOT_BUTTON_WIDTH = 800
	const int TALL_1SLOT_BUTTON_WIDTH = 1200

	int totalColumns = numTallColumns + numShortColumns
	int totalWidth    = 0
	int featuredWidth = 0
	int exclusiveWidth = 0
	int exclusiveX     = 0
	for ( int col = 0; col < 5; col++ )
	{
		int offerPanelWidth
		switch ( layout[col] )
		{
			case LAYOUT_TALL:
				if ( totalColumns > 4 )
					offerPanelWidth = TALL_BUTTON_MIN_WIDTH
				else
					offerPanelWidth = TALL_BUTTON_MAX_WIDTH

				if ( col == 0 && totalColumns + numBlankColumns == 4 )
					offerPanelWidth = TALL_WIDER_BUTTON_WIDTH

				else if ( totalColumns == 2 )
					offerPanelWidth = TALL_2SLOT_BUTTON_WIDTH

				else if ( totalColumns == 1 )
					offerPanelWidth = TALL_1SLOT_BUTTON_WIDTH
				break

			case LAYOUT_SHORT:
				if ( totalColumns > 4 )
					offerPanelWidth = SHORT_BUTTON_MIN_WIDTH
				else
					offerPanelWidth = SHORT_BUTTON_MAX_WIDTH
				break

			case LAYOUT_NONE:
				if ( featuredWidth == 0 || totalColumns <= col )
					offerPanelWidth = 0
				else
					offerPanelWidth = TALL_BUTTON_MIN_WIDTH / 4

				if ( exclusiveX <= 0 )
					exclusiveX = -1
				break
		}

		offerPanelWidth = int( offerPanelWidth * GetContentFixedScaleFactor( GetMenu("MainMenu") ).x )
		int offerX = Hud_GetX( s_offers.fullOfferButtonDataArray[col].button )

		OfferButton_SetWidth( s_offers.fullOfferButtonDataArray[col], offerPanelWidth )
		OfferButton_SetWidth( s_offers.topOfferButtonDataArray[col], offerPanelWidth )
		OfferButton_SetWidth( s_offers.bottomOfferButtonDataArray[col], offerPanelWidth )

		if ( exclusiveX == -1 && layout[col] != LAYOUT_NONE )
			exclusiveX = totalWidth + offerX

		totalWidth += offerPanelWidth + offerX

		if ( exclusiveX == 0 )
		{
			featuredWidth += offerPanelWidth
			if ( col > 0 )
				featuredWidth += offerX
		}
		else if ( exclusiveX > 0 && layout[col] != LAYOUT_NONE)
		{
			exclusiveWidth += offerPanelWidth
			if ( col > 0 && layout[col - 1] != LAYOUT_NONE )
				exclusiveWidth += offerX
		}
	}

	if( specialPageHeaderImage != $"" || specialPageHeaderTitle != "" )                       
	{
		Hud_Hide( s_offers.featuredHeader )
		Hud_Hide( s_offers.exclusiveHeader )
		Hud_Show( s_offers.specialPageHeader )

		HudElem_SetRuiArg( s_offers.specialPageHeader, "headerImage", specialPageHeaderImage, eRuiArgType.IMAGE )
		HudElem_SetRuiArg( s_offers.specialPageHeader, "headerTitle", specialPageHeaderTitle )

		if ( headerOutlineOuterColor != <0,0,0> )
			HudElem_SetRuiArg( s_offers.specialPageHeader, "headerOutlineOuterColor", headerOutlineOuterColor, eRuiArgType.VECTOR )
		if (   headerOutlineOuterAlpha != 0.0 )
			HudElem_SetRuiArg( s_offers.specialPageHeader, "headerOutlineOuterAlpha", headerOutlineOuterAlpha, eRuiArgType.FLOAT )
		if (  headerOutlineInnerColor != <0,0,0> )
			HudElem_SetRuiArg( s_offers.specialPageHeader, "headerOutlineInnerColor", headerOutlineInnerColor, eRuiArgType.VECTOR )
		if (   headerOutlineInnerAlpha != 0.0 )
			HudElem_SetRuiArg( s_offers.specialPageHeader, "headerOutlineInnerAlpha", headerOutlineInnerAlpha, eRuiArgType.FLOAT )

		Hud_SetY( s_offers.buttonAnchor, ContentScaledYAsInt( -28 ) )
		Hud_SetX( s_offers.specialPageHeader, (Hud_GetWidth( s_offers.specialPageHeader ) - totalWidth) / 2 )
	}
	else
	{
		Hud_Hide( s_offers.specialPageHeader )
		Hud_SetY( s_offers.buttonAnchor, 0 )
		Hud_Show( s_offers.featuredHeader )
		Hud_SetVisible( s_offers.exclusiveHeader, exclusiveWidth > 0 )
		Hud_SetWidth( s_offers.featuredHeader, featuredWidth > 0 ? featuredWidth : totalWidth )

		Hud_SetX( s_offers.exclusiveHeader, exclusiveX )
		Hud_SetWidth( s_offers.exclusiveHeader, exclusiveWidth > 0 ? exclusiveWidth : totalWidth - exclusiveX )
	}

	Hud_SetWidth( s_offers.offersPanel, totalWidth )
}


void function ClearOffers()
{
	foreach ( buttonData in s_offers.shopButtonDataArray )
	{
		var rui = Hud_GetRui( buttonData.button )

		RuiSetImage( rui, "imageAsset", $"" )
		RuiSetString( rui, "ecTitle", "" )
		RuiSetString( rui, "ecDesc", "" )
		RuiSetString( rui, "ecReqs", "" )
		RuiSetString( rui, "tagText", "" )
		RuiSetInt( rui, "numCollected", 0 )
		RuiSetInt( rui, "numTotalInCollection", 0 )

		RuiSetString( rui, "ecPrice", "#UNAVAILABLE" )
		RuiSetGameTime( rui, "expireTime", RUI_BADGAMETIME )

		Hud_SetEnabled( buttonData.button, false )
	}
}


#if DEV
void function DEV_OffersPanel_DoFakeOffers( bool doIt = false, string itemRef = "character_skin_caustic_legendary_04", string seasonTag = "", int col0 = 1, int col1 = 1, int col2 = 1, int col3 = 1, int col4 = 1 )
{
	if ( !doIt )
		itemRef = ""

	file.DEV_fakeOffers_itemRef = itemRef
	file.DEV_fakeOffers_seasonTag = seasonTag
	file.DEV_fakeOffers_columnCounts[0] = col0
	file.DEV_fakeOffers_columnCounts[1] = col1
	file.DEV_fakeOffers_columnCounts[2] = col2
	file.DEV_fakeOffers_columnCounts[3] = col3
	file.DEV_fakeOffers_columnCounts[4] = col4

	file.DEV_fakeOffers_expireTime[0] = int( ceil( GetUnixTimestamp() / 500.0 ) * 500.0 )
	file.DEV_fakeOffers_expireTime[1] = int( ceil( GetUnixTimestamp() / 400.0 ) * 400.0 )
	file.DEV_fakeOffers_expireTime[2] = int( ceil( GetUnixTimestamp() / 300.0 ) * 300.0 )
	file.DEV_fakeOffers_expireTime[3] = int( ceil( GetUnixTimestamp() / 200.0 ) * 200.0 )
	file.DEV_fakeOffers_expireTime[4] = int( ceil( GetUnixTimestamp() / 100.0 ) * 100.0 )
}

void function DEV_OffersPanel_DoFakeLayout( bool doIt = false, int col0 = 1, int col1 = 1, int col2 = 1, int col3 = 1, int col4 = 1, string seasonTag = "", string itemRef = "character_skin_caustic_legendary_04" )
{
	if ( !doIt )
		itemRef = ""

	file.DEV_fakeOffers_itemRef = itemRef
	file.DEV_fakeOffers_seasonTag = seasonTag
	file.DEV_fakeOffers_columnCounts[0] = col0
	file.DEV_fakeOffers_columnCounts[1] = col1
	file.DEV_fakeOffers_columnCounts[2] = col2
	file.DEV_fakeOffers_columnCounts[3] = col3
	file.DEV_fakeOffers_columnCounts[4] = col4

	file.DEV_fakeOffers_expireTime[0] = int( ceil( GetUnixTimestamp() / 500.0 ) * 500.0 )
	file.DEV_fakeOffers_expireTime[1] = int( ceil( GetUnixTimestamp() / 400.0 ) * 400.0 )
	file.DEV_fakeOffers_expireTime[2] = int( ceil( GetUnixTimestamp() / 300.0 ) * 300.0 )
	file.DEV_fakeOffers_expireTime[3] = int( ceil( GetUnixTimestamp() / 200.0 ) * 200.0 )
	file.DEV_fakeOffers_expireTime[4] = int( ceil( GetUnixTimestamp() / 100.0 ) * 100.0 )
}
#endif


void function OfferButton_OnActivate( var button )
{
	if ( !(button in s_offers.buttonToOfferData) )
		return

	GRXScriptOffer offer = s_offers.buttonToOfferData[button][0]

	Assert( offer.output.flavors.len() > 0 )
	SetCurrentTabForPIN( "ECPanel" )                                     
	StoreInspectMenu_AttemptOpenWithOffer( offer )                                                            
}


OfferButtonData ornull function GetOfferButtonDataByButton( var button )
{
	foreach ( offerButtonData in s_offers.shopButtonDataArray )
	{
		if ( offerButtonData.button != button )
			continue

		return offerButtonData
	}
	return null
}


void function OfferButton_OnGetFocus( var button )
{
	if( IsValid( s_offers.focusedOfferButton ) )
		OfferButton_RemoveCallbacks( s_offers.focusedOfferButton )

	if ( s_offers.navInputCallbacksRegistered )
		return

	OfferButtonData ornull offerButtonData = GetOfferButtonDataByButton( button )

	if( offerButtonData == null )
		return

	expect OfferButtonData( offerButtonData )

	s_offers.lastStickState = eStickState.NEUTRAL
	RegisterStickMovedCallback( ANALOG_RIGHT_X, offerButtonData.stickMovedCallback )
	AddCallback_OnMouseWheelUp( offerButtonData.wheelUpCallback )
	AddCallback_OnMouseWheelDown( offerButtonData.wheelDownCallback )
	s_offers.focusedOfferButton = button
	s_offers.navInputCallbacksRegistered = true
}


void function OfferButton_OnLoseFocus( var button )
{
	OfferButton_RemoveCallbacks( button )
}

void function OfferButton_RemoveCallbacks( var button )
{
	if ( !s_offers.navInputCallbacksRegistered )
		return

	OfferButtonData ornull offerButtonData = GetOfferButtonDataByButton( button )

	if ( offerButtonData == null )
		return

	expect OfferButtonData( offerButtonData )

	DeregisterStickMovedCallback( ANALOG_RIGHT_X, offerButtonData.stickMovedCallback )
	RemoveCallback_OnMouseWheelUp( offerButtonData.wheelUpCallback )
	RemoveCallback_OnMouseWheelDown( offerButtonData.wheelDownCallback )
	if ( s_offers.focusedOfferButton == button )
	{
		s_offers.focusedOfferButton = null
		s_offers.navInputCallbacksRegistered = false
	}
}

const bool OFFERBUTTON_NAV_RIGHT = true
const bool OFFERBUTTON_NAV_LEFT = false

void function OfferButton_OnStickMoved( OfferButtonData offerButtonData, float stickDeflection )
{
	                                                

	int stickState = eStickState.NEUTRAL
	if ( stickDeflection > 0.25 )
		stickState = eStickState.RIGHT
	else if ( stickDeflection < -0.25 )
		stickState = eStickState.LEFT

	if ( stickState != s_offers.lastStickState && offerButtonData.activeOfferIndex != -1 )
	{
		if ( stickState == eStickState.RIGHT )
		{
			                        
			OfferButton_ChangeOffer( offerButtonData, OFFERBUTTON_NAV_RIGHT )
		}
		else if ( stickState == eStickState.LEFT )
		{
			                       
			OfferButton_ChangeOffer( offerButtonData, OFFERBUTTON_NAV_LEFT )
		}
	}

	s_offers.lastStickState = stickState
}


void function ChangeOfferPageToLeft( OfferButtonData offerButtonData )
{
	if ( offerButtonData.activeOfferIndex == -1 )
		return

	OfferButton_ChangeOffer( offerButtonData, OFFERBUTTON_NAV_LEFT )
}


void function ChangeOfferPageToRight( OfferButtonData offerButtonData )
{
	if ( offerButtonData.activeOfferIndex == -1 )
		return

	OfferButton_ChangeOffer( offerButtonData, OFFERBUTTON_NAV_RIGHT )
}


void function OfferButton_ChangeOffer( OfferButtonData offerButtonData, bool direction )
{
	Assert( direction == OFFERBUTTON_NAV_LEFT || direction == OFFERBUTTON_NAV_RIGHT )
	Assert( offerButtonData.activeOfferIndex != -1 )

	if ( !GRX_IsInventoryReady() || !GRX_AreOffersReady() )
		return

	int numOffers      = offerButtonData.offerData.len()
	int nextOfferIndex = offerButtonData.activeOfferIndex

	for ( int i = 1; i < numOffers; i++ )
	{
		int candidateOfferIndex = direction == OFFERBUTTON_NAV_RIGHT ? (offerButtonData.activeOfferIndex + i) % numOffers : (offerButtonData.activeOfferIndex - i + numOffers) % numOffers

		nextOfferIndex = candidateOfferIndex
		break
	}

	if ( nextOfferIndex != offerButtonData.activeOfferIndex )
		OfferButton_SetOffer( offerButtonData, nextOfferIndex )
}

void function OfferButton_SetWidth( OfferButtonData offerButtonData, int width )
{
	Hud_SetWidth( offerButtonData.button, width )
	Hud_SetWidth( offerButtonData.buttonFade, width )
}

void function OfferButton_SetVisible( OfferButtonData offerButtonData, bool state )
{
	Hud_SetVisible( offerButtonData.button, state )
	Hud_SetVisible( offerButtonData.buttonFade, state )
}

void function OfferButton_SetOffer( OfferButtonData offerButtonData, int offerIndex )
{
	if ( offerIndex == -1 )
	{
		if ( offerButtonData.activeOfferIndex == -1 || offerButtonData.activeOfferIndex >= offerButtonData.offerData.len() )
			offerIndex = 0
		else
			offerIndex = offerButtonData.activeOfferIndex
	}

	int lastActiveOffer = offerButtonData.activeOfferIndex
	if ( lastActiveOffer >= offerButtonData.offerData.len() )
		lastActiveOffer = -1

	offerButtonData.activeOfferIndex = offerIndex

	var button  = offerButtonData.button
	bool isTall = offerButtonData.isTall
	var rui     = Hud_GetRui( button )

	GRXScriptOffer offerData = offerButtonData.offerData[offerIndex]

	if ( GetConVarBool( "assetdownloads_enabled" ) && offerData.imageRef != "" && offerData.image == $"" )
	{
		offerData.image = GetDownloadedImageAsset( offerData.imageRef, offerData.imageRef, (isTall)?ePakType.DL_STORE_TALL:ePakType.DL_STORE_SHORT, button )
	}

	RuiSetInt( rui, "offerCount", offerButtonData.offerData.len() )
	RuiSetInt( rui, "activeOfferIndex", offerButtonData.activeOfferIndex )
	OfferButton_SetDisplay( offerButtonData.button, offerData, offerButtonData.isTall )
	if ( offerButtonData.lastActiveOfferIndex != offerButtonData.activeOfferIndex )
	{
		if ( lastActiveOffer == -1 )
		{
			RuiSetGameTime( Hud_GetRui( offerButtonData.buttonFade ), "initTime", RUI_BADGAMETIME )
		}
		else
		{
			RuiSetInt( Hud_GetRui( offerButtonData.buttonFade ), "offerCount", 0 )
			RuiSetInt( Hud_GetRui( offerButtonData.buttonFade ), "activeOfferIndex", lastActiveOffer )
			RuiSetGameTime( Hud_GetRui( offerButtonData.buttonFade ), "initTime", ClientTime() )
			OfferButton_SetDisplay( offerButtonData.buttonFade, offerButtonData.offerData[lastActiveOffer], offerButtonData.isTall )
		}
	}

	offerButtonData.lastActiveOfferIndex = offerButtonData.activeOfferIndex

	s_offers.buttonToOfferData[offerButtonData.button] <- [offerData]
}


void function OfferButton_SetDisplay( var button, GRXScriptOffer offerData, bool isTall )
{
	var rui = Hud_GetRui( button )
	RuiSetImage( rui, "imageAsset", offerData.image )

	asset backgroundImage
	asset frameOverlayImage
	string seasonTag = offerData.seasonTag in s_offers.seasonalDataMap ? offerData.seasonTag : "default"

	backgroundImage = isTall ? s_offers.seasonalDataMap[seasonTag].tallImage : s_offers.seasonalDataMap[seasonTag].squareImage
	frameOverlayImage = isTall ? s_offers.seasonalDataMap[seasonTag].tallFrameOverlayImage : s_offers.seasonalDataMap[seasonTag].squareFrameOverlayImage

	RuiSetImage( rui, "backgroundImg", backgroundImage )
	RuiSetImage( rui, "frameOverlayImg", frameOverlayImage )

	if ( offerData.tooltipDesc != "" )
	{
		ToolTipData tooltipData
		tooltipData.titleText = offerData.tooltipTitle
		tooltipData.descText = offerData.tooltipDesc

		Hud_SetToolTipData( button, tooltipData )
	}
	else
	{
		Hud_ClearToolTipData( button )
	}

	bool isPurchasableByLocalPlayer = false
	string priceText                = ""

	Assert( offerData.output.flavors.len() > 0 )

	ItemFlavor itemFlav = offerData.output.flavors[0]

	float vertAlign = 0.0
	switch ( ItemFlavor_GetType( itemFlav ) )
	{
		case eItemType.weapon_skin:
			vertAlign = -0.6
			break

		default:
			vertAlign = -0.1
			break
	}

	if ( GetConVarBool( "assetdownloads_enabled" ) && DidImagePakLoadFail( offerData.imageRef ) )
		vertAlign = -0.1                                             

	RuiSetFloat( rui, "vertAlign", isTall ? 0.0 : vertAlign )
	                                                      

	bool isOfferFullyClaimed = GRXOffer_IsFullyClaimed( offerData )

	GRX_PackCollectionInfo packCollectionInfo = GRXOffer_GetEventThematicPackCollectionInfoFromScriptOffer( offerData )

	string originalPriceText = ""
	if ( offerData.originalPrice != null && !isOfferFullyClaimed )
		originalPriceText = GRX_GetFormattedPrice( expect ItemFlavorBag(offerData.originalPrice) )
	RuiSetString( rui, "ecOriginalPrice", originalPriceText )

	if ( !offerData.isAvailable )
	{
		priceText = offerData.unavailableReason
	}
	else if ( isOfferFullyClaimed )
	{
		priceText = "#OWNED"
	}
	else if ( offerData.prices.len() > 0 )
	{
		                                                                                                                 
		if ( offerData.prices.len() == 2 )
		{
			string firstPrice = GRX_GetFormattedPrice( offerData.prices[0] )
			string secondPrice = GRX_GetFormattedPrice( offerData.prices[1] )
			priceText = Localize( "#STORE_PRICE_N_N", firstPrice, secondPrice )

		}
		else
		{
			priceText = GRX_GetFormattedPrice( offerData.prices[0] )
		}

		isPurchasableByLocalPlayer = true
	}
	else
	{
		if( offerData.output.flavors.len() > 1 )
			Warning( "Offer has no price: %s", offerData.offerAlias )
		else
			Warning( "Offer has no price: %s", ItemFlavor_GetHumanReadableRef( itemFlav ) )

		priceText = "#UNAVAILABLE"
	}

	if ( offerData.purchaseLimit > 1 )
	{
		RuiSetString( rui, "ecDesc", Localize( "#STORE_LIMIT_N", offerData.purchaseLimit ) )
	}
	else
	{
		RuiSetString( rui, "ecDesc", ""                       )
	}

	int highestItemQuality = 0
	string highestItemQualityName = ""
	foreach ( ItemFlavor flav in offerData.output.flavors )
	{
		if ( ItemFlavor_HasQuality( flav ) && ItemFlavor_GetQuality( flav ) > highestItemQuality )
		{
			highestItemQuality = ItemFlavor_GetQuality( flav )
			highestItemQualityName = ItemFlavor_GetQualityName( itemFlav )
		}
	}

	RuiSetInt( rui, "rarity", highestItemQuality )
	RuiSetString( rui, "rarityName", highestItemQualityName )
	RuiSetString( rui, "ecTitle", Localize( offerData.titleText ) )
	RuiSetString( rui, "tagText", offerData.tagText )
	RuiSetString( rui, "ecPrice", priceText )
	RuiSetInt( rui, "numCollected", packCollectionInfo.numCollected )
	RuiSetInt( rui, "numTotalInCollection", packCollectionInfo.numTotalInCollection )
	RuiSetBool( rui, "isPriceLoading", ( offerData.offerType == GRX_OFFERTYPE_BUNDLE ) && !GRX_HasUpToDateBundleOffers() )

	int remainingTime = offerData.expireTime - GetUnixTimestamp()
	if ( remainingTime > 0 )
		RuiSetGameTime( rui, "expireTime", ClientTime() + remainingTime )
	else
		RuiSetGameTime( rui, "expireTime", RUI_BADGAMETIME )

	                                                      
	Hud_SetEnabled( button, true )

	if ( offerData.prereq != null )
	{
		ItemFlavor prereqFlav = expect ItemFlavor( offerData.prereq )
		if ( GRX_IsItemOwnedByPlayer( prereqFlav ) )
			RuiSetString( rui, "ecReqs", Localize( "#STORE_REQUIRES_OWNED", Localize( ItemFlavor_GetLongName( prereqFlav ) ) ) )
		else
			RuiSetString( rui, "ecReqs", Localize( "#STORE_REQUIRES_LOCKED", Localize( ItemFlavor_GetLongName( prereqFlav ) ) ) )
	}
	else
	{
		RuiSetString( rui, "ecReqs", "" )
	}
}


void function OfferButton_AutoAdvanceOffers()
{
	Signal( uiGlobal.signalDummy, "EndAutoAdvanceOffers" )
	EndSignal( uiGlobal.signalDummy, "EndAutoAdvanceOffers" )

	const float OFFER_DELAY = 7.0
	while ( true )
	{
		foreach ( offerButtonData in s_offers.shopButtonDataArray )
		{
			HudElem_SetRuiArg( offerButtonData.button, "nextOfferChangeTime", ClientTime() + OFFER_DELAY, eRuiArgType.GAMETIME )
		}

		wait OFFER_DELAY

		foreach ( offerButtonData in s_offers.shopButtonDataArray )
		{
			if ( GetFocus() == offerButtonData.button )
				continue

			if ( offerButtonData.offerData.len() < 2 )
				continue

			if ( !GRX_IsInventoryReady() || !GRX_AreOffersReady() )
				continue

			OfferButton_ChangeOffer( offerButtonData, OFFERBUTTON_NAV_RIGHT )
		}
	}
}

void function JumpToStoreTab()
{
	while ( GetActiveMenu() != GetMenu( "LobbyMenu" ) )
		CloseActiveMenu()

	TabData lobbyTabData = GetTabDataForPanel( GetMenu( "LobbyMenu" ) )
	ActivateTab( lobbyTabData, Tab_GetTabIndexByBodyName( lobbyTabData, "StorePanel" ) )
}

void function JumpToStoreSpecials()
{
	while ( GetActiveMenu() != GetMenu( "LobbyMenu" ) )
		CloseActiveMenu()

	TabData lobbyTabData = GetTabDataForPanel( GetMenu( "LobbyMenu" ) )
	ActivateTab( lobbyTabData, Tab_GetTabIndexByBodyName( lobbyTabData, "StorePanel" ) )

	TabData storeTabData = GetTabDataForPanel( file.storePanel )
	int tabIndex = Tab_GetTabIndexByBodyName( storeTabData, "SpecialsPanel" )
	if ( IsTabIndexVisible( storeTabData, tabIndex ) && IsTabIndexEnabled( storeTabData, tabIndex ) )
		ActivateTab( storeTabData, Tab_GetTabIndexByBodyName( storeTabData, "SpecialsPanel" ) )
}

void function JumpToStoreSkin( ItemFlavor skin )
{
	JumpToStoreTab()

	for ( int index = 0; index < eStoreLocation._COUNT; index++ )
	{
		TabData legendsTabData = GetTabDataForPanel( file.storePanel )
		if ( !IsTabIndexVisible( legendsTabData, index ) || !IsTabIndexEnabled( legendsTabData, index ) )
			continue

		foreach ( offer in GRX_GetStoreOffers( index ) )
		{
			if ( offer.output.flavors.contains( skin ) )
			{
				ActivateTab( legendsTabData, index )
				StoreInspectMenu_AttemptOpenWithOffer( offer )
				return
			}
		}
	}
}


void function JumpToStoreOffer( string storeOfferName )
{
	JumpToStoreTab()

	for ( int index = 0; index < eStoreLocation._COUNT; index++ )
	{
		TabData legendsTabData = GetTabDataForPanel( file.storePanel )
		if ( !IsTabIndexVisible( legendsTabData, index ) || !IsTabIndexEnabled( legendsTabData, index ) )
			continue

		foreach ( offer in GRX_GetStoreOffers( index ) )
		{
			if ( offer.offerAlias == storeOfferName )
			{
				ActivateTab( legendsTabData, index )
				StoreInspectMenu_AttemptOpenWithOffer( offer )
				return
			}
		}
	}
}


void function JumpToStorePacks()
{
	while ( GetActiveMenu() != GetMenu( "LobbyMenu" ) )
		CloseActiveMenu()

	TabData lobbyTabData = GetTabDataForPanel( GetMenu( "LobbyMenu" ) )
	ActivateTab( lobbyTabData, Tab_GetTabIndexByBodyName( lobbyTabData, "StorePanel" ) )

	TabData legendsTabData = GetTabDataForPanel( file.storePanel )
	ActivateTab( legendsTabData, Tab_GetTabIndexByBodyName( legendsTabData, "LootPanel" ) )
}


void function JumpToHeirloomShop()
{
	while ( GetActiveMenu() != GetMenu( "LobbyMenu" ) )
		CloseActiveMenu()

	TabData lobbyTabData = GetTabDataForPanel( GetMenu( "LobbyMenu" ) )
	ActivateTab( lobbyTabData, Tab_GetTabIndexByBodyName( lobbyTabData, "StorePanel" ) )

	TabData storeTabData = GetTabDataForPanel( file.storePanel )
	ActivateTab( storeTabData, Tab_GetTabIndexByBodyName( storeTabData, "HeirloomShopPanel" ) )
}


void function CharactersPanel_OnFocusChanged( var panel, var oldFocus, var newFocus )
{
	if ( !IsValid( panel ) )                  
		return
	if ( GetParentMenu( panel ) != GetActiveMenu() )
		return

	UpdateFooterOptions()
}

int function GetStoreLocationFromPanel( var panel )
{
	string panelName = Hud_GetHudName( panel )

	switch( panelName )
	{
		case "SpecialsPanel":
			return eStoreLocation.SPECIALS

		case "SeasonalPanel":
			return eStoreLocation.SEASONAL

		default:
			return eStoreLocation.SHOP
	}
	unreachable
}
