resource/ui/menus/panels/tabs_club_lobby.res
{
    Anchor
    {
		ControlName				Label
		xpos					0
		ypos					0
		wide					%100
		tall					%100
		labelText				""
		visible				    1
        bgcolor_override        "0 0 0 0"
        paintbackground         1
        proportionalToParent    1
    }

//    Background
//    {
//        ControlName				RuiPanel
//        wide					%100
//        tall					%100
//        visible					1
//        enabled					1
//        proportionalToParent    1
//        rui 					"ui/basic_image.rpak"
//    }

	LeftNavButton
	{
		ControlName				RuiPanel
		xpos                    0
		wide                    40
		tall					40
		visible					1
		rui                     "ui/club_lobby_tab_nav_button.rpak"
		activeInputExclusivePaint	gamepad

		pin_to_sibling			Tab0
		pin_corner_to_sibling	BOTTOM
		pin_to_sibling_corner	TOP
	}

	Tab0
	{
		ControlName				RuiButton
		InheritProperties		TabButtonClubLobby
		scriptID				0
		xpos                    -460

		cursorPriority          100

		pin_to_sibling			Anchor
		pin_corner_to_sibling	BOTTOM_LEFT
		pin_to_sibling_corner	BOTTOM
	}

	Tab1
	{
		ControlName				RuiButton
		InheritProperties		TabButtonClubLobby
		scriptID				1
		xpos                    0

		cursorPriority          100

		pin_to_sibling			Tab0
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
	}

	Tab2
    {
        ControlName				RuiButton
        InheritProperties		TabButtonClubLobby
        scriptID				2
        xpos                    -40

        cursorPriority          10

        pin_to_sibling			Tab1
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
    }

    Tab3
    {
        ControlName				RuiButton
        InheritProperties		TabButtonClubLobby
        scriptID				3
        xpos                    -40

        cursorPriority          10

        pin_to_sibling			Tab2
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
    }

    Tab4
    {
        ControlName				RuiButton
        InheritProperties		TabButtonClubLobby
        scriptID				4
        xpos                    -40

        cursorPriority          10

        pin_to_sibling			Tab3
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
    }

    Tab5
    {
        ControlName				RuiButton
        InheritProperties		TabButtonClubLobby
        scriptID				5
        xpos                    -40

        cursorPriority          10

        pin_to_sibling			Tab4
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
    }

    Tab6
    {
        ControlName				RuiButton
        InheritProperties		TabButtonClubLobby
        scriptID				6
        xpos                    -40

        cursorPriority          10

        pin_to_sibling			Tab5
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
    }

    Tab7
    {
        ControlName				RuiButton
        InheritProperties		TabButtonClubLobby
        scriptID				7
        xpos                    -40

        cursorPriority          10

        pin_to_sibling			Tab6
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
    }

	RightNavButton
	{
		ControlName				RuiPanel
		xpos                    0
		wide                    40
		tall					40
		visible					0
		rui                     "ui/club_lobby_tab_nav_button.rpak"
		activeInputExclusivePaint	gamepad

		pin_to_sibling			Tab1
		pin_corner_to_sibling	BOTTOM
		pin_to_sibling_corner	TOP
	}
}