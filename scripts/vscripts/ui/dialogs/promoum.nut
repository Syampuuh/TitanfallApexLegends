global function InitPromoDialogUM
global function OpenPromoDialogIfNewUM
global function OpenPromoDialogIfNewAfterPakLoadUM
global function PromoDialog_InitPages
global function PromoDialog_OpenHijackedUM
global function PromoDialog_OpenToPage
global function PromoDialog_CanShow

global function UICodeCallback_UMRequestFinished

const PROMO_DIALOG_MAX_PAGES = 4
const string PIN_MESSAGE_TYPE_PROMO = "motd"
const float PROMO_TRANS_DURATION = 0.5
const float PROMO_PREVIEW_BUTTON_WIDTH = 320
const string PROMO_PREVIEW_BUTTON_NAME = "PromoPreviewButton"

struct PromoDialogPageData
{
	asset  image = $""
	string imageName = ""
	string title = ""
	string desc = ""
	string link = ""
	string linkType = ""
	string linkText = ""
	string trackingId = ""
}

enum eTransType
{
	                                      
	NONE = 0,
	SLIDE_LEFT = 1,
	SLIDE_RIGHT = 2,

	_count,
}

struct RedemptionPopupContent
{
	string titleText
	string descText
	string imageName
}

struct
{
	var  menu
	var  prevPageButton
	var  nextPageButton
	var	 viewButton
	var	 viewButtonRui
	var	 controlIndicator
	var	 footer
	bool pageChangeInputsRegistered
	bool hasViewedMOTDThisSession = false

	RedemptionPopupContent hijackContent
	bool hasHijackContent = false

	array<PromoDialogPageData> pages
	array< var >			promoPreviewButtonsRui
	var         			promoPreviewButtons
	var         			promoPreviewActiveIndicatorRui
	var         			promoPreviewActiveIndicator

	int         			activePageIndex = 0
	var         			promoPageRui
	int         			updateID = 0
	int         			numPages = 0
	int         			pageIndexForJump = -1
	PromoDialogPageData& 	activePage
} file


bool function OpenPromoDialogIfNewUM()
{
	if ( IsFeatureSuppressed( eFeatureSuppressionFlags.PROMO_USER_MESSAGES_DIALOG ) )
		return false

	if ( GetConVarBool( "assetdownloads_enabled" ) )
	{
		PromoDialog_InitPages()
		if ( PromoDialog_HasPages() )
		{
			file.numPages = file.promoPreviewButtonsRui.len() < PromoDialog_NumPages() ? file.promoPreviewButtonsRui.len() : PromoDialog_NumPages()
			UpdatePageRui()
			UpdatePreviewButtonRui()
		}
		else
		{
			print("OpenPromoDialogIfNewUM no pages")
		}
		if ( IsPromoDialogNew() )
			return true
	}
	else if ( IsPromoDialogNew() )
	{
		AdvanceMenu( file.menu )
		return true
	}

	return false
}


void function OpenPromoDialogIfNewAfterPakLoadUM()
{
	if ( IsPromoDialogNew() && !file.hasHijackContent )
	{
		UpdatePageRui()
		AdvanceMenu( file.menu )
	}
}


void function PromoDialog_InitPages()
{
	file.pages.clear()

	UMData um = EADP_UM_GetPromoData()
	foreach ( int i, UMAction action in um.actions )
	{
		PromoDialogPageData newPage
		newPage.trackingId = action.trackingId
		foreach ( int j, UMItem item in action.items )
		{
			if ( item.name == "TitleText" )
			{
				newPage.title = item.value
			}
			else if ( item.name == "BodyText" )
			{
				newPage.desc = item.value
			}
			else if ( item.name == "Link" )
			{
				newPage.link = item.value
				foreach ( attr in item.attributes )
				{
					if ( attr.key == "LinkType" )
					{
						newPage.linkType = attr.value
						newPage.linkText = Localize( ViewButtonTextFromLinkType( newPage.linkType ) )
					}
				}
			}
			else if ( item.name == "ImageRef" )
			{
				newPage.imageName = item.value
				if ( file.hasHijackContent )
					newPage.image = GetPromoImage( newPage.imageName )
			}
		}
		file.pages.append( newPage )
	}
}

int function PromoDialog_NumPages()
{
	return file.pages.len()
}

