global function MpWeaponBow_Init
global function OnWeaponActivate_weapon_bow
global function OnWeaponDeactivate_weapon_bow
global function OnWeaponPrimaryAttack_weapon_bow
global function OnProjectileCollision_weapon_bow
global function OnWeaponChargeBegin_weapon_bow
global function OnWeaponChargeEnd_weapon_bow
global function OnWeaponChargeLevelIncreased_weapon_bow

#if CLIENT
global function AttemptCancelCharge
#endif

#if SERVER
                                   
#endif

#if CLIENT
global function WeaponBow_UpdateArrowColor
#endif

global function ArrowsCanBePickedUp

const bool DEBUG_INFINITE_SPECIAL_ARROWS = false

const string HELPER_DOT_RUI_ABORT_SIGNAL = "bow_helper_dot_rui_abort"
const string HELPER_DOT_FIRE_ANIM = "fire_fullyCharged"
const string HELPER_DOT_HIDE_ANIM_EVENT = "hide_helper_dot"

const string BOW_MOVER_SCRIPTNAME = "bow_mover"

enum eArrowTypes
{
	STANDARD,
	SHATTER,

	_count
}
const array<int> STANDARD_ARROWS_AVAILABLE_DMG_LEVELS = [0, 1, 2, 3, 4, 5]
const array<int> SHATTER_ARROWS_AVAILABLE_DMG_LEVELS = [0, 3, 5]

                                                                     
const string CHARGE_MODS_BASE_STR = "charge_lv"
const string STANDARD_CHARGE_DMG_MODS_BASE_STR = "std_charge_dmg_lv"
const int CHARGE_MODS_MAX_LEVEL = 5
const string CHARGE_COMPLETE_SOUND_SETTING = "charge_complete_sound_1p"

const string CENTER_DOT_MIN_CHARGE_SETTING = "center_dot_helper_min_charge_level"

const string BOW_DEACTIVATE_SIGNAL = "BowDeactivate"

const string SPECIAL_ARROWS_REQUIRED_STRING = "#WPN_BOW_SPECIAL_ARROWS_REQUIRED"
const string NEXT_ARROW_TYPE_SOUND = "weapon_mastiff_first_draw_mech_piece"
const string ARROW_COLOR_STANDARD_SETTING = "arrows_standard_color"
const string ARROW_COLOR_SHATTER_SETTING = "arrows_shatter_color"

const string SINGLE_ARROW_LOOT_DATA_REF = "arrows"
const asset SINGLE_ARROW_MODEL = $"mdl/weapons/bullets/w_arrow_projectile.rmdl"
const asset SINGLE_ARROW_MODEL_PICKUP = $"mdl/weapons_r5/loot/_master/w_loot_wep_arrow_single.rmdl"
const float ARROWS_STICK_CHANCE_DEFAULT = 1.0
const int ARROWS_STICK_MAX_PLAYER_DEFAULT = 4
const int ARROWS_STICK_MAX_WORLD_DEFAULT = 750
const int ARROWS_STICK_MAX_ZONE_DEFAULT = 40
const int ARROWS_STICK_MAX_UNKNOWN_ZONE_DEFAULT = 80
const float ARROWS_STICK_INTO_PLAYER_DIST_DEFAULT = 9
const float ARROWS_STICK_LIFETIME_PLAYER_DEFAULT = 90
const float ARROWS_STICK_LIFETIME_WORLD_DEFAULT = 90
const bool ARROWS_CAN_BE_PICKED_UP_DEFAULT = false

const string SHATTER_ARROWS_DMG_MODS_BASE_STR = "arrows_shatter_dmg_lv"

