global function LeaveMatch
global function LeaveMatch_Freelance
global function LeaveParty
global function LeaveMatchAndParty

global function IsSendOpenInviteTrue
global function SendOpenInvite

struct
{
	bool sendOpenInvite = false
} file

void function LeaveMatch()
{
	ResetReconnectParameters()

	                                                                                
	                                                                                
	                                 
	#if DURANGO_PROG
		Durango_LeaveParty()
	#endif                    

	CancelMatchmaking()
	Remote_ServerCallFunction( "ClientCallback_LeaveMatch" )
}

void function LeaveMatch_Freelance()
{
	#if DURANGO_PROG
		Durango_LeaveParty()
	#endif                    

	CancelMatchmaking()

	string hubPlaylist = GetCurrentPlaylistVarString( "freelance_hub_playlist", "freelance_hub" )
	Assert( (hubPlaylist.len() > 0), "Missing 'freelance_hub_playlist' entry." )
	StartMatchmakingStandard( hubPlaylist )
}

void function LeaveParty()
{
	Party_LeaveParty()
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
