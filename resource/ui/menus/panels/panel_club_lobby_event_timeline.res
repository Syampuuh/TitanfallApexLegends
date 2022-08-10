"resource/ui/menus/panels/panel_club_lobby_event_timeline.res"
{
    Screen
    {
        ControlName				Label
        wide			        %100
        tall			        %100
        labelText				""
        visible					0
    }

    //ScreenBlur
    //{
    //    ControlName				RuiPanel
    //    wide					500
    //    tall					688
    //    visible					1
    //    rui                     "ui/screen_blur.rpak"
	//
    //    ruiArgs
    //    {
    //        tintColor           "0.0 0.0 0.0 0.75"
    //        alpha               "0.0"
    //    }
	//
    //    //cursorPriority			10
    //}

    PanelFrame
    {
		ControlName				Label
		xpos					0
		ypos					0
		wide					%100
		tall					%100
		labelText				""
		visible				    1
        bgcolor_override        "30 32 47 192"
        paintbackground         0

        proportionalToParent    1
    }

    TimelineGrid
    {
        ControlName             GridButtonListPanel

        xpos                    0
        ypos                    0

        pin_to_sibling          PanelFrame
        pin_corner_to_sibling   TOP
        pin_to_sibling_corner   TOP

        columns                  1
        rows                     9
        rows_nx_handheld         5		[$NX || $NX_UI_PC]
        buttonSpacing            0
        scrollbarSpacing         0
        scrollbarOnLeft          0
        //tabPosition            1
        //selectOnDpadNav          1
        startScrolledToBottom    1

        ButtonSettings
        {
            rui                      "ui/club_event.rpak"
            clipRui                  1
            wide                     480
            tall                     77
            tall_nx_handheld         140		[$NX || $NX_UI_PC]
            cursorVelocityModifier   0.7
            //rightClickEvents         1
            //doubleClickEvents      1
            //middleClickEvents      1
            sound_focus              ""
            sound_accept             ""
            sound_deny               ""
        }
    }
}