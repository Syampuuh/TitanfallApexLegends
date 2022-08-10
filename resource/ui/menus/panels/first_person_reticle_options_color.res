resource/ui/menus/panels/first_person_reticle_options_color.res
{
	Sizer
    {
        ControlName				Label
        wide					1920
        tall					1080
        labelText				""
        visible				    0
        bgcolor_override        "70 70 00 255"
        paintbackground         1

        proportionalToParent    1

        pin_to_sibling			PanelFrame
		pin_corner_to_sibling	TOP
		pin_to_sibling_corner	TOP
    }
	CenterFrame
	{
		ControlName				Label
        xpos					0
        ypos					0
        wide					1920
		tall					%100
		labelText				""
		visible					1
		paintbackground			1
        proportionalToParent    1

        pin_to_sibling			PanelFrame
        pin_corner_to_sibling	TOP
        pin_to_sibling_corner	TOP
	}
	PaletteFrame
	{
		ControlName				RuiPanel
        xpos					-30
        ypos					-187
        wide					230
		tall					615
		labelText				""
		visible					1
		paintbackground			1
        rui                     "ui/reticle_palette_bg.rpak"
        proportionalToParent    0

        pin_to_sibling			CenterFrame
        pin_corner_to_sibling	TOP_RIGHT
        pin_to_sibling_corner	TOP_RIGHT
	}
    BtnPaletteColor0
    {
        ControlName				RuiButton
        xpos                    -45
        ypos                    -44
        zpos                    100

        selectOnFocus           1
        cursorVelocityModifier  0.7
        cursorPriority          20

        tall		            83
        wide	            	83

        pin_to_sibling			PaletteFrame
        pin_corner_to_sibling	TOP_RIGHT
        pin_to_sibling_corner	TOP_RIGHT

		navDown                 BtnPaletteColor1

        rui                     "ui/reticle_palette.rpak"
    }
    BtnPaletteColor1
    {
        ControlName				RuiButton
        xpos				    0
        ypos                    19
		zpos                    100

        selectOnFocus           1
        cursorVelocityModifier  0.7
        cursorPriority          20

        tall		            83
        wide	            	83

        pin_to_sibling			BtnPaletteColor0
        pin_corner_to_sibling	TOP
        pin_to_sibling_corner	BOTTOM

		navUp                   BtnPaletteColor0
		navDown                 BtnPaletteColor2
        cursorPriority			1

        rui                     "ui/reticle_palette.rpak"
    }
    BtnPaletteColor2
    {
        ControlName				RuiButton
        xpos				    0
        ypos                    19
		zpos                    100

        selectOnFocus           1
        cursorVelocityModifier  0.7
        cursorPriority          20

        tall		            83
        wide	            	83

        pin_to_sibling			BtnPaletteColor1
        pin_corner_to_sibling	TOP
        pin_to_sibling_corner	BOTTOM

		navUp                   BtnPaletteColor1
		navDown                 BtnPaletteColor3
        cursorPriority			1

        rui                     "ui/reticle_palette.rpak"
    }
    BtnPaletteColor3
    {
        ControlName				RuiButton
        xpos				    0
        ypos                    19
		zpos                    100

        selectOnFocus           1
        cursorVelocityModifier  0.7
        cursorPriority          20

        tall		            83
        wide	            	83

        pin_to_sibling			BtnPaletteColor2
        pin_corner_to_sibling	TOP
        pin_to_sibling_corner	BOTTOM

		navUp                   BtnPaletteColor2
		navDown                 BtnDefaultColor
        cursorPriority			1

        rui                     "ui/reticle_palette.rpak"
    }
    BtnDefaultColor
    {
        ControlName				RuiButton
        xpos					2
        ypos                    80
		zpos                    100

        selectOnFocus           1
        cursorVelocityModifier  0.7
        cursorPriority          20

        tall		            83
        wide	            	83

        pin_to_sibling			BtnPaletteColor3
        pin_corner_to_sibling	TOP
        pin_to_sibling_corner	BOTTOM

		navUp                   BtnPaletteColor3
		navDown                 H_Slider
        cursorPriority			1

        rui                     "ui/reticle_palette.rpak"
    }
    H_Slider
    {
        ControlName				SliderControl
        InheritProperties		ColorSlider

        pin_to_sibling			Sizer
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT

        ypos                    -270
        xpos                    -399
		zpos                    100
		tabPosition             1

        selectOnFocus           1
        cursorVelocityModifier  0.7
        cursorPriority          20

        navUp                   PreviewBackgroundSwitch
        navDown                 SV_Slider
        navRight                BtnDefaultColor

        minValue				0.0
        maxValue				0.99
        stepSize				0.001
        inverseFill             0
        showLabel               0
    }
    SV_Slider
    {
        ControlName				SliderControl
        InheritProperties		ColorSlider

		ypos                    8
		zpos                    100

        selectOnFocus           1
        cursorVelocityModifier  0.7
        cursorPriority          20

        minValue				0.0
        maxValue				1.0
        stepSize				0.001
        inverseFill             0
        showLabel               0

        navUp                   H_Slider

        pin_to_sibling			H_Slider
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
    }

    CurrentPreviousColor
    {
        ControlName				RuiPanel
        xpos					8
        ypos					0
        wide					257
        tall					160
        labelText				""
        visible					1
        paintbackground			1
        proportionalToParent    1
        rui                     "ui/reticle_current_previous_color.rpak"

        pin_to_sibling			H_Slider
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
    }
    ApplyRGBButtonBG
    {
          ControlName				ImagePanel
          xpos					    0
          ypos					    8
          wide                      260
          tall					    90
          visible					1
          enabled 				    1
          scaleImage				1
          image					    "vgui/HUD/white"
          drawColor				    "0 0 0 255"

          pin_to_sibling			CurrentPreviousColor
          pin_corner_to_sibling	    BOTTOM_RIGHT
          pin_to_sibling_corner	    TOP_RIGHT
    }
	ApplyRGBButton
    {
        ControlName				RuiButton
        classname               "MenuButton"
        xpos                    0
        ypos                    0
        zpos                    100
        wide					208
        tall					56
        rui                     "ui/generic_bar_button.rpak"
        labelText               ""
        visible					1
        cursorVelocityModifier  0.7

        sound_focus             "UI_Menu_Focus_Large"
        cursorVelocityModifier  0.7
        proportionalToParent	1

        ruiArgs
        {
            buttonText        "#APPLY"
            bottomBarHeight    8.0
        }

        pin_to_sibling          ApplyRGBButtonBG
        pin_corner_to_sibling   CENTER
        pin_to_sibling_corner   CENTER
    }

	PreviousColorButton
    {
        ControlName				RuiButton
        zpos					100
        xpos                    -9
        ypos                    -41
        wide					156
        tall					79
        visible					0
        enabled					1
        rui						"ui/reticle_previous_color_button.rpak"
        labelText				""
        polyShape               "0.55 0.0 1.0 0.0 1.0 1.0 0.0 1.0"
        rightClickEvents		1
        middleClickEvents       1
        sound_focus             "UI_Menu_Focus"
        sound_accept			""
        cursorVelocityModifier  0.7

        pin_to_sibling			CurrentPreviousColor
        pin_corner_to_sibling	BOTTOM_RIGHT
        pin_to_sibling_corner	BOTTOM_RIGHT
    }

	ColorB
    {
        ControlName				RuiPanel
        wide					42
        tall					27
        visible				    1
        rui                     "ui/reticle_color_textframe.rpak"

        xpos                    -9
        ypos                    -8

        ruiArgs
        {
            name        "#MENU_RETICLE_B"
            subtitle    ""
        }

        pin_to_sibling			CurrentPreviousColor
        pin_corner_to_sibling	TOP_RIGHT
        pin_to_sibling_corner	TOP_RIGHT
    }
    ColorBTextEntry
    {
        ControlName				TextEntry
        ClassName               RedTextEntry
        zpos					100 // This works around input weirdness when the control is constructed by code instead of VGUI blackbox.
        xpos                    0
        ypos                    0
        wide					42
        tall					27
        visible					1
        enabled					1
        textHidden				0
        editable				1
        maxchars				3
        textAlignment			"center"
        ruiFont                 TitleRegularFont
        ruiFontHeight           25
        ruiFontHeight_nx_handheld           23 [$NX || $NX_UI_PC]
        keyboardTitle			""
        keyboardDescription		""
        allowRightClickMenu		0
        allowSpecialCharacters	0
        allowAdditionalSpecialCharacters	0
        NumericInputOnly		1
        charBlackList           " "
        unicode					0
        selectOnFocus           1
        cursorVelocityModifier  0.7
        cursorPriority          20
        proportionalToParent    1

		keyboardTitle				""
		keyboardDescription			""

        pin_to_sibling			ColorB
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_LEFT
    }
    ColorG
    {
        ControlName				RuiPanel
        wide					42
        tall					27
        visible				    1
        rui                     "ui/reticle_color_textframe.rpak"

        xpos                    2

        ruiArgs
        {
            name        "#MENU_RETICLE_G"
            subtitle    ""
        }

        pin_to_sibling			ColorB
        pin_corner_to_sibling	TOP_RIGHT
        pin_to_sibling_corner	TOP_LEFT
    }
    ColorGTextEntry
    {
        ControlName				TextEntry
        zpos					100 // This works around input weirdness when the control is constructed by code instead of VGUI blackbox.
        xpos                    0
        ypos                    0
        wide					42
        tall					27
        visible					1
        enabled					1
        textHidden				0
        editable				1
        maxchars				3
        textAlignment			center
        ruiFont                 TitleRegularFont
        ruiFontHeight           25
        ruiFontHeight_nx_handheld           23 [$NX || $NX_UI_PC]
        keyboardTitle			""
        keyboardDescription		""
        allowRightClickMenu		0
        allowSpecialCharacters	0
        allowAdditionalSpecialCharacters	0
        NumericInputOnly		1
        charBlackList           " "
        unicode					0
        selectOnFocus           1
        cursorVelocityModifier  0.7
        cursorPriority          20

		keyboardTitle				""
		keyboardDescription			""

        proportionalToParent    1
        pin_to_sibling			ColorG
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_LEFT
    }
    ColorR
	{
	    ControlName				RuiPanel
	    wide					42
	    tall					27
	    visible				    1

        xpos                    2

	    rui                     "ui/reticle_color_textframe.rpak"

	    ruiArgs
	    {
	        name        "#MENU_RETICLE_R"
	        subtitle    ""
	    }

	    pin_to_sibling			ColorG
        pin_corner_to_sibling	TOP_RIGHT
        pin_to_sibling_corner	TOP_LEFT
	}

	ColorRTextEntry
    {
        ControlName				TextEntry
        zpos					100 // This works around input weirdness when the control is constructed by code instead of VGUI blackbox.
        xpos                    0
        ypos                    0
        wide					42
        tall					27
        visible					1
        enabled					1
        textHidden				0
        editable				1
        maxchars				3
        textAlignment			center
        ruiFont                 TitleRegularFont
        ruiFontHeight           25
        ruiFontHeight_nx_handheld           23 [$NX || $NX_UI_PC]
        keyboardTitle			""
        keyboardDescription		""
        allowRightClickMenu		0
        allowSpecialCharacters	0
        allowAdditionalSpecialCharacters	0
        NumericInputOnly		1
        charBlackList           " "
        unicode					0
        selectOnFocus           1
        cursorVelocityModifier  0.7
        cursorPriority          20

		keyboardTitle				""
		keyboardDescription			""

        proportionalToParent    1
        pin_to_sibling			ColorR
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_LEFT
    }
}