"resource/ui/menus/panels/character_banners_v2.res"
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

	SectionButton0 //FRAME
	{
		ControlName			RuiButton
		xpos			    123
		xpos_nx_handheld    0   [$NX || $NX_UI_PC]
		ypos			    96
		ypos_nx_handheld    55	[$NX || $NX_UI_PC]
		zpos			    3
		wide			    296
		wide_nx_handheld    376 [$NX || $NX_UI_PC]
		tall			    56
		tall_nx_handheld    73  [$NX || $NX_UI_PC]
		visible			    0
		labelText           ""
        rui					"ui/character_section_button.rpak"
        cursorVelocityModifier  0.7

        navDown             SectionButton1
	}

	SectionButton1 //POSE
	{
		ControlName			RuiButton
		xpos			    0
		ypos			    3
		zpos			    3
		wide			    296
		wide_nx_handheld    376 [$NX || $NX_UI_PC]
		tall			    56
		tall_nx_handheld    73  [$NX || $NX_UI_PC]  
		visible			    0
		labelText           ""
        rui					"ui/character_section_button.rpak"
        cursorVelocityModifier  0.7

        pin_to_sibling			SectionButton0
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT

        navUp               SectionButton0
        navDown             SectionButton2
	}

	SectionButton2 //BADGES
	{
		ControlName			RuiButton
		xpos			    0
		ypos			    45
		ypos_nx_handheld    55  [$NX || $NX_UI_PC]
		zpos			    3
		wide			    296
		wide_nx_handheld    376 [$NX || $NX_UI_PC]
		tall			    56
		tall_nx_handheld    73  [$NX || $NX_UI_PC]
		visible			    0
		labelText           ""
        rui					"ui/character_section_button.rpak"
        cursorVelocityModifier  0.7

        pin_to_sibling			SectionButton1
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT

        navUp               SectionButton1
        navDown             SectionButton3
	}

	SectionButton3
	{
		ControlName			RuiButton
		xpos			    0
		ypos			    3
		zpos			    3
		wide			    296
		wide_nx_handheld    376 [$NX || $NX_UI_PC]
		tall			    56
		tall_nx_handheld    73  [$NX || $NX_UI_PC]
		visible			    0
		labelText           ""
        rui					"ui/character_section_button.rpak"
        cursorVelocityModifier  0.7

        pin_to_sibling			SectionButton2
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT

        navUp               SectionButton2
        navDown             SectionButton4
	}

	SectionButton4
	{
		ControlName			RuiButton
		xpos			    0
		ypos			    45
		ypos_nx_handheld    55 [$NX || $NX_UI_PC]
		zpos			    3
		wide			    296
		wide_nx_handheld    376 [$NX || $NX_UI_PC]
		tall			    56
		tall_nx_handheld    73  [$NX || $NX_UI_PC] 
		visible			    0
		labelText           ""
        rui					"ui/character_section_button.rpak"
        cursorVelocityModifier  0.7

        pin_to_sibling			SectionButton3
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT

        navUp               SectionButton3
        navDown             SectionButton5
	}

	SectionButton5
	{
		ControlName			RuiButton
		xpos			    0
		ypos			    3
		zpos			    3
		wide			    296
		wide_nx_handheld    376 [$NX || $NX_UI_PC]
		tall			    56
		tall_nx_handheld    73  [$NX || $NX_UI_PC]
		visible			    0
		labelText           ""
        rui					"ui/character_section_button.rpak"
        cursorVelocityModifier  0.7

        pin_to_sibling			SectionButton4
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT

        navUp               SectionButton4
        //navDown             SectionButton6
	}

	SectionButton6
	{
		ControlName			RuiButton
		xpos			    0
		ypos			    3
		zpos			    3
		wide			    296
		wide_nx_handheld    676 [$NX || $NX_UI_PC]
		tall			    56
		tall_nx_handheld    73  [$NX || $NX_UI_PC]
		visible			    0
		labelText           ""
        rui					"ui/character_section_button.rpak"
        cursorVelocityModifier  0.7

        pin_to_sibling			SectionButton5
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT

		//navUp               SectionButton5
        //navDown             SectionButton7
	}

	SectionButton7
	{
		ControlName			RuiButton
		xpos			    0
		ypos			    3
		zpos			    3
		wide			    296
		wide_nx_handheld    376 [$NX || $NX_UI_PC]
		tall			    56
		tall_nx_handheld    73  [$NX || $NX_UI_PC]
		visible			    0 
		labelText           ""
        rui					"ui/character_section_button.rpak"
        cursorVelocityModifier  0.7

        pin_to_sibling			SectionButton6
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT

		//navUp               SectionButton6
	}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    CardFramesPanel
    {
        ControlName				CNestedPanel
        xpos					491
        xpos_nx_handheld		411  [$NX || $NX_UI_PC]
		ypos			    	96
		ypos_nx_handheld    	55	 [$NX || $NX_UI_PC]
        wide					1408
        tall					840
        visible					1
        tabPosition             1
        controlSettingsFile		"resource/ui/menus/panels/card_frames.res"
    }

    CardPosesPanel
    {
        ControlName				CNestedPanel
        xpos					491
        xpos_nx_handheld		411  [$NX || $NX_UI_PC]
		ypos			    	96
		ypos_nx_handheld    	55	 [$NX || $NX_UI_PC]
        wide					1408
        tall					840
        visible					1
        tabPosition             1
        controlSettingsFile		"resource/ui/menus/panels/card_poses.res"
    }

    CardBadgesPanel
    {
        ControlName				CNestedPanel
        xpos					491
        xpos_nx_handheld		411  [$NX || $NX_UI_PC]
		ypos			    	96
		ypos_nx_handheld   	 	55	 [$NX || $NX_UI_PC]
        wide					1408
        tall					840
        tall_nx_handheld		800  [$NX || $NX_UI_PC]
        visible					1
        tabPosition             1
        controlSettingsFile		"resource/ui/menus/panels/card_badges.res"
    }

    CardTrackersPanel
    {
        ControlName				CNestedPanel
        xpos					491
        xpos_nx_handheld		411  [$NX || $NX_UI_PC]
		ypos			    	96
		ypos_nx_handheld    	55	 [$NX || $NX_UI_PC]
        wide					1408
        tall					840
        visible					1
        tabPosition             1
        controlSettingsFile		"resource/ui/menus/panels/card_trackers.res"
    }

    IntroQuipsPanel
    {
        ControlName				CNestedPanel
        xpos					491
        xpos_nx_handheld		411  [$NX || $NX_UI_PC]
		ypos			    	96
		ypos_nx_handheld    	55	 [$NX || $NX_UI_PC]
        wide					1408
        tall					840
        visible					1
        tabPosition             1
        controlSettingsFile		"resource/ui/menus/panels/quips.res"
    }

    KillQuipsPanel
    {
        ControlName				CNestedPanel
        xpos					491
        xpos_nx_handheld		411  [$NX || $NX_UI_PC]
		ypos			    	96
		ypos_nx_handheld    	55	 [$NX || $NX_UI_PC]
        wide					1408
        tall					840
        visible					1
        tabPosition             1
        controlSettingsFile		"resource/ui/menus/panels/quips.res"
    }

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//    DebugBG
//    {
//        ControlName				Label
//        wide					800
//        tall					800
//        labelText				""
//        bgcolor_override		"70 70 70 100"
//        visible					1
//        paintbackground			1
//
//        pin_to_sibling			CombinedCard
//        pin_corner_to_sibling	TOP_LEFT
//        pin_to_sibling_corner	TOP_LEFT
//    }
    CombinedCard
    {
        ControlName				RuiPanel
        xpos                    -930
        xpos_nx_handheld        -1065 		[$NX || $NX_UI_PC]
        ypos                    -16
        ypos_nx_handheld        5	 		[$NX || $NX_UI_PC]
        wide					850 //800
        wide_nx_handheld		870 		[$NX || $NX_UI_PC]//800
        tall					850 //800
        tall_nx_handheld		870 		[$NX || $NX_UI_PC]//800
        rui                     "ui/combined_card.rpak"
        visible					1

        pin_to_sibling			PanelFrame
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_LEFT
    }
}
