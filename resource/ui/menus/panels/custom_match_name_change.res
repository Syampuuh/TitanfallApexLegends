"resource/ui/menus/panels/custom_match_name_change.res"
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

    PanelFrameBg
    {
        ControlName				ImagePanel
        wide                    %100
        tall                    %100

        pin_to_sibling			PanelFrame
        pin_corner_to_sibling	CENTER
        pin_to_sibling_corner	CENTER

        visible					1
        enabled 				1
        scaleImage				1
        image					"vgui/HUD/white"
        drawColor				"0 0 0 191"
    }

    LobbyName
    {
		ControlName				RuiPanel
		xpos					-20
		wide                    280
        tall					48
        rui                     "ui/custom_match_name_header.rpak"

        pin_to_sibling          PanelFrame
        pin_corner_to_sibling   LEFT
        pin_to_sibling_corner   LEFT
    }

    LobbyNameChange
    {
        ControlName				TextEntry
		xpos					-20
		wide                    280
        tall					48
        visible					0
        editable				1
        textAlignment			"center"
        ruiFont                 DefaultBoldFont
        ruiFontHeight           48
        ruiMinFontHeight        48

        pin_to_sibling			PanelFrame
        pin_corner_to_sibling	LEFT
        pin_to_sibling_corner	LEFT
    }

    ChangeButton
    {
		ControlName				RuiButton
        classname               "MenuButton"
        xpos                    -20
        wide					140
        tall					40

        pin_to_sibling          PanelFrame
        pin_corner_to_sibling   RIGHT
        pin_to_sibling_corner   RIGHT

        rui                     "ui/generic_button.rpak"
        ruiArgs
        {
            buttonText          "#CUSTOM_MATCH_LOBBY_NAME_CHANGE"
        }
    }
}