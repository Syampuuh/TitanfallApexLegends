global function InitClubsSearchMenu
global function OpenClubSearchMenu
global function CloseClubsSearchMenu

global function ClubSearch_ProcessSearchResults

const int SEARCH_RESULTS_PER_PAGE = 10
const string SEARCH_SETTINGS_CHANGED = "SearchSettingsChanged"
const float SEARCH_UPDATE_WAIT_TIME = 1.0

enum eClubSearchLabelResult
{
	INVALID_TAG = -5,
	INVALID_NAME,
	DEFAULT,
	NAME_TOO_SHORT,
	SEARCHING,
	RESULTS_ZERO,
	RESULTS_ONE,
	RESULTS_MULTIPLE,

	_count
}

struct
{
	var menu
	var searchHeaderRui

	var settingsPanel
	var clubNameField
	var clubTagField

	var clubSettingsLabel
	var privacySetting
	var minAccountLvlSetting
	var minAccountReqFrame
	var minRankSetting
	var minRankReqFrame

	int selectedPrivacy = CLUB_PRIVACY_SEARCH_ANY
	int selectedAccountLvl = eClubMinAccountLevel.MINLVL_10
	int selectedRank = eClubMinRank.MINRANK_BRONZE

	bool changingSearchTags
	var searchTagGridPanel
	var searchTagGrid
	array<var> searchTagButtons

	array<var> activePageButtons
	array<ClubHeader> searchResults
	var searchResultGrid
	array<var> searchResultButtons
	table< var, ClubHeader > resultButtonToClubMap

	var searchResultLabel
} file

void function InitClubsSearchMenu( var menu )
{
	printf( "ClubsDebug: Init Club Search Menu" )

	RegisterSignal( SEARCH_SETTINGS_CHANGED )

	file.menu = GetMenu( "ClubsSearchMenu" )

	file.searchHeaderRui = Hud_GetRui( Hud_GetChild( menu, "MenuHeader" ) )
	RuiSetString( file.searchHeaderRui, "menuName", "#LOBBY_CLUBS_SEARCH" )

	file.settingsPanel = Hud_GetChild( file.menu, "SearchSettingsPanel" )

	file.clubNameField = Hud_GetChild( file.settingsPanel, "ClubNameTextEntry" )
	AddButtonEventHandler( file.clubNameField, UIE_CHANGE, ClubName_OnChanged )
	file.clubTagField = Hud_GetChild( file.settingsPanel, "ClubTagTextEntry" )
	AddButtonEventHandler( file.clubTagField, UIE_CHANGE, ClubTag_OnChanged )

	file.clubSettingsLabel = Hud_GetChild( file.settingsPanel, "ClubSettingsLabel" )
	HudElem_SetRuiArg( file.clubSettingsLabel, "textOverride", "#LOBBY_CLUBS_ACCESS_SETTINGS" )
	HudElem_SetRuiArg( file.clubSettingsLabel, "fontSizeOverride", 35.0 )
	HudElem_SetRuiArg( file.clubSettingsLabel, "backgroundAlpha", 0.0 )

	file.privacySetting = Hud_GetChild( file.settingsPanel, "ClubPrivacySwitch" )
	file.minAccountLvlSetting = Hud_GetChild( file.settingsPanel, "ClubLvlReqSwitch" )
	file.minRankSetting = Hud_GetChild( file.settingsPanel, "ClubRankReqSwitch" )
	InitSettingsButtons()

	file.minAccountReqFrame = Hud_GetChild( file.settingsPanel, "ClubLvlReqSwitchFrame" )
	file.minRankReqFrame = Hud_GetChild( file.settingsPanel, "ClubRankReqSwitchFrame" )

	file.searchTagGridPanel = Hud_GetChild( file.settingsPanel, "SearchTagsPanel" )
	file.searchTagGrid = Hud_GetChild( file.searchTagGridPanel, "SearchTagsGrid" )

	file.searchResultGrid = Hud_GetChild( file.menu, "SearchResultsGrid" )

	file.searchResultLabel = Hud_GetChild( file.menu, "SearchResultsLabel" )
	Hud_SetText( file.searchResultLabel, Localize( "#LOBBY_CLUBS_SEARCH_LABEL" ) )

	InitPageIndexButtons()

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnOpen )
	AddMenuEventHandler( menu, eUIEvent.MENU_GET_TOP_LEVEL, OnGainTopLevel )
	AddMenuEventHandler( menu, eUIEvent.MENU_LOSE_TOP_LEVEL, OnLoseTopLevel )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, OnClose )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, OnNavigateBack )

	AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "#B_BUTTON_CLOSE", "#B_BUTTON_CLOSE", null, CanNavigateBack )
}

