"resource/ui/menus/panels/custom_match_summary_survival.res"
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

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    Header00
    {
        ControlName					RuiPanel

        rui							"ui/custom_match_team_overview_header.rpak"
		ruiArgs
		{
			title                   "#CUSTOM_MATCH_FINAL_RESULTS"
			squadHeader             "#SQUADS"
			backgroundColor         "0.0 0.0 0.0 0.9"
		}

        pin_to_sibling              PanelFrame
        pin_corner_to_sibling       TOP_LEFT
        pin_to_sibling_corner       TOP_LEFT

		xpos                        0
		ypos                        0

        wide					    770
        tall 					    70
    }

    Team00
	{
		ControlName                 RuiPanel
		rui                         "ui/custom_match_team_overview.rpak"
		ruiArgs
		{
			highlightSquad          1
		}

		xpos                        0
		ypos                        5

		wide                        770
		tall                        107

		pin_to_sibling              Header00
		pin_corner_to_sibling       TOP_LEFT
		pin_to_sibling_corner       BOTTOM_LEFT

		visible                     1
		scriptId                    0
	}

    Team01
	{
		ControlName                 RuiPanel
		rui                         "ui/custom_match_team_overview.rpak"
		ruiArgs
		{
			highlightSquad          1
		}

		xpos                        0
		ypos                        5

		wide                        770
		tall                        107

		pin_to_sibling              Team00
		pin_corner_to_sibling       TOP_LEFT
		pin_to_sibling_corner       BOTTOM_LEFT

		visible                     1
		scriptId                    1
	}

    Team02
	{
		ControlName                 RuiPanel
		rui                         "ui/custom_match_team_overview.rpak"
		ruiArgs
		{
			highlightSquad          1
		}

		xpos                        0
		ypos                        5

		wide                        770
		tall                        70

		pin_to_sibling              Team01
		pin_corner_to_sibling       TOP_LEFT
		pin_to_sibling_corner       BOTTOM_LEFT

		visible                     1
		scriptId                    2
	}

    Team03
	{
		ControlName                 RuiPanel
		rui                         "ui/custom_match_team_overview.rpak"
		ruiArgs
		{
			highlightSquad          1
		}

		xpos                        0
		ypos                        5

		wide                        770
		tall                        70

		pin_to_sibling              Team02
		pin_corner_to_sibling       TOP_LEFT
		pin_to_sibling_corner       BOTTOM_LEFT

		visible                     1
		scriptId                    3
	}

    Team04
	{
		ControlName                 RuiPanel
		rui                         "ui/custom_match_team_overview.rpak"
		ruiArgs
		{
			highlightSquad          1
		}

		xpos                        0
		ypos                        5

		wide                        770
		tall                        70

		pin_to_sibling              Team03
		pin_corner_to_sibling       TOP_LEFT
		pin_to_sibling_corner       BOTTOM_LEFT

		visible                     1
		scriptId                    4
	}

    Team05
	{
		ControlName                 RuiPanel
		rui                         "ui/custom_match_team_overview.rpak"
		ruiArgs
		{
			highlightSquad          1
		}

		xpos                        0
		ypos                        5

		wide                        770
		tall                        70

		pin_to_sibling              Team04
		pin_corner_to_sibling       TOP_LEFT
		pin_to_sibling_corner       BOTTOM_LEFT

		visible                     1
		scriptId                    5
	}

    Team06
	{
		ControlName                 RuiPanel
		rui                         "ui/custom_match_team_overview.rpak"
		ruiArgs
		{
			highlightSquad          1
		}

		xpos                        0
		ypos                        5

		wide                        770
		tall                        70

		pin_to_sibling              Team05
		pin_corner_to_sibling       TOP_LEFT
		pin_to_sibling_corner       BOTTOM_LEFT

		visible                     1
		scriptId                    6
	}

    Team07
	{
		ControlName                 RuiPanel
		rui                         "ui/custom_match_team_overview.rpak"
		ruiArgs
		{
			highlightSquad          1
		}

		xpos                        0
		ypos                        5

		wide                        770
		tall                        70

		pin_to_sibling              Team06
		pin_corner_to_sibling       TOP_LEFT
		pin_to_sibling_corner       BOTTOM_LEFT

		visible                     1
		scriptId                    7
	}

    Team08
	{
		ControlName                 RuiPanel
		rui                         "ui/custom_match_team_overview.rpak"
		ruiArgs
		{
			highlightSquad          1
		}

		xpos                        0
		ypos                        5

		wide                        770
		tall                        70

		pin_to_sibling              Team07
		pin_corner_to_sibling       TOP_LEFT
		pin_to_sibling_corner       BOTTOM_LEFT

		visible                     1
		scriptId                    8
	}

    Team09
	{
		ControlName                 RuiPanel
		rui                         "ui/custom_match_team_overview.rpak"
		ruiArgs
		{
			highlightSquad          1
		}

		xpos                        0
		ypos                        0

		wide                        770
		tall                        70

        pin_to_sibling              PanelFrame
        pin_corner_to_sibling       TOP_RIGHT
        pin_to_sibling_corner       TOP_RIGHT

		visible                     1
		scriptId                    5
	}

    Team10
	{
		ControlName                 RuiPanel
		rui                         "ui/custom_match_team_overview.rpak"
		ruiArgs
		{
			highlightSquad          1
		}

		xpos                        0
		ypos                        5

		wide                        770
		tall                        70

		pin_to_sibling              Team09
		pin_corner_to_sibling       TOP_LEFT
		pin_to_sibling_corner       BOTTOM_LEFT

		visible                     1
		scriptId                    10
	}

    Team11
	{
		ControlName                 RuiPanel
		rui                         "ui/custom_match_team_overview.rpak"
		ruiArgs
		{
			highlightSquad          1
		}

		xpos                        0
		ypos                        5

		wide                        770
		tall                        70

		pin_to_sibling              Team10
		pin_corner_to_sibling       TOP_LEFT
		pin_to_sibling_corner       BOTTOM_LEFT

		visible                     1
		scriptId                    11
	}

    Team12
	{
		ControlName                 RuiPanel
		rui                         "ui/custom_match_team_overview.rpak"
		ruiArgs
		{
			highlightSquad          1
		}

		xpos                        0
		ypos                        5

		wide                        770
		tall                        70

		pin_to_sibling              Team11
		pin_corner_to_sibling       TOP_LEFT
		pin_to_sibling_corner       BOTTOM_LEFT

		visible                     1
		scriptId                    12
	}

    Team13
	{
		ControlName                 RuiPanel
		rui                         "ui/custom_match_team_overview.rpak"
		ruiArgs
		{
			highlightSquad          1
		}

		xpos                        0
		ypos                        5

		wide                        770
		tall                        70

		pin_to_sibling              Team12
		pin_corner_to_sibling       TOP_LEFT
		pin_to_sibling_corner       BOTTOM_LEFT

		visible                     1
		scriptId                    13
	}

    Team14
	{
		ControlName                 RuiPanel
		rui                         "ui/custom_match_team_overview.rpak"
		ruiArgs
		{
			highlightSquad          1
		}

		xpos                        0
		ypos                        5

		wide                        770
		tall                        70

		pin_to_sibling              Team13
		pin_corner_to_sibling       TOP_LEFT
		pin_to_sibling_corner       BOTTOM_LEFT

		visible                     1
		scriptId                    14
	}

    Team15
	{
		ControlName                 RuiPanel
		rui                         "ui/custom_match_team_overview.rpak"
		ruiArgs
		{
			highlightSquad          1
		}

		xpos                        0
		ypos                        5

		wide                        770
		tall                        70

		pin_to_sibling              Team14
		pin_corner_to_sibling       TOP_LEFT
		pin_to_sibling_corner       BOTTOM_LEFT

		visible                     1
		scriptId                    15
	}

    Team16
	{
		ControlName                 RuiPanel
		rui                         "ui/custom_match_team_overview.rpak"
		ruiArgs
		{
			highlightSquad          1
		}

		xpos                        0
		ypos                        5

		wide                        770
		tall                        70

		pin_to_sibling              Team15
		pin_corner_to_sibling       TOP_LEFT
		pin_to_sibling_corner       BOTTOM_LEFT

		visible                     1
		scriptId                    16
	}

    Team17
	{
		ControlName                 RuiPanel
		rui                         "ui/custom_match_team_overview.rpak"
		ruiArgs
		{
			highlightSquad          1
		}

		xpos                        0
		ypos                        5

		wide                        770
		tall                        70

		pin_to_sibling              Team16
		pin_corner_to_sibling       TOP_LEFT
		pin_to_sibling_corner       BOTTOM_LEFT

		visible                     1
		scriptId                    17
	}

    Team18
	{
		ControlName                 RuiPanel
		rui                         "ui/custom_match_team_overview.rpak"
		ruiArgs
		{
			highlightSquad          1
		}

		xpos                        0
		ypos                        5

		wide                        770
		tall                        70

		pin_to_sibling              Team17
		pin_corner_to_sibling       TOP_LEFT
		pin_to_sibling_corner       BOTTOM_LEFT

		visible                     1
		scriptId                    18
	}

    Team19
	{
		ControlName                 RuiPanel
		rui                         "ui/custom_match_team_overview.rpak"
		ruiArgs
		{
			highlightSquad          1
		}

		xpos                        0
		ypos                        5

		wide                        770
		tall                        70

		pin_to_sibling              Team18
		pin_corner_to_sibling       TOP_LEFT
		pin_to_sibling_corner       BOTTOM_LEFT

		visible                     1
		scriptId                    19
	}
}
