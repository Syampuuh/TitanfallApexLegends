#if SERVER
                                           
                                       
                                              
                                         
#endif

#if CLIENT
global function UICallback_Arenas_UpdateMenuInfo
global function UIToClient_ArenasBuyMenuShow
global function UIToClient_ArenasBuyMenuHide
global function UIToClient_ArenasBuyMenuOpen
global function UIToClient_ArenasBuyMenuClose
global function Arenas_PopulateTeamRuis

const string SOUND_STORE_OPEN		= "ui_arenas_ingame_inventory_Open"
const string SOUND_STORE_CLOSE		= "ui_arenas_ingame_inventory_Close"
#endif

#if SERVER
                                                                               
 
	                                              
 

                                                                                      
 
	                                                              

	                                                              
	                                                                           
	                                                                                          

	                                                                                                                                                                 
	                                                                                                                                                                                                                                 
 

                                                                                 
 
	                                                                                        

	                                                                            

	                                                                                           

	                               
	 
		                                                                  
	 
 

                                                                                   
 
	                                                                  

	                                                           
	                        
	 
		                                                                         
	 
 
#endif

#if CLIENT

void function UICallback_Arenas_UpdateMenuInfo( var playerLoadout, var squadmateLoadout0, var squadmateLoadout1 )
{
	if ( IsLobby() )
		return

	var playerRui		= Hud_GetRui( playerLoadout )

	array<var> squadmateRuis
	squadmateRuis.append( Hud_GetRui( squadmateLoadout0 ) )
	squadmateRuis.append( Hud_GetRui( squadmateLoadout1 ) )

	Arenas_PopulatePlayerLoadouts( playerRui, squadmateRuis )
}

void function UIToClient_ArenasBuyMenuShow()
{

}

void function UIToClient_ArenasBuyMenuHide()
{

}

void function UIToClient_ArenasBuyMenuOpen()
{
	entity localPlayer = GetLocalClientPlayer()
	if ( !IsValid( localPlayer ) )
		return

	EmitSoundOnEntity( localPlayer, SOUND_STORE_OPEN )
	Arenas_OnBuyMenuOpen()
	Remote_ServerCallFunction( "ClientCallback_Arenas_OnBuyMenuOpen" )
}

void function UIToClient_ArenasBuyMenuClose()
{
	entity localPlayer = GetLocalClientPlayer()
	if ( !IsValid( localPlayer ) )
		return

	EmitSoundOnEntity( localPlayer, SOUND_STORE_CLOSE )
	thread Arenas_OnBuyMenuClose()
	Remote_ServerCallFunction( "ClientCallback_Arenas_OnBuyMenuClose" )
}


void function Arenas_PopulateTeamRuis( var rui, int team, array<entity> teamPlayers, string side )
{
	int INTRO_MAX_SLOTS = 3

	string clubName = Arenas_GetArenaSquadClubName( team )
	if ( clubName != "" )
	{
		RuiSetString( rui, "teamName_" + side, clubName )
	}

	if ( side == "L" )
	{
		                                                                                
		entity player = GetLocalViewPlayer()
		teamPlayers.removebyvalue( player )
		teamPlayers.insert( 0, player )
	}

	for ( int i=0; i<INTRO_MAX_SLOTS; i++ )
	{
		if ( teamPlayers.len() > i )
		{
			entity player = teamPlayers[ i ]
			PopulateCharacterRui( rui, player, i, side )
		}
		else
		{
			PopulateCharacterRui( rui, null, i, side )
		}
	}
}

void function PopulateCharacterRui( var rui, entity player, int i, string side )
{
	bool loadoutReady = LoadoutSlot_IsReady( ToEHI( player ), Loadout_Character() )
	if ( loadoutReady )
	{
		ItemFlavor character = LoadoutSlot_GetItemFlavor( ToEHI( player ), Loadout_Character() )
		RuiSetImage( rui, "portraitImage_" + side + (i+1), CharacterClass_GetGalleryPortrait( character ) )
		RuiSetBool( rui, "portraitImageVisible_" + side + (i+1), true )
		RuiSetImage( rui, "portraitBackground_" + side + (i+1), CharacterClass_GetGalleryPortraitBackground( character ) )
		RuiSetString( rui, "portraitText_" + side + (i+1), player.GetPlayerName() )
		RuiTrackInt( rui, "portraitTeamMemberIndex_" + side + (i+1), player, RUI_TRACK_PLAYER_TEAM_MEMBER_INDEX )
		RuiTrackInt( rui, "respawnStatus_" + side + (i+1), player, RUI_TRACK_SCRIPT_NETWORK_VAR_INT, GetNetworkedVariableIndex( "respawnStatus" ) )
	}
	else
	{
		RuiSetBool( rui, "portraitImageVisible_" + side + (i+1), false )
	}
}

#endif