#if CLIENT
global function UpdateLoadscreenPreviewMaterial
global function ClLoadscreensInit
#endif

#if UI
global function InitLoadscreenPanel
#endif

struct
{
	#if UI
		var               panel
		               
		var               listPanel
		var               scrollPanel
		var               descriptionElem
		array<ItemFlavor> loadscreenList
		var               loadscreenElem
	#endif

	#if CLIENT
		array<PakHandle> pakHandles
	#endif
} file

#if CLIENT
void function ClLoadscreensInit()
{
	RegisterSignal( "UpdateLoadscreenPreviewMaterial" )
}
#endif

#if UI
void function InitLoadscreenPanel( var panel )
{
	file.panel = panel
	file.listPanel = Hud_GetChild( panel, "LoadscreenList" )
	                                                                
	file.loadscreenElem = Hud_GetChild( panel, "LoadscreenImage" )
	file.descriptionElem = Hud_GetChild( panel, "DescriptionText" )

	SetPanelTabTitle( panel, "#TAB_CUSTOMIZE_LOADSCREEN" )
	                                                                         

	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, LoadscreenPanel_OnShow )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, LoadscreenPanel_OnHide )
	AddPanelEventHandler_FocusChanged( panel, LoadscreenPanel_OnFocusChanged )

	AddPanelFooterOption( panel, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
	AddPanelFooterOption( panel, LEFT, BUTTON_A, false, "#A_BUTTON_SELECT", "", null, CustomizeMenus_IsFocusedItem )
	AddPanelFooterOption( panel, LEFT, BUTTON_X, false, "#X_BUTTON_EQUIP", "#X_BUTTON_EQUIP", null, CustomizeMenus_IsFocusedItemEquippable )
	AddPanelFooterOption( panel, LEFT, BUTTON_X, false, "#X_BUTTON_UNLOCK", "#X_BUTTON_UNLOCK", null, CustomizeMenus_IsFocusedItemLocked )


	var listPanel = file.listPanel
	void functionref( var ) func = (
	void function( var button ) : ( listPanel )
	{
		SetOrClearFavoriteFromFocus( listPanel )
	}
	)
	#if NX_PROG || PC_PROG_NX_UI
		AddPanelFooterOption( panel, LEFT, BUTTON_Y, false, "#Y_BUTTON_SET_FAVORITE", "#Y_BUTTON_SET_FAVORITE", func, CustomizeMenus_IsFocusedItemFavoriteable )
		AddPanelFooterOption( panel, LEFT, BUTTON_Y, false, "#Y_BUTTON_CLEAR_FAVORITE", "#Y_BUTTON_CLEAR_FAVORITE", func, CustomizeMenus_IsFocusedItemFavorite )
	#else
		AddPanelFooterOption( panel, RIGHT, BUTTON_Y, false, "#Y_BUTTON_SET_FAVORITE", "#Y_BUTTON_SET_FAVORITE", func, CustomizeMenus_IsFocusedItemFavoriteable )
		AddPanelFooterOption( panel, RIGHT, BUTTON_Y, false, "#Y_BUTTON_CLEAR_FAVORITE", "#Y_BUTTON_CLEAR_FAVORITE", func, CustomizeMenus_IsFocusedItemFavorite )
	#endif
}

void function LoadscreenPanel_OnShow( var panel )
{
	AddCallback_OnTopLevelCustomizeContextChanged( panel, LoadscreenPanel_Update )
	LoadscreenPanel_Update( panel )
	AddCallback_ItemFlavorLoadoutSlotDidChange_SpecificPlayer( LocalClientEHI(), Loadout_Loadscreen(), OnLoadscreenEquipChanged )
	RegisterStickMovedCallback( ANALOG_RIGHT_Y, FocusDescriptionForScrolling )
}


void function LoadscreenPanel_OnHide( var panel )
{
	RemoveCallback_OnTopLevelCustomizeContextChanged( panel, LoadscreenPanel_Update )
	LoadscreenPanel_Update( panel )
	RemoveCallback_ItemFlavorLoadoutSlotDidChange_SpecificPlayer( LocalClientEHI(), Loadout_Loadscreen(), OnLoadscreenEquipChanged )
	DeregisterStickMovedCallback( ANALOG_RIGHT_Y, FocusDescriptionForScrolling )
}

void function FocusDescriptionForScrolling(  ... )
{
#if PLAYSTATION_PROG
	if ( CustomizeMenus_IsFocusedItem() )
		return
#endif                        

	if( !Hud_IsFocused( file.descriptionElem ) )
		Hud_SetFocused( file.descriptionElem )
}

