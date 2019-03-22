
//
//
//
//
//
//
global function Settings_Init

global table<string, string> GAMETYPE_TEXT = {}

global table<string, string> GAMETYPE_DESC = {}

//
//
//

global table<string, array<int> > GAMETYPE_COLOR = {}

global string GAMETYPE
global int MAX_TEAMS
global int MAX_PLAYERS
global int MAX_TEAM_PLAYERS
global string GAMEDESC_CURRENT


//
//
//

global const DOUBLEKILL_REQUIREMENT_KILLS 			= 2			//
global const TRIPLEKILL_REQUIREMENT_KILLS 			= 3			//
global const MEGAKILL_REQUIREMENT_KILLS 			= 4			//
global const CASCADINGKILL_REQUIREMENT_TIME 		= 5.0		//
global const ONSLAUGHT_REQUIREMENT_KILLS 			= 8			//
global const ONSLAUGHT_REQUIREMENT_TIME 			= 2.0		//
global const MAYHEM_REQUIREMENT_KILLS 				= 4			//
global const MAYHEM_REQUIREMENT_TIME 				= 2.0		//
global const QUICK_REVENGE_TIME_LIMIT 				= 20.0		//
global const NEMESIS_KILL_REQUIREMENT 				= 3			//
global const DOMINATING_KILL_REQUIREMENT			= 3			//
global const RAMPAGE_KILL_REQUIREMENT				= 5			//
global const KILLINGSPREE_KILL_REQUIREMENT			= 3			//
global const COMEBACK_DEATHS_REQUIREMENT 			= 3			//
global const WORTHIT_REQUIREMENT_TIME 				= 0.5		//

//
//
//

global const OBITUARY_ENABLED_PLAYERS				= 1
global const OBITUARY_ENABLED_NPC					= 0
global const OBITUARY_ENABLED_NPC_TITANS			= 1

global const OBITUARY_DURATION						= 10.0					//

global const OBITUARY_COLOR_DEFAULT 				= <255,255,255>		//
global const OBITUARY_COLOR_FRIENDLY 				= <FRIENDLY_R, FRIENDLY_G, FRIENDLY_B>		//
global const OBITUARY_COLOR_PARTY 					= <179,255,204>		//
global const OBITUARY_COLOR_WEAPON	 				= <255,255,255>		//
global const OBITUARY_COLOR_ENEMY 					= <ENEMY_R, ENEMY_G, ENEMY_B>		//
global const OBITUARY_COLOR_LOCALPLAYER 			= <LOCAL_R, LOCAL_G, LOCAL_B>		//

//
//
//


global const SPLASH_X								= 30				//
global const SPLASH_X_GAP							= 10				//
global const SPLASH_Y								= 120			//
global const SPLASH_DURATION 						= 5.0				//
global const SPLASH_FADE_OUT_DURATION				= 0.5				//
global const SPLASH_SPACING							= 12				//
global const SPLASH_SCROLL_TIME						= 0.1				//
global const SPLASH_TYPEWRITER_TIME					= 0.25				//
global const SPLASH_SHOW_MULTI_SCORE_TOTAL			= 1					//
global const SPLASH_MULTI_SCORE_REQUIREMENT			= 1					//
global const SPLASH_TOTAL_POS_X						= 50
global const SPLASH_TOTAL_POS_Y						= -30
global const SPLASH_TEXT_COLOR 						= "173 226 255 180"	//
global const SPLASH_VALUE_OFFSET_X					= 0 //
global const SPLASH_VALUE_OFFSET_Y					= 0 //
//


//
//
//

global const TEAM_OWNED_SCORE_FREQ					= 2.0				//
global const PLAYER_HELD_SCORE_FREQ					= 10.0				//

