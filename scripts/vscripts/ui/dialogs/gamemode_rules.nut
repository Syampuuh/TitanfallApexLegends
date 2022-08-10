global function InitGameModeRulesDialog
global function InitGameModeRulesPanel

global function OpenGameModeRulesDialog
global function GameModeHasRules
global function GetPlaylist_UIRules

global function UI_OpenGameModeRulesDialog
global function UI_CloseGameModeRulesDialog
global function AddCallback_UI_GameModeRulesDialog_PopulateTabsForMode
global function UI_GameModeRulesDialog_BuildDetailsData



global struct aboutGamemodeDetailsData
{
	string          title
	string		 	description
	asset			image
}

global struct aboutGamemodeDetailsTab
{
	string tabName
	array< aboutGamemodeDetailsData > rules
}

struct {
	var menu
	bool tabsInitialized = false

	array< aboutGamemodeDetailsTab > tabs

	var contentElm
	array< var > panelElms

	table < string, array< aboutGamemodeDetailsTab > functionref() > ruleSetToGamemodePopulateTabsFunction
} file

void function InitGameModeRulesDialog( var newMenuArg )
{
	var menu = newMenuArg
	file.menu = menu

	SetPopup( menu, true )
	SetAllowControllerFooterClick( menu, true )

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, GameModeRulesDialog_OnOpen )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, GameModeRulesDialog_OnClose )

	file.contentElm = Hud_GetChild( menu, "DialogContent" )
	file.panelElms = GetElementsByClassname( file.menu, "AboutGameModePanel" )

}

                                                                                             
void function AddCallback_UI_GameModeRulesDialog_PopulateTabsForMode( array< aboutGamemodeDetailsTab > functionref() func, string ruleSet )
{
	Assert( !( ruleSet in file.ruleSetToGamemodePopulateTabsFunction ) )
	file.ruleSetToGamemodePopulateTabsFunction[ ruleSet ] <- func
}

void function GameModeRulesDialog_OnOpen()
{
	                                         
	file.tabs = GetPlaylistRules()

	if( file.tabs.len() == 0 )                                   
	{
		if ( GetActiveMenu() == file.menu )
		{
			printf( "menu_GameModeRulesDialog: Attempted to Open About Screen with empty Tabs, Closing" )
			CloseActiveMenu()
		}
	}
	else
	{
		if ( !file.tabsInitialized )
		{
			TabData tabData = GetTabDataForPanel( file.menu )
			tabData.centerTabs = true

			foreach( int idx, tab in file.tabs)
			{
				if( tab.rules.len() > 0 )
					AddTab( file.menu, Hud_GetChild( file.menu, "GameModeRulesPanel" + (idx + 1) ), tab.tabName )
			}

			if(file.tabs.len() >= 2 && file.tabs[1].rules.len() == 0 )                                                     
			{
				TabDef firstTab = Tab_GetTabDefByBodyName( tabData, "GameModeRulesPanel1" )
				SetTabDefVisible( firstTab, false )
			}

			file.tabsInitialized = true
		}

		TabData tabData        = GetTabDataForPanel( file.menu )
		UpdateMenuTabs()


		if(file.tabs.len() >= 1)
			ShowPanel( Hud_GetChild( file.menu, "GameModeRulesPanel1" ) )
	}
}

void function GameModeRulesDialog_OnClose()
{
	ClearTabs( file.menu )
	UpdateMenuTabs()

	file.tabs.clear()
	file.tabsInitialized = false
}

void function OpenGameModeRulesDialog( var button )
{
	UI_OpenGameModeRulesDialog()
}


void function UI_OpenGameModeRulesDialog()
{
	if ( !IsFullyConnected() )
		return

	if( !GameModeHasRules() )
		return

	AdvanceMenu( GetMenu( "GameModeRulesDialog" ) )
}


void function UI_CloseGameModeRulesDialog()
{
	if ( GetActiveMenu() == file.menu )
	{
		CloseActiveMenu()
	}
	else if ( MenuStack_Contains( file.menu ) )
	{
		if( IsDialog( GetActiveMenu() ) )
		{
			                                                                                                  
			CloseAllMenus()
		}
		else
		{
			                                                                                                                                                
			MenuStack_Remove( file.menu )
		}
	}
}


void function GameModeRulesDialog_Cancel( var button )
{
	CloseAllToTargetMenu( file.menu )
	CloseActiveMenu()
}


string function GetPlaylist()
{
	if ( IsLobby() )
		return Lobby_GetSelectedPlaylist()
	else
		return GetCurrentPlaylistName()

	unreachable
}

string function GetPlaylist_UIRules()
{
	return GetPlaylistVarString( GetPlaylist(), "ui_rules", "" )
}

bool function GameModeHasRules()
{
	string playlistUiRules = GetPlaylist_UIRules()

	return ( playlistUiRules in file.ruleSetToGamemodePopulateTabsFunction )
}

array< aboutGamemodeDetailsTab > function GetPlaylistRules()
{
	array< aboutGamemodeDetailsTab > tabs

	string playlistUiRules = GetPlaylist_UIRules()

	if ( !GameModeHasRules() )
		return tabs

	array< aboutGamemodeDetailsTab > functionref() populateTabsFunc = file.ruleSetToGamemodePopulateTabsFunction[ playlistUiRules ]
	tabs = populateTabsFunc()
	return tabs
}

aboutGamemodeDetailsData function UI_GameModeRulesDialog_BuildDetailsData( string title = "", string description = "", asset image = $"" )
{
	aboutGamemodeDetailsData data
	data.title = title
	data.description = description
	data.image = image

	return data
}

        
void function InitGameModeRulesPanel(var panel )
{
	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, OnShowPanel )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, OnHidePanel )
	                                                                                           
	AddPanelFooterOption( panel, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
}

void function OnShowPanel( var panel )
{
	int activeTab = GetTabDataForPanel( file.menu ).activeTabIdx

	if( activeTab < 0 )
		return

	array< var > detailElms = GetPanelElementsByClassname( panel, "AboutGameModeDetails" )

	foreach( var elm in detailElms )
	{
		Hud_Hide( elm )
	}
	string playlist = GetPlaylist()
	array< aboutGamemodeDetailsData > rules = file.tabs[activeTab].rules

	RuiSetString( Hud_GetRui( file.contentElm ), "messageText", GetPlaylistVarString( playlist, "name", "" ) )

	foreach( int idx, aboutGamemodeDetailsData data in rules)
	{
		if( detailElms.len() > idx )                                 
		{
			Hud_Show( detailElms[idx] )
			var rui = Hud_GetRui( detailElms[idx] )

			RuiSetString(rui, "title", data.title)
			RuiSetString(rui, "desc", data.description)
			RuiSetImage(rui, "exampleImage", data.image)
		}
	}

	                                                               
	int count = int(min(rules.len(), 4))

	int width = count * Hud_GetWidth( detailElms[0] )
	int offsets = int(max(count - 1, 0)) * Hud_GetX( detailElms[1] )
	Hud_SetX( detailElms[0], -((width / 2) + (offsets / 2)) )

}

void function OnHidePanel( var panel )
{

}