resource/ui/menus/panels/tabs_season.res
{
    Anchor
    {
		ControlName				Label
		xpos                    -2
		ypos					0
		wide					%100
		tall					%100
		labelText				""
		visible				    1
        bgcolor_override        "0 0 0 0"
        paintbackground         1
        proportionalToParent    1
    }

    Background
    {
        ControlName				RuiPanel
		wide					%200
		tall					%100
		xpos                    -512
        visible					0
        enabled					1
        proportionalToParent    1
        visible                 1
        rui 					"ui/tabs_background.rpak"
    }

	TabDivider0
	{
		ControlName             RuiPanel
		classname				TabDividerClass

		pin_to_sibling			Tab0
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
		xpos                    -68
		ypos                    0
		wide					144
		tall					72

		rui                     "ui/tab_divider_season_subnav.rpak"
	}

	TabDivider1
	{
		ControlName             RuiPanel
		classname				TabDividerClass

		pin_to_sibling			Tab0
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
		xpos                    -68
		ypos                    0
		wide					144
		tall					72

		rui                     "ui/tab_divider_season_subnav.rpak"
	}

	TabDivider2
	{
		ControlName             RuiPanel
		classname				TabDividerClass

		pin_to_sibling			Tab0
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
		xpos                    -68
		ypos                    0
		wide					144
		tall					72

		rui                     "ui/tab_divider_season_subnav.rpak"
	}

	TabDivider3
	{
		ControlName             RuiPanel
		classname				TabDividerClass

		pin_to_sibling			Tab0
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
		xpos                    -68
		ypos                    0
		wide					144
		tall					72

		rui                     "ui/tab_divider_season_subnav.rpak"
	}

	Tab0
	{
		ControlName				RuiButton
		InheritProperties		TabButtonSeasonSubNav
		scriptID				0
		xpos                    -780
		pin_to_sibling			Anchor
		pin_corner_to_sibling	BOTTOM_LEFT
		pin_to_sibling_corner	BOTTOM
	}

	Tab1
	{
		ControlName				RuiButton
		InheritProperties		TabButtonSeasonSubNav
		scriptID				1

		xpos                    -68

		pin_to_sibling			Tab0
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
	}

	Tab2
	{
		ControlName				RuiButton
		InheritProperties		TabButtonSeasonSubNav
		scriptID				2

		xpos                    -68

		pin_to_sibling			Tab1
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
	}

	Tab3
	{
		ControlName				RuiButton
		InheritProperties		TabButtonSeasonSubNav
		scriptID				3

		xpos                    -68

		pin_to_sibling			Tab2
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
	}

	Tab4
	{
		ControlName				RuiButton
		InheritProperties		TabButtonSeasonSubNav
		scriptID				4

		xpos                    -68

		pin_to_sibling			Tab3
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
	}

	Tab5
	{
		ControlName				RuiButton
		InheritProperties		TabButtonSeasonSubNav
		scriptID				5

		xpos                    -68

		pin_to_sibling			Tab4
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
	}

	Tab6
	{
		ControlName				RuiButton
		InheritProperties		TabButtonSeasonSubNav
		scriptID				6

		xpos                    -68

		pin_to_sibling			Tab5
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
	}

	Tab7
	{
		ControlName				RuiButton
		InheritProperties		TabButtonSeasonSubNav
		scriptID				7

		xpos                    -40

		pin_to_sibling			Tab6
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
	}

	LeftNavButton
	{
		ControlName				RuiPanel
		xpos                    -68
		wide                    76
		tall					28
		visible					1
		rui                     "ui/shoulder_navigation_shortcut_angle.rpak"
		activeInputExclusivePaint	gamepad

		ruiArgs
		{
			flip	1
		}

		pin_to_sibling			Tab0
		pin_corner_to_sibling	BOTTOM_LEFT
		pin_to_sibling_corner	BOTTOM_RIGHT
	}

	RightNavButton
	{
		ControlName				RuiPanel
		xpos                    -24
		wide                    76
		tall					28
		visible					1
		rui                     "ui/shoulder_navigation_shortcut_angle.rpak"
		activeInputExclusivePaint	gamepad

		ruiArgs
		{
			flip	1
		}

		pin_to_sibling			Anchor
		pin_corner_to_sibling	BOTTOM_LEFT
		pin_to_sibling_corner	BOTTOM_RIGHT
	}
}