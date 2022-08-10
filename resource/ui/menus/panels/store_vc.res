"resource/ui/menus/panels/store_vc.res"
{
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

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

    BackgroundPanel
    {
        ControlName				RuiPanel
        wide					1800
        tall					1000
        visible					1
        rui                     "ui/vc_pop_up_frame.rpak"
        xpos                    0
        ypos                    0

        pin_to_sibling			PanelFrame
        pin_corner_to_sibling	CENTER
        pin_to_sibling_corner	CENTER
    }

	VCButton1
	{
		ControlName			RuiButton
		scriptId            0
		xpos			    "%-50"
		xpos_nx_handheld    -2     		[$NX || $NX_UI_PC]
		ypos			    -60
		ypos_nx_handheld    -135     	[$NX || $NX_UI_PC]
		zpos			    4
		wide			    337
		wide_nx_handheld    300     	[$NX || $NX_UI_PC]
		tall			    318
		tall_nx_handheld    362     	[$NX || $NX_UI_PC]
		visible			    1
		enabled             0
        rui					"ui/store_small_button_vc.rpak"
        cursorVelocityModifier  0.7
		proportionalToParent	1

		tabPosition             1

		navRight                			VCButton3
		navDown                 			VCButton2

        pin_to_sibling						PanelFrame
        pin_corner_to_sibling				TOP_LEFT
        pin_to_sibling_corner				TOP
        pin_to_sibling_corner_nx_handheld 	TOP_LEFT     [$NX || $NX_UI_PC]
	}

	VCButton2
	{
		ControlName			RuiButton
		scriptId            1
		xpos			    0
	    xpos_nx_handheld    0     		[$NX || $NX_UI_PC]
		ypos			    10
		zpos			    4
		wide			    337
		wide_nx_handheld    300     	[$NX || $NX_UI_PC]
		tall			    318
		tall_nx_handheld    362     	[$NX || $NX_UI_PC]
		visible			    1
		enabled             0
        rui					"ui/store_small_button_vc.rpak"
        cursorVelocityModifier  0.7
		proportionalToParent	1

		tabPosition             1

		navRight                			VCButton3
		navUp                    			VCButton1

        pin_to_sibling						VCButton1
        pin_corner_to_sibling				TOP_LEFT
        pin_to_sibling_corner				BOTTOM_LEFT
	}

	VCButton1Tall
    {
        ControlName			RuiButton
        scriptId            0
        xpos			    "%-50"
        xpos_nx_handheld    4     		[$NX || $NX_UI_PC]
        ypos			    -60
        ypos_nx_handheld    -135     	[$NX || $NX_UI_PC]
        zpos			    4
        wide			    337
        wide_nx_handheld    358     	[$NX || $NX_UI_PC]
        tall			    646
        tall_nx_handheld    760     	[$NX || $NX_UI_PC]
        visible			    0
        enabled             0
        rui					"ui/store_button_vc.rpak"
        cursorVelocityModifier  0.7
        proportionalToParent	1

        tabPosition             1

        navRight                			VCButton3

        pin_to_sibling						PanelFrame
        pin_corner_to_sibling				TOP_LEFT
        pin_to_sibling_corner				TOP
        pin_to_sibling_corner_nx_handheld 	TOP_LEFT     [$NX || $NX_UI_PC]
    }

	VCButton3
	{
		ControlName			RuiButton
		scriptId            2
		xpos			    10
		xpos_nx_handheld    21    		[$NX || $NX_UI_PC]
		ypos			    0
		zpos			    4
		wide			    337
		wide_nx_handheld    318    		[$NX || $NX_UI_PC]
		tall			    646
		tall_nx_handheld    732    		[$NX || $NX_UI_PC]
		visible			    1
		enabled             0
        rui					"ui/store_button_vc.rpak"
        cursorVelocityModifier  0.7
		proportionalToParent	1

        navLeft                 VCButton1
		navRight                VCButton4

        pin_to_sibling          VCButton1
        pin_corner_to_sibling   TOP_LEFT
        pin_to_sibling_corner   TOP_RIGHT
	}

	VCButton4
	{
		ControlName			RuiButton
		scriptId            3
		xpos			    0
		xpos_nx_handheld    21     		[$NX || $NX_UI_PC]
		ypos			    -60
		ypos_nx_handheld    0      		[$NX || $NX_UI_PC]
		zpos			    4
		wide			    337
		wide_nx_handheld    318    		[$NX || $NX_UI_PC]
		tall			    646
		tall_nx_handheld    732    		[$NX || $NX_UI_PC]
		visible			    1
		enabled             0
        rui					"ui/store_button_vc.rpak"
        cursorVelocityModifier  0.7
		proportionalToParent	1

        navLeft                 VCButton3
		navRight                VCButton5

        pin_to_sibling          			PanelFrame
        pin_to_sibling_nx_handheld          VCButton3   [$NX || $NX_UI_PC]
        pin_corner_to_sibling   			TOP
        pin_corner_to_sibling_nx_handheld   TOP_LEFT    [$NX || $NX_UI_PC]
        pin_to_sibling_corner   			TOP
        pin_to_sibling_corner_nx_handheld   TOP_RIGHT   [$NX || $NX_UI_PC]
	}

	VCButton5
	{
		ControlName			RuiButton
		scriptId            4
		xpos			    10
		xpos_nx_handheld    21     		[$NX || $NX_UI_PC]
		ypos			    0
		zpos			    4
		wide			    337
		wide_nx_handheld    318    		[$NX || $NX_UI_PC]
		tall			    646
		tall_nx_handheld    732    		[$NX || $NX_UI_PC]
		visible			    1
		enabled             0
        rui					"ui/store_button_vc.rpak"
        cursorVelocityModifier  0.7
		proportionalToParent	1

        navLeft                 VCButton4
		navRight                VCButton6

        pin_to_sibling          			VCButton4
        pin_to_sibling_nx_handheld			VCButton4   [$NX || $NX_UI_PC]
        pin_corner_to_sibling   			TOP_LEFT
        pin_to_sibling_corner   			TOP_RIGHT
	}

	VCButton6
	{
		ControlName			RuiButton
		scriptId            5
		xpos			    "%50"
		xpos_nx_handheld    -2			[$NX || $NX_UI_PC]
		ypos			    -60
		ypos_nx_handheld    -135		[$NX || $NX_UI_PC]
		zpos			    4
		wide			    337
		wide_nx_handheld    318    		[$NX || $NX_UI_PC]
		tall			    646
		tall_nx_handheld    732    		[$NX || $NX_UI_PC]
		visible			    1
		enabled             0
        rui					"ui/store_button_vc.rpak"
        cursorVelocityModifier  0.7
		proportionalToParent	1

        navLeft                 VCButton5

        pin_to_sibling          			PanelFrame
        pin_corner_to_sibling   			TOP_RIGHT
        pin_to_sibling_corner   			TOP
		pin_to_sibling_corner_nx_handheld   TOP_RIGHT    [$NX || $NX_UI_PC]
	}

	DiscountPanel
	{
		ControlName				RuiPanel
		ypos                    5 [$PS4] // Avoid overlapping the PS Store banner
		ypos                    20 [!$PS4]
		wide					900
		tall					132
		visible					1
        rui                     "ui/store_discount_panel.rpak"

        proportionalToParent    1

        pin_to_sibling			VCButton3
        pin_corner_to_sibling	TOP
        pin_to_sibling_corner	BOTTOM
	}
	
	TaxNoticeMessage [$NX]
	{
		ControlName				Label
		labelText				""
		ypos					24
		wide					800
		tall					81
		visible					0
		fontHeight				42
		textAlignment			center

		pin_to_sibling			VCButton3
		pin_corner_to_sibling	TOP
		pin_to_sibling_corner	BOTTOM
	}
}