bool function PromoDialog_HasPages()
{
	return PromoDialog_NumPages() > 0
}

bool function PromoDialog_CanShow()
{
	return (PromoDialog_HasPages() && IsLobby() && IsFullyConnected() && GetActiveMenu() == GetMenu( "LobbyMenu" ) && IsTabPanelActive( GetPanel( "PlayPanel" ) ))
}


bool function IsPromoDialogNew()
{
	entity player = GetLocalClientPlayer()
	if ( player == null || !PromoDialog_CanShow() )
		return false

	return !file.hasViewedMOTDThisSession
}


void function InitPromoDialogUM( var newMenuArg )
{
	file.menu = newMenuArg

	file.prevPageButton = Hud_GetChild( newMenuArg, "PrevPageButton" )
	HudElem_SetRuiArg( file.prevPageButton, "flipHorizontal", true )
	Hud_AddEventHandler( file.prevPageButton, UIE_CLICK, Page_NavLeft )

	file.nextPageButton = Hud_GetChild( newMenuArg, "NextPageButton" )
	Hud_AddEventHandler( file.nextPageButton, UIE_CLICK, Page_NavRight )

	file.viewButton = Hud_GetChild( newMenuArg, "ViewButton" )
	Hud_AddEventHandler( file.viewButton, UIE_CLICK, GoToActivePageLink )

	file.viewButtonRui = Hud_GetRui( file.viewButton )

	file.promoPageRui = Hud_GetRui( Hud_GetChild( newMenuArg, "PromoPage" ) )

	file.promoPreviewActiveIndicator = Hud_GetChild( newMenuArg, "PromoPreviewActiveIndicator" )

	file.promoPreviewActiveIndicatorRui = Hud_GetRui( file.promoPreviewActiveIndicator  )

	file.promoPreviewButtons = Hud_GetChild( newMenuArg, "PromoPreviewButtons" )

	file.controlIndicator = Hud_GetChild( newMenuArg, "ControlIndicator" )

	file.footer = Hud_GetChild( newMenuArg, "FooterButtons" )

	for ( int index = 0; index < PROMO_DIALOG_MAX_PAGES; index++ )
	{
		string previewIndexName	= PROMO_PREVIEW_BUTTON_NAME + string( index )
		var previewButton = Hud_GetChild( file.promoPreviewButtons, previewIndexName )
		file.promoPreviewButtonsRui.append( Hud_GetRui( previewButton ) )
		Hud_AddEventHandler( previewButton, UIE_CLICK, PromoPreview_OnClick )
	}

	Hud_SetWidth( file.promoPreviewButtons, 0 )
	Hud_SetVisible( file.promoPreviewActiveIndicator, false )

	SetDialog( newMenuArg, true )
	SetGamepadCursorEnabled( newMenuArg, false )

	AddMenuEventHandler( newMenuArg, eUIEvent.MENU_OPEN, PromoDialog_OnOpen )
	AddMenuEventHandler( newMenuArg, eUIEvent.MENU_CLOSE, PromoDialog_OnClose )
	AddMenuEventHandler( newMenuArg, eUIEvent.MENU_NAVIGATE_BACK, PromoDialog_OnNavigateBack )
#if NX_PROG || PC_PROG_NX_UI
	AddMenuEventHandler( newMenuArg, eUIEvent.MENU_SHOW, PromoDialog_OnShow)
#endif

	AddMenuFooterOption( newMenuArg, LEFT, BUTTON_B, true, "#B_BUTTON_CLOSE", "#B_BUTTON_CLOSE" )

#if DEV
	AddMenuThinkFunc( newMenuArg, PromoDialogUMAutomationThink )
#endif       
}

void function PromoPreview_OnClick( var button )
{
	JumpToPage( int( Hud_GetScriptID( button ) ) )
}

void function PromoDialog_OpenHijackedUM( string titleText, string descText, string imageName )
{
	file.hasHijackContent = true
	file.hijackContent.titleText = titleText
	file.hijackContent.descText = descText
	file.hijackContent.imageName = imageName
	RunClientScript( "SetIsPromoImageHijacked", true )
	AdvanceMenu( file.menu )
}

