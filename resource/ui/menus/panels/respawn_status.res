"resource/ui/menus/panels/respawn_status.res"
{
	Screen
	{
		ControlName		ImagePanel
		wide			%100
		tall			%100
		visible			0
		scaleImage		1
		fillColor		"0 0 0 0"
		drawColor		"0 0 0 0"
	}

	RespawnStatus
	{
		ControlName		RuiPanel
		wide			1920
		tall			1080
		visible			1
		rui             "ui/respawn_status_overlay.rpak"

		pin_to_sibling			Screen
		pin_corner_to_sibling	TOP
		pin_to_sibling_corner	TOP
	}
}
