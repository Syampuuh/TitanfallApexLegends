global function MapZones_SharedInit
global function MapZones_RegisterNetworking
global function MapZones_RegisterDataTable
global function GetZoneNameForZoneId
global function GetZoneMiniMapNameForZoneId
global function MapZones_GetZoneIdForTriggerName
global function GetDevNameForZoneId

#if(CLIENT)
global function SCB_OnPlayerEntersMapZone
global function MapZones_ZoneIntroText
global function MapZones_GetChromaBackgroundForZoneId
#endif

#if(false)









//

//




//




//
#endif //

#if(false)



#endif //

global struct ZonePopulationInfo
{
	int playersInside = 0
	int playersNearby = 0
}

global enum eZonePop
{
	NO_PLAYERS_AROUND,
	PLAYERS_NEARBY,
	PLAYERS_INSIDE,

	_count
}

#if(false)

#endif //

struct
{
	bool mapZonesInitialized = false
	var mapZonesDataTable
	table<int, int> calculatedZoneTiers
} file

const int INVALID_ZONE_ID = -1

string function GetDevNameForZoneId( int zoneId )
{
	return GetDataTableString( file.mapZonesDataTable, zoneId, GetDataTableColumnByName( file.mapZonesDataTable, "triggerName" ) )
}

const string EDITOR_CLASSNAME_ZONE_TRIGGER = "trigger_pve_zone"
void function MapZones_SharedInit()
{
#if(false)








#endif //
}

const string FUNCNAME_OnPlayerEntersZone = "SCB_OnPlayerEntersMapZone"
void function MapZones_RegisterNetworking()
{
	Remote_RegisterClientFunction( FUNCNAME_OnPlayerEntersZone, "int", 0, 128, "int", 0, 4 )
}

void function MapZones_RegisterDataTable( asset dataTableAsset )
{
	file.mapZonesDataTable = GetDataTable( dataTableAsset )
	file.mapZonesInitialized = true
}

string function GetZoneMiniMapNameForZoneId( int zoneId )
{
	Assert( zoneId < GetDatatableRowCount( file.mapZonesDataTable ) )
	string zoneName = GetDataTableString( file.mapZonesDataTable, zoneId, GetDataTableColumnByName( file.mapZonesDataTable, "miniMapName" ) )
	return zoneName
}

string function GetZoneNameForZoneId( int zoneId )
{
	Assert( zoneId < GetDatatableRowCount( file.mapZonesDataTable ) )
	string zoneName = GetDataTableString( file.mapZonesDataTable, zoneId, GetDataTableColumnByName( file.mapZonesDataTable, "zoneName" ) )
	return zoneName
}

string function MapZones_GetChromaBackgroundForZoneId( int zoneId )
{
	int column = GetDataTableColumnByName( file.mapZonesDataTable, "chroma" )
	if ( column < 0 )
		return ""

	string chroma = GetDataTableString( file.mapZonesDataTable, zoneId, column )
	return chroma
}

int function MapZones_GetZoneIdForTriggerName( string triggerName )
{
	int zoneId = GetDataTableRowMatchingStringValue( file.mapZonesDataTable, GetDataTableColumnByName( file.mapZonesDataTable, "triggerName" ), triggerName )
	return zoneId
}

#if(false)














//

























//




























//
















































































//











//








































































































































































//




















//




















//
//























#endif //


#if(CLIENT)
var s_zoneIntroRui = null
void function MapZones_ZoneIntroText( entity player, string zoneDisplayName, int zoneTier )
{
	if ( s_zoneIntroRui != null )
		RuiDestroyIfAlive( s_zoneIntroRui )

//
//
//

	var rui = CreateCockpitRui( $"ui/map_zone_intro_title.rpak", 0 )
	RuiSetString( rui, "titleText", zoneDisplayName )
	RuiSetInt( rui, "zoneTier", zoneTier )
	s_zoneIntroRui = rui
}

array<string> s_lastZoneDisplayNames = ["", ""]
int s_lastZoneDisplayNameIndex = -1
void function SCB_OnPlayerEntersMapZone( int zoneId, int zoneTier )
{
	entity player = GetLocalViewPlayer()

	Chroma_SetPlayerZone( zoneId )

	int ceFlags = player.GetCinematicEventFlags()
	if ( ceFlags & (CE_FLAG_HIDE_MAIN_HUD | CE_FLAG_INTRO) )
		return

	string zoneDisplayName = GetZoneNameForZoneId( zoneId )
	if ( s_lastZoneDisplayNames.contains( zoneDisplayName ) )
		return
	if ( zoneDisplayName.len() == 0 )
		return

#if(false)

#else
	if ( zoneTier > 1 )
		ClientMusic_RequestStingerForNewZone( zoneId )
#endif

	MapZones_ZoneIntroText( player, zoneDisplayName, zoneTier )
	s_lastZoneDisplayNameIndex = ((s_lastZoneDisplayNameIndex + 1) % s_lastZoneDisplayNames.len())
	s_lastZoneDisplayNames[s_lastZoneDisplayNameIndex] = zoneDisplayName
}
#endif //



#if(false)













//















//


























//






//




































#endif //
