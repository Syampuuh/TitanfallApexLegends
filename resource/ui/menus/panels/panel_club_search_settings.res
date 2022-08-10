"resource/ui/menus/panels/panel_club_search_settings.res"
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

    //ScreenBlur
    //{
    //    ControlName				RuiPanel
    //    wide					%100
    //    tall					%100
    //    visible					1
    //    rui                     "ui/screen_blur.rpak"
	//
    //    ruiArgs
    //    {
    //        tintColor           "0.0 0.0 0.0 0.25"
    //        alpha               "1.0"
    //    }
	//
	//	proportionalToParent    1
    //    cursorPriority			10
    //}

    ScreenBlur
    {
        ControlName				RuiPanel
        xpos                    0
        ypos					0
        wide					%100
        tall					%100
        rui                     "ui/clubs_panel_blur.rpak"

        visible					1

        proportionalToParent    1

        pin_to_sibling          PanelFrame
        pin_corner_to_sibling   TOP_LEFT
        pin_to_sibling_corner   TOP_LEFT
    }

    SettingsHeaderLabel
    {
        ControlName				RuiPanel
        xpos                    0
        ypos					0
        wide					%100
        tall					60
        rui                     "ui/club_search_panel_header.rpak"

        visible					1

		proportionalToParent    1

        pin_to_sibling          PanelFrame
        pin_corner_to_sibling   TOP_LEFT
        pin_to_sibling_corner   TOP_LEFT
    }

    ClubNameTextEntryFrame  //Club Name
    {
        ControlName				RuiPanel
        wide					352
        tall					48
        visible				    1
        rui                     "ui/club_setting_frame.rpak"

        ruiArgs
        {
            name        "#CLUB_CREATION_CLUBNAME_NAME"
            subtitle    "#CLUB_CREATION_CLUBNAME_DESC"
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
        ypos                    45
        wide					352
        tall					48
        visible					1
        enabled					1
        textHidden				0
        editable				1
        maxchars				16
        textAlignment			"east"
        ruiAsianFont            DefaultAsianFont
        ruiFont                 TitleRegularFont
        ruiFontHeight           36
        //ruiMinFontHeight        48
        keyboardTitle			""
        keyboardDescription		""
        allowRightClickMenu		0
        allowSpecialCharacters	0
        allowAdditionalSpecialCharacters 0
        allowUnnecessarySpaces  0
        unicode					1
        selectOnFocus           0
        cursorVelocityModifier  0.7
        cursorPriority          20

        tabPosition             1
        navRight                ClubTagTextEntry
        navDown                 ClubPrivacySwitch

        proportionalToParent    1
        pin_to_sibling			SettingsHeaderLabel
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
    }

    ClubNameTagEntryFrame //Club Tag
    {
        ControlName				RuiPanel
        wide					96
        tall					48
        visible				    1
        rui                     "ui/club_setting_frame.rpak"

        ruiArgs
        {
            name        "#CLUB_CREATION_CLUBTAG_NAME"
            subtitle    "#CLUB_CREATION_CLUBTAG_DESC"
        }

        pin_to_sibling			ClubTagTextEntry
        pin_corner_to_sibling	CENTER
        pin_to_sibling_corner	CENTER
    }

    ClubTagTextEntry
    {
        ControlName				TextEntry
        zpos					100 // This works around input weirdness when the control is constructed by code instead of VGUI blackbox.
        xpos                    64
        ypos                    0
        wide					96
        tall					48
        visible					1
        enabled					1
        textHidden				0
        editable				1
        maxchars				4
        textAlignment			"east"
        ruiFont                 TitleRegularFont
        ruiFontHeight           36
        //ruiMinFontHeight        48
        keyboardTitle			""
        keyboardDescription		""
        allowRightClickMenu		0
        allowSpecialCharacters	0
        allowAdditionalSpecialCharacters 0
        charBlackList           " "
        unicode					0
        selectOnFocus           0
        cursorVelocityModifier  0.7
        cursorPriority          20
		makeTextUpperCase       1

        navLeft                 ClubNameTextEntry
        navDown                 ClubPrivacySwitch

        proportionalToParent    1
        pin_to_sibling			ClubNametextEntry
        pin_corner_to_sibling	LEFT
        pin_to_sibling_corner	RIGHT
    }

    ClubSettingsLabel
    {
        ControlName				RuiPanel
        xpos                    0
        ypos					-192
        ypos_nx_handheld		-220		[$NX || $NX_UI_PC]
        wide					%100
        tall					40
        rui                     "ui/club_search_panel_header.rpak"

        ruiArgs
        {
            //labelType           1
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

		wide                    526
        wide_nx_handheld        726		[$NX || $NX_UI_PC]
        xpos                    4
        xpos_nx_handheld        -80		[$NX || $NX_UI_PC]

        InheritProperties       SwitchButtonCompact
        style                   DialogListButton
        navUp                   ClubNameTextEntry
        navDown                 ClubLvlReqSwitch
        //ConVar                  "TalkIsStream"
        list
        {
            "#CLUB_CREATION_PRIVACY_ANY_LONG"  0
            "#CLUB_CREATION_PRIVACY_OPEN_LONG"      1
            "#CLUB_CREATION_PRIVACY_OPEN_RESTRICTIONS_LONG" 2
            "#CLUB_CREATION_PRIVACY_BYREQUEST_LONG"  3
        }

        pin_to_sibling          ClubPrivacySwitchFrame
        pin_corner_to_sibling   CENTER
        pin_to_sibling_corner   CENTER

        childGroupAlways        MultiChoiceButtonWideAlways

        proportionalToParent    1
    }

    ClubLvlReqSwitchFrame
    {
        ControlName				RuiPanel
        wide					512
        tall					60
        ypos                    32
        ypos_nx_handheld        45		[$NX || $NX_UI_PC]
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
        wide                    526
        wide_nx_handheld        726		[$NX || $NX_UI_PC]
        xpos                    4
        xpos_nx_handheld        -80		[$NX || $NX_UI_PC]

        ControlName             RuiButton
        InheritProperties       SwitchButtonCompact
        style                   DialogListButton
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

        proportionalToParent    1
    }

    ClubRankReqSwitchFrame
    {
        ControlName				RuiPanel
        wide					512
        tall					60
        ypos                    32
        ypos_nx_handheld        45		[$NX]
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
        wide                    526
        wide_nx_handheld        726		[$NX]
        xpos                    4
        xpos_nx_handheld        -80		[$NX]

        ControlName             RuiButton
        InheritProperties       SwitchButtonCompact
        style                   DialogListButton
        navUp                   ClubLvlReqSwitch
        //navDown                 SldOpenMicSensitivity
        //ConVar                  "TalkIsStream"
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

        proportionalToParent    1
    }

    SearchTagsPanel
    {
        ControlName				CNestedPanel

        xpos                    16
        xpos_nx_handheld        -175		[$NX]
        ypos                    8
        ypos_nx_handheld        -15			[$NX]
        zpos                    0

        wide                    %100
        tall                    %45
        proportionalToParent    1

        visible					1
        controlSettingsFile		"resource/ui/menus/panels/panel_club_creation_search_tags.res"

        pin_to_sibling          ClubRankReqSwitch
        pin_corner_to_sibling   TOP_LEFT
        pin_to_sibling_corner   BOTTOM_LEFT
    }
}