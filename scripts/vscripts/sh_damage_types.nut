global function DamageTypes_Init
global function RegisterWeaponDamageSource
global function GetObitFromDamageSourceID
global function GetObitImageFromDamageSourceID
global function DamageSourceIDToString
global function DamageSourceIDHasString
global function GetRefFromDamageSourceID
global function PIN_GetDamageCause

struct
{
	table<int,string> damageSourceIDToName
	table<int,asset> damageSourceIDToImage
	table<int,string> damageSourceIDToString
} file

global enum eDamageSourceId
{
	invalid 	= -1  //

	//
	//
	//
	code_reserved  				//
	damagedef_unknown		   	//
	damagedef_unknownBugIt
	damagedef_suicide
	damagedef_despawn
	damagedef_titan_step
	damagedef_crush
	damagedef_sonic_blast
	damagedef_nuclear_core
	damagedef_titan_fall
	damagedef_titan_hotdrop
	damagedef_reaper_fall
	damagedef_trip_wire
	damagedef_wrecking_ball
	damagedef_reaper_groundslam
	damagedef_reaper_nuke
	damagedef_frag_drone_explode
	damagedef_frag_drone_explode_FD
	damagedef_frag_drone_throwable_PLAYER
	damagedef_frag_drone_throwable_NPC
	damagedef_stalker_powersupply_explosion_small
	damagedef_stalker_powersupply_explosion_large
	damagedef_stalker_powersupply_explosion_large_at
	damagedef_shield_captain_arc_shield
	damagedef_fd_explosive_barrel
	damagedef_fd_tether_trap
	damagedef_pilot_slam
	damagedef_ticky_arc_blast
	damagedef_grenade_gas
	damagedef_gas_exposure
	damagedef_dirty_bomb_explosion
	damagedef_sonic_boom
	damagedef_bangalore_smoke_explosion
	damagedef_creeping_bombardment_detcord_explosion
	damagedef_defensive_bombardment

	//

	//
	mp_weapon_hemlok
	mp_weapon_lmg
	mp_weapon_rspn101
	mp_weapon_vinson
	mp_weapon_lstar
	mp_weapon_g2
	mp_weapon_r97
	#if(false)

#endif
	mp_weapon_dmr
	mp_weapon_wingman
	mp_weapon_semipistol
	mp_weapon_autopistol
	mp_weapon_sniper
	mp_weapon_shotgun
	mp_weapon_mastiff
	mp_weapon_frag_grenade
	mp_weapon_grenade_emp
	mp_weapon_arc_blast
	mp_weapon_thermite_grenade
	mp_weapon_nuke_satchel
	#if(false)

#endif
	mp_extreme_environment
	mp_weapon_shotgun_pistol
	#if(false)

#endif
	#if(false)

#endif
	mp_weapon_doubletake
	mp_weapon_alternator_smg
	mp_weapon_esaw
	mp_weapon_wrecking_ball
	mp_weapon_melee_survival
	mp_weapon_pdw
	#if(false)

#endif
	mp_weapon_energy_ar
	#if(false)

#endif
	//
	melee_pilot_emptyhanded

	melee_wraith_kunai
	mp_weapon_wraith_kunai_primary

	//
	mp_weapon_defensive_bombardment_weapon
	mp_weapon_creeping_bombardment_weapon

	#if(false)

#endif //
	#if(false)
#endif //
	#if(false)

#endif //
	#if(false)


#endif //
	#if(false)

#endif //
	#if(false)


#endif //
	#if(false)
#endif //
	#if(false)
#endif //
	#if(false)

#endif //
	#if(false)
#endif //
	#if(false)


#endif //
	#if(false)

#endif //

	//
	mp_weapon_super_spectre
	mp_weapon_dronebeam
	mp_weapon_dronerocket
	mp_weapon_droneplasma
	mp_weapon_turretplasma
	mp_weapon_turretrockets
	mp_weapon_turretplasma_mega
	mp_weapon_gunship_launcher
	mp_weapon_gunship_turret
	mp_weapon_gunship_missile

	//
	human_melee
	auto_titan_melee
	mind_crime
	charge_ball
	grunt_melee
	spectre_melee
	prowler_melee
	super_spectre_melee
	titan_execution
	human_execution
	eviscerate
	wall_smash
	ai_turret
	team_switch
	rocket
	titan_explosion
	flash_surge
	#if(false)

#endif
	sticky_time_bomb
	vortex_grenade
	droppod_impact
	ai_turret_explosion
	rodeo_trap
	round_end
	bubble_shield
	evac_dropship_explosion
	sticky_explosive
	titan_grapple

	//

	//
	fall
	splat
	crushed
	burn
	lasergrid
	outOfBounds
	indoor_inferno
	submerged
	switchback_trap
	floor_is_lava
	suicideSpectreAoE
	titanEmpField
	stuck
	deadly_fog
	exploding_barrel
	electric_conduit
	turbine
	harvester_beam
	toxic_sludge

	mp_weapon_spectre_spawner

	//
	weapon_cubemap

	//
	phase_shift
	mp_ability_consumable

	bombardment
	bleedout
	mp_weapon_energy_shotgun
	fire
	#if(false)

#endif
	//
	//
	//
	//
	//
	//

	#if(false)


//
#endif

	_count
}

