resource/ui/menus/system.res
{
    ToolTip
    {
        ControlName				RuiPanel
        InheritProperties       ToolTip
    }

    ScreenFrame
    {
        ControlName				ImagePanel
        xpos					0
        ypos					0
        wide                    %100
        tall					%100
        visible					1
        enabled 				1
        scaleImage				1
        image					"vgui/HUD/white"
        drawColor				"0 0 0 0"
    }

    Button0
    {
        ControlName				RuiButton
        classname				"SystemButtonClass MenuButton"
        scriptID				0
        ypos                    16
        wide					376
        tall					60
        rui                     "ui/generic_button.rpak"
        labelText               ""
        visible					1
        cursorVelocityModifier  0.7
        tabPosition             1

        pin_to_sibling			ScreenFrame
        pin_corner_to_sibling	CENTER
        pin_to_sibling_corner	CENTER
    }

    Button1
    {
        ControlName				RuiButton
        classname				"SystemButtonClass MenuButton"
        scriptID				1
        ypos                    8
        wide					376
        tall					60
        rui                     "ui/generic_button.rpak"
        labelText               ""
        visible					1
        cursorVelocityModifier  0.7
        tabPosition             2

        pin_to_sibling			Button0
        pin_corner_to_sibling	TOP
        pin_to_sibling_corner	BOTTOM
    }

    Button2
    {
        ControlName				RuiButton
        classname				"SystemButtonClass MenuButton"
        scriptID				2
        ypos                    8
        wide					376
        tall					60
        rui                     "ui/generic_button.rpak"
        labelText               ""
        visible					1
        cursorVelocityModifier  0.7
        tabPosition             3

        pin_to_sibling			Button1
        pin_corner_to_sibling	TOP
        pin_to_sibling_corner	BOTTOM
    }

    Button3
    {
        ControlName				RuiButton
        classname				"SystemButtonClass MenuButton"
        scriptID				3
        ypos                    8
        wide					376
        tall					60
        rui                     "ui/generic_button.rpak"
        labelText               ""
        visible					1
        cursorVelocityModifier  0.7
        tabPosition             4

        pin_to_sibling			Button2
        pin_corner_to_sibling	TOP
        pin_to_sibling_corner	BOTTOM
    }
}
