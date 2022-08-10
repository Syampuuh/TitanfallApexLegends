
global function InitADSMotionControlsMenuConsole
global function InitADSMotionControlsPanelConsole
global function RestoreADSMotionDefaultsGamePad

struct
{
	var                menu
	var                panel
	table<var, string> buttonTitles
	table<var, string> buttonDescriptions
	var                detailsPanel
	var                contentPanel

	array<ConVarData> conVarDataList

	array<var> customItems
	array<var> defaultItems
} file


void function InitADSMotionControlsMenuConsole( var menu )                                               
{
	file.menu = menu
	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnOpenControlsADSMotionMenuConsole )
}


void function InitADSMotionControlsPanelConsole( var panel )
{
	file.panel = panel
	file.detailsPanel = Hud_GetChild( panel, "DetailsPanel" )
	var contentPanel = Hud_GetChild( panel, "ContentPanel" )
	file.contentPanel = contentPanel

	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, OnADSMotionPanel_Show )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, OnADSMotionPanel_Hide )

	var button = Hud_GetChild( contentPanel, "SwchCustomMotionADSEnabled" )
	SetupSettingsButton( button, "#PEROPTICADS_ENABLED", "#PEROPTICADS_ENABLED_DESC", $"" )
	AddButtonEventHandler( button, UIE_CHANGE, Button_Toggle_ADSMotionEnabled )

	                            
	file.customItems.extend( SetupSettingsSlider( Hud_GetChild( contentPanel, "SldMotionSensitivityADS0" ), "#PEROPTICADS_0", "#GAMEPAD_MENU_SENSITIVITY_ZOOM_DESC", $"" ) )
	file.customItems.extend( SetupSettingsSlider( Hud_GetChild( contentPanel, "SldMotionSensitivityADS1" ), "#PEROPTICADS_1", "#GAMEPAD_MENU_SENSITIVITY_ZOOM_DESC", $"" ) )
	file.customItems.extend( SetupSettingsSlider( Hud_GetChild( contentPanel, "SldMotionSensitivityADS2" ), "#PEROPTICADS_2", "#GAMEPAD_MENU_SENSITIVITY_ZOOM_DESC", $"" ) )
	file.customItems.extend( SetupSettingsSlider( Hud_GetChild( contentPanel, "SldMotionSensitivityADS3" ), "#PEROPTICADS_3", "#GAMEPAD_MENU_SENSITIVITY_ZOOM_DESC", $"" ) )
	file.customItems.extend( SetupSettingsSlider( Hud_GetChild( contentPanel, "SldMotionSensitivityADS4" ), "#PEROPTICADS_4", "#GAMEPAD_MENU_SENSITIVITY_ZOOM_DESC", $"" ) )
	file.customItems.extend( SetupSettingsSlider( Hud_GetChild( contentPanel, "SldMotionSensitivityADS5" ), "#PEROPTICADS_5", "#GAMEPAD_MENU_SENSITIVITY_ZOOM_DESC", $"" ) )
	file.customItems.extend( SetupSettingsSlider( Hud_GetChild( contentPanel, "SldMotionSensitivityADS6" ), "#PEROPTICADS_6", "#GAMEPAD_MENU_SENSITIVITY_ZOOM_DESC", $"" ) )
	
	file.customItems.append( Hud_GetChild( contentPanel, "TextEntryMotionSensitivityADS0" ) )
	file.customItems.append( Hud_GetChild( contentPanel, "TextEntryMotionSensitivityADS1" ) )
	file.customItems.append( Hud_GetChild( contentPanel, "TextEntryMotionSensitivityADS2" ) )
	file.customItems.append( Hud_GetChild( contentPanel, "TextEntryMotionSensitivityADS3" ) )
	file.customItems.append( Hud_GetChild( contentPanel, "TextEntryMotionSensitivityADS4" ) )
	file.customItems.append( Hud_GetChild( contentPanel, "TextEntryMotionSensitivityADS5" ) )
	file.customItems.append( Hud_GetChild( contentPanel, "TextEntryMotionSensitivityADS6" ) )

	ScrollPanel_InitPanel( panel )
	ScrollPanel_InitScrollBar( panel, Hud_GetChild( panel, "ScrollBar" ) )

	AddPanelFooterOption( panel, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
	AddPanelFooterOption( panel, LEFT, BUTTON_BACK, true, "#BACKBUTTON_RESTORE_DEFAULTS", "#RESTORE_DEFAULTS", OpenConfirmRestoreMotionControlsDefaultsDialog )
	AddPanelFooterOption( panel, LEFT, -1, false, "#FOOTER_CHOICE_HINT", "" )
}


void function OnADSMotionPanel_Show( var panel )
{
	ScrollPanel_SetActive( panel, true )
}


void function OnADSMotionPanel_Hide( var panel )
{
	ScrollPanel_SetActive( panel, false )
	SavePlayerSettings()
}


void function OnOpenControlsADSMotionMenuConsole()
{
	if ( IsLobby() )
		UI_SetPresentationType( ePresentationType.WEAPON_CATEGORY )
	SetBlurEnabled( true )

	ShowPanel( Hud_GetChild( file.menu, "ADSMotionControlsPanel" ) )  
	Button_Toggle_ADSMotionEnabled( null )
}

void function Button_Toggle_ADSMotionEnabled( var button )
{
	bool isEnabled = GetConVarBool( "motion_use_per_scope_sensitivity_scalars" )

	foreach ( var item in file.customItems )
		Hud_SetEnabled( item, isEnabled )

	foreach ( var item in file.defaultItems )
		Hud_SetEnabled( item, !isEnabled )
}


void function OpenConfirmRestoreMotionControlsDefaultsDialog( var button )
{
	ConfirmDialogData data
	data.headerText = "#RESTORE_LOOK_DEFAULTS"
	data.messageText = "#RESTORE_LOOK_DEFAULTS_DESC"
	data.resultCallback = void function ( int result ) : ()
	{
		if ( result != eDialogResult.YES )
			return

		RestoreADSMotionDefaultsGamePad()
		Button_Toggle_ADSMotionEnabled( null )
	}
	OpenConfirmDialogFromData( data )
}

void function RestoreADSMotionDefaultsGamePad()
{
	SetConVarToDefault( "motion_use_per_scope_sensitivity_scalars" )
	SetConVarToDefault( "motion_ads_advanced_sensitivity_scalar_0" )
	SetConVarToDefault( "motion_ads_advanced_sensitivity_scalar_1" )
	SetConVarToDefault( "motion_ads_advanced_sensitivity_scalar_2" )
	SetConVarToDefault( "motion_ads_advanced_sensitivity_scalar_3" )
	SetConVarToDefault( "motion_ads_advanced_sensitivity_scalar_4" )
	SetConVarToDefault( "motion_ads_advanced_sensitivity_scalar_5" )
	SetConVarToDefault( "motion_ads_advanced_sensitivity_scalar_6" )
	SetConVarToDefault( "motion_ads_advanced_sensitivity_scalar_7" )
	
	SavePlayerSettings()
}
