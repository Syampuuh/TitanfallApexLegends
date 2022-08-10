"resource/ui/menus/panels/panel_club_discovery.res"
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
		visible				    0
        bgcolor_override        "0 0 0 64"
        paintbackground         1

        proportionalToParent    1
    }

    BlurbBlur
    {
        ControlName				RuiPanel
        xpos                    -46
        ypos					-58
        wide					1074
        tall					235
        tall_nx_handheld		300			[$NX || $NX_UI_PC]

        rui                     "ui/clubs_panel_blur.rpak"
        ruiArgs
        {
            showFrame           "1"
        }

        visible					1

        proportionalToParent    1

        pin_to_sibling          PanelFrame
        pin_corner_to_sibling   TOP_RIGHT
        pin_to_sibling_corner   TOP_RIGHT
    }

    BlurbLabel
    {
        ControlName				RuiPanel
        xpos                    -10
        ypos                    -5
        wide					1074
        tall					192
        tall_nx_handheld		300			[$NX || $NX_UI_PC]
        visible				    1
        rui                     "ui/clubs_discovery_blurb.rpak"

        //ruiArgs
        //{
        //    name        "#CLUB_CREATION_CLUBTAG_NAME"
        //    subtitle    "#CLUB_CREATION_CLUBTAG_DESC"
        //}

        pin_to_sibling          BlurbBlur
        pin_corner_to_sibling   TOP_LEFT
        pin_to_sibling_corner   TOP_LEFT
    }

    TestFieldJoinAndCreateButtons
    {
        ControlName				Label
        wide					1074
        tall					160
        tall_nx_handheld        100 [$NX || $NX_UI_PC]
        xpos                    0
        ypos                    10
        zpos                    0
        labelText               ""
        visible					1
        bgcolor_override        "0 0 0 128"
        paintbackground         0

        pin_to_sibling          BlurbBlur
        pin_corner_to_sibling   TOP
        pin_to_sibling_corner   BOTTOM
    }

    ClubSearchButton
    {
        ControlName				RuiButton
        classname               "MenuButton"
        wide					518
        tall					160
        tall_nx_handheld        100 [$NX || $NX_UI_PC]
        xpos                    0
        rui                     "ui/generic_desc_button.rpak"
        labelText               ""
        visible					1
        cursorVelocityModifier  0.7

        navRight                ClubCreateButton
        navDown                 CasualFilterButton

        proportionalToParent    1

        pin_to_sibling			TestFieldJoinAndCreateButtons
        pin_corner_to_sibling	LEFT
        pin_to_sibling_corner	LEFT

        sound_focus             "UI_Menu_Focus_Large"
    }

    ClubCreateButton
    {
        ControlName				RuiButton
        classname               "MenuButton"
        wide					518
        tall					160
        tall_nx_handheld        100 [$NX || $NX_UI_PC]
        xpos                    0
        rui                     "ui/generic_desc_button.rpak"
        labelText               ""
        visible					1
        cursorVelocityModifier  0.7

        navRight                ClubSearchButton
        navDown                 ClubInvitesButton

        proportionalToParent    1

        pin_to_sibling			TestFieldJoinAndCreateButtons
        pin_corner_to_sibling	RIGHT
        pin_to_sibling_corner	RIGHT

        sound_focus             "UI_Menu_Focus_Large"
        sound_accept            "UI_Menu_Clubs_DiscoverCreate"
    }

    LevelReqButtonBlocker
    {
        ControlName				RuiPanel
        xpos                    0
        ypos                    0
        wide					1122
        tall					60
        visible				    0
        rui                     "ui/club_discovery_button_blocker.rpak"


        pin_to_sibling          TestFieldJoinAndCreateButtons
        pin_corner_to_sibling   CENTER
        pin_to_sibling_corner   CENTER
    }

    TestFieldFilters
    {
        ControlName				Label
        wide					1074
        tall					%5
        xpos                    0
        ypos                    12
        ypos_nx_handheld        10		[$NX || $NX_UI_PC] 
        zpos                    0
        labelText               ""
        visible					1
        bgcolor_override        "0 0 0 128"
        paintbackground         0

        pin_to_sibling          TestFieldJoinAndCreateButtons
        pin_corner_to_sibling   TOP
        pin_to_sibling_corner   BOTTOM
    }

    CasualFilterButton
    {
        ControlName				RuiButton
        classname               "MenuButton"
        wide					256
        wide_nx_handheld		350		[$NX || $NX_UI_PC]
        tall					48
        xpos                    0
        rui                     "ui/generic_button.rpak"
        labelText               ""
        visible					1
        cursorVelocityModifier  0.7

		navUp                   ClubSearchButton
		navRight                ClubInvitesButton

        proportionalToParent    1

        pin_to_sibling          TestFieldFilters
        pin_corner_to_sibling   LEFT
        pin_to_sibling_corner   LEFT

        sound_focus             "UI_Menu_Focus_Large"
        sound_accept            "UI_Menu_Clubs_DiscoverCreate"
    }

    ClubInvitesButton
    {
        ControlName				RuiButton
        classname               "MenuButton"
        wide					256
        wide_nx_handheld		350		[$NX || $NX_UI_PC]
        tall					48
        xpos                    16
        rui                     "ui/generic_button.rpak"
        labelText               ""
        visible					1
        cursorVelocityModifier  0.7

        navUp                   ClubCreateButton
        navLeft                 CasualFilterButton

        proportionalToParent    1

        pin_to_sibling			CasualFilterButton
        pin_corner_to_sibling	LEFT
        pin_to_sibling_corner	RIGHT

        sound_focus             "UI_Menu_Focus_Large"
    }

    TestFieldResults
    {
        ControlName				Label
        wide					1074
        tall					366
        xpos                    0
        ypos                    2
        ypos_nx_handheld        8		[$NX || $NX_UI_PC]
        zpos                    0
        labelText               ""
        visible					1
        bgcolor_override        "0 0 0 128"
        paintbackground         0

        pin_to_sibling          TestFieldFilters
        pin_corner_to_sibling   TOP_RIGHT
        pin_to_sibling_corner   BOTTOM_RIGHT
    }

    DiscoverySearchResultsGrid
    {
        ControlName             GridButtonListPanel

        xpos                    0
        ypos                    0

        pin_to_sibling          TestFieldResults
        pin_corner_to_sibling   TOP_LEFT
        pin_to_sibling_corner   TOP_LEFT

        columns                  		3
        columns_nx_handheld      		2			[$NX || $NX_UI_PC]
        rows                     		3
        rows_nx_handheld         		2			[$NX || $NX_UI_PC]
        buttonSpacing            		12
        buttonSpacing_nx_handheld   	18			[$NX || $NX_UI_PC]
        scrollbarSpacing         		2	
        scrollbarSpacing_nx_handheld    6			[$NX || $NX_UI_PC]
        scrollbarOnLeft          		0
        //tabPosition            		1
        //selectOnDpadNav          		1

        ButtonSettings
        {
            rui                      "ui/club_search_result_button.rpak"
            clipRui                  1
            wide                     350
            wide_nx_handheld         518		[$NX || $NX_UI_PC]
            tall                     114
            tall_nx_handheld		 169		[$NX || $NX_UI_PC]
            cursorVelocityModifier   0.7
            cursorPriority           -1
            rightClickEvents         1
            //doubleClickEvents      1
            //middleClickEvents      1
            sound_focus              "UI_Menu_Focus"
            sound_accept             "UI_Menu_Accept"
            sound_deny               "UI_Menu_Deny"
        }
    }
}