const int PAGE_BUTTON_COUNT = 5
void function InitPageIndexButtons()
{
	for ( int i = 0; i < PAGE_BUTTON_COUNT; i++ )
	{
		string pageButtonString = format( "ResultsPageButton0%d", i )
		var indexButton         = Hud_GetChild( file.menu, pageButtonString )
		AddButtonEventHandler( indexButton, UIE_CLICK, SearchPageIndexButton_OnActivate )
	}
}

void function OpenClubSearchMenu()
{
	AdvanceMenu( file.menu )
}


void function OnOpen()
{
	thread SetSettingsButtonDefaultsThread()

	                                
}


void function OnGainTopLevel()
{
	InitSearchTagsPanel()

	if ( file.changingSearchTags )
	{
		file.changingSearchTags = false
		thread SettingsUpdatedThread()
	}
	else
	{
		printf( "OnClubsSearchMenuGainTopLevel: Search tags unchanged" )
	}
}


void function OnLoseTopLevel()
{
	printf( "ClubsDebug: OnClubsSearchMenuLoseTopLevel" )
	                                                                 
}


void function OnClose()
{
	printf( "ClubsDebug: OnCloseClubSearchMenu" )
	file.changingSearchTags = false
	ClubSearchTag_ClearSelectedSearchTags()
	HideResults()
	UpdateSearchResultsLabel( -3 )
}


bool function CanNavigateBack()
{
	if ( GetActiveMenu() != file.menu )
		return false

	return true
}


void function OnNavigateBack()
{
	if ( !CanNavigateBack() )
		return

	CloseActiveMenu()
}

var function InitSettingsButtons()
{
	AddButtonEventHandler( file.privacySetting, UIE_CHANGE, PrivacySetting_OnChanged )
	AddButtonEventHandler( file.minAccountLvlSetting, UIE_CHANGE, AccountLevelSetting_OnChanged )
	AddButtonEventHandler( file.minRankSetting, UIE_CHANGE, RankSetting_OnChanged )
}

void function SetSettingsButtonDefaultsThread()
{
	file.selectedPrivacy = CLUB_PRIVACY_SEARCH_ANY
	file.selectedAccountLvl = eClubMinAccountLevel.MINLVL_10
	file.selectedRank = eClubMinRank.MINRANK_BRONZE

	Hud_SetDialogListSelectionIndex( file.privacySetting, 0 )
	Hud_SetDialogListSelectionIndex( file.minAccountLvlSetting, 0 )
	Hud_SetDialogListSelectionIndex( file.minRankSetting, 0 )

	WaitFrame()
	WaitFrame()
	WaitFrame()

	UpdateSettingLocks()
	UpdateDpadNav()

	thread SettingsUpdatedThread()
}

void function ClubName_OnChanged( var button )
{
	                           
	thread SettingsUpdatedThread()
}

void function ClubTag_OnChanged( var button )
{
	thread SettingsUpdatedThread()
}

void function PrivacySetting_OnChanged( var button )
{
	thread SetSelectedPrivacyFromSettingThread()

	thread SettingsUpdatedThread()
}