global const CAPTURE_DURATION_CAPTURE				= 10.0				//
global const CAPTURE_DURATION_NEUTRALIZE	 		= 10				//
global const CAPTURE_POINT_COLOR_FRIENDLY 			= "77 142 197 255"	//
global const CAPTURE_POINT_COLOR_ENEMY 				= "192 120 77 255"	//
global const CAPTURE_POINT_COLOR_NEUTRAL 			= "190 190 190 255"	//
global const CAPTURE_POINT_COLOR_FRIENDLY_CAP		= "77 142 197 255"	//
global const CAPTURE_POINT_COLOR_ENEMY_CAP			= "192 120 77 255"	//
global const CAPTURE_POINT_ALPHA_MIN_VALUE			= 120				//
global const CAPTURE_POINT_ALPHA_MIN_DISTANCE 		= 2000				//
global const CAPTURE_POINT_ALPHA_MAX_VALUE 			= 255				//
global const CAPTURE_POINT_ALPHA_MAX_DISTANCE 		= 400				//
global const CAPTURE_POINT_CROSSHAIR_DIST_MAX 		= 40000				//
global const CAPTURE_POINT_CROSSHAIR_DIST_MIN 		= 2500				//
global const CAPTURE_POINT_CROSSHAIR_ALPHA_MOD		= 0.5				//
global const CAPTURE_POINT_SLIDE_IN_TIME			= 0.15
global const CAPTURE_POINT_SLIDE_OUT_TIME			= 0.1
global const CAPTURE_POINT_MINIMAP_ICON_SCALE		= 0.15
global const CAPTURE_POINT_TITANS_BREAK_CONTEST		= true

global const CAPTURE_POINT_AI_CAP_POWER				= 0.25				//

global const CAPTURE_POINT_MAX_PULSE_SPEED			= 2.0				//

global const CAPTURE_POINT_STATE_UNASSIGNED			= 0					//
global const CAPTURE_POINT_STATE_HALTED				= 1					//
global const CAPTURE_POINT_STATE_CAPPING			= 2				//
global const CAPTURE_POINT_STATE_SELF_UNAMPING		= 3		//

//
global const CAPTURE_POINT_STATE_CAPTURED			= 4				//
global const CAPTURE_POINT_STATE_AMPING				= 5
global const CAPTURE_POINT_STATE_AMPED				= 6				//

global const CAPTURE_POINT_STATE_CONTESTED			= 7					//
//
//

global const CAPTURE_POINT_FLAGS_CONTESTED			= (1 << 0)
global const CAPTURE_POINT_FLAGS_AMPED				= (1 << 1)

global const float HARDPOINT_AMPED_DELAY 			= 30.0

global const CAPTURE_POINT_ENEMY					= "Contested: %d/%d"
global const CAPTURE_POINT_ENEMIES					= "Contested: %d/%d"
global const CAPTURE_POINT_EMPTY					= ""
global const CAPTURE_POINT_SECURE					= "Secured" //

//
global const CAPTURE_DURATION_PILOT_CAPTURE = 8
global const CAPTURE_DURATION_TITAN_CAPTURE = 20

//
//
//
global const ROUND_WINNING_KILL_REPLAY_STARTUP_WAIT = 3.5
global const ROUND_WINNING_KILL_REPLAY_LENGTH_OF_REPLAY = 7.5
global const ROUND_WINNING_KILL_REPLAY_SCREEN_FADE_TIME = 4.0
global const ROUND_WINNING_KILL_REPLAY_POST_DEATH_TIME = 3.5

