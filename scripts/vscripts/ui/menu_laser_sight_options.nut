                         
global function InitLaserSightOptionsMenu
global function SetLaserSightOptionsMenuColor

struct
{
	var 				menu

	bool				tabsInitialized = false
	var                	previewBackground
	var 				previewBackgroundSwitch

	array<asset>		previewBackgroundAssets = [
		$"rui/menu/laser_options/laser_example_1",
	]

	bool registeredBindCallbacks = false
} file


void function InitLaserSightOptionsMenu( var newMenuArg )                                               
{
	var menu = GetMenu( "LaserSightOptionsMenu" )
	file.menu = menu

	file.previewBackground = Hud_GetChild( file.menu, "LaserSightExampleBG" )

	RuiSetAsset(  Hud_GetRui( file.previewBackground ), "bgImage", file.previewBackgroundAssets[0] )

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnOpenLaserSightOptionsMenu )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, OnCloseLaserSightOptionsMenu )

	RuiSetString( Hud_GetRui(Hud_GetChild( file.menu , "Title") ), "title", Localize( "#MENU_LASER_CUSTOM_LASER" ).toupper() )
}

void function OnOpenLaserSightOptionsMenu()
{
	if ( !file.tabsInitialized )
	{
		TabData tabData = GetTabDataForPanel( file.menu )
		tabData.centerTabs = true
		AddTab( file.menu, Hud_GetChild( file.menu, "LaserSightOptionsColorPanel" ), "#MENU_RETICLE_COLOR" )
		file.tabsInitialized = true
	}

	TabData tabData        = GetTabDataForPanel( file.menu )
	UpdateMenuTabs()

	SetPreviewBackgoundImage( 0 )                                                              
	ShowPanel( Hud_GetChild( file.menu, "LaserSightOptionsColorPanel" ) )

	RegisterBindCallbacks()
}


void function OnCloseLaserSightOptionsMenu()
{
	DeregisterBindCallbacks()
}

void function OnNavigateBackMenu()
{
	CloseActiveMenu()
}

void function RegisterBindCallbacks()
{
	if(!file.registeredBindCallbacks)
	{
		file.registeredBindCallbacks = true
		          
	}
}

void function DeregisterBindCallbacks()
{
	if(file.registeredBindCallbacks)
	{
		          
		file.registeredBindCallbacks = false
	}
}

void function SetPreviewBackgoundImage( int index )
{
	if(index < file.previewBackgroundAssets.len() && index >= 0)
		RuiSetAsset(  Hud_GetRui( file.previewBackground ), "bgImage", file.previewBackgroundAssets[index] )
}

void function SetLaserSightOptionsMenuColor( vector color )
{
	RuiSetColorAlpha(  Hud_GetRui( file.previewBackground ), "laserColor", color, 1.0)
}
                                   