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
        columns                 3
        rows                    4
        buttonSpacing           10
        scrollbarSpacing        10
        scrollbarOnLeft         0
        visible					1
        ButtonSettings
        {
            rui                     "ui/card_badge_button.rpak"
            clipRui                 1
            wide					150
            tall					150
            cursorVelocityModifier  0.7
            sound_focus             "UI_Menu_Focus_Small"
            rightClickEvents		1
			doubleClickEvents       1
        }
    }
}
