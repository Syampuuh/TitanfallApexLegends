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
        navDown					SwitchRotateMinimap
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
    SwitchRotateMinimap
    {
        ControlName				RuiButton
        InheritProperties		SwitchButton
        style					DialogListButton
        navUp					SwitchShowObituary
        navDown					SwitchWeaponAutoCycle
        ConVar					"hud_setting_minimapRotate"
        list
        {
            "#SETTING_OFF"	0
            "#SETTING_ON"	1
        }

        pin_to_sibling			SwitchShowObituary
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        childGroupAlways        ChoiceButtonAlways
    }
    SwitchWeaponAutoCycle
    {
        ControlName				RuiButton
        InheritProperties		SwitchButton
        style					DialogListButton
        navUp					SwitchRotateMinimap
        navDown					SwitchAutoSprint
        ConVar					"weapon_setting_autocycle_on_empty"
        list
        {
            "#SETTING_OFF"	0
            "#SETTING_ON"	1
        }

        pin_to_sibling			SwitchRotateMinimap
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        childGroupAlways        ChoiceButtonAlways
    }
    SwitchAutoSprint
    {
        ControlName				RuiButton
        InheritProperties		SwitchButton
        style					DialogListButton
        navUp					SwitchWeaponAutoCycle
        navDown					SwitchStickySprintForward
        ConVar					"player_setting_autosprint"
        list
        {
            "#SETTING_OFF"	0
            "#SETTING_ON"	1
        }

        pin_to_sibling			SwitchWeaponAutoCycle
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        childGroupAlways        ChoiceButtonAlways
    }
    SwitchStickySprintForward
    {
        ControlName             RuiButton
        InheritProperties       SwitchButton
        style                   DialogListButton
        navUp                   SwitchAutoSprint
        navDown                 SwitchJetpackControl
        ConVar                  "player_setting_stickysprintforward"
        list
        {
            "#SETTING_OFF"  0
            "#SETTING_ON"   1
        }

        pin_to_sibling          SwitchAutoSprint
        pin_corner_to_sibling   TOP_LEFT
        pin_to_sibling_corner   BOTTOM_LEFT
        childGroupAlways        ChoiceButtonAlways
    }
    SwitchJetpackControl
    {
        ControlName             RuiButton
        InheritProperties       SwitchButton
        style                   DialogListButton
        navUp                   SwitchStickySprintForward
        navDown                 SwitchPilotDamageIndicators
        ConVar                  "toggle_on_jump_to_deactivate"
        list
        {
            "#SETTING_JETPACK_HOLD"   0
            "#SETTING_JETPACK_TOGGLE"  1
        }

        pin_to_sibling          SwitchStickySprintForward
        pin_corner_to_sibling   TOP_LEFT
        pin_to_sibling_corner   BOTTOM_LEFT
        childGroupAlways        ChoiceButtonAlways
    }
    SwitchPilotDamageIndicators
    {
        ControlName				RuiButton
        InheritProperties		SwitchButton
        style					DialogListButton
        navUp                   SwitchJetpackControl
        navDown					SwitchDamageClosesDeathBoxMenu
        ConVar					"damage_indicator_style_pilot"
        list
        {
            "#SETTING_INDICATOR_2D_ONLY"	0
            "#SETTING_INDICATOR_3D_ONLY"	2
            "#SETTING_INDICATOR_BOTH"	    1
        }
        pin_to_sibling			SwitchJetpackControl
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        childGroupAlways        MultiChoiceButtonAlways
    }
    SwitchDamageClosesDeathBoxMenu
    {
        ControlName				RuiButton
        InheritProperties		SwitchButton
        style					DialogListButton
        navUp					SwitchPilotDamageIndicators
        navDown					SwitchHopupPopup
        ConVar					"player_setting_damage_closes_deathbox_menu"
        list
        {
            "#SETTING_OFF"	0
            "#SETTING_ON"	1
        }

        pin_to_sibling			SwitchPilotDamageIndicators
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        childGroupAlways        ChoiceButtonAlways
    }
    SwitchHopupPopup
    {
        ControlName				RuiButton
        InheritProperties		SwitchButton
        style					DialogListButton
        navUp					SwitchDamageClosesDeathBoxMenu
        navDown					SwitchStreamerMode
        ConVar					"hud_setting_showHopUpPopUp"
        list
        {
            "#SETTING_OFF"	0
            "#SETTING_ON"	1
        }

        pin_to_sibling			SwitchDamageClosesDeathBoxMenu
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        childGroupAlways        ChoiceButtonAlways
    }
    SwitchStreamerMode
    {
        ControlName				RuiButton
        InheritProperties		SwitchButton
        style					DialogListButton
        navUp					SwitchHopupPopup
        navDown					SwitchAnonymousMode
        ConVar					"hud_setting_streamerMode"
        visible                 1
        list
        {
            "#SETTING_OFF"	    0
            "#SETTING_KILLER"	1
            "#SETTING_ALL"	    2
        }

        pin_to_sibling			SwitchHopupPopup
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        childGroupAlways        MultiChoiceButtonAlways
    }
    SwitchAnonymousMode
    {
        ControlName				RuiButton
        InheritProperties		SwitchButton
        style					DialogListButton
        navUp					SwitchStreamerMode
        navDown					SwitchAnalytics
        ConVar					"hud_setting_anonymousMode"
        visible                 1
        list
        {
            "#SETTING_DISABLED"	    0
            "#SETTING_ENABLED"	    1
        }

        pin_to_sibling			SwitchStreamerMode
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        childGroupAlways        ChoiceButtonAlways
    }
    SwitchAnalytics
    {
        ControlName				RuiButton
        InheritProperties		SwitchButton
        style					DialogListButton
        navUp					SwitchAnonymousMode
        navDown					SwitchCrossplay [!$PC || $NX_UI_PC]
        navDown					SwitchNetGraph  [$PC && !$NX_UI_PC]
        pin_to_sibling			SwitchAnonymousMode
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
    SwitchCrossplay
    {
        ControlName				RuiButton
        InheritProperties		SwitchButton
        style					DialogListButton
        navUp					SwitchAnalytics
        navDown					SwitchNetGraph [!$NX && !$NX_UI_PC]
		navDown					SwitchClubInvites  [$NX || $NX_UI_PC]
        pin_to_sibling			SwitchAnalytics
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT

        ConVar					"CrossPlay_user_optin"
        list
        {
            "#SETTING_DISABLED"	0
            "#SETTING_ENABLED"	1
        }
        clipRui             1
        childGroupAlways        ChoiceButtonAlways
    }
	SwitchNetGraph
    {
        ControlName				RuiButton
        InheritProperties		SwitchButton
        style					DialogListButton
        navUp					SwitchCrossplay [!$PC || $NX_UI_PC]
        navUp					SwitchAnalytics [$PC && !$NX_UI_PC]
        navDown					SwitchClubInvites
        ConVar					"net_netGraph2"
        visible                 1 [!$NX && !$NX_UI_PC]
		visible					0 [$NX || $NX_UI_PC]
        list
        {
            "#SETTING_OFF"	    0
            "#SETTING_ON"	    1
        }

        pin_to_sibling			SwitchCrossplay
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        childGroupAlways        ChoiceButtonAlways
    }
    SwitchClubInvites
    {
        ControlName				RuiButton
        InheritProperties		SwitchButton
        style					DialogListButton
        navUp					SwitchNetGraph  [!$NX && !$NX_UI_PC]
        navUp					SwitchCrossplay  [$NX || $NX_UI_PC]
        navDown					SwitchCommsFilter
        ConVar					"clubs_showInvites"
        visible                 1
        list
        {
            "#SETTING_DISABLED"	        0
            "#SETTING_ENABLED"	        1
        }

        pin_to_sibling			SwitchNetGraph  [!$NX && !$NX_UI_PC]
        pin_to_sibling			SwitchCrossplay  [$NX || $NX_UI_PC]
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT

        childGroupAlways        ChoiceButtonAlways
    }
    SwitchCommsFilter
    {
        ControlName				RuiButton
        InheritProperties		SwitchButton
        style					DialogListButton
        navUp					SwitchClubInvites
        navDown					SwitchFirstPersonReticleOptions
        ConVar					"cl_comms_filter"
        visible                 1
        list
        {
            "#SETTING_CHATFILTER_EVERYONE"      -1
            "#SETTING_CHATFILTER_FRIENDS"       1
            //"#SETTING_CHATFILTER_PARTYMEMBERS"  2
            "#SETTING_CHATFILTER_NOBODY"        0
        }

        pin_to_sibling		SwitchClubInvites
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT

        childGroupAlways        MultiChoiceButtonAlways
    }
	SwitchFirstPersonReticleOptions
    {
        ControlName             RuiButton
        InheritProperties       SwitchButton
        style                   DialogListButton
        navUp                   SwitchCommsFilter
        navDown                 SwchColorBlindMode
        visible                 1
        //ConVar                  "closecaption"
        list
        {
            "#SETTING_DEFAULT"      0
            "#SETTING_CUSTOMIZE"    1
        }

        pin_to_sibling          SwitchCommsFilter
        pin_corner_to_sibling   TOP_LEFT
        pin_to_sibling_corner   BOTTOM_LEFT

        childGroupAlways        ChoiceButtonAlways
    }
                         
	LaserSightOptions
    {
        ControlName             RuiButton
        InheritProperties       SwitchButton
        style                   DialogListButton
        navUp                   SwitchFirstPersonReticleOptions
        navDown                 SwchColorBlindMode
        visible                 1
        ConVar					"laserSightColorCustomized"
        
        list
        {
            "#SETTING_DEFAULT"      0
            "#SETTING_CUSTOMIZE"    1
        }

        pin_to_sibling          SwitchFirstPersonReticleOptions
        pin_corner_to_sibling   TOP_LEFT
        pin_to_sibling_corner   BOTTOM_LEFT

        childGroupAlways        ChoiceButtonAlways
    }
      
    AccessibilityHeader
    {
        ControlName				ImagePanel
        InheritProperties		SubheaderBackgroundWide
        xpos					0
        ypos					6
        pin_to_sibling			SwitchFirstPersonReticleOptions [!$NX && !$NX_UI_PC]
        pin_to_sibling			SwitchFirstPersonReticleOptions [$NX || $NX_UI_PC]
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

    SwchColorBlindMode
    {
        ControlName				RuiButton
        InheritProperties		SwitchButton
        classname				"AdvancedVideoButtonClass"
        style					DialogListButton
        pin_to_sibling			AccessibilityHeader
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        navUp					SwitchFirstPersonReticleOptions
        navDown					SwchSubtitles
        // list is populated by code
        childGroupAlways        MultiChoiceButtonAlways

        ConVar                  "colorblind_mode"
        list
        {
            "#SETTING_OFF"                  0
            "#SETTING_PROTANOPIA"           1
            "#SETTING_DEUTERANOPIA"         2
            "#SETTING_TRITANOPIA"           3
        }
    }

    SwchSubtitles
    {
        ControlName             RuiButton
        InheritProperties       SwitchButton
        style                   DialogListButton
        navUp                   SwchColorBlindMode
        navDown                 SwchSubtitlesSize

        ConVar                  "closecaption"
        list
        {
            // If we enable hearing impaired captions, rather than use "cc_subtitles", "closecaption" should support a 3rd value
            "#SETTING_OFF"  0
            "#SETTING_ON"   1
        }

        pin_to_sibling          SwchColorBlindMode
        pin_corner_to_sibling   TOP_LEFT
        pin_to_sibling_corner   BOTTOM_LEFT

        childGroupAlways        ChoiceButtonAlways
    }

    SwchSubtitlesSize
    {
        ControlName				RuiButton
        InheritProperties		SwitchButton
        classname				"AdvancedVideoButtonClass"
        style					DialogListButton
        pin_to_sibling			SwchSubtitles
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        navUp					SwchSubtitles
        navDown					SwchAccessibility
        childGroupAlways        MultiChoiceButtonAlways

        ConVar                  "cc_text_size"
        list
        {
            "#SETTING_SUBTITLES_NORMAL"      0
            "#SETTING_SUBTITLES_LARGE"       1
            "#SETTING_SUBTITLES_HUGE"        2
        }
    }

    SwchAccessibility
    {
        ControlName             RuiButton
        InheritProperties       SwitchButton
        style                   DialogListButton
        navUp                   SwchSubtitlesSize
        navDown                 SwchChatSpeechToText [$PC && !$NX_UI_PC]
        navDown                 SwchMuteVoiceChat [!$PC || $NX_UI_PC]

        pin_to_sibling          SwchSubtitlesSize
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

    SwchMuteVoiceChat [$GAMECONSOLE || $NX_UI_PC]
    {
        ControlName             RuiButton
        InheritProperties       SwitchButton
        style                   DialogListButton
        navUp                   SwchAccessibility
        navDown                 SwchChatSpeechToText [$ENGLISH]

        pin_to_sibling          SwchAccessibility
        pin_corner_to_sibling   TOP_LEFT
        pin_to_sibling_corner   BOTTOM_LEFT

        ConVar                  "voice_enabled"
        list
        {
            "#SETTING_OFF"  1
            "#SETTING_ON"   0
        }

        childGroupAlways        ChoiceButtonAlways
    }

    SwchChatSpeechToText
    {
        ControlName             RuiButton
        InheritProperties       SwitchButton
        style                   DialogListButton
        navUp                   SwchMuteVoiceChat  [$GAMECONSOLE]
        navUp                   SwchAccessibility  [!$GAMECONSOLE]
        navDown                 SwchChatTextToSpeech

        pin_to_sibling          SwchAccessibility [$PC && !$NX_UI_PC]
        pin_to_sibling          SwchMuteVoiceChat [!$PC || $NX_UI_PC]
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

    SwchChatTextToSpeech
    {
        ControlName				RuiButton
        InheritProperties		SwitchButton
        style					DialogListButton
        navUp					SwchChatSpeechToText
        ConVar					"hudchat_play_text_to_speech"
        list
        {
            "#SETTING_SYSTEM_DEFAULT" 0  [$PS4 || $PS5]
            "#SETTING_CONSOLE_DEFAULT" 0 [$DURANGO || $XB5]
            "#SETTING_OFF"  0            [!$DURANGO && !$XB5 && !$PS4 && !$PS5]
            "#SETTING_ON"   1
            "#SETTING_OFF"  2            [$DURANGO || $XB5 || $PS4 || $PS5]
        }

        visible                 1 [$ENGLISH]
        visible                 0 [!$ENGLISH]

        pin_to_sibling			SwchChatSpeechToText
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        childGroupAlways        MultiChoiceButtonAlways [$DURANGO || $XB5 || $PS4 || $PS5]
        childGroupAlways        ChoiceButtonAlways [!$DURANGO && !$XB5 && !$PS4 && !$PS5]
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

        pin_to_sibling			SwchChatTextToSpeech
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_LEFT
	}
}