const string FX_BOW_LIGHT_PREFIX = "fx_bow_light_"
const int FX_BOW_LIGHT_COUNT = 3
const table< string, array<string> > fxLightPointsForOptic =
{
	["ironsights"] = ["SIGHT_LIGHT_01", "SIGHT_LIGHT_02", "SIGHT_LIGHT_03"],
	["optic_cq_hcog_classic"] = ["HCOG_OG_LIGHT_01", "HCOG_OG_LIGHT_02", "HCOG_OG_LIGHT_03"],
	["optic_cq_hcog_bruiser"] = ["HCOG_OG_LIGHT_01", "HCOG_OG_LIGHT_02", "HCOG_OG_LIGHT_03"],
	["optic_cq_holosight"] = ["HOLO_LIGHT_01", "HOLO_LIGHT_02", "HOLO_LIGHT_03"],
	["optic_cq_holosight_variable"] = ["HOLOMAG_LIGHT_01", "HOLOMAG_LIGHT_02", "HOLOMAG_LIGHT_03"],
	["optic_ranged_hcog"] = ["ACGS_LIGHT_01", "ACGS_LIGHT_02", "ACGS_LIGHT_03"]
}

const table<string, float> UI_OPTIC_CLAMP_OPTICS =
{
	["ironsights"] = 0.05,
	["optic_cq_holosight"] = 0.1
}

struct
{
	bool fileStructInitialized = false

	float fullChargeSpeed
	float fullChargeSpeedSplit

	string chargeCompleteSound

	MarksmansTempoSettings& bowTempoSettings

	table<string, array<asset> > fxLightAssets1p

	array<vector> arrowTypeColors

	int centerDotHelperMinChargeLvl
	int centerDotHelperMinChargeLvlOpticClamp

	float arrowsStickChance
	int   arrowsStickMaxPlayer
	int   arrowsStickMaxWorld
	int   arrowsStickMaxZone
	int   arrowsStickMaxUnknownZone
	float arrowsStickIntoPlayerDist
	float arrowsStickLifetimePlayer
	float arrowsStickLifetimeWorld
	bool  arrowsCanBePickedUp

	#if SERVER
		                                          
		                                          
	#endif
	int ammoStackSize

	LootData& singleArrowLootData
} file


void function MpWeaponBow_Init()
{
	PrecacheWeapon( "mp_weapon_bow" )

	RegisterSignal( BOW_DEACTIVATE_SIGNAL )
	RegisterSignal( HELPER_DOT_RUI_ABORT_SIGNAL )

	PrecacheModel( SINGLE_ARROW_MODEL )
	PrecacheModel( SINGLE_ARROW_MODEL_PICKUP )

	file.fxLightAssets1p = {}
	string settingStr
	foreach ( string optic, array<string> attachments in fxLightPointsForOptic )
	{
		array<asset> fxLightArr = []
		for ( int i = 0; i < FX_BOW_LIGHT_COUNT; i++ )
		{
			settingStr = FX_BOW_LIGHT_PREFIX + optic + "_" + i
			asset fx1p = GetWeaponInfoFileKeyFieldAsset_Global( "mp_weapon_bow", settingStr + "_1p" )
			#if SERVER
				                      
			#endif
			fxLightArr.append( fx1p )
		}
		file.fxLightAssets1p[optic] <- fxLightArr
	}

	Remote_RegisterServerFunction( "Remote_CancelCharge", "entity" )

	#if CLIENT
		RegisterConCommandTriggeredCallback( "+weaponcycle", AttemptCancelCharge )
		                                                                      
		RegisterConCommandTriggeredCallback( "+reload", AttemptCancelCharge )
	#endif


	file.arrowsStickChance         = GetPlaylistVarFloat( GetCurrentPlaylistName(), "arrows_stick_chance", ARROWS_STICK_CHANCE_DEFAULT )
	file.arrowsStickMaxPlayer      = GetPlaylistVarInt( GetCurrentPlaylistName(), "arrows_stick_max_player", ARROWS_STICK_MAX_PLAYER_DEFAULT )
	file.arrowsStickMaxWorld       = GetPlaylistVarInt( GetCurrentPlaylistName(), "arrows_stick_max_world", ARROWS_STICK_MAX_WORLD_DEFAULT )
	file.arrowsStickMaxZone        = GetPlaylistVarInt( GetCurrentPlaylistName(), "arrows_stick_max_per_zone", ARROWS_STICK_MAX_ZONE_DEFAULT )
	file.arrowsStickMaxUnknownZone = GetPlaylistVarInt( GetCurrentPlaylistName(), "arrows_stick_max_unknown_zone", ARROWS_STICK_MAX_ZONE_DEFAULT )
	file.arrowsStickIntoPlayerDist = GetPlaylistVarFloat( GetCurrentPlaylistName(), "arrows_stick_into_player_dist", ARROWS_STICK_INTO_PLAYER_DIST_DEFAULT )
	file.arrowsStickLifetimePlayer = GetPlaylistVarFloat( GetCurrentPlaylistName(), "arrows_stick_lifetime_player", ARROWS_STICK_LIFETIME_PLAYER_DEFAULT )
	file.arrowsStickLifetimeWorld  = GetPlaylistVarFloat( GetCurrentPlaylistName(), "arrows_stick_lifetime_world", ARROWS_STICK_LIFETIME_WORLD_DEFAULT )
	file.arrowsCanBePickedUp       = GetPlaylistVarBool( GetCurrentPlaylistName(), "arrows_can_be_picked_up", ARROWS_CAN_BE_PICKED_UP_DEFAULT )
	#if SERVER
		                                                                      
	#endif
}


