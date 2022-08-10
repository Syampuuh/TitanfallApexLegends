"resource/ui/menus/panels/private_match_game_team_summary.res"
{
	PanelFrame
	{
		ControlName				Label
		xpos					0
		ypos					0
		wide					%100
		tall					%100
		labelText				""
		bgcolor_override		"255 16 255 32"
		visible					0
		paintbackground			0
		proportionalToParent    1
	}

	ToolTip
    {
        ControlName				RuiPanel
        InheritProperties       ToolTip
        zpos                    999
    }

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    ///////////////////////////////
    // Column 1 (team 1 - team 9)
    ///////////////////////////////

    TeamOverviewHeader01
    {
        ControlName					RuiPanel

        rui							"ui/private_match_team_overview_header.rpak"

        pin_to_sibling              PanelFrame
        pin_corner_to_sibling       TOP_LEFT
        pin_to_sibling_corner       TOP_LEFT

		xpos                    0
		ypos                    0

        wide					742
        tall 					70
    }

	TeamOverview01
    {
        ControlName             GridButtonListPanel

		xpos                    0
		ypos                    10

		pin_to_sibling              TeamOverviewHeader01
		pin_corner_to_sibling       TOP_LEFT
		pin_to_sibling_corner       BOTTOM_LEFT

        columns                 1
        rows                    2
        buttonSpacing           9
        scrollbarSpacing        0
        scrollbarOnLeft         0
        selectOnDpadNav         1

        ButtonSettings
        {
            rui                     "ui/private_match_team_overview.rpak"
            clipRui                 1
            wide                    742
            tall                    110
            cursorVelocityModifier  0.7
            sound_focus             "UI_Menu_Focus_Small"
            sound_accept            ""
            sound_deny              ""
        }
    }

	TeamOverview02
    {
        ControlName             GridButtonListPanel

		xpos                    0
		ypos                    10

		pin_to_sibling              TeamOverview01
		pin_corner_to_sibling       TOP_LEFT
		pin_to_sibling_corner       BOTTOM_LEFT

        columns                 1
        rows                    7
        buttonSpacing           9
        scrollbarSpacing        0
        scrollbarOnLeft         0
        selectOnDpadNav         1

        ButtonSettings
        {
            rui                     "ui/private_match_team_overview.rpak"
            clipRui                 1
            wide                    742
            tall                    70
            cursorVelocityModifier  0.7
            sound_focus             "UI_Menu_Focus_Small"
            sound_accept            ""
            sound_deny              ""
        }
    }

	///////////////////////////////
    // Column 2 (team 10 - team 20)
    ///////////////////////////////

	TeamOverview03
    {
        ControlName             GridButtonListPanel

        xpos                    0
        ypos                    0

        pin_to_sibling          PanelFrame
        pin_corner_to_sibling   TOP_RIGHT
        pin_to_sibling_corner   TOP_RIGHT

        columns                 1
        rows                    11
        buttonSpacing           9
        scrollbarSpacing        0
        scrollbarOnLeft         0

        selectOnDpadNav         1

        ButtonSettings
        {
            rui                     "ui/private_match_team_overview.rpak"
            clipRui                 0
            wide                    742
            tall                    70
            cursorVelocityModifier  0.7
            sound_focus             "UI_Menu_Focus_Small"
            sound_accept            ""
            sound_deny              ""
        }
    }

    PlacementDisclaimer
    {
        ControlName					RuiPanel

        rui                         "ui/private_match_game_status_disclaimer.rpak"

        pin_to_sibling              TeamOverview03
        pin_corner_to_sibling       TOP_RIGHT
        pin_to_sibling_corner       BOTTOM_RIGHT

		xpos                    -20
		ypos                    10

        wide					742
        tall 					70
    }
}
