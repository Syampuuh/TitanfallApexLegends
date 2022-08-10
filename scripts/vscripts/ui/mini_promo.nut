global function InitMiniPromo
global function MiniPromo_Start
global function MiniPromo_Stop

         
                                       
        

const int MINIPROMO_MAX_PAGES = 5
const float MINIPROMO_PAGE_CHANGE_DELAY = 7.0
const bool MINIPROMO_NAV_RIGHT = true
const bool MINIPROMO_NAV_LEFT = false
const bool MINIPROMO_PAGE_FORMAT_DEFAULT = true
const bool MINIPROMO_PAGE_FORMAT_OPENPACK = false
const string PIN_MESSAGE_TYPE_MINIPROMO = "minipromo"

struct MiniPromoPageData
{
	bool          isValid = false
	bool          format = MINIPROMO_PAGE_FORMAT_DEFAULT
	asset         image = $""
	string		  imageName = ""
	string        text1 = ""
	string        text2 = ""
	string        linkType = ""
	string        trackingId = ""
	array<string> linkData
}

struct
{
	bool grxCallbacksRegistered = false

	array<MiniPromoPageData> allPages
	int                      activePageIndex = -1
	var                      button

	table signalDummy

	bool  navInputCallbacksRegistered = false
	float stickDeflection = 0
	int   lastStickState = eStickState.NEUTRAL

	                              
} file


void function InitMiniPromo( var button )
{
	RegisterSignal( "EndAutoAdvancePages" )

	file.button = button

	Hud_AddEventHandler( button, UIE_CLICK, MiniPromoButton_OnActivate )
	Hud_AddEventHandler( button, UIE_GET_FOCUS, MiniPromoButton_OnGetFocus )
	Hud_AddEventHandler( button, UIE_LOSE_FOCUS, MiniPromoButton_OnLoseFocus )
}


void function MiniPromo_Start()
{
	                                                               

	Signal( file.signalDummy, "EndAutoAdvancePages" )                               

	file.allPages = InitPages()

	if ( !file.grxCallbacksRegistered )
	{
		AddCallbackAndCallNow_OnGRXOffersRefreshed( OnGRXStateChanged )
		AddCallbackAndCallNow_OnGRXInventoryStateChanged( OnGRXStateChanged )
		file.grxCallbacksRegistered = true
	}
}


void function MiniPromo_Stop()
{
	                                                              

	MiniPromo_Reset()

	if ( file.grxCallbacksRegistered )
	{
		RemoveCallback_OnGRXOffersRefreshed( OnGRXStateChanged )
		RemoveCallback_OnGRXInventoryStateChanged( OnGRXStateChanged )
		file.grxCallbacksRegistered = false
	}
}


         
                                                  
   
  	                                
  
  	                   
   
        


void function OnGRXStateChanged()
{
	if ( !GRX_IsInventoryReady() || !GRX_AreOffersReady() )
		return

	UpdateValidityOfPages( file.allPages )

	int validPageCount = GetValidPageCount()

	if ( validPageCount > 0 )
	{
		if ( file.activePageIndex == -1 )
		{
			foreach ( index, page in file.allPages )
			{
				if ( !page.isValid )
					continue

				file.activePageIndex = index
				break
			}

			Hud_Show( file.button )
			SetPage( file.activePageIndex, true )
			thread AutoAdvancePages()
		}
		else if ( !IsPageValidToShow( file.allPages[file.activePageIndex] ) )
		{
			ChangePage( MINIPROMO_NAV_RIGHT )
			thread AutoAdvancePages()
		}

		var rui = Hud_GetRui( file.button )
		RuiSetInt( rui, "pageCount", validPageCount )
		RuiSetInt( rui, "activePageIndex", GetActivePageIndexForRui() )
	}
	else
	{
		MiniPromo_Reset()
	}
}


void function MiniPromo_Reset()
{
	Signal( uiGlobal.signalDummy, "EndAutoAdvancePages" )
	file.activePageIndex = -1
	Hud_Hide( file.button )
}


void function UpdateValidityOfPages( array<MiniPromoPageData> pages )
{
	                                          
	   
	  	                                        
	  		                    
	  	    
	  		                             
	   

	foreach ( page in pages )
	{
		switch ( page.linkType )
		{
			case "openpack":
				page.isValid = GRX_IsInventoryReady() && GRX_GetTotalPackCount() > 0
				break

			case "openmotd":
			case "battlepass":
			case "storecharacter":
			case "storeskin":
			case "themedstoreskin":
			case "collectionevent":
			case "storeoffer":
			case "whatsnew":
			case "storespecials":
				page.isValid = true
				break

			case "url":
				page.isValid = true                                      
				break
		}
	}
}


