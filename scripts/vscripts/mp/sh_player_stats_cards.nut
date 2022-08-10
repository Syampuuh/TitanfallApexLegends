#if UI
global function ShPlayerStatCards_Init

global function StatCard_ConstructStatCardProgressBar
global function StatCard_ChangeCardDisplayType
global function StatCard_ConstructAccountProgressBar
global function StatCard_ConstructBattlePassLevelBadge
global function StatCard_ConstructRankedBadges
global function StatCard_UpdateAndDisplayStats
global function StatCard_SetStatValueDisplay
global function StatCard_InitToolTipStringTables
global function StatCard_ClearToolTipStringTables
global function StatCard_AddStatToolTipString
global function StatCard_SetStatToolTip
global function StatsScreen_SetPanelRui
global function StatsCard_OnSeasonRegistered
global function StatsCard_OnRankedPeriodRegistered
global function StatsCard_GetNameOfGameMode
global function StatsCard_GetApprovedModesCount
global function StatsCard_IsSeasonOrRankedRefValidForMode
                       
	global function StatsCard_OnArenasRankedPeriodRegistered
      
#endif     

global function StatCard_GetAvailableSeasons
global function StatCard_GetAvailableSeasonsAndRankedPeriods

global enum eStatCardGameMode
{
	BATTLE_ROYALE,
                        
	ARENAS,
       
	_count
	UNKNOWN,
}

global enum eStatCardType
{
	CAREER,
	SEASON,
	RANKEDPERIOD,
	UNKNOWN,

	_count
}

enum eStatCardSection
{
	HEADER,
	HEADERTOOLTIP,
	BODY,
	BODYTOOLTIP,

	_count
}

enum eStatCalcMethod
{
	SIMPLE,
	CHARACTER_AGGREGATE,
	CHARACTER_HIGHEST,
	WEAPON_AGGREGATE,
	WEAPON_HIGHEST,
	MATH_ADD,
	MATH_SUB,
	MATH_MULTIPLY,
	MATH_DIVIDE,
	MATH_WINRATE,

	_count
}

struct StatCardEntry
{
	int	   gameMode
	int    cardType
	int    section
	int    calcMethod
	string label
	string statRef
	string mathRef
}

struct StatCardStruct
{
	array<StatCardEntry> headerStats
	array<StatCardEntry> headerToolTipStats
	array<StatCardEntry> bodyStats
	array<StatCardEntry> bodyToolTipStats
}

struct LegendStatStruct
{
	string	   legendName
	asset	   portrait
	int        gamesPlayed
	float      winRate
	float      kdr
}

struct WeaponStatStruct
{
	string weaponName
	asset portrait
	int kills
	int damage
	float headshotRatio
	float accuracy
}

struct
{
	var statsRui
	StatCardStruct careerStatCard
	StatCardStruct seasonStatCard
	StatCardStruct rankedPeriodStatCard

	int selectedMode
	                          
	table< int, table< int, StatCardStruct > > statCards

	table<string, array<string> > toolTipStrings

	table<string, int> GUIDToSeasonNumber
	int currentGUIDToSeasonNumber = 1
} file

const string NO_DATA_REF = "000"

const STAT_TOOLTIP_HEADER_CAREER = "careerHeader"
const STAT_TOOLTIP_LCIRCLE_CAREER = "careerLeftCircle"
const STAT_TOOLTIP_RCIRCLE_CAREER = "careerRightCircle"
const STAT_TOOLTIP_COLUMNA_CAREER = "careerColumnA"
const STAT_TOOLTIP_COLUMNB_CAREER = "careerColumnB"
const STAT_TOOLTIP_HEADER_SEASON = "seasonHeader"
const STAT_TOOLTIP_LCIRCLE_SEASON = "seasonLeftCircle"
const STAT_TOOLTIP_RCIRCLE_SEASON = "seasonRightCircle"
const STAT_TOOLTIP_COLUMNA_SEASON = "seasonColumnA"
const STAT_TOOLTIP_COLUMNB_SEASON = "seasonColumnB"

const int MAX_STATS_HEADER = 3
const int MAX_STATS_BODY = 12

#if UI
void function ShPlayerStatCards_Init()
{
	for( int i = 0; i < eStatCardGameMode._count; i++ )
	{
		printf( "StatCardV2Debug: Initializing stat card table for game mode %i", i )
		table<int, StatCardStruct > statCards
		for ( int y = 0; y < eStatCardType._count; y++ )
		{
			printf( "StatCardV2Debug: Initializing stat card table for game mode %i, card type %i", i, y )
			StatCardStruct emptyStatCard
			statCards[y] <- emptyStatCard
		}
		file.statCards[i] <- statCards
	}
	printf( "StatCardV2Debug: file.statCards intialized with %i tables", file.statCards.len() )

	var dataTable = GetDataTable( $"datatable/player_stat_cards.rpak" )
	int numRows = GetDataTableRowCount( dataTable )
	for ( int i = 0; i < numRows; i++ )
	{
		StatCardEntry entry
		string gameModeString = GetDataTableString( dataTable, i, GetDataTableColumnByName( dataTable, "gameMode" ) ).toupper()
		switch ( gameModeString )
		{
			case "BATTLEROYALE":
				entry.gameMode = eStatCardGameMode.BATTLE_ROYALE
				break
                          
				case "ARENAS":
					entry.gameMode = eStatCardGameMode.ARENAS
					break
         
			default:
				entry.gameMode = eStatCardGameMode.UNKNOWN
				break
		}
		                                                                                      

		string cardTypeString = GetDataTableString( dataTable, i, GetDataTableColumnByName( dataTable, "cardType" ) ).toupper()
		switch( cardTypeString.toupper() )
		{
			case "CAREER":
				entry.cardType = eStatCardType.CAREER
				break
			case "SEASON":
				entry.cardType = eStatCardType.SEASON
				break
			case "RANKEDPERIOD":
				entry.cardType = eStatCardType.RANKEDPERIOD
				break
			default:
				entry.cardType = eStatCardType.UNKNOWN
				break
		}
		                                                                                      

		string cardSectionString = GetDataTableString( dataTable, i, GetDataTableColumnByName( dataTable, "section" ) ).toupper()
		switch ( cardSectionString.toupper() )
		{
			case "HEADER":
				entry.section = eStatCardSection.HEADER
				break
			case "HEADERTOOLTIP":
				entry.section = eStatCardSection.HEADERTOOLTIP
				break
			case "BODYTOOLTIP":
				entry.section = eStatCardSection.BODYTOOLTIP
				break
			default:
				entry.section = eStatCardSection.BODY
				break
		}
		                                                                                        

		entry.calcMethod = SetStatCalcMethodFromDataTable( GetDataTableString( dataTable, i, GetDataTableColumnByName( dataTable, "calcMethod" ) ) )
		entry.label = GetDataTableString( dataTable, i, GetDataTableColumnByName( dataTable, "label" ) )
		entry.statRef = GetDataTableString( dataTable, i, GetDataTableColumnByName( dataTable, "statRef" ) )
		entry.mathRef = GetDataTableString( dataTable, i, GetDataTableColumnByName( dataTable, "mathRef" ) )

		if ( entry.cardType == eStatCardType.UNKNOWN )
		{
			printf( "StatCardDebug: Skipping stat entry %i because unknown or empty cardType is defined", i )
			continue
		}

		if ( entry.label == "" )
		{
			entry.label = "UNNAMED STAT"
		}

		if ( entry.statRef == "" )
		{
			entry.statRef = NO_DATA_REF
		}

		                                                                                                                                                                                                         

		switch ( entry.section )
		{
			case eStatCardSection.HEADER:
				file.statCards[entry.gameMode][entry.cardType].headerStats.append( entry )
				break
			case eStatCardSection.HEADERTOOLTIP:
				file.statCards[entry.gameMode][entry.cardType].headerToolTipStats.append( entry )
				break
			case eStatCardSection.BODYTOOLTIP:
				file.statCards[entry.gameMode][entry.cardType].bodyToolTipStats.append( entry )
				break
			default:
				file.statCards[entry.gameMode][entry.cardType].bodyStats.append( entry )
				break
		}
	}

	StatCard_InitToolTipStringTables()
}
#endif