global const ROUND_WINNING_KILL_REPLAY_ANNOUNCEMENT_DURATION = ROUND_WINNING_KILL_REPLAY_LENGTH_OF_REPLAY - ROUND_WINNING_KILL_REPLAY_POST_DEATH_TIME
global const ROUND_WINNING_KILL_REPLAY_CROSSHAIR_FADEOUT_TIME = ROUND_WINNING_KILL_REPLAY_ANNOUNCEMENT_DURATION - 0.5
global const ROUND_WINNING_KILL_REPLAY_DELAY_BETWEEN_ANNOUNCEMENTS = 2.0
global const ROUND_WINNING_KILL_REPLAY_ROUND_SCORE_ANNOUNCEMENT_DURATION = 4.0
global const ROUND_WINNING_KILL_REPLAY_FINAL_SCORE_ANNOUNCEMENT_DURATION = 6.0
global const ROUND_WINNING_KILL_REPLAY_TOTAL_LENGTH = ROUND_WINNING_KILL_REPLAY_STARTUP_WAIT + ROUND_WINNING_KILL_REPLAY_LENGTH_OF_REPLAY


//
//
//

global const GAME_POSTMATCH_LENGTH = 10.0
global const GAME_WINNER_DETERMINED_ROUND_WAIT = 10.0
global const GAME_WINNER_DETERMINED_FINAL_ROUND_WAIT = 3.0
global const GAME_WINNER_DETERMINED_FINAL_ROUND_WITH_ROUND_WINNING_KILL_REPLAY_WAIT = ROUND_WINNING_KILL_REPLAY_TOTAL_LENGTH + 2.0
global const GAME_WINNER_DETERMINED_ROUND_WAIT_WITH_ROUND_WINNING_KILL_REPLAY_WAIT =  ROUND_WINNING_KILL_REPLAY_TOTAL_LENGTH + 3.0
global const SWITCHING_SIDES_DELAY = 8.0
global const SWITCHING_SIDES_DELAY_REPLAY = 2.0

global const GAME_WINNER_DETERMINED_WAIT = 12.8 //
global const GAME_EPILOGUE_PLAYER_RESPAWN_LEEWAY = 10.0
global const GAME_EPILOGUE_ENDING_LEADUP = 6.0
global const GAME_POSTROUND_CLEANUP_WAIT = 5.0
global const PREMATCH_COUNTDOWN_SOUND = "Menu_Timer_LobbyCountdown_Tick"
global const WAITING_FOR_PLAYERS_COUNTDOWN_SOUND = "UI_Survival_Intro_WaitinForPlayers_Countdown"

//
global enum eGameState	//
{
	WaitingForCustomStart,
	WaitingForPlayers,
	PickLoadout,
	Prematch,
	Playing,
	SuddenDeath,
	SwitchingSides,
	WinnerDetermined,
	Epilogue,
	Postmatch,

	_count_
}

//
//
//

global const LOUD_WEAPON_AI_SOUND_RADIUS			= 4000.0
global const LOUD_WEAPON_AI_SOUND_RADIUS_MP			= 5000.0

global const WEAPON_FLYOUTS_ENABLED					= 0					//


//
//
//
global const START_SPAWN_GRACE_PERIOD			= 20.0
global const CLASS_CHANGE_GRACE_PERIOD			= 20.0
global const WAVE_SPAWN_GRACE_PERIOD			= 3.0

//
//
//
global const ELIM_FIRST_SPAWN_GRACE_PERIOD		= 20.0
global const ELIM_TITAN_SPAWN_GRACE_PERIOD		= 30.0

//
global const BALL_LIGHTNING_BURST_NUM = 1
global const BALL_LIGHTNING_BURST_DELAY = 0.4
global const BALL_LIGHTNING_BURST_PAUSE = 0.3 //

global const BALL_LIGHTNING_ZAP_LIFETIME = 0.3
global const BALL_LIGHTNING_ZAP_FX = $"P_wpn_arcball_beam"
global const BALL_LIGHTNING_FX_TABLE = ""
global const BALL_LIGHTNING_ZAP_RADIUS = 400
global const BALL_LIGHTNING_ZAP_HUMANSIZE_RADIUS = 200
global const BALL_LIGHTNING_ZAP_HEIGHT = 300
global const BALL_LIGHTNING_ZAP_SOUND = "weapon_arc_ball_tendril"
global const BALL_LIGHTNING_DAMAGE = 120

