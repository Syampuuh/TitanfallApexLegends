"resource/ui/menus/panels/music_packs.res"
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

    MusicPackList
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
            middleClickEvents       1
            sound_focus             "UI_Menu_Focus_Small"
            sound_accept            ""
            sound_deny              ""
        }
    }

    Preview
    {
        ControlName             RuiPanel
        xpos					760
        xpos_nx_handheld		700				[$NX || $NX_UI_PC]
        ypos					200
        ypos_nx_handheld		50				[$NX || $NX_UI_PC]
        wide                    624//780
        wide_nx_handheld        1022			[$NX || $NX_UI_PC]
        tall                    332//416
        tall_nx_handheld        544				[$NX || $NX_UI_PC]
        visible                 1
        rui                     "ui/loot_reward_intro_quip.rpak"
    }
}