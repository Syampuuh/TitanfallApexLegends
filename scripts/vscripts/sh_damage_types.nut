global function DamageTypes_Init
global function RegisterWeaponDamageSource
global function GetObitFromDamageSourceID
global function GetObitImageFromDamageSourceID
global function DamageSourceIDToString
global function DamageSourceIDHasString
global function GetRefFromDamageSourceID
global function PIN_GetDamageCause
global function RegisterAdditionalMainWeapon
global function GetIsAdditionalMainWeapon

struct
{
	table<int, string> damageSourceIDToName
	table<int, asset>  damageSourceIDToImage
	table<int, string> damageSourceIDToString
	array<int>      additionalMainWeapons
} file


global enum eDamageSourceId
{
	invalid = -1                 

	                             
	                                                                                                                                                      
	                                                                          
	code_reserved                                                      
	damagedef_unknown                                                                            
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
	damagedef_ability_silence
                
                                               
       
	damagedef_defensive_bombardment

                    
                                     
       

                         
                                      
       

                 
                        
       
	damagedef_loot_drone_explosion
                 
                               
       

	                             

	                
	mp_weapon_hemlok
	mp_weapon_lmg
	mp_weapon_rspn101
	mp_weapon_vinson
	mp_weapon_lstar
	mp_weapon_g2
	mp_weapon_r97
	mp_weapon_volt_smg
	mp_weapon_dmr
	mp_weapon_wingman
	mp_weapon_semipistol
	mp_weapon_autopistol
	mp_weapon_sniper
	mp_weapon_sentinel
	mp_weapon_shotgun
	mp_weapon_mastiff
	mp_weapon_frag_grenade
	mp_weapon_grenade_emp
	mp_weapon_arc_blast
	mp_weapon_thermite_grenade
	mp_weapon_nuke_satchel
	mp_weapon_defender
	mp_weapon_defender_sustained
                       
                         
       
	mp_extreme_environment
	mp_weapon_shotgun_pistol
                        
                    
       
                             
                         
       
                         
                             
       
	mp_weapon_doubletake
	mp_weapon_alternator_smg
	mp_weapon_esaw
	mp_weapon_wrecking_ball
	mp_weapon_melee_survival
	mp_weapon_pdw
                          
                      
       
                   
               
       
                      
                  
       
	mp_weapon_energy_ar
                    
                            
       
	mp_weapon_bow
                         
                     
       
	  
	melee_pilot_emptyhanded

	melee_wraith_kunai
	mp_weapon_wraith_kunai_primary

	melee_bloodhound_axe
	mp_weapon_bloodhound_axe_primary

	melee_lifeline_baton
	mp_weapon_lifeline_baton_primary

	melee_pathfinder_gloves
	mp_weapon_pathfinder_gloves_primary

	melee_octane_knife
	mp_weapon_octane_knife_primary

	melee_mirage_statue
	mp_weapon_mirage_statue_primary

	melee_caustic_hammer
	mp_weapon_caustic_hammer

	melee_bangalore_heirloom
	mp_weapon_bangalore_heirloom

	melee_gibraltar_club
	mp_weapon_gibraltar_club

	melee_revenant_scythe
	mp_weapon_revenant_scythe

	melee_wattson_gadget
	mp_weapon_wattson_gadget_primary

	melee_crypto_heirloom
	mp_weapon_crypto_heirloom
	
                     
		melee_valkyrie_spear
		mp_weapon_valkyrie_spear
       

                     
                     
                         
       

                     
                     
                         
       

                                                
		melee_shadowsquad_hands
		melee_shadowroyale_hands
		mp_weapon_shadow_squad_hands_primary
       

                          
                         
       

                
		melee_boxing_ring
		mp_weapon_melee_boxing_ring
       

	melee_rampart_wrench
	mp_weapon_rampart_wrench_primary

	                     
	mp_weapon_defensive_bombardment_weapon
	mp_weapon_creeping_bombardment_weapon

	mp_ability_octane_stim
	mp_ability_revenant_death_totem
	mp_ability_crypto_drone_emp
	mp_ability_crypto_drone_emp_trap
	mp_ability_valk_cluster_missile
	mp_weapon_arc_bolt
                 
                           
                           
	mp_weapon_concussive_breach
	mp_weapon_riot_shield_impact
	mp_weapon_wrecking_ball_puck
                          
                        
                                    
                  
                      
       
                          
                             
                                    
                 
                       
                           
                
                          
                              
                          
	vault_defense
	mp_weapon_mounted_turret_weapon
	mp_weapon_mobile_hmg
	mp_weapon_deployable_cover
                
                       
                           
                          
	mp_weapon_tesla_trap
                 
                          
                        
                           
              
                           
                                  
       
                
                              
                                        
       
              
                  
                      
       
              
                                
       

	mp_ability_sonic_blast

	                  
	mp_weapon_dronebeam
	mp_weapon_dronerocket
	mp_weapon_droneplasma
	mp_weapon_turretplasma
	mp_weapon_turretrockets
	mp_weapon_turretplasma_mega
	mp_weapon_gunship_launcher
	mp_weapon_gunship_turret
	mp_weapon_gunship_missile

	npc_weapon_lstar
	npc_weapon_plasma_cannon
	npc_weapon_plasma_cannon_overcharged
	npc_weapon_proximity_ball
	npc_weapon_rocket_launcher
	npc_weapon_semipistol
	npc_weapon_sniper
	npc_weapon_thermite_grenade
	npc_weapon_super_spectre

	       
	human_melee
	auto_titan_melee
	mind_crime
	charge_ball
	grunt_melee
	spectre_melee
	spectre_ranged_hemlock
	prowler_melee
                          
		spider_melee
		spider_ranged
       
                                 
            
             
       
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

	          

	                
	fall
	splat
	crushed
	burn
                   
		caustic_toxin
                         
	lasergrid
	outOfBounds
	deathField
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
	persistent_damage_layer
                       
                            
       
                    
        
       

	mp_weapon_spectre_spawner
                               
                               
       

	              
	weapon_cubemap

	            
	phase_shift
	mp_ability_consumable

	bombardment
	bleedout
	mp_weapon_energy_shotgun
	fire
                    
         
       
	                                      
	          
	        
	              
	              
	           

                   
                        
                           
       

	shield_tick_damage_notify
	spider_poison

	mp_ability_mobile_respawn_beacon
	mp_ability_tombstone_respawn

                                
                               
       

                           
                          
       

                              
                             
       

	mp_weapon_stun_mine
	mp_weapon_cluster_bomb

	mp_weapon_mortar_ring
	mp_weapon_black_hole

                                 
                           
                          
                         
       

               
                          
                        
       
                  
		mp_ability_shield_throw
		mp_ability_armored_leap
		mp_ability_castle_wall
       
                
		mp_ability_lockon_sniper_ult
		mp_ability_sniper_ult
       
                 
                      
                        
                     
                          
                              
                      
                        
       
                
                      
                        
       
                        
                       
                          
                          
       
                           
                                   
       
		mp_ability_void_ring
		mp_weapon_3030
		mp_weapon_dragon_lmg
		mp_weapon_dragon_lmg_thermite
                                
                            
       
                            
                        
       
		mp_weapon_car
                               
                           
       
                        
                    
       

        
                         
       
                       
                          
       

                                                                    
                              
                                                                          

                    
                                          
                                             
       

	_count
}

