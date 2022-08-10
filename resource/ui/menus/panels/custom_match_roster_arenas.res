"resource/ui/menus/panels/custom_match_roster_arenas.res"
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
		paintbackground			1
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
        ControlName                 CNestedPanel
        controlSettingsFile         "resource/ui/menus/panels/custom_match_team_roster.res"

        xpos                        0
        ypos                        0

        wide                        272
        tall                        192

        pin_to_sibling              VsHeader
        pin_corner_to_sibling       RIGHT
        pin_to_sibling_corner       LEFT

        visible                     1
		scriptId                    2
    }

    Team01
    {
        ControlName                 CNestedPanel
        controlSettingsFile         "resource/ui/menus/panels/custom_match_team_roster.res"

        xpos                        0
        ypos                        0

        wide                        272
        tall                        192

        pin_to_sibling              VsHeader
        pin_corner_to_sibling       LEFT
        pin_to_sibling_corner       RIGHT

        visible                     1
		scriptId                    3
    }
}