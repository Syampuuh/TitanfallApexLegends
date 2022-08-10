resource/ui/menus/panels/custom_match_summary.res
{
    ScreenFrame
    {
        ControlName				Label
        wide					%100
        tall					%100
        labelText				""
        visible				    0
        bgcolor_override        "255 255 0 10"
        paintbackground         1
        proportionalToParent    1
    }

    LeftColumn
    {
        ControlName				Label
        wide                    252
        tall                    %100
        labelText				""
        proportionalToParent    1

        pin_to_sibling          ScreenFrame
        pin_corner_to_sibling   LEFT
        pin_to_sibling_corner   LEFT
    }

    HistoryGrid
    {
        ControlName             GridButtonListPanel

        wide                    252
        tall                    %100

        pin_to_sibling          LeftColumn
        pin_corner_to_sibling   CENTER
        pin_to_sibling_corner   CENTER

        columns                 1
        rows                    9
        buttonSpacing           3
        scrollbarSpacing        1
        scrollbarOnLeft         0
        selectOnDpadNav         1

        ButtonSettings
        {
            rui                     "ui/custom_match_history_button.rpak"
            clipRui                 1
            wide                    240
            tall                    88
            cursorVelocityModifier  0.7
            sound_focus             "UI_Menu_Focus_Small"
            sound_accept            ""
            sound_deny              ""
        }
    }

    RightColumn
    {
        ControlName				Label
        wide                    1546
        tall                    %100
        labelText				""
        proportionalToParent    1

        pin_to_sibling          ScreenFrame
        pin_corner_to_sibling   RIGHT
        pin_to_sibling_corner   RIGHT
    }

    MatchSummary
    {
		ControlName				CNestedPanel
        wide                    1546
        tall                    %100
		visible				    1
        proportionalToParent    1

        pin_to_sibling          RightColumn
        pin_corner_to_sibling   CENTER
        pin_to_sibling_corner   CENTER

        controlSettingsFile     "resource/ui/menus/panels/custom_match_summary_display.res"
    }

	NoHistory
	{
		ControlName				Label
        InheritProperties		SubheaderText
        wide                    1546
        tall                    200

        labelText				"#CUSTOM_MATCH_NO_MATCH_HISTORY"

        pin_to_sibling          ScreenFrame
        pin_corner_to_sibling   CENTER
        pin_to_sibling_corner   CENTER
	}

	Spinner
	{
		ControlName				RuiPanel
		InheritProperties		RuiDialogSpinner
		classname 				DialogSpinnerClass
		visible				    0

		pin_to_sibling			RightColumn
		pin_corner_to_sibling	CENTER
		pin_to_sibling_corner	CENTER
	}
}
