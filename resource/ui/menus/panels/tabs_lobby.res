resource/ui/menus/panels/tabs_lobby.res
{
    Anchor
    {
		ControlName				Label
		zpos					-1
		ypos					0
		wide					1920//%100
		tall					%100
		labelText				""
		visible				    0
        bgcolor_override        "0 0 0 0"
        paintbackground         1
        enabled					0
    }

    Background
    {
        ControlName				RuiPanel
		wide					%300
		tall					84
        visible					1
        enabled					1
        proportionalToParent    1
        rui 					"ui/tabs_background.rpak"

		pin_to_sibling			Anchor
		pin_corner_to_sibling	TOP
		pin_to_sibling_corner	TOP
    }

	LeftNavButton
	{
		ControlName				RuiPanel
		xpos                    -24
		wide                    76
		wide_nx_handheld        87		[$NX || $NX_UI_PC]
		tall					28
		tall_nx_handheld		32		[$NX || $NX_UI_PC]
		visible					1
		rui                     "ui/shoulder_navigation_shortcut_angle.rpak"
		activeInputExclusivePaint	gamepad

		pin_to_sibling			Anchor
		pin_corner_to_sibling	BOTTOM_LEFT
		pin_to_sibling_corner	BOTTOM_RIGHT
	}

	Tab0
	{
		ControlName				RuiButton
		InheritProperties       TabButtonSeason
		scriptID				0

		xpos                    -960

		visible					0

		pin_to_sibling			Anchor
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP
	}

	Tab1
	{
		ControlName				RuiButton
		InheritProperties		TabButtonLobby
		scriptID				1

		xpos                    -80

		pin_to_sibling			Tab0
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
	}

	CallToAction
	{
		ControlName				Label
		xpos					0
		wide					284
		tall					128
		zpos					100
		labelText				""
		visible				    1
		bgcolor_override        "255 255 255 100"
		paintbackground         1
		enabled					0
		disableMouseFocus		1

		pin_to_sibling			Tab0
		pin_corner_to_sibling	TOP_RIGHT
		pin_to_sibling_corner	BOTTOM_RIGHT
	}

	Tab2
	{
		ControlName				RuiButton
		InheritProperties		TabButtonLobby
		scriptID				2

		xpos                    -80

		pin_to_sibling			Tab1
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
	}

	Tab3
	{
		ControlName				RuiButton
		InheritProperties		TabButtonLobby
		scriptID				3

		xpos                    -80

		pin_to_sibling			Tab2
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
	}

	Tab4
	{
		ControlName				RuiButton
		InheritProperties		TabButtonLobby
		scriptID				4

		xpos                    -80

		pin_to_sibling			Tab3
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
	}

	Tab5
	{
		ControlName				RuiButton
		InheritProperties		TabButtonLobby
		scriptID				5

		xpos                    -80

		pin_to_sibling			Tab4
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
	}

	Tab6
	{
		ControlName				RuiButton
		InheritProperties		TabButtonLobby
		scriptID				6

		xpos                    -80

		pin_to_sibling			Tab5
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
	}

	Tab7
	{
		ControlName				RuiButton
		InheritProperties		TabButtonLobby
		scriptID				7

		xpos                    -80

		pin_to_sibling			Tab6
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
	}

	RightNavButton
	{
		ControlName				RuiPanel
		xpos                    -24
		wide                    76
		wide_nx_handheld        87		[$NX || $NX_UI_PC]
		tall					28
		tall_nx_handheld		32		[$NX || $NX_UI_PC]
		visible					1
		rui                     "ui/shoulder_navigation_shortcut_angle.rpak"
		activeInputExclusivePaint	gamepad

		pin_to_sibling			Anchor
		pin_corner_to_sibling	BOTTOM_LEFT
		pin_to_sibling_corner	BOTTOM_RIGHT
	}
}