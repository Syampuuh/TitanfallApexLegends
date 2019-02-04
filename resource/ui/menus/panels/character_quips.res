"resource/ui/menus/panels/character_quips.res"
{
    PanelFrame
    {
		ControlName				Label
		wide					%100
		tall					%100
		labelText				""
		visible				    0
        bgcolor_override        "0 0 0 0"
        paintbackground         1
    }

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    Header
    {
        ControlName             RuiPanel
        xpos                    22
        ypos                    64
        zpos                    4
        wide                    550
        tall                    33
        rui                     "ui/character_items_header.rpak"
    }

	SectionButton0
	{
		ControlName			RuiButton
		xpos			    24
		ypos			    121
		zpos			    3
		wide			    236
		tall			    64
		visible			    0
		labelText           ""
        rui					"ui/prototype_left_nav_button.rpak"
        cursorVelocityModifier  0.7
	}

	SectionButton1
	{
		ControlName			RuiButton
		xpos			    0
		//ypos			    16
		zpos			    3
		wide			    236
		tall			    64
		visible			    0
		labelText           ""
        rui					"ui/prototype_left_nav_button.rpak"
        cursorVelocityModifier  0.7

        pin_to_sibling			SectionButton0
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
	}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    IntroQuipsPanel
    {
        ControlName				CNestedPanel
        xpos					294
        ypos					121
        wide					1408
        tall					840
        visible					1
        controlSettingsFile		"resource/ui/menus/panels/quips.res"
    }

    KillQuipsPanel
    {
        ControlName				CNestedPanel
        xpos					294
        ypos					121
        wide					1408
        tall					840
        visible					1
        controlSettingsFile		"resource/ui/menus/panels/quips.res"
    }
}