void function SetSelectedPrivacyFromSettingThread()
{
	WaitFrame()                                                              

	int currentSetting = Hud_GetDialogListSelectionIndex( file.privacySetting )
	                                                                                        
	int selectedPrivacy
	switch ( currentSetting )
	{
		case 3:
			selectedPrivacy = CLUB_PRIVACY_BY_REQUEST
			break
		case 2:
			selectedPrivacy = CLUB_PRIVACY_OPEN_WITH_REQ
			break
		case 1:
			selectedPrivacy = CLUB_PRIVACY_OPEN
			break
		case 0:
			selectedPrivacy = CLUB_PRIVACY_SEARCH_ANY
			break
	}

	file.selectedPrivacy = selectedPrivacy
	UpdateSettingLocks()
	printf( "ClubSettingsDebug: Privacy Setting Changed. New privacy level converted from %i to %i (%i)", currentSetting, file.selectedPrivacy, selectedPrivacy )
}

void function UpdateSettingLocks()
{
	printf( "ClubSettingsDebug: %s(): Current Privacy Setting = %i", FUNC_NAME(), file.selectedPrivacy )
	bool isSearchSetToRestricted = (file.selectedPrivacy == CLUB_PRIVACY_OPEN_WITH_REQ)

	if ( !isSearchSetToRestricted )
	{
		file.selectedAccountLvl = 0
		Hud_SetDialogListSelectionIndex( file.minAccountLvlSetting, file.selectedAccountLvl )
		file.selectedRank = 0
		Hud_SetDialogListSelectionIndex( file.minRankSetting, file.selectedRank )

	}
	HudElem_SetRuiArg( file.minAccountReqFrame, "isSettingLocked", !isSearchSetToRestricted )
	HudElem_SetRuiArg( file.minRankReqFrame, "isSettingLocked", !isSearchSetToRestricted )

	Hud_SetLocked( file.minAccountLvlSetting, !isSearchSetToRestricted )
	Hud_SetLocked( file.minRankSetting, !isSearchSetToRestricted )
}

void function AccountLevelSetting_OnChanged( var button )
{
	file.selectedAccountLvl = Hud_GetDialogListSelectionIndex( Hud_GetChild( file.settingsPanel, "ClubLvlReqSwitch" ) )
	thread SettingsUpdatedThread()
}

void function RankSetting_OnChanged( var button )
{
	file.selectedRank = Hud_GetDialogListSelectionIndex( Hud_GetChild( file.settingsPanel, "ClubRankReqSwitch" ) )
	thread SettingsUpdatedThread()
}

void function InitSearchTagsPanel()
{
	printf(	"ClubSearchDebug: InitSearchTagsPanel()" )
	array<ItemFlavor> selectedSearchTags = clone( ClubSearchTag_GetSelectedSearchTags() )
	int buttonCount = selectedSearchTags.len()

	foreach ( var button in file.searchTagButtons )
	{
		Hud_RemoveEventHandler( button, UIE_CLICK, SearchTagButton_OnClick )
	}

	if ( file.searchTagButtons.len() > buttonCount )
	{
		file.searchTagButtons.resize( buttonCount )
	}

	if ( buttonCount < CLUB_SEARCH_TAG_SELECTION_MAX )
	{
		buttonCount++
	}

	printf(	"ClubSearchDebug: Search Tag Button Count: %i", buttonCount )

	Hud_InitGridButtons( file.searchTagGrid, buttonCount )
	var gridScrollPanel = Hud_GetChild( file.searchTagGrid, "ScrollPanel" )
	int buttonIdx

	for( int tagIndex; tagIndex < buttonCount; tagIndex++ )
	{
		var button = Hud_GetChild( gridScrollPanel, format( "GridButton%d", tagIndex ) )

		buttonIdx = file.searchTagButtons.find( button )
		if ( buttonIdx == -1 )
		{
			printf( "ClubSearchDebug: Appending search tag button to array" )
			file.searchTagButtons.append( button )
		}
	}

	foreach ( var button in file.searchTagButtons )
	{
		InitSearchTagButton( button )
	}
}