void function DamageTypes_Init()
{
#if(false)

#endif

	foreach ( name, number in eDamageSourceId )
	{
		file.damageSourceIDToString[ number ] <- name
	}

	PrecacheWeapon( $"mp_weapon_rspn101" ) //

#if(DEV)

	int numDamageDefs = DamageDef_GetCount()
	table damageSourceIdEnum = expect table( getconsttable().eDamageSourceId )
	foreach ( name, id in damageSourceIdEnum )
	{
		expect int( id )
		if ( id <= eDamageSourceId.code_reserved || id >= numDamageDefs )
			continue

		string damageDefName = DamageDef_GetName( id )
		Assert( damageDefName == name, "damage def (" + id + ") name: '" + damageDefName + "' doesn't match damage source id '" + name + "'" )
	}
#endif

	file.damageSourceIDToName =
	{
		//
		[ eDamageSourceId.mp_extreme_environment ] 					= "#DAMAGE_EXTREME_ENVIRONMENT",

		[ eDamageSourceId.mp_weapon_super_spectre ]					= "#WPN_SUPERSPECTRE_ROCKETS",
		[ eDamageSourceId.mp_weapon_dronebeam ] 					= "#WPN_DRONERBEAM",
		[ eDamageSourceId.mp_weapon_dronerocket ] 					= "#WPN_DRONEROCKET",
		[ eDamageSourceId.mp_weapon_droneplasma ] 					= "#WPN_DRONEPLASMA",
		[ eDamageSourceId.mp_weapon_turretplasma ] 					= "#WPN_TURRETPLASMA",
		[ eDamageSourceId.mp_weapon_turretrockets ] 				= "#WPN_TURRETROCKETS",
		[ eDamageSourceId.mp_weapon_turretplasma_mega ] 			= "#WPN_TURRETPLASMA_MEGA",
		[ eDamageSourceId.mp_weapon_gunship_launcher ] 				= "#WPN_GUNSHIP_LAUNCHER",
		[ eDamageSourceId.mp_weapon_gunship_turret ]				= "#WPN_GUNSHIP_TURRET",
		[ eDamageSourceId.mp_weapon_gunship_turret ]				= "#WPN_GUNSHIP_MISSILE",

		[ eDamageSourceId.auto_titan_melee ] 						= "#DEATH_AUTO_TITAN_MELEE",

		[ eDamageSourceId.prowler_melee ] 							= "#DEATH_PROWLER_MELEE",
		[ eDamageSourceId.super_spectre_melee ] 					= "#DEATH_SUPER_SPECTRE",
		[ eDamageSourceId.grunt_melee ] 							= "#DEATH_GRUNT_MELEE",
		[ eDamageSourceId.spectre_melee ] 							= "#DEATH_SPECTRE_MELEE",
		[ eDamageSourceId.eviscerate ]	 							= "#DEATH_EVISCERATE",
		[ eDamageSourceId.wall_smash ] 								= "#DEATH_WALL_SMASH",
		[ eDamageSourceId.ai_turret ] 								= "#DEATH_TURRET",
		[ eDamageSourceId.team_switch ] 							= "#DEATH_TEAM_CHANGE",
		[ eDamageSourceId.rocket ] 									= "#DEATH_ROCKET",
		[ eDamageSourceId.titan_explosion ] 						= "#DEATH_TITAN_EXPLOSION",
		[ eDamageSourceId.evac_dropship_explosion ] 				= "#DEATH_EVAC_DROPSHIP_EXPLOSION",
		[ eDamageSourceId.flash_surge ] 							= "#DEATH_FLASH_SURGE"
		#if(false)

#endif
		,[ eDamageSourceId.sticky_time_bomb ] 						= "#DEATH_STICKY_TIME_BOMB",
		[ eDamageSourceId.vortex_grenade ] 							= "#DEATH_VORTEX_GRENADE",
		[ eDamageSourceId.droppod_impact ] 							= "#DEATH_DROPPOD_CRUSH",
		[ eDamageSourceId.ai_turret_explosion ] 					= "#DEATH_TURRET_EXPLOSION",
		[ eDamageSourceId.rodeo_trap ] 								= "#DEATH_RODEO_TRAP",
		[ eDamageSourceId.round_end ] 								= "#DEATH_ROUND_END",
		[ eDamageSourceId.burn ]	 								= "#DEATH_BURN",
		[ eDamageSourceId.mind_crime ]								= "Mind Crime",
		[ eDamageSourceId.charge_ball ]								= "Charge Ball",

		[ eDamageSourceId.bubble_shield ] 							= "#DEATH_BUBBLE_SHIELD",
		[ eDamageSourceId.sticky_explosive ] 						= "#DEATH_STICKY_EXPLOSIVE",
		[ eDamageSourceId.titan_grapple ] 							= "#DEATH_TITAN_GRAPPLE",

		//
		[ eDamageSourceId.fall ]		 							= "#DEATH_FALL",
		 //
		[ eDamageSourceId.splat ] 									= "#DEATH_SPLAT",
		[ eDamageSourceId.titan_execution ] 						= "#DEATH_TITAN_EXECUTION",
		[ eDamageSourceId.human_execution ] 						= "#DEATH_HUMAN_EXECUTION",
		[ eDamageSourceId.outOfBounds ] 							= "#DEATH_OUT_OF_BOUNDS",
		[ eDamageSourceId.indoor_inferno ]	 						= "#DEATH_INDOOR_INFERNO",
		[ eDamageSourceId.submerged ]								= "#DEATH_SUBMERGED",
		[ eDamageSourceId.switchback_trap ]							= "#DEATH_ELECTROCUTION", //
		[ eDamageSourceId.floor_is_lava ]							= "#DEATH_ELECTROCUTION",
		[ eDamageSourceId.suicideSpectreAoE ]						= "#DEATH_SUICIDE_SPECTRE", //
		[ eDamageSourceId.titanEmpField ] 							= "#DEATH_TITAN_EMP_FIELD",
		[ eDamageSourceId.deadly_fog ] 								= "#DEATH_DEADLY_FOG",


		//
		[ eDamageSourceId.phase_shift ]								= "#WPN_SHIFTER",
		[ eDamageSourceId.bleedout ]								= "#DEATH_BLEEDOUT",
		[ eDamageSourceId.mp_weapon_energy_shotgun ]				= "Energy Shotgun",

		[ eDamageSourceId.damagedef_unknownBugIt ] 					= "#DEATH_GENERIC_KILLED",
		[ eDamageSourceId.damagedef_unknown ] 						= "#DEATH_GENERIC_KILLED",
		[ eDamageSourceId.weapon_cubemap ] 							= "#DEATH_GENERIC_KILLED",
		[ eDamageSourceId.stuck ]		 							= "#DEATH_GENERIC_KILLED",

		[ eDamageSourceId.melee_pilot_emptyhanded ] 				= "#DEATH_MELEE",
		[ eDamageSourceId.melee_wraith_kunai ] 						= "#DEATH_MELEE_WRAITH_KUNAI",
		[ eDamageSourceId.mp_weapon_wraith_kunai_primary ] 			= "#DEATH_MELEE_WRAITH_KUNAI",
	}

	#if(DEV)
		//
		file.damageSourceIDToName[ eDamageSourceId.damagedef_unknownBugIt ] 			= "UNKNOWN! BUG IT!"
		file.damageSourceIDToName[ eDamageSourceId.damagedef_unknown ] 				= "Unknown"
		file.damageSourceIDToName[ eDamageSourceId.weapon_cubemap ] 					= "Cubemap"
		//
		file.damageSourceIDToName[ eDamageSourceId.stuck ]		 					= "NPC got Stuck (Don't Bug it!)"
	#endif
}

