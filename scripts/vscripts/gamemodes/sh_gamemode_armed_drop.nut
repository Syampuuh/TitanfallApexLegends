global function IsArmedDropGameMode

global function ShGameMode_ArmedDrop_Init
global function ShGameMode_ArmedDrop_RegisterNetworking

#if CLIENT
global function ShGameMode_ArmedDrop_ServerCallback_PlayerLaunchedFromPlane
#endif

#if DEV
const bool ARMED_DROP_MODE_DEBUG = false
#endif       

#if CLIENT
const asset ASSET_ANNOUNCEMENT_ICON = $"rui/gamemodes/salvo_war_games/war_games_icon"
#endif

void function ShGameMode_ArmedDrop_Init()
{
	if ( !IsArmedDropGameMode() )
	{
		#if DEV
			if ( ARMED_DROP_MODE_DEBUG )
			{
				printf("ShGameMode_ArmedDrop_Init: Game mode disabled. See playlist vars!")
			}
		#endif
		return
	}

	#if SERVER
		                                                                                     
	#endif

	AddCallback_EntitiesDidLoad( ArmedDrop_EntitiesDidLoad )
}

void function ArmedDrop_EntitiesDidLoad()
{
	thread __EntitiesDidLoad()
}

void function __EntitiesDidLoad()
{
	SurvivalCommentary_SetHost( eSurvivalHostType.MAGGIE )
}

void function ShGameMode_ArmedDrop_RegisterNetworking()
{
	if ( !IsArmedDropGameMode() )
	{
		return
	}

	Remote_RegisterClientFunction( "ShGameMode_ArmedDrop_ServerCallback_PlayerLaunchedFromPlane" )
}

#if SERVER
                                                                  
 
	                                                                                                      
 
#endif

#if CLIENT
void function ShGameMode_ArmedDrop_ServerCallback_PlayerLaunchedFromPlane()
{
	ArmedDrop_ServerCallback_AnnouncementSplash()
}

void function ArmedDrop_ServerCallback_AnnouncementSplash()
{
	entity player = GetLocalClientPlayer()
	if ( !IsValid( player ) )
	{
		return
	}

	AnnouncementData announcement = Announcement_Create( "#WAR_GAMESMODE_ARMED_DROP" )
	announcement.drawOverScreenFade = true
	Announcement_SetSubText( announcement, "#WAR_GAMESMODE_ARMED_DROP_ABOUT" )
	Announcement_SetHideOnDeath( announcement, true )
	Announcement_SetDuration( announcement, 16.0 )
	Announcement_SetPurge( announcement, true )
	Announcement_SetStyle( announcement, ANNOUNCEMENT_STYLE_SWEEP )
	Announcement_SetSoundAlias( announcement, SFX_HUD_ANNOUNCE_QUICK )
	Announcement_SetTitleColor( announcement, <0, 0, 0> )
	Announcement_SetIcon( announcement, $"" )
	Announcement_SetLeftIcon( announcement, ASSET_ANNOUNCEMENT_ICON )
	Announcement_SetRightIcon( announcement, ASSET_ANNOUNCEMENT_ICON )
	AnnouncementFromClass( player, announcement )
}
#endif

bool function IsArmedDropGameMode()
{
	return GetCurrentPlaylistVarBool( "is_armed_drop_mode", false )
}