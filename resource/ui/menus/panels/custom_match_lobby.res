resource/ui/menus/panels/custom_match_lobby.res
{
    ScreenFrame
    {
        ControlName				Label
        wide					%100
        tall					%100
        labelText				""
        visible				    0
        bgcolor_override        "255 255 0 10"
        paintbackground         1
        proportionalToParent    1
    }

    PanelFrame
    {
        ControlName				Label
		wide					%100
		tall					816
        labelText				""
        visible				    0
        bgcolor_override        "255 255 0 64"
        paintbackground         1
        proportionalToParent    1

        pin_to_sibling			ScreenFrame
        pin_corner_to_sibling	TOP
        pin_to_sibling_corner	TOP
    }

    LeftColumn
    {
        ControlName				Label
        wide                    372
        tall                    %100
        labelText				""
        proportionalToParent    1

        pin_to_sibling          PanelFrame
        pin_corner_to_sibling   LEFT
        pin_to_sibling_corner   LEFT
    }

    LobbyRosterPanel
    {
        ControlName             CNestedPanel
        controlSettingsFile     "resource/ui/menus/panels/custom_match_lobby_roster.res"

        wide                    372
        tall                    400

        pin_to_sibling          LeftColumn
        pin_corner_to_sibling   TOP
        pin_to_sibling_corner   TOP
    }

    ChatPanel
	{
		ControlName				CBaseHudChat
		InheritProperties		ChatBox

        ypos                    10
        wide                    372
        tall                    300

        pin_to_sibling          LobbyRosterPanel
        pin_corner_to_sibling   TOP
        pin_to_sibling_corner   BOTTOM

        destination				"customlobby"
        interactive				1
        chatBorderThickness		1
        messageModeAlwaysOn		1
        hideInputBox			1 [!$WIN32]
        font 					Default_27
		defaultAdminOnly		1
		setUnusedScrollbarInvisible 1
		timestampChat			1
	}

    StartButton
    {
		ControlName				RuiButton
        classname               "MenuButton"
        wide                    372
        tall                    96

        pin_to_sibling          LeftColumn
        pin_corner_to_sibling   BOTTOM
        pin_to_sibling_corner   BOTTOM

        rui                     "ui/generic_button.rpak"
        ruiArgs
        {
            buttonText          "#READY"
        }
    }

    PlayerRosterPanel
    {
        ControlName             CNestedPanel
        controlSettingsFile     "resource/ui/menus/panels/custom_match_player_roster.res"

        wide                    1406
        tall                    %100
        proportionalToParent    1

        pin_to_sibling          PanelFrame
        pin_corner_to_sibling   RIGHT
        pin_to_sibling_corner   RIGHT
    }

    MouseDragIcon
    {
        ControlName				RuiPanel

        wide                    272
        tall                    48
        visible					0
        enabled 				1
        scaleImage				1
        rui                     "ui/custom_match_team_roster_player.rpak"
        zpos                    20
    }
}
