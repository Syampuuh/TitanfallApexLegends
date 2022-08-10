resource/ui/menus/panels/friend_list_panel.res
{
	menu
	{
		ControlName				Frame
		wide					f0
		tall					f0
		autoResize				0
		pinCorner				0
		visible					1
		enabled					1
		PaintBackgroundType		0
		infocus_bgcolor_override	"0 0 0 0"
		outoffocus_bgcolor_override	"0 0 0 0"

        ScreenFrame
        {
            ControlName				Label
            xpos					0
            ypos					0
            wide					%100
            tall					%100
            labelText				""
            //visible				    1
            //bgcolor_override        "255 255 0 100"
            //paintbackground         1
        }

		PanelFrame
		{
            ControlName				Label
            xpos					0
            ypos					0
            wide					1800
            tall					660
            labelText				""
            visible				    1
            bgcolor_override        "255 255 0 100"
            paintbackground         1

            pin_to_sibling          MenuHeader
            pin_corner_to_sibling   TOP
            pin_to_sibling_corner   BOTTOM
		}

        FriendGridBackground
        {
            ControlName				RuiPanel
            rui                     "ui/grid_spinner.rpak"
            wide                    1300
            tall                    660
            visible					1
            xpos_nx_handheld		58			[$NX || $NX_UI_PC]

            pin_to_sibling			FriendGrid
            pin_corner_to_sibling	TOP_RIGHT
            pin_to_sibling_corner	TOP_RIGHT
        }

        FriendGrid
        {
            ControlName				CNestedPanel
            wide                    1300
            tall                    660
            visible					1

			controlSettingsFile		"resource/ui/menus/panels/friend_list_grid.res"

            pin_to_sibling          PanelFrame
            pin_corner_to_sibling   TOP_RIGHT
            pin_to_sibling_corner   TOP_RIGHT
        }

        PageButton7
        {
            ControlName				RuiButton
            InheritProperties       PaginationButton
            scriptID                7
            ypos                    16

            pin_to_sibling			FriendGrid
            pin_corner_to_sibling	TOP_RIGHT
            pin_to_sibling_corner	BOTTOM_RIGHT
        }

        PageButton6
        {
            ControlName				RuiButton
            InheritProperties       PaginationButton
            scriptID                6
            xpos                    8

            pin_to_sibling			PageButton7
            pin_corner_to_sibling	RIGHT
            pin_to_sibling_corner	LEFT
        }

        PageButton5
        {
            ControlName				RuiButton
            InheritProperties       PaginationButton
            scriptID                5
            xpos                    8

            pin_to_sibling			PageButton6
            pin_corner_to_sibling	RIGHT
            pin_to_sibling_corner	LEFT
        }

        PageButton4
        {
            ControlName				RuiButton
            InheritProperties       PaginationButton
            scriptID                4
            xpos                    8

            pin_to_sibling			PageButton5
            pin_corner_to_sibling	RIGHT
            pin_to_sibling_corner	LEFT
        }

        PageButton3
        {
            ControlName				RuiButton
            InheritProperties       PaginationButton
            scriptID                3
            xpos                    8

            pin_to_sibling			PageButton4
            pin_corner_to_sibling	RIGHT
            pin_to_sibling_corner	LEFT
        }

        PageButton2
        {
            ControlName				RuiButton
            InheritProperties       PaginationButton
            scriptID                2
            xpos                    8

            pin_to_sibling			PageButton3
            pin_corner_to_sibling	RIGHT
            pin_to_sibling_corner	LEFT
        }

        PageButton1
        {
            ControlName				RuiButton
            InheritProperties       PaginationButton
            scriptID                1
            xpos                    8

            pin_to_sibling			PageButton2
            pin_corner_to_sibling	RIGHT
            pin_to_sibling_corner	LEFT
        }

        PageButton0
        {
            ControlName				RuiButton
            InheritProperties       PaginationButton
            scriptID                0
            xpos                    8

            pin_to_sibling			PageButton1
            pin_corner_to_sibling	RIGHT
            pin_to_sibling_corner	LEFT
        }
	}
}