bool function IsPageValidToShow( MiniPromoPageData page )
{
	return page.isValid
}


int function GetValidPageCount()
{
	int validPageCount = 0

	foreach ( page in file.allPages )
	{
		if ( page.isValid )
			validPageCount++
	}

	return validPageCount
}


int function GetActivePageIndexForRui()
{
	int index = 0

	for ( int i = 0; i < file.activePageIndex; i++ )
	{
		if ( file.allPages[i].isValid )
			index++
	}

	return index
}


array<MiniPromoPageData> function InitPages()
{
	array<MiniPromoPageData> pages
	UMData um = EADP_UM_GetPromoData()

	                                  
	MiniPromoPageData openPackPage
	openPackPage.text1 = "OPEN PACK"
	openPackPage.linkType = "openpack"
	openPackPage.imageName = "m_openpack"
	openPackPage.image = GetPromoImage( openPackPage.imageName )
	openPackPage.format = MINIPROMO_PAGE_FORMAT_OPENPACK
	pages.append( openPackPage )

	foreach ( int i, UMAction action in um.actions )
	{
		MiniPromoPageData newPage
		newPage.trackingId = action.trackingId
		foreach ( int j, UMItem item in action.items )
		{
			if ( item.name == "MiniPromoText" )
			{
				newPage.text1 = item.value
			}
			else if ( item.name == "MiniPromoExtraText" )
			{
				newPage.text2 = item.value
			}
			else if ( item.name == "Link" )
			{
				newPage.linkData.append( item.value )
				foreach ( attr in item.attributes )
				{
					if ( attr.key == "LinkType" )
						newPage.linkType = attr.value
				}
			}
			else if ( item.name == "ImageRef" )
			{
				newPage.imageName = item.value
				if ( !GetConVarBool( "assetdownloads_enabled" ) )
					newPage.image = GetPromoImage( newPage.imageName )
			}
		}

		if ( newPage.linkType == "" )
			newPage.linkType = "openmotd"

		newPage.format = MINIPROMO_PAGE_FORMAT_DEFAULT
		pages.append( newPage )

		if( pages.len() >= MINIPROMO_MAX_PAGES )
			break
	}
	return pages
}

bool function IsLinkFormatValid( string linkType, array<string> linkData )
{
	if ( linkType == "openpack" && linkData.len() == 0 )
		return true
	else if ( linkType == "openmotd" && linkData.len() == 0 )
		return true
	else if ( (linkType == "battlepass" || linkType == "storecharacter" || linkType == "storeskin" || linkType == "themedstoreskin" || linkType == "collectionevent") && linkData.len() == 1 && IsValidItemFlavorHumanReadableRef( linkData[0] ) )
		return true
	else if ( linkType == "url" && linkData.len() == 1 )                                      
		return true
	else if ( linkType == "storeoffer" && linkData.len() == 1 )
		return true

	return false
}


void function AutoAdvancePages()
{
	                                                                 
	Signal( uiGlobal.signalDummy, "EndAutoAdvancePages" )
	EndSignal( uiGlobal.signalDummy, "EndAutoAdvancePages" )

	while ( true )
	{
		float delay = file.allPages[file.activePageIndex].linkType == "openpack" ? MINIPROMO_PAGE_CHANGE_DELAY * 3 : MINIPROMO_PAGE_CHANGE_DELAY
		wait delay

		while ( GetFocus() == file.button )
			WaitFrame()

		ChangePage( MINIPROMO_NAV_RIGHT )
	}
}


void function ChangePage( bool direction )
{
	Assert( direction == MINIPROMO_NAV_LEFT || direction == MINIPROMO_NAV_RIGHT )
	Assert( file.activePageIndex != -1 )

	int numPages      = file.allPages.len()
	int nextPageIndex = file.activePageIndex

	for ( int i = 1; i < numPages; i++ )
	{
		int candidatePageIndex          = direction == MINIPROMO_NAV_RIGHT ? (file.activePageIndex + i) % numPages : (file.activePageIndex - i + numPages) % numPages
		                                                                                                                                                                      
		MiniPromoPageData candidatePage = file.allPages[candidatePageIndex]
		if ( IsPageValidToShow( candidatePage ) )
		{
			nextPageIndex = candidatePageIndex
			break
		}
		      
		   
		  	                                                                                                        
		   
	}

	if ( nextPageIndex != file.activePageIndex )
		SetPage( nextPageIndex )
	      
	  	                                                                                                               
}


