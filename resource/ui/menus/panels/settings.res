"resource/ui/menus/panels/settings.res"
{
	PanelFrame
	{
		ControlName				Label
		xpos					0
		ypos					0
		wide					%100
		tall					%100
		labelText				""
	    bgcolor_override		"0 0 0 0"
		visible					0
		paintbackground			1

		proportionalToParent    1
	}

    ScreenBlur
    {
        ControlName     Label
        labelText       ""
    }

    TabsCommon
    {
        ControlName				CNestedPanel
        classname				"TabsCommonClass"
        zpos					1
        wide					f0
        tall					84
        visible					1
        controlSettingsFile		"resource/ui/menus/panels/tabs_settings.res"

        pin_to_sibling			PanelFrame
        pin_corner_to_sibling	TOP
        pin_to_sibling_corner	TOP
    }

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    DetailsPanel
    {
        ControlName				RuiPanel
        InheritProperties       SettingsDetailsPanel
        visible					1
        xpos_nx_handheld        600   [$NX || $NX_UI_PC]
        wide_nx_handheld		640   [$NX || $NX_UI_PC]

        pin_to_sibling			PanelFrame
        pin_corner_to_sibling	TOP
        pin_to_sibling_corner	TOP
    }

    ControlsPCPanelContainer
    {
        ControlName			    CNestedPanel
        InheritProperties       SettingsTabPanel

        pin_to_sibling			PanelFrame
        pin_corner_to_sibling	TOP
        pin_to_sibling_corner	TOP

        tabPosition             1

        ScrollFrame
        {
            ControlName				ImagePanel
            InheritProperties       SettingsScrollFrame
        }

        ScrollBar
        {
            ControlName				RuiButton
            InheritProperties       SettingsScrollBar

            pin_to_sibling			ScrollFrame
            pin_corner_to_sibling	TOP_RIGHT
            pin_to_sibling_corner	TOP_RIGHT
        }

        // Code created via CreateKeyBindingPanel()
        //    ContentPanel
        //    {
        //        ControlName			CNestedPanel
        //        xpos					320
        //        ypos					64
        //        wide					1408
        //        tall					840
        //        visible				0
        //        controlSettingsFile	"resource/ui/menus/panels/controls_pc.res"
        //    }
    }

    ControlsGamepadPanel
    {
        ControlName			    CNestedPanel
        InheritProperties       SettingsTabPanel

        pin_to_sibling			PanelFrame
        pin_corner_to_sibling	TOP
        pin_to_sibling_corner	TOP

        tabPosition             1

        ScrollFrame
        {
            ControlName				ImagePanel
            InheritProperties       SettingsScrollFrame
        }

        ScrollBar
        {
            ControlName				RuiButton
            InheritProperties       SettingsScrollBar

            pin_to_sibling			ScrollFrame
            pin_corner_to_sibling	TOP_RIGHT
            pin_to_sibling_corner	TOP_RIGHT
        }

        ContentPanel
        {
            ControlName				CNestedPanel
            InheritProperties       SettingsContentPanel
			tall                    1100 [!$NX && !$NX_UI_PC]
            tall                    1580 [$NX || $NX_UI_PC]
			tall_nx_handheld        2090 [$NX || $NX_UI_PC]
            tabPosition             1

            controlSettingsFile		"resource/ui/menus/panels/controls.res"
        }
    }

    VideoPanelContainer
    {
        ControlName			    CNestedPanel
        InheritProperties       SettingsTabPanel

        pin_to_sibling			PanelFrame
        pin_corner_to_sibling	TOP
        pin_to_sibling_corner	TOP

        tabPosition             1

        ScrollFrame
        {
            ControlName				ImagePanel
            InheritProperties       SettingsScrollFrame
        }

        ScrollBar
        {
            ControlName				RuiButton
            InheritProperties       SettingsScrollBar

            pin_to_sibling			ScrollFrame
            pin_corner_to_sibling	TOP_RIGHT
            pin_to_sibling_corner	TOP_RIGHT
        }

    // Code created via CreateVideoOptionsPanel()
    //    ContentPanel
    //    {
    //        ControlName			CNestedPanel
    //        xpos					320
    //        ypos					64
    //        wide					1408
    //        tall					840
    //        visible				0
    //        controlSettingsFile	"resource/ui/menus/panels/video.res"
    //        clip                  1
    //    }
    }

    SoundPanel
    {
        ControlName			    CNestedPanel
        InheritProperties       SettingsTabPanel

        pin_to_sibling			PanelFrame
        pin_corner_to_sibling	TOP
        pin_to_sibling_corner	TOP

        tabPosition             1

        ScrollFrame
        {
            ControlName				ImagePanel
            InheritProperties       SettingsScrollFrame
        }

        ScrollBar
        {
            ControlName				RuiButton
            InheritProperties       SettingsScrollBar

            pin_to_sibling			ScrollFrame
            pin_corner_to_sibling	TOP_RIGHT
            pin_to_sibling_corner	TOP_RIGHT
        }

        ContentPanel
        {
            ControlName				CNestedPanel
            InheritProperties       SettingsContentPanel
            tall                    820 [$WINDOWS]
			tall_nx_handheld        800 [$NX]
            tabPosition             1

            controlSettingsFile		"resource/ui/menus/panels/audio.res" [$WINDOWS]
            controlSettingsFile		"resource/ui/menus/panels/audio_console.res" [$GAMECONSOLE]
        }
    }

    HudOptionsPanel
    {
        ControlName			    CNestedPanel
        InheritProperties       SettingsTabPanel

        pin_to_sibling			PanelFrame
        pin_corner_to_sibling	TOP
        pin_to_sibling_corner	TOP

        tabPosition             1

        ScrollFrame
        {
            ControlName				ImagePanel
            InheritProperties       SettingsScrollFrame
        }

        ScrollBar
        {
            ControlName				RuiButton
            InheritProperties       SettingsScrollBar

            pin_to_sibling			ScrollFrame
            pin_corner_to_sibling	TOP_RIGHT
            pin_to_sibling_corner	TOP_RIGHT
        }

        ContentPanel
        {
            ControlName				CNestedPanel
            InheritProperties       SettingsContentPanel
                                     
			tall                    1780		[$WINDOWS]
            tall                    1900		[$GAMECONSOLE && !$NX]
            tall                    1835		[$NX || $NX_UI_PC]
            tall_nx_handheld        2415        [$NX || $NX_UI_PC]
                 
                                           
                                                                
                                                            
                                                                  
                  

            tabPosition             1

            controlSettingsFile		"resource/ui/menus/panels/hud_options.res"
        }
    }

//// LEFT FOOTER ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	LeftRuiFooterButton0 [$NX || $NX_UI_PC]
	{
		ControlName				RuiButton
        InheritProperties		LeftRuiFooterButton
        
        font                    Default_28
        labelText				"DEFAULT"
		scriptID				0

        pin_to_sibling          PanelFrame
        pin_to_sibling_corner   BOTTOM_LEFT
        pin_corner_to_sibling	BOTTOM_LEFT

        xpos					-48
	}
    LeftRuiFooterButton1 [$NX || $NX_UI_PC]
	{
		ControlName				RuiButton
        InheritProperties		LeftRuiFooterButton
        
        font                    Default_28
        labelText				"DEFAULT"
		scriptID				1

        pin_to_sibling          LeftRuiFooterButton0
        pin_to_sibling_corner   BOTTOM_RIGHT
        pin_corner_to_sibling	BOTTOM_LEFT
	}
    LeftRuiFooterButton2 [$NX || $NX_UI_PC]
	{
		ControlName				RuiButton
        InheritProperties		LeftRuiFooterButton
        
        font                    Default_28
        labelText				"DEFAULT"
		scriptID				2

        pin_to_sibling          LeftRuiFooterButton1
        pin_to_sibling_corner   BOTTOM_RIGHT
        pin_corner_to_sibling	BOTTOM_LEFT
	}

//// RIGHT FOOTER //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    RightRuiFooterButton0 [$NX || $NX_UI_PC]
	{
		ControlName				RuiButton
        InheritProperties		RightRuiFooterButton
        
        font                    Default_28
        labelText				"DEFAULT"
		scriptID				0

        pin_to_sibling          PanelFrame
        pin_to_sibling_corner   BOTTOM_RIGHT
        pin_corner_to_sibling	BOTTOM_RIGHT
	}
    RightRuiFooterButton1 [$NX || $NX_UI_PC]
	{
		ControlName				RuiButton
        InheritProperties		RightRuiFooterButton
        
        font                    Default_28
        labelText				"DEFAULT"
		scriptID				1

        pin_to_sibling          RightRuiFooterButton0
        pin_to_sibling_corner   BOTTOM_LEFT
        pin_corner_to_sibling	BOTTOM_RIGHT
	}
}