int function SetStatCalcMethodFromDataTable( string method )
{
	switch ( method.toupper() )
	{
		case "SIMPLE":
			return eStatCalcMethod.SIMPLE
		case "CHARACTER_AGGREGATE":
			return eStatCalcMethod.CHARACTER_AGGREGATE
		case "CHARACTER_HIGHEST":
			return eStatCalcMethod.CHARACTER_HIGHEST
		case "WEAPON_AGGREGATE":
			return eStatCalcMethod.WEAPON_AGGREGATE
		case "WEAPON_HIGHEST":
			return eStatCalcMethod.WEAPON_HIGHEST
		case "MATH_ADD":
			return eStatCalcMethod.MATH_ADD
		case "MATH_SUB":
			return eStatCalcMethod.MATH_SUB
		case "MATH_MULTIPLY":
			return eStatCalcMethod.MATH_MULTIPLY
		case "MATH_DIVIDE":
			return eStatCalcMethod.MATH_DIVIDE
		case "MATH_WINRATE":
			return eStatCalcMethod.MATH_WINRATE
		default:
			Assert( false, format("Stat Card: Unknown Stat Card Calc Type Provided (%s)", method) )
	}

	unreachable
}

#if UI
void function StatCard_UpdateAndDisplayStats( var panel, entity player, int gameMode = eStatCardGameMode.BATTLE_ROYALE, string seasonRef = "" )
{
	printf( "StatCardV2Debug: Constructing Stats Displays for %s, seasonRef %s", GetGameModeName( gameMode ), seasonRef )

	StatCard_ClearToolTipStringTables()

	StatCard_ConstructCareerStatsDisplay( panel, player, gameMode )

	if ( seasonRef != "" )
		StatCard_ConstructSeasonOrRankedPeriodStatsDisplay( panel, player, gameMode, seasonRef )
}
#endif      

const string STATCARD_VAR_FORMAT_HEADER_LABEL = "headerStatFieldLabel"
const string STATCARD_VAR_FORMAT_HEADER_DISPLAY = "headerStatFieldDisplay"
const string STATCARD_VAR_FORMAT_LABEL = "statFieldLabel"
const string STATCARD_VAR_FORMAT_DISPLAY = "statFieldDisplay"

const string STATCARD_VAR_FORMAT_HEADER_LABEL_SEASON = "seasonHeaderStatLabel"
const string STATCARD_VAR_FORMAT_HEADER_DISPLAY_SEASON = "seasonHeaderStatDisplay"

const string STATCARD_CAREER_STAT_LABEL = "careerStatLabel"
const string STATCARD_CAREER_STAT_DISPLAY = "careerStatDisplay"
const string STATCARD_SEASON_STAT_LABEL = "seasonStatLabel"
const string STATCARD_SEASON_STAT_DISPLAY = "seasonStatDisplay"

#if UI
void function StatCard_ConstructCareerStatsDisplay( var panel, entity player, int gameMode )
{
	                                                              
	var rui = Hud_GetRui( panel )

	array<StatCardEntry> statEntries
	string toolTipField

	statEntries = clone( file.statCards[gameMode][eStatCardType.CAREER].headerStats )

	string modeRef = StatsCard_GetRefOfGameMode( gameMode )

	                
	if ( statEntries.len() > 0 )
	{
		for ( int i; i < statEntries.len(); i++ )
		{
			string headerIndex = format( "%02d", i )

			string headerLabelIDString = STATCARD_VAR_FORMAT_HEADER_LABEL + headerIndex
			string headerLabel = statEntries[i].label

			string headerDisplayIDString = STATCARD_VAR_FORMAT_HEADER_DISPLAY + headerIndex
			float headerDisplayFloat = GetDataForStat_Float( player, statEntries[i].statRef, statEntries[i].mathRef, statEntries[i].calcMethod, modeRef )

			RuiSetString( rui, (STATCARD_VAR_FORMAT_HEADER_LABEL + headerIndex), headerLabel )

			StatCard_SetStatValueDisplay( headerDisplayIDString, headerDisplayFloat )
			StatCard_AddStatToolTipString( STAT_TOOLTIP_HEADER_CAREER, statEntries[i].label, headerDisplayFloat, statEntries[i].calcMethod )
		}
	}

	statEntries.clear()
	statEntries = clone( file.statCards[gameMode][eStatCardType.CAREER].headerToolTipStats )

	                 
	if ( statEntries.len() > 0 )
	{
		                                                               
		for ( int i = 0; i < statEntries.len(); i++ )
		{
			float headerToolTipDisplayFloat = GetDataForStat_Float( player, statEntries[i].statRef, statEntries[i].mathRef, statEntries[i].calcMethod, modeRef )

			StatCard_AddStatToolTipString( STAT_TOOLTIP_HEADER_CAREER, statEntries[i].label, headerToolTipDisplayFloat, statEntries[i].calcMethod, i )
		}
	}

	StatCard_SetStatToolTip( STAT_TOOLTIP_HEADER_CAREER )

	statEntries.clear()
	statEntries = clone( file.statCards[gameMode][eStatCardType.CAREER].bodyStats )

	int bodyEntries = statEntries.len()
	int openBodyFields = MAX_STATS_BODY - statEntries.len()
	printf( "StatCardV2Debug: %s(): %i/%i body stats to display (%i empty fields)", FUNC_NAME(), bodyEntries, MAX_STATS_BODY, openBodyFields )
	              
	for ( int i; i < (bodyEntries+openBodyFields); i++ )
	{
		string bodyIndex = format( "%02d", i )
		string bodyLabelIDString = STATCARD_CAREER_STAT_LABEL + bodyIndex

		if ( i < bodyEntries )
		{

			string bodyLabel = statEntries[i].label

			string bodyDisplayIDString = STATCARD_CAREER_STAT_DISPLAY + bodyIndex
			float bodyDisplayFloat = GetDataForStat_Float( player, statEntries[i].statRef, statEntries[i].mathRef, statEntries[i].calcMethod, modeRef )

			toolTipField = StatCard_GetToolTipFieldFromIndex( i, eStatCardType.CAREER, eStatCardSection.BODY )

			RuiSetString( rui, bodyLabelIDString, bodyLabel )

			StatCard_SetStatValueDisplay( bodyDisplayIDString, bodyDisplayFloat, 7, 2 )
			StatCard_AddStatToolTipString( toolTipField, statEntries[i].label, bodyDisplayFloat, statEntries[i].calcMethod )
		}
		else
		{
			RuiSetString( rui, bodyLabelIDString, "" )
		}
	}

	StatCard_SetStatToolTip( STAT_TOOLTIP_LCIRCLE_CAREER )
	StatCard_SetStatToolTip( STAT_TOOLTIP_RCIRCLE_CAREER )
	StatCard_SetStatToolTip( STAT_TOOLTIP_COLUMNA_CAREER )
	StatCard_SetStatToolTip( STAT_TOOLTIP_COLUMNB_CAREER )
}