void function PromoDialog_OnOpen()
{
	PromoDialog_InitPages()
	SetGamepadCursorEnabled( file.menu, true )
	file.numPages = file.promoPreviewButtonsRui.len() < PromoDialog_NumPages() ? file.promoPreviewButtonsRui.len() : PromoDialog_NumPages()

	if ( !file.hasHijackContent )
	{
		file.hasViewedMOTDThisSession = true

		                                                                                                             
		if ( file.pageIndexForJump < 1 )
			SendImpressionPINMessage( file.activePageIndex )
	}

	UpdatePageRui()
	UpdatePromoButtons()
	RegisterPageChangeInput()

	RegisterButtonPressedCallback( KEY_SPACE, GoToActivePageLink )
	RegisterButtonPressedCallback( BUTTON_X, GoToActivePageLink )

	UpdatePreviewButtonRui()
	UpdateViewButton()

	if ( file.pageIndexForJump >= 0 )
	{
		JumpToPage( file.pageIndexForJump )
		file.pageIndexForJump = -1
	}
}

#if DEV
void function PromoDialogUMAutomationThink( var menu )
{
	if (AutomateUi())
	{
		printt("PromoDialogUMAutomationThink CloseActiveMenu()")
		CloseActiveMenu()
	}
}
#endif       

#if NX_PROG || PC_PROG_NX_UI
void function PromoDialog_OnShow()
{
	UpdatePageRui()
	UpdatePromoButtons()
	RegisterPageChangeInput()
	
	UpdatePreviewButtonRui()

	UpdateViewButton()
}
#endif

void function PromoDialog_OnClose()
{
	DeregisterPageChangeInput()
	DeregisterButtonPressedCallback( KEY_SPACE, GoToActivePageLink )
	DeregisterButtonPressedCallback( BUTTON_X, GoToActivePageLink )
	file.activePageIndex = 0
	file.updateID = 0
	RuiSetInt( file.promoPreviewActiveIndicatorRui, "target", file.updateID )

	if ( file.hasHijackContent )
	{
		file.hasHijackContent = false
		RunClientScript( "SetIsPromoImageHijacked", false )
	}

	SocialEventUpdate()
}


void function PromoDialog_OnNavigateBack()
{
	CloseActiveMenu()
}

string function ParseLinkText( string link )
{
	int separatorIndex = link.find( ":" )

	if ( separatorIndex >= 0 )
	{
		string linkDataSubstring = link.slice( separatorIndex + 1, link.len() )
		string linkType = link.slice( 0, separatorIndex )

		if ( linkType == "battlepass" )
		{
			return "#PROMO_PAGE_VIEW_UNLOCK"
		}
		else if ( linkType == "storecharacter" )
		{
			return "#PROMO_PAGE_VIEW_UNLOCK"
		}
		else if ( linkType == "storeskin" )
		{
			return "#PROMO_PAGE_VIEW_UNLOCK"
		}
		else if ( linkType == "themedstoreskin" )
		{
			return "#PROMO_PAGE_VIEW_UNLOCK"
		}
		else if ( linkType == "collectionevent" )
		{
			return "#PROMO_PAGE_VIEW_LINK"
		}
		else if ( linkType == "url" )
		{
			return "#PROMO_PAGE_VIEW_LINK"
		}
		else if ( linkType == "storeoffer" )
		{
			return "#PROMO_PAGE_VIEW_BUY"
		}
		else
		{
			return "#PROMO_PAGE_VIEW_LINK"
		}
	}

	return "Invalid Link"
}

void function RegisterPageChangeInput()
{
	if ( file.pageChangeInputsRegistered )
		return

	RegisterButtonPressedCallback( BUTTON_SHOULDER_LEFT, Page_NavLeft )
	RegisterButtonPressedCallback( BUTTON_DPAD_LEFT, Page_NavLeft )
	RegisterButtonPressedCallback( KEY_LEFT, Page_NavLeft )
	AddCallback_OnMouseWheelUp( Page_NavLeftOnInput )

	RegisterButtonPressedCallback( BUTTON_SHOULDER_RIGHT, Page_NavRight )
	RegisterButtonPressedCallback( BUTTON_DPAD_RIGHT, Page_NavRight )
	RegisterButtonPressedCallback( KEY_RIGHT, Page_NavRight )
	AddCallback_OnMouseWheelDown( Page_NavRightOnInput )

	file.pageChangeInputsRegistered = true

	thread TrackDpadInput()
}


