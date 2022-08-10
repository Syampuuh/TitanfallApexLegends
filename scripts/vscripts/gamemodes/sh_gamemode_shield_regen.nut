global function IsShieldRegenGameMode
global function ShGameMode_ShieldRegen_Init
global function ShGameMode_ShieldRegen_RegisterNetworking

#if CLIENT
global function ShGameMode_ShieldRegen_ServerCallback_AnnouncementSplash
#endif

#if DEV
const bool POWER_WEAPONS_MODE_DEBUG = false
#endif       

#if CLIENT                                        
const asset ASSET_ANNOUNCEMENT_ICON = $"rui/gamemodes/salvo_war_games/war_games_icon"
#endif

void function ShGameMode_ShieldRegen_Init()
{
	#if DEV
		if ( POWER_WEAPONS_MODE_DEBUG )
		{
			printf("ShGameMode_ShieldRegen_Init()")
		}
	#endif

	if ( !IsShieldRegenGameMode() )
	{
		#if DEV
			if ( POWER_WEAPONS_MODE_DEBUG )
			{
				printf("ShGameMode_ShieldRegen_Init: Game mode disabled. See playlist vars!")
			}
		#endif
		return
	}

	#if SERVER
		                              
			                                                                                       
	#endif

	if ( IsShieldRegenGameMode() )
		AddCallback_EntitiesDidLoad( ShieldRegen_EntitiesDidLoad )
}

void function ShieldRegen_EntitiesDidLoad()
{
	thread __EntitiesDidLoad()
}

void function __EntitiesDidLoad()
{
	SurvivalCommentary_SetHost( eSurvivalHostType.MAGGIE )
}

void function ShGameMode_ShieldRegen_RegisterNetworking()
{
	if ( !IsShieldRegenGameMode() )
	{
		return
	}

	if ( IsShieldRegenGameMode() )
		Remote_RegisterClientFunction( "ShGameMode_ShieldRegen_ServerCallback_AnnouncementSplash" )
}

#if SERVER
                                                                    
 
	                                                                                                   
 
#endif

#if CLIENT
void function ShGameMode_ShieldRegen_ServerCallback_AnnouncementSplash()
{
	entity player = GetLocalClientPlayer()
	if ( !IsValid( player ) )
	{
		return
	}

	int style = ANNOUNCEMENT_STYLE_SWEEP
	float duration = 16.0
	string messageText = "#WAR_GAMESMODE_SHIELD_REGEN"
	string subText = "#WAR_GAMESMODE_SHIELD_REGEN_ABOUT"
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

                                            
bool function IsShieldRegenGameMode()
{
	return GetCurrentPlaylistVarBool( "is_shield_regen_mode", false )
}
