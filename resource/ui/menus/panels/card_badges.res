"resource/ui/menus/panels/card_badges.res"
{
	PanelFrame
	{
		ControlName				Label
		xpos					0
		ypos					0
		wide					%100
		tall					%100
		labelText				""
//		bgcolor_override		"70 70 70 255"
//		visible					1
//		paintbackground			1

        proportionalToParent    1
	}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    BadgeList
    {
        ControlName				GridButtonListPanel
        xpos                    0
        ypos                    0
        columns                 4
        rows                    5
        rows_nx_handheld        4  		[$NX || $NX_UI_PC]
        buttonSpacing           6
        scrollbarSpacing        10
        scrollbarSpacing_nx_handheld     8  		[$NX || $NX_UI_PC]
        scrollbarOnLeft         0
        visible					1
        tabPosition             1
        bubbleNavEvents         1

        CategorySettings
		{
			rui                     "ui/gcard_badge_category.rpak"
			clipRui                 1
			wide					514
			tall					40
			enabled                 false
		}

        ButtonSettings
        {
            rui                     "ui/card_badge_button.rpak"
            clipRui                 1
            wide					124
            wide_nx_handheld		182 	[$NX || $NX_UI_PC]
            tall					124
            tall_nx_handheld		182 	[$NX || $NX_UI_PC]
            cursorVelocityModifier  0.7
            sound_focus             "UI_Menu_Focus_Small"
            rightClickEvents		1
			doubleClickEvents       1
            bubbleNavEvents         1
        }
    }

    ToggleHideShowLocked
    {
	    ControlName			RuiButton
        clipRui             0
        xpos                0
        ypos                10
        zpos			    5
        wide			    192
        wide_nx_handheld    240			[$NX || $NX_UI_PC]
        tall			    45
        tall_nx_handheld    56			[$NX || $NX_UI_PC]
        rui					"ui/gcard_show_hide_locked.rpak"

        pin_to_sibling			BadgeList
        pin_corner_to_sibling	TOP_RIGHT
        pin_to_sibling_corner	BOTTOM_RIGHT
    }
}
