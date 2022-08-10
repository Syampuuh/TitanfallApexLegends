global function ControlGunRackPanels_Init

global const string CONTROLGUNRACKPANEL_CLASS_NAME = "control_gun_rack_panel"
const float CONTROLGUNRACKPANEL_INTERACT_DURATION = 1.0

#if SERVER
                                                                                               
#endif          

#if CLIENT
const string CONTROLGUNRACKPANEL_USE_LOOP_SOUND = "survival_titan_linking_loop"
const string CONTROLGUNRACKPANEL_USE_SUCCESS_SOUND = "ui_menu_store_purchase_success"
const string CONTROLGUNRACKPANEL_USE_FAIL_SOUND = "menu_deny"
const asset GUNRACKPANEL_MAP_ICON = $"rui/menu/buttons/battlepass/weapon_skin"
#endif          

struct
{
#if SERVER
	                              
#endif          
	table <entity, int> gunRackPanelToLootTierTable
} file

void function ControlGunRackPanels_Init()
{
	if ( !Control_IsModeEnabled() || !GetCurrentPlaylistVarBool( "control_enable_gunracks", false ) || GetCurrentPlaylistVarBool( "control_gunracks_self_replenish", false ) || GetCurrentPlaylistVarBool( "control_gunracks_reset_all_group_loot_on_pickup", false ) )
	{
		#if SERVER
			                                                                                   
		#endif          
		return
	}

	#if SERVER
		                                          
		                                                                                                           
		                                                
	#endif          

	#if CLIENT
		AddCreateCallback( "prop_dynamic", OnControlGunRackPanelSpawned )
		RegisterSignal( "ControlGunRackPanels_ExtendedUseSuccess" )
	#endif          
}

#if SERVER
                                                          
                                 
 
	                   
	                                                        
	 
		                                                

		                        
		                                                        
		                                                                                                           
		                                                                                
		                                                                             
	 
 
#endif          

                                                                   
void function OnControlGunRackPanelSpawned( entity gunRackPanel )
{
	if ( gunRackPanel.GetScriptName() != CONTROLGUNRACKPANEL_CLASS_NAME )
		return

	int lootTier = GetCurrentPlaylistVarInt( "control_gunrack_starting_tier", 0 )
	file.gunRackPanelToLootTierTable[ gunRackPanel ] <- lootTier

	#if SERVER
		                                            
	#endif          


	#if CLIENT
		AddCallback_OnUseEntity_ClientServer( gunRackPanel, ControlGunRackPanels_OnUse )
		SetCallback_CanUseEntityCallback( gunRackPanel, ControlGunRackPanels_CanUse )
		AddEntityCallback_GetUseEntOverrideText( gunRackPanel, ControlGunRackPanels_UseTextOverride )
		thread ControlGunRackPanels_CreateMapIcon_Thread( gunRackPanel, lootTier )
	#endif          
}

#if SERVER
                                                 
                                                                                   
 
	                          
	                                                  
	 
		                                                                               
	 
	    
	 
		                                                                                                                              
		                                                                                                                               
	 

	                         
 
#endif          

                                     
bool function ControlGunRackPanels_CanUse( entity player, entity gunRackPanel, int useFlags)
{
	if ( !SURVIVAL_PlayerCanUse_AnimatedInteraction( player, gunRackPanel ) )
		return false

	return true
}

#if CLIENT
                                                                                          