void function InitSearchTagButton( var button )
{
	int buttonIdx = file.searchTagButtons.find( button )
	Assert( buttonIdx >= 0, "Club Search: Attempted to get index for non-existant or unregistered search tag button" )

	array<ItemFlavor> selectedSearchTags = clone( ClubSearchTag_GetSelectedSearchTags() )

	bool isAddButton = buttonIdx + 1 > selectedSearchTags.len()

	InitButtonRCP( button )

	if ( !isAddButton )
	{
		string buttonText = ClubSearchTag_GetTagString( selectedSearchTags[ buttonIdx ] )
		HudElem_SetRuiArg( button, "buttonText", buttonText )
	}
	else
	{
		HudElem_SetRuiArg( button, "buttonText", "" )
	}

	Hud_AddEventHandler( button, UIE_CLICK, SearchTagButton_OnClick )
	Hud_Show( button )
}

void function SearchTagButton_OnClick( var button )
{
	int buttonIdx = file.searchTagButtons.find( button )
	Assert( buttonIdx >= 0, "Club Search: Attempted to get index for non-existant or unregistered search tag button" )
	printf( "ClubSearchDebug: Player clicked on button index %i", buttonIdx )

	file.changingSearchTags = true
	OpenSearchTagDialog()
}

void function SettingsUpdatedThread()
{
	Signal( uiGlobal.signalDummy, SEARCH_SETTINGS_CHANGED )
	EndSignal( uiGlobal.signalDummy, SEARCH_SETTINGS_CHANGED )

	OnThreadEnd(
		function() : ()
		{
			printf( "ClubSearchDebug: Club Search Thread Ended" )
		}
	)

	wait( SEARCH_UPDATE_WAIT_TIME )

	thread OnSearchSettingsChanged()
}

void function OnSearchSettingsChanged()
{
	printf( "ClubSearchDebug: Settings Changed" )
	Signal( uiGlobal.signalDummy, SEARCH_SETTINGS_CHANGED )

	int unicodeLen = Hud_GetUnicodeLen( file.clubNameField )
	if ( unicodeLen > 0 && unicodeLen < 3 )
	{
		UpdateSearchResultsLabel( -2 )
		return
	}

	string clubName = Hud_GetUTF8Text( file.clubNameField )
	if ( !ClubIsValidName( clubName )  )
	{
		UpdateSearchResultsLabel( -4 )
		return
	}

	string clubTag = Hud_GetUTF8Text( file.clubTagField )
	if ( clubTag.len() > 0 && !Clubs_IsValidClubTag( clubTag ) )
	{
		UpdateSearchResultsLabel( -5 )
		return
	}

	UpdateSearchResultsLabel( -1 )
	array<ItemFlavor> selectedTags = clone( ClubSearchTag_GetSelectedSearchTags() )

	bool anyDataCenter = false
	if ( clubName != "" || clubTag != "" )
		anyDataCenter = true

	string pinSearchTerms = clubName + ", " + clubTag
	string pinSearchFilters = Clubs_GetDescStringForPrivacyLevel( file.selectedPrivacy ) + ", " + Clubs_GetDescStringForMinAccountLevel( file.selectedAccountLvl ) + ", " + Clubs_GetDescStringForMinRank( file.selectedRank ) + ", "
	string searchTagNames
	foreach ( tag in selectedTags )
	{
		string delimiter = selectedTags.find( tag ) == selectedTags.len() - 1 ? "" : ", "
		searchTagNames = Localize( ClubSearchTag_GetTagString( tag ) ) + delimiter
	}
	pinSearchFilters = pinSearchFilters + searchTagNames

	PIN_Club_Search( pinSearchTerms, pinSearchFilters )
	Clubs_Search( clubName, clubTag, file.selectedPrivacy, file.selectedAccountLvl, file.selectedRank, selectedTags, 100, anyDataCenter )
}

