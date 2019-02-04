"resource/ui/menus/panels/matchmaking_status.res"
{
	Screen
	{
		ControlName		ImagePanel
		wide			%100
		tall			%100
		visible			1
		scaleImage		1
		fillColor		"0 0 0 0"
		drawColor		"0 0 0 0"
	}

	MatchmakingStatus
	{
		ControlName		RuiPanel
		wide			500
		tall			72
		visible			1
		rui             "ui/matchmaking_status.rpak"
		classname				MatchmakingStatusRui

		pin_to_sibling			Screen
		pin_corner_to_sibling	TOP
		pin_to_sibling_corner	TOP
	}
}
