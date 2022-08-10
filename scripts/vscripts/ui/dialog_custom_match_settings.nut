global function InitCustomMatchSettingsDialog
global function InitCustomMatchSettingsPanel

struct
{
	var menu
	var modeSelectPanel
	var mapSelectPanel
	var optionsSelectPanel
} file

void function InitCustomMatchSettingsDialog( var menu )
{
	file.menu = menu

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, CustomMatchSettings_OnOpen )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, CustomMatchSettings_OnClose )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, CustomMatchSettings_OnNavigateBack )

	var nameChangePanel 	= Hud_GetChild( menu, "NameChangePanel" )
	file.modeSelectPanel 	= Hud_GetChild( menu, "ModeSelectPanel" )
	var settingsSelectPanel = Hud_GetChild( menu, "SettingsSelectPanel" )

	Hud_Show( nameChangePanel )
	Hud_Show( file.modeSelectPanel )
	Hud_Show( settingsSelectPanel )

	AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "#B_BUTTON_CLOSE", "#CLOSE" )
	AddMenuFooterOption( menu, LEFT, BUTTON_A, true, "#A_BUTTON_SELECT" )
}

void function InitCustomMatchSettingsPanel( var panel )
{
	file.mapSelectPanel 	= Hud_GetChild( panel, "MapSelectPanel" )
	file.optionsSelectPanel = Hud_GetChild( panel, "OptionsSelectPanel" )
	var submitButton 		= Hud_GetChild( panel, "SubmitButton" )
	var cancelButton 		= Hud_GetChild( panel, "CancelButton" )

	Hud_Show( file.mapSelectPanel )
	Hud_Show( file.optionsSelectPanel )

	AddButtonEventHandler( submitButton, UIE_CLICK, SubmitButton_OnClick )
	AddButtonEventHandler( cancelButton, UIE_CLICK, CancelButton_OnClick )
}

void function CustomMatchSettings_OnOpen()
{
	CustomMatch_LockLocalSettings( true )
	Hud_SetVisible( Hud_GetChild( file.menu, "NameChangePanel" ), GetConVarBool( "customMatch_public_enabled" ) )
	CustomMatch_RefreshPlaylists()
	AddCallback_OnCustomMatchSettingChanged( CUSTOM_MATCH_SETTING_PLAYLIST, Callback_OnPlaylistChanged )
	Callback_OnPlaylistChanged( CUSTOM_MATCH_SETTING_PLAYLIST, CustomMatch_GetSetting( CUSTOM_MATCH_SETTING_PLAYLIST ) )
}

void function CustomMatchSettings_OnClose()
{
	CustomMatch_LockLocalSettings( false )
	RemoveCallback_OnCustomMatchSettingChanged( CUSTOM_MATCH_SETTING_PLAYLIST, Callback_OnPlaylistChanged )
}

void function CustomMatchSettings_OnNavigateBack()
{
	CloseActiveMenu()

	                                                                                        
	CustomMatch_RestoreSettings()
}

void function SubmitButton_OnClick( var button )
{
	if ( CustomMatch_IsLocalAdmin() )
		CustomMatch_SubmitSettings()
	else
		Warning( "Local player is not a custom match administrator." )

	CloseActiveMenu()
}

void function CancelButton_OnClick( var button )
{
	CustomMatchSettings_OnNavigateBack()
}

                                                                                      
                             
                                                                                      

void function Callback_OnPlaylistChanged( string _, string value )
{
	CustomMatchPlaylist playlist 	= expect CustomMatchPlaylist( CustomMatch_GetPlaylist( value ) )
	CustomMatchMap map 				= expect CustomMatchMap( CustomMatch_GetMap( playlist.mapIndex ) )
	CustomMatchCategory category 	= expect CustomMatchCategory( CustomMatch_GetCategory( playlist.categoryIndex ) )

	var modeSelected 	= GetButton( Hud_GetChild( file.modeSelectPanel, "SelectModeGrid" ), playlist.categoryIndex )
	var mapSelected 	= GetButton( Hud_GetChild( file.mapSelectPanel, "SelectMapGrid" ), category.maps.find( map ) )

	Hud_SetNavRight( file.modeSelectPanel, mapSelected )
	Hud_SetNavLeft( file.mapSelectPanel, modeSelected )
}

var function GetButton( var menuGrid, int index )
{
	Assert( index < Hud_GetButtonCount( menuGrid ) )
	if ( index < Hud_GetButtonCount( menuGrid ) )
		return Hud_GetButton( menuGrid, index )
	return null
}