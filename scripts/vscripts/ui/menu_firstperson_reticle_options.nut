global function InitFirstPersonReticleOptionsMenu

struct
{
	var 				menu

	bool				tabsInitialized = false
	var                	previewBackground
	var 				previewBackgroundSwitch

	array<asset>		previewBackgroundAssets = [
		$"rui/menu/reticle_options/reticle_example_1",
		$"rui/menu/reticle_options/reticle_example_2",
		$"rui/menu/reticle_options/reticle_example_3",
		$"rui/menu/reticle_options/reticle_example_4"
	]

	bool registeredBindCallbacks = false
} file


void function InitFirstPersonReticleOptionsMenu( var newMenuArg )                                               
{
	var menu = GetMenu( "FirstPersonReticleOptionsMenu" )
	file.menu = menu

	file.previewBackground = Hud_GetChild( file.menu, "ReticleExampleBG" )
	file.previewBackgroundSwitch = Hud_GetChild( file.menu, "PreviewBackgroundSwitch" )

	RuiSetAsset(  Hud_GetRui( file.previewBackground ), "bgImage", file.previewBackgroundAssets[0] )

	             
	RuiSetBool( Hud_GetRui(Hud_GetChild( file.previewBackgroundSwitch , "ValueButton") ), "hideBackground", true )
	RuiSetBool( Hud_GetRui(Hud_GetChild( file.previewBackgroundSwitch , "LeftButton") ), "hideBackground", true )
	RuiSetBool( Hud_GetRui(Hud_GetChild( file.previewBackgroundSwitch , "RightButton") ), "hideBackground", true )

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnOpenFirstPersonReticleOptionsMenu )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, OnCloseFirstPersonReticleOptionsMenu )
	AddButtonEventHandler( file.previewBackgroundSwitch, UIE_CHANGE, PreviewBackgroundSelector_OnChanged )


	RuiSetString( Hud_GetRui(Hud_GetChild( file.menu , "Title") ), "title", Localize( "#MENU_RETICLE_CUSTOM_RETICLE" ).toupper() )
}

void function OnOpenFirstPersonReticleOptionsMenu()
{
	if ( !file.tabsInitialized )
	{
		TabData tabData = GetTabDataForPanel( file.menu )
		tabData.centerTabs = true
		AddTab( file.menu, Hud_GetChild( file.menu, "FirstPersonReticleOptionsColorPanel" ), "#MENU_RETICLE_COLOR" )
		file.tabsInitialized = true
	}

	TabData tabData        = GetTabDataForPanel( file.menu )
	UpdateMenuTabs()

	SetPreviewBackgoundImage( 0 )
	ShowPanel( Hud_GetChild( file.menu, "FirstPersonReticleOptionsColorPanel" ) )


	Hud_SetDialogListSelectionIndex( file.previewBackgroundSwitch, 0 )
	RegisterBindCallbacks()
}


void function OnCloseFirstPersonReticleOptionsMenu()
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

void function PreviewBackgroundSelector_OnChanged( var button )
{
	int index = Hud_GetDialogListSelectionIndex( file.previewBackgroundSwitch )
	SetPreviewBackgoundImage( index )
}

