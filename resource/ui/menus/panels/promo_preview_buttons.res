"resource/ui/menus/panels/dialog_footer_buttons.res"
{
	PanelFrame
    {
        ControlName				Label
        xpos					0
        ypos					0
        wide					%100
        tall					%100
        labelText				""
        bgcolor_override		"70 30 30 255"
        visible					0
        paintbackground			1
        proportionalToParent    1
    }

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	PromoPreviewButton0
	{
		ControlName				RuiButton
        rui						"ui/promo_page_preview.rpak"
        wide                    240
        tall					135
        xpos                    0
        font                    Default_28
        labelText				"DEFAULT"
        enabled					1
        visible					1

		scriptID				0
		pin_to_sibling			PinFrame
		pin_corner_to_sibling	BOTTOM_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}
	PromoPreviewButton1
	{
		ControlName				RuiButton
        rui						"ui/promo_page_preview.rpak"
        wide                    240
        tall					135
        xpos                    2
        font                    Default_28
        labelText				"DEFAULT"
        enabled					1
        visible					1

		scriptID				1
		pin_to_sibling			PromoPreviewButton0
		pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
	}
	PromoPreviewButton2
    {
        ControlName				RuiButton
        rui						"ui/promo_page_preview.rpak"
        wide                    240
        tall					135
        xpos                    2
        font                    Default_28
        labelText				"DEFAULT"
        enabled					1
        visible					1

        scriptID				2
        pin_to_sibling			PromoPreviewButton1
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
    }

    PromoPreviewButton3
    {
        ControlName				RuiButton
        rui						"ui/promo_page_preview.rpak"
        wide                    240
        tall					135
        xpos                    2
        font                    Default_28
        labelText				"DEFAULT"
        enabled					1
        visible					1

        scriptID				3
        pin_to_sibling			PromoPreviewButton2
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
    }
}