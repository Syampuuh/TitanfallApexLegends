"resource/ui/menus/panels/panel_club_lobby_chat.res"
{
    Screen
    {
        ControlName				Label
        wide			        %100
        tall			        %100
        labelText				""
        visible					0
    }

	ScreenBlur
    {
        ControlName     Label
        labelText       ""
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
    //    }
	//
    //    cursorPriority			10
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

	CommBlockWarning
    {
        ControlName				RuiPanel
    	rui                     "ui/club_comm_block_warning.rpak"
    	xpos					80
    	ypos					0
    	wide					500
    	tall					0
		clipRui                  1

		pin_to_sibling          TextEntryChat
        pin_corner_to_sibling   BOTTOM
        pin_to_sibling_corner   TOP
     }

	ChatGrid
    {
        ControlName             GridButtonListPanel

        xpos                    0
        ypos                    0

        pin_to_sibling          CommBlockWarning
        pin_corner_to_sibling   BOTTOM
        pin_to_sibling_corner   TOP

        columns                  1
        rows                     11
        rows_nx_handheld         5			[$NX || $NX_UI_PC]
        buttonSpacing            0
        scrollbarSpacing         0
        scrollbarOnLeft          0
        //tabPosition            1
        selectOnDpadNav          0
        startScrolledToBottom    1

        ButtonSettings
        {
            rui                      "ui/club_chat.rpak"
            clipRui                  1
            wide                     480
            tall                     58
            tall_nx_handheld         140		[$NX || $NX_UI_PC]
            cursorVelocityModifier   0.7
            cursorPriority           20
            //rightClickEvents         1
            //doubleClickEvents      1
            //middleClickEvents      1
            sound_focus              ""
            sound_accept             ""
            sound_deny               ""
        }
    }

    TextEntryBackground
    {
        ControlName				RuiPanel
        wide					404
        //wide					450 [$WINDOWS] //Apparently, this only works for [$NX]
        tall					48
        visible				    1
        rui                     "ui/basic_image.rpak"

        ruiArgs
        {
            basicImageColor     "0.10 0.10 0.10"
        }

        pin_to_sibling			TextEntryChat
        pin_corner_to_sibling	CENTER
        pin_to_sibling_corner	CENTER
    }

    TextEntryChat
    {
        ControlName				TextEntry
        zpos					100 // This works around input weirdness when the control is constructed by code instead of VGUI blackbox.
        xpos                    0
        ypos                    0 //20
        wide					404
        //wide					450 [$WINDOWS] //Apparently, this only works for [$NX]
        tall					48
        visible					1
        enabled					1
        textHidden				0
        editable				1
        maxchars				63
        textAlignment			west
        ruiAsianFont            DefaultAsianFont
        ruiFont                 TitleRegularFont
        ruiFontHeight           28
        //ruiMinFontHeight        48
        keyboardTitle			""
        keyboardDescription		""
        allowRightClickMenu		0
        allowSpecialCharacters	1
        allowAdditionalSpecialCharacters	1
        unicode					1
        selectOnFocus           0
        cursorVelocityModifier  0.7
        cursorPriority          20

        pin_to_sibling			PanelFrame
        pin_corner_to_sibling	BOTTOM_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
    }

    SubmitChatButton
    {
        ControlName				RuiButton
        classname               "MenuButton"

        xpos                    0
        ypos                    0 //20

        wide					96
        tall					48
        rui                     "ui/generic_button.rpak"
        visible					1
        cursorVelocityModifier  0.7
        cursorPriority          25


        proportionalToParent    1

        pin_to_sibling          PanelFrame
        pin_corner_to_sibling   BOTTOM_RIGHT
        pin_to_sibling_corner   BOTTOM_RIGHT

        sound_focus             "UI_Menu_Focus_Large"
    }
}