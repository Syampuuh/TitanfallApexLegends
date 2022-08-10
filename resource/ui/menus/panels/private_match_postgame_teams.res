"resource/ui/menus/panels/private_match_postgame_teams.res"
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

	ToolTip
    {
        ControlName				RuiPanel
        InheritProperties       ToolTip
        zpos                    999
    }

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    ///////////////////////////////
    // Row 1 (team 0 - team 4)
    ///////////////////////////////

    Team00
    {
        ControlName                 CNestedPanel
        controlSettingsFile         "resource/ui/menus/panels/private_match_placement_roster.res"

        xpos                        0
        ypos                        0

        wide                        322
        tall                        192

        pin_to_sibling              PanelFrame
        pin_corner_to_sibling       TOP_LEFT
        pin_to_sibling_corner       TOP_LEFT

        visible                     1
    }

    Team01
    {
        ControlName                 CNestedPanel
        controlSettingsFile         "resource/ui/menus/panels/private_match_placement_roster.res"

        xpos                        48
        ypos                        0

        wide                        322
        tall                        192

        pin_to_sibling              Team00
        pin_corner_to_sibling       TOP_LEFT
        pin_to_sibling_corner       TOP_RIGHT

        visible                     1
    }

    Team02
    {
        ControlName                 CNestedPanel
        controlSettingsFile         "resource/ui/menus/panels/private_match_placement_roster.res"

        xpos                        48
        ypos                        0

        wide                        322
        tall                        192

        pin_to_sibling              Team01
        pin_corner_to_sibling       TOP_LEFT
        pin_to_sibling_corner       TOP_RIGHT

        visible                     1
    }

    Team03
    {
        ControlName                 CNestedPanel
        controlSettingsFile         "resource/ui/menus/panels/private_match_placement_roster.res"

        xpos                        48
        ypos                        0

        wide                        322
        tall                        192

        pin_to_sibling              Team02
        pin_corner_to_sibling       TOP_LEFT
        pin_to_sibling_corner       TOP_RIGHT

        visible                     1
    }

    Team04
    {
        ControlName                 CNestedPanel
        controlSettingsFile         "resource/ui/menus/panels/private_match_placement_roster.res"

        xpos                        48
        ypos                        0

        wide                        322
        tall                        192

        pin_to_sibling              Team03
        pin_corner_to_sibling       TOP_LEFT
        pin_to_sibling_corner       TOP_RIGHT

        visible                     1
    }

    ///////////////////////////////
    // Row 2 (team 5 - team 9)
    ///////////////////////////////

    Team05
    {
        ControlName                 CNestedPanel
        controlSettingsFile         "resource/ui/menus/panels/private_match_placement_roster.res"

        xpos                        0
        ypos                        12

        wide                        322
        tall                        192

        pin_to_sibling              Team00
        pin_corner_to_sibling       TOP_LEFT
        pin_to_sibling_corner       BOTTOM_LEFT

        visible                     1
    }

    Team06
    {
        ControlName                 CNestedPanel
        controlSettingsFile         "resource/ui/menus/panels/private_match_placement_roster.res"

        xpos                        48
        ypos                        0

        wide                        322
        tall                        192

        pin_to_sibling              Team05
        pin_corner_to_sibling       TOP_LEFT
        pin_to_sibling_corner       TOP_RIGHT

        visible                     1
    }

    Team07
    {
        ControlName                 CNestedPanel
        controlSettingsFile         "resource/ui/menus/panels/private_match_placement_roster.res"

        xpos                        48
        ypos                        0

        wide                        322
        tall                        192

        pin_to_sibling              Team06
        pin_corner_to_sibling       TOP_LEFT
        pin_to_sibling_corner       TOP_RIGHT

        visible                     1
    }

    Team08
    {
        ControlName                 CNestedPanel
        controlSettingsFile         "resource/ui/menus/panels/private_match_placement_roster.res"

        xpos                        48
        ypos                        0

        wide                        322
        tall                        192

        pin_to_sibling              Team07
        pin_corner_to_sibling       TOP_LEFT
        pin_to_sibling_corner       TOP_RIGHT

        visible                     1
    }

    Team09
    {
        ControlName                 CNestedPanel
        controlSettingsFile         "resource/ui/menus/panels/private_match_placement_roster.res"

        xpos                        48
        ypos                        0

        wide                        322
        tall                        192

        pin_to_sibling              Team08
        pin_corner_to_sibling       TOP_LEFT
        pin_to_sibling_corner       TOP_RIGHT

        visible                     1
    }

    ///////////////////////////////
    // Row 3 (team 10 - team 14)
    ///////////////////////////////

    Team10
    {
        ControlName                 CNestedPanel
        controlSettingsFile         "resource/ui/menus/panels/private_match_placement_roster.res"

        xpos                        0
        ypos                        12

        wide                        322
        tall                        192

        pin_to_sibling              Team05
        pin_corner_to_sibling       TOP_LEFT
        pin_to_sibling_corner       BOTTOM_LEFT

        visible                     1
    }

    Team11
    {
        ControlName                 CNestedPanel
        controlSettingsFile         "resource/ui/menus/panels/private_match_placement_roster.res"

        xpos                        48
        ypos                        0

        wide                        322
        tall                        192

        pin_to_sibling              Team10
        pin_corner_to_sibling       TOP_LEFT
        pin_to_sibling_corner       TOP_RIGHT

        visible                     1
    }

    Team12
    {
        ControlName                 CNestedPanel
        controlSettingsFile         "resource/ui/menus/panels/private_match_placement_roster.res"

        xpos                        48
        ypos                        0

        wide                        322
        tall                        192

        pin_to_sibling              Team11
        pin_corner_to_sibling       TOP_LEFT
        pin_to_sibling_corner       TOP_RIGHT

        visible                     1
    }

    Team13
    {
        ControlName                 CNestedPanel
        controlSettingsFile         "resource/ui/menus/panels/private_match_placement_roster.res"

        xpos                        48
        ypos                        0

        wide                        322
        tall                        192

        pin_to_sibling              Team12
        pin_corner_to_sibling       TOP_LEFT
        pin_to_sibling_corner       TOP_RIGHT

        visible                     1
    }

    Team14
    {
        ControlName                 CNestedPanel
        controlSettingsFile         "resource/ui/menus/panels/private_match_placement_roster.res"

        xpos                        48
        ypos                        0

        wide                        322
        tall                        192

        pin_to_sibling              Team13
        pin_corner_to_sibling       TOP_LEFT
        pin_to_sibling_corner       TOP_RIGHT

        visible                     1
    }

    ///////////////////////////////
    // Row 4 (team 15 - team 19)
    ///////////////////////////////

    Team15
    {
        ControlName                 CNestedPanel
        controlSettingsFile         "resource/ui/menus/panels/private_match_placement_roster.res"

        xpos                        0
        ypos                        12

        wide                        322
        tall                        192

        pin_to_sibling              Team10
        pin_corner_to_sibling       TOP_LEFT
        pin_to_sibling_corner       BOTTOM_LEFT

        visible                     1
    }

    Team16
    {
        ControlName                 CNestedPanel
        controlSettingsFile         "resource/ui/menus/panels/private_match_placement_roster.res"

        xpos                        48
        ypos                        0

        wide                        322
        tall                        192

        pin_to_sibling              Team15
        pin_corner_to_sibling       TOP_LEFT
        pin_to_sibling_corner       TOP_RIGHT

        visible                     1
    }

    Team17
    {
        ControlName                 CNestedPanel
        controlSettingsFile         "resource/ui/menus/panels/private_match_placement_roster.res"

        xpos                        48
        ypos                        0

        wide                        322
        tall                        192

        pin_to_sibling              Team16
        pin_corner_to_sibling       TOP_LEFT
        pin_to_sibling_corner       TOP_RIGHT

        visible                     1
    }

    Team18
    {
        ControlName                 CNestedPanel
        controlSettingsFile         "resource/ui/menus/panels/private_match_placement_roster.res"

        xpos                        48
        ypos                        0

        wide                        322
        tall                        192

        pin_to_sibling              Team17
        pin_corner_to_sibling       TOP_LEFT
        pin_to_sibling_corner       TOP_RIGHT

        visible                     1
    }

    Team19
    {
        ControlName                 CNestedPanel
        controlSettingsFile         "resource/ui/menus/panels/private_match_placement_roster.res"

        xpos                        48
        ypos                        0

        wide                        322
        tall                        192

        pin_to_sibling              Team18
        pin_corner_to_sibling       TOP_LEFT
        pin_to_sibling_corner       TOP_RIGHT

        visible                     1
    }
}