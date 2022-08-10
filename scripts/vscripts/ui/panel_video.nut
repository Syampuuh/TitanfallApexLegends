global function InitVideoPanel
global function InitVideoPanelForCode
global function ApplyVideoSettingsButton_Activate
global function UICodeCallback_ResolutionChanged
global function RestoreVideoDefaults
global function RevertVideoSettings
global function OnVideoMenu_CanNavigateAway
global function DiscardVideoSettingsDialog
global function VideoPanel_GetConVarData
global function AreVideoSettingsChanged

struct
{
	var                panel
	var                videoPanel
	table<var, string> buttonTitles
	table<var, string> buttonDescriptions
	var                detailsPanel

	array<ConVarData>    conVarDataList

	bool videoSettingsChanged = false
} file

void function InitVideoPanelForCode( var panel )
{
	#if PC_PROG
		asset resFile = $"resource/ui/menus/panels/video.res"
	#elseif CONSOLE_PROG
		asset resFile = $"resource/ui/menus/panels/video_console.res"
	#endif
	file.videoPanel = CreateVideoOptionsPanel( panel, "ContentPanel", resFile )
	Hud_SetPos( file.videoPanel, 0, 0 )

	Assert( Hud_HasChild( file.videoPanel, "PanelFrame" ) )
	UISize elementSize = REPLACEHud_GetSize( Hud_GetChild( file.videoPanel, "PanelFrame" ) )
	Hud_SetSize( file.videoPanel, elementSize.width, elementSize.height )
	Hud_Hide( file.videoPanel )
}