void function DeregisterPageChangeInput()
{
	if ( !file.pageChangeInputsRegistered )
		return

	DeregisterButtonPressedCallback( BUTTON_SHOULDER_LEFT, Page_NavLeft )
	DeregisterButtonPressedCallback( BUTTON_DPAD_LEFT, Page_NavLeft )
	DeregisterButtonPressedCallback( KEY_LEFT, Page_NavLeft )
	RemoveCallback_OnMouseWheelUp( Page_NavLeftOnInput )

	DeregisterButtonPressedCallback( BUTTON_SHOULDER_RIGHT, Page_NavRight )
	DeregisterButtonPressedCallback( BUTTON_DPAD_RIGHT, Page_NavRight )
	DeregisterButtonPressedCallback( KEY_RIGHT, Page_NavRight )
	RemoveCallback_OnMouseWheelDown( Page_NavRightOnInput )

	file.pageChangeInputsRegistered = false
}


void function TrackDpadInput()
{
	bool canChangePage = false

	while ( file.pageChangeInputsRegistered )
	{
		float xAxis = InputGetAxis( ANALOG_RIGHT_X )

		if ( !canChangePage )
			canChangePage = fabs( xAxis ) < 0.5

		if ( canChangePage )
		{
			if ( xAxis > 0.9 )
			{
				ChangePage( 1 )
				canChangePage = false
			}
			else if ( xAxis < -0.9 )
			{
				ChangePage( -1 )
				canChangePage = false
			}
		}

		WaitFrame()
	}
}


void function Page_NavLeft( var button )
{
	ChangePage( -1 )
}

void function Page_NavLeftOnInput()
{
	ChangePage( -1 )
}

void function Page_NavRight( var button )
{
	ChangePage( 1 )
}

void function Page_NavRightOnInput()
{
	ChangePage( 1 )
}

void function ChangePage( int delta )
{
	Assert( delta == -1 || delta == 1 )

	if ( file.hasHijackContent )
		return

	int newPageIndex = file.activePageIndex + delta
	if ( newPageIndex < 0 || newPageIndex >= file.numPages )
		return

	file.activePageIndex = newPageIndex
	SendImpressionPINMessage( file.activePageIndex )
	RuiSetInt( file.promoPreviewActiveIndicatorRui, "activePageIndex", file.activePageIndex )
	UpdatePageRui()
	TransitionPage( delta == 1 ? eTransType.SLIDE_LEFT : eTransType.SLIDE_RIGHT )
	thread TransitionViewButton( file.updateID )
	EmitUISound( "UI_Menu_MOTD_Tab" )

	UpdatePromoButtons()
}

void function JumpToPage( int pageIndex )
{
	if ( file.activePageIndex == pageIndex )
		return

	if ( pageIndex < 0 || pageIndex >= file.numPages )
		return

	int lastPageIndex = file.activePageIndex
	file.activePageIndex = pageIndex
	SendImpressionPINMessage( file.activePageIndex )

	RuiSetInt( file.promoPreviewActiveIndicatorRui, "activePageIndex", pageIndex )
	UpdatePageRui()
	TransitionPage( eTransType.NONE )
	RuiSetInt( file.promoPreviewActiveIndicatorRui, "target", file.updateID )
	UpdateViewButton()
	UpdatePromoButtons()
	EmitUISound( "UI_Menu_MOTD_Tab" )
}

void function SendImpressionPINMessage( int pageIndex )
{
	PromoDialogPageData page = file.pages[pageIndex]
	PIN_UM_Message( page.title, page.trackingId, PIN_MESSAGE_TYPE_PROMO, ePINPromoMessageStatus.IMPRESSION, pageIndex )
}

void function TransitionViewButton( int updateID )
{
	Hud_Hide( file.viewButton )
	if( !ActivePageHasLink() )
		return

	wait PROMO_TRANS_DURATION
	if( file.updateID == updateID )
		UpdateViewButton()
}

void function UpdateViewButton()
{
	bool isLinkVisible = ActivePageHasLink()
	Hud_SetVisible( file.viewButton, isLinkVisible )

	if ( !isLinkVisible )
		return

	RuiSetString( file.viewButtonRui, "buttonText", file.activePage.linkText )
}