void function ClubSearch_ProcessSearchResults()
{
	if ( GetActiveMenu() != file.menu )
		return

	file.searchResults.clear()

	printf( "ClubSearchDebug: Processing Search Results" )

	array<ClubHeader> searchResults = ClubGetSearchResults()
	if ( searchResults.len() == 0 )
	{
		UpdateSearchResultsLabel( searchResults.len() )
		printf( "ClubSearchDebug: 0 results." )
		HideResults()
		return
	}

	int nameLen = Hud_GetUnicodeLen( file.clubNameField )
	int tagLen = Hud_GetUnicodeLen( file.clubTagField )

	for ( int i = 0; i < searchResults.len(); i++ )
	{
		if ( ClubIsValid() && searchResults[i].clubID == ClubGetHeader().clubID )
			continue

		if ( Clubs_DoesMeetJoinRequirements( searchResults[i] ) || nameLen != 0 || tagLen != 0 )
			file.searchResults.append( searchResults[i] )
	}
	file.searchResults.sort( SortSearchResults )
	if ( file.searchResults.len() > CLUB_SEARCH_MAX_RESULTS )
	{
		file.searchResults.resize( CLUB_SEARCH_MAX_RESULTS )
	}

	UpdateSearchResultsLabel( file.searchResults.len() )
	ConfigurePageIndexButtons()
}

int function SortSearchResults( ClubHeader a, ClubHeader b )
{
	if ( CountMatchingSearchTags( a.searchTags ) > CountMatchingSearchTags( b.searchTags ) )
		return -1
	if ( CountMatchingSearchTags( a.searchTags ) < CountMatchingSearchTags( b.searchTags ) )
		return 1
	if ( a.memberCount > b.memberCount )
		return -1
	if ( a.memberCount < b.memberCount )
		return 1

	return 0
}

int function CountMatchingSearchTags( int searchTagMask )
{
	int matchCount
	array<ItemFlavor> searchTags = ClubSearchTag_GetItemFlavorsFromBitMask( searchTagMask )
	array<ItemFlavor> selectedTags = ClubSearchTag_GetSelectedSearchTags()
	foreach ( searchTag in searchTags )
	{
		if ( selectedTags.contains( searchTag ) )
			matchCount++
	}

	return matchCount
}

void function ConfigurePageIndexButtons()
{
	                                                    
	foreach( button in file.activePageButtons )
	{
		Hud_SetVisible( button, false )
	}
	file.activePageButtons.clear()

	float buttonCount = float( file.searchResults.len() ) / float( SEARCH_RESULTS_PER_PAGE )
	Assert( buttonCount <= 5, "Clubs: Attempted to index too many search results" )

	int buttonCountInt
	if ( buttonCount > 1.0 )
	{
		float integral = floor( buttonCount )
		buttonCountInt = int( integral )
		float decimal = buttonCount % 1
		if ( buttonCount < 5 && decimal > 0 )
		{
			buttonCountInt++
		}
		printf( "ClubSearchMenuDebug: %s(): buttonCount = %f, integral = %f, decimal = %f, buttonCountInt = %i", FUNC_NAME(), buttonCount, integral, decimal, buttonCountInt )
	}
	printf( "ClubSearchMenuDebug: %s(): Dividing %i results amongst %i pages", FUNC_NAME(), file.searchResults.len(), buttonCountInt )

	                                                                                                                           
	for ( int i = 0; i < buttonCountInt; i++ )
	{
		string pageButtonString = format( "ResultsPageButton0%d", i )
		                                                                                                            

		var indexButton         = Hud_GetChild( file.menu, pageButtonString )
		int displayIndex =  (buttonCountInt - i)
		                                                                                                                                    
		HudElem_SetRuiArg( indexButton, "buttonIndex", displayIndex )
		file.activePageButtons.append( indexButton )
	}

	foreach( button in file.activePageButtons )
	{
		Hud_SetVisible( button, true )
	}

	file.activePageButtons.reverse()
	SearchPageIndexButton_SetActivePage( 0 )
}

