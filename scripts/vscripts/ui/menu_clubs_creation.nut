global function InitClubsCreationMenu
global function OpenClubCreationMenu
global function SubmitClubEdit
global function CloseClubCreationMenu

global function ClubCreation_SetClubLogoFromEditor

#if DEV
global function DEV_PrintClubLogoString
#endif

struct
{
	var menu
	var menuHeaderRui

	var logoPanel
	var logoEditorButton
	var logoRandomizeButton
	ClubLogo& selectedLogo

	var settingsPanel
	var clubNameField
	var clubTagField
	var privacySetting
	var minAccountLvlSetting
	var minRankSetting

	string selectedName
	string selectedTag

	int selectedPrivacy = CLUB_PRIVACY_OPEN
	int selectedAccountLvl = eClubMinAccountLevel.MINLVL_10
	var minAccountReqFrame
	int selectedRank = eClubMinRank.MINRANK_BRONZE
	var minRankReqFrame

	var searchTagsPanel
	var searchTagGrid
	array<var> searchTagButtons
	var createClubButton

	var submitButton

	bool hasPlayerChangedSetting = false
} file

void function InitClubsCreationMenu( var menu )
{
	printf( "ClubsDebug: Init Club Creation Menu" )
	file.menu = GetMenu( "ClubsCreationMenu" )

	file.menuHeaderRui = Hud_GetRui( Hud_GetChild( menu, "MenuHeader" ) )
	RuiSetString( file.menuHeaderRui, "menuName", "#LOBBY_CLUBS_CREATE" )

	file.logoPanel = Hud_GetChild( menu, "ClubCreationLogoPanel" )
	file.logoEditorButton = Hud_GetChild( file.logoPanel, "LogoEditorButton" )
	Hud_AddEventHandler( file.logoEditorButton, UIE_CLICK, LogoEditorButton_OnActivate )
	HudElem_SetRuiArg( file.logoEditorButton, "buttonText", Localize( "#CLUB_CREATION_LOGO_EDITOR_NAME" ) )
	file.logoRandomizeButton = Hud_GetChild( file.logoPanel, "RandomizeLogoButton" )
	HudElem_SetRuiArg( file.logoRandomizeButton, "buttonText", Localize( "#CLUB_CREATION_LOGO_RANDOMIZE_NAME" ) )
	Hud_AddEventHandler( file.logoRandomizeButton, UIE_CLICK, LogoRandomizeButton_OnActivate )

	file.settingsPanel = Hud_GetChild( menu, "ClubCreationSettingsPanel" )

	file.clubNameField = Hud_GetChild( file.settingsPanel, "ClubNameTextEntry" )
	AddButtonEventHandler( file.clubNameField, UIE_CHANGE, ClubName_OnChanged )
	file.clubTagField = Hud_GetChild( file.settingsPanel, "ClubTagTextEntry" )
	AddButtonEventHandler( file.clubTagField, UIE_CHANGE, ClubTag_OnChanged )

	file.privacySetting = Hud_GetChild( file.settingsPanel, "ClubPrivacySwitch" )
	file.minAccountLvlSetting = Hud_GetChild( file.settingsPanel, "ClubLvlReqSwitch" )
	file.minAccountReqFrame = Hud_GetChild( file.settingsPanel, "ClubLvlReqSwitchFrame" )
	file.minRankSetting = Hud_GetChild( file.settingsPanel, "ClubRankReqSwitch" )
	file.minRankReqFrame = Hud_GetChild( file.settingsPanel, "ClubRankReqSwitchFrame" )
	InitSettingsButtons()

	file.searchTagsPanel = Hud_GetChild( menu, "ClubCreationSearchTagsPanel" )
	file.searchTagGrid = Hud_GetChild( file.searchTagsPanel, "SearchTagsGrid" )

	file.submitButton = Hud_GetChild( menu, "SubmitClubInfoButton" )
	Hud_AddEventHandler( file.submitButton, UIE_CLICK, SubmitClubButton_OnClick )

	RegisterSignal( "ClubCreationMenu_LoseTopLevel" )

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnOpen )
	AddMenuEventHandler( menu, eUIEvent.MENU_GET_TOP_LEVEL, OnGainTopLevel )
	AddMenuEventHandler( menu, eUIEvent.MENU_LOSE_TOP_LEVEL, OnLoseTopLevel )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, OnClose )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, OnNavigateBack )

	AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "#B_BUTTON_CLOSE", "#B_BUTTON_CLOSE", TryCloseMenuFromFooter, CanNavigateBack )
}


