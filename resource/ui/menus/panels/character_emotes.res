"resource/ui/menus/panels/character_emotes.res"
{
    PanelFrame
    {
		ControlName				Label
		wide					%100
		tall					%100
		labelText				""
        bgcolor_override        "0 0 0 0"
		visible				    0
        paintbackground         1
    }

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    Header
    {
        ControlName             RuiPanel
        xpos                    163 //22
        ypos                    64
        zpos                    4
        wide                    550
        tall                    33
        rui                     "ui/character_items_header.rpak"
    }

	SectionButton0
	{
		ControlName			    RuiButton
        xpos				    123
        xpos_nx_handheld	    0			[$NX || $NX_UI_PC]
        ypos				    96
        ypos_nx_handheld	    55			[$NX || $NX_UI_PC]
		zpos			        3
		wide			        296
		wide_nx_handheld        376			[$NX || $NX_UI_PC]
		tall			        56
		tall_nx_handheld        73			[$NX || $NX_UI_PC]
		visible			        0
		labelText               ""
        rui					    "ui/character_section_button.rpak"
        cursorVelocityModifier  0.7

        navDown                 SectionButton1
	}

	SectionButton1
	{
		ControlName			    RuiButton
		xpos			        0
		ypos			        3
		zpos			        3
		wide			        296
		wide_nx_handheld        376			[$NX || $NX_UI_PC]
		tall			        56
		tall_nx_handheld        73			[$NX || $NX_UI_PC]
		visible			        0
		labelText               ""
        rui					    "ui/character_section_button.rpak"
        cursorVelocityModifier  0.7

        pin_to_sibling			SectionButton0
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT

        navUp                   SectionButton0
        navDown                 SectionButton2
	}

	SectionButton2
	{
		ControlName			    RuiButton
		xpos			        0
		ypos			        3
		zpos			        3
		wide			        296
		wide_nx_handheld        376			[$NX || $NX_UI_PC]
		tall			        56
		tall_nx_handheld        73			[$NX || $NX_UI_PC]
		visible			        0
		labelText               ""
        rui					    "ui/character_section_button.rpak"
        cursorVelocityModifier  0.7

        pin_to_sibling			SectionButton1
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT

        navUp                   SectionButton1
        navDown                 SectionButton3
	}

	SectionButton3
	{
		ControlName			    RuiButton
		xpos			        0
		ypos			        45
		zpos			        3
		wide			        296
		wide_nx_handheld        376			[$NX || $NX_UI_PC]
		tall			        56
		tall_nx_handheld        73			[$NX || $NX_UI_PC]
		visible			        0
		labelText               ""
        rui					    "ui/character_section_button.rpak"
        cursorVelocityModifier  0.7

        pin_to_sibling			SectionButton2
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT

        navUp                   SectionButton2
	}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    LinePanel
    {
        ControlName				CNestedPanel
        xpos					491
        xpos_nx_handheld		36			[$NX || $NX_UI_PC]
        ypos					96
        ypos_nx_handheld		0			[$NX || $NX_UI_PC]
        wide					550
		wide_nx_handheld		800			[$NX || $NX_UI_PC]
        tall					840
        visible					0
        tabPosition             1
        controlSettingsFile		"resource/ui/menus/panels/quips.res"
        zpos                    100
		
        pin_to_sibling_nx_handheld			SectionButton0		[$NX || $NX_UI_PC]
        pin_corner_to_sibling_nx_handheld	TOP_LEFT			[$NX || $NX_UI_PC]
        pin_to_sibling_corner_nx_handheld	TOP_RIGHT			[$NX || $NX_UI_PC]
    }

    BoxesPanel
    {
        ControlName				CNestedPanel
        xpos					491
        xpos_nx_handheld		36			[$NX || $NX_UI_PC]
        ypos					96
        ypos_nx_handheld		0			[$NX || $NX_UI_PC]
        wide					550
		wide_nx_handheld		800			[$NX || $NX_UI_PC]
        tall					840
        visible					0
        tabPosition             1
        controlSettingsFile		"resource/ui/menus/panels/emotes.res"
        zpos                    100
		
        pin_to_sibling_nx_handheld			SectionButton0		[$NX || $NX_UI_PC]
        pin_corner_to_sibling_nx_handheld	TOP_LEFT			[$NX || $NX_UI_PC]
        pin_to_sibling_corner_nx_handheld	TOP_RIGHT			[$NX || $NX_UI_PC]
    }

	SkydiveEmotesPanel
	{
        ControlName				CNestedPanel
        xpos					491
        xpos_nx_handheld		36			[$NX || $NX_UI_PC]
        ypos					96
        ypos_nx_handheld		0			[$NX || $NX_UI_PC]
        wide					550
		wide_nx_handheld		800			[$NX || $NX_UI_PC]
        tall					840
        visible					0
        tabPosition             1
        controlSettingsFile		"resource/ui/menus/panels/skydive_emotes.res"
        zpos                    100

        pin_to_sibling_nx_handheld			SectionButton0		[$NX || $NX_UI_PC]
        pin_corner_to_sibling_nx_handheld	TOP_LEFT			[$NX || $NX_UI_PC]
        pin_to_sibling_corner_nx_handheld	TOP_RIGHT			[$NX || $NX_UI_PC]
	}

    ModelRotateMouseCapture
    {
        ControlName				CMouseMovementCapturePanel
        xpos                    700
        ypos                    0
        wide                    1340
        tall                    %100
    }

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	HintGamepad
	{
		ControlName			    RuiPanel
        ypos				    205
        ypos_nx_handheld	    105			[$NX || $NX_UI_PC]
        xpos				    0
		zpos			        3
		wide			        492
		tall			        196
		tall_nx_handheld        296			[$NX || $NX_UI_PC]
		visible			        1
		labelText               ""
        rui					    "ui/character_section_button.rpak"
        activeInputExclusivePaint	gamepad

        ruiArgs
        {
            textBreakWidth 400.0
        }

        pin_to_sibling			SectionButton3
        pin_corner_to_sibling	TOP_RIGHT
        pin_to_sibling_corner	BOTTOM_RIGHT
	}

	HintMKB
	{
		ControlName			    RuiPanel
        ypos				    163
        ypos_nx_handheld	    63			[$NX || $NX_UI_PC]
        xpos				    0
		zpos			        3
		wide			        492
		tall			        196
		tall_nx_handheld        296			[$NX || $NX_UI_PC]
		visible			        1
		labelText               ""
        rui					    "ui/character_section_button.rpak"
		activeInputExclusivePaint		keyboard

		ruiArgs
		{
		    textBreakWidth 400.0
        }

        pin_to_sibling			SectionButton3
        pin_corner_to_sibling	TOP_RIGHT
        pin_to_sibling_corner	BOTTOM_RIGHT
	}
}
