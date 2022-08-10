"resource/ui/menus/panels/panel_club_creation_settings.res"
{
    Screen
    {
        ControlName				Label
        wide			        %100
        tall			        %100
        labelText				""
        visible					0
    }

    PanelFrame
    {
		ControlName				Label
		xpos					0
		ypos					0
		wide					%100
		tall					%100
		labelText				""
		visible				    1
        bgcolor_override        "0 0 0 64"
        paintbackground         0

        proportionalToParent    1
    }

    ClubNameTextEntryBackground
    {
        ControlName				Label
        xpos					0
        ypos					0
        wide					380
        wide_nx_handheld		430		[$NX || $NX_UI_PC]
        tall					48
        tall_nx_handheld		60		[$NX || $NX_UI_PC]
        labelText				""
        visible				    1
        bgcolor_override        "64 64 64 255"
        paintbackground         1

        proportionalToParent    1

        pin_to_sibling			ClubNameTextEntry
        pin_corner_to_sibling	CENTER
        pin_to_sibling_corner	CENTER
    }

    ClubNameTextEntryFrame
    {
        ControlName				RuiPanel
        wide					380
        wide_nx_handheld		430		[$NX || $NX_UI_PC]
        tall					48
        tall_nx_handheld		60		[$NX || $NX_UI_PC]
        visible				    1
        rui                     "ui/club_setting_frame.rpak"

        ruiArgs
        {
            name        "#CLUB_CREATION_CLUBNAME_NAME"
            subtitle    "#CLUB_CREATION_CLUBNAME_DESC"
            isBright    1
            allCaps     1
        }

        pin_to_sibling			ClubNameTextEntry
        pin_corner_to_sibling	CENTER
        pin_to_sibling_corner	CENTER
    }

    ClubNameTextEntry
    {
        ControlName				TextEntry
        zpos					100 // This works around input weirdness when the control is constructed by code instead of VGUI blackbox.
        xpos                    -32
        ypos                    -32
        wide					380
        wide_nx_handheld		430		[$NX || $NX_UI_PC]
        tall					48
        tall_nx_handheld		60		[$NX || $NX_UI_PC]
        visible					1
        enabled					1
        textHidden				0
        editable				1
        maxchars				16
        textAlignment			"east"
        ruiAsianFont            DefaultAsianFont
        ruiFont                 TitleRegularFont
        ruiFontHeight           38
        //ruiMinFontHeight        48
        keyboardTitle			""
        keyboardDescription		""
        allowRightClickMenu		0
        allowSpecialCharacters	0
        allowAdditionalSpecialCharacters	0
        allowUnnecessarySpaces  0
        unicode					1
        selectOnFocus           1
        cursorVelocityModifier  0.7
        cursorPriority          20

		tabPosition             0
        navRight                ClubTagTextEntry
        navDown                 ClubPrivacySwitch

        proportionalToParent    1
        pin_to_sibling			PanelFrame
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_LEFT
    }

    ClubNameTagEntryBackground
    {
        ControlName				Label
        xpos					0
        ypos					0
        wide					96
        wide_nx_handheld		165		[$NX || $NX_UI_PC]
        tall					48
        tall_nx_handheld		60		[$NX || $NX_UI_PC]
        labelText				""
        visible				    1
        bgcolor_override        "64 64 64 255"
        paintbackground         1

        proportionalToParent    1

        pin_to_sibling			ClubTagTextEntry
        pin_corner_to_sibling	CENTER
        pin_to_sibling_corner	CENTER
    }

    ClubNameTagEntryFrame
    {
        ControlName				RuiPanel
        wide					96
        wide_nx_handheld		165		[$NX || $NX_UI_PC]
        tall					48
        tall_nx_handheld		60		[$NX || $NX_UI_PC]
        visible				    1
        rui                     "ui/club_setting_frame.rpak"

        ruiArgs
        {
            name        "#CLUB_CREATION_CLUBTAG_NAME"
            subtitle    "#CLUB_CREATION_CLUBTAG_DESC"
            isBright    1
            allCaps     1
        }

        pin_to_sibling			ClubTagTextEntry
        pin_corner_to_sibling	CENTER
        pin_to_sibling_corner	CENTER
    }

    ClubTagTextEntry
    {
        ControlName				TextEntry
        zpos					100 // This works around input weirdness when the control is constructed by code instead of VGUI blackbox.
        xpos                    48
        xpos_nx_handheld        38		[$NX || $NX_UI_PC]
        ypos                    0
        wide					96
        wide_nx_handheld		165		[$NX || $NX_UI_PC]
        tall					48
        tall_nx_handheld		60		[$NX || $NX_UI_PC]
        visible					1
        enabled					1
        textHidden				0
        editable				1
        maxchars				4
        textAlignment			"east"
        ruiFont                 TitleRegularFont
        ruiFontHeight           38
        //ruiMinFontHeight        48
        keyboardTitle			""
        keyboardDescription		""
        allowRightClickMenu		0
        allowSpecialCharacters	0
		allowAdditionalSpecialCharacters	0
        charBlackList           " "
        unicode					0
        selectOnFocus           1
        cursorVelocityModifier  0.7
        cursorPriority          20
		makeTextUpperCase       1

        navLeft                 ClubNameTextEntry
        navDown                 ClubPrivacySwitch

        proportionalToParent    1
        pin_to_sibling			ClubNameTextEntry
        pin_corner_to_sibling	LEFT
        pin_to_sibling_corner	RIGHT
    }

    ClubSettingsLabel
    {
        ControlName				RuiPanel
        xpos                    0
        ypos					-192
        wide					%100
        tall					40
        rui                     "ui/club_search_panel_header.rpak"

        ruiArgs
        {
            //labelType           1
            textOverride        "#LOBBY_CLUBS_ACCESS_SETTINGS"
            //fontSizeOverride    "35"
            backgroundAlpha     "0.0"
        }

        visible					1

        proportionalToParent    1

        pin_to_sibling          PanelFrame
        pin_corner_to_sibling   TOP_LEFT
        pin_to_sibling_corner   TOP_LEFT
    }

    SettingFrame
    {
        ControlName				Label
        xpos					0
        xpos_nx_handheld		175		[$NX || $NX_UI_PC]
        ypos					45
        wide					%100
        tall					%50
        labelText				""
        visible				    0
        bgcolor_override        "255 0 0 64"
        paintbackground         0

        proportionalToParent    1
        pin_to_sibling          ClubSettingsLabel
        pin_corner_to_sibling   TOP_LEFT
        pin_to_sibling_corner   BOTTOM_LEFT
    }

    ClubPrivacySwitchFrame
    {
        ControlName				RuiPanel
        wide					512
        tall					60
        visible				    1
        rui                     "ui/club_setting_frame.rpak"

        ruiArgs
        {
            name            "#CLUB_CREATION_PRIVACY_NAME"
            subtitle        ""
            isFrameVisible  0
        }

        pin_to_sibling			SettingFrame
        pin_corner_to_sibling	TOP
        pin_to_sibling_corner	TOP
    }

    ClubPrivacySwitch
    {
        ControlName             RuiButton
        InheritProperties       SwitchButtonCompact
        style                   DialogListButton

        wide                    526
        wide_nx_handheld        726		[$NX || $NX_UI_PC]
        xpos                    4
        xpos_nx_handheld        -82		[$NX || $NX_UI_PC]

        navUp                   ClubNameTextEntry
        navDown                 ClubLvlReqSwitch
        //ConVar                  "TalkIsStream"
        list
        {
            "#CLUB_CREATION_PRIVACY_OPEN_LONG"      0
            "#CLUB_CREATION_PRIVACY_OPEN_RESTRICTIONS_LONG" 1
            "#CLUB_CREATION_PRIVACY_BYREQUEST_LONG"  2
            "#CLUB_CREATION_PRIVACY_INVITEONLY_LONG"  3
        }

        pin_to_sibling          ClubPrivacySwitchFrame
        pin_corner_to_sibling   CENTER
        pin_to_sibling_corner   CENTER

        childGroupAlways        MultiChoiceButtonWideAlways

        sound_accept            "UI_Menu_Clubs_SettingAdjust"

        proportionalToParent    1
    }

    ClubLvlReqSwitchFrame
    {
        ControlName				RuiPanel
        wide					512
        tall					60
        ypos                    45
        visible				    1
        rui                     "ui/club_setting_frame.rpak"

        ruiArgs
        {
            name        "#CLUB_CREATION_LVLREQ_NAME"
            subtitle    ""
            isFrameVisible  0
        }

        pin_to_sibling			ClubPrivacySwitchFrame
        pin_corner_to_sibling	TOP
        pin_to_sibling_corner	BOTTOM
    }

    ClubLvlReqSwitch
    {
        ControlName             RuiButton
        InheritProperties       SwitchButtonCompact
        style                   DialogListButton

        wide                    526
        wide_nx_handheld        726		[$NX || $NX_UI_PC]
        xpos                    4
        xpos_nx_handheld        -82		[$NX || $NX_UI_PC]
		
        navUp                   ClubPrivacySwitch
        navDown                 ClubRankReqSwitch
        //ConVar                  "TalkIsStream"

        list
        {
            "#CLUB_CREATION_LVLREQ_10_LONG"      0
            "#CLUB_CREATION_LVLREQ_50_LONG"      1
            "#CLUB_CREATION_LVLREQ_100_LONG"     2
            "#CLUB_CREATION_LVLREQ_200_LONG"     3
            "#CLUB_CREATION_LVLREQ_300_LONG"     4
            "#CLUB_CREATION_LVLREQ_400_LONG"     5
            "#CLUB_CREATION_LVLREQ_500_LONG"     6
        }

        pin_to_sibling          ClubLvlReqSwitchFrame
        pin_corner_to_sibling   CENTER
        pin_to_sibling_corner   CENTER

        childGroupAlways        MultiChoiceButtonWideAlways
		
        sound_accept            "UI_Menu_Clubs_SettingAdjust"

        proportionalToParent    1
    }

    ClubRankReqSwitchFrame
    {
        ControlName				RuiPanel
        wide					512
        tall					60
        ypos                    45
        visible				    1
        rui                     "ui/club_setting_frame.rpak"

        ruiArgs
        {
            name        "#CLUB_CREATION_RANKREQ_NAME"
            subtitle    ""
            isFrameVisible  0
        }

        pin_to_sibling			ClubLvlReqSwitchFrame
        pin_corner_to_sibling	TOP
        pin_to_sibling_corner	BOTTOM
    }

    ClubRankReqSwitch
    {
        ControlName             RuiButton
        InheritProperties       SwitchButtonCompact
        style                   DialogListButton

        wide                    526
        wide_nx_handheld        726		[$NX || $NX_UI_PC]
        xpos                    4
        xpos_nx_handheld        -82		[$NX || $NX_UI_PC]
		
        navUp                   ClubLvlReqSwitch
        //navDown                 SldOpenMicSensitivity
		cursorPriority          -1

        list
        {			
            "#CLUB_CREATION_RANKREQ_BRONZE"     0
            "#CLUB_CREATION_RANKREQ_SILVER"     1
            "#CLUB_CREATION_RANKREQ_GOLD"       2
            "#CLUB_CREATION_RANKREQ_PLATINUM"   3
            "#CLUB_CREATION_RANKREQ_DIAMOND"    4
            "#CLUB_CREATION_RANKREQ_MASTER_LONG"     5
        }

        pin_to_sibling          ClubRankReqSwitchFrame
        pin_corner_to_sibling   CENTER
        pin_to_sibling_corner   CENTER

        childGroupAlways        MultiChoiceButtonWideAlways
		
        sound_accept            "UI_Menu_Clubs_SettingAdjust"

        proportionalToParent    1
    }
}