void function SetPage( int pageIndex, bool instant = false )
{
	                                                                       

	var rui = Hud_GetRui( file.button )

	float time = instant ? ClientTime() - 10 : ClientTime()
	RuiSetGameTime( rui, "initTime", time )

	int lastActivePage = file.activePageIndex
	file.activePageIndex = pageIndex

	MiniPromoPageData page = file.allPages[file.activePageIndex]
	if( GetConVarBool( "assetdownloads_enabled" ) && file.activePageIndex > 0 )
		RuiSetImage( rui, "imageAsset", GetDownloadedImageAsset( page.imageName, page.imageName, ePakType.DL_MINI_PROMO, file.button ) )
	else
		RuiSetImage( rui, "imageAsset", page.image )
	RuiSetBool( rui, "format", page.format )
	RuiSetString( rui, "text1", page.text1 )
	RuiSetString( rui, "text2", page.text2 )

	MiniPromoPageData lastPage = file.allPages[lastActivePage]
	if( GetConVarBool( "assetdownloads_enabled" ) && lastActivePage > 0 )
		RuiSetImage( rui, "lastImageAsset", GetDownloadedImageAsset( lastPage.imageName, lastPage.imageName, ePakType.DL_MINI_PROMO ) )
	else
		RuiSetImage( rui, "lastImageAsset", lastPage.image )
	RuiSetBool( rui, "lastFormat", lastPage.format )
	RuiSetString( rui, "lastText1", lastPage.text1 )
	RuiSetString( rui, "lastText2", lastPage.text2 )
	RuiSetBool( rui, "largeImageMode", true )

	RuiSetInt( rui, "activePageIndex", GetActivePageIndexForRui() )

	int ownedPacks = GRX_IsInventoryReady() ? GRX_GetTotalPackCount() : 0
	Hud_ClearToolTipData( file.button )
	if ( ownedPacks > 0 )
	{
		ItemFlavor ornull pack = GetNextLootBox()
		expect ItemFlavor( pack )
		int nextPacks = GRX_GetPackCount( ItemFlavor_GetGRXIndex( pack ) )
		RuiSetInt( rui, "nextPacks",  nextPacks )
		if ( nextPacks < ownedPacks )
		{
			RuiSetInt( rui, "ownedPacks", ownedPacks )
			ToolTipData toolTipData = GetPackInfoToolTip( ownedPacks )
			Hud_SetToolTipData( file.button, toolTipData )
		}

		asset packIcon            = GRXPack_GetOpenButtonIcon( pack )
		int packRarity            = ItemFlavor_GetQuality( pack )
		vector ornull customColor = GRXPack_GetCustomColor( pack, 0 )
		bool isRegularApexPack    = packIcon == "" && packRarity == 1

		vector packColor = <1, 1, 1>
		if ( customColor != null )
			packColor = expect vector( customColor )
		else if ( !isRegularApexPack )
			packColor = GetKeyColor( COLORID_TEXT_LOOT_TIER0, packRarity + 1 ) / 255.0

		vector countTextCol              = <255, 78, 29> * 1.0 / 255.0
		vector ornull customCountTextCol = GRXPack_GetCustomCountTextCol( pack )
		if ( customCountTextCol != null )
			countTextCol = expect vector(customCountTextCol)

		vector rarityColor = GetKeyColor( COLORID_TEXT_LOOT_TIER0, packRarity + 1 ) / 255.0

		RuiSetAsset( rui, "packIcon", packIcon )
		RuiSetColorAlpha( rui, "packColor", SrgbToLinear( packColor ), 1.0 )
		RuiSetColorAlpha( rui, "packCountTextCol", SrgbToLinear( countTextCol ), 1.0 )
		RuiSetColorAlpha( rui, "rarityColor", SrgbToLinear( rarityColor ), 1.0 )
		string nextPackDescription = "#APEX"

		if ( ItemFlavor_GetAccountPackType( pack ) == eAccountPackType.EVENT )
		{
			nextPackDescription = "#PACK_BUNDLE_EVENT_TEXT"
		}
		else if ( ItemFlavor_GetAccountPackType( pack ) == eAccountPackType.EVENT_THEMATIC )
		{
			nextPackDescription = "#PACK_BUNDLE_THEMATIC_TEXT"
		}
		else if ( ItemFlavor_GetAccountPackType( pack ) == eAccountPackType.THEMATIC )
		{
			nextPackDescription = ItemFlavor_GetShortName( pack )                                                                                   
		}
		else if ( packIcon != "" && ItemFlavor_GetAccountPackType( pack ) == eAccountPackType.APEX )
		{
			nextPackDescription = ItemFlavor_GetQualityName( pack )                                                                                          
		}

		RuiSetString( rui, "packDescription", nextPackDescription )
	}
	else
	{
		RuiSetInt( rui, "ownedPacks", 0 )
	}

	if ( page.linkType != "openpack" )
		Hud_ClearToolTipData( file.button )
}

