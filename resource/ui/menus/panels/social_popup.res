resource/ui/menus/panels/social_popup.res
{
	Content
	{
		ControlName				RuiPanel
		xpos					0
		ypos					0
		wide					560
		tall					184
		rui                     "ui/social_popup.rpak"
		visible					1
	}

    AcceptButton
    {
        ControlName				RuiButton
        wide					150
        tall					50
        ypos                    0
        xpos                    -85
        zpos                    20
        rui                     "ui/social_popup_button.rpak"

        labelText               ""
        visible					1
        cursorVelocityModifier  0.7

        pin_to_sibling			Content
        pin_corner_to_sibling	BOTTOM_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
    }

    RejectButton
    {
        ControlName				RuiButton
        wide					150
        tall					50
        ypos                    0
        xpos                    -243
        zpos                    20
        rui                     "ui/social_popup_button.rpak"

        labelText               ""
        visible					1
        cursorVelocityModifier  0.7

        pin_to_sibling			Content
        pin_corner_to_sibling	BOTTOM_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
    }

    BlockButton
    {
        ControlName				RuiButton
        wide					150
        tall					50
        ypos                    0
        xpos                    -400
        zpos                    20
        rui                     "ui/social_popup_button.rpak"

        labelText               ""
        visible					1
        cursorVelocityModifier  0.7

        pin_to_sibling			Content
        pin_corner_to_sibling	BOTTOM_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
    }
}