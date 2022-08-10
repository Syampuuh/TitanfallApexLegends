"resource/ui/menus/panels/character_skins.res"
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
		proportionalToParent    1
	}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    Header
    {
        ControlName             RuiPanel
        xpos                    194
        ypos                    50
        zpos                    4
        wide                    550
        tall                    33
        rui                     "ui/character_items_header.rpak"
    }

    SkinBlurb
    {
        ControlName             RuiPanel
        xpos                    0
        ypos                    -50
        zpos                    0
        wide                    308
        wide_nx_handheld        380		[$NX || $NX_UI_PC]
        tall                    308
        tall_nx_handheld        380		[$NX || $NX_UI_PC]
        rui                     "ui/character_skin_blurb.rpak"
        visible                 0

        pin_to_sibling			PanelFrame
        pin_corner_to_sibling	TOP_RIGHT
        pin_to_sibling_corner	TOP_RIGHT
    }

	MythicSkinInfo
	{
		ControlName             RuiPanel
		xpos                    0
		ypos                    -50
		zpos                    0
		wide                    308
		wide_nx_handheld        380		[$NX || $NX_UI_PC]
		tall                    250
		tall_nx_handheld        370		[$NX || $NX_UI_PC]
		rui                     "ui/character_mythin_skin_info.rpak"
		visible                 0

		pin_to_sibling			PanelFrame
		pin_corner_to_sibling	TOP_RIGHT
		pin_to_sibling_corner	TOP_RIGHT
	}

    MythicSkinLeftButton
    {
        ControlName             RuiButton
        xpos                    -25
        xpos_nx_handheld        -40		[$NX || $NX_UI_PC]
        wide					54
        wide_nx_handheld		80		[$NX || $NX_UI_PC]
        tall					54
        tall_nx_handheld		70		[$NX || $NX_UI_PC]
        ypos                    0
        visible			        0
        zpos 100

        rui					    "ui/mythin_skin_info_arrow_button.rpak"
        ruiArgs
        {
            isRightOption       0
        }

        cursorVelocityModifier  0.5
        cursorPriority          1
        pin_to_sibling			MythicSkinInfo
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT

        navRight                MythicSkinRightButton
    }

    MythicSkinSelection
    {
        ControlName				RuiButton
        xpos                    30
        ypos_nx_handheld		10 		[$NX || $NX_UI_PC]
        wide					140
        wide_nx_handheld		147		[$NX || $NX_UI_PC]
        tall					54
        tall_nx_handheld		70		[$NX || $NX_UI_PC]
        visible					0
        rui					    "ui/mythin_skin_info_selection.rpak"
        sound_accept            ""

        cursorVelocityModifier  0.7
        pin_to_sibling			MythicSkinLeftButton
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
    }

    MythicSkinRightButton
    {
        ControlName             RuiButton
        xpos                    25
        ypos_nx_handheld		-10		[$NX || $NX_UI_PC]      
        wide					54
        wide_nx_handheld		80		[$NX || $NX_UI_PC]
        tall					54
        tall_nx_handheld		70		[$NX || $NX_UI_PC]
        visible			        1
        zpos 100

        rui					    "ui/mythin_skin_info_arrow_button.rpak"
        ruiArgs
        {
            isRightOption       1
        }

        cursorVelocityModifier  0.5
        cursorPriority          1
        pin_to_sibling			MythicSkinSelection
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT

        navLeft                 MythicSkinLeftButton
    }

    CharacterSkinList
    {
        ControlName				GridButtonListPanel
        xpos                    194
        xpos_nx_handheld        35  [$NX || $NX_UI_PC]
        ypos                    96
        columns                 1
        rows                    12
        rows_nx_handheld        7   [$NX || $NX_UI_PC]
        buttonSpacing           6
        buttonSpacing_nx_handheld   10  [$NX || $NX_UI_PC]
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
            wide_nx_handheld		630  [$NX || $NX_UI_PC]
            tall					50
            tall_nx_handheld		85   [$NX || $NX_UI_PC]
            cursorVelocityModifier  0.7
            rightClickEvents		1
			doubleClickEvents       1
			middleClickEvents       1
            sound_focus             "UI_Menu_Focus_Small"
            sound_accept            ""
            sound_deny              ""
        }
    }

    ModelRotateMouseCapture
    {
        ControlName				CMouseMovementCapturePanel
        xpos                    700
        ypos                    0
        wide                    1340
        tall                    %100
    }

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    ActionButton
    {
        ControlName				RuiButton
        classname               "MenuButton"
        wide					280
        wide_nx_handheld        420			[$NX || $NX_UI_PC]
        tall					110
        tall_nx_handheld		150			[$NX || $NX_UI_PC]
        xpos                    -28
        xpos_nx_handheld        38			[$NX || $NX_UI_PC]
        ypos                    -25
        ypos_nx_handheld        -38			[$NX || $NX_UI_PC]
        rui                     "ui/generic_loot_button.rpak"
        labelText               ""
        visible					1
        cursorVelocityModifier  0.7

        pin_to_sibling			PanelFrame
        pin_corner_to_sibling	BOTTOM_RIGHT
        pin_to_sibling_corner	BOTTOM_RIGHT
    }

	EquipMythicButton
	{
	    ControlName				RuiButton
	    classname               "MenuButton"
	    wide					280
	    wide_nx_handheld        420			[$NX || $NX_UI_PC]
	    tall					110
	    tall_nx_handheld		150			[$NX || $NX_UI_PC]
	    xpos                    -28
	    xpos_nx_handheld        38			[$NX || $NX_UI_PC]
	    ypos                    -25
	    ypos_nx_handheld        -38			[$NX || $NX_UI_PC]
	    rui                     "ui/generic_loot_button.rpak"
	    labelText               ""
	    visible					0

	    cursorVelocityModifier  0.7
	    pin_to_sibling			PanelFrame
	    pin_corner_to_sibling	BOTTOM_RIGHT
	    pin_to_sibling_corner	BOTTOM_RIGHT
	}

    EquipHeirloomButton
    {
        ControlName             RuiButton
        classname               "MenuButton"
        wide                    280
        wide_nx_handheld        420			[$NX || $NX_UI_PC]
        tall                    110
        tall_nx_handheld		150			[$NX || $NX_UI_PC]
        ypos                    6
        rui                     "ui/generic_loot_button.rpak"
        labelText               ""
        visible                 1
        cursorVelocityModifier  0.7

        pin_to_sibling			ActionButton
        pin_corner_to_sibling	BOTTOM_RIGHT
        pin_to_sibling_corner	TOP_RIGHT
    }

    TrackMythicButton
    {
        ControlName             RuiButton
        classname               "MenuButton"
        wide					280
        wide_nx_handheld        420			[$NX || $NX_UI_PC]
        tall					110
        tall_nx_handheld		150			[$NX || $NX_UI_PC]
        xpos                    -28
        xpos_nx_handheld        38			[$NX || $NX_UI_PC]
        ypos                    -25
        ypos_nx_handheld        -38			[$NX || $NX_UI_PC]
        rui                     "ui/generic_loot_button.rpak"
        labelText               ""
        visible					1
        cursorVelocityModifier  0.7

        pin_to_sibling			PanelFrame
        pin_corner_to_sibling	BOTTOM_RIGHT
        pin_to_sibling_corner	BOTTOM_RIGHT
    }

}