ToolTipData function GetPackInfoToolTip( int ownedPacks )
{
	ToolTipData toolTipData
	toolTipData.tooltipStyle = eTooltipStyle.MINI_PROMO_APEX_PACK
	toolTipData.titleText    = Localize( "#UNOPENED_PACKS_CNT", string(ownedPacks) )

	int numDifferentLowerTierPacks = 0
	int legPackCnt = 0
	int epcPackCnt = 0
	int rarPackCnt = 0
	int evtPackCnt = 0
	int thmPackCnt = 0
	int apxPackCnt = 0
	string hint3 = "", hint2 = "", hint1 = ""

	foreach ( ItemFlavor counterPack in GRX_GetAllPackFlavors() )
	{
		if ( ItemFlavor_GetAccountPackType( counterPack ) == eAccountPackType.EVENT )
		{
			evtPackCnt += GRX_GetPackCount( ItemFlavor_GetGRXIndex( counterPack ) )
		}
		else if ( ItemFlavor_GetAccountPackType( counterPack ) == eAccountPackType.THEMATIC || ItemFlavor_GetAccountPackType( counterPack ) == eAccountPackType.EVENT_THEMATIC )
		{
			thmPackCnt += GRX_GetPackCount( ItemFlavor_GetGRXIndex( counterPack ) )
		}
		else                                                                      
		{
			int packRarity = ItemFlavor_GetQuality( counterPack )
			if ( packRarity == 3 )             
				legPackCnt += GRX_GetPackCount( ItemFlavor_GetGRXIndex( counterPack ) )
			else if ( packRarity == 2 )        
				epcPackCnt += GRX_GetPackCount( ItemFlavor_GetGRXIndex( counterPack ) )
			else if ( packRarity == 1 )                      
				apxPackCnt += GRX_GetPackCount( ItemFlavor_GetGRXIndex( counterPack ) )
		}
	}

	                                                                                                                                                    
	if ( legPackCnt > 0 )
	{
		hint3 = Localize( "#CNT_LEGENDARY_PACKS", string( legPackCnt ) )
	}
	if ( evtPackCnt > 0 )
	{
		if ( hint3 == "" )
			hint3 = Localize( "#CNT_EVENT_PACKS", string( evtPackCnt ) )
		else
			hint2 = Localize( "#CNT_EVENT_PACKS", string( evtPackCnt ) )
	}
	if ( epcPackCnt > 0 )
	{
		if ( hint3 == "" )
		{
			hint3 = Localize( "#CNT_EPIC_PACKS", string( epcPackCnt ) )
		}
		else if ( hint2 == "" )
		{
			hint2 = Localize( "#CNT_EPIC_PACKS", string( epcPackCnt ) )
		}
		else
		{
			hint1 = Localize( "#CNT_EPIC_PACKS", string( epcPackCnt ) )
			numDifferentLowerTierPacks = numDifferentLowerTierPacks | 2
		}
	}
	if ( thmPackCnt > 0 )
	{
		if ( hint3 == "" )
		{
			hint3 = Localize( "#CNT_THEMATIC_PACKS", string( thmPackCnt ) )
		}
		else if ( hint2 == "" )
		{
			hint2 = Localize( "#CNT_THEMATIC_PACKS", string( thmPackCnt ) )
		}
		else if ( hint1 == "" )
		{
			hint1 = Localize( "#CNT_THEMATIC_PACKS", string( thmPackCnt ) )
			numDifferentLowerTierPacks = numDifferentLowerTierPacks | 1
		}
		else
		{
			hint1 = Localize( "#CNT_ADDITIONAL_PACKS", string( thmPackCnt + epcPackCnt + apxPackCnt ) )
			numDifferentLowerTierPacks = numDifferentLowerTierPacks | 1
		}
	}
	if ( apxPackCnt > 0 )
	{
		if ( hint3 == "" )
			hint3 = Localize( "#CNT_RARE_PACKS", string( apxPackCnt ) )
		else if ( hint2 == "" )
			hint2 = Localize( "#CNT_RARE_PACKS", string( apxPackCnt ) )
		else if ( hint1 == "" )
			hint1 = Localize( "#CNT_RARE_PACKS", string( apxPackCnt ) )
		else if ( numDifferentLowerTierPacks & 2 )
			hint1 = Localize( "#CNT_ADDITIONAL_PACKS", string( thmPackCnt + epcPackCnt + apxPackCnt ) )
		else if ( numDifferentLowerTierPacks & 1 )
			hint1 = Localize( "#CNT_ADDITIONAL_PACKS", string( thmPackCnt + apxPackCnt ) )

	}

	toolTipData.actionHint3  = hint3
	toolTipData.actionHint2  = hint2
	toolTipData.actionHint1  = hint1

	toolTipData.tooltipFlags = toolTipData.tooltipFlags | eToolTipFlag.INSTANT_FADE_IN

	return toolTipData
}


                                                                                                                      
int function GetCorrespondingMOTDPageIndex()
{
	MiniPromoPageData firstPage = file.allPages[0]
	if ( firstPage.linkType == "openpack" )
		return file.activePageIndex - 1

	return file.activePageIndex
}


                                                                      
void function MiniPromoButton_OnActivate( var button )
{
	                                                

	MiniPromoPageData page = file.allPages[file.activePageIndex]
	int motdIndex = GetCorrespondingMOTDPageIndex()

	if ( page.linkType == "openpack" )
	{
		if ( GRX_IsInventoryReady() && GRX_GetTotalPackCount() > 0 )
		{
			EmitUISound( "UI_Menu_OpenLootBox" )
			OnLobbyOpenLootBoxMenu_ButtonPress()
		}
	}
	else if ( page.linkType == "openmotd" )
	{
		PIN_UM_Message( page.text1, page.trackingId, PIN_MESSAGE_TYPE_MINIPROMO, ePINPromoMessageStatus.CLICK, motdIndex )
		PromoDialog_OpenToPage( motdIndex )
	}
	else
	{
		PIN_UM_Message( page.text1, page.trackingId, PIN_MESSAGE_TYPE_MINIPROMO, ePINPromoMessageStatus.CLICK, motdIndex )
		OpenPromoLink( page.linkType, page.linkData[0] )
	}
}


