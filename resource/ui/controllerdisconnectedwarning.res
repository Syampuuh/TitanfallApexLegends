ControllerDisconnectedWarningLayout
{
	ControlName				Frame
	xpos					0
	ypos					0
	zpos					999
	wide					f0
	tall					f0
	autoResize				0
	pinCorner				0
	visible					1
	enabled					1
	tabPosition				0
	PaintBackgroundType		0
	infocus_bgcolor_override	"0 0 0 0"
	outoffocus_bgcolor_override	"0 0 0 0"

		DarkenBackground
		{
			ControlName				RuiPanel
			wide					%100
			tall					%100
			visible					1
			rui                     "ui/basic_image.rpak"

            ruiArgs
            {
                basicImageColor     "0 0 0"
                basicImageAlpha     0.65
            }
		}

        DialogFrame
        {
            ControlName				Label
            wide					%100
            tall					480
            labelText				""
            bgcolor_override		"0 0 0 255"
            visible					0
            paintbackground			1

            pin_to_sibling			DarkenBackground
            pin_corner_to_sibling	CENTER
            pin_to_sibling_corner	CENTER
        }

        ContentRui
        {
            ControlName				RuiPanel
            classname               "MenuButton"
            wide					%100
            tall					480
            visible				    1
            rui                     "ui/dialog_content.rpak"

			pin_to_sibling			DialogFrame
			pin_corner_to_sibling	TOP
			pin_to_sibling_corner	TOP
        }

    DialogImage
    {
        ControlName				RuiPanel
        xpos                    0
        ypos                    -32
        wide					120
        tall					120
        visible					1
        rui                     "ui/controller_disconnected_image.rpak"

        pin_to_sibling			DialogFrame
        pin_corner_to_sibling	TOP
        pin_to_sibling_corner	TOP
    }

    DialogHeader
    {
        ControlName				Label
        xpos					0
        ypos                    0
        auto_wide_tocontents	1
        tall					80
        visible					1
        labelText				"#CONTROLLER_DISCONNECTED_TITLE"
        font					DefaultBold_80
		fontHeight_nx_handheld	50		[$NX || $NX_UI_PC]
        allcaps					1
        fgcolor_override		"255 255 255 255"

        pin_to_sibling			DialogImage
        pin_corner_to_sibling	TOP
        pin_to_sibling_corner	BOTTOM
    }

    DialogMessage
    {
		ControlName				RuiPanel
        rui                     "ui/controller_disconnected_message.rpak"
        ypos					32
        wide					736
        tall					81
        visible					1

        pin_to_sibling			DialogHeader
        pin_corner_to_sibling	TOP
        pin_to_sibling_corner	BOTTOM
    }


}