void function RegisterWeaponDamageSource( string weaponRef )
{
	int sourceID = eDamageSourceId[weaponRef]
	file.damageSourceIDToName[ sourceID ] <- GetWeaponInfoFileKeyField_GlobalString( weaponRef, "shortprintname" )
	file.damageSourceIDToImage[ sourceID ] <- GetWeaponInfoFileKeyFieldAsset_Global( weaponRef, "hud_icon" )
	file.damageSourceIDToString[ sourceID ] <- weaponRef
}

bool function DamageSourceIDHasString( int index )
{
	return (index in file.damageSourceIDToString)
}

string function DamageSourceIDToString( int index )
{
	return file.damageSourceIDToString[ index ]
}

string function GetObitFromDamageSourceID( int damageSourceID )
{
	if ( damageSourceID > 0 && damageSourceID < DamageDef_GetCount() )
	{
		return DamageDef_GetObituary( damageSourceID )
	}

	if ( damageSourceID in file.damageSourceIDToName )
		return file.damageSourceIDToName[ damageSourceID ]

	table damageSourceIdEnum = expect table( getconsttable().eDamageSourceId )
	foreach ( name, id in damageSourceIdEnum )
	{
		if ( id == damageSourceID )
			return expect string( name )
	}

	return ""
}

asset function GetObitImageFromDamageSourceID( int damageSourceID )
{
	if ( damageSourceID in file.damageSourceIDToImage )
		return file.damageSourceIDToImage[ damageSourceID ]

	return $""
}

string function GetRefFromDamageSourceID( int damageSourceID )
{
	return file.damageSourceIDToString[damageSourceID]
}

string function PIN_GetDamageCause( var damageInfo )
{
	/*









*/

	//

	return ""
}
