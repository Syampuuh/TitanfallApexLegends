"resource/ui/menus/panels/emotes.res"
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

    QuipList
    {
        ControlName				GridButtonListPanel
        xpos                    0
        ypos                    0
        columns                 3
        rows                    4
        rows_nx_handheld        3			[$NX || $NX_UI_PC]
        buttonSpacing           6
        scrollbarSpacing        10
        scrollbarSpacing_nx_handheld     8  		[$NX || $NX_UI_PC]
        scrollbarOnLeft         0
        visible					1
        tabPosition             1

        ButtonSettings
        {
            rui                     "ui/card_badge_button.rpak"
            clipRui                 1
            wide					168
            wide_nx_handheld		246 	[$NX || $NX_UI_PC]
            tall					168
            tall_nx_handheld		246 	[$NX || $NX_UI_PC]
            cursorVelocityModifier  0.7
            sound_focus             "UI_Menu_Focus_Small"
            rightClickEvents		1
			doubleClickEvents       1
			middleClickEvents       1
			bubbleNavEvents         1
        }
    }
}