void function StatCard_ConstructSeasonOrRankedPeriodStatsDisplay( var panel, entity player, int gameMode, string seasonOrRankedPeriodRef )
{
	var rui = Hud_GetRui( panel )
	string toolTipField

	                              
	RuiSetInt( rui, "seasonColorHack", file.GUIDToSeasonNumber[seasonOrRankedPeriodRef] )

	array<StatCardEntry> statEntries = []

	int refGUID = ConvertItemFlavorGUIDStringToGUID( seasonOrRankedPeriodRef )
	ItemFlavor refFlavor = GetItemFlavorByGUID( refGUID )
	bool isSeasonStats = IsSeasonFlavor( refFlavor )

	string modeRef = StatsCard_GetRefOfGameMode( gameMode )

	if ( isSeasonStats )
	{
		statEntries = clone( file.statCards[ gameMode ][ eStatCardType.SEASON ].headerStats )
	}
	else
	{
		statEntries = clone( file.statCards[ gameMode ][ eStatCardType.RANKEDPERIOD ].headerStats )
	}

	if ( statEntries.len() > 0 )
	{
		                                                               
		for ( int i; i < statEntries.len(); i++ )
		{
			string headerIndex = format( "%02d", i )

			string headerLabelIDString = STATCARD_VAR_FORMAT_HEADER_LABEL_SEASON + headerIndex
			string headerLabel = statEntries[i].label

			string headerDisplayIDString = STATCARD_VAR_FORMAT_HEADER_DISPLAY_SEASON + headerIndex

			float headerDisplayFloat = GetDataForStat_Float( player, statEntries[i].statRef, statEntries[i].mathRef, statEntries[i].calcMethod, modeRef, seasonOrRankedPeriodRef )

			RuiSetString( rui, headerLabelIDString, headerLabel )

			StatCard_SetStatValueDisplay( headerDisplayIDString, headerDisplayFloat )
			StatCard_AddStatToolTipString( STAT_TOOLTIP_HEADER_SEASON, statEntries[i].label, headerDisplayFloat, statEntries[i].calcMethod )
		}
	}

	statEntries.clear()
	if ( isSeasonStats )
		statEntries = clone( file.statCards[ gameMode ][ eStatCardType.SEASON ].headerToolTipStats )
	else
		statEntries = clone( file.statCards[ gameMode ][ eStatCardType.RANKEDPERIOD ].headerToolTipStats )

	if ( statEntries.len() > 0 )
	{
		                                                               
		for ( int i = 0; i < statEntries.len(); i++ )
		{
			float headerToolTipDisplayFloat = GetDataForStat_Float( player, statEntries[i].statRef, statEntries[i].mathRef, statEntries[i].calcMethod, modeRef, seasonOrRankedPeriodRef )

			                                                                                                                               
			StatCard_AddStatToolTipString( STAT_TOOLTIP_HEADER_SEASON, statEntries[i].label, headerToolTipDisplayFloat, statEntries[i].calcMethod, i )
		}
	}

	StatCard_SetStatToolTip( STAT_TOOLTIP_HEADER_SEASON )

	statEntries.clear()
	if ( isSeasonStats )
		statEntries = clone( file.statCards[ gameMode ][ eStatCardType.SEASON ].bodyStats )
	else
		statEntries = clone( file.statCards[ gameMode ][ eStatCardType.RANKEDPERIOD ].bodyStats )

	int bodyEntries = statEntries.len()
	int openBodyFields = MAX_STATS_BODY - statEntries.len()
	for ( int i; i < (bodyEntries+openBodyFields); i++ )
	{
		string bodyIndex = format( "%02d", i )
		string bodyLabelIDString = STATCARD_SEASON_STAT_LABEL + bodyIndex

		if ( i < bodyEntries )
		{
			string bodyLabel = statEntries[i].label

			string bodyDisplayIDString = STATCARD_SEASON_STAT_DISPLAY + bodyIndex
			float bodyDisplayFloat = GetDataForStat_Float( player, statEntries[i].statRef, statEntries[i].mathRef, statEntries[i].calcMethod, modeRef, seasonOrRankedPeriodRef )

			toolTipField = StatCard_GetToolTipFieldFromIndex( i, eStatCardType.SEASON, eStatCardSection.BODY )

			RuiSetString( rui, bodyLabelIDString, bodyLabel )
			StatCard_SetStatValueDisplay( bodyDisplayIDString, bodyDisplayFloat, 7, 2 )
			StatCard_AddStatToolTipString( toolTipField, statEntries[i].label, bodyDisplayFloat, statEntries[i].calcMethod )
		}
		else
		{
			RuiSetString( rui, bodyLabelIDString, "" )
		}
	}

	StatCard_SetStatToolTip( STAT_TOOLTIP_LCIRCLE_SEASON )
	StatCard_SetStatToolTip( STAT_TOOLTIP_RCIRCLE_SEASON )
	StatCard_SetStatToolTip( STAT_TOOLTIP_COLUMNA_SEASON )
	StatCard_SetStatToolTip( STAT_TOOLTIP_COLUMNB_SEASON )
}

void function StatCard_ConstructStatCardProgressBar( var panel, int totalXP, int start_accountLevel, float start_accountLevelFrac, int cardType, entity player = null )
{
	var rui = Hud_GetRui( panel )
	RuiDestroyNestedIfAlive( rui, "progressBarHandle" )
	var progressBarRui = CreateNestedProgressBar( rui, "progressBarHandle" )

	RuiSetColorAlpha( progressBarRui, "oldProgressColor", <196 / 255.0, 151 / 255.0, 41 / 255.0>, 1 )
	RuiSetColorAlpha( progressBarRui, "newProgressColor", <255 / 255.0, 182 / 255.0, 0 / 255.0>, 1 )
	RuiSetBool( progressBarRui, "largeFormat", true )
	RuiSetInt( progressBarRui, "startLevel", start_accountLevel )
	RuiSetFloat( progressBarRui, "startLevelFrac", start_accountLevelFrac )
	RuiSetInt( progressBarRui, "endLevel", start_accountLevel )
	RuiSetFloat( progressBarRui, "endLevelFrac", 1.0 )
	RuiSetGameTime( progressBarRui, "startTime", RUI_BADGAMETIME )
	RuiSetFloat( progressBarRui, "startDelay", 0.0 )
	RuiSetString( progressBarRui, "headerText", "#EOG_XP_HEADER_MATCH" )
	RuiSetFloat( progressBarRui, "progressBarFillTime", 2.0 )
	RuiSetInt( progressBarRui, format( "displayLevel1XP", start_accountLevel + 1 ), GetTotalXPToCompleteAccountLevel( start_accountLevel ) - GetTotalXPToCompleteAccountLevel( start_accountLevel - 1 ) )

	if ( cardType == eStatCardType.CAREER )
	{
		                                                                                                     
		                                                                                                      
		  
		                                                                                                    
		                                                                                                     


	}

	if ( cardType == eStatCardType.SEASON )
	{
		RuiSetBool( progressBarRui, "battlePass", true )

		RuiSetString( progressBarRui, "currentDisplayLevel", "" )
		RuiSetString( progressBarRui, "nextDisplayLevel", "" )
		RuiSetImage( progressBarRui, "currentDisplayBadge", $"" )
		RuiSetImage( progressBarRui, "nextDisplayBadge", $"" )

		ItemFlavor ornull activeBattlePass
		activeBattlePass = GetPlayerActiveBattlePass( ToEHI( player ) )
		expect ItemFlavor( activeBattlePass )

		int currentBattlePassXP  = GetPlayerBattlePassXPProgress( ToEHI( player ), activeBattlePass, false )
		int ending_passLevel       = GetBattlePassLevelForXP( activeBattlePass, currentBattlePassXP )
		int ending_passXP          = GetTotalXPToCompletePassLevel( activeBattlePass, ending_passLevel - 1 )
		bool isMaxPassLevel 	   = ending_passLevel > GetBattlePassMaxLevelIndex( activeBattlePass )

		ItemFlavor dummy
		ItemFlavor bpLevelBadge = GetBattlePassProgressBadge( activeBattlePass )

		RuiDestroyNestedIfAlive( progressBarRui, "currentBadgeHandle" )
		CreateNestedGladiatorCardBadge( progressBarRui, "currentBadgeHandle", ToEHI( player ), bpLevelBadge, 0, dummy, start_accountLevel + 1 )

		RuiDestroyNestedIfAlive( progressBarRui, "nextBadgeHandle" )
		if ( !isMaxPassLevel )
			CreateNestedGladiatorCardBadge( progressBarRui, "nextBadgeHandle", ToEHI( player ), bpLevelBadge, 0, dummy, start_accountLevel + 2 )
	}
}

void function StatCard_ConstructAccountProgressBar( var panel, int start_accountLevel, float start_accountLevelFrac )
{
	var rui = Hud_GetRui( panel )
	RuiDestroyNestedIfAlive( rui, "careerProgressBarHandle" )
	var progressBarRui = CreateNestedProgressBar( rui, "careerProgressBarHandle" )

	RuiSetColorAlpha( progressBarRui, "oldProgressColor", <196 / 255.0, 151 / 255.0, 41 / 255.0>, 1 )
	RuiSetColorAlpha( progressBarRui, "newProgressColor", <255 / 255.0, 182 / 255.0, 0 / 255.0>, 1 )
	RuiSetBool( progressBarRui, "largeFormat", true )
	RuiSetInt( progressBarRui, "startLevel", start_accountLevel )
	RuiSetFloat( progressBarRui, "startLevelFrac", start_accountLevelFrac )
	RuiSetInt( progressBarRui, "endLevel", start_accountLevel )
	RuiSetFloat( progressBarRui, "endLevelFrac", 1.0 )
	RuiSetGameTime( progressBarRui, "startTime", RUI_BADGAMETIME )
	RuiSetFloat( progressBarRui, "startDelay", 0.0 )
	RuiSetString( progressBarRui, "headerText", "#EOG_XP_HEADER_MATCH" )
	RuiSetFloat( progressBarRui, "progressBarFillTime", 2.0 )
	RuiSetInt( progressBarRui, format( "displayLevel1XP", start_accountLevel + 1 ), GetTotalXPToCompleteAccountLevel( start_accountLevel ) - GetTotalXPToCompleteAccountLevel( start_accountLevel - 1 ) )


	var nestedCurrentLevelBadge = CreateNestedAccountDisplayBadge( progressBarRui, "currentBadgeHandle", start_accountLevel )
	var nestedNextLevelBadge = CreateNestedAccountDisplayBadge( progressBarRui, "nextBadgeHandle", start_accountLevel + 1 )
	                                                                                                     
	                                                                                                      
	  
	                                                                                                    
	                                                                                                     
}

