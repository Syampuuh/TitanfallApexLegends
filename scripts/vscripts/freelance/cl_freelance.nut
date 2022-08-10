global function ServerCallback_Freelance_OnPlayerConnected

                  
                                                     
                        
  
global function ClientInit_Freelance

struct
{
	var matchCandyHUDRui
	int evacFXHandle
} file


void function ClientInit_Freelance()
{
	RegisterMinimapPackages()
	AddCallback_OnClientScriptInit( AdjustIngameTextChat )

	AddNeutralTeamConversations()

	AddCallback_GameStateEnter( eGameState.Prematch, DoLevelIntroText )

	ClGamemodeSurvival_Init()

	                       
	{
		CircleCullScriptName( "jump_tower_flag" )
	}
}


void function DoLevelIntroText()
{
                  
                              
                                                                   
                        
}


void function AdjustIngameTextChat( entity player )
{
	const xPos = -32
	const yPos = -150

	var hudElement = HudElement( "IngameTextChat" )
	Hud_SetPos( hudElement, xPos, yPos )
}


void function RegisterMinimapPackages()
{
	                                                                                                                               
	                                                                                                                               
	                                                                                                                               
	                                                                                                                                     

	                                                                                                                                  

	                                        			                                          	                                                        
}

const vector RUI_BURN_COLOR = <0.9216, 0.2384, 0.0212>                                                        
void function MinimapPackage_Target( entity ent, var rui )
{
	RuiSetImage( rui, "defaultIcon", $"rui/hud/gametype_icons/obj_foreground_turret_small" )
	RuiSetImage( rui, "clampedDefaultIcon", $"rui/hud/gametype_icons/obj_foreground_turret_small" )
	RuiSetBool( rui, "useTeamColor", false )
	RuiSetBool( rui, "showOnMinimapOnFire", false )

	RuiSetFloat3( rui, "iconColor", RUI_BURN_COLOR )
}


void function MinimapPackage_ObjectiveAreaInit( entity ent, var rui )
{
	if ( ent.IsClientOnly() )
		RuiSetFloat( rui, "objectRadius", ent.e.clientEntMinimapScale )
	else
		RuiTrackFloat( rui, "objectRadius", ent, RUI_TRACK_MINIMAP_SCALE )
	RuiSetImage( rui, "clampedImage", $"rui/hud/gametype_icons/obj_foreground_turret_small" )
	RuiSetImage( rui, "centerImage", $"rui/hud/gametype_icons/obj_foreground_turret_small" )
}


void function ServerCallback_Freelance_OnPlayerConnected()
{
	if ( Freelance_IsHubLevel() )
	{
		thread InitHubHUD()
		MatchmakingStatus_AddOverlayToHUD()
	}
}


void function InitHubHUD()
{
	Assert( IsNewThread(), "Must be threaded off." )

	var rui = CreateCockpitRui( $"ui/pve_hub_hud.rpak", 500 )

	                                      
	                                                                                                                                      

	file.matchCandyHUDRui = rui

	OnThreadEnd(
		function() : ( rui )
		{
			RuiDestroy( rui )
		}
	)

	for ( ; ; )
	{
		entity player = GetLocalClientPlayer()
		if ( !IsValid( player ) )
			continue

                     
            
   
                                                                   
                                                    
   
        

                    
               
   
                                                                                 
                                                           
   
                          

		WaitFrame()
	}
}

                  
                                                                                                                        
 
                                                            
                

                             
                                                           

                     
  
                                      

                        
   
                            
                                            

                         
    
                                                                         
                                                                  

                           
     
                                                                                           
     
    
   
  
 
                        