void function OpenClubCreationMenu()
{
	if ( AreWeMatchmaking() )
	{
		if ( ClubIsValid() )
			Clubs_OpenClubEditBlockedByMatchmakingDialog()
		else
			Clubs_OpenClubCreateBlockedByMatchmakingDialog()
		return
	}

	AdvanceMenu( file.menu )
}


void function OnOpen()
{
	printf( "ClubsDebug: OnOpenClubCreationMenu" )

	InitClubLogo( file.selectedLogo )

	if ( ClubIsValid() )
	{
		ConfigureMenuForEdit()
	}
	else
	{
		ConfigureMenuForCreation()
	}

	SetupDpadNav()
}


void function SetupDpadNav()
{
	Hud_SetNavRight( file.clubTagField, file.searchTagButtons[0] )
	Hud_SetNavRight( file.logoRandomizeButton, file.privacySetting )

	Hud_SetNavDown( file.searchTagButtons[ file.searchTagButtons.len() - 1 ], file.submitButton )

	Hud_SetNavUp( file.submitButton, file.searchTagButtons[ file.searchTagButtons.len() - 1 ] )

	Hud_SetNavLeft( file.submitButton, file.privacySetting )
	foreach ( var button in file.searchTagButtons )
	{
		Hud_SetNavLeft( button, file.clubTagField )
	}

	Hud_SetNavLeft( file.clubNameField, file.logoRandomizeButton )
	Hud_SetNavLeft( file.privacySetting, file.logoRandomizeButton )
	Hud_SetNavLeft( file.minAccountLvlSetting, file.logoRandomizeButton )
	Hud_SetNavLeft( file.minRankSetting, file.logoRandomizeButton )
}


void function OnGainTopLevel()
{
	printf( "ClubsDebug: OnClubsCreationMenuGainTopLevel" )

	InitSearchTagsPanel()
}


void function OnLoseTopLevel()
{
	printf( "ClubsDebug: OnClubsCreationMenuLoseTopLevel" )
	Signal( uiGlobal.signalDummy, "ClubCreationMenu_LoseTopLevel" )
}


void function OnClose()
{
	printf( "ClubsDebug: OnCloseClubCreationMenu" )
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

	if ( file.hasPlayerChangedSetting )
		TryOpenChangeConfirmationDialog( false )
	else
		CloseActiveMenu()
}

void function ClubCreation_SetClubLogoFromEditor( ClubLogo logo )
{
	file.selectedLogo = logo
	UpdateClubLogo( file.selectedLogo )

	SetChangesMade()

	ClubsLogoEditor_CloseLogoEditor()
}

void function InitClubLogo( ClubLogo logo )
{
	if ( !ClubIsValid() )
	{
		logo = GenerateRandomClubLogo()
	}
	else
	{
		ClubHeader clubHeader = ClubGetHeader()
		string clubLogoString = clubHeader.logoString
		if ( clubLogoString.len() == 0 )
			logo = GenerateRandomClubLogo( clubHeader.clubID )
		else
			logo = ClubLogo_ConvertLogoStringToLogo( clubLogoString )
	}

	printf( "ClubCreationDebug: Created a logo with %i layers", logo.logoLayers.len() )
	UpdateClubLogo( logo )
}


void function RandomizeClubLogo()
{
	ClubLogo logo = GenerateRandomClubLogo()
	UpdateClubLogo( logo )
}