void function UpdatePromoImage( var promoRui, PromoDialogPageData activePage, asset image, bool isLoading )
{
	RuiSetImage( promoRui, "imageAsset", image )
	RuiSetBool( promoRui, "isImageLoading", isLoading )
	RuiSetString( promoRui, "titleText", activePage.title )
	RuiSetString( promoRui, "descText", activePage.desc )
}

void function UpdateLeftPromoImage( var promoRui, PromoDialogPageData activePage, asset image, bool isLoading )
{
	RuiSetImage( promoRui, "leftImageAsset", image )
	RuiSetBool( promoRui, "isLeftImageLoading", isLoading )
	RuiSetString( promoRui, "leftTitleText", activePage.title )
	RuiSetString( promoRui, "leftDescText", activePage.desc )
}

void function UpdateRightPromoImage( var promoRui, PromoDialogPageData activePage, asset image, bool isLoading )
{
	RuiSetImage( promoRui, "rightImageAsset", image )
	RuiSetBool( promoRui, "isRightImageLoading", isLoading )
	RuiSetString( promoRui, "rightTitleText", activePage.title )
	RuiSetString( promoRui, "rightDescText", activePage.desc )
}

void function UpdatePageRui()
{
	array<PromoDialogPageData> pages = file.pages

	var promoRui = file.promoPageRui

	if ( file.hasHijackContent )
	{
		RuiSetImage( promoRui, "imageAsset", GetPromoImage( file.hijackContent.imageName ) )
		RuiSetBool( promoRui, "isImageLoading", false )
		RuiSetString( promoRui, "titleText", file.hijackContent.titleText )
		RuiSetString( promoRui, "descText", file.hijackContent.descText )

		RuiSetBool( promoRui, "isRightImageLoading", true)
		RuiSetBool( promoRui, "isLeftImageLoading", true )
	}
	else
	{
		if( !pages.len() )
			return

		int pageIndex = file.activePageIndex
		PromoDialogPageData page = pages[pageIndex]
		file.activePage = page

		bool downloaded =  GetConVarBool( "assetdownloads_enabled" )

		if( downloaded )
		{
			var promoElem = Hud_GetChild( file.menu, "PromoPage" )
			UpdatePromoImage( promoRui, page, GetDownloadedImageAsset( page.imageName, page.imageName,
				ePakType.DL_PROMO, promoElem ), IsImagePakLoading( page.imageName ) )
		}
		else
		{
			UpdatePromoImage( promoRui, page , pages[pageIndex].image, false )
		}

		if ( pageIndex - 1 >= 0 )
		{
			if( downloaded )
			{
				UpdateLeftPromoImage( promoRui, pages[pageIndex - 1] ,GetDownloadedImageAsset( page.imageName,
					pages[pageIndex - 1].imageName, ePakType.DL_PROMO ), IsImagePakLoading( page.imageName ) )
			}
			else
			{
				UpdateLeftPromoImage( promoRui, pages[pageIndex - 1] , pages[pageIndex - 1].image, false )
			}
		}
		else
		{
			RuiSetBool( promoRui, "isLeftImageLoading", true )
		}

		if ( pageIndex + 1 < file.numPages )
		{
			if( downloaded )
			{
				UpdateRightPromoImage( promoRui, pages[pageIndex + 1] ,GetDownloadedImageAsset( page.imageName, pages[pageIndex + 1].imageName, ePakType.DL_PROMO ), IsImagePakLoading( page.imageName ) )
			}
			else
			{
				UpdateRightPromoImage( promoRui, pages[pageIndex + 1] , pages[pageIndex + 1].image, false )
			}
		}
		else
		{
			RuiSetBool( promoRui, "isRightImageLoading", true )
		}
	}
}

