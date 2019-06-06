global function InitMiniPromo
global function StartMiniPromo
global function StopMiniPromo

const MINI_PROMO_MAX_PAGES = 5
const MINI_PROMO_PAGE_CHANGE_DELAY = 7

struct MiniPromoPageData
{
	asset  image = $""
	string header = ""
	string title = ""
	string desc = ""
	string linkType = ""
	string linkRef1 = ""
	string linkRef2 = ""
}

struct
{
	array<MiniPromoPageData> pages
	int activePageIndex = 0
	var button

	table signalDummy
} file


void function InitMiniPromo( var button )
{
	RegisterSignal( "EndCyclePages" )

	file.button = button

	Hud_AddEventHandler( button, UIE_CLICK, MiniPromoButton_OnActivate )
}


void function StartMiniPromo()
{
	Signal( file.signalDummy, "EndCyclePages" )

	UpdatePromoData()

	if ( !IsPromoDataProtocolValid() )
	{
		Hud_Hide( file.button )
		return
	}

	//
	file.pages = InitPages()
	int numPages = file.pages.len()

	if ( numPages < 1 )
	{
		Hud_Hide( file.button )
		return
	}

	Hud_Show( file.button )
	RuiSetInt( Hud_GetRui( file.button ), "pageCount", numPages )

	thread CyclePages()
}


void function StopMiniPromo()
{
	Hud_Hide( file.button )

	Signal( file.signalDummy, "EndCyclePages" )
}


array<MiniPromoPageData> function InitPages()
{
	string content = "" //
	//
	//
	//

	//
	array< array<string> > matches = RegexpFindAll( content, "<m\\|([^>\\|]*)\\|([^>\\|]*)\\|([^>\\|]*)\\|([^>\\|]*)\\|([^>\\|]*)>" )
	if ( matches.len() > MINI_PROMO_MAX_PAGES )
	{
		Warning( "Ignoring extra mini promo pages! Found " + matches.len() + " pages and only " + MINI_PROMO_MAX_PAGES + " are supported." )
		matches.resize( MINI_PROMO_MAX_PAGES )
	}

	array<MiniPromoPageData> pages

	foreach ( vals in matches )
	{
		//
		//
		//

		MiniPromoPageData newPage
		//
		newPage.image = GetPromoImage( vals[1] )
		newPage.header = vals[2]
		newPage.title = vals[3]
		newPage.desc = vals[4]

		if ( vals[5] != "" )
		{
			array<string> linkVals = split( vals[5], ":" )

			if ( linkVals.len() == 2 || linkVals.len() == 3 )
			{
				newPage.linkType = linkVals[0]
				newPage.linkRef1 = linkVals[1]

				if ( linkVals.len() == 3 )
					newPage.linkRef2 = linkVals[2]
			}
			else
			{
				Warning( "Ignoring invalid mini promo link format (" + vals[5] + ")! Expected 2 or 3 parts but found " + linkVals.len() + "." )
			}
		}

		pages.append( newPage )
	}

	return pages
}


void function CyclePages()
{
	//
	Signal( file.signalDummy, "EndCyclePages" )
	EndSignal( file.signalDummy, "EndCyclePages" )

	int pageIndex = 0
	SetPage( pageIndex, true )

	int numPages = file.pages.len()
	if ( numPages == 1 )
		return

	while ( true )
	{
		wait MINI_PROMO_PAGE_CHANGE_DELAY

		pageIndex++
		if ( pageIndex >= numPages )
			pageIndex = 0

		SetPage( pageIndex )
	}
}


void function SetPage( int pageIndex, bool instant = false )
{
	//

	var rui = Hud_GetRui( file.button )

	float time = instant ? Time() - 10 : Time()
	RuiSetGameTime( rui, "initTime", time )

	int lastActivePage = file.activePageIndex
	file.activePageIndex = pageIndex

	MiniPromoPageData lastPage = file.pages[lastActivePage]
	RuiSetImage( rui, "lastImageAsset", lastPage.image )
	RuiSetString( rui, "lastHeaderText", lastPage.header )
	RuiSetString( rui, "lastTitleText", lastPage.title )
	RuiSetString( rui, "lastDescText", lastPage.desc )

	MiniPromoPageData page = file.pages[file.activePageIndex]
	RuiSetImage( rui, "imageAsset", page.image )
	RuiSetString( rui, "headerText", page.header )
	RuiSetString( rui, "titleText", page.title )
	RuiSetString( rui, "descText", page.desc )

	RuiSetInt( rui, "activePageIndex", file.activePageIndex )
}


//
//
void function MiniPromoButton_OnActivate( var button )
{
	printt( "*** MiniPromoButton_OnActivate ***" )

	MiniPromoPageData page = file.pages[file.activePageIndex]

	if ( page.linkType == "lobbytab" )
	{
		TabData lobbyTabData = GetTabDataForPanel( GetMenu( "LobbyMenu" ) )
		ActivateTab( lobbyTabData, Tab_GetTabIndexByBodyName( lobbyTabData, page.linkRef1 ) )
	}
	else if ( page.linkType == "storetab" )
	{
		if ( IsValidItemFlavorHumanReadableRef( page.linkRef2 ) )
		{
			ItemFlavor character = GetItemFlavorByHumanReadableRef( page.linkRef2 )
			if ( !GRX_IsItemOwnedByPlayer( character ) )
				JumpToStoreCharacter( character )
		}
	}

	//
}