global const BALL_LIGHTNING_DAMAGE_TO_PILOTS = 8

global const BALL_LIGHTNING_CHARGED_ZAP_LIFETIME = 0.4
global const BALL_LIGHTNING_CHARGED_ZAP_RADIUS = 600
global const BALL_LIGHTNING_CHARGED_ZAP_HEIGHT = 300
global const BALL_LIGHTNING_CHARGED_DAMAGE = 60

//

global const SFX_SMOKE_DEPLOY_1P = "titan_offhand_electricsmoke_deploy_1P"
global const SFX_SMOKE_DEPLOY_3P = "titan_offhand_electricsmoke_deploy_3P"
global const SFX_SMOKE_DEPLOY_BURN_1P = "titan_offhand_electricsmoke_deploy_amped_1P"
global const SFX_SMOKE_DEPLOY_BURN_3P = "titan_offhand_electricsmoke_deploy_amped_3P"
global const SFX_SMOKE_GRENADE_DEPLOY = "Weapon_SmokeGrenade_Temp"
global const SFX_SMOKE_DAMAGE = "Titan_Offhand_ElectricSmoke_Damage"
global const ELECTRIC_SMOKESCREEN_SFX_DAMAGE_PILOT_1P = "Titan_Offhand_ElectricSmoke_Human_Damage_1P"
global const ELECTRIC_SMOKESCREEN_SFX_DAMAGE_PILOT_3P = "Titan_Offhand_ElectricSmoke_Human_Damage_3P"
global const ELECTRIC_SMOKESCREEN_SFX_DAMAGE_TITAN_1P = "Titan_Offhand_ElectricSmoke_Titan_Damage_1P"
global const ELECTRIC_SMOKESCREEN_SFX_DAMAGE_TITAN_3P = "Titan_Offhand_ElectricSmoke_Titan_Damage_3P"
global const ELECTRIC_SMOKE_GRENADE_SFX_DAMAGE_PILOT_1P = "Titan_Offhand_ElectricSmoke_Human_Damage_1P"
global const ELECTRIC_SMOKE_GRENADE_SFX_DAMAGE_PILOT_3P = "Titan_Offhand_ElectricSmoke_Human_Damage_3P"
global const ELECTRIC_SMOKE_GRENADE_SFX_DAMAGE_TITAN_1P = "Titan_Offhand_ElectricSmoke_Titan_Damage_1P"
global const ELECTRIC_SMOKE_GRENADE_SFX_DAMAGE_TITAN_3P = "Titan_Offhand_ElectricSmoke_Titan_Damage_3P"

global const SMOKESCREEN_SFX_POPCORN_EXPLOSION = "Weapon_ElectricSmokescreen.Explosion"

global const FX_ELECTRIC_SMOKESCREEN = $"P_wpn_smk_electric"
global const FX_ELECTRIC_SMOKESCREEN_BURN = $"P_wpn_smk_electric_burn_mod"
global const FX_ELECTRIC_SMOKESCREEN_HEAL = $"P_wpn_smk_electric_heal"
global const FX_GRENADE_SMOKESCREEN = $"P_smkscreen_test"

global const MAX_DAMAGE_HISTORY_TIME 					= SECONDS_PER_MINUTE * 5
global const MAX_NPC_KILL_STEAL_PREVENTION_TIME			= 0.0 //
global const MAX_ASSIST_TIME_GAP						= 0.75 //

global const HIT_GROUP_HEADSHOT 						= 1 //

//
//
//
global const PILOT_SYNCED_MELEE_CONETRACE_RANGE = 400
global const PILOT_SYNCED_MELEE_CONETRACE_RANGE_PHASE_ASSASSIN = 2048

global const HUMAN_EXECUTION_RANGE = 115
global const HUMAN_EXECUTION_ANGLE = 40