void function UpdatePreviewButtonRui()
{
	if ( !file.hasHijackContent )
	{
		RuiSetInt( file.promoPreviewActiveIndicatorRui, "activePageIndex", file.activePageIndex )
		RuiSetInt( file.promoPreviewActiveIndicatorRui, "updateID", file.updateID )
		RuiSetFloat(file.promoPreviewActiveIndicatorRui, "promoPageWidth", ContentScaledX( 240 ) )

		                                 
		Hud_SetWidth( file.promoPreviewButtons, ContentScaledXAsInt( 242 * file.numPages ) )
		Hud_SetVisible( file.promoPreviewActiveIndicator, bool( file.pages.len() ) )

		for ( int i = 0; i < file.numPages; i++ )
		{
			PromoDialogPageData page = file.pages[i]
			var rui = file.promoPreviewButtonsRui[i]
			RuiSetBool( rui, "isPageActive", true )

			if( GetConVarBool( "assetdownloads_enabled" ) )
			{
				var previewButton = Hud_GetChild( file.promoPreviewButtons, PROMO_PREVIEW_BUTTON_NAME + string( i ) )
				RuiSetImage( rui, "imageAsset", GetDownloadedImageAsset( page.imageName, page.imageName, ePakType.DL_PROMO, previewButton ) )
				RuiSetBool( rui, "isImageLoading", IsImagePakLoading( page.imageName ) )
			}
			else
			{
				RuiSetImage( rui, "imageAsset", page.image )
			}
			RuiSetString( rui, "titleText", page.title )
		}
	}
	else
	{
		Hud_SetWidth( file.promoPreviewButtons, 0 )
		Hud_SetVisible( file.promoPreviewActiveIndicator, false )
	}
}


void function TransitionPage( int transType )
{
	file.updateID++
	RuiSetInt( file.promoPageRui, "transType", transType )
	RuiSetInt( file.promoPageRui, "updateID", file.updateID )
	RuiSetInt( file.promoPreviewActiveIndicatorRui, "updateID", file.updateID )

}

void function UpdatePromoButtons()
{
	if ( file.hasHijackContent )
	{
		Hud_Hide( file.prevPageButton )
		Hud_Hide( file.nextPageButton )
		UpdateFooterOptions()
		Hud_Hide( file.controlIndicator )
		Hud_SetPos( file.footer, ( Hud_GetWidth( file.footer ) * 0.5 ) + 7.0 , 0 )
		return
	}
	float newXPos = bool( file.numPages ) ? float( Hud_GetWidth( file.footer ) + 11 ) : ( Hud_GetWidth( file.footer ) * 0.5 ) + 7.0
    Hud_SetPos( file.footer, newXPos, 0 )
	Hud_SetVisible( file.controlIndicator, bool( file.numPages ) )

	if ( file.activePageIndex == 0 )
		Hud_Hide( file.prevPageButton )
	else
		Hud_Show( file.prevPageButton )

	if ( file.activePageIndex == file.numPages - 1 )
		Hud_Hide( file.nextPageButton )
	else
		Hud_Show( file.nextPageButton )

	UpdateFooterOptions()
}


bool function ActivePageHasLink()
{
	if ( file.hasHijackContent )
		return false

	return file.activePage.linkType != "" && file.activePage.linkText != ""
}


void function GoToActivePageLink( var button )
{
	PromoDialogPageData page = file.activePage

	if ( page.linkType == "" )
		return

	PIN_UM_Message( page.title, page.trackingId, PIN_MESSAGE_TYPE_PROMO, ePINPromoMessageStatus.CLICK, file.activePageIndex )
	OpenPromoLink( page.linkType, page.link )
}


string function ViewButtonTextFromLinkType( string linkType )
{
	if ( linkType == "battlepass" )
	{
		return "#PROMO_PAGE_VIEW_UNLOCK"
	}
	else if ( linkType == "storecharacter" )
	{
		return "#PROMO_PAGE_VIEW_UNLOCK"
	}
	else if ( linkType == "storeskin" )
	{
		return "#PROMO_PAGE_VIEW_UNLOCK"
	}
	else if ( linkType == "themedstoreskin" )
	{
		return "#PROMO_PAGE_VIEW_UNLOCK"
	}
	else if ( linkType == "collectionevent" )
	{
		return "#PROMO_PAGE_VIEW_LINK"
	}
	else if ( linkType == "url" )
	{
		return "#PROMO_PAGE_VIEW_LINK"
	}
	else if ( linkType == "storeoffer" )
	{
		return "#PROMO_PAGE_VIEW_LINK"
	}
	else
	{
		return "#PROMO_PAGE_VIEW_LINK"
	}
	unreachable
}

void function PromoDialog_OpenToPage( int pageIndex )
{
	file.pageIndexForJump = pageIndex
	AdvanceMenu( file.menu )
}

void function UICodeCallback_UMRequestFinished( int result )
{
	SetNewsButtonTooltip( result )
}