void function OnLoadscreenEquipChanged( EHI playerEHI, ItemFlavor flavor )
{
	if ( GetPlaylistVarBool( Lobby_GetSelectedPlaylist(), "force_level_loadscreen", false ) )
		Lobby_UpdateLoadscreenFromPlaylist()
	else
		thread Loadscreen_SetCustomLoadscreen( flavor )
}


void function LoadscreenPanel_Update( var panel )
{
	var scrollPanel = Hud_GetChild( file.listPanel, "ScrollPanel" )

	          
	foreach ( int flavIdx, ItemFlavor unused in file.loadscreenList )
	{
		var button = Hud_GetChild( scrollPanel, "GridButton" + flavIdx )
		CustomizeButton_UnmarkForUpdating( button )
	}
	file.loadscreenList.clear()

	RunClientScript( "UpdateLoadscreenPreviewMaterial", file.loadscreenElem, file.descriptionElem, 0 )

	                                  
	if ( IsPanelActive( file.panel ) )
	{
		LoadoutEntry entry = Loadout_Loadscreen()
		file.loadscreenList = GetLoadoutItemsSortedForMenu( entry, Loadscreen_GetSortOrdinal )

		Hud_InitGridButtons( file.listPanel, file.loadscreenList.len() )
		foreach ( int flavIdx, ItemFlavor flav in file.loadscreenList )
		{
			var button = Hud_GetChild( scrollPanel, "GridButton" + flavIdx )
			CustomizeButton_UpdateAndMarkForUpdating( button, [entry], flav, PreviewLoadscreen, null )
		}

		                                                                                                              
	}
}


void function LoadscreenPanel_OnFocusChanged( var panel, var oldFocus, var newFocus )
{
	if ( !IsValid( panel ) )                  
		return
	if ( GetParentMenu( panel ) != GetActiveMenu() )
		return

	UpdateFooterOptions()
}


void function PreviewLoadscreen( ItemFlavor flav )
{
	RunClientScript( "UpdateLoadscreenPreviewMaterial", file.loadscreenElem, file.descriptionElem, ItemFlavor_GetGUID( flav ) )
}
#endif      

#if CLIENT
void function UpdateLoadscreenPreviewMaterial( var loadscreenElem, var descriptionElem, SettingsAssetGUID guid )
{
	                                                                             
	thread UpdateLoadscreenPreviewMaterial_internal( loadscreenElem, descriptionElem, guid )
}

void function UpdateLoadscreenPreviewMaterial_internal( var loadscreenElem, var descriptionElem, SettingsAssetGUID guid )
{
	Signal( clGlobal.signalDummy, "UpdateLoadscreenPreviewMaterial" )
	EndSignal( clGlobal.signalDummy, "UpdateLoadscreenPreviewMaterial" )

	                                 
	RuiSetImage( Hud_GetRui( loadscreenElem ), "loadscreenImage", $"" )
	RuiSetBool( Hud_GetRui( loadscreenElem ), "loadscreenImageIsReady", false )
	Hud_SetVisible( loadscreenElem, false )
	if ( descriptionElem != null )
	{
		                                                               
		Hud_SetText( descriptionElem, "" )
		Hud_SetVisible( descriptionElem, false )
	}

	OnThreadEnd(
		function() : ()
		{
			                                 
			foreach( handle in file.pakHandles )
			{
				if ( handle.isAvailable )
					ReleasePakFile( handle )
			}
		}
	)

	if ( guid == 0 )
		return

	                                
	ItemFlavor flavor = GetItemFlavorByGUID( guid )
	Assert( ItemFlavor_GetType( flavor ) == eItemType.loadscreen )
	asset loadscreenImage = Loadscreen_GetLoadscreenImageAsset( flavor )

	if ( loadscreenImage == $"" )
		return

	WaitFrame()                                                                 

	Hud_SetVisible( loadscreenElem, true )

	                     
	string rpak         = Loadscreen_GetRPakName( flavor )
	PakHandle pakHandle = RequestPakFile( rpak )
	file.pakHandles.append( pakHandle )

	if ( !pakHandle.isAvailable )
		WaitSignal( pakHandle, "PakFileLoaded" )

	RuiSetImage( Hud_GetRui( loadscreenElem ), "loadscreenImage", loadscreenImage )
	RuiSetBool( Hud_GetRui( loadscreenElem ), "loadscreenImageIsReady", true )
	Hud_SetVisible( loadscreenElem, true )

	if ( descriptionElem != null )
	{
		string description = Loadscreen_GetImageOverlayText( flavor )
		if ( description != "" )
		{
			                                                                                                                 
			Hud_SetText( descriptionElem, description )
			Hud_SetVisible( descriptionElem, true )
		}
	}

	WaitForever()
}
#endif          