void function StatCard_ConstructBattlePassLevelBadge( var panel, entity player, int battlePassLevel, string seasonRef )
{
	var rui = Hud_GetRui( panel )
	RuiDestroyNestedIfAlive( rui, "battlePassLevelBadge" )
	RuiDestroyNestedIfAlive( rui, "battlePassLevelBadge2" )
	RuiSetString( rui, "rankedSplitTextLabel", ""  )
	RuiSetString( rui, "rankedSplitTextLabel2", ""  )
	RuiSetBool( rui, "twoBadgeMode", false  )

	                                                                                   
	                                       

	SettingsAssetGUID seasonGUID = ConvertItemFlavorGUIDStringToGUID( seasonRef )
	ItemFlavor season = GetItemFlavorByGUID( seasonGUID )
	ItemFlavor battlePass = Season_GetBattlePass( season )

	ItemFlavor dummy
	ItemFlavor bpLevelBadge = GetBattlePassProgressBadge( battlePass )

	CreateNestedGladiatorCardBadge( rui, "battlePassLevelBadge", ToEHI( player ), bpLevelBadge, 0, dummy, battlePassLevel + 1 )
}

void function StatCard_ConstructRankedBadges( var panel, entity player, string rankedPeriodRef )
{
	var rui = Hud_GetRui( panel )
	RuiDestroyNestedIfAlive( rui, "battlePassLevelBadge" )
	RuiDestroyNestedIfAlive( rui, "battlePassLevelBadge2" )
	RuiSetString( rui, "rankedSplitTextLabel", "" )
	RuiSetString( rui, "rankedSplitTextLabel2", ""  )
	RuiSetBool( rui, "twoBadgeMode", false  )

	ItemFlavor rankedPeriodItemFlavor = GetItemFlavorByGUID( ConvertItemFlavorGUIDStringToGUID( rankedPeriodRef ) )
	int itemType = ItemFlavor_GetType( rankedPeriodItemFlavor )
                        
		Assert( itemType == eItemType.calevent_rankedperiod || itemType == eItemType.calevent_arenas_ranked_period, "tried to custruct ranked badges with non ranked ref" )
       

	if ( SharedRankedPeriod_HasSplits( rankedPeriodItemFlavor )  )
	{
		if ( rankedPeriodRef == GetCurrentStatRankedPeriodRefOrNullByType( itemType ) && SharedRankedPeriod_IsFirstSplitActive( rankedPeriodItemFlavor ) )
			StatsCard_ConstructRankBadgesForSingleBadgeShared( rui, player, rankedPeriodRef )
		else
			StatsCard_ConstructRankBadgesForDoubleBadgeShared( rui, player, rankedPeriodRef )
	}
	else
	{
		StatsCard_ConstructRankBadgesForSingleBadgeShared( rui, player, rankedPeriodRef )
	}
}

void function StatsCard_ConstructRankBadgesForSingleBadgeShared( var rui, entity player,  string rankedPeriodRef  )
{
	ItemFlavor rankedPeriodItemFlavor = GetItemFlavorByGUID( ConvertItemFlavorGUIDStringToGUID( rankedPeriodRef ) )
	int itemType                     = ItemFlavor_GetType( rankedPeriodItemFlavor )

	var badgeRui = CreateNestedRankedBadge( rui, "battlePassLevelBadge" )

	if ( itemType == eItemType.calevent_rankedperiod )
		Ranked_ConstructSingleRankBadgeForStatsCard( badgeRui, player, rankedPeriodRef )
                        
		else
			ArenasRanked_ConstructSingleRankBadgeForStatsCard( badgeRui, player, rankedPeriodRef )
       
}


void function StatsCard_ConstructRankBadgesForDoubleBadgeShared( var rui, entity player,  string rankedPeriodRef  )
{
	ItemFlavor rankedPeriodItemFlavor = GetItemFlavorByGUID( ConvertItemFlavorGUIDStringToGUID( rankedPeriodRef ) )
	int itemType                     = ItemFlavor_GetType( rankedPeriodItemFlavor )

	RuiSetBool( rui, "twoBadgeMode", true )
	RuiSetString( rui, "rankedSplitTextLabel", Localize( "#RANKED_SPLIT_1" ) )
	RuiSetString( rui, "rankedSplitTextLabel2", Localize( "#RANKED_SPLIT_2" ) )

	var firstSplitBadgeRui  = CreateNestedRankedBadge( rui, "battlePassLevelBadge" )
	var secondSplitBadgeRui = CreateNestedRankedBadge( rui, "battlePassLevelBadge2" )

	if ( itemType == eItemType.calevent_rankedperiod )
		Ranked_ConstructDoubleRankBadgeForStatsCard( firstSplitBadgeRui, secondSplitBadgeRui, player, rankedPeriodRef )
                        
		else
			ArenasRanked_ConstructDoubleRankBadgeForStatsCard( firstSplitBadgeRui, secondSplitBadgeRui, player, rankedPeriodRef )
       
}

void function StatCard_ChangeCardDisplayType( var panel, int displayType )
{
	var rui = Hud_GetRui( panel )
	RuiSetInt( rui, "displayType", displayType )
}
#endif     

string function GetDataForStat( entity player, string statRef, string mathRef, int calcMethod, string modeRef = "", string seasonOrRankedRef = "" )
{
	if( statRef == NO_DATA_REF )
	{
		return statRef
	}
	else
	{
		StatTemplate stat = GetStatTemplateFromString( statRef )

		bool statComesFromAggregate = (calcMethod == eStatCalcMethod.CHARACTER_AGGREGATE) || (calcMethod == eStatCalcMethod.CHARACTER_HIGHEST) || (calcMethod == eStatCalcMethod.WEAPON_AGGREGATE) || (calcMethod == eStatCalcMethod.WEAPON_HIGHEST)
		bool statComesFromMath = (calcMethod == eStatCalcMethod.MATH_DIVIDE) || (calcMethod == eStatCalcMethod.MATH_MULTIPLY) || (calcMethod == eStatCalcMethod.MATH_SUB) || (calcMethod == eStatCalcMethod.MATH_ADD) || (calcMethod == eStatCalcMethod.MATH_WINRATE)

		int data
		if ( calcMethod == eStatCalcMethod.SIMPLE )
		{
			if( modeRef == "" )
			{
				if ( seasonOrRankedRef == "" )
					data = GetStat_Int( player, ResolveStatEntry( stat ), eStatGetWhen.CURRENT )
				else
					data = GetStat_Int( player, ResolveStatEntry( stat, seasonOrRankedRef ), eStatGetWhen.CURRENT )
			}
			else
			{
				if ( seasonOrRankedRef == "" )
					data = GetStat_Int( player, ResolveStatEntry( stat, modeRef ), eStatGetWhen.CURRENT )
				else
					data = GetStat_Int( player, ResolveStatEntry( stat, modeRef, seasonOrRankedRef ), eStatGetWhen.CURRENT )
			}
		}
		else if ( statComesFromAggregate )
		{
			data = AggregateStat( player, stat, calcMethod, seasonOrRankedRef )
		}
		else if ( statComesFromMath )
		{
			Assert( (mathRef != ""), format( "Stat Cards: Attempted to calculate a stat value without providing two stats to calculate from (%s)", mathRef) )

			StatTemplate mathStat = GetStatTemplateFromString( mathRef )
			float calcData = CalculateStat( player, stat, mathStat, calcMethod, seasonOrRankedRef, "" )
			float modValue = (calcData % 1) * 100.0

			string result
			if ( modValue != 0 )
				result = format( "%02d.%02d", calcData, modValue )
			else
				result = string( calcData )
			return result
		}

		return format( "%02d", data )
	}

	unreachable
}

