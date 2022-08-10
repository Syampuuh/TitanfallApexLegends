"resource/ui/menus/panels/custom_match_map_select.res"
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

    SelectMapSubHeader
    {
        ControlName             RuiPanel

        wide                    680
        tall                    48
        clipRui                 1

        rui                     "ui/custom_match_settings_sub_header.rpak"
        ruiArgs
        {
            headerText          "#CUSTOM_MATCH_MAP_SELECT"
        }

        pin_to_sibling          PanelFrame
        pin_corner_to_sibling   TOP_LEFT
        pin_to_sibling_corner   TOP_LEFT
    }

    SelectMapGrid
    {
        ControlName             GridButtonListPanel

		xpos					0
        wide                    680

        pin_to_sibling          SelectMapSubHeader
        pin_corner_to_sibling   TOP_LEFT
        pin_to_sibling_corner   BOTTOM_LEFT

        columns                 2
        rows                    4
        buttonSpacing           12
        scrollbarSpacing        6
        scrollbarOnLeft         0
        selectOnDpadNav         0

        ButtonSettings
        {
            rui                     "ui/custom_match_map_button.rpak"
            clipRui                 1
            wide                    325
            tall                    160
            cursorVelocityModifier  0.7
            bubbleNavEvents         1
            sound_focus             "UI_Menu_Focus"
            sound_accept            "UI_Menu_Accept"
            sound_deny              "UI_Menu_Deny"
        }
    }
}