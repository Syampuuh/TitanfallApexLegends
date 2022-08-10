untyped

global function InitRespawnOverlay
global function SetRespawnOverlayTime

global function UI_ClearRespawnOverlay


struct
{
	array<var> respawnRuis

	float respawnStartTime = RUI_BADGAMETIME
	float respawnEndTime = RUI_BADGAMETIME
} file

void function InitRespawnOverlay()
{
	file.respawnRuis = GetElementsByClassnameForMenus( "RespawnStatusRui", uiGlobal.allMenus )
	foreach ( var el in file.respawnRuis )
		printt( "respawnStatusRuis ", GetParentMenu( el ).GetHudName() )

}

void function SetRespawnOverlayTime( float respawnStartTime, float respawnEndTime )
{
	file.respawnStartTime = respawnStartTime
	file.respawnEndTime   = respawnEndTime

	foreach ( var element in file.respawnRuis )
	{
		var rui = Hud_GetRui( Hud_GetChild( element, "RespawnStatus" ) )
		RuiSetGameTime( rui, "respawnStartTime", respawnStartTime )
		RuiSetGameTime( rui, "respawnEndTime", respawnEndTime )
	}
}

void function HideRespawnOverlay()
{
	foreach ( element in file.respawnRuis )
		RuiSetBool( Hud_GetRui( element ), "visible", false )

}

void function ShowRespawnOverlay()
{
	foreach ( element in file.respawnRuis )
		RuiSetBool( Hud_GetRui( element ), "visible", false )

}

void function UI_ClearRespawnOverlay()
{
	SetRespawnOverlayTime( RUI_BADGAMETIME, RUI_BADGAMETIME )
}