void function SearchPageIndexButton_OnActivate( var button )
{
	int index = file.activePageButtons.find( button )
	if ( index == -1 )
		return

	SearchPageIndexButton_SetActivePage( index )
}

void function SearchPageIndexButton_SetActivePage( int pageIndex )
{
	foreach ( button in file.activePageButtons )
	{
		bool isActive = ( file.activePageButtons[pageIndex] == button )
		HudElem_SetRuiArg( button, "activeIndex", isActive )
	}

	array<ClubHeader> results
	int startResult = pageIndex * SEARCH_RESULTS_PER_PAGE
	if ( startResult < file.searchResults.len() )
	{
		int endResult = minint( (startResult + SEARCH_RESULTS_PER_PAGE - 1), (file.searchResults.len() - 1) )

		for ( int i = startResult; i <= endResult; i++ )
		{
			results.append( file.searchResults[i] )
		}
	}

	                                                                                                                                   
	UpdateResultsGrid( results )
}

void function HideResults()
{
	foreach ( var button in file.searchResultButtons )
	{
		Hud_Hide( button )
	}
}

void function UpdateResultsGrid( array<ClubHeader> displayResults )
{
	printf( "ClubSearchDebug: UpdateResultsGrid" )

	int buttonCount = displayResults.len()
	                                                                                               

	foreach ( var button in file.searchResultButtons )
	{
		Hud_RemoveEventHandler( button, UIE_CLICK, SearchResultButton_OnClick )
		Hud_RemoveEventHandler( button, UIE_CLICKRIGHT, SearchResultButton_OnClickRight )
		Hud_Hide( button )
	}

	if ( file.searchResultButtons.len() > buttonCount )
	{
		file.searchResultButtons.resize( buttonCount )
	}

	Hud_InitGridButtons( file.searchResultGrid, buttonCount )
	var scrollPanel = Hud_GetChild( file.searchResultGrid, "ScrollPanel" )
	for ( int btnIdx; btnIdx < buttonCount; btnIdx++ )
	{
		var button = Hud_GetChild( scrollPanel, format( "GridButton%d", btnIdx ) )
		ClubHeader resultHeader = displayResults[btnIdx]

		if ( !file.searchResultButtons.contains( button ) )
			file.searchResultButtons.append( button )

		file.resultButtonToClubMap[ button ] <- resultHeader
		Clubs_InitSearchResultButton( button, resultHeader )
	}

	foreach( var button in file.searchResultButtons )
	{
		Hud_AddEventHandler( button, UIE_CLICK, SearchResultButton_OnClick )
		Hud_AddEventHandler( button, UIE_CLICKRIGHT, SearchResultButton_OnClickRight )
	}

	UpdateDpadNav()
}

void function UpdateSearchResultsLabel( int resultCount = 0 )
{
	printf( "ClubSearchDebug: UpdateSearchResultsLabel (%i results)", resultCount )
	string resultString
	switch( resultCount )
	{
		case eClubSearchLabelResult.INVALID_TAG:
			resultString = Localize( "#CLUB_OP_FAIL_SEARCH_INVALIDTAG" )
			break
		case eClubSearchLabelResult.INVALID_NAME:
			resultString = Localize( "#CLUB_OP_FAIL_INVALIDNAME" )
			break
		case eClubSearchLabelResult.DEFAULT:
			resultString = Localize( "#LOBBY_CLUBS_SEARCH_LABEL" )
			break
		case eClubSearchLabelResult.NAME_TOO_SHORT:
			resultString = Localize( "#CLUB_OP_FAIL_SEARCH_NAMELENGTH" )
			break
		case eClubSearchLabelResult.SEARCHING:
			resultString = Localize( "#LOBBY_CLUBS_SEARCH_SEARCHING" )
			break
		case eClubSearchLabelResult.RESULTS_ZERO:
			resultString = Localize( "#LOBBY_CLUBS_SEARCH_RESULTS_ZERO" )
			break
		case eClubSearchLabelResult.RESULTS_ONE:
			resultString = Localize( "#LOBBY_CLUBS_SEARCH_RESULTS_ONE" )
			break
		default:
			resultString = Localize( "#LOBBY_CLUBS_SEARCH_RESULTS", resultCount )
			break
	}

	Hud_SetText( file.searchResultLabel, resultString )
}