float function GetDataForStat_Float( entity player, string statRef, string mathRef, int calcMethod, string modeRef, string seasonOrRankedRef = "" )
{
	if( statRef == NO_DATA_REF )
	{
		                                                                                 
		return -1
	}
	else
	{
		printf( "StatCardV2Debug: Collecting Data for %s", statRef )

		StatTemplate stat = GetStatTemplateFromString( statRef )

		bool statComesFromAggregate = (calcMethod == eStatCalcMethod.CHARACTER_AGGREGATE) || (calcMethod == eStatCalcMethod.CHARACTER_HIGHEST) || (calcMethod == eStatCalcMethod.WEAPON_AGGREGATE) || (calcMethod == eStatCalcMethod.WEAPON_HIGHEST)
		bool statComesFromMath = (calcMethod == eStatCalcMethod.MATH_DIVIDE) || (calcMethod == eStatCalcMethod.MATH_MULTIPLY) || (calcMethod == eStatCalcMethod.MATH_SUB) || (calcMethod == eStatCalcMethod.MATH_ADD) || (calcMethod == eStatCalcMethod.MATH_WINRATE)

		int data
		if ( calcMethod == eStatCalcMethod.SIMPLE )
		{
			if( modeRef == "" || !ShouldIncludeModeRef( modeRef, seasonOrRankedRef ) )
			{
				if ( seasonOrRankedRef == "" )
					data = GetStat_Int( player, ResolveStatEntry( stat ), eStatGetWhen.CURRENT )
				else
					data = GetStat_Int( player, ResolveStatEntry( stat, seasonOrRankedRef ), eStatGetWhen.CURRENT )
			}
			else
			{
				if ( seasonOrRankedRef == "" )
					data = GetStat_Int( player, ResolveStatEntry( stat, modeRef ), eStatGetWhen.CURRENT )
				else
					data = GetStat_Int( player, ResolveStatEntry( stat, modeRef, seasonOrRankedRef ), eStatGetWhen.CURRENT )
			}
		}
		else if ( statComesFromAggregate )
		{
			data = AggregateStat( player, stat, calcMethod, modeRef, seasonOrRankedRef )
		}
		else if ( statComesFromMath )
		{
			Assert( (mathRef != ""), format( "Stat Cards: Attempted to calculate a stat value without providing two stats to calculate from (%s)", mathRef) )

			StatTemplate mathStat = GetStatTemplateFromString( mathRef )
			float calcData = CalculateStat( player, stat, mathStat, calcMethod, modeRef, seasonOrRankedRef, "" )

			return calcData
		}

		return float( data )
	}

	unreachable
}

StatTemplate function GetStatTemplateFromString( string statRef )
{
	switch ( statRef )
	{
		                                
		case "CAREER_STATS.games_played":
			return CAREER_STATS.games_played
		case "CAREER_STATS.placements_win":
			return CAREER_STATS.placements_win
		case "CAREER_STATS.placements_top_3":
			return CAREER_STATS.placements_top_3
		case "CAREER_STATS.kills":
			return CAREER_STATS.kills
		case "CAREER_STATS.deaths":
			return CAREER_STATS.deaths
		case "CAREER_STATS.dooms":
			return CAREER_STATS.dooms
		case "CAREER_STATS.team_work_kill_count":
			return CAREER_STATS.team_work_kill_count
		case "CAREER_STATS.revived_ally":
			return CAREER_STATS.revived_ally
		case "CAREER_STATS.damage_done":
			return CAREER_STATS.damage_done
		case "CAREER_STATS.character_damage_done_max_single_game":
			return CAREER_STATS.character_damage_done_max_single_game
		case "CAREER_STATS.season_character_kills":
			return CAREER_STATS.season_character_kills
		case "CAREER_STATS.season_character_damage_done":
			return CAREER_STATS.season_character_damage_done
		case "CAREER_STATS.season_character_placements_win":
			return CAREER_STATS.season_character_placements_win
		case "CAREER_STATS.season_character_placements_top_5":
			return CAREER_STATS.season_character_placements_top_5
		case "CAREER_STATS.weapon_damage_done":
			return CAREER_STATS.weapon_damage_done
		case "CAREER_STATS.weapon_headshots":
			return CAREER_STATS.weapon_headshots
		case "CAREER_STATS.weapon_shots":
			return CAREER_STATS.weapon_shots
		case "CAREER_STATS.weapon_hits":
			return CAREER_STATS.weapon_hits
		case "CAREER_STATS.character_games_played":
			return CAREER_STATS.character_games_played
		case "CAREER_STATS.character_kills":
			return CAREER_STATS.character_kills
		case "CAREER_STATS.character_deaths":
			return CAREER_STATS.character_deaths
		case "CAREER_STATS.character_placements_win":
			return CAREER_STATS.character_placements_win
		case "CAREER_STATS.times_respawned_ally":
			return CAREER_STATS.times_respawned_ally

		                                
		case "CAREER_STATS.season_games_played":
			return CAREER_STATS.season_games_played
		case "CAREER_STATS.season_damage_done":
			return CAREER_STATS.season_damage_done
		case "CAREER_STATS.season_kills":
			return CAREER_STATS.season_kills
		case "CAREER_STATS.season_deaths":
			return CAREER_STATS.season_deaths
		case "CAREER_STATS.season_dooms":
			return CAREER_STATS.season_dooms
		case "CAREER_STATS.season_team_work_kill_count":
			return CAREER_STATS.season_team_work_kill_count
		case "CAREER_STATS.season_revived_ally":
			return CAREER_STATS.season_revived_ally
		case "CAREER_STATS.season_times_respawned_ally":
			return CAREER_STATS.season_times_respawned_ally
		case "CAREER_STATS.season_character_damage_done_max_single_game":
			return CAREER_STATS.season_character_damage_done_max_single_game
		case "CAREER_STATS.assists":
			return CAREER_STATS.assists
		case "CAREER_STATS.season_assists":
			return CAREER_STATS.season_assists
		case "CAREER_STATS.kills_max_single_game":
			return CAREER_STATS.kills_max_single_game
		case "CAREER_STATS.season_kills_max_single_game":
			return CAREER_STATS.season_kills_max_single_game
		case "CAREER_STATS.win_streak_longest":
			return CAREER_STATS.win_streak_longest
		case "CAREER_STATS.season_win_streak_longest":
			return CAREER_STATS.season_win_streak_longest
		case "CAREER_STATS.season_placements_win":
			return CAREER_STATS.season_placements_win
		case "CAREER_STATS.placements_top_5":
			return CAREER_STATS.placements_top_5
		case "CAREER_STATS.placements_top_10":
			return CAREER_STATS.placements_top_10

		                              
		case "CAREER_STATS.rankedperiod_assists":
			return CAREER_STATS.rankedperiod_assists
		case "CAREER_STATS.rankedperiod_character_damage_done_max_single_game":
			return CAREER_STATS.rankedperiod_character_damage_done_max_single_game
		case "CAREER_STATS.rankedperiod_damage_done":
			return CAREER_STATS.rankedperiod_damage_done
		case "CAREER_STATS.rankedperiod_deaths":
			return CAREER_STATS.rankedperiod_deaths
		case "CAREER_STATS.rankedperiod_dooms":
			return CAREER_STATS.rankedperiod_dooms
		case "CAREER_STATS.rankedperiod_games_played":
			return CAREER_STATS.rankedperiod_games_played
		case "CAREER_STATS.rankedperiod_kills":
			return CAREER_STATS.rankedperiod_kills
		case "CAREER_STATS.rankedperiod_kills_max_single_game":
			return CAREER_STATS.rankedperiod_kills_max_single_game
		case "CAREER_STATS.rankedperiod_placements_top_5":
			return CAREER_STATS.rankedperiod_placements_top_5
		case "CAREER_STATS.rankedperiod_placements_win":
			return CAREER_STATS.rankedperiod_placements_win
		case "CAREER_STATS.rankedperiod_revived_ally":
			return CAREER_STATS.rankedperiod_revived_ally
		case "CAREER_STATS.rankedperiod_times_respawned_ally":
			return CAREER_STATS.rankedperiod_times_respawned_ally
		case "CAREER_STATS.rankedperiod_win_streak_longest":
			return CAREER_STATS.rankedperiod_win_streak_longest

                         
		                         
		case "CAREER_STATS.modes_games_played":
			return CAREER_STATS.modes_games_played
		case "CAREER_STATS.modes_placements_win":
			return CAREER_STATS.modes_placements_win
		case "CAREER_STATS.modes_damage_done":
			return CAREER_STATS.modes_damage_done
		case "CAREER_STATS.modes_damage_done_max_single_game":
			return CAREER_STATS.modes_damage_done_max_single_game
		case "CAREER_STATS.modes_kills":
			return CAREER_STATS.modes_kills
		case "CAREER_STATS.modes_deaths":
			return CAREER_STATS.modes_deaths
		case "CAREER_STATS.modes_kills_max_single_game":
			return CAREER_STATS.modes_kills_max_single_game
		case "CAREER_STATS.modes_dooms":
			return CAREER_STATS.modes_dooms
		case "CAREER_STATS.modes_assists":
			return CAREER_STATS.modes_assists
		case "CAREER_STATS.modes_win_streak_longest":
			return CAREER_STATS.modes_win_streak_longest
		case "CAREER_STATS.modes_revived_ally":
			return CAREER_STATS.modes_revived_ally

		                         
		case "CAREER_STATS.modes_season_games_played":
			return CAREER_STATS.modes_season_games_played
		case "CAREER_STATS.modes_season_placements_win":
			return CAREER_STATS.modes_season_placements_win
		case "CAREER_STATS.modes_season_damage_done":
			return CAREER_STATS.modes_season_damage_done
		case "CAREER_STATS.modes_season_damage_done_max_single_game":
			return CAREER_STATS.modes_season_damage_done_max_single_game
		case "CAREER_STATS.modes_season_kills":
			return CAREER_STATS.modes_season_kills
		case "CAREER_STATS.modes_season_kills_max_single_game":
			return CAREER_STATS.modes_season_kills_max_single_game
		case "CAREER_STATS.modes_season_deaths":
			return CAREER_STATS.modes_season_deaths
		case "CAREER_STATS.modes_season_dooms":
			return CAREER_STATS.modes_season_dooms
		case "CAREER_STATS.modes_season_assists":
			return CAREER_STATS.modes_season_assists
		case "CAREER_STATS.modes_season_win_streak_current":
			return CAREER_STATS.modes_season_win_streak_current
		case "CAREER_STATS.modes_season_win_streak_longest":
			return CAREER_STATS.modes_season_win_streak_longest
		case "CAREER_STATS.modes_season_revived_ally":
			return CAREER_STATS.modes_season_revived_ally

		                       
		case "CAREER_STATS.arenas_rankedperiod_games_played":
			return CAREER_STATS.arenas_rankedperiod_games_played
		case "CAREER_STATS.arenas_rankedperiod_placements_win":
			return CAREER_STATS.arenas_rankedperiod_placements_win
		case "CAREER_STATS.arenas_rankedperiod_damage_done":
			return CAREER_STATS.arenas_rankedperiod_damage_done
		case "CAREER_STATS.arenas_rankedperiod_damage_done_max_single_game":
			return CAREER_STATS.arenas_rankedperiod_damage_done_max_single_game
		case "CAREER_STATS.arenas_rankedperiod_damage_done":
			return CAREER_STATS.arenas_rankedperiod_damage_done
		case "CAREER_STATS.arenas_rankedperiod_kills":
			return CAREER_STATS.arenas_rankedperiod_kills
		case "CAREER_STATS.arenas_rankedperiod_kills_max_single_game":
			return CAREER_STATS.arenas_rankedperiod_kills_max_single_game
		case "CAREER_STATS.arenas_rankedperiod_deaths":
			return CAREER_STATS.arenas_rankedperiod_deaths
		case "CAREER_STATS.arenas_rankedperiod_dooms":
			return CAREER_STATS.arenas_rankedperiod_dooms
		case "CAREER_STATS.arenas_rankedperiod_assists":
			return CAREER_STATS.arenas_rankedperiod_assists
		case "CAREER_STATS.arenas_rankedperiod_win_streak_current_new":
			return CAREER_STATS.arenas_rankedperiod_win_streak_current_new
		case "CAREER_STATS.arenas_rankedperiod_win_streak_longest_new":
			return CAREER_STATS.arenas_rankedperiod_win_streak_longest_new
		case "CAREER_STATS.arenas_rankedperiod_revived_ally":
			return CAREER_STATS.arenas_rankedperiod_revived_ally
        


		default:
			Assert( false, format( "Stat Card attempted to look up an unknown StatTemplate: %s", statRef) )
	}

	unreachable
}

