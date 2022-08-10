"resource/ui/menus/panels/store_heirloom_shop.res"
{
	PanelFrame
	{
		ControlName				Label
		wide					%100
		tall					%100
		labelText				""
	    bgcolor_override		"0 0 0 192"
		visible					1
		paintbackground			1
        proportionalToParent    1
	}

	CenterFrame
	{
		ControlName				Label
        xpos					0
        ypos					-50
        wide					%100
        tall					670

		labelText				""
	    bgcolor_override		"0 0 0 192"
		visible					1
		paintbackground			1
        proportionalToParent    1

        pin_to_sibling			PanelFrame
        pin_corner_to_sibling	TOP
        pin_to_sibling_corner	TOP
	}

    HeirloomList
    {
        ControlName				GridButtonListPanel
        xpos                    0
        ypos                    0
        columns                 4
        rows                    1
        buttonSpacing           16
        scrollbarSpacing        16
        scrollbarOnLeft         0
        visible					1
        tabPosition             1
        selectOnDpadNav         0
        horizontalScroll        1

        pin_to_sibling			CenterFrame
        pin_corner_to_sibling	CENTER
        pin_to_sibling_corner	CENTER

        ButtonSettings
        {
            rui                     "ui/heirloom_shop_item_button_tall.rpak"
            clipRui                 1
            wide					252
            wide_nx_handheld		277		[$NX || $NX_UI_PC]
            tall					569
            tall_nx_handheld		626		[$NX || $NX_UI_PC]
            cursorVelocityModifier  0.7
            rightClickEvents		1
            doubleClickEvents       1
			middleClickEvents       1
            sound_focus             "UI_Menu_Focus_Small"
            sound_accept            "UI_Menu_Accept"
            sound_deny              ""
        }
    }

    MythicList
    {
        ControlName				GridButtonListPanel
        xpos                    0
        ypos                    0
        columns                 1
        rows                    1
        buttonSpacing           16
        scrollbarSpacing        16
        scrollbarOnLeft         0
        visible					1
        tabPosition             1
        selectOnDpadNav         0
        horizontalScroll        1

        pin_to_sibling			CenterFrame
        pin_corner_to_sibling	CENTER
        pin_to_sibling_corner	CENTER

        ButtonSettings
        {
            rui                     "ui/heirloom_shop_item_button_mythic.rpak"
            clipRui                 1
            wide					569
            wide_nx_handheld		544	[$NX || $NX_UI_PC]
            tall					569
            tall_nx_handheld		626		[$NX || $NX_UI_PC]
            cursorVelocityModifier  0.7
            rightClickEvents		1
            doubleClickEvents       1
            middleClickEvents       1
            sound_focus             "UI_Menu_Focus_Small"
            sound_accept            "UI_Menu_Accept"
            sound_deny              ""
        }
    }

	WeaponSkinToggle
	{
	    ControlName			RuiButton

	    pin_to_sibling			PanelFrame
	    pin_corner_to_sibling	BOTTOM_RIGHT
	    pin_to_sibling_corner	BOTTOM
	    xpos					-70
	    ypos					-260
	    zpos                    100
	    wide					450
	    tall					60

        visible                 1
	    rui					    "ui/heirloom_shop_weapon_skin_button.rpak"

		sound_accept            "UI_Menu_StoreTab_Toggle"
	}

	InfoBoxOld
	{
	    ControlName				RuiPanel

	    pin_to_sibling			CenterFrame
	    pin_corner_to_sibling	TOP_LEFT
	    pin_to_sibling_corner	TOP_LEFT
	    xpos					0
	    ypos					-48
		ypos_nx_handheld		-12			[$NX || $NX_UI_PC]
	    wide					628
	    tall					370
	    tall_nx_handheld		392			[$NX || $NX_UI_PC]

        visible                 0
	    rui					    "ui/heirloom_shop_info_box.rpak"
	}

	InfoBox
	{
	    ControlName				RuiPanel

        pin_to_sibling			WeaponSkinToggle
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
	    xpos					90
	    ypos					0
	    wide					400
	    tall					108

        visible                 1
	    rui					    "ui/heirloom_shop_info_box_v3.rpak"
	}

	MoreInfoButton
	{
		ControlName				RuiButton
        classname               "MenuButton"

        pin_to_sibling			WeaponSkinToggle
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
        xpos					520
        ypos					-10
        wide					200
        wide_nx_handheld		400		[$NX || $NX_UI_PC]
        tall					42
        tall_nx_handheld		84		[$NX || $NX_UI_PC]

        visible                 1
        rui					    "ui/collection_event_about_button.rpak"
	}

	OfferButton1
	{
		ControlName				RuiButton
        classname               "MenuButton"

        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling			InfoBox
        pin_to_sibling_corner	TOP_RIGHT
		xpos					42
		xpos_nx_handheld		25			[$NX || $NX_UI_PC]
		ypos                    0
		wide					580
		wide_nx_handheld		613			[$NX || $NX_UI_PC]
		tall					370
		tall_nx_handheld		392			[$NX || $NX_UI_PC]

        visible                 0
        rui					    "ui/heirloom_shop_item_button.rpak"
        rightClickEvents		1
        navLeft                 OfferButton5
        navRight                OfferButton2
        navDown                 OfferButton3
	}

	OfferButton2
	{
		ControlName				RuiButton
        classname               "MenuButton"

        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling			OfferButton1
        pin_to_sibling_corner	TOP_RIGHT
		xpos					42
		xpos_nx_handheld		25			[$NX || $NX_UI_PC]
		ypos                    0
		wide					580
		wide_nx_handheld		613			[$NX || $NX_UI_PC]
		tall					370
		tall_nx_handheld		392			[$NX || $NX_UI_PC]

        visible                 0
        rui					    "ui/heirloom_shop_item_button.rpak"
        rightClickEvents		1
        navLeft                 OfferButton1
        navDown                 OfferButton4
	}

	OfferButton3
	{
		ControlName				RuiButton
        classname               "MenuButton"

        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling			OfferButton1
        pin_to_sibling_corner	BOTTOM_LEFT
		xpos					0
		xpos_nx_handheld		25			[$NX || $NX_UI_PC]
		ypos                    42
		ypos_nx_handheld        0			[$NX || $NX_UI_PC]
		wide					580
		wide_nx_handheld		613			[$NX || $NX_UI_PC]
		tall					370
		tall_nx_handheld		392			[$NX || $NX_UI_PC]

        visible                 0
        rui					    "ui/heirloom_shop_item_button.rpak"
        rightClickEvents		1
        navLeft                 OfferButton5
        navRight                OfferButton4
        navUp                   OfferButton1
	}

	OfferButton4
	{
		ControlName				RuiButton
        classname               "MenuButton"

        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling			OfferButton3
        pin_to_sibling_corner	TOP_RIGHT
		xpos					42
		xpos_nx_handheld		25			[$NX || $NX_UI_PC]
		ypos                    0
		wide					580
		wide_nx_handheld		613			[$NX || $NX_UI_PC]
		tall					370
		tall_nx_handheld		392			[$NX|| $NX_UI_PC]

        visible                 0
        rui					    "ui/heirloom_shop_item_button.rpak"
        rightClickEvents		1
        navLeft                 OfferButton3
        navUp                   OfferButton2
	}

	OfferButton5
	{
		ControlName				RuiButton
        classname               "MenuButton"

        pin_corner_to_sibling	TOP_RIGHT
        pin_to_sibling			InfoBox
        pin_to_sibling_corner	BOTTOM_RIGHT
		xpos					0
		ypos                   	42
		ypos_nx_handheld        25			[$NX || $NX_UI_PC]
		wide					580
		wide_nx_handheld		613			[$NX || $NX_UI_PC]
		tall					370
		tall_nx_handheld		392			[$NX || $NX_UI_PC]

        visible                 0
        rui					    "ui/heirloom_shop_item_button.rpak"
        rightClickEvents		1
        navRight                OfferButton3
        navUp					OfferButton1
	}
}