void function DamageTypes_Init()
{
	#if SERVER
		                                                     
	#endif

	foreach ( name, number in eDamageSourceId )
	{
		file.damageSourceIDToString[ number ] <- name
	}

	PrecacheWeapon( $"mp_weapon_rspn101" )                          

	#if DEV

		int numDamageDefs        = DamageDef_GetCount()
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

	file.damageSourceIDToImage =
	{
		                                                                                                                                                           
		                                                                           
		                                                                        
		                                                           
		                                                                       
	}

                                                
		file.damageSourceIDToImage[eDamageSourceId.melee_shadowsquad_hands] <- $"rui/gamemodes/shadow_squad/shadow_icon_small"
		file.damageSourceIDToImage[eDamageSourceId.melee_shadowroyale_hands] <- $"rui/gamemodes/shadow_squad/shadow_icon_small"
       

	file.damageSourceIDToName =
	{
		    
		[ eDamageSourceId.mp_extreme_environment ] = "#DAMAGE_EXTREME_ENVIRONMENT",

		[ eDamageSourceId.npc_weapon_super_spectre ] = "#WPN_SUPERSPECTRE_ROCKETS",
		[ eDamageSourceId.mp_weapon_dronebeam ] = "#WPN_DRONERBEAM",
		[ eDamageSourceId.mp_weapon_dronerocket ] = "#WPN_DRONEROCKET",
		[ eDamageSourceId.mp_weapon_droneplasma ] = "#WPN_DRONEPLASMA",
		[ eDamageSourceId.mp_weapon_turretplasma ] = "#WPN_TURRETPLASMA",
		[ eDamageSourceId.mp_weapon_turretrockets ] = "#WPN_TURRETROCKETS",
		[ eDamageSourceId.mp_weapon_turretplasma_mega ] = "#WPN_TURRETPLASMA_MEGA",
		[ eDamageSourceId.mp_weapon_gunship_launcher ] = "#WPN_GUNSHIP_LAUNCHER",
		[ eDamageSourceId.mp_weapon_gunship_turret ] = "#WPN_GUNSHIP_TURRET",
		[ eDamageSourceId.mp_weapon_gunship_turret ] = "#WPN_GUNSHIP_MISSILE",

		[ eDamageSourceId.auto_titan_melee ] = "#DEATH_AUTO_TITAN_MELEE",

               
                                                                                              
        

		[ eDamageSourceId.prowler_melee ] = "#DEATH_PROWLER_MELEE",
                           
			[ eDamageSourceId.spider_melee ] = "#DEATH_SPIDER_MELEE",
			[ eDamageSourceId.spider_ranged ] = "#DEATH_SPIDER_RANGED",
        
                                  
                                                         
                                                          
        
		[ eDamageSourceId.super_spectre_melee ] = "#DEATH_SUPER_SPECTRE",
		[ eDamageSourceId.grunt_melee ] = "#DEATH_GRUNT_MELEE",
                     
			[ eDamageSourceId.spectre_melee ] = "#DEATH_SPECTRE_MELEE",
			[ eDamageSourceId.spectre_ranged_hemlock ] = "#DEATH_SPECTRE_RANGED_HEMLOCK",
			[ eDamageSourceId.npc_weapon_thermite_grenade ] = "#DEATH_SPECTRE_THERMITE",
        
		[ eDamageSourceId.eviscerate ] = "#DEATH_EVISCERATE",
		[ eDamageSourceId.wall_smash ] = "#DEATH_WALL_SMASH",
		[ eDamageSourceId.ai_turret ] = "#DEATH_TURRET",
		[ eDamageSourceId.team_switch ] = "#DEATH_TEAM_CHANGE",
		[ eDamageSourceId.rocket ] = "#DEATH_ROCKET",
		[ eDamageSourceId.titan_explosion ] = "#DEATH_TITAN_EXPLOSION",
		[ eDamageSourceId.evac_dropship_explosion ] = "#DEATH_EVAC_DROPSHIP_EXPLOSION",
		[ eDamageSourceId.flash_surge ] = "#DEATH_FLASH_SURGE",
                     
                                                  
        
		[ eDamageSourceId.sticky_time_bomb ] = "#DEATH_STICKY_TIME_BOMB",
		[ eDamageSourceId.vortex_grenade ] = "#DEATH_VORTEX_GRENADE",
		[ eDamageSourceId.droppod_impact ] = "#DEATH_DROPPOD_CRUSH",
		[ eDamageSourceId.ai_turret_explosion ] = "#DEATH_TURRET_EXPLOSION",
		[ eDamageSourceId.rodeo_trap ] = "#DEATH_RODEO_TRAP",
		[ eDamageSourceId.round_end ] = "#DEATH_ROUND_END",
		[ eDamageSourceId.burn ] = "#DEATH_BURN",
                    
			[ eDamageSourceId.caustic_toxin ] = "#DEATH_CAUSTIC_TOXIN",
                          
		[ eDamageSourceId.mind_crime ] = "Mind Crime",
		[ eDamageSourceId.charge_ball ] = "Charge Ball",

		[ eDamageSourceId.bubble_shield ] = "#DEATH_BUBBLE_SHIELD",
		[ eDamageSourceId.sticky_explosive ] = "#DEATH_STICKY_EXPLOSIVE",
		[ eDamageSourceId.titan_grapple ] = "#DEATH_TITAN_GRAPPLE",

		                                                     
		[ eDamageSourceId.fall ] = "#DEATH_FALL",
		                                                                                                                                                                                                                                                                                               
		[ eDamageSourceId.splat ] = "#DEATH_SPLAT",
		[ eDamageSourceId.titan_execution ] = "#DEATH_TITAN_EXECUTION",
		[ eDamageSourceId.human_execution ] = "#DEATH_HUMAN_EXECUTION",
		[ eDamageSourceId.outOfBounds ] = "#DEATH_OUT_OF_BOUNDS",
		[ eDamageSourceId.deathField ] = "#DEATH_DEATH_FIELD",
		[ eDamageSourceId.indoor_inferno ] = "#DEATH_INDOOR_INFERNO",
		[ eDamageSourceId.submerged ] = "#DEATH_SUBMERGED",
		[ eDamageSourceId.switchback_trap ] = "#DEATH_ELECTROCUTION",                                       
		[ eDamageSourceId.floor_is_lava ] = "#DEATH_ELECTROCUTION",
		[ eDamageSourceId.suicideSpectreAoE ] = "#DEATH_SUICIDE_SPECTRE",                                                            
		[ eDamageSourceId.titanEmpField ] = "#DEATH_TITAN_EMP_FIELD",
		[ eDamageSourceId.deadly_fog ] = "#DEATH_DEADLY_FOG",
		[ eDamageSourceId.crushed ] = "#DEATH_CRUSHED",
                                
                                                                             
        

		[ eDamageSourceId.mp_ability_valk_cluster_missile ] = "#DEATH_VALK_CLUSTER_MISSILE",
                 
		[ eDamageSourceId.mp_ability_sniper_ult ] = "#ABL_ULT_SNIPER_SHORT",
        
		            
		[ eDamageSourceId.phase_shift ] = "#WPN_SHIFTER",
		[ eDamageSourceId.bleedout ] = "#DEATH_BLEEDOUT",
		[ eDamageSourceId.mp_weapon_energy_shotgun ] = "Energy Shotgun",

		[ eDamageSourceId.damagedef_unknownBugIt ] = "#DEATH_GENERIC_KILLED",
		[ eDamageSourceId.damagedef_unknown ] = "#DEATH_GENERIC_KILLED",
		[ eDamageSourceId.weapon_cubemap ] = "#DEATH_GENERIC_KILLED",
		[ eDamageSourceId.stuck ] = "#DEATH_GENERIC_KILLED",

		[ eDamageSourceId.melee_pilot_emptyhanded ] = "#DEATH_MELEE",
		[ eDamageSourceId.melee_wraith_kunai ] = "#DEATH_MELEE_WRAITH_KUNAI",
		[ eDamageSourceId.mp_weapon_wraith_kunai_primary ] = "#DEATH_MELEE_WRAITH_KUNAI",

		[ eDamageSourceId.mp_ability_octane_stim ] = "#WPN_OCTANE_STIM_SHORT",

		[ eDamageSourceId.mp_weapon_tesla_trap ] = "#DEATH_TESLA_TRAP",

		[ eDamageSourceId.mp_ability_crypto_drone_emp ] = "#WPN_DRONE_EMP",                                            
		[ eDamageSourceId.mp_ability_crypto_drone_emp_trap ] = "#WPN_DRONE_EMP",

		[ eDamageSourceId.melee_bloodhound_axe ] = "#DEATH_MELEE_BLOODHOUND_AXE",
		[ eDamageSourceId.mp_weapon_bloodhound_axe_primary ] = "#DEATH_MELEE_BLOODHOUND_AXE",

		[ eDamageSourceId.melee_lifeline_baton ] = "#DEATH_MELEE_LIFELINE_BATON",
		[ eDamageSourceId.mp_weapon_lifeline_baton_primary ] = "#DEATH_MELEE_LIFELINE_BATON",

		[ eDamageSourceId.melee_pathfinder_gloves ] = "#DEATH_MELEE_PATHFINDER_GLOVES",
		[ eDamageSourceId.mp_weapon_pathfinder_gloves_primary ] = "#DEATH_MELEE_PATHFINDER_GLOVES",

		[ eDamageSourceId.mp_ability_revenant_death_totem ] = "#ABL_DEATH_TOTEM_DAMAGE",

		[ eDamageSourceId.melee_octane_knife ] = "#DEATH_MELEE_OCTANE_KNIFE",
		[ eDamageSourceId.mp_weapon_octane_knife_primary ] = "#DEATH_MELEE_OCTANE_KNIFE",

		[ eDamageSourceId.melee_mirage_statue ] = "#DEATH_MELEE_MIRAGE_STATUE",
		[ eDamageSourceId.mp_weapon_mirage_statue_primary ] = "#DEATH_MELEE_MIRAGE_STATUE",

		[ eDamageSourceId.melee_caustic_hammer ] =  "#DEATH_MELEE_CAUSTIC_HAMMER",
		[ eDamageSourceId.mp_weapon_caustic_hammer ] = "#DEATH_MELEE_CAUSTIC_HAMMER",

		[ eDamageSourceId.melee_bangalore_heirloom ] =  "#DEATH_MELEE_BANGALORE_HEIRLOOM",
		[ eDamageSourceId.mp_weapon_bangalore_heirloom ] = "#DEATH_MELEE_BANGALORE_HEIRLOOM",

		[ eDamageSourceId.melee_gibraltar_club ] = "#DEATH_MELEE_GIBRALTAR_CLUB",
		[ eDamageSourceId.mp_weapon_gibraltar_club ] = "#DEATH_MELEE_GIBRALTAR_CLUB",

		[ eDamageSourceId.melee_revenant_scythe ] = "#DEATH_MELEE_REVENANT_SCYTHE",
		[ eDamageSourceId.mp_weapon_revenant_scythe ] = "#DEATH_MELEE_REVENANT_SCYTHE",
		
		[ eDamageSourceId.melee_wattson_gadget ] = "#DEATH_MELEE_WATTSON_GADGET",
		[ eDamageSourceId.mp_weapon_wattson_gadget_primary ] = "#DEATH_MELEE_WATTSON_GADGET",

		[ eDamageSourceId.melee_crypto_heirloom ] = "#DEATH_MELEE_CRYPTO_HEIRLOOM",
		[ eDamageSourceId.mp_weapon_crypto_heirloom ] = "#DEATH_MELEE_CRYPTO_HEIRLOOM",
		
                      
			[ eDamageSourceId.melee_valkyrie_spear ] = "#DEATH_MELEE_VALKYRIE_SPEAR",
			[ eDamageSourceId.mp_weapon_valkyrie_spear] = "#DEATH_MELEE_VALKYRIE_SPEAR",
        

                      
                                                                          
                                                                             
        

                      
                                                                          
                                                                             
        

		[ eDamageSourceId.melee_rampart_wrench ] = "#DEATH_MELEE_RAMPART_WRENCH",
		[ eDamageSourceId.mp_weapon_rampart_wrench_primary ] = "#DEATH_MELEE_RAMPART_WRENCH",

		[ eDamageSourceId.mp_weapon_stun_mine ] = "#WPN_TACTICAL_STUN_MINES",
		[ eDamageSourceId.mp_weapon_cluster_bomb ] = "#WPN_CLUSTER_BOMB",
		[ eDamageSourceId.mp_weapon_mortar_ring ] = "#WPN_MORTAR_RING",

                   
			[ eDamageSourceId.mp_ability_armored_leap ] = "#WPN_ARMORED_LEAP",
			[ eDamageSourceId.mp_ability_castle_wall ] = "#WPN_ARMORED_LEAP",
			[ eDamageSourceId.mp_ability_shield_throw ] = "#WPN_SHIELD_THROW",
        
                  
                                                                    
                                                              
                                                                
                                                              
        

                                                 
			[ eDamageSourceId.melee_shadowsquad_hands ] = "#DEATH_MELEE_SHADOWSQUAD_HANDS",
			[ eDamageSourceId.melee_shadowroyale_hands ] = "#DEATH_MELEE_SHADOWSQUAD_HANDS",
			[ eDamageSourceId.mp_weapon_shadow_squad_hands_primary ] = "#DEATH_MELEE_SHADOWSQUAD_HANDS",
        

                           
                                                                                  
        

                  
                                                                     
        

               
                                                                         
                                                                                
        

                 
			[ eDamageSourceId.melee_boxing_ring ] = "#DEATH_MELEE_BOXING_RING",
			[ eDamageSourceId.mp_weapon_melee_boxing_ring ] = "#DEATH_MELEE_BOXING_RING",
        

			[ eDamageSourceId.mp_ability_sonic_blast ] = "#WPN_SONIC_BLAST",

		[ eDamageSourceId.mp_weapon_concussive_breach ] = "#WPN_RIOT_DRILL",

		[ eDamageSourceId.mp_weapon_arc_bolt ] = "#WPN_ARC_BOLT",

		[ eDamageSourceId.vault_defense ] = "#VAULT_DEFENSE",
		[ eDamageSourceId.mp_weapon_mobile_hmg ] = "#WPN_MOBILE_HMG",
	}

	#if DEV
		                                                                                                 
		file.damageSourceIDToName[ eDamageSourceId.damagedef_unknownBugIt ] = "UNKNOWN! BUG IT!"
		file.damageSourceIDToName[ eDamageSourceId.damagedef_unknown ] = "Unknown"
		file.damageSourceIDToName[ eDamageSourceId.weapon_cubemap ] = "Cubemap"
		                                                                            
		file.damageSourceIDToName[ eDamageSourceId.stuck ] = "NPC got Stuck (Don't Bug it!)"
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
	  
	        
	       
	      
	     
	    
	   
	    
	        
	            
	  

	                                                             

	return ""
}

void function RegisterAdditionalMainWeapon( string weaponRef )
{
	int damageSourceID = eDamageSourceId[weaponRef]
	if ( !file.additionalMainWeapons.contains( damageSourceID ) )
		file.additionalMainWeapons.push( damageSourceID )
}

bool function GetIsAdditionalMainWeapon( int damageSourceID )
{
	return file.additionalMainWeapons.contains( damageSourceID )
}