bool function ArrowsCanBePickedUp()
{
	return file.arrowsCanBePickedUp
}


void function OnWeaponActivate_weapon_bow( entity weapon )
{
	                                                                                      
	if ( !file.fileStructInitialized )
	{
		file.fileStructInitialized = true

		file.fullChargeSpeed      = GetWeaponInfoFileKeyField_GlobalFloat( "mp_weapon_bow", "projectile_launch_speed_full_charge" )
		file.fullChargeSpeedSplit = GetWeaponInfoFileKeyField_GlobalFloat( "mp_weapon_bow", "projectile_launch_speed_full_charge_shatter_arrows" )

		file.chargeCompleteSound = GetWeaponInfoFileKeyField_GlobalString( "mp_weapon_bow", CHARGE_COMPLETE_SOUND_SETTING )

		MarksmansTempoSettings settings
		settings.requiredShots             = GetWeaponInfoFileKeyField_GlobalInt( "mp_weapon_bow", MARKSMANS_TEMPO_REQUIRED_SHOTS_SETTING )
		settings.graceTimeBuildup          = GetWeaponInfoFileKeyField_GlobalFloat( "mp_weapon_bow", MARKSMANS_TEMPO_GRACE_TIME_SETTING )
		settings.graceTimeInTempo          = GetWeaponInfoFileKeyField_GlobalFloat( "mp_weapon_bow", MARKSMANS_TEMPO_GRACE_TIME_IN_TEMPO_SETTING )
		settings.fadeoffMatchGraceTime     = GetWeaponInfoFileKeyField_GlobalInt( "mp_weapon_bow", MARKSMANS_TEMPO_FADEOFF_MATCH_GRACE_TIME )
		settings.fadeoffOnPerfectMomentHit = GetWeaponInfoFileKeyField_GlobalFloat( "mp_weapon_bow", MARKSMANS_TEMPO_FADEOFF_ON_PERFECT_MOMENT_SETTING )
		settings.fadeoffOnFire             = GetWeaponInfoFileKeyField_GlobalFloat( "mp_weapon_bow", MARKSMANS_TEMPO_FADEOFF_ON_FIRE_SETTING )
		settings.weaponDeactivateSignal    = BOW_DEACTIVATE_SIGNAL
		file.bowTempoSettings              = settings

		file.centerDotHelperMinChargeLvl           = GetWeaponInfoFileKeyField_GlobalInt( "mp_weapon_bow", CENTER_DOT_MIN_CHARGE_SETTING )
		file.centerDotHelperMinChargeLvlOpticClamp = GetWeaponInfoFileKeyField_GlobalInt( "mp_weapon_bow", CENTER_DOT_MIN_CHARGE_SETTING + "_optic_clamp" )

		Assert( eArrowTypes._count == 2 )                                                        
		file.arrowTypeColors.append( GetWeaponInfoFileKeyField_GlobalVectorInt( "mp_weapon_bow", ARROW_COLOR_STANDARD_SETTING ) )
		file.arrowTypeColors.append( GetWeaponInfoFileKeyField_GlobalVectorInt( "mp_weapon_bow", ARROW_COLOR_SHATTER_SETTING ) )

		                                                                                                                                      

		file.singleArrowLootData = SURVIVAL_Loot_GetLootDataByRef( SINGLE_ARROW_LOOT_DATA_REF )

		if ( ArrowsCanBePickedUp() )
			SetCallback_LootTypeExtraCanUseFunction( file.singleArrowLootData, StuckArrow_ExtraCanUseFunction )

		#if SERVER
			                                                                                 
			                                              
			 
				                                                                          
			 
		#endif
	}

	entity player = weapon.GetWeaponOwner()


	thread ShatterRounds_UpdateShatterRoundsThink( weapon )
	#if SERVER
		                                                
			                                                
		    
			                                              
	#endif
	thread MarksmansTempo_OnActivate( weapon, file.bowTempoSettings )
}


