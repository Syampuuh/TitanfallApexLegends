"resource/ui/menus/panels/custom_match_player_roster.res"
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

    SurvivalRoster
    {
        ControlName                 CNestedPanel
        controlSettingsFile         "resource/ui/menus/panels/custom_match_roster_survival.res"

		wide					    %100
		tall					    %100
		proportionalToParent        1
		visible                     0

        pin_to_sibling              PanelFrame
        pin_corner_to_sibling       TOP_LEFT
        pin_to_sibling_corner       TOP_LEFT
    }

    ArenasRoster
    {
        ControlName                 CNestedPanel
        controlSettingsFile         "resource/ui/menus/panels/custom_match_roster_arenas.res"

		wide					    %100
		tall					    %100
		proportionalToParent        1
		visible                     0

        pin_to_sibling              PanelFrame
        pin_corner_to_sibling       TOP_LEFT
        pin_to_sibling_corner       TOP_LEFT
    }
}