void function MiniPromoButton_OnGetFocus( var button )
{
	if ( file.navInputCallbacksRegistered )
		return

	file.lastStickState = eStickState.NEUTRAL
	RegisterStickMovedCallback( ANALOG_RIGHT_X, OnStickMoved )
	AddCallback_OnMouseWheelUp( ChangePromoPageToLeft )
	AddCallback_OnMouseWheelDown( ChangePromoPageToRight )
	file.navInputCallbacksRegistered = true
}


void function MiniPromoButton_OnLoseFocus( var button )
{
	if ( !file.navInputCallbacksRegistered )
		return

	DeregisterStickMovedCallback( ANALOG_RIGHT_X, OnStickMoved )
	RemoveCallback_OnMouseWheelUp( ChangePromoPageToLeft )
	RemoveCallback_OnMouseWheelDown( ChangePromoPageToRight )
	file.navInputCallbacksRegistered = false
}


void function OnStickMoved( ... )
{
	float stickDeflection = expect float( vargv[1] )
	                                                

	int stickState = eStickState.NEUTRAL
	if ( stickDeflection > 0.25 )
		stickState = eStickState.RIGHT
	else if ( stickDeflection < -0.25 )
		stickState = eStickState.LEFT

	if ( stickState != file.lastStickState && file.activePageIndex != -1 )
	{
		if ( stickState == eStickState.RIGHT )
		{
			                        
			ChangePage( MINIPROMO_NAV_RIGHT )
			thread AutoAdvancePages()
		}
		else if ( stickState == eStickState.LEFT )
		{
			                       
			ChangePage( MINIPROMO_NAV_LEFT )
			thread AutoAdvancePages()
		}
	}

	file.lastStickState = stickState
}


void function ChangePromoPageToLeft()
{
	if ( file.activePageIndex == -1 )
		return

	ChangePage( MINIPROMO_NAV_LEFT )
	thread AutoAdvancePages()
}


void function ChangePromoPageToRight()
{
	if ( file.activePageIndex == -1 )
		return

	ChangePage( MINIPROMO_NAV_RIGHT )
	thread AutoAdvancePages()
}