void function UpdateDpadNav()
{
	Hud_SetNavDown( file.minRankSetting, file.searchTagButtons[0] )
	Hud_SetNavUp( file.searchTagButtons[0], file.minRankSetting )

	if ( file.searchResultButtons.len() > 0 )
	{
		Hud_SetNavRight( file.clubTagField, file.searchResultButtons[0] )

		for ( int i = 0; i < file.searchResultButtons.len(); i++ )
		{
			Hud_SetNavLeft( file.searchResultButtons[i], file.clubTagField )
			i++
		}

		foreach ( var searchTagButton in file.searchTagButtons )
			Hud_SetNavRight( searchTagButton, file.searchResultButtons[0] )

		if ( file.activePageButtons.len() > 0 )
		{
			int lastResultButtonIdx = file.searchResultButtons.len() - 1
			Hud_SetNavDown( file.searchResultButtons[ lastResultButtonIdx ], file.activePageButtons[0] )

			foreach ( var pageButton in file.activePageButtons )
				Hud_SetNavUp( pageButton, file.searchResultButtons[ lastResultButtonIdx ]  )
		}
	}

	if ( file.selectedPrivacy == CLUB_PRIVACY_OPEN_WITH_REQ )
	{
		Hud_SetNavDown( file.privacySetting, file.searchTagButtons[0] )
		Hud_SetNavUp( file.searchTagButtons[0], file.privacySetting )
	}
	else
	{
		Hud_SetNavDown( file.privacySetting, file.minAccountLvlSetting )
		Hud_SetNavDown( file.minAccountLvlSetting, file.minRankSetting )
		Hud_SetNavDown( file.minRankSetting, file.searchTagButtons[0] )
		Hud_SetNavUp( file.searchTagButtons[0] , file.minRankSetting )
	}
}

void function SearchResultButton_OnClick( var button )
{
	bool isButtonMapped = ( button in file.resultButtonToClubMap )
	if ( !isButtonMapped )
		return

	                                                      
	                    
	ClubHeader selectedClubHeader = file.resultButtonToClubMap[ button ]

	if ( !Clubs_DoesMeetJoinRequirements( selectedClubHeader ) )
	{
		entity player = GetLocalClientPlayer()
		int currentXP    = GetPlayerAccountXPProgress( ToEHI( player ) )
		int currentLevel = GetAccountLevelForXP( currentXP )

		if ( selectedClubHeader.privacySetting == CLUB_PRIVACY_OPEN_WITH_REQ )
		{
			EmitUISound( "UI_Menu_Deny" )
			Clubs_OpenErrorStringDialog( "#CLUB_OP_FAIL_JOIN_REQS" )
			return
		}
#if !DEV
		                       
		 
			                             
			                                                         
			      
		 
#endif       

		EmitUISound( "UI_Menu_Accept" )
		Clubs_OpenJoinReqsConfirmDialog( selectedClubHeader )
		return
	}

	OpenClubJoinDialog( selectedClubHeader )
	                        
}

void function SearchResultButton_OnClickRight( var button )
{
	bool isButtonMapped = (button in file.resultButtonToClubMap)
	if ( !isButtonMapped )
		return

	ClubHeader selectedClubHeader = file.resultButtonToClubMap[ button ]

	Clubs_OpenReportClubConfirmDialog( selectedClubHeader )
}

void function CloseClubsSearchMenu()
{
	if ( GetActiveMenu() == file.menu )
		CloseActiveMenu()
}