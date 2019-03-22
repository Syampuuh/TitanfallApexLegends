global function IsRecruitMode
global function CanRecruitOrRevivePlayer

#if(false)


#endif

#if(CLIENT)
global function CL_RecruitModeUnitFrames_Init
global function Recruit_OnPlayerTeamChanged

struct
{
	array<var>    recruitModeRuis
} file
#endif

bool function IsRecruitMode()
{
	return GetCurrentPlaylistVarInt( "recruit_mode", 0 ) == 1
}


bool function CanRecruitOrRevivePlayer( entity reviver, entity target )
{
	if ( GetPlayerArrayOfTeam( reviver.GetTeam() ).len() < GetCurrentPlaylistVarInt( "recruit_max_team_size", 3 ) )
		return true

	if ( reviver.GetTeam() == target.GetTeam() )
		return true

	return false
}

#if(false)




#endif

#if(CLIENT)
void function CL_RecruitModeUnitFrames_Init()
{
	AddCreateCallback( "player", OnPlayerCreated )
	AddCallback_OnPlayerChangedTeam( Recruit_OnPlayerTeamChanged )
}

void function OnPlayerCreated( entity player )
{
	//
	//
	//
	//
	Recruit_OnPlayerTeamChanged( player, TEAM_UNASSIGNED, player.GetTeam() ) //

	if ( IsRecruitMode() && GetLocalClientPlayer() == player )
		CreateRecruitModeRuis()
}

void function Recruit_OnPlayerTeamChanged( entity player, int oldTeam, int newTeam )
{
	if ( oldTeam == TEAM_INVALID || newTeam == TEAM_INVALID )
		return

	if ( !IsValid( player ) )
		return

	UpdateUnitframePlaceholderVisibility()
	ResetWaypointVisibilities()

	string playerName      = player.GetPlayerName()
	vector playerNameColor = GetKeyColor( COLORID_ENEMY )

	if ( newTeam == GetLocalViewPlayer().GetTeam() )
		playerNameColor = GetKeyColor( COLORID_FRIENDLY )

	if ( GetGameState() > eGameState.Prematch && oldTeam > 1 && newTeam > 1 )
	{
		Obituary_Print_Localized( Localize( "#RECRUIT_MODE_OBIT", playerName ), playerNameColor )
	}
}

void function CreateRecruitModeRuis()
{
	if ( file.recruitModeRuis.len() > 0 ) //
		return

	int maxTeamSize = GetCurrentPlaylistVarInt( "recruit_max_team_size", 3 ) - 1 //
	for ( int i = 0; i < maxTeamSize; i++ )
	{
		var rui = CreatePermanentCockpitPostFXRui( $"ui/unitframe_recruit_mode.rpak", HUD_Z_BASE )
		RuiSetInt( rui, "frameSlot", i )
		RuiSetImage( rui, "icon", $"rui/menu/buttons/lobby_character_select/random" )
		RuiSetBool( rui, "isVisible", true )
		file.recruitModeRuis.append( rui )
	}
}

void function UpdateUnitframePlaceholderVisibility()
{
	entity viewer             = GetLocalViewPlayer()
	array<entity> playerArray = GetPlayerArrayOfTeam( viewer.GetTeam() )
	int teamMembers           = playerArray.len()

	foreach( index, rui in file.recruitModeRuis )
	{
		if ( index >= (teamMembers - 1) )
			RuiSetBool( file.recruitModeRuis[ index ], "isVisible", true )
		else
			RuiSetBool( file.recruitModeRuis[ index ], "isVisible", false )
	}
}
#endif

#if(false)






























//





























#endif