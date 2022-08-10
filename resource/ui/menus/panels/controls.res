"resource/ui/menus/panels/controls.res"
{
	PanelFrame
	{
		ControlName				Label
		xpos					0
		ypos					0
		wide					%100
		tall					1500
		labelText				""
		bgcolor_override		"70 70 70 255"
		visible					0
		paintbackground			1

        proportionalToParent    1
	}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    BtnGamepadLayout
    {
        ControlName				RuiButton
        InheritProperties		SettingBasicButton
        tabPosition				1

        navDown					SwchStickLayout
    }
    SwchStickLayout
    {
        ControlName				RuiButton
        InheritProperties		SwitchButton
        style					DialogListButton
        pin_to_sibling			BtnGamepadLayout
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        navUp					BtnGamepadLayout
        navDown					SwchTapToUse
        ConVar					"gamepad_stick_layout"
        list
        {
            "#SETTING_DEFAULT"	0
            "#SOUTHPAW"			1
            "#LEGACY"			2
            "#LEGACY_SOUTHPAW"	3
        }

        childGroupAlways        MultiChoiceButtonAlways
    }
    SwchTapToUse
    {
        ControlName				RuiButton
        InheritProperties		SwitchButton
        style					DialogListButton
        pin_to_sibling			SwchStickLayout
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        navUp					SwchStickLayout
        navDown					SwchHoldToCrouch
        ConVar					"gamepad_use_type"
        list
        {
            "#SETTING_HOLDTOUSE_TAPTORELOAD"    0
            "#SETTING_TAPTOUSE_HOLDTORELOAD"    1
            "#SETTING_TAPTOUSE_TAPTORELOAD"     2
        }

        childGroupAlways        MultiChoiceButtonAlways
    }
    SwchHoldToCrouch
    {
        ControlName				RuiButton
        InheritProperties		SwitchButton
        style					DialogListButton
        pin_to_sibling			SwchTapToUse
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        navUp					SwchTapToUse
        navDown					SwchToggleGamepadADS
        ConVar					"gamepad_togglecrouch_hold"
        list
        {
            "#HOLDTOCROUCH_OFF"	0
            "#HOLDTOCROUCH_ON"	1
        }

        childGroupAlways        ChoiceButtonAlways
    }
    SwchToggleGamepadADS
    {
        ControlName				RuiButton
        InheritProperties		SwitchButton
        style					DialogListButton
        pin_to_sibling			SwchHoldToCrouch
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        navUp					SwchHoldToCrouch
        navDown					SwitchSurvivalSlotToWeaponInspect
		
        ConVar					"gamepad_toggle_ads"
        list
        {
            "#GAMEPAD_TOGGLE_ADS_OFF"	0
            "#GAMEPAD_TOGGLE_ADS_ON"	1
        }

        childGroupAlways        ChoiceButtonAlways
    }
    SwitchSurvivalSlotToWeaponInspect
    {
        ControlName				RuiButton
        InheritProperties		SwitchButton
        style					DialogListButton
        navUp					SwchToggleGamepadADS
        navDown					SwchTriggerDeadzone [!$NX && !$NX_UI_PC]
        navDown					SldCursorVelocity   [$NX || $NX_UI_PC]
        ConVar					"gamepad_toggle_survivalSlot_to_weaponInspect"
        list
        {
            "#SETTING_USE_SURVIVAL_SLOT"    0
            "#SETTING_USE_WEAPON_INSPECT"   1
        }

        pin_to_sibling			SwchToggleGamepadADS
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        childGroupAlways        ChoiceButtonAlways
    }
    SwchTriggerDeadzone [!$NX]
    {
        ControlName				RuiButton
        InheritProperties		SwitchButton
        style					DialogListButton
        pin_to_sibling			SwitchSurvivalSlotToWeaponInspect
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
		navUp					SwitchSurvivalSlotToWeaponInspect
        navDown					SldCursorVelocity
        ConVar					"gamepad_trigger_threshold"
        list
        {
            "#SETTING_TRIGGERDEADZONE_NONE"			0
            "#SETTING_TRIGGERDEADZONE_DEFAULT"		30
            "#SETTING_TRIGGERDEADZONE_MODERATE"		64
            "#SETTING_TRIGGERDEADZONE_HIGH"			128
            "#SETTING_TRIGGERDEADZONE_MAX"			255
        }

        childGroupAlways        MultiChoiceButtonAlways
    }
    SldCursorVelocity
    {
        ControlName				SliderControl
        InheritProperties		SliderControl
        
        pin_to_sibling			SwchTriggerDeadzone  [!$NX && !$NX_UI_PC]
        pin_to_sibling			SwitchSurvivalSlotToWeaponInspect [$NX || $NX_UI_PC]
        navUp				SwchTriggerDeadzone  [!$NX && !$NX_UI_PC]
        navUp				SwitchSurvivalSlotToWeaponInspect [$NX || $NX_UI_PC]

        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT

        navDown					SwchLookSensitivity
        minValue				1300.0
        maxValue				4300.0
        stepSize				100.0
        conCommand				"gameCursor_velocity"
    }
    LookMoveHeader
    {
        ControlName				ImagePanel
        InheritProperties		SubheaderBackgroundWide
        xpos					0
        ypos					6
        pin_to_sibling			SldCursorVelocity
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
    }
    LookMoveHeaderText
    {
        ControlName				Label
        InheritProperties		SubheaderText
        pin_to_sibling			LookMoveHeader
        pin_corner_to_sibling	LEFT
        pin_to_sibling_corner	LEFT
        labelText				"#MENU_LOOKMOVE"
    }
    SwchLookSensitivity
    {
        ControlName				RuiButton
        InheritProperties		SwitchButton
        style					DialogListButton
        pin_to_sibling			LookMoveHeader
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        navUp					SldCursorVelocity
        navDown					SwchLookSensitivityADS
        ConVar					"gamepad_aim_speed"
        list
        {
            "#SETTING_SENSITIVITY_VERYLOW"		0
            "#SETTING_SENSITIVITY_LOW"			1
            "#SETTING_SENSITIVITY_DEFAULT_NUM"	2
            "#SETTING_SENSITIVITY_HIGH"			3
            "#SETTING_SENSITIVITY_VERY_HIGH"	4
            "#SETTING_SENSITIVITY_SUPER_HIGH"	5
            "#SETTING_SENSITIVITY_ULTRA_HIGH"	6
            "#SETTING_SENSITIVITY_INSANE"		7
        }

        childGroupAlways        MultiChoiceButtonAlways
    }
    SwchLookSensitivity_AdvLabel
    {
        ControlName				Label
        InheritProperties		AdvControlsLabel	//SubheaderText
        pin_to_sibling			SwchLookSensitivity
        pin_corner_to_sibling	CENTER
        pin_to_sibling_corner	CENTER
        xpos					0
        ypos					0
        font					DefaultBold_27_DropShadow
        labelText				"#CONTROLS_ADVANCED_LOOK_ENABLED"
        visible                 0
    }
    SwchLookSensitivityADS
    {
        ControlName				RuiButton
        InheritProperties		SwitchButton
        style					DialogListButton
        pin_to_sibling			SwchLookSensitivity
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        navUp					SwchLookSensitivity
        navDown					BtnLookSensitivityMenu
        ConVar					"gamepad_aim_speed_ads_0"
        list
        {
            "#SETTING_SENSITIVITY_SAME"			-1
            "#SETTING_SENSITIVITY_VERYLOW"		0
            "#SETTING_SENSITIVITY_LOW"			1
            "#SETTING_SENSITIVITY_DEFAULT_NUM"	2
            "#SETTING_SENSITIVITY_HIGH"			3
            "#SETTING_SENSITIVITY_VERY_HIGH"	4
            "#SETTING_SENSITIVITY_SUPER_HIGH"	5
            "#SETTING_SENSITIVITY_ULTRA_HIGH"	6
            "#SETTING_SENSITIVITY_INSANE"		7
        }

        childGroupAlways        MultiChoiceButtonAlways
    }
    SwchLookSensitivityADS_AdvLabel
    {
        ControlName				Label
        InheritProperties		AdvControlsLabel
        pin_to_sibling			BtnLookSensitivityMenu
        pin_corner_to_sibling	CENTER
        pin_to_sibling_corner	CENTER
        xpos					0
        ypos					0
        font					DefaultBold_27_DropShadow
        labelText				"#CONTROLS_ADVANCED_LOOK_ENABLED"
        visible                 0
    }
    BtnLookSensitivityMenu
    {
        ControlName				RuiButton
        InheritProperties		SettingBasicButton

        pin_to_sibling			SwchLookSensitivityADS
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        navUp					SwchLookSensitivityADS
        navDown					SwchLookAiming
    }
    SwchLookAiming
    {
        ControlName				RuiButton
        InheritProperties		SwitchButton
        style					DialogListButton
        pin_to_sibling			BtnLookSensitivityMenu
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        navUp					BtnLookSensitivityMenu
        navDown					SwchLookDeadzone
        ConVar					"gamepad_look_curve"
        list
        {
            "#LOOKSTICK_AIMING_0"		0
            "#LOOKSTICK_AIMING_1"		1
            "#LOOKSTICK_AIMING_2"		2
            "#LOOKSTICK_AIMING_3"		3
            "#LOOKSTICK_AIMING_4"		4
        }

        childGroupAlways        MultiChoiceButtonAlways
    }
    SwchLookAiming_AdvLabel
    {
        ControlName				Label
        InheritProperties		AdvControlsLabel
        pin_to_sibling			SwchLookAiming
        pin_corner_to_sibling	CENTER
        pin_to_sibling_corner	CENTER
        xpos					0
        ypos					0
        font					DefaultBold_27_DropShadow
        labelText				"#CONTROLS_ADVANCED_LOOK_ENABLED"
        visible                 0
    }
    SwchLookDeadzone
    {
        ControlName				RuiButton
        InheritProperties		SwitchButton
        style					DialogListButton
        pin_to_sibling			SwchLookAiming
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        navUp					SwchLookAiming
        navDown					SwchMoveDeadzone
        ConVar					"gamepad_deadzone_index_look"
        list
        {
            "#SETTING_NONE"		0       [!$NX]
            "#SETTING_SMALL"	1
            "#SETTING_LARGE"	2
        }

        childGroupAlways        MultiChoiceButtonAlways
    }
    SwchLookDeadzone_AdvLabel
    {
        ControlName				Label
        InheritProperties		AdvControlsLabel
        pin_to_sibling			SwchLookDeadzone
        pin_corner_to_sibling	CENTER
        pin_to_sibling_corner	CENTER
        xpos					0
        ypos					0
        font					DefaultBold_27_DropShadow
        labelText				"#CONTROLS_ADVANCED_LOOK_ENABLED"
        visible                 0
    }
    SwchMoveDeadzone
    {
        ControlName				RuiButton
        InheritProperties		SwitchButton
        style					DialogListButton
        pin_to_sibling			SwchLookDeadzone
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        navUp					SwchLookDeadzone
        navDown					SwchLookInvert
        ConVar					"gamepad_deadzone_index_move"
        list
        {
            "#SETTING_SMALL"	1
            "#SETTING_LARGE"	2
        }

        childGroupAlways        ChoiceButtonAlways
    }
    SwchLookInvert
    {
        ControlName				RuiButton
        InheritProperties		SwitchButton
        style					DialogListButton
        pin_to_sibling			SwchMoveDeadzone
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        navUp					SwchMoveDeadzone
        navDown					SwchVibration
        ConVar					"joy_inverty"
        list
        {
            "#SETTING_OFF"			0
            "#SETTING_INVERTED"		1
        }

        childGroupAlways        ChoiceButtonAlways
    }
    SwchVibration
    {
        ControlName				RuiButton
        InheritProperties		SwitchButton
        style					DialogListButton
        pin_to_sibling			SwchLookInvert
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        navUp					SwchLookInvert
        navDown					BtnControllerOpenAdvancedMenu
        ConVar					"joy_rumble"
        list
        {
            "#SETTING_OFF"		0
            "#SETTING_ON"		1
        }

        childGroupAlways        ChoiceButtonAlways
    }

    BtnControllerOpenAdvancedMenu
    {
        ControlName				RuiButton
        InheritProperties		SettingBasicButton
        pin_to_sibling			SwchVibration
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        navUp					SwchVibration
		navDown					NXMotionOnOff [$NX || $NX_UI_PC]
        visible                 1
    }
    BtnControllerOpenAdvancedMenu_NXMissingProLabel [$NX || $NX_UI_PC]
    {
        ControlName				Label
        InheritProperties		AdvControlsLabel
        pin_to_sibling			BtnControllerOpenAdvancedMenu
        pin_corner_to_sibling	RIGHT
        pin_to_sibling_corner	RIGHT
        xpos					-10
        ypos					0
        font					DefaultBold_27_DropShadow
        labelText				"#CONTROLS_NX_PRO_CONTROLLER_REQUIRED"
        visible                 0
		fontHeight				45
    }

	PanelBottom
	{
		ControlName				Label
		labelText               ""

		zpos                    0
		wide					1
		tall					1
		visible					1
		enabled 				0

        pin_to_sibling			BtnControllerOpenAdvancedMenu
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_LEFT
	}

//    LblAdvControllerOff
//    {
//        ControlName				Label
//        InheritProperties		AdvControlsLabel
//        pin_to_sibling			BtnControllerOpenAdvancedMenu
//        pin_corner_to_sibling	RIGHT
//        pin_to_sibling_corner	RIGHT
//        xpos					-10
//        zpos					2
//        auto_tall_tocontents	1
//        visible                 0
//
//        fgcolor_override		"255 255 255 127"
//        labelText				"#SETTING_DISABLED"
//        font                    DefaultRegularFont
//        fontHeight              25
//    }
//    LblAdvControllerOn
//    {
//        ControlName				Label
//        InheritProperties		AdvControlsLabel
//        pin_to_sibling			BtnControllerOpenAdvancedMenu
//        pin_corner_to_sibling	RIGHT
//        pin_to_sibling_corner	RIGHT
//        xpos					-10
//        zpos					2
//        auto_tall_tocontents	1
//        visible                 0
//
//        labelText				"#SETTING_ENABLED"
//        font                    DefaultRegularFont
//        fontHeight              26
//    }
	NXMotionControlHeader [$NX]
    {
        ControlName				ImagePanel
        InheritProperties		SubheaderBackgroundWide
        xpos					0
        ypos					6
        pin_to_sibling			BtnControllerOpenAdvancedMenu
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
    }
    NXMotionControlHeaderText [$NX]
    {
        ControlName				Label
        InheritProperties		SubheaderText
        pin_to_sibling			NXMotionControlHeader
        pin_corner_to_sibling	LEFT
        pin_to_sibling_corner	LEFT
        labelText				"#MENU_NXMOTIONCONTROL"
    }
	NXMotionOnOff [$NX]
    {
        ControlName				RuiButton
        InheritProperties		SwitchButton
        style					DialogListButton
        pin_to_sibling			NXMotionControlHeader
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        navUp					BtnControllerOpenAdvancedMenu
        navDown					SldNXMotionSensitivity
        ConVar					"nx_six_axis_control_on"
        list
        {
            "#SETTING_OFF"			0
            "#SETTING_ON"			1
        }

        childGroupAlways        ChoiceButtonAlways
    }
	
	SldNXMotionSensitivity [$NX]
    {
        ControlName				SliderControl
        InheritProperties		SliderControl
        pin_to_sibling			NXMotionOnOff
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        navUp					NXMotionOnOff
        navDown					SldNXHorizontalSensitivity
        conCommand				"nx_six_axis_sensitivity"
        minValue				0.2
        maxValue				10.0
        stepSize				0.2
        inverseFill             0
        showLabel               0
    }
    TextNXMotionSensitivity [$NX]
    {
        ControlName				TextEntry
        InheritProperties       SliderControlTextEntry
        syncedConVar            "nx_six_axis_sensitivity"
        showConVarAsFloat		1

        pin_to_sibling			SldNXMotionSensitivity
        pin_corner_to_sibling	RIGHT
        pin_to_sibling_corner	RIGHT
    }
	
	SldNXHorizontalSensitivity [$NX]
    {
        ControlName				SliderControl
        InheritProperties		SliderControl
        pin_to_sibling			SldNXMotionSensitivity
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        navUp					SldNXMotionSensitivity
        navDown					SldNXVerticalSensitivity
        conCommand				"nx_six_axis_horizontalScale"
        minValue				4.0
        maxValue				20.0
        stepSize				0.2
        inverseFill             0
        showLabel               0
    }
    TextNXHorizontalSensitivity [$NX]
    {
        ControlName				TextEntry
        InheritProperties       SliderControlTextEntry
        syncedConVar            "nx_six_axis_horizontalScale"
        showConVarAsFloat		1

        pin_to_sibling			SldNXHorizontalSensitivity
        pin_corner_to_sibling	RIGHT
        pin_to_sibling_corner	RIGHT
    }
	
	SldNXVerticalSensitivity [$NX]
    {
        ControlName				SliderControl
        InheritProperties		SliderControl
        pin_to_sibling			SldNXHorizontalSensitivity
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        navUp					SldNXHorizontalSensitivity
        navDown					SldNXADSMotionSensitivity
        conCommand				"nx_six_axis_verticalScale"
        minValue				4.0
        maxValue				20.0
        stepSize				0.2
        inverseFill             0
        showLabel               0
    }
    TextNXVerticalSensitivity [$NX]
    {
        ControlName				TextEntry
        InheritProperties       SliderControlTextEntry
        syncedConVar            "nx_six_axis_verticalScale"
        showConVarAsFloat		1

        pin_to_sibling			SldNXVerticalSensitivity
        pin_corner_to_sibling	RIGHT
        pin_to_sibling_corner	RIGHT
    }
	
	SldNXADSMotionSensitivity [$NX]
    {
        ControlName				SliderControl
        InheritProperties		SliderControl
        pin_to_sibling			SldNXVerticalSensitivity
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        navUp					SldNXVerticalSensitivity
        navDown					BtnMotionPerOpticMenu
        conCommand				"nx_six_axis_ads_sensitivity"
        minValue				0.2
        maxValue				10.0
        stepSize				0.2
        inverseFill             0
        showLabel               0
    }
    TextNXADSMotionSensitivity [$NX]
    {
        ControlName				TextEntry
        InheritProperties       SliderControlTextEntry
        syncedConVar            "nx_six_axis_ads_sensitivity"
        showConVarAsFloat		1

        pin_to_sibling			SldNXADSMotionSensitivity
        pin_corner_to_sibling	RIGHT
        pin_to_sibling_corner	RIGHT
    }
	
	BtnMotionPerOpticMenu [$NX]
    {
        ControlName				RuiButton
        InheritProperties		SettingBasicButton

        pin_to_sibling			SldNXADSMotionSensitivity
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        navUp					SldNXADSMotionSensitivity
        navDown					SldNXADSHorizontalSensitivity
    }
	
	SldNXADSHorizontalSensitivity [$NX]
    {
        ControlName				SliderControl
        InheritProperties		SliderControl
        pin_to_sibling			BtnMotionPerOpticMenu
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        navUp					BtnMotionPerOpticMenu
        navDown					SldNXADSVerticalSensitivity
        conCommand				"nx_six_axis_ads_horizontalScale"
        minValue				4.0
        maxValue				20.0
        stepSize				0.2
        inverseFill             0
        showLabel               0
    }
    TextNXADSHorizontalSensitivity [$NX]
    {
        ControlName				TextEntry
        InheritProperties       SliderControlTextEntry
        syncedConVar            "nx_six_axis_ads_horizontalScale"
        showConVarAsFloat		1

        pin_to_sibling			SldNXADSHorizontalSensitivity
        pin_corner_to_sibling	RIGHT
        pin_to_sibling_corner	RIGHT
    }
	
	SldNXADSVerticalSensitivity [$NX]
    {
        ControlName				SliderControl
        InheritProperties		SliderControl
        pin_to_sibling			SldNXADSHorizontalSensitivity
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        navUp					SldNXADSHorizontalSensitivity
        navDown					""
        conCommand				"nx_six_axis_ads_verticalScale"
        minValue				4.0
        maxValue				20.0
        stepSize				0.2
        inverseFill             0
        showLabel               0
    }
    TextNXADSVerticalSensitivity [$NX]
    {
        ControlName				TextEntry
        InheritProperties       SliderControlTextEntry
        syncedConVar            "nx_six_axis_ads_verticalScale"
        showConVarAsFloat		1

        pin_to_sibling			SldNXADSVerticalSensitivity
        pin_corner_to_sibling	RIGHT
        pin_to_sibling_corner	RIGHT
    }
	
//	NXPersistentTurnOnOff [$NX]
//    {
//        ControlName				RuiButton
//        InheritProperties		SwitchButton
//        style					DialogListButton
//        pin_to_sibling			NXADSVerticalSensitivity
//        pin_corner_to_sibling	TOP_LEFT
//        pin_to_sibling_corner	BOTTOM_LEFT
//        navUp					NXADSVerticalSensitivity
//        ConVar					"nx_six_axis_persist_turn"
//        list
//        {
//            "#SETTING_OFF"			0
//            "#SETTING_ON"			1
//        }
//
//        childGroupAlways        ChoiceButtonAlways
//    }
}