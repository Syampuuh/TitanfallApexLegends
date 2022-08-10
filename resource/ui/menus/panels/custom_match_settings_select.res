"resource/ui/menus/panels/custom_match_settings_select.res"
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

    SelectSettingsHeader
    {
        ControlName             RuiPanel

        wide                    1280
        wide_nx_handheld        1390 		[$NX || $NX_UI_PC]
        tall                    48
        clipRui                 1

        rui                     "ui/custom_match_settings_header.rpak"
        ruiArgs
        {
            headerText          "#CUSTOM_MATCH_SETTINGS_SELECT"
        }

        pin_to_sibling          PanelFrame
        pin_corner_to_sibling   TOP_LEFT
        pin_to_sibling_corner   TOP_LEFT
    }

    MapSelectPanel
    {
        ControlName				CNestedPanel
        xpos					0
        ypos					0
        wide                    680
        tall					772
        visible					1
        enabled 				1

        pin_to_sibling			SelectSettingsHeader
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT

        controlSettingsFile     "resource/ui/menus/panels/custom_match_map_select.res"
    }

    OptionsSelectPanel
    {
        ControlName				CNestedPanel
        xpos					0
        xpos_nx_handheld			40		[$NX || $NX_UI_PC]
        ypos					0
        wide                    590
        wide_nx_handheld			740			[$NX || $NX_UI_PC]
        tall					632
        visible					1
        enabled 				1

        pin_to_sibling			SelectSettingsHeader
        pin_corner_to_sibling	TOP_RIGHT
        pin_to_sibling_corner	BOTTOM_RIGHT

        controlSettingsFile     "resource/ui/menus/panels/custom_match_options_select.res"
    }

    SubmitButton
    {
		ControlName				RuiButton
        classname               "MenuButton"
        xpos                    10
        wide					290
        tall					80

        pin_to_sibling          CancelButton
        pin_corner_to_sibling   RIGHT
        pin_to_sibling_corner   LEFT

        rui                     "ui/generic_button.rpak"
        ruiArgs
        {
            buttonText          "#APPLY"
        }
    }

    CancelButton
    {
		ControlName				RuiButton
        classname               "MenuButton"
        ypos                    10
        wide					290
        tall					80

        pin_to_sibling          OptionsSelectPanel
        pin_corner_to_sibling   TOP_RIGHT
        pin_to_sibling_corner   BOTTOM_RIGHT

        rui                     "ui/generic_button.rpak"
        ruiArgs
        {
            buttonText          "#CANCEL"
        }
    }
}