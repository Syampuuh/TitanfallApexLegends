"resource/ui/menus/panels/store_mythic_inspect_panel.res"
{
	PanelFrame
	{
		ControlName				Label
		wide					%100
		tall					%100
		labelText				""
	    bgcolor_override		"70 70 0 128"
		visible					0
		paintbackground			1
	    proportionalToParent    1
	}

	CenterFrame
	{
		ControlName				Label
        xpos					0
        ypos					0
        wide					1920
		tall					%100
		labelText				""
	    bgcolor_override		"70 30 70 64"
		visible					0
		paintbackground			1
        proportionalToParent    1

        pin_to_sibling			PanelFrame
        pin_corner_to_sibling	TOP
        pin_to_sibling_corner	TOP
	}

    InspectHeader
    {
        ControlName				RuiPanel
        xpos                    -125
        ypos					-75
        wide					1200
        tall					250
        visible				    1
        rui                     "ui/store_mythic_inspect_header.rpak"

        pin_to_sibling			PanelFrame
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_LEFT
    }

	MythicOwned
	{
		ControlName				RuiPanel
        xpos                    -5
        ypos					-46
        wide					512
        tall					152
        visible				    1
        rui                     "ui/store_mythic_owned_indicator.rpak"

        pin_to_sibling			InspectHeader
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
	}

    MythicInspectButton0
    {
        ControlName			    RuiButton
        xpos					-31
        ypos					-20
        zpos					6
        wide					100
        tall					100
        visible					1
        enabled					1
        textAlignment			left
        labelText 				""
        rui						"ui/store_mythic_inspect_button.rpak"
        cursorVelocityModifier  0.7
        scriptID				0

        pin_to_sibling			InspectHeader
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
    }

    MythicInspectButton1
    {
        ControlName			    RuiButton
        xpos					20
        ypos					0
        zpos					5
        wide					100
        tall					100
        visible					1
        enabled					1
        textAlignment			left
        labelText 				""
        rui						"ui/store_mythic_inspect_button.rpak"
        cursorVelocityModifier  0.7
        scriptID				1

        pin_to_sibling			MythicInspectButton0
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
    }

    MythicInspectButton2
    {
        ControlName			    RuiButton
        xpos					20
        ypos					0
        zpos					4
        wide					100
        tall					100
        visible					1
        enabled					1
        textAlignment			left
        labelText 				""
        rui						"ui/store_mythic_inspect_button.rpak"
        cursorVelocityModifier  0.7
        scriptID				2

        pin_to_sibling			MythicInspectButton1
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
    }

    MythicInspectButton3
    {
        ControlName			    RuiButton
        xpos					20
        ypos					0
        zpos					3
        wide					100
        tall					100
        visible					1
        enabled					1
        textAlignment			left
        labelText 				""
        rui						"ui/store_mythic_inspect_button.rpak"
        cursorVelocityModifier  0.7
        scriptID				3

        pin_to_sibling			MythicInspectButton2
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
    }

    DiscountInfo
    {
        ControlName				RuiPanel
        ypos					-225
        xpos                    -65
        wide					600
        tall					60
        visible				    1
        rui                     "ui/store_inspect_discount_info.rpak"

        pin_to_sibling			PanelFrame
        pin_corner_to_sibling	BOTTOM_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
    }

    PurchaseOfferButton
    {
        ControlName			    RuiButton
        xpos					0
        ypos					0
        zpos					2
        wide					100
        tall					100
        visible					1
        enabled					1
        style					RuiButton
        textAlignment			left
        labelText 				""
        rui						"ui/store_inspect_grid_button.rpak"
        cursorVelocityModifier  0.7

        pin_to_sibling			DiscountInfo
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
    }

    PurchaseOfferButton
    {
        ControlName			    RuiButton
        classname               "MenuButton"

        xpos				    0
        ypos				    16
        wide				    600
        tall				    100
        cursorVelocityModifier  0.7
        visible                 1
        tabPosition             1

        rui					    "ui/store_inspect_purchase_button.rpak"
        sound_focus             "UI_Menu_Focus_Large"

        pin_to_sibling			DiscountInfo
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
    }

    PurchaseLimit
    {
        ControlName				RuiPanel
        ypos					10
        wide					350
        tall					50
        visible				    1
        rui                     "ui/store_inspect_limit.rpak"

        pin_to_sibling			PurchaseOfferButton
        pin_corner_to_sibling	TOP
        pin_to_sibling_corner	BOTTOM
    }

    IndividualItemInfo
    {
        ControlName				RuiPanel
        xpos                    -75
        ypos					-75
        wide					500
        wide_nx_handheld		625		[$NX || $NX_UI_PC]
        tall					300
        tall_nx_handheld		375		[$NX || $NX_UI_PC]
        visible				    1
        rui                     "ui/store_inspect_mythic_item_info.rpak"

        pin_to_sibling			PanelFrame
        pin_corner_to_sibling	BOTTOM_RIGHT
        pin_to_sibling_corner	BOTTOM_RIGHT
    }

    LoadscreenImage
    {
        ControlName             RuiPanel
        xpos					-75
        ypos					0
        wide                    650
        tall                    365
        visible                 0
        rui                     "ui/custom_loadscreen_image.rpak"

        pin_to_sibling			PanelFrame
        pin_corner_to_sibling	RIGHT
        pin_to_sibling_corner	RIGHT
    }
}