int function AggregateStat( entity player, StatTemplate stat, int calcMethod, string modeRef, string seasonOrRankedRef = "" )
{
	int total

	if ( calcMethod == eStatCalcMethod.CHARACTER_HIGHEST || calcMethod == eStatCalcMethod.CHARACTER_AGGREGATE )
	{
		foreach( ItemFlavor character in GetAllCharactersForStats() )
		{
			string characterRef = ItemFlavor_GetGUIDString( character )

			                                                                                                                

			int statValue
			if ( modeRef == "" || !ShouldIncludeModeRef( modeRef, seasonOrRankedRef ) )
			{
				if ( seasonOrRankedRef == "" )
					statValue = GetStat_Int( player, ResolveStatEntry( stat, characterRef ), eStatGetWhen.CURRENT )
				else
					statValue = GetStat_Int( player, ResolveStatEntry( stat, seasonOrRankedRef, characterRef ), eStatGetWhen.CURRENT )
			}
			else
			{
				if ( seasonOrRankedRef == "" )
					statValue = GetStat_Int( player, ResolveStatEntry( stat, modeRef, characterRef ), eStatGetWhen.CURRENT )
				else
					statValue = GetStat_Int( player, ResolveStatEntry( stat, modeRef, seasonOrRankedRef, characterRef ), eStatGetWhen.CURRENT )
			}

			if ( (calcMethod == eStatCalcMethod.CHARACTER_HIGHEST) && (statValue > total) )
				total = statValue
			if ( calcMethod == eStatCalcMethod.CHARACTER_AGGREGATE )
				total += statValue
		}
	}

	return total
}

float function CalculateStat( entity player, StatTemplate stat1, StatTemplate stat2, int calcMethod, string modeRef, string seasonOrRankedRef = "", string ref = "" )
{
	int stat1Int
	int stat2Int

	if ( seasonOrRankedRef == "" )
	{
		if ( modeRef == "" || !ShouldIncludeModeRef( modeRef, seasonOrRankedRef ) )
		{
			stat1Int = GetStat_Int( player, ResolveStatEntry( stat1 ), eStatGetWhen.CURRENT )
			stat2Int = GetStat_Int( player, ResolveStatEntry( stat2 ), eStatGetWhen.CURRENT )
		}
		else
		{
			stat1Int = GetStat_Int( player, ResolveStatEntry( stat1, modeRef ), eStatGetWhen.CURRENT )
			stat2Int = GetStat_Int( player, ResolveStatEntry( stat2, modeRef ), eStatGetWhen.CURRENT )
		}
	}
	else if ( ref != "" )
	{
		if ( modeRef == "" || !ShouldIncludeModeRef( modeRef, seasonOrRankedRef ) )
		{
			stat1Int = GetStat_Int( player, ResolveStatEntry( stat1, ref ), eStatGetWhen.CURRENT )
			stat2Int = GetStat_Int( player, ResolveStatEntry( stat2, ref ), eStatGetWhen.CURRENT )
		}
		else
		{
			stat1Int = GetStat_Int( player, ResolveStatEntry( stat1, modeRef, ref ), eStatGetWhen.CURRENT )
			stat2Int = GetStat_Int( player, ResolveStatEntry( stat2, modeRef, ref ), eStatGetWhen.CURRENT )
		}
	}
	else
	{
		if ( modeRef == "" || !ShouldIncludeModeRef( modeRef, seasonOrRankedRef ) )
		{
			stat1Int = GetStat_Int( player, ResolveStatEntry( stat1, seasonOrRankedRef ), eStatGetWhen.CURRENT )
			stat2Int = GetStat_Int( player, ResolveStatEntry( stat2, seasonOrRankedRef ), eStatGetWhen.CURRENT )
		}
		else
		{
			stat1Int = GetStat_Int( player, ResolveStatEntry( stat1, modeRef, seasonOrRankedRef ), eStatGetWhen.CURRENT )
			stat2Int = GetStat_Int( player, ResolveStatEntry( stat2, modeRef, seasonOrRankedRef ), eStatGetWhen.CURRENT )
		}
	}

	switch ( calcMethod )
	{
		case eStatCalcMethod.MATH_ADD:
			return float( stat1Int + stat2Int )
		case eStatCalcMethod.MATH_SUB:
			return float( stat1Int - stat2Int )
		case eStatCalcMethod.MATH_MULTIPLY:
			return float( stat1Int * stat2Int )
	}

	if ( calcMethod == eStatCalcMethod.MATH_DIVIDE )
	{
		if ( stat2Int != 0 )
			printf( "StatMathDebug: %i / %i = %f", stat1Int, stat2Int, (float(stat1Int)/float(stat2Int)) )

		if ( stat2Int != 0 )
			return float( stat1Int ) / float( stat2Int )
		else
			return float( stat1Int )
	}

	if ( calcMethod == eStatCalcMethod.MATH_WINRATE )
	{
		if ( stat2Int != 0 )
			return (float( stat1Int ) / float( stat2Int )) * 100.0
		else
			return 0
	}

	unreachable
}

