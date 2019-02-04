"resource/ui/menus/panels/hud_options.res"
{
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    PanelFrame
    {
		ControlName				Label
		xpos					0
		ypos					0
		wide					%100
		tall					%100
		labelText				""
		visible				    0
        bgcolor_override        "0 255 0 32"
        paintbackground         1

        proportionalToParent    1
    }

    SwitchLootPromptStyle
    {
		ypos					0
        ControlName				RuiButton
        InheritProperties		SwitchButton
        style					DialogListButton
        navUp                   SwitchAnalytics [$GAMECONSOLE]
        navUp                   SwitchChatMessages [!$GAMECONSOLE]
        navDown					SwitchShotButtonHints
        ConVar					"hud_setting_showMedals"
        list
        {
            "#SETTING_COMPACT"	0
            "#SETTING_DEFAULT"	1
        }

        tabPosition             1
        ypos                    0
        childGroupAlways        ChoiceButtonAlways
    }

    SwitchShotButtonHints
    {
        ControlName				RuiButton
        InheritProperties		SwitchButton
        style					DialogListButton
        navUp					SwitchLootPromptStyle
        navDown					SwitchDamageIndicatorStyle
        ConVar					"hud_setting_showButtonHints"
        list
        {
            "#SETTING_OFF"	0
            "#SETTING_ON"	1
        }

        pin_to_sibling			SwitchLootPromptStyle
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        childGroupAlways        ChoiceButtonAlways
    }

    SwitchDamageIndicatorStyle
    {
        ControlName				RuiButton
        InheritProperties		SwitchButton
        style					DialogListButton
        navUp					SwitchShotButtonHints
        navDown					SwitchDamageTextStyle
        ConVar					"hud_setting_damageIndicatorStyle"
        list
        {
            "#SETTING_OFF"	                0
            "#SETTING_CROSSHAIR"	        1
            "#SETTING_CROSSHAIR_SHEILDS"	2
        }

        pin_to_sibling			SwitchShotButtonHints
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        childGroupAlways        MultiChoiceButtonAlways
    }

    SwitchDamageTextStyle
    {
        ControlName				RuiButton
        InheritProperties		SwitchButton
        style					DialogListButton
        navUp					SwitchDamageIndicatorStyle
        navDown					SwitchPingOpacity
        ConVar					"hud_setting_damageTextStyle"
        list
        {
            "#SETTING_OFF"	    0
            "#SETTING_STACKING"	1
            "#SETTING_FLOATING"	2
            "#SETTING_BOTH"	    3
        }

        pin_to_sibling			SwitchDamageIndicatorStyle
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        childGroupAlways        MultiChoiceButtonAlways
    }

    SwitchPingOpacity
    {
        ControlName				RuiButton
        InheritProperties		SwitchButton
        style					DialogListButton
        navUp					SwitchDamageTextStyle
        navDown					SwitchShowObituary
        ConVar					"hud_setting_pingAlpha"
        list
        {
            "#SETTING_DEFAULT"	1.0
            "#SETTING_FADED"	0.5
        }

        pin_to_sibling			SwitchDamageTextStyle
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        childGroupAlways        ChoiceButtonAlways
    }

    SwitchShowObituary
    {
        ControlName				RuiButton
        InheritProperties		SwitchButton
        style					DialogListButton
        navUp					SwitchPingOpacity
        navDown					SwitchPilotDamageIndicators
        ConVar					"hud_setting_showObituary"
        list
        {
            "#SETTING_OFF"	0
            "#SETTING_ON"	1
        }

        pin_to_sibling			SwitchPingOpacity
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        childGroupAlways        ChoiceButtonAlways
    }
    SwitchPilotDamageIndicators
    {
        ControlName				RuiButton
        InheritProperties		SwitchButton
        style					DialogListButton
        navUp					SwitchShowObituary
        navDown					SwitchStreamerMode
        ConVar					"damage_indicator_style_pilot"
        list
        {
            "#SETTING_INDICATOR_2D_ONLY"	0
            "#SETTING_INDICATOR_3D_ONLY"	2
            "#SETTING_INDICATOR_BOTH"	    1
        }

        pin_to_sibling			SwitchShowObituary
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        childGroupAlways        MultiChoiceButtonAlways
    }
    SwitchStreamerMode
    {
        ControlName				RuiButton
        InheritProperties		SwitchButton
        style					DialogListButton
        navUp					SwitchPilotDamageIndicators
        navDown					SwitchAnalytics
        ConVar					"hud_setting_streamerMode"
        visible                 1
        list
        {
            "#SETTING_OFF"	    0
            "#SETTING_KILLER"	1
            "#SETTING_ALL"	    2
        }

        pin_to_sibling			SwitchPilotDamageIndicators
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        childGroupAlways        MultiChoiceButtonAlways
    }
    SwitchAnalytics
    {
        ControlName				RuiButton
        InheritProperties		SwitchButton
        style					DialogListButton
        navUp					SwitchStreamerMode
        navDown					SwchAccessibility
        pin_to_sibling			SwitchStreamerMode
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT

        ConVar					"pin_opt_in"
        list
        {
            "#SETTING_DISABLED"	0
            "#SETTING_ENABLED"	1
        }
        clipRui             1
        childGroupAlways        ChoiceButtonAlways
    }

    AccessibilityHeader
    {
        ControlName				ImagePanel
        InheritProperties		SubheaderBackgroundWide
        xpos					0
        ypos					6
        pin_to_sibling			SwitchAnalytics
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT

        visible                 1 [$ENGLISH]
        visible                 0 [!$ENGLISH]
    }
    AccessibilityHeaderText
    {
        ControlName				Label
        InheritProperties		SubheaderText
        pin_to_sibling			AccessibilityHeader
        pin_corner_to_sibling	LEFT
        pin_to_sibling_corner	LEFT
        labelText				"#MENU_ACCESSIBILITY"

        visible                 1 [$ENGLISH]
        visible                 0 [!$ENGLISH]
    }

    SwchAccessibility
    {
        ControlName             RuiButton
        InheritProperties       SwitchButton
        style                   DialogListButton
        navUp                   SwitchAnalytics
        navDown                 SwchChatSpeechToText

        pin_to_sibling          AccessibilityHeader
        pin_corner_to_sibling   TOP_LEFT
        pin_to_sibling_corner   BOTTOM_LEFT

        visible                 1 [$ENGLISH]
        visible                 0 [!$ENGLISH]

        ConVar                  "hud_setting_accessibleChat"
        list
        {
            "#SETTING_OFF"              0
            "#SETTING_VISUAL"           1
            "#SETTING_AUDIO"            2
            "#SETTING_VISUAL_AUDIO"     3
        }

        childGroupAlways        MultiChoiceButtonAlways
    }

    SwchChatSpeechToText
    {
        ControlName             RuiButton
        InheritProperties       SwitchButton
        style                   DialogListButton
        navUp                   SwchAccessibility
        navDown                 SwitchChatMessages

        pin_to_sibling          SwchAccessibility
        pin_corner_to_sibling   TOP_LEFT
        pin_to_sibling_corner   BOTTOM_LEFT

        visible                 1 [$ENGLISH]
        visible                 0 [!$ENGLISH]

        ConVar                  "speechtotext_enabled"
        list
        {
            "#SETTING_OFF"  0
            "#SETTING_ON"   1
        }

        ruiArgs
        {
            buttonText      "#MENU_CHAT_SPEECH_TO_TEXT"
        }
        clipRui                 1
        childGroupAlways        ChoiceButtonAlways
    }

    SwitchChatMessages [!$GAMECONSOLE]
    {
        ControlName				RuiButton
        InheritProperties		SwitchButton
        style					DialogListButton
        navUp					SwchChatSpeechToText
        navDown					SwitchLootPromptStyle
        ConVar					"hudchat_play_text_to_speech"
        list
        {
            "#SETTING_OFF"	0
            "#SETTING_ON"	1
        }

        visible                 1 [$ENGLISH]
        visible                 0 [!$ENGLISH]

        pin_to_sibling			SwchChatSpeechToText
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        childGroupAlways        ChoiceButtonAlways
    }

}