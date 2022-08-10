"resource/ui/menus/panels/private_match_admin_controls.res"
{
	PanelFrame
	{
		ControlName				Label
		xpos					0
		ypos					0
		wide					%100
		tall					%100
		labelText				""
		bgcolor_override		"255 16 255 32"
		visible					1
		paintbackground			0
		proportionalToParent    1
	}

	ToolTip
    {
        ControlName				RuiPanel
        InheritProperties       ToolTip
        zpos                    999
    }
	
	AdminChatWindow
	{
		ControlName				CBaseHudChat
		InheritProperties		ChatBox

		destination				"match"
        interactive				1
        chatBorderThickness		1
		messageModeAlwaysOn		1
        hideInputBox			1 [!$WIN32]
		defaultAdminOnly		1

		pin_to_sibling			PanelFrame
		pin_corner_to_sibling   LEFT
        pin_to_sibling_corner   LEFT
		
		visible 				1
		enabled					1
		ypos					-60
		
		tall                    400
	}

	AdminChatBoxIcon
    {
        ControlName				Label
        pin_to_sibling			AdminChatWindow
        pin_corner_to_sibling   BOTTOM_LEFT
        pin_to_sibling_corner   BOTTOM_RIGHT

        labelText               " %[R_TRIGGER|]%"
        visible                 1
    }
	
	AdminChatModeButton
    {
        ControlName				RuiButton
        classname               "MenuButton"
        wide					288
        tall					112
		ypos					120
        rui                     "ui/generic_button.rpak"
        labelText               ""
        visible					1
        cursorVelocityModifier  0.7
      
        proportionalToParent    1

        pin_to_sibling			AdminChatWindow
        pin_corner_to_sibling	BOTTOM_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT

        sound_focus             "UI_Menu_Focus_Large"
    }
	
	SpectatorChatCheckBox
	{
		ControlName				RuiButton
		ypos					0
		xpos					15
		labelText				"#TOURNAMENT_SPECTATOR_CHAT_CHECKBOX"
		rui						"ui/private_match_spectator_chat_checkbox.rpak"

		wide					200
		tall 					48

		pin_to_sibling			AdminChatModeButton
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
	}

	AdminChatTarget
	{
		ControlName				RuiPanel
		rui						"ui/private_match_chat_target_text.rpak"

		ruiArgs
		{
			targetText			""
		}

	  	pin_to_sibling			SpectatorChatCheckBox
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT

		wide					200
		tall 					48	
	}

	EndMatchButton
    {
        ControlName				RuiButton
        classname               "MenuButton"
        wide					288
        tall					112
        rui                     "ui/generic_button.rpak"
        labelText               ""
        visible					1
        cursorVelocityModifier  0.7
      
        proportionalToParent    1

        pin_to_sibling			PanelFrame
        pin_corner_to_sibling	BOTTOM_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT

        sound_focus             "UI_Menu_Focus_Large"
    }

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  
}