array< ItemFlavor > function StatCard_GetAvailableSeasons( int gameMode )
{
	array< ItemFlavor > seasons = GetAllSeasonFlavors()

	foreach( ItemFlavor season in seasons )
	{
		if ( !CalEvent_IsRevealed( season, GetUnixTimestamp() ) )
			seasons.removebyvalue( season )

                         
			                                                           
			if ( gameMode == eStatCardGameMode.ARENAS )
			{
				ItemFlavor season09CalEvent = GetItemFlavorByAsset( $"settings/itemflav/calevent/season09.rpak" )
				int season09StartTime       = CalEvent_GetStartUnixTime( season09CalEvent )
				int startTime               = CalEvent_GetStartUnixTime( season )
				if ( startTime < season09StartTime )
					seasons.removebyvalue( season )
			}
        
	}

	return seasons
}

array< ItemFlavor > function StatCard_GetAvailableSeasonsAndRankedPeriods( int gameMode )
{
	                                                     
	array< ItemFlavor > seasons = clone GetAllItemFlavorsOfType( eItemType.calevent_season )                                                                                                                             
                        
		ItemFlavor season09CalEvent = GetItemFlavorByAsset( $"settings/itemflav/calevent/season09.rpak" )
		int season09StartTime       = CalEvent_GetStartUnixTime( season09CalEvent )
       

	foreach( ItemFlavor season in seasons )
	{
		if ( !CalEvent_IsRevealed( season, GetUnixTimestamp() ) )
			seasons.removebyvalue( season )

		                                                                                        
		string guid = ItemFlavor_GetGUIDString( season )
		if ( guid == "SAID01769158912" )
			seasons.removebyvalue( season )
	}

	array< ItemFlavor > rankedPeriods
	rankedPeriods.extend( GetAllRankedPeriodFlavorsByType( eItemType.calevent_rankedperiod ) )

                        
		array< ItemFlavor > arenaRankedPeriods
		arenaRankedPeriods.extend( GetAllRankedPeriodFlavorsByType( eItemType.calevent_arenas_ranked_period ) )
       

	foreach( ItemFlavor period in rankedPeriods )
	{
		if ( !CalEvent_IsRevealed( period, GetUnixTimestamp() ) )
			rankedPeriods.removebyvalue( period )
	}

	array< ItemFlavor > seasonsAndPeriods = []
	seasonsAndPeriods.extend( seasons )
                        
		if ( gameMode == eStatCardGameMode.ARENAS )
		{
			seasonsAndPeriods.extend( arenaRankedPeriods )
		}
		else
		{
			seasonsAndPeriods.extend( rankedPeriods )
		}
      
                                           
       
	seasonsAndPeriods.sort( SortSeasonAndRankedStats )

                        
	if ( gameMode == eStatCardGameMode.ARENAS )
	{
		int season09Idx = seasonsAndPeriods.find( season09CalEvent )
		for ( int i = 0; i < season09Idx; i++ )
		{
			seasonsAndPeriods.remove(0)
		}
	}
       
	return seasonsAndPeriods
}

int function SortSeasonAndRankedStats( ItemFlavor a, ItemFlavor b )
{
	int aTime = CalEvent_GetStartUnixTime( a )
	int bTime = CalEvent_GetStartUnixTime( b )

	if ( aTime < bTime )
		return -1
	else if ( aTime > bTime )
		return 1
	else if ( IsSeasonFlavor( a ) && !IsSeasonFlavor( b )  )
		return -1
	else if ( !IsSeasonFlavor( a ) && IsSeasonFlavor( b ) )
		return 1
	else
		return 0

	unreachable
}

string function StatCard_GetToolTipFieldFromIndex( int index, int statCardType, int statCardSection )
{
	if ( statCardType == eStatCardType.CAREER )
	{
		if ( statCardSection == eStatCardSection.HEADER )
		{
			return STAT_TOOLTIP_HEADER_CAREER
		}
		else
		{
			if ( index <= 2 )
				return STAT_TOOLTIP_LCIRCLE_CAREER
			else if ( index <= 5 )
				return STAT_TOOLTIP_RCIRCLE_CAREER
			else if ( index <= 8 )
				return STAT_TOOLTIP_COLUMNA_CAREER
			else
				return STAT_TOOLTIP_COLUMNB_CAREER
		}
	}
	else
	{
		if ( statCardSection == eStatCardSection.HEADER )
		{
			return STAT_TOOLTIP_HEADER_SEASON
		}
		else
		{
			if ( index <= 2 )
				return STAT_TOOLTIP_LCIRCLE_SEASON
			else if ( index <= 5 )
				return STAT_TOOLTIP_RCIRCLE_SEASON
			else if ( index <= 8 )
				return STAT_TOOLTIP_COLUMNA_SEASON
			else
				return STAT_TOOLTIP_COLUMNB_SEASON
		}
	}

	return ""
}


bool function ShouldIncludeModeRef( string modeRef, string seasonOrRankedRef )
{
	bool shouldInclude = true

                        
		if ( modeRef.toupper() == "ARENAS" )
		{
			if ( seasonOrRankedRef != "" )
			{
				                                                                                                                                                                  
				array<ItemFlavor> allRankedArenaPeriods = GetAllRankedPeriodFlavorsByType( eItemType.calevent_arenas_ranked_period )
				foreach ( ItemFlavor rankedArenaPeriod in allRankedArenaPeriods )
				{
					if ( ItemFlavor_GetGUIDString( rankedArenaPeriod ) == seasonOrRankedRef )
					{
						shouldInclude = false
						break
					}
				}
			}
		}
       

	return shouldInclude
}


#if UI
void function StatsScreen_SetPanelRui()
{
	var menu = GetMenu( "InspectMenu" )
	var menuPanel = Hud_GetChild( menu, "StatsSummaryPanel" )
	var ruiPanel = Hud_GetChild( menuPanel, "LifetimeAndSeasonalStats" )
	file.statsRui = Hud_GetRui( ruiPanel )
}

void function StatCard_SetStatValueDisplay( string argName, float value, int maxIntegers = 3, int maxDecimals = 0 )
{
	if ( file.statsRui == null )
		StatsScreen_SetPanelRui()

	string valueString = ""

	if( value != -1 )
		valueString = LocalizeAndShortenNumber_Float( value, maxIntegers, maxDecimals )
	else
		valueString = NO_DATA_REF

	                                                                                                                         

	RuiSetString( file.statsRui, argName, valueString )
}

void function StatCard_InitToolTipStringTables()
{
	file.toolTipStrings[ "careerHeader" ] <- []
	file.toolTipStrings[ "careerLeftCircle" ] <- []
	file.toolTipStrings[ "careerRightCircle" ] <- []
	file.toolTipStrings[ "careerColumnA" ] <- []
	file.toolTipStrings[ "careerColumnB" ] <- []

	file.toolTipStrings[ "seasonHeader" ] <- []
	file.toolTipStrings[ "seasonLeftCircle" ] <- []
	file.toolTipStrings[ "seasonRightCircle" ] <- []
	file.toolTipStrings[ "seasonColumnA" ] <- []
	file.toolTipStrings[ "seasonColumnB" ] <- []
}

