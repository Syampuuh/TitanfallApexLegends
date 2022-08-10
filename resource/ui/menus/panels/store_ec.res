"resource/ui/menus/panels/store_ec.res"
{
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	PanelFrame
	{
		ControlName				Label
		wide					%100
		tall					%100
		labelText				""
	    bgcolor_override		"70 70 0 128"
		visible					0
		paintbackground			1
        proportionalToParent    1
	}

	RightHeader
	{
		ControlName				RuiPanel
		xpos					0
		ypos					48
		wide					332
		tall					48
		visible					1
        rui					    "ui/store_header_ec.rpak"
	}

	LeftHeader
	{
		ControlName				RuiPanel
		xpos					0
		ypos					48
		wide					1004
		tall					48
		visible					1
        rui					    "ui/store_header_ec.rpak"
	}

	SpecialPageHeader
	{
		ControlName				RuiPanel
        rui					    "ui/store_header_special.rpak"

        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling			PanelFrame
        pin_to_sibling_corner	TOP_LEFT
		xpos					0
		ypos					0
		wide					1920
		tall					160

		visible					0
	}

	ButtonAnchor
	{
		ControlName				Label
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling			PanelFrame
        pin_to_sibling_corner	TOP_LEFT
		xpos                    0
		ypos                    28
		wide					1
		tall					1

		labelText				""
	    bgcolor_override		"70 70 0 128"
		visible					0
		paintbackground			1
        proportionalToParent    1
	}

	TallButton1
	{
		ControlName				RuiButton
		xpos					0
		ypos					-112
		zpos                    5
		wide					420
		tall					672
		visible					1
        rui					    "ui/store_button_ec_v2.rpak"
        scriptID                0
        classname               "FullOfferButton"

        navRight                SquareButton2x1

        tabPosition             1

        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling			ButtonAnchor
        pin_to_sibling_corner	TOP_LEFT
	}
	TallButtonFade1
	{
		ControlName				RuiPanel
		xpos					0
		ypos					-112
		zpos                    6
		wide					420
		tall					672
		visible					1
        rui					    "ui/store_button_ec_v2.rpak"
        scriptID                0
        classname               "FullOfferButtonFade"
        enable                  0

        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling			ButtonAnchor
        pin_to_sibling_corner	TOP_LEFT
	}


	TallButton2
	{
		ControlName				RuiButton
		xpos					24
		ypos					0
		zpos                    5
		wide					420
		tall					672
		visible					1
        rui					    "ui/store_button_ec_v2.rpak"
        scriptID                1
        classname               "FullOfferButton"

        navRight                SquareButton3x1
        navLeft                 SquareButton2x1

        pin_to_sibling			TallButton1
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
	}
	TallButtonFade2
	{
		ControlName				RuiPanel
		xpos					24
		ypos					0
		zpos                    6
		wide					420
		tall					672
		visible					1
        rui					    "ui/store_button_ec_v2.rpak"
        scriptID                1
        classname               "FullOfferButtonFade"

        pin_to_sibling			TallButton1
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
	}


	TallButton3
	{
		ControlName				RuiButton
		xpos					24
		ypos					0
		zpos                    5
		wide					420
		tall					672
		visible					1
        rui					    "ui/store_button_ec_v2.rpak"
        scriptID                2
        classname               "FullOfferButton"

        navRight                SquareButton4x1
        navLeft                 SquareButton3x1

        pin_to_sibling			TallButton2
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
	}
	TallButtonFade3
	{
		ControlName				RuiPanel
		xpos					24
		ypos					0
		zpos                    6
		wide					420
		tall					672
		visible					1
        rui					    "ui/store_button_ec_v2.rpak"
        scriptID                2
        classname               "FullOfferButtonFade"

        pin_to_sibling			TallButton2
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
	}

	TallButton4
	{
		ControlName				RuiButton
		xpos					24
		ypos					0
		zpos                    5
		wide					420
		tall					672
		visible					1
        rui					    "ui/store_button_ec_v2.rpak"
        scriptID                3
        classname               "FullOfferButton"

        navRight                SquareButton5x1
        navLeft                 SquareButton4x1

        pin_to_sibling			TallButton3
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
	}
	TallButtonFade4
	{
		ControlName				RuiPanel
		xpos					24
		ypos					0
		zpos                    6
		wide					420
		tall					672
		visible					1
        rui					    "ui/store_button_ec_v2.rpak"
        scriptID                3
        classname               "FullOfferButtonFade"

        pin_to_sibling			TallButton3
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
	}

	TallButton5
	{
		ControlName				RuiButton
		xpos					24
		ypos					0
		zpos                    5
		wide					420
		tall					672
		visible					1
        rui					    "ui/store_button_ec_v2.rpak"
        scriptID                4
        classname               "FullOfferButton"

        pin_to_sibling			TallButton4
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
	}
	TallButtonFade5
	{
		ControlName				RuiPanel
		xpos					24
		ypos					0
		zpos                    6
		wide					420
		tall					672
		visible					1
        rui					    "ui/store_button_ec_v2.rpak"
        scriptID                4
        classname               "FullOfferButtonFade"

        pin_to_sibling			TallButton4
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
	}

	SquareButton1x1
	{
		ControlName				RuiButton
		zpos                    5
		wide					370
		tall					324
		visible					1
        rui					    "ui/store_button_ec_v2.rpak"
        scriptID                0
        classname               "TopOfferButton"

        tabPosition             1

        navDown                 SquareButton1x2
        navRight                TallButton2

        pin_to_sibling			TallButton1
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_LEFT
	}
	SquareButton1x1Fade
	{
		ControlName				RuiPanel
		zpos                    6
		wide					370
		tall					324
		visible					1
        rui					    "ui/store_button_ec_v2.rpak"
        scriptID                0
        classname               "TopOfferButtonFade"

        pin_to_sibling			TallButton1
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_LEFT
	}

	SquareButton1x2
	{
		ControlName				RuiButton
		zpos                    5
		wide					370
		tall					324
		visible					1
        rui					    "ui/store_button_ec_v2.rpak"
        scriptID                0
        classname               "BottomOfferButton"

        navUp                   SquareButton1x1
        navRight                TallButton2

        pin_to_sibling			TallButton1
        pin_corner_to_sibling	BOTTOM_RIGHT
        pin_to_sibling_corner	BOTTOM_RIGHT
	}
	SquareButton1x2Fade
	{
		ControlName				RuiPanel
		zpos                    6
		wide					370
		tall					324
		visible					1
        rui					    "ui/store_button_ec_v2.rpak"
        scriptID                0
        classname               "BottomOfferButtonFade"

        pin_to_sibling			TallButton1
        pin_corner_to_sibling	BOTTOM_RIGHT
        pin_to_sibling_corner	BOTTOM_RIGHT
	}

	SquareButton2x1
	{
		ControlName				RuiButton
		zpos                    5
		wide					370
		tall					324
		visible					1
        rui					    "ui/store_button_ec_v2.rpak"
        scriptID                1
        classname               "TopOfferButton"

        navDown                 SquareButton2x2
        navRight                TallButton2
        navLeft                 TallButton1

        pin_to_sibling			TallButton2
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_LEFT
	}
	SquareButton2x1Fade
	{
		ControlName				RuiPanel
		zpos                    6
		wide					370
		tall					324
		visible					1
        rui					    "ui/store_button_ec_v2.rpak"
        scriptID                1
        classname               "TopOfferButtonFade"

        pin_to_sibling			TallButton2
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_LEFT
	}

	SquareButton2x2
	{
		ControlName				RuiButton
		zpos                    5
		wide					370
		tall					324
		visible					1
        rui					    "ui/store_button_ec_v2.rpak"
        scriptID                1
        classname               "BottomOfferButton"

        navUp                   SquareButton2x1
        navRight                TallButton2
        navLeft                 TallButton1

        pin_to_sibling			TallButton2
        pin_corner_to_sibling	BOTTOM_RIGHT
        pin_to_sibling_corner	BOTTOM_RIGHT
	}
	SquareButton2x2Fade
	{
		ControlName				RuiPanel
		zpos                    6
		wide					370
		tall					324
		visible					1
        rui					    "ui/store_button_ec_v2.rpak"
        scriptID                1
        classname               "BottomOfferButtonFade"

        pin_to_sibling			TallButton2
        pin_corner_to_sibling	BOTTOM_RIGHT
        pin_to_sibling_corner	BOTTOM_RIGHT
	}

	SquareButton3x1
	{
		ControlName				RuiButton
		zpos                    5
		wide					370
		tall					324
		visible					1
        rui					    "ui/store_button_ec_v2.rpak"
        scriptID                2
        classname               "TopOfferButton"

        navLeft                 TallButton2
        navDown                 SquareButton3x2
        navRight                TallButton3

        pin_to_sibling			TallButton3
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_LEFT
	}
	SquareButton3x1Fade
	{
		ControlName				RuiPanel
		zpos                    6
		wide					370
		tall					324
		visible					1
        rui					    "ui/store_button_ec_v2.rpak"
        scriptID                2
        classname               "TopOfferButtonFade"

        pin_to_sibling			TallButton3
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_LEFT
	}

	SquareButton3x2
	{
		ControlName				RuiButton
		zpos                    5
		wide					370
		tall					324
		visible					1
        rui					    "ui/store_button_ec_v2.rpak"
        scriptID                2
        classname               "BottomOfferButton"

        navLeft                 TallButton2
        navUp                   SquareButton3x1
        navRight                SquareButton5x2

        pin_to_sibling			TallButton3
        pin_corner_to_sibling	BOTTOM_RIGHT
        pin_to_sibling_corner	BOTTOM_RIGHT
	}
	SquareButton3x2Fade
	{
		ControlName				RuiPanel
		zpos                    6
		wide					370
		tall					324
		visible					1
        rui					    "ui/store_button_ec_v2.rpak"
        scriptID                2
        classname               "BottomOfferButtonFade"

        pin_to_sibling			TallButton3
        pin_corner_to_sibling	BOTTOM_RIGHT
        pin_to_sibling_corner	BOTTOM_RIGHT
	}

	SquareButton4x1
	{
		ControlName				RuiButton
		zpos                    5
		wide					370
		tall					324
		visible					1
        rui					    "ui/store_button_ec_v2.rpak"
        scriptID                3
        classname               "TopOfferButton"

        navLeft                 TallButton3
        navDown                 SquareButton4x2
        navRight                TallButton4

        pin_to_sibling			TallButton4
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_LEFT
	}
	SquareButton4x1Fade
	{
		ControlName				RuiPanel
		zpos                    6
		wide					370
		tall					324
		visible					1
        rui					    "ui/store_button_ec_v2.rpak"
        scriptID                3
        classname               "TopOfferButtonFade"

        pin_to_sibling			TallButton4
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_LEFT
	}

	SquareButton4x2
	{
		ControlName				RuiButton
		zpos                    5
		wide					370
		tall					324
		visible					1
        rui					    "ui/store_button_ec_v2.rpak"
        scriptID                3
        classname               "BottomOfferButton"

        navLeft                 TallButton3
        navUp                   SquareButton4x1
        navRight                TallButton4

        pin_to_sibling			TallButton4
        pin_corner_to_sibling	BOTTOM_RIGHT
        pin_to_sibling_corner	BOTTOM_RIGHT
	}
	SquareButton4x2Fade
	{
		ControlName				RuiPanel
		zpos                    6
		wide					370
		tall					324
		visible					1
        rui					    "ui/store_button_ec_v2.rpak"
        scriptID                3
        classname               "BottomOfferButtonFade"

        pin_to_sibling			TallButton4
        pin_corner_to_sibling	BOTTOM_RIGHT
        pin_to_sibling_corner	BOTTOM_RIGHT
	}

	SquareButton5x1
	{
		ControlName				RuiButton
		zpos                    5
		wide					370
		tall					324
		visible					1
        rui					    "ui/store_button_ec_v2.rpak"
        scriptID                4
        classname               "TopOfferButton"

        navLeft                 TallButton4
        navRight                TallButton5
        navDown                 SquareButton5x2

        pin_to_sibling			TallButton5
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_LEFT
	}
	SquareButton5x1Fade
	{
		ControlName				RuiPanel
		zpos                    6
		wide					370
		tall					324
		visible					1
        rui					    "ui/store_button_ec_v2.rpak"
        scriptID                4
        classname               "TopOfferButtonFade"

        pin_to_sibling			TallButton5
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_LEFT
	}

	SquareButton5x2
	{
		ControlName				RuiButton
		zpos                    5
		wide					370
		tall					324
		visible					1
        rui					    "ui/store_button_ec_v2.rpak"
        scriptID                4
        classname               "BottomOfferButton"

        navLeft                 SquareButton3x2
        navRight                TallButton5
        navUp                   SquareButton5x1

        pin_to_sibling			TallButton5
        pin_corner_to_sibling	BOTTOM_RIGHT
        pin_to_sibling_corner	BOTTOM_RIGHT
	}
	SquareButton5x2Fade
	{
		ControlName				RuiPanel
		zpos                    6
		wide					370
		tall					324
		visible					1
        rui					    "ui/store_button_ec_v2.rpak"
        scriptID                4
        classname               "BottomOfferButtonFade"

        pin_to_sibling			TallButton5
        pin_corner_to_sibling	BOTTOM_RIGHT
        pin_to_sibling_corner	BOTTOM_RIGHT
	}
}