string function ControlGunRackPanels_UseTextOverride( entity gunRackPanel )
{
	string useText = ""

	entity player = GetLocalClientPlayer()
	if ( !IsValid( player ) || !IsValid( gunRackPanel ) )
		return useText

	if ( GradeFlagsHas( gunRackPanel, eGradeFlags.IS_LOCKED ) )
		return Localize( "#CONTROL_GUNRACKS_PANEL_ONCOOLDOWN", ControlGunRacks_GetCoolDownDuration() )

	int lootTier = file.gunRackPanelToLootTierTable[ gunRackPanel ]
	int useCost = ControlGunRackPanels_GetCost( gunRackPanel )

	if ( lootTier == 0 )
	{
		if ( ControlGunRackPanels_CostCheck( gunRackPanel, player ) )
		{
			useText = Localize( "#CONTROL_GUNRACKS_ACTIVATE", useCost )
		}
		else
		{
			useText = Localize( "#CONTROL_GUNRACKS_TOOEXPENSIVE_ACTIVATE", useCost )
		}
	}
	else if ( lootTier >= CONTROL_MAX_LOOT_TIER )
	{
		if ( ControlGunRackPanels_CostCheck( gunRackPanel, player ) )
		{
			useText = Localize( "#CONTROL_GUNRACKS_REFRESH", useCost )
		}
		else
		{
			useText = Localize( "#CONTROL_GUNRACKS_TOOEXPENSIVE_REFRESH", useCost )
		}
	}
	else
	{
		if ( ControlGunRackPanels_CostCheck( gunRackPanel, player ) )
		{
			useText = Localize( "#CONTROL_GUNRACKS_UPGRADE", useCost )
		}
		else
		{
			useText = Localize( "#CONTROL_GUNRACKS_TOOEXPENSIVE_UPGRADE", useCost )
		}
	}

	return useText
}
#endif         

                                                                                                     
void function ControlGunRackPanels_OnUse( entity gunRackPanel, entity player, int useInputFlags )
{
	if( ControlGunRackPanels_CostCheck( gunRackPanel, player ) && !GradeFlagsHas( gunRackPanel, eGradeFlags.IS_LOCKED ) )
	{
		if ( useInputFlags & USE_INPUT_LONG )
			thread ControlGunRackPanels_UseThink_Thread( gunRackPanel, player )
	}
	else
	{
		#if CLIENT
			EmitSoundOnEntity( player, CONTROLGUNRACKPANEL_USE_FAIL_SOUND )
		#endif         
	}
}

                                                          
bool function ControlGunRackPanels_CostCheck( entity gunRackPanel, entity player )
{
	if( Control_GetPlayerExpTotal( player ) >= ControlGunRackPanels_GetCost( gunRackPanel ) )
	{
		return true
	}

	return false
}

                                                          
int function ControlGunRackPanels_GetCost( entity gunRackPanel )
{
	int cost = 0
	int nextLootTier = file.gunRackPanelToLootTierTable[ gunRackPanel ] + 1

	if ( nextLootTier <= CONTROL_MAX_LOOT_TIER )
	{
		cost = GetCurrentPlaylistVarInt( "control_gunrack_exp_cost_tier" + nextLootTier, 0 )
	}
	else
	{
		cost = GetCurrentPlaylistVarInt( "control_gunrack_exp_cost_refresh", 0 )
	}

	return cost
}

                                                                              
void function ControlGunRackPanels_UseThink_Thread( entity gunRackPanel, entity playerUser )
{
	ExtendedUseSettings settings
	settings.duration = CONTROLGUNRACKPANEL_INTERACT_DURATION
	settings.successFunc = ControlGunRackPanels_ExtendedUseSuccess

	#if CLIENT
		string useText = ""
		int lootTier = file.gunRackPanelToLootTierTable[ gunRackPanel ]

		if ( lootTier == 0 )
		{
			useText = Localize( "#CONTROL_GUNRACKS_ACTIVATING" )
		}
		else if ( lootTier >= CONTROL_MAX_LOOT_TIER )
		{
			useText = Localize( "#CONTROL_GUNRACKS_REFRESHING" )
		}
		else
		{
			useText = Localize( "#CONTROL_GUNRACKS_UPGRADING", ( lootTier + 1 ) )
		}

		settings.icon = $""
		settings.hint = useText
		settings.displayRui = $"ui/extended_use_hint.rpak"
		settings.displayRuiFunc = ControlGunRackPanels_DisplayRui
		settings.loopSound = CONTROLGUNRACKPANEL_USE_LOOP_SOUND
		settings.successSound = CONTROLGUNRACKPANEL_USE_SUCCESS_SOUND
	#endif         

	gunRackPanel.EndSignal( "OnDestroy" )
	playerUser.EndSignal( "OnDeath" )

	waitthread ExtendedUse( gunRackPanel, playerUser, settings )
}

                                                              
#if CLIENT
void function ControlGunRackPanels_DisplayRui( entity ent, entity player, var rui, ExtendedUseSettings settings )
{
	RuiSetString( rui, "holdButtonHint", settings.holdHint )
	RuiSetString( rui, "hintText", settings.hint )
	RuiSetGameTime( rui, "startTime", Time() )
	RuiSetGameTime( rui, "endTime", Time() + settings.duration )
}
#endif         

                                                                                                                                                      
void function ControlGunRackPanels_ExtendedUseSuccess( entity gunRackPanel, entity player, ExtendedUseSettings settings )
{
	#if SERVER
		                                                                
	#endif         

	int lootTier = file.gunRackPanelToLootTierTable[ gunRackPanel ]
	int newLootTier = minint( lootTier + 1, CONTROL_MAX_LOOT_TIER )

	#if SERVER
		                                                          
		                                                                         
		                                                                                        
		                                                                             
		                                                                                         
		                                                                                                                                                             
	#endif         

	#if CLIENT
		gunRackPanel.Signal( "ControlGunRackPanels_ExtendedUseSuccess" )
		thread ControlGunRackPanels_CreateMapIcon_Thread( gunRackPanel, newLootTier )
	#endif         
	file.gunRackPanelToLootTierTable[ gunRackPanel ] = newLootTier
}

