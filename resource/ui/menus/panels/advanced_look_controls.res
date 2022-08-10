"resource/ui/menus/panels/advanced_look_controls.res"
{
//	PanelFrame
//	{
//		ControlName				Label
//		xpos					0
//		ypos					0
//		wide					%100
//		tall					1500
//		labelText				""
//		bgcolor_override		"70 70 70 255"
//		visible					0
//		paintbackground			1
//
//        proportionalToParent    1
//	}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    SwchGamepadCustomEnabled
    {
        ControlName				RuiButton
        InheritProperties		SwitchButton
        style					DialogListButton
        xpos					0
        ypos					0
        navDown					SldGamepadCustomDeadzoneIn
        tabPosition				1
        ConVar					"gamepad_custom_enabled"
        list
        {
            "#SETTING_OFF"		0
            "#SETTING_ON"		1
        }

        childGroupAlways        ChoiceButtonAlways
    }

    SldGamepadCustomDeadzoneIn
    {
        ControlName				SliderControl
        InheritProperties		SliderControl
        pin_to_sibling			SwchGamepadCustomEnabled
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        ypos					32
        navUp					SwchGamepadCustomEnabled
        navDown					SldGamepadCustomDeadzoneOut
        conCommand				"gamepad_custom_deadzone_in"
        minValue				0.0
        maxValue				0.5
        stepSize				0.025
        inverseFill             0
        showLabel               3
    }

    SldGamepadCustomDeadzoneOut
    {
        ControlName				SliderControl
        InheritProperties		SliderControl
        pin_to_sibling			SldGamepadCustomDeadzoneIn
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        navUp					SldGamepadCustomDeadzoneIn
        navDown					SldGamepadCustomCurve
        conCommand				"gamepad_custom_deadzone_out"
        minValue				0.01
        maxValue				0.3
        stepSize				0.01
        inverseFill             0
        showLabel               3
    }

    SldGamepadCustomCurve
    {
        ControlName				SliderControl
        InheritProperties		SliderControl
        pin_to_sibling			SldGamepadCustomDeadzoneOut
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        navUp					SldGamepadCustomDeadzoneOut
        navDown					BtnLookSensitivityMenu
        conCommand				"gamepad_custom_curve"
        minValue				0.0
        maxValue				30.0
        stepSize				1.0
        inverseFill             0
        showLabel               1
    }
	
	//////////////////////////
	// Per Optic Settings...
	//////////////////////////

	BtnLookSensitivityMenu
    {
        ControlName				RuiButton
        InheritProperties		SettingBasicButton

        pin_to_sibling			SldGamepadCustomCurve
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        ypos					32
        navUp					SldGamepadCustomCurve
        navDown					SldGamepadCustomHipYaw
    }
    
    ///////////////////////////
    // Hipfire
    ///////////////////////////

    SldGamepadCustomHipYaw
    {
        ControlName				SliderControl
        InheritProperties		SliderControl
        pin_to_sibling			BtnLookSensitivityMenu
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        ypos					32
        navUp					BtnLookSensitivityMenu
        navDown					SldGamepadCustomHipPitch
        conCommand				"gamepad_custom_hip_yaw"
        minValue				0.0
        maxValue				500.0
        stepSize				10.0
        inverseFill             0
        showLabel               1
    }

    SldGamepadCustomHipPitch
    {
        ControlName				SliderControl
        InheritProperties		SliderControl
        pin_to_sibling			SldGamepadCustomHipYaw
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        navUp					SldGamepadCustomHipYaw
        navDown					SldGamepadCustomHipTurnYaw
        conCommand				"gamepad_custom_hip_pitch"
        minValue				0.0
        maxValue				500.0
        stepSize				10.0
        inverseFill             0
        showLabel               1
    }

    SldGamepadCustomHipTurnYaw
    {
        ControlName				SliderControl
        InheritProperties		SliderControl
        pin_to_sibling			SldGamepadCustomHipPitch
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        navUp					SldGamepadCustomHipPitch
        navDown					SldGamepadCustomHipTurnPitch
        conCommand				"gamepad_custom_hip_turn_yaw"
        minValue				0.0
        maxValue				250.0
        stepSize				10.0
        showLabel               1
    }

    SldGamepadCustomHipTurnPitch
    {
        ControlName				SliderControl
        InheritProperties		SliderControl
        pin_to_sibling			SldGamepadCustomHipTurnYaw
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        navUp					SldGamepadCustomHipTurnYaw
        navDown					SldGamepadCustomHipTurnTime
        conCommand				"gamepad_custom_hip_turn_pitch"
        minValue				0.0
        maxValue				250.0
        stepSize				10.0
        inverseFill             0
        showLabel               1
    }

    SldGamepadCustomHipTurnTime
    {
        ControlName				SliderControl
        InheritProperties		SliderControl
        pin_to_sibling			SldGamepadCustomHipTurnPitch
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        navUp					SldGamepadCustomHipTurnPitch
        navDown					SldGamepadCustomHipTurnDelay
        conCommand				"gamepad_custom_hip_turn_time"
        minValue				0.0
        maxValue				1.0
        stepSize				0.05
        inverseFill             0
        showLabel               3
    }

    SldGamepadCustomHipTurnDelay
    {
        ControlName				SliderControl
        InheritProperties		SliderControl
        pin_to_sibling			SldGamepadCustomHipTurnTime
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        navUp					SldGamepadCustomHipTurnTime
        navDown					SldGamepadCustomADSYaw
        conCommand				"gamepad_custom_hip_turn_delay"
        minValue				0.0
        maxValue				1.0
        stepSize				0.05
        inverseFill             0
        showLabel               3
    }

    ///////////////////////////
    // ADS
    ///////////////////////////

    SldGamepadCustomADSYaw
    {
        ControlName				SliderControl
        InheritProperties		SliderControl
        pin_to_sibling			SldGamepadCustomHipTurnDelay
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        ypos					32
        navUp					SldGamepadCustomHipTurnDelay
        navDown					SldGamepadCustomADSPitch
        conCommand				"gamepad_custom_ads_yaw"
        minValue				0.0
        maxValue				500.0
        stepSize				10.0
        inverseFill             0
        showLabel               1
    }

    SldGamepadCustomADSPitch
    {
        ControlName				SliderControl
        InheritProperties		SliderControl
        pin_to_sibling			SldGamepadCustomADSYaw
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        navUp					SldGamepadCustomADSYaw
        navDown					SldGamepadCustomADSTurnYaw
        conCommand				"gamepad_custom_ads_pitch"
        minValue				0.0
        maxValue				500.0
        stepSize				10.0
        inverseFill             0
        showLabel               1
    }

    SldGamepadCustomADSTurnYaw
    {
        ControlName				SliderControl
        InheritProperties		SliderControl
        pin_to_sibling			SldGamepadCustomADSPitch
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        navUp					SldGamepadCustomADSPitch
        navDown					SldGamepadCustomADSTurnPitch
        conCommand				"gamepad_custom_ads_turn_yaw"
        minValue				0.0
        maxValue				250.0
        stepSize				10.0
        inverseFill             0
        showLabel               1
    }

    SldGamepadCustomADSTurnPitch
    {
        ControlName				SliderControl
        InheritProperties		SliderControl
        pin_to_sibling			SldGamepadCustomADSTurnYaw
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        navUp					SldGamepadCustomADSTurnYaw
        navDown					SldGamepadCustomADSTurnTime
        conCommand				"gamepad_custom_ads_turn_pitch"
        minValue				0.0
        maxValue				250.0
        stepSize				10.0
        inverseFill             0
        showLabel               1
    }

    SldGamepadCustomADSTurnTime
    {
        ControlName				SliderControl
        InheritProperties		SliderControl
        pin_to_sibling			SldGamepadCustomADSTurnPitch
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        navUp					SldGamepadCustomADSTurnPitch
        navDown					SldGamepadCustomADSTurnDelay
        conCommand				"gamepad_custom_ads_turn_time"
        minValue				0.0
        maxValue				1.0
        stepSize				0.05
        inverseFill             0
        showLabel               3
    }

    SldGamepadCustomADSTurnDelay
    {
        ControlName				SliderControl
        InheritProperties		SliderControl
        pin_to_sibling			SldGamepadCustomADSTurnTime
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        navUp					SldGamepadCustomADSTurnTime
        navDown					SwchGamepadAimAssist
        conCommand				"gamepad_custom_ads_turn_delay"
        minValue				0.0
        maxValue				1.0
        stepSize				0.05
        inverseFill             0
        showLabel               3
    }

	///////////////////////////
    // Aim Assist
    ///////////////////////////
    
	CustomAimAssistHeader
	{
		ControlName				ImagePanel
		InheritProperties		SubheaderBackgroundWide
		pin_to_sibling			SldGamepadCustomADSTurnDelay
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
		ypos					32
	}
	CustomAimAssistHeaderText
	{
		ControlName				Label
		InheritProperties		SubheaderText
		pin_to_sibling			CustomAimAssistHeader
		pin_corner_to_sibling	LEFT
		pin_to_sibling_corner	LEFT
		labelText				"#GAMEPADCUSTOM_ASSIST"
	}
	SwchGamepadAimAssist
        {
            ControlName				RuiButton
            InheritProperties		SwitchButton
            style					DialogListButton
            navUp					SldGamepadCustomADSTurnDelay
            navDown					SwchGamepadAimAssistMelee
            ConVar					"gamepad_custom_assist_on"
            list
            {
                "#SETTING_OFF"		0
                "#SETTING_ON"		1
            }

            pin_to_sibling			CustomAimAssistHeader
            pin_corner_to_sibling	TOP_LEFT
            pin_to_sibling_corner	BOTTOM_LEFT
            childGroupAlways        ChoiceButtonAlways
    }
    SwchGamepadAimAssistMelee
    {
        ControlName				RuiButton
        InheritProperties		SwitchButton
        style					DialogListButton
        navUp					SwchGamepadAimAssist
        navDown					SwchGamepadAimAssistStyle [$GAMECONSOLE]
		navDown					SwchGamepadAimAssistHipLowPowerScope [$WINDOWS]		
        ConVar					"gamepad_aim_assist_melee"
        list
        {
            "#SETTING_OFF"		0
            "#SETTING_ON"		1
        }

        pin_to_sibling			SwchGamepadAimAssist
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        childGroupAlways        ChoiceButtonAlways
    }
    SwchGamepadAimAssistStyle [$GAMECONSOLE]
    {
        ControlName				RuiButton
        InheritProperties		SwitchButton
        style					DialogListButton
        navUp					SwchGamepadAimAssistMelee
        navDown					SwchGamepadAimAssistHipLowPowerScope
        ConVar					"gamepad_custom_assist_style"
        list
        {
            "#SETTING_DEFAULT"		0
            "#SETTING_AIMASSISTSTYLE_PCASSIST"		1
        }

        pin_to_sibling			SwchGamepadAimAssistMelee
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        childGroupAlways        ChoiceButtonAlways
}
    /////////////////////////////
	// Hip Target Compensation
	/////////////////////////////
	CustomAimAssistHipHeader
	{
		ControlName				ImagePanel
		InheritProperties		SubheaderBackgroundWide
		ypos					32
        pin_to_sibling			SwchGamepadAimAssistStyle [$GAMECONSOLE]
		pin_to_sibling			SwchGamepadAimAssistMelee [$WINDOWS]
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
	}
	CustomAimAssistHipHeaderText
	{
		ControlName				Label
		InheritProperties		SubheaderText
		pin_to_sibling			CustomAimAssistHipHeader
		pin_corner_to_sibling	LEFT
		pin_to_sibling_corner	LEFT
		labelText				"#GAMEPADCUSTOM_ASSIST_HIP"
	}
    SwchGamepadAimAssistHipLowPowerScope
    {
        ControlName				RuiButton
        InheritProperties		SwitchButton
        style					DialogListButton
        navUp					SwchGamepadAimAssistStyle [$GAMECONSOLE]
		navUp					SwchGamepadAimAssistMelee [$WINDOWS]
        navDown					SwchGamepadAimAssistHipHighPowerScope
        ConVar					"gamepad_aim_assist_hip_low_power_scopes"
        list
        {
            "#SETTING_OFF"		0
            "#SETTING_ON"		1
        }
        pin_to_sibling			CustomAimAssistHipHeader
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        childGroupAlways        ChoiceButtonAlways
    }
    SwchGamepadAimAssistHipHighPowerScope
    {
        ControlName				RuiButton
        InheritProperties		SwitchButton
        style					DialogListButton
        navUp					SwchGamepadAimAssistHipLowPowerScope
        navDown					SwchGamepadAimAssistAdsLowPowerScope
        ConVar					"gamepad_aim_assist_hip_high_power_scopes"
        list
        {
            "#SETTING_OFF"		0
            "#SETTING_ON"		1
        }
        pin_to_sibling			SwchGamepadAimAssistHipLowPowerScope
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        childGroupAlways        ChoiceButtonAlways
    }
    ///////////////////////////////////////
	// ADS Target Compensation
	///////////////////////////////////////
	CustomAimAssistAdsHeader
	{
		ControlName				ImagePanel
		InheritProperties		SubheaderBackgroundWide
		ypos					32
        pin_to_sibling			SwchGamepadAimAssistHipHighPowerScope
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
	}
	CustomAimAssistAdsHeaderText
	{
		ControlName				Label
		InheritProperties		SubheaderText
		pin_to_sibling			CustomAimAssistAdsHeader
		pin_corner_to_sibling	LEFT
		pin_to_sibling_corner	LEFT
		labelText				"#GAMEPADCUSTOM_ASSIST_ADS"
	}
    SwchGamepadAimAssistAdsLowPowerScope
    {
        ControlName				RuiButton
        InheritProperties		SwitchButton
        style					DialogListButton
        navUp					SwchGamepadAimAssistHipHighPowerScope
        navDown					SwchGamepadAimAssistAdsHighPowerScope
        ConVar					"gamepad_aim_assist_ads_low_power_scopes"
        list
        {
            "#SETTING_OFF"		0
            "#SETTING_ON"		1
        }
        pin_to_sibling			CustomAimAssistAdsHeader
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        childGroupAlways        ChoiceButtonAlways
    }
    SwchGamepadAimAssistAdsHighPowerScope
    {
        ControlName				RuiButton
        InheritProperties		SwitchButton
        style					DialogListButton
        navUp					SwchGamepadAimAssistAdsLowPowerScope
        ConVar					"gamepad_aim_assist_ads_high_power_scopes"
        list
        {
            "#SETTING_OFF"		0
            "#SETTING_ON"		1
        }
        pin_to_sibling			SwchGamepadAimAssistAdsLowPowerScope
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        childGroupAlways        ChoiceButtonAlways
    }
    ///////////////////////////////////////
	// Bottom Panel
	///////////////////////////////////////
    PanelBottom
	{
		ControlName				Label
		labelText               ""

		zpos                    0
		wide					1
		tall					1
		visible					1
		enabled 				0

        pin_to_sibling			SwchGamepadAimAssistAdsHighPowerScope
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_LEFT
	}
}