void function OnWeaponDeactivate_weapon_bow( entity weapon )
{
	ClearChargeAndDmgLevelMods( weapon )
	#if CLIENT
		weapon.Signal( BOW_DEACTIVATE_SIGNAL )

		weapon.Signal( SHATTER_ROUNDS_THINK_END_SIGNAL )

		#if SERVER
			                                                             
		#endif

	#endif
	MarksmansTempo_OnDeactivate( weapon, file.bowTempoSettings )
}


var function OnWeaponPrimaryAttack_weapon_bow( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	if ( !IsValid( weapon ) )
		return 0

	entity player = weapon.GetWeaponOwner()
	if ( !IsValid( player ) || !player.IsPlayer() )
		return 0

	#if CLIENT
		if ( !(InPrediction() && weapon.ShouldPredictProjectiles()) )
			return 0
	#endif

	ApplyModsForChargeLevel( weapon, weapon.GetWeaponChargeLevel() )

	weapon.SetSoundCodeControllerValue( 100.0 * weapon.GetWeaponChargeFractionCurved() )

	                     
	float adjustedChargeFrac = max( 0.0, min( weapon.GetWeaponChargeFractionCurved(), 1.0 ) )

	float baseSpeed       = weapon.GetWeaponSettingFloat( eWeaponVar.projectile_launch_speed )
	float speedMultiplier = 0.0
	bool ignoreSpread     = false

	if ( weapon.HasMod( SHATTER_ROUNDS_HIPFIRE_MOD ) )
	{
		speedMultiplier = GraphCapped( adjustedChargeFrac, 0.0, 1.0, baseSpeed, file.fullChargeSpeedSplit )
		ignoreSpread    = true
	}
	else
	{
		speedMultiplier = GraphCapped( adjustedChargeFrac, 0.0, 1.0, baseSpeed, file.fullChargeSpeed )
	}
	speedMultiplier /= baseSpeed                                                                                                                            
	weapon.FireWeapon_Default( attackParams.pos, attackParams.dir, speedMultiplier, 1.0, ignoreSpread )


	MarksmansTempo_OnFire( weapon, file.bowTempoSettings, true )

	thread ClearChargeAfterFrame( weapon )

	#if CLIENT
		if ( InPrediction() )
		{
			int slot     = GetSlotForWeapon( player, weapon )
			string optic = ""
			if ( slot >= 0 )
			{
				optic = SURVIVAL_GetWeaponAttachmentForPoint( player, slot, "sight" )
			}
			else
			{
				Warning( "Invalid weapon slot " + slot + " for bow on player " + player )
				return weapon.GetWeaponSettingInt( eWeaponVar.ammo_per_shot )
			}

			if ( optic == "" )
				optic = "ironsights"
			bool isClampedOptic   = optic in UI_OPTIC_CLAMP_OPTICS
			float clampOpticDelay = isClampedOptic ? UI_OPTIC_CLAMP_OPTICS[optic] : 0.0
			int minChargeLevel    = isClampedOptic ? file.centerDotHelperMinChargeLvlOpticClamp : file.centerDotHelperMinChargeLvl
			int chargeLvl         = weapon.GetWeaponChargeLevel() - 1
			if ( chargeLvl >= minChargeLevel )
			{
				weapon.Signal( HELPER_DOT_RUI_ABORT_SIGNAL )
				float seqDur   = weapon.GetSequenceDuration( HELPER_DOT_FIRE_ANIM )
				float frac     = weapon.GetScriptedAnimEventCycleFrac( HELPER_DOT_FIRE_ANIM, HELPER_DOT_HIDE_ANIM_EVENT )
				float duration = seqDur * frac
				float delay    = 0.0
				if ( isClampedOptic && chargeLvl < file.centerDotHelperMinChargeLvl && chargeLvl >= file.centerDotHelperMinChargeLvlOpticClamp )
				{
					duration -= clampOpticDelay
					delay = clampOpticDelay
				}
				thread DisplayCenterDotRui( weapon, HELPER_DOT_RUI_ABORT_SIGNAL, delay, duration, 0.7, 0.05, 0.1 )
			}
		}
	#endif

	return weapon.GetWeaponSettingInt( eWeaponVar.ammo_per_shot )
}


