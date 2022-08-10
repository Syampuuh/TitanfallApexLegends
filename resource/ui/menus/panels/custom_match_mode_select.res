"resource/ui/menus/panels/custom_match_mode_select.res"
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

    SelectModeHeader
    {
        ControlName             RuiPanel

        wide                    500
        wide_nx_handheld        330			[$NX || $NX_UI_PC]
        tall                    48
        tall_nx_handheld        32			[$NX || $NX_UI_PC]
        ypos_nx_handheld        -10			[$NX || $NX_UI_PC]
        clipRui                 1

        rui                     "ui/custom_match_settings_header.rpak"
        ruiArgs
        {
            headerText          "#CUSTOM_MATCH_MODE_SELECT"
        }

        pin_to_sibling          PanelFrame
        pin_corner_to_sibling   TOP_LEFT
        pin_to_sibling_corner   TOP_LEFT
    }

    SelectModeGrid
    {
        ControlName             GridButtonListPanel

		xpos					0
		ypos                    46
        wide                    %100
        tall                    %-140

        pin_to_sibling          SelectModeHeader
        pin_corner_to_sibling   TOP_LEFT
        pin_to_sibling_corner   BOTTOM_LEFT

        columns                 1
        rows                    4
        buttonSpacing           12
        scrollbarSpacing        2
        scrollbarOnLeft         0
        selectOnDpadNav         0

        ButtonSettings
        {
            rui                     "ui/custom_match_mode_button.rpak"
            clipRui                 1
            wide                    480
            wide_nx_handheld        320			[$NX || $NX_UI_PC]
            tall                    170
            tall_nx_handheld        113			[$NX || $NX_UI_PC]
            cursorVelocityModifier  0.7
            bubbleNavEvents         1
            sound_focus             "UI_Menu_Focus"
            sound_accept            "UI_Menu_Accept"
            sound_deny              "UI_Menu_Deny"
        }
    }
}