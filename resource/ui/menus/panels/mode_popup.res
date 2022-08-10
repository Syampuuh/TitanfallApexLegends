"resource/ui/menus/panels/mode_popup.res"
{
    PanelFrame
    {
		ControlName				Label
		xpos					0
		ypos					0
		wide					%100
		tall					%100
		labelText				""
		visible				    1
        bgcolor_override        "0 0 255 128"
        paintbackground         0

        proportionalToParent    0
    }

    ModeList
    {
        ControlName				GridButtonListPanel
        xpos                    0
        ypos                    0
        tall                    60
        columns                 1
        rows                    12
        buttonSpacing           0
        scrollbarSpacing        6
        scrollbarOnLeft         0
        visible					1
        ButtonSettings
        {
            rui                     "ui/generic_popup_button.rpak"
            clipRui                 1
            wide					367
			wide_nx_handheld		477		[$NX || $NX_UI_PC]
            tall					60
            tall_nx_handheld		78		[$NX || $NX_UI_PC]
            cursorVelocityModifier  0.7
        }
    }

	ModeModListHeaderText
    {
        ControlName				Label
        InheritProperties		SubheaderText
		xpos					400
		xpos_nx_handheld		0		[$NX || $NX_UI_PC]
		ypos					0
		ypos_nx_handheld		-60		[$NX || $NX_UI_PC]
        labelText				"Playlist Mods:"
    }

	ModeModList
    {
        ControlName				GridButtonListPanel
        xpos                    400
		ypos                    60
        tall                    60
        columns                 1
        rows                    12
        buttonSpacing           0
        scrollbarSpacing        6
        scrollbarOnLeft         0 
        visible					1
        ButtonSettings
        {
            rui                     "ui/generic_popup_button.rpak"
            clipRui                 1
            wide					367
			wide_nx_handheld		477		[$NX || $NX_UI_PC ]
            tall					60
            tall_nx_handheld		78		[$NX || $NX_UI_PC]
            cursorVelocityModifier  0.7
        }
    }
}