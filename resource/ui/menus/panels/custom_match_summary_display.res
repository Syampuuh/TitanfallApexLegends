"resource/ui/menus/panels/custom_match_summary_display.res"
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

    SurvivalSummary00
    {
        ControlName                 CNestedPanel
        controlSettingsFile         "resource/ui/menus/panels/custom_match_summary_survival.res"

		wide					    %100
		tall					    %100
		proportionalToParent        1

        pin_to_sibling              PanelFrame
        pin_corner_to_sibling       TOP_LEFT
        pin_to_sibling_corner       TOP_LEFT
    }

    SurvivalSummary01
    {
        ControlName                 CNestedPanel
        controlSettingsFile         "resource/ui/menus/panels/custom_match_summary_survival_progress.res"

		wide					    %100
		tall					    %100
		proportionalToParent        1

        pin_to_sibling              PanelFrame
        pin_corner_to_sibling       TOP_LEFT
        pin_to_sibling_corner       TOP_LEFT
    }

    ArenasSummary00
    {
        ControlName                 CNestedPanel
        controlSettingsFile         "resource/ui/menus/panels/custom_match_summary_arenas.res"

		wide					    %100
		tall					    %100
		proportionalToParent        1

        pin_to_sibling              PanelFrame
        pin_corner_to_sibling       TOP_LEFT
        pin_to_sibling_corner       TOP_LEFT
    }

    ArenasSummary01
    {
        ControlName                 CNestedPanel
        controlSettingsFile         "resource/ui/menus/panels/custom_match_summary_arenas_progress.res"

		wide					    %100
		tall					    %100
		proportionalToParent        1

        pin_to_sibling              PanelFrame
        pin_corner_to_sibling       TOP_LEFT
        pin_to_sibling_corner       TOP_LEFT
    }
}