void function ClearChargeAfterFrame( entity weapon )
{
	                                                                                                                                 
	AssertIsNewThread()
	weapon.EndSignal( "OnDestroy" )
	weapon.EndSignal( BOW_DEACTIVATE_SIGNAL )

	OnThreadEnd(
		function() : ( weapon )
		{
			if ( IsValid( weapon ) )
				ClearChargeAndDmgLevelMods( weapon )
		}
	)

	WaitFrame()
}


bool function OnWeaponChargeBegin_weapon_bow( entity weapon )
{
	entity player = weapon.GetWeaponOwner()
	if ( !IsValid( player ) || !IsAlive( player ) )
		return false

	#if CLIENT
		weapon.Signal( HELPER_DOT_RUI_ABORT_SIGNAL )
		PlayChargeFX( player, weapon )
	#endif

	MarksmansTempo_AbortFadeoff( weapon, file.bowTempoSettings )
	return true
}


void function OnWeaponChargeEnd_weapon_bow( entity weapon )
{
	StopChargeFX( weapon )
}


bool function OnWeaponChargeLevelIncreased_weapon_bow( entity weapon )
{
	if ( weapon.GetWeaponChargeLevel() == weapon.GetWeaponChargeLevelMax() )
	{
		entity player = weapon.GetWeaponOwner()
		if ( !IsValid( player ) )
			return true

		#if CLIENT
			weapon.EmitWeaponSound_1p3p( file.chargeCompleteSound, "" )

			if ( IsValid( player ) && IsLocalClientPlayer( player ) )
			{
				Rumble_Play( "rumble_bow_max_charge", {} )
			}
		#endif

		MarksmansTempo_SetPerfectTempoMoment( weapon, file.bowTempoSettings, player, Time(), true )
	}

	                                           
	ApplyModsForChargeLevel( weapon, weapon.GetWeaponChargeLevel() )

	return true
}

                                                                                         
  
  	           
  
                                                                                         

