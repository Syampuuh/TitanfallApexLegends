resource/ui/menus/dialogs/select_slot_quips.res
{
    DarkenBackground
    {
        ControlName				RuiButton
        wide					%100
        tall					%100
        rui                     "ui/basic_image.rpak"
        labelText               ""
        visible					1
        ruiArgs
        {
            basicImageColor     "0 0 0"
            basicImageAlpha     0.98
        }
        navDown                   PurchaseButton0
    }

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    DisplayItem
    {
        ControlName				RuiPanel
        classname               "MenuButton"
        scriptId                0

        proportionalToParent    1
        pin_corner_to_sibling	RIGHT
        pin_to_sibling			DarkenBackground
        pin_to_sibling_corner	TOP_LEFT
        wide					310
        wide_nx_handheld		700			[$NX || $NX_UI_PC]

        rightClickEvents		1
        tall					96
        ypos                    8
        ypos_nx_handheld        125			[$NX || $NX_UI_PC]
        zpos                    100
        cursorPriority          1

        visible					1
        labelText               ""
        rui                     "ui/select_slot_button_quips.rpak"
        cursorVelocityModifier  0.7

        navDown                 PurchaseButton1
    }

    SwapIcon
    {
        ControlName				RuiPanel
        rui                     "ui/basic_image.rpak"
        xpos					0
        ypos					0
        wide					64
        wide_nx_handheld		84		[$NX || $NX_UI_PC]
        tall					64
        tall_nx_handheld		84		[$NX || $NX_UI_PC]
        visible					1


        pin_corner_to_sibling	CENTER
        pin_to_sibling			DarkenBackground
        pin_to_sibling_corner	TOP_LEFT
    }

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    PurchaseButton0
    {
        ControlName				RuiButton
        classname               "MenuButton"
        scriptId                0

        proportionalToParent    1
        pin_corner_to_sibling	LEFT
        pin_to_sibling			DarkenBackground
        pin_to_sibling_corner	TOP_LEFT
        wide					310
        wide_nx_handheld		700			[$NX || $NX_UI_PC]
        rightClickEvents		1
        tall					96
        ypos                    8
        zpos                    100
        cursorPriority          1
        tabPosition             1

        visible					0
        labelText               ""
        rui                     "ui/select_slot_button_quips.rpak"
        cursorVelocityModifier  0.7

        navDown                 PurchaseButton1
    }

    PurchaseButton1
    {
        ControlName				RuiButton
        classname               "MenuButton"
        scriptId                1

        proportionalToParent    1
        pin_corner_to_sibling	TOP
        pin_to_sibling			PurchaseButton0
        pin_to_sibling_corner	BOTTOM


        rightClickEvents		1
        wide					310
        wide_nx_handheld		700			[$NX || $NX_UI_PC]
        tall					96
        ypos                    8
        zpos                    100
        cursorPriority          1
        tabPosition             1

        visible					0
        labelText               ""
        rui                     "ui/select_slot_button_quips.rpak"
        cursorVelocityModifier  0.7

        navUp                   PurchaseButton0
        navDown                 PurchaseButton2
    }

    PurchaseButton2
    {
        ControlName				RuiButton
        classname               "MenuButton"
        scriptId                2

        proportionalToParent    1
        pin_corner_to_sibling	TOP
        pin_to_sibling			PurchaseButton1
        pin_to_sibling_corner	BOTTOM


        rightClickEvents		1
        wide					310
        wide_nx_handheld		700			[$NX || $NX_UI_PC]
        tall					96
        ypos                    8
        zpos                    100
        cursorPriority          1
        tabPosition             1

        visible					0
        labelText               ""
        rui                     "ui/select_slot_button_quips.rpak"
        cursorVelocityModifier  0.7

        navUp                   PurchaseButton1
        navDown                 PurchaseButton3
    }

    PurchaseButton3
    {
        ControlName				RuiButton
        classname               "MenuButton"
        scriptId                3

        proportionalToParent    1
        pin_corner_to_sibling	TOP
        pin_to_sibling			PurchaseButton2
        pin_to_sibling_corner	BOTTOM


        rightClickEvents		1
        wide					310
        wide_nx_handheld		700			[$NX || $NX_UI_PC]
        tall					96
        ypos                    8
        zpos                    100
        cursorPriority          1
        tabPosition             1

        visible					0
        labelText               ""
        rui                     "ui/select_slot_button_quips.rpak"
        cursorVelocityModifier  0.7

        navUp                   PurchaseButton2
        navDown                 PurchaseButton4
    }

    PurchaseButton4
    {
        ControlName				RuiButton
        classname               "MenuButton"
        scriptId                4

        proportionalToParent    1
        pin_corner_to_sibling	TOP
        pin_to_sibling			PurchaseButton3
        pin_to_sibling_corner	BOTTOM


        rightClickEvents		1
        wide					310
        wide_nx_handheld		700			[$NX || $NX_UI_PC]
        tall					96
        ypos                    8
        zpos                    100
        cursorPriority          1
        tabPosition             1

        visible					0
        labelText               ""
        rui                     "ui/select_slot_button_quips.rpak"
        cursorVelocityModifier  0.7

        navUp                   PurchaseButton3
        navDown                   PurchaseButton5
    }

    PurchaseButton5
    {
        ControlName				RuiButton
        classname               "MenuButton"
        scriptId                5

        proportionalToParent    1
        pin_corner_to_sibling	TOP
        pin_to_sibling			PurchaseButton4
        pin_to_sibling_corner	BOTTOM


        rightClickEvents		1
        wide					310
        wide_nx_handheld		700			[$NX || $NX_UI_PC]
        tall					96
        ypos                    8
        zpos                    100
        cursorPriority          1
        tabPosition             1

        visible					0
        labelText               ""
        rui                     "ui/select_slot_button_quips.rpak"
        cursorVelocityModifier  0.7


        navUp                   PurchaseButton4
        navDown                   PurchaseButton6
    }

    PurchaseButton6
    {
        ControlName				RuiButton
        classname               "MenuButton"
        scriptId                6

        proportionalToParent    1
        pin_corner_to_sibling	TOP
        pin_to_sibling			PurchaseButton5
        pin_to_sibling_corner	BOTTOM


        rightClickEvents		1
        wide					310
        wide_nx_handheld		700			[$NX || $NX_UI_PC]
        tall					96
        ypos                    8
        zpos                    100
        cursorPriority          1
        tabPosition             1

        visible					0
        labelText               ""
        rui                     "ui/select_slot_button_quips.rpak"
        cursorVelocityModifier  0.7



        navUp                   PurchaseButton5
        navDown                   PurchaseButton7
    }

    PurchaseButton7
    {
        ControlName				RuiButton
        classname               "MenuButton"
        scriptId                7

        proportionalToParent    1
        pin_corner_to_sibling	TOP
        pin_to_sibling			PurchaseButton6
        pin_to_sibling_corner	BOTTOM


        rightClickEvents		1
        wide					310
        wide_nx_handheld		700			[$NX || $NX_UI_PC]
        tall					96
        ypos                    8
        zpos                    100
        cursorPriority          1
        tabPosition             1

        visible					0
        labelText               ""
        rui                     "ui/select_slot_button_quips.rpak"
        cursorVelocityModifier  0.7


        navUp                   PurchaseButton6
    }
}