void function UpdateClubLogo( ClubLogo logo )
{
	file.selectedLogo = logo
	var logoAnchor    = Hud_GetChild( file.logoPanel, "ClubLogoDisplay" )
	var logoAnchorRui = Hud_GetRui( logoAnchor )

	printf( "ClubCreationDebug: Creating a nested Club Logo with %i layers", logo.logoLayers.len() )
	var nestedLogo = ClubLogoUI_CreateNestedClubLogo( logoAnchorRui, "clubLogo", logo )
}


void function LogoEditorButton_OnActivate( var button )
{
	ClubsLogoEditor_OpenLogoEditor( file.selectedLogo )
}

void function LogoRandomizeButton_OnActivate( var button )
{
	SetChangesMade()
	RandomizeClubLogo()
}

var function InitSettingsButtons()
{
	AddButtonEventHandler( file.privacySetting, UIE_CHANGE, PrivacySetting_OnChanged )
	AddButtonEventHandler( file.minAccountLvlSetting, UIE_CHANGE, AccountLevelSetting_OnChanged )
	AddButtonEventHandler( file.minRankSetting, UIE_CHANGE, RankSetting_OnChanged )
}

void function SetSettingsButtonDefaultsThread()
{
	file.selectedPrivacy = CLUB_PRIVACY_OPEN
	file.selectedAccountLvl = eClubMinAccountLevel.MINLVL_10
	file.selectedRank = eClubMinRank.MINRANK_BRONZE

	Hud_SetDialogListSelectionIndex( file.privacySetting, 0 )
	Hud_SetDialogListSelectionIndex( file.minAccountLvlSetting, 0 )
	Hud_SetDialogListSelectionIndex( file.minRankSetting, 0 )

	WaitFrame()
	WaitFrame()
	WaitFrame()

	UpdateSettingLocks()
}

void function ClubName_OnChanged( var button )
{
	SetChangesMade()
}

void function ClubTag_OnChanged( var button )
{
	SetChangesMade()
}

void function PrivacySetting_OnChanged( var button )
{
	file.selectedPrivacy = Hud_GetDialogListSelectionIndex( file.privacySetting )

	UpdateSettingLocks()
	SetChangesMade()
}

void function UpdateSettingLocks()
{
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
	file.selectedAccountLvl = Hud_GetDialogListSelectionIndex( file.minAccountLvlSetting )

	SetChangesMade()
}

void function RankSetting_OnChanged( var button )
{
	file.selectedRank = Hud_GetDialogListSelectionIndex( file.minRankSetting )

	SetChangesMade()
}

void function InitSearchTagsPanel()
{
	printf(	"SearchTagsDebug: InitSearchTagsPanel()" )
	int buttonCount = ClubSearchTag_GetSelectedSearchTags().len()

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

	         	                                                             

	Hud_InitGridButtons( file.searchTagGrid, buttonCount )
	var gridScrollPanel = Hud_GetChild( file.searchTagGrid, "ScrollPanel" )
	int buttonIdx

	for( int tagIndex; tagIndex < buttonCount; tagIndex++ )
	{
		var button = Hud_GetChild( gridScrollPanel, format( "GridButton%d", tagIndex ) )

		buttonIdx = file.searchTagButtons.find( button )
		if ( buttonIdx == -1 )
		{
			                                                                   
			file.searchTagButtons.append( button )
		}
	}

	foreach ( var button in file.searchTagButtons )
	{
		InitSearchTagButton( button )
	}

	SetupDpadNav()
}

void function InitSearchTagButton( var button )
{
	                                                    
	int buttonIdx = file.searchTagButtons.find( button )
	Assert( buttonIdx >= 0, "Club Creation: Attempted to get index for non-existant or unregistered search tag button" )

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
	Assert( buttonIdx >= 0, "Club Creation: Attempted to get index for non-existant or unregistered search tag button" )
	                                                                          

	OpenSearchTagDialog()
}

