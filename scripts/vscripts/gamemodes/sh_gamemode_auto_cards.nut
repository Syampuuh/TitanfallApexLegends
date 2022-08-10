global function IsAutoCardsGameMode
global function ShGameMode_AutoCards_Init
global function ShGameMode_AutoCards_RegisterNetworking

#if CLIENT
global function ShGameMode_AutoCards_ServerCallback_AnnouncementSplash
global function ShGameMode_AutoCards_ServerCallback_RetrievalNotice
#endif          

#if DEV
const bool HOT_DROP_MODE_DEBUG = false
#endif       

#if CLIENT
const asset ASSET_ANNOUNCEMENT_ICON = $"rui/gamemodes/salvo_war_games/war_games_icon"

const vector BONUS_COLOR = < 124.0 / 255.0, 39.0 / 255.0, 229.0 / 255.0 >
#endif

const string BULLET_AMMO = "bullet"
const string HIGHCAL_AMMO = "highcal"
const string SHOTGUN_AMMO = "shotgun"
const string SPECIAL_AMMO = "special"
                     
                                    
      
const string ARROWS_AMMO = "arrows"
const string SNIPER_AMMO = "sniper"

#if SERVER
                                   	         
									          
									          
									          
                              
                      
               
									         
									          
#endif

void function ShGameMode_AutoCards_Init()
{
	#if DEV
		if ( HOT_DROP_MODE_DEBUG )
		{
			printf("ShGameMode_AutoCards_Init()")
		}
	#endif

	if ( !IsAutoCardsGameMode() )
	{
		#if DEV
			if ( HOT_DROP_MODE_DEBUG )
			{
				printf("ShGameMode_AutoCards_Init: Hot Drop Game Mode Disabled. See playlist vars!")
			}
		#endif
		return
	}
	#if SERVER
		                                                            
		                                                                                     
	#endif

	AddCallback_EntitiesDidLoad( AutoCards_EntitiesDidLoad )
}

void function AutoCards_EntitiesDidLoad()
{
	thread __EntitiesDidLoad()
}

void function __EntitiesDidLoad()
{
	SurvivalCommentary_SetHost( eSurvivalHostType.MAGGIE )
}

void function ShGameMode_AutoCards_RegisterNetworking()
{
	if ( !IsAutoCardsGameMode() )
		return

	Remote_RegisterClientFunction( "ShGameMode_AutoCards_ServerCallback_AnnouncementSplash" )
	Remote_RegisterClientFunction( "ShGameMode_AutoCards_ServerCallback_RetrievalNotice" )
}

#if SERVER
                                                                                                 
 
	       
		                          
		 
			                                       
		 
	      

	                                       
	 
		                                                         
		                                                        
		                                      
		 
			                                                                                                 
			                               
		 
	 

	                     
	                                   
	                        
	 
		                                                                           

		                           
		 
			                                 
			                                         
			                                                                                                   
		 
	 
 

                                                           
 
	                                                                                   
	                  
	 
		                 
			                                                                                 
		                  
			                                                                                
		                  
			                                                                                  
		                  
			                                                                                 
                     
                 
                                                                                  
      
		                 
			                                                                                
		                 
			                                                                                 
	 
	                        
 

                                                                  
 
	                         
		      

	                                                                                                 
 
#endif

#if CLIENT
void function ShGameMode_AutoCards_ServerCallback_AnnouncementSplash()
{
	entity player = GetLocalClientPlayer()
	if ( !IsValid( player ) )
		return

	AnnouncementData announcement = Announcement_Create( "#WAR_GAMESMODE_AUTO_CARDS" )
	announcement.drawOverScreenFade = true
	Announcement_SetSubText( announcement, "#WAR_GAMESMODE_AUTO_CARDS_ABOUT" )
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

void function ShGameMode_AutoCards_ServerCallback_RetrievalNotice()
{
	entity player = GetLocalClientPlayer()
	if ( !IsValid( player ) )
		return

	AnnouncementData announcement = Announcement_Create( "#WAR_GAMESMODE_AUTO_CARDS_NOTICE" )
	announcement.drawOverScreenFade = true
	Announcement_SetHideOnDeath( announcement, true )
	Announcement_SetDuration( announcement, 8.0 )
	Announcement_SetPurge( announcement, true )
	Announcement_SetStyle( announcement, ANNOUNCEMENT_STYLE_QUICK )
	Announcement_SetSoundAlias( announcement, "" )
	Announcement_SetTitleColor( announcement, GetKeyColor( COLORID_HUD_HEAL_COLOR ) )
	AnnouncementFromClass( player, announcement )
}
#endif

bool function IsAutoCardsGameMode()
{
	return GetCurrentPlaylistVarBool( "is_auto_cards_mode", false )
}
