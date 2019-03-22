global function LeaveMatch
#if(false)

#endif
global function LeaveParty
global function LeaveMatchAndParty

global function IsSendOpenInviteTrue
global function SendOpenInvite

global function CanPlaylistFitMyParty
global function GetVisiblePlaylists

struct
{
	bool sendOpenInvite = false
} file

void function LeaveMatch()
{
	//
	//
	//
	#if(DURANGO_PROG)
		Durango_LeaveParty()
	#endif //

	CancelMatchmaking()
	ClientCommand( "LeaveMatch" )
}

#if(false)




//







#endif

void function LeaveParty()
{
	ClientCommand( "party_leave" )
	Signal( uiGlobal.signalDummy, "LeaveParty" )
}

void function LeaveMatchAndParty()
{
	LeaveParty()
	LeaveMatchWithDialog()
}

void function SendOpenInvite( bool state )
{
	file.sendOpenInvite = state
}

bool function IsSendOpenInviteTrue()
{
	return file.sendOpenInvite
}

bool function CanPlaylistFitMyParty( string playlistName )
{
	int partySize = GetPartySize()
	int maxPlayers = GetMaxPlayersForPlaylistName( playlistName )
	int maxTeams = GetMaxTeamsForPlaylistName( playlistName )
	int maxPlayersPerTeam = int( max( maxPlayers / maxTeams, 1 ) )
	bool partiesAllowed = GetCurrentPlaylistVarInt( "parties_allowed", 1 ) > 0

	if ( partySize > maxPlayersPerTeam )
		return false

	if ( file.sendOpenInvite && maxPlayersPerTeam == 1 )
		return false

	if ( !partiesAllowed )
	{
		if ( partySize > 1 )
			return false

		if ( file.sendOpenInvite )
			return false
	}

	return true
}

array<string> function GetVisiblePlaylists()
{
	int numPlaylists = GetPlaylistCount()

	array<string> fallbackPlaylists = []
	array<string> list = []

	for ( int i = 0; i < numPlaylists; i++ )
	{
		string name = string( GetPlaylistName(i) )
		bool visible = GetPlaylistVarOrUseValue( name, "visible", "0" ) == "1"
		bool hubOnly = GetPlaylistVarOrUseValue( name, "hub_only", "0" ) == "1"

		if ( visible && !hubOnly && !fallbackPlaylists.contains( name ) )
			list.append( name )
	}

	return list
}