void function SubmitClubButton_OnClick( var button )
{
	TryOpenChangeConfirmationDialog( true )
}

void function SubmitClubEdit()
{
	ClubHeader clubHeader

	clubHeader.name = Hud_GetUTF8Text( file.clubNameField )
	clubHeader.tag = Hud_GetUTF8Text( file.clubTagField )

	clubHeader.privacySetting = file.selectedPrivacy
	clubHeader.minLevel = file.selectedAccountLvl
	clubHeader.minRating = file.selectedRank

	if ( clubHeader.privacySetting == CLUB_PRIVACY_OPEN_WITH_REQ && clubHeader.minLevel == 0 && clubHeader.minRating == 0 )
		clubHeader.privacySetting = CLUB_PRIVACY_OPEN

	clubHeader.searchTags = ClubSearchTag_CreateSearchTagBitMask( ClubSearchTag_GetSelectedSearchTags() )

	clubHeader.logoString = ClubLogo_ConvertLogoToString( file.selectedLogo )

	if ( ClubIsValid() )
	{
		Clubs_EditClubSettings( clubHeader )
	}
	else
	{
		if ( AreWeMatchmaking() )
		{
			Clubs_OpenClubCreateBlockedByMatchmakingDialog()
			thread CloseClubCreationMenu()
			return
		}

		Clubs_CreateNewClub( clubHeader )
		EmitUISound( "UI_Menu_Clubs_CreateClub" )
	}
}

void function ConfigureMenuForEdit()
{
	thread ConfigureEditMenuThread()

	HudElem_SetRuiArg( file.submitButton, "buttonText", Localize( "#LOBBY_CLUBS_EDIT_SAVE_CHANGES" ) )
}

void function ConfigureEditMenuThread()
{
	ClubHeader clubHeader = ClubGetHeader()

	string headerString = Localize( "#LOBBY_CLUBS_EDIT", clubHeader.name.toupper() )
	RuiSetString( file.menuHeaderRui, "menuName", headerString )

	Hud_SetUTF8Text( file.clubNameField, clubHeader.name )
	Hud_SetEnabled( file.clubNameField, false )
	Hud_SetUTF8Text( file.clubTagField, clubHeader.tag )
	Hud_SetEnabled( file.clubTagField, false )

	file.selectedPrivacy = clubHeader.privacySetting
	Hud_SetDialogListSelectionIndex( file.privacySetting, clubHeader.privacySetting )

	file.selectedAccountLvl = clubHeader.minLevel
	file.selectedRank = clubHeader.minRating

	if ( clubHeader.privacySetting == CLUB_PRIVACY_OPEN_WITH_REQ )
	{
		Hud_SetDialogListSelectionIndex( file.minAccountLvlSetting, clubHeader.minLevel )
		Hud_SetDialogListSelectionIndex( file.minRankSetting, clubHeader.minRating )
	}
	else
	{
		Hud_SetDialogListSelectionIndex( file.minAccountLvlSetting, 0 )
		Hud_SetDialogListSelectionIndex( file.minRankSetting, 0 )
	}

	ClubSearchTag_ClearSelectedSearchTags()
	array<ItemFlavor> searchTags = ClubSearchTag_GetItemFlavorsFromBitMask( clubHeader.searchTags )
	foreach ( searchTag in searchTags )
	{
		ClubSearchTag_AddSearchTagToSelection( searchTag )
	}
	InitSearchTagsPanel()

	WaitFrame()
	WaitFrame()
	WaitFrame()

	UpdateSettingLocks()
}

void function ConfigureMenuForCreation()
{
	RuiSetString( file.menuHeaderRui, "menuName", "#LOBBY_CLUBS_CREATE" )

	Hud_SetUTF8Text( file.clubNameField, "" )
	Hud_SetEnabled( file.clubNameField, true )
	Hud_SetUTF8Text( file.clubTagField, "" )
	Hud_SetEnabled( file.clubTagField, true )

	thread SetSettingsButtonDefaultsThread()

	ClubSearchTag_ClearSelectedSearchTags()
	InitSearchTagsPanel()

	HudElem_SetRuiArg( file.submitButton, "buttonText", Localize( "#LOBBY_CLUBS_CREATE" ) )
}