void function StatCard_ClearToolTipStringTables()
{
	file.toolTipStrings[ "careerHeader" ].clear()
	file.toolTipStrings[ "careerLeftCircle" ].clear()
	file.toolTipStrings[ "careerRightCircle" ].clear()
	file.toolTipStrings[ "careerColumnA" ].clear()
	file.toolTipStrings[ "careerColumnB" ].clear()

	file.toolTipStrings[ "seasonHeader" ].clear()
	file.toolTipStrings[ "seasonLeftCircle" ].clear()
	file.toolTipStrings[ "seasonRightCircle" ].clear()
	file.toolTipStrings[ "seasonColumnA" ].clear()
	file.toolTipStrings[ "seasonColumnB" ].clear()
}

void function StatCard_AddStatToolTipString( string category, string label, float value, int calcMethod, int forcePos = -1 )
{
	string valueString = LocalizeAndShortenNumber_Float( value, 9, 2 )

	if ( calcMethod == eStatCalcMethod.MATH_WINRATE )
		valueString += Localize( "#STATS_VALUE_PERCENT" )

	string toolTipString = label
	if ( toolTipString.find( "_TOOLTIP" ) == -1 )
		toolTipString += "_TOOLTIP"
	toolTipString = Localize( toolTipString )
	toolTipString += valueString

	if ( forcePos > -1 )
		file.toolTipStrings[ category ].insert( forcePos, toolTipString )
	else
		file.toolTipStrings[ category ].append( toolTipString )

	                                                                                                                                                 
}

void function StatCard_SetStatToolTip( string category )
{
	var menu = GetMenu( "InspectMenu" )
	var menuPanel = Hud_GetChild( menu, "StatsSummaryPanel" )

	string toolTipString = ""

	                                                                              

	for( int i = 0; i < file.toolTipStrings[ category ].len(); i++ )
	{
		toolTipString += file.toolTipStrings[ category ][i]

		                                                                                                 

		if( i != file.toolTipStrings[ category ].len() - 1 )
			toolTipString += "\n"
	}

	var toolTipField = GetToolTipField( menuPanel, category )
	ToolTipData toolTipData
	toolTipData.descText = toolTipString
	Hud_SetToolTipData( toolTipField, toolTipData )
}

var function GetToolTipField( var menuPanel, string category )
{
	if ( category == STAT_TOOLTIP_HEADER_CAREER )
	{
		return Hud_GetChild( menuPanel, "StatsCardToolTipField_Summary_Header"  )
	}
	else if ( category == STAT_TOOLTIP_LCIRCLE_CAREER )
	{
		return Hud_GetChild( menuPanel, "StatsCardToolTipField_Summary_LeftCircle"  )
	}
	else if ( category == STAT_TOOLTIP_RCIRCLE_CAREER )
	{
		return Hud_GetChild( menuPanel, "StatsCardToolTipField_Summary_RightCircle"  )
	}
	else if ( category == STAT_TOOLTIP_COLUMNA_CAREER )
	{
		return Hud_GetChild( menuPanel, "StatsCardToolTipField_Summary_ColumnA"  )
	}
	else if ( category == STAT_TOOLTIP_COLUMNB_CAREER )
	{
		return Hud_GetChild( menuPanel, "StatsCardToolTipField_Summary_ColumnB"  )
	}
	else if ( category == STAT_TOOLTIP_HEADER_SEASON )
	{
		return Hud_GetChild( menuPanel, "StatsCardToolTipField_Season_Header"  )
	}
	else if ( category == STAT_TOOLTIP_LCIRCLE_SEASON )
	{
		return Hud_GetChild( menuPanel, "StatsCardToolTipField_Season_LeftCircle"  )
	}
	else if ( category == STAT_TOOLTIP_RCIRCLE_SEASON )
	{
		return Hud_GetChild( menuPanel, "StatsCardToolTipField_Season_RightCircle"  )
	}
	else if ( category == STAT_TOOLTIP_COLUMNA_SEASON )
	{
		return Hud_GetChild( menuPanel, "StatsCardToolTipField_Season_ColumnA"  )
	}
	else
	{
		return Hud_GetChild( menuPanel, "StatsCardToolTipField_Season_ColumnB"  )
	}
}

var function CreateNestedProgressBar( var parentRui, string argName )
{
	var nestedRui = RuiCreateNested( parentRui, argName, $"ui/xp_progress_bars_stats_card.rpak" )

	return nestedRui
}

var function CreateNestedRankedBadge( var parentRui, string argName )
{
	var nestedRui = RuiCreateNested( parentRui, argName, $"ui/ranked_badge.rpak" )

	return nestedRui
}

void function StatsCard_OnRankedPeriodRegistered( ItemFlavor rp )
{
	string seasonGUIDString = ItemFlavor_GetGUIDString( rp )
	file.GUIDToSeasonNumber[ seasonGUIDString ] <- 0
}

                       
void function StatsCard_OnArenasRankedPeriodRegistered( ItemFlavor calEventArenasRanked )
{
	string seasonGUIDString = ItemFlavor_GetGUIDString( calEventArenasRanked )
	file.GUIDToSeasonNumber[ seasonGUIDString ] <- 0
}
      

void function StatsCard_OnSeasonRegistered( ItemFlavor rp )                                                                                                                   
{
	string seasonGUIDString = ItemFlavor_GetGUIDString( rp )
	file.GUIDToSeasonNumber[ seasonGUIDString ] <- file.currentGUIDToSeasonNumber++
}


string function StatsCard_GetNameOfGameMode( int gameMode )
{
	switch( gameMode )
	{
                         
			case eStatCardGameMode.ARENAS:
				return "#STATS_CARD_MODE_ARENAS"
        
		default:
			return "#STATS_CARD_MODE_BR"
	}

	unreachable
}


string function StatsCard_GetRefOfGameMode( int gameMode )
{
	string mode
                        
		switch( gameMode )
		{
			case eStatCardGameMode.ARENAS:
				mode = "arenas"
				break
		}
       

	if ( STATS_ALTERNATE_MODE_REFS.contains( mode ) )
	{
		return mode
	}

	return ""
}


                         
string function GetGameModeName( int gameMode )
{
	switch ( gameMode )
	{
		case eStatCardGameMode.BATTLE_ROYALE:
			return "BATTLE ROYALE"
                         
			case eStatCardGameMode.ARENAS:
				return "ARENAS"
        
		default:
			return "UNKNOWN"
	}

	unreachable
}


string function GetCardTypeName( int cardType )
{
	switch ( cardType )
	{
		case eStatCardType.CAREER:
			return "CAREER"
		case eStatCardType.SEASON:
			return "SEASON"
		case eStatCardType.RANKEDPERIOD:
			return "RANKEDPERIOD"
		default:
			return "UNKNOWN"
	}

	unreachable
}


string function GetSectionName( int section )
{
	switch ( section )
	{
		case eStatCardSection.HEADER:
			return "HEADER"
		case eStatCardSection.HEADERTOOLTIP:
			return "HEADERTOOLTIP"
		case eStatCardSection.BODY:
			return "BODY"
		case eStatCardSection.BODYTOOLTIP:
			return "BODYTOOLTIP"
		default:
			return "UNKNOWN"
	}

	unreachable
}

int function StatsCard_GetApprovedModesCount()
{
	int finalCount

	for ( int i=0; i < eStatCardGameMode._count; i++ )
	{
		if ( i >= eStatCardGameMode.UNKNOWN )
			break
		else
			finalCount = i
	}

	return finalCount
}

bool function StatsCard_IsSeasonOrRankedRefValidForMode( int gameMode, string rankedRef )
{
	if ( gameMode == eStatCardGameMode.UNKNOWN )
		return false

	bool isMatch
	array<ItemFlavor> seasonAndRankedPeriods = StatCard_GetAvailableSeasonsAndRankedPeriods( gameMode )

	foreach ( rankedPeriod in seasonAndRankedPeriods )
	{
		string guid = ItemFlavor_GetGUIDString( rankedPeriod )
		if ( guid == rankedRef )
		{
			isMatch = true
			break
		}
	}

	return isMatch
}
#endif      