void function InitVideoPanel( var panel )
{
	file.panel = panel

	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, OnVideoPanel_Show )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, OnVideoPanel_Hide )

	                                                                                

	var button
	#if PC_PROG
		button = Hud_GetChild( file.videoPanel, "SwchDisplayMode" )
		SetupSettingsButton( button, "#DISPLAY_MODE", "#ADVANCED_VIDEO_MENU_DISPLAYMODE_DESC", $"rui/menu/settings/settings_video" )
		                                                                  

		button = Hud_GetChild( file.videoPanel, "SwchAspectRatio" )
		SetupSettingsButton( button, "#ASPECT_RATIO", "#ADVANCED_VIDEO_MENU_ASPECT_RATIO_DESC", $"rui/menu/settings/settings_video" )
		                                                                  

		button = Hud_GetChild( file.videoPanel, "SldAdaptiveRes" )
		SetupSettingsSlider( button, "#ADAPTIVE_RES", "#ADAPTIVE_RES_DESC", $"rui/menu/settings/settings_video" )
		                                                                  
		AddButtonEventHandler( Hud_GetChild( file.videoPanel, "TextEntryAdaptiveRes" ), UIE_CHANGE, AdaptiveResText_Changed )

		SetupSettingsButton( Hud_GetChild( file.videoPanel, "SwchTextureDetail" ), "#TEXTURE_QUALITY", "#ADVANCED_VIDEO_MENU_TEXTURE_DETAIL_DESC", $"rui/menu/settings/settings_video" )
		                                                                                                                        

		SetupSettingsButton( Hud_GetChild( file.videoPanel, "SwchAdaptiveSupersample" ), "#ADAPTIVE_SUPERSAMPLE", "#ADAPTIVE_SUPERSAMPLE_DESC", $"rui/menu/settings/settings_video" )

		SetupSettingsButton( Hud_GetChild( file.videoPanel, "SwchVolumetricLighting" ), "#VOLUMETRIC_LIGHTING", "#VOLUMETRIC_LIGHTING_DESC", $"rui/menu/settings/settings_video" )
		#if DEV
		SetupSettingsButton( Hud_GetChild( file.videoPanel, "SwchVolumetricFog" ), "#VOLUMETRIC_FOG", "#VOLUMETRIC_FOG_DESC", $"rui/menu/settings/settings_video" )
		#endif
		SetupSettingsButton( Hud_GetChild( file.videoPanel, "SwchResolution" ), "#RESOLUTION", "#ADVANCED_VIDEO_MENU_RESOLUTION_DESC", $"rui/menu/settings/settings_video" )
		                                                                                                                     

		SetupSettingsSlider( Hud_GetChild( file.videoPanel, "SldBrightness" ), "#BRIGHTNESS", "#ADVANCED_VIDEO_MENU_BRIGHTNESS_DESC", $"rui/menu/settings/settings_video" )

		SetupSettingsButton( Hud_GetChild( file.videoPanel, "SwchVSync" ), "#VSYNC", "#ADVANCED_VIDEO_MENU_VSYNC_DESC", $"rui/menu/settings/settings_video" )
		SetupSettingsButton( Hud_GetChild( file.videoPanel, "SwchReflex" ), "#REFLEX", "#ADVANCED_VIDEO_MENU_REFLEX_DESC", $"rui/menu/settings/settings_video" )
		SetupSettingsButton( Hud_GetChild( file.videoPanel, "SwchAntialiasing" ), "#ANTIALIASING", "#ADVANCED_VIDEO_MENU_ANTIALIASING_DESC", $"rui/menu/settings/settings_video" )
		SetupSettingsButton( Hud_GetChild( file.videoPanel, "SwchFilteringMode" ), "#MENU_TEXTURE_FILTERING", "#ADVANCED_VIDEO_MENU_FILTERING_MODE_DESC", $"rui/menu/settings/settings_video" )
		SetupSettingsButton( Hud_GetChild( file.videoPanel, "SwchSunShadowCoverage" ), "#MENU_SUN_SHADOW_COVERAGE", "#ADVANCED_VIDEO_MENU_SUN_SHADOW_COVERAGE_DESC", $"rui/menu/settings/settings_video" )
		SetupSettingsButton( Hud_GetChild( file.videoPanel, "SwchSunShadowDetail" ), "#MENU_SUN_SHADOW_DETAILS", "#ADVANCED_VIDEO_MENU_SUN_SHADOW_DETAIL_DESC", $"rui/menu/settings/settings_video" )
		SetupSettingsButton( Hud_GetChild( file.videoPanel, "SwchSpotShadowDetail" ), "#MENU_SPOT_SHADOW_DETAILS", "#ADVANCED_VIDEO_MENU_SPOT_SHADOW_DETAIL_DESC", $"rui/menu/settings/settings_video" )
		AddButtonEventHandler( Hud_GetChild( file.videoPanel, "SwchSpotShadowDetail" ), UIE_CHANGE, SpotShadowDetail_Changed )
		SetupSettingsButton( Hud_GetChild( file.videoPanel, "SwchDynamicSpotShadows" ), "#MENU_DYNAMIC_SPOT_SHADOWS", "#ADVANCED_VIDEO_MENU_DYNAMIC_SPOT_SHADOWS_DESC", $"rui/menu/settings/settings_video" )
		SetupSettingsButton( Hud_GetChild( file.videoPanel, "SwchAmbientOcclusionQuality" ), "#MENU_AMBIENT_OCCLUSION_QUALITY", "#ADVANCED_VIDEO_MENU_AMBIENT_OCCLUSION_QUALITY_DESC", $"rui/menu/settings/settings_video" )
		SetupSettingsButton( Hud_GetChild( file.videoPanel, "SwchModelDetail" ), "#MENU_MODEL_DETAIL", "#ADVANCED_VIDEO_MENU_MODEL_DETAIL_DESC", $"rui/menu/settings/settings_video" )
		SetupSettingsButton( Hud_GetChild( file.videoPanel, "SwchEffectsDetail" ), "#MENU_EFFECT_DETAIL", "#ADVANCED_VIDEO_MENU_EFFECTS_DETAIL_DESC", $"rui/menu/settings/settings_video" )
		SetupSettingsButton( Hud_GetChild( file.videoPanel, "SwchImpactMarks" ), "#MENU_IMPACT_MARKS", "#ADVANCED_VIDEO_MENU_IMPACT_MARKS_DESC", $"rui/menu/settings/settings_video" )
		SetupSettingsButton( Hud_GetChild( file.videoPanel, "SwchRagdolls" ), "#MENU_RAGDOLLS", "#ADVANCED_VIDEO_MENU_RAGDOLLS_DESC", $"rui/menu/settings/settings_video" )
	#elseif CONSOLE_PROG
		button = Hud_GetChild( file.videoPanel, "BtnBrightness" )
		SetupSettingsButton( button, "#BRIGHTNESS", "#CONSOLE_BRIGHTNESS_DESC", $"rui/menu/settings/settings_video" )
		AddButtonEventHandler( button, UIE_CLICK, AdvanceMenuEventHandler( GetMenu( "GammaMenu" ) ) )
	#endif

	button = Hud_GetChild( file.videoPanel, "SldFOV" )
	SetupSettingsSlider( button, "#FOV", "#ADVANCED_VIDEO_MENU_FOV_DESC", $"rui/menu/settings/settings_video" )
	AddButtonEventHandler( Hud_GetChild( file.videoPanel, "TextEntrySldFOV" ), UIE_CHANGE, FOVTextEntry_Changed )
	SetupSettingsButton( Hud_GetChild( file.videoPanel, "SwchFOVAbilityScaling" ), "#FOV_ABILITY_SCALING", "#FOV_ABILITY_SCALING_DESC", $"rui/menu/settings/settings_video" )
	button = SetupSettingsButton( Hud_GetChild( file.videoPanel, "SwchSprintCameraSmoothing" ), "#SPRINT_VIEW_SHAKE", "#OPTIONS_MENU_SPRINT_VIEW_SHAKE", $"rui/menu/settings/settings_video" )
	AddButtonEventHandler( button, UIE_CHANGE, SprintViewShake_Changed )                                                                                            

	ScrollPanel_InitPanel( panel )
	ScrollPanel_InitScrollBar( panel, Hud_GetChild( panel, "ScrollBar" ) )

	var parentMenu = GetMenu( "MiscMenu" )                              
	AddEventHandlerToButtonClass( parentMenu, "AdvancedVideoButtonClass", UIE_CHANGE, AdvancedVideoButton_Changed )                                                              
	                                                                                                             

	file.conVarDataList.append( CreateSettingsConVarData( "colorblind_mode", eConVarType.INT ) )

	AddPanelFooterOption( panel, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
	AddPanelFooterOption( panel, LEFT, BUTTON_BACK, true, "#BACKBUTTON_RESTORE_DEFAULTS", "#RESTORE_DEFAULTS", OpenConfirmRestoreVideoDefaultsDialog )                                  
	AddPanelFooterOption( panel, LEFT, -1, false, "#FOOTER_CHOICE_HINT", "" )
	AddPanelFooterOption( panel, RIGHT, BUTTON_Y, true, "#Y_BUTTON_APPLY", "#APPLY", ApplyVideoSettingsButton_Activate, AreVideoSettingsChanged )
}