#if SERVER
                                                                                   
                                                                                     
 
	                                   
	                        
	 
		                                                             
		                                                                
		                                                                            
		                                                                                
		                                                            
		                                                                
		                                                                                  
		                                                                                      

		                                                                                        
			                                                 

		                                                                                            
			                                                   
	 
	                       
 

                                                                                                               
                                                                                                               
 
	                                
		                     

	                              
	                     
	                     
	 
		       
			                       
			     
		       
			                      
			     
		       
			                        
			     
		       
			                   
			     
		        
			              
			     
	 

	                      
	                                           
	 
		                                           
		                                          
	 

	                       
 


                                                                                                               
                                                                              
 
	                                                    
	            
		                             
		 
			                                                      
		 
	 

	                                                                                        

	                                          
 
#endif         

#if CLIENT
                                                                          
void function ControlGunRackPanels_CreateMapIcon_Thread( entity gunRackPanel, int lootTier )
{
	FlagWait( "EntitiesDidLoad" )
	entity player = GetLocalViewPlayer()
	if ( !IsValid( player ) || !IsValid( gunRackPanel ) )
		return

	player.EndSignal( "OnDestroy" )
	gunRackPanel.EndSignal( "OnDestroy" )
	gunRackPanel.EndSignal( "ControlGunRackPanels_ExtendedUseSuccess" )

	int iconColorID
	switch( lootTier )
	{
		case 0:
			iconColorID = COLORID_HUD_LOOT_TIER0
			break
		case 1:
			iconColorID = COLORID_HUD_LOOT_TIER1
			break
		case 2:
			iconColorID = COLORID_HUD_LOOT_TIER2
			break
		case 3:
			iconColorID = COLORID_HUD_LOOT_TIER3
			break
		case 4:
			iconColorID = COLORID_HUD_LOOT_TIER4
			break
		default:
			iconColorID = COLORID_HUD_LOOT_TIER0
			break
	}

	vector iconColor = GetKeyColor( iconColorID ) * ( 1.0 / 255.0 )
	var minimapRui = Minimap_AddIconAtPosition( gunRackPanel.GetOrigin(), <0,90,0>, GUNRACKPANEL_MAP_ICON, 1.0, iconColor )
	var fullmapRui = FullMap_AddIconAtPos( gunRackPanel.GetOrigin(), <0,0,0>, GUNRACKPANEL_MAP_ICON, 7.0, iconColor )

	OnThreadEnd(
		function() : ( minimapRui, fullmapRui )
		{
			Minimap_CommonCleanup( minimapRui )
			Fullmap_RemoveRui( fullmapRui )
			RuiDestroy( fullmapRui )
		}
	)

	WaitForever()
}
#endif          
