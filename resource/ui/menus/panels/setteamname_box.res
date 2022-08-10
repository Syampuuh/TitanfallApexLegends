"resource/ui/menus/panels/setteamname_box.res"
{
    PanelFrame
    {
		ControlName				Label
		xpos					0
		ypos					0
		wide					%100
		tall					%100
		labelText				""
		visible				    0
        bgcolor_override        "0 0 255 32"
        paintbackground         1

        proportionalToParent    1
    }

    ConnectBoxFrame
    {
        ControlName				RuiPanel
        wide					%100
        tall					%100
        visible				    1
        rui                     "ui/tournament_connect_box.rpak"

        pin_to_sibling			PanelFrame
        pin_corner_to_sibling	CENTER
        pin_to_sibling_corner	CENTER

        proportionalToParent    1
    }

    TextEntryBackground
    {
        ControlName				RuiPanel
        wide					300
        wide_nx_handheld		600			[$NX || $NX_UI_PC]
        tall					48
        visible				    1
        rui                     "ui/basic_image.rpak"

        ruiArgs
        {
            basicImageColor     "0.18 0.18 0.18"
        }

        pin_to_sibling			TextEntryCode
        pin_corner_to_sibling	CENTER
        pin_to_sibling_corner	CENTER
    }

    TextEntryCode
    {
        ControlName				TextEntry
        zpos					100 // This works around input weirdness when the control is constructed by code instead of VGUI blackbox.
        xpos                    0
        ypos                    20
        ypos_nx_handheld        100			[$NX || $NX_UI_PC]
        wide					300
        wide_nx_handheld		600			[$NX || $NX_UI_PC]
        tall					48
        visible					1
        enabled					1
        textHidden				0
        editable				1
        maxchars				16
        textAlignment			"center"
        ruiFont                 TitleRegularFont
        ruiFontHeight           48
        ruiMinFontHeight        48
        keyboardTitle			""
        keyboardDescription		""
        allowRightClickMenu		0
        allowSpecialCharacters	0
        unicode					0
        selectOnFocus           1
        cursorVelocityModifier  0.7
        cursorPriority          20

        pin_to_sibling			PanelFrame
        pin_corner_to_sibling	CENTER
        pin_to_sibling_corner	CENTER
    }

    ConnectButton
    {
        ControlName				RuiButton
        classname               "MenuButton"
        wide					300
        wide_nx_handheld		600			[$NX || $NX_UI_PC]
        tall					100
        ypos                    %-10
        ypos_nx_handheld        %-5			[$NX || $NX_UI_PC]
        rui                     "ui/generic_bar_button.rpak"
        labelText               ""
        visible					1
		cursorVelocityModifier  0.7

        proportionalToParent    1

        pin_to_sibling			PanelFrame
        pin_corner_to_sibling	BOTTOM
        pin_to_sibling_corner	BOTTOM

        sound_focus             "UI_Menu_Focus_Large"
    }
}
