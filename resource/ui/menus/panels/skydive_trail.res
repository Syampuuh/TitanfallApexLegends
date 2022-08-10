"resource/ui/menus/panels/skydive_trail.res"
{
	PanelFrame
	{
		ControlName				Label
		xpos					0
		ypos					0
		wide					%100
		tall					%100
		labelText				""
		bgcolor_override		"70 70 70 255"
		visible					0
		paintbackground			1
	}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    Header
    {
        ControlName             RuiPanel
        xpos                    194
        xpos_nx_handheld		34   	[$NX || $NX_UI_PC]
        ypos                    50
        zpos                    4
        wide                    550
        tall                    33
        rui                     "ui/character_items_header.rpak"
        visible                 0
    }

    SkydiveTrailList
    {
        ControlName				GridButtonListPanel
        xpos                    194
        xpos_nx_handheld		8		[$NX || $NX_UI_PC]
        ypos                    96
        ypos_nx_handheld		50		[$NX || $NX_UI_PC]
        columns                 1
        rows                    12
        rows_nx_handheld        8		[$NX || $NX_UI_PC]
        buttonSpacing           6
        scrollbarSpacing        6
        scrollbarOnLeft         0
        visible					1
        tabPosition             1
        selectOnDpadNav         1

        ButtonSettings
        {
            rui                     "ui/generic_item_button.rpak"
            clipRui                 1
            wide					350
            wide_nx_handheld		630		[$NX || $NX_UI_PC]
            tall					50
            tall_nx_handheld		85		[$NX || $NX_UI_PC]
            cursorVelocityModifier  0.7
            rightClickEvents		1
			doubleClickEvents       1
            sound_focus             "UI_Menu_Focus_Small"
            sound_accept            ""
            sound_deny              ""
        }
    }

    Video
    {
        ControlName             RuiPanel
        xpos					576
        xpos_nx_handheld		635			[$NX || $NX_UI_PC]
        ypos					71
        ypos_nx_handheld		20			[$NX || $NX_UI_PC] 
        wide                    1022
        wide_nx_handheld        1142		[$NX || $NX_UI_PC]
        tall                    575
        tall_nx_handheld        643			[$NX || $NX_UI_PC]
        visible                 1
        rui                     "ui/finisher_video.rpak"
    }
}