"resource/ui/menus/panels/clubs_logo_editor_canvas.res"
{
	PanelFrame
	{
		ControlName				Label
		xpos					0
		ypos					0
		wide					%100
		tall					%100
		labelText				""
		bgcolor_override		"0 0 0 255"
		visible					1
		paintbackground			0
		proportionalToParent    1
	}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


	LayerSelector
	{
	     ControlName                RuiButton
	     classname                  "MenuButton"

	     xpos                       0
	     ypos                       0
	     zpos                       10

	     wide					    512
	     wide_nx_handheld		    701			[$NX || $NX_UI_PC]
	     tall					    200
	     tall_nx_handheld		    274			[$NX || $NX_UI_PC]
	     rui                        "ui/clubs_logo_element_selector.rpak"
	     visible					1
	     cursorVelocityModifier     0.7


	     proportionalToParent       1

	     pin_to_sibling             PanelFrame
	     pin_corner_to_sibling      CENTER
	     pin_to_sibling_corner      CENTER

	     sound_focus                "UI_Menu_Focus_Large"
	     sound_accept               "UI_Menu_Focus_Large"
	}

	LeftArrow
	{
	    ControlName				RuiButton
	    classname               "MenuButton"

	    xpos                     0
	    ypos                     0
	    zpos                     10

	    wide					 32
	    wide_nx_handheld		 64			[$NX || $NX_UI_PC]
	    tall					 128
	    tall_nx_handheld		 256		[$NX || $NX_UI_PC]
	    rui                      "ui/club_logo_selector_arrow_button.rpak"
	    visible					1
	    cursorVelocityModifier   0.7

	    proportionalToParent    1

	    pin_to_sibling          LayerSelector
	    pin_corner_to_sibling   RIGHT
	    pin_to_sibling_corner   LEFT

	    sound_focus             "UI_Menu_Focus_Large"
	    sound_accept            "UI_Menu_Clubs_LogoEditor_Adjust"
	}

	RightArrow
	{
	    ControlName				RuiButton
	    classname               "MenuButton"

	    xpos                     0
	    ypos                     0
	    zpos                     10

	    wide					 32
	    wide_nx_handheld		 64			[$NX || $NX_UI_PC]
	    tall					 128
	    tall_nx_handheld		 256		[$NX || $NX_UI_PC]
	    rui                      "ui/club_logo_selector_arrow_button.rpak"
	    visible					1
	    cursorVelocityModifier   0.7

	     ruiArgs
	     {
	         isRightFacing 1
	     }

	    proportionalToParent    1

	    pin_to_sibling          LayerSelector
	    pin_corner_to_sibling   LEFT
	    pin_to_sibling_corner   RIGHT

	    sound_focus             "UI_Menu_Focus_Large"
	    sound_accept            "UI_Menu_Clubs_LogoEditor_Adjust"
	}
}