void function OnProjectileCollision_weapon_bow( entity projectile, vector pos, vector normal, entity hitEnt, int hitBox, bool isCritical, bool isPassthrough )
{
	#if SERVER
		                                                                 
			      

		                                                            
			      

		                         
			      

		                               
			      

		                                 
		                                      
		  	      

		                                          
		 
			                                                 
			 
				                        
				 
					                                                
				 
			 
			                                                               
			 
				                                                
				                                                
				               
			 

			                                                                                      
			                                                                 
			                                                                                
			                             
			                                       
			                                                    

			                                                                         
			                         
			                           
			                                  
			                                   
			                                                                 

			                        
				                                                            

			                         
			                            
				                                         
			    
				                                     

			                                                                        

			                                        
		 
		                                        
		 
			                                                                             
			                                                    
			 
				                                                                
				                          
					                  
			 

			                                                                   
			                                                              
			                                                      
			                                            
			 
				                                                        
				                          
					                  
			 


			          

			                            
			 
				                                     
				                                   
				                                                    

				                                                    

				               
				                               
				                                                                                                                     
				                        

				                                          

				                     
			 
			    
			 
				                                    
				                                             
			 

			                                                  
			                            
			                           
			                                     
			                                                                                                       
			                                      

			                    
			                                  

			                        
			                                                   

			                                                                 
			                                              
			                         
			                      

			                                
			                       
			                                                 
			                          
			                                                                                                              
			                              

			                              

			                            
				                        

			                                                           
			 
				             
				      
			 

			                         
			                            
				                                         
			    
				                                                                                       


			                                                   
			                                           

			                                                                  
		 
	#endif

	return
}


bool function StuckArrow_ExtraCanUseFunction( entity player, entity arrow, int useFlags )
{
	if ( Bleedout_IsBleedingOut( player ) )
		return false

	if ( !ArrowsCanBePickedUp() )
		return false

	if ( (useFlags & USE_FLAG_AUTO) != 0 )
	{
		                                    
		array<entity> weapons = player.GetMainWeapons()
		bool hasBow           = false
		foreach ( entity weapon in weapons )
		{
			if ( weapon.GetWeaponClassName() == "mp_weapon_bow" )
			{
				hasBow = true
				break
			}
		}

		if ( !hasBow )
			return false

		                                                                    
		int poolCount = player.AmmoPool_GetCount( eAmmoPoolType.arrows )
		if ( poolCount > 0 && (poolCount % file.ammoStackSize) == 0 )
			return false
	}
	return true
}

#if SERVER
                                                                    
 
	            
		                            
		 
			                     
			 
				             
			 
		 
	 

	                        
	 
		                                                                  
			      

		                               
		                             
		                                         
	 
	    
	 
		      
	 

	                     
		                            
	    
		      

	                
		         
	    
		             
 
#endif

                                                                                         
  
  	          
  
                                                                                         
#if CLIENT
void function WeaponBow_UpdateArrowColor( entity weapon, int shatterRoundsType )
{
	if ( shatterRoundsType == eShatterRoundsTypes.STANDARD )
		weapon.kv.rendercolor = VectorToColorString( file.arrowTypeColors[ eArrowTypes.STANDARD ], 255 )
	else if ( shatterRoundsType == eShatterRoundsTypes.SHATTER_TRI )
		weapon.kv.rendercolor = VectorToColorString( file.arrowTypeColors[ eArrowTypes.SHATTER ], 255 )
}
#endif

                                                                                         
  
  	      
  
                                                                                         
void function ApplyModsForChargeLevel( entity weapon, int level )
{
	#if CLIENT
		if ( !InPrediction() )
			return
	#endif

	ClearChargeAndDmgLevelMods( weapon )

	if ( level - 1 > 0 )
		weapon.AddMod( CHARGE_MODS_BASE_STR + (level - 1) )

	int dmgModLevel
	string baseDmgModStr
	if ( weapon.HasMod( SHATTER_ROUNDS_HIPFIRE_MOD ) )
	{
		baseDmgModStr = SHATTER_ARROWS_DMG_MODS_BASE_STR
		dmgModLevel   = GetBestAvailableModLevel( SHATTER_ARROWS_AVAILABLE_DMG_LEVELS, level - 1 )
	}
	else
	{
		baseDmgModStr = STANDARD_CHARGE_DMG_MODS_BASE_STR
		dmgModLevel   = GetBestAvailableModLevel( STANDARD_ARROWS_AVAILABLE_DMG_LEVELS, level - 1 )
		                                                                                                                              
		if ( dmgModLevel == 0 )
			return
	}
	weapon.AddMod( baseDmgModStr + dmgModLevel )
}


