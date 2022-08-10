"resource/ui/menus/panels/private_match_game_team_overview.res"
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
    // Alive Squads Overview
    ///////////////////////////////

	TeamOverview
    {
        ControlName             GridButtonListPanel

		xpos                    0
		ypos                    0

		pin_to_sibling              PanelFrame
		pin_corner_to_sibling       TOP_LEFT
		pin_to_sibling_corner       TOP_LEFT

        columns                 2
        rows                    11
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

    AliveSquadsHeader
    {
        ControlName					RuiPanel

        rui							"ui/private_match_team_overview_titled_header.rpak"

        pin_to_sibling              PanelFrame
        pin_corner_to_sibling       TOP_LEFT
        pin_to_sibling_corner       TOP_LEFT

		xpos                    0
		ypos                    0

        wide					742
        tall 					70
    }

    EliminatedSquadsHeader
    {
        ControlName					RuiPanel

        rui							"ui/private_match_team_overview_titled_header.rpak"

        pin_to_sibling              PanelFrame
        pin_corner_to_sibling       TOP_LEFT
        pin_to_sibling_corner       TOP_LEFT

		xpos                    0
		ypos                    0

        wide					742
        tall 					70
    }

    PlacementDisclaimer
    {
        ControlName					RuiPanel

        rui                         "ui/private_match_game_status_disclaimer.rpak"

        pin_to_sibling              TeamOverview
        pin_corner_to_sibling       TOP_RIGHT
        pin_to_sibling_corner       BOTTOM_RIGHT

		xpos                    -20
		ypos                    10

        wide					742
        tall 					70
    }
}
