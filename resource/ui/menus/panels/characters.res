"resource/ui/menus/panels/characters.res"
{
    PanelFrame
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

    //ActionButton
    //{
    //    ControlName				RuiButton
    //    classname               "MenuButton"
    //    wide					280
    //    tall					80
    //    xpos                    -28
    //    ypos                    -25
    //    rui                     "ui/generic_loot_button.rpak"
    //    labelText               ""
    //    visible					0
    //    cursorVelocityModifier  0.7

    //    pin_to_sibling			PanelFrame
    //    pin_corner_to_sibling	BOTTOM_LEFT
    //    pin_to_sibling_corner	BOTTOM_LEFT
    //}

    ActionLabel
    {
        ControlName				Label
        auto_wide_tocontents 	1
        auto_tall_tocontents 	1
        visible					0
        labelText				"This is a Label"
        fgcolor_override		"220 220 220 255"
        fontHeight              36
        ypos                    316
        xpos                    64

        pin_to_sibling			CharacterSelectInfo
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
    }

    CharacterSelectInfo
    {
        ControlName		        RuiPanel
        xpos                    -150
        ypos                    -120
        wide                    740
        tall                    153
        visible			        1
        rui                     "ui/character_select_info.rpak"

        pin_to_sibling			PanelFrame
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_LEFT
    }

    // ROW 1 ----------------------------------------------

    CharacterButton0
    {
        ControlName				RuiButton
        InheritProperties		LobbyCharacterButton
        classname               CharacterButtonClass
        scriptID				0
        xpos                    60
        ypos                    320
        visible                 0
        tabPosition             1
        cursorVelocityModifier  0.7

        navLeft                 CharacterButton5
        navRight                CharacterButton1
        navUp                   CharacterButton6
        navDown                 CharacterButton6
    }
    CharacterButton1
    {
        ControlName				RuiButton
        InheritProperties		LobbyCharacterButton
        classname               CharacterButtonClass
        scriptID				1
        xpos                    -121
        visible					0
        cursorVelocityModifier  0.7

        navLeft                 CharacterButton0
        navRight                CharacterButton2
        navUp                   CharacterButton6
        navDown                 CharacterButton6

        pin_to_sibling			CharacterButton0
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_LEFT //TOP_RIGHT
    }
    CharacterButton2
    {
        ControlName				RuiButton
        InheritProperties		LobbyCharacterButton
        classname               CharacterButtonClass
        scriptID				2
        xpos                    -121
        visible					0
        cursorVelocityModifier  0.7

        navLeft                 CharacterButton1
        navRight                CharacterButton3
        navUp                   CharacterButton6
        navDown                 CharacterButton6

        pin_to_sibling			CharacterButton1
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_LEFT
    }
    CharacterButton3
    {
        ControlName				RuiButton
        InheritProperties		LobbyCharacterButton
        classname               CharacterButtonClass
        scriptID				3
        xpos                    -121
        visible					0
        cursorVelocityModifier  0.7

        navLeft                 CharacterButton2
        navRight                CharacterButton4
        navUp                   CharacterButton7
        navDown                 CharacterButton7

        pin_to_sibling			CharacterButton2
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_LEFT
    }
    CharacterButton4
    {
        ControlName				RuiButton
        InheritProperties		LobbyCharacterButton
        classname               CharacterButtonClass
        scriptID				4
        xpos                    -121
        visible					0
        cursorVelocityModifier  0.7

        navLeft                 CharacterButton3
        navRight                CharacterButton5
        navUp                   CharacterButton8
        navDown                 CharacterButton8

        pin_to_sibling			CharacterButton3
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_LEFT
    }
    CharacterButton5
    {
        ControlName				RuiButton
        InheritProperties		LobbyCharacterButton
        classname               CharacterButtonClass
        scriptID				5
        xpos                    -121
        visible					0
        cursorVelocityModifier  0.7

        navLeft                 CharacterButton4
        navRight                CharacterButton0
        navUp                   CharacterButton9
        navDown                 CharacterButton9

        pin_to_sibling			CharacterButton4
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_LEFT
    }

    // ROW 2 ----------------------------------------------

    CharacterButton6
    {
        ControlName				RuiButton
        InheritProperties		LobbyCharacterButton
        classname               CharacterButtonClass
        scriptID				5
        xpos                    -24//72
        visible					0
        cursorVelocityModifier  0.7

        navLeft                CharacterButton11
        navRight                CharacterButton7
        navUp                   CharacterButton2
        navDown                 CharacterButton2

        pin_to_sibling			CharacterButton1
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
    }
    CharacterButton7
    {
        ControlName				RuiButton
        InheritProperties		LobbyCharacterButton
        classname               CharacterButtonClass
        scriptID				6
        xpos                    -121
        visible					0
        cursorVelocityModifier  0.7

        navLeft                 CharacterButton6
        navRight                CharacterButton8
        navUp                   CharacterButton3
        navDown                 CharacterButton3

        pin_to_sibling			CharacterButton6
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_LEFT
    }
    CharacterButton8
    {
        ControlName				RuiButton
        InheritProperties		LobbyCharacterButton
        classname               CharacterButtonClass
        scriptID				7
        xpos                    -121
        visible					0
        cursorVelocityModifier  0.7

        navLeft                 CharacterButton7
        navRight                CharacterButton9
        navUp                   CharacterButton4
        navDown                 CharacterButton4

        pin_to_sibling			CharacterButton7
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_LEFT
    }
    CharacterButton9
    {
        ControlName				RuiButton
        InheritProperties		LobbyCharacterButton
        classname               CharacterButtonClass
        scriptID				8
        xpos                    -121
        visible					0
        cursorVelocityModifier  0.7

        navLeft                 CharacterButton8
        navRight                CharacterButton10
        navUp                   CharacterButton5
        navDown                 CharacterButton5

        pin_to_sibling			CharacterButton8
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_LEFT
    }
    CharacterButton10
    {
        ControlName				RuiButton
        InheritProperties		LobbyCharacterButton
        classname               CharacterButtonClass
        scriptID				9
        xpos                    -121
        visible					0
        cursorVelocityModifier  0.7

        navLeft                 CharacterButton9
        navRight                CharacterButton11
        navUp                   CharacterButton6
        navDown                 CharacterButton6

        pin_to_sibling			CharacterButton9
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_LEFT
    }
    CharacterButton11
    {
        ControlName				RuiButton
        InheritProperties		LobbyCharacterButton
        classname               CharacterButtonClass
        scriptID				9
        xpos                    -121
        visible					0
        cursorVelocityModifier  0.7

        navLeft                 CharacterButton10
        navRight                CharacterButton6
        navUp                   CharacterButton7
        navDown                 CharacterButton7

        pin_to_sibling			CharacterButton10
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_LEFT
    }

    // ROW 3 ----------------------------------------------

    CharacterButton12
    {
        ControlName             RuiButton
        InheritProperties       LobbyCharacterButton
        classname               CharacterButtonClass
        scriptID                10
        xpos                    72 // -48
        visible                 0
        cursorVelocityModifier  0.7

        //navUp                   CharacterButton6
        //navRight                CharacterButton11

        pin_to_sibling			CharacterButton7
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
    }
    CharacterButton13
    {
        ControlName             RuiButton
        InheritProperties       LobbyCharacterButton
        classname               CharacterButtonClass
        scriptID                11
        xpos                    -121
        visible                 0
        cursorVelocityModifier  0.7

        //navUp                   CharacterButton7
        //navDown                 CharacterButton15
        //navLeft                 CharacterButton10
        //navRight                CharacterButton12

        pin_to_sibling          CharacterButton12
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_LEFT
    }
    CharacterButton14
    {
        ControlName             RuiButton
        InheritProperties       LobbyCharacterButton
        classname               CharacterButtonClass
        scriptID                12
        xpos                    -121
        visible                 0
        cursorVelocityModifier  0.7

        //navUp                   CharacterButton8
        //navDown                 CharacterButton16
        //navLeft                 CharacterButton11
        //navRight                CharacterButton13

        pin_to_sibling          CharacterButton13
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_LEFT
    }
    CharacterButton15
    {
        ControlName             RuiButton
        InheritProperties       LobbyCharacterButton
        classname               CharacterButtonClass
        scriptID                13
        xpos                    -121
        visible                 0
        cursorVelocityModifier  0.7

        //navUp                   CharacterButton9
        //navDown                 CharacterButton17
        //navLeft                 CharacterButton12
        //navRight                CharacterButton14

        pin_to_sibling          CharacterButton14
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_LEFT
    }
    CharacterButton16
    {
        ControlName             RuiButton
        InheritProperties       LobbyCharacterButton
        classname               CharacterButtonClass
        scriptID                14
        xpos                    -121
        visible                 0
        cursorVelocityModifier  0.7

        //navDown                 CharacterButton18
        //navLeft                 CharacterButton13

        pin_to_sibling          CharacterButton15
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_LEFT
    }
    CharacterButton17
    {
        ControlName             RuiButton
        InheritProperties       LobbyCharacterButton
        classname               CharacterButtonClass
        scriptID                15
        xpos                    -121
        visible                 0
        cursorVelocityModifier  0.7

        //navUp                   CharacterButton11
        //navRight                CharacterButton16

        pin_to_sibling          CharacterButton16
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_LEFT
    }

    // ROW 3 ----------------------------------------------

    CharacterButton18
    {
        ControlName             RuiButton
        InheritProperties       LobbyCharacterButton
        classname               CharacterButtonClass
        scriptID                16
        xpos                    72 // -48
        visible                 0
        cursorVelocityModifier  0.7

        //navUp                   CharacterButton12
        //navLeft                 CharacterButton15
        //navRight                CharacterButton17

        pin_to_sibling			CharacterButton13
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
    }
    CharacterButton19
    {
        ControlName             RuiButton
        InheritProperties       LobbyCharacterButton
        classname               CharacterButtonClass
        scriptID                17
        xpos                    -121
        visible                 0
        cursorVelocityModifier  0.7

        //navUp                   CharacterButton13
        //navLeft                 CharacterButton16
        //navRight                CharacterButton18

        pin_to_sibling          CharacterButton18
        pin_corner_to_sibling   TOP_LEFT
        pin_to_sibling_corner   TOP_LEFT
    }
    CharacterButton20
    {
        ControlName             RuiButton
        InheritProperties       LobbyCharacterButton
        classname               CharacterButtonClass
        scriptID                18
        xpos                    -121
        visible                 0
        cursorVelocityModifier  0.7

        //navUp                   CharacterButton14
        //navLeft                 CharacterButton17

        pin_to_sibling          CharacterButton19
        pin_corner_to_sibling   TOP_LEFT
        pin_to_sibling_corner   TOP_LEFT
    }
    CharacterButton21
    {
        ControlName             RuiButton
        InheritProperties       LobbyCharacterButton
        classname               CharacterButtonClass
        scriptID                19
        xpos                    -121
        visible                 0
        cursorVelocityModifier  0.7

        pin_to_sibling          CharacterButton20
        pin_corner_to_sibling   TOP_LEFT
        pin_to_sibling_corner   TOP_LEFT
    }
}

