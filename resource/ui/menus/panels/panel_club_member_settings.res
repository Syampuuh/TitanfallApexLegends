"resource/ui/menus/panels/panel_club_member_settings.res"
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

    ScreenBlur
    {
        ControlName				RuiPanel
        xpos                    0
        ypos					0
        wide					%100
        tall					%100
        rui                     "ui/clubs_panel_blur.rpak"

        ruiArgs
        {
            alpha               "0.75"
            showFrame           "1"
        }

        visible					1

        proportionalToParent    1

        //pin_to_sibling          PanelFrame
        //pin_corner_to_sibling   TOP_LEFT
        //pin_to_sibling_corner   TOP_LEFT
    }

    UserNameHeader
    {
        ControlName             RuiPanel
        xpos                    -32
        ypos                    -24
        zpos                    4
        wide                    550
        tall                    64
        rui                     "ui/club_user_mgmt_header.rpak"

        pin_to_sibling			PanelFrame
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_LEFT
    }

    InspectProfileButton
    {
        ControlName				RuiButton
        classname               "MenuButton"
        wide					340
        wide_nx_handheld		455		[$NX || $NX_UI_PC]
        tall					55
        tall_nx_handheld		75		[$NX || $NX_UI_PC]
        xpos                    0
        ypos                    16
        rui                     "ui/generic_button.rpak"
        labelText               ""
        visible					1
        cursorVelocityModifier  0.7

        //navDown                   ModeButton

        proportionalToParent    1

        pin_to_sibling						UserNameHeader
        pin_corner_to_sibling				TOP_LEFT
        pin_to_sibling_corner				BOTTOM_LEFT

        sound_focus             "UI_Menu_Focus_Large"
    }

    RankLabel
    {
        ControlName				RuiPanel
        xpos                    18
        ypos					32
        wide					340
        wide_nx_handheld		455		[$NX || $NX_UI_PC]
        tall					60
        rui                     "ui/club_search_panel_header.rpak"

        ruiArgs
        {
            textOverride        "#CLUB_MEMBER_MGMT_HEADER_RANK"
            //fontColorOverride   "<0.5, 0.5, 0.5, 1.0>"
            backgroundAlpha     "0.0"
        }

        visible					1

        proportionalToParent    1

        pin_to_sibling          InspectProfileButton
        pin_corner_to_sibling   TOP_LEFT
        pin_to_sibling_corner   BOTTOM_LEFT
    }

    UserRankSetting
    {
        ControlName             RuiButton
        InheritProperties       SwitchButtonCompact
        xpos                    144
        xpos_nx_handheld        28		[$NX || $NX_UI_PC]
        ypos                    -12
        style                   DialogListButton
        navUp                   KickUserButton
        navDown                 SaveButton
        //ConVar                  "TalkIsStream"
        list
        {
            "#LOBBY_CLUBS_RANK_GRUNT"      0
            "#LOBBY_CLUBS_RANK_CAPTAIN" 1
            "#LOBBY_CLUBS_RANK_ADMIN"  2
            "#LOBBY_CLUBS_RANK_CREATOR"  3
        }

        pin_to_sibling          RankLabel
        pin_corner_to_sibling   TOP_LEFT
        pin_to_sibling_corner   BOTTOM_LEFT

        childGroupAlways        MultiChoiceButtonAlways

        proportionalToParent    1
    }

    UserRankDescription
    {
        ControlName             RuiPanel
        xpos                    -96
        xpos_nx_handheld        -208		[$NX || $NX_UI_PC]
        ypos                    24
        ypos_nx_handheld        0			[$NX || $NX_UI_PC]
        zpos                    4
        wide                    344
        tall                    55
        tall_nx_handheld		75			[$NX || $NX_UI_PC]
        rui                     "ui/club_user_mgmt_rank_description.rpak"

        pin_to_sibling			UserRankSetting
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM
    }

    FeedbackLabel
    {
        ControlName				RuiPanel
        xpos                    18
        ypos					64
        ypos_nx_handheld		60		[$NX || $NX_UI_PC]
        wide					384
        tall					60
        rui                     "ui/club_search_panel_header.rpak"

        ruiArgs
        {
            textOverride        "#CLUB_MEMBER_MGMT_HEADER_FEEDBACK"
            //fontColorOverride   "<0.5, 0.5, 0.5, 1.0>"
            //fontSizeOverride    "21"
            backgroundAlpha     "0.0"
        }

        visible					1

        proportionalToParent    1

        pin_to_sibling          UserRankDescription
        pin_corner_to_sibling   TOP_LEFT
        pin_to_sibling_corner   BOTTOM_LEFT
    }

    ReportsToggleButton
    {
        ControlName				RuiButton
        classname               "MenuButton"
        wide					340
        wide_nx_handheld		455		[$NX || $NX_UI_PC]
        tall					55
        tall_nx_handheld		75		[$NX || $NX_UI_PC]
        xpos                    -18
        ypos                    0
        rui                     "ui/generic_button.rpak"
        labelText               ""
        visible					1
        cursorVelocityModifier  0.7

        //navDown                   ModeButton

        proportionalToParent    1

        pin_to_sibling						FeedbackLabel
        pin_corner_to_sibling				TOP_LEFT
        pin_to_sibling_corner				BOTTOM_LEFT

        sound_focus             "UI_Menu_Focus_Large"
    }

    KickUserButton
    {
        ControlName				RuiButton
        classname               "MenuButton"
        wide					340
        wide_nx_handheld		455		[$NX || $NX_UI_PC]
        tall					55
        tall_nx_handheld		75		[$NX || $NX_UI_PC] 
        xpos                    0
        ypos                    16
        rui                     "ui/generic_button.rpak"
        labelText               ""
        visible					1
        cursorVelocityModifier  0.7

        //navDown                   ModeButton

        proportionalToParent    1

        pin_to_sibling						ReportsToggleButton
        pin_corner_to_sibling				TOP_RIGHT
        pin_to_sibling_corner				BOTTOM_RIGHT

        sound_focus             "UI_Menu_Focus_Large"
    }

    SaveButton
    {
        ControlName				RuiButton
        classname               "MenuButton"
        wide					272
        wide_nx_handheld		375		[$NX]
        tall					55
        tall_nx_handheld		75		[$NX]
        xpos                    -32
        ypos                    -24
        ypos_nx_handheld        -35		[$NX]
        rui                     "ui/generic_button.rpak"
        labelText               ""
        visible					1
        cursorVelocityModifier  0.7

		navUp                       UserRankSetting
        navDown                   ResetChangesButton

        proportionalToParent    1

        pin_to_sibling						PanelFrame
        pin_corner_to_sibling				BOTTOM_LEFT
        pin_to_sibling_corner				BOTTOM_LEFT

        sound_focus             "UI_Menu_Focus_Large"
        //sound_accept            "UI_Menu_OpenLootBox"
    }

    ResetChangesButton
    {
        ControlName				RuiButton
        classname               "MenuButton"
        wide					55
        wide_nx_handheld		75		[$NX]
        tall					55
        tall_nx_handheld		75		[$NX]
        xpos                    16
        ypos                    0
        rui                     "ui/generic_button.rpak"
        labelText               ""
        visible					1
        cursorVelocityModifier  0.7

		navUp                       SaveButton
        //navDown                   ModeButton

        proportionalToParent    1

        pin_to_sibling						SaveButton
        pin_corner_to_sibling				TOP_LEFT
        pin_to_sibling_corner				TOP_RIGHT

        sound_focus             "UI_Menu_Focus_Large"
    }

    MemberGladCard
    {
        ControlName			RuiPanel

        xpos                   128
        ypos                   0
        zpos                    2

        wide					850//800
        wide_nx_handheld		895			[$NX]
        tall					850//800
        tall_nx_handheld		940			[$NX]
        rui                    "ui/combined_card.rpak"
        visible					1

        pin_to_sibling          PanelFrame
        pin_corner_to_sibling   RIGHT
        pin_to_sibling_corner   RIGHT
    }

    ReportGrid
    {
        ControlName             GridButtonListPanel

        xpos                    -64
        ypos                    0

        pin_to_sibling          PanelFrame
        pin_corner_to_sibling   RIGHT
        pin_to_sibling_corner   RIGHT

        visible                  0

        columns                  1
        rows                     8
        buttonSpacing            10
        scrollbarSpacing         2
        scrollbarOnLeft          0
        //tabPosition            1
        selectOnDpadNav          1

        ButtonSettings
        {
            rui                      "ui/club_event.rpak"
            clipRui                  1
            wide                     480
            tall                     77
            cursorVelocityModifier   0.7
            //rightClickEvents         1
            //doubleClickEvents      1
            //middleClickEvents      1
            sound_focus              ""
            sound_accept             ""
            sound_deny               ""
        }
    }
}