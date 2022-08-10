"resource/ui/menus/panels/store_inspect_panel.res"
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
        xpos                    -75
        ypos					-75
        wide					1200
        tall					250
        visible				    1
        rui                     "ui/store_inspect_header.rpak"

        pin_to_sibling			PanelFrame
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_LEFT
    }

    ItemGridPanel
    {
        ControlName				CNestedPanel

        xpos					0
        ypos					0
		ypos_nx_handheld		80		[$NX || $NX_UI_PC] 
        zpos                    5
        wide					600
        wide_nx_handheld		750		[$NX || $NX_UI_PC] 
        tall					400
        tall_nx_handheld		500		[$NX || $NX_UI_PC]

        visible					1
        controlSettingsFile		"resource/ui/menus/panels/store_inspect_grid.res"

        pin_to_sibling			InspectHeader
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
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
        rui                     "ui/store_inspect_individual_item_info.rpak"

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