bool function OnVideoMenu_CanNavigateAway( var panel, int desiredTabIndex )
{
	if ( file.videoSettingsChanged )
	{
		DiscardVideoSettingsDialog( panel, desiredTabIndex )
		return false
	}

	return true
}


bool function AreVideoSettingsChanged()
{
	                                                                   
	return file.videoSettingsChanged
}


void function OnVideoPanel_Show( var panel )
{
	ScrollPanel_SetActive( panel, true )
	Hud_Show( file.videoPanel )
	VideoOptions_FillInCurrent( file.videoPanel )
	file.videoSettingsChanged = false
	UpdateFooterOptions()

	#if PC_PROG
		var aspectRatioButton = Hud_GetChild( file.videoPanel, "SwchAspectRatio" )
		var resolutionButton  = Hud_GetChild( file.videoPanel, "SwchResolution" )

		if ( GetConVarBool( "party_readyToSearch" ) )
		{
			ToolTipData lockedSettingToolTip
			lockedSettingToolTip.descText = "#ADVANCED_VIDEO_MENU_LOCKED_TOOLTIP"
			Hud_SetToolTipData( aspectRatioButton, lockedSettingToolTip )
			Hud_SetToolTipData( resolutionButton, lockedSettingToolTip )
		}
		else
		{
			Hud_ClearToolTipData( aspectRatioButton )
			Hud_ClearToolTipData( resolutionButton )
		}
	#endif
}


array<ConVarData> function VideoPanel_GetConVarData()
{
	return file.conVarDataList
}


void function OnVideoPanel_Hide( var panel )
{
	SaveSettingsConVars( file.conVarDataList )
	ScrollPanel_SetActive( panel, false )
	Hud_Hide( file.videoPanel )
	SavePlayerSettings()
	file.videoSettingsChanged = false
}


void function AdvancedVideoButton_Changed( var button )
{

	#if PC_PROG
		if ( button == Hud_GetChild( file.videoPanel, "SwchDisplayMode" ) )
			DisplayMode_Changed( button )
		else if ( button == Hud_GetChild( file.videoPanel, "SwchAspectRatio" ) )
			AspectRatio_Changed( button )
		else if ( button == Hud_GetChild( file.videoPanel, "SldAdaptiveRes" ) )
			AdaptiveRes_Changed( button )
		                                                                               
		  	                                 
		else if ( button == Hud_GetChild( file.videoPanel, "SwchTextureDetail" ) )
			TextureStreamBudget_Changed( button )
		else if ( button == Hud_GetChild( file.videoPanel, "SwchResolution" ) )
			ResolutionSelection_Changed( button )
	#endif

	if ( button == Hud_GetChild( file.videoPanel, "SldFOV" ) )
		FOV_Changed( button )

	                                                                                   
	if ( !IsTabPanelActive( file.panel ) )
		return

	file.videoSettingsChanged = true

	UpdateFooterOptions()
}