void function ClearChargeAndDmgLevelMods( entity weapon )
{
	#if CLIENT
		if ( !InPrediction() )
			return
	#endif

	for ( int i = 0; i < CHARGE_MODS_MAX_LEVEL + 1; i++ )
	{
		weapon.RemoveMod( CHARGE_MODS_BASE_STR + i )

		weapon.RemoveMod( STANDARD_CHARGE_DMG_MODS_BASE_STR + i )
		weapon.RemoveMod( SHATTER_ARROWS_DMG_MODS_BASE_STR + i )
	}
}


int function GetBestAvailableModLevel( array<int> availableLevels, int desiredLevel )
{
	if ( availableLevels[0] >= desiredLevel )
		return availableLevels[0]

	for ( int i = 0; i < availableLevels.len(); i++ )
	{
		if ( availableLevels[i] > desiredLevel )
			return availableLevels[maxint( i - 1, 0 )]
	}

	return availableLevels[availableLevels.len() - 1]
}

#if CLIENT
void function AttemptCancelCharge( entity player )
{
	if ( !IsValid( player ) )
		return

	entity weapon = player.GetActiveWeapon( eActiveInventorySlot.mainHand )
	if ( !IsValid( weapon ) )
		return

	if ( weapon.GetWeaponClassName() != "mp_weapon_bow" )
		return

	if ( !weapon.IsWeaponCharging() )
		return

	Remote_ServerCallFunction( "Remote_CancelCharge", weapon )
}
#endif

#if SERVER
                                                                 
 
	                                               
	 
		                                                                
		      
	 

	                                                
		      

	                                        
		      

	                               
 
#endif


                                                                                         
  
  	  
  
                                                                                         
#if CLIENT
void function PlayChargeFX( entity player, entity weapon )
{
	if ( !IsValid( weapon ) || !IsValid( player ) || !IsAlive( player ) )
		return

	entity vm = weapon.GetWeaponViewmodel()
	if ( !IsValid( vm ) )
		return

	string opticAttachment = GetInstalledWeaponAttachmentForPoint( weapon, "sight" )
	if ( opticAttachment == "" )
		opticAttachment = "ironsights"
	array<string> attachPoints = fxLightPointsForOptic[opticAttachment]
	for ( int i = 0; i < FX_BOW_LIGHT_COUNT; i++ )
	{
		asset fx1p = file.fxLightAssets1p[opticAttachment][i]

		                                                                                                                                          

		if ( fx1p == "" )
			continue

		int handle = weapon.PlayWeaponEffectNoCullReturnViewEffectHandle( fx1p, $"", attachPoints[i], true, FX_PATTACH_WEAPON_CHARGE_FRACTION_CURVED )
		EffectSetControlPointVector( handle, 2, file.arrowTypeColors[ weapon.GetScriptInt0() ] )
	}
}
#endif

void function StopChargeFX( entity weapon )
{
	if ( !IsValid( weapon ) )
		return

	entity vm = weapon.GetWeaponViewmodel()
	if ( !IsValid( vm ) )
		return

	string opticAttachment = GetInstalledWeaponAttachmentForPoint( weapon, "sight" )
	if ( opticAttachment == "" )
		opticAttachment = "ironsights"
	string settingStr
	for ( int i = 0; i < FX_BOW_LIGHT_COUNT; i++ )
	{
		settingStr = FX_BOW_LIGHT_PREFIX + opticAttachment + "_" + i
		asset fx1p = weapon.GetWeaponInfoFileKeyFieldAsset( settingStr + "_1p" )

		if ( fx1p == "" )
			continue

		weapon.StopWeaponEffect( fx1p, $"" )
	}
}