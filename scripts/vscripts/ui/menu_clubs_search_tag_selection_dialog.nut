global function InitSearchTagSelectionDialog
global function OpenSearchTagDialog

struct
{
	var menu
	var menuHeader
	var buttonGrid
	array<var> buttons
	table< var, ItemFlavor > buttonToSearchTagMap
	var closeMenuButton

	bool isGridInitialized
} file


void function InitSearchTagSelectionDialog( var menu )                                               
{
	file.menu = menu
	SetDialog( menu, true )

	                                                        
	                                                              

	var frameElem = Hud_GetChild( menu, "DialogFrame" )
	RuiSetImage( Hud_GetRui( frameElem ), "basicImage", $"rui/menu/common/dialog_gradient" )
	RuiSetFloat3( Hud_GetRui( frameElem ), "basicImageColor", <1, 1, 1> )

	file.buttonGrid = Hud_GetChild( file.menu, "SearchTagGrid" )

	file.closeMenuButton = Hud_GetChild( file.menu, "CloseMenuButton" )
	HudElem_SetRuiArg( file.closeMenuButton, "buttonText", "#CLUBTAG_CLOSE_BUTTON" )
	Hud_AddEventHandler( file.closeMenuButton, UIE_CLICK, CloseMenuButton_OnClick )

	                                                                                                                                         
	                                                                                                                                       
	                                                                                                                                     
	                                                                                                                    
	                                                                                                   

	AddMenuEventHandler( file.menu, eUIEvent.MENU_OPEN, SearchTagSelection_OnOpen )
	                                                                    
	                                                                      
}

void function OpenSearchTagDialog()
{
	if ( !file.isGridInitialized )
		InitSearchTagGrid()
	else
		RefreshSearchTagGrid()

	AdvanceMenu( file.menu )
}

void function SearchTagSelection_OnOpen()
{
	RefreshButtonChecks()
}

void function InitSearchTagGrid()
{
	array<ItemFlavor> allSearchTags = ClubSearchTag_GetAllEnabledSearchTags()
	array<ItemFlavor> selectedSearchTags = clone( ClubSearchTag_GetSelectedSearchTags() )

	int buttonCount = allSearchTags.len()
	Hud_InitGridButtons( file.buttonGrid, buttonCount )
	var gridScrollPanel = Hud_GetChild( file.buttonGrid, "ScrollPanel" )

	for ( int btnIndex; btnIndex < buttonCount; btnIndex++ )
	{
		var button = Hud_GetChild( gridScrollPanel, format( "GridButton%d", btnIndex ) )
		var buttonRui = Hud_GetRui( button )
		ItemFlavor searchTag = allSearchTags[ btnIndex ]
		file.buttonToSearchTagMap[ button ] <- searchTag

		string searchTagString = ClubSearchTag_GetTagString( searchTag )
		RuiSetString( buttonRui, "buttonText", searchTagString )

		bool isChecked
		if ( selectedSearchTags.contains( allSearchTags[ btnIndex ] ) )
			isChecked = true
		else
			isChecked = false
		RuiSetBool( buttonRui, "isChecked", isChecked )

		Hud_AddEventHandler( button, UIE_CLICK, SearchTag_OnClick )
	}

	file.isGridInitialized = true
}

void function RefreshSearchTagGrid()
{
	array<ItemFlavor> allSearchTags = ClubSearchTag_GetAllEnabledSearchTags()
	array<ItemFlavor> selectedSearchTags = clone( ClubSearchTag_GetSelectedSearchTags() )

	int buttonCount = allSearchTags.len()
	var gridScrollPanel = Hud_GetChild( file.buttonGrid, "ScrollPanel" )

	file.buttonToSearchTagMap.clear()

	for ( int btnIndex; btnIndex < buttonCount; btnIndex++ )
	{
		var button = Hud_GetChild( gridScrollPanel, format( "GridButton%d", btnIndex ) )
		var buttonRui = Hud_GetRui( button )
		ItemFlavor searchTag = allSearchTags[ btnIndex ]
		file.buttonToSearchTagMap[ button ] <- searchTag

		string searchTagString = ClubSearchTag_GetTagString( searchTag )
		RuiSetString( buttonRui, "buttonText", searchTagString )

		bool isChecked
		if ( selectedSearchTags.contains( allSearchTags[ btnIndex ] ) )
			isChecked = true
		else
			isChecked = false

		RuiSetBool( buttonRui, "isChecked", isChecked )
	}
}

void function RefreshButtonChecks()
{
	array<ItemFlavor> selectedSearchTags = clone( ClubSearchTag_GetSelectedSearchTags() )

	foreach ( var button, ItemFlavor searchTag in file.buttonToSearchTagMap )
	{
		var buttonRui = Hud_GetRui( button )
		if ( selectedSearchTags.contains( searchTag ) )
			RuiSetBool( buttonRui, "isChecked", true )
		else
			RuiSetBool( buttonRui, "isChecked", false )
	}
}

void function SearchTag_OnClick( var button )
{
	                                                   
	array<ItemFlavor> selectedSearchTags = clone( ClubSearchTag_GetSelectedSearchTags() )

	ItemFlavor buttonTag = file.buttonToSearchTagMap[ button ]

	if ( selectedSearchTags.contains( buttonTag ) )
	{
		ClubSearchTag_RemoveSearchTagFromSelection( buttonTag )
		EmitUISound( "UI_Menu_Clubs_TagToggle_Off" )
	}
	else
	{
		if ( selectedSearchTags.len() < CLUB_SEARCH_TAG_SELECTION_MAX )
		{
			ClubSearchTag_AddSearchTagToSelection( buttonTag )
			EmitUISound( "UI_Menu_Clubs_TagToggle_On" )
		}
	}

	RefreshButtonChecks()
}

void function CloseMenuButton_OnClick( var button )
{
	CloseActiveMenu()
}