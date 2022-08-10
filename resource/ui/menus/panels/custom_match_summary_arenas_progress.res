"resource/ui/menus/panels/custom_match_summary_arenas_progress.res"
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

    VsHeader
    {
        ControlName                 RuiPanel
        rui                         "ui/custom_match_vs_header.rpak"

        wide                        144
        tall                        144

        pin_to_sibling              PanelFrame
        pin_corner_to_sibling       CENTER
        pin_to_sibling_corner       CENTER
    }

    Team00
	{
		ControlName                 RuiPanel
		rui                         "ui/custom_match_team_overview.rpak"

		xpos                        0
		ypos                        0

		wide                        830
		tall                        100

		pin_to_sibling              VsHeader
		pin_corner_to_sibling       BOTTOM
		pin_to_sibling_corner       TOP

		visible                     1
		scriptId                    0
	}


    Team01
	{
		ControlName                 RuiPanel
		rui                         "ui/custom_match_team_overview.rpak"

		xpos                        0
		ypos                        0

		wide                        830
		tall                        100

		pin_to_sibling              VsHeader
		pin_corner_to_sibling       TOP
		pin_to_sibling_corner       BOTTOM

		visible                     1
		scriptId                    1
	}
}
