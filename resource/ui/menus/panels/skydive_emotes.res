"resource/ui/menus/panels/skydive_emotes.res"
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

    SkydiveEmotesList
    {
        ControlName				GridButtonListPanel
        xpos                    0
        ypos                    0
        columns                 2
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

    Video
    {
        ControlName             RuiPanel
        xpos					370 //576
        xpos_nx_handheld		447   [$NX || $NX_UI_PC]
        ypos					-21 //71
        ypos_nx_handheld		60    [$NX || $NX_UI_PC]
        wide                    818 //1022
        wide_nx_handheld        1022  [$NX || $NX_UI_PC]
        tall                    460 //575
        tall_nx_handheld        647   [$NX || $NX_UI_PC]
        visible                 1
        rui                     "ui/finisher_video.rpak"
    }
}
