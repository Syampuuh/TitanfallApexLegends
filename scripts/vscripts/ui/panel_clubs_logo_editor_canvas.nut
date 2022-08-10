global function InitClubsLogoEditorCanvasPanel

struct
{
	var canvasPanel
} file

void function InitClubsLogoEditorCanvasPanel( var panel )
{
	file.canvasPanel = panel
	printf( "ClubLogoEditorDebug: Canvas Panel set to %s", Hud_GetHudName( panel ) )
}