global const PILOT_ELITE_MELEE_COUNTER_RANGE = 400
global const PILOT_ELITE_MELEE_COUNTER_DAMAGE = 400
global const PROWLER_EXECUTION_RANGE = 200
global const PROWLER_EXECUTION_ANGLE = 40

//
global const HUMAN_MELEE_KICK_ATTACK_DAMAGE = 120
global const HUMAN_MELEE_KICK_ATTACK_PUSHBACK_MULTIPLIER = 600


//
//
//

global const int VO_PRIORITY_STORY						= 3000	//
global const int VO_PRIORITY_GAMESTATE					= 1500	//
global const int VO_PRIORITY_ELIMINATION_STATUS			= 1250  //
global const int VO_PRIORITY_GAMEMODE					= 800
global const int VO_PRIORITY_PLAYERSTATE				= 500
//
//
//

//
global const VO_PRIORITY_AI_CHATTER_HIGH	= 30
global const VO_PRIORITY_AI_CHATTER			= 20
global const VO_PRIORITY_AI_CHATTER_LOW		= 10
global const VO_PRIORITY_AI_CHATTER_LOWEST	= 1

global float VO_DEBOUNCE_TIME_AI_CHATTER_HIGH	= 4.0
global float VO_DEBOUNCE_TIME_AI_CHATTER		= 5.0
global float VO_DEBOUNCE_TIME_AI_CHATTER_LOW	= 6.0
global float VO_DEBOUNCE_TIME_AI_CHATTER_LOWEST	= 7.0

global const STANCE_KNEEL = 0
global const STANCE_KNEELING = 1 //
global const STANCE_STANDING = 2 //
global const STANCE_STAND = 3


//
//
//

global const TITAN_DAMAGE_STATE_ARMOR_HEALTH			= 0.25	//
global const TITAN_ADDITIVE_FLINCH_DAMAGE_THRESHOLD	= 500	//
global const COCKPIT_SPARK_FX_DAMAGE_LIMIT = 200 //

//
//
//

global const TITAN_BUBBLE_SHIELD_INVULNERABILITY_RANGE = 240
global const TITAN_BUBBLE_SHIELD_INVULNERABILITY_RANGE_SQUARED = TITAN_BUBBLE_SHIELD_INVULNERABILITY_RANGE * TITAN_BUBBLE_SHIELD_INVULNERABILITY_RANGE
global const TITAN_BUBBLE_SHIELD_CYLINDER_TRIGGER_HEIGHT = TITAN_BUBBLE_SHIELD_INVULNERABILITY_RANGE + 50 //

#if(false)

#else
global const FIRST_PERSON_SPECTATOR_DELAY = 0.5
#endif //

global const BURN_METER_RADAR_JAMMER_PULSE_DURATION = 6.0
global const BURN_METER_RADAR_JAMMER_EASE_OFF_TIME = 1.0

void function Settings_Init()
{
	level.teams <- [ TEAM_IMC, TEAM_MILITIA ]

	#if(!UI)
		#if(false)


#endif

		GAMETYPE = GameRules_GetGameMode()
		printl( "GAMETYPE: " + GAMETYPE )

		MAX_TEAMS = GetCurrentPlaylistVarInt( "max_teams", 2 )
		printl( "MAX_TEAMS: " + MAX_TEAMS )

		MAX_PLAYERS = GetCurrentPlaylistVarInt( "max_players", 12 )
		printl( "MAX_PLAYERS: " + MAX_PLAYERS )

		MAX_TEAM_PLAYERS = GetMaxTeamPlayers()
		printl( "MAX_TEAM_PLAYERS: " + MAX_TEAM_PLAYERS )

		GAMEDESC_CURRENT = GAMETYPE_DESC[GAMETYPE]

		Assert( GAMETYPE in GAMETYPE_TEXT, "Unsupported gamemode: " + GameRules_GetGameMode() + " is not a valid game mode." )

		SetWaveSpawnType( GetCurrentPlaylistVarInt( "riff_wave_spawn", 0 ) )
	#endif
}