void function OpenConfirmRestoreVideoDefaultsDialog( var button )
{
	ConfirmDialogData data
	data.headerText = "#RESTORE_VIDEO_DEFAULTS"
	data.messageText = "#RESTORE_VIDEO_DEFAULTS_DESC"
	data.resultCallback = OnConfirmDialogResult

	OpenConfirmDialogFromData( data )
	AdvanceMenu( GetMenu( "ConfirmDialog" ) )
}


void function OnConfirmDialogResult( int result )
{
	switch ( result )
	{
		case eDialogResult.YES:
			RestoreVideoDefaults()
	}
}


void function RestoreVideoDefaults()
{
	VideoOptions_ResetToRecommended( file.videoPanel )
}


void function ApplyVideoSettingsButton_Activate( var button )
{
	print( "Video Settings Changed\n" )
	VideoOptions_Apply( file.videoPanel )
	file.videoSettingsChanged = false

	UpdateFooterOptions()
}


void function DiscardVideoSettingsDialog( var panel, int desiredTabIndex = -1 )
{
	ConfirmDialogData dialogData
	dialogData.headerText = "#APPLY_CHANGES"
	dialogData.messageText = "#APPLY_CHANGES_DESC"
	dialogData.yesText = ["#A_BUTTON_DISCARD", "#DISCARD"]

	dialogData.resultCallback = void function ( int result ) : ( panel, desiredTabIndex )
	{
		if ( result == eDialogResult.YES )
		{
			thread (void function() : ( panel, desiredTabIndex )
			{
				file.videoSettingsChanged = false
				if ( desiredTabIndex <= 0 )
				{
					if ( GetActiveMenu() == GetMenu( "MiscMenu" ) )
						CloseActiveMenu()

					return
				}

				TabData tabData = GetTabDataForPanel( panel )
				ActivateTab( tabData, desiredTabIndex )
			})()
		}
	}

	OpenConfirmDialogFromData( dialogData )
}


void function UICodeCallback_ResolutionChanged( bool askForConfirmation )
{
	if ( askForConfirmation )
	{
		CloseAllDialogs()                                                                                                                                               
		AdvanceMenu( GetMenu( "ConfirmKeepVideoChangesDialog" ) )
	}
	else
	{
		foreach ( func in uiGlobal.resolutionChangedCallbacks )
			func()
	}
}


void function RevertVideoSettings()
{
	thread RevertVideoSettingsThread()
}


void function RevertVideoSettingsThread()
{
	                                                                                                  
	WaitEndFrame()

	VideoOptions_RejectNewSettings( file.videoPanel )
	WaitFrame()
	VideoOptions_FillInCurrent( file.videoPanel )
	file.videoSettingsChanged = false
}


void function DialogChoice_ApplyVideoSettingsAndCloseMenu()
{
	VideoOptions_Apply( file.videoPanel )
}


void function DisplayMode_Changed( var button )
{
	VideoOptions_OnWindowedChanged( file.videoPanel )
}


void function AspectRatio_Changed( var button )
{
	VideoOptions_ResetResolutionList( file.videoPanel )
}


void function AdaptiveRes_Changed( var button )
{
	VideoOptions_AdaptiveResChanged( file.videoPanel )
}


void function ResolutionSelection_Changed( var button )
{
	VideoOptions_ResolutionSelectionChanged( file.videoPanel )
}


void function AdaptiveResText_Changed( var button )
{
	VideoOptions_AdaptiveResTextChanged( file.videoPanel )
}


void function FOV_Changed( var button )
{
	VideoOptions_FOVChanged( file.videoPanel )
}


void function FOVTextEntry_Changed( var button )
{
	VideoOptions_FOVTextChanged( file.videoPanel )
}


void function SprintViewShake_Changed( var button )
{
	file.videoSettingsChanged = true
	UpdateFooterOptions()
}


void function TextureStreamBudget_Changed( var button )
{
	VideoOptions_TextureStreamBudgetChanged( file.videoPanel )
}

void function SpotShadowDetail_Changed( var button )
{
	VideoOptions_SpotShadowDetailChanged( file.videoPanel )
}


void function FooterButton_Focused( var button )
{
	                                                                  
	                          
}
