global function IsGlowZonesGameMode

global function ShGameMode_GlowZones_Init
global function ShGameMode_GlowZones_RegisterNetworking

#if CLIENT
global function ShGameMode_GlowZones_ServerCallback_AnnouncementSplash
#endif

#if DEV
const bool GLOW_ZONES_MODE_DEBUG = false
#endif       

#if CLIENT                                        
const asset ASSET_ANNOUNCEMENT_ICON = $"rui/gamemodes/salvo_war_games/war_games_icon"
#endif

void function ShGameMode_GlowZones_Init()
{
	if ( !IsGlowZonesGameMode() )
	{
		#if DEV
			if ( GLOW_ZONES_MODE_DEBUG )
			{
				printf("ShGameMode_GlowZones_Init: Game mode disabled. See playlist vars!")
			}
		#endif
		return
	}

	#if SERVER
		                                                                                     
	#endif

	AddCallback_EntitiesDidLoad( GlowZones_EntitiesDidLoad )
}

void function GlowZones_EntitiesDidLoad()
{
	thread __EntitiesDidLoad()
}

void function __EntitiesDidLoad()
{
	SurvivalCommentary_SetHost( eSurvivalHostType.MAGGIE )
}

void function ShGameMode_GlowZones_RegisterNetworking()
{
	if ( !IsGlowZonesGameMode() )
	{
		return
	}

	Remote_RegisterClientFunction( "ShGameMode_GlowZones_ServerCallback_AnnouncementSplash" )
}

#if SERVER
                                                                  
 
	                                                                                                 
 
#endif

#if CLIENT
void function ShGameMode_GlowZones_ServerCallback_AnnouncementSplash()
{
	entity player = GetLocalClientPlayer()
	if ( !IsValid( player ) )
	{
		return
	}

	int style = ANNOUNCEMENT_STYLE_SWEEP
	float duration = 16.0
	string messageText = "#WAR_GAMESMODE_GLOW_ZONES"
	string subText = "#WAR_GAMESMODE_GLOW_ZONES_ABOUT"
	vector titleColor = <0, 0, 0>
	asset icon = $""
	asset leftIcon = ASSET_ANNOUNCEMENT_ICON
	asset rightIcon = ASSET_ANNOUNCEMENT_ICON
	string soundAlias = SFX_HUD_ANNOUNCE_QUICK

	AnnouncementData announcement = Announcement_Create( messageText )
	announcement.drawOverScreenFade = true
	Announcement_SetSubText( announcement, subText )
	Announcement_SetHideOnDeath( announcement, true )
	Announcement_SetDuration( announcement, duration )
	Announcement_SetPurge( announcement, true )
	Announcement_SetStyle( announcement, style )
	Announcement_SetSoundAlias( announcement, soundAlias )
	Announcement_SetTitleColor( announcement, titleColor )
	Announcement_SetIcon( announcement, icon )
	Announcement_SetLeftIcon( announcement, leftIcon )
	Announcement_SetRightIcon( announcement, rightIcon )
	AnnouncementFromClass( player, announcement )
}
#endif

bool function IsGlowZonesGameMode()
{
	return GetCurrentPlaylistVarBool( "is_glow_zones_mode", false )
}