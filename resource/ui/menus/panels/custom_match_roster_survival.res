"resource/ui/menus/panels/custom_match_roster_survival.res"
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

    Team00
    {
        ControlName                 CNestedPanel
        controlSettingsFile         "resource/ui/menus/panels/custom_match_team_roster.res"

        xpos                        0
        ypos                        0

        wide                        272
        tall                        192

        pin_to_sibling              PanelFrame
        pin_corner_to_sibling       TOP_LEFT
        pin_to_sibling_corner       TOP_LEFT

        visible                     1
		scriptId                    2
    }

    Team01
    {
        ControlName                 CNestedPanel
        controlSettingsFile         "resource/ui/menus/panels/custom_match_team_roster.res"

        xpos                        11
        ypos                        0

        wide                        272
        tall                        192

        pin_to_sibling              Team00
        pin_corner_to_sibling       TOP_LEFT
        pin_to_sibling_corner       TOP_RIGHT

        visible                     1
		scriptId                    3
    }

    Team02
    {
        ControlName                 CNestedPanel
        controlSettingsFile         "resource/ui/menus/panels/custom_match_team_roster.res"

        xpos                        11
        ypos                        0

        wide                        272
        tall                        192

        pin_to_sibling              Team01
        pin_corner_to_sibling       TOP_LEFT
        pin_to_sibling_corner       TOP_RIGHT

        visible                     1
		scriptId                    4
    }

    Team03
    {
        ControlName                 CNestedPanel
        controlSettingsFile         "resource/ui/menus/panels/custom_match_team_roster.res"

        xpos                        11
        ypos                        0

        wide                        272
        tall                        192

        pin_to_sibling              Team02
        pin_corner_to_sibling       TOP_LEFT
        pin_to_sibling_corner       TOP_RIGHT

        visible                     1
		scriptId                    5
    }

    Team04
    {
        ControlName                 CNestedPanel
        controlSettingsFile         "resource/ui/menus/panels/custom_match_team_roster.res"

        xpos                        11
        ypos                        0

        wide                        272
        tall                        192

        pin_to_sibling              Team03
        pin_corner_to_sibling       TOP_LEFT
        pin_to_sibling_corner       TOP_RIGHT

        visible                     1
		scriptId                    6
    }

    Team05
    {
        ControlName                 CNestedPanel
        controlSettingsFile         "resource/ui/menus/panels/custom_match_team_roster.res"

        xpos                        0
        ypos                        16

        wide                        272
        tall                        192

        pin_to_sibling              Team00
        pin_corner_to_sibling       TOP_LEFT
        pin_to_sibling_corner       BOTTOM_LEFT

        visible                     1
		scriptId                    7
    }

    Team06
    {
        ControlName                 CNestedPanel
        controlSettingsFile         "resource/ui/menus/panels/custom_match_team_roster.res"

        xpos                        11
        ypos                        0

        wide                        272
        tall                        192

        pin_to_sibling              Team05
        pin_corner_to_sibling       TOP_LEFT
        pin_to_sibling_corner       TOP_RIGHT

        visible                     1
		scriptId                    8
    }

    Team07
    {
        ControlName                 CNestedPanel
        controlSettingsFile         "resource/ui/menus/panels/custom_match_team_roster.res"

        xpos                        11
        ypos                        0

        wide                        272
        tall                        192

        pin_to_sibling              Team06
        pin_corner_to_sibling       TOP_LEFT
        pin_to_sibling_corner       TOP_RIGHT

        visible                     1
		scriptId                    9
    }

    Team08
    {
        ControlName                 CNestedPanel
        controlSettingsFile         "resource/ui/menus/panels/custom_match_team_roster.res"

        xpos                        11
        ypos                        0

        wide                        272
        tall                        192

        pin_to_sibling              Team07
        pin_corner_to_sibling       TOP_LEFT
        pin_to_sibling_corner       TOP_RIGHT

        visible                     1
		scriptId                    10
    }

    Team09
    {
        ControlName                 CNestedPanel
        controlSettingsFile         "resource/ui/menus/panels/custom_match_team_roster.res"

        xpos                        11
        ypos                        0

        wide                        272
        tall                        192

        pin_to_sibling              Team08
        pin_corner_to_sibling       TOP_LEFT
        pin_to_sibling_corner       TOP_RIGHT

        visible                     1
		scriptId                    11
    }

    Team10
    {
        ControlName                 CNestedPanel
        controlSettingsFile         "resource/ui/menus/panels/custom_match_team_roster.res"

        xpos                        0
        ypos                        16

        wide                        272
        tall                        192

        pin_to_sibling              Team05
        pin_corner_to_sibling       TOP_LEFT
        pin_to_sibling_corner       BOTTOM_LEFT

        visible                     1
		scriptId                    12
    }

    Team11
    {
        ControlName                 CNestedPanel
        controlSettingsFile         "resource/ui/menus/panels/custom_match_team_roster.res"

        xpos                        11
        ypos                        0

        wide                        272
        tall                        192

        pin_to_sibling              Team10
        pin_corner_to_sibling       TOP_LEFT
        pin_to_sibling_corner       TOP_RIGHT

        visible                     1
		scriptId                    13
    }

    Team12
    {
        ControlName                 CNestedPanel
        controlSettingsFile         "resource/ui/menus/panels/custom_match_team_roster.res"

        xpos                        11
        ypos                        0

        wide                        272
        tall                        192

        pin_to_sibling              Team11
        pin_corner_to_sibling       TOP_LEFT
        pin_to_sibling_corner       TOP_RIGHT

        visible                     1
		scriptId                    14
    }

    Team13
    {
        ControlName                 CNestedPanel
        controlSettingsFile         "resource/ui/menus/panels/custom_match_team_roster.res"

        xpos                        11
        ypos                        0

        wide                        272
        tall                        192

        pin_to_sibling              Team12
        pin_corner_to_sibling       TOP_LEFT
        pin_to_sibling_corner       TOP_RIGHT

        visible                     1
		scriptId                    15
    }

    Team14
    {
        ControlName                 CNestedPanel
        controlSettingsFile         "resource/ui/menus/panels/custom_match_team_roster.res"

        xpos                        11
        ypos                        0

        wide                        272
        tall                        192

        pin_to_sibling              Team13
        pin_corner_to_sibling       TOP_LEFT
        pin_to_sibling_corner       TOP_RIGHT

        visible                     1
		scriptId                    16
    }

    Team15
    {
        ControlName                 CNestedPanel
        controlSettingsFile         "resource/ui/menus/panels/custom_match_team_roster.res"

        xpos                        0
        ypos                        16

        wide                        272
        tall                        192

        pin_to_sibling              Team10
        pin_corner_to_sibling       TOP_LEFT
        pin_to_sibling_corner       BOTTOM_LEFT

        visible                     1
		scriptId                    17
    }

    Team16
    {
        ControlName                 CNestedPanel
        controlSettingsFile         "resource/ui/menus/panels/custom_match_team_roster.res"

        xpos                        11
        ypos                        0

        wide                        272
        tall                        192

        pin_to_sibling              Team15
        pin_corner_to_sibling       TOP_LEFT
        pin_to_sibling_corner       TOP_RIGHT

        visible                     1
		scriptId                    18
    }

    Team17
    {
        ControlName                 CNestedPanel
        controlSettingsFile         "resource/ui/menus/panels/custom_match_team_roster.res"

        xpos                        11
        ypos                        0

        wide                        272
        tall                        192

        pin_to_sibling              Team16
        pin_corner_to_sibling       TOP_LEFT
        pin_to_sibling_corner       TOP_RIGHT

        visible                     1
		scriptId                    19
    }

    Team18
    {
        ControlName                 CNestedPanel
        controlSettingsFile         "resource/ui/menus/panels/custom_match_team_roster.res"

        xpos                        11
        ypos                        0

        wide                        272
        tall                        192

        pin_to_sibling              Team17
        pin_corner_to_sibling       TOP_LEFT
        pin_to_sibling_corner       TOP_RIGHT

        visible                     1
		scriptId                    20
    }

    Team19
    {
        ControlName                 CNestedPanel
        controlSettingsFile         "resource/ui/menus/panels/custom_match_team_roster.res"

        xpos                        11
        ypos                        0

        wide                        272
        tall                        192

        pin_to_sibling              Team18
        pin_corner_to_sibling       TOP_LEFT
        pin_to_sibling_corner       TOP_RIGHT

        visible                     1
		scriptId                    21
    }
}