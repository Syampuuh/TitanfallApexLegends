"resource/ui/menus/panels/weapon_skins.res"
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

    WeaponName
    {
        ControlName				RuiPanel
        xpos					92
        ypos					16
        ypos_nx_handheld		0		[$NX || $NX_UI_PC]
        wide					900
        tall					78
        rui                     "ui/weapon_name.rpak"
    }

    Owned
    {
        ControlName             RuiPanel
        xpos                    92
        ypos                    100
        ypos_nx_handheld        75		[$NX || $NX_UI_PC]
        wide                    550
        wide_nx_handheld        633		[$NX || $NX_UI_PC]
        tall                    33
        tall_nx_handheld        38		[$NX || $NX_UI_PC]
        rui                     "ui/character_items_header.rpak"
    }

    WeaponSkinList
    {
        ControlName				GridButtonListPanel
        xpos                    92
        ypos                    151
        ypos_nx_handheld        136		[$NX || $NX_UI_PC]
        columns                 1
        rows                    11
        rows_nx_handheld        7		[$NX || $NX_UI_PC]
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
            tall_nx_handheld		85   [$NX || $NX_UI_PC ]
            cursorVelocityModifier  0.7
            rightClickEvents		1
            doubleClickEvents       1
			middleClickEvents       1
            sound_focus             "UI_Menu_Focus_Small"
            sound_accept            ""
            sound_deny              ""
        }
    }

//    RefFrame
//    {
//        ControlName				Label
//        xpos					364 //637
//        ypos					151
//        wide					1095
//        tall					514
//        labelText				""
//        bgcolor_override		"0 0 0 80"
//        visible					1
//        paintbackground			1
//    }

    ModelRotateMouseCapture
    {
        ControlName				CMouseMovementCapturePanel
        xpos                    610
        ypos                    0
        wide                    1340
        tall                    %100
    }


    ActionButton
    {
        ControlName				RuiButton
        classname               "MenuButton"
        wide					280
        wide_nx_handheld		420			[$NX || $NX_UI_PC]
        tall					110
        tall_nx_handheld		150			[$NX || $NX_UI_PC]
        xpos                    -28
        ypos                    -25
        rui                     "ui/generic_loot_button.rpak"
        labelText               ""
        visible					1
        cursorVelocityModifier  0.7

        pin_to_sibling			PanelFrame
        pin_corner_to_sibling	BOTTOM_RIGHT
        pin_to_sibling_corner	BOTTOM_RIGHT
    }


    CharmsButton
    {
        ControlName				RuiButton
         classname               "MenuButton"
         wide					280
         wide_nx_handheld		420			[$NX || $NX_UI_PC]
         tall					110
         tall_nx_handheld		150			[$NX || $NX_UI_PC]
         xpos                    -28
         ypos                    -25
         rui                     "ui/generic_loot_button.rpak"
         labelText               ""
         visible					0
         enabled                 0

         cursorVelocityModifier  0.7

         pin_to_sibling			PanelFrame
         pin_corner_to_sibling	TOP_RIGHT
         pin_to_sibling_corner	TOP_RIGHT
     }
 }