void function CleanClubCreationStruct()
{
	file.selectedPrivacy = 0
	file.selectedAccountLvl = 0
	file.selectedRank = 0
	ClubSearchTag_ClearSelectedSearchTags()
}

void function TryCloseMenuFromFooter( var button )
{
	TryOpenChangeConfirmationDialog( false )
}

void function TryOpenChangeConfirmationDialog( bool commitChange )
{
	if ( GetActiveMenu() != file.menu )
	{
		return
	}

	if ( file.hasPlayerChangedSetting == false )
	{
		EmitUISound( "UI_Menu_Deny" )
		thread CloseClubCreationMenu()
	}

	if ( commitChange )
	{
		string clubName = Hud_GetUTF8Text( file.clubNameField )
		if ( !ClubIsValid() )
		{
			int unicodeLen = Hud_GetUnicodeLen( file.clubNameField )
			if ( unicodeLen < CLUB_NAME_LENGTH_MIN )
			{
				Clubs_OpenErrorStringDialog( "#CLUB_OP_FAIL_CREATE_NAMELENGTH" )
				return
			}

			if ( !ClubIsValidName( clubName ) )
			{
				Clubs_OpenErrorStringDialog( "#CLUB_OP_FAIL_INVALIDNAME" )
				return
			}
		}

		string clubTag = Hud_GetUTF8Text( file.clubTagField )

		                                            
		int tagUnicodeLen = Hud_GetUnicodeLen( file.clubTagField )
		if ( tagUnicodeLen < CLUB_TAG_LENGTH_MIN || !ClubIsValidTag( clubTag ) )
		{
			Clubs_OpenErrorStringDialog( "#CLUB_OP_FAIL_CREATE_INVALIDTAG" )
			return
		}

                                                                                                     
		if ( !ClubIsAllowedTag( clubTag ) )
		{
			Clubs_OpenErrorStringDialog( Localize("#CLUB_OP_FAIL_CREATE_INAPPROPRIATETAG" , clubTag ))
			return
		}


		if ( ClubIsValid() )
		{
			ConfirmEditClubDialog_Open( commitChange )
		}
		else
		{
			EmitUISound( "UI_Menu_Clubs_CreateClub" )
			ClubHeader clubHeader
			clubHeader.name = clubName
			clubHeader.tag = clubTag
			clubHeader.privacySetting = file.selectedPrivacy
			clubHeader.minRating = file.selectedRank
			clubHeader.minLevel = file.selectedAccountLvl
			clubHeader.searchTags = ClubSearchTag_CreateSearchTagBitMask( ClubSearchTag_GetSelectedSearchTags() )
			clubHeader.logoString = ClubLogo_ConvertLogoToString( file.selectedLogo )
			OpenClubCreateDialog( clubHeader )
		}
	}
	else
	{
		if ( file.hasPlayerChangedSetting )
			ConfirmEditClubDialog_Open( false )
		else
			thread CloseClubCreationMenu()
	}
}


void function CloseClubCreationMenu()
{
	                          
	   
	  	           
	   


	CloseAllDialogs()

	wait 0.1

	if ( GetActiveMenu() == file.menu )
		CloseActiveMenu()

	Clubs_UpdateMyData()
	                           
}

void function SetChangesMade()
{
	file.hasPlayerChangedSetting = true
}

bool function UserChangedClubSettings()
{
	return file.hasPlayerChangedSetting
}

#if DEV
void function DEV_PrintClubLogoString()
{
	string logoString = ClubLogo_ConvertLogoToString( file.selectedLogo )
	printf( "ClubLogoString: %s", logoString )
}
#endif